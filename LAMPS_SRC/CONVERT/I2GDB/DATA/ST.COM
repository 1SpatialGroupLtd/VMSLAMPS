
$! TEST OUT I2GDB PROGRAM
$!
$! output revision level 1
$	define lsl$iff_output_revision 1
$!
$! define which version of the program to use
$!
$!	i2gdb == "$lsl$source_root:[convert.i2gdb]i2gdb"
$!
$! generate iff file for testing
$!
$	ifromtext/frt=here:st.frt -
		here:st.txt -
		here:st.iff
$!
$! run it
$!
$	i2gdb 	/frt=here:st.frt -
		/parameters=here:st.par -
		here:st.iff -
		here:st.gdb
