# List all available programming hardwares, and select the USBBlaster.
# (Note: this example assumes only one USBBlaster connected.)
puts "Programming Hardwares:"
foreach hardware_name [get_hardware_names] {
	puts $hardware_name
	if { [string match "USB-Blaster*" $hardware_name] } {
		set usbblaster_name $hardware_name
	}
}
puts "\nSelect JTAG chain connected to $usbblaster_name.\n";

# List all devices on the chain, and select the first device on the chain.
puts "\nDevices on the JTAG chain:"
foreach device_name [get_device_names -hardware_name $usbblaster_name] {
	puts $device_name
	if { [string match "@1*" $device_name] } {
		set test_device $device_name
	}
}
puts "\nSelect device: $test_device.\n";

# Open device 
open_device -hardware_name $usbblaster_name -device_name $test_device

# Retrieve device id code.
# IDCODE instruction value is 6; The ID code is 32 bits long.

# IR and DR shift should be locked together to ensure that other applications 
# will not change the instruction register before the id code value is shifted
# out while the instruction register is still holding the IDCODE instruction.
device_lock -timeout 10000
device_ir_shift -ir_value 6 -no_captured_ir_value
puts "IDCODE: 0x[device_dr_shift -length 32 -value_in_hex]"
device_unlock

# Close device
close_device