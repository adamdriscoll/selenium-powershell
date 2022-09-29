Add-Type -Path ".\Selenium\3.0.1\assemblies\WebDriver.dll"
$FFPath = ".\FirefoxPortable\App\Firefox64\firefox.exe"
$FirefoxOptions = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
$FirefoxOptions.BrowserExecutableLocation = $((Get-Item $FFPath).FullName)
$Driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($FirefoxOptions)

Enter-SeUrl "http://google.com" -Driver $Driver
