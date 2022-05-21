C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-22 17:53:14.000000000 +0100
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
	INTEGER*4 FUNCTION RDPAR
C
CDEC$	IDENT	'22SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created (based on AUTOTEXT READ_PAR)		RJH	 9-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Read Parameter File
C
C Description
C
C	Reads the parameter file which relates IFF feature codes to MAPDATA
C	feature codes.
C
C	Returns the error code held in LSL_STATUS if something drastic goes
C	wrong, LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'($STSDEF)/NOLIST'
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
	INCLUDE 'CMN:LUN.PAR'			! logical unit numbers
C
C Common Blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB filename expansion
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
	INCLUDE	'CMN:FILES.CMN'      		! filenames
	INCLUDE	'CMN:CONTROL.CMN'      		! control variables
C
C Functions called
C
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file open for reading
	INTEGER*4	FLRLIN		! read in line from file
C
	INTEGER*4	RDLIN		! decode current line
C
	INTEGER*4	SET_AC_DETAILS	! set up AC codes and names
C
C Local Variables
C
	INTEGER*4	LINE		! count line numbers
C
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
C
C Assume that everything goes well
C
	RDPAR = LSL__NORMAL
C
C Clear parameter tables
C
	FC_NUM = 0			! number of entries
C
C Open parameter file, read only
C
	ERRCOD = FLROPN(PARLUN,PARFIL(1:PARLEN),RETCOD)
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2MD__ERROPNPAR,PARFIL(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
C
	IF (HAD_LOG) CALL LSL_PUTMSG(I2MD__READPAR,PARFIL(1:PARLEN))
C
C and initialise line number
C
	LINE = 0
C
C Get the next line from the file
C
500	LINE = LINE+1
C
	ERRCOD = FLRLIN(,,,RETCOD)
	IF (ERRCOD .EQ. LSL__EOF) GOTO 800
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2MD__ERRRDPAR,PARFIL(1:PARLEN),LINE)
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
C
C Now decode the line
C
	IF (.NOT. RDLIN(LINE)) GOTO 800
	GOTO 500
C
C Close the file
C
800	ERRCOD = FLRCLO(PARLUN,RETCOD)
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2MD__ERRCLOPAR,PARFIL(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
C
	IF (.NOT.LSL_STATUS .AND. IBITS(LSL_STATUS,0,3).NE.STS$K_WARNING)
     &	     GOTO 9999			! deal with errors from RDLIN
C
C Ensure all AC codes and names are set up
C
	IF (.NOT. SET_AC_DETAILS()) GOTO 9999
C
C Check that we have at least one FC
C
	IF (FC_NUM .LE. 0) THEN
	   CALL LSL_PUTMSG(I2MD__NOCODES)
	   GOTO 9999
	ENDIF
C
C Report statistics
C
	IF (HAD_LOG) CALL LSL_PUTMSG(I2MD__CODES,FC_NUM)
C
	GOTO 10000
C
C Failure
C
9999	RDPAR = LSL_STATUS
C
C Return
C
10000	RETURN
	END
