function ConvertTo-Selenium {
    <#
        .SYNOPSIS
        Convert Selenium IDE .side recording file to PowerShell commands.
    #>
    [CmdletBinding()]
    param (
        # Path to .side file.
        [Parameter(Mandatory)]
        [String]$Path
    )

    $ByMap = @{
        id       = 'Id'
        css      = 'CssSelector'
        xpath    = 'XPath'
        linkText = 'LinkText'
        label    = 'Text'
        index    = 'Index'
    }
    function Get-Replace {
        <#
        .SYNOPSIS
        Helper function to convert ScriptBlocks to strings.

        Parameter set 1:
        Replace -From [String] with -To [String].
        -QuotesTo adds quotes around -To.
        -SplitTo take only the value part from "label=value" of -To.

        Parameter set 2:
        -By "label=value" replaces input "-By $By" with "-By <Selector> -value '<value>'".
        * $ByMap is used to map the labels.
    #>
        [CmdletBinding()]
        param (
            [String]$From,
            [String]$To,
            [String]$By,
            [Parameter(ValueFromPipeline)]
            $InputObject,
            [switch]$QuotesTo,
            [switch]$SplitTo
        )
        process {
            $String = $InputObject.ToString().Trim()
            if ($From) {
                if ($QuotesTo) {
                    $To = '"' + $To + '"'
                }
                if ($SplitTo) {
                    $To = $To.Split('=', 2)[1]
                }
                $String = $String.Replace($From, $To)
            }
            if ($By) {
                $String = $String.Replace('-By $By', ('-By {0} -value {1}' -f $ByMap[$By.Split('=', 2)[0]], ('"' + $By.Split('=', 2)[1] + '"')))
            }
            $String
        }
    }

    $ActionMap = @{
        click    = { Invoke-SeClick }
        sendKeys = { Invoke-SeKeys -Keys $Keys }
        type     = { Invoke-SeKeys -Keys $Keys }
        select   = { Set-SeSelectValue -By $By }
    }

    $Recording = Get-Content -Path $Path | ConvertFrom-Json
    $BaseUrl = [Uri]$Recording.url
    $PsCode = $(
        '# Project: ' + $Recording.name
        foreach ($Test in $Recording.tests) {
            '# Test: ' + $Test.name
            foreach ($Command in $Test.commands) {
                switch ($Command) {
                    { $_.comment } { '# Description: ' + $_.comment }
                    { $_.command -eq 'open' } {
                        $Url = if ([Uri]::IsWellFormedUriString($_.target, [System.UriKind]::Relative)) {
                            [Uri]::new($BaseUrl, $_.target)
                        }
                        else {
                            $_.target
                        }
                        { Set-SeUrl -Url $Url } | Get-Replace -From '$Url' -To $Url -QuotesTo
                        Break
                    }
                    { $_.command -eq 'close' } { { Stop-SeDriver } ; Break }
                    { $_.command -in $ActionMap.Keys } {
                        $Action = $ActionMap[$_.command] | Get-Replace -From '$Keys' -To $_.value -QuotesTo -By $_.value
                        { Get-SeElement -By $By | _Action_ } | Get-Replace -From '_Action_' -To $Action -By $_.target
                        Break
                    }
                    { $_.command -eq 'selectFrame' } {
                        if ($_.target -eq 'relative=parent') {
                            { Switch-SeFrame -Parent }
                        }
                        else {
                            { $null = (Get-SeDriver -Current).SwitchTo().Frame($Index) } | Get-Replace -From '$Index' -To $_.target -SplitTo
                        }
                        Break
                    }
                    Default { '# Unsupported command. Command: "{0}", Target: "{1}", Value: "{2}", Comment: "{3}".' -f $_.command, $_.target, $_.value, $_.comment }
                }
            }
        }
    ) | Get-Replace
    [ScriptBlock]::Create($PsCode -join [Environment]::NewLine)
}