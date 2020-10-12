. "$(Join-Path -Path $PSScriptRoot -ChildPath '_TestDependencies.ps1' )"
      
$Global:TestCaseSettings = Get-TestCasesSettings 
$Global:BrowserOptHash = $Global:TestCaseSettings."$Global:DefaultBrowser".DefaultOptions
$Env:BrowserOptText = Build-StringFromHash $Global:BrowserOptHash
$Env:BrowserID = "$Global:DefaultBrowser on $([System.Environment]::OSVersion.Platform)"
Describe "Testing the tailspin toys demo site at $env:SITE_URL" {
    BeforeAll {
        . "$(Join-Path -Path $PSScriptRoot -ChildPath '_TestDependencies.ps1' )"
      
        $Global:TestCaseSettings = Get-TestCasesSettings 
        $Global:BrowserOptHash = $Global:TestCaseSettings."$Global:DefaultBrowser".DefaultOptions
        $Env:BrowserOptText = Build-StringFromHash $Global:BrowserOptHash
        #Relying on environment variable to pick the browser. Capture ID for use in logs by requesting verbose and redirecting it.
        try { Start-SeDriver -Browser $Global:DefaultBrowser -StartURL $env:SITE_URL  @Global:BrowserOptHash -Verbose  4>&1  -ErrorAction Stop } catch { throw $_ }
        $Env:BrowserID = "$Global:DefaultBrowser on $([System.Environment]::OSVersion.Platform)"
   
    }
    Context "in $($Env:BrowserID) with settings ($Env:BrowserOptText)" {
        It "produced the right modal dialog for the <name>" -TestCases (Get-ModalTestCases) {
            Param ($linkXPath, $modalXPath)
            SeShouldHave   $modalXPath -With displayed eq $false -Timeout 10
            SeElement      $linkXPath | Invoke-SeClick  -Action Click_JS -Sleep 1
            SeElement   $modalXPath   | SeElement -By ClassName 'close' | Invoke-SeClick -Action Click_JS -Sleep 1
            SeShouldHave  'body'       -By   TagName
            SeShouldHave   $modalXPath -With displayed eq $false
        }
    }
    #                               Additional tests would be here
    AfterAll { Stop-SeDriver }
}
#endregion

#URLs we will visit in the remaining tests

#


#As before rely on environment variable to pick browser. Capture ID by requesting & redirecting verbose
Describe "PsGallery Test" {
    BeforeAll {
        . "$(Join-Path -Path $PSScriptRoot -ChildPath '_TestDependencies.ps1' )"
        $PSGalleryPage = 'https://www.powershellgallery.com/'
        $Global:TestCaseSettings = Get-TestCasesSettings 
        $Global:BrowserOptHash = $Global:TestCaseSettings[$Global:DefaultBrowser].DefaultOptions
        $Env:BrowserOptText = Build-StringFromHash $Global:BrowserOptHash
        try { Start-SeDriver -Browser $Global:DefaultBrowser -StartURL $PSGalleryPage @Global:BrowserOptHash -Verbose  4>&1  -ErrorAction Stop }catch {}
        $Env:BrowserID = "$Global:DefaultBrowser on $([System.Environment]::OSVersion.Platform)"
    }
    Context "in $Env:BrowserID with settings ($Env:BrowserOptText)" {
        It 'opened the browser, saving the webdriver in a global variable          ' {
            Get-SeDriver -Current                                          | Should -Not -BeNullOrEmpty
            Get-SeDriver -Current                                          | Should -BeOfType [OpenQA.Selenium.Remote.RemoteWebDriver]
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
            Get-SeElement -By TagName -Value 'input' |
                Invoke-SeKeys -ClearFirst -Keys "selenium{{Enter}}" -PassThru -Sleep 2    | Should -Not -BeNullorEmpty
        }
        It 'searched successfully                                                  ' {
            $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
            SeShouldHave -URL                 match 'packages\?q=selenium' -Timeout 15
            #Two tests on the same element, second passes it through to click
            SeShouldHave $linkpath -With href match selenium
            SeShouldHave $linkpath -With Text like *selenium* -PassThru | Invoke-SeClick -Action Click_JS -Sleep 5
        }
        It 'opened the search result page and found the expected content           ' {
            #Just to show we can test for the presence of multiple links. Each one is re-tested ...
            SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
            '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -Timeout 15

            SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

            #Can test with "Get-SeElement | where-object <<complex test>>" rather than "with <<feild>> <<operator>> <<value>>"
            SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
                Where-Object { ($_.text -like "*Project Site*") -and ($_.GetAttribute('href') -match "selenium") } |
                    Invoke-SeClick -PassThru  | Should -Not -Benullorempty
        }
        It 'went to Github from the project link on the search result              ' {
            SeShouldHave -URL  match 'github' -Timeout 30
        }
        It 'navigated back to the start page and closed the browser                ' {
            Set-SeUrl -Back
            Set-SeUrl -Back
            Set-SeUrl -Back
            SeShouldHave -URL eq $PSGalleryPage -Timeout 30
            Stop-SeDriver
            Get-SeDriver -Current                                              | Should      -BeNullOrEmpty
        }
    }
    AfterAll { Stop-SeDriver }
}


Describe "Alerts and Selection boxes tests" {
    BeforeAll {
        . "$(Join-Path -Path $PSScriptRoot -ChildPath '_TestDependencies.ps1' )"
        $AlertTestPage = 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
        $SelectTestPage = 'https://www.w3schools.com/html/tryit.asp?filename=tryhtml_elem_select'
        $Global:TestCaseSettings = Get-TestCasesSettings 
        $Global:BrowserOptHash = $Global:TestCaseSettings[$Global:DefaultBrowser].PrivateOptions
        $Env:BrowserOptText = Build-StringFromHash $Global:BrowserOptHash

        if ($Env:BrowserOptText) {
            $Global:NoLabel = [string]::IsNullOrEmpty($Global:TestCaseSettings[$Global:DefaultBrowser].InPrivateLabel)
            $wv = $null
            try { Start-SeDriver -Browser $Global:DefaultBrowser -StartURL $alertTestPage  @BrowserOptHash -WarningVariable wv  -ErrorAction Stop }catch {}
            if ($wv) { Write-Output "##vso[task.logissue type=warning]$wv" }
        }
        else {
            $Global:NoLabel = $true
            try { Start-SeDriver -Browser $Global:DefaultBrowser -StartURL $alertTestPage    -ErrorAction Stop } catch {}

        }
        $Env:BrowserID = "$Global:DefaultBrowser on $([System.Environment]::OSVersion.Platform)"
    }
    Context "in $Env:BrowserID with settings ($Env:BrowserOptText)" {
        # It 're-opended the browser and validated "InPrivate" mode by window title  ' {
        #     $DriverProcess = Get-Process *driver | Where-Object { $_.Parent.id -eq $pid }
        #     $BrowserProcess = Get-Process         | Where-Object { $_.Parent.id -eq $DriverProcess.id -and $_.Name -ne "conhost" }
        #     $BrowserProcess.MainWindowTitle                                | Should match $Global:TestCaseSettings[$Global:DefaultBrowser].InPrivateLabel
        # } -Skip:$Global:NoLabel
        It 'opened the right page                                                  ' {
            SeShouldHave -URL -eq $alertTestPage
        }
        It 'Navigated to the child iframe' { #'triggered and dismissed an alert'
            SeShouldHave -Selection "iframe" -By TagName -with id eq iframeResult
            Switch-SeFrame  'iframeResult'
            Get-SeElement "/html/body/button"   | Should -Not -BeNullOrEmpty  #Removed  | Invoke-SeClick  -PassThru
            #Checking the text of the alert is optional. Dissmiss can pass the alert result through
            #{ Wait-SeDriver -Condition AlertState -Value $false -Timeout 15 -ErrorAction Stop } | Should -Not -throw
            #Clear-SeAlert -Alert $Alert -Action Dismiss -PassThru  | Should -Not -BeNullOrEmpty
        }
        It 'reselected the parent frame                                            ' {
            Switch-SeFrame -Parent
            SeShouldHave -Selection "iframe" -By TagName -with id eq iframeResult
        }
        It 'navigated to a new page, and found the "cars" selection box in frame 1 ' {
            Set-SeUrl  $SelectTestPage
            SeShouldHave -Selection "iframe" -By TagName -with id eq iframeResult
            Switch-SeFrame 'iframeResult'
            $e = SeElement -by Name "cars"
            $e | Should -Not -BeNullOrEmpty
            (Get-SeSelectValue -Element $e -All).Items.Text | Should -Contain 'volvo'
        }
        It 'made selections from the "cars" selection box                          ' {
            $e = SeElement -by Name "cars"
            #Values are lower case Text has inital caps comparisons are case sensitve. Index is 0-based
            { $e | Set-SeSelectValue -By Value -value  "Audi" }                                 | Should      -Throw
            { $e | Set-SeSelectValue -By Value -value "audi" }                                  | Should -not -throw
            $e | Set-SeSelectValue -By Index -value "2"; (Get-SeSelectValue -Element $e).Text   | Should      -Be 'Fiat'
            $e | Set-SeSelectValue -By Text  -value "Sa*"
        }
        It 'submitted the form and got the expected response                       ' {
            Get-SeElement '/html/body/form/input' | Invoke-SeClick -Sleep 5
            Switch-SeFrame -Parent
            Switch-SeFrame 'iframeResult'
            SeShouldHave "/html/body/div[1]" -with text match "cars=saab"
        }
        It 'closed the in-private browser instance                                 ' {
            Stop-SeDriver
            if ($DriverProcess.Id) {
                (Get-Process -id $DriverProcess.id ).HasExited             | Should      -Be $true
            }
            if ($BrowserProcess.Id) {
                (Get-Process -id $BrowserProcess.id).HasExited             | Should      -Be $true
            }
        }
    }
    AfterAll { Stop-SeDriver }
}

  
$Global:BrowserOptHash = $Global:TestCaseSettings[$Global:DefaultBrowser].HeadlessOptions
$Env:BrowserOptText = Build-StringFromHash  $Global:BrowserOptHash
$Global:SkipTests = [String]::IsNullOrEmpty($Env:BrowserOptText)

Describe "'Headless' mode browser test" {
    BeforeAll {
        . "$(Join-Path -Path $PSScriptRoot -ChildPath '_TestDependencies.ps1' )"
        $Global:TestCaseSettings = Get-TestCasesSettings 

        $Global:BrowserOptHash = $Global:TestCaseSettings[$Global:DefaultBrowser].HeadlessOptions
        $Env:BrowserOptText = Build-StringFromHash  $Global:BrowserOptHash
        $Global:SkipTests = $true
        if (![String]::IsNullOrEmpty($Env:BrowserOptText)) {
            $Global:SkipTests = $false
            try { $Env:BrowserID = Start-SeDriver -Browser $Global:DefaultBrowser -StartURL $env:SITE_URL  @BrowserOptHash  -ErrorAction Stop }catch {}
        } 
        $Env:BrowserID = "$Global:DefaultBrowser on $([System.Environment]::OSVersion.Platform)"
    }
    Context "in $Env:BrowserID with settings ($Env:BrowserOptText)" {
        It 're-opened the Browser in "Headless" mode' {
            if ($PSVersionTable.PSVersion.Major -eq 5) {
                $Processes = Get-CimInstance -Class Win32_Process
                $DriverProcess = $Processes | Where { $_.Name -like '*driver.exe' -and $_.ParentProcessId -eq $Pid }
                $BrowserProcess = $Processes | Where-Object { $_.ParentProcessId -eq $DriverProcess.ProcessId -and $_.Name -ne 'conhost.exe' }
                if ($BrowserProcess -ne $null) {
                    (Get-process -Id $BrowserProcess.ProcessId).MainWindowHandle   | Should      -be 0
                }
            }
            else {
                $DriverProcess = Get-Process *driver | Where-Object { $_.Parent.id -eq $pid }
                $BrowserProcess = Get-Process         | Where-Object { $_.Parent.id -eq $DriverProcess.id -and $_.Name -ne 'conhost' }
                $BrowserProcess.MainWindowHandle  | Select-Object -First 1     | Should      -be 0
            }
        }
        it 'did a google Search                                                    ' {
            Set-SeUrl 'https://www.google.com/ncr'
            SeShouldHave -by Name q
            SeShouldHave -by ClassName 'gLFyf'
            SeShouldHave -By Name q -PassThru | Where Displayed -eq $true | 
                Select-Object -First 1 | Invoke-SeKeys -Keys 'Powershell-Selenium{{Enter}}' -PassThru  | 
                    should -Not -BeNullOrEmpty

            SeShouldHave '//*[@id="tsf"]/div[2]/div[1]/div[1]/a' -PassThru |
                Invoke-SeClick -PassThru                 | should -Not -BeNullOrEmpty
        }
        It 'closed the browser a third time                                        ' {
            Stop-SeDriver
            Get-SeDriver -Current                                          | Should      -BeNullOrEmpty
            if ($DriverProcess.Id) {
                (Get-Process -id $DriverProcess.id ).HasExited             | Should      -Be $true
            }
            if ($BrowserProcess.Id) {
                (Get-Process -id $BrowserProcess.id).HasExited             | Should      -Be $true
            }
        }
    } -Skip:$Global:SkipTests
    AfterAll { Stop-SeDriver }
}