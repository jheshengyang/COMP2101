get-ciminstance win32_networkadapterconfiguration |
    Where-Object {$_.IPEnabled -eq $True} |
    ft Description,
       Index,
       IPAddress,
       IPSubnet,
       DNSDomain,
       @{n="DNSServer";e={$_.DNSServerSearchOrder}}
