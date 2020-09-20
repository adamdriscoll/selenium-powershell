using namespace system.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

if ('ValidateURIAttribute' -as [type]) {
    class ValidateURIAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
        [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
            $Out = $null
            if ([uri]::TryCreate($arguments, [System.UriKind]::Absolute, [ref]$Out)) { return }
            else { throw  [System.Management.Automation.ValidationMetadataException]::new('Incorrect StartURL please make sure the URL starts with http:// or https://') }
            return
        }
    }    
    class ValidateURI : ValidateURIAttribute {}
}


if ('ValidateIsWebDriverAttribute' -as [type]) {
    class ValidateIsWebDriverAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
        [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
            if ($arguments -isnot [OpenQA.Selenium.Remote.RemoteWebDriver]) {
                throw  [System.Management.Automation.ValidationMetadataException]::new('Target was not a valid web driver')
            }
            return
        }
    }
    class ValidateIsWebDriver : ValidateIsWebDriverAttribute {}
}



if ('OperatorTransformAttribute' -as [type]) {
    #Allow operator to use containing, matching, matches, equals etc.
    class OperatorTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
        [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object] $InputData) {
            if ($inputData -match '^(contains|like|notlike|match|notmatch|eq|ne|gt|lt)$') {
                return $InputData
            }
            switch -regex ($InputData) {
                "^contain" { return 'contains' ; break }
                "^match" { return 'match'    ; break }
                "^n\w*match" { return 'notmatch' ; break }
                "^eq" { return 'eq'       ; break }
                "^n\w*eq" { return 'ne'       ; break }
                "^n\w*like" { return 'like'       ; break }
            }
            return $InputData
        }
    }

    class OperatorTransform : OperatorTransformAttribute {}
}

$dll1Path = Join-path -path (Join-path -path $PSScriptRoot -ChildPath 'assemblies') -ChildPath 'WebDriver.dll'
$dll2Path = Join-path -path (Join-path -path $PSScriptRoot -ChildPath 'assemblies') -ChildPath 'WebDriver.Support.dll'

Add-type @"
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Collections.Generic;
namespace SeleniumSelection {
    public class Option {
        public static bool IsMultiSelect(IWebElement element) {
            var selection = new SelectElement(element);
            return selection.IsMultiple;
        }
        public static IList<IWebElement> GetOptions(IWebElement element) {
            var selection = new SelectElement(element);
            return selection.Options;
        }
        public static void SelectByValue(IWebElement element, string value) {
            var selection = new SelectElement(element);
            selection.SelectByValue(value);
        }
        public static void DeselectByValue(IWebElement element, string value) {
            var selection = new SelectElement(element);
            selection.DeselectByValue(value);
        }
        public static void SelectByText(IWebElement element, string text, bool partialMatch = false) {
            var selection = new SelectElement(element);
            selection.SelectByText(text,partialMatch);
        }
        public static void DeselectByText(IWebElement element, string text) {
            var selection = new SelectElement(element);
            selection.DeselectByText(text);
        }
        public static void SelectByIndex(IWebElement element, int index) {
            var selection = new SelectElement(element);
            selection.SelectByIndex(index);
        }
        public static void DeselectByIndex(IWebElement element, int index) {
            var selection = new SelectElement(element);
            selection.DeselectByIndex(index);
        }
        public static void DeselectAll(IWebElement element) {
            var selection = new SelectElement(element);
            selection.DeselectAll();
        }
        public static IWebElement GetSelectedOption(IWebElement element) {
            var selection = new SelectElement(element);
            return selection.SelectedOption;
        }
        public static IList<IWebElement> GetAllSelectedOptions(IWebElement element) {
            var selection = new SelectElement(element);
            return selection.AllSelectedOptions;
        }
    }
}
"@ -ReferencedAssemblies $dll1Path, $dll2Path, mscorlib


enum SeBrowsers {
    Chrome
    Edge 
    Firefox
    InternetExplorer
    MSEdge
}

enum SeWindowState {
    Headless
    Default
    Minimized
    Maximized
    Fullscreen
}

enum SeBySelector {
    ClassName
    CssSelector
    Id
    LinkText
    PartialLinkText
    Name
    TagName
    XPath
}

enum SeBySelect {
    Index
    Text
    Value    
}





#region SeDriverConditions
$Script:SeDriverConditions = @(
    [PSCustomObject]@{Text = 'AlertState'; ValueType = [bool]; Tooltip = "A value indicating whether or not an alert should be displayed in order to meet this condition." }
    [PSCustomObject]@{Text = 'TitleContains'; ValueType = [String]; Tooltip = "An expectation for checking that the title of a page contains a case-sensitive substring." }
    [PSCustomObject]@{Text = 'TitleIs'; ValueType = [String]; Tooltip = "An expectation for checking the title of a page." }
    [PSCustomObject]@{Text = 'UrlContains'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
    [PSCustomObject]@{Text = 'UrlMatches'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
    [PSCustomObject]@{Text = 'UrlToBe'; ValueType = [String]; Tooltip = "An expectation for the URL of the current page to be a specific URL." }
)

class SeDriverConditionsCompleter : IArgumentCompleter {
    [IEnumerable[CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [CommandAst]  $CommandAst,
        [IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [List[CompletionResult]]::new()

        $Script:SeDriverConditions.where( { $_.Text -like $wildcard }) |
            ForEach-Object { 
                $Valuetype = $_.ValueType
                if ($null -eq $ValueType) { $Valuetype = 'None' }
                $pvalue = [CompletionResultType]::ParameterValue
                $CompletionResults.Add(([System.Management.Automation.CompletionResult]::new($_.Text, $_.Text, $pvalue, "Value: $ValueType`n$($_.Tooltip)") ) ) 
            }
        return $CompletionResults
    }
}

Function Get-SeDriverConditionsValidation {
    [CmdletBinding()]
    Param($Condition) 
    return $Condition -in $Script:SeDriverConditions.Text
}

function Get-SeDriverConditionsValueValidation {
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
            return $true      
        }
    }
 
}
    
#endregion


#region SeElementsConditions 
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

Function Get-SeElementsConditionsValueType($Text) { return $Script:SeElementsConditions.Where( { $_.Text -eq $Text }, 'first')[0].ValueType }

class SeElementsConditionsCompleter : IArgumentCompleter {
    [IEnumerable[CompletionResult]] CompleteArgument(
        [string]      $CommandName ,
        [string]      $ParameterName,
        [string]      $WordToComplete,
        [CommandAst]  $CommandAst,
        [IDictionary] $FakeBoundParameters
    ) { 
        $wildcard = ("*" + $wordToComplete + "*")
        $CompletionResults = [List[CompletionResult]]::new()
       
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


function Get-SeElementsConditionsValueValidation {
    Param(
        $Element,
        $By,
        $Condition,
        $ConditionValue
    )
    # 0: All;
    # 1: By 
    # 2: Element
    if ($PSBoundParameters.ContainsKey('ConditionValue')) {
        $ConditionValueType = $Script:SeElementsConditions.Where( { $_.Text -eq $Condition }, 'first')[0].ValueType
        if ($null -eq $ConditionValueType) {
            Throw "The condition $Condition do not accept value"
        }
        elseif ($ConditionValue -isnot $ConditionValueType) {
            Throw "The condition $Condition accept only value of type $ConditionValueType. The value provided was of type $($ConditionValue.GetType())"
        }
        else {
            return $true      
        }
    }
}


Function Get-SeElementsConditionsValidation {
    [CmdletBinding()]
    Param($By, $Condition) 

    $SearchBy = 2
    if ($null -ne $By) { $SearchBy = 1 }
   
    return $Script:SeElementsConditions.where( { $_.Text -like $Condition -and $_.By_Element -in @(0, $SearchBy) }).count -eq 1
}
#endregion



#region SizePoint Transformation
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
                    [System.Drawing.Size]::new($sp[0],$sp[1]) 
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
                    [System.Drawing.Point]::new($sp[0],$sp[1]) 
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
#endregion