function Stop-SeDriver { 
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Target
    )
    Begin {
        $ElementsToRemove = [System.Collections.Generic.List[PSObject]]::new()
        $TextInfo = (Get-Culture).TextInfo 
    }
    Process {
        if (! $PSBoundParameters.ContainsKey('Target')) {
            $Target = $script:SeDriversCurrent
        }


        if ($null -ne $Target) {
            $BrowserName = $TextInfo.ToTitleCase($Target.Capabilities.browsername)

            if ($null -eq $Target.SessionId) {
                Write-Warning "$BrowserName Driver already closed"
                return $null
            }

            Write-Verbose -Message "Closing $BrowserName $($Target.SeFriendlyName )..."
            
            $Target.Close()
            $Target.Dispose()
            $ElementsToRemove.Add($Target)    
      
       
        }
        else { Write-Warning 'A valid <IWebDriver> must be provided.' }
    }
    End {
        $ElementsToRemove | ForEach-Object { [void]($script:SeDrivers.Remove($_)) }
        
    }
    

  
}