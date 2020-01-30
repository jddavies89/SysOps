#!/usr/bin/env python
#^ used for the watchdog module to be recognised.

'''

Author: Joe Richards

Created Date: 28/02/2018

Python Version 2.7

'''

#Import the modules.
import logging
import sys
import time
import smtplib
from watchdog.events  import FileSystemEventHandler
from watchdog.observers import Observer

#Set the global strings.
global sendSMTP
global logFile
global fileName

#Send smtp emails within Office365.
def sendsmtp(msgText):
    server = smtplib.SMTP("mail.messaging.microsoft.com")
    message = 'Subject: {}\n\n{}'.format("Path Monitor", msgText)
    server.sendmail("itsupport@", "itsupport@", message)
    server.quit()

#Class for the watchdog monitor.
class monitorEvents(FileSystemEventHandler):
    #global variables needed within the class.
    global sendSMTP
    global logFile
    global fileName

    #Check the parameter arguemtns.
    def logger(self):
        #Check to see if logging to file is enabled or not and if so adds the file path and name to filename= within the logging.
        if (logFile == "True"):
            logging.basicConfig(level=logging.DEBUG,filename=fileName,format="%(asctime)s   :   %(message)s")
            print("logging to file.")
        else:
            print("Not logging to file.")

        #Check to see if logging to email is enabled or not.
        if(sendSMTP != "True"):
            print("Not logging to email.")
        else:
            print("Logging to email.")

    def catch_all_handler(self, event):
        #Log to the the log file.
        if (logFile == "True"):
            logging.debug(event)
  
    def on_moved(self, event):
        self.catch_all_handler(event)
  
    def on_created(self, event):
        self.catch_all_handler(event)
  
    def on_deleted(self, event):
        #self.catch_all_handler(event)
        #Prints on screen.
        print(event)
        
        #Log to the the log file.
        if (logFile == "True"):
            logging.debug(event)
            
        #Sends email if argument is true.
        if(sendSMTP == "True"):
            #Send email.
            sendsmtp(event)
            
    def on_modified(self, event):
        self.catch_all_handler(event)

#Start the monitoring process.
def monitor(path):
    #Stores the class.
    monitor_events = monitorEvents()
    #Runs the logger function for checking to see if logging to file is enabled.
    monitor_events.logger()
    
    observer = Observer()
    observer.schedule(monitor_events, path, recursive=True)
    observer.start()    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

#Main program.
def main():
    #global variables needed within the function.
    global sendSMTP
    global logFile
    global fileName
    
    #Check if there is four arguments written in by the user.
    #The first argument is the name of the python script.
    #The second argument is the directory in which is being listened.
    #The third argument is if you want to send an email true/false.
    #The fourth argument is log to a file true/false.
    #The fith argument is the file name.
    if (len(sys.argv) == 5 and sys.argv[2] == "true" or sys.argv[2] == "false" and sys.argv[3] == "true" or sys.argv[3] == "false" and sys.argv[4] != None):
        #Splits and stores the arguements into strings.
        path = sys.argv[1]
        SMTP = sys.argv[2]
        log = sys.argv[3]
        fileName = sys.argv[4]
        
        #Check if its sending email is true or false.
        if(SMTP.upper() == "TRUE"):
            sendSMTP = "True"
        else:            
            sendSMTP = "False"
            
        #Check if the program is logging to a file.
        if (log.upper() == "TRUE"):
            logFile = "True"
        else:
            logFile = "False"
        
        #Monitor the path given in the argument.
        monitor(path)    
    else:
        #Print an error if it doe not match the format.
        print(sys.stderr, "Argument error. Usage: <app.py> <dir_to_monitor> SMTPSending:true/false> <LogFile:true/false> <filename.extension>")

#Starts the program.
main()




'''
Example of the program running;

C:\Python27>PathMonitor.py C:\ true true file
logging to file.
Logging to email.
<FileDeletedEvent: src_path=u'C:\\Program Files (x86)\\...\\screen.png'>
<FileDeletedEvent: src_path=u'C:\\Windows\\Temp\\....tmp'>
<FileDeletedEvent: src_path=u'C:\\Windows\\Temp\\....tmp'>
<FileDeletedEvent: src_path=u'C:\\ProgramData\\...\\journal345CDDFC'>



Example of file created.

2018-02-28 14:18:06,979   :   <FileModifiedEvent: src_path=u'C:\\ProgramData\\...\\...\\....dat'>
2018-02-28 14:18:09,986   :   <FileCreatedEvent: src_path=u'C:\\Program Files (x86)\\...\\screen.png'>
2018-02-28 14:18:10,513   :   <FileDeletedEvent: src_path=u'C:\\Program Files (x86)\\...\\screen.png'>



Example of email

<FileDeletedEvent: src_path=u'C:\\Program Files (x86)\\...\\screen.png'>

---
This email has been checked for viruses by ...



Example of program failing on arguments.

C:\Python27>PathMonitor.py C:\ false f file
(<open file '<stderr>', mode 'w' at 0x0222D0D0>, 'Argument error. Usage: <app.py> <dir_to_monitor> SMTPSending:true/false> <LogFile:true/false> <filename.extension>')


'''



