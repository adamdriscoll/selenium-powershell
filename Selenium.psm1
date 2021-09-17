[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\WebDriver.Support.dll")
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\assemblies\HtmlAgilityPack.dll")

if($IsLinux){
    $AssembliesPath = "$PSScriptRoot/assemblies/linux"
}
elseif($IsMacOS){
    $AssembliesPath = "$PSScriptRoot/assemblies/macos"
}

# Grant Execution permission to assemblies on Linux and MacOS 
if($IsLinux -or $IsMacOS){
    # Check if powershell is NOT running as root
    $AssemblieFiles = Get-ChildItem -Path $AssembliesPath |Where-Object{$_.Name -eq 'chromedriver' -or $_.Name -eq 'geckodriver'}
    foreach($AssemblieFile in $AssemblieFiles){
        if($IsLinux){
            $FileMod = stat -c "%a" $AssemblieFile.fullname
        }
        elseif($IsMacOS){
            $FileMod = /usr/bin/stat -f "%A" $AssemblieFile.fullname
        }

        if($FileMod[2] -ne '5' -and $FileMod[2] -ne '7' ){
            Write-Host "Granting $($AssemblieFile.fullname) Execution Permissions ..."
            chmod +x $AssemblieFile.fullname
        }
    }
}


#region htmlagilitypack

function Init-HTMLAgilityPack {
    [CmdletBinding()]
    param ($Element)
    
    # Initialize the Selenium Driver
    $driver = Init-SeDriver -Element $Element
    Refresh-HTMLAgilityPackSource -Driver $driver

}

function Refresh-HTMLAgilityPackSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Driver
    )

    process {
        # If the Driver Page Source is $null, skip
        if ($Null -eq $Driver.PageSource) {
            $Driver.HTMLAgilityPackDocument = $null 
        } else {
            $Driver.HTMLAgilityPackDocument.LoadHtml($Driver.PageSource)
        }

    }

}

function Get-SeHTMLAgilityPack {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Driver
    )
        
    process {
        return $Driver.HTMLAgilityPackDocument
    }
    
}

function Refresh-SeHTMLAgilityPack {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Driver
    )

    process {
        Refresh-HTMLAgilityPackSource -Driver $Driver
    }
    
    end {

        if ($null -eq $Driver.HTMLAgilityPackDocument) {
            Throw ([System.InvalidOperationException]::new("Missing Selenium HTML Driver. Please Start the Selenium Driver prior to invoking the HTMLAgilityPack."))
        }

        return $Driver.HTMLAgilityPackDocument

    }

}

function Get-SeChildElements {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]
        $Element
    )

    if ($null -eq $Element.WrappedHTMLAgilityPackElement) {
        Throw "HTMLAgilityPack was not loaded or could not be matched to this element."
    }

    if ($null -ne $Element.WrappedHTMLAgilityPackElement.ChildNodes.XPath) {
        $Element.WrappedHTMLAgilityPackElement.ChildNodes.XPath | Where-Object {
            # Exclude all '#text' SeElements.
            $_ -notmatch '\/#[a-z\[\0-9\]]+\z$'
        } | ForEach-Object {
            Find-SeElement -Element $Element.WrappedDriver -XPath $_
        }
    }
    
}

function Get-SeParentElement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]
        $Element
    )

    if ($null -eq $Element.WrappedHTMLAgilityPackElement) {
        Throw "HTMLAgilityPack was not loaded or could not be matched to this element."
    }

    if ($null -ne $Element.WrappedHTMLAgilityPackElement.ParentNode.XPath) {
        Find-SeElement -Element $Element.WrappedDriver -XPath $Element.WrappedHTMLAgilityPackElement.ParentNode.XPath
    }
    
}

#endregion htmlagilitypack

function Validate-URL{
    param(
        [Parameter(Mandatory=$true)]$URL
    )
    $Out = $null
    [uri]::TryCreate($URL,[System.UriKind]::Absolute, [ref]$Out)
}

function Start-SeChrome {
    Param(
        [Parameter(Mandatory = $false)]
        [array]$Arguments,
        [switch]$HideVersionHint,
        [string]$StartURL,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [System.IO.FileInfo]$ProfileDirectoryPath,
        [bool]$DisableBuiltInPDFViewer=$true,
        [switch]$Headless,
        [switch]$Incognito,
        [switch]$Maximized,
        [switch]$Minimized,
        [switch]$Fullscreen,
        [System.IO.FileInfo]$ChromeBinaryPath,

        [ValidateScript({  if ($_) {Test-Path -Path $_ -PathType Container}  })]
        [string]$DriverPath
    )

    BEGIN{
        if($Maximized -ne $false -and $Minimized -ne $false){
            throw 'Maximized and Minimized may not be specified together.'
        }
        elseif($Maximized -ne $false -and $Fullscreen -ne $false){
            throw 'Maximized and Fullscreen may not be specified together.'
        }
        elseif($Minimized -ne $false -and $Fullscreen -ne $false){
            throw 'Minimized and Fullscreen may not be specified together.'
        }

        if($StartURL){
            if(!(Validate-URL -URL $StartURL)){
                throw 'Incorrect StartURL please make sure the URL starts with http:// or https://'
            }
        }
    }
    PROCESS{
        $Chrome_Options = New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeOptions"
    
        if($DefaultDownloadPath){
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Chrome_Options.AddUserProfilePreference('download', @{'default_directory' = $($DefaultDownloadPath.FullName); 'prompt_for_download' = $false; })
        }

        if($ProfileDirectoryPath){
            Write-Verbose "Setting Profile directory: $ProfileDirectoryPath"
            $Chrome_Options.AddArgument("user-data-dir=$ProfileDirectoryPath")
        }
        
        if($ChromeBinaryPath){
            Write-Verbose "Setting Chrome Binary directory: $ChromeBinaryPath"
            $Chrome_Options.BinaryLocation ="$ChromeBinaryPath"
        }
        

        if($DisableBuiltInPDFViewer){
            $Chrome_Options.AddUserProfilePreference('plugins', @{'always_open_pdf_externally' =  $true;})
        }
        
        if($Headless){
            $Chrome_Options.AddArguments('headless')
        }

        if($Incognito){
            $Chrome_Options.AddArguments('Incognito')
        }

        if($Maximized){
            $Chrome_Options.AddArguments('start-maximized')
        }

        if($Fullscreen){
            $Chrome_Options.AddArguments('start-fullscreen')
        }

        if($Arguments){
            foreach ($Argument in $Arguments){
                $Chrome_Options.AddArguments($Argument)
            }
        }
        
        if(!$HideVersionHint){
            Write-Verbose "Download the right chromedriver from 'http://chromedriver.chromium.org/downloads'"
        }

        if ($DriverPath){
            $Driver = New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver" -ArgumentList $DriverPath,$Chrome_Options
        }
        elseif($IsLinux -or $IsMacOS){
            $Driver = New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver" -ArgumentList $AssembliesPath,$Chrome_Options
        }
        else{
            $Driver = New-Object -TypeName "OpenQA.Selenium.Chrome.ChromeDriver" -ArgumentList $Chrome_Options
        }

        if($Minimized -and $Driver){
            $driver.Manage().Window.Minimize();
        }

        if($Headless -and $DefaultDownloadPath -and $Driver){
            $HeadlessDownloadParams = New-Object 'system.collections.generic.dictionary[[System.String],[System.Object]]]'
            $HeadlessDownloadParams.Add('behavior', 'allow')
            $HeadlessDownloadParams.Add('downloadPath', $DefaultDownloadPath.FullName)
            $Driver.ExecuteChromeCommand('Page.setDownloadBehavior', $HeadlessDownloadParams)
        }

        # Add the HTML Agility Pack into the Driver
        $mp = @{InputObject = $Driver ; MemberType = 'NoteProperty' }
        Add-Member @mp -Name 'HTMLAgilityPackDocument' -Value ([HtmlAgilityPack.HtmlDocument]::New())

        if($StartURL -and $Driver){
            Enter-SeUrl -Driver $Driver -Url $StartURL
            Refresh-HTMLAgilityPackSource -Driver $Driver
        }
    }
    END{
        return $Driver
    }
}

function Start-SeInternetExplorer {
    $InternetExplorer_Options = New-Object -TypeName "OpenQA.Selenium.IE.InternetExplorerOptions"
    $InternetExplorer_Options.IgnoreZoomLevel = $true
    New-Object -TypeName "OpenQA.Selenium.IE.InternetExplorerDriver" -ArgumentList $InternetExplorer_Options 
}

function Start-SeEdge {
    
    $Driver = [OpenQA.Selenium.Edge.EdgeDriver]::New()

    # Add the HTML Agility Pack into the Driver
    $mp = @{InputObject = $Driver ; MemberType = 'NoteProperty' }
    Add-Member @mp -Name 'HTMLAgilityPackDocument' -Value ([HtmlAgilityPack.HtmlDocument]::New())
    Refresh-HTMLAgilityPackSource -Driver $Driver

    return $Driver

}

function Start-SeFirefox {
    param(
        [array]$Arguments,
        [string]$StartURL,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$Headless,
        [switch]$PrivateBrowsing,
        [switch]$Maximized,
        [switch]$Minimized,
        [switch]$Fullscreen,
        [switch]$SuppressLogging
    )

    BEGIN{
        if($Maximized -ne $false -and $Minimized -ne $false){
            throw 'Maximized and Minimized may not be specified together.'
        }
        elseif($Maximized -ne $false -and $Fullscreen -ne $false){
            throw 'Maximized and Fullscreen may not be specified together.'
        }
        elseif($Minimized -ne $false -and $Fullscreen -ne $false){
            throw 'Minimized and Fullscreen may not be specified together.'
        }

        if($StartURL){
            if(!(Validate-URL -URL $StartURL)){
                throw 'Incorrect StartURL please make sure the URL starts with http:// or https://'
            }
        }
    }
    PROCESS{
        $Firefox_Options = New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxOptions"

        if($Headless){
            $Firefox_Options.AddArguments('-headless')
        }

        if($DefaultDownloadPath){
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Firefox_Options.setPreference("browser.download.folderList",2);
            $Firefox_Options.SetPreference("browser.download.dir", "$DefaultDownloadPath");
        }
        
        if($PrivateBrowsing){
            $Firefox_Options.SetPreference("browser.privatebrowsing.autostart", $true)
        }

        if($Arguments){
            foreach ($Argument in $Arguments){
                $Firefox_Options.AddArguments($Argument)
            }
        }

        if($SuppressLogging){
            # Sets GeckoDriver log level to Fatal.
            $Firefox_Options.LogLevel = 6
        }

        if($IsLinux -or $IsMacOS){
            $Driver = New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver" -ArgumentList $AssembliesPath,$Firefox_Options
        }
        else{
            $Driver = New-Object -TypeName "OpenQA.Selenium.Firefox.FirefoxDriver" -ArgumentList $Firefox_Options
        }

        if($Driver){
            $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(10)
        }

        if($Minimized -and $Driver){
            $Driver.Manage().Window.Minimize()
        }

        if($Maximized -and $Driver){
            $Driver.Manage().Window.Maximize()
        }

        if($Fullscreen -and $Driver){
            $Driver.Manage().Window.FullScreen()
        }

        # Add the HTML Agility Pack into the Driver
        $mp = @{InputObject = $Driver ; MemberType = 'NoteProperty' }
        Add-Member @mp -Name 'HTMLAgilityPackDocument' -Value ([HtmlAgilityPack.HtmlDocument]::New())

        if($StartURL -and $Driver){
            Enter-SeUrl -Driver $Driver -Url $StartURL
            Refresh-HTMLAgilityPackSource -Driver $Driver
        }
    }
    END{
        return $Driver
    }
}

function Stop-SeDriver {
    param($Driver) 

    $Driver.Dispose()
}

function Enter-SeUrl {
    param($Driver, $Url)

    $Driver.Navigate().GoToUrl($Url)

    # Refresh the HTMLAgilityPack with all the amzaing goodness!
    Refresh-HTMLAgilityPackSource -Driver $Driver    

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
        $XPath,
        [Parameter(ParameterSetName = "ByText")]
        $Text
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

        Try {

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

                if ($PSCmdlet.ParameterSetName -eq 'ByText') {
                    $XPath = "//*[contains(text(), '$Text')]"
                    $TargetElement = [OpenQA.Selenium.By]::XPath($XPath)
                }
                
                $WebDriverWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($Driver, (New-TimeSpan -Seconds $Timeout))
                $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
                $output = $WebDriverWait.Until($Condition)
            }
            else
            {
                if ($PSCmdlet.ParameterSetName -eq "ByName") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::Name($Name))
                }
    
                if ($PSCmdlet.ParameterSetName -eq "ById") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::Id($Id))
                }
    
                if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::LinkText($LinkText))
                }
    
                if ($PSCmdlet.ParameterSetName -eq "ByPartialLinkText") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::PartialLinkText($PartialLinkText))
                }
    
                if ($PSCmdlet.ParameterSetName -eq "ByClassName") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::ClassName($ClassName))
                }
    
                if ($PSCmdlet.ParameterSetName -eq "ByTagName") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::TagName($TagName))
                }
    
                if ($PSCmdlet.ParameterSetName -eq "ByXPath") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::XPath($XPath))
                }
                
                if ($PSCmdlet.ParameterSetName -eq "ByCss") {
                    $output = $Target.FindElements([OpenQA.Selenium.By]::CssSelector($Css))
                }

                if ($PSCmdlet.ParameterSetName -eq 'ByText') {
                    $XPath = "//*[contains(text(), '$Text')]"
                    $output = $Target.FindElements([OpenQA.Selenium.By]::XPath($XPath))
                }

            }

            # Append the HTMLAgilityPack Object into the resulting element         
            Refresh-HTMLAgilityPackSource -Driver $Target

            if ($output) {

                $xpathQuery = $(
                    switch ($output) {

                        # Append ID into XPathQuery if there is an ID. Strict match.
                        {$Id} {
                            '//*[@id="{0}"]' -f $_.GetAttribute('Id') 
                            break
                        }

                        # Perform Literal lookup if using XPath in the lookup                    
                        {$XPath} { $XPath; break }

                        # Provided that there is a class and a tagname, perform a loose match within XPath
                        {$null -ne $_.Tagname -and $null -ne $_.GetAttribute('Class')} {
                            '//*/{0}[@class="{1}"]' -f $_.Tagname, $_.GetAttribute('Class')
                            break
                        }

                        # No match could be found.
                        default { 
                            Write-Error "Could not match the HTMLAgilityPack object with the Selenium Element."
                            $null
                        }

                    }
                )

                $null = $output | Add-Member -MemberType NoteProperty -Name 'WrappedHTMLAgilityPackElement' -Value ($output.WrappedDriver.HTMLAgilityPackDocument.DocumentNode.SelectSingleNode($xpathQuery))
                                 
            }

        } Catch {
            
            Write-Error $_
            return $null

        }
    
        # Return
        return $Output

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

    Refresh-HTMLAgilityPackSource -Driver $Element.WrappedDriver

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

    Refresh-HTMLAgilityPackSource -Driver $Element.WrappedDriver
}

function Get-SeCookie {
    param($Driver)

    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}

function Remove-SeCookie {
    param(
        $Driver,
        [switch]$DeleteAllCookies,
        [string]$Name
    )

    if($DeleteAllCookies){
        $Driver.Manage().Cookies.DeleteAllCookies()
    }
    else{
        $Driver.Manage().Cookies.DeleteCookieNamed($Name)
    }
}

function Set-SeCookie {
    param(
        [ValidateNotNull()]$Driver, 
        [string]$Name,
        [string]$Value,
        [string]$Path,
        [string]$Domain,
        $ExpiryDate
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
    Begin{
        if($ExpiryDate -ne $null -and $ExpiryDate.GetType().Name -ne 'DateTime'){
            throw '$ExpiryDate can only be $null or TypeName: System.DateTime'
        }
    }

    Process {
        if($Name -and $Value -and (!$Path -and !$Domain -and !$ExpiryDate)){
            $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value
        }
        Elseif($Name -and $Value -and $Path -and (!$Domain -and !$ExpiryDate)){
            $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value,$Path
        }
        Elseif($Name -and $Value -and $Path -and $ExpiryDate -and !$Domain){
            $cookie = New-Object -TypeName OpenQA.Selenium.Cookie -ArgumentList $Name,$Value,$Path,$ExpiryDate
        }
        Elseif($Name -and $Value -and $Path -and $Domain -and (!$ExpiryDate -or $ExpiryDate)){
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
