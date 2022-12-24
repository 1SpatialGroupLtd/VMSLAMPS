C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-18 09:07:36.000000000 +0100
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
C **************************************************************************
C
C These routines are to be built as a shared image to allow a stereoplotter
C to act as a 3D input device for LITES2.
C
C SSPI version for VIAK in Sweden			PGH	11-May-1990
C
C Calling sequence is:
C	DSR_INIT	called once to initialise
C	DSR_START	called to set up read
C	DSR_TRN		called on read event to return button number
C	DSR_READ	called on read event to return X,Y,Z
C	(loop back to DSR_START)
C
C	DSR_MOVE	is supplied as a No-Op in this version
C
C **************************************************************************
C
	LOGICAL FUNCTION DSR_INIT
C
CDEC$	IDENT	'18MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					CCB	 2-Mar-1989
C	VIAK version				PGH	11-May-1990
C
C	Function to initialise DSR (Digital Steroplotter Reading!)
C	in this case as SSPI (Serial StereoPlotter Input).
C
C	Returns .TRUE. if successful, .FALSE. otherwise
C
	IMPLICIT NONE
C
C system parameters
	INCLUDE		'($DCDEF)'
	INCLUDE		'($DEVDEF)'
	INCLUDE 	'($DVIDEF)'
	INCLUDE		'($IODEF)'
	INCLUDE		'($TTDEF)'
	INCLUDE		'($SSDEF)'
C
C common
	INCLUDE		'DSR_SSPI_CMN.CMN'
C
C workspace
	INTEGER*4	IERR		! error code
	LOGICAL		NTYPAHD		! whether line was no type ahead
	LOGICAL		NOBRDCST	! whether line was no broadcast
	INTEGER*4	VAL		! returned value
	INTEGER*4	LEN		! returned length
	INTEGER*4	BUFF(2)		! term characteristics
	INTEGER*2	IOSB(4)		! I/O status block
	BYTE		WBUFF(8)	! write buffer
	EQUIVALENCE	(BUFF,WBUFF)
	INTEGER*4	I,J
C
C functions called
	INTEGER*4	LIB$GETDVI
	INTEGER*4	SYS$ALLOC
	INTEGER*4	SYS$ASSIGN
	INTEGER*4	SYS$QIOW
	INTEGER*4	SYS$TRNLNM
C
C skip if already done
	IF (CHAN.NE.0) GOTO 9990	! channel already assigned
C
C try to translate logical name for table line
	IERR=SYS$TRNLNM(,'LNM$FILE_DEV',LOGNAM,,)
	IF (IERR.EQ.SS$_NOLOGNAM) THEN
	   TYPE *,'***  Error translating ',LOGNAM,', not a logical name'
	   GOTO 9999
	ELSEIF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error translating ',LOGNAM,' logical name'
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9999
	ENDIF
C
C assign channel
	IERR=SYS$ASSIGN(LOGNAM,CHAN,,)
	IF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error assigning channel to ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9999
	ENDIF
C
C check that line is a terminal line
	IERR=LIB$GETDVI(DVI$_DEVCLASS,CHAN,,VAL,,)
	IF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error obtaining characteristics for ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9998
	ENDIF
C
	IF (VAL.NE.DC$_TERM) THEN
	   TYPE *,'***  Error as ',LOGNAM,' is not a terminal line'
	   GOTO 9998
	ENDIF
C
C allocate device
	IERR=SYS$ALLOC(LOGNAM,,,,)
	IF (IERR.EQ.SS$_DEVALLOC) THEN
	   TYPE *,'***  Error allocating ',LOGNAM
	   TYPE *,'***  Device already in use'
	   GOTO 9998
	ELSEIF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error allocating ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9998
	ENDIF
C
C check whether type-ahead or not
	IERR=LIB$GETDVI(DVI$_TT_NOTYPEAHD,,LOGNAM,VAL)
	IF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error obtaining characteristics for ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9997
	ENDIF
C
	NTYPAHD=VAL.EQ.1
C
C check whether no broadcast or not
	IERR=LIB$GETDVI(DVI$_TT_NOBRDCST,,LOGNAM,VAL)
	IF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error obtaining characteristics for ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9997
	ENDIF
C
	NOBRDCST=VAL.EQ.1
C
	IF (NTYPAHD.OR..NOT.NOBRDCST) THEN
C
C get current setting
	   IERR=SYS$QIOW(,			! efn
     &	                 %VAL(CHAN),		! channel
     &	                 %VAL(IO$_SENSEMODE),	! function
     &	                 IOSB,			! iosb
     &	                 ,			! astadr
     &	                 ,			! astprm
     &	                 BUFF,			! terminal char'istics
     &	                 %VAL(8),		! length of BUFF
     &	                 ,			! p3
     &	                 ,			! p4
     &	                 ,			! p5
     &	                  )			! p6
C
	   IF (IERR.NE.SS$_NORMAL) THEN
	      TYPE *,'***  Error sensing characteristics for ',LOGNAM
	      CALL SSPI_SIGNAL(IERR)
	      GOTO 9997
	   ENDIF
	   IF (.NOT.IOSB(1)) THEN
	      TYPE *,'***  Error sensing characteristics for ',LOGNAM
	      IERR=IOSB(1)
	      CALL SSPI_SIGNAL(IERR)
	      GOTO 9997
	   ENDIF
C
C remove no_typahead terminal characteristic
C
	   IF (NTYPAHD) BUFF(2)=BUFF(2).AND..NOT.TT$M_NOTYPEAHD
	   IF (.NOT.NOBRDCST)BUFF(2)=BUFF(2).OR.TT$M_NOBRDCST
C
C and write it back
C
	   IERR=SYS$QIOW(,			! efn
     &	                 %VAL(CHAN),		! channel
     &	                 %VAL(IO$_SETMODE),	! function
     &	                 IOSB,			! iosb
     &	                 ,			! astadr
     &	                 ,			! astprm
     &	                 BUFF,			! terminal char'istics
     &	                 %VAL(8),		! length of BUFF
     &	                 ,			! p3
     &	                 ,			! p4
     &	                 ,			! p5
     &	                  )			! p6
C
	   IF (IERR.NE.SS$_NORMAL) THEN
	      TYPE *,'***  Error setting characteristics for ',LOGNAM
	      CALL SSPI_SIGNAL(IERR)
	      GOTO 9997
	   ENDIF
	   IF (.NOT.IOSB(1)) THEN
	      TYPE *,'***  Error setting characteristics for ',LOGNAM
	      IERR=IOSB(1)
	      CALL SSPI_SIGNAL(IERR)
	      GOTO 9997
	   ENDIF
	ENDIF
C
C send Ctrl/Q to table to wake it up in case it is on a terminal server
	WBUFF(1) = 17			! ctrl Q
	IERR=SYS$QIOW(,			! efn
     &	        %VAL(CHAN),		! channel
     &	        %VAL(IO$_WRITEVBLK.OR.
     &	        IO$M_CANCTRLO),		! function
     &	        IOSB,			! iosb
     &	        ,			! astadr
     &	        ,			! astprm
     &	        WBUFF,			! p1
     &	        %VAL(1),		! p2 - length of WBUFF
     &	        ,			! p3 - zero time out
     &	        ,			! p4
     &	        ,			! p5
     &	        )			! p6
	IF (IERR.NE.SS$_NORMAL) THEN
	   TYPE *,'***  Error with inital write to ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9997
	ENDIF
	IF (.NOT.IOSB(1)) THEN
	   TYPE *,'***  Error with inital write to ',LOGNAM
	   IERR=IOSB(1)
	   CALL SSPI_SIGNAL(IERR)
	   GOTO 9997
	ENDIF
C
C success exit
9990	DSR_INIT = .TRUE.	! success
	GOTO 9900
C
C error exits
C
9997	CALL SYS$DALLOC(LOGNAM,)
9998	CALL SYS$DASSGN(%VAL(CHAN))
9999	TYPE *,' '
	DSR_INIT = .FALSE.	! failure
	GOTO 9900
C
C
9900	RETURN
	END
C
	SUBROUTINE DSR_MOVE(X,Y,Z,WAIT)
C
CDEC$	IDENT	'15MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					CCB	 2-Mar-1989
C	VIAK version				PGH	11-May-1990
C
C	Move DSR to position
C
	IMPLICIT NONE
C
C arguments
	REAL*8	X,Y,Z
	LOGICAL	WAIT
C
C This routine is a No-Op at present as plotter cannot be driven by program.
	RETURN
	END
C
	LOGICAL FUNCTION DSR_START(EFN,IOSB,AST,BUFF)
C
CDEC$	IDENT	'15MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					CCB	 2-Mar-1989
C	VIAK version				PGH	11-May-1990
C
C	Function to put up a read to DSR
C	Returns .TRUE. if successful, .FALSE. otherwise (error in QIO)
C
	IMPLICIT NONE
C
C
C Arguments
	INTEGER*4	EFN		! event flag to wait for
	INTEGER*2	IOSB(4)		! I/O status block to set
	EXTERNAL	AST		! AST routine to call
	BYTE		BUFF		! buffer for output
C
C common
	INCLUDE		'DSR_SSPI_CMN.CMN'
C
C system parameters
	INCLUDE		'($IODEF)'
C
C functions called
	INTEGER*4	SYS$QIO
C
C workspace
	INTEGER*4	IERR
C
	DSR_START=.TRUE.			! assume OK
C
C The following is a nasty frig because the calling LITES2 code
C only expects a single character read, and we have a whole line.
C
	IOSBADDR = %LOC(IOSB(1))		! remember IOSB
	BUFFADDR = %LOC(BUFF)			! remember BUFF
C
	IERR=SYS$QIO(%VAL(EFN),			! efn
     &	             %VAL(CHAN),		! channel
     &	             %VAL(IO$_READVBLK.OR.IO$M_NOECHO),! function
     &	             IOSB,			! iosb
     &	             AST,			! astadr
     &	             ,				! astprm
     &	             %REF(SSPILINE),		! p1 - buffer for input 
     &	             %VAL(80),			! p2 - length of buffer
     &	             ,				! p3
     &	             ,				! p4
     &	             ,				! p5
     &	              )				! p6
C
	IF (.NOT.IERR) THEN
	   TYPE *,'***  Error with read from ',LOGNAM
	   CALL SSPI_SIGNAL(IERR)
	   TYPE *,' '
	   DSR_START=.FALSE.			! QIO failed??
	ENDIF
C
9999	RETURN
	END
C
	SUBROUTINE DSR_READ(X,Y,Z)
C
CDEC$	IDENT	'15MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					CCB	 2-Mar-1989
C	VIAK version				PGH	11-May-1990
C
C	Read DSR position
C
	IMPLICIT NONE
C
C arguments
	REAL*8	X,Y,Z
C
C common
	INCLUDE		'DSR_SSPI_CMN.CMN'
C
C return X,Y,Z from info previously extracted by DSR_TRN
C
	X = SAVX
	Y = SAVY
	Z = SAVZ
	RETURN
	END
C
	INTEGER FUNCTION DSR_TRN(CH)
C
CDEC$	IDENT	'15MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					CCB	 2-Mar-1989
C	VIAK version				PGH	11-May-1990
C
C	Translate a character from DSR button to button number
C
	IMPLICIT NONE
C
C Arguments
	BYTE		CH		! the character
C
C common
	INCLUDE		'DSR_SSPI_CMN.CMN'
C
C functions
	INTEGER		SSPI_DECODE
C
C In this VIAK version, this routine calls SSPI_DECODE to decode the
C info read from the serial line. We pass all the info here, to help
C where only addresses are known.
C
	DSR_TRN = SSPI_DECODE(SSPILINE,%VAL(BUFFADDR),%VAL(IOSBADDR),
     &     SAVX,SAVY,SAVZ,SAVBUT)
C
9999	RETURN
	END
C
	INTEGER FUNCTION SSPI_DECODE(LINE,BUFF,IOSB,X,Y,Z,BUTTON)
C
CDEC$	IDENT	'18MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					CCB	 2-Mar-1989
C	VIAK version				PGH	11-May-1990
C
C	Decode the information read from the serial line, and split it
C	into X,Y,Z, button.
C
	IMPLICIT NONE
C
C Arguments
	CHARACTER*80	LINE		! real buffer for input
	BYTE		BUFF		! fake buffer for input
	INTEGER*2	IOSB(4)		! I/O status block 
	REAL*8		X,Y,Z		! coordinates
	INTEGER		BUTTON		! button number
C
C common
	INCLUDE		'DSR_SSPI_CMN.CMN'
C
C workspace
	INTEGER		NCHS		! number of chars
C
	SSPI_DECODE = -1		! assume naff
	NCHS = IOSB(2)
C
	IF (NCHS.LE.0) GOTO 9999	! nothing there
	IF (NCHS.LT.7) GOTO 9000	! not enough
	READ(LINE(1:NCHS),101,END=9000,ERR=9000) X,Y,Z,BUTTON
101	FORMAT(3D20.0,I2)
	IF (BUTTON.LT.0) GOTO 9000	! invalid button number
	BUFF = MOD(BUTTON,80)+48	! as a character (but not used)
	SSPI_DECODE = BUTTON
	GOTO 9999
C
C here with invalid string
9000	TYPE *,'***  Error decoding from ',LOGNAM
	TYPE *,'***  Invalid string is "',LINE(1:NCHS),'"'
	TYPE *,' '
C
9999	RETURN
	END
C
	SUBROUTINE SSPI_SIGNAL(IERR)
C
CDEC$	IDENT	'15MY90'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	VIAK version				PGH	11-May-1990
C
C	signal an error
C
	IMPLICIT NONE
C
C Arguments
	INTEGER*4	IERR		! the error number
	INTEGER*4	MERR		! modified error number
C
C signal the value, reduced in severity
	MERR = (IERR.AND.(.NOT.7))
	CALL LIB$SIGNAL(%VAL(MERR))
	RETURN
	END
