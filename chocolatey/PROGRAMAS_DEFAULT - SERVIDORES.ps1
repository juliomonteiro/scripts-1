Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install 7zip -y 
choco install anydesk -y 
choco install notepadplusplus.install -y 
choco install vscode -y 
choco install sysinternals -y 
choco install nirlauncher -y
choco install treesizefree -y 
choco install python -y 
choco install azurepowershell -y 
choco install azure-cli -y 
choco install azcopy -y 
choco install baretail -y 
choco install teracopy -y 
choco install snaketail -y