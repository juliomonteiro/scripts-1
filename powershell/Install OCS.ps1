cd /
cd c:\
mkdir skylan
cd c:\skylan
Invoke-WebRequest -Uri http://inventario.skylan.com.br/ocs/OCS-NG-Windows-Agent-Setup.exe -outfile "OCS-NG-Windows-Agent-Setup.exe"
c:\skylan\OCS-NG-Windows-Agent-Setup.exe /S /NOSPLASH /TAG=SKYLAN /SERVER=http://inventario.skylan.com.br/ocsinventory
exit
