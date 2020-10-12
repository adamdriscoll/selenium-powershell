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
            $Driver = $script:SeDriversCurrent
        }

        
        $Processes = (Get-Process -Id $Drv.SeProcessId, $Drv.SeServiceProcessId -ErrorAction SilentlyContinue )

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
        $script:SeDriversCurrent = $null
    }
    

  
}