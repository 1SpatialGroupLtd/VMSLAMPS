C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-01-28 10:32:58.000000000 +0000
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
	LOGICAL FUNCTION CREATE_IFF
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Nov-1990
C
C Description:
C
C	Module CREATE_IFF called by ARC2I in package CONVERT
C	Creates the output IFF file and writes the basic header information.
C	The RA is not written, but marked so that it can be written after all
C	points save been read in.
C	
C-------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNIFF:IFFHAN.CMN'		! IFFLIB interface
	INCLUDE	'LSL$CMNIFF:MHDEF.CMN'		! Default Map header
	INCLUDE	'LSL$CMNIFF:MD2DES.CMN'		! Default Map descriptor
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:IFFINFO.CMN'		! IFF information
C
C Functions
C
	LOGICAL		IFFCREATE		! Create a new IFF file
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
	INTEGER*4	I,J			! Loop counters
	CHARACTER*9	DAT			! date
	CHARACTER*8	TIM			! time
 	REAL		CC(10,2)		! cubic coefficients
	BYTE		NEW_SECTION(41)		! for NS entry
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	STATUS = .TRUE.
C
C Open IFF disk file for write.
C
	STATUS = IFFCREATE( IFFLUN, IFFFILE(1:IFFLEN),,,, )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS )
	   GOTO 9000
	ENDIF
C
	CALL WRITEF('IFF file %S created.',IFFFILE(1:IFFLEN))
C
	LPOSRA = LPOSE			! Save pos of RAange to patch in later
	CALL IFFRA( RANGE )
	CALL IFFHI
	CALL IFFMH( MHARR, MHLEN )
	MATV2 = 2			! type 2 will be set
C
C write Map Descriptor with scale (if have one)
C
	IF ( HAD_SCALE ) MD2SCL = SCALE
	CALL IFFMD( MD2ARR,MD2LEN )	! type 2 MD
C
C assemble an NS entry
C
	CALL DATE( DAT )
	CALL TIME( TIM )
	CALL EXPAND('%WCreated by ARC2I on %S at %S',
     &	   NEW_SECTION,DAT,TIM)
	CALL IFFNS( NEW_SECTION, 41 )	! new section
C
C set up our cubic coefficients array - the same for all sheets
C
	DO 20 I = 1,10
	   DO 10 J = 1,2
	      CC(I,J) = 0.0
10	   CONTINUE
20	CONTINUE
C
C set up the unit matrix
C
	CC(2,1) = 1.0
	CC(3,2) = 1.0
	CALL IFFCC( CC )		! unit matrix cubic coefficients
	CALL IFFCP( CPS )		! sheet corners as corner pts
C
	LPOSNO = LPOSE			! remember where our NO is going
	CALL IFFNO( 1, 0, 0 )		! output everything in layer 1
C
C Did an error occur?
C
	IF (IERCD.NE.0) THEN 
	   CALL LSL_PUTMSG( ARC2I__ERRIFF )	! Error creating IFF file
	   CALL IFFERR
	   STATUS = IERCD
	ENDIF
C
9000	CREATE_IFF = STATUS
C
	RETURN
	END
