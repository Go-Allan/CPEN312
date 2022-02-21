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
	global usbblaster_name
	global target_device
 
    # Record the client's information
 
    puts "Accept $sock from $addr port $port"
    set conn(addr,$sock) [list $addr $port]
 
    # Ensure that each "puts" by the server results in a network transmission
 
    # fconfigure $sock -buffering none
    fconfigure $sock -translation binary -buffering none -blocking false
    # Set up a callback for when the client sends data
 
    fileevent $sock readable [list IncomingData $sock]

	puts "\nConnecting to $usbblaster_name $target_device";
    begin_memory_edit -hardware_name $usbblaster_name -device_name $target_device
    
 	#puts $sock "Ready for Commands.\r"
 	
 	#while {1} {
 	#	if {[eof $sock]} {
 	#		break
 	#	}
	#	set count [read_content_from_memory -instance_index 1 -start_address 0x100 -word_count 1 -content_in_hex]
	#	#puts "Count: $count"
	#	set countd [expr 0x$count]
	#	set mystr ""
	#	if {$countd!=0} {
	#		set received [read_content_from_memory -instance_index 1 -start_address 0x101 -word_count $countd -content_in_hex]
	#		for {set i 0} {$i<$countd} {incr i} {
	#			set ascii_hex [string range $received [expr $i*2] [expr $i*2+1]]
	#			set mystr [format "%c" [expr 0x$ascii_hex]]$mystr
	#		}
	#		# puts "RX: $received ($mystr)\r"
 	#		puts $sock "$mystr\r"
	#		write_content_to_memory -instance_index 1 -start_address 0x100 -word_count 1 -content "00" -content_in_hex
	#	}
	#	update
	#}
}
 
proc IncomingData {sock} {
    global conn
 
    # Check end of file or abnormal connection drop,
    # then write the data to the vJTAG
 
    if {[eof $sock] || [catch {gets $sock line}]} {
	    close $sock
	    puts "Close $conn(addr,$sock)"
	    unset conn(addr,$sock)
	    end_memory_edit
    } else {
	    #Before the connection is closed we get an emtpy data transmission. Let's check for it and trap it
	    set data_len [string length $line]
	    set myval ""
	    if {$data_len != "0"} then {
			for {set i 0} {$i < [string length $line]} {incr i} {
				set char [string index $line $i]
				scan $char %c ascii
				set myval [format "%02X" $ascii]$myval
				#puts "char: $char (ascii: $ascii) (hex: $myval)"
			}
			#puts "sending $myval, which has $i characters"
			write_content_to_memory -instance_index 1 -start_address 1 -word_count $i -content "$myval" -content_in_hex
			set myval "[format "%02X" $i]"
			#puts "Setting first byte to $myval"
			write_content_to_memory -instance_index 1 -start_address 0 -word_count 1 -content "$myval" -content_in_hex
	    }
    
		set count [read_content_from_memory -instance_index 1 -start_address 0x100 -word_count 1 -content_in_hex]
		#puts "Count: $count"
		set countd [expr 0x$count]
		set mystr ""
		if {$countd!=0} {
			set received [read_content_from_memory -instance_index 1 -start_address 0x101 -word_count $countd -content_in_hex]
			for {set i 0} {$i<$countd} {incr i} {
				set ascii_hex [string range $received [expr $i*2] [expr $i*2+1]]
				set mystr [format "%c" [expr 0x$ascii_hex]]$mystr
			}
			# puts "RX: $received ($mystr)\r"
			puts $sock "$mystr\r"
			write_content_to_memory -instance_index 1 -start_address 0x100 -word_count 1 -content "00" -content_in_hex
		}
    }

}

exec stty raw

#Start thet Server at Port 2540
Start_Server 2540

#set char "A"
#scan $char %c ascii
#set myval "[format "%2x" $ascii]"
#puts "char: $char (ascii: $ascii) (hex: $myval)"

