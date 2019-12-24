SeOpen https://www.powershellgallery.com/ -In NewEdge

Describe "PsGallery Test"  {
    It 'Reached the right starting page                                       ' {
        SeShouldHave -url eq 'https://www.powershellgallery.com/'
    }
    It 'Found and typed in the search box on the starting page                 '{
        SeElement -by XPath '//*[@id="search"]' | SeType -ClearFirst "selenium{{Enter}}" -PassThru | should not beNullorEmpty
    }
    $linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'
    It 'Searched successfully                                                  '{
        SeShouldHave -url                 match 'packages\?q=selenium'
        SeShouldHave $linkpath -With href match selenium
        SeShouldHave $linkpath -With Text like *selenium* -PassThru | SeClick
    }
    It 'Opened the search result page and found the expected content           '{
        SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' ,
                     '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'

        SeShouldHave '//*[@id="version-history"]/table/tbody[1]/tr[1]/ td[1]/a/b' -With text match "current"

        SeElement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  |
            Where {($_.text -eq "Project Site") -and ($_.GetAttribute('href') -match "selenium") } |
                SeClick -PassThru    | should not benullorempty
    }
    It 'Went to Github from the project link on the search result              ' {
        SeShouldHave -url  match 'github'
    }
    AfterAll { SeClose }
}
