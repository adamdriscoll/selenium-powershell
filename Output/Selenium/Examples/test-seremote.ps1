$PSGalleryPage     = 'https://www.powershellgallery.com/'
$AlertTestPage     = 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
$SelectTestPage    = 'https://www.w3schools.com/html/tryit.asp?filename=tryhtml_elem_select'

#other services at
#https://crossbrowsertesting.com/freetrial / https://help.crossbrowsertesting.com/selenium-testing/getting-started/c-sharp/
#https://www.browserstack.com/automate/c-sharp

$key               = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$secret            = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$RemoteDriverURL   = [uri]"http://$key`:$secret@hub.testingbot.com/wd/hub"
$caps = @{
  platform         = 'HIGH-SIERRA'
  browserName      = 'safari'
  version          = '11'
}

Start-SeRemote -RemoteAddress $RemoteDriverURL -DesiredCapabilities $caps -AsDefaultDriver -StartURL $PSGalleryPage
$BrowserID = $SeDriver.Capabilities.ToDictionary()["platformName", "browserName", "version"] -join " "

Describe "All in one Test"  {
    Context "in $BrowserID with settings ($BrowserOptText)"{
        It 'opened the put the webdriver in a global variable                      ' {
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
                SeType -ClearFirst "selenium{{Enter}}" -PassThru -Sleep 2    | Should -Not -BeNullorEmpty
        }
        $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
        It 'searched successfully                                                  ' {
            SeShouldHave -URL                 match 'packages\?q=selenium' -Timeout 15
            #Two tests on the same element, second passes it through to click
            SeShouldHave $linkpath -With href match selenium
            SeShouldHave $linkpath -With Text like *selenium* -PassThru | SeClick -Sleep 5
        }
        It 'opened the search result page and found the expected content           ' {
            #Just to show we can test for the presence of multiple links. Each one is re-tested ...
            SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
                         '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -Timeout 15

            SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

            #Can test with "Get-SeElement | where-object <<complex test>>" rather than "with <<feild>> <<operator>> <<value>>"
            SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
                Where-Object {($_.text -like "*Project Site*") -and ($_.GetAttribute('href') -match "selenium") } |
                    SeClick -PassThru  | Should -Not -Benullorempty
        }
        It 'went to Github from the project link on the search result              ' {
            SeShouldHave -URL  match 'github' -Timeout 30
        }

        It 'navigated back to the start page                                       ' {
            SeNavigate   -Back
            SeNavigate   -Back
            SeNavigate   -Back
            SeShouldHave -URL eq $PSGalleryPage -Timeout 30
        }
        It 'did a google Search                                                    ' {
            SeNavigate 'https://www.google.com/ncr'
            SeShouldHave -by Name q
            SeShouldHave -by ClassName 'gLFyf'
            SeShouldHave -By TagName  input -With title eq 'Search' -PassThru |
                Select-Object -First 1 |
                    SeType -Keys 'Powershell-Selenium{{Enter}}' -PassThru  | should -Not -BeNullOrEmpty

            SeShouldHave '//*[@id="tsf"]/div[2]/div[1]/div[1]/a' -PassThru |
                                            SeClick -PassThru                 | should -Not -BeNullOrEmpty
        }
        It 'opened the the alert test-page                                         ' {
            SeNavigate   $alertTestPage
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
            {$e | SeSelection -ByValue "Audi"}                              | Should      -Throw
            {$e | SeSelection -ByValue "audi"}                              | Should -Not -Throw
             $e | SeSelection -ByIndex "2"  -GetSelected                    | Should      -Be 'Fiat'
             $e | SeSelection -ByPartialText  "Sa"
        }
        It 'submitted the form and got the expected response                       ' {
            SeElement '/html/body/form/input' | SeClick -Sleep 5
            SeFrame -Parent
            SeFrame 'iframeResult'
            SeShouldHave "/html/body/div[1]" -with text match "cars=saab"
        }
    }
}
SeClose