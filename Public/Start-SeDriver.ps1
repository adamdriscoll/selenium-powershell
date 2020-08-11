
function Start-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [OutputType([OpenQA.Selenium.IWebDriver])]
    param(
        #Common to all browsers
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        $Browser,
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ArgumentCompleter( { [Enum]::GetNames([SeWindowState]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeWindowState]) })]
        $State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [switch]$Quiet,
        [int]$ImplicitWait = 10,
        $WebDriverPath,
        $BinaryPath,
        [Parameter(ParameterSetName = 'DriverOptions', Mandatory = $true)]
        [OpenQA.Selenium.DriverOptions]$Options,
        [Parameter(ParameterSetName = 'Default')]
        [String[]]$Switches,
        [String[]]$Arguments,
        $ProfilePath,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [Switch]$PassThru,
        $Name 
        # See ParametersToRemove to view parameters that should not be passed to browsers internal implementations.
    )
    process {
        # Exclusive parameters to Start-SeDriver we don't want to pass down to anything else.
        # Still available through the variable directly within this cmdlet
        $ParametersToRemove = @('Arguments', 'Browser', 'Name', 'PassThru')
        $SelectedBrowser = $Browser
        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                $PSBoundParameters.Add('Options', (New-SeDriverOptions -Browser $Browser)) 
            }
            'DriverOptions' {
                $Options = $PSBoundParameters.Item('Options') 
                $SelectedBrowser = $Options.SeParams.Browser

                # Start-SeDrivers params overrides whatever is in the options. 
                # Any options parameter not specified by Start-SeDriver get added to the psboundparameters
                foreach ($Key in $Options.SeParams.Keys) {
                    if (! $PSBoundParameters.ContainsKey($Key)) {
                        $PSBoundParameters.Add($Key, $Options.SeParams.Item($Key))
                    }
                }

            }
        }

        if ($PSBoundParameters.ContainsKey('Arguments')) {
            foreach ($Argument in $Arguments) {
                $Options.AddArguments($Argument)
            }
        }

        
        $FriendlyName = $null
        if ($PSBoundParameters.ContainsKey('Name')) { 
            $FriendlyName = $Name 
       
            $AlreadyExist = $Script:SeDrivers.Where( { $_.SeFriendlyName -eq $FriendlyName }, 'first').Count -gt 0
            if ($AlreadyExist) {
                throw "A driver with the name $FriendlyName is already in the active list of started driver."
            }
        }
       

        #Remove params exclusive to this cmdlet before going further.
        $ParametersToRemove | ForEach-Object { if ($PSBoundParameters.ContainsKey("$_")) { $PSBoundParameters.Remove("$_") } }

        switch ($SelectedBrowser) {
            'Chrome' { $Driver = Start-SeChromeDriver @PSBoundParameters; break }
            'Edge' { $Driver = Start-EdgeDriver @PSBoundParameters; break }
            'Firefox' { $Driver = Start-SeFirefoxDriver @PSBoundParameters; break }
            'InternetExplorer' { $Driver = Start-SeInternetExplorerDriver @PSBoundParameters; break }
            'MSEdge' { $Driver = Start-SeMSEdgeDriver @PSBoundParameters; break }
        }
        if ($null -ne $Driver) {
            if (! $PSBoundParameters.ContainsKey('Name')) { $FriendlyName = $Driver.SessionId } 



            $defaultDisplaySet = 'SeFriendlyName', 'SeBrowser', 'SeTitle', 'SeUrl'
            $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
            $Driver | Add-Member MemberSet PSStandardMembers ([System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet))

            #Se prefix used to avoid clash with anything from Selenium in the future
            #SessionId scriptproperty validation to avoid perfomance cost of checking closed session.
            Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeFriendlyName' -Value $FriendlyName
            Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeBrowser' -Value $SelectedBrowser
            Add-Member -InputObject $Driver -MemberType ScriptProperty -Name 'SeTitle' -Value { if ($null -ne $this.SessionId) { $this.Title } }
            Add-Member -InputObject $Driver -MemberType ScriptProperty -Name 'SeUrl' -Value { if ($null -ne $this.SessionId) { $this.Url } }
            $Script:SeDrivers.Add($Driver)
            $Script:SeDriversCurrent = $Driver
        }

        if ($PassThru) {
            return $Driver
        }
    }
}

