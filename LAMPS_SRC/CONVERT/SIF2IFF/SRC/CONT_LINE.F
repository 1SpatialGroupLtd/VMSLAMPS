C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-19 16:45:52.000000000 +0000
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
	LOGICAL FUNCTION CONT_LINE
C
CDEC$	IDENT	'19MR92'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - test for a contination line
C
C	This routine is called after comma delimiter is read,
C	to check if there is a continuation line.
C
	IMPLICIT	NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'CMN:LUN.PAR'		    ! logical unit numbers
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FILES.CMN'		! files
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions
C
	LOGICAL		RDCHS			! read character skip spaces
	INTEGER		READLINE		! read from file or tape
C
C Workspace
C
	INTEGER*4	ERRCOD			! LSLLIB error code
	INTEGER*4	RETCOD			! system error code
	BYTE		ICH			! ASCII code of found char.
	LOGICAL		EOLN			! end of line flag
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	CONT_LINE = .TRUE.
C
C Read next char. If end of line is not returned it is not a continuation line
C
	EOLN = RDCHS(ICH)
	IF (.NOT.EOLN) THEN
	   CALL BSCH
	ELSE
C
C End of line returned - hence a continuation line, so read next line.
C
	   LINE = LINE+1
C
	   ERRCOD = READLINE(RETCOD)
	   IF (ERRCOD.EQ.LSL__EOF) GOTO 900
	   IF (.NOT. ERRCOD) THEN
	      IF (MAGTAPE) THEN
	         CALL LSL_PUTMSG(SIF2IFF__ERRRDMAG,TAPEDEV(1:TAPEDEVLEN))
	         CALL LSL_ADDMSG(ERRCOD)
	      ELSE
	         CALL LSL_PUTMSG(SIF2IFF__ERRRDSIF,SIFFIL(1:SIFLEN),LINE)
	         CALL LSL_ADDMSG(ERRCOD)
	         IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	      ENDIF
	      CONT_LINE = .FALSE.
	   ENDIF
C
	   CALL BSLN				! point to start of line
	ENDIF
C
900	RETURN
	END
