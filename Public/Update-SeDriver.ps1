function Update-SeDriver {
    [CmdletBinding()]
    param (
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        $Browser,
        [ValidateSet('Linux', 'Mac', 'Windows')]
        $OS,
        [ValidateScript( { (Test-Path -Path $_) -and ((Get-Item -Path $_) -is [System.IO.DirectoryInfo]) })]
        $Path
    )

    if (! $PSBoundParameters.ContainsKey('OS')) {
        if ($IsMacOS) { $OS = 'Mac' } elseif ($IsLinux) { $OS = 'Linux' } else { $OS = 'Windows' }
    }
    
    if (! $PSBoundParameters.ContainsKey('Path')) {
        $Path = $PSScriptRoot
        if ($Path.EndsWith('Public')) { $Path = Split-Path -Path $Path } #Debugging
        switch ($OS) {
            'Linux' { $AssembliesDir = Join-Path -Path $Path -ChildPath '/assembiles/linux' }
            'Mac' { $AssembliesDir = Join-Path -Path $Path -ChildPath '/assembiles/macos' }
            'Windows' { $AssembliesDir = Join-Path -Path $Path -ChildPath '/assembiles' }
        }
        
    }
    
    $TempDir = [System.IO.Path]::GetTempPath()

    switch ($Browser) {
        'Chrome' {
            $LatestChromeStableRelease = Invoke-WebRequest 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' | Select-Object -ExpandProperty Content
            $ChromeBuilds = @{
                Linux   = 'chromedriver_linux64'
                Mac     = 'chromedriver_mac64' 
                Windows = 'chromedriver_win32'
            }
            
            $Build = $ChromeBuilds.$OS
            
        
            $BuildFileName = "$Build.zip"
            Write-Verbose "Downloading: $BuildFileName"
            Invoke-WebRequest -OutFile "$($TempDir + $BuildFileName)" "https://chromedriver.storage.googleapis.com/$LatestChromeStableRelease/$BuildFileName" 
            
            # Expand the ZIP Archive to the correct Assemblies Dir 
            Write-Verbose "Explanding: $($TempDir + $BuildFileName) to $AssembliesDir"
            Expand-Archive -Path "$($TempDir + $BuildFileName)" -DestinationPath $AssembliesDir -Force
         
        }
        'Firefox' {
            Write-Warning 'Not Supported Yet' 

        }
        'Edge' {
            Write-Warning 'Not Supported Yet' 
        }
        Default {
            Write-Warning 'Not Supported Yet' 
        }
    }


    


}