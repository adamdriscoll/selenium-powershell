---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# New-SeDriverService

## SYNOPSIS
Create an instance of WebDriver service to be used with Start-SeDriver

## SYNTAX

```
New-SeDriverService [-Browser <Object>] [-WebDriverPath <Object>] [<CommonParameters>]
```

## DESCRIPTION
Create an instance of WebDriver service to be used with Start-SeDriver

## EXAMPLES

### Example 1
```powershell
PS C:\> $Service = New-SeDriverService -Browser Chrome 
PS C:\> $Service.PortServerAddress = 100
PS C:\> $Options = New-SeDriverOptions -Browser Chrome -Position 1920x0 -Size 1920x1080
PS C:\> Start-SeDriver -Service $Service -Options $Options
PS C:\> $Service.ProcessId
```

Create a new instance of Chrome driver service, set a custom port and start the driver with the modified service instance.

## PARAMETERS

### -Browser
Browser name

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebDriverPath
Location of the web driver to be used.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### OpenQA.Selenium.Chrome.ChromeDriverService

### OpenQA.Selenium.Firefox.FirefoxDriverService

### OpenQA.Selenium.IE.InternetExplorerDriverService

### OpenQA.Selenium.Edge.EdgeDriverService

## NOTES

## RELATED LINKS
