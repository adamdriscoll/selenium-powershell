$Script:SeKeys = [OpenQA.Selenium.Keys] | Get-Member -MemberType Property -Static |
    Select-Object -Property Name, @{N = "ObjectString"; E = { "[OpenQA.Selenium.Keys]::$($_.Name)" } }

#region Set path to assemblies on Linux and MacOS and Grant Execution permissions on them
if ($IsLinux) {
    $AssembliesPath = "$PSScriptRoot/assemblies/linux"
}
elseif ($IsMacOS) {
    $AssembliesPath = "$PSScriptRoot/assemblies/macos"
}

# Grant Execution permission to assemblies on Linux and MacOS
if ($AssembliesPath) {
    # Check if powershell is NOT running as root
    Get-Item -Path "$AssembliesPath/chromedriver", "$AssembliesPath/geckodriver" | ForEach-Object {
        if ($IsLinux) { $FileMod = stat -c "%a" $_.FullName }
        elseif ($IsMacOS) { $FileMod = /usr/bin/stat -f "%A" $_.FullName }
        Write-Verbose "$($_.FullName) $Filemod"
        if ($FileMod[2] -ne '5' -and $FileMod[2] -ne '7') {
            Write-Host "Granting $($AssemblieFile.fullname) Execution Permissions ..."
            chmod +x $_.fullname
        }
    }
}

#endregion














<#
@jhoneill Shouldn't -default be assumed if not feed a webdriver? see alternate below
function Stop-SeDriver {
    [alias('SeClose')]
    param(
        [Parameter(ValueFromPipeline = $true, position = 0, ParameterSetName = 'Driver')]
        [ValidateIsWebDriverAttribute()]
        $Driver,
        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [switch]$Default
    )
    if (-not $PSBoundParameters.ContainsKey('Driver') -and $Global:SeDriver -and ($Default -or $MyInvocation.InvocationName -eq 'SeClose')) {
        Write-Verbose -Message "Closing $($Global:SeDriver.Capabilities.browsername)..."
        $Global:SeDriver.Close()
        $Global:SeDriver.Dispose()
        Remove-Variable -Name SeDriver -Scope global
    }
    elseif ($Driver) {
        $Driver.Close()
        $Driver.Dispose()
    }
    else { Write-Warning -Message 'No Driver Specified' }
}
#>



<#
function Enter-SeUrl {
    param($Driver, $Url)
    $Driver.Navigate().GoToUrl($Url)
}
#>



<#
function Find-SeElement {
    param(
        [Parameter()]
        $Driver,
        [Parameter()]
        $Element,
        [Parameter()][Switch]$Wait,
        [Parameter()]$Timeout = 30,
        [Parameter(ParameterSetName = "ByCss")]
        $Css,
        [Parameter(ParameterSetName = "ByName")]
        $Name,
        [Parameter(ParameterSetName = "ById")]
        $Id,
        [Parameter(ParameterSetName = "ByClassName")]
        $ClassName,
        [Parameter(ParameterSetName = "ByLinkText")]
        $LinkText,
        [Parameter(ParameterSetName = "ByPartialLinkText")]
        $PartialLinkText,
        [Parameter(ParameterSetName = "ByTagName")]
        $TagName,
        [Parameter(ParameterSetName = "ByXPath")]
        $XPath
    )


    process {

        if ($null -ne $Driver -and $null -ne $Element) {
            throw "Driver and Element may not be specified together."
        }
        elseif ($null -ne $Driver) {
            $Target = $Driver
        }
        elseif (-ne $Null $Element) {
            $Target = $Element
        }
        else {
            "Driver or element must be specified"
        }

        if ($Wait) {
            if ($PSCmdlet.ParameterSetName -eq "ByName") {
                $TargetElement = [OpenQA.Selenium.By]::Name($Name)
            }

            if ($PSCmdlet.ParameterSetName -eq "ById") {
                $TargetElement = [OpenQA.Selenium.By]::Id($Id)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
                $TargetElement = [OpenQA.Selenium.By]::LinkText($LinkText)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByPartialLinkText") {
                $TargetElement = [OpenQA.Selenium.By]::PartialLinkText($PartialLinkText)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByClassName") {
                $TargetElement = [OpenQA.Selenium.By]::ClassName($ClassName)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByTagName") {
                $TargetElement = [OpenQA.Selenium.By]::TagName($TagName)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByXPath") {
                $TargetElement = [OpenQA.Selenium.By]::XPath($XPath)
            }

            if ($PSCmdlet.ParameterSetName -eq "ByCss") {
                $TargetElement = [OpenQA.Selenium.By]::CssSelector($Css)
            }

            $WebDriverWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($Driver, (New-TimeSpan -Seconds $Timeout))
            $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
            $WebDriverWait.Until($Condition)
        }
        else {
            if ($PSCmdlet.ParameterSetName -eq "ByName") {
                $Target.FindElements([OpenQA.Selenium.By]::Name($Name))
            }

            if ($PSCmdlet.ParameterSetName -eq "ById") {
                $Target.FindElements([OpenQA.Selenium.By]::Id($Id))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByLinkText") {
                $Target.FindElements([OpenQA.Selenium.By]::LinkText($LinkText))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByPartialLinkText") {
                $Target.FindElements([OpenQA.Selenium.By]::PartialLinkText($PartialLinkText))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByClassName") {
                $Target.FindElements([OpenQA.Selenium.By]::ClassName($ClassName))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByTagName") {
                $Target.FindElements([OpenQA.Selenium.By]::TagName($TagName))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByXPath") {
                $Target.FindElements([OpenQA.Selenium.By]::XPath($XPath))
            }

            if ($PSCmdlet.ParameterSetName -eq "ByCss") {
                $Target.FindElements([OpenQA.Selenium.By]::CssSelector($Css))
            }
        }
    }
}
#>















