C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-08-03 15:13:32.000000000 +0100
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
	LOGICAL FUNCTION RDSYM
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF SYM command
C
C Description
C
C	Read parameters of SIF SYM command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:TEXT.CMN'		! text variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	READSTR		! read a string
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		READ_SEP	! read a SIF command seperator
	LOGICAL		RDLONG
	LOGICAL		RDREAL		! read a real
	LOGICAL		FINDFC		! find a feature code
	LOGICAL		CONT_LINE	! end of line test
	LOGICAL		GET_XYZ
	LOGICAL		SKIP_CONTLIN	! skip over continuation lines
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! loop counter
	CHARACTER*80	DUMSTR		! dummy character string
	REAL		RDUMMY		! dummy real
	INTEGER*4	IDUMMY		! dummy integer
	INTEGER*4	RESULT		! command read result
	LOGICAL		NOLONG
	LOGICAL		NOREAL		! flag returned real
	LOGICAL		HAD_OR		! flag OR parameter
	LOGICAL		OK		! function return status
	INTEGER		AXIS		! flag x or y axis
	REAL		T11,T21,T12,T22	! matrix parameters
	REAL		X,Y,Z		! coords
	INTEGER		XYZVAL		! 
	INTEGER		XYZ1		!
	INTEGER		XYZ2		! 
	BYTE		COMMA		! terminating character
	PARAMETER	(COMMA=',')
	BYTE		PTR		! decode pointer
C
C External declaration
C
	INTEGER*4	SYMCMD_CMD_TABLE
	EXTERNAL	SYMCMD_CMD_TABLE
C
C...............................................................................
C Assume that everything goes well
C
	RDSYM = .TRUE.
	ORI_SYM = .TRUE.
C
	IS_SYMBOL = .TRUE.
	HAD_OR = .FALSE.
	NOMESS = .FALSE.
C
C...............................................................................
C read the command from the line
C
500	RESULT = RDCOMM(SYMCMD_CMD_TABLE)
C
C	........................................................................
C	and check that there was one.
C
	IF (RESULT .LE. 0) THEN
	   IF (HAD_OR) THEN
	      CALL DCPSET(PTR)
	      GOTO 600
	    ENDIF
	    GOTO 9999
	ENDIF
C
C	........................................................................
C	Look for ',' or '=' seperator - send warning mess if not found
C
	OK = READ_SEP(',')
	IF (.NOT.OK) THEN
	   CALL BSCH
	   OK = READ_SEP('=')
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(SIF2IFF__SEPNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	ENDIF
C
C	........................................................................
C	test for continuation line
C
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C	........................................................................
C	Despatch according to command
C
	GOTO (510,520,530,540) RESULT
C
C	........................................................................
C	Unknown command - might be symbol name string
C
	GOTO 600
C
C...............................................................................
C	MX - Ignore mirroring, continue reading rest of line
C
510	GOTO 500
C
C	........................................................................
C	MY - Ignore mirroring, continue reading rest of line
C
520	GOTO 500
C
C	........................................................................
C	OR - symbol origin
C
530	IF (.NOT.HAD_EST) THEN
	   AXIS = 1
555	   CONTINUE
	   NOLONG = RDLONG( XYZVAL )
	   IF (NOLONG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   IF ( AXIS.EQ.1 ) THEN
	      XYZ1 = XYZVAL
	      X = (REAL(XYZVAL)-REAL(XMIN))/REAL(UNITS)	! Convert to MMs
	      AXIS = 2
	   ELSE IF (AXIS.EQ.2) THEN
	      XYZ2 = XYZVAL
	      Y = (REAL(XYZVAL)-REAL(YMIN))/REAL(UNITS)	! Convert to MMs
	      IF (DIMEN.EQ.2) THEN
	         Z = 0.0
	         CALL COORD( X,Y,Z )
	         AXIS = 1
	      ELSE
	        AXIS = 3
	      ENDIF
	   ELSE
	      Z = (REAL(XYZVAL)-REAL(ZMIN))/REAL(UNITS)	! Convert to MMs
	      CALL COORD( X,Y,Z )
	      AXIS = 1
	   ENDIF
	   OK = READ_SEP(',')
	   IF (OK) THEN
	      IF (.NOT.CONT_LINE()) GOTO 9999
	   ENDIF
C
	   IF (AXIS.EQ.2.OR.AXIS.EQ.3) GOTO 555		! get y or z coord
	ENDIF
	HAD_OR = .TRUE.
	CALL DCPSAV(PTR)
	NOMESS = .TRUE.
C
	GOTO 500				!get next command or text string
C
C	........................................................................
C	MA - 
C
540	NOREAL = RDREAL(T11)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	NOREAL = RDREAL(T21)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	NOREAL = RDREAL(T12)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	NOREAL = RDREAL(T22)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	IF (DIMEN.EQ.3) THEN			!3D NOT IMPLEMENTED
	   DO 592 I = 1,5
	     NOREAL = RDREAL(RDUMMY)	
	     OK = READ_SEP(',')
	     IF (.NOT.CONT_LINE()) GOTO 9999
592	   CONTINUE
	ENDIF

	ANGLE = ATAN2(T21,T11)			! orientation
	SCALE_FACTOR = T11*T22 - T12*T21	! scale factor
C
C	** For CCG only output oriented symbols. **
C
	IF (.NOT.HAD_CCG) THEN		
	   IF (.NOT.((SCALE_FACTOR-1.0).LT.ACC)) THEN	! its a scaled symbol
	      ORI_SYM = .FALSE.
	      X = COS(ANGLE)
	      Y = SIN(ANGLE)
	      Z = 0.0
	      CALL COORD( X,Y,Z )
	      SYMTYPE = 1
	    ENDIF
	ENDIF
	CALL DCPSAV(PTR)
	NOMESS = .TRUE.
	GOTO 500				!get next command or text string
C
C	........................................................................
C	Read the symbol name
C
600	NCHS = READSTR(TEXT)
	IF (NCHS.EQ.0) THEN
	   CALL LSL_PUTMSG(SIF2IFF__TEXNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
C
C...............................................................................
C	Now ready to create a new IFF feature.
C
	IF (.NOT.FINDFC()) THEN
	  OK = SKIP_CONTLIN()
	  GOTO 9999
	ENDIF
C
	CALL START_FEATURE
C
C	........................................................................
C	If coord out of specified range give warning
C
	IF (HAD_RANGE.OR.HAD_CCG) THEN
	  IF (	(XYZ1.LT.XMIN).OR.(XYZ1.GT.XMAX) .OR.
     &		(XYZ2.LT.YMIN).OR.(XYZ2.GT.YMAX) 	)THEN
	     CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	  ENDIF
	ENDIF
C
C	........................................................................
C	Now write the feature
C
	CALL WRITE_FEATURE
	ORI_SYM = .FALSE.
	RDSYM = .TRUE.
	GOTO 9000
C
C...............................................................................
9999	RDSYM = .FALSE.
	IF (DONE_START_FEATURE) CALL IFFDEL
	DONE_START_FEATURE = .FALSE.
C
C...............................................................................
C Return
C
9000	IS_SYMBOL = .FALSE.
	NOMESS = .FALSE.
	RETURN
	END
