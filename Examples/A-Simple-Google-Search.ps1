# The line below will Import-Module Selenium if it fails it will display the installation command and stop the script. 
Import-Module -Name Selenium

# Start the Selenium Chrome Driver
Start-SeDriver -Browser Chrome -StartURL 'google.com/ncr'



#Getting the Search box
    
<# This is the HTML code of the search box, found using the browser developer tools
        <input class="gLFyf gsfi" maxlength="2048" name="q" type="text" jsaction="paste:puy29d" aria-autocomplete="both" aria-haspopup="false" autocapitalize="off" autocomplete="off" autocorrect="off" role="combobox" spellcheck="false" title="Search" value="" aria-label="Search">
#>

#Here's a few different ways, all valid, to access that searchbox

# By examining the HTML code of the google seach box we can see that the search box name is q so in the below example we'll use the name q to find its element
#The Single parameter will write an error if there's not 1 element.
$Searchbox = Get-SeElement -By Name -value q -Single

# We can also use the class name gLFyf to find the google search box.
$Searchbox = Get-SeElement  -ClassName 'gLFyf'

# This line will get us all elements with the input TagName also known as <input>
#The -All parameter (optional) also includes hidden elements.
# The -Attributes parameter will load the specified attribute in the result and make them available through an Attributes property
$AllInputElement = Get-SeElement  -By TagName -Value input -All -Attributes title
$AllInputElement | select Attributes
# The $AllInputElements contains all the input elements on the page if we want to find the specific element for the google search box we will need to loop through each input element in the $AllInputElements array and get the attibute we want in this case we're looking for the title attribute.
# And we only want to return the element that has a title equal to Search we can find this out based on the html code on the page.
$Searchbox = $AllInputElement.Where( { $_.Attributes.title -eq 'Search' }, 'first')[0]

# Now for the fun part after finding the element we want to send keyboard input to it. this will allow us to automate the search process
# We can get the list of all special keyboard keys like enter/backspace etc using the Get-SeKeys command
    
# Now that we can see all the keys we can send send some keys to the SearchBoxElement
Invoke-SeKeys -Element $Searchbox -Keys 'Powershell-Selenium'

# You can send special key strokes to the SearchBoxElement, you should use the Selenium Keys enum. For example, if we wanted to send an enter key stroke, you could do it like this
# To view special keys, use Get-SeKeys
Invoke-SeKeys -Element $Searchbox -Keys ([OpenQA.Selenium.Keys]::Enter)
    
# When working with dynamic websites, it's often necessary to wait awhile for elements to appear on the page. By default, Selenium won't wait and you'll receive $null from Find-SeElement because the element isn�t there yet. There are a couple ways to work around this.
# The first is to use the Find-SeElement cmdlet with the -Wait switch to wait for the existence of an element in the document.
# When using the Find-SeElement with the -Wait please take into account that only 1 element can be returned unlike the without the -Wait switch where multiple elements can be returned.

# This command will wait for the img elements for 10 seconds and then return it to you or time out if the element wasn't found on.
#Note, the value parameter is provided positionally.
$LogoImageElement = Get-SeElement  -Timeout 10 -By Id 'logo'
    
# Once we have the image element we can simulate a mouse click on it using the Invoke-SeClick command.
Invoke-SeClick  -Element $LogoImageElement

# Once we are done with the web driver and we finished with all our testing/automation we can release the driver by running the Stop-SeDriver command.
Stop-SeDriver 