##################################################################
#Autor:RedBullDog                                               #
#Data:29/12/2017                                                 #
#Descrição:Script para scannear portas abertas em servidores     #
##################################################################
from socket import *
from datetime import datetime

def Buscador(arquivo):
    dt = DataLog()
    #input de ip e portas que deseja vascular
    ip = str(input("Input ip server:"))
    start = int(input("Input initial port:"))
    end=int(input("Input final port:"))

    #Escrevendo logs
    arquivo.write("{} IP Server: {}\n".format(dt,ip))
    arquivo.write("{} Initial Port: {}\n".format(dt,start))
    arquivo.write("{} Final Port: {}\n".format(dt,end))
    print("Scanning ip {}".format(ip))
    for port in range(start,end):
        print("Teste Port"+str(port)+"....")
        s=socket(AF_INET, SOCK_STREAM)
        s.settimeout(5)
        if(s.connect_ex((ip,port))==0):
            print("port", port, "is open")
            dt1 = DataLog()
            arquivo.write("{} Port Open {}\n".format(dt1,port))
        s.close()

#função para escrever log
def WriteLog():
    msg="Scanneamento terminou, realizadocom sucesso"
    try:
        arquivo = open("ScannerPort.log","w")
        Buscador(arquivo)
        arquivo.close()
    except:
        msg="Erro!!! Verifique que você digitou informações ou se o servidor está on-line"
    finally:
        print(msg)

#função para gerar data dos eventos
def DataLog():
    data = datetime.now()
    tamanho = len(str(data)) - 7
    data2 = str(data)
    
    return data2[0:tamanho]

def Letreiro():
    print("<---------------------------------->")
    print("<-----------Bem-Vindo-------------->")
    print("<---------------------------------->")
    print("Versão:1.0.0.0")
    print("Scanner de porta")

Letreiro()
WriteLog()


