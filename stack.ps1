# Remove stack by name
function stack-remove {
    Param(
        [ValidateSet("ccp", "identityintegration-test")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$stackName
    )

    docker stack rm $stackName
}

# Remove all stacks
function stack-rm-all {

    docker stack ls |
    ForEach-Object {
        $line = $_ 
        $data = $line -split '\s+'
        docker stack rm $data[0]
    }
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
        [ValidateSet("ccp", "identityintegration-test", "logagg")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$stackName
    )

    $elapsed = [System.Diagnostics.Stopwatch]::StartNew()
    $stackHealthy = $false;
    while(-Not $stackHealthy) {
        Write-Host "STACK HEALTH CHECK -------------------------------------------------------"
        $isHealthy = $true
        docker stack services $stackName |
        ForEach-Object {
            $line = $_ 
            $data = $line -split '\s+'
            $replicas = $data[3]
            $replicated = $replicas -split '/'

            if($replicated[0] -ne $replicated[1] -and $data[3] -match '\d') {
                $isHealthy = $false
                Write-Host "$($data[1]) $($data[3])" 
            }
        }

        $stackHealthy = $isHealthy
        if (-Not $stackHealthy) {
            Write-Host "unhealthy. wait 5 seconds ... Elapsed Time: $($elapsed.Elapsed.ToString("mm\:ss"))"
            Start-Sleep -s 5
        }
        else {
            Write-Host "STACK IS HEALTHY"
            docker service ls
            return;
        }
    }
    $elapsed.Stop()
}