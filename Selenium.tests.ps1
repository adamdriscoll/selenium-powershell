Import-Module (Join-Path $PSScriptRoot "Selenium.psd1") -Force

Describe "Verify the Binaries SHA256 Hash" {
    It "Check WebDriver.dll Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/0ee619b1786cf5971c0f9c6ee1859497aecba93a4953cf92fea998e8eefadf3c/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\WebDriver.dll).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\WebDriver.dll.sha256)
    }

    It "Check WebDriver.Support.dll Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/b59ba7d0cffe43e722b13ad737cf596f030788b86b5b557cb479f0b6957cce8a/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\WebDriver.Support.dll).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\WebDriver.Support.dll.sha256)
    }

    It "Check ChromeDriver.exe Hash"{
        # The ChromeDriver.exe was extracted from https://chromedriver.storage.googleapis.com/76.0.3809.68/chromedriver_win32.zip its VirusTotal Scan URL - https://www.virustotal.com/gui/url/69ffe387a3fa4fbf8a108391580f1a0befb8b96b82486da4417cfcdab4add4d4/detection
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/66cfa645f83fde41720beac7061a559fd57b6f5caa83d7918f44de0f4dd27845/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\chromedriver.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\chromedriver.exe.sha256)
    }
    
    It "Check ChromeDriver Linux Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/3da69344b8b2b3b7e1497378672231a179eed6b3a0fdccbfacd3d053612e2547/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\linux\chromedriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\linux\chromedriver.sha256)
    }

    It "Check ChromeDriver MacOS Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/57097bb65200f003152906c831ccd226ebbd5a9fd47df46f18adc29f7d01f2f0/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\macos\chromedriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\macos\chromedriver.sha256)
    }

    It "Check GeckoDriver.exe Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/1ae81b2a6f40f7d11be3c91c4d83977ae0c0897bd5d154c02a6d869b58866b58/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\geckodriver.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\geckodriver.exe.sha256)
    }

    It "Check GeckoDriver Linux Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/4490a47280ab38f68511ac0dfff214bfad89bfd5442b1c3096c28d5372dfe2e9/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\linux\geckodriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\linux\geckodriver.sha256)
    }

    It "Check GeckoDriver MacOS Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/1f3873a8ee0b2cb9f2918329cbdf0d65e45c0182127ea03520bec70f0dab3917/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\macos\geckodriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\macos\geckodriver.sha256)
    }

    It "Check IEDriverServer.exe Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/a1e26b0e8cb5f8db1cd784bac71bbf540485d81e697293b0b4586e25a31a8187/detection - this driver seems to have 2 false positives and is marked as clean in the comments
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\IEDriverServer.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\IEDriverServer.exe.sha256)
    }

    It "Check MicrosoftWebDriver.exe Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/6e8182697ea5189491b5519d8496a3392e43741b7c0515130f2f8205881d208e/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\MicrosoftWebDriver.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\MicrosoftWebDriver.exe.sha256)
    }
}

Describe "Start-SeChrome" {
    Context "Should Start Chrome Driver" {
        $Driver = Start-SeChrome 
        Stop-SeDriver $Driver
    }
}

Describe "Start-SeChrome headless" {
    Context "Should Start Chrome Driver in headless mode" {
        $Driver = Start-SeChrome -Headless
        Stop-SeDriver $Driver
    }
}

Describe "Start-SeFirefox" {
    Context "Should Start Firefox Driver" {
        $Driver = Start-SeFirefox 
        Stop-SeDriver $Driver
    }
}

Describe "Start-SeEdge" {
    Context "Should Start Edge Driver" {
        if(!$IsLinux -and !$IsMacOS){
            $Driver = Start-SeEdge 
            Stop-SeDriver $Driver
        }
    }
}

Describe "Start-SeInternetExplorer" {
    Context "Should Start InternetExplorer Driver" {
        if(!$IsLinux -and !$IsMacOS){
            $Driver = Start-SeInternetExplorer 
            Stop-SeDriver $Driver
        }
    }
}

Describe "Get-SeCookie" {
    $Driver = Start-SeFirefox
    Context "Should get cookies from google" {
        Enter-SeUrl -Driver $Driver -Url "http://www.google.com"

        Get-SeCookie $Driver
    }
    Stop-SeDriver $Driver
}

Describe "Send-SeKeys" {
    $Driver = Start-SeFirefox
    Enter-SeUrl -Driver $Driver -Url "http://www.google.com"
    Context "Find-SeElement" {
        It "By Css" {
            $SearchInput = Find-SeElement -Driver $Driver -Css "input[name='q']"
            Send-SeKeys -Element $SearchInput -Keys "test"
        }
    }
    Stop-SeDriver $Driver
}