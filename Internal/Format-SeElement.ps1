<#
.SYNOPSIS
Format the list of elements by adding a DefaultDisplayPropertySet

.DESCRIPTION
Format the list of elements by adding a DefaultDisplayPropertySet.
It is meant to offer a visually easier default table format and 
to be used internally by any functions returning one or multiple IwebElement object.

.PARAMETER Elements
List of IwebElement to be formatted

.EXAMPLE
$Elements | Format-SeElement

.NOTES
General notes
#>
function Format-SeElement {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowNull()]
        [OpenQA.Selenium.IWebElement[]]$Elements
    )
    Begin {
        $Index = 0 
    }
    process {
        if ($null -eq $_) { return $null }
        $IndexStr = $Index.ToString().PadRight(2, ' ')
        $Value = "$IndexStr $($_.TagName.PadRight(7,' ')) $($_.Enabled.ToString().PadRight(7,' ')) $($_.Displayed)"
        add-member -InputObject $_ -Name '#  Tagname Enabled Displayed' -Value $Value -MemberType NoteProperty -Force
        # Default display set
        $defaultDisplaySet = '#  Tagname Enabled Displayed', 'Text', 'Location', 'Size'
        $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet)
        $_ | Add-Member MemberSet PSStandardMembers ([System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)) -Force
        $Index += 1
        return $_
    }
}

