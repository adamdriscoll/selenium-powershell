function Wait-SeDriver {
    [Cmdletbinding(DefaultParameterSetName = 'Default')]
    param(
        #Specifies whether the selction text is to select by name, ID, Xpath etc
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [SeBySelector]$By = [SeBySelector]::XPath,
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$Value,
        #Specifies a time out
        [Parameter(Position = 2, ParameterSetName = 'Default')]
        [Int]$Timeout = 0,
        #The driver or Element where the search should be performed.
        [Parameter(Position = 3, ValueFromPipeline = $true, ParameterSetName = 'Default')]
        $Driver = $Script:SeDriversCurrent

    )
    process {
        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
        $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::AlertIsPresent()
        $WebDriverWait.Until($Condition)
        $Alert = $Driver.SwitchTo().alert() 


        $ECM = [OpenQA.Selenium.Support.UI.ExpectedConditions] | Get-Member -Static
        $ByElements, $Remaining = $ECM.where( { $_.Definition -like '*OpenQA.Selenium.By*' }, 'split')
            
        [OpenQA.Selenium.Support.UI.ExpectedConditions]::equ
        
        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                if ($Timeout) {
                    $TargetElement = [OpenQA.Selenium.By]::$By($Value)
                    $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
                    $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
                    $WebDriverWait.Until($Condition) 
                }
                else {
                    $Driver.FindElements([OpenQA.Selenium.By]::$By($Value))
                }
                
            }
            'ByElement' {
                Write-Warning "Timeout does not apply when searching an Element" 
                $Element.FindElements([OpenQA.Selenium.By]::$By($Value))
            }
        }
    }
}



