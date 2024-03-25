# Drupal Docker

## Drupal Docker base project to test migrations.
- All services working
- Todo
    - fix drupal7 to open from localhost:8080 instead of localhost:8080/drupal7

#Instructions using vscode
## Docker commands
### Start services using
```bash
docker-compose up 
```
### In separate command terminals run the following
```bash 
docker exec -it drupal-docker-drupal7-1 bash /var/install_drupal7.sh
```
```bash
docker exec -it drupal-docker-drupal10-1 bash /var/install_drupal10.sh
```

### Portainer service accessible from `localhost:9000`
### Drupal 7 site currently accessible from `localhost:8080/drupal7`
### Drupal 10 site currently accessible from `localhost:8081`