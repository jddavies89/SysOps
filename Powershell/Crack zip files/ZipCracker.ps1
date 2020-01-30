<#
.Synopsis
   Dictionary attack on zip file.
.DESCRIPTION
    This script runs a brute force dictionary attack against a 7zip file.
    First function Checks to see if 7zip module is installed, if not will install.
    The second function runs the brute force password attack.
    Optionally to install the module manually: Install-Module -Name 7Zip4Powershell
.PARAMETER DictionaryFile
    The directory of where the dictionary file is stored holding the password list.
.PARAMTER ArchivedFile
    The zip file we need to gain access.
.EXAMPLE
    Crack7zip -DictionaryFile .\pwd.txt -ArchivedFile .\demo.7z
    Trys to crack the demo.7z file with the passwords in the Dictionary list ll in the same folder.
.Notes
   Author: Joe Richards
   Date:   09/01/2020
#>



function ModuleChecker{
    #Gets the module 7Zip4Powershell if its installed and returns a value.
    $isMod = Get-Module -Name 7Zip4Powershell  
    #If its not installed, install the module.
    if($isMod -ne $null ){Install-Module -Name 7Zip4Powershell -ErrorAction stop}else{Write-Host "7Zip4Powershell module already installed."}
 }

 #Advanced module for easy pipeline commands.
 function Crack7zip(){

    [CmdletBinding(SupportsShouldProcess=$true)]        

        Param (   
            #Dictionary file has ot be there and value must be given.     
            [Parameter(Mandatory=$true,
                       ValueFromPipeline=$true,
                       Position=0)]
            [ValidateScript({
                if(Test-Path $_){$true}else{Throw "Invalid path given: $_"}
                })]
            [string]$DictionaryFile,

            #ArchivedFile must be there and value must be given.
            [Parameter(Mandatory=$true,
                       ValueFromPipeline=$true,
                       Position=1)]
            [ValidateScript({
                if(Test-Path $_){$true}else{Throw "Invalid path given: $_"}
                })]
            [string]$ArchivedFile

            )

    #Gets each line of the dictionary file and test each password against the zip file.
    Get-Content $DictionaryFile | ForEach-Object {
            try{
                    Write-Host "Trying password $($_)"
                    #Test the password for the .7z file.
                    get-7Zip -ArchiveFileName $ArchivedFile -Password $_
                    Write-Host "Password is $($_)"
                    #Breaks out of the loop early if the password is found.
                    Break
                   
                }
                catch{}
        }
}

#Installes the module if its not installed.
ModuleChecker

#Trys to cracks the zip file demo.7z from pwd.txt from qorking directory.
#Crack7zip -DictionaryFile .\pwd.txt -ArchivedFile .\pwd.7z