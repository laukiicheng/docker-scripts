. .\registry.ps1
. .\env-parse.ps1
parse-variables

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
    $repoImageName = "$registryName/$imageName`:$tag"
    $localImageName = "$localRegistryName/local-$imageName"

    docker tag  $repoImageName $localImageName
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
    
    $repoImageName = "$registryName/$imageName`:$tag"
    $localImageName = "$localRegistryName/local-$imageName"

    docker image rm $localImageName
    docker tag  $repoImageName $localImageName
    docker image ls | Select-String $localImageName
}

# Remove image(s) by the tag name
# This goes a general pattern match
function remove-image-by-tag([string]$tag) {
    docker image ls |
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
    
    docker image ls |
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

