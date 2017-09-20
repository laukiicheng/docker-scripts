# Shut down 1 container for a service
function service-rm-container {
    Param(
        [ValidateSet("ccp-identityserver", "ccp-logstash", "ccp-rabbitmq", "ejabberdactivityprocessor")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    docker service ps $serviceName | 
    ForEach-Object {
        $line = $_ 
        $data = $line -split '\s+'
        
        # Shutdown first container and return
        $containerId = $data[0]
        docker container stop $containerId
        docker rm $containerId
        return;
    }
}

# Scale service down and back up
function service-scale {
    Param(
        [ValidateSet("ccp-identityserver", "ccp-logstash", "ccp-rabbitmq", "ejabberdactivityprocessor")]
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
        [ValidateSet("ccp-identityserver", "ccp-logstash", "ccp-rabbitmq", "ejabberdactivityprocessor")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$serviceName
    )

    Write-Host "LOGS: $serviceName -------------------------------------------------------------------"
    docker service logs --tail 15 $serviceName
    Write-Host "INFO: $serviceName -------------------------------------------------------------------"
    docker service ps $serviceName
}