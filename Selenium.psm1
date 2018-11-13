[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\WebDriver.Support.dll")

function Start-SeChrome {
    New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver"
}

function Start-SeIe {
    New-Object -TypeName "OpenQA.Selenium.IE.InternetExplorerDriver"
}

function Start-SeFirefox {
    param([Switch]$Profile)

    if ($Profile) {
        #Doesn't work....
        $ProfilePath = Join-Path $PSScriptRoot "Assets\ff-profile\rust_mozprofile.YwpEBLY3hCRX"
        $firefoxProfile = New-Object OpenQA.Selenium.Firefox.FirefoxProfile -ArgumentList ($ProfilePath)
        $firefoxProfile.WriteToDisk()
        New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver" -ArgumentList $firefoxProfile
    }
    else {
        $Driver = New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver"
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(10)
        $Driver
    }
    
}

function Stop-SeDriver {
    param($Driver) 

    $Driver.Dispose()
}

function Enter-SeUrl {
    param($Driver, $Url)

    $Driver.Navigate().GoToUrl($Url)
}

function Find-SeElement {
    param(
        [Parameter()]
        $Driver,
        [Parameter()]
        $Element,
        [Parameter(ParameterSetName = "ByName")]
        $Name,
        [Parameter(ParameterSetName = "ById")]
        $Id,
        [Parameter(ParameterSetName = "ByClassName")]
        $ClassName,
        [Parameter(ParameterSetName = "ByLinkText")]
        $LinkText,
        [Parameter(ParameterSetName = "ByTagName")]
        $TagName,
        [Parameter(ParameterSetName = "ByXPath")]
        $XPath,
        [Parameter(ParameterSetName = "ByCssSelector")]
        $Css)

    Process {

        if ($Driver -ne $null -and $Element -ne $null) {
            throw "Driver and Element may not be specified together."
        }
        elseif ($Driver -ne $Null) {
            $Target = $Driver
        }
        elseif ($Element -ne $Null) {
            $Target = $Element
        }
        else {
            "Driver or element must be specified"
        }

        if ($PSCmdlet.ParameterSetName -eq "ByName") {
            $Target.FindElements([OpenQA.Selenium.By]::Name($Name))
        }

        if ($PSCmdlet.ParameterSetName -eq "ById") {
            $Target.FindElements([OpenQA.Selenium.By]::Id($Id))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
            $Target.FindElements([OpenQA.Selenium.By]::LinkText($LinkText))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByClassName") {
            $Target.FindElements([OpenQA.Selenium.By]::ClassName($ClassName))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByTagName") {
            $Target.FindElements([OpenQA.Selenium.By]::TagName($TagName))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByXPath") {
            $Target.FindElements([OpenQA.Selenium.By]::XPath($XPath))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByCss") {
            $Target.FindElements([OpenQA.Selenium.By]::CssSelector($Css))
        }
    }
}

function Invoke-SeClick {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter()]
        [Switch]$JavaScriptClick,
        [Parameter()]
        $Driver
        )

    if ($JavaScriptClick) {
        $Driver.ExecuteScript("arguments[0].click()", $Element)
    } else {
        $Element.Click()
    }

}

function Send-SeKeys {
    param([OpenQA.Selenium.IWebElement]$Element, [string]$Keys)

    $Element.SendKeys($Keys)
}

function Get-SeCookie {
    param($Driver)

    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}

function Remove-SeCookie {
    param($Driver)
    
    $Driver.Manage().Cookies.DeleteAllCookies()
}

function Set-SeCookie {
    param($Driver, $name, $value)

    $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$value
    
    $Driver.Manage().Cookies.AddCookie($cookie)
}

function Get-SeElementAttribute {
    param(
        [Parameter(ValueFromPipeline=$true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory=$true)]
        [string]$Attribute
    )

    Process {
        $Element.GetAttribute($Attribute)
    }   
}

function Invoke-SeScreenshot {
    param($Driver, [Switch]$AsBase64EncodedString)

    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver)
    if ($AsBase64String) {
        $Screenshot.AsBase64EncodedString
    }
}

function Save-SeScreenshot {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.Screenshot]$Screenshot,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter()]
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png)

        Process {
            $Screenshot.SaveAsFile($Path, $ImageFormat)
        }
}
