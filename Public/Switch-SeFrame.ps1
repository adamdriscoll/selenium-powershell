function Switch-SeFrame {
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Frame', Position = 0)]
        $Frame,

        [Parameter(Mandatory = $true, ParameterSetName = 'Parent')]
        [switch]$Parent,

        [Parameter(Mandatory = $true, ParameterSetName = 'Root')]
        #TODO Which one make more sense
        [Alias('defaultContent')]
        [switch]$Root,

        [Parameter(ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver = $Script:SeDriversCurrent
    )
 #TODO Frame validation... Do not try to switch if element does not exist ?
    if ($frame) { [void]$Driver.SwitchTo().Frame($Frame) }
    elseif ($Parent) { [void]$Driver.SwitchTo().ParentFrame() }
    elseif ($Root) { [void]$Driver.SwitchTo().defaultContent() }
}