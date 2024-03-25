#Drupal Docker

##Drupal Docker base project to test migrations.
All services working

#Instructions using vscode
##Docker commands
###Start services using
- docker-compose up 

###In separate command terminals run the following
- docker exec -it drupal-docker-drupal7-1 bash /var/install_drupal7.sh
- docker exec -it drupal-docker-drupal10-1 bash /var/install_drupal10.sh

##Drupal 7 site currently accessible from localhost:8080/drupal7
##Drupal 10 site currently accessible from localhost:8081