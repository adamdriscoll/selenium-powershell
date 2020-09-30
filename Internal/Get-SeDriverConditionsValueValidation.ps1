function Get-SeDriverConditionsValueValidation {
    [CmdletBinding()]
    param (
        $Condition, $Value
    )

    if ($PSBoundParameters.ContainsKey('Condition')) {
        $ConditionValueType = $Script:SeDriverConditions.Where( { $_.Text -eq $Condition }, 'first')[0].ValueType
        
        if ($null -eq $ConditionValueType) {
            Throw "The condition $Condition do not accept value"
        }
        elseif ($Value -isnot $ConditionValueType) {
            Throw "The condition $Condition accept only value of type $ConditionValueType. The value provided was of type $($Value.GetType())"
        }
        else {
            return $true      
        }
    }
 
}