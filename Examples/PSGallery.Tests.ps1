#        SeOpen NewEdge #chrome

Describe "PsGallery Test"  {
    BeforeAll {
        SeNavigate https://www.powershellgallery.com/                                   # Open-SeUrl -Url "https://www.powershellgallery.com/"
    }
    It 'Reached the right page and found the search box'.PadRight(100) {
        SeShouldHave -url eq 'https://www.powershellgallery.com/'
        SeShouldHave '//*[@id="search"]' -PassThru  | SeType "selenium{{Enter}}" -ClearFirst  # $e = Get-SeElement -By XPath '//*[@id="search"]' ; $e.clear(); Send-SeKeys  -Element $e -Keys "selenium{{Enter}}"
    }
    It 'Searched successfully'.PadRight(100){
        SeShouldHave -url -match 'packages\?q=selenium'
        $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
        SeShouldHave $linkpath  TEXT Like *selenium*                               # Long form seShouldHave -Selection $linkpath -By XPath -With TEXT -Operator Like  -Value "*selenium*"
        SeShouldHave $linkpath -with href match selenium  -PassThru | SeClick      # LONG form seShouldHave $linkpath -with href -Operator match -Value "selenium"
                                                                                   # Get-SeElement -By XPath -Selection $linkpath -Driver $global:SeDriver
    }
    It 'Opened the search result page'.PadRight(100) {
        #Current version should be top of the the version history table
        seshouldhave '//*[@id="version-history"]/table/tbody[1]/tr[1]/td[1]/a/b'   -with text -match "current"

        #Project site link should go to the right place
        seShouldHave '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -with text eq "Project Site"
        seShouldHave '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -with href match "selenium"
        seelement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  | seclick
    }
    It 'Went to Github'.PadRight(100) {
        seShouldHave -url  match 'github'
    }
    AfterAll {
        SeClose
    }
}


