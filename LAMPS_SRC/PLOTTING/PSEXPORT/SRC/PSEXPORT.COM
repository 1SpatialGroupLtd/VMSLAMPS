$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						CCB 12-Jan-1994
$!
$! Command file for building PSEXPORT
$!
$	inq/nop CLD "Compile CLD module? "
$	inq/nop MES "Generate message definitions? "
$	inq/nop COMP "Compile Fortran? "
$	inq/nop LNKIT "Link? "
$!
$	if MES
$	then
$	  NEWMSG psexport/number=1188/prefix=PSEXP__/param=fort/runoff
$	  @psexport.TEMP_COM
$	endif
$!
$	if CLD
$	then
$	  ADC psexport.TMP=psexport.CLD
$	  SET COMMAND/OBJECT=psexport_cld psexport.TMP
$	  PVV psexport_cld
$	  DELETE adc.ide;*
$	  DELETE psexport.TMP;*	
$	  PURGE/NOLOG psexport_cld.OBJ
$	endif
$!
$	if COMP
$	then
$	  FORT/nolist psexport.f
$	  PURGE/NOLOG psexport.OBJ
$	  FORT/nolist process_setup.f
$	  PURGE/NOLOG process_setup.OBJ
$	  FORT/nolist process_plot.f
$	  PURGE/NOLOG process_plot.OBJ
$	endif
$!
$	if LNKIT
$	then
$	  link/map psexport,process_setup,process_plot,-
	    psexport_cld,psexport.PROMSG_OBJ, -
	    LSL$LIBRARY:LSLSHR/OPT
$	endif
$!
