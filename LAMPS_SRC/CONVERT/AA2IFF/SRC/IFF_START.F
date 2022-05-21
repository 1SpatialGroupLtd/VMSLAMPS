C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-19 13:44:38.000000000 +0100
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
	SUBROUTINE 	IFF_START
CDEC$	IDENT	'19AP91'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C	Created				12-Jun-1990	John Cadogan
C	Mod				11-Apr-1991	Jon Barber
C
C Description:
C
C	Write the start of the IFF file
C
	IMPLICIT NONE
C
C Common Blocks
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! current position in IFF file
	INCLUDE 'LSL$CMNIFF:MHDEF.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
C
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'			! IFF map data
	INCLUDE 'CMN:AA.CMN'			! AA map data
C
C Local Variables
	INTEGER		I,J,K		! DO loop/date variables
	CHARACTER*9	DAT		! date
	CHARACTER*8	TIM		! time
	BYTE		NEW_SECTION(42)	! for NS entry
C
	DATA CPS/0.0,1000.0,0.0,1000.0,0.0,0.0,0.0,0.0,
     &           1000.0,0.0,1000.0,0.0,1000.0,1000.0,1000.0,1000.0/
C
C-------------------------------------------------------------------------------
C Initialise FSN's
C
	FSN = 0
C
C Initialise our cubic coefficients array 
C
	DO 20 I = 1,10
	   DO 10 J = 1,2
	      CC(I,J) = 0.0
10	   CONTINUE
20	CONTINUE
C
C Set up the unit matrix for the cubic coefficients
C
	CC(2,1) = 1.0
	CC(3,2) = 1.0
C
C Leave the map header unset by default
C
	MHDESC(1) = 0
	MHDESC(2) = 0
	MHDESC(3) = 0
	MHDESC(4) = 0
C
C Set up a type 2 map descriptor
C
	SCALE = 200000
	XOFF = 0
	YOFF = 0
	ZOFF = 0
C
	MD2SCL = SCALE
	MATV2 = 2		! type 2 will be set
	MD2LOC(1) = XOFF
	MD2LOC(2) = YOFF
C
C Now assemble an NS entry
C
	CALL DATE( DAT )
	CALL TIME( TIM )
	CALL EXPAND('%WCreated by AA2IFF on %S at %S',NEW_SECTION,DAT,TIM)
C
C Assume that the range is something silly
C
	RANGE(X_MIN) =  XMIN - XOFF
	RANGE(X_MAX) =  XMAX - XOFF
	RANGE(Y_MIN) =  YMIN - YOFF
	RANGE(Y_MAX) =  YMAX - YOFF
C
C Now output all the stuff before the first feature
C
	LPOSRA = LPOSE			! remember where the RAnge is
	CALL IFFRA( RANGE )		! return & correct this later
	CALL IFFHI			! HI as new type IFF file
	CALL IFFMH( MHARR,MHLEN )	! output OS style map header
	CALL IFFMD( MD2ARR,MD2LEN )	! type 2 MD
	CALL IFFNS( NEW_SECTION, 42 )	! new section
	CALL IFFCC( CC )		! unit matrix cubic coefficients
	CALL IFFCP( CPS )		! sheet corners as corner pts
	LPOSNO = LPOSE			! remember where our NO is going
C
C Header data now written successfully
C
	DONE_START_MAP = .TRUE.
C
C Return
C
	RETURN
	END
C
