class PointTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    # Implement the Transform() method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        <#
            The parameter value(s) are passed in here as $inputData. We aren't accepting array input
            for our function, but it's good to make these fairly versatile where possible, so that
            you can reuse them easily!
        #>
        $outputData = switch ($inputData) {
            { $_ -is [PointTransformAttribute] } { $_ }
            { $_ -is [int] } { [System.Drawing.Point]::new($_, $_) }
            { $_ -is [string] -and (($_ -split '[,x]').count -eq 2) } { 
                $sp = $_ -split '[,x]'
                [System.Drawing.Point]::new($sp[0], $sp[1]) 
            }
            default {
                # If we hit something we can't convert, throw an exception
                throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
                    "Could not convert input '$_' to a valid Point object."
                )
            }
        }

        return $OutputData
    }

}