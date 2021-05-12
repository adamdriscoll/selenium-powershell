function Start-SeChromeDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath = $env:ChromeWebDriver,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        $UserAgent,
        [Switch]$AcceptInsecureCertificates,
        [Double]$CommandTimeout



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

        if ($UserAgent) {
            Write-Verbose "Setting User Agent: $UserAgent"
            $Options.AddArgument("--user-agent=$UserAgent")
        }

        if ($AcceptInsecureCertificates) {
            Write-Verbose "AcceptInsecureCertificates capability set to: $($AcceptInsecureCertificates.IsPresent)"
            $Options.AddAdditionalCapability([OpenQA.Selenium.Remote.CapabilityType]::AcceptInsecureCertificates, $true, $true)
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
            { $_ -eq [SeWindowState]::Headless } { $Options.AddArguments('headless') }
            #  { $_ -eq [SeWindowState]::Minimized } {}  # No switches... Managed after launch
            { $_ -eq [SeWindowState]::Maximized } { $Options.AddArguments('start-maximized') }
            { $_ -eq [SeWindowState]::Fullscreen } { $Options.AddArguments('start-fullscreen') }
        }

        if ($PrivateBrowsing) {
            $Options.AddArguments('Incognito')
        }
        #  $Location = @('--window-position=1921,0', '--window-size=1919,1080')
        if ($PSBoundParameters.ContainsKey('Size')) {
            $Options.AddArguments("--window-size=$($Size.Width),$($Size.Height)")
        }
        if ($PSBoundParameters.ContainsKey('Position')) {
            $Options.AddArguments("--window-position=$($Position.X),$($Position.Y)")
        }



        if (-not $PSBoundParameters.ContainsKey('Service')) {
            $ServiceParams = @{}
            if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
            $service = New-SeDriverService -Browser Chrome @ServiceParams
        }


        if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
            $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Options, [TimeSpan]::FromMilliseconds($CommandTimeout * 1000))
        }
        else {
            $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Options)
        }
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }
        Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)

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

