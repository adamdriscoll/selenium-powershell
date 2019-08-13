Import-Module (Join-Path $PSScriptRoot "Selenium.psd1") -Force

Describe "Start-SeChrome" {
    Context "Should Start Chrome Driver" {
        $Driver = Start-SeChrome 
        Stop-SeDriver $Driver
    }
}

Describe "Start-SeChrome headless" {
    Context "Should Start Chrome Driver in headless mode" {
        $Driver = Start-SeChrome -Headless $true
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
        $Driver = Start-SeEdge 
        Stop-SeDriver $Driver
    }
}

Describe "Start-SeInternetExplorer" {
    Context "Should Start InternetExplorer Driver" {
        $Driver = Start-SeInternetExplorer 
        Stop-SeDriver $Driver
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