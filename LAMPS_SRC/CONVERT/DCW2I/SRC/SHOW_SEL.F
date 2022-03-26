	LOGICAL FUNCTION SHOW_SEL(CHOICE)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	13-May-1992
C
C Description:
C
C	Function to show all or individual options selected.
C       CHOICE = 1   - show all selections
C       CHOICE = 2   - show selected library
C       CHOICE = 3   - show selected coverages
C       CHOICE = 4   - show selected georef
C       CHOICE = 5   - show selected classes
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
C
C Arguments
C
	INTEGER*4	CHOICE
C
C Local workspace
C
	INTEGER*4	I,J			! loop controls.
	INTEGER*4	COUNT			! num selected coverages
	CHARACTER*128	OUTSTR
	INTEGER*4	STRLEN
	INTEGER*4	ST
	INTEGER*4	END
C
C***********************************************************************
C
	IF (.NOT.HAD_ENA_REPLY .AND. CHOICE.GT.1) GOTO 100
C
C Show library selected
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.2) THEN
	   IF (LIBRARY.EQ.0) THEN
	      STRLEN = 4
	      OUTSTR(1:STRLEN) = 'NONE'
	   ELSE
	      STRLEN = LIB_NAME_LEN(LIBRARY) + 2 + LIB_DESC_LEN(LIBRARY)
	      OUTSTR(1:STRLEN) = LIB_NAME(LIBRARY)(1:LIB_NAME_LEN(LIBRARY))
     &		                 //', '//
     &		                 LIB_DESC(LIBRARY)(1:LIB_DESC_LEN(LIBRARY))
	   ENDIF
	   CALL WRITEF('Library selected   : %S',OUTSTR(1:STRLEN))
	ENDIF
C
C Show coverage selections
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.3) THEN
	   IF (HAD_SEL_LIB) THEN
	      ST = STARTPOS
	      END = ENDPOS
	   ELSE
	      ST = 1
	      END = NUM_COVERAGES
	   ENDIF
	   STRLEN = 1
	   COUNT = 0
	   DO 60 I = ST,END
	      IF (COVER_SEL(I).EQ.1) THEN
		 COUNT = COUNT + 1
		 OUTSTR(STRLEN:STRLEN+2) = COVERAGE(I)(1:2) // ','
		 STRLEN = STRLEN + 3
	      ENDIF
60	   CONTINUE
	   STRLEN = STRLEN - 2
	   IF (COUNT.EQ.0) THEN
	      STRLEN = 4
	      OUTSTR(1:STRLEN) = 'NONE'
	   ENDIF
	   CALL WRITEF('Coverages selected : %S',OUTSTR(1:STRLEN))
	ENDIF
C
C Show georef selections
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.4) THEN
	   IF (LIBRARY.EQ.BROWSE) THEN
	      STRLEN = 11
	      OUTSTR(1:STRLEN) = 'UNAVAILABLE'
	   ELSE
	      IF (ALL_GEO_SEL) THEN
		 STRLEN = 3
		 OUTSTR(1:STRLEN) = 'ALL'
		 CALL WRITEF('GEOREFs selected   : %S',OUTSTR(1:STRLEN))
	      ELSEIF (NUM_GEO_SEL.EQ.0) THEN
		 STRLEN = 4
		 OUTSTR(1:STRLEN) = 'NONE'
		 CALL WRITEF('GEOREFs selected   : %S',OUTSTR(1:STRLEN))
	      ELSE
		 DO 70 I = 1,NUM_GEO_SEL
		    COUNT = 0
		    DO 62 J = 1,9
		       IF (GEO_TILE_SEL(I,J)(1:2).NE.'  ') COUNT = COUNT + 1
62		    CONTINUE
		    STRLEN = 1
		    OUTSTR(STRLEN:STRLEN+1) = GEO_SEL(I)(1:2)
		    STRLEN = STRLEN + 2
		    IF (COUNT.EQ.9) THEN
		       OUTSTR(STRLEN:STRLEN+11) = ', ALL Tiles'
		       STRLEN = STRLEN + 11
		       GOTO 66
		    ELSE
		       OUTSTR(STRLEN:STRLEN+9) = ', Tiles: '
		       STRLEN = STRLEN + 9
		    ENDIF
		    DO 65 J = 1,9
		       IF (GEO_TILE_SEL(I,J)(1:2).NE.'  ') THEN
			  OUTSTR(STRLEN:STRLEN+2) = GEO_TILE_SEL(I,J)(1:2)//','
			  STRLEN = STRLEN + 3
		       ENDIF
65		    CONTINUE
		    STRLEN = STRLEN - 2
66		    IF (I.EQ.1) THEN
		       CALL WRITEF('GEOREFs selected   : %S',OUTSTR(1:STRLEN))
		    ELSE
		       CALL WRITEF('                   : %S',OUTSTR(1:STRLEN))
		    ENDIF
70		 CONTINUE
	      ENDIF
	   ENDIF
	ENDIF
C
C Show class selections
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.5) THEN
	   STRLEN = 0
	   IF (WANT_ALL_CLASSES) THEN
	      STRLEN = 5
	      OUTSTR(1:STRLEN)='ALL  '
	   ELSE
	      IF (WANT_AREAS) THEN
		 OUTSTR(STRLEN+1:STRLEN+7)='AREAS, '
		 STRLEN = STRLEN + 7
	      ENDIF
	      IF (WANT_LINES) THEN
		 OUTSTR(STRLEN+1:STRLEN+7)='LINES, '
		 STRLEN = STRLEN + 7
	      ENDIF
	      IF (WANT_POINTS) THEN
		 OUTSTR(STRLEN+1:STRLEN+8)='POINTS, '
		 STRLEN = STRLEN + 8
	      ENDIF
	      IF (WANT_TEXT) THEN
		 OUTSTR(STRLEN+1:STRLEN+6)='TEXT  '
		 STRLEN = STRLEN + 6
	      ENDIF
	   ENDIF
	   IF (.NOT.(WANT_ALL_CLASSES .OR. WANT_AREAS  .OR. WANT_LINES  .OR.
     &		     WANT_POINTS .OR. WANT_TEXT)) THEN
	      OUTSTR(STRLEN+1:STRLEN+6)='NONE  '
	      STRLEN = STRLEN + 6
	   ENDIF
	   STRLEN = STRLEN - 2
	   CALL WRITEF('Classes selected   : %S',OUTSTR(1:STRLEN))
	ENDIF
C
	CALL WRITEF
100	RETURN
	END
