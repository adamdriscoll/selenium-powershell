#requires -Module EZOut
#  Install-Module EZOut or https://github.com/StartAutomating/EZOut
$myFile = $MyInvocation.MyCommand.ScriptBlock.File
$myModuleName = $($myFile | Split-Path -Leaf) -replace '\.ezformat\.ps1', '' -replace '\.ezout\.ps1', ''
$myRoot = $myFile | Split-Path
Push-Location $myRoot
$Type = @{TypeName = 'OpenQA.Selenium.Remote.RemoteWebElement' }
$Typed = @{TypeName = 'OpenQA.Selenium.Remote.RemoteWebDriver' }
$formatting = @(
    Write-FormatView @type  -Property Tagname, Enabled, Displayed, Text   -Width 7, 7, 9, 80 -AlignProperty @{Text = 'Left' }
    Write-FormatView @type -AsList -Property Tagname, Text, Enabled, Selected, Location, Size, Displayed 

    Write-FormatView -TypeName 'selenium-powershell/SeFrame' -Property 'TagName', 'Enabled', 'Name', 'Id' -VirtualProperty @{
        Name = { $_.Attributes.name }
        Id   = { $_.Attributes.id }
    }

        Write-FormatView -TypeName 'selenium-powershell/SeInput' -Property 'Tagname','Type*','Enabled','Displayed','Text','Placeholder*','Value*'  -VirtualProperty @{
            'Type*' = {$_.Attributes.type}
            'Placeholder*' = {$_.Attributes.placeholder}
            'Value*' =  {$_.Attributes.value}
        }
    

    # Add your own Write-FormatView here,
    # or put them in a Formatting or Views directory
    foreach ($potentialDirectory in 'Formatting', 'Views') {
        Join-Path $myRoot $potentialDirectory |
            Get-ChildItem -ea ignore |
                Import-FormatView -FilePath { $_.Fullname }
    }
)

$destinationRoot = $myRoot 

if ($formatting) {
    $myFormatFile = Join-Path $destinationRoot "formats/$myModuleName.format.ps1xml"
    $formatting | Out-FormatData -Module $MyModuleName | Set-Content $myFormatFile -Encoding UTF8
}

$types = @(
    Write-TypeView @Type -DefaultDisplay 'Tagname', 'Enabled', 'Displayed', 'Text'
    Write-TypeView @Typed -ScriptProperty @{
        SeTitle = { if ($null -ne $this.SessionId) { $this.Title } }
        SeUrl   = { if ($null -ne $this.SessionId) { $this.Url } }
    } -DefaultDisplay 'SeFriendlyName', 'SeBrowser', 'SeTitle', 'SeUrl' 

    # Add your own Write-T
    #TypeView statements here
    # or declare them in the 'Types' directory
    Join-Path $myRoot Types |
        Get-Item -ea ignore |
            Import-TypeView

)

if ($types) {
    $myTypesFile = Join-Path $destinationRoot "types/$myModuleName.types.ps1xml"
    $types | Out-TypeData | Set-Content $myTypesFile -Encoding UTF8
}
Pop-Location

$Content = Get-Content -Path $myFormatFile | Select -SkipLast 2

$SeSelectViewPath = Join-Path -Path $PSScriptRoot  -ChildPath 'views/SeSelectValueInfo.ps1xml'
$EndOfFile = @'

  </ViewDefinitions>
</Configuration>
'@
($Content | Out-String) + (Get-Content -Path $SeSelectViewPath -raw) + $EndOfFile | Out-File -Encoding utf8 $myFormatFile
