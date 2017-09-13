function remove-stack([string]$stackName) {
    docker stack rm $stackName
}

function clear-docker {
    docker stop $(docker ps -aq);
    docker system prune -f; 
    docker volume prune -f;
}