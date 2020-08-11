---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeDriver

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### default (Default)
```
Start-SeDriver [[-StartURL] <String>] [-State <Object>] [-DefaultDownloadPath <FileInfo>] [-PrivateBrowsing]
 [-Quiet] [-ImplicitWait <Int32>] [-WebDriverPath <Object>] [-BinaryPath <Object>] [-Arguments <String[]>]
 [-ProfilePath <Object>] [-LogLevel <LogLevel>] [-PassThru] [-Name <Object>] [<CommonParameters>]
```

### Default
```
Start-SeDriver [-Browser <Object>] [[-StartURL] <String>] [-State <Object>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-Quiet] [-ImplicitWait <Int32>] [-WebDriverPath <Object>] [-BinaryPath <Object>]
 [-Switches <String[]>] [-Arguments <String[]>] [-ProfilePath <Object>] [-LogLevel <LogLevel>] [-PassThru]
 [-Name <Object>] [<CommonParameters>]
```

### DriverOptions
```
Start-SeDriver [[-StartURL] <String>] [-State <Object>] [-DefaultDownloadPath <FileInfo>] [-PrivateBrowsing]
 [-Quiet] [-ImplicitWait <Int32>] [-WebDriverPath <Object>] [-BinaryPath <Object>] -Options <DriverOptions>
 [-Arguments <String[]>] [-ProfilePath <Object>] [-LogLevel <LogLevel>] [-PassThru] [-Name <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Arguments
{{ Fill Arguments Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinaryPath
{{ Fill BinaryPath Description }}

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

### -Browser
{{ Fill Browser Description }}

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultDownloadPath
{{ Fill DefaultDownloadPath Description }}

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImplicitWait
{{ Fill ImplicitWait Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogLevel
{{ Fill LogLevel Description }}

```yaml
Type: LogLevel
Parameter Sets: (All)
Aliases:
Accepted values: All, Debug, Info, Warning, Severe, Off

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

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

### -Options
{{ Fill Options Description }}

```yaml
Type: DriverOptions
Parameter Sets: DriverOptions
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{ Fill PassThru Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateBrowsing
{{ Fill PrivateBrowsing Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfilePath
{{ Fill ProfilePath Description }}

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

### -Quiet
{{ Fill Quiet Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartURL
{{ Fill StartURL Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
{{ Fill State Description }}

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

### -Switches
{{ Fill Switches Description }}

```yaml
Type: String[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebDriverPath
{{ Fill WebDriverPath Description }}

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

### OpenQA.Selenium.IWebDriver

## NOTES

## RELATED LINKS
