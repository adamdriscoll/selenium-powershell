function Switch-SeFrame {
    [Alias('SeFrame')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Frame', Position = 0)]
        $Frame,

        [Parameter(Mandatory = $true, ParameterSetName = 'Parent')]
        [switch]$Parent,

        [Parameter(Mandatory = $true, ParameterSetName = 'Root')]
        [Alias('defaultContent')]
        [switch]$Root,

        [Parameter(ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Global:SeDriver
    )
 
    if ($frame) { [void]$Target.SwitchTo().Frame($Frame) }
    elseif ($Parent) { [void]$Target.SwitchTo().ParentFrame() }
    elseif ($Root) { [void]$Target.SwitchTo().defaultContent() }
}