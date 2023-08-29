param(
    [Parameter(Mandatory=$true)][ValidateSet('Chrome','Firefox','Edge')]$Browser
)

$TempDir = [System.IO.Path]::GetTempPath()

switch ($Browser){
    'Chrome'{
        $cftUrl = "https://googlechromelabs.github.io/chrome-for-testing/"
        $cftContent = (Invoke-WebRequest -Uri $cftUrl -UseBasicParsing).Content
        if($cftContent -match "<h2>Stable</h2><p>Version: <code>([^<]+)</code>") {
            $latestChromeStableVersion = $matches[1]
        } else {
            Write-Host "Unable to determine latest stable release number of Chrome from '$cftUrl'. Exiting."
            return
        }

        $cftKnownGoodVersionsUrl = "https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json"
        $currentVersionDownloadsContent = (Invoke-WebRequest -Uri $cftKnownGoodVersionsUrl -UseBasicParsing).Content
        $currentVersionDownloads = ConvertFrom-Json -InputObject $currentVersionDownloadsContent

        $version = $currentVersionDownloads.versions |? { $_.version -eq $latestChromeStableVersion }
        if(-not $version) {
            Write-Host "Unable to find download information for latest stable Chrome version '$latestChromeStableVersion' from '$cftKnownGoodVersionsUrl`. Exiting."
        }

        $ChromeBuilds = @('chromedriver_linux64','chromedriver_mac64','chromedriver_win32')
        
        foreach ($Build in $ChromeBuilds){
            switch($Build){
                'chromedriver_linux64'{
                    $AssembliesDir = "$PSScriptRoot/assemblies/linux"
                    $BinaryFileName = 'chromedriver'
                    $DownloadUrl = ($version.downloads.chromedriver |? { $_.platform -eq "linux64" }).url
                    $ExtraExpandDirName = "chromedriver-linux64"
                    }
                'chromedriver_mac64'{
                    $AssembliesDir = "$PSScriptRoot/assemblies/macos"
                    $BinaryFileName = 'chromedriver'
                    $DownloadUrl = ($version.downloads.chromedriver |? { $_.platform -eq "mac-x64" }).url
                    $ExtraExpandDirName = "chromedriver-mac-x64"
                    }
                'chromedriver_win32'{
                    $AssembliesDir = "$PSScriptRoot/assemblies"
                    $BinaryFileName = 'chromedriver.exe'
                    $DownloadUrl = ($version.downloads.chromedriver |? { $_.platform -eq "win32" }).url
                    $ExtraExpandDirName = "chromedriver-win32"
                    }
                default{throw 'Incorrect Build Type'}
            }
        
            $BuildFileName = "$Build.zip"
            $downloadPath = $TempDir + $BuildFileName
            Write-Verbose "Downloading: $BuildFileName"
            Invoke-WebRequest -OutFile $downloadPath $DownloadUrl
            
            # Expand the ZIP Archive to the correct Assemblies Dir 
            Write-Verbose "Expanding: $downloadPath to $AssembliesDir"
            Expand-Archive -Path $downloadPath -DestinationPath $AssembliesDir -Force

            $extraAssembliesDir = "$AssembliesDir/$extraExpandDirName"
            if(Test-Path -Path $extraAssembliesDir) {
                Copy-Item -Path "$extraAssembliesDir\*" -Destination $AssembliesDir
                Remove-Item -Path $extraAssembliesDir -Recurse -Force
            }
            
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