Import-Module (Join-Path $PSScriptRoot "Selenium.psd1") -Force

Describe "Verify the Binaries SHA256 Hash" {
    It "Check WebDriver.dll Hash"{
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/0ee619b1786cf5971c0f9c6ee1859497aecba93a4953cf92fea998e8eefadf3c/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\WebDriver.dll).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\WebDriver.dll.sha256)
    }

    It "Check WebDriver.Support.dll Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/b59ba7d0cffe43e722b13ad737cf596f030788b86b5b557cb479f0b6957cce8a/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\WebDriver.Support.dll).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\WebDriver.Support.dll.sha256)
    }

    It "Check ChromeDriver.exe Hash" {
        # The ChromeDriver.exe was extracted from https://chromedriver.storage.googleapis.com/77.0.3865.40/chromedriver_win32.zip its VirusTotal Scan URL - https://www.virustotal.com/gui/url/959e6d054ab90deb141b6802dbac103c1a88c3ceb1ea9e51419e9f8d1fce3986/detection
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/16b847237787d54c562ea2fc9e52dcf8830f638718905b611c8bad11897a34a8/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\chromedriver.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\chromedriver.exe.sha256)
    }
    
    It "Check ChromeDriver Linux Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/b470963df497fdafc6de8e033e059e97ae786589994b23cbcf044677d2209512/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\linux\chromedriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\linux\chromedriver.sha256)
    }

    It "Check ChromeDriver MacOS Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/c8726dbd612d209957731372ec6e105ef4851f2e70bc3737caedc4c58218382c/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\macos\chromedriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\macos\chromedriver.sha256)
    }

    It "Check GeckoDriver.exe Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/3104a5ba26ff22962d0d75536506c081939bcd7580ba16503d4f3ce5507d06d2/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\geckodriver.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\geckodriver.exe.sha256)
    }

    It "Check GeckoDriver Linux Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/4490a47280ab38f68511ac0dfff214bfad89bfd5442b1c3096c28d5372dfe2e9/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\linux\geckodriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\linux\geckodriver.sha256)
    }

    It "Check GeckoDriver MacOS Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/1f3873a8ee0b2cb9f2918329cbdf0d65e45c0182127ea03520bec70f0dab3917/detection
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\macos\geckodriver).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\macos\geckodriver.sha256)
    }

    It "Check IEDriverServer.exe Hash" {
        # VirusTotal Scan URL = https://www.virustotal.com/gui/file/a1e26b0e8cb5f8db1cd784bac71bbf540485d81e697293b0b4586e25a31a8187/detection - this driver seems to have 2 false positives and is marked as clean in the comments
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $PSScriptRoot\assemblies\IEDriverServer.exe).Hash
        $Hash |Should Be (Get-Content -Path $PSScriptRoot\assemblies\IEDriverServer.exe.sha256)
    }

    It "Check MicrosoftWebDriver.exe Hash" {
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

Describe "Start-SeChrome with Options" {
    Context "Should Start Chrome Driver with different startup options" {
        It "Start Chrome with StartURL" {
            $Driver = Start-SeChrome -StartURL 'https://github.com/adamdriscoll/selenium-powershell'
            Stop-SeDriver $Driver
        }

        It "Start Chrome in Headless mode" {
            $Driver = Start-SeChrome -Headless
            Stop-SeDriver $Driver
        }

        It "Start Chrome Minimize" {
            $Driver = Start-SeChrome -Minimize
            Stop-SeDriver $Driver
        }

        It "Start Chrome Maximized" {
            $Driver = Start-SeChrome -Maximized
            Stop-SeDriver $Driver
        }

        It "Start Chrome Incognito" {
            $Driver = Start-SeChrome -Incognito
            Stop-SeDriver $Driver
        }
        
        It "Start Chrome Fullscreen" {
            $Driver = Start-SeChrome -Fullscreen
            Stop-SeDriver $Driver
        }

        It "Start Chrome Maximized and Incognito" {
            $Driver = Start-SeChrome -Maximized -Incognito
            Stop-SeDriver $Driver
        }

        It "Start Chrome with Multiple arguments" {
            $Driver = Start-SeChrome -Arguments @('Incognito','start-maximized')
            Stop-SeDriver $Driver
        }
    }
}

Describe "Start-SeFirefox"{
    Context "Should Start Firefox Driver" {
        $Driver = Start-SeFirefox 
        Stop-SeDriver $Driver
    }
}

Describe "Start-SeFirefox with Options" {
    Context "Should Start Firefox Driver with different startup options" {
        It "Start Firefox with StartURL" {
            $Driver = Start-SeFirefox -StartURL 'https://github.com/adamdriscoll/selenium-powershell'
            Stop-SeDriver $Driver
        }

        It "Start Firefox in Headless mode" {
            $Driver = Start-SeFirefox -Headless
            Stop-SeDriver $Driver
        }

        It "Start Firefox Minimize" {
            $Driver = Start-SeFirefox -Minimize
            Stop-SeDriver $Driver
        }

        It "Start Firefox Maximized" {
            $Driver = Start-SeFirefox -Maximized
            Stop-SeDriver $Driver
        }

        It "Start Firefox PrivateBrowsing (Incognito)" {
            $Driver = Start-SeFirefox -PrivateBrowsing
            Stop-SeDriver $Driver
        }
        
        It "Start Firefox Fullscreen" {
            $Driver = Start-SeFirefox -Fullscreen
            Stop-SeDriver $Driver
        }

        It "Start Firefox Maximized and PrivateBrowsing (Incognito)" {
            $Driver = Start-SeFirefox -Maximized -PrivateBrowsing
            Stop-SeDriver $Driver
        }

        It "Start Firefox with Multiple arguments" {
            $Driver = Start-SeFirefox -Arguments @('-headless','-private')
            Stop-SeDriver $Driver
        }
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
    Enter-SeUrl -Driver $Driver -Url "http://www.google.com/ncr"
    Context "Find-SeElement" {
        It "By Css" {
            $SearchInput = Find-SeElement -Driver $Driver -Css "input[name='q']"
            Send-SeKeys -Element $SearchInput -Keys "test"
        }
    }
    Stop-SeDriver $Driver
}

Describe "Find-SeElement Firefox" {
    $Driver = Start-SeFirefox
    Enter-SeUrl -Driver $Driver -Url "http://www.google.com/ncr"
    Context "Find-SeElement" {
        It "By Css" {
            $SearchInput = Find-SeElement -Driver $Driver -Css "input[name='q']"
        }
    }
    
    Context "Find-SeElement -Wait" {
        It "By Name"{
            $SearchInput = Find-SeElement -Driver $Driver -Wait -Name q -Timeout 60
        }
    }

    Stop-SeDriver $Driver
}

