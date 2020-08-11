#TODO parameter set hell
function Get-SeSelectionOption {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param (

        [Parameter(Mandatory = $true, ParameterSetName = 'byValue', Position = 0, ValueFromPipelineByPropertyName = $true)]
        [String]$ByValue,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [OpenQA.Selenium.IWebElement]$Element,

        [Parameter(Mandatory = $true, ParameterSetName = 'byText', ValueFromPipelineByPropertyName = $true)]
        [String]$ByFullText,

        [Parameter(Mandatory = $true, ParameterSetName = 'bypart', ValueFromPipelineByPropertyName = $true)]
        [String]$ByPartialText,

        [Parameter(Mandatory = $true, ParameterSetName = 'byIndex', ValueFromPipelineByPropertyName = $true)]
        [int]$ByIndex,

        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byValue')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byText')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byIndex')]
        [switch]$Clear,

        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [switch]$ListOptionText,

        [Parameter(Mandatory = $true, ParameterSetName = 'multi')]
        [switch]$IsMultiSelect,

        [Parameter(Mandatory = $true, ParameterSetName = 'selected')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byValue')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byText')]
        [Parameter(Mandatory = $false, ParameterSetName = 'bypart')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byIndex')]
        [switch]$GetSelected,

        [Parameter(Mandatory = $true, ParameterSetName = 'allSelected')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byValue')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byText')]
        [Parameter(Mandatory = $false, ParameterSetName = 'bypart')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byIndex')]
        [switch]$GetAllSelected,

        [Parameter(Mandatory = $false, ParameterSetName = 'byValue')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byText')]
        [Parameter(Mandatory = $false, ParameterSetName = 'bypart')]
        [Parameter(Mandatory = $false, ParameterSetName = 'byIndex')]
        [switch]$PassThru
    )
    try {
        #byindex can be 0, but ByText and ByValue can't be empty strings
        if ($ByFullText -or $ByPartialText -or $ByValue -or $PSBoundParameters.ContainsKey('ByIndex')) {
            if ($Clear) {
                if ($ByText) { [SeleniumSelection.Option]::DeselectByText($Element, $ByText) }
                elseif ($ByValue) { [SeleniumSelection.Option]::DeselectByValue($Element, $ByValue) }
                else { [SeleniumSelection.Option]::DeselectByIndex($Element, $ByIndex) }
            }
            else {
                if ($ByText) { [SeleniumSelection.Option]::SelectByText($Element, $ByText, $false) }
                if ($ByPartialText) { [SeleniumSelection.Option]::SelectByText($Element, $ByPartialText, $true) }
                elseif ($ByValue) { [SeleniumSelection.Option]::SelectByValue($Element, $ByValue) }
                else { [SeleniumSelection.Option]::SelectByIndex($Element, $ByIndex) }
            }
        }
        elseif ($Clear) { [SeleniumSelection.Option]::DeselectAll($Element) }
        if ($IsMultiSelect) {
            return [SeleniumSelection.Option]::IsMultiSelect($Element)
        }
        if ($PassThru -and ($GetAllSelected -or $GetAllSelected)) {
            Write-Warning -Message "-Passthru option ignored because other values are returned"
        }
        if ($GetSelected) {
            return [SeleniumSelection.Option]::GetSelectedOption($Element).text
        }
        if ($GetAllSelected) {
            return [SeleniumSelection.Option]::GetAllSelectedOptions($Element).text
        }
        if ($PSCmdlet.ParameterSetName -eq 'default') {
            [SeleniumSelection.Option]::GetOptions($Element) | Select-Object -ExpandProperty Text
        }
        elseif ($PassThru) { $Element }
    }
    catch {
        throw "An error occured checking the selection box, the message was:`r`n $($_.exception.message)"
    }
}