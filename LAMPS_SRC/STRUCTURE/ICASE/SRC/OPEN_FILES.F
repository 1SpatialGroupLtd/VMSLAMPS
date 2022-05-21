C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-02-19 11:58:56.000000000 +0000
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
	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'25SE91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description:
C	Open input, output and FRT files
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'	! File LUNs, etc
!	INCLUDE 'LSL$CMNLSL:CLD.CMN'	! DCL command decoding
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! Access to IERCD
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'	! FRT command block
C
	LOGICAL*4	FRTINI		! Initialise reading from FRT
	LOGICAL*4	FAILED		! Reading FRT failed
C
C------------------------------------------------------------------------------
C
C Open FRT file
C
	IF (HAD_FRT) THEN
	   FAILED = FRTINI(FRTFILE(:FRTLEN))		!open the FRT file
	   IF (FAILED) THEN
	      CALL LSL_PUTMSG(ICASE__ERRRDFRT,FRTFILE(:FRTLEN) )
	      CALL LSL_ADDMSG( FAILED )
	      IN_OPEN = .FALSE.           		! force routine to fail
	      OUT_OPEN = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
C open input file read only
C
	CALL IFFERM(.FALSE.)              ! turn off error messages
	CALL IFFOPN(INLUN,INFILE,0)
	CALL IFFERM(.TRUE.)               ! turn on error messages
	IN_OPEN = IERCD.EQ.0
	IF (.NOT.IN_OPEN) THEN
	   CALL LSL_PUTMSG(ICASE__ERROPN,INFILE(1:INLEN))
	ENDIF
C
C open output file
C
	CALL IFFERM(.FALSE.)              ! turn off error messages
	CALL IFFOPN(OUTLUN,OUTFILE)
	CALL IFFERM(.TRUE.)               ! turn on error messages
	OUT_OPEN = IERCD.EQ.0
	IF (.NOT.OUT_OPEN) THEN
	   CALL LSL_PUTMSG(ICASE__ERROPN,OUTFILE(1:OUTLEN))
	ELSE
	   IF (IN_OPEN) CALL IFFSEL(INLUN)
	ENDIF
C
999	OPEN_FILES = IN_OPEN .AND. OUT_OPEN
C
	RETURN
	END
