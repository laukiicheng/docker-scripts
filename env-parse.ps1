

function parse-variables {
    Get-Content .\env.txt |
    ForEach-Object {
        Write-Host $_
        $var = $_.Split('=')
        New-Variable -Name $var[0] -Value $var[1]
    }
}