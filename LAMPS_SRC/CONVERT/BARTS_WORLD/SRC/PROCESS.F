	SUBROUTINE 	PROCESS
CDEC$	IDENT	'15JA92'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Auth					01-Oct-1991	Jon Barber
C
C Description:
C
C	Process the BARTS file into format suitable for IFROMTEXT/FRT=
C	Produces a file with:
C
C	RA -180 180 -90 90
C	MD
C	SC 1		! scale (temp)
C	LO 0 0		! local origin
C
C	NO 1
C	FS FC 		! FC for text
C	ST 
C	X Y
C	TX
C	RO
C	EF
C
C	EO
C	EM
C	EJ
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'	! READSTR parameters
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
	INCLUDE 'CMN:FILE.CMN'
C
	INTEGER		STATUS
	LOGICAL		OK
C
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		FLWSTR
	LOGICAL		FLWCLO
	INTEGER		READSTR
C
	LOGICAL		RDCH
	LOGICAL		RDLONG
	LOGICAL		RDDBLE
C
C Local
	INTEGER		I,J,K,RECNUM
	INTEGER		LEN,RETVAL
	BYTE		ICH,BYTE
	INTEGER*2	FC,TH
C
C Record types
C
	INTEGER		AC_TYPE
	PARAMETER	(AC_TYPE=3)
C
	INTEGER*2	CAPITAL_FC(5)
	INTEGER*2	TOWN_FC(5)
	INTEGER*2	RIVER_FC
	INTEGER*2	COUNTRY_FC
	INTEGER*2	ADMINAREA_FC
	INTEGER*2	PHYSICAL_FC
	INTEGER*2	PHYSICAL_HEIGHT_FC
C
	INTEGER*2	CAPITAL_TH(5)
	INTEGER*2	TOWN_TH(5)
	INTEGER*2	RIVER_TH
	INTEGER*2	COUNTRY_TH
	INTEGER*2	ADMINAREA_TH
	INTEGER*2	PHYSICAL_TH
C
	DATA		CAPITAL_FC  /64,65,66,67,68/
	DATA		TOWN_FC     /69,70,71,72,73/
	DATA		RIVER_FC    /55/
	DATA		COUNTRY_FC  /79/
	DATA		ADMINAREA_FC/80/
	DATA		PHYSICAL_FC /99/
	DATA		PHYSICAL_HEIGHT_FC /100/
C
	DATA		CAPITAL_TH  /6,8,10,12,14/
	DATA		TOWN_TH     /6,8,10,12,14/
	DATA		RIVER_TH    /5/
	DATA		COUNTRY_TH  /12/
	DATA		ADMINAREA_TH/9/
	DATA		PHYSICAL_TH /7/
C
	INTEGER		START			! start read posn
	INTEGER*2	PTR			! reading posn
	INTEGER		ACC_CODE		! accent code
	BYTE		ACC_BYTE(2)		! accent code
C
	REAL*8		Y,X			! geog degrees
	INTEGER		LOWER,UPPER		! populations
	INTEGER		HEIGHT,DEPTH		! populations
	LOGICAL		HAD_HEIGHT
	LOGICAL		HAD_DEPTH
C
	CHARACTER*255	STRING			! record type
	CHARACTER*255	TEXT			! name
	INTEGER		TEXT_LEN
	CHARACTER*1	TERM_CHAR		! ':'
	BYTE		TC
	CHARACTER*1	ASTERISK		! '*'
	BYTE		STAR
C
	BYTE		LF
	DATA		LF/Z0A/		! <LF> character
C
C-------------------------------------------------------------------------------
C Set termination character ':' and '*'
C
	TERM_CHAR = ':'
	TC = ICHAR(TERM_CHAR)
C
	ASTERISK = '*'
	STAR = ICHAR(ASTERISK)
C
	CALL SET_ASCII
C
C Select files for read and write
C
	CALL FLRSEL(BARTLUN)
	CALL FLWSEL(TXTLUN)
C
	RECNUM = 0
C
C Create MD2 with scale set to 1, coords in decimal degrees
C
	CALL FLWSTR('RA -180 180 -90 90')
	CALL FLWSTR('MD')
	CALL FLWSTR('SC 14000000')
	CALL FLWSTR('LO 0 0')
C
C Create layer 0 with corner ticks
C
C	CALL FLWSTR('NO 0')
C
C	CALL FLWSTR('NF')
C	CALL FLWSTR('FS 0')
C	CALL FLWSTR('ST')
C	CALL FLWSTR('1600 20000')
C	CALL FLWSTR('0 20000')
C	CALL FLWSTR('0 19000')
C	CALL FLWSTR('EF')
C
C	CALL FLWSTR('NF')
C	CALL FLWSTR('FS 0')
C	CALL FLWSTR('ST')
C	CALL FLWSTR('0 1000')
C	CALL FLWSTR('0 0')
C	CALL FLWSTR('1600 0')
C	CALL FLWSTR('EF')
C
C	CALL FLWSTR('NF')
C	CALL FLWSTR('FS 0')
C	CALL FLWSTR('ST')
C	CALL FLWSTR('30400 0')
C	CALL FLWSTR('32000 0')
C	CALL FLWSTR('32000 1000')
C	CALL FLWSTR('EF')
C
C	CALL FLWSTR('NF')
C	CALL FLWSTR('FS 0')
C	CALL FLWSTR('ST')
C	CALL FLWSTR('32000 19000')
C	CALL FLWSTR('32000 20000')
C	CALL FLWSTR('30400 20000')
C	CALL FLWSTR('EF')
C
C	CALL FLWSTR('EO')
C
C Layer 1 for features
C
	CALL FLWSTR('NO 1')
C
10	STATUS = FLRLIN()
	IF (.NOT.STATUS) THEN
	   IF (STATUS.EQ.LSL__EOF) GOTO 102
	   GOTO 999
	ENDIF
	RECNUM = RECNUM + 1
C
	CALL BSLN
	OK = RDCH(ICH)			! Check for linefeed
	IF (OK) THEN			! no char
	   CALL WRITEF (' Unable to read character on line %N',RECNUM)
	   GOTO 10
	ENDIF
C
	IF (ICH.NE.LF) CALL BSCH
C
C ***************************************************************
C
	LEN = READSTR(STRING,TC,ON_CHAR,.TRUE.,RETVAL)
C
	IF (STRING(1:LEN).EQ. 'CAPITAL') THEN
	   FC = CAPITAL_FC(1)
	   TH = CAPITAL_TH(1)
	ELSEIF (STRING(1:LEN).EQ. 'TOWN') THEN
	   FC = TOWN_FC(1)
	   TH = TOWN_TH(1)
	ELSEIF (STRING(1:LEN).EQ. 'RIVER') THEN
	   FC = RIVER_FC
	   TH = RIVER_TH
	ELSEIF (STRING(1:LEN).EQ. 'COUNTRY') THEN
	   FC = COUNTRY_FC
	   TH = COUNTRY_TH
	ELSEIF (STRING(1:LEN).EQ. 'ADMINAREA') THEN
	   FC = ADMINAREA_FC
	   TH = ADMINAREA_TH
	ELSEIF (STRING(1:LEN).EQ. 'PHYSICAL') THEN
	   FC = PHYSICAL_FC
	   TH = PHYSICAL_TH
	ELSE
	   CALL WRITEF (' Unknown entry %S on line %N',
     &					STRING(1:LEN),RECNUM)
	ENDIF
C
	TEXT_LEN = READSTR(TEXT,TC,ON_CHAR,.TRUE.,RETVAL)
	CALL DCPSAV(PTR)		! ':' read
C
	START = 1
C
103	DO 5 I = START,TEXT_LEN
	   BYTE = ICHAR(TEXT(I:I))
	   IF (BYTE.NE.STAR) GOTO 5
C
	   ACC_BYTE(1) = ICHAR(TEXT(I+1:I+1))	! convert into byte
	   ACC_BYTE(2) = ICHAR(TEXT(I+2:I+2))	! for rdlong
	   CALL SETAUX(ACC_BYTE,2)
	   OK = RDLONG(ACC_CODE)		! accent code
C
C Get relevant character to be accented
C
	   K = ICHAR(TEXT(I+3:I+3))
C
C Get ASCII byte value for accented character from ACC_CODE & K
C
	   IF(ASCII_CODE(ACC_CODE,K) .NE. 0) THEN
	      TEXT(I:I) = CHAR(ASCII_CODE(ACC_CODE,K))
	   ELSE
	      TEXT(I:I) = TEXT(I+3:I+3)
	   ENDIF
C
C Shift all chars up over the accent code
C Special case for Icelandic-d represented by *21 alone (i or u follows here)
C
	   IF (ACC_CODE.NE.21) THEN
	     DO 6 J = I+4,TEXT_LEN
	       TEXT(J-3:J-3) = TEXT(J:J)
6	     CONTINUE
	     TEXT_LEN = TEXT_LEN - 3
	   ELSE
	     DO 7 J = I+3,TEXT_LEN
	       TEXT(J-2:J-2) = TEXT(J:J)
7	     CONTINUE
	     TEXT_LEN = TEXT_LEN - 2
	   ENDIF
C
	   START = I+1
	   GOTO 103
C
5	CONTINUE
C
C Reset text buffer
C
	CALL SETAUX(TXTBUF,TXTPTR)
	CALL DCPSET(PTR)
C
	OK = RDDBLE(Y)
	IF (OK) THEN			! no number
	   CALL WRITEF (' Unable to read coord on line %N',RECNUM)
	   GOTO 10
	ENDIF
C
	OK = RDCH(ICH)			! Check for ':'
	IF (OK) THEN			! no char
	   CALL WRITEF (' Unable to read character on line %N',RECNUM)
	   GOTO 10
	ENDIF
	IF (ICH.NE.TC) CALL BSCH
C
	OK = RDDBLE(X)
	IF (OK) THEN			! no number
	   CALL WRITEF (' Unable to read coord on line %N',RECNUM)
	   GOTO 10
	ENDIF
C
C No populations for these features
C
	IF (FC.EQ.ADMINAREA_FC .OR.
     &	    FC.EQ.COUNTRY_FC  .OR. FC.EQ.RIVER_FC) GOTO 101
C 
	IF (FC.EQ.PHYSICAL_FC) THEN		! no populations
	   HAD_HEIGHT = .FALSE.
	   HAD_DEPTH  = .FALSE.
C
	   OK = RDCH(ICH)			! Check for ':'
	   OK = RDCH(ICH)			! Check for ':'
	   OK = RDCH(ICH)			! Check for ':'
	   IF (ICH.NE.TC) CALL BSCH
C
	   OK = RDLONG(HEIGHT) 	      
	   IF (.NOT.OK) HAD_HEIGHT = .TRUE.
C
	   OK = RDCH(ICH)			! Check for ':'
C
	   OK = RDLONG(DEPTH)
	   IF (.NOT.OK) HAD_DEPTH = .TRUE.
C
	   GOTO 101
	ENDIF
C
C Get populations
C
	OK = RDCH(ICH)			! Check for ':'
	IF (OK) THEN			! no char
	   CALL WRITEF (' Unable to read character on line %N',RECNUM)
	   GOTO 10
	ENDIF
	IF (ICH.NE.TC) CALL BSCH
C
	LOWER = 0
	UPPER = 0
C
	OK = RDLONG(LOWER) 	      
	IF (OK) THEN
	   LOWER = 0
	   GOTO 101		! no number
	ENDIF
C
	OK = RDCH(ICH)			! Check for ':'
	IF (OK) THEN			! no char
C	   CALL WRITEF (' Unable to read character on line %N',RECNUM)
	   GOTO 10
	ENDIF
	IF (ICH.NE.TC) CALL BSCH
C
	OK = RDLONG(UPPER)
	IF (OK) GOTO 101		! no number
C
C ***************************************************************
C
101	CONTINUE
C
	CALL FLWSTR('NF')
C
C Alter FC depending on population
C
	IF (FC.EQ.CAPITAL_FC(1)) THEN
	   IF (LOWER.EQ.100000 .AND. UPPER.EQ.500000) THEN
	      FC = CAPITAL_FC(2)
	      TH = CAPITAL_TH(2)
	   ELSEIF (LOWER.EQ.500000 .AND. UPPER.EQ.1000000) THEN
	      FC = CAPITAL_FC(3)
	      TH = CAPITAL_TH(3)
	   ELSEIF (LOWER.EQ.1000000 .AND. UPPER.EQ.5000000) THEN
	      FC = CAPITAL_FC(4)
	      TH = CAPITAL_TH(4)
	   ELSEIF (LOWER.EQ.5000000) THEN
	      FC = CAPITAL_FC(5)
	      TH = CAPITAL_TH(5)
	   ELSEIF (LOWER.EQ.0 .AND. UPPER.EQ.0) THEN
	      FC = CAPITAL_FC(1)
	      TH = CAPITAL_TH(1)
	   ELSEIF (LOWER.EQ.0 .AND. UPPER.EQ.100000) THEN
	      FC = CAPITAL_FC(1)
	      TH = CAPITAL_TH(1)
	   ELSE
	      CALL WRITEF (' Unknown population bands %N %N on line %N',
     &						LOWER,UPPER,RECNUM)
	   ENDIF
	ENDIF
C
	IF (FC.EQ.TOWN_FC(1)) THEN
	   IF (LOWER.EQ.100000 .AND. UPPER.EQ.500000) THEN
	      FC = TOWN_FC(2)
	      TH = TOWN_TH(2)
	   ELSEIF (LOWER.EQ.500000 .AND. UPPER.EQ.1000000) THEN
	      FC = TOWN_FC(3)
	      TH = TOWN_TH(3)
	   ELSEIF (LOWER.EQ.1000000 .AND. UPPER.EQ.5000000) THEN
	      FC = TOWN_FC(4)
	      TH = TOWN_TH(4)
	   ELSEIF (LOWER.EQ.5000000) THEN
	      FC = TOWN_FC(5)
	      TH = TOWN_TH(5)
	   ELSEIF (LOWER.EQ.0 .AND. UPPER.EQ.0) THEN
	      FC = TOWN_FC(1)
	      TH = TOWN_TH(1)
	   ELSEIF (LOWER.EQ.0 .AND. UPPER.EQ.100000) THEN
	      FC = TOWN_FC(1)
	      TH = TOWN_TH(1)
	   ELSE
	      CALL WRITEF (' Unknown population bands %N %N on line %N',
     &						LOWER,UPPER,RECNUM)
	   ENDIF
	ENDIF
C
	CALL EXPAND('FS %^W%N',FC)
	CALL FLWLIN()
C
	IF (HAD_HEIGHT) THEN
	   CALL EXPAND('AC %N %N',AC_TYPE,HEIGHT)
	   CALL FLWLIN()
	ENDIF
C
	IF (HAD_DEPTH) THEN
	   CALL EXPAND('AC %N %N',AC_TYPE,DEPTH)
	   CALL FLWLIN()
	ENDIF
C
	CALL EXPAND('TH %^W%N',TH)
	CALL FLWLIN()
	CALL FLWSTR('ST')
C
	CALL EXPAND('%F %F',Y,X)
	CALL FLWLIN()
	CALL EXPAND('TX %S',TEXT(1:TEXT_LEN))
	CALL FLWLIN()
C
	CALL FLWSTR('EF')
C
C Add extra TX features for height or depth of physical features
C
	IF (HAD_HEIGHT .OR. HAD_DEPTH) THEN
	   CALL FLWSTR('NF')
C
	   CALL EXPAND('FS %^W%N',PHYSICAL_HEIGHT_FC)
	   CALL FLWLIN()
C
	   IF (HAD_HEIGHT) THEN
	      CALL EXPAND('AC %N %N',AC_TYPE,HEIGHT)
	      CALL FLWLIN()
	   ENDIF
C
	   IF (HAD_DEPTH) THEN
	      CALL EXPAND('AC %N %N',AC_TYPE,DEPTH)
	      CALL FLWLIN()
	   ENDIF
C
	   CALL EXPAND('TH %^W%N',TH)
	   CALL FLWLIN()
	   CALL FLWSTR('ST')
C
	   CALL EXPAND('%F %F',Y,X)
	   CALL FLWLIN()
C
	   IF (HAD_HEIGHT) THEN
	      CALL EXPAND('TX %N',HEIGHT)
	      CALL FLWLIN()
	   ENDIF
C
	   IF (HAD_DEPTH) THEN
	      CALL EXPAND('TX %N',DEPTH)
	      CALL FLWLIN()
	   ENDIF
C
	   CALL FLWSTR('EF')
	ENDIF
C
	GOTO 10
C
102	CONTINUE
C
	CALL FLWSTR('EO')
	CALL FLWSTR('EM')
	CALL FLWSTR('EJ')
C
C Tidy up
C
999	CONTINUE
C
C Finish off the text file
C
	CALL FLRCLO(BARTLUN)
	CALL FLWCLO(TXTLUN)
C
	RETURN
	END
C
