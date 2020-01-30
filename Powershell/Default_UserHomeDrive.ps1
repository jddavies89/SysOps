<#
.Synopsis
   This script sets the home drive to default.
.DESCRIPTION
       All data is deleted in the selected Active Directory home drives except the following folder:
            Custom Office Templates
            Music
            My Music
            Pictures
            My Pictures
            Videos
            My Videos
            Favorites

.PARAMETER Path
    The path to where the user(s) home dive reside.
.PARAMETER MinCount
    lowest AD user, for example; pupil1.
.PARAMETER MaxCount
   Highest AD user, for example; pupil10.
.EXAMPLE
   PS C:\> Default-UsersHomeDrive -Path F:\ExamControl -MinCount 1 -MaxCount 3
   Loops through accounts F:\ExamControl1 to ExamControl3 and sets the home drive data back to default.
.EXAMPLE
    PS C:\> Default-UsersHomeDrive -Path F:\ExamControl -MinCount 19 -MaxCount 20
   Loops through accounts F:\ExamControl19 to ExamControl20 and sets the home drive data back to default.
.EXAMPLE
   PS C:\> Default-UsersHomeDrive -Path F:\ExamControl -MinCount 1 -MaxCount 1
   Sets the home drive data back to default for ExamControl1 only.
.LINK
  https://github.com/joer89/Admin-Tools/
#>

function Default-UsersHomeDrive{

           [CmdletBinding(SupportsShouldProcess=$true)]        

        Param (        
            [Parameter(Mandatory=$true,
                       ValueFromPipeline=$true,
                       Position=0)]
            [String]$Path,

             [Parameter(Mandatory=$true,
                       ValueFromPipeline=$true,
                       Position=1)]
            [int]$MinCount,

             [Parameter(Mandatory=$true,
                       ValueFromPipeline=$true,
                       Position=2)]          
            [Int]$MaxCount
        
        )#Parameter
        Begin{}#End begin
        Process{
            #Stores the accounts to later display out on screen at the End{}.
            [array]$arrADAccounts

            #Loops through each home drive.
            for($i=$MinCount;$i -le $MaxCount;$i++) {
              
               #Checks to see if the path exists.
               if(test-path $Path$i){
                  
                    #Goes to the AD home drive location.
                    Set-Location -LiteralPath "$Path$i\" 
                    #Tells the user what is going on.
                    Write-Host "Going to location  $Path$i\"  -ForegroundColor Yellow -BackgroundColor Black
                    #Removes each file and folder except what is in the exception.
                    Get-ChildItem -Exclude "Custom Office Templates","Music","My Music","Pictures","My Pictures","Videos","My Videos","Favorites" | Remove-Item -Recurse 
                    #Adds each AD home drive location to the array with an indent at the begining and a new line at the end, this is for displaying the results out at the end of the script.
                    $arrADAccounts = $arrADAccounts + "`t"+$Path+$i+"`n"
               
               }#End if
            }#End for loop
        }#End process
        End{
          
            #Tells the user which directories have been modified.
            Write-Host "The following accounts have default home drives."  -ForegroundColor Yellow -BackgroundColor Black 
            Write-Host $arrADAccounts -ForegroundColor Yellow -BackgroundColor Black
            #Sets the script location to C:\.                        
            Set-Location C:\
       
        }#end
}
#Testing.
#Default-UsersHomeDrive -Path F:\ExamControl -MinCount 1 -MaxCount 3
