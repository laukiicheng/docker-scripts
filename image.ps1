. .\registry.ps1

function push-local-image
{
    Param(
        [ValidateSet("rabbitmq")][string]$imageName
    )

    add-local-registry
    
    $registryName = "nexus.spokvdev.com"
    $tag = "master"
    $localRegistryName = "localhost`:1500"
    $fullImageName = "ccp-$imageName"
    $serviceName = "ccp_$imageName"
    $nexusImageName = "$registryName/$fullImageName`:$tag"
    $localImageName = "$localRegistryName/local-$imageName"

    docker tag  $nexusImageName $localImageName
    docker push $localImageName
    docker service update --image $localImageName $serviceName
}


function remove-image-by-tag([string]$tag) {
    $containers = docker image ls | Select-String $tag

    $containers |
    ForEach-Object{
        $line = $_ 
        $data = $line -split '\s+'
        Write-Host $data[2]
        $containerId = $data[2]
        docker image rm $containerId
    }
}

function remove-image-by-name([string]$name) {
    $containers = docker image ls | Select-String $name

    $containers |
    ForEach-Object{
        $line = $_ 
        $data = $line -split '\s+'
        Write-Host $data[2]
        $containerId = $data[2]
        docker image rm $containerId
    }
}

