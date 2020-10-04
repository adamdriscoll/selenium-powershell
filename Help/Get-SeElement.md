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

### Default (Default)
```
Get-SeElement [-By <SeBySelector[]>] [-Value] <String[]> [[-Timeout] <Double>] [[-Driver] <IWebDriver>] [-All]
 [-Attributes <String[]>] [-Single] [<CommonParameters>]
```

### ByElement
```
Get-SeElement [-By <SeBySelector[]>] [-Value] <String[]> [-Element] <IWebElement> [-All]
 [-Attributes <String[]>] [-Single] [<CommonParameters>]
```

## DESCRIPTION
Finds all IWebElements within the current context using the given mechanism.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeElement -By XPath '//*[@id="home_text3"]/div[2]' -Value '//*[@id="home_text3"]/div[2]'
#Same but positionally bound
PS C:\> Get-SeElement '//*[@id="home_text3"]/div[2]'
```

Get the elements matching the specified XPath selector.

### Example 2
```powershell
PS C:\> Get-SeElement -By Name -Value 'username' -Single
```

Get the username field by name with the expectation only one element is to be returned.

### Example 3
```powershell
PS C:\> Get-SeElement -By Name -Value 'username' -Single
```

Get the username field by name with the expectation only one element is to be returned.

### Example 4
```powershell
PS C:\> Get-SeElement -By ClassName -Value homeitem -All -Attributes name, id -Timeout 2.5
#To return all attributes instead: -Attributes *
```

Get the elements by classname. Include hidden items `-All` and append an `Attributes` NoteProperty to all the result containing the value for the name and id attribute. The call will also fail if no results are found after 2.5 seconds.

### Example 5
```powershell
PS C:\> Get-SeElement -By ClassName,PartialLinkText -Value 'homeitem','The'
```

Get the elements that match the selectors in a sequential manner. This call will return all links that contains the defined text (The) within elements that have a classname of "homeitem".

## PARAMETERS

### -All
Return matching hidden items in addition to displayed ones. 

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

### -Attributes
Append a list of Attributes (case sensitive) to each element returned. Attributes will be available through a dictionary property of the same name. Is the wildcard `*` character is used, all attributes will be queried and appended.

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

### -By
The locating mechanism to use. It is possible to use multiple locator, in which case they will be processed sequentially.

```yaml
Type: SeBySelector[]
Parameter Sets: (All)
Aliases:
Accepted values: ClassName, CssSelector, Id, LinkText, PartialLinkText, Name, TagName, XPath

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
{{ Fill Driver Description }}

```yaml
Type: IWebDriver
Parameter Sets: Default
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Element
{{ Fill Element Description }}

```yaml
Type: IWebElement
Parameter Sets: ByElement
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Single
Expectation that only one element will be returned. An error will be returned if that parameter is set and more than one corresponding element is found.

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

### -Timeout
Timeout (in seconds)

```yaml
Type: Double
Parameter Sets: Default
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Locator Value corresponding to the `$By` selector. There should be an equal number of values than `$By` selector provided.

```yaml
Type: String[]
Parameter Sets: (All)
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

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
