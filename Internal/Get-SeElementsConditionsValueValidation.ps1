function Get-SeElementsConditionsValueValidation {
    Param(
        $Element,
        $By,
        $Condition,
        $ConditionValue
    )
    # 0: All;
    # 1: By 
    # 2: Element
    if ($PSBoundParameters.ContainsKey('ConditionValue')) {
        $ConditionValueType = $Script:SeElementsConditions.Where( { $_.Text -eq $Condition }, 'first')[0].ValueType
        if ($null -eq $ConditionValueType) {
            Throw "The condition $Condition do not accept value"
        }
        elseif ($ConditionValue -isnot $ConditionValueType) {
            Throw "The condition $Condition accept only value of type $ConditionValueType. The value provided was of type $($ConditionValue.GetType())"
        }
        else {
            return $true      
        }
    }
}