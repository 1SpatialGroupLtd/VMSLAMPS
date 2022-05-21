C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1995-05-30 11:37:22.000000000 +0100
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
	LOGICAL FUNCTION RDFDF
C
CDEC$	IDENT	'30MY95'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from IMAP2I and modified	JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read FDF entry
C
C Description
C
C	Reads an FDF table entry
C
C	Expects the secondary command number just read to be in 
C		SECMDN    in /CMDCOM/
C
C	Returns FALSE if something goes wrong with a command line, 
C	TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'CMN:FDF.PAR'	    	    ! FDF parameters
C
C Common Blocks
C
	INCLUDE 'CMN:FDF_LOOKUP.CMN'
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		READ_NAM	! read attribute name
	LOGICAL		RDLONG		! read long integer
C
C Local Variables
C
	INTEGER*4	RESULT		! command read result
	LOGICAL		NOINT		! returned integer flag
	INTEGER*4	IPAR		! integer parameter
C
C Assume that everything goes well
C
	RDFDF = .TRUE.
C
C Advance pointer to next position in FDF lookup arrays
C
	NUM_FEATS = NUM_FEATS + 1
C
C Despatch according to secondary command
C
	GOTO (100,200,300,100,100,100,100) SECMDN
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,SECNST)	! unknown command
	GOTO 9999
C
C FDF LINE or FDF AREA - we have already read the line so check that 
C it is in range 
C
100	IF ( INTARG(1).LT.0 .OR. INTARG(1).GT.MAX_STYLE ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADLINE,INTARG(1))
	   GOTO 9999
	ENDIF
	IF ( INTARG(2).LT.0 .OR. INTARG(2).GT.MAX_COLOUR ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADCOLOUR,INTARG(2))
	   GOTO 9999
	ENDIF
	IF ( INTARG(3).LT.0 .OR. INTARG(3).GT.MAX_WEIGHT ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADWEIGHT,INTARG(3))
	   GOTO 9999
	ENDIF
	IF ( INTARG(4).LT.0 .OR. INTARG(4).GT.MAX_PATTERN ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADPATTERN,INTARG(4),MAX_PATTERN)
	   GOTO 9999
	ENDIF
C
	IF (.NOT. READ_NAM(FDF_PATNAM(NUM_FEATS),FDF_PATLEN)) THEN
	    FDF_PATLEN = 1
	   GOTO 9999
	ENDIF
C
C If arc look for direction parameter
C
	IF (SECMDN.EQ.5) THEN
	   NOINT = RDLONG(IPAR)
	   IF (NOINT) THEN
	      CALL LSL_PUTMSG(SIF2IFF__NOARCDIR)
	      GOTO 9999
	   ELSE IF (IPAR.LT.-1.OR.IPAR.GT.1) THEN
	      CALL LSL_PUTMSG(SIF2IFF__BADARCDIR,IPAR)
	      GOTO 9999
	   ENDIF
	   FDF_ARCDIR(NUM_FEATS) = IPAR
	ENDIF
C
C If circle then set flag.
C
	IF (SECMDN.EQ.4) FDF_CIRCLE(NUM_FEATS) = 1
C
C Add to line style, weight and colour lookup arrays
C
	FDF_STYLE(NUM_FEATS) = INTARG(1)
	FDF_COLOUR(NUM_FEATS) = INTARG(2)
	FDF_WEIGHT(NUM_FEATS) = INTARG(3)
	IF (SECMDN.EQ.7) THEN
	   FDF_AREAPAT(NUM_FEATS) = INTARG(4)
	ELSE
	   FDF_LINPAT(NUM_FEATS) = INTARG(4)
	ENDIF
C
	GOTO 900
C
C FDF SYMBOL - read in the symbol name and type and add to lookup array
C
200	IF ( INTARG(1).LT.0 .OR. INTARG(1).GT.1 ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADSYMTYPE,INTARG(1))
	   GOTO 9999
	ENDIF
	FDF_SYMTYPE(NUM_FEATS) = INTARG(1)
	IF (.NOT. READ_NAM(FDF_SYM(NUM_FEATS),FDF_SYMLEN)) GOTO 9999
C
	GOTO 900
C
C FDF TEXT- we have already read the line so check that it is in range
C
300	IF ( INTARG(1).LT.0 .OR. INTARG(1).GT.MAX_FONT ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADFONT,INTARG(1))
	   GOTO 9999
	ENDIF
C
C Add to font lookup array
C
	FDF_FONT(NUM_FEATS) = INTARG(1)
C
C Get the colour
C
	NOINT = RDLONG(IPAR)
	IF ( IPAR.LT.0.OR.IPAR.GT.MAX_COLOUR ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADCOLOUR,IPAR)
	   GOTO 9999
	ENDIF
	FDF_TXTCOL(NUM_FEATS) = IPAR
	
C
C Now get the feature code and add to FC lookup array
C
900	NOINT = RDLONG(FDF_FC(NUM_FEATS))
	IF (NOINT) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADFC,FDF_FC(NUM_FEATS))
	   GOTO 9999
	ENDIF
	IF (FDF_FC(NUM_FEATS).LT.0.OR.FDF_FC(NUM_FEATS).GT.MAX_FCS) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADFC,FDF_FC(NUM_FEATS))
	   GOTO 9999
	ENDIF
C
C and finish
C
	GOTO 9000			! success
C
C Errors
C
9999	RDFDF = .FALSE.			! failure
C
C Return
C
9000	RETURN
	END
