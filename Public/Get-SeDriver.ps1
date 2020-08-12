function Get-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'Current')]
    param(
        [parameter(ParameterSetName = 'Current', Mandatory = $false)]
        [Switch]$Current,
        [parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $false)]
        [String]$Name,
        [parameter(ParameterSetName = 'ByBrowser', Mandatory = $false)]
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        $Browser
        
        
    
    )
    

    if ($Script:SeDrivers.count -eq 0) { return $null }
    if ($Current) { return $Script:SeDriversCurrent }


    if ($PSBoundParameters.ContainsKey('Browser')) { 
        return $Script:SeDrivers.Where( { $Browser -like "$($_.SeBrowser)*" } )
    }
    
    if ($PSBoundParameters.ContainsKey('Name')) { 
        return $Script:SeDrivers.Where( { $_.SeFriendlyName -eq $Name }, 'first' )
    }

    return $Script:SeDrivers

}

