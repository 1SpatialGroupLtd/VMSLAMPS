C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-08-15 18:22:16.000000000 +0100
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
        SUBROUTINE INI_FDF
C
CDEC$	IDENT   '15AU91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	14-Jan-1990
C
C	CONVERT SIF2IFF Utility - Initialisation of FDF lookup tables
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions

	INCLUDE 'CMN:FDF.PAR'		! FDF limits
C
C Arguments
C
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FDF_LOOKUP.CMN'	! FDF lookup tables
C
C Functions called
C
C
C Local Variables
C
	INTEGER		I		! loop counter
C
C----------------------------------------------------------------------------
C
C Some arrays need to be inititialised with unique values. -999 used for 
C integers, %&$ used for strings.
C 
	DO 100 I = 1,MAX_FEATS
	   FDF_STYLE(I) = 0
	   FDF_WEIGHT(I) = 0
	   FDF_LINPAT(I) = -999
	   FDF_AREAPAT(I) = -999
	   FDF_COLOUR(I) = 0
	   FDF_TXTCOL(I) = -999
	   FDF_FONT(I) = -999
	   FDF_SYM(I) = ' '
	   FDF_PATNAM(I) = '%&$'
	   FDF_FC(I) = 0
	   FDF_ARCDIR(I) = -999
	   FDF_CIRCLE(I) = 0
C
	   AREA_STYLE(I) = -999
	   AREA_WEIGHT(I) = -999
	   AREA_COLOUR(I) = -999
	   AREA_AREAPAT(I) = -999
	   AREA_PATNAM(I) = '%&$'
C
	   LINE_STYLE(I) = -999
	   LINE_WEIGHT(I) = -999
	   LINE_COLOUR(I) = -999
	   LINE_LINPAT(I) = -999
	   LINE_PATNAM(I) = '%&$'
C
	   ARC_STYLE(I) = -999
	   ARC_WEIGHT(I) = -999
	   ARC_COLOUR(I) = -999
	   ARC_LINPAT(I) = -999
	   ARC_PATNAM(I) = '%&$'
	   ARC_ARCDIR(I) = -999
C
	   TEXT_COLOUR(I) = -999
	   TEXT_FONT  (I) = -999
C
	   SYMBOL_SYMTYPE(I) = -999
	   SYMBOL_SYM(I) = ' '
C
100	CONTINUE
C
	DO 200 I = 1,MAX_PSIZE
	   NF_PSIZE_HEIGHT(I) = 0
	   NF_PSIZE_WIDTH(I) = 0
	   PSIZE_WIDTH(I) = 0
	   PSIZE_HEIGHT(I) = 0
	   PSIZE_SIZE(I) = 0
200	CONTINUE
C
	IAREA_FCS = 0		
	ILINE_FCS = 0		
	ICIRCLE_FCS = 0		
	IARC_FCS = 0		
	ITEXT_FCS = 0		
	ISYMBOL_FCS = 0		
	IPSIZE = 0		
C
	NUM_FEATS = 0		! number of features in parameter file
	NUM_PSIZE = 0		! number of pointsizes in parameter file
	FDF_PATLEN = 1
	FDF_SYMLEN = 1
C
C Return
C
	RETURN
        END
