C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-09-27 19:52:48.000000000 +0100
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
	LOGICAL FUNCTION WRITE_START
C
CDEC$	IDENT	'22FE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from IMAP2I			JMC	11-Jan-1990
C	Created					RJH	21-Oct-1987
C
C	CONVERT SIF2IFF Utility - Write header data to IFF file
C
C Description
C
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:SIF2IFF.CMN'	! global variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! feature details
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
	INCLUDE	'LSL$CMNIFF:MHDMB.CMN'	! OS style map header
	INCLUDE	'LSL$CMNIFF:MD2DES.CMN'	! map descriptor (type 2)
C
C Local Variables
C
	INTEGER		I,J,K		! DO loop/date variables
	CHARACTER*9	DAT		! date
	CHARACTER*8	TIM		! time
	BYTE		NEW_SECTION(42)	! for NS entry
C
C Assume success
C
	WRITE_START = .TRUE.
C
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
	MATV2 = 2		! type 2 will be set
	IF (HAD_CCG) THEN
	   MD2LOC(1) = DBLE( XMIN ) / UNITS
	   MD2LOC(2) = DBLE( YMIN ) / UNITS
	ELSE
	   MD2LOC(1) = XOFF
	   MD2LOC(2) = YOFF
	ENDIF
	MD2SCL = SCALE
C
C Now assemble an NS entry
C
	CALL DATE( DAT )
	CALL TIME( TIM )
	CALL EXPAND
     &	   ('%WCreated by SIF2IFF on %S at %S',NEW_SECTION,DAT,TIM)
C
C Assume that the range is something silly.
C
	   RANGE(X_MIN) =  32767
	   RANGE(X_MAX) = -32767
	   RANGE(Y_MIN) =  32767
	   RANGE(Y_MAX) = -32767
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
	CALL IFFNO( 1, 0, 0 )		! output everything in layer 1
C
C Header data now written successfully
C
	IF ((IERCD .EQ. 0) .AND. (IERNM .EQ. 1)) THEN
	   DONE_START_MAP = .TRUE.
C
C Error writing to IFF file
C
	ELSE
	   CALL LSL_PUTMSG(SIF2IFF__IFFABORTED)
	   WRITE_START = .FALSE.
	ENDIF
C
C Return
C
	RETURN
	END
