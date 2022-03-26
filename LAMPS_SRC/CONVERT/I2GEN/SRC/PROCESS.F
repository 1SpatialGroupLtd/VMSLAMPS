	  INTEGER*4  FUNCTION PROCESS()
C
CDEC$	IDENT	'22AP91'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C Created.						ST  22-Apr-1991
C
C Transfer input IFF file (open on lun IFFLUN) to GENAMAP 19 format.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'PARAMS.PAR'
C
C Common
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'IFF.CMN'
	INCLUDE 'COMMAND.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNLSL:EXPC.CMN'
C
C Presets
C
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C Functions
C
	INTEGER		FLWLIN		! 
	INTEGER		FLWCLO		! 
	INTEGER		FLWOPN		! 
	INTEGER		FLWSEL		! 
	INTEGER*2       APPEND
C
C Word
C
	INTEGER*2	I,J,WORD! temporary/loop variable
	INTEGER*2	IENDS	! pen control for ST or ZS
	INTEGER*2	IFC	! current feature code 
	INTEGER*2	TXTDAT	! text status
	INTEGER*2	IELEN	! length of
	INTEGER*2	IECODE  ! ... current iff entry
	INTEGER*2	ITYPE	! current type of AC entry
	INTEGER*2	NOVER	! layer number
	INTEGER*2	NPTS	! number of points in ST or ZS
	INTEGER*2	STBLOCKS! number of STs in a feature
	INTEGER*2       LEN,LEN2
C
C Longword
C
	INTEGER*4	STATUS
	INTEGER*4	IERR	! for error return	
	INTEGER*4	IHEIGHT	! integer contour height
	INTEGER*4	LPOSEO	! position of next EO entry
	INTEGER*4	LONGHT	! the contour height for 2d string
	INTEGER*4	NFNUM   ! feature number
	INTEGER*4	TOTPTS	! total points in feature
	INTEGER*4	TXTLEN	! length of TX entry string
	INTEGER*4	NCOUNT	! A counter
C
C Real*4
C
	REAL*4	STBUFF(2,MAXPTS) ! all coordinates from all STs in feat.
	REAL*4	ST3BUF(3,MAXPTS) ! all coordinates from all ZSs in feat.
C
	EQUIVALENCE (ST3BUF(1,1),STBUFF(1,1))
C
	REAL		TEXTX,TEXTY,X,Y,Z	! temporary variables 
C
C Character
C
	CHARACTER*32	LABEL	!Feature description
	CHARACTER*80	TXTSTR
	BYTE		TXT(80)
	EQUIVALENCE(TXT(1),TXTSTR)
C
C Logical
C
	LOGICAL		TEXTF	! True if a text feature
	LOGICAL		HAD_ZS	! had a ZS entry in feature
	LOGICAL         HAD_TXT_COORDS
	LOGICAL         HAD_SOME_TEXT
	LOGICAL         HAD_SOME_VECTS
C
C ......................................................................
C
C Assume the best
C
	STATUS = .TRUE.
C
	HAD_SOME_VECTS = .FALSE.
	HAD_SOME_TEXT  = .FALSE.
C
C Rewind IFF file
C
	CALL IFFRWD
C
	CALL FLWSEL(GENLUN)
C
C ......................................................................
C
C			M A I N   L O O P
C
100	CALL IFFNXT(IECODE,IELEN)
	IF (IELEN.EQ.-1) GOTO 220
101	IF (IECODE.EQ.'RA') GOTO 200
	IF (IECODE.EQ.'MD') GOTO 210
	IF (IECODE.EQ.'NF') GOTO 300
	IF (IECODE.EQ.'FS') GOTO 400
	IF (IECODE.EQ.'TX') GOTO 500
	IF (IECODE.EQ.'ST') GOTO 600
	IF (IECODE.EQ.'ZS') GOTO 600
	IF (IECODE.EQ.'EF') GOTO 800
	IF (IECODE.EQ.'EJ') GOTO 900
	GOTO 100
C
C ......................................................................
C
C RA - Range
C
200	CALL EIHRR(RANGE,4,1)
	GOTO 100			! get next IFF entry
C
C ......................................................................
C
C MD - Map Descriptor - Offset to be added to range
C
210	CALL EIHRI( MD2ARR,MIN(MD2LEN,IELEN),1 )
C
C Dont want to do this at the mo. Unsure of what GENAMAP does with origins.
C
	IF (HAD_OFFSET) THEN
	   RANGE(1) = RANGE(1) + MD2LOC(1)
	   RANGE(2) = RANGE(2) + MD2LOC(1)
	   RANGE(3) = RANGE(3) + MD2LOC(2)
	   RANGE(4) = RANGE(4) + MD2LOC(2)
	ENDIF
	GOTO 100			! get next IFF entry
C
C ......................................................................
C
C NF - New Feature
C
300	NFNUM = NFNUM + 1
	TOTPTS=0
	HAD_TXT_COORDS = .FALSE.
	GOTO 100
C
C ......................................................................
C
C FS - Feature Code
C
400	CALL EIHRI(IFC,1,1)		! read feature code
	CALL EIHRI(TXTDAT,1,3)		! read text bits
C	
	TEXTF = (TXTDAT.AND.'8000'X).NE.0
C
C Check if IFF to GEN feature code to string label conversion is needed
C
	IF (HAD_PAR) THEN			! it's compulsory anyway!
	   DO 410 I=1,NUMC			! for each tab.
	      IF (IFC.EQ.PAR_FC(I)) THEN	! check each label
	         LABEL=PAR_LAB(I)		! a hit!
		 PAR_FLG(I) = 1                 ! flag it for menu_vector file
	         GOTO 100			! get next IFF entry
	      ENDIF
410	   CONTINUE
C
C If we fall through to here we have a feature code which is undefined
C in the /PARAMETER file. This is presumably because the user wants to ignore
C it. Give a warning and jump to next EF.
C
	   CALL WRITEF('FC %^W%I0 undefined in parameter - feature ignored',IFC)
	   CALL IFFNXC('EF',IELEN)
	   IF (IELEN.EQ.-1) GOTO 220
	ENDIF
	GOTO 100
C
C ......................................................................
C
C TX - Text
C
500	IF (.NOT.TEXTF) THEN
	   CALL WRITEF('TX entry found in non-text feature - feature ignored')
	   CALL IFFNXC('EF',IELEN)
	   IF (IELEN.EQ.-1) GOTO 220
	ELSE
	   IF (.NOT.HAD_TXT_COORDS) THEN
	      CALL WRITEF('No ST entry found text feature - feature ignored')
	      CALL IFFNXC('EF',IELEN)
	      IF (IELEN.EQ.-1) GOTO 220
	   ELSE
	      DO 510 I=1,80
		 TXT(I)=0
 510	      CONTINUE
	      CALL EIHR(TXT,IELEN,1)
	      TXTLEN = IELEN*2
	      IF (TXT(TXTLEN).EQ.0) TXTLEN=TXTLEN-1
	      CALL FLWSEL(TXTLUN)
	      CALL EXPAND('%S',TXTSTR(1:TXTLEN))
	      CALL FLWLIN(,,,)
	      CALL EXPAND('%F0.1 %F0.1',TEXTX,TEXTY)
	      CALL FLWLIN(,,,)
	      CALL FLWSEL(GENLUN)
	      HAD_SOME_TEXT = .TRUE.
	   ENDIF
	ENDIF
	GOTO 100
C
C ......................................................................
C
C ST - STring (2d)
C
C Get total number of points in feature
C
600	HAD_ZS = IECODE.EQ.'ZS'
	STBLOCKS = 1
	CALL EIHMK(1)
	CALL EIHRS(NPTS,IENDS)
	TOTPTS = TOTPTS + NPTS
610	CALL IFFNXT(IECODE,IELEN)
	IF (IELEN.EQ.-1) GOTO 220
	IF (IECODE.EQ.'ST'.OR.IECODE.EQ.'ZS') THEN
	   STBLOCKS = STBLOCKS + 1
	   CALL EIHRS(NPTS,IENDS)
	   IF (STBLOCKS.GT.1 .AND. IENDS.EQ.0) GOTO 610	! invisible lines
	   TOTPTS = TOTPTS + NPTS
	   GOTO 610
	ELSE
	   CALL IFFRWM
	ENDIF
C
C If it's a text feature save the coords until we get TX
C
	IF (TEXTF) THEN
	   IF (TOTPTS.NE.1) THEN
	      CALL WRITEF('Text feature does not contain a single point - feature ignored')
	      CALL IFFNXC('EF',IELEN)
	      IF (IELEN.EQ.-1) GOTO 220
	      GOTO 100
	   ENDIF
	   IF (HAD_ZS) THEN
	      CALL EIHRR(ST3BUF,3,1)
	      TEXTX=ST3BUF(1,1)
	      TEXTY=ST3BUF(2,1)
	   ELSE
	      CALL EIHRR(STBUFF,2,1)
	      TEXTX=STBUFF(1,1)
	      TEXTY=STBUFF(2,1)
	   ENDIF
	   HAD_TXT_COORDS = .TRUE.
	   IF (HAD_OFFSET) THEN
	      TEXTX=TEXTX+MD2LOC(1)
	      TEXTY=TEXTY+MD2LOC(2)
	   ENDIF
	ELSE
C
C Write header line
C
	   CALL EXPAND
	   LEN = APPEND('%N',NFNUM)
	   LEN = APPEND('%[ %]%[ %]%S%[ %]',5-LEN,10,LABEL(1:32),3)
!	   LEN = APPEND('%[ %]%S%S',5-LEN+10,LABEL(1:32),'   ')
	   LEN2 = APPEND('%N',TOTPTS) - LEN
	   LEN2 = APPEND('%[ %]',5-LEN2)
	   CALL FLWLIN(,,,)
C
C Read in all ST blocks
C
	   DO 620 J = 1,STBLOCKS
	      CALL EIHRS(NPTS,IENDS)
	      IF (J.GT.1 .AND. IENDS.EQ.0) GOTO 625   ! ignore invisible line
	      IF (HAD_ZS) THEN
	         CALL EIHRR(ST3BUF,NPTS*3,1)
	      ELSE
	         CALL EIHRR(STBUFF,NPTS*2,1)
	      ENDIF
	      DO 630 I = 1,NPTS
		 IF (HAD_ZS) THEN
	            X=ST3BUF(1,I)
	            Y=ST3BUF(2,I)
		 ELSE
	            X=STBUFF(1,I)
	            Y=STBUFF(2,I)
		 ENDIF
		 IF (HAD_OFFSET) THEN
		    X=X+MD2LOC(1)     ! add origin offset in MD
		    Y=Y+MD2LOC(2)
		 ENDIF
	         CALL EXPAND('%F0.1 %F0.1',X,Y)
	         CALL FLWLIN(,,,)
630	      CONTINUE
	      HAD_SOME_VECTS = .TRUE.
625	      CALL IFFNXT(IECODE,IELEN)
	      IF (IELEN.EQ.-1) GOTO 220
	      IF (IECODE.NE.'ST'.AND.IECODE.NE.'ZS') GOTO 101
620	   CONTINUE
	ENDIF
C
	GOTO 100
C
C ......................................................................
C
C EF - End Feature
C
800	GOTO 100
C
C ......................................................................
C
C EJ - End Job
C
900	CONTINUE
C
C Tidy up 
C
	IF (HAD_SOME_VECTS) THEN
C
C Open MENU_VECTOR output file
C
	   IF (.NOT.FLWOPN(MENU_VECT_LUN,
     &		'MENU_VECTOR.'//STR_NAM(1:LEN_NAM)//';0',,)) GOTO 255
	   CALL WRITEF('Opened file MENU_VECTOR for write...')
	   NCOUNT = 1
	   CALL FLWSEL(MENU_VECT_LUN)
	   DO 910 I = 1,NUMC
	      IF (PAR_FLG(I).EQ.1) THEN
	         CALL EXPAND('%N %S',NCOUNT,PAR_LAB(I))
	         CALL FLWLIN(,,,)
	         NCOUNT = NCOUNT + 1
	      ENDIF
910	   CONTINUE
	   CALL FLWCLO(MENU_VECT_LUN)
C
C Open INDEX_VECTOR output file
C
	   IF (.NOT.FLWOPN(IND_VECT_LUN,
     &		'INDEX_VECTOR.'//STR_NAM(1:LEN_NAM)//';0',,)) GOTO 255
	   CALL WRITEF('Opened file INDEX_VECTOR for write...')
	   CALL FLWSEL(IND_VECT_LUN)
	   CALL EXPAND('%S',STR_NAM(1:LEN_NAM)//'.GENVECT')
	   DO 920 I = 1,4
	      CALL APPEND(' %F0.1',RANGE(I))
920	   CONTINUE
	   CALL FLWLIN(,,,)
	   CALL FLWCLO(IND_VECT_LUN)
	ENDIF
C
	IF (HAD_SOME_TEXT) THEN
C
C Open INDEX_TEXT output file
C
	   IF (.NOT.FLWOPN(IND_TEXT_LUN,
     &		'INDEX_TEXT.'//STR_NAM(1:LEN_NAM)//';0',,)) GOTO 255
	   CALL WRITEF('Opened file INDEX_TEXT for write...')
	   CALL FLWSEL(IND_TEXT_LUN)
	   CALL EXPAND('%S',STR_NAM(1:LEN_NAM)//'.GENTEXT')
	   DO 930 I = 1,4
	      CALL APPEND(' %F0.1',RANGE(I))
930	   CONTINUE
	   CALL FLWLIN(,,,)
	   CALL FLWCLO(IND_TEXT_LUN)
	ENDIF
C
	GOTO 260
C
C ......................................................................
C
C			E R R O R S 
C
C Unexpected end of file
220	PROCESS = .FALSE.
	CALL WRITEF('Unexpected EOF')
	GOTO 260
C
C Feature code has undefined GEN string label
230	PROCESS = .FALSE.
	CALL WRITEF('FC %^W%I0 was undefined',IFC)
	GOTO 260
C
C Feature has negative coordinates
C
240	PROCESS = .FALSE.
	CALL WRITEF('Feature has -ve coords')
	GOTO 260
C
C Insufficient buffer space for coordinates
C
250	PROCESS = .FALSE.
	CALL WRITEF('Insufficient space for coords')
	GOTO 260
C
C Error opening GEN file for output
C
255	PROCESS = .FALSE.
	CALL WRITEF('Error opening an output file')
	GOTO 260
C
C ......................................................................
C
260	IF (PROCESS) PROCESS=%LOC(SS$_NORMAL)
	RETURN
	END
