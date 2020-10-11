function Get-SeDriverTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait'
    )
    begin {
        $Driver = Init-SeDriver -ErrorAction Stop
    }
    Process {
        return $Driver.Manage().Timeouts().$TimeoutType 
    }
    End {}
}

