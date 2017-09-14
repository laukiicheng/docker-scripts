# Remove stack by name
function remove-stack([string]$stackName) {
    docker stack rm $stackName
}

# Stop all running containers. Prune the Docker system and volumes
function docker-clear {
    docker stop $(docker ps -aq);
    docker system prune -f; 
    docker volume prune -f;
}

# Check the health of all services
function service-health-check {
    while($true) {
        $containersDown = docker service ls | Select-String 0/1
        if (-Not $containersDown) {
            Write-Host "STACK IS HEALTHY"
            return;
        }
        Write-Host "unhealthy. wait 5 seconds ..."
        Start-Sleep -s 5
    }
}
