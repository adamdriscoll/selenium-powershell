function Start-SeChrome {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [Alias('SeChrome')]
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [Parameter(Mandatory = $false)]
        [array]$Arguments,
        [switch]$HideVersionHint,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [System.IO.FileInfo]$ProfileDirectoryPath,
        [Parameter(DontShow)]
        [bool]$DisableBuiltInPDFViewer = $true,
        [switch]$EnablePDFViewer,
        [Alias('PrivateBrowsing')]
        [switch]$Incognito,
        [parameter(ParameterSetName = 'Headless', Mandatory = $true)]
        [switch]$Headless,
        [parameter(ParameterSetName = 'Minimized', Mandatory = $true)]
        [switch]$Maximized,
        [parameter(ParameterSetName = 'Maximized', Mandatory = $true)]
        [switch]$Minimized,
        [parameter(ParameterSetName = 'Fullscreen', Mandatory = $true)]
        [switch]$Fullscreen,
        [switch]$DisableAutomationExtension,
        [Alias('ChromeBinaryPath')]
        $BinaryPath,
        $WebDriverDirectory = $env:ChromeWebDriver,
        [switch]$Quiet,
        [switch]$AsDefaultDriver,
        [int]$ImplicitWait = 10
    )

    process {
        #region chrome set-up options
        $Chrome_Options = [OpenQA.Selenium.Chrome.ChromeOptions]::new()

        if ($DefaultDownloadPath) {
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Chrome_Options.AddUserProfilePreference('download', @{'default_directory' = $($DefaultDownloadPath.FullName); 'prompt_for_download' = $false; })
        }

        if ($ProfileDirectoryPath) {
            Write-Verbose "Setting Profile directory: $ProfileDirectoryPath"
            $Chrome_Options.AddArgument("user-data-dir=$ProfileDirectoryPath")
        }

        if ($BinaryPath) {
            Write-Verbose "Setting Chrome Binary directory: $BinaryPath"
            $Chrome_Options.BinaryLocation = "$BinaryPath"
        }

        if ($DisableBuiltInPDFViewer -and -not $EnablePDFViewer) {
            $Chrome_Options.AddUserProfilePreference('plugins', @{'always_open_pdf_externally' = $true; })
        }

        if ($Headless) {
            $Chrome_Options.AddArguments('headless')
        }

        if ($Incognito) {
            $Chrome_Options.AddArguments('Incognito')
        }

        if ($Maximized) {
            $Chrome_Options.AddArguments('start-maximized')
        }

        if ($Fullscreen) {
            $Chrome_Options.AddArguments('start-fullscreen')
        }
		
        if ($DisableAutomationExtension) {
            $Chrome_Options.AddAdditionalCapability('useAutomationExtension', $false)
            $Chrome_Options.AddExcludedArgument('enable-automation')
        }

        if ($Arguments) {
            foreach ($Argument in $Arguments) {
                $Chrome_Options.AddArguments($Argument)
            }
        }

        if (!$HideVersionHint) {
            Write-Verbose "Download the right chromedriver from 'http://chromedriver.chromium.org/downloads'"
        }

        if ($WebDriverDirectory) { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($WebDriverDirectory) }
        elseif ($AssembliesPath) { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($AssembliesPath) }
        else { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService() }
        if ($Quiet) { $service.HideCommandPromptWindow = $true }
        #endregion

        $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Chrome_Options)
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }

        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)

        if ($Minimized) {
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

        if ($AsDefaultDriver) {
            if ($Global:SeDriver) { $Global:SeDriver.Dispose() }
            $Global:SeDriver = $Driver
        }
        else { $Driver }
    }
}