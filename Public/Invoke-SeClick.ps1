function Invoke-SeClick {
    param(
        [parameter(Position = 0, HelpMessage = 'test')]
        [ArgumentCompleter([SeMouseClickActionCompleter])]
        [ValidateScript( { $_ -in $Script:SeMouseClickAction.Text })]
        $Action = 'Click',
        [Parameter( ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element,
        [Double]$Sleep = 0 ,
        [OpenQA.Selenium.IWebDriver]$Driver,
        [switch]$PassThru
    )

    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        $HasElement = $PSBoundParameters.ContainsKey('Element') -or $PSCmdlet.MyInvocation.ExpectingInput
        if ($Action -eq 'Click_JS' -and -not $HasElement) {
            Write-Error 'Click_JS can only be performed if an $Element is specified'
            return $null
        }
    }
    Process {

        switch ($Action) {
            'Click_Js' {
                try { $Driver.ExecuteScript("arguments[0].click()", $Element) }
                catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            Default {
                $Interaction = [OpenQA.Selenium.Interactions.Actions]::new($Driver)
                if ($PSBoundParameters.ContainsKey('Element')) {
                    try { $Interaction.$Action($Element).Perform() }
                    catch { $PSCmdlet.ThrowTerminatingError($_) }
                }
                else {
                    try { $Interaction.$Action().Perform() }
                    catch { $PSCmdlet.ThrowTerminatingError($_) }
                }
            }
        }

        if ($Sleep -gt 0) { Start-Sleep -Milliseconds ($Sleep * 1000) }
        if ($PassThru) { if ($HasElement) { return $Element } else { return $Driver } }
        
    }
}