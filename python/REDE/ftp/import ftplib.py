import ftplib
session = ftplib.FTP('juliomonteiro.net','juliomonteiro','Singapore2806')
session.cwd('/')
f = open('*.bmp', 'r')
session.storbinary('STOR *.bmp', f)
f.close()
session.quit()
