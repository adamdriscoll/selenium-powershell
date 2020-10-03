class SeDriverUserAgentCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
       
        $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue

        [System.Collections.Generic.List[PSObject]]$Predefined = 
        [Microsoft.PowerShell.Commands.PSUserAgent].GetProperties() |
            Select-Object Name, @{n = 'UserAgent'; e = { [Microsoft.PowerShell.Commands.PSUserAgent]::$($_.Name) } }
        
        $Predefined.Add([PSCustomObject]@{Name = 'Android'; UserAgent = 'Android' })
        $Predefined.Add([PSCustomObject]@{Name = 'Iphone'; UserAgent = 'Iphone' })

        $Predefined |
            ForEach-Object { 
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, $pvalue, $_.UserAgent) ) ) 
            }
        return $CompletionResults
    }
}