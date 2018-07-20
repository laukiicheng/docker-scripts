
function cn-logs {
    Param(
        [ValidateSet("localstack")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$containerName
    )

    $containers = docker container ps | Select-String $containerName
    if($containers) {
        $containers |
        ForEach-Object {
            $line = $_ 
            $data = $line -split '\s+'
            $containerId = $data[0]
            $container = $data[1] -split '/'
            Write-Host "logs for $($container[1]) $($containerId)"
            docker logs -tf $containerId
            break
        }
    }
    else {
        Write-Host "No containers found for $containerName"
    }
}
