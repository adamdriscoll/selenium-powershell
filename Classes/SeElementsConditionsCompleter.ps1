$Script:SeElementsConditions = @(
    [PSCustomObject]@{Text = 'ElementExists'; ValueType = $null; By_Element = 1; Tooltip = 'An expectation for checking that an element is present on the DOM of a page. This does not necessarily mean that the element is visible.' }
    [PSCustomObject]@{Text = 'ElementIsVisible'; ValueType = $null; By_Element = 1; Tooltip = 'An expectation for checking that an element is present on the DOM of a page and visible. Visibility means that the element is not only displayed but also has a height and width that is greater than 0.' }
    [PSCustomObject]@{Text = 'ElementToBeSelected'; ValueType = [bool]; By_Element = 0; Tooltip = 'An expectation for checking if the given element is selected.' }
    [PSCustomObject]@{Text = 'InvisibilityOfElementLocated'; ValueType = [bool]; By_Element = 1; Tooltip = 'An expectation for checking that an element is either invisible or not present on the DOM.' }
    [PSCustomObject]@{Text = 'ElementToBeClickable'; ValueType = $null; By_Element = 0; Tooltip = 'An expectation for checking an element is visible and enabled such that you can click it.' }
    [PSCustomObject]@{Text = 'InvisibilityOfElementWithText'; ValueType = [string]; By_Element = 1; Tooltip = 'An expectation for checking that an element with text is either invisible or not present on the DOM.' }
    [PSCustomObject]@{Text = 'PresenceOfAllElementsLocatedBy'; ValueType = $null; By_Element = 1; Tooltip = 'An expectation for checking that all elements present on the web page that match the locator.' }
    [PSCustomObject]@{Text = 'TextToBePresentInElement'; ValueType = [string]; By_Element = 2; Tooltip = 'An expectation for checking if the given text is present in the specified element.' }
    [PSCustomObject]@{Text = 'TextToBePresentInElementValue'; ValueType = [string]; By_Element = 0; Tooltip = 'An expectation for checking if the given text is present in the specified elements value attribute.' }
    [PSCustomObject]@{Text = 'StalenessOf'; ValueType = $null; By_Element = 2; Tooltip = 'Wait until an element is no longer attached to the DOM.' }
)

class SeElementsConditionsCompleter : System.Management.Automation.IArgumentCompleter {
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
        $SearchBy = 0
        switch ($true) {
            { $fakeBoundParameters.ContainsKey('By') } { $SearchBy = 1; break }
            { $fakeBoundParameters.ContainsKey('Element') } { $SearchBy = 2; break }
        }
        $Script:SeElementsConditions.where( { $_.Text -like $wildcard -and $_.By_Element -in @(0, $SearchBy) }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Value: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}