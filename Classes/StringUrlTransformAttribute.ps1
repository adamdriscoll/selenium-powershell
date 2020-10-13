class StringUrlTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    # Implement the Transform() method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        <#
            The parameter value(s) are passed in here as $inputData. We aren't accepting array input
            for our function, but it's good to make these fairly versatile where possible, so that
            you can reuse them easily!
        #>
        $outputData = switch ($inputData) {
            { $_ -is [string] } { 
                if ($_ -match '://') { 
                    $_ 
                }
                else {
                    "https://$_"
                }
            }
            default {
                # If we hit something we can't convert, throw an exception
                throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
                    "Only String attributes are supported."
                )
            }
        }

        return $OutputData
    }

}