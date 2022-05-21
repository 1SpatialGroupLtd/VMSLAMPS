C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-09-27 11:35:56.000000000 +0100
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
	LOGICAL FUNCTION FINDFC
C
CDEC$	IDENT	'19JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
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
C Assume success
C
	FINDFC = .TRUE.
C
C If /CCG used then FCs are already assigned so skip this
C
	IF (HAD_CCG) GOTO 900
C
C
C Search for matching line characteristics
C
	IF (IS_LINE) THEN
	   DO 100 I = 1,NUM_FEATS
	      IF ((LINWGT.EQ.FDF_WEIGHT(I)).AND.
     &            (LINSTY.EQ.FDF_STYLE(I)).AND.
     &            (LINCOL.EQ.FDF_COLOUR(I)).AND.
     &            (LINPAT.EQ.FDF_LINPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.FDF_PATNAM(I)(1:FDF_PATLEN)).AND.
     &  	  (FDF_CIRCLE(I).EQ.0)) THEN
	   	 FC = FDF_FC(I)
	   	 GOTO 900
	      ENDIF
100	   CONTINUE
	ELSE IF (IS_TEXT) THEN
C
C Search for matching text characteristics
C
	   DO 200 I = 1,NUM_FEATS
	      IF (FONT.EQ.FDF_FONT(I).AND.LINCOL.EQ.FDF_TXTCOL(I)) THEN
	   	 FC = FDF_FC(I)
	   	 GOTO 900
	      ENDIF
200	   CONTINUE
	ELSE IF (IS_SYMBOL) THEN
C
C Search for matching symbol characteristics
C
	   DO 300 I = 1,NUM_FEATS
	      IF ((TEXT(1:NCHS).EQ.FDF_SYM(I)(1:NCHS)).AND.
     &		   (SYMTYPE.EQ.FDF_SYMTYPE(I))) THEN
	   	 FC = FDF_FC(I)
	   	 GOTO 900
	      ENDIF
300	   CONTINUE
	ELSE IF (IS_AREA) THEN
C
C Search for matching area characteristics
C
	   DO 400 I = 1,NUM_FEATS
	      IF ((LINWGT.EQ.FDF_WEIGHT(I)).AND.
     &            (LINSTY.EQ.FDF_STYLE(I)).AND.
     &            (LINCOL.EQ.FDF_COLOUR(I)).AND.
     &            (AREAPAT.EQ.FDF_AREAPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.FDF_PATNAM(I)(1:FDF_PATLEN))) THEN
	   	 FC = FDF_FC(I)
	   	 GOTO 900
	      ENDIF
400	   CONTINUE
C
C Search for matching arc characteristics
C
	ELSE IF (IS_ARC) THEN
	   DO 500 I = 1,NUM_FEATS
	      IF ((LINWGT.EQ.FDF_WEIGHT(I)).AND.
     &            (LINSTY.EQ.FDF_STYLE(I)).AND.
     &            (LINCOL.EQ.FDF_COLOUR(I)).AND.
     &            (LINPAT.EQ.FDF_LINPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.FDF_PATNAM(I)(1:FDF_PATLEN)).AND.
     &            (ARCDIR.EQ.FDF_ARCDIR(I))) THEN
	   	 FC = FDF_FC(I)
	   	 GOTO 900
	      ENDIF
500	   CONTINUE
C
C Search for matching circle characteristics
C
	ELSE IF (IS_CIRCLE) THEN
	   DO 600 I = 1,NUM_FEATS
	      IF ((LINWGT.EQ.FDF_WEIGHT(I)).AND.
     &            (LINSTY.EQ.FDF_STYLE(I)).AND.
     &            (LINCOL.EQ.FDF_COLOUR(I)).AND.
     &            (LINPAT.EQ.FDF_LINPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.FDF_PATNAM(I)(1:FDF_PATLEN)).AND.
     &  	  (FDF_CIRCLE(I).EQ.1)) THEN
	   	 FC = FDF_FC(I)
	   	 GOTO 900
	      ENDIF
600	   CONTINUE
	ENDIF
C
C FC not found...
C
	FINDFC = .FALSE.
C
C No FC for a LINE, CURVE, or CIRCLE
C
	IF (IS_LINE) THEN
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1001 I = 1,ILINE_FCS
	      IF ((LINSTY.EQ.LINE_STYLE(I)).AND.
     &            (LINCOL.EQ.LINE_COLOUR(I)).AND.
     &            (LINWGT.EQ.LINE_WEIGHT(I)).AND.
     &            (LINPAT.EQ.LINE_LINPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.LINE_PATNAM(I)(1:FDF_PATLEN))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
	         GOTO 900 
	      ENDIF
1001	   CONTINUE
C
C Not had this combination so store
C
	   ILINE_FCS = ILINE_FCS + 1
	   LINE_STYLE(ILINE_FCS) = LINSTY
	   LINE_COLOUR(ILINE_FCS) = LINCOL
	   LINE_WEIGHT(ILINE_FCS) = LINWGT
	   LINE_LINPAT(ILINE_FCS) = LINPAT
	   LINE_PATNAM(ILINE_FCS)(1:FDF_PATLEN) = PATNAM(1:FDF_PATLEN)
C
	   CALL LSL_PUTMSG (SIF2IFF__NOLINEFC, LINSTY, LINCOL,
     &  	LINWGT, LINPAT, PATNAM(1:FDF_PATLEN))		!Warning message
	ENDIF
C
C No FC for a CIRCLE
C
	IF (IS_CIRCLE) THEN
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1006 I = 1,ICIRCLE_FCS
	      IF ((LINSTY.EQ.CIRCLE_STYLE(I)).AND.
     &            (LINCOL.EQ.CIRCLE_COLOUR(I)).AND.
     &            (LINWGT.EQ.CIRCLE_WEIGHT(I)).AND.
     &            (LINPAT.EQ.CIRCLE_LINPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.CIRCLE_PATNAM(I)(1:FDF_PATLEN))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
	         GOTO 900 
	      ENDIF
1006	   CONTINUE
C
C Not had this combination so store
C
	   ICIRCLE_FCS = ICIRCLE_FCS + 1
	   CIRCLE_STYLE(ICIRCLE_FCS) = LINSTY
	   CIRCLE_COLOUR(ICIRCLE_FCS) = LINCOL
	   CIRCLE_WEIGHT(ICIRCLE_FCS) = LINWGT
	   CIRCLE_LINPAT(ICIRCLE_FCS) = LINPAT
	   CIRCLE_PATNAM(ICIRCLE_FCS)(1:FDF_PATLEN) = PATNAM(1:FDF_PATLEN)
C
	   CALL LSL_PUTMSG (SIF2IFF__NOCIRCFC, LINSTY, LINCOL,
     &  	LINWGT, LINPAT, PATNAM(1:FDF_PATLEN))		!Warning message
	ENDIF
C
C No FC for an ARC
C
	IF (IS_ARC) THEN
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1002 I = 1,IARC_FCS
	      IF ((LINSTY.EQ.ARC_STYLE(I)).AND.
     &            (LINCOL.EQ.ARC_COLOUR(I)).AND.
     &            (LINWGT.EQ.ARC_WEIGHT(I)).AND.
     &            (LINPAT.EQ.ARC_LINPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.ARC_PATNAM(I)(1:FDF_PATLEN)).AND.
     &            (ARCDIR.EQ.ARC_ARCDIR(I))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
	         GOTO 900 
	      ENDIF
1002	   CONTINUE
C
C Not had this combination so store
C
	   IARC_FCS = IARC_FCS + 1
	   ARC_STYLE(IARC_FCS) = LINSTY
	   ARC_COLOUR(IARC_FCS) = LINCOL
	   ARC_WEIGHT(IARC_FCS) = LINWGT
	   ARC_LINPAT(IARC_FCS) = LINPAT
	   ARC_PATNAM(IARC_FCS)(1:FDF_PATLEN) = PATNAM(1:FDF_PATLEN)
	   ARC_ARCDIR(IARC_FCS) = ARCDIR
C
	   CALL LSL_PUTMSG (SIF2IFF__NOARCFC, LINSTY, LINCOL,
     &  	LINWGT, LINPAT, PATNAM(1:FDF_PATLEN), ARCDIR)	!Warning message
	ENDIF
C
C No FC for a TEXT
C
	IF (IS_TEXT) THEN
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1003 I = 1,ITEXT_FCS
     	      IF ((LINCOL.EQ.TEXT_COLOUR(I)).AND.
     &            (FONT.EQ.TEXT_FONT(I))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
	         GOTO 900 
	      ENDIF
1003	   CONTINUE
C
C Not had this combination so store
C
	   ITEXT_FCS = ITEXT_FCS + 1
	   TEXT_COLOUR(ITEXT_FCS) = LINCOL
	   TEXT_FONT(ITEXT_FCS) = FONT
C
	   CALL LSL_PUTMSG (SIF2IFF__NOTEXTFC, FONT, LINCOL) 	!Warning message
	ENDIF
C
C No FC for a SYMBOL
C
	IF (IS_SYMBOL) THEN
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1004 I = 1,ISYMBOL_FCS
	      IF ((TEXT(1:NCHS).EQ.SYMBOL_SYM(I)(1:NCHS)).AND.
     &		   (SYMTYPE.EQ.SYMBOL_SYMTYPE(I))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
	         GOTO 900 
	      ENDIF
1004	   CONTINUE
C
C Not had this combination so store
C
	   ISYMBOL_FCS = ISYMBOL_FCS + 1
	   SYMBOL_SYM(ISYMBOL_FCS)(1:NCHS) = TEXT(1:NCHS)
	   SYMBOL_SYMTYPE(ISYMBOL_FCS) = SYMTYPE
C
	   CALL LSL_PUTMSG (SIF2IFF__NOSYMFC, SYMTYPE,
     &  	TEXT(1:NCHS))				!Warning message
	ENDIF
C
C No FC for an area
C
	IF (IS_AREA) THEN
C
C Check if we've already had this combination. If so dont need to report it
C again.
C
	   DO 1005 I = 1,IAREA_FCS
	      IF ((LINSTY.EQ.AREA_STYLE(I)).AND.
     &            (LINCOL.EQ.AREA_COLOUR(I)).AND.
     &            (LINWGT.EQ.AREA_WEIGHT(I)).AND.
     &            (AREAPAT.EQ.AREA_AREAPAT(I)).AND.
     &		  (PATNAM(1:FDF_PATLEN).EQ.AREA_PATNAM(I)(1:FDF_PATLEN))) THEN
C
C Had this combination so don't report
C
		 NOLINEMESS = .TRUE.
	         GOTO 900 
	      ENDIF
1005	   CONTINUE
C
C Not had this combination so store
C
	   IAREA_FCS = IAREA_FCS + 1
	   AREA_STYLE(IAREA_FCS) = LINSTY
	   AREA_COLOUR(IAREA_FCS) = LINCOL
	   AREA_WEIGHT(IAREA_FCS) = LINWGT
	   AREA_AREAPAT(IAREA_FCS) = AREAPAT
	   AREA_PATNAM(IAREA_FCS)(1:FDF_PATLEN) = PATNAM(1:FDF_PATLEN)
C
	   CALL LSL_PUTMSG (SIF2IFF__NOAREAFC, LINSTY, LINCOL,
     &  	 LINWGT, AREAPAT, PATNAM(1:FDF_PATLEN))		!Warning message
	ENDIF
C
900	RETURN
	END
