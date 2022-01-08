########################################### 
##  FTP Check and Get routine
##                        
## Martin Stevens
## budgester@budgester.com
###########################################

from ftplib import FTP
import os

print 'Welcome to the Log Transfer program'

###########################################
## Set-up the variables                    
###########################################

SITE = '******'
USER = '******'
PASS = '******'
REMOTE_LOG_DIR = '/WEBLOGS'
LOCAL_LOG_DIR = "/home/"

###########################################
## Connect to the FTP server and get a list
## of the files and get a list of the files
## that is held locally.                   
###########################################

print 'Connecting to the Remote Server'

ftp = FTP(SITE, USER, PASS)
ftp.set_debuglevel(0)
ftp.connect(SITE)
ftp.login(USER, PASS)
ftp.getwelcome()
ftp.set_pasv(1)
REMOTE_LOG_LIST = ftp.nlst(REMOTE_LOG_DIR)
LOCAL_LOG_LIST = os.listdir(LOCAL_LOG_DIR)


###########################################
## Compare the local and remote list's     
## Change list to only the files to get    
## from the remote server                  
###########################################

print 'Sorting which files need to be retrieved'

for x in LOCAL_LOG_LIST:
    for y in REMOTE_LOG_LIST:
        if y == x:
            REMOTE_LOG_LIST.remove(y)

ftp.cwd(REMOTE_LOG_DIR)

last_item = len(REMOTE_LOG_LIST)
print last_item - 1, ' Files to retrieve'
del REMOTE_LOG_LIST[last_item - 1]


###########################################
## Retrieve files from the remote server
###########################################

for logs_to_get in REMOTE_LOG_LIST:
    print 'Getting >', logs_to_get   
    get_file = 'RETR ' + logs_to_get
    retrieved_file = LOCAL_LOG_DIR + '\\' +     logs_to_get
    output = open(retrieved_file, 'wb')
    ftp.retrbinary(get_file, output.write)

print 'We have now got all the files, have a nice day'

ftp.quit()
