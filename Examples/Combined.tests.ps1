if ($Global:SeDriver) { Write-Warning -Message 'Close any previous session first'; return }

#SeOpen will use an environment variable DefaultBrowser if no browser is specified on the command line, so
# we can run the script with different browsers by changing that and running invoke-pester again. If it wasn't set, set it now
if (-not $env:DefaultBrowser) { $env:DefaultBrowser = 'Chrome' }

#For each browser we will test in, specify the options for headless, inprivate & window title label for in-private
$AlwaysHeadless = $env:AlwaysHeadless -eq $true
$TestCaseSettings = @{
    'NewEdge' = @{ DefaultOptions = @{Headless = $AlwaysHeadless }
        #     HeadlessOptions = @{Headless=$true}
        PrivateOptions            = @{PrivateBrowsing = $true
            Headless                       = $AlwaysHeadless 
        }
        #     InPrivateLabel  = 'InPrivate'
    } # broken after build 79 of web driver#>
    'Chrome'  = @{ PrivateOptions = @{PrivateBrowsing = $true
            Headless                                 = $AlwaysHeadless
        }
        DefaultOptions           = @{Headless = $AlwaysHeadless }
        HeadlessOptions          = @{Headless = $true }
    }
    'Firefox' = @{ PrivateOptions = @{PrivateBrowsing = $true
            Headless                                  = $AlwaysHeadless
        }
        DefaultOptions            = @{Headless = $AlwaysHeadless }
        HeadlessOptions           = @{Headless = $true }
    }
    'MSEdge'  = @{ DefaultOptions = @{Headless = $AlwaysHeadless }
        PrivateOptions           = @{PrivateBrowsing = $true }
    }
    'IE'      = @{ DefaultOptions = @{ImplicitWait = 30 }
        PrivateOptions       = @{ImplicitWait = 30 }
    }
}

function Build-StringFromHash {
    param ($Hash)
    $(foreach ($k in $Hash.Keys) { "$K`:$($hash[$K])" }) -join '; '
}

#region tailspin demo from the Azure Devops training materials
if (-not $env:SITE_URL) {
    $env:SITE_URL = 'http://tailspin-spacegame-web.azurewebsites.net'
}
$ModaltestCases = @(
    @{Name         = 'Download Page'
        linkXPath  = '/html/body/div/div/section[2]/div[2]/a'
        modalXPath = '//*[@id="pretend-modal"]/div/div'
    },
    @{Name         = 'Screen Image'
        linkXPath  = '/html/body/div/div/section[3]/div/ul/li[1]/a'
        modalXPath = '/html/body/div[1]/div/div[2]'
    },
    @{Name         = 'Top Player'
        linkXPath  = '/html/body/div/div/section[4]/div/div/div[1]/div[2]/div[2]/div/a/div'
        modalXPath = '//*[@id="profile-modal-1"]/div/div'
    }
)

$BrowserOptHash = $TestCaseSettings[$env:DefaultBrowser].DefaultOptions
$BrowserOptText = Build-StringFromHash $BrowserOptHash
Describe "Testing the tailspin toys demo site at $env:SITE_URL" {
    BeforeAll {
        #Relying on environment variable to pick the browser. Capture ID for use in logs by requesting verbose and redirecting it.
        $BrowserOptHash = $TestCaseSettings[$env:DefaultBrowser].DefaultOptions
        Write-Verbose ($BrowserOptHash -eq $null) -Verbose
        $BrowserID = SeOpen -URL $env:SITE_URL -Options  $BrowserOptHash 4>&1
        $BrowserID = ($BrowserID.Message -replace '^Opened ', '') + ' on ' + [System.Environment]::OSVersion.Platform
    }
    Context "in $BrowserID with settings ($BrowserOptText)" {
        It "produced the right modal dialog for the <name>" -TestCases $ModaltestCases {
            Param ($linkXPath, $modalXPath)
            SeShouldHave   $modalXPath -With displayed eq $false
            SeElement      $linkXPath | SeClick -JavaScriptClick -SleepSeconds 1
            SeShouldHave   $modalXPath -With displayed eq $true -PassThru | SeElement -By Class 'close' | SeClick -J -S 1
            SeShouldHave  'body'       -By   TagName
            SeShouldHave   $modalXPath -With displayed eq $false
        }
    }
    #                               Additional tests would be here
    AfterAll { SeClose }
}
#endregion

#URLs we will visit in the remaining tests
$PSGalleryPage = 'https://www.powershellgallery.com/'
$AlertTestPage = 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
$SelectTestPage = 'https://www.w3schools.com/html/tryit.asp?filename=tryhtml_elem_select'

#As before rely on environment variable to pick browser. Capture ID by requesting & redirecting verbose
$BrowserOptHash = $TestCaseSettings[$env:DefaultBrowser].DefaultOptions
$BrowserOptText = Build-StringFromHash $BrowserOptHash
$BrowserID = SeOpen -URL $PSGalleryPage -Options $BrowserOptHash -Verbose  4>&1
$BrowserID = ($BrowserID.Message -replace '^Opened ', '') + ' on ' + [System.Environment]::OSVersion.Platform
Describe "PsGallery Test" {
    Context "in $BrowserID with settings ($BrowserOptText)" {
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
            SeShouldHave -By Id search
        }
        It 'found the search box on the home page by Name                          ' {
            SeShouldHave -By Name 'q'
        }
        It 'found the search box on the home page by css selector                  ' {
            #can write -By <<mechanism>> [-selection] <<selection text>>
            #       or [-selection] <<selection text>> -By <<mechanism>>
            SeShouldHave 'input[name=q]' -By CssSelector
        }
        It 'found the search box on the home page by class name                    ' {
            SeShouldHave -By ClassName "search-box"
        }
        It 'found the search box on the home page by Tagname and typed in it       ' {
            #get element, pipe as input element for Typing, pass the element through
            #so pester catches 'null or empty' if it was not found
            SeElement -By TagName input |
                SeType -ClearFirst "selenium{{Enter}}" -PassThru -SleepSeconds 2    | Should -Not -BeNullorEmpty
        }
        $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
        It 'searched successfully                                                  ' {
            SeShouldHave -URL                 match 'packages\?q=selenium' -Timeout 15
            #Two tests on the same element, second passes it through to click
            SeShouldHave $linkpath -With href match selenium
            SeShouldHave $linkpath -With Text like *selenium* -PassThru | SeClick -SleepSeconds 5
        }
        It 'opened the search result page and found the expected content           ' {
            #Just to show we can test for the presence of multiple links. Each one is re-tested ...
            SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
            '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -Timeout 15

            SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

            #Can test with "Get-SeElement | where-object <<complex test>>" rather than "with <<feild>> <<operator>> <<value>>"
            SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
                Where-Object { ($_.text -like "*Project Site*") -and ($_.GetAttribute('href') -match "selenium") } |
                    SeClick -PassThru  | Should -Not -Benullorempty
        }
        It 'went to Github from the project link on the search result              ' {
            SeShouldHave -URL  match 'github' -Timeout 30
        }
        It 'navigated back to the start page and closed the browser                ' {
            SeNavigate   -Back
            SeNavigate   -Back
            SeNavigate   -Back
            SeShouldHave -URL eq $PSGalleryPage -Timeout 30
            SeClose
            $Global:SeDriver                                               | Should      -BeNullOrEmpty
        }
    }
}

$BrowserOptHash = $TestCaseSettings[$env:DefaultBrowser].PrivateOptions
$BrowserOptText = Build-StringFromHash $BrowserOptHash
if ($BrowserOptText) {
    $NoLabel = [string]::IsNullOrEmpty($TestCaseSettings[$env:DefaultBrowser].InPrivateLabel)
    $wv = $null
    SeOpen   -Options $BrowserOptHash -URL $alertTestPage -WarningVariable wv
    if ($wv) { Write-Output "##vso[task.logissue type=warning]$wv" }
}
else {
    $NoLabel = $true
    SeOpen -URL $alertTestPage
}
Describe "Alerts and Selection boxes tests" {
    Context "in $BrowserID with settings ($BrowserOptText)" {
        It 're-opended the browser and validated "InPrivate" mode by window title  ' {
            $DriverProcess = Get-Process *driver | Where-Object { $_.Parent.id -eq $pid }
            $BrowserProcess = Get-Process         | Where-Object { $_.Parent.id -eq $DriverProcess.id -and $_.Name -ne "conhost" }
            $BrowserProcess.MainWindowTitle                                | Should match $TestCaseSettings[$env:DefaultBrowser].InPrivateLabel
        } -Skip:$NoLabel
        It 'opened the right page                                                  ' {
            SeShouldHave -URL -eq $alertTestPage
        }
        It 'found and clicked a button in frame 1                                  ' {
            SeShouldHave -Selection "iframe" -By TagName -with id eq iframeResult
            SeFrame 'iframeResult'
            SeElement "/html/body/button"  | SeClick  -PassThru   | Should -Not -BeNullOrEmpty
        }
        It 'saw and dismissed an alert                                             ' {
            #Checking the text of the alert is optional. Dissmiss can pass the alert result through
            SeShouldHave -Alert match "box" -PassThru  |
                SeDismiss -PassThru                                             | Should -Not -BeNullOrEmpty
        }
        It 'reselected the parent frame                                            ' {
            SeFrame -Parent
            SeShouldHave -Selection "iframe" -By TagName -with id eq iframeResult
        }
        It 'navigated to a new page, and found the "cars" selection box in frame 1 ' {
            SeNavigate $SelectTestPage
            SeShouldHave -Selection "iframe" -By TagName -with id eq iframeResult
            SeFrame 'iframeResult'
            SeShouldHave -By Name "cars" -With choice contains "volvo"
        }
        It 'made selections from the "cars" selection box                          ' {
            $e = SeElement -by Name "cars"
            #Values are lower case Text has inital caps comparisons are case sensitve. Index is 0-based
            { $e | SeSelection -ByValue "Audi" }                              | Should      -Throw
            { $e | SeSelection -ByValue "audi" }                              | Should -not -throw
            $e | SeSelection -ByIndex "2"  -GetSelected                    | Should      -Be 'Fiat'
            $e | SeSelection -ByPartialText  "Sa"
        }
        It 'submitted the form and got the expected response                       ' {
            SeElement '/html/body/form/input' | SeClick -SleepSeconds 5
            SeFrame -Parent
            SeFrame 'iframeResult'
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

$BrowserOptHash = $TestCaseSettings[$env:DefaultBrowser].HeadlessOptions
$BrowserOptText = Build-StringFromHash $BrowserOptHash
if ($BrowserOptText) {
    SeOpen -Options $BrowserOptHash
    Describe "'Headless' mode browser test" {
        Context "in $BrowserID with settings ($BrowserOptText)" {
            It 're-opened the Browser in "Headless" mode                               ' {
                $DriverProcess = Get-Process *driver | Where-Object { $_.Parent.id -eq $pid }
                $BrowserProcess = Get-Process         | Where-Object { $_.Parent.id -eq $DriverProcess.id -and $_.Name -ne 'conhost' }
                $BrowserProcess.MainWindowHandle  | Select-Object -First 1     | Should      -Be 0
            }
            it 'did a google Search                                                    ' {
                SeNavigate 'https://www.google.com/ncr'
                SeShouldHave -by Name q
                SeShouldHave -by ClassName 'gLFyf'
                SeShouldHave -By TagName  input -With title eq 'Search' -PassThru |
                    Select-Object -First 1 |
                        SeType -Keys 'Powershell-Selenium{{Enter}}' -PassThru  | should -Not -BeNullOrEmpty

                SeShouldHave '//*[@id="tsf"]/div[2]/div[1]/div[1]/a' -PassThru |
                    SeClick -PassThru                 | should -Not -BeNullOrEmpty
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