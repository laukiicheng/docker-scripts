# Parse and create variables for lines in the env.txt file
function parse-variables {
    Get-Content .\env.txt |
    ForEach-Object {
        $var = $_.Split('=')
        New-Variable -Name $var[0] -Value $var[1]
    }
}