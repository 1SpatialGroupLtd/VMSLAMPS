C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-04-07 13:30:50.000000000 +0100
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
	SUBROUTINE	START_FEATURE
CDEC$	IDENT	'07AP93'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C	Created				9-Nov-1989	A.P.Brown
C	Mod				9-Apr-1991	J Barber
C
C Description:
C
C	Start a new feature.
C
C	AA2IFF:
C 	This routine is called by AA2IFF before all the coords have been
C	read, so the default of 0 may give a line FC for a one point symbol
C
C	AAGAZ2IFF:
C	IS_TEXT true signifies called by AAGAZ2IFF, so check that the FC
C	(either from par file or default of 999 if missing from supplied
C	par file; or AA code derivation for no par file) is a TEXT
C
C
	IMPLICIT	NONE
C
C parameter files
C
	INCLUDE	'LSL$CMNFRT:FRTCOM.CMN'	! FRT definitions
C
C common blocks
C
	INCLUDE 'CMN:AA2IFFMSG.PAR'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C functions
	LOGICAL		FRTFND
C
C workspace
C
	INTEGER*2	ISTAT(4)	! for the FS entry
	LOGICAL		OK
C
	DATA	HEIGHT  / 6 /		! Fixed pointsize
C
C-------------------------------------------------------------------------------
C calculate all the bits of the FS entry
C
	ISTAT(1) = FC
C
	ISTAT(2) = 0
	ISTAT(3) = 0
C
C AA2IFF feature codes are linear by default, unles the parameter file 
C specifies a symbol FC for single coordinate entries
C AAGAZ2IFF feature codes are always texts and IS_TEXT .TRUE.
C
C Check FRT file for supplied FC's to get GT 
C
	IF (HAD_PAR) THEN
	   IF (DEFAULT_FC) THEN
	      IF (IS_SYMBOL .OR. IS_TEXT) THEN
	         FC = 999
	      ELSE
	         FC = 0
	      ENDIF
	   ENDIF
C
	   OK = FRTFND(FC,.FALSE.)
	   IF (OK) THEN				! FC not found
	      CALL LSL_PUTMSG(AA2I__ERRFNDFC, FC)
	      GOTO 99
	   ENDIF
C
	   IF (IS_SYMBOL) THEN
	      IF (FRTGT.NE.UNOTYP .AND. FRTGT.NE.ORITYP .AND.
     &	          FRTGT.NE.SCATYP .AND. HAD_LOG) CALL LSL_PUTMSG
     &				(AA2I__NOTSYMBFTR,FC,CODENUM)
C
	   ELSEIF (IS_TEXT) THEN
	      IF (FRTGT.NE.TEXTYP .AND. HAD_LOG) CALL LSL_PUTMSG
     &				(AA2I__NOTTEXTFTR,FC,CODENUM)
C
	   ELSE
	      IF (FRTGT.NE.LINTYP .AND. FRTGT.NE.CURTYP .AND.
     &	          FRTGT.NE.STRTYP .AND. FRTGT.NE.ARETYP .AND. 
     &			HAD_LOG) CALL LSL_PUTMSG
     &				(AA2I__NOTLINEFTR,FC,CODENUM)
	   ENDIF
	ENDIF
C
C for texts (set in AAGAZ2IFF), assume we have the digitised position
C
99	IF (IS_TEXT) THEN
	   CALL LIB$INSV( JUSTIF,   0, 4, ISTAT(3) )
	   CALL LIB$INSV( STYLE,    4, 2, ISTAT(3) )
	   CALL LIB$INSV( CATEGORY, 6, 6, ISTAT(3) )
	   ISTAT(3) = ISTAT(3).OR.'8000'X   ! bits 14-15 = 2 (text)
	ELSEIF ( IS_SYMBOL ) THEN
	   ISTAT(3) = ISTAT(3).OR.'4000'X   ! bits 14-15 = 1 (symbol)
	ENDIF
C
C so write the FS entry
C
	CALL IFFFS( ISTAT )
C
C Write a fixed Text Height (pointsize 6)
C
 	IF (IS_TEXT) CALL IFFTH(HEIGHT)
C
C signal pen up for the first ST
C
	PEN_UP = .TRUE.
C
C and we haven't output any ZS/ST's for this feature yet
C
	DONE_ZS = .FALSE.
C
C so we've finished START_FEATURE
C
	DONE_START_FEATURE = .TRUE.
C
C and that's it
C
	RETURN
	END
C
