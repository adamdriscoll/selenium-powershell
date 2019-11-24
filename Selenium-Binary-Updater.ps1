param(
    [Parameter(Mandatory=$true)][ValidateSet('Chrome','Firefox','Edge')]$Browser
)

$TempDir = [System.IO.Path]::GetTempPath()

switch ($Browser){
    'Chrome'{
        $LatestChromeStableRelease = Invoke-WebRequest 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' | Select-Object -ExpandProperty Content
        $ChromeBuilds = @('chromedriver_linux64','chromedriver_mac64','chromedriver_win32')
        
        foreach ($Build in $ChromeBuilds){
            switch($Build){
                'chromedriver_linux64'{
                    $AssembliesDir = "$PSScriptRoot/assemblies/linux"
                    $BinaryFileName = 'chromedriver'
                    }
                'chromedriver_mac64'{
                    $AssembliesDir = "$PSScriptRoot/assemblies/macos"
                    $BinaryFileName = 'chromedriver'
                    }
                'chromedriver_win32'{
                    $AssembliesDir = "$PSScriptRoot/assemblies"
                    $BinaryFileName = 'chromedriver.exe'
                    }
                default{throw 'Incorrect Build Type'}
            }
        
            $BuildFileName = "$Build.zip"
            Write-Verbose "Downloading: $BuildFileName"
            Invoke-WebRequest -OutFile "$($TempDir + $BuildFileName)" "https://chromedriver.storage.googleapis.com/$LatestChromeStableRelease/$BuildFileName" 
            
            # Expand the ZIP Archive to the correct Assemblies Dir 
            Write-Verbose "Explanding: $($TempDir + $BuildFileName) to $AssembliesDir"
            Expand-Archive -Path "$($TempDir + $BuildFileName)" -DestinationPath $AssembliesDir -Force
            
            # Generate Hash Files 
            Write-Verbose "Generating SHA256 Hash File: $AssembliesDir/$BinaryFileName.sha256"
            Get-FileHash -Path "$AssembliesDir/$BinaryFileName"  -Algorithm SHA256 | Select-Object -ExpandProperty Hash | Set-Content -Path "$AssembliesDir/$BinaryFileName.sha256" -Force
            
        }
    }
    'Firefox'{
        Write-Host 'Not Supported Yet' 

    }
    'Edge'{
        Write-Host 'Not Supported Yet' 
    }
}