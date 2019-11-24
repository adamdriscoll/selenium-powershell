param(
    [Parameter(Mandatory=$true)][ValidateSet('Chrome','Firefox','Edge')]$Browser
)

switch ($true) {
    $IsLinux {
        $TempDir = "/tmp"
    }

    $IsMacOS {
        #code to check temp folder on mac needs to be added
    }

    $IsWindows {
        $TempDir = $env:temp
    }
    default {
        $TempDir = $env:temp
    }
}

if($IsLinux){
    $TempDir = '/tmp'
}
elseif($IsMacOS){
    #mac temp folder 
}

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
            Write-host "$BuildFileName $AssembliesDir"
            Invoke-WebRequest -OutFile "/tmp/$BuildFileName" "https://chromedriver.storage.googleapis.com/$LatestChromeStableRelease/$BuildFileName" 
            
            # Expand the ZIP Archive to the correct Assemblies Dir 
            Expand-Archive -Path "$TempDir/$BuildFileName" -DestinationPath $AssembliesDir -Force
            
            # Generate Hash Files 
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

