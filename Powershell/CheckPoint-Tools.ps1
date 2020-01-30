<#
  .Description
    This script manipulates the System Restore Points and has to be run as admin.
    It has a built in checker within the program to see if it has been run as admin.
 
  .Example
    .\CheckPoint-Tools.ps1
 
  .Notes
    Name  : CheckPoint-Tools
    Author: Joe Richards
    Date  : 02/01/2016
 
  .Link
  https://github.com/joer89/Admin-Tools/
#>


#Disables a local resotre point.
function disableLocalRestorePoint{


    #Puts the main menu banners in the appropriate variables.
    $title = "Checkpoint Tools"
    $message = " `n `t 1. Back to Main Menu. `n `t 2. Exits."
    $option = "`n `n Option 1 - 2 "

    cls       
        #Displays the Title
        Write-Host -ForegroundColor Gray $title

        $drive = Read-Host " `n `t Which drive would you like to disable the restore point of? format is C:\ not C "
        #Create a restore point a selected drive.
        Disable-ComputerRestore $drive

        #Displays the menu.
        Write-Host -ForegroundColor Gray $message
        #User input to the switch statement.
        $option = Read-Host $option

        #Switch statement for the appropriate functions.
        switch ($option) {
            1. {openMenu}
            2. {exit}
        }
 }

#Enables a local restore point of a selected drive.
function enableLocalRestorePoint{


    #Puts the main menu banners in the appropriate variables.
    $title = "Checkpoint Tools"
    $message = " `n `t 1. Back to Main Menu. `n `t 2. Exit."
    $option = "`n `n Option 1 - 2 "

    cls       
        #Displays the Title
        Write-Host -ForegroundColor Gray $title

        $drive = Read-Host " `n `t Which drive would you like to enable a restore point of? format is C:\ not C"
        #Create a restore point a selected drive.
        Enable-ComputerRestore $drive

        #Displays the menu.
        Write-Host -ForegroundColor Gray $message
        #User input to the switch statement.
        $option = Read-Host $option

        #Switch statement for the appropriate functions.
        switch ($option) {
            1. {openMenu}
            2. {exit}
        }
 }

#Creates a restore point.
function GetRestorePoint{

    #Puts the main menu banners in the appropriate variables.
    $title = "Checkpoint Tools"
    $message = " `n `t 1. Back to Main Menu. `n `t 2. Exit."
    $option = "`n `n Option 1 - 2 "

    cls       
        #Displays the Title
        Write-Host -ForegroundColor Gray $title

        #Displays the check points of a Computer.
        Get-ComputerRestorePoint

        #Displays the menu.
        Write-Host -ForegroundColor Gray $message
        #User input to the switch statement.
        $option = Read-Host $option

        #Switch statement for the appropriate functions.
        switch ($option) {
            1. {openMenu}
            2. {exit}
        }
 }

#Displays the main menu.
function openMenu {

#Puts the main menu banners in the appropriate variables.
$title = "Checkpoint Tools"
$message = " `n `t 1. View Restore point. `n `t 2. Enable a local restore point.  `n `t 3. Disable a local restore point `n `t 4. Exits.  "
$option = "`n `n Option 1 - 4 "

cls
    #Displays the appropriate veriables.
    Write-Host -ForegroundColor Gray $title
    Write-Host -ForegroundColor Gray $message
    #User input to the switch statement.
    $option = Read-Host $option

    #Switch statement for the appropriate functions.
    switch ($option) {
        1. {GetRestorePoint}
        2. {enableLocalRestorePoint}
        3. {disableLocalRestorePoint}
        4. {exit}
    }
}

#Makes sure the script runs as admin.
function isAdmin{

    #Checks if the script is admin, if not, stops the program.
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
     {    
      cls
      Echo "This script needs to be run As Admin, the program will stop!"
      Break
     }
     else{
         #Opens the menu function.
         openMenu
     }
 }

#Starts the program.
isAdmin
