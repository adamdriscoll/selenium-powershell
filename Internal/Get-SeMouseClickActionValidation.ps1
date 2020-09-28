
$Script:SeMouseAction = @(
    New-Condition -Text 'DragAndDrop' -ValueType ([OpenQA.Selenium.IWebElement]) -Tooltip 'Performs a drag-and-drop operation from one element to another.'
    New-Condition -Text 'DragAndDropToOffset'  -ValueType ([System.Drawing.Point]) -Tooltip 'Performs a drag-and-drop operation on one element to a specified offset.'
    New-Condition -Text 'MoveByOffset' -ValueType ([System.Drawing.Point]) -ElementRequired $null -Tooltip 'Moves the mouse to the specified offset of the last known mouse coordinates.'
    New-Condition -Text 'MoveToElement'  -ValueType ([System.Drawing.Point]) -OptionalValue -Tooltip 'Moves the mouse to the specified element with offset of the top-left corner of the specified element.'
    New-Condition -Text 'Release' -ValueType $null -Tooltip 'Releases the mouse button at the last known mouse coordinates or specified element.'
)


$Script:SeMouseClickAction = @(
    New-Condition -Text 'Click'         -Tooltip 'Clicks the mouse on the specified element.'
    New-Condition -Text 'Click_JS' -ElementRequired $true -Tooltip 'Clicks the mouse on the specified element using Javascript.'
    New-Condition -Text 'ClickAndHold'  -Tooltip 'Clicks and holds the mouse button down on the specified element.'
    New-Condition -Text 'ContextClick'  -Tooltip 'Right-clicks the mouse on the specified element.'
    New-Condition -Text 'DoubleClick'   -Tooltip 'Double-clicks the mouse on the specified element.'
    New-Condition -Text 'Release'       -Tooltip 'Releases the mouse button at the last known mouse coordinates or specified element.'
)

Function Get-SeMouseClickActionValidation($Action) {
    return $Action -in $Script:SeMouseClickAction.Text
}