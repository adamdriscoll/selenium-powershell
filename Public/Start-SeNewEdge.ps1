function Start-SeNewEdge {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [Alias('CrEdge', 'NewEdge')]
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [switch]$HideVersionHint,
        [parameter(ParameterSetName = 'Minimized', Mandatory = $true)]
        [switch]$Minimized,
        [parameter(ParameterSetName = 'Maximized', Mandatory = $true)]
        [switch]$Maximized,
        [parameter(ParameterSetName = 'Fullscreen', Mandatory = $true)]
        [switch]$FullScreen,
        [parameter(ParameterSetName = 'Headless', Mandatory = $true)]
        [switch]$Headless,
        $BinaryPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        $ProfileDirectoryPath,
        $DefaultDownloadPath,
        [switch]$AsDefaultDriver,
        [switch]$Quiet,
        [Alias('Incognito')]
        [switch]$PrivateBrowsing,
        [int]$ImplicitWait = 10,
        $WebDriverDirectory = $env:EdgeWebDriver
    )
    $OptionSettings = @{ browserName = '' }
    #region check / set paths for browser and web driver and edge options
    if ($PSBoundParameters['BinaryPath'] -and -not (Test-Path -Path $BinaryPath)) {
        throw "Could not find $BinaryPath"; return
    }

    #Were we given a driver location and is msedgedriver there ?
    #If were were given a location (which might be from an environment variable) is the driver THERE ?
    # if not, were we given a path for the browser executable, and is the driver THERE ?
    # and if not there either, is there one in the assemblies sub dir ? And if not bail
    if ($WebDriverDirectory -and -not (Test-Path -Path (Join-Path -Path $WebDriverDirectory -ChildPath 'msedgedriver.exe'))) {
        throw "Could not find msedgedriver.exe in $WebDriverDirectory"; return
    }
    elseif ($WebDriverDirectory -and (Test-Path (Join-Path -Path $WebDriverDirectory -ChildPath 'msedge.exe'))) {
        Write-Verbose -Message "Using browser from $WebDriverDirectory"
        $optionsettings['BinaryLocation'] = Join-Path -Path $WebDriverDirectory -ChildPath 'msedge.exe'
    }
    elseif ($BinaryPath) {
        $optionsettings['BinaryLocation'] = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BinaryPath)
        $binaryDir = Split-Path -Path $BinaryPath -Parent
        Write-Verbose -Message "Will request $($OptionSettings['BinaryLocation']) as the browser"
    }
    if (-not $WebDriverDirectory -and $binaryDir -and (Test-Path (Join-Path -Path $binaryDir -ChildPath 'msedgedriver.exe'))) {
        $WebDriverDirectory = $binaryDir
    }
    # No linux or mac driver to test for yet
    if (-not $WebDriverDirectory -and (Test-Path (Join-Path -Path "$PSScriptRoot\Assemblies\" -ChildPath 'msedgedriver.exe'))) {
        $WebDriverDirectory = "$PSScriptRoot\Assemblies\"
        Write-Verbose -Message "Using Web driver from the default location"
    }
    if (-not $WebDriverDirectory) { throw "Could not find msedgedriver.exe"; return }

    # The "credge" web driver will work with the edge selenium objects, but works better with the chrome ones.
    $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($WebDriverDirectory, 'msedgedriver.exe')
    $options = New-Object -TypeName OpenQA.Selenium.Chrome.ChromeOptions -Property $OptionSettings
    #The command line args may now be --inprivate --headless but msedge driver V81 does not pass them
    if ($PrivateBrowsing) { $options.AddArguments('InPrivate') }
    if ($Headless) { $options.AddArguments('headless') }
    if ($Quiet) { $service.HideCommandPromptWindow = $true }
    if ($ProfileDirectoryPath) {
        $ProfileDirectoryPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProfileDirectoryPath)
        Write-Verbose "Setting Profile directory: $ProfileDirectoryPath"
        $options.AddArgument("user-data-dir=$ProfileDirectoryPath")
    }
    if ($DefaultDownloadPath) {
        $DefaultDownloadPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DefaultDownloadPath)
        Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
        $Options.AddUserProfilePreference('download', @{'default_directory' = $DefaultDownloadPath; 'prompt_for_download' = $false; })
    }
    #endregion

    $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $options)

    #region post driver checks and option checks If we have a version know to have problems with passing arguments, generate a warning if we tried to send any.
    if (-not $Driver) {
        Write-Warning "Web driver was not created"; return
    }
    else {
        $driverversion = $Driver.Capabilities.ToDictionary().msedge.msedgedriverVersion -replace '^([\d.]+).*$', '$1'
        if (-not $driverversion) { $driverversion = $driver.Capabilities.ToDictionary().chrome.chromedriverVersion -replace '^([\d.]+).*$', '$1' }
        Write-Verbose "Web Driver version $driverversion"
        Write-Verbose ("Browser: {0,9} {1}" -f $Driver.Capabilities.ToDictionary().browserName,
            $Driver.Capabilities.ToDictionary().browserVersion)
        if (!$HideVersionHint) {
            Write-Verbose "You can download the right webdriver from 'https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/'"
        }
        $browserCmdline = (Get-CimInstance -Verbose:$false -Query (
                "Select * From win32_process " +
                "Where parentprocessid = $($service.ProcessId) " +
                "And name = 'msedge.exe'")).commandline
        $options.arguments | Where-Object { $browserCmdline -notlike "*$_*" } | ForEach-Object {
            Write-Warning "Argument $_ was not passed to the Browser. This is a known issue with some web driver versions."
        }
    }

    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)
    if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }

    if ($Minimized) {
        $Driver.Manage().Window.Minimize();
    }
    if ($Maximized) {
        $Driver.Manage().Window.Maximize()
    }
    if ($FullScreen) {
        $Driver.Manage().Window.FullScreen()
    }
    #endregion

    if ($AsDefaultDriver) {
        if ($Global:SeDriver) { $Global:SeDriver.Dispose() }
        $Global:SeDriver = $Driver
    }
    else { $Driver }
}