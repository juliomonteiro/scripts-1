Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#Instalar Office 365
choco install office365business --params="/productid:O365ProPlusRetail" /language:"pt-BR" /updates:"FALSE" /eula:"FALSE"

choco install googlechrome -y
choco install spotify -y
choco install adobereader -y
choco install microsoft-windows-terminal -y
choco install paint.net -y
choco install treesizefree -y
choco install vscode.install -y
choco install microsoft-teams -y
choco install putty.install -y
choco install 7zip -y
choco install sysinternals -y 
choco install vlc -y
choco install python3 -y
choco install notepadplusplus.install -y
choco install fastcopy -Y