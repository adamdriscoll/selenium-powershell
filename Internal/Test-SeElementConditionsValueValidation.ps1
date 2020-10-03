function Test-SeElementConditionsValueValidation {
    Param(
        $Element,
        $By,
        $Condition,
        $ConditionValue,
        $ParameterSetName
    )
    # 0: All;
    # 1: By 
    # 2: Element

    $ConditionDetails = $Script:SeElementsConditions.Where( { $_.Text -eq $Condition }, 'first')[0]

    switch ($ParameterSetName) {
        'Locator' {  
            if ($ConditionDetails.By_Element -eq 2) { 
                Throw "The condition $Condition can only be used with an element (`$Element)"
            }
        }
        'Element' {
            if ($ConditionDetails.By_Element -eq 1) { 
                Throw "The condition $Condition can only be used with a locator (`$By & `$Value)"
            }
        }
    }


    
    if ($null -ne $ConditionValue) {
        if ($null -eq $ConditionDetails.ValueType) {
            Throw "The condition $Condition do not accept value"
        }
        elseif ($ConditionValue -isnot $ConditionDetails.ValueType) {
            Throw "The condition $Condition accept only value of type $($ConditionDetails.ValueType). The value provided was of type $($ConditionValue.GetType())"
        }
        else {
            return $true      
        }
    }
}