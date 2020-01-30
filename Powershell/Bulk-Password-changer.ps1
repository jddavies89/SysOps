<#
  .Synopsis
    This script bulk changes the user passwords in the OU of OU=Generic Accounts,OU=Users,OU=Organisation,DC=contoso,DC=com.
   
  .Description
    Where it says 'DEPARTMENT', this filters the specific accounts.

  .Notes
    Name  : Bulk-Password-changer
    Author: Joe Richards
    Date  : 17/08/2017
 
  .Link
  https://github.com/joer89/Admin-Tools/
#>

#Imports Active Directory module.
import-module activedirectory

#Changes the passwords.
Get-ADUser -Filter {Department -eq "DEPARTMENT"} -SearchScope Subtree -SearchBase "OU=Generic Accounts,OU=Users,OU=Organisation,DC=contoso,DC=com" | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Password" -Force)
