function Invoke-SeClick {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'JavaScript')]
        [OpenQA.Selenium.IWebElement]$Element,

        [Parameter(Mandatory = $true, ParameterSetName = 'JavaScript')]
        [Switch]$JavaScriptClick,

        [Parameter(ParameterSetName = 'JavaScript')]
	[ValidateIsWebDriverAttribute()]
        $Driver = $global:SeDriver
    )

    if ($JavaScriptClick) {
	try {
            $Driver.ExecuteScript("arguments[0].click()", $Element)
	}
	catch {
	    $PSCmdlet.ThrowTerminatingError($_)
	}
    }
    else {
        $Element.Click()
    }

}