C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-02-19 15:47:02.000000000 +0000
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
	SUBROUTINE TEXT_FCODE(FCODE,LEVEL,SYMBOL)
C
CDEC$	IDENT	'19FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	18-Feb-1993
C
C Description:
C
C	Function TEXT_FCODE called from GET_TXTSIX in ARC2I.
C	It gets the VERSION 6.0 text feature code by looking up the text
C       LEVEL and SYMBOL in the lookup table - ANNO_TAB.
C
C------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'ARC2IMSG.PAR'			! ARC2I messages
C
C Common blocks
C
	INCLUDE	'COMMANDS.CMN'			! For HAD_LOG
	INCLUDE	'TABLES.CMN'			! The lookup table ANNO_TAB
	INCLUDE	'IFFINFO.CMN'			! IFF information
C
C Arguments
C
	INTEGER*2	FCODE			! The resultant feature code
	INTEGER*4	LEVEL			! The text LEVEL
	INTEGER*4	SYMBOL			! The text SYMBOL
C
C Local Variables
C
	INTEGER*4	I			! Loop counter
C
C------------------------------------------------------------------------------
C
C Use null FC to check at end if it was set
C
	FCODE = -1
C
	DO 100 I = 1,ANNO_PTR
	   IF (ANNO_TAB(ANNO_LEV,I).EQ.-1) THEN
	      IF (ANNO_TAB(ANNO_SYM,I).EQ.SYMBOL) THEN
C
C FC derived from SYMBOL only
C
		 FCODE = ANNO_TAB(ANNO_FC,I)
		 GOTO 900
	      ENDIF
	   ENDIF
C
	   IF (ANNO_TAB(ANNO_SYM,I).EQ.-1) THEN
	      IF (ANNO_TAB(ANNO_LEV,I).EQ.LEVEL) THEN
C
C FC derived from LEVEL only
C
		 FCODE = ANNO_TAB(ANNO_FC,I)
		 GOTO 900
	      ENDIF
	   ENDIF
C
	   IF ((ANNO_TAB(ANNO_LEV,I).EQ.LEVEL) .AND.
     &	       (ANNO_TAB(ANNO_SYM,I).EQ.SYMBOL)) THEN
C
C FC derived from LEVEL amnd SYMBOL
C
	      FCODE = ANNO_TAB(ANNO_FC,I)
	      GOTO 900
	   ENDIF
100	CONTINUE
C
C Report a warning if feature code was not found in parameter file
C
	IF (FCODE.EQ.-1.AND.HAD_LOG) THEN
	   CALL LSL_PUTMSG(ARC2I__DEFAULTFC,LEVEL,SYMBOL)
	ENDIF
	FCODE = TEXT_FC
C
900	RETURN
	END
