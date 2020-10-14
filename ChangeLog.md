


# 4.0.0-preview1 (Prerelease)
Note: V4 have an enormous amount of breakchanges. Most of the cmdlet have been rewriten in a way or another.
Important changes includes, but are not limited to: 
- Removing all aliases and duplicate functions
- Removal of -AsDefaultDriver and $Driver parameter in favor of an internal implementation which make the last driver started the active driver. Should you need to switch between 1 or more driver, this can be accomplished through the Switch-SeDriver cmdlet.

  
## Added
- Convert-toSeSelenium to convert IDE projects to Selenium-Powershell script
- Update-SeDriver to download the latest driver (Support only Chrome currently)
- Support for UserAgent in Start-SeDriver (#91)
- New view for IwebDriver (#111). IWebDriver will now display as a table in the console by default instead of a list.
- Get-SeElement - New view. Elements will now be returned in a table view to show the essential only. This make it significantly easier to deal with elements in the console interactively (#115)
- Get-SeElement - Bychained support. The cmdlet will now drilldown when multiple by / value are provided to allow for instance the selection of links in a div containing a specific classname. This is an alternative for those less savy with Xpath  (#116)
- Get-SeHtml - Allow the retrieval of the html of an element (or driver is no element is provided). Essentially a wrapper around $Element.GetAttribute('xxHTML') (xx: Inner /Outer) (#118)
- New-SeDriverService - Allow the creation of a driver service to be used later on with Start-SeDriver. Only useful if you need to do change to the service parameters native object before starting the driver (#119)
- Invoke-SeMouseAction - Support for interactions  (#122)
- Wait-SeDriver / Wait-SeElement expliciti wait support (#125)
- Get-SeElement -Attributes. Allow getting specific attributes (or all using *) to the elements to be returned. Attributes will be available in an Attributes string dictionary attached to each elements.  (#133)
- Position / Size parameter for Start-SeDriver. Allow starting the driver at a specified position and size. If no command line available (or not implemented), the driver will start with the default settings and the be moved. (#134)
- Get-SeElement -Single switch added. Define the expectaction that only one element should be returned (#144)
- Get/Set-SeDriverTimeout - Allow changing driver timeouts easily (#150)
- Invoke-SeJavascript - A wrapper around $Driver.ExecuteScript (#151)
- Get-SeFrame, wrapper around Get-SeElement to show iframe along with their name / id in a convenient view (#159)
- New-SeWindow / Remove-SeWindow cmdlet added to complement the existing Get/Switch  (#170)
- Get-SeInput (#178) - A wrapper around Get-SeElement to get input element.



## Changed
- AsDefaultDriver implementation changed. Instead, Start-SeDriver automatically make the started driver the default. (#93)
- Driver parameter was removed on most cmdleet. It is now expected to use the Switch-SeDriver cmdlet to change the active driver if multiple are open. 
- Start-SeChrome and other have been removed in favor of Start-SeDriver -Browser Chrome (#100)
- #98 Removed duplicate functions that performed the same thing or overlapped significantly
- Removed all the aliases everywhere on all the parameter / functions in favor of a more rigid way of writing things (#99)
- Standardize parameters. Some parameters had different names to mean the same thing (#100)
- Revamp Get-SeSelectionOption. The cmdlet have been separated in 3 cmdlet Get/Clear/Set -SeSelectValue. The get cmdlet will also now return the Text & Value of the selected element instead of the text only. (#112)
- Set-SeUrl now have a -Depth parameter to navigate forward or back x times (#124)
- Get-SeElement now returns visible elements by default. To view hidden elements, the All switch parameter need to be used (#126)
- Start-SeDriver -Quiet parameter removal. Quiet is now the default. This remove the extra Selenium verbose and resolves an issue with Driver not being usable in jobs. (#127)
- Get-SeElement now write an error if no element are returned.  (#135)
- cmdlet that expect urls will now accept urls without protocol defined. Assumptions in these cases is that the url is https thus google.ca will be treated as https://www.google.ca (#153)
- Get-SeElementAttribute - Accept multiple values and wildcard to load all attributes (#161)
- Get-SeElement - support for multiple classname (#160)
- Get-SeElementCssValue - support for multiple values / wildcard character (#162)
- Sleep / Timeout parameters type changed from int to double (Still seconds, but provide more granularity)
- Invoke-SeScreenshot - support for Element screenshot. You can now easily produce a screenshot of a specific element instead of the whole page. (#168)



## Bugfixes
- Get-SeElement no longer support splatting (#82)
- Getck driver abysmal performance (#113). Gecko service need to be configured to use localhost ::1. Otherwise, it take significantly more time to do everything with it (#113)
- Get-SeElement with Timeout return only the first element instead of the collection  (#139)
- Implcit-Wait - Default reduced to 0.3 seconds instead of 10 seconds. One of the problem of implicit wait is that some operation will wait 100% of the defined implicit wait before performing an action. (#146) 
- Implicit / Explicit wait management. Some cmdlet (old an new) uses explicit wait. Explicit wait and Implicit wait should not be mixed together. Therefore, when an explicit wait is used, implicit wait (if present) get temporary disabled(#149)


# 3.1.0 - Unreleased

## Added
- Added -IgnoreProtectedModeSettings to Start-SeInternetExplorer - https://github.com/adamdriscoll/selenium-powershell/issues/79 - Thanks, @MysticRyuujin!

- Added Markdown documentation (See Help subfolder) for all the cmdlets (PlatyPS is used behind the scene to maintain it) 
- Added MAML embedded help that can be accessed through `Get-Help`(eg: `Get-Help Start-SeChrome -Examples`)
- Added Get-SeUrl / Pop-SeUrl / Push-SeUrl / Set-SeUrl (Thanks @vexx32)

## Changed
 - Converted monolythic module into a scaffolded module through a Plaster template. Module will now have a debug version and a compiled version that need to be built with Invoke-Build. See the Debug folder for additional informations on how to debug.

 - Open-SeUrl removed in favor of Set-SeUrl
 - Send-SeKeys won't return an exception if you send $null or empty strings.
 - Stop-SeDriver won't throw exceptions anymore when celled multiple times on a driver already closed.

# 3.0.0 - 3/31/2020

## Changed

- Fixed issue with importing module in PSv5.1 - https://github.com/adamdriscoll/selenium-powershell/issues/69
- Updated Chrome drivers

# 3.0.0-beta2 - 1/29/2020

## Added 

- Added Get-SeElementCssValue

# 3.0.0-beta1 - 1/29/2020

## Added

# General
## Start a Browser Driver for the browser of your choice (Chrome/Firefox/Edge/InternetExplorer)
```powershell
#Either: store the driver in your own variable
$Driver = Start-SeChrome

#OR save it to $global:SeDriver
Start-SeChrome           -AsDefaultDriver  # alias Chrome
Start-SeFirefox          -AsDefaultDriver  # alias Firefox
Start-SeEdge             -AsDefaultDriver  # alias MsEdge
Start-SeNewEdge          -AsDefaultDriver  # alias CrEdge / NewEdge
Start-SeInternetExplorer -AsDefaultDriver  # alias IE / InternetExplorer

#OR use a shortcut which takes a browser name and sets it as the default.
SeOpen -In Chrome
```
in the last case, -in can come an environment variable, to run the same script _n_ times with _n_ different browsers

## Navigate to a page
```powershell
#Use a saved driver and the original function name
Enter-SeUrl https://www.poshud.com -Driver $Driver

#Use the default driver and the new funtion name
Open-SeUrl https://www.poshud.com           #alias SeNavigate

#or Start the driver and navigate in one
Start-SeChrome -AsDefaultDriver -StartURL https://www.poshud.com

#or using SeOpen
SeOpen -URL https://www.poshud.com -In Chrome
```

## Find an Element on the page
```powershell
#Using the saved driver and the old syntax
$Element = Find-SeElement -Driver $Driver -ClassName 'center-align'

#Using the default driver and the new syntax
$Element = Get-SeElement -By ClassName 'center-align'     #alias SeElement

#xpath is selected by default - you can specify a timeout to wait for the element to appear.
$xpath = '/html/body/div[1]/div/main/div/div[2]/div[3]/div[1]/div/div/div[2]/a'
$Element = Get-SeElement $xpath -Timeout 10

#In a Pester Test you can check the element is present with
SeElement $xpath  | should not beNullOrEmpty
#or
SeShouldHave $xpath
```
_SeElement_ and _Find-SeElement_ are aliases for Get-SeElement.

## Click on an Element/Button
```powershell
#send to a saved element with old syntax
Invoke-SeClick -Element $Element

#Pipe an element into the command using new syntax
Get-SeElement $Xpath | Send-SeClick -SleepSeconds 2 #alias SeClick

#in a Pester Test you can get the element, click and confirm a element was found
SeElement $xPath | SeClick -sleep 2 -passthru | should not beNullOrEmpty
```
_Invove-SeClick_ and _Send-SeClick_ are almost interchangable, _SeClick_ is an alias for the latter

## Send Keystrokes

```powershell
#using a saved element
$Element = Find-SeElement -Driver $Driver -Id "txtEmail"
Send-SeKeys -Element $Element -Keys "adam@poshtools.com"

#or using the pipeline
seElement -by ID "txtEmail" | Send-SeKeys -Keys "adam@poshtools.com"

#in a Pester Test you can get the element, sendkeys and confirm a element was found
seElement -by ID "txtEmail" | SeType "adam@poshtools.com" -passthru | should not beNullOrEmpty
```
_setype_ is a wrapper for _Send-SeKeys_ to be more Pester-friendly

# using pester
### Navigating to a page (SeNavigate)

```powershell
    Enter-SeUrl -Url "https://www.powershellgallery.com/" -driver $Global:SeDriver
    #Enter-SeUrl has an alias of SeNavigate, and will assume the driver is $Global:SeDriver, and take URL by position giving
    SeNavigate https://www.powershellgallery.com/
```
### Checking the page url and title (SeShouldHave)

```powershell
    #knowing about the driver we could use it with a standard pester command
    $Global:SeDriver.Url  | should be "https://www.powershellgallery.com/"

    #Or we could use SeShouldHave. The full, explicit form looks like this
    SeShouldHave -URL -Operator eq -Value "https://www.powershellgallery.com/"
    #which can be shorted by passing Operator and Value parameters by position;
    #Operator will tab-complete contains, match, notlike etc and will transform other names; match and notmatch are regular expressions
    SeShouldHave -URL equalTo "https://www.powershellgallery.com/"
    SeShouldHave -Title match "PowerShell\s+Gallery"
```
The primary job of _SeShouldHave_ is to work like pesters _should_ and succeed silently or fail the test by throwing an error.

### Finding and using an element: (SeElement)
```powershell
    #we can shorten the command :Get-SeElement -By XPath -Selection '//*[@id="search"]'
    #first with an alias and then -by Xpath is assumed and Selection can be passed in the first position to become
    # SeElement  '//*[@id="search"]' |  SeType -ClearFirst "selenium{{Enter}}"
    #This will not report a failure if the element was not found so
    SeElement  '//*[@id="search"]' |  SeType -ClearFirst "selenium{{Enter}}"  -PassThru | should not beNullorEmpty
```
This is also possible with SeShouldHave.. see below

### Checking elements: (SeShouldHave)
```powershell
    $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
    #SeShouldHave can be written explictly like this
    SeShouldHave -Selection $linkpath -By XPath -With Text -Operator match 'selenium'
    #-by Xpath is assumed and the other parameters can be passed by position. Operators will tab complete, and convert "matching" or "matches" to match etc
    SeShouldHave $linkpath  Text  matching  'selenium'
```
The `-with` parameter can be 'Text', 'Displayed', 'Enabled', 'TagName', 'X', 'Y', 'Width', 'Height', 'Choice' or _the name of an attribute_, like 'href'.
 If `-with` is not specified only _the presence_ of the page element is checked.
 If `-PassThru` is specified, matching elements will be sent to the pipeline. (`-Passthru` can't be used when checking the page URL or tile, only with elements on the page).
```powershell
    SeShouldHave $linkpath -PassThru | SeClick
```
### Checking Multiple elements
The selection parameter can take multiple values; in the following command it is specified by position (and assumed to be one or more Xpaths)
```powershell
    SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
                 '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'
```
When multiple elements are found from the selection criteria, and '-With' is specified the test will pass _any_ element passess - in other words, all elements do not need to pass.
```powershell
    #The following counts 8 elements
    SeNavigate 'https://www.google.com/ncr'
    SeShouldHave -by TagName input -PassThru | measure
    #The following command rejects 7 of these 8, without error, and passes the one with a title attribute of 'search' to another command
    SeShouldHave -by TagName input -With Title eq Search -PassThru | SeType 'PowerShell-Selenium'
```

### Selecting frames (SeFrame)
on a page which uses frames it is necessary to specify which one containst the data
```powershell
    seNavigate 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
    sleep -Seconds 5 #can go too fast for frames
    SeFrame 1
```

### Checking alerts (SeShouldHave, SeAccept, SeDismiss)
As well as checking the page URL, and page title. _SeShouldHave_  Supports  -Alert and -NoAlert
```powershell
    #in Frame 1 on  'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'  this will produce an alert
    SeElement "/html/body/button" -Timeout 10 | SeClick -SleepSeconds 2
    #and this will check for it.
    SeShouldHave -Alert match "box"
    #Usually you will want to accept or dismiss the alert
    SeShouldHave -Alert -PassThru | SeDismiss
```
### Working with  select/option "dropdown" controls (SeShouldHave, SeSelection)
```powershell
    #This will go to a page with a dropdown box
    SeNavigate 'https://www.w3schools.com/html/tryit.asp?filename=tryhtml_elem_select'
    sleep -Seconds 5 #can go too fast for frames
    SeFrame 1
    $dropDown = SeShouldHave -By Name "cars" -With choice contains "volvo" -PassThru
```
In the code above, SeShouldHave finds the dropdown box which is named "Cars", and does a check to confirm one of the choices is Volvo, and assigns the result to a variable. This can be used with SeSelection (alias for Get-SeSelectionOption) to test or set options in the dropdown box. An option can be selected (and in the case of mult-select boxes, deselected) by its index, value or [partof] its display text. And the -GetSelected / -GetAllSelected options can be included in a set operation to (or used alone) to return the selected text.
```powershell
    $dropdown | SeSelection -IsMultiSelect               | should be $false
    $dropdown | SeSelection -GetSelected                 | should be 'Volvo'
    $dropdown | SeSelection -ListOptionText              | should not contain "Ferrari"
    #not the selections are case sensitive. The value in this case is all lower case, the display text has initial caps.
    $dropdown | SeSelection -ByValue 'audi' -GetSelected | should be 'Audi'
```

DLL loading is now from the PSD1 file instead of the PSM1 file.
Now use presence of $AssembliesPath to judge "IsMacOS" -or "IsLinux"

Send-SeKeys
  -Element and -Keys parameters are both mandatory
  Selenium-keys are now cached in a script-scoped variable for performance. (Get-SEKeys can be dropped)
  Added -PassThru


Valdate-URL
   Function Renamed to validateUrl (private helper function does not need to use verb-noun naming and "validate" verb upsets script analyzer)
   Added the old name back as an alias (which _is_ allowed. )
   Moved functionality into a validation class which so URLs are validated before enering functions

Checks for valid webdriver also moved to a validation class.

Get-SeCookie & Invoke-SeScreenshot
  In line with other functions, -Driver parameter is renamed -Target, with alias "Driver", and will come from $Global:SeDriver
  and throws an error if no driver is passed or found from Global var

Start-SeFirefox & Start-SeChrome
  Added aliases "SeChrome" and "SeFirefox" - user can now write in a sort of DSL "SeCHROME $URL -asDefault" etc.
  Made -StartUrl the first parameter and use a parameter-validation class to check it.
  Now call the .Navigate method directly instead of via Enter-SeURL if -StartURL is specified
  Now use parameter-sets to avoid the conflict between Minimized/Maximized/FullScreen/Headless,
  Added parameter aliases so "Incognito" works with Firefox and "PrivateBrowsing" works with Chrome
  Now trap a failure to return driver, and simplified the subsequent if statements
  Set ImplicitWait to 10 seconds
  Added Parameter -AsDefaultDriver which sets $Global:SeDriver, instead of returning the driver
  Added Parameter -Quiet to run tests without web driver prattle.
  Allow AzureDevops environment vars (GeckoWebDriver / ChromeWebDriver)  or commandline
  parameter -WebDriverDirectory to specify source of Webdriver.
  Removed a possible bug with piped input, by returning the driver in the process block instead of the end block

Start-SeInternetExplorer
  Added Aliases "SeInternetExplorer" & "SeIE" and parameter -StartUrl
  Plus -AsDefaultDriver which sets $Global:SeDriver, instead of returning the driver, and -Quiet to run tests
  without web driver prattle.
  Allow AzureDevops environment vars or commandline parameter -WebDriverDirectory to specify source of Webdriver
  Set ImplicitWait to 10 seconds

Start-SeEdge
  Added Aliases "MSEdge" & "LegacyEdge", and parameters -StartUrl, -Maximized, -Minimized, FullScreen
  and -PrivateBrowsing (alias Incognito)
  Plus -AsDefaultDriver which sets $Global:SeDriver, instead of returning the driver, and -Quiet to run tests
  without web driver prattle.
  Added message if driver load errors - Webdriver is now added as a windows Feature and will be found from windows\system32,
  which is on the path. Removed old driver and SHA file.
  Set ImplicitWait to 10 seconds

Stop-SeDriver
  Updated to handle the default drive being in $global:SeDriver.

Start-SeNewEdge  **New Function** with alias, credge to support Chromium based edge.
  Also added V79 webdriver. Specifying V80. V81 from an ENV variable (EdgeWebDriver), or via command line requires
  it to be in the same directory as MSEdge.exe and -inPrivate, -headless, and -binaryLocation options don't work.

Start-SeRemote **New Function**
  Connects to remote driver by URL and requested capablites tested with testingbot.com

                        Start-SeChrome  Start-SeEdge Start-SeFirefox  Start-SeInternetExplorer  Start-SeNewEdge  Start-SeRemote
    AsDefaultDriver	         X               X            X                X                         X                X
    Fullscreen               X               X            X                X                         X
    Headless                 X               X            X                X                         X
    ImplicitWait             X               X            X                X                         X                X
    Maximized                X               X            X                X                         X
    Minimized                X               X            X                X                         X
    Incognito                X             As alias	    As alias         As alias                  As alias
    PrivateBrowsing	       As alias          X            X                X                         X
    Quiet                    X               X            X                X                         X
    StartURL                 X               X            X                X                         X                 X
    WebDriverDirectory       X                            X                X                         X
    or Env var         ChromeWebDriver       -       GeckoWebDriver      IEWebDriver             EdgeWebDriver
    BinaryPath               X                                                                       X
    ProfileDirectoryPath     X                                                                       X
    DefaultDownloadPath      X                            X                                          X
    Arguments                X                            X

SeOpen **New Function**
  Takes -In (name of browser) and opens that browser and optional naviagates to destination in -URL
  The browser is opened as with -AsDefault and other options passed in -Options.
  If the browser name is omitted the function will look for $env:DefaultBrowser.
  Mainly for Pester/DSL freindliness - by changing the environment variable a different browser can be used in different test runs

Send-SeClick **New Function** (with alias SeClick) {replacement for Invoke-SeClick}
  Element can be passed by position (first)
  -JavaScriptClick can be abreviated -JS
  Driver is ignored  (element.wrapedDriver used instead)
  Added -SleepSeconds and -PassThru parameters

New-SeScreenShot: **New Function** with alias SeScreenshot. Merges functionality of Invoke-ScreenShot and SaveSeScreenShot
   Can pass -Path,
            -Passthru (Alias PT)
            -Path & -Passthru
       or   -AsBase64
   "Target" with alias "Driver", can come from $Global:SeDriver
   and throws an error if no driver passed or found from Global var

Open-SeURL *New Function** with alias SeNavigate
  Url is first on the commandline and mandatory
  Driver is renamed target, with alias "Driver", and will come from $Global:SeDriver
  Throws an error if no driver passed or found from Global var
  Made interoperable with Enter-SEURL via aliases
  Back, forward and refresh are available via switches
  Commented out Enter-SeURL and changed PSD1,

Get-SeElement **New Function** with alias seElement
    New -By parameter with possible values "CssSelector", "Name", "Id", "ClassName", "LinkText", "PartialLinkText", "TagName", "XPath"
    combined with a "Selection" parameter which holds the value, replaces the 8 parameters with those names and parametersets.
    Wait made optional; -Wait without -Timeout sets timeout to 30 , and -Timeout 5 works without -Wait
    -Element and -Driver are merged as -Target which has aliases of 'Element' and 'Driver'
    Made interoperable with Find-seElement by aliases
    Commented out Find-seElement and updated PSD1.

Switch-SeFrame **New Function** with alias SeFrame
    Selects a frame.

Clear-SeAlert **New Function** with aliases SeAccept, SeDissmiss
    Accepts or dismisses an alert box so execution can continue
    If called using the aliases selects Accept or dismiss.

SeType **New Function**
  More DSL friendly form of Send-SeKeys - takes piped element;  keys is first parameter and supports
  clearing the text box, submit and passthru, to allow element to be fetched and keys typed, and then
  Pester to throw if element was not found.

Get-SeSelectionOption **New Function** alias SeSelection
  For setting and checking options in a dropdown lists.

SeShouldHave **New Function**
Drives pester tests as a single command See examples for details, but allows things like
    SeShouldHave -url -match 'packages\?q=selenium'
    SeShouldHave -Selection $linkpath -By XPath -With Text -Operator Like  -Value "*selenium*"
    which can be shortened to
    seShouldHave $linkpath text -Like "*selenium*"

Added some new examples - showing DSL style in Pester.

Reorder PSD file for easy reading & add file list.

Create CI directory with files for doing a build / test pass is Azure devops.
