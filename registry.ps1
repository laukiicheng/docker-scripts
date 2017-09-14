# Remove local Docker registry
function registry-remove-local {
    $containerInfo = docker ps -a | Select-String registry

    if(-Not [string]::IsNullOrEmpty($containerInfo)) {
        Write-Host "Removing local registry.";
        $line = $containerInfo -split '\s+'
        $containerId = $line[0]
        docker stop $containerId; 
        docker rm $containerId;
    }
    else {
        Write-Host "Local registry not found."
    }
}

# Add local Docker registry
function registry-add-local {
    if(get-registry-status) {
        # remove-local-registry
        Write-Host "Local registry is already running."
    }
    else {
        Write-Host "Creating a new local registry";
        docker run -d -p 1500:5000 --name localregistry registry ;
    }
}

# Get local Docker registry status
function registry-get-status {
    $registryIsRunning = docker ps -a | Select-String registry
    if($registryIsRunning) {
        return $true;
    }
}