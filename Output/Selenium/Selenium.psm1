using namespace System.Collections.Generic


if (!$PSCommandPath.EndsWith('init.ps1')) {
    $MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { 
         Get-SeDriver | Stop-SeDriver
    }

}


Function New-Condition {
    Param([Parameter(Mandatory = $true)]$Text, [Type]$ValueType, $Tooltip, [Switch]$OptionalValue, $ElementRequired = $true )
    return [PSCustomObject]@{
        Text            = $Text
        ValueType       = $ValueType
        Tooltip         = $Tooltip
        ElementRequired = $ElementRequired
    }
}

$Script:SeMouseAction = @(
    New-Condition -Text 'DragAndDrop' -ValueType ([OpenQA.Selenium.IWebElement]) -Tooltip 'Performs a drag-and-drop operation from one element to another.'
    New-Condition -Text 'DragAndDropToOffset'  -ValueType ([System.Drawing.Point]) -Tooltip 'Performs a drag-and-drop operation on one element to a specified offset.'
    New-Condition -Text 'MoveByOffset' -ValueType ([System.Drawing.Point]) -ElementRequired $null -Tooltip 'Moves the mouse to the specified offset of the last known mouse coordinates.'
    New-Condition -Text 'MoveToElement'  -ValueType ([System.Drawing.Point]) -OptionalValue -Tooltip 'Moves the mouse to the specified element with offset of the top-left corner of the specified element.'
    New-Condition -Text 'Release' -ValueType $null -Tooltip 'Releases the mouse button at the last known mouse coordinates or specified element.'
)

$Script:SeKeys = [OpenQA.Selenium.Keys] | Get-Member -MemberType Property -Static |
    Select-Object -Property Name, @{N = "ObjectString"; E = { "[OpenQA.Selenium.Keys]::$($_.Name)" } }

[Dictionary[object, Stack[string]]] $Script:SeLocationMap = [Dictionary[object, Stack[string]]]::new()

#region Set path to assemblies on Linux and MacOS and Grant Execution permissions on them

$ScriptRoot = $PSScriptRoot
# This will happens only if we are debugging
if ($ScriptRoot.EndsWith('Internal')){
    $ScriptRoot = Split-Path -Path $ScriptRoot
}

if ($IsLinux) {
    $AssembliesPath = "$ScriptRoot/assemblies/linux"
}
elseif ($IsMacOS) {
    $AssembliesPath = "$ScriptRoot/assemblies/macos"
} else {
    $AssembliesPath = "$ScriptRoot\assemblies"
}

# Grant Execution permission to assemblies on Linux and MacOS
if ($IsLinux -or $IsMacOS) {
    # Check if powershell is NOT running as root
    Get-Item -Path "$AssembliesPath/chromedriver", "$AssembliesPath/geckodriver" | ForEach-Object {
        if ($IsLinux) { $FileMod = stat -c "%a" $_.FullName }
        elseif ($IsMacOS) { $FileMod = /usr/bin/stat -f "%A" $_.FullName }
        Write-Verbose "$($_.FullName) $Filemod"
        if ($FileMod[2] -ne '5' -and $FileMod[2] -ne '7') {
            Write-Host "Granting $($AssemblieFile.fullname) Execution Permissions ..."
            chmod +x $_.fullname
        }
    }
}

$Script:SeDriversAdditionalBrowserSwitches = @{
    Chrome           = @('DisableAutomationExtension', 'EnablePDFViewer')
    Edge             = @()
    Firefox          = @('SuppressLogging')
    InternetExplorer = @('IgnoreProtectedModeSettings')
    MsEdge           = @()
}

# List of suggested command line arguments for each browser
$Script:SeDriversBrowserArguments = @{
    Chrome           = @("--user-agent=Android")
    Edge             = @()
    Firefox          = @()
    InternetExplorer = @()
    MsEdge           = @()
}

$Script:SeDrivers = [System.Collections.Generic.List[PSObject]]::new()
$Script:SeDriversCurrent = $null


$AdditionalOptionsSwitchesCompletion = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    if ($fakeBoundParameters.ContainsKey('Browser')) {
        $Browser = $fakeBoundParameters.Item('Browser')
        
        $Output = $Script:SeDriversAdditionalBrowserSwitches."$Browser"
        $Output | % { [System.Management.Automation.CompletionResult]::new($_) }
        
        
    }
}


$SeDriversBrowserArgumentsCompletion = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    if ($fakeBoundParameters.ContainsKey('Browser')) {
        $Browser = $fakeBoundParameters.Item('Browser')
        $Output = $Script:SeDriversBrowserArguments."$Browser" | Where { $_ -like "*$wordToComplete*" }
        $ptext = [System.Management.Automation.CompletionResultType]::ParameterValue
        $Output | % { [System.Management.Automation.CompletionResult]::new("'$_'", $_, $ptext, $_) }
    }
}

Register-ArgumentCompleter -CommandName Start-SeDriver, New-SeDriverOptions -ParameterName Switches -ScriptBlock $AdditionalOptionsSwitchesCompletion 
Register-ArgumentCompleter -CommandName Start-SeDriver, New-SeDriverOptions -ParameterName Arguments -ScriptBlock $SeDriversBrowserArgumentsCompletion 
function Clear-SeAlert {
    [CmdletBinding()]
    param (
        [ValidateSet('Accept', 'Dismiss')]
        $Action = 'Dismiss',
        [parameter(ParameterSetName = 'Alert', ValueFromPipeline = $true)]
        $Alert,
        [switch]$PassThru
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
        $ImpTimeout = 0
    }
    Process {
        if ($Driver) {
            try { 
                $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver
                $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds 10))
                $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::AlertIsPresent()
                $WebDriverWait.Until($Condition)
                $Alert = $Driver.SwitchTo().alert() 
            }
            catch { 
                Write-Warning 'No alert was displayed'
                return 
            }
            Finally {
                Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
            }
        }
        if ($Alert) { $alert.$action() }
        if ($PassThru) { $Alert }
    }
    End {}
}

function Clear-SeSelectValue {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element 
    )
    [SeleniumSelection.Option]::DeselectAll($Element)        
  
}

function ConvertTo-Selenium {
    [CmdletBinding()]
    param (
        # Path to .side file.
        [Parameter(Mandatory)]
        [String]$Path
    )

    $ByMap = @{
        id       = 'Id'
        css      = 'CssSelector'
        xpath    = 'XPath'
        linkText = 'LinkText'
        label    = 'Text'
        index    = 'Index'
    }
    function Get-Replace {
        <#
        .SYNOPSIS
        Helper function to convert ScriptBlocks to strings.

        Parameter set 1:
        Replace -From [String] with -To [String].
        -QuotesTo adds quotes around -To.
        -SplitTo take only the value part from "label=value" of -To.

        Parameter set 2:
        -By "label=value" replaces input "-By $By" with "-By <Selector> -value '<value>'".
        * $ByMap is used to map the labels.
    #>
        [CmdletBinding()]
        param (
            [String]$From,
            [String]$To,
            [String]$By,
            [Parameter(ValueFromPipeline)]
            $InputObject,
            [switch]$QuotesTo,
            [switch]$SplitTo
        )
        process {
            $String = $InputObject.ToString().Trim()
            if ($From) {
                if ($QuotesTo) {
                    $To = '"' + $To + '"'
                }
                if ($SplitTo) {
                    $To = $To.Split('=', 2)[1]
                }
                $String = $String.Replace($From, $To)
            }
            if ($By) {
                $String = $String.Replace('-By $By', ('-By {0} -value {1}' -f $ByMap[$By.Split('=', 2)[0]], ('"' + $By.Split('=', 2)[1] + '"')))
            }
            $String
        }
    }

    $ActionMap = @{
        click       = { Invoke-SeClick }
        doubleClick = { Invoke-SeClick -Action DoubleClick }
        sendKeys    = { Invoke-SeKeys -Keys $Keys }
        type        = { Invoke-SeKeys -Keys $Keys }
        select      = { Set-SeSelectValue -By $By }
    }

    $Recording = Get-Content -Path $Path | ConvertFrom-Json
    $BaseUrl = [Uri]$Recording.url
    $PsCode = $(
        '# Project: ' + $Recording.name
        foreach ($Test in $Recording.tests) {
            '# Test: ' + $Test.name
            foreach ($Command in $Test.commands) {
                switch ($Command) {
                    { $_.comment } { '# Description: ' + $_.comment }
                    { $_.command -eq 'open' } {
                        $Url = if ([Uri]::IsWellFormedUriString($_.target, [System.UriKind]::Relative)) {
                            [Uri]::new($BaseUrl, $_.target)
                        }
                        else {
                            $_.target
                        }
                        { Set-SeUrl -Url $Url } | Get-Replace -From '$Url' -To $Url -QuotesTo
                        Break
                    }
                    { $_.command -eq 'close' } { { Stop-SeDriver } ; Break }
                    { $_.command -in $ActionMap.Keys } {
                        $Action = $ActionMap[$_.command] | Get-Replace -From '$Keys' -To ($_.value.Replace('${KEY_ENTER}', '{{Enter}}')) -QuotesTo -By $_.value
                        { Get-SeElement -By $By | _Action_ } | Get-Replace -From '_Action_' -To $Action -By $_.target
                        Break
                    }
                    { $_.command -eq 'selectFrame' } {
                        if ($_.target -eq 'relative=parent') {
                            { Switch-SeFrame -Parent }
                        }
                        else {
                            { Switch-SeFrame -Frame $Index } | Get-Replace -From '$Index' -To $_.target -SplitTo
                        }
                        Break
                    }
                    Default { '# Unsupported command. Command: "{0}", Target: "{1}", Value: "{2}", Comment: "{3}".' -f $_.command, $_.target, $_.value, $_.comment }
                }
            }
        }
    ) | Get-Replace
    [ScriptBlock]::Create($PsCode -join [Environment]::NewLine)
}
function Get-SeCookie {
    [CmdletBinding()]
    param()
    $Driver = Init-SeDriver -ErrorAction Stop
    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}

function Get-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(ParameterSetName = 'Current', Mandatory = $false)]
        [Switch]$Current,
        [parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $false)]
        [String]$Name,
        [parameter(ParameterSetName = 'ByBrowser', Mandatory = $false)]
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        $Browser
          
          
      
    )

    $Output = $null
    switch ($PSCmdlet.ParameterSetName) {
        'All' { $Output = $Script:SeDrivers; break }
        'Current' { $Output = $Script:SeDriversCurrent; break }
        'ByName' { $Output = $Script:SeDrivers.Where( { $_.SeFriendlyName -eq $Name }, 'first' ); break }
        'ByBrowser' { $Output = $Script:SeDrivers.Where( { $_.SeBrowser -like "$Browser*" }); break }
    }

    if ($null -eq $Output) { return }
    
    $DriversToClose = [System.Collections.Generic.List[PSObject]]::new()
    Foreach ($drv in $Output) {
        $Processes = (Get-Process -Id $Drv.SeProcessId, $Drv.SeServiceProcessId -ErrorAction SilentlyContinue )
        if ($Processes.count -eq 2) { Continue }

        if ($Processes.count -eq 0) {
            Write-Warning -Message "The driver $($Drv.SeFriendlyName) $($Drv.SeBrowser) processes are not running anymore and have been removed automatically from the list of available drivers."
        }
        else { 
            $ProcessType = if ($Processes.id -eq $Drv.SeServiceProcessId) { "driver service" } else { "browser" }
            Write-Warning -Message "The driver $($Drv.SeFriendlyName) $($Drv.SeBrowser) $ProcessType is not running anymore and will be removed from the active driver list."
        }
        $DriversToClose.Add($Drv)
    }

    if ($DriversToClose.Count -gt 0) { 
        foreach ($drv in $DriversToClose) {
            $Output = $Output.Where( { $_.SeServiceProcessId -ne $drv.SeServiceProcessId })
            Stop-SeDriver -Driver $drv
        }
    }
    return $Output
}
function Get-SeDriverTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait'
    )
    begin {
        $Driver = Init-SeDriver -ErrorAction Stop
    }
    Process {
        return $Driver.Manage().Timeouts().$TimeoutType 
    }
    End {}
}

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
        [scriptblock]$Filter,
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
        
 
        $GetAllAttributes = $PSBoundParameters.ContainsKey('Attributes') -and $Attributes.Count -eq 1 -and $Attributes[0] -eq '*'
        $MyAttributes =  [System.Collections.Generic.List[String]]::new()
        if ( $null -ne $Attributes) { $MyAttributes = [System.Collections.Generic.List[String]]$Attributes }
        
        if (!$GetAllAttributes -and $Filter) {
                $AdditionalAttributes = [regex]::Matches($Filter, '\$_\.Attributes.(\w+)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | % { $_.Groups[1].value }
                $AdditionalAttributes | ForEach-Object {if (!$MyAttributes.Contains($_)) { $MyAttributes.Add($_) }}
        }

        if ($MyAttributes.Count -gt 0) {
           Foreach ($Item in $Output) {
                $htAttributes = Get-SeElementAttribute -Element $Item -Name $MyAttributes
                if ($htAttributes -is [String]) {$htAttributes = @{$MyAttributes[0] = $htAttributes }}
                Add-Member -InputObject $Item -Name 'Attributes' -Value $htAttributes -MemberType NoteProperty
           }
        }

        # Apply filter here
        $AndFilterstr = ""
        if ($Filter) { 
            $AndFilterstr = " and the applied filter"
            $Output = $Output | Where-Object $Filter 
        }
        

        if ($null -eq $Output) {
            $Message = "no such element: Unable to locate element by: $($By -join ',') with value $($Value -join ',')$AndFilterstr"
            Write-Error -Exception ([System.Management.Automation.ItemNotFoundException]::new($Message))
            return
        }
        elseif ($PSBoundParameters.ContainsKey('Single') -and $Single -eq $true -and $Output.count -gt 1) {
            $Message = "A single element was expected but $($Output.count) elements were found using the locator  $($By -join ',') with value $($Value -join ',')$AndFilterstr."
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
function Get-SeElementAttribute {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string[]]$Name
    )
    Begin {
        $Script = 'var items = {}; for (index = 0; index < arguments[0].attributes.length; ++index) { items[arguments[0].attributes[index].name] = arguments[0].attributes[index].value }; return items;'
    }
    process {
        $AllAttributes = $Name.Count -eq 1 -and $Name[0] -eq '*'
        $ManyAttributes = $Name.Count -gt 1

        if ($AllAttributes) {
            $AllAttributes = $Element.WrappedDriver.ExecuteScript($Script, $Element)
            $Output = @{}
            
            Foreach ($Att in $AllAttributes.Keys) {
                $value = $Element.GetAttribute($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
            $Output
        }
        elseif ($ManyAttributes) {
            $Output = @{}
            Foreach ($Att in $Name) {
                $value = $Element.GetAttribute($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
           $Output
        }
        else {
            $Element.GetAttribute($Name)
        }

        
    }
}
function Get-SeElementCssValue {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string[]]$Name
    )
    Begin {
        $ScriptAllValues = @'
 var items = {};
var o = getComputedStyle(arguments[0]);
for(var i = 0; i < o.length; i++){
    items[o[i]] =  o.getPropertyValue(o[i])
}
return items;
'@
    }
    Process {
        $AllValues = $Name.Count -eq 1 -and $Name[0] -eq '*'
        $ManyValues = $Name.Count -gt 1


        if ($AllValues) {

            $AllCSSNames = $Element.WrappedDriver.ExecuteScript($ScriptAllValues, $Element)
            $Output = @{}
            
            Foreach ($Att in $AllCSSNames.Keys) {
                $value = $Element.GetCssValue($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
            [PSCustomObject]$Output 
        }
        elseif ($ManyValues) {
            $Output = @{}
            Foreach ($Item in $Name) {
                $Value = $Element.GetCssValue($Item)
                if ($Value -ne "") {
                    $Output.$Item = $Value
                }
            }
            [PSCustomObject]$Output
        }
        else {
            $Element.GetCssValue($Name)
        }


    }
}
function Get-SeFrame {
    [cmdletbinding()]
    param()

    $Driver = Init-SeDriver -ErrorAction Stop
    
    Get-SeElement -By TagName -Value iframe -Attributes name, id -ErrorAction SilentlyContinue | 
        ForEach-Object {
            $_.Psobject.TypeNames.Insert(0, 'selenium-powershell/SeFrame')
            $_
        } 

}

function Get-SeHtml {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [switch]$Inner        
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
    }
    Process {
        if ($PSBoundParameters.ContainsKey('Element')) {
            if ($Inner) { return $Element.GetAttribute('innerHTML') }
            return $Element.GetAttribute('outerHTML')
        }
        else {
            $Driver.PageSource
        }
        
    }
}

function Get-SeInput {
    [CmdletBinding()]
    param(
        [ArgumentCompleter( { @('button', 'checkbox', 'color', 'date', 'datetime-local', 'email', 'file', 'hidden', 'image', 'month', 'number', 'password', 'radio', 'range', 'reset', 'search', 'submit', 'tel', 'text', 'time', 'url', 'week') })]
        [String]$Type,
        [Switch]$Single,
        [String]$Text,
        [Double]$Timeout,
        [Switch]$All,
        [String[]]$Attributes,
        [String]$Value

    
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
    }
    Process {
        $MyAttributes = @{Attributes = [System.Collections.Generic.List[String]]::new()}
        $SelectedAttribute = ""
        $LoadAllAttributes = $false

        if ($PSBoundParameters.Remove('Attributes')) {
            $MyAttributes = @{Attributes = [System.Collections.Generic.List[String]]$Attributes }
            $LoadAllAttributes = $Attributes.Count -eq 1 -and  $Attributes[0] -eq '*'
            if ($Attributes[0] -ne '*') { $SelectedAttribute = $MyAttributes.Attributes[0] }
        }

        if (!$LoadAllAttributes){
            if ($PSBoundParameters.Remove('Type')) {
                if (-not $MyAttributes.Attributes.Contains('type')) { $MyAttributes.Attributes.add('type') }
            }
            if (-not $MyAttributes.Attributes.Contains('placeholder')) { $MyAttributes.Attributes.add('placeholder') }
            if (-not $MyAttributes.Attributes.Contains('value')) { $MyAttributes.Attributes.add('value') }
        }


        [void]($PSBoundParameters.Remove('Value'))

        $Filter = [scriptblock]::Create(@"
            if ("" -ne "$Type") { if (`$_.Attributes.type -ne "$type") { return } }
            if ("" -ne "$Text") { if (`$_.Text -ne "$Text" ) { return } }
            if ("" -ne "$Value" -and "" -ne "$SelectedAttribute") { if (`$_.Attributes."$SelectedAttribute" -ne "$Value" ) { return } }
            `$_
"@)

        Get-SeElement -By TagName -Value input @PSBoundParameters @MyAttributes -Filter $Filter | ForEach-Object {
            $_.Psobject.TypeNames.Insert(0, 'selenium-powershell/SeInput')
            $_
        } 

    }
}

function Get-SeKeys {
    [OpenQA.Selenium.Keys] | 
        Get-Member -MemberType Property -Static | 
            Select-Object -Property Name, @{N = "ObjectString"; E = { "[OpenQA.Selenium.Keys]::$($_.Name)" } }
}
function Get-SeSelectValue {
    [CmdletBinding()]
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param (
        [Parameter( ValueFromPipeline = $true, Mandatory = $true, Position = 1)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Switch]$All
    )
    try {
        $IsMultiSelectResult = [SeleniumSelection.Option]::IsMultiSelect($Element)
        
        
        $SelectStatement = if ($IsMultiSelectResult) { 'GetAllSelectedOptions' } else { 'GetSelectedOption' }
        $Selected = [SeleniumSelection.Option]::$SelectStatement($Element) 
        $Items = @(foreach ($item in $Selected) {
                [PSCustomObject]@{
                    Text  = $Item.text
                    Value = Get-SeElementAttribute -Element $Item -Name value
                }
            })

        if (-not $All) {
            return $Items
        }
        else {
               
            $Index = 0
            $Options = Get-SeElement -Element $Element -By Tagname -Value option -Attributes value
            $Values = foreach ($Opt in $Options) {
                [PSCustomObject]@{
                    Index    = $Index
                    Text     = $Opt.text
                    Value    = $opt.Attributes.value
                    Selected = $Null -ne $Items.Value -and $Items.Value.Contains($opt.Attributes.value)
                }
                $Index += 1
            }
            return  [PSCustomObject]@{
                PSTypeName    = 'selenium-powershell/SeSelectValueInfo'
                IsMultiSelect = [SeleniumSelection.Option]::IsMultiSelect($Element)
                Items         = $Values
            }
        }



    }
    catch {
        throw "An error occured checking the selection box, the message was:`r`n $($_.exception.message)"
    }
}
function Get-SeUrl {
    <#
    .SYNOPSIS
    Retrieves the current URL of a target webdriver instance.

    .DESCRIPTION
    Retrieves the current URL of a target webdriver instance, or the currently
    stored internal location stack.

    .EXAMPLE
    Get-SeUrl

    Retrieves the current URL of the default webdriver instance.

    .NOTES
    When using -Stack, the retrieved stack will not contain any of the driver's
    history (Back/Forward) data. It only handles locations added with
    Push-SeUrl.

    To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.
    #>
    [CmdletBinding()]
    param(
        # Optionally retrieve the stored URL stack for the target or default
        # webdriver instance.
        [Parameter()]
        [switch]
        $Stack
    )
    $Driver = Init-SeDriver -ErrorAction Stop
    
    if ($Stack) {
        if ($Script:SeLocationMap[$Driver].Count -gt 0) {
            $Script:SeLocationMap[$Driver].ToArray()
        }
    }
    else {
        $Driver.Url
    }
}
function Get-SeWindow {
    [CmdletBinding()]
    param()
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        $Driver.WindowHandles
    }
}
function Invoke-SeClick {
    [CmdletBinding()]
    param(
        [parameter(Position = 0, HelpMessage = 'test')]
        [ArgumentCompleter([SeMouseClickActionCompleter])]
        [ValidateScript( { $_ -in $Script:SeMouseClickAction.Text })]
        $Action = 'Click',
        [Parameter( ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element,
        [Double]$Sleep = 0 ,
        [switch]$PassThru
    )

    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
        $HasElement = $PSBoundParameters.ContainsKey('Element') -or $PSCmdlet.MyInvocation.ExpectingInput
        if ($Action -eq 'Click_JS' -and -not $HasElement) {
            Write-Error 'Click_JS can only be performed if an $Element is specified'
            return $null
        }
    }
    Process {
        Write-Verbose "Performing $Action"
        switch ($Action) {
            'Click_Js' {
                try { $Driver.ExecuteScript("arguments[0].click()", $Element) }
                catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            Default {
                $Interaction = [OpenQA.Selenium.Interactions.Actions]::new($Driver)
                if ($PSBoundParameters.ContainsKey('Element')) {
                    Write-Verbose "On Element: $($Element.Tagname)"
                    if ($Action -eq 'Click') {  
                        $Element.Click() #Mitigating IE driver issue with statement below.
                    }
                    else {
                        try { $Interaction.$Action($Element).Perform() }
                        catch { $PSCmdlet.ThrowTerminatingError($_) }
                    }
                }
                else {
                    Write-Verbose "On Driver currently located at: $($Driver.Url)"
                    try { $Interaction.$Action().Perform() }
                    catch { $PSCmdlet.ThrowTerminatingError($_) }
                }
            }
        }

        if ($Sleep -gt 0) { Start-Sleep -Milliseconds ($Sleep * 1000) }
        if ($PassThru) { if ($HasElement) { return $Element } else { return $Driver } }
        
    }
}
function Invoke-SeJavascript {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [String]$Script,
        [Parameter(Position = 1)]
        [Object[]]$ArgumentList        
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    Process {
        #Fix #165 
        $MYargumentList = Foreach ($item in $ArgumentList) {
            $Item -as $Item.GetType()
        }
        $Driver.ExecuteScript($Script, $MyArgumentList)
    }
    End {}
}

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
        [switch]$PassThru
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
        
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
                    $Keys = $Keys -replace "{{$key}}", ''
                }
                else {
                    $Keys = $Keys -replace "{{$key}}", [OpenQA.Selenium.Keys]::$key
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
function Invoke-SeMouseAction {
    [CmdletBinding()]
    param (
        [ArgumentCompleter([SeMouseActionCompleter])]
        [ValidateScript( { $_ -in $Script:SeMouseAction.Text })]
        $Action,
        $Value,
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    Test-SeMouseActionValueValidation -Action $Action -ConditionValue $Value -ErrorAction Stop


    $Value2 = $null
    if ($Action -in @('DragAndDropToOffset', 'MoveByOffset', 'MoveToElement') -and $Value -is [String]) {
        $Value2 = $Value -split '[,x]'
    }


    $Interaction = [OpenQA.Selenium.Interactions.Actions]::new($Driver)

    $HasElement = $PSBoundParameters.ContainsKey('Element')
    $HasValue = $PSBoundParameters.ContainsKey('Value')

    if ($HasElement) {
        if ($HasValue) {
            if ($null -ne $value2) {
                try { $Interaction.$Action($Element, $Value2[0], $value2[1]).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            else {
                try { $Interaction.$Action($Element, $Value).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
        }
        else {
            try { $Interaction.$Action($Element).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
        }
    }
    else {
        if ($HasValue) {
            if ($null -ne $value2) {
                try { $Interaction.$Action($Value2[0], $Value2[1]).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            else {
                try { $Interaction.$Action($Value).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }    
            }

            
        }
        else {
            try { $Interaction.$Action().Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
        }
    }
    


    

}
function New-SeDriverOptions {
    [cmdletbinding()]
    [OutputType(
        [OpenQA.Selenium.Chrome.ChromeOptions],
        [OpenQA.Selenium.Edge.EdgeOptions],
        [OpenQA.Selenium.Firefox.FirefoxOptions],
        [OpenQA.Selenium.IE.InternetExplorerOptions]
    )]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        $Browser,
        [StringUrlTransformAttribute()]
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ArgumentCompleter( { [Enum]::GetNames([SeWindowState]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeWindowState]) })]
        $State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait = 0.3,
        [System.Drawing.Size][SizeTransformAttribute()]$Size,
        [System.Drawing.Point][PointTransformAttribute()]$Position,
        $WebDriverPath,
        $BinaryPath,
        [String[]]$Switches,
        [String[]]$Arguments,
        $ProfilePath,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [SeDriverUserAgentTransformAttribute()]
        [ValidateNotNull()]
        [ArgumentCompleter( [SeDriverUserAgentCompleter])]
        [String]$UserAgent,
        [Switch]$AcceptInsecureCertificates
    )
    if ($PSBoundParameters.ContainsKey('UserAgent')) { Test-SeDriverUserAgent -Browser $Browser -ErrorAction Stop }
    if ($PSBoundParameters.ContainsKey('AcceptInsecureCertificates')) { Test-SeDriverAcceptInsecureCertificates -Browser $Browser -ErrorAction Stop }
    
    #  [Enum]::GetNames([sebrowsers])
    $output = $null
    switch ($Browser) {
        Chrome { $Output = [OpenQA.Selenium.Chrome.ChromeOptions]::new() }
        Edge { $Output = New-Object -TypeName OpenQA.Selenium.Chrome.ChromeOptions -Property @{ browserName = '' } }
        Firefox { $Output = [OpenQA.Selenium.Firefox.FirefoxOptions]::new() }
        InternetExplorer { 
            $Output = [OpenQA.Selenium.IE.InternetExplorerOptions]::new() 
            $Output.IgnoreZoomLevel = $true
        }
        MSEdge { $Output = [OpenQA.Selenium.Edge.EdgeOptions]::new() }
    }

    #Add members to be treated by Internal Start cmdlet since Start-SeDriver won't allow their use with Options parameter set.
    Add-Member -InputObject $output -MemberType NoteProperty -Name 'SeParams' -Value $PSBoundParameters
    

    return $output
}
function New-SeDriverService {
    [cmdletbinding()]
    [OutputType(
        [OpenQA.Selenium.Chrome.ChromeDriverService],
        [OpenQA.Selenium.Firefox.FirefoxDriverService],
        [OpenQA.Selenium.IE.InternetExplorerDriverService],
        [OpenQA.Selenium.Edge.EdgeDriverService]
    )]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        $Browser,
        $WebDriverPath
    )

    #$AssembliesPath defined in init.ps1
    $service = $null
    $ServicePath = $null
    
    if ($WebDriverPath) { $ServicePath = $WebDriverPath } elseif ($AssembliesPath) { $ServicePath = $AssembliesPath }
    
    switch ($Browser) {
        
        Chrome { 
            if ($ServicePath) { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($ServicePath) }
            else { $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService() }
        }
        Edge { 
            $service = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($ServicePath, 'msedgedriver.exe')
        }
        Firefox { 
            if ($ServicePath) { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($ServicePath) }
            else { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService() }
            $service.Host = '::1'
        }
        InternetExplorer { 
            if ($WebDriverPath) { $Service = [OpenQA.Selenium.IE.InternetExplorerDriverService]::CreateDefaultService($WebDriverPath) }
            else { $Service = [OpenQA.Selenium.IE.InternetExplorerDriverService]::CreateDefaultService() }
            
        }
        MSEdge { 
            $service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService()
        }
    }

    #Set to $true by default; removing it will cause problems in jobs and create a second source of Verbose in the console.
    $Service.HideCommandPromptWindow = $true 

    return $service
}

function New-SeScreenshot {
    
    [cmdletbinding(DefaultParameterSetName = 'Driver')]
    param(
        [Parameter(DontShow, ValueFromPipeline = $true, ParameterSetName = 'Pipeline')]
        [ValidateScript( {
                $Types = @([OpenQA.Selenium.IWebDriver], [OpenQA.Selenium.IWebElement])
                $Found = $false
                Foreach ($t in $Types) { if ($_ -is $t) { $Found = $true; break } }
                if ($found) { return $true } else { Throw "Input must be of one of the following types $($Types -join ',')" }
            })]
        $InputObject,
        [Switch]$AsBase64EncodedString,
        [Parameter(ParameterSetName = 'Element')]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element
    )
    Begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            'Pipeline' {
                switch ($InputObject) {
                    { $_ -is [OpenQA.Selenium.IWebElement] } { $Screenshot = $InputObject.GetScreenshot() }
                    { $_ -is [OpenQA.Selenium.IWebDriver] } { $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($InputObject) }
                }                
            }
            'Element' { $Screenshot = $Element.GetScreenshot() }
            'Driver' { $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver) }
        }

        if ($AsBase64EncodedString) { 
            return $Screenshot.AsBase64EncodedString 
        }
        else {
            return $Screenshot
        }
    }
    End {}
    
    
}
function New-SeWindow {
    [CmdletBinding()]
    param(
        [ValidateURIAttribute()]
        [StringUrlTransformAttribute()]
        $Url
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        $Windows = Get-SeWindow
        $Driver.ExecuteScript('window.open()')
        $WindowsNewSet = Get-SeWindow
        $NewWindowHandle = (Compare-Object -ReferenceObject $Windows -DifferenceObject $WindowsNewSet).Inputobject
        Switch-SeWindow -Window $NewWindowHandle
        if ($PSBoundParameters.ContainsKey('Url')) { Set-SeUrl -Url $Url }
    }
}
function Pop-SeUrl {
    <#
    .SYNOPSIS
    Navigate back to the most recently pushed URL in the location stack.

    .DESCRIPTION
    Retrieves the most recently pushed URL from the location stack and navigates
    to that URL with the specified or default driver.

    .EXAMPLE
    Pop-SeUrl

    Retrieves the most recently pushed URL and navigates back to that URL.

    .NOTES
    A separate internal location stack is maintained for each driver instance
    by the module. This stack is completely separate from the driver's internal
    Back/Forward history logic.

    To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.
    #>
    [CmdletBinding()]
    param()
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        if ($Script:SeLocationMap[$Driver].Count -gt 0) {
            Set-SeUrl -Url $Script:SeLocationMap[$Driver].Pop() -Driver $Driver
        }
    }
}
function Push-SeUrl {
    <#
    .SYNOPSIS
    Stores the current URL in the driver's location stack and optionally
    navigate to a new URL.

    .DESCRIPTION
    The current driver URL is added to the stack, and if a URL is provided, the
    driver navigates to the new URL.

    .EXAMPLE
    Push-SeUrl

    The current driver URL is added to the location stack.

    .EXAMPLE
    Push-SeUrl 'https://google.com/'

    The current driver URL is added to the location stack, and the driver then
    navigates to the provided target URL.

    .NOTES
    A separate internal location stack is maintained for each driver instance
    by the module. This stack is completely separate from the driver's internal
    Back/Forward history logic.

    To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.
    #>
    [CmdletBinding()]
    param(
        # The new URL to navigate to after storing the current location.
        [Parameter(Position = 0, ParameterSetName = 'url')]
        [ValidateURIAttribute()]
        [string]
        $Url
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    if (-not $Script:SeLocationMap.ContainsKey($Driver)) {
        $script:SeLocationMap[$Driver] = [System.Collections.Generic.Stack[string]]@()
    }

    # Push the current location to the stack
    $script:SeLocationMap[$Driver].Push($Driver.Url)

    if ($Url) {
        # Change the driver current URL to provided URL
        Set-SeUrl -Url $Url -Driver $Driver
    }
}
function Remove-SeCookie {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $true, ParameterSetName = 'NamedCookie')] 
        [string]$Name
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    if ($All) {
        $Driver.Manage().Cookies.DeleteAllCookies()
    }
    else {
        $Driver.Manage().Cookies.DeleteCookieNamed($Name)
    }
}
function Remove-SeWindow {
    [CmdletBinding()]
    param(
        [String]$SwitchToWindow
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        try {
            $Windows = @(Get-SeWindow)
            if ($Windows.Count -eq 1) { Write-Warning -Message 'The driver has only one window left. Operation aborted. Use Stop-Driver instead.' }    

            $Driver.Close()
            if ($PSBoundParameters.ContainsKey('SwitchTo')) {
                Switch-SeWindow -Window $SwitchToWindow
            }
            else {
                $Windows = @(Get-SeWindow)
                if ($Windows.count -gt 0) {
                    Switch-SeWindow -Window $Windows[0]
                }
            }
        }
        catch {
            Write-Error $_
        }
        
        
    }
}
function Save-SeScreenshot {
    [CmdletBinding(DefaultParameterSetName = 'Driver')]
    param(
        [Parameter(DontShow, ValueFromPipeline = $true, ParameterSetName = 'Pipeline')]
        [ValidateScript( {
                $Types = @([OpenQA.Selenium.IWebDriver], [OpenQA.Selenium.IWebElement], [OpenQA.Selenium.Screenshot])
                $Found = $false
                Foreach ($t in $Types) { if ($_ -is $t) { $Found = $true; break } }
                if ($found) { return $true } else { Throw "Input must be of one of the following types $($Types -join ',')" }
            })]
        $InputObject,
        [Parameter( Mandatory = $true, ParameterSetName = 'Screenshot')]
        [OpenQA.Selenium.Screenshot]$Screenshot,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png,
        [Parameter(Mandatory = $true, ParameterSetName = 'Element')]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'Driver') {
            $Driver = Init-SeDriver  -ErrorAction Stop
        }
    }
    process {

        switch ($PSCmdlet.ParameterSetName) {
            'Pipeline' {
                switch ($InputObject) {
                    { $_ -is [OpenQA.Selenium.IWebElement] } { $Screenshot = $InputObject.GetScreenshot() }
                    { $_ -is [OpenQA.Selenium.IWebDriver] } { $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($InputObject) }
                    { $_ -is [OpenQA.Selenium.Screenshot] } { $Screenshot = $InputObject }
                }    
            }
            'Driver' { $Screenshot = New-SeScreenshot }
            'Element' { $Screenshot = New-SeScreenshot -Element $Element }
        }
        
        $Screenshot.SaveAsFile($Path, $ImageFormat)
    }
}
function SeShouldHave {
    [cmdletbinding(DefaultParameterSetName = 'DefaultPS')]
    param(
        [Parameter(ParameterSetName = 'DefaultPS', Mandatory = $true , Position = 0, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'Element' , Mandatory = $true , Position = 0, ValueFromPipeline = $true)]
        [string[]]$Selection,

        [Parameter(ParameterSetName = 'DefaultPS', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Element' , Mandatory = $false)]
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [string]$By = [SeBySelector]::XPath,

        [Parameter(ParameterSetName = 'Element' , Mandatory = $true , Position = 1)]
        [string]$With,

        [Parameter(ParameterSetName = 'Alert' , Mandatory = $true)]
        [switch]$Alert,
        [Parameter(ParameterSetName = 'NoAlert' , Mandatory = $true)]
        [switch]$NoAlert,
        [Parameter(ParameterSetName = 'Title' , Mandatory = $true)]
        [switch]$Title,
        [Parameter(ParameterSetName = 'URL' , Mandatory = $true)]
        [switch]$URL,
        [Parameter(ParameterSetName = 'Element' , Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'Alert' , Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'Title' , Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'URL' , Mandatory = $false, Position = 3)]
        [ValidateSet('like', 'notlike', 'match', 'notmatch', 'contains', 'eq', 'ne', 'gt', 'lt')]
        [OperatorTransformAttribute()]
        [String]$Operator = 'like',

        [Parameter(ParameterSetName = 'Element' , Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'Alert' , Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'Title' , Mandatory = $true , Position = 4)]
        [Parameter(ParameterSetName = 'URL' , Mandatory = $true , Position = 4)]
        [Alias('contains', 'like', 'notlike', 'match', 'notmatch', 'eq', 'ne', 'gt', 'lt')]
        [AllowEmptyString()]
        $Value,

        [Parameter(ParameterSetName = 'DefaultPS')]
        [Parameter(ParameterSetName = 'Element')]
        [Parameter(ParameterSetName = 'Alert')]
        [switch]$PassThru,

        [Double]$Timeout = 0
    )
    begin {
        $endTime = [datetime]::now.AddMilliseconds($Timeout * 1000)
        $lineText = $MyInvocation.Line.TrimEnd("$([System.Environment]::NewLine)")
        $lineNo = $MyInvocation.ScriptLineNumber
        $file = $MyInvocation.ScriptName
        Function expandErr {
            param ($message)
            [Management.Automation.ErrorRecord]::new(
                [System.Exception]::new($message),
                'PesterAssertionFailed',
                [Management.Automation.ErrorCategory]::InvalidResult,
                @{
                    Message  = $message
                    File     = $file
                    Line     = $lineNo
                    Linetext = $lineText
                }
            )
        }
        function applyTest {
            param(
                $Testitems,
                $Operator,
                $Value
            )
            Switch ($Operator) {
                'Contains' { return ($testitems -contains $Value) }
                'eq' { return ($TestItems -eq $Value) }
                'ne' { return ($TestItems -ne $Value) }
                'like' { return ($TestItems -like $Value) }
                'notlike' { return ($TestItems -notlike $Value) }
                'match' { return ($TestItems -match $Value) }
                'notmatch' { return ($TestItems -notmatch $Value) }
                'gt' { return ($TestItems -gt $Value) }
                'le' { return ($TestItems -lt $Value) }
            }
        }

        #if operator was not passed, allow it to be taken from an alias for the -value
        if (-not $PSBoundParameters.ContainsKey('operator') -and $lineText -match ' -(eq|ne|contains|match|notmatch|like|notlike|gt|lt) ') {
            $Operator = $matches[1]
        }
        $Success = $false
        $foundElements = [System.Collections.Generic.List[PSObject]]::new()
    }
    process {
        $Driver = (Get-SeDriver -Current)
        #If we have been asked to check URL or title get them from the driver. Otherwise call Get-SEElement.
        if ($URL) {
            do {
                $Success = applyTest -testitems $Driver.Url -operator $Operator -value $Value
                Start-Sleep -Milliseconds 500
            }
            until ($Success -or [datetime]::now -gt $endTime)
            if (-not $Success) {
                throw (expandErr "PageURL was $($Driver.Url). The comparison '-$operator $value' failed.")
            }
        }
        elseif ($Title) {
            do {
                $Success = applyTest -testitems $Driver.Title -operator $Operator -value $Value
                Start-Sleep -Milliseconds 500
            }
            until ($Success -or [datetime]::now -gt $endTime)
            if (-not $Success) {
                throw (expandErr "Page title was $($Driver.Title). The comparison '-$operator $value' failed.")
            }
        }
        elseif ($Alert -or $NoAlert) {
            do {
                try {
                    $a = $Driver.SwitchTo().alert()
                    $Success = $true
                }
                catch {
                    Start-Sleep -Milliseconds 500
                }
                finally {
                    if ($NoAlert -and $a) { throw (expandErr "Expected no alert but an alert of '$($a.Text)' was displayed") }
                }
            }
            until ($Success -or [datetime]::now -gt $endTime)

            if ($Alert -and -not $Success) {
                throw (expandErr "Expected an alert but but none was displayed")
            }
            elseif ($value -and -not (applyTest -testitems $a.text -operator $Operator -value $value)) {
                throw (expandErr "Alert text was $($a.text). The comparison '-$operator $value' failed.")
            }
            elseif ($PassThru) { return $a }
        }
        else {
            foreach ($s in $Selection) {
                $GSEParams = @{By = $By; Value = $s }
                if ($Timeout) { $GSEParams['Timeout'] = $Timeout }
                try { $e = Get-SeElement @GSEParams -All }
                catch { throw (expandErr $_.Exception.Message) }

                #throw if we didn't get the element; if were only asked to check it was there, return gracefully
                if (-not $e) { throw (expandErr "Didn't find '$s' by $by") }
                else {
                    Write-Verbose "Matched element(s) for $s"
                    $foundElements.add($e)
                }
            }
        }
    }
    end {
        if ($PSCmdlet.ParameterSetName -eq "DefaultPS" -and $PassThru) { return $e }
        elseif ($PSCmdlet.ParameterSetName -eq "DefaultPS") { return }
        else {
            foreach ($e in $foundElements) {
                switch ($with) {
                    'Text' { $testItem = $e.Text }
                    'Displayed' { $testItem = $e.Displayed }
                    'Enabled' { $testItem = $e.Enabled }
                    'TagName' { $testItem = $e.TagName }
                    'X' { $testItem = $e.Location.X }
                    'Y' { $testItem = $e.Location.Y }
                    'Width' { $testItem = $e.Size.Width }
                    'Height' { $testItem = $e.Size.Height }
                    'Choice' { $testItem = (Get-SeSelectValue -Element $e -All).Items.Text }
                    default { $testItem = $e.GetAttribute($with) }
                }
                if (-not $testItem -and ($Value -ne '' -and $foundElements.count -eq 1)) {
                    throw (expandErr "Didn't find '$with' on element")
                }
                if (applyTest -testitems $testItem -operator $Operator -value $Value) {
                    $Success = $true
                    if ($PassThru) { $e }
                }
            }
            if (-not $Success) {
                if ($foundElements.count -gt 1) {
                    throw (expandErr "$Selection match $($foundElements.Count) elements, none has a value for $with which passed the comparison '-$operator $value'.")
                }
                else {
                    throw (expandErr "$with had a value of $testitem which did not pass the the comparison '-$operator $value'.")
                }
            }
        }
    }
}
function Set-SeCookie {
    [cmdletbinding()]
    param(
        [string]$Name,
        [string]$Value,
        [string]$Path,
        [string]$Domain,
        [DateTime]$ExpiryDate
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }

    process {
        if ($Name -and $Value -and (!$Path -and !$Domain -and !$ExpiryDate)) {
            $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value)
        }
        Elseif ($Name -and $Value -and $Path -and (!$Domain -and !$ExpiryDate)) {
            $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value, $Path)
        }
        Elseif ($Name -and $Value -and $Path -and $ExpiryDate -and !$Domain) {
            $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value, $Path, $ExpiryDate)
        }
        Elseif ($Name -and $Value -and $Path -and $Domain -and (!$ExpiryDate -or $ExpiryDate)) {
            if ($Driver.Url -match $Domain) {
                $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value, $Domain, $Path, $ExpiryDate)
            }
            else {
                Throw 'In order to set the cookie the browser needs to be on the cookie domain URL'
            }
        }
        else {
            Throw "Incorrect Cookie Layout:
            Cookie(String, String)
            Initializes a new instance of the Cookie class with a specific name and value.
            Cookie(String, String, String)
            Initializes a new instance of the Cookie class with a specific name, value, and path.
            Cookie(String, String, String, Nullable<DateTime>)
            Initializes a new instance of the Cookie class with a specific name, value, path and expiration date.
            Cookie(String, String, String, String, Nullable<DateTime>)
            Initializes a new instance of the Cookie class with a specific name, value, domain, path and expiration date."
        }

        $Driver.Manage().Cookies.AddCookie($cookie)
    }
}
function Set-SeDriverTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait',
        [Parameter(Position = 1)]
        [Double]$Timeout = 0
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    Process {
        $Driver.Manage().Timeouts().$TimeoutType = [timespan]::FromMilliseconds($Timeout * 1000)
    }
    End {}
}

function Set-SeSelectValue {
    [CmdletBinding()]
    param (
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelect]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelect]) })]
        [SeBySelect]$By = [SeBySelect]::Text,
        [Parameter( ValueFromPipeline = $true, Position = 1, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Object]$value
        
    )
    try {
        $IsMultiSelect = [SeleniumSelection.Option]::IsMultiSelect($Element)

        if (-not $IsMultiSelect -and $Value.Count -gt 1) {
            Write-Error 'This select control do not accept multiple values'
            return $null
        }
  
        #byindex can be 0, but ByText and ByValue can't be empty strings
        switch ($By) {
            { $_ -eq [SeBySelect]::Text } {
                $HaveWildcards = $null -ne (Get-WildcardsIndices -Value $value)

                if ($HaveWildcards) {
                    $ValuesToSelect = Get-SeSelectValue -Element $Element  -All
                    $ValuesToSelect = $ValuesToSelect.Items | Where-Object { $_.Text -like $Value }
                    if (! $IsMultiSelect) { $ValuesToSelect = $ValuesToSelect | Select -first 1 }
                    Foreach ($v in $ValuesToSelect) {
                        [SeleniumSelection.Option]::SelectByText($Element, $v.Text, $false)     
                    }
                }
                else {
                    [SeleniumSelection.Option]::SelectByText($Element, $value, $false) 
                }
               
            }
            
            { $_ -eq [SeBySelect]::Value } { [SeleniumSelection.Option]::SelectByValue($Element, $value) } 
            { $_ -eq [SeBySelect]::Index } { [SeleniumSelection.Option]::SelectByIndex($Element, $value) }
        }
    }
    catch {
        throw "An error occured checking the selection box, the message was:`r`n $($_.exception.message)"
    }
}
function Set-SeUrl {
    <#
    .SYNOPSIS
    Navigates to the targeted URL with the selected or default driver.

    .DESCRIPTION
    Used for webdriver navigation commands, either to specific target URLs or
    for history (Back/Forward) navigation or refreshing the current page.

    .EXAMPLE
    Set-SeUrl 'https://www.google.com/'

    Directs the default driver to navigate to www.google.com.

    .EXAMPLE
    Set-SeUrl -Refresh

    Reloads the current page for the default driver.

    .EXAMPLE
    Set-SeUrl -Target $Driver -Back

    Directs the targeted webdriver instance to navigate Back in its history.

    .EXAMPLE
    Set-SeUrl -Forward

    Directs the default webdriver to navigate Forward in its history.

    .NOTES
    The Back/Forward/Refresh logic is handled by the webdriver itself. If you
    need a more granular approach to handling which locations are saved or
    retrieved, use Push-SeUrl or Pop-SeUrl to utilise a separately managed
    location stack.
    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    param(
        # The target URL for the webdriver to navigate to.
        [Parameter(Mandatory = $true, position = 0, ParameterSetName = 'url')]
        [StringUrlTransformAttribute()]
        [ValidateURIAttribute()]
        [string]$Url,

        # Trigger the Back history navigation action in the webdriver.
        [Parameter(Mandatory = $true, ParameterSetName = 'back')]
        [switch]$Back,

        # Trigger the Forward history navigation action in the webdriver.
        [Parameter(Mandatory = $true, ParameterSetName = 'forward')]
        [switch]$Forward,

        # Refresh the current page in the webdriver.
        [Parameter(Mandatory = $true, ParameterSetName = 'refresh')]
        [switch]$Refresh,
        
        [Parameter(ParameterSetName = 'back')]
        [Parameter(ParameterSetName = 'forward', Position = 1)]
        [ValidateScript( { $_ -ge 1 })] 
        [Int]$Depth = 1
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    for ($i = 0; $i -lt $Depth; $i++) {
        switch ($PSCmdlet.ParameterSetName) {
            'url' { $Driver.Navigate().GoToUrl($Url); break }
            'back' { $Driver.Navigate().Back(); break }
            'forward' { $Driver.Navigate().Forward(); break }
            'refresh' { $Driver.Navigate().Refresh(); break }
            default { throw 'Unexpected ParameterSet' }
        }    
    }
    
}

function Start-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [OutputType([OpenQA.Selenium.IWebDriver])]
    param(
        #Common to all browsers
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'DriverOptions')]
        $Browser,
        [StringUrlTransformAttribute()]
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ArgumentCompleter( { [Enum]::GetNames([SeWindowState]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeWindowState]) })]
        [SeWindowState] $State = [SeWindowState]::Default,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait = 0.2,
        [System.Drawing.Size][SizeTransformAttribute()]$Size,
        [System.Drawing.Point][PointTransformAttribute()]$Position,
        $WebDriverPath,
        $BinaryPath,
        [Parameter(ParameterSetName = 'DriverOptions', Mandatory = $false)]
        [OpenQA.Selenium.DriverService]$Service,
        [Parameter(ParameterSetName = 'DriverOptions', Mandatory = $true)]
        [OpenQA.Selenium.DriverOptions]$Options,
        [Parameter(ParameterSetName = 'Default')]
        [String[]]$Switches,
        [String[]]$Arguments,
        $ProfilePath,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [ValidateNotNullOrEmpty()]
        $Name,
        [SeDriverUserAgentTransformAttribute()]
        [ValidateNotNull()]
        [ArgumentCompleter( [SeDriverUserAgentCompleter])]
        [String]$UserAgent,
        [Switch]$AcceptInsecureCertificates,
        [Double]$CommandTimeout
        # See ParametersToRemove to view parameters that should not be passed to browsers internal implementations.
    )
    Begin {
        if ($PSBoundParameters.ContainsKey('UserAgent')) { Test-SeDriverUserAgent -Browser $Browser -ErrorAction Stop }
        if ($PSBoundParameters.ContainsKey('AcceptInsecureCertificates')) { Test-SeDriverAcceptInsecureCertificates -Browser $Browser -ErrorAction Stop }
    }
    process {
        #Params with default value that need to be pased down to Start-SeXXDriver
        $OptionalParams = @('ImplicitWait', 'State')
        Foreach ($key in $OptionalParams) {
            if (!$PSBoundParameters.ContainsKey($Key)) {
                $PSBoundParameters.Add($key, (Get-Variable -Name $key -ValueOnly))
            }
        }
        # Exclusive parameters to Start-SeDriver we don't want to pass down to anything else.
        # Still available through the variable directly within this cmdlet
        $ParametersToRemove = @('Arguments', 'Browser', 'Name', 'PassThru')
        $SelectedBrowser = $Browser
        switch ($PSCmdlet.ParameterSetName) {
            'Default' {
                $Options = New-SeDriverOptions -Browser $Browser
                $PSBoundParameters.Add('Options', $Options)

            }
            'DriverOptions' {
                if ($PSBoundParameters.ContainsKey('Service')) {
                    $MyService = $PSBoundParameters.Item('Service')
                    foreach ($Key in $MyService.SeParams.Keys) {
                        if (! $PSBoundParameters.ContainsKey($Key)) {
                            $PSBoundParameters.Add($Key, $MyService.SeParams.Item($Key))
                        }
                    }
                }

                $Options = $PSBoundParameters.Item('Options')
                $SelectedBrowser = $Options.SeParams.Browser

                # Start-SeDrivers params overrides whatever is in the options.
                # Any options parameter not specified by Start-SeDriver get added to the psboundparameters
                foreach ($Key in $Options.SeParams.Keys) {
                    if (! $PSBoundParameters.ContainsKey($Key)) {
                        $PSBoundParameters.Add($Key, $Options.SeParams.Item($Key))
                    }
                }

            }
        }

        if ($PSBoundParameters.ContainsKey('Arguments')) {
            foreach ($Argument in $Arguments) {
                $Options.AddArguments($Argument)
            }
        }


        $FriendlyName = $null
        if ($PSBoundParameters.ContainsKey('Name')) {
            $FriendlyName = $Name

            $AlreadyExist = $Script:SeDrivers.Where( { $_.SeFriendlyName -eq $FriendlyName }, 'first').Count -gt 0
            if ($AlreadyExist) {
                throw "A driver with the name $FriendlyName is already in the active list of started driver."
            }
        }


        #Remove params exclusive to this cmdlet before going further.
        $ParametersToRemove | ForEach-Object { if ($PSBoundParameters.ContainsKey("$_")) { [void]($PSBoundParameters.Remove("$_")) } }

        switch ($SelectedBrowser) {
            'Chrome' { $Driver = Start-SeChromeDriver @PSBoundParameters; break }
            'Edge' { $Driver = Start-SeEdgeDriver @PSBoundParameters; break }
            'Firefox' { $Driver = Start-SeFirefoxDriver @PSBoundParameters; break }
            'InternetExplorer' { $Driver = Start-SeInternetExplorerDriver @PSBoundParameters; break }
            'MSEdge' { $Driver = Start-SeMSEdgeDriver @PSBoundParameters; break }
        }
        if ($null -ne $Driver) {
            if ($null -eq $FriendlyName) { $FriendlyName = $Driver.SessionId }
            Write-Verbose -Message "Opened $($Driver.Capabilities.browsername) $($Driver.Capabilities.ToDictionary().browserVersion)"

            #Se prefix used to avoid clash with anything from Selenium in the future
            #SessionId scriptproperty validation to avoid perfomance cost of checking closed session.
            $Headless = if ($state -eq [SeWindowState]::Headless) { " (headless)" } else { "" }
            $mp = @{InputObject = $Driver ; MemberType = 'NoteProperty' }
            Add-Member @mp -Name 'SeBrowser' -Value "$SelectedBrowser$($Headless)"
            Add-Member @mp -Name 'SeFriendlyName' -Value "$FriendlyName"
            Add-Member @mp -Name 'SeSelectedElements' -Value $null
            Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeProcessId' -Value (Get-DriverProcessId -ServiceProcessId $Driver.SeServiceProcessId)

            $Script:SeDrivers.Add($Driver)
            Return Switch-SeDriver -Name $FriendlyName
        }

    }
}

function Start-SeRemote {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$RemoteAddress,
        [hashtable]$DesiredCapabilities,
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [Double]$ImplicitWait = 0.3,
        [System.Drawing.Size][SizeTransformAttribute()]$Size,
        [System.Drawing.Point][PointTransformAttribute()]$Position
    )

    $desired = [OpenQA.Selenium.Remote.DesiredCapabilities]::new()
    if (-not $DesiredCapabilities.Name) {
        $desired.SetCapability('name', [datetime]::now.tostring("yyyyMMdd-hhmmss"))
    }
    foreach ($k in $DesiredCapabilities.keys) { $desired.SetCapability($k, $DesiredCapabilities[$k]) }
    $Driver = [OpenQA.Selenium.Remote.RemoteWebDriver]::new($RemoteAddress, $desired)

    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)
    if ($StartURL) { $Driver.Navigate().GotoUrl($StartURL) }

    return $Driver
}
function Stop-SeDriver { 
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver
    )
    Begin {
        $ElementsToRemove = [System.Collections.Generic.List[PSObject]]::new()
    }
    Process {
        if (! $PSBoundParameters.ContainsKey('Driver')) {
            $Driver = Get-SeDriver -Current
        }

        
        if ($null -ne $Driver) {
            $Processes = (Get-Process -Id $Driver.SeProcessId, $Driver.SeServiceProcessId -ErrorAction SilentlyContinue )

            switch ($Processes.Count) {
                2 {
                    Write-Verbose -Message "Closing $BrowserName $($Driver.SeFriendlyName )..."
                    $Driver.Close()
                    $Driver.Dispose() 
                    break
                }
                1 { Stop-Process -Id $Processes.Id -ErrorAction SilentlyContinue }
            }
            $ElementsToRemove.Add($Driver)   
        }
               
    }
    End {
        $ElementsToRemove | ForEach-Object { [void]($script:SeDrivers.Remove($_)) }
        if ($script:SeDriversCurrent -notin $script:SeDrivers) {
            $script:SeDriversCurrent = $null
        }
        
    }
    

  
}
function Switch-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'ByName')]
    param(
        [parameter(Position = 0, ParameterSetName = 'ByDriver', Mandatory = $True)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $True)]
        [String]$Name
    )

    # Remove Selected visual indicator
    if ($null -ne $Script:SeDriversCurrent) { 
        $Script:SeDriversCurrent.SeBrowser = $Script:SeDriversCurrent.SeBrowser -replace ' \*$', ''
    }

    switch ($PSCmdlet.ParameterSetName) {
        'ByDriver' { $Script:SeDriversCurrent = $Driver }
        'ByName' {
            $Driver = Get-SeDriver -Name $Name 
            if ($null -eq $Driver) {
                $PSCmdlet.ThrowTerminatingError("Driver with Name: $Name not found ")
            }
            else {
                $Script:SeDriversCurrent = $Driver
            }
        }
    }

    $Driver.SeBrowser = "$($Driver.SeBrowser) *"

    return $Driver
}

function Switch-SeFrame {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Frame', Position = 0)]
        $Frame,

        [Parameter(Mandatory = $true, ParameterSetName = 'Parent')]
        [switch]$Parent,

        [Parameter(Mandatory = $true, ParameterSetName = 'Root')]
        [switch]$Root
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    #TODO Frame validation... Do not try to switch if element does not exist ?
    #TODO Review ... Maybe Parent / Root should be a unique parameter : -Level Parent/Root )
    if ($PSBoundParameters.ContainsKey('Frame')) { [void]$Driver.SwitchTo().Frame($Frame) }
    elseif ($Parent) { [void]$Driver.SwitchTo().ParentFrame() }
    elseif ($Root) { [void]$Driver.SwitchTo().defaultContent() }
}
function Switch-SeWindow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Window
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }
    process {
        $Driver.SwitchTo().Window($Window) | Out-Null
    }
}
function Update-SeDriver {
    [CmdletBinding()]
    param (
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        $Browser,
        [ValidateSet('Linux', 'Mac', 'Windows')]
        $OS,
        [ValidateScript( { (Test-Path -Path $_) -and ((Get-Item -Path $_) -is [System.IO.DirectoryInfo]) })]
        $Path
    )

    if (! $PSBoundParameters.ContainsKey('OS')) {
        if ($IsMacOS) { $OS = 'Mac' } elseif ($IsLinux) { $OS = 'Linux' } else { $OS = 'Windows' }
    }
    
    if (! $PSBoundParameters.ContainsKey('Path')) {
        $Path = $PSScriptRoot
        if ($Path.EndsWith('Public')) { $Path = Split-Path -Path $Path } #Debugging
        switch ($OS) {
            'Linux' { $AssembliesDir = Join-Path -Path $Path -ChildPath '/assemblies/linux' }
            'Mac' { $AssembliesDir = Join-Path -Path $Path -ChildPath '/assemblies/macos' }
            'Windows' { $AssembliesDir = Join-Path -Path $Path -ChildPath '/assemblies' }
        }
        
    }
    
    $TempDir = [System.IO.Path]::GetTempPath()

    switch ($Browser) {
        'Chrome' {
            $LatestChromeStableRelease = Invoke-WebRequest 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' | Select-Object -ExpandProperty Content
            $ChromeBuilds = @{
                Linux   = 'chromedriver_linux64'
                Mac     = 'chromedriver_mac64' 
                Windows = 'chromedriver_win32'
            }
            
            $Build = $ChromeBuilds.$OS
            
        
            $BuildFileName = "$Build.zip"
            Write-Verbose "Downloading: $BuildFileName"
            Invoke-WebRequest -OutFile "$($TempDir + $BuildFileName)" "https://chromedriver.storage.googleapis.com/$LatestChromeStableRelease/$BuildFileName" 
            
            # Expand the ZIP Archive to the correct Assemblies Dir 
            Write-Verbose "Explanding: $($TempDir + $BuildFileName) to $AssembliesDir"
            Expand-Archive -Path "$($TempDir + $BuildFileName)" -DestinationPath $AssembliesDir -Force
         
        }
        'Firefox' {
            Write-Warning 'Not Supported Yet' 

        }
        'Edge' {
            Write-Warning 'Not Supported Yet' 
        }
        Default {
            Write-Warning 'Not Supported Yet' 
        }
    }
}
function Wait-SeDriver {
    [Cmdletbinding()]
    param(
        [ArgumentCompleter([SeDriverConditionsCompleter])]
        [ValidateScript( { $_ -in $Script:SeDriverConditions.Text })]
        [Parameter(Position = 0, Mandatory = $true)]
        $Condition,
        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNull()]
        $Value,
        #Specifies a time out
        [Parameter(Position = 2)]
        [Double]$Timeout = 3
    )
    Begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
        $ImpTimeout = -1
        Test-SeDriverConditionsValueValidation -Condition $Condition -Value $Value -Erroraction Stop
    }
    process {
        $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver 
        if ($Condition -eq 'ScriptBlock') {
            $SeCondition = [System.Func[OpenQA.Selenium.IWebDriver, Bool]]$Value
        }
        else {
            $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Value)
        }
        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, ([timespan]::FromMilliseconds($Timeout * 1000)))
            
        try {
            [void]($WebDriverWait.Until($SeCondition))
            return $true
        }
        catch {
            Write-Error $_
            return $false
        }
        Finally {
            Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
        }
    }
}
function Wait-SeElement {
    [Cmdletbinding(DefaultParameterSetName = 'Element')]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [Parameter(ParameterSetName = 'Locator', Position = 0)]
        [SeBySelector]$By = [SeBySelector]::XPath,
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Locator')]
        [string]$Value,

        [Parameter(ParameterSetName = 'Element', Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [ArgumentCompleter([SeElementsConditionsCompleter])]
        [ValidateScript( { $_ -in $Script:SeElementsConditions.Text })]
        $Condition,
        [ValidateNotNull()]
        $ConditionValue,
        #Specifies a time out
        [Double]$Timeout = 3

    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
        Test-SeElementConditionsValueValidation -By $By -Element $Element -Condition $Condition -ConditionValue $ConditionValue -ParameterSetName $PSCmdlet.ParameterSetName @Stop 
        $ImpTimeout = -1 

        $ExpectedValueType = Get-SeElementsConditionsValueType -text $Condition

    }
    process {
        $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver

        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, ([timespan]::FromMilliseconds($Timeout * 1000)))
        $NoExtraArg = $null -eq $ExpectedValueType
        
        if ($PSBoundParameters.ContainsKey('Element')) {
            if ($NoExtraArg) {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Element)
            }
            else {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Element, $ConditionValue)
            }
        }
        else {
            if ($NoExtraArg) {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition([OpenQA.Selenium.By]::$By($Value))
            }
            else {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition([OpenQA.Selenium.By]::$By($Value), $ConditionValue)
            }
        }

        try {
            [void]($WebDriverWait.Until($SeCondition))
            return $true
        }
        catch {
            Write-Error $_
            return $false
        }
        Finally {
            Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
        }
    }
}



<#
.SYNOPSIS
   Disable Implicitt wait on the specidifed driver
.DESCRIPTION
    This cmdlet is used alongside the corresponding Enable cmdlet to temporarily disable
    Implicit wait whenever explicit wait are used.
.EXAMPLE
    PS C:\> $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver
    Disable implicit wait on the specified driver and return the old timespan.
.INPUTS
    Inputs (if any)
.OUTPUTS
    Implicit wait Timespan obtained before setting it to 0
.NOTES
    These cmdlet are used because mixing ImplicitWait and ExplicitWait can have unintended consequences.
    Thus, implicit wait should always temporarily be disabled when using explicit wait statements.
#>
function Disable-SeDriverImplicitTimeout {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver
    )
    $Output = $Driver.Manage().Timeouts().ImplicitWait
    $Driver.Manage().Timeouts().ImplicitWait = 0
    return $Output
}

<#
.SYNOPSIS
    Enable ImplicitWait on the specified driver.
.DESCRIPTION
    Enable ImplicitWait on the specified driver. See the corresponding Disable cmdlet for more information.
.EXAMPLE
    PS C:\> Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Enable-SeDriverImplicitTimeout {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [timespan]$Timeout
    )
    $Driver.Manage().Timeouts().ImplicitWait = $Timeout
}

function Get-DriverProcessId {
    [CmdletBinding()]
    param (
        $ServiceProcessId
    )

    $IsWindowsPowershell = $PSVersionTable.PSVersion.Major -lt 6

    if ($IsWindowsPowershell) {
        $Processes = Get-CimInstance -Class Win32_Process -Filter "ParentProcessId=$ServiceProcessId"
        $BrowserProcess = $Processes | Where-Object  { $_.Name -ne 'conhost.exe' } | Select-Object -First 1 -ExpandProperty ProcessId
    }
    else {
        $BrowserProcess = (Get-Process).Where( { { $_.Parent.id -eq $ServiceProcessId -and $_.Name -ne 'conhost' } }, 'first').Id
    }
    return $BrowserProcess

}

Function Get-OptionsSwitchValue($Switches, $Name) {
    if ($null -eq $Switches -or -not $Switches.Contains($Name)) { Return $false }
    return $True
}
Function Get-SeElementsConditionsValueType($Text) {
    return $Script:SeElementsConditions.Where( { $_.Text -eq $Text }, 'first')[0].ValueType 
}
Function Get-WildcardsIndices($Value) {
   
    $Escape = 0
    $Index = -1 
    $Value.ToCharArray() | ForEach-Object {
        $Index += 1
        $IsWildCard = $false
        switch ($_) {
            '`' { $Escape += 1; break }
            '*' { $IsWildCard = $Escape % 2 -eq 0; $Escape = 0 }
            Default { $Escape = 0 }
        }
        if ($IsWildCard) { return $Index }
 
    }
}
function Init-SeDriver {
    [CmdletBinding()]
    param ($Element)
    
    IF ($null -NE $Element) {
        $Driver = ($Element | Select-Object -First 1).WrappedDriver
    }
    $Driver = Get-SeDriver -Current -ErrorAction Stop
       
    if ($null -ne $Driver) {
        return $Driver
    }
    else {
        Throw [System.ArgumentNullException]::new("An available Driver could not be found.")
    }



    
    
}


function Start-SeChromeDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath = $env:ChromeWebDriver,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        $UserAgent,
        [Switch]$AcceptInsecureCertificates,
        [Double]$CommandTimeout



        #        [System.IO.FileInfo]$ProfilePath,
        #        $BinaryPath,

        # "user-data-dir=$ProfilePath"



    )

    process {
        #Additional Switches
        $EnablePDFViewer = Get-OptionsSwitchValue -Switches $Switches -Name  'EnablePDFViewer'
        $DisableAutomationExtension = Get-OptionsSwitchValue -Switches $Switches -Name 'DisableAutomationExtension'

        #region Process Additional Switches
        if ($EnablePDFViewer) { $Options.AddUserProfilePreference('plugins', @{'always_open_pdf_externally' = $true; }) }

        if ($DisableAutomationExtension) {
            $Options.AddAdditionalCapability('useAutomationExtension', $false)
            $Options.AddExcludedArgument('enable-automation')
        }

        #endregion

        if ($DefaultDownloadPath) {
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Options.AddUserProfilePreference('download', @{'default_directory' = $($DefaultDownloadPath.FullName); 'prompt_for_download' = $false; })
        }

        if ($UserAgent) {
            Write-Verbose "Setting User Agent: $UserAgent"
            $Options.AddArgument("--user-agent=$UserAgent")
        }

        if ($AcceptInsecureCertificates) {
            Write-Verbose "AcceptInsecureCertificates capability set to: $($AcceptInsecureCertificates.IsPresent)"
            $Options.AddAdditionalCapability([OpenQA.Selenium.Remote.CapabilityType]::AcceptInsecureCertificates, $true, $true)
        }

        if ($ProfilePath) {
            Write-Verbose "Setting Profile directory: $ProfilePath"
            $Options.AddArgument("user-data-dir=$ProfilePath")
        }

        if ($BinaryPath) {
            Write-Verbose "Setting Chrome Binary directory: $BinaryPath"
            $Options.BinaryLocation = "$BinaryPath"
        }

        if ($PSBoundParameters.ContainsKey('LogLevel')) {
            Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
        }



        switch ($State) {
            { $_ -eq [SeWindowState]::Headless } { $Options.AddArguments('headless') }
            #  { $_ -eq [SeWindowState]::Minimized } {}  # No switches... Managed after launch
            { $_ -eq [SeWindowState]::Maximized } { $Options.AddArguments('start-maximized') }
            { $_ -eq [SeWindowState]::Fullscreen } { $Options.AddArguments('start-fullscreen') }
        }

        if ($PrivateBrowsing) {
            $Options.AddArguments('Incognito')
        }
        #  $Location = @('--window-position=1921,0', '--window-size=1919,1080')
        if ($PSBoundParameters.ContainsKey('Size')) {
            $Options.AddArguments("--window-size=$($Size.Width),$($Size.Height)")
        }
        if ($PSBoundParameters.ContainsKey('Position')) {
            $Options.AddArguments("--window-position=$($Position.X),$($Position.Y)")
        }



        if (-not $PSBoundParameters.ContainsKey('Service')) {
            $ServiceParams = @{}
            if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
            $service = New-SeDriverService -Browser Chrome @ServiceParams
        }


        if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
            $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Options, [TimeSpan]::FromMilliseconds($CommandTimeout * 1000))
        }
        else {
            $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Options)
        }
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }
        Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)

        if ($State -eq 'Minimized') {
            $Driver.Manage().Window.Minimize();
        }

        if ($Headless -and $DefaultDownloadPath) {
            $HeadlessDownloadParams = [system.collections.generic.dictionary[[System.String], [System.Object]]]::new()
            $HeadlessDownloadParams.Add('behavior', 'allow')
            $HeadlessDownloadParams.Add('downloadPath', $DefaultDownloadPath.FullName)
            $Driver.ExecuteChromeCommand('Page.setDownloadBehavior', $HeadlessDownloadParams)
        }

        if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }
        #endregion


        return $Driver
    }
}

function Start-SeEdgeDriver {
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [Switch]$AcceptInsecureCertificates,
        [Double]$CommandTimeout

    )

    if ($AcceptInsecureCertificates) {
        Write-Verbose "AcceptInsecureCertificates capability set to: $($AcceptInsecureCertificates.IsPresent)"
        $Options.AddAdditionalCapability([OpenQA.Selenium.Remote.CapabilityType]::AcceptInsecureCertificates, $true, $true)
    }

    #region check / set paths for browser and web driver and edge options
    if ($PSBoundParameters['BinaryPath'] -and -not (Test-Path -Path $BinaryPath)) {
        throw "Could not find $BinaryPath"; return
    }

    if ($WebDriverPath -and -not (Test-Path -Path (Join-Path -Path $WebDriverPath -ChildPath 'msedgedriver.exe'))) {
        throw "Could not find msedgedriver.exe in $WebDriverPath"; return
    }
    elseif ($WebDriverPath -and (Test-Path (Join-Path -Path $WebDriverPath -ChildPath 'msedge.exe'))) {
        Write-Verbose -Message "Using browser from $WebDriverPath"
        $Options.BinaryLocation = Join-Path -Path $WebDriverPath -ChildPath 'msedge.exe'
    }
    elseif ($BinaryPath) {
        $Options.BinaryLocation = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BinaryPath)
        Write-Verbose -Message "Will request $($Options.BinaryLocation) as the browser"
    }

    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    if (-not $WebDriverPath -and $binaryDir -and (Test-Path (Join-Path -Path $binaryDir -ChildPath 'msedgedriver.exe'))) {
        $WebDriverPath = $binaryDir
    }
    # No linux or mac driver to test for yet
    if (-not $WebDriverPath -and (Test-Path (Join-Path -Path "$PSScriptRoot\Assemblies\" -ChildPath 'msedgedriver.exe'))) {
        $WebDriverPath = "$PSScriptRoot\Assemblies\"
        Write-Verbose -Message "Using Web driver from the default location"
    }

    if (-not $PSBoundParameters.ContainsKey('Service')) {
        $ServiceParams = @{}
        if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
        $service = New-SeDriverService -Browser Edge @ServiceParams
    }

    #The command line args may now be --inprivate --headless but msedge driver V81 does not pass them
    if ($PrivateBrowsing) { $options.AddArguments('InPrivate') }
    if ($State -eq [SeWindowState]::Headless) { $options.AddArguments('headless') }
    if ($ProfilePath) {
        $ProfilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProfilePath)
        Write-Verbose "Setting Profile directory: $ProfilePath"
        $options.AddArgument("user-data-dir=$ProfilePath")
    }
    if ($DefaultDownloadPath) {
        $DefaultDownloadPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DefaultDownloadPath)
        Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
        $Options.AddUserProfilePreference('download', @{'default_directory' = $DefaultDownloadPath; 'prompt_for_download' = $false; })
    }
    #endregion

    if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
        $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $Options, [TimeSpan]::FromMilliseconds($CommandTimeout * 1000))
    }
    else {
        $Driver = [OpenQA.Selenium.Chrome.ChromeDriver]::new($service, $options)
    }

    #region post driver checks and option checks If we have a version know to have problems with passing arguments, generate a warning if we tried to send any.
    if (-not $Driver) {
        Write-Warning "Web driver was not created"; return
    }
    else {
        Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
        $driverversion = $Driver.Capabilities.ToDictionary().msedge.msedgedriverVersion -replace '^([\d.]+).*$', '$1'
        if (-not $driverversion) { $driverversion = $driver.Capabilities.ToDictionary().chrome.chromedriverVersion -replace '^([\d.]+).*$', '$1' }
        Write-Verbose "Web Driver version $driverversion"
        Write-Verbose ("Browser: {0,9} {1}" -f $Driver.Capabilities.ToDictionary().browserName,
            $Driver.Capabilities.ToDictionary().browserVersion)

        $browserCmdline = (Get-CimInstance -Verbose:$false -Query (
                "Select * From win32_process " +
                "Where parentprocessid = $($service.ProcessId) " +
                "And name = 'msedge.exe'")).commandline
        $options.arguments | Where-Object { $browserCmdline -notlike "*$_*" } | ForEach-Object {
            Write-Warning "Argument $_ was not passed to the Browser. This is a known issue with some web driver versions."
        }
    }

    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }

    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)
    if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }


    switch ($State) {
        { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); }
        { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() }
        { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() }
    }


    #endregion

    return  $Driver
}
function Start-SeFirefoxDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath = $env:GeckoWebDriver,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [String]$UserAgent,
        [Switch]$AcceptInsecureCertificates,
        [Double]$CommandTimeout

    )
    process {

        if ($State -eq [SeWindowState]::Headless) {
            $Options.AddArguments('-headless')
        }

        if ($DefaultDownloadPath) {
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Options.setPreference("browser.download.folderList", 2);
            $Options.SetPreference("browser.download.dir", "$DefaultDownloadPath");
        }

        if ($UserAgent) {
            Write-Verbose "Setting User Agent: $UserAgent"
            $Options.SetPreference("general.useragent.override", $UserAgent)
        }

        if ($AcceptInsecureCertificates) {
            Write-Verbose "AcceptInsecureCertificates capability set to: $($AcceptInsecureCertificates.IsPresent)"
            $Options.AddAdditionalCapability([OpenQA.Selenium.Remote.CapabilityType]::AcceptInsecureCertificates,$true,$true)
        }

        if ($PrivateBrowsing) {
            $Options.SetPreference("browser.privatebrowsing.autostart", $true)
        }

        if ($PSBoundParameters.ContainsKey('LogLevel')) {
            Write-Verbose "Setting Firefox LogLevel to $LogLevel"
            $Options.LogLevel = $LogLevel
        }

        if (-not $PSBoundParameters.ContainsKey('Service')) {
            $ServiceParams = @{}
            if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
            $service = New-SeDriverService -Browser Firefox @ServiceParams
        }


        if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
            $Driver = [OpenQA.Selenium.Firefox.FirefoxDriver]::new($service, $Options, [TimeSpan]::FromMilliseconds($CommandTimeout * 1000))
        }
        else {
            $Driver = [OpenQA.Selenium.Firefox.FirefoxDriver]::new($service, $Options)
        }
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }
        Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)

        if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
        if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }

        # [SeWindowState]
        switch ($State) {
            { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); break }
            { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() ; break }
            { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() ; break }
        }

        if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }
        #endregion

        Return $Driver
    }
}
function Start-SeInternetExplorerDriver {
    param(
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [Double]$CommandTimeout
    )


    #region IE set-up options
    if ($state -eq [SeWindowState]::Headless -or $PrivateBrowsing) { Write-Warning 'The Internet explorer driver does not support headless or Inprivate operation; these switches are ignored' }

    $IgnoreProtectedModeSettings = Get-OptionsSwitchValue -Switches $Switches -Name  'IgnoreProtectedModeSettings'
    if ($IgnoreProtectedModeSettings) {
        $Options.IntroduceInstabilityByIgnoringProtectedModeSettings = $true
    }

    if ($StartURL) { $Options.InitialBrowserUrl = $StartURL }

    if (-not $PSBoundParameters.ContainsKey('Service')) {
        $ServiceParams = @{}
        if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
        $service = New-SeDriverService -Browser InternetExplorer @ServiceParams
    }

    #endregion

    if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
        $Driver = [OpenQA.Selenium.IE.InternetExplorerDriver]::new($service, $Options, [TimeSpan]::FromMilliseconds($CommandTimeout * 1000))
    }
    else {
        $Driver = [OpenQA.Selenium.IE.InternetExplorerDriver]::new($service, $Options)
    }
    if (-not $Driver) { Write-Warning "Web driver was not created"; return }
    Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    #region post creation options
    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)


    switch ($State) {
        { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); }
        { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() }
        { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() }
    }

    #endregion

    return $Driver
}
function Start-SeMSEdgeDriver {
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel
    )
    #region Edge set-up options
    if ($state -eq [SeWindowState]::Headless) { Write-Warning 'Pre-Chromium Edge does not support headless operation; the Headless switch is ignored' }
    
    if (-not $PSBoundParameters.ContainsKey('Service')) {
        $ServiceParams = @{}
        #if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
        $service = New-SeDriverService -Browser MSEdge @ServiceParams -ErrorAction Stop
    }
    
    if ($PrivateBrowsing) { $options.UseInPrivateBrowsing = $true }
    if ($StartURL) { $options.StartPage = $StartURL }
    #endregion

    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    try {
        $Driver = [OpenQA.Selenium.Edge.EdgeDriver]::new($service , $options)
    }
    catch {
        $driverversion = (Get-Item .\assemblies\MicrosoftWebDriver.exe).VersionInfo.ProductVersion
        $WindowsVersion = [System.Environment]::OSVersion.Version.ToString()
        Write-Warning -Message "Edge driver is $driverversion. Windows is $WindowsVersion. If the driver is out-of-date, update it as a Windows feature,`r`nand then delete $PSScriptRoot\assemblies\MicrosoftWebDriver.exe"
        throw $_ ; return
    }
    if (-not $Driver) { Write-Warning "Web driver was not created"; return }
    Add-Member -InputObject $Driver -MemberType NoteProperty -Name 'SeServiceProcessId' -Value $Service.ProcessID
    #region post creation options
    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)

    switch ($State) {
        { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize() }
        { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() }
        { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() }
    }

    #endregion

    Return $Driver
}
function Test-SeDriverAcceptInsecureCertificates {
    [CmdletBinding()]
    param (
        $Browser, [ref]$AcceptInsecureCertificates,
        $Boundparameters
    )

    $SupportedBrowsers = @('Chrome','Edge','Firefox')
    if ($Browser -in $SupportedBrowsers) { 
        return 
    }
    else {
        Throw ([System.NotImplementedException]::new(@"
AcceptInsecureCertificates parameter is only supported by the following browser: $($SupportedBrowsers -join ',')
Selected browser: $Browser
"@))
    }
}
function Test-SeDriverConditionsValueValidation {
    [CmdletBinding()]
    param (
        $Condition, $Value
    )

    if ($PSBoundParameters.ContainsKey('Condition')) {
        $ConditionValueType = $Script:SeDriverConditions.Where( { $_.Text -eq $Condition }, 'first')[0].ValueType
        
        if ($null -eq $ConditionValueType) {
            Throw "The condition $Condition do not accept value"
        }
        elseif ($Value -isnot $ConditionValueType) {
            Throw "The condition $Condition accept only value of type $ConditionValueType. The value provided was of type $($Value.GetType())"
        }
        else {
            return 
        }
    }
 
}
function Test-SeDriverUserAgent {
    [CmdletBinding()]
    param (
        $Browser, [ref]$UserAgent,
        $Boundparameters
    )

    $SupportedBrowsers = @('Chrome', 'Firefox')
    if ($Browser -in $SupportedBrowsers) { 
        return 
    }
    else {
        Throw ([System.NotImplementedException]::new(@"
UserAgent parameter is only supported by the following browser: $($SupportedBrowsers -join ',')
Selected browser: $Browser
"@))
    }
}
function Test-SeElementConditionsValueValidation {
    Param(
        $Element,
        $By,
        $Condition,
        $ConditionValue,
        $ParameterSetName
    )
    # 0: All;
    # 1: By 
    # 2: Element

    $ConditionDetails = $Script:SeElementsConditions.Where( { $_.Text -eq $Condition }, 'first')[0]

    switch ($ParameterSetName) {
        'Locator' {  
            if ($ConditionDetails.By_Element -eq 2) { 
                Throw "The condition $Condition can only be used with an element (`$Element)"
            }
        }
        'Element' {
            if ($ConditionDetails.By_Element -eq 1) { 
                Throw "The condition $Condition can only be used with a locator (`$By & `$Value)"
            }
        }
    }


    
    if ($null -ne $ConditionValue) {
        if ($null -eq $ConditionDetails.ValueType) {
            Throw "The condition $Condition do not accept value"
        }
        elseif ($ConditionValue -isnot $ConditionDetails.ValueType) {
            Throw "The condition $Condition accept only value of type $($ConditionDetails.ValueType). The value provided was of type $($ConditionValue.GetType())"
        }
        else {
            return 
        }
    }
}
function Test-SeMouseActionValueValidation {
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
class PointTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    # Implement the Transform() method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        <#
            The parameter value(s) are passed in here as $inputData. We aren't accepting array input
            for our function, but it's good to make these fairly versatile where possible, so that
            you can reuse them easily!
        #>
        $outputData = switch ($inputData) {
            { $_ -is [PointTransformAttribute] } { $_ }
            { $_ -is [int] } { [System.Drawing.Point]::new($_, $_) }
            { $_ -is [string] -and (($_ -split '[,x]').count -eq 2) } { 
                $sp = $_ -split '[,x]'
                [System.Drawing.Point]::new($sp[0], $sp[1]) 
            }
            default {
                # If we hit something we can't convert, throw an exception
                throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
                    "Could not convert input '$_' to a valid Point object."
                )
            }
        }

        return $OutputData
    }

}
$Script:SeDriverConditions = @(
    [PSCustomObject]@{Text = 'AlertState'; ValueType = [bool]; Tooltip = "A value indicating whether or not an alert should be displayed in order to meet this condition." }
    [PSCustomObject]@{Text = 'ScriptBlock'; ValueType = [ScriptBlock]; Tooltip = "A scriptblock to be evaluated." }
    [PSCustomObject]@{Text = 'TitleContains'; ValueType = [String]; Tooltip = "An expectation for checking that the title of a page contains a case-sensitive substring." }
    [PSCustomObject]@{Text = 'TitleIs'; ValueType = [String]; Tooltip = "An expectation for checking the title of a page." }
    [PSCustomObject]@{Text = 'UrlContains'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
    [PSCustomObject]@{Text = 'UrlMatches'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
    [PSCustomObject]@{Text = 'UrlToBe'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
)

class SeDriverConditionsCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

        $Script:SeDriverConditions.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Value: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}
class SeDriverUserAgentCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
       
        $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue

        [System.Collections.Generic.List[PSObject]]$Predefined = 
        [Microsoft.PowerShell.Commands.PSUserAgent].GetProperties() |
            Select-Object Name, @{n = 'UserAgent'; e = { [Microsoft.PowerShell.Commands.PSUserAgent]::$($_.Name) } }
        
        $Predefined.Add([PSCustomObject]@{Name = 'Android'; UserAgent = 'Android' })
        $Predefined.Add([PSCustomObject]@{Name = 'Iphone'; UserAgent = 'Iphone' })

        $Predefined |
            ForEach-Object { 
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, $pvalue, $_.UserAgent) ) ) 
            }
        return $CompletionResults
    }
}
class SeDriverUserAgentTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    # Implement the Transform() method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        <#
            The parameter value(s) are passed in here as $inputData. We aren't accepting array input
            for our function, but it's good to make these fairly versatile where possible, so that
            you can reuse them easily!
        #>
        $outputData = switch ($inputData) {
            { $_ -is [string] } { 
                $output = [Microsoft.PowerShell.Commands.PSUserAgent]::$_
                if ($null -ne $output) { $output } else { $_ }
            }
            default {
                # If we hit something we can't convert, throw an exception
                throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
                    "Only String attributes are supported."
                )
            }
        }

        return $OutputData
    }

}
$Script:SeElementsConditions = @(
    [PSCustomObject]@{Text = 'ElementExists'; ValueType = $null; By_Element = 1; Tooltip = 'An expectation for checking that an element is present on the DOM of a page. This does not necessarily mean that the element is visible.' }
    [PSCustomObject]@{Text = 'ElementIsVisible'; ValueType = $null; By_Element = 1; Tooltip = 'An expectation for checking that an element is present on the DOM of a page and visible. Visibility means that the element is not only displayed but also has a height and width that is greater than 0.' }
    [PSCustomObject]@{Text = 'ElementToBeSelected'; ValueType = [bool]; By_Element = 0; Tooltip = 'An expectation for checking if the given element is selected.' }
    [PSCustomObject]@{Text = 'InvisibilityOfElementLocated'; ValueType = [bool]; By_Element = 1; Tooltip = 'An expectation for checking that an element is either invisible or not present on the DOM.' }
    [PSCustomObject]@{Text = 'ElementToBeClickable'; ValueType = $null; By_Element = 0; Tooltip = 'An expectation for checking an element is visible and enabled such that you can click it.' }
    [PSCustomObject]@{Text = 'InvisibilityOfElementWithText'; ValueType = [string]; By_Element = 1; Tooltip = 'An expectation for checking that an element with text is either invisible or not present on the DOM.' }
    [PSCustomObject]@{Text = 'PresenceOfAllElementsLocatedBy'; ValueType = $null; By_Element = 1; Tooltip = 'An expectation for checking that all elements present on the web page that match the locator.' }
    [PSCustomObject]@{Text = 'TextToBePresentInElement'; ValueType = [string]; By_Element = 2; Tooltip = 'An expectation for checking if the given text is present in the specified element.' }
    [PSCustomObject]@{Text = 'TextToBePresentInElementValue'; ValueType = [string]; By_Element = 0; Tooltip = 'An expectation for checking if the given text is present in the specified elements value attribute.' }
    [PSCustomObject]@{Text = 'StalenessOf'; ValueType = $null; By_Element = 2; Tooltip = 'Wait until an element is no longer attached to the DOM.' }
)

class SeElementsConditionsCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
       
        $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue
        $SearchBy = 0
        switch ($true) {
            { $fakeBoundParameters.ContainsKey('By') } { $SearchBy = 1; break }
            { $fakeBoundParameters.ContainsKey('Element') } { $SearchBy = 2; break }
        }
        $Script:SeElementsConditions.where( { $_.Text -like $wildcard -and $_.By_Element -in @(0, $SearchBy) }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Value: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}
class SeMouseActionCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
       
        $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue

        $Script:SeMouseAction.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $ElementRequired = 'N/A'
                switch ($_.ElementRequired) {
                    $true { $ElementRequired = 'Required' }
                    $false { $ElementRequired = 'Optional' }
                }


                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Element: $ElementRequired`nValue: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}
$Script:SeMouseClickAction = @(
    New-Condition -Text 'Click'         -Tooltip 'Clicks the mouse on the specified element.'
    New-Condition -Text 'Click_JS' -ElementRequired $true -Tooltip 'Clicks the mouse on the specified element using Javascript.'
    New-Condition -Text 'ClickAndHold'  -Tooltip 'Clicks and holds the mouse button down on the specified element.'
    New-Condition -Text 'ContextClick'  -Tooltip 'Right-clicks the mouse on the specified element.'
    New-Condition -Text 'DoubleClick'   -Tooltip 'Double-clicks the mouse on the specified element.'
    New-Condition -Text 'Release'       -Tooltip 'Releases the mouse button at the last known mouse coordinates or specified element.'
)

class SeMouseClickActionCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [System.Management.Automation.Language.CommandAst]  $CommandAst,
        [system.Collections.IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        $pvalue = [System.Management.Automation.CompletionResultType]::ParameterValue
        
        
        $Script:SeMouseClickAction.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, $_.Tooltip) ) ) 
            }
        return $CompletionResults
    }
}
class SizeTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    # Implement the Transform() method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        <#
            The parameter value(s) are passed in here as $inputData. We aren't accepting array input
            for our function, but it's good to make these fairly versatile where possible, so that
            you can reuse them easily!
        #>
        $outputData = switch ($inputData) {
            { $_ -is [SizeTransformAttribute] } { $_ }
            { $_ -is [int] } { [System.Drawing.Size]::new($_, $_) }
            { $_ -is [string] -and (($_ -split '[,x]').count -eq 2) } { 
                $sp = $_ -split '[,x]'
                [System.Drawing.Size]::new($sp[0], $sp[1]) 
            }
            default {
                # If we hit something we can't convert, throw an exception
                throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
                    "Could not convert input '$_' to a valid Size object."
                )
            }
        }

        return $OutputData
    }

}
class StringUrlTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    # Implement the Transform() method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        <#
            The parameter value(s) are passed in here as $inputData. We aren't accepting array input
            for our function, but it's good to make these fairly versatile where possible, so that
            you can reuse them easily!
        #>
        $outputData = switch ($inputData) {
            { $_ -is [string] } { 
                if ($_ -match '://') { 
                    $_ 
                }
                else {
                    "https://$_"
                }
            }
            default {
                # If we hit something we can't convert, throw an exception
                throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
                    "Only String attributes are supported."
                )
            }
        }

        return $OutputData
    }

}
