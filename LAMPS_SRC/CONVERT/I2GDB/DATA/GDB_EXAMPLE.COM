
$! TEST OUT I2GDB PROGRAM
$!
$! output revision level 1
$	define lsl$iff_output_revision 1
$!
$! define which version of the program to use
$!
$	i2gdb == "$lsl$source_root:[convert.i2gdb]i2gdb"
$!
$! generate iff file for testing
$!
$	ifromtext/frt=here:gdb_example.frt -
		here:gdb_example.txt -
		here:gdb_example.iff
$!
$! run it
$!
$	i2gdb 	/frt=here:gdb_example.frt -
		/parameters=here:gdb_example.par -
		here:gdb_example.iff -
		here:gdb_example.gdb
