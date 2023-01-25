$env:SSLKEYLOGFILE=(Join-Path $PSScriptRoot "sslkeylogfile.txt")
& "chrome.exe"
if (Test-Path -Path "$pwd/eportal.pcapng" ) {
    Rename-Item -Path "$pwd/eportal.pcapng"  -NewName ("eportal-"+(Get-Date -Format "MM-dd-yyyy-HH-mm-ss")+".pcapng")
}
$interface =  Get-CimInstance -Class Win32_NetworkAdapter -Property NetConnectionID,NetConnectionStatus | Where-Object { $_.NetConnectionStatus -eq 2 } | Select-Object -Property NetConnectionID -ExpandProperty NetConnectionID
& "tshark.exe" -w .\eportal.pcapng -i $interface -o tls.keylog_file:"sslkeylogfile.txt"