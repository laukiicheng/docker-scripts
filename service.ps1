# Shut down 1 container for a service
function service-rm-container {
    Param(
        [ValidateSet("ccp_identityserver", "ccp_kibana", "ccp_logstash")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    $containerName = name-service-to-container $serviceName
    $containers = docker container ps | Select-String $containerName
    if($containers) {
        $containers |
        ForEach-Object {
            $line = $_ 
            $data = $line -split '\s+'
            $containerId = $data[0]
            Write-Host "Stoping container $($containerId)"
            # docker container stop $containerId
            # docker rm $containerId
            # return;
        }
    }
    else {
        Write-Host "No containers running for $serviceName"
    }
}

# Scale service down and back up
function service-scale-to {
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


function service-info {
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
    $containerName = name-service-to-container $serviceName
    $containers = docker container ps | Select-String $containerName
    if($containers ) {
        Write-Host $containers
    }
    else {
        Write-Host "No containers running for $baseImageName"
    }
}

function name-service-to-container {
    Param(
        [ValidateSet("ccp_identityserver", "ccp_kibana", "ccp_logstash")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    $serviceSplit = $serviceName -split '_'
    return "$($serviceSplit[0])-$($serviceSplit[1])"
}