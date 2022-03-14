echo "######### Warning : This will terminate all Command Windows and Java Programs. Proceed? #########"
pause
taskkill /F /IM "java.exe"
taskkill /F /IM "cmd.exe"
