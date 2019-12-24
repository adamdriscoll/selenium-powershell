if ($env:DefaultBrowser) {$browser = $env:DefaultBrowser}
else {$browser = "NewEdge"}
SeOpen 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert' -in $browser -SleepSeconds 2

Describe 'Alert test' {
    It 'Opened the right page                                                  ' {
        SeShouldHave -URL -eq 'https://www.w3schools.com/js/tryit.asp?filename=tryjs_alert'
    }
    It 'Found and clicked a button in frame 1                                  ' {
        SeFrame 1
        SeElement    "/html/body/button" | SeClick -SleepSeconds 2 -PassThru | should not beNullOrEmpty
    }
    It 'Saw and dismissed an alert                                             ' {
        SeShouldHave -Alert -PassThru    | SeDismiss -PassThru | should not beNullOrEmpty
    }
    It 'Reselected the parent frame                                            ' {
        SeFrame -Parent
    }
    AfterAll {
        SeClose
    }
}
