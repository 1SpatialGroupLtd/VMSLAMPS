C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-23 09:51:34.000000000 +0000
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
	LOGICAL FUNCTION GET_XYZ
C
CDEC$	IDENT	'23MR92'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	07-Feb-1990
C
C	CONVERT SIF2IFF Utility - get SIF coords in a SIF command line
C
C Description
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:FLAGS.CMN'		    ! flags
	INCLUDE 'CMN:SIF2IFF.CMN'	    ! globals
	INCLUDE 'CMN:IFF_FEATURE.CMN'	    ! feature data
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	    ! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'     ! LSLLIB status flag
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDLONG		! read a long
	LOGICAL		FINDFC		! find a feature code
	LOGICAL		READ_SEP	! read a seperator
	LOGICAL		RDCHS		! read a character
	LOGICAL		CONT_LINE	! continuation line
C
C Local Variables
C
	INTEGER*4	RESULT		! command read result
	LOGICAL		OK		! function return status
	LOGICAL		NOLONG		! flag returned integer
	LOGICAL		EOLN		! end of line flag
	INTEGER		AXIS		! flag x or y axis
	REAL		RDUMMY		! dummy real
	REAL		X,Y,Z		! coords
	INTEGER		XYZVAL		! SIF coords in UORS
	BYTE		ICH		! ASCII character
C
C Assume that everything goes well
C
	GET_XYZ = .TRUE.
C
C Read coords and store in buffer
C
	IF (.NOT.HAD_EST) THEN
	   AXIS = 1
555	   CONTINUE
	   NOLONG = RDLONG( XYZVAL )
C
C If coord out of specified range give warning
C
	   IF (HAD_RANGE.OR.HAD_CCG) THEN
	      IF (AXIS.EQ.1) THEN
	         IF (.NOT.(XYZVAL.GE.XMIN.AND.XYZVAL.LE.XMAX)) THEN
	            CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	            CALL LSL_ADDMSG(SIF2IFF__LINEINSIF,LINE)
	            LSL_STATUS = SIF2IFF__LINEINSIF	!reduce error status
	 	 ENDIF
	      ELSE IF (AXIS.EQ.2) THEN
	         IF (.NOT.(XYZVAL.GE.YMIN.AND.XYZVAL.LE.YMAX)) THEN
	            CALL LSL_PUTMSG(SIF2IFF__COORDOUTRA,FSN)
	            CALL LSL_ADDMSG(SIF2IFF__LINEINSIF,LINE)
	            LSL_STATUS = SIF2IFF__LINEINSIF	!reduce error status
	 	 ENDIF
	      ENDIF
	   ENDIF
C
C Get the coord
C
	   IF (NOLONG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	      GOTO 9999
	   ENDIF
	   IF ( AXIS.EQ.1 ) THEN
	      X = (REAL(XYZVAL)-REAL(XMIN))/REAL(UNITS)	! Convert to MMs
	      AXIS = 2
	   ELSE IF (AXIS.EQ.2) THEN
	      Y = (REAL(XYZVAL)-REAL(YMIN))/REAL(UNITS)	! Convert to MMs
	      IF (DIMEN.EQ.2) THEN
		 IF (IS_TEXT) THEN
		    TORX = X
		    TORY = Y
		    TORZ = 0.0
		 ELSE
	            Z = 0.0
	            CALL COORD( X,Y,Z )
		 ENDIF
	         AXIS = 1
	      ELSE
	        AXIS = 3
	      ENDIF
	   ELSE
	      Z = (REAL(XYZVAL)-REAL(ZMIN))/REAL(UNITS)	! Convert to MMs
	      IF (IS_TEXT) THEN
		 TORX = X
		 TORY = Y
		 TORZ = Z
	      ELSE
	         CALL COORD( X,Y,Z )
	      ENDIF
	      AXIS = 1
	   ENDIF
	   OK = READ_SEP(',')
	   IF (OK) THEN
	      IF (.NOT.CONT_LINE()) GOTO 9999
	   ENDIF
C
	   IF (AXIS.EQ.2.OR.AXIS.EQ.3) GOTO 555		! get y or z coord
	ENDIF
	GOTO 9000
C
9999	GET_XYZ = .FALSE.
C
9000	RETURN
	END
