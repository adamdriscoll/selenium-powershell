function Get-SeWindow {
    [CmdletBinding()]
    param()
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        $Driver.WindowHandles
    }
}