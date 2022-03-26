	INTEGER	FUNCTION PROCESS_SETUP
C
CDEC$	IDENT	'16FE94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	13-January-1994
C
C Process the setup section, looking for colours and fonts
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
	INCLUDE		'PSEXPORTMSG.PAR'
	INCLUDE		'PSEXPORT.CMN'
C
C Functions
	INTEGER		FLRLIN
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	LOGICAL		RDCHS
C
C workspace
	INTEGER		OK
	INTEGER		I,N
	CHARACTER*(MAX_TXTLIM)	TXTSTR
	EQUIVALENCE	(TXTBUF,TXTSTR)
	REAL		C(4)
	BYTE		CH
	REAL		S,SCALE
	INTEGER		NAME_START,NAME_END
C
C set all the colours to black
	DO 5 I=0,MAXCOL-1
	   COLTAB(1,I) = 0.0
	   COLTAB(2,I) = 0.0
	   COLTAB(3,I) = 0.0
	   COLTAB(4,I) = 1.0
5	CONTINUE
C
C and indictate no fonts found so far
	NFONT = 0
C
10	OK = FLRLIN()
	IF (.NOT.OK) GOTO 999
C
	IF (TXTPTR.GE.10 .AND.
     &	    TXTSTR(:10).EQ.'%%EndSetup') GOTO 999
C
	IF (TXTPTR.GE.6 .AND.
     &	    TXTSTR(:6).EQ.'COLTAB') THEN
	   CALL BSLN
	   CALL SETWIN(7)
	   IF (RDLONG(N)) GOTO 10	! colour number
	   IF (N.LT.0.OR.N.GE.MAXCOL) GOTO 10
	   IF (RDCHS(CH)) GOTO 10
	   IF (CH.NE.'{') GOTO 10
	   IF (RDREAL(C(1))) GOTO 10
	   IF (RDCHS(CH)) GOTO 10
	   CALL BSCH
	   IF (TXTPTR-DCPTR+1.GE.7 .AND.
     &	       TXTSTR(DCPTR:DCPTR+6).EQ.'setgray') THEN
	      C(4) = 1.0-C(1)
	      C(1) = 0.0
	      C(2) = 0.0
	      C(3) = 0.0
	      GOTO 100
	   ENDIF
	   IF (RDREAL(C(2))) GOTO 10
	   IF (RDREAL(C(3))) GOTO 10
	   IF (RDCHS(CH)) GOTO 10
	   CALL BSCH
	   IF (TXTPTR-DCPTR+1.GE.11 .AND.
     &	       TXTSTR(DCPTR:DCPTR+10).EQ.'setrgbcolor') THEN
	      C(1) = 1.0-C(1)
	      C(2) = 1.0-C(2)
	      C(3) = 1.0-C(3)
	      C(4) = MIN(C(1),C(2),C(3))
	      C(1) = C(1)-C(4)
	      C(2) = C(2)-C(4)
	      C(3) = C(3)-C(4)
	      GOTO 100
	   ENDIF
	   IF (RDREAL(C(4))) GOTO 10
	   IF (RDCHS(CH)) GOTO 10
	   CALL BSCH
	   IF (TXTPTR-DCPTR+1.GE.12 .AND.
     &	       TXTSTR(DCPTR:DCPTR+11).EQ.'setcmykcolor') GOTO 100
	   GOTO 10
C
100	   COLTAB(1,N) = C(1)
	   COLTAB(2,N) = C(2)
	   COLTAB(3,N) = C(3)
	   COLTAB(4,N) = C(4)
	ELSEIF (TXTPTR.GE.7 .AND.
     &	        TXTSTR(:7).EQ.'FNTDICT') THEN
	   N = INDEX(TXTSTR(:TXTPTR),'/F')
	   IF (N.EQ.0) GOTO 10
	   CALL BSLN
	   CALL SETWIN(N+2)
	   IF (RDLONG(N)) GOTO 10	! font number
	   OK = FLRLIN()
	   IF (.NOT.OK) GOTO 999
	   CALL BSLN
	   IF (RDCHS(CH)) GOTO 10
	   IF (CH.NE.'/') GOTO 10
	   IF (TXTPTR-DCPTR+1.LT.10) GOTO 10
	   NAME_START = DCPTR
	   NAME_END = INDEX(TXTSTR(DCPTR:TXTPTR),' ')
	   IF (NAME_END.LE.1) GOTO 10
	   NAME_END = NAME_START+NAME_END-2
	   CALL EXPAND('%S',TXTSTR(NAME_START:NAME_END)) ! temp save
	   CALL SETWIN(NAME_END+2)
	   IF (RDCHS(CH)) GOTO 10
	   CALL BSCH
	   IF (TXTPTR-DCPTR+1.LT.8 .OR.
     &	       TXTSTR(DCPTR:DCPTR+7).NE.'findfont') GOTO 10
	   OK = FLRLIN()
	   IF (.NOT.OK) GOTO 999
	   CALL BSLN
	   SCALE = 1.0
	   IF (.NOT.RDREAL(S)) THEN
	      IF (.NOT.RDCHS(CH)) THEN
	         CALL BSCH
	         IF (TXTPTR-DCPTR+1.GE.9 .AND.
     &		     TXTSTR(DCPTR:DCPTR+8).EQ.'scalefont'
     &		    ) SCALE = S
	      ENDIF
	   ENDIF
C
C slot the font in array
	   DO 200 I=1,NFONT
	      IF (FNTTAB(I).NUMBER.EQ.N) GOTO 210
200	   CONTINUE
	   IF (NFONT.GE.MAXFNT) GOTO 10
	   NFONT = NFONT+1
	   I = NFONT
210	   FNTTAB(I).NUMBER = N
	   FNTTAB(I).SCALE = SCALE
	   CALL STR$COPY_DX(FNTTAB(I).NAME,EXPDSC)
	ENDIF
	GOTO 10
C
999	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__NOENDSETUP)
	   CALL LSL_ADDMSG(OK)
	ENDIF
	PROCESS_SETUP = OK
	RETURN
	END
