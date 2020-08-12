function Select-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'ByName')]
    param(
        [parameter(Position = 0, ParameterSetName = 'ByDriver', Mandatory = $True)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $True)]
        [String]$Name
    )

    # Remove Selected visual indicator
    if ($null -ne $Script:SeDriversCurrent) { 
        $Script:SeDriversCurrent.SeBrowser = $Script:SeDriversCurrent.SeBrowser -replace ' \*$', ''
    }

    switch ($PSCmdlet.ParameterSetName) {
        'ByDriver' { $Script:SeDriversCurrent = $Driver }
        'ByName' {
            $Driver = Get-SeDriver -Name $Name 
            if ($null -eq $Driver) {
                $PSCmdlet.ThrowTerminatingError("Driver with Name: $Name not found ")
            }
            else {
                $Script:SeDriversCurrent = $Driver
            }
        }
    }

    $Driver.SeBrowser = "$($Driver.SeBrowser) *"

    return $Driver
}

