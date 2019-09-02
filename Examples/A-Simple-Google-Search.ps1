<#
.VERSION - 0.2

.DESCRIPTION
This is an example script that will show you how to use the Selenium driver to preform a simple google search.
Using this example script you will learn the basic usage of the Selenium powershell module.
Each comment line will explain the line that will come after it so you can follow it in a step by step fashion.
#>

# The line below will Import-Module Selenium if it fails it will display the installation command and stop the script. 
try{Import-Module -Name Selenium -ErrorAction Stop}catch{Write-Host 'Importing the Selenium module failed. Please install it using the following command: Install-Module Selenium';break}

# Start the Selenium Chrome Driver
$Driver = Start-SeChrome

# Next we will check if the driver is running and if it's not running we will show a message. If the driver is running we will run the commands inside the if statment.
if($Driver){
    # Now that we verified that the driver is running we can start doing cool things with it.

    # Using the Enter-SeUrl command we can tell the driver to go to any URL we want in this case we'll go to https://google.com/ncr 
    # I used the /ncr in the end of the URL because I want google to always stay in english and not redirect to a specific language for consistency.
    Enter-SeUrl -Driver $Driver -Url 'https://www.google.com/ncr'

    # After nevigating to the desired URL we can start interacting with elements on the page in this example we are going to find the search box and type something in it.
    # We can find elements using different ways like the element id or the Name/ClassName/TagName and a few other ways.
    # In the below code we're going to show you a few ways to solve this problem.
    
    <# This is the HTML code of the search box
        <input class="gLFyf gsfi" maxlength="2048" name="q" type="text" jsaction="paste:puy29d" aria-autocomplete="both" aria-haspopup="false" autocapitalize="off" autocomplete="off" autocorrect="off" role="combobox" spellcheck="false" title="Search" value="" aria-label="Search">
    #>

    # By examining the HTML code of the google seach box we can see that the search box name is q so in the below example we'll use the name q to find its element
    $SearchBoxElement = Find-SeElement -Driver $Driver -Name q

    # We can also use the class name gLFyf to find the google search box.
    $SearchBoxElement = Find-SeElement -Driver $Driver -ClassName 'gLFyf'

    # This line will get us all elements with the input TagName also known as <input>
    $AllInputElements = Find-SeElement -Driver $Driver -TagName input

    # The $AllInputElements contains all the input elements on the page if we want to find the specific element for the google search box we will need to loop through each input element in the $AllInputElements array and get the attibute we want in this case we're looking for the title attribute.
    # And we only want to return the element that has a title equal to Search we can find this out based on the html code on the page.
    $SearchBoxElement = $AllInputElements|ForEach-Object{if($_.GetAttribute('title') -eq 'Search'){return $_}}

    # Now for the fun part after finding the element we want to send keyboard input to it. this will allow us to automate the search process
    # We can get the list of all special keyboard keys like enter/backspace etc using the Get-SeKeys command
    
    # Now that we can see all the keys we can send send some keys to the SearchBoxElement
    Send-SeKeys -Element $SearchBoxElement -Keys 'Powershell-Selenium'

    # You can send special key strokes to the SearchBoxElement, you should use the Selenium Keys enum. For example, if we wanted to send an enter key stroke, you could do it like this
    Send-SeKeys -Element $SearchBoxElement -Keys ([OpenQA.Selenium.Keys]::Enter)
    
    # When working with dynamic websites, it's often necessary to wait awhile for elements to appear on the page. By default, Selenium won't wait and you'll receive $null from Find-SeElement because the element isn�t there yet. There are a couple ways to work around this.
    # The first is to use the Find-SeElement cmdlet with the -Wait switch to wait for the existence of an element in the document.
    # When using the Find-SeElement with the -Wait please take into account that only 1 element can be returned unlike the without the -Wait switch where multiple elements can be returned.

    # This command will wait for the img elements for 10 seconds and then return it to you or time out if the element wasn't found on.
    $LogoImageElement = Find-SeElement -Driver $Driver -Wait -Timeout 10 -Id 'logo'
    
    # Once we have the image element we can simulate a mouse click on it using the Invoke-SeClick command.
    Invoke-SeClick -Driver $Driver -Element $LogoImageElement

    # Once we are done with the web driver and we finished with all our testing/automation we can release the driver by running the Stop-SeDriver command.
    Stop-SeDriver -Driver $Driver
}
# if the driver is not running we will enter the script block in the else section and display a message
else{
    Write-Host "The selenium driver was not running." -ForegroundColor Yellow
}