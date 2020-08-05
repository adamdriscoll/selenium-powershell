function Clear-SeAlert {
    [Alias('SeAccept', 'SeDismiss')]
    param (
        [parameter(ParameterSetName = 'Alert', Position = 0, ValueFromPipeline = $true)]
        $Alert,
        [parameter(ParameterSetName = 'Driver')]
        [ValidateIsWebDriverAttribute()]
        [Alias("Driver")]
        $Target = $Global:SeDriver,
        [ValidateSet('Accept', 'Dismiss')]
        $Action = 'Dismiss',
        [Alias('PT')]
        [switch]$PassThru
    )
    if ($Target) {
        try { $Alert = $Target.SwitchTo().alert() }
        catch { Write-Warning 'No alert was displayed'; return }
    }
    if (-not $PSBoundParameters.ContainsKey('Action') -and
        $MyInvocation.InvocationName -match 'Accept') { $Action = 'Accept' }
    if ($Alert) { $alert.$action() }
    if ($PassThru) { $Alert }
}