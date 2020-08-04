---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Remove-SeCookie

## SYNOPSIS
Delete the named cookie from the current domain

## SYNTAX

### DeleteAllCookies
```
Remove-SeCookie [-Target <IWebDriver>] [-DeleteAllCookies] [<CommonParameters>]
```

### NamedCookie
```
Remove-SeCookie [-Target <IWebDriver>] -Name <String> [<CommonParameters>]
```

## DESCRIPTION
Delete the named cookie from the current domain

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-SeCookie -Name 'CookieName'
```

Remove cookie from targeted Driver

### Example 2
```powershell
PS C:\> Remove-SeCookie -DeleteAllCookies
```

Remove all cookies from targeted Driver

## PARAMETERS

### -DeleteAllCookies
Remove all cookies from webdriver

```yaml
Type: SwitchParameter
Parameter Sets: DeleteAllCookies
Aliases: Purge

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Cookie name to remove

```yaml
Type: String
Parameter Sets: NamedCookie
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
Target webdriver

```yaml
Type: IWebDriver
Parameter Sets: (All)
Aliases: Driver

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OpenQA.Selenium.IWebDriver

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
