#TODO Positional binding $Element = Get-SeElement Tagname 'Select'
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
        [Double]$Timeout = 0,
        [Parameter(Position = 3, ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'ByElement')]
        [OpenQA.Selenium.IWebElement]
        $Element,
        [Switch]$All,
        [ValidateNotNullOrEmpty()]
        [String[]]$Attributes,
        [Switch]$Single
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
        $ShowAll = $PSBoundParameters.ContainsKey('All') -and $PSBoundParameters.Item('All') -eq $true
        if ($By.Count -ne $Value.Count) {
            Throw [System.InvalidOperationException]::new("An equal number of `$By element ($($By.Count)) and `$Value ($($Value.Count)) must be provided.")
        }
        Filter DisplayedFilter([Switch]$All) {
            if ($All) { $_ } else { if ($_.Displayed) { $_ } } 
        }
        $Output = $null
        $ByCondition = $null

        

        if ($by.Count -gt 1) {
            $ByChainedArgs = for ($i = 0; $i -lt $by.Count; $i++) {
                $cby = $by[$i]
                $CValue = $value[$i]
                if ($cby -eq ([SeBySelector]::ClassName)) {
                    $spl = $CValue.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
                    if ($spl.count -gt 1) {
                        $Cby = [SeBySelector]::CssSelector
                        $CValue = ".$($spl -join '.')"
                    }
                }
                [OpenQA.Selenium.By]::$cby($CValue)
            }
            $ByCondition = [OpenQA.Selenium.Support.PageObjects.ByChained]::new($ByChainedArgs)
        }
        else {
            if ($By[0] -eq ([SeBySelector]::ClassName)) {
                $spl = $Value.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
                if ($spl.Count -gt 1) {
                    $by = [SeBySelector]::CssSelector
                    $Value = ".$($spl -join '.')"
                }
            }
            $ByCondition = [OpenQA.Selenium.By]::$By($Value)
        }
        
        $ImpTimeout = -1 
        if ($By.Count -gt 1 -or $PSBoundParameters.ContainsKey('Timeout')) {
            $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver 
        }
        #Id Should always be considered as Single
        if ($By.Contains('Id') -and !$PSBoundParameters.ContainsKey('Single')) {
            $PSBoundParameters.Add('Single', $true)     
        }
    } 
    process {
      
        
        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                if ($Timeout) {
                    $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, ([timespan]::FromMilliseconds($Timeout * 1000)))
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
        if ($null -eq $Output) {
            $Message = "no such element: Unable to locate element by: $($By -join ',') with value $($Value -join ',')"
            Write-Error -Exception ([System.Management.Automation.ItemNotFoundException]::new($Message))
            return
        }
        elseif ($PSBoundParameters.ContainsKey('Single') -and $Single -eq $true -and $Output.count -gt 1) {
            $Message = "A single element was expected bu $($Output.count) elements were found using the locator  $($By -join ',') with value $($Value -join ',')."
            Write-Error -Exception ([System.InvalidOperationException]::new($Message))
            return
        }
        else {
            return $Output
        }
    }
    End {
        if ($ImpTimeout -ne -1) { Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout }
        
    }
}