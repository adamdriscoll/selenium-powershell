function Open-SeUrl {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [Alias('SeNavigate', "Enter-SeUrl")]
    param(
        [Parameter(Mandatory = $true, position = 0, ParameterSetName = 'url')]
        [ValidateURIAttribute()]
        [string]$Url,

        [Parameter(Mandatory = $true, ParameterSetName = 'back')]
        [switch]$Back,

        [Parameter(Mandatory = $true, ParameterSetName = 'forward')]
        [switch]$Forward,

        [Parameter(Mandatory = $true, ParameterSetName = 'refresh')]
        [switch]$Refresh,

        [Parameter(ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Global:SeDriver
    )

    switch ($PSCmdlet.ParameterSetName) {
        'url' { $Target.Navigate().GoToUrl($Url); break }
        'back' { $Target.Navigate().Back(); break }
        'forward' { $Target.Navigate().Forward(); break }
        'refresh' { $Target.Navigate().Refresh(); break }

        default { throw 'Unexpected ParameterSet' }
    }
}