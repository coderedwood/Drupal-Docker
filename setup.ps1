# Set the path to the Docker Compose file
$composeFilePath = ".\docker-compose.yml"

# Start the Docker Compose project
docker-compose -f $composeFilePath up -d

# Wait for the containers to start
Write-Host "Waiting for containers to start..."
Start-Sleep -Seconds 10

# Countdown
for ($i = 10; $i -gt 0; $i--) {
    Write-Host "Countdown: $i"
    Start-Sleep -Seconds 1
}

# Define the source directory containing the bash scripts
$scriptSourceDir = ".\bash-scripts"

# Define the target directory inside the containers to copy the scripts
$scriptTargetDir = "/scripts"

# Get the list of service names for Drupal containers
$drupalServiceNames = "drupal7", "drupal10" # Add more service names as needed

# Iterate over each Drupal service
foreach ($serviceName in $drupalServiceNames) {
    # Get the container ID of the service
    $containerId = docker-compose -f $composeFilePath ps -q $serviceName

    # Determine the name of the bash script based on the container ID
    $bashScriptName = "${serviceName}.sh"


    # Create the target directory in the container if it doesn't exist
    docker exec ${containerId} bash -c "mkdir -p ${scriptTargetDir}"

    # Copy the bash script to the container
    docker cp "$scriptSourceDir/$bashScriptName" ${containerId}:${scriptTargetDir}

    # Run the bash script inside the container
    docker exec ${containerId} bash -c "cd ${scriptTargetDir} && chmod +x ${bashScriptName} && ./${bashScriptName}"
    
    # Optional: Remove the copied script from the container
    docker exec ${containerId} rm -rf ${scriptTargetDir}/${bashScriptName}
}

# Optional: Stop and remove the Docker Compose project
# docker-compose -f $composeFilePath down