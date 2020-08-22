function New-SeDriverService {
    [cmdletbinding()]
    [OutputType(
        [OpenQA.Selenium.Chrome.ChromeDriverService],
        [OpenQA.Selenium.Firefox.FirefoxDriverService],
        [OpenQA.Selenium.IE.InternetExplorerDriverService],
        [OpenQA.Selenium.Edge.EdgeDriverService]
    )]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        $Browser,
        [switch]$Quiet,
        $WebDriverPath
    )

    #$AssembliesPath defined in init.ps1
    $service = $null
    $ServicePath = $null
    
    if ($WebDriverPath) { $ServicePath = $WebDriverPath } elseif ($AssembliesPath) { $ServicePath = $AssembliesPath }
    
    switch ($Browser) {
        
        Chrome { 
            if ($ServicePath) { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($ServicePath) }
            else { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService() }
        }
        Edge { 
            $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($WebDriverPath, 'msedgedriver.exe')
        }
        Firefox { 
            if ($ServicePath) { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($ServicePath) }
            else { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService() }
        }
        InternetExplorer { 
            if ($WebDriverPath) { $Service = [OpenQA.Selenium.IE.InternetExplorerDriverService]::CreateDefaultService($WebDriverPath) }
            else { $Service = [OpenQA.Selenium.IE.InternetExplorerDriverService]::CreateDefaultService() }
            
        }
        MSEdge { 
            $service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService()
        }
    }

    $service.Host = '::1'
    if ($Quiet) { $Service.HideCommandPromptWindow = $true }

    return $service
}

