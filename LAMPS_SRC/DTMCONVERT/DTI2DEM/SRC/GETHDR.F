C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-26 13:54:56.000000000 +0100
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
	LOGICAL FUNCTION GETHDR
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	22-Nov-1985
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C 	
C	Get the header from the user for the DEM
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE		'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE		'($RMSDEF)'
C
C Common blocks
C
        INCLUDE     	'LSL$DTI2DEM:DEMA.CMN'
    	INCLUDE     	'LSL$DTI2DEM:GENERAL.CMN'
C
C Functions
C
	INTEGER		TTRSTR
	INTEGER		EXPAND
C
C Local variables
C
	INTEGER		STATUS
	INTEGER		NUMCH
	CHARACTER*256	TEMP
	CHARACTER*80	PROMPT
	INTEGER*4	PROMPTL
C
C-------------------------------------------------------------------------------
C
C Generate prompt string 
C
	PROMPTL=EXPAND('%WSEnter header for DEM (%S): ',PROMPT,
     &	               DEMNAM(1:DEMNAML))
C
C and get header
C
	STATUS=TTRSTR(TEMP,NUMCH,PROMPT(1:PROMPTL),GETHDR)
	IF ( .NOT.STATUS ) THEN
	   IF (GETHDR.NE.RMS$_EOF) THEN
	      CALL LSL_PUTMSG( DTI2DEM__BADHDR )
	      CALL LSL_ADDMSG( GETHDR )
	   ENDIF
	   GOTO 900
	ELSEIF (NUMCH.NE.0) THEN
	   DEMNAM = TEMP
	   DEMNAML = NUMCH
	ENDIF
C
	GETHDR=.TRUE.
C
  900	CONTINUE
	RETURN
	END
