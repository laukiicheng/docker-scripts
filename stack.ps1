# Remove stack by name
function remove-stack([string]$stackName) {
    docker stack rm $stackName
}

# Stop all running containers. Prune the Docker system and volumes
function docker-clean {
    docker stop $(docker ps -aq);
    docker system prune -f; 
    docker volume prune -f;
}

# Check the health of all services
function stack-health-check {
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string]$stackName
    )

    while($true) {
        $containersDown = docker stack services $stackName | Select-String 0/1
        if (-Not $containersDown) {
            Write-Host "STACK IS HEALTHY"
            return;
        }
        Write-Host "unhealthy. wait 5 seconds ..."
        Start-Sleep -s 5
    }
}
