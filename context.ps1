# Check the health of all services
function ctx-health-check {

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

# Pull images for the messaging context by tag
function ctx-pull {
    Param(
        [ValidateSet("master", "test-stable")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$tag,
        [ValidateSet("messaging", "log")]
        [Parameter(Position=1,mandatory=$true)]
        [string]$contextName
    )

    $images = docker image ls --format "{{. | json}}" | 
    ConvertFrom-Json | 
    where { $_.Repository -like  "*$($contextName)*" -AND $_.Tag -notlike "dev"}

    foreach($element in $images) {
        docker pull "$($element.Repository):$($tag)"
    }
}
