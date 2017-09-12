function remove-local-stack([string]$stackName) {
    docker stack rm $stackName
    clear-docker
}

function clear-docker {
    docker stop $(docker ps -aq);
    docker system prune -f; 
    docker volume prune -f;
}