C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-19 14:19:28.000000000 +0100
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
	LOGICAL FUNCTION OPENOUT(FILENAME)
C
CDEC$	IDENT	'19OC89'
C
C	Copyright 			Laser-Scan Ltd., Cambridge, England
C
C	Created						RWR	22-Nov-1985
C
C	Modified					APB	17-Oct-1989
C
C		Moved to DTMCONVERT and adapted to use LSLLIB, DTILIB and
C		standard message
C
C Description:
C 
C	Opens the DEM file or magtape for write
C
	IMPLICIT NONE
C
C Argument
C
	CHARACTER*(*)	FILENAME
C
C Parameters
C
	INCLUDE 'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C System parameters
C
	INCLUDE '($MTDEF)'
	INCLUDE '($DCDEF)'
	INCLUDE '($DVIDEF)'
C
C Common blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'
	INCLUDE 'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE 'LSL$DTI2DEM:GENERAL.CMN'
C
C Functions
C
	LOGICAL		LIB$GETDVI		! Get device information
	LOGICAL		MTONIT			! Initialise tape for output
	LOGICAL		MTOSPC			! Space tape forward
	LOGICAL		MTORWD			! Rewind tape
	LOGICAL		MTOEOV			! Find EOV
	LOGICAL		FLWOPN			! Open disk file for write
C
C Local variables
C
	INTEGER		VAL
	LOGICAL		PE1600			! arg to MTONIT
	LOGICAL		START,EOF
	LOGICAL		NORWND
	INTEGER		ERROR			! System error
C
	DATA	PE1600/.TRUE./
C
C-------------------------------------------------------------------------------
C
	OUTOP=.FALSE.
C
C Note: the filename has already been parsed into the RDFLN common block
C
C If no device, then assume a filename (should not happen)
C
	IF (HAD_DEV) THEN
C
C Check if output is a mag tape unit
C
	   OPENOUT=LIB$GETDVI(DVI$_DEVCLASS,,STR_DEV(1:LEN_DEV),VAL,,)
	   IF (.NOT.OPENOUT) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADDEV,STR_DEV(1:LEN_DEV) )
	      GOTO 900
	   ENDIF
C
	   ISTAPE=VAL.EQ.DC$_TAPE
	ELSE
	   ISTAPE=.FALSE.
	ENDIF
C
C Initialize tape as output & rewind
C
	IF (ISTAPE) THEN
C
C Get name of device
C
	   OPENOUT=LIB$GETDVI(DVI$_DEVNAM,,STR_DEV(1:LEN_DEV),,
     &	               DEVNAM,DEVNAML)
	   IF (.NOT.OPENOUT) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADDEV,STR_DEV(1:LEN_DEV) )
	      GOTO 900
	   ENDIF
C
C Find out if at beginning of tape
C
	   OPENOUT=LIB$GETDVI(DVI$_DEVDEPEND,,STR_DEV(1:LEN_DEV),VAL,,)
	   IF (.NOT.OPENOUT) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADDEV,STR_DEV(1:LEN_DEV) )
	      GOTO 900
	   ENDIF
C
	   START=(VAL.AND.MT$M_BOT).NE.0
	   EOF  =(VAL.AND.MT$M_EOF).NE.0
C
	   IF (START.AND.REWIND) THEN
	      NORWND=.TRUE.
	   ELSE
	      NORWND=.NOT.REWIND
	   ENDIF
C	   
C Initialise tape
C
	   OPENOUT=MTONIT(DEVNAM,PE1600,NORWND)
	   IF (.NOT.OPENOUT) THEN
	      CALL LSL_PUTMSG( DTI2DEM__MTOPEN,DEVNAM(1:DEVNAML) )
	      IF (OPENOUT .EQ. LSL__SYSERR) CALL LSL_ADDMSG(MTOERR)
	      GOTO 900
	   ENDIF
C
C Move to end of tape if not rewinding
C
	   IF (.NOT. REWIND) THEN
C
C If at EOF, then backspace one block, and read to EOV
C otherwise rewind and read to EOV (which may take some time, so
C output a message)
C
	      IF (EOF) THEN
	         OPENOUT=MTOSPC(-1)			! space back 1 block
	      ELSE	         
	         CALL LSL_PUTMSG( DTI2DEM__NOTEOF )
	         OPENOUT=MTORWD()			! rewind tape
	      ENDIF
C
C check for error
C
	      IF (.NOT.OPENOUT) THEN
	         CALL LSL_PUTMSG( DTI2DEM__MTOPEN,DEVNAM(1:DEVNAML) )
	         IF ( OPENOUT.EQ.LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	         GOTO 900
	      ENDIF
C
C Search for EOV
C
	      OPENOUT=MTOEOV(1)			
	      IF ( .NOT.OPENOUT ) THEN
	         CALL LSL_PUTMSG( OPENOUT )
	         IF ( OPENOUT.EQ.LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	         GOTO 900
	      ENDIF
	   ENDIF
C
C Or open file
C
	ELSE
	   OPENOUT=FLWOPN(OUTLUN,FILENAME,ERROR)
	   IF (.NOT.OPENOUT) THEN
	      CALL LSL_PUTMSG( DTI2DEM__FILOPEN,FILENAME )
	      CALL LSL_ADDMSG( OPENOUT )
	      IF ( OPENOUT.EQ.LSL__SYSOPEN ) CALL LSL_ADDMSG(ERROR)
	      GOTO 900
	   ENDIF
	ENDIF
	OUTOP=.TRUE.
	GOTO 900
C 
  900	CONTINUE
	RETURN
	END
