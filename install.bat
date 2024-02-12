@echo off
chcp 65001 >nul
mode con: cols=80 lines=20

rem Verifica se o script foi executado com o argumento "payload"
if _%1_==_payload_ goto :payload

rem Obtém privilégios de administrador
:getadmin
echo %~nx0: iniciando o script...
set vbs=%temp%\getadmin.vbs
echo Set UAC = CreateObject^("Shell.Application"^)                >> "%vbs%"
echo UAC.ShellExecute "%~s0", "payload %~sdp0 %*", "", "runas", 1 >> "%vbs%"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

rem Este script executa o comando setup.exe com a configuração fornecida no arquivo Configuração.xml
rem Requer privilégios de administrador
:payload

rem Exibe o título e o menu principal
mode con: cols=80 lines=20
echo.
echo.
echo.
echo.
echo ██ ██████  ██     ██ ███████ ██████  
echo ██ ██   ██ ██     ██ ██      ██   ██ 
echo ██ ██   ██ ██  █  ██ █████   ██████  
echo ██ ██   ██ ██ ███ ██ ██      ██   ██ 
echo ██ ██████   ███ ███  ███████ ██████  
echo.                                     
echo.                                    
echo ===============================
echo        MENU PRINCIPAL
echo ===============================
echo 1. Executar setup
echo 2. Sair
echo ===============================

rem Solicita a escolha do usuário
set /p OPTION=Escolha uma opção: 

rem Verifica a opção escolhida pelo usuário
if "%OPTION%"=="1" (
    call :RUN_SETUP
) else if "%OPTION%"=="2" (
    exit
) else (
    echo Opção inválida. Por favor, escolha novamente.
    timeout /t 3 >nul
    goto :payload
)

exit /b

rem Executa o setup.exe com a configuração fornecida
:RUN_SETUP
rem Mudar para o diretório do script
cd /d "%~dp0"

rem Defina o caminho para o arquivo setup.exe
set SETUP_PATH="setup.exe"

rem Defina o caminho para o arquivo de configuração Configuração.xml
set CONFIG_FILE="Configuração.xml"

rem Verifique se os arquivos existem
if not exist %SETUP_PATH% (
    echo O arquivo setup.exe não foi encontrado.
    exit /b 1
)
if not exist %CONFIG_FILE% (
    echo O arquivo de configuração Configuração.xml não foi encontrado.
    exit /b 1
)

rem Verificar se o script está sendo executado como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requer privilégios de administrador.
    powershell -command "Start-Process '%comspec%' -ArgumentList '/c %~0' -Verb RunAs"
    exit /b
)

rem Execute o setup.exe com a configuração fornecida
echo.
echo.
echo █████   ██████  ██    ██  █████  ██████  ██████  ███████          
echo ██   ██ ██       ██    ██ ██   ██ ██   ██ ██   ██ ██               
echo ███████ ██   ███ ██    ██ ███████ ██████  ██   ██ █████            
echo ██   ██ ██    ██ ██    ██ ██   ██ ██   ██ ██   ██ ██               
echo ██   ██  ██████   ██████  ██   ██ ██   ██ ██████  ███████ ██ ██ ██ 
echo.
echo.
%SETUP_PATH% /configure %CONFIG_FILE%
exit /b