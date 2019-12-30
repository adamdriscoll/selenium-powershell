if ($Global:SeDriver) {Write-Warning -Message 'Close any previous session first'; return}

#SeOpen will use an environment variable DefaultBrowser if no browser is specified. on the command line so we
# can run the script with different browsers by changing that and running invoke-pester again. If it wasn't set, set it now
if (-not $env:DefaultBrowser) {$env:DefaultBrowser = 'NewEdge'}

#For each browser we will test in, specify the options for headless, inprivate & window title label for in-private
$TestCaseSettings = @{
    'NewEdge'     = @{ HeadlessOptions = @{Headless=$true}
                       PrivOptions     = @{PrivateBrowsing=$true}
                       InPrivateLabel  = 'InPrivate'}
    'Chrome'      = @{ HeadlessOptions = @{Headless=$true}
                       PrivOptions     = @{PrivateBrowsing=$true}
                       InPrivateLabel  = 'Incognito'}
    'Firefox'     = @{ HeadlessOptions = @{Headless=$true}
                       PrivOptions     = @{PrivateBrowsing=$true}
                       InPrivateLabel  = 'Private'}
}

#URLs we will visit
$PSGalleryPage    = 'https://www.powershellgallery.com/'
$AlertTestPage    = 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
$SelectTestPage   = 'https://www.w3schools.com/html/tryit.asp?filename=tryhtml_elem_select'

#Rely environment variable to choose browser. Capture ID by requesting verbose and redirecting it.
$BrowserID = SeOpen -URL $PSGalleryPage -Verbose  4>&1
$BrowserID = ($BrowserID.Message -replace '^Opened ','') + ' on ' + [System.Environment]::OSVersion.Platform
Describe "PsGallery Test"  {
        Context "in $BrowserID"{
            It 'opened the browser, saving the webdriver in a global variable          ' {
                $Global:SeDriver                                               | Should -Not -BeNullOrEmpty
                $Global:SeDriver                                               | Should      -BeOfType [OpenQA.Selenium.Remote.RemoteWebDriver]
            }
            It 'reached the right starting page                                        ' {
                #Should have can check alerts, page title, URL or an element on the page
                SeShouldHave -URL eq $PSGalleryPage
            }
            It 'found the "Sign in" link on the home page by partial text              ' {
                SeShouldHave -By PartialLinkText 'Sign in' -With href match logon
            }
            It 'found the search box on the home page by ID                            ' {
                SeShouldHave -By Id search -Timeout 10
            }
            It 'found the search box on the home page by TagName                       ' {
                SeShouldHave -By TagName input
            }
            It 'found the search box on the home page by css selector                  ' {
                #can write -By <<mechanism>> [-selection] <<selection text>>
                #       or [-selection] <<selection text>> -By <<mechanism>>
                SeShouldHave 'input[name=q]' -By CssSelector
            }
            It 'found the search box on the home page by class name                    ' {
                SeShouldHave -By ClassName "search-box"
            }
            It 'found the search box on the home page by name and typed in it          ' {
                #get element, pipe as input element for Typing, pass the element through
                #so pester catches 'null or empty' if it was not found
                SeElement -By Name 'q' |
                    SeType -ClearFirst "selenium{{Enter}}" -PassThru -SleepSeconds 2    | Should -Not -BeNullorEmpty
            }
            $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
            It 'searched successfully                                                  ' {
                SeShouldHave -URL                 match 'packages\?q=selenium'
                #Two tests on the same element, second passes it through to click
                SeShouldHave $linkpath -With href match selenium
                SeShouldHave $linkpath -With Text like *selenium* -PassThru | SeClick -SleepSeconds 2
            }
            It 'opened the search result page and found the expected content           ' {
                #Just to show we can test for the presence of multiple links. Each one is re-tested ...
                SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
                            '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'

                SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

                #Can test with "Get-SeElement | where-object <<complex test>>" rather than "with <<feild>> <<operator>> <<value>>"
                SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
                    Where-Object {($_.text -eq "Project Site") -and ($_.GetAttribute('href') -match "selenium") } |
                        SeClick -PassThru -SleepSeconds 5 | Should -Not -Benullorempty
            }
            It 'went to Github from the project link on the search result              ' {
                SeShouldHave -URL  match 'github'
            }
            It 'navigated back to the start page and closed the browser                ' {
                SeNavigate   -Back
                SeNavigate   -Back
                SeNavigate   -Back
                SeShouldHave -URL eq $PSGalleryPage
                SeClose
                $Global:SeDriver                                               | Should      -BeNullOrEmpty
                if ($DriverProcess.Id) {
                    (Get-Process -id $DriverProcess.id ).HasExited             | Should      -Be $true
                }
                if ($BrowserProcess.Id) {
                    (Get-Process -id $BrowserProcess.id).HasExited             | Should      -Be $true
                }
            }
        }
}

$BrowserOptions = $TestCaseSettings[$env:DefaultBrowser].PrivOptions.keys -join ", "
if ($BrowserOptions) {
    SeOpen   -Options $TestCaseSettings[$env:DefaultBrowser].PrivOptions -URL $alertTestPage
    Describe "Alerts, Selection boxes and Private browsing test"{
        Context "with setting $BrowserOptions in $BrowserID" {
            It 're-opended the browser in "InPrivate" mode                             ' {
                $DriverProcess  = Get-Process *driver | Where-Object {$_.Parent.id -eq $pid}
                $BrowserProcess = Get-Process         | Where-Object {$_.Parent.id -eq $DriverProcess.id}
                $BrowserProcess.MainWindowTitle                                | Should match $TestCaseSettings[$env:DefaultBrowser].InPrivateLabel
            }
            It 'opened the right page                                                  ' {
                SeShouldHave -URL -eq $alertTestPage
            }
            It 'found and clicked a button in frame 1                                  ' {
                Start-Sleep -Seconds 5 #can go too fast for frames
                SeFrame 1
                SeElement "/html/body/button" -Timeout 10 | SeClick -Sleep 2 -PassThru   | Should -Not -BeNullOrEmpty
            }
            It 'saw and dismissed an alert                                             ' {
                #Checking the text of the alert is optional. Dissmiss can pass the alert result through
                SeShouldHave -Alert match "box" -PassThru | SeDismiss -PassThru          | Should -Not -BeNullOrEmpty
            }
            It 'reselected the parent frame                                            ' {
                SeFrame -Parent
            }
            It 'navigated to a new page, and found the "cars" selection box in frame 1 ' {
                SeNavigate $SelectTestPage
                Start-Sleep -Seconds 5
                SeFrame 1
                SeShouldHave -By Name "cars" -With choice contains "volvo" -Timeout 10
            }
            It 'made selections from the "cars" selection box                          ' {
                $e = SeElement -by Name "cars" -Timeout 10
                #Values are lower case Text has inital caps comparisons are case sensitve. Index is 0-based
                {$e | SeSelection -ByValue "Audi"}                             | Should      -Throw
                {$e | SeSelection -ByValue "audi"}                             | Should -not -throw
                $e | SeSelection -ByIndex "2" -GetSelected                     | Should      -Be 'Fiat'
                $e | SeSelection -ByText "Sa" -PartialText
            }
            It 'submitted the form and got the expected response                       ' {
                SeElement '/html/body/form/input' | SeClick -SleepSeconds 5
                SeShouldHave "/html/body/div[1]" -with text match "cars=saab"
            }
            It 'closed the in-private browser instance                                 ' {
                SeClose
                if ($DriverProcess.Id) {
                    (Get-Process -id $DriverProcess.id ).HasExited             | Should      -Be $true
                }
                if ($BrowserProcess.Id) {
                    (Get-Process -id $BrowserProcess.id).HasExited             | Should      -Be $true
                }
            }
        }
    }
}

$BrowserOptions =   $TestCaseSettings[$env:DefaultBrowser].HeadlessOptions.keys -join ", "
if ($BrowserOptions){
    SeOpen -Options $TestCaseSettings[$env:DefaultBrowser].HeadlessOptions
    Describe "'Headless' mode browser test" {
        Context "with setting $BrowserOptions in $BrowserID" {
            It 're-opened the Browser in "Headless" mode                               ' {
                $DriverProcess  = Get-Process *driver | Where-Object {$_.Parent.id -eq $pid}
                $BrowserProcess = Get-Process | Where-Object {$_.Parent.id -eq $DriverProcess.id}
                $BrowserProcess.MainWindowHandle | Should be 0
            }
            It 'closed the browser a third time                                        ' {
                SeClose
                $Global:SeDriver                                               | Should      -BeNullOrEmpty
                if ($DriverProcess.Id) {
                    (Get-Process -id $DriverProcess.id ).HasExited             | Should      -Be $true
                }
                if ($BrowserProcess.Id) {
                    (Get-Process -id $BrowserProcess.id).HasExited             | Should      -Be $true
                }
            }
        }
    }
}