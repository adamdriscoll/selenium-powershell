$Script:SeMouseClickAction = @(
    New-Condition -Text 'Click'         -Tooltip 'Clicks the mouse on the specified element.'
    New-Condition -Text 'Click_JS' -ElementRequired $true -Tooltip 'Clicks the mouse on the specified element using Javascript.'
    New-Condition -Text 'ClickAndHold'  -Tooltip 'Clicks and holds the mouse button down on the specified element.'
    New-Condition -Text 'ContextClick'  -Tooltip 'Right-clicks the mouse on the specified element.'
    New-Condition -Text 'DoubleClick'   -Tooltip 'Double-clicks the mouse on the specified element.'
    New-Condition -Text 'Release'       -Tooltip 'Releases the mouse button at the last known mouse coordinates or specified element.'
)

class SeMouseClickActionCompleter : System.Management.Automation.IArgumentCompleter {
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
        
        
        $Script:SeMouseClickAction.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, $_.Tooltip) ) ) 
            }
        return $CompletionResults
    }
}