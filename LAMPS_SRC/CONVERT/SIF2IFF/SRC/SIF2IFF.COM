$!
$! Command file to compile SIF2IFF program
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!
$	define/nolog  cmn  'f$logical("HERE")
$	define/nolog  lsl$sif lsl$data_root:[lsl.sif]
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	debug :=
$	mbug  :=
$ 	lbug  :=
$	link_dir := "lsl$SOURCE_ROOT:[CONVERT.SIF2IFF.SRC]"
$	cmp   :=
$	lst   :=
$	list  :=
$	cmt   :=
$	lnk   :=
$	rno   :=
$	runoff:=
$	tidy  := "delete"
$	ver   := ";*"
$	link_dir := 'f$logical("HERE")
$!
$	MAIN    := 
$	CLD     :=
$	CMD     :=
$	INI     :=
$	RD1     :=
$	RD2     :=
$	RD3     :=
$	TAB     :=
$	PR1	:=
$       PR2     :=
$	IF1     :=
$	IF2     :=
$	CCG     :=
$	MES     :=
$	STUFF	:=
$!
$	wsb
$       inquire CMP "Compile                 "
$	if CMP
$	then
$	  inquire DBG "   with debug           "
$	  if DBG
$	  then
$	     debug = "/debug/noopt/check=all"
$	     mbug  = "/debug"
$	     cmt   = "/co"
$	     tidy  = "purge"
$	     ver   = ""
$	     list = "/list"
$	  endif
$!
$	  inquire MAIN     "sif2iff                                        "
$	  inquire CLD      "Command Line Decoding                          "
$	  inquire CMD      "cmdlin                                         "
$	  inquire INI      "ini_sif2iff,ini_fdf,ini_feature                "
$	  inquire RD1      "rdpar,rdfdf,rdsif,rddid,rdlst                  "
$	  inquire RD2      "rdsym,rdtxt,rdcir,rdarc,rdlac                  "
$	  inquire RD3      "rdpln,rdpg,rdtpc,rdacz,rdmtx,rdptn,rdtx3       "
$	  inquire TAB      "xxxCMD                                         "
$	  inquire PR1	   "condat,findfc,read_nam,read_sep,cont_line      "
$         inquire PR2      "report,readline,get_xyz,skip_contlin,findpsize "
$	  inquire IF1      "close_iff,write_start,write_end                "
$	  inquire IF2      "start_feature,flush,coord,write_feature        "
$	  inquire CCG      "read_lut,write_lut,id_ccsm                     "
$	  inquire MES      "Message Definitions                            "
$	  inquire STUFF	   "TXTC stuff                                     "
$	  if MES
$	  then
$	    inquire RNO    "Runoff file                                    "
$	    if RNO then runoff = "/runoff/hl=2"
$	  endif
$	endif
$!
$	wsb
$!
$	inquire LNK	 "Link                                      "
$	if LNK
$	then
$	  inquire DBG	 "   with debug                             "
$	  if DBG then lbug  = "/debug"
$	endif
$!
$!
$	if MES
$	then
$	  set verify
$	  newmsg  SIF2IFF/number=1610'runoff'
$	  set noverify
$	  @SIF2IFF.temp_com
$	  if RNO then purge SIF2IFFMSG.rno
$	endif
$!
$	if CLD
$	then
$	  set verify
$	  set command/object=SIF2IFF_CLD SIF2IFF_CLD
$	  set noverify
$	  purge SIF2IFF_CLD.obj
$	endif
$!
$	if MAIN
$	then
$	  set verify
$	  fort'debug''list' SIF2IFF.F
$	  set noverify
$	  purge SIF2IFF.obj
$	endif
$!
$	if CMD
$	then
$	  set verify
$	  fort 'debug''list' CMDLIN.F
$	  set noverify
$	  purge CMDLIN.obj
$	endif
$!
$	if INI
$	then
$	  set verify
$	  fort 'debug''list' INI_SIF2IFF.F+INI_FDF.F+INI_FEATURE.F
$	  set noverify
$	  purge INI_SIF2IFF.obj
$	endif
$!
$	if RD1
$	then
$	  set verify
$	  fort 'debug''list' RDPAR.F
$	  fort 'debug''list' RDFDF.F
$	  fort 'debug''list' RDSIF.F
$	  fort 'debug''list' RDDID.F
$	  set noverify
$	  fort 'debug''list' RDLST.F
$	  append RDLST.obj,RDFDF.obj,RDSIF.obj,RDDID.obj RDPAR.OBJ
$	  purge RDPAR.obj
$	  delete RDFDF.obj;*,RDSIF.obj;*,RDDID.obj;*,RDLST.obj;*
$	endif
$!
$	if RD2
$	then
$	  set verify
$	  fort 'debug''list' RDSYM.F
$	  fort 'debug''list' RDTXT.F
$ 	  fort 'debug''list' RDCIR.F
$	  fort 'debug''list' RDARC.F
$	  fort 'debug''list' RDLAC.F
$	  set noverify
$	  append RDTXT.obj,RDCIR.obj,RDARC.obj,RDLAC.obj RDSYM.OBJ
$	  purge RDSYM.obj
$	  delete RDTXT.obj;*,RDCIR.obj;*,RDARC.obj;*,RDLAC.obj;*
$	endif
$!
$	if RD3
$	then
$	  set verify
$	  fort 'debug''list' RDPTN.F
$	  fort 'debug''list' RDTX3.F
$	  fort 'debug''list' RDPLN.F
$	  fort 'debug''list' RDPG.F
$	  fort 'debug''list' RDTPC.F
$	  fort 'debug''list' RDACZ.F
$	  fort 'debug''list' RDMTX.F
$	  set noverify
$	  append RDTPC.obj,RDACZ.obj,RDMTX.obj,RDTX3.obj,RDPLN.obj,RDPG.obj-
	  RDPTN.obj
$	  purge RDPTN.obj
$	  delete RDTX3.obj;*,RDPLN.obj;*,RDPG.obj;*
$	  delete RDTPC.obj;*,RDACZ.obj;*,RDMTX.obj;*
$	endif
$!
$	if TAB
$	then
$	  set verify
$	  macro'mbug''list' PARCMD
$	  macro'mbug''list' SIFCMD
$	  macro'mbug''list' LACCMD
$	  macro'mbug''list' LSTCMD
$	  macro'mbug''list' TXTCMD
$	  macro'mbug''list' DIDCMD
$	  macro'mbug''list' SYMCMD
$	  macro'mbug''list' CIRCMD
$  	  macro'mbug''list' ARCCMD
$	  macro'mbug''list' PTNCMD
$	  macro'mbug''list' TX3CMD
$	  macro'mbug''list' PGCMD
$	  macro'mbug''list' PLNCMD
$	  macro'mbug''list' TPCCMD
$	  macro'mbug''list' ACZCMD
$	  macro'mbug''list' MTXCMD
$	  set noverify
$	  append LACCMD.OBJ,LSTCMD.OBJ,TXTCMD.OBJ,DIDCMD.OBJ PARCMD.obj
$	  append SYMCMD.OBJ,CIRCMD.OBJ,ARCCMD.OBJ,PTNCMD PARCMD.obj
$	  append TX3CMD.OBJ,PGCMD.OBJ,PLNCMD.OBJ,TPCCMD.OBJ PARCMD.obj
$	  append ACZCMD.OBJ,MTXCMD.OBJ,SIFCMD.OBJ PARCMD.obj
$	  purge PARCMD.obj
$	  delete SIFCMD.obj;*,LACCMD.OBJ;*,LSTCMD.OBJ;*
$	  delete TXTCMD.OBJ;*,DIDCMD.OBJ;*,SYMCMD.OBJ;*
$	  delete CIRCMD.OBJ;*,ARCCMD.OBJ;*,PTNCMD.OBJ;*
$	  delete TX3CMD.OBJ;*,PGCMD.OBJ;*,PLNCMD.OBJ;*,TPCCMD.OBJ;*
$	  delete ACZCMD.OBJ;*,MTXCMD.OBJ;*
$	endif
$!
$	if PR1 
$	then
$	  set verify
$	  fort 'debug''list' CONDAT.F+FINDFC.F+READ_NAM.F+READ_SEP.F-
	  +CONT_LINE.F
$	  set noverify
$	  purge CONDAT.obj
$	endif
$!
$	if PR2
$	then
$	  set verify
$	  fort 'debug''list' REPORT.F+READLINE.F+GET_XYZ.F+SKIP_CONTLIN-
	  +FINDPSIZE
$	  set noverify
$	  purge REPORT.obj
$	endif
$!
$	if IF1
$	then
$	  set verify
$	  fort 'debug''list' CLOSE_IFF.F+WRITE_START.F+WRITE_END.F
$	  set noverify
$	  purge CLOSE_IFF.obj
$	endif
$!
$	if IF2
$	then
$	  set verify
$	  fort 'debug''list' START_FEATURE.F+FLUSH.F+COORD.F+WRITE_FEATURE.F
$	  set noverify
$	  purge START_FEATURE.obj
$	endif
$!
$	if CCG
$	then
$	  set verify
$	  fort 'debug''list' READ_LUT.F+WRITE_LUT.F+ID_CCSM.F
$	  set noverify
$	  purge READ_LUT.obj
$	endif
$!
$	if STUFF
$	then
$	  set verify
$	  fort 'debug''list' MY_TXTC_STUFF.F
$	  set noverify
$	  purge MY_TXTC_STUFF.obj
$	endif
$!
$	if LNK
$	then
$	  set verify
$	  link'lbug'/map='link_dir'/exe='link_dir' -
			SIF2IFF,SIF2IFF_CLD, -
			CMDLIN, INI_SIF2IFF, RDPAR,-
			RDSYM, RDPTN, PARCMD,-
			CONDAT, REPORT, CLOSE_IFF,-
			START_FEATURE,-
			READ_LUT, MY_TXTC_STUFF,-
			SIF2IFF.PROMSG_OBJ,-
			LSL$LIBRARY:IFFSHR/OPT,-
			LSL$LIBRARY:LSLSHR/OPT
$	  set noverify
$	endif
$end:
$	set noverify
$	wsb
