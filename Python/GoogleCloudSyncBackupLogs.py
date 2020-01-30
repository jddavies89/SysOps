###########################################################
##
##  Author:         Joe Richards
##
##  Creation Date:  24/July/2017
##
##  Purpose:        Backup the Google Cloud Sync Log file.
##
##  Written in:     Python 3.6.0
##
###########################################################

#Import the apps.
import shutil
import datetime as dt
import os
#Stores the current date and time.
global time

class googleCloudSync:
    #path to current gcds_syncFileLog
    gcds_syncLogPath = r"\\Google_Cloud_Sync_Server\Share\GADS_sync.log"

    #Backup path for gcds_synfFileLog
    gcds_syncLogBackupPath = r"\\Backup_Server\Share\Google_Cloud_Sync_Backups"


def dirExist():
    #Create the backup directory if it doesn't exist.
    if not os.path.exists(googleCloudSync.gcds_syncLogBackupPath):
        os.mkdir(googleCloudSync.gcds_syncLogBackupPath)

try:
    #Retrieves the date and time.
    time = dt.datetime.now()

    #Function for creating the directory if it doesnt exist.
    dirExist()
    
    #Append or create the log file.
    file = open(googleCloudSync.gcds_syncLogBackupPath + "\\logs.txt", "a")
    file.write("\n"+str(time))
    file.write("\nTrying to copy from: " + googleCloudSync.gcds_syncLogPath + " To " + googleCloudSync.gcds_syncLogBackupPath)

    #Copy the GADS_sync.log file and metadata.
    copyCloudLog = shutil.copy2(googleCloudSync.gcds_syncLogPath,googleCloudSync.gcds_syncLogBackupPath)

    file.write("\nCopied " + googleCloudSync.gcds_syncLogPath)
    file.close()
        
except Exception as error:
    #Append or create the log file and report the error.
    file = open(googleCloudSync.gcds_syncLogBackupPath + "\\logs.txt", "a")
    file.write(("\n"+str(time)) + " - " + str(error.args))    
    file.close()
    
