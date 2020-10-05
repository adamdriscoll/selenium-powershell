---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeDriver

## SYNOPSIS
Get the list of all active drivers.

## SYNTAX

### Current (Default)
```
Get-SeDriver [-Current] [<CommonParameters>]
```

### ByName
```
Get-SeDriver [[-Name] <String>] [<CommonParameters>]
```

### ByBrowser
```
Get-SeDriver [-Browser <Object>] [<CommonParameters>]
```

## DESCRIPTION
Get the list of all active drivers or drivers matching the specified criterias.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeDriver
```

Return the list of all active drivers.

### Example 2
```powershell
PS C:\> Get-SeDriver -Current
```

Return the currently selected browser.

### Example 3
```powershell
PS C:\> Get-SeDriver -Browser Chrome
```

Returh the list of all active "Chrome" browsers.

### Example 3
```powershell
PS C:\> Get-SeDriver -Name '70c91e0f112dcdbd22b84dd567560b8d'
```

Return the driver with the specified name.

## PARAMETERS

### -Browser
Filter the list of returned drivers by their Browser type (enum: [SeBrowsers])

```yaml
Type: Object
Parameter Sets: ByBrowser
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Current
Return the currently selected browser. Selected browser is the last one started, unless changed via Switch-SeDriver and is always the one that get used in all cmdlet that have an unspecified $Driver.

```yaml
Type: SwitchParameter
Parameter Sets: Current
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filter driver returned by its name (SeFriendlyName).

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
