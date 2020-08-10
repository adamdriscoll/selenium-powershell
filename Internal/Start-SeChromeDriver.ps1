function Start-SeChromeDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
      
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ValidateSet('Headless', 'Minimized', 'Maximized', 'Fullscreen')]
        $State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [switch]$Quiet,
        [int]$ImplicitWait = 10,
        $WebDriverPath = $env:ChromeWebDriver,
        $BinaryPath,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel
        


        #        [System.IO.FileInfo]$ProfilePath,
        #        $BinaryPath,
    
        # "user-data-dir=$ProfilePath"


    
    )

    process {
        #Additional Switches 
        $EnablePDFViewer = Get-OptionsSwitchValue -Switches $Switches -Name  'EnablePDFViewer'
        $DisableAutomationExtension = Get-OptionsSwitchValue -Switches $Switches -Name 'DisableAutomationExtension'

        #region Process Additional Switches
        if ($EnablePDFViewer) { $Options.AddUserProfilePreference('plugins', @{'always_open_pdf_externally' = $true; }) }

        if ($DisableAutomationExtension) {
            $Options.AddAdditionalCapability('useAutomationExtension', $false)
            $Options.AddExcludedArgument('enable-automation')
        }

        #endregion

        if ($DefaultDownloadPath) {
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Options.AddUserProfilePreference('download', @{'default_directory' = $($DefaultDownloadPath.FullName); 'prompt_for_download' = $false; })
        }

        if ($ProfilePath) {
            Write-Verbose "Setting Profile directory: $ProfilePath"
            $Options.AddArgument("user-data-dir=$ProfilePath")
        }

        if ($BinaryPath) {
            Write-Verbose "Setting Chrome Binary directory: $BinaryPath"
            $Options.BinaryLocation = "$BinaryPath"
        }

        if ($PSBoundParameters.ContainsKey('LogLevel')) {
            Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
        }

       

        switch ($State) {
            Headless { $Options.AddArguments('headless') }
            #  Minimized {}  # No switches... Managed after launch
            Maximized { $Options.AddArguments('start-maximized') }
            Fullscreen { $Options.AddArguments('start-fullscreen') }
        }
      
        if ($PrivateBrowsing) {
            $Options.AddArguments('Incognito')
        }
		
        

       
        #$AssembliesPath defined in init.ps1
        
        if ($WebDriverPath) { 
            $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($WebDriverPath) 
        }
        elseif ($AssembliesPath) { 
            $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($AssembliesPath) 
        }
        else { 
            $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService() 
        }
       
        if ($Quiet) { 
            $service.HideCommandPromptWindow = $true 
        }
        #endregion

        $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Options)
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }

        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)

        if ($State -eq 'Minimized') {
            $Driver.Manage().Window.Minimize();
        }

        if ($Headless -and $DefaultDownloadPath) {
            $HeadlessDownloadParams = [system.collections.generic.dictionary[[System.String], [System.Object]]]::new()
            $HeadlessDownloadParams.Add('behavior', 'allow')
            $HeadlessDownloadParams.Add('downloadPath', $DefaultDownloadPath.FullName)
            $Driver.ExecuteChromeCommand('Page.setDownloadBehavior', $HeadlessDownloadParams)
        }

        if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }
        #endregion


        return $Driver
    }
}

