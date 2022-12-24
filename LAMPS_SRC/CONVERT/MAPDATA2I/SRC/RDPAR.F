C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-27 17:42:08.000000000 +0100
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
	LOGICAL FUNCTION RDPAR
CDEC$	IDENT	'27SE94'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Jon Barber				21-Mar-1991
C	Ripped off from DSTPARLIB
C	Mod 1400. Tailored to reflect MAPDATA2I design.	1-Sep-1994	ST
C
C	CONVERT MAPDATA2I Utility - to read parameter file 
C
C Description
C
C	This function reads the parameter file which relates MAPDATA
C	feature codes (and optional curved line flags) to IFF 
C	feature codes
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'	! LSLLIB READSTR definitions
	INCLUDE 'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! for exit status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE 'CMN:TOLERANCES.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C Local Parameters
C
	BYTE		PLING			! comment delimiter
	PARAMETER	(PLING = '!')
C
C Functions called
C
	INTEGER*4	FLROPN		! open file
	INTEGER*4	FLRCLO		! close file
	INTEGER*4	FLRLIN		! read in a line from file
	INTEGER*4	READSTR		! read a string
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDINT		! read next integer
	LOGICAL		RDLONG		! read next integer
	LOGICAL		FRTINI		! open FRT file
	INTEGER*4	RDLIN		! decode current line
	INTEGER*4	SET_AC_DETAILS	! set up AC codes and names
C
C Local Variables
C
	INTEGER*4	I,J
	INTEGER*4	LEN
	INTEGER*4	RESULT		! command read result
	INTEGER*4	RETCOD		! system error code
	BYTE		SINGCHAR	! character read
	INTEGER*4	LINE		! line number
	INTEGER*2	FCODE		! FC
	CHARACTER*1	TMPCHAR
	CHARACTER*32	ACODE
	CHARACTER*80	FEATINTERP
	LOGICAL		FAILED
C
C External declaration
C
	INTEGER*4	PARCMD_CMD_TABLE
	EXTERNAL	PARCMD_CMD_TABLE
C
C------------------------------------------------------------------------------
C Initialise FRT file for the GT's of the FC's in the parameter file
C
	IF (HAD_FRT) THEN
	   FAILED = FRTINI(FRTFILE(1:FRTLEN))
	   IF (FAILED) THEN
	      CALL LSL_PUTMSG(MD2I__ERROPNFRT, FRTFILE(1:FRTLEN))
	      RDPAR = MD2I__ERROPNFRT
	      GOTO 9999
	   ELSE
	      IF (HAD_LOG) CALL LSL_PUTMSG(MD2I__OPNFRT,FRTFILE(1:FRTLEN))
	   ENDIF
	ELSE
	   CALL FRT_ACDINI
	ENDIF
C
C------------------------------------------------------------------------------
C Open PARAMETER file, read only
C
	RDPAR = FLROPN(PARLUN,PARFILE(1:PARLEN),RETCOD)
C
C If unsuccessful, output message and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(MD2I__ERROPNPAR,PARFILE(1:PARLEN))
	   RDPAR = MD2I__ERROPNPAR
	   GOTO 9999
	ENDIF
C
	IF (HAD_LOG) CALL LSL_PUTMSG(MD2I__OPNPAR,PARFILE(1:PARLEN))
C
C------------------------------------------------------------------------------
C
	LINE = 0
	FC_CNT = 0
C
C Get a line
C
500	LINE = LINE + 1
C
	RDPAR = FLRLIN(,,,RETCOD)
C
	IF (RDPAR.EQ.LSL__EOF) THEN
	   RDPAR = LSL__NORMAL		! not an error
	   GOTO 800
	ENDIF
C
C If unsuccessful, output message, and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(MD2I__ERRRDPAR,LINE)
	   CALL LSL_ADDMSG(RDPAR)
	   GOTO 9999
	ENDIF
C
C Now decode the line
C
	RDPAR = RDLIN(LINE)
	FAILED = .NOT.RDPAR
	IF (FAILED) GOTO 800
	GOTO 500
C
C Close the PARAMETER file
C
800	RDPAR = FLRCLO(PARLUN,RETCOD)
	IF (.NOT. RDPAR) THEN
	   CALL LSL_PUTMSG(MD2I__ERRCLOPAR,PARFILE(1:PARLEN))
	   CALL LSL_ADDMSG(RDPAR)
	   IF (RDPAR .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
C
C If RDLIN had an error in the parameter file, we should end this routine
C rather than calling SET_AC_DETAILS and any messages.
C
	IF (FAILED) THEN
	   RDPAR = 0				! restore code for failure
	   GOTO 9999
	ENDIF
C
C Ensure all AC codes and names are set up
C
	RDPAR = SET_AC_DETAILS()
	IF (.NOT.RDPAR) GOTO 9999
C
C Check that we have at least one FC
C
	IF (FC_CNT.LE.0) THEN
	   CALL LSL_PUTMSG(MD2I__NOPARFC)
	   RDPAR = MD2I__NOPARFC
	   GOTO 9999
	ENDIF
C
C report statistics
C
	IF (HAD_LOG) CALL LSL_PUTMSG(MD2I__FCFND,FC_CNT)
C
C------------------------------------------------------------------------------
C
9999	RETURN
	END
C
