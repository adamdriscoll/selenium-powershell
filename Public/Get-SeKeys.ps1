function Get-SeKeys {
    [OpenQA.Selenium.Keys] | 
        Get-Member -MemberType Property -Static | 
            Select-Object -Property Name, @{N = "ObjectString"; E = { "[OpenQA.Selenium.Keys]::$($_.Name)" } }
}