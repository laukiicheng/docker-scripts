. .\registry.ps1

$registryName = "nexus.spokvdev.com"
$tag = "master"

function get-base-image-name([string]$fullImageName) {
    $hasprefix = $fullImageName | Select-String "ccp"
    if($hasprefix) {
        $firstDash = $fullImageName.IndexOf("-")
        return $fullImageName.SubString($firstDash + 1)
    }
    else {
        return $fullImageName
    } 
}

function update-service-to-local-image {
    Param(
        [ValidateSet("ccp-rabbitmq", "ejabberdactivityprocessor")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$imageName
    )

    add-local-registry
    $localRegistryName = "localhost`:1500"
    $baseImageName = get-base-image-name $imageName
    $serviceName = "ccp_$baseImageName"
    $nexusImageName = "$registryName/$imageName`:$tag"
    $localImageName = "$localRegistryName/local-$imageName"

    docker tag  $nexusImageName $localImageName
    docker push $localImageName
    docker service update --image $localImageName $serviceName
}

function tag-as-local-image {
    Param(
        [ValidateSet("ccp-rabbitmq", "ejabberdactivityprocessor")][string]$imageName
    )
    
    $localRegistryName = "localhost`:1500"
    $nexusImageName = "$registryName/$imageName`:$tag"
    $localImageName = "$localRegistryName/local-$imageName"

    docker tag  $nexusImageName $localImageName
    docker image ls | Select-String $localImageName
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

