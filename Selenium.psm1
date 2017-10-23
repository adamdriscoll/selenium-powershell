[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\WebDriver.Support.dll")

<#
.SYNOPSIS
Starts a Selenium Chrome driver

.DESCRIPTION
Starts a Selenium Chrome driver

.EXAMPLE
Start-SeChrome
#>
function Start-SeChrome {
    New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver"
}

<#
.SYNOPSIS
Starts a Selenium Firefox driver

.DESCRIPTION
Starts a Selenium Firefox driver

.EXAMPLE
Start-SeFirefox
#>
function Start-SeFirefox {
    New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver"
}
<#
.SYNOPSIS
Starts a Selenium Edge driver

.DESCRIPTION
Starts a Selenium Edge driver

.EXAMPLE
Start-SeEdge
#>
function Start-SeEdge {
    New-Object -TypeName "OpenQA.Selenium.Edge.EdgeDriver"
}

<#
.SYNOPSIS
Starts a Selenium Internet Explorer driver

.DESCRIPTION
Starts a Selenium Internet Explorer driver

.EXAMPLE
Start-SeInternetExplorer
#>
function Start-SeInternetExplorer {
    New-Object -TypeName "OpenQA.Selenium.IE.InternetExplorerDriver"
}


<#
.SYNOPSIS
Stops a Selenium driver.

.DESCRIPTION
Stops a Selenium driver.

.PARAMETER Driver
The driver to stop.
#>
function Stop-SeDriver {
    param([OpenQA.Selenium.IWebDriver]$Driver) 

    $Driver.Dispose()
}

<#
.SYNOPSIS
Navigates to a url.

.DESCRIPTION
Navigates to a url.

.PARAMETER Driver
The driver to navigate with. See Start-SeChrome and Start-SeFirefox.

.PARAMETER Url
The URL to navigate to. 

.EXAMPLE
Enter-SeUrl -Url https://www.google.com -Driver (Start-SeChrome)
#>

function Enter-SeUrl {
    param([OpenQA.Selenium.IWebDriver]$Driver, $Url)

    $Driver.Navigate().GoToUrl($Url)
}

<#
.SYNOPSIS
Find an element in the currently loaded page.

.DESCRIPTION
Find an element in the currently loaded page.

.PARAMETER Driver
The driver to navigate with. See Start-SeChrome and Start-SeFirefox.

.PARAMETER Name
The name of the element to find. 

.PARAMETER Id
The Id of the element to find. 

.PARAMETER ClassName
The ClassName of the element to find. 

.PARAMETER LinkText
The LinkText of the element to find. 

.EXAMPLE
$Element = Find-SeElement -Driver $Driver -Id "MyTextbox"
#>
function Find-SeElement {
    param(
        [Parameter()]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [Parameter(ParameterSetName = "ByName")]
        $Name,
        [Parameter(ParameterSetName = "ById")]
        $Id,
        [Parameter(ParameterSetName = "ByClassName")]
        $ClassName,
        [Parameter(ParameterSetName = "ByLinkText")]
        $LinkText)

    Process {
        if ($PSCmdlet.ParameterSetName -eq "ByName") {
            $Driver.FindElement([OpenQA.Selenium.By]::Name($Name))
        }

        if ($PSCmdlet.ParameterSetName -eq "ById") {
            $Driver.FindElement([OpenQA.Selenium.By]::Id($Id))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
            $Driver.FindElement([OpenQA.Selenium.By]::LinkText($LinkText))
        }

        if ($PSCmdlet.ParameterSetName -eq "ByClassName") {
            $Driver.FindElement([OpenQA.Selenium.By]::ClassName($ClassName))
        }
    }
}

<#
.SYNOPSIS
Clicks an element

.DESCRIPTION
Clicks an element

.PARAMETER Element
The element to click.

.EXAMPLE
Invoke-SeClick -Element $Element
#>
function Invoke-SeClick {
    param([OpenQA.Selenium.IWebElement]$Element)

    $Element.Click()
}

function Invoke-SeNavigateBack {
    param(
        [Parameter()]
        [OpenQA.Selenium.IWebDriver]$Driver)

        $Driver.Navigate.Back()
}

function Invoke-SeNavigateForward {
    param(
        [Parameter()]
        [OpenQA.Selenium.IWebDriver]$Driver)

        $Driver.Navigate.Forward()
}

function Invoke-SeRefresh {
    param(
        [Parameter()]
        [OpenQA.Selenium.IWebDriver]$Driver)

        $Driver.Navigate.Refresh()
}


<#
.SYNOPSIS
Sends keys to an element

.DESCRIPTION
Sends keys to an element

.PARAMETER Element
The element to send keys to. 

.PARAMETER Keys
The keys to send.

.EXAMPLE
Send-SeKeys -Element $Element -Keys "Hey, there!"
#>
function Send-SeKeys {
    param([OpenQA.Selenium.IWebElement]$Element, [string]$Keys)

    $Element.SendKeys($Keys)
}