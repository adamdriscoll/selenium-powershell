
class ValidateURIAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
    [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        $Out = $null
        if   ([uri]::TryCreate($arguments,[System.UriKind]::Absolute, [ref]$Out)) {return}
        else {throw  [System.Management.Automation.ValidationMetadataException]::new('Incorrect StartURL please make sure the URL starts with http:// or https://')}
        return
    }
}

class ValidateIsWebDriverAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
    [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        if ($arguments -isnot [OpenQA.Selenium.Remote.RemoteWebDriver]) {
                throw  [System.Management.Automation.ValidationMetadataException]::new('Target was not a valid web driver')
        }
        return
    }
}

#Allow BY to shorten cssSelector, ClassName, LinkText, and TagName
class ByTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute  {
    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object] $InputData) {
        if ($inputData -match 'CssSelector|Name|Id|ClassName|LinkText|PartialLinkText|TagName|XPath') {
            return $InputData
        }
        switch -regex ($InputData) {
            "^css"    {return 'CssSelector'; break}
            "^class"  {return 'ClassName'  ; break}
            "^link"   {return 'LinkText'   ; break}
            "^tag"    {return 'TagName'    ; break}
        }
        return $InputData
    }
}

#Allow operator to use containing, matching, matches, equals etc.
class OperatorTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute  {
    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object] $InputData) {
        if ($inputData -match '^(contains|like|notlike|match|notmatch|eq|ne|gt|lt)$#') {
            return $InputData
        }
        switch -regex ($InputData) {
            "^contain"    {return 'contains' ; break}
            "^match"      {return 'match'    ; break}
            "^n\w*match"  {return 'notmatch' ; break}
            "^eq"         {return 'eq'       ; break}
            "^n\w*eq"     {return 'ne'       ; break}
        }
        return $InputData
    }
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
"@ -ReferencedAssemblies $dll1Path,$dll2Path, mscorlib
