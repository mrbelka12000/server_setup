# Docker Daemon Configuration

Конфигурация Docker daemon для корректной работы логирования в Grafana Stack.

## Проблема

По умолчанию Docker json-file log driver НЕ записывает метаданные контейнеров в логи.
Без этой настройки Promtail не сможет извлечь labels:

- `container_name` / `tag`
- `compose_project` / `compose_service`
- `service_name` (для Docker Swarm)
- `stack_name` (для Docker Swarm)

## Решение

Файл `daemon.json` добавляет в логи:

| Параметр | Описание |
|----------|----------|
| `tag` | Имя контейнера (template `{{.Name}}`) |
| `com.docker.compose.project` | Имя compose проекта |
| `com.docker.compose.service` | Имя compose сервиса |
| `com.docker.stack.namespace` | Имя swarm стека |
| `com.docker.swarm.service.name` | Имя swarm сервиса |

## Установка

### 1. Скопировать на каждую ноду swarm

```bash
sudo cp daemon.json /etc/docker/daemon.json
```

### 2. Перезапустить Docker

```bash
sudo systemctl restart docker
```

### 3. Пересоздать контейнеры

**Важно**: Существующие контейнеры НЕ получат новые атрибуты. Нужно пересоздать:

```bash
# Docker Swarm
docker stack rm grafana
docker stack deploy -c grafana.yaml grafana

# Docker Compose
docker compose down && docker compose up -d
```

## Проверка

### Проверить что атрибуты записываются в логи

```bash
# Найти лог файл контейнера
docker inspect $(docker ps -q | head -1) --format='{{.LogPath}}'

# Посмотреть содержимое
cat <path_to_log> | head -1 | jq '.attrs'
```

Должно показать:

```json
{
  "tag": "grafana_loki.1.xxx",
  "com.docker.swarm.service.name": "grafana_loki"
}
```

### Проверить в Grafana

1. Открыть Grafana → Explore → Loki
2. Выбрать label `service_name` или `container_id`
3. Если labels появились — настройка работает

## Troubleshooting

### Labels не появляются после настройки

1. Проверить что daemon.json скопирован: `cat /etc/docker/daemon.json`
2. Проверить что Docker перезапущен: `systemctl status docker`
3. Проверить что контейнеры пересозданы (timestamp должен быть новый): `docker ps`
4. Проверить attrs в логе контейнера (см. выше)

### Level появляется, но service_name нет

`level` извлекается из содержимого лога (парсинг JSON/текста в promtail).
`service_name` берётся из attrs Docker — нужна настройка daemon.json.

## Альтернативный подход

В `grafana_stack_for_docker/Readme.md` описан альтернативный метод с `labels-regex`:

```json
{
  "log-opts": {
    "labels-regex": "^.+"
  }
}
```

Различия:

- `labels-regex: "^.+"` — захватывает ВСЕ Docker labels (может быть много лишних)
- `labels: "..."` — явный список нужных labels (более контролируемо)
- `tag: "{{.Name}}"` — добавляет имя контейнера (нужно для container_name)

Рекомендуется использовать явный список из этого репозитория.
