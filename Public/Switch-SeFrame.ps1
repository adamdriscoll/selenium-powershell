function Switch-SeFrame {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Frame', Position = 0)]
        $Frame,

        [Parameter(Mandatory = $true, ParameterSetName = 'Parent')]
        [switch]$Parent,

        [Parameter(Mandatory = $true, ParameterSetName = 'Root')]
        [switch]$Root
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    #TODO Frame validation... Do not try to switch if element does not exist ?
    #TODO Review ... Maybe Parent / Root should be a unique parameter : -Level Parent/Root )
    if ($frame) { [void]$Driver.SwitchTo().Frame($Frame) }
    elseif ($Parent) { [void]$Driver.SwitchTo().ParentFrame() }
    elseif ($Root) { [void]$Driver.SwitchTo().defaultContent() }
}