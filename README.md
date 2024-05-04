# server_setup

## Set up default services

### Repository with sctripts for deploying basic services for web development

## USAGE:

### For initialize swarm and external network:
    make init

### Postgres
    make postgres password="your password"

### Redis 
    make redis

### Monitoring (grafana+prometheus)
    make monitoring

### MongoDB
    make mongodb

### Jaeger
    make jaeger