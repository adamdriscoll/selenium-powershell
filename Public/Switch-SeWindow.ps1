function Switch-SeWindow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Window
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        $Driver.SwitchTo().Window($Window) | Out-Null
    }
}