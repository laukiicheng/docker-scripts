# Shut down 1 container for a service


function sr-rm-container {
    Param(
        [ValidateSet("ccp_identityserver", "ccp_kibana", "ccp_logstash")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    $containerName = name-sr-to-container $serviceName
    $containers = docker container ps | Select-String $containerName
    if($containers) {
        $containers |
        ForEach-Object {
            $line = $_ 
            $data = $line -split '\s+'
            $containerId = $data[0]
            $container = $data[1] -split '/'
            Write-Host "Stoping container $($container[1]) $($containerId)"
            docker container stop $containerId
            docker rm $containerId
            break
        }
    }
    else {
        Write-Host "No containers running for $serviceName"
    }
}

# Scale service down and back up
function sr-scale-to {
    Param(
        [ValidateSet("ccp_identityserver", "ccp_kibana", "ccp_logstash")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName, 

        [Parameter(Position=1,mandatory=$true)]
        [int]$scaleTo
    )

    docker service scale $serviceName=0
    docker service scale $serviceName=$scaleTo
}


function sr-info {
    Param(
        [ValidateSet("ccp_identityserver", "ccp_kibana", "ccp_logstash")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    Write-Host "LOGS -----------------------------------------------------------------------------"
    docker service logs --tail 5 $serviceName
    Write-Host "SERVICE INFO ---------------------------------------------------------------------"
    docker service ps $serviceName
    Write-Host "CONTAINERS-------------------------------------------------------------------------"
    $containerName = name-sr-to-container $serviceName
    $containers = docker container ps | Select-String $containerName
    if($containers ) {
        Write-Host $containers
    }
    else {
        Write-Host "No containers running for $baseImageName"
    }
}

function name-sr-to-container {
    Param(
        [ValidateSet("ccp_identityserver", "ccp_kibana", "ccp_logstash")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    $serviceSplit = $serviceName -split '_'
    return "$($serviceSplit[0])-$($serviceSplit[1])"
}