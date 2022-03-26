
$	state:='f$verify(0)'
$	set noon
$!-------------------------------------------------------------------
$!
$! Command-file to build the PRIM2RASTER program.
$!
$! Author	J.H.Rees
$! Written	22-May-1989
$!
$!-------------------------------------------------------------------
$!
$!
$ ASSIGN	LSL$SOURCE_ROOT:[PLOTTING.PRIM2RASTER]	CMN
$ ASSIGN	LSL$SOURCE_ROOT:[LSLMAINT.GKSPRIMLIB]	PRIM_CMN
$ GENERATE_MESS		:= ""
$ PRIM2RASTER		:= ""
$ CLD			:= ""
$ READ_IFF		:= ""
$ SETUP_BUFFERS		:= ""
$ SWATHE_HIT		:= ""
$ UPDATE_SECTOR		:= ""
$ EXPLOIT_SECTORS	:= ""
$ LINE			:= ""
$ FORMAT		:= ""
$ MOUNT_TAPE		:= ""
$ RASTER_LINE		:= ""
$ FILL_CIRCLE		:= ""
$ FILL_SIDEQ		:= ""
$ GFAIPL		:= ""
$ SKPC			:= ""
$ HELL_MDP		:= ""
$ TDP			:= ""
$ C_LIST_ON 		 = ""
$ C_DEB_ON 		 = ""
$ CC_DEB_ON 		 = ""
$ KEEP_COMS		 = ""
$!
$	WRITE SYS$OUTPUT "[1mUse control-C if no further sources are to be compiled[0m "
$	inquire/nop DO_COMP	"Compile ? "
$	if .not. DO_COMP then goto ASK_LINK
$	inquire/nop C_ALL	"ALL ? "	
$	if .not. C_ALL then goto select
$	GENERATE_MESS		:= "TRUE"
$	PRIM2RASTER		:= "TRUE"
$	CLD			:= "TRUE"
$	READ_IFF		:= "TRUE"
$	SETUP_BUFFERS		:= "TRUE"
$	SWATHE_HIT		:= "TRUE"
$	UPDATE_SECTOR		:= "TRUE"
$	EXPLOIT_SECTORS 	:= "TRUE"
$	LINE			:= "TRUE"
$	FORMAT			:= "TRUE"
$	MOUNT_TAPE		:= "TRUE"
$	RASTER_LINE		:= "TRUE"
$	FILL_CIRCLE		:= "TRUE"
$	FILL_SIDEQ		:= "TRUE"
$	GFAIPL			:= "TRUE"
$	SKPC			:= "TRUE"
$	HELL_MDP		:= "TRUE"
$	TDP			:= "TRUE"
$	goto ASK_DEB
$SELECT:
$ on control_y then goto ASK_DEB
$	inquire/nop GENERATE_MESS	"Generate the message file ? "
$	inquire/nop PRIM2RASTER		"Compile PRIM2RASTER ? "
$	inquire/nop CLD			"Compile CLD ? "
$	inquire/nop READ_IFF		"Compile READ_IFF ? "
$	inquire/nop SETUP_BUFFERS	"Compile SETUP_BUFFERS ? "
$	inquire/nop SWATHE_HIT		"Compile SWATHE_HIT ? "
$	inquire/nop UPDATE_SECTOR	"Compile UPDATE_SECTOR ? "
$	inquire/nop EXPLOIT_SECTORS	"Compile EXPLOIT_SECTORS ? "
$	inquire/nop LINE		"Compile LINE ? "
$	inquire/nop FORMAT		"Compile FORMAT ? "
$	inquire/nop MOUNT_TAPE		"Compile MOUNT_TAPE ? "
$	inquire/nop RASTER_LINE		"Compile RASTER_LINE ? "
$	inquire/nop FILL_CIRCLE		"Compile FILL_CIRCLE ? "
$	inquire/nop FILL_SIDEQ		"Compile FILL_SIDEQ ? "
$	inquire/nop GFAIPL		"Compile GFAIPL ? "
$	inquire/nop SKPC		"Compile SKPC ? "
$	inquire/nop HELL_MDP		"Compile HELL_MDP ? "
$	inquire/nop TDP			"Compile TDP ? "
$ASK_DEB:
$ on control_y then goto END
$	inquire/nop C_LIST	"Listings ? "
$	if C_LIST then C_LIST_ON = "/LIST"
$	inquire/nop C_DEB	"With DEBUG ? "
$	if C_DEB then C_DEB_ON = "/DEBUG/NOOPT"
$	if C_DEB then CC_DEB_ON = "/DEBUG"
$	if C_DEB then KEEP_COMS = "/CO"
$ASK_LINK:
$	inquire/nop DO_LINK	"Link ? "
$	if .not. DO_LINK then goto START_COMPILE
$	inquire/nop L_DEB	"With DEBUG ? "
$	L_DEB_ON = ""
$	if L_DEB then L_DEB_ON = "/DEBUG"
$!
$! Compile:
$!
$! ...Generate the message file...
$!
$START_COMPILE:
$	if .not. GENERATE_MESS then goto GENERATE_MESS_END
$	set verify
$	newmsg PRIM2RASTER/NUMBER=1187/RUNOFF/PREFIX=P2R__
$	state:='f$verify(0)'
$	WRITE SYS$OUTPUT "Generating the message file..."
$	@PRIM2RASTER.TEMP_COM
$GENERATE_MESS_END:
$!
$! ....CLD...
$!
$	if .not. CLD then goto CLD_END
$	set verify
$	adc PRIM2RASTER.TMP=PRIM2RASTER_CLD.CLD'keep_coms'
$	set command/object=PRIM2RASTER_CLD PRIM2RASTER.TMP
$	state:='f$verify(0)'
$	ok=$status
$	if ok then pvv PRIM2RASTER_CLD
$	purge PRIM2RASTER_CLD.OBJ, PRIM2RASTER.TMP
$CLD_END:
$!
$	call compile PRIM2RASTER PRIM2RASTER
$	call compile READ_IFF READ_IFF
$	call compile SETUP_BUFFERS SETUP_BUFFERS
$	call compile SWATHE_HIT SWATHE_HIT
$	call compile UPDATE_SECTOR UPDATE_SECTOR
$	call compile EXPLOIT_SECTORS EXPLOIT_SECTORS
$	call compile LINE LINE
$	call compile FORMAT FORMAT_INIT,FORMAT_CLOSE,OUTPUT_SWATHE
$	call compile MOUNT_TAPE MOUNT_TAPE
$	call compile FILL_CIRCLE FILL_CIRCLE
$	call compile FILL_SIDEQ FILL_SIDEQ,CFSIDE
$	call compile GFAIPL GFAIPL
$	call compile HELL_MDP HELL_MDP_INIT,HELL_MDP_CLOSE,HELL_MDP_SWATHE_OUT,-
HELL_MDP_RUN_GEN,HELL_MDP_RUN_OUT,HELL_MDP_BUFFER,HELL_MDP_FILE_OPEN,-
HELL_MDP_TO_TAPE
$	call compile TDP TDP_INIT,TDP_CLOSE,TDP_SWATHE_OUT,TDP_TO_FILE
$!
$	if RASTER_LINE
$	then
$	set verify
$	cc'c_list_on''cc_deb_on' RASTER_LINE
$	state:='f$verify(0)'
$	ok=$status
$	purge RASTER_LINE.OBJ
$	if C_LIST then purge RASTER_LINE.LIS
$	endif
$!
$	if SKPC
$	then
$	set verify
$	macro/nolist SKPC
$	state:='f$verify(0)'
$	purge SKPC.OBJ
$	endif
$!	
$! Link:
$!
$	if .not. DO_LINK then goto end
$!
$	set verify
$	link/map/full'l_deb_on' -
					PRIM2RASTER, -
		   			PRIM2RASTER_CLD, -
					PRIM2RASTER.PROMSG_OBJ, -
					READ_IFF.OBJ, -
					SETUP_BUFFERS, -
					SWATHE_HIT, -
					UPDATE_SECTOR, -
					EXPLOIT_SECTORS, -
					LINE, -
					FORMAT, -
					MOUNT_TAPE, -
					RASTER_LINE, -
					FILL_CIRCLE, -
					FILL_SIDEQ, -
					GFAIPL, -
					SKPC, -
					HELL_MDP, -
					TDP, -
					LSL$LIBRARY:GKSLDLIB2/LIB,-
sys$input:/opt,-
lsl$library:lslshr/opt, -
lsl$library:iffshr/opt
!
! next line for dummy magtape library
!!!cluster=DUMMY,,,SYS$DUMMY,LSL$LIBRARY:DMTLIB/INCLUDE=(MTONIT,MTOWRB,MTOEOF)
sys$library:vaxcrtl/share
$	purge PRIM2RASTER.EXE,PRIM2RASTER.MAP
$	state:='f$verify(0)'
$!
$END:
$	DEASSIGN	CMN
$	DEASSIGN	PRIM_CMN
$	WRITE SYS$OUTPUT "Finished..."
$	WRITE SYS$OUTPUT ""
$	EXIT
$!
$COMPILE: SUBROUTINE
$	if .not.'p1' then exit
$	n = 0
$	ap = ""
$nextsrc:
$	srcfile = f$element(n,",",p2)
$	if srcfile.eqs."," then goto forit
$	set verify
$	adc 'p1''ap' = 'srcfile''keep_coms'
$	state='f$verify(0)
$	n = n+1
$	ap = "/ap"
$	goto nextsrc
$!
$forit:
$	set verify
$	fort'c_list_on''c_deb_on' 'p1'
$	state='f$verify(0)
$	ok=$status
$	if ok then pvv 'p1'
$	delete ADC.IDE;*
$	purge 'p1'.FOR, 'p1'.OBJ
$	if C_LIST then purge 'p1'.LIS
$!
$ENDSUBROUTINE
