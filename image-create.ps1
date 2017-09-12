[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [alias("i")]
    [ValidateSet("rabbitmq")]
    [string[]]$imageName = @(),

    [alias("r")]
    [string[]]$registryName = @(),

    [alias("t")]
    [string[]]$tag = @(),

    [switch]$updateService
)

. .\local-registry.ps1

add-local-registry

if(-Not $registryName )
{
    $registryName = "nexus.spokvdev.com"
}
if(-Not $tag )
{
    $tag = "master"
}

$localRegistryName = "localhost`:1500"
$fullImageName = "ccp-$imageName"
$serviceName = "ccp_$imageName"
$nexusImageName = "$registryName/$fullImageName`:$tag"
$localImageName = "$localRegistryName/local-$imageName"

function push-local-image([string]$imageName)
{
    docker tag  $nexusImageName $localImageName
    docker push $localImageName
}

function update-service()
{
    docker service update --image $localImageName $serviceName
}

push-local-image

if ($updateService -like $true) {
    update-service
}
