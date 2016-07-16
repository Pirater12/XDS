xds; もう一回、上から始めましょ!

thanks to
plutooo
Normmatt
Bond697
who helped me create XDS

To build XDS, run `make`. Yes, you can pass -jwhatever here. The goal is to hopefully clean up *some* of this mess (which is...hard, to say the least.)

To generate a NAND dump of the firmware, decrypt all CIAs for the firmware and run `python NAND/title/build_nand.py dir/to/cias` and the decrypted firmware will be placed into the correct directories. You also need ctrtool for this.
