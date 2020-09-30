$Script:SeDriverConditions = @(
    [PSCustomObject]@{Text = 'AlertState'; ValueType = [bool]; Tooltip = "A value indicating whether or not an alert should be displayed in order to meet this condition." }
    [PSCustomObject]@{Text = 'ScriptBlock'; ValueType = [ScriptBlock]; Tooltip = "A scriptblock to be evaluated." }
    [PSCustomObject]@{Text = 'TitleContains'; ValueType = [String]; Tooltip = "An expectation for checking that the title of a page contains a case-sensitive substring." }
    [PSCustomObject]@{Text = 'TitleIs'; ValueType = [String]; Tooltip = "An expectation for checking the title of a page." }
    [PSCustomObject]@{Text = 'UrlContains'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
    [PSCustomObject]@{Text = 'UrlMatches'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
    [PSCustomObject]@{Text = 'UrlToBe'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
)

class SeDriverConditionsCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

        $Script:SeDriverConditions.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Value: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}