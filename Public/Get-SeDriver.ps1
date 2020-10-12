
function Get-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'All')]
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

    $Output = $null
    switch ($PSCmdlet.ParameterSetName) {
        'All' { $Output = $Script:SeDrivers; break }
        'Current' { 
            $Output = $Script:SeDriversCurrent
            if ($null -eq $Output) { Write-Warning 'No selected driver' }
            break 
        }
        'ByName' { $Output = $Script:SeDrivers.Where( { $_.SeFriendlyName -eq $Name }, 'first' ); break }
        'ByBrowser' { $Output = $Script:SeDrivers.Where( { $_.SeBrowser -like "$Browser*" }); break }
    }

    if ($null -eq $Output) { return }
    
    $DriversToClose = [System.Collections.Generic.List[PSObject]]::new()
    Foreach ($drv in $Output) {
        $Processes = (Get-Process -Id $Drv.SeProcessId, $Drv.SeServiceProcessId -ErrorAction SilentlyContinue )
        if ($Processes.count -eq 2) { Continue }

        if ($Processes.count -eq 0) {
            Write-Warning -Message "The driver $($Drv.SeFriendlyName) $($Drv.SeBrowser) processes are not running anymore and have been removed automatically from the list of available drivers."
        }
        else { 
            $ProcessType = if ($Processes.id -eq $Drv.SeServiceProcessId) { "driver service" } else { "browser" }
            Write-Warning -Message "The driver $($Drv.SeFriendlyName) $($Drv.SeBrowser) $ProcessType is not running anymore and will be removed from the active driver list."
        }
        $DriversToClose.Add($Drv)
    }

    if ($DriversToClose.Count -gt 0) { 
        foreach ($drv in $DriversToClose) {
            $Output = $Output.Where( { $_.SeServiceProcessId -ne $drv.SeServiceProcessId })
            Stop-SeDriver -Driver $drv
        }
    }
    return $Output
}