.PHONY: init redis postgres monitoring mongodb mongodb_atlas jaeger

init:
	# Check is docker exists and user can work with docker
	docker ps

	# init swarm
	docker swarm init


	# create external network
	docker network create --scope=swarm --attachable -d overlay main

redis:
	docker stack deploy -c redis/docker-compose.yml redis

postgres:
	POSTGRES_PASSWORD=$(password) docker stack deploy -c postgres/docker-compose.yml postgres

monitoring:
	sudo mkdir /var/lib/prometheus
	sudo bash -c 'cat monitoring/prometheus.yml > /var/lib/prometheus/prometheus.yml'
	docker stack deploy -c monitoring/docker-compose.yml monitoring

mongodb:
	docker stack deploy -c mongodb/docker-compose.yml mongo

mongodb_atlas:
	docker stack deploy -c mongodb_atlas/docker-compose.yml mongo_atlas

jaeger:
	docker stack deploy -c jaeger/docker-compose.yml jaeger
