$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	ioffset=="$lsl$source_root:[structure.icase.ioffset]ioffset"
$!
$	si lsl$source_root:[structure.icase.ioffset]
$!
$	ilink/break	2030_st.iff 2030_st.ifj
$	ilink/struct	2030_st.ifj 2030_st.ifj
$	ilink/sortarms	2030_st.ifj 2030_st.ifj
$!
$	ioffset /par=lsl$source_root:[structure.icase.ioffset]st.par -
		2030_st.ifj -
		2030_st_cased.iff
$!
$	purge 	2030_st.*
$!
