
Function Get-DefaultParams() {
    if ($null -eq $Global:DefaultBrowser) { $Global:DefaultBrowser = 'Firefox' }
    if ($null -eq $env:SITE_URL) { $env:SITE_URL = 'http://tailspin-spacegame-web.azurewebsites.net' }
    if ($null -eq $Global:HeadlessOnly) { $Global:HeadlessOnly = $False }
}
Get-DefaultParams


Function Get-TestCasesSettings() {
    $HeadlessState = if ($Global:HeadlessOnly) { 'Headless' } else { 'Maximized' }
    return   @{
        'NewEdge'          = @{ 
            DefaultOptions = @{State = $HeadlessState }
            PrivateOptions = @{
                PrivateBrowsing = $true
                State           = $HeadlessState
            }
            #     InPrivateLabel  = 'InPrivate'
        } # broken after build 79 of web driver#>
        'Chrome'           = @{ 
            PrivateOptions  = @{
                PrivateBrowsing = $true
                State           = $HeadlessState
            }
            DefaultOptions  = @{State = $HeadlessState }
            HeadlessOptions = @{State = 'Headless' }
        }
        'Firefox'          = @{ 
            PrivateOptions  = @{
                PrivateBrowsing = $true
                State           = $HeadlessState
            }
            DefaultOptions  = @{State = $HeadlessState }
            HeadlessOptions = @{State = 'Headless' }
        }
        'MSEdge'           = @{ 
            DefaultOptions = @{State = $HeadlessState }
            PrivateOptions = @{PrivateBrowsing = $true }
        }
        'InternetExplorer' = @{ 
            DefaultOptions = @{ImplicitWait = 30 }
            PrivateOptions = @{ImplicitWait = 30 }
        }
    }
}

function Build-StringFromHash {
    param ($Hash)
    $(foreach ($k in $Hash.Keys) { "$K`:$($hash[$K])" }) -join '; '
}



function Get-ModalTestCases() {
    return  @(
        @{Name         = 'Download Page'
            linkXPath  = '/html/body/div/div/section[2]/div[2]/a'
            modalXPath = '//*[@id="pretend-modal"]/div/div'
        },
        @{Name         = 'Screen Image'
            linkXPath  = '/html/body/div/div/section[3]/div/ul/li[1]/a'
            modalXPath = '/html/body/div[1]/div/div[2]'
        },
        @{Name         = 'Top Player'
            linkXPath  = '/html/body/div/div/section[4]/div/div/div[1]/div[2]/div[2]/div/a/div'
            modalXPath = '//*[@id="profile-modal-1"]/div/div'
        }
    )
}
