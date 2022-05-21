C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-29 15:33:36.000000000 +0100
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
	INTEGER*4 FUNCTION READLINE(RETCOD)
C
CDEC$	IDENT	'02FE90'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - read a line from magtape or a file
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
	INCLUDE 'CMN:FILES.CMN'	! files
	INCLUDE 'CMN:FLAGS.CMN'	! flags
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'	! 
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions
C
	INTEGER		FLRLIN			! read a line
	INTEGER		MTIRDB			! read from tape
C
C Arguements
C
	INTEGER*4	RETCOD			! system error code
	INTEGER*4	I,J			! loop counter
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	READLINE = 1
C
C if reading from magtape, then read then next block if the maximum
C number of records per block has been reached, then the 1st
C record of the block to TXTBUF. Otherwise copy the next record
C windowed in MTBUF into TXTBUF.
C
	IF (MAGTAPE) THEN
	   IF (REC_COUNT.EQ.MAX_RECS.OR.REC_COUNT.EQ.0)THEN
	      READLINE = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	      REC_COUNT = 1
	      MTPTR = 1
	   ELSE
	      REC_COUNT = REC_COUNT + 1
	   ENDIF
	   J = 0
	   DO 100 I = MTPTR,MTPTR+(RECSIZ-1)
	      J = J + 1
	      TXTBUF(J) = MTBUF(I)
100	   CONTINUE
	   MTPTR = MTPTR + RECSIZ
	   TXTPTR = RECSIZ
	   CALL SET_TXTLIM(RECSIZ)
	ELSE
	   CALL SET_TXTLIM(80)
	   READLINE = FLRLIN(,,,RETCOD)
	ENDIF
C
	IF (HAD_DEBUG) THEN
	  CALL WRITEF
	  CALL TTWLIN(TXTBUF,80,)
	ENDIF
C	
	CALL BSLN
C
	RETURN
	END
