function New-SeWindow {
    [CmdletBinding()]
    param(
        [ValidateURIAttribute()]
        [StringUrlTransformAttribute()]
        $Url,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver 
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        $Windows = Get-SeWindow
        $Driver.ExecuteScript('window.open()')
        $WindowsNewSet = Get-SeWindow
        $NewWindowHandle = (Compare-Object -ReferenceObject $Windows -DifferenceObject $WindowsNewSet).Inputobject
        Switch-SeWindow -Window $NewWindowHandle
        if ($PSBoundParameters.ContainsKey('Url')) { Set-SeUrl -Url $Url }
    }
}