<#
  .Description
    A PowerShell script that adds, gets and removes mailbox permissions on Office365.
  .Example
    .\Office365_CalendarPermissions.ps1
  .Notes
    Name  : Office365_CalendarPermissions
    Author: Joe Richards
 .Link
   https://github.com/joer89/SysOps.git
#>


#Retrivw the mailbox permissions.
function prepGetMailBx{
    #Stores the owners username.
    $ownerUsr = Read-Host "Enter the owner's username: "
    #binds the email address in the correct format.
    $ownersEmail = "$ownerUsr@domain.com"
    try{
        #Retrives the users and access rightrsd of the calendar.
        Get-MailboxPermission -Identity $ownersEmail | Format-List User, AccessRights
    }
    catch{
        #Displays a simple error.
        Write-Error "Failed to get owners calendar."
    }
    Finally{
        #Goes back to the menu.
        MenuOptions
    }
}
#End Function

#Gives access to a users calendar
function Add-MailBxPermissions{
    #ownerUsr is the owners email address in the format of emailAddress:\calendar
    #guestUsr is the requesters email address.
    #accessRights is the access which is required for the calendar.
    param ([String]$ownerUsr,[String]$guestUsr,[String]$accessRights)
    #Stores the owners username.
    $ownerUsr = Read-Host "Enter the owner's username: "
    #Stores the requestees username.
    $guestUsr = Read-Host "Enter the requestee username: " 
    #Displays a link.   
    Write-Host "`n `tFor a list of access rights please reference the link below. `n `thttps://support.office.com/en-us/article/Share-your-calendar-information-353ed2c1-3ec5-449d-8c73-6931a0adab88`n `t"   
    #Stores the access rights.
    $accessRights = Read-Host "Enter the access right: "
    #binds the email address in the correct format.
    $ownersEmail = "$ownerUsr@domain.com:\calendar"
    #binds the email address in the correct format.
    $Requestee = "$guestUsr@domain.com"
    #Displays the key details of whats about to be set.
    Write-Host "`n `EMail: "  $ownersEmail "`n `tRequester's EMail Address: " $guestUsr "`n `tAccess right: " $accessRights
    try{
        #Sets the calendar permissions.
        Add-MailboxFolderPermission -Identity $ownersEmail -User  $Requestee -AccessRights $accessRights
    }
    catch{
        #Displays a simple error.
        Write-Error "Failed to set owners calendar."
    }
    Finally{
        #Goes back to the menu.
        MenuOptions
    }
}
#End function


#Removes a user from the owners calendar.
function RemovetMailBx{
    #Stores the owners username.
    $ownerUsr = Read-Host "Enter the owner's username: "
      #Stores the owners username.
    $guestUsr = Read-Host "Enter the guest's username: "
    #Bind the username with the email address.
    $ownersEmail = "$ownerUsr@domain.com:\calendar"
    #binds the email address in the correct format.
    $guestEmail = "$guestUsr@domain.com"
    try{
        #Removes the user from the owners calendar.        
        remove-mailboxfolderpermission -Identity $ownersEmail -User $guestEmail
    }
    catch{
        #Displays a simple error.
        Write-Error "Failed to get owners calendar."
    }
    Finally{
        #Goes back to the menu.
        MenuOptions
    }
}
#End Function


function Office365{
    #Try to imports the Active directory module and stops the program if it does not exist.
    try{
        Import-Module ActiveDirectory -ErrorAction Stop
        Write-Host "AD module has been loaded."

        #Stores the credentials for Office365
        $Username = "Office365username@domain.com"
        $Password = ConvertTo-SecureString ‘Office365Password’ -AsPlainText -Force
        $UserCredential = New-Object System.Management.Automation.PSCredential $Username, $Password
        #Stores the FQDN of the exchange server and in to a stirng.
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
        #Creates the session
        Import-PSSession $Session -AllowClobber
        #Opens the menu.
        MenuOptions
    }
    catch{
        Write-Host "Something went wrong connecting to Office365." -foregroundcolor red 
    }
}

function menuOptions{
    #the storage of the menu's user choice 
    [int]$choice = 0

    while($choice -lt 1 -or $choice -gt 3){
        #Display the options in the menu.
        Write-Host "1. Add mailbox permissions."
        Write-Host "2. Get a user mailbox permissions."
        Write-Host "3. Removes mailbox permissions."
        Write-Host "4. Quit"
    
        #Stores the users menu option.
        $choice  = Read-Host "Please choose an option"
        
        Switch ($choice) {
            1{Add-MailBxPermissions}
            2{prepGetMailBx}
            3{RemovetMailBx}
            4{#Exits the script.
              #Removes the session from Office365.
              Remove-PSSession $Session
              Exit}
            default{
                #goes to the menu.
                menuOptions
            }
        }
    }
}


Office365
