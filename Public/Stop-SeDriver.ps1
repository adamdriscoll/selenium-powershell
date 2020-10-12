function Stop-SeDriver { 
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver
    )
    Begin {
        $ElementsToRemove = [System.Collections.Generic.List[PSObject]]::new()
        $TextInfo = (Get-Culture).TextInfo 
    }
    Process {
        if (! $PSBoundParameters.ContainsKey('Driver')) {
            $Driver = Get-SeDriver -Current
        }

        
        $Processes = (Get-Process -Id $Driver.SeProcessId, $Driver.SeServiceProcessId -ErrorAction SilentlyContinue )

        switch ($Processes.Count) {
            2 {
                Write-Verbose -Message "Closing $BrowserName $($Driver.SeFriendlyName )..."
                $Driver.Close()
                $Driver.Dispose() 
                break
            }
            1 { Stop-Process -Id $Processes.Id -ErrorAction SilentlyContinue }
        }
        $ElementsToRemove.Add($Driver)   
               
    }
    End {
        $ElementsToRemove | ForEach-Object { [void]($script:SeDrivers.Remove($_)) }
        if ($script:SeDriversCurrent -notin $script:SeDrivers) {
            $script:SeDriversCurrent = $null
        }
        
    }
    

  
}