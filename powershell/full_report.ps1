#---------------------------------------------functions----------------------------------------------------------
function system_hardware_info {
    gwmi win32_computersystem | select @{ n="Hardware Description"; e={$_.name} } 
}
function operating_system_info {
    gwmi win32_operatingsystem | select Caption,Version
}
function CPU_info {
    gwmi win32_processor | select Name,NumberOfCores,
                                  @{ n = "L1CacheSize" ; e = { if($_.L1CacheSize -ne $null) {
                                                                    $_.L1CacheSize
                                                               } else {
                                                                    "data unavailable"
                                                               }
                                                             }
                                  }, 
                                  @{ n = "L2CacheSize" ; e = { if($_.L2CacheSize -ne $null) {
                                                                    $_.L2CacheSize
                                                               } else {
                                                                    "data unavailable"
                                                               }
                                                             }                              
                                  }, 
                                  @{ n = "L3CacheSize" ; e = { if($_.L3CacheSize -ne $null) {
                                                                    $_.L3CacheSize
                                                               } else {
                                                                    "data unavailable"
                                                               }
                                                             }                              
                                  }
}
function memory_info {
    gwmi win32_physicalmemory | select @{ n = "Vendor"; e = {$_.Manufacturer}},
                                       Description,
                                       @{ n = "Size(GB)"; e = {$_.Capacity / 1GB -as [int]}},
                                       BankLabel,
                                       DeviceLocator
}
function disk_info {
    $diskdrives = Get-CIMInstance CIM_diskdrive
    $diskinfo = foreach ($disk in $diskdrives) { 
        $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition 
        foreach ($partition in $partitions) { 
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk 
            foreach ($logicaldisk in $logicaldisks) { 
                new-object -typename psobject -property @{ Drive=$logicaldisk.deviceid; 
                                                           Vendor=$disk.Manufacturer; 
                                                           Model=$disk.model; 
                                                           “Size(GB)”="{0:N2}" -f ($logicaldisk.size / 1gb); 
                                                           "Space Usage(GB)"= "{0:N2}" -f (($logicaldisk.size - $logicaldisk.freespace) / 1gb)
                                                          } 
            } 
        }
    } 
$diskinfo
}
function video_card {
    gwmi win32_videocontroller | select @{ n = "Vendor"; e={$_.AdapterCompatibility}},
                                        Description,
                                        @{ n = "Current screen resolution"; e = { if ($_.CurrentHorizontalResolution -ne $null -and $_.CurrentVerticalResolution -ne $null) {
                                                                                    ($_.CurrentHorizontalResolution).toString() +" x " + ($_.CurrentVerticalResolution).toString() 
                                                                                  } else {
                                                                                    "data unavailable"
                                                                                  }
                                                                                }
                                        }
}

#---------------------------------------------main code----------------------------------------------------------
"Your System Information Report

1. System hardware description:"
system_hardware_info | fl

"2. Operating System:"
operating_system_info | fl

"3. Processor:"
CPU_info | fl

"4. Memory:"
memory_info | ft -AutoSize

"5. Disk:"
disk_info | ft -AutoSize

"6. Network Adapter:"
ip_configuration_report.ps1 | ft -AutoSize

"7. Video Card:"
video_card | fl
                                                                            