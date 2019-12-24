SeOpen NewEdge #chrome                                                                      #  $global:sedriver = Start-SeChrome

Describe "PsGallery Test"  {
    BeforeAll {
        SeNavigate https://www.powershellgallery.com/                                       # Enter-SeUrl -Url "https://www.powershellgallery.com/" -driver $global:sedriver
    }
    It 'Reached the right starting page'.PadRight(100) {
        SeShouldHave -url eq 'https://www.powershellgallery.com/'
    }
    It 'Found and typed in the search box on the starting page'.PadRight(100) {
        SeElement -by XPath '//*[@id="search"]' |                                           # $e = Find-SeElement -XPath '//*[@id="search"]' -driver $global:seDriver
            SeType -ClearFirst "selenium{{Enter}}" -PassThru | should not beNullorEmpty     # $e | should not beNullor empty ; $e.clear(); Send-SeKeys  -Element $e -Keys "selenium{{Enter}}"
    }
    $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
    It 'Searched successfully'.PadRight(100){
        SeShouldHave -url match 'packages\?q=selenium'
       #seShouldHave -Selection $linkpath -By XPath -With TEXT -Operator Like  -Value "*selenium*" #shortens to:
        SeShouldHave $linkpath  Text like *selenium*
        #  -match as an alias for "-value and infer that operator should be 'match'"
        SeShouldHave $linkpath -With href -match selenium  -PassThru | SeClick              #  $e=  Find-SeElement -xpath $linkpath -Driver $global:SeDriver ; Invoke-SeClick $e
    }
    It 'Opened the search result page and found the expected content'.PadRight(100) {
        #can test for the same thing on multiple page elements - eg. presence of element
        SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
                     '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'

        #Current version should be top of the the version history table
        SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

        #Get the element, check values of a property and an attribute, if they pass, click the element.
        #if they fail (but the elemenet was found), use stanadard pester to fail the test.
        SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
            Where-Object {($_.text -eq "Project Site") -and ($_.GetAttribute('href') -match "selenium") } |
                SeClick -PassThru    | should not benullorempty
    }
    It 'Went to Github from the project link on the search result'.PadRight(100) {
        SeShouldHave -url  match 'github'
    }
    AfterAll {
        SeClose
    }
}
