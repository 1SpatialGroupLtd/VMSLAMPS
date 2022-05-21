C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-17 16:03:12.000000000 +0100
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
	LOGICAL FUNCTION SEL_GEOREF(SELECT)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	13-May-1992
C
C Description:
C
C	Function to read a list of GEOREFs from the command line and
C       select them or deselect them according to the value of the logical
C       argument
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'SELECTIONS.CMN'
C
C Arguments
C
	LOGICAL		SELECT
C
C Functions
C
	LOGICAL		RDCHS,RDCH
	INTEGER*4	READSTR
	INTEGER*4	SIGCHS
C
C Local workspace
C
	INTEGER*4	I,J,K,L,P		! loop controls
	BYTE		COMMA			! ASCII constant
	PARAMETER	(COMMA=44)
	CHARACTER*255	TMP
	CHARACTER*2	TMP_SEL(MAX_NUM_GEO)
	CHARACTER*2	TMP_TILE_SEL(MAX_NUM_GEO,9)
	CHARACTER*2	TILE
	LOGICAL		DUP
	LOGICAL		MATCH
	LOGICAL		HAD_TILE
	LOGICAL		HAD_SEP
	INTEGER*4	LEN,PTR,COUNT
	INTEGER*4	REMOVEPOS
	INTEGER*4	CURR_POS
	INTEGER*4	RETVAL
	INTEGER*4	NUM_TMP_SEL
C
C***********************************************************************
C
	SEL_GEOREF=.TRUE.			! assume success
	MATCH = .FALSE.
C
	NUM_TMP_SEL = 0
	DO 6 J = 1,MAX_NUM_GEO
	   DO 5 I = 1,9
	      TMP_TILE_SEL(J,I)(1:2) = '  '
5	   CONTINUE
6	CONTINUE
C
C Fill string with blanks so that SIGCHS can find the end
C
10	DO 20 I = 1, 255
	   TMP(I:I) = CHAR(32)
20	CONTINUE
C
C Read up to each comma or end of line
C
	LEN = READSTR(TMP,COMMA,,.TRUE.,RETVAL)
	LEN = SIGCHS(TMP)
C
C Upper case the string
C
	CALL STR$UPCASE(TMP,TMP)
C
C Check for sillies 
C
	IF (LEN.EQ.0) GOTO 50
	IF (LEN.EQ.1) THEN
	   CALL LSL_PUTMSG(DCW2I__GEOINVALID,TMP(1:LEN))
	   GOTO 999
	ENDIF
C
C Deselect or Select ALL
C
	IF (LEN.EQ.3.AND.TMP(1:3).EQ.'ALL') THEN
	   ALL_GEO_SEL = SELECT
	   NUM_GEO_SEL = 0
	   CALL SHOW_SEL(4)
	   GOTO 1000
	ENDIF
C
C We have one or more individual GEOREF. Find first char in LONG_GEO list 
C and second char in LAT_GEO list
C
	MATCH = .FALSE.
	DO 40 I = 1,NUM_LONG_GEO
	   IF (TMP(1:1).EQ.LONG_GEOREF(I:I)) THEN
	      DO 35 J = 1,NUM_LAT_GEO
		 IF (TMP(2:2).EQ.LAT_GEOREF(J:J)) THEN
		    MATCH = .TRUE.
		    GOTO 45
		 ENDIF
35	      CONTINUE
	   ENDIF
40	CONTINUE
45	IF (.NOT.MATCH) THEN
	   CALL LSL_PUTMSG(DCW2I__GEOINVALID,TMP(1:LEN))
	   GOTO 999
	ENDIF
C
C Got match, now check if sub tile given
C
	HAD_TILE = .FALSE.
	HAD_SEP = .FALSE.
	IF (LEN.GT.2) THEN
	   DO 400 I = 3,LEN
	      IF (TMP(I:I).EQ.':') THEN
		 HAD_SEP = .TRUE.
	      ELSEIF (TMP(I:I).NE.' '.AND..NOT.HAD_SEP) THEN
		 CALL LSL_PUTMSG(DCW2I__GEOINVALID,TMP(1:LEN))
		 GOTO 999
	      ENDIF
400	   CONTINUE
	   DO 500 I = 3,LEN
	      IF (TMP(I:I).EQ.':') THEN
		 DO 510 J = I+1,LEN
		    IF (TMP(J:J).NE.' ') THEN
		       IF (J.EQ.LEN) THEN
			  CALL LSL_PUTMSG(DCW2I__BADSUBTILE,TMP(1:2))
			  GOTO 999
		       ELSE
			  IF (ICHAR(TMP(J:J))-48.GE.1.AND.
     &			      ICHAR(TMP(J:J))-48.LE.3.AND.
     &			      ICHAR(TMP(J+1:J+1))-48.GE.1.AND.
     &			      ICHAR(TMP(J+1:J+1))-48.LE.3) THEN
			     HAD_TILE = .TRUE.
			     TILE(1:2) = TMP(J:J+1)
			     GOTO 520
			  ELSE
			     CALL LSL_PUTMSG(DCW2I__BADSUBTILE,TMP(1:2))
			     GOTO 999
			  ENDIF
		       ENDIF
		    ENDIF
510		 CONTINUE
		 GOTO 520
	      ENDIF
500	   CONTINUE
	ENDIF
C
520	DUP = .FALSE.
	IF (NUM_TMP_SEL.GT.0) THEN
	   DO 530 I = 1,NUM_TMP_SEL
	      IF (TMP_SEL(I)(1:2).EQ.TMP(1:2)) THEN
		 DUP = .TRUE.
		 CURR_POS = I
	      ENDIF
530	   CONTINUE
	ENDIF
	IF (.NOT.DUP) THEN
	   NUM_TMP_SEL = NUM_TMP_SEL + 1
	   TMP_SEL(NUM_TMP_SEL)(1:2) = TMP(1:2)
	   CURR_POS = NUM_TMP_SEL
	ENDIF
	IF (HAD_TILE) THEN
	   P = ((ICHAR(TILE(1:1))-48)-1)*3 + (ICHAR(TILE(2:2))-48)
	   TMP_TILE_SEL(CURR_POS,P)(1:2) = TILE(1:2)
	ELSE
	   DO 550 I = 1,3
	      DO 540 J = 1,3
		 P = (I-1)*3+J
		 TMP_TILE_SEL(CURR_POS,P)(1:2) = CHAR(I+48)//CHAR(J+48)
540	      CONTINUE
550	   CONTINUE
	ENDIF
C
C If no room for saves, force it to believe it's the end of line. Ignore rest.
C
	IF (NUM_GEO_SEL+NUM_TMP_SEL.GE.MAX_NUM_GEO) THEN
	   RETVAL = LSL__STREOL
	   GOTO 50
	ENDIF
C
C End of line
C
50	IF (RETVAL.EQ.LSL__STREOL) THEN
C
C Check the each one in the temporary list to see if already selected
C
	   IF (MATCH) THEN
	      DO 80 I = 1,NUM_TMP_SEL
		 MATCH = .FALSE.
		 DO 60 J = 1,NUM_GEO_SEL
		    IF (GEO_SEL(J)(1:2).EQ.TMP_SEL(I)(1:2)) THEN
		       MATCH=.TRUE.
		       REMOVEPOS = J
		       GOTO 65
		    ENDIF
60		 CONTINUE
65		 IF (MATCH) THEN
		    IF (SELECT) THEN
		       CURR_POS = REMOVEPOS
		       DO 66 L = 1,9
			  IF (TMP_TILE_SEL(I,L)(1:2).NE.'  ') THEN
			     GEO_TILE_SEL(CURR_POS,L)(1:2) = 
     &				  TMP_TILE_SEL(I,L)(1:2)
			  ENDIF
 66		       CONTINUE
		    ELSE
C
C If we are deselecting and it is in the list, remove it
C
		       COUNT = 0
		       DO 68 L = 1,9
			  IF (TMP_TILE_SEL(I,L)(1:2).NE.'  ') COUNT = COUNT + 1
 68		       CONTINUE
		       IF (COUNT.EQ.9) THEN
			  DO 70 K = REMOVEPOS,NUM_GEO_SEL !shift 'em down
			     IF (K.LT.NUM_GEO_SEL) THEN
				GEO_SEL(K)(1:2) = GEO_SEL(K+1)(1:2)
				DO 69 L = 1,9
				   GEO_TILE_SEL(K,L)(1:2) =
     &					GEO_TILE_SEL(K+1,L)(1:2)
 69				CONTINUE
			     ENDIF
 70			  CONTINUE
			  GEO_SEL(NUM_GEO_SEL)(1:2) = '  ' ! clear end one
			  DO 71 L = 1,9
			     GEO_TILE_SEL(NUM_GEO_SEL,L)(1:2)='  '
 71			  CONTINUE
			  NUM_GEO_SEL = NUM_GEO_SEL - 1
		       ELSE
			  DO 72 L = 1,9
			     IF (TMP_TILE_SEL(I,L)(1:2).NE.'  ') THEN
				IF (GEO_TILE_SEL(REMOVEPOS,L)(1:2).EQ.'  ') THEN
				   CALL LSL_PUTMSG(DCW2I__TILENOTSEL,
     &					           TMP_TILE_SEL(I,L)(1:2),
     &					           GEO_SEL(REMOVEPOS)(1:2))
				   GOTO 999
				ENDIF
				GEO_TILE_SEL(REMOVEPOS,L)(1:2)='  '
			     ENDIF
72			  CONTINUE
		       ENDIF
		    ENDIF
		 ELSE
C
C If it is not in the list and we are selecting, add it to list
C
		    IF (SELECT) THEN
		       NUM_GEO_SEL = NUM_GEO_SEL + 1
		       IF (NUM_GEO_SEL.GT.MAX_NUM_GEO) THEN
			  NUM_GEO_SEL = MAX_NUM_GEO
			  CALL LSL_PUTMSG(DCW2I__TOOMANY,MAX_NUM_GEO)
			  GOTO 999
		       ENDIF
		       GEO_SEL(NUM_GEO_SEL)(1:2) = TMP_SEL(I)(1:2)
		       DO 75 L = 1,9
			  GEO_TILE_SEL(NUM_GEO_SEL,L)(1:2) = 
     &			       TMP_TILE_SEL(I,L)(1:2)
75		       CONTINUE
		    ELSE
C
C Trying to deselect one that wasn't in the list. Complain
C
		       IF (ALL_GEO_SEL) THEN
			  CALL LSL_PUTMSG(DCW2I__CANTDESEL)
			  GOTO 999
		       ELSE
			  CALL LSL_PUTMSG(DCW2I__GEONOTSEL,TMP(1:LEN))
			  GOTO 999
		       ENDIF
		    ENDIF
		 ENDIF
80	      CONTINUE
	      CALL SHOW_SEL(4)
	   ELSE
C
C Otherwise complain
C
	      CALL LSL_PUTMSG(DCW2I__NONAME,'GEOREF')
	      GOTO 999
	   ENDIF
	   GOTO 1000
	ENDIF
C
C Read upto next comma
C
	GOTO 10
C
C
C***********************************************************************
C
C Exit
C
999	CALL WRITEF
	SEL_GEOREF=.FALSE.		! reject the rest of the command line.
1000	RETURN
C
	END

