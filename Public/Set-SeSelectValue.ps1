function Set-SeSelectValue {
    param (
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelect]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelect]) })]
        [SeBySelect]$By = [SeBySelect]::Text,
        [Parameter( ValueFromPipeline = $true, Position = 1, Mandatory = $true)]
        [Object]$value,
        [OpenQA.Selenium.IWebElement]$Element
    )
    try {
        $IsMultiSelect = [SeleniumSelection.Option]::IsMultiSelect($Element)

        if (-not $IsMultiSelect -and $Value.Count -gt 1) {
            Write-Error 'This select control do not accept multiple values'
            return $null
        }
  
        #byindex can be 0, but ByText and ByValue can't be empty strings
        switch ($By) {
            { $_ -eq [SeBySelect]::Text } {
                $HaveWildcards = $null -ne (Get-WildcardsIndices -Value $value)

                if ($HaveWildcards) {
                    $ValuesToSelect = Get-SeSelectValue -Element $Element  -All
                    $ValuesToSelect = $ValuesToSelect | Where-Object { $_ -like $Value }
                    if (! $IsMultiSelect) { $ValuesToSelect = $ValuesToSelect | Select -first 1 }
                    Foreach ($v in $ValuesToSelect) {
                        [SeleniumSelection.Option]::SelectByText($Element, $v, $false)     
                    }
                }
                else {
                    [SeleniumSelection.Option]::SelectByText($Element, $value, $false) 
                }
               
            }
            
            { $_ -eq [SeBySelect]::Value } { [SeleniumSelection.Option]::SelectByValue($Element, $value) } 
            { $_ -eq [SeBySelect]::Index } { [SeleniumSelection.Option]::SelectByIndex($Element, $value) }
        }
    }
    catch {
        throw "An error occured checking the selection box, the message was:`r`n $($_.exception.message)"
    }
}