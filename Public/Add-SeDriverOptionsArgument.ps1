function Add-SeDriverOptionsArgument {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [OpenQA.Selenium.DriverOptions]$InputObject,
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(Position = 0)]
        $Browser,
        [Parameter(Mandatory = $true, Position = 1)]
        [String]$Name,
        [Parameter(Mandatory = $true, Position = 1)]
        [String]$Value
    )
    
    
    Write-Host $InputObject.SeBrowser -ForegroundColor Cyan
    Write-Host  ($null -eq $Browser)
    Write-Host '---'
}



