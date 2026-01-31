.PHONY: init redis postgres minio rabbitmq

init:
	# Check if docker exists and user can work with docker
	docker ps

	# init swarm
	docker swarm init

	# create external network
	docker network create --scope=swarm --attachable -d overlay backend

redis:
	docker stack deploy -c redis/redis.yaml redis

postgres:
	docker stack deploy -c postgres/stack.yaml db

minio:
	docker stack deploy -c minio/minio.yaml minio

rabbitmq:
	docker stack deploy -c rabbitmq/rabbitmq.yaml rabbitmq
