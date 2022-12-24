C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-07-19 12:05:16.000000000 +0100
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
	SUBROUTINE 	CONGAZ
CDEC$	IDENT	'19JL94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C	Created				11-Jun-1990	John Cadogan
C	Mod				16-Apr-1991	Jon Barber
C
C Description:
C
C	Process the AA file
C
	IMPLICIT	NONE
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! current position in IFF file
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
C
	INCLUDE 'CMN:AA2IFFMSG.PAR'
	INCLUDE 'CMN:AA.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
	INTEGER		STATUS
	INTEGER*2	IECODE		! IFF entry type
	INTEGER*2	IELEN		! IFF entry length
C
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		RDLONG
	LOGICAL		READSTR
	LOGICAL		RDINT
C
	INTEGER		LEN,CATLEN,LEVLEN
	INTEGER		I
	INTEGER*2	OLDLAYER
	INTEGER*2	LAYER
	INTEGER		NUM
	INTEGER		COUNTY
	REAL*8		X,Y
	LOGICAL		FIRST_FEATURE
	LOGICAL		OUTPUT
C
	BYTE		CHARBYTE
	INTEGER*4	CHARINT
	EQUIVALENCE	(CHARINT,CHARBYTE)
C
C Record types
C
	CHARACTER*1	CAT,LEV
	CHARACTER*32	ACODE
	CHARACTER*80	TEXT
	BYTE		TXBUF(80)
	INTEGER*2	NCHS
C
C-------------------------------------------------------------------------------
C
	OUTPUT  = .TRUE.
	IS_TEXT = .TRUE.
	FIRST_FEATURE = .TRUE.
	HAD_RANGE_SET = .FALSE.
	FSN    = 0
	RECNUM = 0
C
	CALL IFF_START				! Write start of IFF file
	IF (HAD_PAR) CALL IFFNO(1,0,0)		! start new layer
C
	CALL FLRSEL(AALUN)
C
500	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	IF ( STATUS .EQ. LSL__EOF ) THEN
	   STATUS = LSL__NORMAL			! not an error
	   GOTO 999
	ENDIF
C
	CALL BSLN
C
C read the name text string
C
	LEN = READSTR(TEXT)
C	IF (OUTPUT) CALL WRITEF( 'Record #%^L%I0 is type %S',
C     &					RECNUM,TEXT(1:LEN) )
	NCHS = LEN
C
C County Number
C
	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	CALL BSLN
	STATUS = RDLONG(COUNTY)
C
C Grid coords
C
	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	CALL BSLN
	STATUS = RDLONG(NUM)
	X = NUM
	STATUS = RDLONG(NUM)
	Y = NUM
	CALL COORD2D(X,Y)
C
C Short Reference
C
	IF (HAD_FULL) THEN
	   RECNUM = RECNUM + 1
	   STATUS = FLRLIN()
	ENDIF
C
C Category/FC
C
	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	CALL BSLN
	IF (HAD_PAR) THEN
	   CATLEN = READSTR(CAT)
	ELSE
	   STATUS = RDINT(FC)
	ENDIF
C
C Level/Layer
C
	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	CALL BSLN
	IF (HAD_PAR) THEN
	   LEVLEN = READSTR(LEV)
	ELSE
	   STATUS = RDINT(LAYER)
	ENDIF
C
C Create a string from category and level as real number to compare with
C the parameter file entry
C
	CODENUM = RECNUM
C
	IF (HAD_PAR) THEN
	   DEFAULT_FC = .FALSE.
	   ACODE = CAT//'.'//LEV
	   LEN = CATLEN + LEVLEN + 1
C
	   DO 99 I = 1,FC_CNT
	      IF (ACODE(1:LEN).EQ.AA_CODE(I)(1:AA_LEN(I)) ) THEN
		 FC = IFF_FC(I)
		 GOTO 101
	      ENDIF
99	   CONTINUE
C
	   DEFAULT_FC = .TRUE.
	   CALL LSL_PUTMSG(AA2I__FCDEFAULT,ACODE(1:LEN),CODENUM)
	   FC = 999
C
	ELSE
	   IF (FIRST_FEATURE) THEN
	      LAYER = 1
	      CALL IFFNO(LAYER,0,0)		! start new layer
	      OLDLAYER = LAYER
C	      IF (OUTPUT) CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	      FIRST_FEATURE = .FALSE.
	   ENDIF   
C
	   IF (OLDLAYER.NE.LAYER) THEN
	      CALL IFFUNO(LPOSNO)			! update NO/EO pointer
	      CALL IFFEO				! end the layer
C
	      LPOSNO = LPOSE
	      CALL IFFNO(LAYER,0,0)		! start new layer
	      OLDLAYER = LAYER
C	      IF (OUTPUT) CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	   ENDIF
	ENDIF
C
C Lat/long & space
C
101	CONTINUE
C
	IF (HAD_FULL) THEN
	   RECNUM = RECNUM + 1
	   STATUS = FLRLIN()
	   RECNUM = RECNUM + 1
	   STATUS = FLRLIN()
	ENDIF
C
	DONE_START_FEATURE = .FALSE.
	FSN = FSN + 1
	ISQ = 0
	CALL IFFNF(FSN,ISQ)
C
	CALL START_FEATURE
	CALL IFFAC(1,COUNTY)
	CALL IFFST(STBUF,1,0)
	CALL IFFRO( ANGLE )
C
C Prevent an integer overflow by first assigning the result of ICHAR to a
C 4 byte int since this can be negative for composite characters and use an
C equivalenced byte when copying the character to the TXBUF array.
C
	DO 200 I = 1, NCHS
	   CHARINT = ICHAR(TEXT(I:I))
	   TXBUF(I) = CHARBYTE
200	CONTINUE
C
	CALL IFFTX(TXBUF, NCHS)
C
C and end the feature
C
	CALL IFFEF
C
	GOTO 500
C
C Tidy up
C
999	CONTINUE
C
C Finish off the IFF file
C
	CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	CALL IFFEO			! end the layer
	CALL IFFEM			! end the map
	CALL IFFEJ			! end the 'job'
C
C Now go back and set the RA entry
C
	CALL IFFPKE( IECODE, IELEN, LPOSRA )
	CALL EIHWR( RANGE, 4, 1 )
C
C and close it
C
	STATUS = FLRCLO(AALUN)
C
	RETURN
	END
C
