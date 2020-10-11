function Get-SeWindow {
    [CmdletBinding()]
    param()
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        $Driver.WindowHandles
    }
}