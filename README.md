xds; Gör om, gör rätt.

thanks to
plutooo
Normmatt
Bond697
who helped me create XDS

To build XDS, first build external/gl3w
On Windows, use windows/xds.sln
On OSX, install libglfw3 (Makefile assumes its installed with MacPorts), then 
run `make`

To generate a NAND dump of the firmware, decrypt all CIAs for the firmware and 
run `python NAND/title/build_nand.py dir/to/cias` and the decrypted firmware 
will be placed into the correct directories. You also need ctrtool for this.
