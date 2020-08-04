---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# SeShouldHave

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### DefaultPS (Default)
```
SeShouldHave [-Selection] <String[]> [-By <String>] [-PassThru] [-Timeout <Int32>] [<CommonParameters>]
```

### Element
```
SeShouldHave [-Selection] <String[]> [-By <String>] [-With] <String> [[-Operator] <String>] [[-Value] <Object>]
 [-PassThru] [-Timeout <Int32>] [<CommonParameters>]
```

### Alert
```
SeShouldHave [-Alert] [[-Operator] <String>] [[-Value] <Object>] [-PassThru] [-Timeout <Int32>]
 [<CommonParameters>]
```

### NoAlert
```
SeShouldHave [-NoAlert] [-Timeout <Int32>] [<CommonParameters>]
```

### Title
```
SeShouldHave [-Title] [[-Operator] <String>] [-Value] <Object> [-Timeout <Int32>] [<CommonParameters>]
```

### URL
```
SeShouldHave [-URL] [[-Operator] <String>] [-Value] <Object> [-Timeout <Int32>] [<CommonParameters>]
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

### -Alert
{{ Fill Alert Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Alert
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -By
{{ Fill By Description }}

```yaml
Type: String
Parameter Sets: DefaultPS, Element
Aliases:
Accepted values: CssSelector, Name, Id, ClassName, LinkText, PartialLinkText, TagName, XPath

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoAlert
{{ Fill NoAlert Description }}

```yaml
Type: SwitchParameter
Parameter Sets: NoAlert
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Operator
{{ Fill Operator Description }}

```yaml
Type: String
Parameter Sets: Element, Alert, Title, URL
Aliases:
Accepted values: like, notlike, match, notmatch, contains, eq, ne, gt, lt

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{ Fill PassThru Description }}

```yaml
Type: SwitchParameter
Parameter Sets: DefaultPS, Element, Alert
Aliases: PT

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Selection
{{ Fill Selection Description }}

```yaml
Type: String[]
Parameter Sets: DefaultPS, Element
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Timeout
{{ Fill Timeout Description }}

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

### -Title
{{ Fill Title Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Title
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
{{ Fill URL Description }}

```yaml
Type: SwitchParameter
Parameter Sets: URL
Aliases: URI

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
{{ Fill Value Description }}

```yaml
Type: Object
Parameter Sets: Element, Alert
Aliases: contains, like, notlike, match, notmatch, eq, ne, gt, lt

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Object
Parameter Sets: Title, URL
Aliases: contains, like, notlike, match, notmatch, eq, ne, gt, lt

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -With
{{ Fill With Description }}

```yaml
Type: String
Parameter Sets: Element
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
