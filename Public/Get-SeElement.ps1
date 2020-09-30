function Get-SeElement {
    [Cmdletbinding(DefaultParameterSetName = 'Default')]
    param(
        #Specifies whether the selction text is to select by name, ID, Xpath etc
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [SeBySelector[]]$By = [SeBySelector]::XPath,
        [Parameter(Position = 1, Mandatory = $true)]
        [string[]]$Value,
        #Specifies a time out
        [Parameter(Position = 2, ParameterSetName = 'Default')]
        [Int]$Timeout = 0,
        #The driver or Element where the search should be performed.
        [Parameter(Position = 3, ValueFromPipeline = $true, ParameterSetName = 'Default')]
        [OpenQA.Selenium.IWebDriver]
        $Driver,
        [Parameter(Position = 3, ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'ByElement')]
        [OpenQA.Selenium.IWebElement]
        $Element,
        [Switch]$All,
        [ValidateNotNullOrEmpty()]
        [String[]]$Attributes
    )
    Begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        $ShowAll = $PSBoundParameters.ContainsKey('All') -and $PSBoundParameters.Item('All') -eq $true
        if ($By.Count -ne $Value.Count) {
            Write-Error "The number of `$By $($By.Count) element must match the number of `$value $($value.Count) provided"
            return 
        }
        Filter DisplayedFilter([Switch]$All) {
            if ($All) { $_ } else { if ($_.Displayed) { $_ } } 
        }
        $Output = $null
    
        $ResetImplicitTimeout = $null
        $ByCondition = $null
        if ($by.Count -gt 1) {
            $Args = for ($i = 0; $i -lt $by.Count; $i++) {
                $cby = $by[$i]
                [OpenQA.Selenium.By]::$cby($value[$i])
            }

            $ByCondition = [OpenQA.Selenium.Support.PageObjects.ByChained]::new($Args)
        }
        else {
            $ByCondition = [OpenQA.Selenium.By]::$By($Value)
        }
        
        if ($By.Count -gt 1 -or $PSBoundParameters.ContainsKey('Timeout')) {
            $ResetImplicitTimeout = $Driver.Manage().Timeouts().ImplicitWait
            $Driver.Manage().Timeouts().ImplicitWait = 0
        }
    } 
    process {
      
        
        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                if ($Timeout) {
                    $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
                    $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::PresenceOfAllElementsLocatedBy($ByCondition)
                    $Output = $WebDriverWait.Until($Condition) | DisplayedFilter -All:$ShowAll
                }
                else {
                    $Output = $Driver.FindElements($ByCondition) | DisplayedFilter -All:$ShowAll
                }
            }
            'ByElement' {
                Write-Verbose "Searching an Element - Timeout ignored" 
                $Output = $Element.FindElements($ByCondition) | DisplayedFilter -All:$ShowAll
            }
        }
        
 

        if ($PSBoundParameters.ContainsKey('Attributes')) {
            $GetAllAttributes = $Attributes.Count -eq 1 -and $Attributes[0] -eq '*'
            
            if ($GetAllAttributes) {
                Foreach ($Item in $Output) {
                    $AllAttributes = $Driver.ExecuteScript('var items = {}; for (index = 0; index < arguments[0].attributes.length; ++index) { items[arguments[0].attributes[index].name] = arguments[0].attributes[index].value }; return items;', $Item)
                    $AttArray = [System.Collections.Generic.Dictionary[String, String]]::new()

                    Foreach ($AttKey in $AllAttributes.Keys) {
                        $AttArray.Add($AttKey, $AllAttributes[$AttKey])
                    }

                    Add-Member -InputObject $Item -Name 'Attributes' -Value $AttArray -MemberType NoteProperty
                }
            }
            else {
                foreach ($Item in $Output) {
                    $AttArray = [System.Collections.Generic.Dictionary[String, String]]::new()
                 
                    foreach ($att in $Attributes) {
                        $Value = $Item.GetAttribute($att)
                        if ($Value -ne "") {
                            $AttArray.Add($att, $Item.GetAttribute($att))
                        }
                
                    }
                    Add-Member -InputObject $Item -Name 'Attributes' -Value $AttArray -MemberType NoteProperty
                }
            }
              
        }
        
        #Issue #135 - Explicit $null so it get picked up by downstream cmdlets
        if ($null -eq $Output) { return $null } else { return $Output }
        
    }
    End {
        if ($null -ne $ResetImplicitTimeout) {
            $Driver.Manage().Timeouts().ImplicitWait = $ResetImplicitTimeout
        }
        
    }
}


