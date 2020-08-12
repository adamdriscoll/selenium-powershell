function Select-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'ByName')]
    param(
        [parameter(Position = 0, ParameterSetName = 'ByDriver', Mandatory = $True)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $True)]
        [String]$Name
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ByDriver' { $Script:SeDriversCurrent = $Driver }
        'ByName' {
            $Driver = Get-SeDriver -Name $Name 
            if ($null -eq $Driver) {
                Throw  "No corresponding driver was selected. (Name: $Name) " 
            }
            else {
                $Script:SeDriversCurrent = $Driver
            }
        }
    }

    return $Driver
}

