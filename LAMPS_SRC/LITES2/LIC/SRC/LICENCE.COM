$!
$! Command file to generate a licencing function for LITES2
$!
$	SAVVER='f$verify(0)
$	CURDIR=f$environment("DEFAULT")
$	set on
$	on WARNING then goto  ERR_EXIT	! stop for anything
$!
$	set default LSL$SOURCE_ROOT:[LITES2.LIC]
$!
$! get name of installation
$!
$	if P1 .nes. "" then goto GOT_NAME
$	write SYS$OUTPUT ""
$	inquire P1 "Installation name"
$	if P1 .eqs. "" then goto ERR_EXIT	! premature exit
$! 
$! run INSTGEN as a foreign image, to create the file COM:CUSTDAT.SRC
$!
$ GOT_NAME:
$	instgen := $SYS$DISK:[]instgen
$	define/user_mode SYS$INPUT SYS$COMMAND	! get input from terminal
$	if f$search(CURDIR+P1+".FAC") .nes. "" then-
	   define/user_mode SYS$INPUT 'CURDIR''P1'.FAC
$	instgen 'P1'
$!
$! now compile and build a licencing subroutine using this data
$!
$	write SYS$OUTPUT ""
$	write SYS$OUTPUT "Creating licence file"
$	LICFILE:='CURDIR''P1'.LIC
$	adc LOCKFU=LOCKFU
$	fort LOCKFU
$	pvv LOCKFU
$	delete ADC.IDE;*
$	link/share/exe='LICFILE' SYS$INPUT:/OPT
LOCKFU
UNIVERSAL=LOCKFU
$	set noon				! file created now
$	delete LOCKFU.FOR;*,LOCKFU.OBJ;*
$	purge 'LICFILE'
$	purge CUSTDAT.SRC
$	write SYS$OUTPUT ""
$	write SYS$OUTPUT "Licence file ''LICFILE' created"
$	GOTO EXIT
$!
$ ERR_EXIT:
$	write SYS$OUTPUT ""
$	write SYS$OUTPUT "No licence file created"
$ EXIT:
$	write SYS$OUTPUT ""
$	set default 'CURDIR'
$	if SAVVER then set noverify
