function Invoke-SeClick {
    [CmdletBinding()]
    param(
        [parameter(Position = 0, HelpMessage = 'test')]
        [ArgumentCompleter([SeMouseClickActionCompleter])]
        [ValidateScript( { $_ -in $Script:SeMouseClickAction.Text })]
        $Action = 'Click',
        [Parameter( ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element,
        [Double]$Sleep = 0 ,
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
        Write-Verbose "Performing $Action"
        switch ($Action) {
            'Click_Js' {
                try { $Driver.ExecuteScript("arguments[0].click()", $Element) }
                catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            Default {
                $Interaction = [OpenQA.Selenium.Interactions.Actions]::new($Driver)
                if ($PSBoundParameters.ContainsKey('Element')) {
                    Write-Verbose "On Element: $($Element.Tagname)"
                    if ($Action -eq 'Click') {  
                        $Element.Click() #Mitigating IE driver issue with statement below.
                    }
                    else {
                        try { $Interaction.$Action($Element).Perform() }
                        catch { $PSCmdlet.ThrowTerminatingError($_) }
                    }
                }
                else {
                    Write-Verbose "On Driver currently located at: $($Driver.Url)"
                    try { $Interaction.$Action().Perform() }
                    catch { $PSCmdlet.ThrowTerminatingError($_) }
                }
            }
        }

        if ($Sleep -gt 0) { Start-Sleep -Milliseconds ($Sleep * 1000) }
        if ($PassThru) { if ($HasElement) { return $Element } else { return $Driver } }
        
    }
}