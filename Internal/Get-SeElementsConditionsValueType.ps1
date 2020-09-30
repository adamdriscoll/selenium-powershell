Function Get-SeElementsConditionsValueType($Text) {
    return $Script:SeElementsConditions.Where( { $_.Text -eq $Text }, 'first')[0].ValueType 
}