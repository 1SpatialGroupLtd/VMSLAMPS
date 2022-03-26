$!
$! Command file to compile I2IMAP program
$!
$! Mod 1463 Allow compiling on AXP		ST 01-Feb-1995
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!
$	def cmn here:
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	axp   :=
$	debug :=
$	mbug  :=
$	cmp   :=
$	lst   :=
$	list  :=
$	cmt   :=
$	rno   :=
$	runoff:=
$	tidy  := "delete/noconfirm"
$	ver   := ";*"
$ 	lbug  :=
$	link_dir := "here:"
$	prog := "I2IMAP"
$!
$	wsb
$	inquire CMP "Compile                 "
$	if CMP
$	then
$	  inquire DBG "   with debug           "
$	  if DBG
$	  then
$	     debug = "/debug/noopt/list/check=all"
$	     mbug  = "/debug"
$	     cmt   = "/co"
$	     tidy  = "purge"
$	     ver   = ""
$	  endif
$!
$	  wsb
$	  inquire CLD      "Command Line Decoding         "
$	  inquire MES      "Message Definitions           "
$	  if MES then runoff = "/runoff/hl=2"
$	  wsb
$	  inquire MAIN  "Main program: I2IMAP,BLKDAT,REPORT,CLOSE_IFF         "
$	  inquire CMD   "Commands: GET_COMMAND,UPCASE,STRTOBUF                "
$	  inquire DBS   "Database: PLOTTR, IMAP_SYSMSG, STAPRO, TIDYWT, NONGRA"
$	  inquire PAR   "Params  : RD*, READ_*, ADD_DTR, IS_ANNOTATION        "
$	  inquire PROC  "Process : PROCESS,COORD,OFFSET,FC_IND,ATTR_IND,ANNO.."
$	  inquire SUM	"Summary : SUMMARY, INVALID, INV_OUT                  "
$!
$	  wsb
$!
$	endif
$! 
$	wsb
$!
$	wsb
$!
$!
$! Check the architecture
$!
$	if F$GETSYI("ARCH_NAME").eqs."Alpha"
$	then
$	   axp = "/tie/extend/separate/float=d_float"
$	   maxp =  "/migrate/notie/unalign"
$	   cmt = cmt + "/ll:80"
$	else
$	   axp = ""
$	   maxp = ""
$	endif
$!
$	if CMP
$	then
$	wsb
$	  set noverify
$!
$	  if CLD
$	  then
$	    adc CLD.tmp'cmt' = I2IMAP.CLD
$	    set ver
$	    set command/object = I2IMAP_CLD CLD.tmp
$	    set nover
$	    pvv I2IMAP_CLD
$	    purge I2IMAP_CLD.obj
$	    delete/noconf  adc.ide;*,CLD.tmp;*
$	  endif
$!
$	  if MES
$	  then
$	    set ver
$	    newmsg  I2IMAP/number=1609'runoff'
$	    @I2IMAP.temp_com
$	    set nover
$	    if RNO then purge I2IMAPMSG.rno
$	  endif
$!
$	  if MAIN
$	  then
$	    adc I2IMAP'cmt' = I2IMAP,BLKDAT,REPORT,CLOSE_IFF
$	    set ver
$	    fort 'debug''axp''list' I2IMAP
$	    set nover
$	    pvv I2IMAP
$	    purge I2IMAP.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' I2IMAP.for'ver'
$	  endif
$!
$	  if CMD
$	  then
$	    adc GET_COMMAND'cmt' = GET_COMMAND,UPCASE,STRTOBUF
$	    set ver
$	    fort 'debug''axp''list' GET_COMMAND
$	    set nover
$	    pvv GET_COMMAND
$	    purge GET_COMMAND.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' GET_COMMAND.for'ver'
$	  endif
$!
$	  if DBS
$	  then
$	    adc PLOTTR'cmt' = PLOTTR,IMAP_SYSMSG,STAPRO,TIDYWT,NONGRA
$	    set ver
$	    fort 'debug''axp''list' PLOTTR
$	    set nover
$	    pvv PLOTTR
$	    purge PLOTTR.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' PLOTTR.for'ver'
$	  endif
$!
$	  if PAR 
$	  then
$	    adc RDPAR'cmt' = RDPAR,RDFDT,RDADT,RDTES,RDTEL,RDTET
$	    adc RDPAR'cmt'/ap = READ_NAM,UP_NAM,READ_DTR,ADD_DTR
$	    adc RDPAR'cmt'/ap = IS_ANNOTATION
$	    set ver
$	    fort 'debug''axp''list' RDPAR
$	    set nover
$	    pvv RDPAR
$	    set ver
$	    macro'mbug''maxp''list' PARCMD
$	    macro'mbug''maxp''list' FLDCMD
$	    set nover
$	    append PARCMD.obj,FLDCMD.obj RDPAR.obj
$	    purge RDPAR.obj
$	    delete/noconf  adc.ide;*,PARCMD.obj;*,FLDCMD.obj;*
$	    'tidy' RDPAR.for'ver'
$	  endif
$!
$	  if PROC
$	  then
$	    adc PROCESS'cmt' = PROCESS,COORD,GET_OFFSET,FC_IND,ATTR_IND
$	    adc PROCESS'cmt'/ap = PROCESS_ANNOTATION
$	    set ver
$	    fort 'debug''axp''list' PROCESS
$	    set nover
$	    pvv PROCESS
$	    purge PROCESS.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' PROCESS.for'ver'
$	  endif
$!
$	  if SUM
$	  then
$	    adc SUMMARY'cmt' = SUMMARY,INVALID,INV_OUT
$	    set ver
$ 	    fort'debug''axp''list' SUMMARY
$	    set nover
$	    pvv SUMMARY
$	    purge SUMMARY.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' SUMMARY.for'ver'
$	  endif
$!
$	  set noverify
$	endif
$!
$	wsb
$	ws "***************************************************************"
$	ws "INFORMAP is installed on LSLV3A, 	LINK IT FROM THERE"
$	ws "Look in Sunils 1992 logbook, section I2IMAP to find out how"
$	ws "  to get Informap up and running, and other I2IMAP material"
$	ws "***************************************************************"
$	wsb
$!------------------------------------------------------------------------------
$!
$! tidy the link directory
$!
$	purge/by=dba			'link_dir'i2imap.*
$	wsb
$end:
$	set noverify
