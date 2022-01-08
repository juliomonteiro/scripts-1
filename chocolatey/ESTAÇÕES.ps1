Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install javaruntime -y

choco install 7zip -y

choco install powershell -y
choco install GoogleChrome -y
choco install firefox -y
choco install opera -y
choco install 7zip -y
choco install JavaRuntime -y
choco install dotnet4.7.2 -y
choco install silverlight -y
choco install adobereader -y
choco install microsoft-teams -y
choco install notepadplusplus.install -y