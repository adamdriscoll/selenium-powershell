function Set-SeDriverTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait',
        [Parameter(Position = 1)]
        [Double]$Timeout = 0
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        $Driver.Manage().Timeouts().$TimeoutType = [timespan]::FromMilliseconds($Timeout * 1000)
    }
    End {}
}

