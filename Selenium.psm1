[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\WebDriver.Support.dll")

function Start-SeChrome {
    New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver"
}

function Start-SeFirefox {
    New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver"
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
        $TagName)

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
    }
}

function Invoke-SeClick {
    param([OpenQA.Selenium.IWebElement]$Element)

    $Element.Click()
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