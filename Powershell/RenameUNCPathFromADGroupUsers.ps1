<#
  .Description
    A PowerShell script which creates a weblink called Helpdesk.url on everyones desktop who is part of a AD Group.
  .Notes
    Name  : RenameUNCPathFromADGroupUsers
    Author: Joe Richards
  .Link
    https://github.com/joer89/Admin-Tools/
#>

clear
#Imports AD Module.
Import-module activedirectory

#Stores all the usersnames in an Array
$usrArray =@()

#Stores the directories that do not exist.
$usrMissedArray = @()


################################
##Retrives the users in an AD Group and puts them in an array.
################################

#Stores the group name of the user input to $group.
$group = Read-Host "Which group would you like a list of?"

#If group exists do the work else give use an error message.
if (Get-ADGroup -Filter {SamAccountName -eq $group}){

    #exports all the items in the group.
    $usrArray += Get-ADGroupMember $group -Recursive | select -Expand name 
}
else{
    #Writes out an error message.
    Write-Host "This Group does not exist $group."
}


####################################
##Renames IT Helpdesk to Helpdesk and displays the result on the screen.
####################################

foreach($usrPath in $usrArray){

    #Path of the directory.
    $path ="\\FileServer\Users\$usrPath\Desktop\IT Helpdesk.url"


    if(!(Test-path -Path $path)){
        #Puts the path in missed array if it does not exist.
        $usrMissedArray += $Path
    }
    else{
        #Renames the file in the path of $path
        Rename-Item -Path $path -NewName Helpdesk.url
    }
}


if(Test-path -Path $path){
    Write-Host "no directories have missed."
}
else{
    #Writes out a list of missed 
    Write-Host "List of paths that do not exist"
    #Displays the array.
    $usrMissedArray
    #Displays the amount of items in the array.
    $usrMissedArray.Count
    #Clears the array.
    #$usrMissedArray = @()
    #Displays the amount of items in the array. (Testing only)
    #$usrMissedArray.Count
}