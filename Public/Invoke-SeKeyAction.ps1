Function Invoke-SeKeyAction {
    [CmdletBinding()]
    param (
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element,
        [ValidateSet('KeyDown', 'KeyUp')]
        $Action,
        [ValidateSet('CTRL', 'Alt', 'Shift')]
        [String[]]$Key,
        [Switch]$RightKey,
        [Parameter(ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver
    )
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    $LeftKey = if ($RightKey) { '' } else { 'Left' }

    foreach ($K in $Key) {
        if ($K -eq 'CTRL') { $K = 'Control' }
        $ActualKey = [OpenQA.Selenium.Keys]::"$LeftKey$K"
        

        $Interaction = [OpenQA.Selenium.Interactions.Actions]::new($Driver)

        if ($PSBoundParameters.ContainsKey('Element')) {
            $Interaction.$Action($Element, $ActualKey).Perform()
        }
        else {
            $Interaction.$Action($ActualKey).Perform()
        }
        
       
    
    }
}