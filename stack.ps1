function remove-stack([string]$stackName) {
    docker stack rm $stackName
}

function docker-clear {
    docker stop $(docker ps -aq);
    docker system prune -f; 
    docker volume prune -f;
}