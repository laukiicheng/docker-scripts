. .\registry.ps1

$registryName = "nexus.spokvdev.com"
$tag = "master"
$localRegistryName = "localhost`:1500"

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
        [ValidateSet("ccp-rabbitmq", "ejabberdactivityprocessor")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$imageName
    )
    
    $nexusImageName = "$registryName/$imageName`:$tag"
    $localImageName = "$localRegistryName/local-$imageName"

    docker image rm $localImageName
    docker tag  $nexusImageName $localImageName
    docker image ls | Select-String $localImageName
}


function remove-image-by-tag([string]$tag) {
    $containers = docker image ls

    $containers |
    ForEach-Object {
        $line = $_ 
        $data = $line -split '\s+'
        $matchesTag = $data[1] | Select-String $tag
        if($matchesTag) {
            $containerId = $data[2]
            docker image rm -f $containerId
        }
    }
}

function remove-image-by-name([string]$name) {
    $containers = docker image ls
    
        $containers |
        ForEach-Object {
            $line = $_ 
            $data = $line -split '\s+'
            $matchesName = $data[0] | Select-String $name
            if($matchesName) {
                $containerId = $data[2]
                docker image rm -f $containerId
            }
        }
}

