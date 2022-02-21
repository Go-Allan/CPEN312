# Script mostly from:
# http://quartushelp.altera.com/current/mergedProjects/tafs/tafs/tcl_pkg_jtag_ver_1.0_cmd_get_device_names.htm
#
# List all available programming hardwares, and select the USBBlaster.
# (Note: this example assumes only one USBBlaster connected.)
#puts "JTAG chains:"

global myindex

if { [catch get_hardware_names] } {
	puts "ERROR: USB-Blaster hardware not found."
	exit
}

foreach hardware_name [get_hardware_names] {
	puts $hardware_name
	if { [string match "USB-Blaster*" $hardware_name] } {
		set usbblaster_name $hardware_name
	}
	if { [string match "DE-SoC*" $hardware_name] } {
		set usbblaster_name $hardware_name
	}
}

# List all devices on the chain, and select the first device on the chain.
#puts "\nDevices available on JTAG chain:"
set target_device "0"
foreach device_name [get_device_names -hardware_name $usbblaster_name] {
	puts $device_name
	if { [string match "@1*" $device_name] } {
		set target_device $device_name
	}
}

# The DE1-SoC's FPGA is device number 2
if { [string match "@1: SOCVHPS*" $target_device] } {
	set target_device "0"
	foreach device_name [get_device_names -hardware_name $usbblaster_name] {
		puts $device_name
		if { [string match "@2*" $device_name] } {
			set target_device $device_name
		}
	}
}

if {$target_device==0} {
	puts "ERROR: Target device not found."
	exit
}

puts "\nConnecting to $usbblaster_name $target_device";

set lastbyte "0"
set mem_list [get_editable_mem_instances -hardware_name $usbblaster_name -device_name $target_device]
foreach i $mem_list {
	# puts "[lindex $i 0],[lindex $i 1],[lindex $i 2],[lindex $i 3],[lindex $i 4],[lindex $i 5]"
	if {"XDAT"==[lindex $i 5]} {
		puts "Valid memory found"
		set myindex [lindex $i 0]
		set lastbyte [expr [lindex $i 1]-1]
	}
}
# puts "myindex=$myindex, mysize=$lastbyte"

if {$lastbyte==0} {
	puts "ERROR: 'XDAT' memory not found in target device."
	exit
}

#Code Derived from Tcl Developer Exchange - http://www.tcl.tk/about/netserver.html
 
proc Start_Server {port} {
    set s [socket -server ConnAccept $port]
    puts "Started Socket Server on port - $port"
    vwait forever
}
 
proc ConnAccept {sock addr port} {
    global conn
 
    # Record the client's information
 
    puts "Accept $sock from $addr port $port"
    set conn(addr,$sock) [list $addr $port]
 
    # Ensure that each "puts" by the server
    # results in a network transmission
 
    fconfigure $sock -buffering none
 
    # Set up a callback for when the client sends data
 
    fileevent $sock readable [list IncomingData $sock]
}
 
proc IncomingData {sock} {
    global conn
 
    # Check end of file or abnormal connection drop,
    # then write the data to the vJTAG
 
    if {[eof $sock] || [catch {gets $sock line}]} {
    close $sock
    puts "Close $conn(addr,$sock)"
    unset conn(addr,$sock)
    } else {
    #Before the connection is closed we get an emtpy data transmission. Let's check for it and trap it
    set data_len [string length $line]
    if {$data_len != "0"} then {
		for {set i 0} {$i < [string length $line]} {incr i} {
		  set char [string index $line $i]
		  scan $char %c ascii
		  set myval "[format "%2x" $ascii]"
		  #puts "char: $char (ascii: $ascii) (hex: $myval)"
		  write_content_to_memory -instance_index 1 -start_address 1 -word_count 1 -content "$myval" -content_in_hex
		  write_content_to_memory -instance_index 1 -start_address 0 -word_count 1 -content "01" -content_in_hex
		}
    }
    }
}
 
#Start thet Server at Port 2540
begin_memory_edit -hardware_name $usbblaster_name -device_name $target_device
Start_Server 2540

#set char "A"
#scan $char %c ascii
#set myval "[format "%2x" $ascii]"
#puts "char: $char (ascii: $ascii) (hex: $myval)"




