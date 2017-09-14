. .\registry.ps1

$registryName = "nexus.spokvdev.com"
$tag = "master"
$localRegistryName = "localhost`:1500"

# Get the base image name if prefixed with ccp
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

# Update the service in the stack to an image pushed to a local regsitry
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

# Tag an image for pushing to a local repository
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

# Remove image(s) by the tag name
# This goes a general pattern match
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

# Remove image(s) by the image name
# This goes a general pattern match
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

