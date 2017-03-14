winrm quickconfig -force
winrm set winrm/config/client '@{TrustedHosts="*"}'
Enable-WSManCredSSP Server -force
winrm set winrm/config '@{MaxEnvelopeSizekb="8000"}' 
netsh advfirewall firewall set rule group=”File and Printer Sharing” new enable=Yes
wevtutil.exe set-log “Microsoft-Windows-Dsc/Analytic” /q:true /e:true /ms:104857600
wevtutil.exe set-log “Microsoft-Windows-Dsc/Debug” /q:True /e:true /ms:104857600

Test Winrm is running in server
Test-WSMan 192.168.your.ip
