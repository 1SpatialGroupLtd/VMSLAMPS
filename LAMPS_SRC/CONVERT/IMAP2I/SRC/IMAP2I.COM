$!
$! Command file to compile IMAP2I program
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!
$	define  cmn  'f$logical("HERE")
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	debug :=
$	mbug  :=
$	cmp   :=
$	lst   :=
$	list  :=
$	cmt   :=
$	rno   :=
$	runoff:=
$	tidy  := "delete"
$	ver   := ";*"
$	link_dir := 'f$logical("HERE")
$!
$	wsb
$askcmp:inquire CMP "Compile                 "
$	if .not. CMP then goto askcop
$	inquire DBG "   with debug           "
$	if .not. DBG then goto askall
$	   debug = "/debug/noopt/check=all"
$	   mbug  = "/debug"
$	   cmt   = "/co"
$	   tidy  = "purge"
$	   ver   = ""
$!
$	inquire LST "   and listings         "
$	if LST then list = "/list"
$!
$askall:wsb
$	inquire MAIN     "Main program                  "
$	inquire CMD      "Get commands                  "
$	inquire PAR      "Read parameters               "
$	inquire FAC      "Get facets                    "
$	inquire RET      "INFORMAP Retrieval            "
$	inquire IFF      "Output to IFF file            "
$!
$	wsb
$	inquire CLD      "Command Line Decoding         "
$	inquire MES      "Message Definitions           "
$!
$	if .not. MES then goto askcop
$	   inquire RNO   "Runoff file                   "
$	   if RNO then runoff = "/runoff/hl=2"
$! 
$askcop:wsb
$!
$	if .not. CMP then goto noCMP
$	wsb
$	set verify
$!
$	if .not. MES then goto noMES
$	newmsg  IMAP2I/number=1610'runoff'
$	@IMAP2I.temp_com
$	if RNO then purge IMAP2IMSG.rno
$!
$noMES :if .not. CLD then goto noCLD
$       adc CLD.tmp'cmt' = IMAP2I.CLD
$	set command/object = IMAP2I_CLD CLD.tmp
$	pvv IMAP2I_CLD
$	purge IMAP2I_CLD.obj
$	delete adc.ide;*,CLD.tmp;*
$!
$noCLD:	if .not. MAIN then goto noMAIN
$	adc IMAP2I'cmt' = IMAP2I,REPORT
$	fort'debug''list' IMAP2I
$	pvv IMAP2I
$	purge IMAP2I.obj
$	delete adc.ide;*
$	'tidy' IMAP2I.for'ver'
$!
$noMAIN:if .not. CMD then goto noCMD
$	adc GET_COMMAND'cmt' = GET_COMMAND,UPCASE,STRTOBUF
$	fort 'debug''list' GET_COMMAND
$	pvv GET_COMMAND
$	purge GET_COMMAND.obj
$	delete adc.ide;*
$	'tidy' GET_COMMAND.for'ver'
$!
$noCMD:	if .not. PAR then goto noPAR
$	adc RDPAR'cmt' = RDPAR,RDDDT,RDADT
$	adc RDPAR'cmt'/ap = READ_NAM,UP_NAM,READ_DTR,ADD_DTR
$	fort 'debug''list' RDPAR
$	pvv RDPAR
$	macro'mbug''list' PARCMD
$	macro'mbug''list' FLDCMD
$	append PARCMD.obj,FLDCMD.obj RDPAR.obj
$	purge RDPAR.obj
$	delete adc.ide;*,PARCMD.obj;*,FLDCMD.obj;*
$	'tidy' RDPAR.for'ver'
$!
$noPAR:	if .not. FAC then goto noFAC
$	adc GET_LIST'cmt' = GET_LIST,RDFDT,FDT_LINE,RECFAX,BASFAC
$	fort 'debug''list' GET_LIST
$	pvv GET_LIST
$	purge GET_LIST.obj
$	delete adc.ide;*
$	'tidy' GET_LIST.for'ver'
$!
$noFAC: if .not. RET then goto noRET
$	adc CONDAT'cmt'    = CONDAT,STARET,ENDRET,RETLIN,RETSYM,RETTXT,RETATT
$	adc CONDAT'cmt'/ap = CHKTXT,ATTR_IND,AC_IND,GETLIN,GETSYM,GETTEX,GETATT
$	adc CONDAT'cmt'/ap = NXTGRA,IMAP_SYSMSG
$	fort 'debug''list' CONDAT
$	pvv CONDAT
$	purge CONDAT.obj
$	delete adc.ide;*
$	'tidy' CONDAT.for'ver'
$!
$noRET: if .not. IFF then goto noIFF
$	adc WRITE_IFF'cmt'    = CLOSE_IFF,GET_LIMITS,INI_FEATURE,NEW_FEATURE
$	adc WRITE_IFF'cmt'/ap = WRITE_START,WRITE_END,WRITE_FEATURE
$	adc WRITE_IFF'cmt'/ap = START_FEATURE,FLUSH,COORD
$	fort 'debug''list' WRITE_IFF
$	pvv WRITE_IFF
$	purge WRITE_IFF.obj
$	delete adc.ide;*
$	'tidy' WRITE_IFF.for'ver'
$!
$noIFF:	set noverify
$noCMP:	
$	wsb
$end:
