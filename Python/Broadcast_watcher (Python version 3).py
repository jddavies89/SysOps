#C:\python27\Python.exe
#-*- coding: cp1252 -*-
'''

==========================================================================================================

Author                  : Joe Richards

Created Date            : 08/03/2018
Update Date             : 23/03/2018
Update Date             : 17/01/2019

Python Version          : 3

Description             : Broadcast_watcher.py is a client server program that once the clients connect to the server,
                          the server pings the clients IP Address and if the ping has failed, the server emails to notify the user.

Update                  : Changed the syntax for Python version 3 from 2.7.
                        : _winreg has changed to winregistry.
                        
Version                 : 4.2

Edits                   : To make this program work for yourself, you will need to make slight adjustments in the following functions.
                        : regAdd - Change the IP Addresses to your server ip address range and client ip address range.
                        : sendgmailsmtp - Change the email credentials to your gmail.
                        : sendOffice365smtp - Change the email credentials to your Office365.

Link                    : https://github.com/joer89/System_Operations.git

Modules                 : winregistry - .\pip.exe install winregistry

Running the program:

        The Client runs as follows.

        C:\Python27>broadcast_watcher.py client 127.0.0.1 10
        C:\Python27>broadcast_watcher.py client <IP_Address_Of_server> <Port_Of_Server>

        The Server runs as follows.

        C:\Python27Broadcast_watcher.py server 10 Broadcast_watcher
        C:\Python27>Broadcast_watcher.py server <Port_To_Use> <Email_subject_For_Office365>

Example of the Server side running:


        D:\Broadcast_watcher>Broadcast_watcher.py server 88 subject_title
        Listening for broadcasts on socket  ('0.0.0.0', 88)
        [+] Client connection ('127.0.0.1', 50531)
        ---> stat: b'User <username> logged in on computer <Computername>'
        ---> Time: 'Tue Mar 20 10:39:32 2018'
        [+]--�

        Pinging 127.0.0.1 with 32 bytes of data:
        Reply from 127.0.0.1: bytes=32 time<1ms TTL=128

        Ping statistics for 127.0.0.1:
            Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
        Approximate round trip times in milli-seconds:
            Minimum = 0ms, Maximum = 0ms, Average = 0ms



        [+] Client connection ('127.0.0.1', 50531)
        ---> stat: b'User <username> logged in on computer <Computername>'
        ---> Time: 'Tue Mar 20 10:39:42 2018'
        127.0.0.1 is in the list
        [+]--�

        Pinging 127.0.0.1 with 32 bytes of data:
        Reply from 127.0.0.1: bytes=32 time<1ms TTL=128

        Ping statistics for 127.0.0.1:
            Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
        Approximate round trip times in milli-seconds:
            Minimum = 0ms, Maximum = 0ms, Average = 0ms



        [+] Client connection ('10.xxx.xxx.xxx', 50646)
        ---> stat: b'User <username> logged in on computer <Computername>'
        ---> Time: 'Tue Mar 20 10:39:42 2018'
        [+] Client connection ('127.0.0.1', 50531)
        ---> stat: b'User <username> logged in on computer <Computername>'
        ---> Time: 'Tue Mar 20 10:39:52 2018'
        127.0.0.1 is in the list
        [+]--�

        Pinging 10.xxx.xxx.xxx with 32 bytes of data:
        Reply from 10.xxx.xxx.xxx: bytes=32 time<1ms TTL=128

        Ping statistics for 10.xxx.xxx.xxx:
            Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
        Approximate round trip times in milli-seconds:
            Minimum = 0ms, Maximum = 0ms, Average = 0ms



        [+] Client connection ('10.xxx.xxx.xxx', 50646)
        ---> stat: b'User <username> logged in on computer <Computername>'
        ---> Time: 'Tue Mar 20 10:39:52 2018'
        10.xxx.xxx.xxx is in the list

Server emails with the following:

        Subject         : Broadcast_watcher

        Body            : Failed to ping 10.xxx.xxx.xxx on Mon Mar 19 14:50:30 2018


==========================================================================================================

This file is part of Broadcast_watcher

Broadcast watcher is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Broadcast watcher is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

Please visit the GNU General Public License for more details: http://www.gnu.org/licenses/.


==========================================================================================================
'''

import socket
import sys
import datetime
import getpass
import re
from threading import Thread
import socket
import os
import smtplib
import time
from winreg import *



try:
        #Set the socket to a udp broadcast.
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
except socket.error as msg:
        print ("Failed to create socket. \nError: %s" % msg)
        sys.exit();

#Stores the subject name for emailing within Office365.
global subject
#Stores the max data to recv in bytes.
MAX = 65535
#Stores the format of the date and time used within the server.
format = "%a %b %d %H:%M:%S %Y"
#Stores the IP Addresses connected to the server i a list ({}) for dictionary, ([]) for list.
ipAddr = []

#Adding the running file path to the registry.
#Path is SOFTWARE\Microsoft\Windows\CurrentVersion\Run
def regAdd(node,IPOrPort,subjectOrPort):
        #Add to the registry.
        addr = socket.gethostbyname(socket.gethostname())

        aReg = ConnectRegistry(None,HKEY_CURRENT_USER)
        aKey = OpenKey(aReg, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Run", 0, KEY_WRITE)
        try:
                if(addr.find("10.210.14") != -1):
                        #Running on a server.
                        #Added the value manually due to py2exe not picking up __file__, and used sys.argv[] with the pipe commands.
                        SetValueEx(aKey,"Broadcast_watcher",0, REG_SZ, "C:\Broadcast_watcher\dist\Broadcast_watcher.exe %s %s %s" % (node, IPOrPort, subjectOrPort)) #server 100 Broadcast_watcher
                elif(addr.find("10.210.13") != -1):
                        #Running on a client.
                        #Added the value manually due to py2exe not picking up __file__, and used sys.argv[] with the pipe commands.
                        SetValueEx(aKey,"Broadcast_watcher",0, REG_SZ, "C:\Broadcast_watcher\dist\Broadcast_watcher.exe %s %s %s" %(node, IPOrPort, subjectOrPort)) #client 10.210.143.21 100")

        except EnvironmentError:
                #Get the current time.
                tme = getTime()
                print("Failed to write to the registry at %s." % (tme))
        #Close the registry connections.
        CloseKey(aKey)
        CloseKey(aReg)

#Send smtp emails within Gmail.
def sendgmailsmtp(msgText):
    server = smtplib.SMTP("smtp.gmail.com",587)
    server.starttls()
    server.login("Emailgmail.com", "Password")
    message = 'Subject: {}\n\n{}'.format("Subject", msgText)
    server.sendmail("Emailgmail.com", "Emailgmail.com", message)
    server.quit()

#Send smtp emails within Office365.
def sendOffice365smtp(msgText):
    #Stores the subject name for emailing within Office365.
    global subject
    server = smtplib.SMTP("{your_domain}.mail.protection.outlook.com")
    message = "Subject: {}\n\n{}".format(subject, msgText)
    server.sendmail("FromEmail@domain.com", "ToEmail@domain.com", message)
    server.quit()

#Ping the ip addresses seperately within each thread.
def pingIPAddress(address):
        #Ping the ip addresses within the list of IP Addresses.
        print("[+]--�")
        response = os.system(("ping -n 1 -i 10 %s") % address)
        print("\n\n")
        # and then check the response...
        if response != 0:
                #Get the current time.
                tme = getTime()
                #For the email message.
                msg = ("Failed to ping %s at %s" % (address, tme))
                #Send to the gmail account.
                #sendgmailsmtp(msg)
                #Send to the Office365 account.
                sendOffice365smtp(msg)

#Run 'pingIPAddress' function in seperate threads.
def threadedPing(address):
        t = Thread(target=pingIPAddress, args=(address,))
        t.start()

#Extract the IP Address from the receiving socket in the server then append to the list.
def ragexIPAddress(address):
        ip = re.search("([\d]+.[\d]+.[\d]+.[\d]+)", str(address))
        ips = ip.group()
        return ips

#Check if the address is in the array of ipAddresses list.
def appendAddress(address):
        if (address not in ipAddr):
                #Append the ip address to the list.
                ipAddr.append(address)
        else:
                print("%s is in the list" % address)

#Ping each address connected to the server to check connectivity.
def monitor():
        try:
            while True:
                for x in ipAddr:
                        #ping the ip address within a new thread
                        threadedPing(x)
                        #Wait 10 seconds before each ping.
                        time.sleep(10)
        except KeyboardInterrupt:
                pass

#returns the current date and time.
def getTime():
        today = datetime.datetime.today()
        tm = today.strftime(format)
        return tm

#Sends data to the server from the client.
def send(network,PORT):
        #Stores the message in the correct format with the currently logged in username and computer name as a byte mesage.
        msg = ("User %s logged in on computer %s" % (getpass.getuser(),socket.gethostname())).encode()
        #Sends the string.
        sock.sendto(msg, (network,PORT))

#Recevives the message fromthe client.
def recv(sock):

        #Retrives the data and address of the client.
        data, address = sock.recvfrom(MAX)
        '''
         Prints out the string in the correct format, for example:
            [+] Client connection ('<IP Address>', 50894)
            ---> stat: 'User <username> logged in on computer <Computername>'
            ---> Time: 'Tue Mar 06 12:40:07 2018'
         '''
        msg = ("[+] Client connection %r \n---> stat: %r \n---> Time: %r" % (address, data, getTime()))
        print(msg)

        #Extract the IP Address from the socket.
        addr = ragexIPAddress(address)

        #Add the IP Address to the list if its not in the list.
        appendAddress(addr)

#Run the main program.
def main():

        '''
        If the Server is in the format of:
        program.ext server <portNo> <Subject>
        '''
        if (len(sys.argv) <= 4 and sys.argv[1] == "server" and sys.argv[2] != None and sys.argv[3] != None):

                #Keyboard Interrupt to cancel.
                try:
                        #Adds the program to the registry with the pipe commands.
                        regAdd(sys.argv[1],sys.argv[2],sys.argv[3])

                        #Stores the subject name for emailing within Office365.
                        global subject
                        #Stores the subject from the inline argument.
                        subject = sys.argv[3]

                        #Start the ping loop in a new thread.
                        th = Thread(target=monitor)
                        th.start()

                        #Store the port number from the argument.
                        PORT = int(sys.argv[2])
                        #Make a socket.
                        sock.bind(("",PORT))

                        #Print out on screen.
                        print("Listening for broadcasts on socket ",sock.getsockname())
                        #While there is data to receive, receive the data.
                        while True:
                            recv(sock)

                except socket.error as msg:
                        print ("Failed to create socket. \nError: %s" % msg)
                        sys.exit(0);

                '''
                If the client is in the format of;
                program.ext client <IPAddress_Of_Server> <Port_no>
                '''
        elif(len(sys.argv) == 4 and sys.argv[1] == "client" and sys.argv[2] != None and sys.argv[3] != None):

                #Adds the program to the registry with the pipe commands.
                regAdd(sys.argv[1],sys.argv[2],sys.argv[3])

                #Store the arguments to the correct strings.
                network = sys.argv[2]
                PORT = int(sys.argv[3])

                #Send a transmittion every 10 seconds to check in.
                while True:
                        #Send the data to the server.
                        send(network,PORT)
                        time.sleep(10)

        #Otherwise print an error and exit.
        else:
                print(sys.stderr, "usage: Broadcast_watcher.py server <PORT> <EMAIL_SUBJECT>")
                print(sys.stderr, "usage: Broadcast_watcher.py client <HOST> <samePortAsServer>")
                sys.exit(2)

#Start the program.
main()
