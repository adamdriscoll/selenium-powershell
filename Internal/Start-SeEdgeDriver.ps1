function Start-SeEdgeDriver {
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel

    )
    $OptionSettings = @{ browserName = '' }
    #region check / set paths for browser and web driver and edge options
    if ($PSBoundParameters['BinaryPath'] -and -not (Test-Path -Path $BinaryPath)) {
        throw "Could not find $BinaryPath"; return
    }

    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    #Were we given a driver location and is msedgedriver there ?
    #If were were given a location (which might be from an environment variable) is the driver THERE ?
    # if not, were we given a path for the browser executable, and is the driver THERE ?
    # and if not there either, is there one in the assemblies sub dir ? And if not bail
    if ($WebDriverPath -and -not (Test-Path -Path (Join-Path -Path $WebDriverPath -ChildPath 'msedgedriver.exe'))) {
        throw "Could not find msedgedriver.exe in $WebDriverPath"; return
    }
    elseif ($WebDriverPath -and (Test-Path (Join-Path -Path $WebDriverPath -ChildPath 'msedge.exe'))) {
        Write-Verbose -Message "Using browser from $WebDriverPath"
        $optionsettings['BinaryLocation'] = Join-Path -Path $WebDriverPath -ChildPath 'msedge.exe'
    }
    elseif ($BinaryPath) {
        $optionsettings['BinaryLocation'] = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BinaryPath)
        $binaryDir = Split-Path -Path $BinaryPath -Parent
        Write-Verbose -Message "Will request $($OptionSettings['BinaryLocation']) as the browser"
    }
    if (-not $WebDriverPath -and $binaryDir -and (Test-Path (Join-Path -Path $binaryDir -ChildPath 'msedgedriver.exe'))) {
        $WebDriverPath = $binaryDir
    }
    # No linux or mac driver to test for yet
    if (-not $WebDriverPath -and (Test-Path (Join-Path -Path "$PSScriptRoot\Assemblies\" -ChildPath 'msedgedriver.exe'))) {
        $WebDriverPath = "$PSScriptRoot\Assemblies\"
        Write-Verbose -Message "Using Web driver from the default location"
    }
    
    if (-not $PSBoundParameters.ContainsKey('Service')) {
        $ServiceParams = @{}
        if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
        $service = New-SeDriverService -Browser Edge @ServiceParams
    }
    
    $options = New-Object -TypeName OpenQA.Selenium.Chrome.ChromeOptions -Property $OptionSettings
    
    #The command line args may now be --inprivate --headless but msedge driver V81 does not pass them
    if ($PrivateBrowsing) { $options.AddArguments('InPrivate') }
    if ($State -eq [SeWindowState]::Headless) { $options.AddArguments('headless') }
    if ($ProfilePath) {
        $ProfilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProfilePath)
        Write-Verbose "Setting Profile directory: $ProfilePath"
        $options.AddArgument("user-data-dir=$ProfilePath")
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
        Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
        $driverversion = $Driver.Capabilities.ToDictionary().msedge.msedgedriverVersion -replace '^([\d.]+).*$', '$1'
        if (-not $driverversion) { $driverversion = $driver.Capabilities.ToDictionary().chrome.chromedriverVersion -replace '^([\d.]+).*$', '$1' }
        Write-Verbose "Web Driver version $driverversion"
        Write-Verbose ("Browser: {0,9} {1}" -f $Driver.Capabilities.ToDictionary().browserName,
            $Driver.Capabilities.ToDictionary().browserVersion)
        
        $browserCmdline = (Get-CimInstance -Verbose:$false -Query (
                "Select * From win32_process " +
                "Where parentprocessid = $($service.ProcessId) " +
                "And name = 'msedge.exe'")).commandline
        $options.arguments | Where-Object { $browserCmdline -notlike "*$_*" } | ForEach-Object {
            Write-Warning "Argument $_ was not passed to the Browser. This is a known issue with some web driver versions."
        }
    }

    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }

    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)
    if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }


    switch ($State) {
        { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); }
        { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() }
        { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() }
    }

 
    #endregion

    return  $Driver
}