function Switch-SeWindow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Window
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        $Driver.SwitchTo().Window($Window) | Out-Null
    }
}