#!/bin/bash

# Install unzip & default-mysql-client
install_util() {
    apt-get update && apt-get install -y default-mysql-client unzip
}

# Install Composer
install_composer() {
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    chmod +x /usr/local/bin/composer
}

#!/bin/bash

# Install Drush
install_drush() {
    composer global require drush/drush --with-all-dependencies
    export PATH="$HOME/.composer/vendor/bin:$PATH"
    echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
}

# Pull down Drupal projects and install sites using Drush
pull_drupal_projects() {
    local project_name=$1
    local drupal_version=$2
    local site_host="mysql10"
    local site_name="My Drupal 10 Site"
    local web_root="/var/www/html"

    # Change directory to the Drupal project
    cd ${web_root}

    # Download Drupal core using Drush
    drush dl drupal-${drupal_version} --drupal-project-rename=${project_name} -y

    # Get database credentials from Docker Compose
    local mysql_user=${project_name}
    local mysql_password=${project_name}
    local mysql_database=${project_name}
    local mysql_host=${site_host}

    # Install Drupal site using Drush and Docker Compose credentials
    cd ${web_root}/${project_name}
    drush site-install standard --db-url=mysql://${mysql_user}:${mysql_password}@${mysql_host}/${mysql_database} --account-name=admin --account-pass=admin_password --site-name="${site_name}" -y

    # Optional: Set permissions on Drupal files and folders
    find . -type d -exec chmod 755 {} \;
    find . -type f -exec chmod 644 {} \;

    # Optional: Set permissions on the sites/default/files directory
    chmod -R 777 sites/default
}

# Main script
install_composer
install_drush
pull_drupal_projects "drupal10" "10.x"

# Keep the container running
sleep infinity