C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-09-28 13:02:46.000000000 +0100
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
	SUBROUTINE FINDPSIZE
C
CDEC$	IDENT	'28SE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	28-Sep-1990
C
C	CONVERT SIF2IFF Utility - find feature code using lookup tables
C
C Description
C
C	Find feature code using lookup tables
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:FDF.PAR'	    	    ! limits of lookup arrays
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:TEXT.CMN'	    	    ! text for IFF
	INCLUDE 'CMN:FLAGS.CMN'	    	    ! flags
	INCLUDE 'CMN:IFF_FEATURE.CMN'	    ! iff feature info
	INCLUDE 'CMN:FDF_LOOKUP.CMN'	    ! lookup tables
	INCLUDE 'CMN:SIF2IFF.CMN'	    ! globals
C
C Functions called
C
C
C Local Variables
C
	INTEGER*4	I		    ! loop counter
C
C Search for matching height and width characteristics
C
	DO 100 I = 1,NUM_PSIZE
	   IF ((HEIGHT.EQ.PSIZE_HEIGHT(I)).AND.
     &            (TXT_WIDTH.EQ.PSIZE_WIDTH(I))) THEN
	   	 HEIGHT = PSIZE_SIZE(I)
	   	 GOTO 900
	   ENDIF
100	CONTINUE
C
C POINTSIZE not found...
C
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1001 I = 1,IPSIZE
	      IF ((HEIGHT.EQ.NF_PSIZE_HEIGHT(I)).AND.
     &            (TXT_WIDTH.EQ.NF_PSIZE_WIDTH(I))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
C
C set default pointsize
C
		 HEIGHT = 1
	         GOTO 900 
	      ENDIF
1001	   CONTINUE
C
C Not had this combination so store
C
	   IPSIZE = IPSIZE + 1
	   NF_PSIZE_HEIGHT(IPSIZE) = HEIGHT
	   NF_PSIZE_WIDTH(IPSIZE) = TXT_WIDTH
C
	   CALL LSL_PUTMSG (SIF2IFF__NOPSIZE, HEIGHT, TXT_WIDTH)
C
C set default pointsize
C
	   HEIGHT = 1
C
900	RETURN
	END
