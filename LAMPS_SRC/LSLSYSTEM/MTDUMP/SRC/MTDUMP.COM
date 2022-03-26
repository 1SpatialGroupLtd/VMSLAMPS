$!
$!	set up the exit route for error and cntl Y
$!
$ 	on control_y then goto COEXIT
$	on error then goto COEXIT
$!
$	inquire mes "Messages"
$	inquire cld "CLD file"
$	inquire for "Fortran"
$	inquire lnk "Link"
$	inquire deb "With debug"
$!
$	set verify
$	if mes then newmsg MTDUMP/number=1272
$	if mes then @MTDUMP.TEMP_COM
$!
$	if .not.cld then goto nocld
$		adc MTDUMP.TMP=MTDUMP.CLD
$	   	set command/object=MTDUMP_CLD MTDUMP.TMP
$		pvv MTDUMP_CLD
$		delete ADC.IDE;*,MTDUMP.TMP;*
$		
$!
$nocld:	if .not.for then goto nofor
$	opt1=""
$	if deb then opt1="/deb/noopt/check=all"
$		adc MTDUMP/co=MTDUMP,OBEY,MTI,ICLASC
$		fort'OPT1' MTDUMP
$		pvv	MTDUMP
$		if .not.deb then delete MTDUMP.FOR;*
$		delete ADC.IDE;*
$!
$nofor:	if .not.lnk then goto COEXIT
$	lpt1=""
$	if deb then lpt1="/deb"
$		link/map'LPT1'  MTDUMP,-
			    MTDUMP_CLD,-
			    MTDUMP.PROMSG_OBJ,-
			    LSL$LIBRARY:LSLSHR/OPT
$!
$COEXIT:
$	pur/nolog *.FOR,*.OBJ,MTDUMP.*
$	set noverify
$	exit
