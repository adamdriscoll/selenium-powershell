
SeOpen  chrome
SeNavigate https://www.powershellgallery.com/    # Open-SeUrl -Url "https://www.powershellgallery.com/"


SeElement '//*[@id="search"]' | SeType -keys "selenium{{Enter}}"            # $e = Get-SeElement -By XPath '//*[@id="search"]' ; Send-SeKeys  -Element $e -Keys "selenium{{Enter}}"
$linkpath = '//*[@id="skippedToContent"]/section/div[1]/div[2]/div[2]/section[1]/div/table/tbody/tr/td[1]/div/div[2]/header/div[1]/h1/a'

seShouldHave $linkpath  TEXT Like "*selenium*"                              # Long form seShouldHave -Value $linkpath -By XPath -With TEXT -Operator Like  -Value "*selenium*"
seShouldHave $linkpath -with href match "selenium"                          # LONG form seShouldHave $linkpath -with href -Operator match -Value "selenium"     
SeElement    $linkPath | seclick                                            # Get-SeElement -By XPath -Value $linkpath -Driver $global:SeDriver
#Current version should be top of the the version history table 
seshouldhave '//*[@id="version-history"]/table/tbody[1]/tr[1]/td[1]/a/b'   -with text -match "current" -Verbose
#Project site link should go to the right place
seShouldHave '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -with text eq "Project Site"
seShouldHave '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a' -with href match "selenium"
seelement    '//*[@id="skippedToContent"]/section/div/aside/ul[2]/li[1]/a'  | seclick

seShouldHave -url  match "github"




