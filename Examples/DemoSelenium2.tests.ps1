<#
.description
    This is a reworking of the C# file used for the selenium test in the the mslearn training "Deploy applications with Azure DevOps" at
    https://docs.microsoft.com/en-gb/learn/modules/run-functional-tests-azure-pipelines/5-write-ui-tests
    The C# File is https://github.com/MicrosoftDocs/mslearn-tailspin-spacegame-web-deploy/blob/selenium/Tailspin.SpaceGame.Web.UITests/HomePageTest.cs
#>

if (-not $env:SITE_URL) {$env:SITE_URL='http://tailspin-spacegame-web.azurewebsites.net'}
$ModaltestCases = @(
    @{Name       = 'Download Page'
      linkXPath  = '/html/body/div/div/section[2]/div[2]/a'
      modalXPath = '//*[@id="pretend-modal"]/div/div'
    },
    @{Name       = 'Screen Image'
      linkXPath  = '/html/body/div/div/section[3]/div/ul/li[1]/a'
      modalXPath = '/html/body/div[1]/div/div[2]'
    },
    @{Name       = 'Top Player'
      linkXPath  = '/html/body/div/div/section[4]/div/div/div[1]/div[2]/div[2]/div/a/div'
      modalXPath = '//*[@id="profile-modal-1"]/div/div'}
)

Describe "Testing $env:SITE_URL" {
    BeforeAll {
        if ($env:DefaultBrowser)  {SeOpen $env:SITE_URL -In  $env:DefaultBrowser}
        else                      {SeOpen $env:SITE_URL -In Chrome}
    }

    Context "Testing Modal Dialogs in $(($SeDriver.Capabilities.ToDictionary()).browserName) $(($SeDriver.Capabilities.ToDictionary()).browserVersion)" {
        It "Produced the right modal for the <name>" -TestCases $ModaltestCases {
            Param ($linkXPath, $modalXPath)
                SeShouldHave   $modalXPath -With displayed eq $false
                SeElement      $linkXPath | SeClick -JavaScriptClick -SleepSeconds 1
                SeShouldHave   $modalXPath -With displayed eq $true -PassThru| SeElement -By Class 'close' | SeClick -J -S 1
                SeShouldHave  'body'       -By   TagName
                SeShouldHave   $modalXPath -With displayed eq $false
        }
    }
#                               Additional tests would be here
    AfterAll {SeClose}
}