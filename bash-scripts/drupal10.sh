#!/bin/bash

# Install unzip & default-mysql-client
install_util() {
    apt-get update && apt-get install -y default-mysql-client unzip
}

# Install Composer
install_composer() {
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    chmod +x /usr/local/bin/composer
    export PATH="$HOME/.composer/vendor/bin:$PATH"
    echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
}

#!/bin/bash

#Install Drush
install_drush() {
    composer require drush/drush
}

#Pull down Drupal projects and install sites using Drush
pull_drupal_projects() {
    local project_name=$1
    local drupal_version=$2
    local site_host="mysql10"
    local site_name="My Drupal $drupal_version Site"
    local web_root="/var/www/html"

    # Change directory to the Drupal project
    cd ${web_root}
    composer create drupal/drupal:^$drupal_version
    install_drush

    # Download Drupal core using Drush
    # drush dl drupal-${drupal_version} --drupal-project-rename=${project_name} -y
    # composer require drupal/core

    # Get database credentials from Docker Compose
    local mysql_user=${project_name}
    local mysql_password=${project_name}
    local mysql_database=${project_name}
    local mysql_host=${site_host}

    # # Install Drupal site using Drush and Docker Compose credentials
    # cd ${web_root}/${project_name}
    drush site-install standard --db-url=mysql://${mysql_user}:${mysql_password}@${mysql_host}/${mysql_database} --account-name=admin --account-pass=admin_password --site-name="${site_name}" -y

    # # Optional: Set permissions on Drupal files and folders
    echo "Fixing drupal directory permissions to 755"
    find . -type d -exec chmod 755 {} \;
    echo "Fixing drupal file permissions to 644"
    find . -type f -exec chmod 644 {} \;

    # Optional: Set permissions on the sites/default/files directory
    echo "Fixing drupal sites/default directory permissions to 777"
    chmod -R 777 sites/default
}

# Main script
install_util
install_composer
pull_drupal_projects "drupal10" "10"

# Keep the container running
sleep infinity