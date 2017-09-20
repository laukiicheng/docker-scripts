# Check the health of all services
function context-health-check {

    while($true) {
        $containersUnhealthy = docker ps -a  | Select-String "unhealthy"
        $containersStarting = docker ps -a  | Select-String "starting"
        if (-Not $containersUnhealthy -AND -Not $containersStarting) {
            Write-Host "CONTAINERS ARE HEALTHY"
            return;
        }
        Write-Host "unhealthy. wait 5 seconds ..."
        Start-Sleep -s 5
    }
}
