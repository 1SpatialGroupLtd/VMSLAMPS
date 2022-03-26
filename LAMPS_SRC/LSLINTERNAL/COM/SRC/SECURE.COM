$	VERIFICATION=F$VERIFY(0)
$       ON CONTROL_Y THEN GOTO PANIC
$	WS="WRITE SYS$OUTPUT"
$	REC_DIR_FLAG="N"
$!
$! Add missing parenthesis after previous edit		WJJ	 4-May-1993
$! Correct computation of second tape name		WJJ	16-Apr-1993
$! Disable unfinished SPLIT stuff!!			WJJ	 6-APR-1993
$! LSS and LSR tape labels introduced			TJH  02-Apr-1993
$! Add SPLIT command (SPLIT <n> leaves only n entries
$! on the queue, the rest being deferred		RF   18-Jul-1990
$!
$! Add QSS (QS with SIZE) command			RF   16-Jul-1990
$!
$! Make provision for DEFERRED_ARCHDIR,
$! ensure that all SEARCH keys are quoted (separately)	RF   13-Jul-1990
$!
$! Correct bug in Restore inserted by RF - extra $ !	PGH  07-Nov-1989
$!
$! Make recovery operations specify the UIC of the person requesting 
$! recovery (since otherwise recoverd files will all acquire random
$! owners, depending on where they go, etc.)		RF   5-Jul-1989
$!
$! Tidy up target device/directory stuff for recover, extend messages
$! to recovery operations, merge all messages to one user, introduce
$! some new bugs....					RF   7-Feb-1989
$!
$! Send messages to the user who asked for an archive to
$! be done (one message/request, pro tem!)		RF  11-Jan-1989
$!
$! Now correctly write ALL queue information into master
$! archive record - after LAVc conversion lost username
$! and date of archive					TJH 21-Jan-1987
$!
$! Now handles LAVc device names			TJH 07-Jan-1987
$!
$! Cause of fatal error: savsets > 17 characters cause
$! BACKUP to behave inconsistently - backs up the file
$! OK and then can't find it on the tape! Saveset names
$! now trimmed to 17 characters in MAGNETIC: option	TJH 23-Dec-1987
$!
$! Fatal errors during backup now cause termination of
$! the procedure with blatant error message.		TJH 21-Dec-1987
$!
$! P2 can be file to be secured so command line ok	PGH 22-Oct-1986
$!
$! Version 4.0 file specifications catered for.		TJH 12-Mar-1986
$!
$! Tape is dismounted after operator aborts a mount
$! and WS substituted for WRITE SYS$OUTPUT.		TJH 26-Sep-1984
$!
$! Now possible to supply option command on command 
$! line and DUA3: added to poss. target devices		TJH 14-Sep-1984
$!
$! Command file to archive and restore disk files to mag tape
$! and keep permanent and working directories of them
$!
$!......................................................................
$!
$! Determine name of user
$       USRNAME:='F$GETJPI("","USERNAME")
$!
$! Option keyword supplied on command line?
$	STRAIGHT_IN=0
$	IF P1.NES."" THEN STRAIGHT_IN=1
$	IF STRAIGHT_IN THEN GOTO STRAIGHT_IN
$       TYPE SYS$INPUT

The SECURE command file accepts entries for two temporary queues. A "secure"
queue containing the names of files for archive and a "recover" queue
containing the names of files for recovery from archive magnetic tapes. All
valid DCL wild card characters are allowed. When the two temporary queues
contain sufficient files to make it worth while assigning an operator to load
the necessary tapes the queues will be executed. The tapes are written from the
command file using BACKUP with the /VERIFY switch set.  Two tape copies are
made and hardcopy listings of the BACKUP command lines are examined for errors
before logging out of the archive session. A directory file containing all
filenames held on secure archive tapes is updated at the end of the queue
execution process. This may be examined using the secure command file. NEVER
delete a disk file until its name appears in the secure directory file. 

For help type HELP (or ?) in response to a "SECURE option?" prompt.

$ QUEST:
$	IF STRAIGHT_IN THEN GOTO PANIC	! single command on line
$	MARKER="0"
$	REC_DIR_FLAG="N"
$       INQ/NOP P1 "SECURE option? "
$ STRAIGHT_IN:
$	IF P1 .EQS."?" THEN GOTO TELL
$       IF P1 .EQS."" THEN GOTO PANIC
$	CLEN=F$LENGTH(P1)
$	IF P1.EQS.F$EXTRACT(0,CLEN,"HELP") THEN GOTO TELL
$	IF P1.EQS.F$EXTRACT(0,CLEN,"SECURE") THEN GOTO ARCQ
$       IF P1.EQS.F$EXTRACT(0,CLEN,"RECOVER") THEN GOTO RESQ
$       IF P1.EQS.F$EXTRACT(0,CLEN,"QUEUE") THEN GOTO QDIR
$       IF P1.EQS.F$EXTRACT(0,CLEN,"DIRECTORY") THEN GOTO DIRQ
$	IF P1.EQS.F$EXTRACT(0,CLEN,"OPERATE") THEN GOTO MAGNETIC
$!!!	if p1.eqs.f$extract(0,clen,"SPLIT") then goto split_queue
$       IF P1.EQS."QS" THEN GOTO QDIR
$	if p1.eqs."QSS" then goto qdir
$	IF P1.EQS."QR" THEN GOTO RQDIR
$	if p1.eqs."SD" then goto arcq
$	WS "%SECURE-W-UNKNCMD, unknown command"
$	WS "\''P1'\"
$	GOTO QUEST
$!
$!......................................................................
$ARCQ:	! Archive
$!......................................................................
$QFILE:
$	if p1.eqs."SD"
$	then
$	  to_delete="DEL"
$	else
$	  to_delete=""
$	endif
$	IF P2.EQS."" THEN INQUIRE P2 "Give full file specification "
$	FLMN=P2
$	P2=""
$       MARKER=1
$       IF FLMN.EQS."" THEN GOTO QUEST
$       TOTFILE:='F$SEARCH(FLMN)
$	IF .NOT.$STATUS THEN GOTO ERRS
$       IF TOTFILE.EQS."" THEN GOTO NOEXIST
$	GOTO KILL
$!
$ERRS:
$	WS "ERROR:  ''F$MESSAGE($STATUS)'"
$	IF MARKER THEN GOTO QFILE
$       GOTO QUEST
$!
$NOEXIST:
$       WS "%SECURE-W-FILNOTFND, file not found"
$	WS "\''FLMN'\"
$       GOTO QFILE
$!
$KILL:
$       MARKER=0
$!
$! Put current time into 'TIME'
$       TIME=F$TIME()
$!
$! Create full file specification using F$PARSE to allow for wild card
$! characters
$       DEV=F$PARSE(FLMN,,,"DEVICE","NO_CONCEAL")
$       FDIRECTORY=F$PARSE(FLMN,,,"DIRECTORY","NO_CONCEAL")-"]["
$       FILENAME=F$PARSE(FLMN,,,"NAME")
$       EXTNE=F$PARSE(FLMN,,,"TYPE")
$       VERSION=F$PARSE(FLMN,,,"VERSION")
$	COMPFIL:='FILENAME''EXTNE''VERSION'
$	COMPLETE:='DEV''FDIRECTORY''COMPFIL'
$!
$	FIELDS[0,38]:='DEV'
$	FIELDS[38,13]:='USRNAME'
$	if to_delete.nes."" then fields[42,3]:='to_delete'
$	FIELDS[58,22]:='TIME'
$!
$! Open temp archive directory file
$	if f$search("lsl$secure:deferred_archdir.dat").nes.""
$	then
$	  deferred=1
$         open/append adir lsl$secure:deferred_archdir.dat
$	else
$	  deferred=0
$         open/append adir lsl$secure:archdir.dat
$	endif
$!
$! Version 4.0 file specs mean that we must now allow more space for the
$! the complete file/date-time/user information. We now have 3 records:
$!
$! 1) Device, username and date of entry
$       WRITE ADIR FIELDS
$!
$! 2) Source directory 
$       WRITE ADIR FDIRECTORY
$!
$! 3) Complete file spec. of 'filename.extension;version'
$       WRITE ADIR COMPFIL
$!
$       CLOSE ADIR
$!
$! Send a reassuring message to user
$	WS "%SECURE-I-QUEJOIN, ''COMPLETE' has joined the archive queue"
$	if deferred then -
	ws "%SECURE-I-QUEDEF, archiving will be deferred, since queue is already overfull"
$       GOTO QUEST
$!
$! SPLIT - split the archive queue
$split_queue: if f$search("lsl$secure:deferred_archdir.dat").nes.""
$	then
$	  write sys$output "%SECURE-E-QALRSPL, queue already split"
$	  goto quest
$	endif
$!
$! acquire the number to split at
$	if p2.eqs."" then inquire/nopunc p2 "Number of entries to retain : "
$	if p2.eqs."" then goto quest
$!
$! open the old queue for reading, to ensure nothing gets added, pro tem.
$	open/read/write oldqueue lsl$secure:archdir.dat
$	edt_file="lsl$secure:split_"+f$getjpi("","pid")+".edt"
$	open/write edt_file 'edt_file'
$	end_queue=3*p2
$	start_deferred=end_queue+1
$	write edt_file "write lsl$secure:deferred_archdir.dat ",-
			start_deferred, " thru end"
$	write edt_file "write lsl$secure:archdir.dat 1 thru ''end_queue'"
$	write edt_file "quit"
$	close edt_file
$	define/user sys$output nla0:
$	edit/edt/command='edt_file' oldqueue:
$	delete 'edt_file';*
$	close oldqueue
$	purge/log lsl$secure:archdir.dat
$!
$! now we fall through to QSS -
$	p1="QSS"
$!
$!......................................................................
$QDIR:	! Give directory listing of secure queue
$!......................................................................
$!
$	if p1.eqs."QSS"
$	then aq_p1="size"
$	else aq_p1="nosize"
$	endif
$	@LSL$COM:ARCHIVE_QUEUE 'aq_p1'
$       IF P1 .EQS."QUEUE" THEN GOTO RQDIR
$	GOTO QUEST
$!
$!......................................................................
$RESQ:	! Add the specified files to the queue for recovery
$!......................................................................
$   	TYPE SYS$INPUT 

Give details of the file stored on tape. All the requested information
is available from the secure file directory.  You will need:

                     1  The name of the savefile on tape.  eg: TST.SAV

               	     2  The name of the tape

$AGAIN:
$       INQ/NOP REC_DIR_FLAG -
	"Do you want a listing of the secure file directory? [Y/N] "
$	IF REC_DIR_FLAG .NES."Y" -
		.AND.REC_DIR_FLAG .NES."N" -
		.AND.REC_DIR_FLAG .NES."" THEN GOTO AGAIN
$       IF REC_DIR_FLAG.EQS."Y" THEN GOTO DIRQ
$       GOTO REASK
$!
$TAPEQUEST: 
$	TYPE SYS$INPUT

If a series of files was secured using a wild card specification (e.g.
DISASTER.*) then several files may be held in a single saveset name
(DISASTER.SAV in this example). If you wish to recover only a part of this
saveset e.g. DISASTER.FOR  you may do so by specifying the directory, name and
extension of the original file i.e. [BUREAU]DISASTER.FOR when  prompted. 

$YETAGAIN:
$	WS "Do you want another listing of the secure file directory to"
$       INQ/NOP REC_DIR_FLAG -
		 "find the original directory and filename? [Y/N] "
$       IF REC_DIR_FLAG .NES. "Y" -
		.AND. REC_DIR_FLAG .NES."N" -
		.AND. REC_DIR_FLAG .NES."" THEN GOTO YETAGAIN
$       IF REC_DIR_FLAG .EQS. "Y" THEN GOTO DIRQ
$!
$REASK:
$	OLDFILE=" "
$	INQUIRE/NOP ANS "Do you wish to recover only part of a saveset? [Y/N] "
$	IF ANS .NES."Y".AND.ANS.NES."N".AND.ANS.NES. "" -
 	THEN GOTO REASK
$	IF ANS.NES."Y" THEN GOTO PERSIST
$!
$NOANS:
$	TYPE SYS$INPUT

Give the exact specification of the original filename and extension
eg. GUBBINS.DAT;4

$	INQUIRE/NOPUNCT OLDFILE "Filename? "
$	IF OLDFILE .EQS. "" THEN GOTO QUEST
$       OLDFILE="("+OLDFILE+")"
$!
$PERSIST:
$       REC_DIR_FLAG="N"
$       INQUIRE/NOPUNCT SAVFILE "Name of saveset (eg TEST.SAV) on tape? "
$	IF SAVFILE .EQS."" THEN GOTO QUEST
$!
$ASK:
$       INQUIRE/NOPUN LSLTAPE -
	  "Name of tape (eg LSLS09 or LSS120) containing the secured file? "
$	IF LSLTAPE .EQS."" THEN GOTO QUEST
$! From 2-Apr-1993 the integer value range of tapes prefixed with LSLS and LSLR
$! was extended by changing the prefixes to LSS and LSR respectively. This 
$! must be accounted for... 
$	LSLTAPE=F$EDIT(LSLTAPE,"UPCASE,TRIM")
$	IF F$LENGTH(LSLTAPE).EQ.6 
$	THEN
$	   DIGITS=F$EXTRACT(4,2,LSLTAPE)
$	   IF (F$EXTRACT(0,4,LSLTAPE).EQS."LSLS" -
		.OR.F$EXTRACT(0,4,LSLTAPE).EQS."LSLR") -
		   .AND. F$TYPE(DIGITS).EQS."INTEGER"
$	   THEN 
$	      TAPE_OK="T"
$	   ELSE
$	      DIGITS=F$EXTRACT(3,3,LSLTAPE)
$	      IF (F$EXTRACT(0,3,LSLTAPE).EQS."LSS" -
		.OR.F$EXTRACT(0,3,LSLTAPE).EQS."LSR") -
		   .AND. F$TYPE(DIGITS).EQS."INTEGER"
$	      THEN 
$	        TAPE_OK="T"
$	      ELSE
$	         TAPE_OK="F"
$	      ENDIF
$	   ENDIF
$	ELSE
$	   TAPE_OK="F"
$	ENDIF
$	IF TAPE_OK THEN GOTO DEVASK
$	TYPE SYS$INPUT

All SECURE tape names begin with the prefix LSLS, LSLR, LSS or LSR and have a
total of 6 characters. LSLS and LSLR or LSS and LSR tapes are paired, thus
LSLR97 is a backup for LSLS97, similarly  LSR120 is a backup for LSS120. 
Try again! 

$	   GOTO ASK
$!
$DEVASK:
$	INQUIRE/NOP TARGETDEV "Name of target device (eg DRA2:)? "
$!
$REPROMPT:
$	INQ/NOP TARGETDIR "Name of target directory (eg [BUREAU.TST])? "
$!
$! Check for presence of brackets and add if absent
$	IF TARGETDIR.EQS."" THEN GOTO parse_rec_dev_dir
$       TLEN=F$LENGTH(TARGETDIR)
$!
$! Check for angle brackets...
$	RANGLE=F$LOCATE(">",TARGETDIR)
$	ANGLE=F$LOCATE("<",TARGETDIR)
$	IF ANGLE.ge.TLEN THEN GOTO SQUARE
$	targetdir[angle,angle]="["
$	IF RANGLE.lt.TLEN THEN targetdir[rangle,rangle]="]"
$!
$! Left angle bracket is okay but right bracket is missing
$       if rangle.ge.tlen then targetdir=targetdir+"]"
$!
$	GOTO parse_rec_dev_dir
$!
$SQUARE:
$!
$!Check that no right angle bracket is present ......if so remove.
$       IF RANGLE.lt.TLEN THEN TARGETDIR=TARGETDIR-">"
$!
$!Check for presence of square brackets......
$       LBR=F$LOCATE("[",TARGETDIR)
$	RBR=F$LOCATE("]",TARGETDIR)
$	IF LBR.ge.TLEN.AND.RBR.ge.TLEN THEN GOTO ADDBOTH
$	IF LBR.ge.TLEN THEN GOTO ADDL
$       IF RBR.ge.TLEN THEN GOTO ADDR
$	GOTO parse_rec_dev_dir
$!
$ADDBOTH: TARGETDIR="["+TARGETDIR+"]"
$       GOTO parse_rec_dev_dir
$!
$ADDL:	TARGETDIR="["+TARGETDIR
$	GOTO parse_rec_dev_dir
$!
$ADDR:	TARGETDIR=TARGETDIR+"]"
$!
$parse_rec_dev_dir:! ss targetdev
$!	ss targetdir
$!	set verify
$	tardevdir=targetdev+targetdir+"xxx.xxx;30"
$	targetdev=f$parse(tardevdir,,,"DEVICE","NO_CONCEAL")
$!	ss targetdev
$!
$! General check for mounted target disk
$	if f$locate("$",targetdev).lt.f$length(targetdev)
$	then
$	  add_dollars=0
$	else
$	  add_dollars=1
$	endif
$check_target_disk: 
$!	ss targetdev
$!	ss add_dollars
$	IF F$GETDVI(TARGETDEV,"EXISTS")
$	then 
$	  if F$GETDVI(TARGETDEV,"MNT") THEN GOTO form_target
$	else
$	  if add_dollars.gt.0
$	  then
$	    if add_dollars.eq.1
$	    then
$	      targetdev="lslm3a$"+targetdev
$	      add_dollars=2
$	    else
$	      targetdev="lslm3b"+targetdev-"lslm3a"
$	      add_dollars=0
$	    endif
$	    goto check_target_disk
$	  endif
$	endif
$moan_targetdev: WS "%SECURE-W-UNKDEV, unknown device \''TARGETDEV'\"
$	GOTO DEVASK
$!
$! now set up a `puckah' target device and directory
$form_target: tardevdir=targetdev+ -
		f$parse(tardevdir,,,"DIRECTORY","NO_CONCEAL")-"]["
$!	set noverify
$!	ss tardevdir
$!
$! Put current time into 'TIME'
$       TIME=F$TIME()
$!
$! get the requester's numeric UIC, for the benefit of the recovery operation
$	symbolic_uic==f$user()
$	comma_pos==f$locate(",",symbolic_uic)
$	if comma_pos.ge.f$length(symbolic_uic)
$	then
$	  uic_value==f$identifier(f$extract(1,f$length(symbolic_uic)-2,-
						      symbolic_uic    ),-
				 "name_to_number")
$	else
$	  uic_value==f$identifier(f$extract(comma_pos+1,-
			         f$length(symbolic_uic)-comma_pos-2,-
					  symbolic_uic    ),-
				 "name_to_number")
$	endif
$!
$!set up output field to write to queue directory
$	fields[0,131]:=" "
$!
$! The first line of a recovery queue entry has several fields in it:
$! pos 0, size 7:	secure archive tape name
$! pos 8, size 20:	saveset name (actual max length: 17)
$! pos 30, size 20:	(numeric) UIC of requester
$! pos 94, size 13:	requester's username
$! pos 108, size 22:	time of request
$       FIELDS[0,7]:='LSLTAPE'
$       FIELDS[8,20]:='SAVFILE'
$	fields[30,20]:='f$fao("!%U",uic_value)'
$       FIELDS[94,13]:='USRNAME'
$       FIELDS[108,22]:='TIME'
$       OPEN/APPEND RADIR LSL$SECURE:RESTDIR.DAT
$       WRITE RADIR FIELDS
$	WRITE RADIR TARDEVDIR
$       WRITE RADIR OLDFILE
$       CLOSE RADIR
$	WS "%SECURE-I-QUEJOIN, file ''SAVFILE' has joined the recover queue"
$	GOTO QUEST
$!
$!......................................................................
$RQDIR:		! Give directory listing of recover queue
$!......................................................................
$!
$	@LSL$COM:RECOVER_QUEUE.COM
$	GOTO  QUEST
$!
$!......................................................................
$DIRQ:	! Sequence for listing out directory of permanently
$	! archived or restored filenames
$!......................................................................
$!
$! Give them the option of sending the results to the lineprinter
$	SEARCH_OUT="SYS$OUTPUT"
$	INQ/NOP LP_OUT "Output to LP: ?  [Y/N] "
$	IF .NOT. LP_OUT THEN GOTO NOLP
$	SEARCH_OUT = "TMPFILE"
$	CRE LSL$SECURE:TMPFILE.DAT
$	OPEN/APP TMPFILE LSL$SECURE:TMPFILE.DAT
$	ON CONTROL_Y THEN GOTO DELT
$	WO="WRITE TMPFILE"
$	WO ""
$	WO "Listing of Secure Archive directory:
$	WO ""
$ NOLP:	LST=""
$	INQUIRE/NOPUNCT SPFSTR -
		"Search for a specific string in the directory? [Y/N] "
$	IF SPFSTR THEN GOTO SP_STR
$	INQUIRE/NOPUNCT LST "List the whole SECURE directory? [Y/N] "
$	IF .NOT. LST .AND. .NOT. SPFSTR .AND. .NOT. LP_OUT .AND. REC_DIR_FLAG THEN GOTO YETAGAIN
$	IF .NOT. LST .AND. .NOT. SPFSTR .AND. .NOT. LP_OUT THEN GOTO QUEST
$	IF .NOT. LST .AND. .NOT. SPFSTR THEN GOTO DELT
$	IF .NOT. LST THEN GOTO SP_STR
$	@LSL$COM:MASTER_ARCHIVE.COM 
$	IF LP_OUT THEN GOTO T_END
$	IF REC_DIR_FLAG THEN GOTO YETAGAIN
$	GOTO QUEST
$!
$! No option was chosen except LP: output - delete the infant LP: file
$ DELT:	OK=F$SEARCH("LSL$SECURE:TMPFILE.DAT;")
$	IF OK THEN DELETE/NOCONFIRM LSL$SECURE:TMPFILE.DAT;*
$	IF REC_DIR_FLAG THEN GOTO YETAGAIN
$	GOTO QUEST
$!
$! Specific string to be searched for
$ SP_STR:
$	WS -
"Specify the string that you want to look for in the Secure directory"
$	WS ""
$       INQ/NOP ITEM ""
$	IF ITEM .EQS."" .AND. REC_DIR_FLAG THEN GOTO YETAGAIN
$	IF ITEM .EQS. "" THEN GOTO QUEST
$!
$! now process the item to explicitly quote each key
$	final_item=""
$find_commas: slash_pos=f$locate("/",item)
$	comma_pos=f$locate(",",item)
$	if comma_pos.lt.slash_pos
$	then
$	  final_item=final_item+""""+f$extract(0,comma_pos,item)+""","
$	  item=f$extract(comma_pos+1,f$length(item),item)
$	  goto find_commas
$	endif
$	if slash_pos.ge.f$length(item)
$	then
$	  item=final_item+""""+item+""""
$	else
$	  item=final_item+""""+f$extract(0,slash_pos,item)+""""+-
				f$extract(slash_pos,f$length(item),item)
$	endif
$!	ss item
$!
$! now we can go ahead and do the search
$	IF .NOT. LP_OUT THEN GOTO THE_SEARCH
$	WO "(Key selected for search = ''ITEM' )"
$	WO ""
$!
$ THE_SEARCH:
$	ON CONTROL_Y THEN GOTO CTRLY
$	SEARCH/OUTPUT=LSL$SECURE:SEARCH.TMP/NOHEADING/NONUMBERS -
				LSL$SECURE:MARCHIVE.DAT 'ITEM'
$!
$! Read the temp search file and format the output
$	OPEN/READ SF LSL$SECURE:SEARCH.TMP
$	ON CONTROL_Y THEN GOTO SF_EOF
$ AR2:	READ/END=SF_EOF SF LINE
$!
$       LABEL=F$EXTRACT(F$LOCATE("L",LINE),7,LINE) ! SECURE tape label
$       USRNAM=F$EXTRACT(8,13,LINE)		! username
$       QDATE=F$EXTRACT(22,11,LINE)		! date of archive
$       OPERATOR=F$EXTRACT(34,13,LINE)		! operator name
$	TMPLINE=F$EXTRACT(48,85,LINE)		! saveset name ...
$	SAVENAME=F$EXTRACT(0,F$LOCATE(" ",TMPLINE),TMPLINE)
$!
$! Extract parts of original file spec
$	LINE=F$EXTRACT(133,F$LENGTH(LINE),LINE) ! get file-spec field only
$	FDEVICE="UNKNOWN"			! allow for "" default
$	COLPOS=F$LOCATE(":",LINE)
$	IF COLPOS.NE.F$LENGTH(LINE) THEN -
		FDEVICE=F$EXTRACT(0,COLPOS+1,LINE)
$       FDIRECTORY=F$PARSE(LINE,,,"DIRECTORY")
$       FILENAME=F$PARSE(LINE,,,"NAME")
$       EXTNE=F$PARSE(LINE,,,"TYPE")
$       VERSION=F$PARSE(LINE,,,"VERSION")
$	COMPFIL:='FILENAME''EXTNE''VERSION'
$!
$! And write it all out?
$	IF LP_OUT THEN GOTO LP_OUTPUT
$	WS " "
$	WS "User:               ''USRNAM'     Date of archive:    ''QDATE'"
$	FIELD[0,38]:= "Original device:    ''FDEVICE'"
$	FIELD[38,40]:="Tape label:         ''LABEL'"
$	WS FIELD
$	WS "Original directory: ''FDIRECTORY'"
$	WS "File:               ''COMPFIL'"
$	WS "Saveset name:       ''SAVENAME'"
$	WS "Archive operator:   ''OPERATOR'"
$	GOTO AR2
$
$!
$! Line printer output
$ LP_OUTPUT:
$	WO " "
$	WO "User:               ''USRNAM'     Date of archive:    ''QDATE'"
$	FIELD[0,38]:= "Original device:    ''FDEVICE'"
$	FIELD[38,40]:="Tape label:         ''LABEL'"
$	WO FIELD
$	WO "Original directory: ''FDIRECTORY'"
$	WO "File:               ''COMPFIL'"
$	WO "Saveset name:       ''SAVENAME'"
$	WO "Archive operator:   ''OPERATOR'"
$	GOTO AR2
$!
$! Hit end of file
$ SF_EOF:
$	CLOSE SF
$ CTRLY:OK=F$SEARCH("LSL$SECURE:SEARCH.TMP;")
$	IF OK .NES. "" THEN DELETE/NOCON LSL$SECURE:SEARCH.TMP;*
$	WS " "
$	IF .NOT. LP_OUT .AND. REC_DIR_FLAG THEN GOTO YETAGAIN
$	IF .NOT. LP_OUT THEN GOTO QUEST
$ T_END:
$	CLOSE TMPFILE
$	PRINT/DEL LSL$SECURE:TMPFILE.DAT
$	IF REC_DIR_FLAG THEN GOTO YETAGAIN
$       GOTO QUEST
$!
$ PRETELL:
$	CLOSE INPUT
$	IF FLAG.EQ.0 THEN WS "%SECURE-I-STRNOTFND, string not found \''ITEM'\"
$	IF REC_DIR_FLAG THEN GOTO YETAGAIN
$	GOTO QUEST
$!
$!......................................................................
$ TELL:	! Help 
$!......................................................................
$	TYPE SYS$INPUT


	THE COMMANDS YOU CAN USE ARE:

	SECURE    Records the specified file in the Secure Queue
	          <min abbreviation S >

        RECOVER   Records the specified file in the Recover Queue
	          <min abbreviation R >

        QS	  Gives listing of current Secure Queue

        QR        Gives listing of current Recover Queue

        QUEUE     Gives listing of both current Secure and
                  Recover Queues

        DIRECTORY Gives directory listing of all secured files
                  Ordering of the listing may be specified.
		  <min abbreviation D >

        OPERATE   Gives prompts for mounting of mag tapes and carries 
      	    	  out the Secure and Recover processes on the files 
  		  held in the respective queues.

$!
$GOTO QUEST
$!
$!......................................................................
$MAGNETIC:	! Perform tape operations
$!......................................................................
$	SET NOON
$!
$! Get name of the operator who's performing this tape operation 
$       OPERATOR:='F$GETJPI("","USERNAME")'
$!
$!give directory listing of archive queue
$	@LSL$COM:ARCHIVE_QUEUE.COM size symbols
$!! DISABLE SPLIT stuff - incomplete?!?!
$	split_suggested = 0
$!!
$	if split_suggested.gt.0
$	then
$	  ws "The queue is seriously full - suggest splitting it at ", -
							split_suggested
$	  inquire/nopunc do_split "* Do you want to do this [Y/N] ? "
$	  if do_split
$	  then
$	    secure split 'split_suggested'
$	  endif
$	else
$	  if split_suggested.lt.0
$	  then
$	    ws "The first entry on the queue is oversized -"
$	    inquire/nopunc do_split -
		 "* do you want to split it off and try it [Y/N] ? "
$	    if do_split
$	    then secure split 2
$	    else
$	      ws "*** DO NOT ATTEMPT TO SECURE ***"
$	      ws "*** Notify computer department of the problem ***"
$	    endif
$	  endif
$	endif
$!
$!give directory listing of recover queue
$	@LSL$COM:RECOVER_QUEUE.COM
$!
$!Allocate the tape drive 
$       ALLOCATE MUB1:
$	IF $STATUS THEN GOTO GOTIT
$       WS "''F$MESSAGE($STATUS)'"
$       WS "%SECURE-I-FINDALLOC, find who has allocated the tape drive"
$       GOTO QUEST
$!
$GOTIT:
$     	TIME=F$TIME()
$!
$TOP:
$	INQUIRE REC_ONLY "Do you wish only to recover files? [Y/N] "
$       IF REC_ONLY.NES."Y" -
		   .AND.REC_ONLY.NES."" -
		   .AND.REC_ONLY.NES."N" THEN GOTO TOP
$       IF REC_ONLY.EQS."Y" THEN GOTO ONLY
$!
$!......................................................................
$! First tape copy...
$!......................................................................
$!
$! First create dummy file to act as identifier (volume label) for
$! save set. This is necessary as /for option selected for backup
$	TYPE SYS$INPUT

All SECURE tape names created after 2-Apr-1993 begin with the prefix LSS or LSR
and have 6 characters. They MUST be used in their numbered pairs e.g. LSS120
and LSR120 are examples of a matching pair. Load the LSS tape for the FIRST
secure copy. Load the LSR tape when prompted for the SECOND secure
copy. 

Should the tape that you are using fill up and BACKUP prompt for a continuation 
tape adopt the following procedure:

 1) Use control_Y to interrupt the archive procedure
 2) Start the SECURE archive again but this time start a NEW pair of tapes
    and in answer to the question, "Does the tape you have just loaded already
    contain archived files that you wish to preserve? [Y/N]" answer "N".

This will mean that some files have been archives twice on the LSSxx tapes
but don't worry, magnetic tape is cheap compared with lost files.

$!
$! As there are operators who cannot count which is the highest tape label
$! in the LSL$SECURE tape rack give them a little help from a lookup file.
$	ON CONTROL_Y THEN GOTO CONTRL_Y_PEST
$ 	OPEN/READ LA LSL$SECURE:LABELS.DAT;
$ LOO:	READ/END=LAST_LINE LA LINE
$	PREV_LINE=LINE
$	GOTO LOO
$ LAST_LINE:
$	CLOSE LA
$	LABEL=F$EXTRACT(0,6,PREV_LINE)
$!
$DUMMYLAB:
$       INQUIRE NEWLAB -
	"LSStape number to be mounted? (for default ''LABEL' press <RETURN>) "
$	IF NEWLAB.EQS."" THEN GOTO CREATLAB
$	NEWLAB=F$EDIT(NEWLAB,"UPCASE,TRIM")
$	IF F$LENGTH(NEWLAB).EQ.6 
$	THEN
$	   DIGITS=F$EXTRACT(3,3,NEWLAB)
$	   IF (F$EXTRACT(0,3,NEWLAB).EQS."LSS" -
	      .AND. F$TYPE(DIGITS).EQS."INTEGER")
$	   THEN 
$	      TAPE_OK="T"
$	   ELSE
$	      TAPE_OK="F"
$	   ENDIF
$	ELSE
$	   TAPE_OK="F"
$	ENDIF
$	IF TAPE_OK THEN GOTO CREATE_NEW_LAB
$       WS "%SECURE-W-INVTAPNAM, invalid SECURE tape name"
$	WS " \''NEWLAB'\"
$	GOTO DUMMYLAB
$!
$ CREATE_NEW_LAB:
$	LABEL=NEWLAB
$!
$ CREATLAB:
$	CREATE LSL$SECURE:'LABEL'
$!
$! Open the file containing the archive queue infomation
$	ON CONTROL_Y THEN GOTO CLOSE_FILES
$	OPEN/READ INPUT LSL$SECURE:ARCHDIR.DAT
$	GOTO INSTRUCT1
$!
$ LOAD_IT_AGAIN:
$! We have failed to mount the tape properly (no write ring?)
$	DISM MUB1:	! try dismounting it
$!
$! Load the tape to hold the archived files
$ INSTRUCT1:
$       WS "Load ''LABEL' for the first archive copy "
$	WS -
	"(the tape will be mounted for you by the secure command file)"
$       INQUIRE/NOP GO "Press <RETURN> when ready"
$	MOUNT MUB1:/FOR/DENS=1600 
$	INQ/NOP LOADED "Did the tape mount OK? [Y/N] "
$	IF .NOT.LOADED THEN GOTO LOAD_IT_AGAIN
$	TYPE SYS$INPUT

Does the tape you have just loaded already contain archived files
$PROMPT:
$	MTINIT = 0
$       INQUIRE/NOPUNCT NOYES "that you wish to preserve? [Y/N] "
$       IF NOYES.NES."N".AND.NOYES.NES."Y".AND.NOYES.NES."" THEN GOTO PROMPT
$!
$! Catch any severe errors and issue a brash warning message to give up and
$! seek help next morning!
$	SET ON
$	ON SEVERE_ERROR THEN GOTO FATAL_FLAW
$	IF NOYES.EQS."Y" THEN GOTO LOOP
$       BACKUP/REWIND/LOG LSL$SECURE:/IGNORE=(LABEL,INTERLOCK) MUB1:[LSL.SECURE]'LABEL'       
$	MTINIT = 1
$!
$LOOP:
$	READ/END=ENDIT INPUT LINE1
$	READ/END=ENDIT INPUT LINE2
$	READ/END=ENDIT INPUT LINE3
$	TOTFILE=F$EXTRACT(0,F$LOCATE(":",LINE1)+1,LINE1)
$	TOTFILE=TOTFILE+LINE2
$	TOTFILE=TOTFILE+F$EXTRACT(0,F$LOCATE(" ",LINE3),LINE3)
$	FULLNAME=F$SEARCH(TOTFILE)
$	FILETYPE=F$PARSE(FULLNAME,,,"TYPE")
$       IF FULLNAME.EQS."" THEN GOTO MISSING
$	FILENAME=F$PARSE(FULLNAME,,,"NAME")
$	SAVNAME=FILENAME+FILETYPE
$	IF F$LENGTH(SAVNAME).GT.17 THEN SAVNAME=F$EXTRACT(0,17,SAVNAME)
$	set magtape/skip=records:-1 mub1:
$	BACKUP/NOREWIND/LOG/IGNORE=(LABEL,INTERLOCK)/VERIFY 'TOTFILE' MUB1:'SAVNAME'
$	WS "%SECURE-I-SAVENAME, magnetic tape saveset name = ''SAVNAME'"
$!
$! Reset F$SEARCH from wild card expansion
$       SAVNAME=F$SEARCH(" ")
$	GOTO LOOP
$!
$MISSING:
$	WS -
	"%SECURE-I-NOSEL, nothing selected from \''TOTFILE'\"
$!
$! Find USERNAME from string (needed for mail file name)
$	USERNAME=F$EXTRACT(38,13,LINE1)
$	trimmed_username=f$edit(username,"TRIM")
$!
$! now prepare to tell the user about what's happened
$	mf_exists=f$search("lsl$secure:''trimmed_username'_temp_mail_file.dat")
$	if mf_exists.nes."" then goto mf_append_1
$	open/write mail_file lsl$secure:'trimmed_username'_temp_mail_file.dat
$	goto mf_open_1
$!
$mf_append_1: open/append mail_file -
			lsl$secure:'trimmed_username'_temp_mail_file.dat
$	write mail_file "===="
$mf_open_1: mf_exists=f$search(" ") ! canonical "reset f$search"
$	write mail_file "Secure archive of ", totfile
$	write mail_file "  not performed by operator ", operator
$	write mail_file "   on ''f$extract(0,11,f$time())' at ", -
			"''f$extract(12,5,f$time())' (nothing selected)"
$	close mail_file
$!
$	GOTO LOOP
$!
$ENDIT:
$        CLOSE INPUT
$        DISMOUNT MUB1:
$	 SET NOON
$!......................................................................
$!Second tape copy......
$!......................................................................
$!
$!First construct the matching volume label
$!  New regime LSSnnn/LSRnnn from April 1993	
$	RNUM=F$EXTRACT(3,3,LABEL)
$       RLABEL="LSR"+RNUM
$	CREATE LSL$SECURE:'RLABEL'
$!
$	GOTO INSTRUCT2
$!
$RELOAD_IT:
$!
$! We have failed to mount the tape properly (no write ring?)
$	DISM MUB1:	! try dismounting it
$!
$! Load the tape to hold the archived files
$!
$INSTRUCT2: WS -
"First archive copy completed,now load ''RLABEL' for the second archive copy"
$	WS -
"(the tape will be mounted for you by the secure command file)"
$	INQUIRE/NOPUNCT READY "Press <RETURN> when ready"
$       MOUNT MUB1:/FOR/DENS=1600 
$	INQ/NOP LOADED "Did the tape mount OK?  [Y/N] "
$	IF .NOT.LOADED THEN GOTO RELOAD_IT
$!
$! Catch any severe errors and issue a brash warning message to give up and
$! seek help next morning!
$	SET ON
$	ON SEVERE_ERROR THEN GOTO FATAL_FLAW
$!
$	OPEN/READ INPUT LSL$SECURE:ARCHDIR.DAT
$!
$! Write dummy filename to act as volume label if new tape being used.
$       IF MTINIT THEN BACKup/LOG/IGNORE=(LABEL,INTERLOCK)/REWIND -
        LSL$SECURE:'RLABEL' MUB1:[LSL.SECURE]'RLABEL'
$!
$ALOOP:
$	READ/END=LAST INPUT LINE1
$	READ/END=LAST INPUT LINE2
$	READ/END=LAST INPUT LINE3
$	TOTFILE=F$EXTRACT(0,F$LOCATE(":",LINE1)+1,LINE1)
$	TOTFILE=TOTFILE+LINE2
$	TOTFILE=TOTFILE+F$EXTRACT(0,F$LOCATE(" ",LINE3),LINE3)
$	FULLNAME=F$SEARCH(TOTFILE)
$	FILETYPE=F$PARSE(FULLNAME,,,"TYPE")
$       IF FULLNAME.EQS."" THEN GOTO NOTHING
$	FILENAME=F$PARSE(FULLNAME,,,"NAME")
$	SAVNAME=FILENAME+FILETYPE
$	IF F$LENGTH(SAVNAME).GT.17 THEN SAVNAME=F$EXTRACT(0,17,SAVNAME)
$	set magtape/skip=records:-1 mub1:
$	BACKUP/NOREWIND/LOG/IGNORE=(LABEL,INTERLOCK)/VERIFY 'TOTFILE' MUB1:'SAVNAME'
$	WS "%SECURE-I-SAVENAME, magnetic tape saveset name = ''SAVNAME'"
$!
$! Reset F$SEARCH from wild card expansion
$       SAVNAME=F$SEARCH(" ")
$!
$	GOTO ALOOP
$!
$NOTHING:
$	WS "%SECURE-I-NOSEL, nothing selected from \''TOTFILE'\"
$!
$	GOTO ALOOP
$!
$LAST:
$       DISMOUNT MUB1:
$	CLOSE INPUT
$	SET NOON
$!
$! Put names of transfered files into master directory
$! together with mount information
$	WS "%SECURE-I-WRITDIR, writing to the secure archive directory"
$	OPEN/APP MARCHIVE LSL$SECURE:MARCHIVE.DAT
$	OPEN/READ INPUT LSL$SECURE:ARCHDIR.DAT
$!
$BLOOP:
$	READ/END=THEND INPUT LINE1
$	READ/END=THEND INPUT LINE2
$	READ/END=THEND INPUT LINE3
$	TOTFILE=F$EXTRACT(0,F$LOCATE(":",LINE1)+1,LINE1)
$	TOTFILE=TOTFILE+LINE2
$	TOTFILE=TOTFILE+F$EXTRACT(0,F$LOCATE(" ",LINE3),LINE3)
$	FULLNAME=TOTFILE
$!
$! Search for * and % wild card characters
$	STAR=0
$       PCENT=0
$	MARK=0
$	STAR=F$LOCATE("*",TOTFILE)
$	PCENT=F$LOCATE("%",TOTFILE)
$       IF STAR.EQ.F$LENGTH(TOTFILE) -
			.AND.PCENT.EQ.F$LENGTH(TOTFILE) THEN GOTO NOSTAR
$!
$STARLOOP:
$	FULLNAME=F$SEARCH(TOTFILE)
$       IF FULLNAME .EQS. "" THEN GOTO BLOOP_message
$       NAME=F$PARSE(FULLNAME,,,"NAME")
$!
$! Create labels for 'field'
$       FDEVICE=F$PARSE(FULLNAME,,,"DEVICE")
$       FDIRECTORY=F$PARSE(FULLNAME,,,"DIRECTORY")
$       PARTFILE=F$PARSE(FULLNAME,,,"NAME")
$       KIND=F$PARSE(FULLNAME,,,"TYPE")
$	VERSION=F$PARSE(FULLNAME,,,"VERSION")
$       ORIGFILE=PARTFILE+KIND+VERSION
$	IF MARK THEN GOTO FIELDFORM
$       MARK=1
$	SAVNAME=PARTFILE+KIND
$	IF F$LENGTH(SAVNAME).GT.17 THEN SAVNAME=F$EXTRACT(0,17,SAVNAME)
$	GOTO FIELDFORM
$!
$NOSTAR:
$!
$! Extract filename from parsed queue string to use as basis for 
$! savename
$       FILENAME=F$PARSE(TOTFILE,,,"NAME")
$	EXTENT=F$PARSE(TOTFILE,,,"TYPE")
$       SAVNAME=FILENAME+EXTENT
$	IF F$LENGTH(SAVNAME).GT.17 THEN SAVNAME=F$EXTRACT(0,17,SAVNAME)
$!
$! Create labels for 'field'
$       FDEVICE=F$PARSE(TOTFILE,,,"DEVICE")
$       FDIRECTORY=F$PARSE(TOTFILE,,,"DIRECTORY")
$       PARTFILE=F$PARSE(TOTFILE,,,"NAME")
$       KIND=F$PARSE(TOTFILE,,,"TYPE")
$	VERSION=F$PARSE(TOTFILE,,,"VERSION")
$       ORIGFILE=PARTFILE+KIND+VERSION
$!
$FIELDFORM:
$!
$! Find USERNAME from string
$	USERNAME=F$EXTRACT(38,13,LINE1)
$	trimmed_username=f$edit(username,"TRIM")
$!
$! Extract date from qtime string
$       QDATE=F$EXTRACT(58,12,LINE1)
$!
$! Make up general archive information 
$       FIELD[0,7]:='LABEL'			! SECURE tape label
$       FIELD[8,13]:='USERNAME'			! username
$	FIELD[22,11]:='QDATE'			! date of queue request
$       FIELD[34,13]:='OPERATOR'		! operator name
$       FIELD[48,85]:='SAVNAME'			! saveset name
$!
$! And original file information 
$	WRITE MARCHIVE FIELD,FDEVICE,FDIRECTORY,ORIGFILE
$       IF MARK THEN GOTO STARLOOP
$!
$! Finally, prepare a message to person who asked for the archiving to happen
$BLOOP_message: 
$	mf_exists=f$search("lsl$secure:''trimmed_username'_temp_mail_file.dat")
$	if mf_exists.nes."" then goto mf_append_2
$	open/write mail_file lsl$secure:'trimmed_username'_temp_mail_file.dat
$	goto mf_open_2
$!
$mf_append_2: open/append mail_file -
			lsl$secure:'trimmed_username'_temp_mail_file.dat
$	write mail_file "===="
$mf_open_2: mf_exists=f$search(" ") ! canonical "reset f$search"
$	write mail_file "Secure archive of ", totfile
$	write mail_file "  performed by operator ", operator
$	write mail_file "   on ''f$extract(0,11,f$time())' at ", -
			"''f$extract(12,5,f$time())'"
$	close mail_file
$!
$       GOTO BLOOP
$!
$! end of archiving: close things up, and do the tape labels game
$THEND:	CLOSE INPUT
$	CLOSE MARCHIVE
$!
$! Write the tape label used into the tape label lookup file 
$! LSL$SECURE:LABELS.DAT
$write_label_file: OPEN/APPEND LA LSL$SECURE:LABELS.DAT
$	WRITE LA LABEL
$	CLOSE LA
$	if f$search("lsl$secure:deferred_archdir.dat").nes.""
$	then
$	  rename/noconfirm lsl$secure:deferred_archdir.dat -
			   lsl$secure:archdir.dat
$	  purge/noconfirm  lsl$secure:archdir.dat
$	else
$	  DELETE/NOCONFIRM LSL$SECURE:ARCHDIR.DAT;*
$         CREATE LSL$SECURE:ARCHDIR.DAT
$	endif
$	DELETE/NOCONFIRM LSL$SECURE:'LABEL';*
$	DELETE/NOCONFIRM LSL$SECURE:'RLABEL';*
$!
$ONLY:
$!
$	WS "%SECURE-I-RECSTART, recover procedure started"
$	OPEN/READ INPUT LSL$SECURE:RESTDIR.DAT
$!
$! Get name of the operator who performed the tape operation 
$       OPERATOR:='F$GETJPI("","USERNAME")
$!
$ROUND:
$	SPECIF=2
$	READ/END=FINITO INPUT LINE1
$	READ/END=FINITO INPUT LINE2
$	READ/END=FINITO INPUT LINE3
$! Extract the LSL tape label
$	LSLTAPE=F$EXTRACT(0,F$LOCATE(" ",LINE1),LINE1)
$!
$! Attempt to load
$	WS "Load tape ''LSLTAPE',and press RETURN when ready"
$	WS "If the tape is already loaded then just press RETURN"
$	INQUIRE/NOPUNCT RET " "      
$	ON WARNING THEN GOTO BLUNDER
$!
$! ... and mount the tape
$	MOUNT/FOR MUB1:
$!
$! Make up the elements of a BACKUP command line
$	PARTLINE=F$EXT(0,F$LOCATE(" ",LINE3),LINE3)
$       OLDLEN=F$LENGTH(PARTLINE)
$       LOCDOT=F$LOCATE(".",PARTLINE)
$	IF LOCDOT.EQ.OLDLEN THEN SPECIF=0
$	PARTOF=F$EXTRACT(0,OLDLEN,PARTLINE)
$	TMPLIN=F$EXTRACT(8,20,LINE1)
$       SAVNAME=F$EXTRACT(0,F$LOCATE(" ",TMPLIN),TMPLIN)
$	TARGET=F$EXTRACT(0,F$LOCATE(":",LINE2)+1,LINE2)+ -
	       F$EXTRACT(F$LOCATE("[",LINE2),F$LOCATE("]",LINE2)+1,LINE2)
$	target_uic=f$extract(30,20,line1)
$	target_uic=f$extract(0,f$locate(" ",target_uic),target_uic)
$	if target_uic.nes."" then target_uic="/by_owner="+target_uic
$	recoveries=0
$	IF SPECIF.GT.1 THEN GOTO SOME
$!
$! As there may be more than one save-set with the same name, loop
$! around the backup command until all the savesets with that name
$! are recovered. After the last occurrence of the saveset name is found
$! and copied the search will continue until EOT is contacted. The 
$! resulting warning message causes control to pass out of the search 
$! loop to BLUNDER:
$!
$TRYITAGAIN:
$	BACKUP/NOREWIND/LOG/IGNORE=(LABEL,INTERLOCK)/VERIFY MUB1:'SAVNAME' -
			'TARGET''target_uic'
$       WS "%SECURE-I-SAVCOPY, ''SAVNAME' now copied to ''TARGET'"
$	recoveries=recoveries+1
$!
$       GOTO TRYITAGAIN
$!
$SOME:
$	BACKUP/NOREWIND/LOG/IGNORE=(LABEL,INTERLOCK)/VERIFY/SELECT='PARTOF' -
		MUB1:'SAVNAME' 'TARGET''target_uic'
$	WS "%SECURE-I-SAVCOPY, ''PARTOF' now copied to ''TARGET'"
$	recoveries=recoveries+1
$!
$	GOTO SOME
$!
$BLUNDER: DISMOUNT MUB1:
$!
$! now open mail file and make up an entry
$	username=f$edit(f$extract(94,13,line1),"TRIM")
$	mf_exists=f$search("lsl$secure:''username'_temp_mail_file.dat")
$	if mf_exists.nes."" then goto rec_mf_exists
$	open/write mail_file lsl$secure:'username'_temp_mail_file.dat
$	goto rec_mf_open
$rec_mf_exists: open/append mail_file lsl$secure:'username'_temp_mail_file.dat
$	write mail_file	"===="
$rec_mf_open: if recoveries.eq.0 then howmany="Nothing"
$	if recoveries.eq.1 then howmany="1 saveset"
$	if recoveries.gt.1 then howmany="''recoveries' savesets"
$	write mail_file	howmany, " recovered from ", lsltape, ":", savname, -
				 " to ", target
$	if specif.gt.1 then write mail_file -
			" (under selection ", partof, ")"
$	write mail_file "  performed by operator ", operator
$	write mail_file "   on ''f$extract(0,11,f$time())' at ", -
			"''f$extract(12,5,f$time())'"
$	close mail_file
$!
$	mf_exists=f$search(" ")
$!
$	GOTO ROUND
$!
$FINITO:
$	CLOSE INPUT
$	DEL/NOCONFIRM LSL$SECURE:RESTDIR.DAT;*
$	CREATE LSL$SECURE:RESTDIR.DAT
$	SET CONTROL=Y
$!
$	message_count=0
$message_loop: zompo_poog=f$search("lsl$secure:*_temp_mail_file.dat")
$	if zompo_poog.eqs."" then goto final_message
$	username=f$parse(zompo_poog,,,"NAME")
$	username=f$extract(0,f$locate("_",username),username)
$	mail/subject="SECURE operation report" -
		lsl$secure:'username'_temp_mail_file.dat 'username'
$	delete	lsl$secure:'username'_temp_mail_file.dat;*/noconfirm/nolog
$	write sys$output "%SECURE-I-USNOTIF, ", username, " notified"
$	message_count=message_count+1
$	goto message_loop
$!
$final_message: if message_count.eq.0 then write sys$output -
		"%SECURE-I-NOMSGSNT, no messages sent to users"
$	if message_count.gt.0 then write sys$output -
		"%SECURE-I-NONDMSG, no need of messages to those users"
$	GOTO QUEST
$!
$! general fall-over-in-a-heap exit
$FATAL_FLAW: TYPE SYS$INPUT:

*******************************************************************************
*                                                                             *
*                F A T A L   E R R O R   D E T E C T E D                      *
*                                                                             *
*     Please discontinue the SECURE archive and seek assistance from          *
*     the system manager. Ensure that this listing is preserved.              * 
*     DO NOT TELL ANY USERS THAT THEIR FILES HAVE BEEN ARCHIVED.              *
*                                                                             *
*                                                                             *
*******************************************************************************


$	DISMOUNT/UNLOAD MUB1:
$! If we had a FATAL error or the user jumped in with ^Y while archiving,
$! ensure that the archive queue files are closed
$ CLOSE_FILES:
$	CLOSE INPUT
$	DEALLOCATE MUB1:
$	GOTO PANIC
$!
$ CONTRL_Y_PEST:
$	CLOSE LA
$	DEALLOCATE MUB1:
$!
$PANIC:
$	IF VERIFICATION.EQ.1 THEN SET VERIFY
$       EXIT
