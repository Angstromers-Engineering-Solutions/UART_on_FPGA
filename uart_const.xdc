# Clock signal
set_property PACKAGE_PIN F14 [get_ports clk_100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100MHz]
	
# LEDs
set_property PACKAGE_PIN G1	 [get_ports {LED[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN G2	 [get_ports {LED[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN F1 	 [get_ports {LED[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN F2      [get_ports {LED[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN E1      [get_ports {LED[4]}]					
set_property IOSTANDARD LLVCMOS33[get_ports {LED[4]}]
set_property PACKAGE_PIN E2 	 [get_ports {LED[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN E3 	 [get_ports {LED[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN E5 	 [get_ports {LED[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]

#7 segment display
set_property PACKAGE_PIN D7 	 [get_ports {seg[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN C5 	 [get_ports {seg[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN A5 	 [get_ports {seg[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN B7  	 [get_ports {seg[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN A7 	 [get_ports {seg[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN D6 	 [get_ports {seg[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN B5 	 [get_ports {seg[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN D5 	 [get_ports {an[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN C4 	 [get_ports {an[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN C7 	 [get_ports {an[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN A8 	 [get_ports {an[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

##Buttons
## btnL
set_property PACKAGE_PIN J2 	 [get_ports btn]						
set_property IOSTANDARD LVCMOS33 [get_ports btn]
## btnR
set_property PACKAGE_PIN J5  	 [get_ports reset]						
set_property IOSTANDARD LVCMOS33 [get_ports reset]

##USB-RS232 Interface
set_property PACKAGE_PIN V12 [get_ports rx]						
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN U11 [get_ports tx]						
set_property IOSTANDARD LVCMOS33 [get_ports tx]
