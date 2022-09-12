Param
(
    [Parameter(Mandatory=$true,
               ValueFromPipelineByPropertyName=$true,
               Position=0)]
    [string] $inputuri = ""
)

function Get-QueryStrings
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string] $inputuri = ""
    )
    Add-Type -AssemblyName System.Web
    #Write-Host $inputuri
    $inputuri -split "[?&]" -like "*=*" | foreach -Begin {$h = @{}} -Process {
    $h[($_ -split "=",2 | select -index 0)] = ($_ -split "=",2)| select -index 1
    }
    $h.Keys.Clone() | ForEach-Object { $h[$_] = [System.Web.HttpUtility]::UrlDecode($h[$_]) }
    $h
    $selectedkey = Read-Host -Prompt 'Expand which Query?'
    $h.$selectedkey
    return
}

#$inputuri | Measure-Object -Character
Get-QueryStrings $inputuri
