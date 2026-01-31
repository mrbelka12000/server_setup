# server_setup

## Set up default services

### Repository with scripts for deploying basic services for web development

## USAGE:

### For initialize swarm and external network:
    make init

### Docker Daemon (обязательно для мониторинга)

Для корректной работы labels в логах, на **каждой ноде** настроить Docker daemon:

```bash
sudo cp docker/daemon.json /etc/docker/daemon.json
sudo systemctl restart docker
```

Подробнее: [docker/README.md](docker/README.md)

---

### Postgres
    make postgres password="your password"

### Redis
    make redis

### RabbitMQ
    make rabbitmq

### MinIO (S3-совместимое хранилище)
    make minio

### Grafana Stack (мониторинг + логи)

Подробная документация: [grafana_stack_for_docker/Readme.md](grafana_stack_for_docker/Readme.md)

```bash
cd grafana_stack_for_docker
# следовать инструкциям в Readme.md
```
