class SeMouseActionCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
       
        $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue

        $Script:SeMouseAction.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $ElementRequired = 'N/A'
                switch ($_.ElementRequired) {
                    $true { $ElementRequired = 'Required' }
                    $false { $ElementRequired = 'Optional' }
                }


                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Element: $ElementRequired`nValue: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}