function Get-SeDriverTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait'
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        return $Driver.Manage().Timeouts().$TimeoutType 
    }
    End {}
}

