C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1999-11-08 18:33:00.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	LOGICAL FUNCTION WAIT_INPUT(PROMPT,WANT_TABLE,WANT_VDU)
	IMPLICIT NONE
	CHARACTER*(*)		PROMPT		! prompt
	LOGICAL*1		WANT_TABLE	! table input wanted
	LOGICAL*1		WANT_VDU	! VDU input wanted
	INCLUDE '($IODEF)'
        INTEGER    LSL__CREATED                   
        PARAMETER (LSL__CREATED                   =   201424905)
        INTEGER    LSL__NORMAL                    
        PARAMETER (LSL__NORMAL                    =   201424913)
        INTEGER    LSL__SIGSUCC                   
        PARAMETER (LSL__SIGSUCC                   =   201424921)
        INTEGER    LSL__STREOL                    
        PARAMETER (LSL__STREOL                    =   201424929)
        INTEGER    LSL__STRCHAR                   
        PARAMETER (LSL__STRCHAR                   =   201424937)
        INTEGER    LSL__STRCMD                    
        PARAMETER (LSL__STRCMD                    =   201424945)
        INTEGER    LSL__STRSPACE                  
        PARAMETER (LSL__STRSPACE                  =   201424953)
        INTEGER    LSL__DUMMY1                    
        PARAMETER (LSL__DUMMY1                    =   201424961)
        INTEGER    LSL__DUMMY2                    
        PARAMETER (LSL__DUMMY2                    =   201424969)
        INTEGER    LSL__DUMMY3                    
        PARAMETER (LSL__DUMMY3                    =   201424977)
        INTEGER    LSL__DUMMY4                    
        PARAMETER (LSL__DUMMY4                    =   201424985)
        INTEGER    LSL__DUMMY5                    
        PARAMETER (LSL__DUMMY5                    =   201424993)
        INTEGER    LSL__DUMMY6                    
        PARAMETER (LSL__DUMMY6                    =   201425001)
        INTEGER    LSL__DUMMY7                    
        PARAMETER (LSL__DUMMY7                    =   201425009)
        INTEGER    LSL__DUMMY8                    
        PARAMETER (LSL__DUMMY8                    =   201425017)
        INTEGER    LSL__DUMMY9                    
        PARAMETER (LSL__DUMMY9                    =   201425025)
        INTEGER    LSL__DUMMY10                   
        PARAMETER (LSL__DUMMY10                   =   201425033)
        INTEGER    LSL__DEFTOOBIG                 
        PARAMETER (LSL__DEFTOOBIG                 =   201425040)
        INTEGER    LSL__EOF                       
        PARAMETER (LSL__EOF                       =   201425048)
        INTEGER    LSL__FILTOOLONG                
        PARAMETER (LSL__FILTOOLONG                =   201425056)
        INTEGER    LSL__NEGPOSNMK                 
        PARAMETER (LSL__NEGPOSNMK                 =   201425064)
        INTEGER    LSL__POSNMKOVF                 
        PARAMETER (LSL__POSNMKOVF                 =   201425072)
        INTEGER    LSL__RANREV                    
        PARAMETER (LSL__RANREV                    =   201425080)
        INTEGER    LSL__RECTOOBIG                 
        PARAMETER (LSL__RECTOOBIG                 =   201425088)
        INTEGER    LSL__SIGWARN                   
        PARAMETER (LSL__SIGWARN                   =   201425096)
        INTEGER    LSL__SRCTOOBIG                 
        PARAMETER (LSL__SRCTOOBIG                 =   201425104)
        INTEGER    LSL__NOFIELD                   
        PARAMETER (LSL__NOFIELD                   =   201425112)
        INTEGER    LSL__DUMMYW2                   
        PARAMETER (LSL__DUMMYW2                   =   201425120)
        INTEGER    LSL__DUMMYW3                   
        PARAMETER (LSL__DUMMYW3                   =   201425128)
        INTEGER    LSL__DUMMYW4                   
        PARAMETER (LSL__DUMMYW4                   =   201425136)
        INTEGER    LSL__DUMMYW5                   
        PARAMETER (LSL__DUMMYW5                   =   201425144)
        INTEGER    LSL__DUMMYW6                   
        PARAMETER (LSL__DUMMYW6                   =   201425152)
        INTEGER    LSL__DUMMYW7                   
        PARAMETER (LSL__DUMMYW7                   =   201425160)
        INTEGER    LSL__DUMMYW8                   
        PARAMETER (LSL__DUMMYW8                   =   201425168)
        INTEGER    LSL__DUMMYW9                   
        PARAMETER (LSL__DUMMYW9                   =   201425176)
        INTEGER    LSL__DUMMYW10                  
        PARAMETER (LSL__DUMMYW10                  =   201425184)
        INTEGER    LSL__AMBIG                     
        PARAMETER (LSL__AMBIG                     =   201425194)
        INTEGER    LSL__AMBINEQ                   
        PARAMETER (LSL__AMBINEQ                   =   201425202)
        INTEGER    LSL__AMBIG2                    
        PARAMETER (LSL__AMBIG2                    =   201425210)
        INTEGER    LSL__BADEXCEP                  
        PARAMETER (LSL__BADEXCEP                  =   201425218)
        INTEGER    LSL__BADINEQ                   
        PARAMETER (LSL__BADINEQ                   =   201425226)
        INTEGER    LSL__BADPARSE                  
        PARAMETER (LSL__BADPARSE                  =   201425234)
        INTEGER    LSL__BADTCOND                  
        PARAMETER (LSL__BADTCOND                  =   201425242)
        INTEGER    LSL__BASECH                    
        PARAMETER (LSL__BASECH                    =   201425250)
        INTEGER    LSL__BUFOVFLW                  
        PARAMETER (LSL__BUFOVFLW                  =   201425258)
        INTEGER    LSL__BUFFEROVF                 
        PARAMETER (LSL__BUFFEROVF                 =   201425266)
        INTEGER    LSL__COMMA                     
        PARAMETER (LSL__COMMA                     =   201425274)
        INTEGER    LSL__DEFFILNAM                 
        PARAMETER (LSL__DEFFILNAM                 =   201425282)
        INTEGER    LSL__DEFVERNUM                 
        PARAMETER (LSL__DEFVERNUM                 =   201425290)
        INTEGER    LSL__DEVALLOC                  
        PARAMETER (LSL__DEVALLOC                  =   201425298)
        INTEGER    LSL__ENDOFTAPE                 
        PARAMETER (LSL__ENDOFTAPE                 =   201425306)
        INTEGER    LSL__ENDOFVOL                  
        PARAMETER (LSL__ENDOFVOL                  =   201425314)
        INTEGER    LSL__FAC                       
        PARAMETER (LSL__FAC                       =   201425322)
        INTEGER    LSL__FILINUSE                  
        PARAMETER (LSL__FILINUSE                  =   201425330)
        INTEGER    LSL__FLTDIV                    
        PARAMETER (LSL__FLTDIV                    =   201425338)
        INTEGER    LSL__FLTOVF                    
        PARAMETER (LSL__FLTOVF                    =   201425346)
        INTEGER    LSL__FLTUND                    
        PARAMETER (LSL__FLTUND                    =   201425354)
        INTEGER    LSL__HADEXCP                   
        PARAMETER (LSL__HADEXCP                   =   201425362)
        INTEGER    LSL__ILLEGLUN                  
        PARAMETER (LSL__ILLEGLUN                  =   201425370)
        INTEGER    LSL__INTPARSERR                
        PARAMETER (LSL__INTPARSERR                =   201425378)
        INTEGER    LSL__INTDIV                    
        PARAMETER (LSL__INTDIV                    =   201425386)
        INTEGER    LSL__INTOVF                    
        PARAMETER (LSL__INTOVF                    =   201425394)
        INTEGER    LSL__INVALSPEC                 
        PARAMETER (LSL__INVALSPEC                 =   201425402)
        INTEGER    LSL__LUNINUSE                  
        PARAMETER (LSL__LUNINUSE                  =   201425410)
        INTEGER    LSL__MAXPAREX                  
        PARAMETER (LSL__MAXPAREX                  =   201425418)
        INTEGER    LSL__MISSARGS                  
        PARAMETER (LSL__MISSARGS                  =   201425426)
        INTEGER    LSL__MSGNOTFND                 
        PARAMETER (LSL__MSGNOTFND                 =   201425434)
        INTEGER    LSL__NOLUNS                    
        PARAMETER (LSL__NOLUNS                    =   201425442)
        INTEGER    LSL__NONUM                     
        PARAMETER (LSL__NONUM                     =   201425450)
        INTEGER    LSL__NOSUCHDEV                 
        PARAMETER (LSL__NOSUCHDEV                 =   201425458)
        INTEGER    LSL__NOSUCHLUN                 
        PARAMETER (LSL__NOSUCHLUN                 =   201425466)
        INTEGER    LSL__NOSUCHFILE                
        PARAMETER (LSL__NOSUCHFILE                =   201425474)
        INTEGER    LSL__RESPARSOVF                
        PARAMETER (LSL__RESPARSOVF                =   201425482)
        INTEGER    LSL__SIGERR                    
        PARAMETER (LSL__SIGERR                    =   201425490)
        INTEGER    LSL__SRCFILNAM                 
        PARAMETER (LSL__SRCFILNAM                 =   201425498)
        INTEGER    LSL__SRCVERNUM                 
        PARAMETER (LSL__SRCVERNUM                 =   201425506)
        INTEGER    LSL__STRTOOLONG                
        PARAMETER (LSL__STRTOOLONG                =   201425514)
        INTEGER    LSL__SYNTAXERR                 
        PARAMETER (LSL__SYNTAXERR                 =   201425522)
        INTEGER    LSL__SYSCLOSE                  
        PARAMETER (LSL__SYSCLOSE                  =   201425530)
        INTEGER    LSL__SYSERR                    
        PARAMETER (LSL__SYSERR                    =   201425538)
        INTEGER    LSL__SYSFIND                   
        PARAMETER (LSL__SYSFIND                   =   201425546)
        INTEGER    LSL__SYSREAD                   
        PARAMETER (LSL__SYSREAD                   =   201425554)
        INTEGER    LSL__SYSREW                    
        PARAMETER (LSL__SYSREW                    =   201425562)
        INTEGER    LSL__SYSUPD                    
        PARAMETER (LSL__SYSUPD                    =   201425570)
        INTEGER    LSL__SYSWRITE                  
        PARAMETER (LSL__SYSWRITE                  =   201425578)
        INTEGER    LSL__SYSOPEN                   
        PARAMETER (LSL__SYSOPEN                   =   201425586)
        INTEGER    LSL__UNEXPCH                   
        PARAMETER (LSL__UNEXPCH                   =   201425594)
        INTEGER    LSL__UNEXPCMD                  
        PARAMETER (LSL__UNEXPCMD                  =   201425602)
        INTEGER    LSL__UNEXPCMD2                 
        PARAMETER (LSL__UNEXPCMD2                 =   201425610)
        INTEGER    LSL__UNEXPEOF                  
        PARAMETER (LSL__UNEXPEOF                  =   201425618)
        INTEGER    LSL__UNEXPEOL                  
        PARAMETER (LSL__UNEXPEOL                  =   201425626)
        INTEGER    LSL__FILNOLEN                  
        PARAMETER (LSL__FILNOLEN                  =   201425634)
        INTEGER    LSL__SYSFLUSH                  
        PARAMETER (LSL__SYSFLUSH                  =   201425642)
        INTEGER    LSL__DUMMYE3                   
        PARAMETER (LSL__DUMMYE3                   =   201425650)
        INTEGER    LSL__DUMMYE4                   
        PARAMETER (LSL__DUMMYE4                   =   201425658)
        INTEGER    LSL__DUMMYE5                   
        PARAMETER (LSL__DUMMYE5                   =   201425666)
        INTEGER    LSL__DUMMYE6                   
        PARAMETER (LSL__DUMMYE6                   =   201425674)
        INTEGER    LSL__DUMMYE7                   
        PARAMETER (LSL__DUMMYE7                   =   201425682)
        INTEGER    LSL__DUMMYE8                   
        PARAMETER (LSL__DUMMYE8                   =   201425690)
        INTEGER    LSL__DUMMYE9                   
        PARAMETER (LSL__DUMMYE9                   =   201425698)
        INTEGER    LSL__DUMMYE10                  
        PARAMETER (LSL__DUMMYE10                  =   201425706)
        INTEGER    LSL__SIGSEVER                  
        PARAMETER (LSL__SIGSEVER                  =   201425716)
        INTEGER    LSL__DUMMYS1                   
        PARAMETER (LSL__DUMMYS1                   =   201425724)
        INTEGER    LSL__DUMMYS2                   
        PARAMETER (LSL__DUMMYS2                   =   201425732)
        INTEGER    LSL__DUMMYS3                   
        PARAMETER (LSL__DUMMYS3                   =   201425740)
        INTEGER    LSL__DUMMYS4                   
        PARAMETER (LSL__DUMMYS4                   =   201425748)
        INTEGER    LSL__DUMMYS5                   
        PARAMETER (LSL__DUMMYS5                   =   201425756)
        INTEGER    LSL__DUMMYS6                   
        PARAMETER (LSL__DUMMYS6                   =   201425764)
        INTEGER    LSL__DUMMYS7                   
        PARAMETER (LSL__DUMMYS7                   =   201425772)
        INTEGER    LSL__DUMMYS8                   
        PARAMETER (LSL__DUMMYS8                   =   201425780)
        INTEGER    LSL__DUMMYS9                   
        PARAMETER (LSL__DUMMYS9                   =   201425788)
        INTEGER    LSL__DUMMYS10                  
        PARAMETER (LSL__DUMMYS10                  =   201425796)
        INTEGER    LSL__SIGINFO                   
        PARAMETER (LSL__SIGINFO                   =   201425803)
        INTEGER    LSL__DUMMYI1                   
        PARAMETER (LSL__DUMMYI1                   =   201425811)
        INTEGER    LSL__DUMMYI2                   
        PARAMETER (LSL__DUMMYI2                   =   201425819)
        INTEGER    LSL__DUMMYI3                   
        PARAMETER (LSL__DUMMYI3                   =   201425827)
        INTEGER    LSL__DUMMYI4                   
        PARAMETER (LSL__DUMMYI4                   =   201425835)
        INTEGER    LSL__DUMMYI5                   
        PARAMETER (LSL__DUMMYI5                   =   201425843)
        INTEGER    LSL__DUMMYI6                   
        PARAMETER (LSL__DUMMYI6                   =   201425851)
        INTEGER    LSL__DUMMYI7                   
        PARAMETER (LSL__DUMMYI7                   =   201425859)
        INTEGER    LSL__DUMMYI8                   
        PARAMETER (LSL__DUMMYI8                   =   201425867)
        INTEGER    LSL__DUMMYI9                   
        PARAMETER (LSL__DUMMYI9                   =   201425875)
        INTEGER    LSL__DUMMYI10                  
        PARAMETER (LSL__DUMMYI10                  =   201425883)
        INTEGER    LSL__IFFOPENED                 
        PARAMETER (LSL__IFFOPENED                 =   201425891)
        INTEGER    LSL__IFFPARSE                  
        PARAMETER (LSL__IFFPARSE                  =   201425898)
        INTEGER    LSL__IFFVERNUM                 
        PARAMETER (LSL__IFFVERNUM                 =   201425906)
        INTEGER    LSL__IFFSIZE                   
        PARAMETER (LSL__IFFSIZE                   =   201425914)
        INTEGER    LSL__IFFOPEN                   
        PARAMETER (LSL__IFFOPEN                   =   201425922)
        INTEGER    LSL__IFFCREATE                 
        PARAMETER (LSL__IFFCREATE                 =   201425930)
        INTEGER    LSL__IFFMODIFY                 
        PARAMETER (LSL__IFFMODIFY                 =   201425938)
        INTEGER    LSL__LCMOPNOUT                 
        PARAMETER (LSL__LCMOPNOUT                 =   201425947)
        INTEGER    LSL__LOGOPNOUT                 
        PARAMETER (LSL__LOGOPNOUT                 =   201425955)
        INTEGER    LSL__OPLCM                     
        PARAMETER (LSL__OPLCM                     =   201425962)
        INTEGER    LSL__OPLOG                     
        PARAMETER (LSL__OPLOG                     =   201425970)
        INTEGER    LSL__IFFINREV                  
        PARAMETER (LSL__IFFINREV                  =   201425978)
        INTEGER    LSL__IFFOUTREV                 
        PARAMETER (LSL__IFFOUTREV                 =   201425986)
	INTEGER*4	MAX_TXTLIM	! maximum possible buffer length
	PARAMETER	(MAX_TXTLIM = 1024)
	INTEGER*4	DEF_TXTLIM	! default buffer length
	PARAMETER	(DEF_TXTLIM = 255)
	INTEGER*2 	DCPTR   	! decode pointer
	INTEGER*2 	TXTPTR  	! end of line pointer
	BYTE		TXTTYP  	! type of fake string
	BYTE		TXTCLA  	! class of fake string
	INTEGER*4 	TXTADD  	! address of buffer
	INTEGER*2 	TXTLIM  	! actual buffer length
	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer
	INTEGER*4	TXTDSC(2)	! fake string descriptor
	EQUIVALENCE	(TXTDSC,TXTPTR)
	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	EXTERNAL	CTRLCAST
	INTEGER		SYS$QIO		! queue an input requeuest
	INTEGER		SYS$ASSIGN	! assign I/O channels
	INTEGER		TTRSTR		! read line from SYS$INPUT
	INTEGER		TEST_TERM
	LOGICAL		HAD_ERROR	! had table input error?
	LOGICAL		READ_ERROR	! read error message
	INTEGER		OK
	BYTE		ERRBUF(80)	! error message buffer
	INTEGER*2	ERRLEN		! error message length
	INTEGER		ERRNOM		! error number
	WAIT_INPUT = .FALSE.	! assume error
10	IF (CMDFIL) THEN		! commands from command file?
	  OK = TTRSTR()			! read next line from SYS$INPUT
	  IF (.NOT.OK) THEN
	    CALL TTWSTR('*** End of command file ***')
	    OK = TEST_TERM('SYS$COMMAND',TERM,IERR)
	    IF (.NOT.OK) THEN
	      IF (OK.EQ.LSL__SYSERR) THEN
	        CALL LSL_PUTMSG(IERR)
	      ELSE
	        CALL LSL_PUTMSG(OK)
	      ENDIF
	    ELSE
	      CMDFIL = .NOT.TERM		! input from command file
	    ENDIF
	    IF (CMDFIL) GOTO 20		! not a terminal so give up
	    CALL SET_OUTBAND_AST(CTRLCAST,8,,'SYS$COMMAND')
	    IERR = SYS$ASSIGN('SYS$COMMAND',IN_CHAN,,)
	    IF (.NOT.IERR) THEN
	      CALL LSL_PUTMSG(IERR)
	      GOTO 20			! as for ^Z
	    ENDIF
	    GOTO 10			! take commands from terminal
	  ENDIF
	  CALL WRITEF('%S> %S',PROMPT,TXTDSC)	! echo command
	  HAD_VDU = .TRUE.
	  GOTO 18			! input is a text command line
	ENDIF
	TTOPRO = .TRUE.
	CALL TTWSTR(PROMPT//'> ')
	IF (.NOT.HADQIO) THEN
	  IERR = SYS$QIO(
     +		%VAL(EF_VDU),		! event flag to be set
     +  	%VAL(IN_CHAN),		! input channel number
     +  	%VAL(IO$_READVBLK),	! I/O function
     +  	ISB,			! I/O status block
     +  	,			! AST address
     +  	,			! AST parameters
     +  	TXTBUF,			! p1 is buffer
     +  	%VAL(TXTLIM-1),		! p2 is max buffer length
     +    	,			! p3 is default timeout period
     +  	,			! p4 is default terminator
     +  	,			! p5 is prompt string
     +  				! p6 is prompt length
     +  	)
	  IF (.NOT.IERR) THEN
	    CALL LSL_PUTMSG(IERR)
	    GOTO 10			! try again
	  ENDIF
	  HADQIO = .TRUE.		! now had a QIO
	ENDIF
	IF (TABLE) THEN
	   CALL WFLOR(EF_POINT,EF_ERROR,EF_VDU)
	ELSE
	   CALL SYS$WAITFR(%VAL(EF_VDU))
	ENDIF
	HAD_VDU = ISB_STATUS.NE.0
	IF (HAD_VDU) THEN		! had keyboard input?
	  HADQIO = .FALSE.		! no QIO now
	  TTIDON = .TRUE.		! had some input
	  IF (.NOT.ISB_STATUS) THEN
	    CALL LSL_PUTMSG(ISB_STATUS)	! debug
	    GOTO 10			! try again
	  ENDIF
	  IF (ISB_TSIZ.EQ.1.AND.ISB_TRM.EQ.26) GOTO 20	! ctrl/Z
	  TXTPTR = ISB_TOFF
	  IF (WANT_VDU) GOTO 18		! yes so OK
	  CALL TTWSTR('Input must be from table')
	  GOTO 10
	ENDIF
	IF (HAD_ERROR(IERR)) THEN
	  CALL READ_ERROR(ERRBUF,ERRLEN,ERRNOM,IERR)
	  GOTO 10			! try again
	ENDIF
	IF (.NOT.WANT_TABLE) THEN
	  CALL TTWSTR('Input must be from keyboard')
	  CALL READ_PUCK(BUTTON,OK,OK,IERR)	! ditch the input
	  GOTO 10
	ENDIF
18	IF (HAD_VDU) THEN		! had keyboard input?
	  IF (TXTPTR.EQ.0) GOTO 10	! try again if blank line
	  CALL BSLN
	ENDIF
	WAIT_INPUT = .TRUE.		! success
20	RETURN
	END

	SUBROUTINE	PUT_OUTPUT(STRDSC)
	IMPLICIT NONE
	INTEGER*4	STRDSC(2)	! string descriptor
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	INCLUDE	'($IODEF)'
	INTEGER*4	LIB$PUT_OUTPUT
	INTEGER*4	SYS$QIOW
	INTEGER*4	IERR		! system error code
	INTEGER		LENGTH		! length of string
	INTEGER*4	CCLONG		! carriage control longword
	LOGICAL*1	CCBYTE(4)	! same as bytes
	EQUIVALENCE	(CCLONG,CCBYTE)
	IF (TERM) THEN
	   LENGTH = STRDSC(1).AND.65535
	   CCLONG = 0
	   IF (.NOT.TTOBEL) THEN
	      IF (TTODON.OR.TTIDON) THEN
	         CCBYTE(3) = 141		! cr before
	      ELSE
	         CCBYTE(3) = 1			! newline before
	      ENDIF
	      IF (.NOT.TTOPRO) CCBYTE(4) = 1	! newline after
	   ENDIF
	   IERR = SYS$QIOW(	,			! efn
     &			   	%VAL(OUT_CHAN),		! channel
     &				%VAL(IO$_WRITEVBLK),	! functions
     &				,			! iosb
     &				,			! astadr
     &				,			! astprm
     &				%VAL(STRDSC(2)),	! p1 =buffer
     &				%VAL(LENGTH),		! p2 = size
     &				,			! p3 = unused
     &				%VAL(CCLONG),		! p4 = car. ctrl
     &				,			! p5 = unused
     &				)			! p6 = unused
	   IF (.NOT.IERR) CALL LIB$SIGNAL(%VAL(IERR))	! can't WRITEF!
	ELSE
	   IF (.NOT.(TTOBEL.OR.TTOPRO))	THEN	! no bell or prompt
	      IERR = LIB$PUT_OUTPUT(STRDSC)
	      IF (.NOT.IERR) CALL LIB$SIGNAL(%VAL(IERR))! can't WRITEF!
	   ENDIF
	ENDIF
	IF (.NOT.TTOBEL) THEN
	   TTODON = .NOT.TTOPRO
	   IF (TTOPRO) TTIDON = .FALSE.
	   TTOPRO = .FALSE.		! prompt is a one shot
	ENDIF
999	RETURN
	END

        SUBROUTINE CTRLCAST
        IMPLICIT NONE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	CTRLC = .TRUE.			! notify the world
        RETURN
        END

        LOGICAL FUNCTION HADCTRLC
        IMPLICIT NONE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	HADCTRLC = CTRLC
	IF (CTRLC) THEN
	   CALL TTWSTR('Operation aborted by CTRL-C')
	   CTRLC = .FALSE.		! nothing pending now
	ENDIF
	RETURN
        END

	SUBROUTINE SHOW_ERROR(IER)
	IMPLICIT NONE
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	INTEGER		IER	! returned error code
	BYTE		ERRBUF(80)
	INTEGER*2	ERRLEN
	INTEGER		ERRNOM
	CALL READ_ERROR(ERRBUF,ERRLEN,ERRNOM,IER)
	IF (ERRLEN.LT.80) ERRBUF(ERRLEN+1) = 0
	CALL WRITEF('*** %A80',ERRBUF)
	END

	SUBROUTINE CLEAR (IQUAD,PIC)
	IMPLICIT NONE
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP,GSOLID
	PARAMETER (GASTI=3)		! deferral At Some TIme
	PARAMETER (GSUPPD=0)		! regeneration suppressed
	PARAMETER (GBUNDL=0)		! GKS ASF bundled
	PARAMETER (GINDIV=1)		! GKS ASF individual
	PARAMETER (GMETRE=0)		! device coords metres
	PARAMETER (GSUPP=0)		! suppress update regeneration
	PARAMETER (GALWAY=1)		! clear always
	PARAMETER (GNONE=0)		! no input
	PARAMETER (GOK=1)		! input OK
	PARAMETER (GNPICK=2)		! no segment picked
	PARAMETER (GINVIS=0)		! invisible
	PARAMETER (GVISI=1)		! visible
	PARAMETER (GNORML=0)		! normal
	PARAMETER (GHILIT=1)		! highlighted
	PARAMETER (GNCLIP=0)		! no clipping
	PARAMETER (GCLIP=1)		! clipping
	PARAMETER (GSOLID=1)		! solid 
	INTEGER*4	IQUAD		! Which quadrant to clear
	INTEGER*4	PIC		! Which PICTURE
	REAL		PX(4),PY(4)	! rectangle coordinates
	INTEGER*4	I		! counter
	INTEGER*4	SAVED_QUAD	! copy of QUAD
	IF (.NOT.(PRIMARY.OR.SECONDARY))GOTO 999
	SAVED_QUAD = QUAD
	QUAD = IQUAD
	IF (QUAD.EQ.0)THEN
	   IF(PIC.EQ.-1.OR.NOPLNS.EQ.4)THEN
	     IF(PRIMARY.AND.INIT_PRIMARY)THEN
               CALL GCLRWK(1,GALWAY)
	       DO 10 I = 0,4
	          VIEW_SHOWN(1,I) = .FALSE.
10	       CONTINUE
	     ENDIF
	     IF(SECONDARY.AND.INIT_SECONDARY)THEN
               CALL GCLRWK(2,GALWAY)
	       DO 20 I = 0,4
	          VIEW_SHOWN(2,I) = .FALSE.
20	       CONTINUE
	     ENDIF
	   ELSE
	     IF(WTYPE(1).EQ.9900)CALL GDAWK(1)
	     IF(PIC.EQ.1)THEN
	       IF(PRIMARY.AND.INIT_PRIMARY)THEN
	          CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	          CALL LSG_PLANE_OFFSET(1,0)
	       ENDIF
	       IF(SECONDARY.AND.INIT_SECONDARY)THEN
	          CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	          CALL LSG_PLANE_OFFSET(2,0)
	       ENDIF
	     ELSE IF(PIC.EQ.2)THEN
	       IF(PRIMARY.AND.INIT_PRIMARY)THEN
	          CALL LSG_PLANE_SELECT(1,.NOT.PLANE_MASK)
	          CALL LSG_PLANE_OFFSET(1,NOPLNS)
	       ENDIF
	       IF(SECONDARY.AND.INIT_SECONDARY)THEN
	          CALL LSG_PLANE_SELECT(2,.NOT.PLANE_MASK)
	          CALL LSG_PLANE_OFFSET(2,NOPLNS)
	       ENDIF
	     ENDIF
	     CALL PLTPOS(.FALSE.,.TRUE.)
	     CALL GSSGT
	     CALL G3FILL(WXMIN,WYMIN,WXMAX,WYMAX,0)
             IF(WTYPE(1).EQ.9900)CALL GACWK(1)
	  ENDIF
	  QUAD=SAVED_QUAD
          IF(PRIMARY)CALL GUWK(1,GSUPP)
          IF(SECONDARY)CALL GUWK(2,GSUPP)
	  GOTO 999
	ENDIF
	IF(PRIMARY)THEN
	  IF(PIC.EQ.-1)THEN
	    CALL LSG_PLANE_SELECT(1,-1)
	    CALL LSG_PLANE_OFFSET(1,0)
	  ELSE IF(PIC.EQ.1)THEN
	    CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(1,0)
	  ELSE IF(PIC.EQ.2)THEN
	    CALL LSG_PLANE_SELECT(1,.NOT.PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(1,NOPLNS)
	  ENDIF
	ENDIF
	IF(SECONDARY)THEN
	  IF(PIC.EQ.-1)THEN
	    CALL LSG_PLANE_SELECT(2,-1)
	    CALL LSG_PLANE_OFFSET(2,0)
	  ELSE IF(PIC.EQ.1)THEN
	    CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(2,0)
	  ELSE IF(PIC.EQ.2)THEN
	    CALL LSG_PLANE_SELECT(2,.NOT.PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(2,NOPLNS)
	  ENDIF
	ENDIF
	IF(PRIMARY.AND.WTYPE(1).EQ.9900)CALL GDAWK(1)
	CALL PLTPOS(.FALSE.,.TRUE.)
	CALL GSSGT
	CALL G3FILL(WXMIN,WYMIN,WXMAX,WYMAX,0)
	IF(PRIMARY)VIEW_SHOWN(1,IQUAD)=.FALSE. 
	IF(SECONDARY)VIEW_SHOWN(2,IQUAD)=.FALSE.
	QUAD=SAVED_QUAD
	IF(PRIMARY.AND.WTYPE(1).EQ.9900)CALL GACWK(1)
	IF(PRIMARY)CALL GUWK(1,GSUPP)
	IF(SECONDARY)CALL GUWK(2,GSUPP)
999	RETURN
	END
	LOGICAL FUNCTION GET_DTI_COORDS(X_DTI,Y_DTI,PROMPT)
	IMPLICIT NONE
	CHARACTER*(*)	PROMPT		! prompt string
	INTEGER		X_DTI,Y_DTI	! DTI coords
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	LOGICAL		READ_PUCK	! read puck data
	LOGICAL		HAD_PUCK	! had puck input?
	INTEGER*4	RDLONG		! read integer?
	LOGICAL		IN_MENU		! point in menu area
	LOGICAL		WAIT_INPUT	! wait for input
	INTEGER		X_TAB,Y_TAB	! table coords
	INTEGER		CMD		! menu command number
	GET_DTI_COORDS = .FALSE.	! set unsuccessfull
10	IF (.NOT.WAIT_INPUT(PROMPT,.TRUE.,.TRUE.)) GOTO 20
	IF (HAD_VDU) THEN	! keyboard input
	  IF (RDLONG(X_DTI)) GOTO 20	! failure
	  IF (RDLONG(Y_DTI)) GOTO 20	! failure
	ELSEIF (HAD_PUCK(IERR)) THEN	! point input?
	  IF (READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR)) THEN
	    CALL SHOW_ERROR(IERR)
	    GOTO 20			! failure
	  ENDIF
	  IF(IN_MENU(X_TAB,Y_TAB,CMD))THEN
	    CALL WRITEF('*** Menu command not valid in this context')
	    GOTO 10
	  ENDIF
	  IF (.NOT.MAP_SET) THEN
	    CALL WRITEF('*** Map is not located')
	    GOTO 10			! try again
	  ENDIF
	  X_DTI=TAB_DTI(1,1)*X_TAB + TAB_DTI(1,2)*Y_TAB + TAB_DTI(1,3)
	  Y_DTI=TAB_DTI(2,1)*X_TAB + TAB_DTI(2,2)*Y_TAB + TAB_DTI(2,3)
	  TTOBEL = .TRUE.	! signal to VIO$PUT_OUTPUT (OUTPUT.SRC)
	  CALL WRITEF('%N %N',X_DTI,Y_DTI)
	  TTOBEL = .FALSE.
	ENDIF
	IF (X_DTI.LT.1.OR.X_DTI.GT.X_EXTENT(1).OR.
     +	    Y_DTI.LT.1.OR.Y_DTI.GT.Y_EXTENT(1)) THEN
	  CALL WRITEF('*** DTI coords out of range')
	  GOTO 10			! try again
	ENDIF
	GET_DTI_COORDS = .TRUE.		! success
20	RETURN
	END

	LOGICAL FUNCTION GET_TAB_COORDS(X_TAB,Y_TAB,PROMPT)
	IMPLICIT NONE
	CHARACTER*(*)	PROMPT		! prompt string
	INTEGER		X_TAB,Y_TAB	! table coords
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	LOGICAL		READ_PUCK	! read puck data
	LOGICAL		WAIT_INPUT	! wait for input
	GET_TAB_COORDS = .FALSE.	! set unsuccessful
	IF (.NOT.WAIT_INPUT(PROMPT,.TRUE.,.FALSE.)) GOTO 20
	IF (READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR)) THEN
	  CALL SHOW_ERROR(IERR)
	  GOTO 20			! failure
	ENDIF
	GET_TAB_COORDS = .TRUE.		! success
20	RETURN
	END

	LOGICAL FUNCTION GET_WINDOW_POINTS (MCMD)
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	DTIPROJ_IDENT1
	PARAMETER	(DTIPROJ_IDENT1='*DTI')
	INTEGER*4	DTIPROJ_IDENT2
	PARAMETER	(DTIPROJ_IDENT2='PROJ')
	INTEGER*4	NUM_DTI
	PARAMETER	(NUM_DTI=9)
	INTEGER*4	DTIPROJ_RECORD_LENGTH	
	PARAMETER	(DTIPROJ_RECORD_LENGTH=1600)
	INTEGER*4	DTIPROJ_RECORD_OFFSET(NUM_DTI)
	REAL*8		DTIPROJ_ORIGIN(2,NUM_DTI)
	REAL*4 		DTIPROJ_SAMPLE(2,NUM_DTI)
	INTEGER*4	DTIPROJ_UNITS(NUM_DTI)
	INTEGER*4	DTIPROJ_SPHEROID(NUM_DTI)
	INTEGER*4	DTIPROJ_PROJECTION(NUM_DTI)
	REAL*8		DTIPROJ_USER_SPHEROID(2,NUM_DTI)
	REAL*8		DTIPROJ_PROJ_PARAMS(15,NUM_DTI)
	COMMON/DTIPROJ/	
     &			DTIPROJ_RECORD_OFFSET,
     &			DTIPROJ_ORIGIN,DTIPROJ_SAMPLE,
     &			DTIPROJ_UNITS,DTIPROJ_SPHEROID,
     &			DTIPROJ_PROJECTION,
     &			DTIPROJ_USER_SPHEROID,
     &			DTIPROJ_PROJ_PARAMS
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	LOGICAL		MCMD		! true if the command is
	INTEGER*4	X1,Y1,X2,Y2	! window coordinate values
	INTEGER*4	LLDEGS(4)	! values in seconds
	INTEGER*4	X_TAB,Y_TAB	! table coordinates
	INTEGER*4	CMD		! menu command number
	LOGICAL		READLL		! reads lat/long
	LOGICAL		RDREAL		! read real value
	LOGICAL		WAIT_INPUT	! to wait for input
	LOGICAL		READ_PUCK	! read puck data
	LOGICAL		IN_MENU		! test if in menu area
	GET_WINDOW_POINTS = .FALSE.
	IF(CMDACT.EQ.0)MCMD=.TRUE.
	IF(.NOT.MCMD)THEN
	  IF(CMDACT.NE.4.AND.UNITS.NE.4)THEN
	    CALL WRITEF('%S Specifying command WINDOW',ERROR_BELL)
	    CALL WRITEF('Command requires 4 arguments')
	    GOTO 999
	  ENDIF
	  IF     (UNITS.EQ.1)THEN
	    X1=NINT(REALAR(1))
	    Y1=NINT(REALAR(2))
	    X2=NINT(REALAR(3))
	    Y2=NINT(REALAR(4))
	  ELSE IF(UNITS.EQ.2)THEN
	    IF (HAD_ABSOLUTE) THEN
	      X1=NINT((REALAR(1)-X_OFFSET(1))/X_GRID(1))+1
	      Y1=NINT((REALAR(2)-Y_OFFSET(1))/Y_GRID(1))+1
	      X2=NINT((REALAR(3)-X_OFFSET(1))/X_GRID(1))+1
	      Y2=NINT((REALAR(4)-Y_OFFSET(1))/Y_GRID(1))+1
	    ELSE
	      X1=NINT(REALAR(1)/X_GRID(1))+1
	      Y1=NINT(REALAR(2)/Y_GRID(1))+1
	      X2=NINT(REALAR(3)/X_GRID(1))+1
	      Y2=NINT(REALAR(4)/Y_GRID(1))+1
	    ENDIF
	  ELSE IF(UNITS.EQ.4)THEN
	    IF(READLL(LLDEGS,4,.FALSE.))THEN
	      CALL WRITEF('%S Specifying command WINDOW',ERROR_BELL)
	      CALL WRITEF
     &        ('Latitude and longitude values supplied in wrong format')
	      GOTO 999
	    ENDIF
	    REALAR(1)=LLDEGS(1)
	    REALAR(2)=LLDEGS(2)
	    REALAR(3)=LLDEGS(3)
	    REALAR(4)=LLDEGS(4)
	  ELSEIF(UNITS .EQ. 5)THEN
	    IF (HAD_ABSOLUTE) THEN 
	      X1=NINT((REALAR(1)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	      Y1=NINT((REALAR(2)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	      X2=NINT((REALAR(3)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	      Y2=NINT((REALAR(4)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	    ELSE
	      X1=NINT(REALAR(1)/DTIPROJ_SAMPLE(1,1))+1
	      Y1=NINT(REALAR(2)/DTIPROJ_SAMPLE(2,1))+1
	      X2=NINT(REALAR(3)/DTIPROJ_SAMPLE(1,1))+1
	      Y2=NINT(REALAR(4)/DTIPROJ_SAMPLE(2,1))+1
	    ENDIF
	  ENDIF	      	      
	  IF(UNITS.EQ.3.OR.UNITS.EQ.4)THEN
	    X1=NINT(REALAR(2)*10)
	    Y1=NINT(REALAR(1)*10)
	    X1=((X1-LONREC(1,1))/LONINT(1))+1
	    Y1=((Y1-LATREC(1,1))/LATINT(1))+1
	    X2=NINT(REALAR(4)*10)
	    Y2=NINT(REALAR(3)*10)
	    X2=((X2-LONREC(1,1))/LONINT(1))+1
	    Y2=((Y2-LATREC(1,1))/LATINT(1))+1
	  ENDIF
	  IF(X1.LT.1.OR.X1.GT.X_EXTENT(1).OR.
     &       Y1.LT.1.OR.Y1.GT.Y_EXTENT(1).OR.
     &       X2.LT.1.OR.X2.GT.X_EXTENT(1).OR.
     &       Y2.LT.1.OR.Y2.GT.Y_EXTENT(1))THEN
	     CALL WRITEF('%S Specifying command WINDOW',ERROR_BELL)
	     CALL WRITEF('Supplied values outside DTM bounds')
	     GOTO 999
	  ENDIF	   
	  IF(X2.LE.X1.OR.Y2.LE.Y1)THEN
	     CALL WRITEF('%S Specifying command WINDOW',ERROR_BELL)
	     CALL WRITEF('NE corner values must exceed SW corner values')
	     GOTO 999				!reprompt
	  ENDIF	   
	  GOTO 900
	ENDIF
	IF(MCMD)THEN
100	   IF(.NOT.WAIT_INPUT('Window SW corner',.TRUE.,.TRUE.))
     &     GOTO 999
	   IF(HAD_VDU)THEN
             IF(UNITS.NE.4)THEN
	       IF(RDREAL(REALAR(1)))GOTO 100	!reprompt
	       IF(RDREAL(REALAR(2)))GOTO 100	!reprompt
	     ELSE
               IF(READLL(LLDEGS,2,.FALSE.))THEN
	         CALL WRITEF
     &	   ('Latitude and longitude values supplied in wrong format')
	         GOTO 100				!reprompt
	       ELSE
	         REALAR(1)=LLDEGS(1)		!lat in seconds
	         REALAR(2)=LLDEGS(2)		!long in seconds
	       ENDIF
	     ENDIF
	     IF     (UNITS.EQ.1)THEN			!matrix
	        X1=NINT(REALAR(1))
	        Y1=NINT(REALAR(2))
	     ELSE IF(UNITS.EQ.2)THEN			!metres
		IF (HAD_ABSOLUTE)THEN
	           X1=NINT((REALAR(1)-X_OFFSET(1))/X_GRID(1))+1
	           Y1=NINT((REALAR(2)-Y_OFFSET(1))/Y_GRID(1))+1
		ELSE
	           X1=NINT((REALAR(1))/X_GRID(1))+1
	           Y1=NINT((REALAR(2))/Y_GRID(1))+1
		ENDIF
	     ELSE IF (UNITS.EQ.3 .OR. UNITS.EQ.4)THEN	!secs or LATLONG
	        X1=NINT(REALAR(2)*10)
	        Y1=NINT(REALAR(1)*10)
	        X1=((X1-LONREC(1,1))/LONINT(1))+1
	        Y1=((Y1-LATREC(1,1))/LATINT(1))+1
	     ELSE				     !projection units
	        IF (HAD_ABSOLUTE) THEN 
	           X1=NINT((REALAR(1)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	           Y1=NINT((REALAR(2)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	        ELSE
	           X1=NINT(REALAR(1)/DTIPROJ_SAMPLE(1,1))+1
	           Y1=NINT(REALAR(2)/DTIPROJ_SAMPLE(2,1))+1
	        ENDIF
	     ENDIF
	   ELSE 
	     IF(.NOT.MAP_SET)THEN
	       CALL WRITEF('%S Inputting coordinates from table',ERROR_BELL)
	       CALL WRITEF('No map setup has been performed')
	       GOTO 999				!return
	     ENDIF
	     IF(READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR))THEN
               CALL SHOW_ERROR(IERR)
	       GOTO 999
	     ENDIF
	     IF(IN_MENU(X_TAB,Y_TAB,CMD))THEN
	       CALL WRITEF('%S Inputting coordinates from table',ERROR_BELL)
	       CALL WRITEF('Digitised point lies inside the menu')
	       GOTO 100				!reprompt
	     ENDIF
	     X1=NINT(TAB_DTI(1,1)*X_TAB+TAB_DTI(1,2)*Y_TAB+TAB_DTI(1,3))
	     Y1=NINT(TAB_DTI(2,1)*X_TAB+TAB_DTI(2,2)*Y_TAB+TAB_DTI(2,3))
	     TTOBEL = .TRUE.	!signal to VIO$PUT_OUTPUT
	     CALL WRITEF('%N %N',X1,Y1)
	     TTOBEL = .FALSE.
	  ENDIF
	  IF(X1.LT.1.OR.X1.GT.X_EXTENT(1).OR.
     &       Y1.LT.1.OR.Y1.GT.Y_EXTENT(1))THEN
	     CALL WRITEF
     &    ('%S Specifying WINDOW SW corner',ERROR_BELL)
	     CALL WRITEF('Point is outside DTM bounds')
	     GOTO 100				!reprompt
	  ENDIF	   
200	  IF(.NOT.WAIT_INPUT('Window NE corner',.TRUE.,.TRUE.))
     &    GOTO 999
	  IF(HAD_VDU)THEN
            IF(UNITS.NE.4)THEN
	      IF(RDREAL(REALAR(3)))GOTO 200	!reprompt
	      IF(RDREAL(REALAR(4)))GOTO 200	!reprompt
	    ELSE
              IF(READLL(LLDEGS,2,.FALSE.))THEN
	        CALL WRITEF
     &	     ('Latitude and longitude values supplied in wrong format')
	        GOTO 200				!reprompt
	      ELSE
	        REALAR(3)=LLDEGS(1)		!lat in seconds
	        REALAR(4)=LLDEGS(2)		!long in seconds
	      ENDIF
	    ENDIF
	    IF     (UNITS.EQ.1)THEN			!matrix
	        X2=NINT(REALAR(3))
	        Y2=NINT(REALAR(4))
	    ELSE IF(UNITS.EQ.2)THEN			!metres
		IF (HAD_ABSOLUTE) THEN
	           X2=NINT((REALAR(3)-X_OFFSET(1))/X_GRID(1))+1
	           Y2=NINT((REALAR(4)-Y_OFFSET(1))/Y_GRID(1))+1
		ELSE
	           X2=NINT((REALAR(3))/X_GRID(1))+1
	           Y2=NINT((REALAR(4))/Y_GRID(1))+1
		ENDIF
	    ELSEIF (UNITS .EQ. 3 .OR. UNITS .EQ. 4)THEN	!secs or LATLONG
	        X2=NINT(REALAR(4)*10)
	        Y2=NINT(REALAR(3)*10)
	        X2=((X2-LONREC(1,1))/LONINT(1))+1
	        Y2=((Y2-LATREC(1,1))/LATINT(1))+1
	    ELSE					!projection
	        IF (HAD_ABSOLUTE) THEN 
	           X2=NINT((REALAR(3)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	           Y2=NINT((REALAR(4)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	        ELSE
	           X2=NINT(REALAR(3)/DTIPROJ_SAMPLE(1,1))+1
	           Y2=NINT(REALAR(4)/DTIPROJ_SAMPLE(2,1))+1
	        ENDIF
	    ENDIF
	  ELSE 
	    IF(READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR))THEN
               CALL SHOW_ERROR(IERR)
	       GOTO 999
	    ENDIF
	    IF(IN_MENU(X_TAB,Y_TAB,CMD))THEN
	       CALL WRITEF('%S Inputting coordinates from table',ERROR_BELL)
	       CALL WRITEF('Digitised point lies inside the menu')
	       GOTO 200				!reprompt
	    ENDIF
	     X2=NINT(TAB_DTI(1,1)*X_TAB+TAB_DTI(1,2)*Y_TAB+TAB_DTI(1,3))
	     Y2=NINT(TAB_DTI(2,1)*X_TAB+TAB_DTI(2,2)*Y_TAB+TAB_DTI(2,3))
	     TTOBEL = .TRUE.	!signal to VIO$PUT_OUTPUT
	     CALL WRITEF('%N %N',X2,Y2)
	     TTOBEL = .FALSE.
	  ENDIF
	  IF(X2.LT.1.OR.X2.GT.X_EXTENT(1).OR.
     &       Y2.LT.1.OR.Y2.GT.Y_EXTENT(1))THEN
	     CALL WRITEF
     &       ('%S Specifying WINDOW NE corner',ERROR_BELL)
	     CALL WRITEF('Point is outside DTM bounds')
	     GOTO 200				!reprompt
	  ENDIF
	ENDIF	   
900	GET_WINDOW_POINTS=.TRUE.
	DTI_WINDOW_SWX(1) = X1
	DTI_WINDOW_SWY(1) = Y1
	DTI_WINDOW_NEX(1) = X2	
	DTI_WINDOW_NEY(1) = Y2
999	MCMD=.FALSE.
	RETURN
	END	  

	LOGICAL FUNCTION GET_PROFILE_POINTS (MCMD,X1,Y1,X2,Y2)
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	DTIPROJ_IDENT1
	PARAMETER	(DTIPROJ_IDENT1='*DTI')
	INTEGER*4	DTIPROJ_IDENT2
	PARAMETER	(DTIPROJ_IDENT2='PROJ')
	INTEGER*4	NUM_DTI
	PARAMETER	(NUM_DTI=9)
	INTEGER*4	DTIPROJ_RECORD_LENGTH	
	PARAMETER	(DTIPROJ_RECORD_LENGTH=1600)
	INTEGER*4	DTIPROJ_RECORD_OFFSET(NUM_DTI)
	REAL*8		DTIPROJ_ORIGIN(2,NUM_DTI)
	REAL*4 		DTIPROJ_SAMPLE(2,NUM_DTI)
	INTEGER*4	DTIPROJ_UNITS(NUM_DTI)
	INTEGER*4	DTIPROJ_SPHEROID(NUM_DTI)
	INTEGER*4	DTIPROJ_PROJECTION(NUM_DTI)
	REAL*8		DTIPROJ_USER_SPHEROID(2,NUM_DTI)
	REAL*8		DTIPROJ_PROJ_PARAMS(15,NUM_DTI)
	COMMON/DTIPROJ/	
     &			DTIPROJ_RECORD_OFFSET,
     &			DTIPROJ_ORIGIN,DTIPROJ_SAMPLE,
     &			DTIPROJ_UNITS,DTIPROJ_SPHEROID,
     &			DTIPROJ_PROJECTION,
     &			DTIPROJ_USER_SPHEROID,
     &			DTIPROJ_PROJ_PARAMS
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	LOGICAL		MCMD		! true if the command is
	INTEGER*4	X1,Y1		! profile start coords (returned)
	INTEGER*4	X2,Y2		! profile end coords (returned)
	INTEGER*4	LLDEGS(4)	! values in seconds
	INTEGER*4	X_TAB,Y_TAB	! table coordinates
	INTEGER*4	CMD		! menu command number
	LOGICAL		READLL		! reads lat/long
	LOGICAL		RDREAL		! read real value
	LOGICAL		WAIT_INPUT	! to wait for input
	LOGICAL		READ_PUCK	! read puck data
	LOGICAL		IN_MENU		! test if in menu area
	GET_PROFILE_POINTS = .FALSE.
	IF(CMDACT.EQ.0)MCMD=.TRUE.
	IF(.NOT.MCMD)THEN
	  IF(CMDACT.NE.4.AND.UNITS.NE.4)THEN
	    CALL WRITEF('%S Specifying command PROFILE',ERROR_BELL)
	    CALL WRITEF('Command requires 4 arguments')
	    GOTO 999
	  ENDIF
	  IF     (UNITS.EQ.1)THEN
	    X1=NINT(REALAR(1))
	    Y1=NINT(REALAR(2))
	    X2=NINT(REALAR(3))
	    Y2=NINT(REALAR(4))
	  ELSE IF(UNITS.EQ.2)THEN
	    IF (HAD_ABSOLUTE) THEN
	      X1=NINT((REALAR(1)-X_OFFSET(1))/X_GRID(1))+1
	      Y1=NINT((REALAR(2)-Y_OFFSET(1))/Y_GRID(1))+1
	      X2=NINT((REALAR(3)-X_OFFSET(1))/X_GRID(1))+1
	      Y2=NINT((REALAR(4)-Y_OFFSET(1))/Y_GRID(1))+1
	    ELSE
	      X1=NINT(REALAR(1)/X_GRID(1))+1
	      Y1=NINT(REALAR(2)/Y_GRID(1))+1
	      X2=NINT(REALAR(3)/X_GRID(1))+1
	      Y2=NINT(REALAR(4)/Y_GRID(1))+1
	    ENDIF
	  ELSE IF(UNITS.EQ.4)THEN
	    IF(READLL(LLDEGS,4,.FALSE.))THEN
	      CALL WRITEF('%S Specifying command PROFILE',ERROR_BELL)
	      CALL WRITEF
     &        ('Latitude and longitude values supplied in wrong format')
	      GOTO 999
	    ENDIF
	    REALAR(1)=LLDEGS(1)
	    REALAR(2)=LLDEGS(2)
	    REALAR(3)=LLDEGS(3)
	    REALAR(4)=LLDEGS(4)
	  ELSEIF(UNITS.EQ.5)THEN
	    IF (HAD_ABSOLUTE) THEN 
	      X1=NINT((REALAR(1)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	      Y1=NINT((REALAR(2)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	      X2=NINT((REALAR(3)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	      Y2=NINT((REALAR(4)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	    ELSE
	      X1=NINT(REALAR(1)/DTIPROJ_SAMPLE(1,1))+1
	      Y1=NINT(REALAR(2)/DTIPROJ_SAMPLE(2,1))+1
	      X2=NINT(REALAR(3)/DTIPROJ_SAMPLE(1,1))+1
	      Y2=NINT(REALAR(4)/DTIPROJ_SAMPLE(2,1))+1
	    ENDIF
	  ENDIF	      	      
	  IF(UNITS.EQ.3.OR.UNITS.EQ.4)THEN
	    X1=NINT(REALAR(2)*10)
	    Y1=NINT(REALAR(1)*10)
	    X1=((X1-LONREC(1,1))/LONINT(1))+1
	    Y1=((Y1-LATREC(1,1))/LATINT(1))+1
	    X2=NINT(REALAR(4)*10)
	    Y2=NINT(REALAR(3)*10)
	    X2=((X2-LONREC(1,1))/LONINT(1))+1
	    Y2=((Y2-LATREC(1,1))/LATINT(1))+1
	  ENDIF
	  IF(X1.LT.1.OR.X1.GT.X_EXTENT(1).OR.
     &       Y1.LT.1.OR.Y1.GT.Y_EXTENT(1))THEN
	     CALL WRITEF('%S Specifying coordinates of start point',ERROR_BELL)
	     CALL WRITEF('Point is outside DTM bounds')
	     GOTO 999
	  ENDIF	   
	  IF(X2.LT.1.OR.X2.GT.X_EXTENT(1).OR.
     &       Y2.LT.1.OR.Y2.GT.Y_EXTENT(1))THEN
	     CALL WRITEF('%S Specifying coordinates of end point',ERROR_BELL)
	     CALL WRITEF('Point is outside DTM bounds')
	     GOTO 999				!reprompt
	  ENDIF	   
	  GOTO 900
	ENDIF
	IF(MCMD)THEN
100	   IF(.NOT.WAIT_INPUT('Start x and y coordinates',.TRUE.,.TRUE.))
     &     GOTO 999
	   IF(HAD_VDU)THEN
             IF(UNITS.NE.4)THEN
	       IF(RDREAL(REALAR(1)))GOTO 100	!reprompt
	       IF(RDREAL(REALAR(2)))GOTO 100	!reprompt
	     ELSE
               IF(READLL(LLDEGS,2,.FALSE.))THEN
	         CALL WRITEF
     &	   ('Latitude and longitude values supplied in wrong format')
	         GOTO 100				!reprompt
	       ELSE
	         REALAR(1)=LLDEGS(1)		!lat in seconds
	         REALAR(2)=LLDEGS(2)		!long in seconds
	       ENDIF
	     ENDIF
	     IF     (UNITS.EQ.1)THEN			!matrix
	        X1=NINT(REALAR(1))
	        Y1=NINT(REALAR(2))
	     ELSE IF(UNITS.EQ.2)THEN			!metres
		IF (HAD_ABSOLUTE)THEN
	           X1=NINT((REALAR(1)-X_OFFSET(1))/X_GRID(1))+1
	           Y1=NINT((REALAR(2)-Y_OFFSET(1))/Y_GRID(1))+1
		ELSE
	           X1=NINT((REALAR(1))/X_GRID(1))+1
	           Y1=NINT((REALAR(2))/Y_GRID(1))+1
		ENDIF
	     ELSEIF (UNITS.EQ.3 .OR. UNITS.EQ.4)THEN	!secs or LATLONG
	        X1=NINT(REALAR(2)*10)
	        Y1=NINT(REALAR(1)*10)
	        X1=((X1-LONREC(1,1))/LONINT(1))+1
	        Y1=((Y1-LATREC(1,1))/LATINT(1))+1
	     ELSE				     !projection units
	        IF (HAD_ABSOLUTE) THEN 
	           X1=NINT((REALAR(1)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	           Y1=NINT((REALAR(2)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	        ELSE
	           X1=NINT(REALAR(1)/DTIPROJ_SAMPLE(1,1))+1
	           Y1=NINT(REALAR(2)/DTIPROJ_SAMPLE(2,1))+1
	        ENDIF
	     ENDIF
	   ELSE 
	     IF(.NOT.MAP_SET)THEN
	       CALL WRITEF('%S Inputting coordinates from table',ERROR_BELL)
	       CALL WRITEF('No map setup has been performed')
	       GOTO 999				!return
	     ENDIF
	     IF(READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR))THEN
               CALL SHOW_ERROR(IERR)
	       GOTO 999
	     ENDIF
	     IF(IN_MENU(X_TAB,Y_TAB,CMD))THEN
	       CALL WRITEF('%S Inputting coordinates from table',ERROR_BELL)
	       CALL WRITEF('Digitised point lies inside the menu')
	       GOTO 100				!reprompt
	     ENDIF
	     X1=NINT(TAB_DTI(1,1)*X_TAB+TAB_DTI(1,2)*Y_TAB+TAB_DTI(1,3))
	     Y1=NINT(TAB_DTI(2,1)*X_TAB+TAB_DTI(2,2)*Y_TAB+TAB_DTI(2,3))
	     TTOBEL = .TRUE.	!signal to VIO$PUT_OUTPUT
	     CALL WRITEF('%N %N',X1,Y1)
	     TTOBEL = .FALSE.
	  ENDIF
	  IF(X1.LT.1.OR.X1.GT.X_EXTENT(1).OR.
     &       Y1.LT.1.OR.Y1.GT.Y_EXTENT(1))THEN
	     CALL WRITEF
     &    ('%S Specifying coordinates of start point',ERROR_BELL)
	     CALL WRITEF('Point is outside DTM bounds')
	     GOTO 100				!reprompt
	  ENDIF	   
200	  IF(.NOT.WAIT_INPUT('End   x and y coordinates',.TRUE.,.TRUE.))
     &    GOTO 999
	  IF(HAD_VDU)THEN
            IF(UNITS.NE.4)THEN
	      IF(RDREAL(REALAR(3)))GOTO 200	!reprompt
	      IF(RDREAL(REALAR(4)))GOTO 200	!reprompt
	    ELSE
              IF(READLL(LLDEGS,2,.FALSE.))THEN
	        CALL WRITEF
     &	     ('Latitude and longitude values supplied in wrong format')
	        GOTO 200				!reprompt
	      ELSE
	        REALAR(3)=LLDEGS(1)			!lat in seconds
	        REALAR(4)=LLDEGS(2)			!long in seconds
	      ENDIF
	    ENDIF
	    IF     (UNITS.EQ.1)THEN			!matrix
	        X2=NINT(REALAR(3))
	        Y2=NINT(REALAR(4))
	    ELSE IF(UNITS.EQ.2)THEN			!metres
		IF (HAD_ABSOLUTE) THEN
	           X2=NINT((REALAR(3)-X_OFFSET(1))/X_GRID(1))+1
	           Y2=NINT((REALAR(4)-Y_OFFSET(1))/Y_GRID(1))+1
		ELSE
	           X2=NINT((REALAR(3))/X_GRID(1))+1
	           Y2=NINT((REALAR(4))/Y_GRID(1))+1
		ENDIF
	    ELSEIF(UNITS .EQ. 3 .OR. UNITS .EQ. 4)THEN	!secs or LATLONG
	        X2=NINT(REALAR(4)*10)
	        Y2=NINT(REALAR(3)*10)
	        X2=((X2-LONREC(1,1))/LONINT(1))+1
	        Y2=((Y2-LATREC(1,1))/LATINT(1))+1
	    ELSE					!projection
	        IF (HAD_ABSOLUTE) THEN 
	           X2=NINT((REALAR(3)-DTIPROJ_ORIGIN(1,1))
     &             /DTIPROJ_SAMPLE(1,1))+1
	           Y2=NINT((REALAR(4)-DTIPROJ_ORIGIN(2,1))
     &             /DTIPROJ_SAMPLE(2,1))+1
	        ELSE
	           X2=NINT(REALAR(3)/DTIPROJ_SAMPLE(1,1))+1
	           Y2=NINT(REALAR(4)/DTIPROJ_SAMPLE(2,1))+1
	        ENDIF
	    ENDIF
	  ELSE 
	    IF(READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR))THEN
               CALL SHOW_ERROR(IERR)
	       GOTO 999
	    ENDIF
	    IF(IN_MENU(X_TAB,Y_TAB,CMD))THEN
	       CALL WRITEF('%S Inputting coordinates from table',ERROR_BELL)
	       CALL WRITEF('Digitised point lies inside the menu')
	       GOTO 200				!reprompt
	    ENDIF
	    X2=NINT(TAB_DTI(1,1)*X_TAB+TAB_DTI(1,2)*Y_TAB+TAB_DTI(1,3))
	    Y2=NINT(TAB_DTI(2,1)*X_TAB+TAB_DTI(2,2)*Y_TAB+TAB_DTI(2,3))
	    TTOBEL = .TRUE.			!signal to VIO$PUT_OUTPUT
	    CALL WRITEF('%N %N',X2,Y2)
	    TTOBEL = .FALSE.
	  ENDIF
	  IF(X2.LT.1.OR.X2.GT.X_EXTENT(1).OR.
     &       Y2.LT.1.OR.Y2.GT.Y_EXTENT(1))THEN
	     CALL WRITEF
     &       ('%S Specifying coordinates of end point',ERROR_BELL)
	     CALL WRITEF('Point is outside DTM bounds')
	     GOTO 200				!reprompt
	  ENDIF
	ENDIF	   
900	GET_PROFILE_POINTS=.TRUE.
999	MCMD=.FALSE.
	RETURN
	END	  
