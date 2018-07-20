docker stop $(docker ps -aq);
docker system prune -f; 
docker volume prune -f;