<#
.Description
    This script is a menu utility to manage wireless profiles on your local wireless computer.
.Example
    .\WiFIAdmin-Tool.ps1
.Notes
  Name  : WiFiAdmin-Tool.ps1
  Author: Joe Richards
  Date  : 30/12/2016
.Link
  https://github.com/joer89/Admin-Tools/
#>


#Displays Wireless profiles.
function viewWiFiProfile {

    #display the text on screen.
    Write-Host "Displaying Wireless profiles."
    #Show Wireless Profiles in the machine.
    netsh wlan show profiles
    #Go to the main menu.
    main

}

#Exports the profile of choice.
function exportAWiFiProfile{

    #Displays the Wireless profiles.
    netsh wlan show profiles
    
    #display the text on screen.
    Write-Host "Write the Wireless Profile name, if there is spaces encapsulate the name with double quotes."

    #user inputs the wireless profile name (if there is spaces use standard convention '"').
    $input = Read-Host "WiFi Profile name."
    #True or false, for displaying the Wireless key.
    $key = Read-Host "Leave the password encrypted? y/n"
   
    #If the user wants a visible Wireless key.
    if ($key -eq 'n'){
        #Exports the Wireless profile with a clear password.
        netsh wlan export profile name=$input key=clear
        #Go to the main menu.
        main
    }
    else{
        #Exports the Wireless profile with an encrypted key.
        netsh wlan export profile name=$input
        #Go to the main Menu.
        main
    }
}
#Imports a XML Wireless Profile.
function ImportXMLWiFiProfile{
    
    #Displays the Wireless profiles.
    netsh wlan show profiles
    
    #display the text on screen.
    Write-Host "Import a Wireless profile from a XML file, syntax is 'profileName.xml'."
    Write-Host "If there is spaces encapsulate the name with double quotes."

    #User inputs a Wireless XML profile name to be imported.
    $input = Read-Host "XML Profile name to be imported."
    #Imports a Wireless profile.
    netsh wlan add profile filename=$input
    #Go to the main menu.
    main
}

#Deletes a Wireless Profile.
function DeleteWirelessProfile{

    #Displays the Wireless profiles.
    netsh wlan show profiles
    
    #display the text on screen.
    Write-Host "Delete a profile from the computer, if there is spaces encapsulate the name with double quotes"

    #User inputs a Wireless profile name to be deleted.
    $input = Read-Host "Profile name to be deleted."
    #Deletes the Wireless profile.
    netsh wlan delete profile $input
    #Go to the main menu.
    main

}
#Main Menu Function.
function main {
    #Main menu choice.
    Write-Host "1. View WiFi Profiles."
    Write-Host "2. Export a WiFi Profiles."
    Write-Host "3. Import a WiFi XLM Profile."
    Write-Host "4. Delete a Wireless Profile."
    #Users Choice, input of numeric value.
    $input = Read-Host "Please make a numeric choice."
    #Start of te switch statement to implement the functions.
    Switch($input){
        '1'{
                #Clears the screen and gots to the function of 'viewWiFiProfile'.
                cls
                viewWiFiProfile
                }
        '2'{
                #Clears the screen and gots to the function of 'ExportAWiFiProfile'.
                cls
                ExportAWiFiProfile
                }
        '3'{
                #Clears the screen and gots to the function of 'ImportXMLWiFiProfile'.
                cls
                ImportXMLWiFiProfile
                }
        '4'{
                #Clears the screen and gots to the function of 'DeleteWirelessProfile'.
                cls
                DeleteWirelessProfile
                }
    }#End Switch
}#End Function.

#Displays the Main Menu.
main;
