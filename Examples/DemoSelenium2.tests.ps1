<#
.description
    This is a reworking of the C# file used for the selenium test in the the mslearn training "Deploy applications with Azure DevOps" at
    https://docs.microsoft.com/en-gb/learn/modules/run-functional-tests-azure-pipelines/5-write-ui-tests 
    The C# File is https://github.com/MicrosoftDocs/mslearn-tailspin-spacegame-web-deploy/blob/selenium/Tailspin.SpaceGame.Web.UITests/HomePageTest.cs

#>
#$env:SITE_URL='http://tailspin-spacegame-web.azurewebsites.net'
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

Function ClickOpensModal {
	Param ($linkXPath , $modalXPath)
    Get-SeElement -by XPath  $linkXPath | Send-SeClick -JavaScriptClick -Sleep 1
	$modal = SeElement  $modalXPath -by XPath
	if (-not $modal.displayed) {Write-Warning -Message 'Modal not displayed'; return $false}
	else {
       $modal | SeElement ClassName 'close'  | seclick -Js -Sleep 1	
	   $null =  SeElement TagName   'body'
   	   if ($modal.displayed)   {Write-Warning -Message 'Modal did not close'; return $false}
	   else {return $true}
	}
}

Describe "Testing $env:SITE_URL" {
    BeforeAll { Chrome $env:SITE_URL -AsDefaultDriver }
    
    Context "Testing Modal Dialogs" {
        It "Produced the right modal for the <name>" -TestCases $ModaltestCases {
            Param ($linkXPath, $modalXPath)
            ClickOpensModal $linkXPath  $modalXPath | should contain $true
        }
    }
    
    #more tests here
    
    AfterAll {Stop-SeDriver -Default }
}