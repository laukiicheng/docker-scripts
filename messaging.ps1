# Pull images for the messaging context by tag
function mg-pull {
    Param(
        [ValidateSet("master", "test-stable")]
        [Parameter(Position=0,mandatory=$true)]
        [string]$tag
    )

    $images = docker image ls --format "{{. | json}}" | 
    ConvertFrom-Json | 
    where { $_.Repository -like  "*messaging*" -AND $_.Tag -notlike "dev"}

    foreach($element in $images) {
        docker pull "$($element.Repository):$($tag)"
    }
}

