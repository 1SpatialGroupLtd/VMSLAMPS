$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	ioffset=="$lsl$source_root:[structure.icase.ioffset]ioffset"
$!
$	si lsl$source_root:[structure.icase.ioffset]
$!
$	ilink/break	st.iff st.ifj
$	ilink/struct	st.ifj st.ifj
$	ilink/sortarms	st.ifj st.ifj
$!
$	ioffset /par=lsl$source_root:[structure.icase.ioffset]st.par -
		st.ifj -
		st_cased.iff
$!
$	purge 	st.*
$!
