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
        
        Filter DisplayedFilter([Switch]$All) {
            if ($All) { $_ } else { if ($_.Displayed) { $_ } } 
        }
        $Output = $null
    }
    process {
      
        
        
        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                if ($Timeout) {
                    $TargetElement = [OpenQA.Selenium.By]::$By($Value)
                    $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
                    $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::PresenceOfAllElementsLocatedBy($TargetElement)
                    $Output = $WebDriverWait.Until($Condition) | DisplayedFilter -All:$ShowAll
                }
                else {
                    $Output = $Driver.FindElements([OpenQA.Selenium.By]::$By($Value)) | DisplayedFilter -All:$ShowAll
                }
            }
            'ByElement' {
                Write-Verbose "Searching an Element - Timeout ignored" 
                $Output = $Element.FindElements([OpenQA.Selenium.By]::$By($Value)) | DisplayedFilter -All:$ShowAll
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


        return $Output
    }
}


