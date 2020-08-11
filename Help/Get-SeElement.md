---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeElement

## SYNOPSIS
	
Finds all IWebElements within the current context using the given mechanism

## SYNTAX

```
Get-SeElement [-By <String>] [-Selection] <String> [[-Timeout] <Int32>] [[-Driver] <Object>] [-Wait]
 [<CommonParameters>]
```

## DESCRIPTION
Finds all IWebElements within the current context using the given mechanism

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeElement -By Name -Selection 'username'
```

Get the username field by name

## PARAMETERS

### -By
The locating mechanism to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: CssSelector, Name, Id, ClassName, LinkText, PartialLinkText, TagName, XPath

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
{{ Fill Driver Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Element

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Selection
String Identifier of the object to find

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Timeout (in seconds)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Set Timeout to 30 seconds (Will not override Timeout value if already defined)

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
