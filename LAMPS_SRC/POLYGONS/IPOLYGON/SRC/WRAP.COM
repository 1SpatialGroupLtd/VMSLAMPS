$	set nover
$	if (P1.nes."")
$	then
$		WS "including the wrapper"
$		OPEN/write INIFILE tmp_init.EDT
$		WRITE INIFILE "include w."
$		WRITE INIFILE "exit"
$		CLOSE INIFILE
$		DEF/USER edtini "here:tmp_init.edt"
$		edt 'P1'.SRC
$!
$		WS "processing"
$		OPEN/write INIFILE tmp_init.EDT
$		WRITE INIFILE "SUBS/???/"'P1'"/:10000/NOTY"
$		WRITE INIFILE "FIND ""PROPER FUNCTION"""
$		WRITE INIFILE "SUBS/"'P1'"/ACTUAL_"'P1'"/:10000/NOTY
$		WRITE INIFILE "FIND ""***"""
$		WRITE INIFILE "INCLUDE ARGS."
$		WRITE INIFILE "exit"
$		CLOSE INIFILE
$		DEF/USER edtini "here:tmp_init.edt"
$		edt 'P1'.SRC
$!
$		DEF/USER SYS$INPUT SYS$COMMAND
$		edt 'P1'.SRC
$	ELSE
$		WS "NO FILE NAME SUPPLIED YOU FOOL!"
$	ENDIF
