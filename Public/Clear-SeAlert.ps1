function Clear-SeAlert {
    param (
        [parameter(ParameterSetName = 'Alert', Position = 0, ValueFromPipeline = $true)]
        $Alert,
        [parameter(ParameterSetName = 'Driver')]
        [ValidateIsWebDriverAttribute()]
        $Target = $Script:SeDriversCurrent,
        [ValidateSet('Accept', 'Dismiss')]
        $Action = 'Dismiss',
        [switch]$PassThru
    )
    if ($Target) {
        try { $Alert = $Target.SwitchTo().alert() }
        catch { Write-Warning 'No alert was displayed'; return }
    }
    if ($Alert) { $alert.$action() }
    if ($PassThru) { $Alert }
}