<#
.SYNOPSIS
    These set of scripts are general one liners in Powershell for everyday use.
.DESCRIPTION 
        You need to import the ActiveDirectory module for the AD scripts.
        If you have any more, contact me and ill add them in.
.Notes
   Author: Joe Richards
   Date:   30/01/2020
.LINK
  https://github.com/joer89/Admin-Tools.git
#>


#Active Directory.

#Export to csv file all accounts cn and last logon time stamp.
Get-ADUser -Filter * -SearchBase "OU=Users,OU=TRS,DC=trs,DC=local" -ResultPageSize 0 -Properties CN,lastLogonTimestamp | Select CN,lastLogonTimestamp | Export-CSV -NoType c:\files\last.csv

#find all accounts connected 90 day ago or more.
get-aduser -filter 'enabled -eq $true' -Properties lastlogondate | Where-object {$_.lastlogondate -lt (get-date).AddDays(-90)} | Export-csv C:\users.csv -NoTypeInformation -Force -Delimiter ";"

#List all accounts with pager and name.
Get-ADUser -filter * -Properties pager | Format-List Name, pager

#List all accounts beginging with 1 and list the name ad pager.
Get-ADUser -LDAPFilter "(&(!pager=*)(name=1*))" -Properties pager | Format-List Name, pager

#list all computers starting with trs-sl-sp and get extattr4, 5 and os versin.
Get-ADComputer -LDAPFilter "(name=trs-sl*)" -Properties extensionAttribute4, extensionAttribute5, operatingSystemVersion | Format-List name, extensionAttribute4, extensionAttribute5, operatingSystemVersion

#Get a list of computer with ldap
Get-ADComputer -LDAPFilter "(name=trs-sl-sp*)" | Format-List name

#WMI

#get physical memory of workstation
Get-WmiObject -class "Win32_PhysicalMemory" -ComputerName trs-002-main

#Obtain the SN number of local machine
Get-WmiObject -class win32_BIOS | Format-List Serial*

#Obtain the SN number of remote machine 
Get-WmiObject -class win32_BIOS -ComputerName trs-002-main | Format-List Serial*

#Display NVIDIA driver names and version.
Get-WmiObject Win32_PnPSignedDriver| select devicename, driverversion | where {$_.devicename -like "*nvidia*"}

#Display Intel drivers and version on a remote machine.
Get-WmiObject Win32_PnPSignedDriver -ComputerName trs-002-main | Select devicename, driverversion | where {$_.devicename -like "*intel*"}

#Disk Utilities

#Get the Size of the primary drive in PS instead of using diskpart.
get-disk -Number 0 | Format-List Size
