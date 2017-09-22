

function clear-logs {
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string]$path
    )

    $pathExists = Test-Path $path
    if(-Not $pathExists) {
        Write-Host "Path does not exist"
        return;
    }

    Get-ChildItem $path | 
    ForEach-Object {
        $files = Get-ChildItem "$($path)/$($_)"
        $currentPath = "$($path)\$($_)"
        Write-Host "--------------------------------------------------"
        Write-Host "CURRENT PATH $($currentPath)"
        $files |
        ForEach-Object {
            if($_.Name -ne ".keep") {
                Write-Host "Removing $($_)"
                Remove-Item "$($currentPath)\$($_)"
            }
        }
    }

}