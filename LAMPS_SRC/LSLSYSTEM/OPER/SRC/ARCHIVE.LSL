$! Command file to archive a disc, specified by the parameter
$! Created AJW June 1980
$! Revised PGH September 1981
$! Revised for V3			PGH	25-Aug-1982
$! add /REW for V3.3			PGH	17-Aug-1983
$! Tidy magtape mount errors		PGH	25-Aug-1983
$! TVES version for DU disk at 6250BPI	PGH	28-May-1984
$! incremental archive added		PGH	19-Jul-1984
$! RA60 archive				PGH	13-Aug-1984
$! LSL VAX version			PGH	16-Sep-1984
$! All Backups done /verify		PWD	27-Jan-1986
$! Tailored to backup the 750 from itself on ms 20-May-1986 HLP
$! CLUSTER WIDE backup (750+GPX)	HLP	25-Mar-1988
$! To allow for TK70 archives		HLP     29-Dec-1988
$! Tidied Up And Debugged		BN	04-Jan-1989
$! density, buffers, listings changed	PGH	17-Feb-1989
$! Amend for VMS5			HLP	30-May-1989
$! remove buffer count for VMS V5.2	PGH	12-Jan-1990
$!
$!
$MENU:
$	TYPE SYS$INPUT

		DISK MENU
		=========

	0		LSLM3A$DUA0:
	1		LSLM3A$DUA1:
	2		LSLM3A$DUA2:
	3		LSLM3A$DUA3:	(Not currently existing)
	4		LSLM3A$DUA4:
	5		LSLV3B$DUA0:
	6		LSLGPX$DUA0:	(Used to be LSLGPX$DUB0:)
	7		LSLM3B$DUA5:
	8		LSLM3B$DUA6:	

	EXIT		Leaves this command file.







$!
$	SET NOON
$	ON CONTROL THEN GOTO ERR3
$	SET PROCESS/PRIORITY=4
$	WS:=WRITE SYS$OUTPUT
$!	RA:=REPLY/BELL/ALL
$	RA:=WRITE SYS$OUTPUT
$!
$! work out which disk it is
$!
$	READ/PROMPT="Which disk do wish to archive?" SYS$COMMAND P1
$	IF P1 .EQS. "EXIT" THEN GOTO END
$	IF P1 .EQS. "0"   .OR. -
	   P1 .EQS. "1"   .OR. -
	   P1 .EQS. "2"   .OR. -
	   P1 .EQS. "4"   .OR. -
	   P1 .EQS. "5"   .OR. -
	   P1 .EQS. "6"   .OR. -
	   P1 .EQS. "7"   .OR. -
	   P1 .EQS. "8"   THEN GOTO ARGOK
$	IF P1 .EQS. "3"	  THEN GOTO NOT_BOUGHT
$	WS "						"
$	WS "UNKNOWN DISK ", P1
$	GOTO MENU
$NOT_BOUGHT:
$!
$	WS "							 "
	WS "This Disk Hasn't Even Been Ordered Yet - Try Again..."
	WS "							 "
$GOTO MENU	
$!
$ ARGOK:
$	IF P1 .EQS. "0"   THEN DISK := "LSLM3A$DUA0:"
$	IF P1 .EQS. "1"   THEN DISK := "LSLM3A$DUA1:"
$	IF P1 .EQS. "2"   THEN DISK := "LSLM3A$DUA2:"
$	IF P1 .EQS. "3"   THEN DISK := "LSLM3A$DUA3:"	
$	IF P1 .EQS. "4"   THEN DISK := "LSLM3A$DUA4:"
$	IF P1 .EQS. "5"   THEN DISK := "LSLV3B$DUA0:"
$	IF P1 .EQS. "6"   THEN DISK := "LSLGPX$DUA0:"
$	IF P1 .EQS. "7"   THEN DISK := "LSLM3B$DUA5:"
$	IF P1 .EQS. "8"   THEN DISK := "LSLM3B$DUA6:"
$!
$! full or incremental archive ?
$!
$	ROOTDIR=DISK+"<000000>000000.DIR"
$	LASTBACK=F$FILE_ATTRIBUTE(ROOTDIR,"BDT")
$	WS "                                                    "
$	WS "Last full backup of ",DISK," was done on ",LASTBACK
$	WS "An incremental archive will only save files changed since that date."
$	READ/PROMPT="Incremental archive (Y/N) ?  " SYS$COMMAND INCREM 
$	BACKSW="/IMAGE/RECORD"
$	IF INCREM THEN BACKSW="/SINCE=BACKUP"
$	INSPEC=DISK
$	IF INCREM THEN INSPEC=DISK+"<*...>*.*;*
$! get date for volume name
$!
$	DATE:='F$TIME()
$	MINUS='F$LOCATE("-",DATE)
$	MONPOS=MINUS+1
$	MONTH:='F$EXTRACT(MONPOS,3,DATE)
$	DAY:='F$EXTRACT(0,MINUS,DATE)
$	IF MINUS.EQ.1 THEN DAY:=0'DAY'
$!
$! Choice of tapedrives...
$!
$IF INCREM THEN	GOTO DISPLAY_MESSAGE
$goto GET_TDRV
$!
$DISPLAY_MESSAGE:
$	TYPE SYS$INPUT








	**********************************************************
	     INCREMENTAL ARCHIVES ARE ON MAGTAPE DRIVE MUB1.
	**********************************************************








$IF INCREM THEN TAPEDRV="MUB1"
$IF INCREM THEN GOTO GOT_TDRV
$!
$	WS "THIS IS A FULL ARCHIVE..."
$GET_TDRV:
$	TYPE SYS$INPUT






	    DRIVE MENU
            ==========

	0		MUA0:
	1		MUB1:

	EXIT		Exits back to main menu







$	READ/PROMPT="Which drive do you wish to use?" SYS$COMMAND P1 
$	IF P1 .EQS. "EXIT" THEN GOTO MENU
$	IF P1 .EQS. "0" THEN TAPEDRV = "MUA0"
$	IF P1 .EQS. "1" THEN TAPEDRV = "MUB1"
$	IF P1 .EQS. "0" .OR. - 
	   P1 .EQS. "1" THEN GOTO GOT_TDRV
$	WS " "
$	WS "FOOLISH INDIVIDUAL. LET US TRY AGAIN."
$	GOTO GET_TDRV
$!
$GOT_TDRV:
$	IF TAPEDRV.EQS."MUB1" THEN BACKSW=BACKSW+"/DENS=6250"
$!
$! announce ourselves
$!
$	RA "Archive of ''DISK' starting now"
$!
$! get devices available
$!
$ MTOK1:
$	READ/PROMPT="Hit return when the first reel is loaded on ''TAPEDRV'" -
		SYS$COMMAND X 
$	MOUNT/FOREIGN 'TAPEDRV':
$	READ/PROMPT="Did the mag tape mount correctly (Y/N) ?" SYS$COMMAND X 
$	IF X THEN GOTO MTOK2
$	DISMOUNT 'TAPEDRV':
$	GOTO MTOK1
$!
$! and let it rip
$!
$ MTOK2:
$	SET PROCESS/DUMP
$	SET NOON
$	SET VERIFY
$	ASSIGN/USER 'F$LOG("TT")' SYS$INPUT
$	BACKUP/VERIFY/REWIND/IGNORE=(LABEL,INTERLOCK)'BACKSW' -
               'INSPEC'     'TAPEDRV':V'NP1''MONTH''DAY'
$	SET NOVERIFY
$!
$ERR3:	SET NOON
$	DISMOUNT 'TAPEDRV':
$ERR4:	SET PROCESS/PRIORITY=4
$	SET NOVERIFY
$	SET PROCESS/NODUMP
$	RA "Archive of ''DISK' complete"
$ END:
