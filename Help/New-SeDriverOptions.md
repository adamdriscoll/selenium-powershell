---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# New-SeDriverOptions

## SYNOPSIS
Create a driver options object that can be used with `Start-SeDriver`

## SYNTAX

```
New-SeDriverOptions [-Browser <Object>] [[-StartURL] <String>] [-State <Object>]
 [-DefaultDownloadPath <FileInfo>] [-PrivateBrowsing] [-ImplicitWait <Double>] [-Size <Size>]
 [-Position <Point>] [-WebDriverPath <Object>] [-BinaryPath <Object>] [-Switches <String[]>]
 [-Arguments <String[]>] [-ProfilePath <Object>] [-LogLevel <LogLevel>] [-UserAgent <String>]
 [-AcceptInsecureCertificates] [<CommonParameters>]
```

## DESCRIPTION
Create a driver options object that can be used with `Start-SeDriver`

This allow for more flexibility than the Start-SeDriver cmdlet as you can perform additional things with the driver options before starting the driver.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Options = New-SeDriverOptions -Browser Chrome -Position 1920x0 -Size 1920x1080
PS C:\> $Options.AddAdditionalCapability('useAutomationExtension', $false)
PS C:\> Start-SeDriver -Options $Options
```

Create a Chrome driver option object to perform additional things unsupported directly by Start-SeDriver, such as adding an additional capability, then Start a driver instance with the modified Chrome driver options object.

## PARAMETERS

### -AcceptInsecureCertificates
If set, Ignore SSL certificate error (Chrome,Edge,Firefox)

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

### -Arguments
Command line arguments to be passed to the browser.

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
Browser name to be started.

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
Maximum time that the browser will implicitely wait between operations

```yaml
Type: Double
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

### -Position
Position of the browser to be set on or after launch. Some browser might not support position to be set prior launch and will have their position set after launch.

```yaml
Type: Point
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateBrowsing
Launch the browser in a private session

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

### -Size
Size of the browser to be set on or after launch. Some browser might not support size to be set prior launch and will have their size set after launch.

```yaml
Type: Size
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartURL
Start URL to be set immediately after launch. If no protocol is specified, https will be assumed.

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
Window state of the browser.

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
Special switches (additional legacy options that might appear for some browser )

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

### -UserAgent
UserAgent to be set. Supported by Chrome & Firefox

```yaml
Type: String
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

### OpenQA.Selenium.Chrome.ChromeOptions

### OpenQA.Selenium.Edge.EdgeOptions

### OpenQA.Selenium.Firefox.FirefoxOptions

### OpenQA.Selenium.IE.InternetExplorerOptions

## NOTES

## RELATED LINKS
