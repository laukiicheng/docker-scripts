
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

