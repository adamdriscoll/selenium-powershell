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
        $Target = $Script:SeDriversCurrent
    )
 
    if ($frame) { [void]$Target.SwitchTo().Frame($Frame) }
    elseif ($Parent) { [void]$Target.SwitchTo().ParentFrame() }
    elseif ($Root) { [void]$Target.SwitchTo().defaultContent() }
}