function Stop-SeDriver { 
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


        if ($null -ne $Driver) {
            $BrowserName = $TextInfo.ToTitleCase($Driver.Capabilities.browsername)

            if ($null -eq $Driver.SessionId) {
                Write-Warning "$BrowserName Driver already closed"
                if ($ElementsToRemove.contains($Driver)) { $ElementsToRemove.Add($Driver) }
                
            }
            else {
                Write-Verbose -Message "Closing $BrowserName $($Driver.SeFriendlyName )..."
            
                $Driver.Close()
                $Driver.Dispose()
                $ElementsToRemove.Add($Driver)    
            }

            
      
       
        }
        
    }
    End {
        $ElementsToRemove | ForEach-Object { [void]($script:SeDrivers.Remove($_)) }
        $script:SeDriversCurrent = $null
    }
    

  
}