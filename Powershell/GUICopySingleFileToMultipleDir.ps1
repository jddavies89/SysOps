<#
.SYNOPSIS
    This script runs a graphical display for easily coping a file to multiple sub folders.
.DESCRIPTION    
    Copy file textbox has to have a single file, this will be the file being copied.
    Past file textbox has to have the directory where the subfolders are, the subfolders is where the file will be copied.
 .Notes
   Author: Joe Richards
   Date:   14/11/2017
   Version 2.0
.LINK
  https://github.com/joer89/Admin-Tools.git
#>

#Load the GUI Form.
function frmLoad {
    #Load System.Windows.Forms.
    [void][reflection.assembly]::loadwithpartialname("System.Windows.Forms") 
  
    #Set the form parameters.
    $frmMain = New-Object System.Windows.Forms.Form
    $frmMain.Text = "GUI Copier"
    $frmMain.StartPosition = 1
    $frmMain.ClientSize = "500,290"

     #Set the label parameters.
    $lblCopyFrom = New-Object System.Windows.Forms.Label    
    $lblCopyFrom.Size = New-Object System.Drawing.Size(170,20) 
    $lblCopyFrom.Location = New-Object System.Drawing.Size(10,20) 
    $lblCopyFrom.Text = "Copy file or Create Directory :"
    $frmMain.Controls.Add($lblCopyFrom) 

    #Set the textbox parameters.
    $txtCopyFrom = New-Object System.Windows.Forms.TextBox    
    $txtCopyFrom.Size = New-Object System.Drawing.Size(200,20) 
    $txtCopyFrom.Location = New-Object System.Drawing.Size(200,20) 
    $frmMain.Controls.Add($txtCopyFrom) 

    #Set the label parameters.
    $lblPastFrom = New-Object System.Windows.Forms.Label    
    $lblPastFrom.Size = New-Object System.Drawing.Size(150,20) 
    $lblPastFrom.Location = New-Object System.Drawing.Size(10,50) 
    $lblPastFrom.Text = "Copy to :"
    $frmMain.Controls.Add($lblPastFrom) 

    #Set the textbox parameters.
    $txtPastTo = New-Object System.Windows.Forms.TextBox    
    $txtPastTo.Size = New-Object System.Drawing.Size(200,40) 
    $txtPastTo.Location = New-Object System.Drawing.Size(200,50) 
    $frmMain.Controls.Add($txtPastTo) 

    #Set the button parameters.
    $btnExecute = New-Object System.Windows.Forms.Button
    $btnExecute.Size = New-Object System.Drawing.Size(60,60) 
    $btnExecute.Location = New-Object System.Drawing.Size(10,100)    
    $btnExecute.Text = "Execute" 
    $btnExecute.Add_click($btnExecute_click)
    $frmMain.Controls.Add($btnExecute) 
      
    #Set the checkbox parameters.
    $chBCreatefolder = New-Object System.Windows.Forms.checkbox
    $chBCreatefolder.Size = New-Object System.Drawing.Size(150,50) 
    $chBCreatefolder.Location = New-Object System.Drawing.Size(410, 5)
    $chBCreatefolder.Text = "Create folder"
    $frmMain.Controls.Add($chBCreatefolder)

    #Set the button parameters.
    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Size = New-Object System.Drawing.Size(60,60) 
    $btnClose.Location = New-Object System.Drawing.Size(70,100)    
    $btnClose.Text = "Close" 
    $btnClose.Add_click($btnClose_click)
    $frmMain.Controls.Add($btnClose)
    
    #Set the label parameters.
    $lblProgress = New-Object System.Windows.Forms.Label
    $lblProgress.AutoSize = $True
    $lblProgress.Location = New-Object System.Drawing.Size(130,100) 
    $lblProgress.Text = "Progress: User input."
    $frmMain.Controls.Add($lblProgress) 
    
    $progressBar = new-object Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Size(10,200)
    $progressBar.Size = New-Object System.Drawing.Size(470,80)
    #Implement the variables in the progress bar.
    $progressBar.Maximum = 100
    $progressBar.Minimum = 0
    $progressBar.Value = 0
    $progressBar.Name = 'progressBar'
    $progressBar.Style="Continuous"
    $frmMain.controls.add($progressBar)  

    #Set the preset variables.
    preSetVariables

    #Show the form.
    $frmMain.ShowDialog()
}

#On close button.
$btnClose_click = {
    #Close the form.
    $frmMain.Close()
}

#On invoke button.
$btnExecute_click = {
        
        #Start the Coping process.
        CopyfiletoMultiDir

}


#Copy the data.
Function CopyfiletoMultiDir{

            #Display File dialog box
            if($txtCopyFrom.Text -eq ""){
                $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
                $OpenFileDialog.initialDirectory = "C:\"
                $OpenFileDialog.filter = "All files (*.*)| *.*"
                $OpenFileDialog.ShowDialog()# | Out-Null
                $txtCopyFrom.Text = $OpenFileDialog.FileName
            }

       try{

            #List the folders in the past directory to the array.
            $list = Get-ChildItem -Directory -Path $txtPastTo.Text
            #changes the label text on starting.
            $lblProgress.Text = "Progress: Started."
    
            #Copy the file to multiple directories.
            for ($i =0; $i -le $list.count; $i++){

                    #Calculate the percentage.
                    $Percentage = ($i/$list.Count)*100

                    #Creates a live progress bar of the coping.            
                    $progressBar.Value = $Percentage
                    
                    
                    if($chBCreatefolder.Checked){
                        #List the folder being creating to the current directory.
                        $lblProgress.Text = "Creating : $($txtCopyFrom.Text) at $($list[$i].FullName)\."
                    
                        #Create the flders.
                      
                        New-Item -ItemType directory -Path "$($list[$i].FullName)\$($txtCopyFrom.text)"

                        #List the folder being created to the current directory.
                        $lblProgress.Text = "Created: $($txtCopyFrom.Text) at $($list[$i].FullName)\."
                    
                    }
                    elseif($chBCreatefolder.Checked -eq $false){

                        #List the file being copied to the current directory.
                        $lblProgress.Text = "Copying : $($txtCopyFrom.Text) to $($list[$i].FullName)\."
                    
                        #Copy the file to each directory. 
                        Copy-Item -Path $txtCopyFrom.text -Destination "$($list[$i].FullName)\" -Force

                        #List the current file being copied.
                        $lblProgress.Text = "Copied : $($txtCopyFrom.Text) to $($list[$i].FullName)\." 
                    } 
            } 

          }
          catch{
                #Error for the end user.
                $lblProgress.Text += "`nError occured please contact IT Support on`n`nEXT: 10591`nEmail: itsupport@contoso.co.uk."
           }  
           $chBCreatefolder.Checked = $false
}#End function.

#Populate the vaiables in the textbox.
function preSetVariables{

    #Define the variables for copying.
    $txtCopyFrom.Text =  ""
    $txtPastTo.Text = "M:\"
}

#Loads the form.
frmLoad
