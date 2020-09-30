function Get-SeMouseActionValueValidation {
    [CmdletBinding()]
    Param(
        $Action,
        $ConditionValue
    )
    
    $ConditionValueType = $Script:SeMouseAction.Where( { $_.Text -eq $Action }, 'first')[0].ValueType
    if ($null -eq $ConditionValueType) {
        Throw "The condition $Condition do not accept value"
    }
    elseif ($ConditionValue -isnot $ConditionValueType) {
        if ($ConditionValueType.FullName -eq 'System.Drawing.Point' -and $ConditionValue -is [String] -and ($ConditionValue -split '[,x]').Count -eq 2) { return $True }
        Throw "The condition $Condition accept only value of type $ConditionValueType. The value provided was of type $($ConditionValue.GetType())"
    }
    else {
        return $true      
    }
    
}