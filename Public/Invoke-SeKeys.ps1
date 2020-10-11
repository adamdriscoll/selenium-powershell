$Script:ModifierKeys = @(
    'Control',
    'LeftControl'
    'Alt',
    'LeftAlt'
    'Shift',
    'LeftShift'
)
function Invoke-SeKeys {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter( Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element ,
        [Parameter(Mandatory = $true, Position = 1)]
        [AllowEmptyString()]
        [string]$Keys,
        [switch]$ClearFirst,
        [Double]$Sleep = 0 ,
        [switch]$Submit,
        [switch]$PassThru,
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebDriver]$Driver
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        
        $Regexstr = '(?<expression>{{(?<value>.*?)}})'
        $MyMatches = [Regex]::Matches($Keys, $Regexstr)
        #Treat modifier keys as key down . 
        $Sequence = [System.Collections.Generic.List[String]]::new()
        $UseSequence = $Keys.StartsWith('{{')

        Foreach ($m in $MyMatches) {
            $key = $m.Groups.Item('value').value   
            $Found = $Script:SeKeys.Name.Contains($value)
            if ($null -ne $Found) {
                if ($UseSequence -and $Key -in $Script:ModifierKeys) {
                    $Sequence.Add([OpenQA.Selenium.Keys]::$key)
                    $Inputstr = $Inputstr -replace "{{$key}}", ''
                }
                else {
                    $Inputstr = $Inputstr -replace "{{$key}}", [OpenQA.Selenium.Keys]::$key
                }
                
            }
        }
        $UseSequence = $UseSequence -and $Sequence.Count -gt 0
        
    }
    process {
        $Action = [OpenQA.Selenium.Interactions.Actions]::new($Driver)

        switch ($PSBoundParameters.ContainsKey('Element')) {
            $true {
                if ($ClearFirst) { $Element.Clear() }

                if ($UseSequence) {
                    Foreach ($k in $Sequence) { $Action.KeyDown($Element, $k) }
                    $Action.SendKeys($Element, $Keys)
                    Foreach ($k in $Sequence) { $Action.KeyUp($Element, $k) }
                    $Action.Build().Perform()
                }
                else {
                    $Action.SendKeys($Element, $Keys).Perform()
                }

                if ($Submit) { $Element.Submit() }
            }
            $false {
                if ($UseSequence) {
                    Foreach ($k in $Sequence) { $Action.KeyDown($k) }
                    $Action.SendKeys($Keys)
                    Foreach ($k in $Sequence) { $Action.KeyUp($k) }
                    $Action.Build().Perform()
                }
                else {
                    $Action.SendKeys($Keys).Perform()
                }
            }
        }
      
        if ($Sleep) { Start-Sleep -Milliseconds ($Sleep * 1000) }
        if ($PassThru) { $Element }
    }
}