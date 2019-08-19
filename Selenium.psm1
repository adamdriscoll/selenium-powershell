[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\WebDriver.Support.dll")

if($IsLinux){
    $AssembliesPath = "$PSScriptRoot/assemblies/linux"
}
elseif($IsMacOS){
    $AssembliesPath = "$PSScriptRoot/assemblies/macos"
}

function Start-SeChrome {
    Param(
        [Parameter(Mandatory = $false)]
        [array]$Arguments,
        [switch]$HideVersionHint,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [bool]$DisableBuiltInPDFViewer=$true,
        [switch]$Headless,
        [switch]$Incognito,
        [switch]$Maximized
    )

    $Chrome_Options = New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeOptions"
    
    if($DefaultDownloadPath){
        Write-Host "Setting Default Download directory: $DefaultDownloadPath"
        $Chrome_Options.AddUserProfilePreference('download', @{'default_directory' = $($DefaultDownloadPath.FullName); 'prompt_for_download' = $false; })
    }
    
    if($DisableBuiltInPDFViewer){
       $Chrome_Options.AddUserProfilePreference('plugins', @{'always_open_pdf_externally' =  $true;})
    }
    
    if ($Headless) {
        $Chrome_Options.AddArguments('headless')
    }

    if ($Incognito) {
        $Chrome_Options.AddArguments('Incognito')
    }

    if ($Maximized) {
        $Chrome_Options.AddArguments('start-maximized')
    }

    if ($Arguments) {
        $Chrome_Options.AddArguments($Arguments)
    }
    
    if (!$HideVersionHint) {
        Write-Host "Download the right chromedriver from 'http://chromedriver.chromium.org/downloads'" -ForegroundColor Yellow
    }

    if($IsLinux -or $IsMacOS){
        New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver" -ArgumentList $AssembliesPath,$Chrome_Options
    }
    else{
        New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver" -ArgumentList $Chrome_Options 
    }
}

function Start-SeInternetExplorer {
    $InternetExplorer_Options = New-Object -TypeName "OpenQA.Selenium.IE.InternetExplorerOptions"
    $InternetExplorer_Options.IgnoreZoomLevel = $true
    New-Object -TypeName "OpenQA.Selenium.IE.InternetExplorerDriver" -ArgumentList $InternetExplorer_Options 
}

function Start-SeEdge {
    New-Object -TypeName "OpenQA.Selenium.Edge.EdgeDriver"
}

function Start-SeFirefox {
    param([Switch]$Profile)

    if ($Profile) {
        #Doesn't work....
        $ProfilePath = Join-Path $PSScriptRoot "Assets\ff-profile\rust_mozprofile.YwpEBLY3hCRX"
        $firefoxProfile = New-Object OpenQA.Selenium.Firefox.FirefoxProfile -ArgumentList ($ProfilePath)
        $firefoxProfile.WriteToDisk()
        if($IsLinux -or $IsMacOS){
            New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver" -ArgumentList $AssembliesPath,$firefoxProfile
        }
        else{
            New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver" -ArgumentList $firefoxProfile
        }
    }
    else {
        if($IsLinux -or $IsMacOS){
            $Driver = New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver" -ArgumentList $AssembliesPath
        }
        else{
            $Driver = New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver"
        }
    }
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(10)
    $Driver
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
        [Parameter()][Switch]$Wait,
        [Parameter()]$Timeout = 30,
        [Parameter(ParameterSetName = "ByCss")]
        $Css,
        [Parameter(ParameterSetName = "ByName")]
        $Name,
        [Parameter(ParameterSetName = "ById")]
        $Id,
        [Parameter(ParameterSetName = "ByClassName")]
        $ClassName,
        [Parameter(ParameterSetName = "ByLinkText")]
        $LinkText,
        [Parameter(ParameterSetName = "ByPartialLinkText")]
        $PartialLinkText,
        [Parameter(ParameterSetName = "ByTagName")]
        $TagName,
        [Parameter(ParameterSetName = "ByXPath")]
        $XPath
        )


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

        if($Wait){
            if ($PSCmdlet.ParameterSetName -eq "ByName") {
                $TargetElement = [OpenQA.Selenium.By]::Name($Name)
            }

            if ($PSCmdlet.ParameterSetName -eq "ById") {
                $TargetElement = [OpenQA.Selenium.By]::Id($Id)
            }
            
            if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
                $TargetElement = [OpenQA.Selenium.By]::LinkText($LinkText)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByPartialLinkText") {
                $TargetElement = [OpenQA.Selenium.By]::PartialLinkText($PartialLinkText)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByClassName") {
                $TargetElement = [OpenQA.Selenium.By]::ClassName($ClassName)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByTagName") {
                $TargetElement = [OpenQA.Selenium.By]::TagName($TagName)
            }
            
            if ($PSCmdlet.ParameterSetName -eq "ByXPath") {
                $TargetElement = [OpenQA.Selenium.By]::XPath($XPath)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByCss") {
                $TargetElement = [OpenQA.Selenium.By]::CssSelector($Css)
            }
            
            $WebDriverWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($Driver, (New-TimeSpan -Seconds $Timeout))
            $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
            $WebDriverWait.Until($Condition)
        }
        else{
            if ($PSCmdlet.ParameterSetName -eq "ByName") {
                $Target.FindElements([OpenQA.Selenium.By]::Name($Name))
            }

            if ($PSCmdlet.ParameterSetName -eq "ById") {
                $Target.FindElements([OpenQA.Selenium.By]::Id($Id))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
                $Target.FindElements([OpenQA.Selenium.By]::LinkText($LinkText))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByPartialLinkText") {
                $Target.FindElements([OpenQA.Selenium.By]::PartialLinkText($PartialLinkText))
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
    }
    else {
        $Element.Click()
    }

}

function Get-SeKeys {
    
    [OpenQA.Selenium.Keys] | Get-Member -MemberType Property -Static | Select-Object -Property Name, @{N = "ObjectString"; E = { "[OpenQA.Selenium.Keys]::$($_.Name)" } }
}

function Send-SeKeys {
    param([OpenQA.Selenium.IWebElement]$Element, [string]$Keys)
    
    foreach ($Key in @(Get-SeKeys).Name) {
        $Keys = $Keys -replace "{{$Key}}", [OpenQA.Selenium.Keys]::$Key
    }
    
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
    param(
        $Driver, 
        [string]$Name, 
        [string]$Value,
        [string]$Path,
        [string]$Domain,
        [datetime]$ExpiryDate
        )

    <# Selenium Cookie Information
    Cookie(String, String)
    Initializes a new instance of the Cookie class with a specific name and value.
    Cookie(String, String, String)
    Initializes a new instance of the Cookie class with a specific name, value, and path.
    Cookie(String, String, String, Nullable<DateTime>)
    Initializes a new instance of the Cookie class with a specific name, value, path and expiration date.
    Cookie(String, String, String, String, Nullable<DateTime>)
    Initializes a new instance of the Cookie class with a specific name, value, domain, path and expiration date. 
    #>

    if($Name -and $Value -and (!$Path -and !$Domain -and !$ExpiryDate)){
        $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value
    }
    Elseif($Name -and $Value -and $Path -and (!$Domain -and !$ExpiryDate)){
        $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value,$Path
    }
    Elseif($Name -and $Value -and $Path -and $ExpiryDate -and !$Domain){
        $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value,$Path,$ExpiryDate
    }
    Elseif($Name -and $Value -and $Path -and $ExpiryDate -and $Domain){
        if($Driver.Url -match $Domain){
            $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value,$Domain,$Path,$ExpiryDate
        }
        else{
            Throw 'In order to set the cookie the browser needs to be on the cookie domain URL'
        }
    }
    else{
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

function Get-SeElementAttribute {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string]$Attribute
    )

    Process {
        $Element.GetAttribute($Attribute)
    }   
}

function Invoke-SeScreenshot {
    param($Driver, [Switch]$AsBase64EncodedString)

    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver)
    if ($AsBase64EncodedString) {
        $Screenshot.AsBase64EncodedString
    }
    else {
        $Screenshot
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

function Get-SeWindow {
    param(
        [Parameter(Mandatory = $true)][OpenQA.Selenium.IWebDriver]$Driver
    )

    Process {
        $Driver.WindowHandles
    }   
}

function Switch-SeWindow {
    param(
        [Parameter(Mandatory = $true)][OpenQA.Selenium.IWebDriver]$Driver,
        [Parameter(Mandatory = $true)]$Window
    )

    Process {
        $Driver.SwitchTo().Window($Window)|Out-Null
    }   
}
