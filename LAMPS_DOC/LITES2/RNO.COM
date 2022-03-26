$	v = 'f$verify(0)
$	set noon
$!
$! command file to facilitate the maintenance of indices and contents
$! pages with RUNOFF
$! - this version tailored for the LITES2 documentation...
$!
$	ws  = "write sys$output"
$	wsb = "write sys$output """""
$	inqnop = "inquire/nopunc"
$!
$	whole = 1
$!
$	wsb
$	ws "LITES2 documentation command file, version 2.1 (see README.1ST)"
$	wsb
$!
$! now, which document do they want to work with?
$! if they have given us a directory, then assume it is a correct one
$!
$	if p1 .nes. "" then goto gotd
$	   ws "Available documents are USER, REF, PROG"
$!
$askd:	   wsb
$	   inqnop p1 "Which document do you want? "
$	   if p1 .eqs. "" then exit		! give up
$!
$! check that we understand the answer
$!
$	   if p1.eqs."USER" .or. p1.eqs."REF" .or.p1.eqs."PROG" then goto gotd
$!
$	      wsb
$	      ws "Please answer with USER, REF, or PROG"
$	      goto askd
$!
$! we have a document name - choose the relevant sub-directory
$!
$gotd:	wsb
$	SD LSL$DOC_ROOT:[LITES2.'p1']
$	wsb
$!
$! by default, we will work on 'P1'.RNO, which is assumed to produce the
$! entire document in this directory. However, if P2 is given, then we
$! produce 'P2'.RNO
$!
$	if p2 .nes. "" then whole = 0
$	if p2 .nes. "" then goto dopart
$	   inqnop whole "assemble whole document? "
$	   if .not.whole then inqnop p2 "which part? "
$	   if      whole then p2 = p1
$!
$! we will assume that it is a .RNO file
$!
$dopart:file   = p2
$	allnam = file+".RNO;0"
$!
$! now we must check that the file required exists
$!
$	t$rno = f$search(allnam)
$	if t$rno.eqs."" then ws allnam," does not exist"
$	if t$rno.eqs."" then goto exit
$!
$! and prepare to run it off
$!
$doall:	output   = "PRINT"		! assume for printing
$	separate = "NO"			! assume underline NOT /sep
$!
$	wsb
$	inqnop pretty "To be output on the LQP? "
$	if pretty then output = "LQP"
$!
$	if pretty then goto dorno
$	   inqnop sep "Separate underlines? "
$	   if sep then separate = "YES"
$!
$dorno:	wsb
$	ws "Preparing ",t$rno
$	wsb
$!
$	@LSL$DOCHDR:RNO  'file'  'separate'  ""  "/LOG"
$!
$! and do they want to print/lqp the final result?
$!
$	wsb
$	inqnop prt "''output' the results? "
$	if .not.prt then goto exit
$!
$	inqnop num "how many copies [1]? "
$	if num.eqs."" then ws "- printing one copy"
$	if num.eqs."" then num = "1"
$!
$	'output'/del/copies='num' 'file'.MEM
$!
$exit:	purge/log 'file'.*		! clear things out
$	if v then set verify
