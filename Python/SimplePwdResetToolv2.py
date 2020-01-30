'''
Author          :   Joe Richards
Date            :   12/12/2019.
Python version  :   3
Descriotion:    :   Bored of resetting passwords for people? job done.
        
                    To do:
                       1.  under section 'user.set_password("YourPassw0rdH3r3")', type a password of your choice.
                       2.  Under section 'print(user, "\npassword has been reset to YourPassw0rdH3r3")', type a password of your choice.
                    
Link            :   https://github.com/joer89/SysOps.git

Output of program in execution.

Active Directory username: User1
Do you want to reset the password for AD User1 ?
y = yes, anykey = quit; y
<ADUser 'CN=User1,OU=Finance,OU=England,OU=Users,OU=Org,DC=Domain,DC=com'> 
password has been reset to YourPassw0rdH3r3
Active Directory username:


Download pypiwin32 from pip.
pip install pypiwin32
from pyad import *

'''

def menu():    
    usr = input("Active Directory username: ")
    try:        
        user = pyad.aduser.ADUser.from_cn(usr)
        option = input("Do you want to reset the password for {} ?\ny = yes, anykey = quit; ".format(user.displayname))
        if option == "y":        
            reset_ADPassword(user)
    except:
        print("Please check username exists in AD.")
    finally:
        menu()


def reset_ADPassword(user):    
    user.set_password("YourPassw0rdH3r3")
    user.force_pwd_change_on_login()
    print(user, "\npassword has been reset to YourPassw0rdH3r3")

if __name__ == "__main__":
    menu()
    
