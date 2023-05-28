FROM drupal:7-apache

# Install MySQL client
RUN apt-get update && apt-get install -y default-mysql-client unzip

# Copy the script to the container
COPY ./bash-scripts/drupal7.sh /var/install_drupal7.sh

# Set executable permissions on the script
RUN chmod +x /var/install_drupal7.sh

# Set the working directory
WORKDIR /var/www/html

# Run the script during container startup
CMD ["/var/install_drupal7.sh"]