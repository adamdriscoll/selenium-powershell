function Set-SeCookie {
    [cmdletbinding()]
    param(
        [string]$Name,
        [string]$Value,
        [string]$Path,
        [string]$Domain,
        [DateTime]$ExpiryDate
    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
    }

    process {
        if ($Name -and $Value -and (!$Path -and !$Domain -and !$ExpiryDate)) {
            $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value)
        }
        Elseif ($Name -and $Value -and $Path -and (!$Domain -and !$ExpiryDate)) {
            $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value, $Path)
        }
        Elseif ($Name -and $Value -and $Path -and $ExpiryDate -and !$Domain) {
            $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value, $Path, $ExpiryDate)
        }
        Elseif ($Name -and $Value -and $Path -and $Domain -and (!$ExpiryDate -or $ExpiryDate)) {
            if ($Driver.Url -match $Domain) {
                $cookie = [OpenQA.Selenium.Cookie]::new($Name, $Value, $Domain, $Path, $ExpiryDate)
            }
            else {
                Throw 'In order to set the cookie the browser needs to be on the cookie domain URL'
            }
        }
        else {
            Throw "Incorrect Cookie Layout:
            Cookie(String, String)
            Initializes a new instance of the Cookie class with a specific name and value.
            Cookie(String, String, String)
            Initializes a new instance of the Cookie class with a specific name, value, and path.
            Cookie(String, String, String, Nullable<DateTime>)
            Initializes a new instance of the Cookie class with a specific name, value, path and expiration date.
            Cookie(String, String, String, String, Nullable<DateTime>)
            Initializes a new instance of the Cookie class with a specific name, value, domain, path and expiration date."
        }

        $Driver.Manage().Cookies.AddCookie($cookie)
    }
}