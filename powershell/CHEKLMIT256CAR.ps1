Set-ExecutionPolicy Unrestricted

#Informar o caminho da pasta do Onedrive
#Exemplo: $path_onedrive = "C:\Users\euedi\OneDrive - Skylan Technology"

$path_onedrive = "D:\#CLOUD\SKYLAN\Julio Monteiro"
cd $path_onedrive

#Informar o destino onde o arquivo de log será gravado
$path = "c:\skylan\resultado.txt"

#Lista o path de todos os arquivos com mais de 256 caracteres no PATH
$file = Get-ChildItem -r * |? {$_.GetType().Name -match "File" } |? {$_.fullname.length -ge 256} |%{$_.fullname}

#Exporta o resultado para o arquivo.txt conforme informado na variável $PATH
$file | out-file -filepath $path -Append