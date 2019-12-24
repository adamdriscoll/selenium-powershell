
class ValidateURIAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
    [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        $Out = $null
        if   ([uri]::TryCreate($arguments,[System.UriKind]::Absolute, [ref]$Out)) {return}
        else {throw  [System.Management.Automation.ValidationMetadataException]::new('Incorrect StartURL please make sure the URL starts with http:// or https://')}
        return
    }
}

class ValidateIsWebDriverAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
    [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        if ($arguments -isnot [OpenQA.Selenium.Remote.RemoteWebDriver]) {
                throw  [System.Management.Automation.ValidationMetadataException]::new('Target was not a valid web driver')
        }
        return
    }
}
