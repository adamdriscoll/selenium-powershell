function Get-SeElement {
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
        [OpenQA.Selenium.IWebDriver]
        $Driver = $Script:SeDriversCurrent,
        [Parameter(Position = 3, ValueFromPipeline = $true,Mandatory=$true, ParameterSetName = 'ByElement')]
        [OpenQA.Selenium.IWebElement]
        $Element,
        [Switch]$All
    )
    Begin {
        $ShowAll = $PSBoundParameters.ContainsKey('All') -and $PSBoundParameters.Item('All') -eq $true
        
        Filter DisplayedFilter([Switch]$All) {
            if ($All) { $_ } else { if ($_.Displayed) { $_ } } 
        }
    }
    process {
      
        
        
        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                if ($Timeout) {
                    $TargetElement = [OpenQA.Selenium.By]::$By($Value)
                    $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
                    $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
                    $Driver.SeSelectedElements = $WebDriverWait.Until($Condition) | DisplayedFilter -All:$ShowAll
                }
                else {
                    $Driver.SeSelectedElements = $Driver.FindElements([OpenQA.Selenium.By]::$By($Value)) | DisplayedFilter -All:$ShowAll
                }
                return $Driver.SeSelectedElements
                
            }
            'ByElement' {
                Write-Warning "Timeout does not apply when searching an Element" 
                $Driver.SeSelectedElements = $Element.FindElements([OpenQA.Selenium.By]::$By($Value)) | DisplayedFilter -All:$ShowAll
                return $Driver.SeSelectedElements 
            }
        }
    }
}


