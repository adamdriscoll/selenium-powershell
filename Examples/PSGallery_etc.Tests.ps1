if ($Global:SeDriver) {Write-Warning -Message 'Close any previous session first'; return}

#can run the script with different browsers by changing an env. variable and calling invoke-pester again.
if ($env:DefaultBrowser)
        {$Browser = $env:DefaultBrowser}
else    {$Browser = 'NewEdge'}
#For each browser we will test with specify the options for headless, inprivate & window title label for in-private
$TestCaseSettings = @{
    'NewEdge'     = @{ HeadlessOptions = @{Headless=$true}
                       PrivOptions     = @{PrivateBrowsing=$true}
                       InPrivateLabel  = 'InPrivate'}
}
#URLs we will visit
$PSGalleryPage    = 'https://www.powershellgallery.com/'
$AlertTestPage    = 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
$SelectTestPage   = 'https://www.w3schools.com/html/tryit.asp?filename=tryhtml_elem_select'

SeOpen $PSGalleryPage -In $Browser
Describe "PsGallery Test with $Browser"  {
    It "Opened $Browser, saving the driver in a global variable".padright(71) {
        $DriverProcess  = Get-Process *driver | Where-Object {$_.Parent.id -eq $pid}
        $BrowserProcess = Get-Process | Where-Object {$_.Parent.id -eq $DriverProcess.id}
        $DriverProcess                                                 | should not beNullOrEmpty
        $BrowserProcess                                                | should not beNullOrEmpty
        $Global:SeDriver                                               | should not beNullOrEmpty
        $Global:SeDriver -is [OpenQA.Selenium.Remote.RemoteWebDriver]  | should     be true
    }
    It 'Reached the right starting page                                        ' {
        #Should have can check alerts, page title, URL or an element on the page
        SeShouldHave -URL eq $PSGalleryPage
    }
    It 'Found the "Sign in" link on the homepage by partial text               ' {
        SeShouldHave -By PartialLinkText 'Sign in' -With href match logon
    }
    It 'Found the search box on the home by ID                                 ' {
        SeShouldHave -By Id search -Timeout 10
    }
    It 'Found the search box on the home by ID                                 ' {
        SeShouldHave -By TagName input
    }
    It 'Found the search box on the home by css selector                       ' {
        #can write -By <<mechanism>> [-selection] <<selection text>>
        #       or [-selection] <<selection text>> -By <<mechanism>>
        SeShouldHave 'input[name=q]' -By CssSelector
    }
    It 'Found the search box on the home by class name                         ' {
        SeShouldHave -By ClassName "search-box"
    }
    It 'Found the search box on the home page by name and typed in it          ' {
        #get element, pipe as input element for Typing, pass the element through
        #so pester catches 'null or empty' if it was not found
        SeElement -By Name 'q' |
            SeType -ClearFirst "selenium{{Enter}}" -PassThru           | should not beNullorEmpty
    }
    $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
    It 'Searched successfully                                                  ' {
        SeShouldHave -URL                 match 'packages\?q=selenium'
        #Two tests on the same element, second passes it through to click
        SeShouldHave $linkpath -With href match selenium
        SeShouldHave $linkpath -With Text like *selenium* -PassThru | SeClick
    }
    It 'Opened the search result page and found the expected content           ' {
        #Just to show we can test for the presence of multiple links. Each one is re-tested ...
        SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
                     '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'

        SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

        #Can test with "Get-SeElement | where-object <<complex test>>" rather than "with <<feild>> <<operator>> <<value>>"
        SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
            Where {($_.text -eq "Project Site") -and ($_.GetAttribute('href') -match "selenium") } |
                SeClick -PassThru    | should not benullorempty
    }
    It 'Went to Github from the project link on the search result              ' {
        SeShouldHave -URL  match 'github'
    }
    it 'Navigated back to the start page and closed the browser                ' {
        SeNavigate   -Back
        SeNavigate   -Back
        SeNavigate   -Back
        SeShouldHave -URL eq $PSGalleryPage
        SeClose
        $Global:SeDriver                                               | should     beNullOrEmpty
        if ($DriverProcess.Id) {
            (Get-Process -id $DriverProcess.id ).HasExited             | should     be $true
        }
        if ($BrowserProcess.Id) {
            (Get-Process -id $BrowserProcess.id).HasExited             | should     be $true
        }
    }
}

SeOpen $alertTestPage -In $Browser -Options $TestCaseSettings[$Browser].PrivOptions
Describe "Alerts, Selection boxes and Private browsing with $Browser"{
    It "Re-opended $browser in 'InPrivate' mode".padright(71) {
        $DriverProcess  = Get-Process *driver | Where-Object {$_.Parent.id -eq $pid}
        $BrowserProcess = Get-Process         | Where-Object {$_.Parent.id -eq $DriverProcess.id}
        $BrowserProcess.MainWindowTitle                                | should match $TestCaseSettings[$Browser].InPrivateLabel
    }
    It 'Opened the right page                                                  ' {
        SeShouldHave -URL -eq $alertTestPage
    }
    It 'Found and clicked a button in frame 1                                  ' {
        sleep -Seconds 5 #can go too fast for frames
        SeFrame 1
        SeElement "/html/body/button" -Timeout 10 |
                SeClick -SleepSeconds 2 -PassThru                      | should not beNullOrEmpty
    }
    It 'Saw and dismissed an alert                                             ' {
        #checking the text of the alert is optional. Dissmiss can the alert result through
        SeShouldHave -Alert match "box" -PassThru | SeDismiss -PT      | should not beNullOrEmpty
    }
    It 'Reselected the parent frame                                            ' {
        SeFrame -Parent
    }
    It 'Navigated to a new page, and found the "cars" selection box in frame 1 ' {
        SeNavigate $SelectTestPage
        sleep -Seconds 5
        SeFrame 1
        SeShouldHave -By Name "cars" -With choice contains "volvo" -Timeout 10
    }
    It 'Made selections from the "cars" selection box                          ' {
         $e = SeElement -by Name "cars" -Timeout 10
         #Values are lower case Text has inital caps comparisons are case sensitve. Index is 0-based
        {$e | SeSelection -ByValue "Audi"}                             | should     throw
        {$e | SeSelection -ByValue "audi"}                             | should not throw
         $e | SeSelection -ByIndex "2" -GetSelected                    | should     be 'Fiat'
         $e | SeSelection -ByText "Sa" -PartialText
    }
    It 'Submitted the form and got the expected response                       ' {
        SeElement '/html/body/form/input' | SeClick -SleepSeconds 5
        SeShouldHave "/html/body/div[1]" -with text match "cars=saab"
    }
    it 'Closed the in-private browser instance                                 ' {
        SeClose
        if ($DriverProcess.Id) {
            (Get-Process -id $DriverProcess.id ).HasExited             | should     be $true
        }
        if ($BrowserProcess.Id) {
            (Get-Process -id $BrowserProcess.id).HasExited             | should     be $true
        }
    }
}

SeOpen $Browser -Options $TestCaseSettings[$Browser].HeadlessOptions
Describe "Headless browser mode with $browser" {
    it "Re-opened $Browser in 'Headless' mode".padright(71){
        $DriverProcess  = Get-Process *driver | Where-Object {$_.Parent.id -eq $pid}
        $BrowserProcess = Get-Process | Where-Object {$_.Parent.id -eq $DriverProcess.id}
        $BrowserProcess.MainWindowHandle | should be 0
    }
    it 'Closed the browser a third time                                        ' {
        SeClose
        $Global:SeDriver                                               | should     beNullOrEmpty
        if ($DriverProcess.Id) {
            (Get-Process -id $DriverProcess.id ).HasExited             | should     be $true
        }
        if ($BrowserProcess.Id) {
            (Get-Process -id $BrowserProcess.id).HasExited             | should     be $true
        }
    }
}
