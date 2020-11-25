# Lab 2 COMP2101 welcome script for profile
#
$env:path += ";$HOME/documents/github/comp2101/powershell"
#----------------------------------------------------------------------------------
new-item -path alias:np -value notepad | out-null

function get-cpuinfo {
	get-ciminstance cim_processor | Select-Object manufacturer,name,numberofcores,currentclockspeed,Maxclockspeed
}

function welcome {
	write-output "Welcome to planet $env:computername Overlord $env:username"
	$now = get-date -format 'HH:MM tt on dddd'
	write-output "It is $now.`n"
}

function get-mydisks {
    get-wmiobject win32_diskdrive | foreach {
        new-object -typename psobject -property @{Manufacturer=$_.Manufacturer;Model=$_.Model;
            SerialNumber=$_.SerialNumber;FirmwareRevision=$_.FirmwareVersion;Size=($_.size / 1GB).tostring() + " GB"}
    }
} 
#----------------------------------------------------------------------------------
get-cpuinfo | fl
welcome