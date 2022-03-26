$	ver='f$verify(0)'
$	set noon
$!
$	assign 'f$logical("HERE")' CGEN
$	assign LSL$SOURCE_ROOT:[LITES2.SRC] SRC
$	assign LSL$SOURCE_ROOT:[LITES2.EXE] EXE
$!
$	inquire DBG "With Debug"
$	if .not.DBG then DBG=""
$	if      DBG then MLDBG="/DEBUG"
$	inquire COMPILE "Compile"
$	if .not.COMPILE then goto NOC
$	  if      DBG then DBG="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$!
$	  A1="F.COMGEN,COMGEN"
$	  A2="F.PREP,PREP,GETCML,NAMFIL,OPNFIL"
$	  A3="F.WRTHDR,WRTHDR"
$	  A4="F.WRTBDY,WRTBDY"
$	  A5="F.WRTMID,WRTMID"
$	  A6="F.WRTGTO,WRTGTO"
$	  A7="F.WRTTRL,WRTTRL"
$	  A8="F.WRTBLK,WRTBLK"
$	  A9="F.GET,GETSTR,GETCOM,GETCMT"
$	  A10="F.ARG,WRTCO1,WRTCO2,WRTCM1,WRTCM2"
$	  A11="F.CLOFIL,CLOFIL"
$!
$	  A12="F.GETID,GETID"
$!
$	  TIMES=12
$	  COUNT=0
$ NXTASK:
$	  COUNT=COUNT+1
$	  OUT=f$extract(2,F$LOCATE(",",A'COUNT')-2,A'COUNT')
$	  FILES=f$extract(F$LOCATE(",",A'COUNT')+1,100,A'COUNT')
$	  inquire YES "''OUT' (''FILES')"
$	  if .NOT.YES then A'COUNT'=""
$	  if COUNT.lt.TIMES then goto NXTASK
$ NOC:	inquire BUILD "Link"
$	if .not.BUILD then goto NOB
$ NOB:
$	ERROR=""
$	if .not.COMPILE then goto DOBLD
$	  COUNT=0
$ NXTC:
$	  COUNT=COUNT+1
$	    CMP=f$extract(0,1,A'COUNT')
$	    OUT=f$extract(2,f$locate(",",A'COUNT')-2,A'COUNT')
$	    FILES=f$extract(F$LOCATE(",",A'COUNT')+1,100,A'COUNT')
$	    if CMP.eqs."M" then goto MAC
$	    if CMP.nes."F" then goto SKIPC
$	      set verify
$	adc 'OUT'='FILES'
$	FORT/LIST'DBG' 'OUT'
$	      OK=$STATUS			!'f$verify(0)
$	      if .not.OK then ERROR=ERROR+" "+OUT
$	      set verify
$	if OK then pvv 'OUT'
$	if OK then DELETE 'OUT'.LIS;*
$	pip 'OUT'.OBJ/nm,.FOR/NM,.LIS/nm/pu
$	delete ADC.IDE;*
$	      goto skipc			!'f$verify(0)
$ MAC:
$	      set verify
$	macro'MLDBG'/OBJECT='OUT' 'FILES'
$	      OK=$STATUS			!'f$verify(0)
$	      if .not.OK then ERROR=ERROR+" "+OUT
$	      set verify
$	pip 'OUT'.OBJ/nm/pu
$ SKIPC:					!'f$verify(0)
$	  if count.lt.times then goto NXTC
$DOBLD: if .not.BUILD.or.(ERROR.nes."") then goto tidy	! 'f$verify(0)'
$	  set verify
$	LINK/MAP/CROSS'MLDBG' -
	COMGEN,-
	PREP,-
	WRTHDR,WRTBDY,WRTMID,WRTGTO,WRTTRL,WRTBLK,GET,ARG,-
	CLOFIL,GETID,-
	LSL$LIBRARY:LSLLIB/INCLUDE=SIGCHS,-
      	LSL$LIBRARY:CMDLIB/LIB,-
	LSL$LIBRARY:VIOLIB/LIB
$	PIP COMGEN.MAP/nm,.EXE/nm/pu
$	RENAME COMGEN.EXE EXE:COMGEN.EXE
$tidy:	! 'f$verify(0)'
$	if error.nes."" then write sys$output "Errors in ",error
$	if ver then set verify
