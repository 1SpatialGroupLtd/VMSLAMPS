C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-06-16 11:45:42.000000000 +0100
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
	  INTEGER*4  FUNCTION PROCESS_GR()
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
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'IFF.CMN'
	INCLUDE 'COMMAND.CMN'
	INCLUDE 'LSL$CMNLSL:EXPC.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
C
C Presets
C
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C Functions
C
	INTEGER		FLRLIN		! 
	INTEGER		FLRSEL		! 
	INTEGER		FLWLIN		! 
	INTEGER		FLWSTR		! 
	INTEGER		FLWSEL		! 
	INTEGER*2       APPEND
	INTEGER*4	READSTR
	LOGICAL		RDINT
C
C Word
C
	INTEGER*2	I,J,WORD! temporary/loop variable
	INTEGER*2       LEN
C
C Longword
C
	INTEGER*4	STATUS
	INTEGER*4	IERR	! for error return	
	INTEGER*4	OK
C
	REAL*4		COORD(1000,3)
	REAL*4		RAC(1000,3)
	REAL*8		RVAL
	CHARACTER*80	TXTAC(1000),SVAL
	INTEGER*4	NUM
	LOGICAL		RREAL8
	LOGICAL		FOUND
	INTEGER*4	PTR,P,PEN
C
C Logical
C
	LOGICAL		TEXTF	! True if a text feature
	LOGICAL		HAD_ZS	! had a ZS entry in feature
	LOGICAL         HAD_TXT_COORDS
	LOGICAL         HAD_SOME_TEXT
	LOGICAL         HAD_SOME_VECTS
C
	PARAMETER	TYPE_REAL = 1
	PARAMETER	TYPE_ASC  = 2

	INTEGER*4	NEXT,R,PNT,WID,DEC
	INTEGER*4	NUM_DTYPES,NLINE,NCOL
	INTEGER*4	DTYPES(10,4)		! 1=type 2=r,3=wid,4=decimals
	INTEGER*4	LINES(10,10)
C
	CHARACTER*4	CODE
	CHARACTER*4	FCODE(2000)
	INTEGER*4	NUM_FCODES
	INTEGER*2	NF

	CHARACTER*80	STR
	BYTE		STRBUF(80)
	CHARACTER*80	TXTSTR
	BYTE		TXT(80)
	EQUIVALENCE(TXT(1),TXTSTR)
	EQUIVALENCE(STRBUF(1),STR)
C
C ......................................................................
C
C Assume the best
C
	STATUS = .TRUE.
	NUM_FCODES = 0
C
	CALL FLRSEL(MOSSLUN)
C
	OK = FLRLIN(TXT,,80,)
	IF (OK.EQ.LSL__EOF) GOTO 220
	CALL BSLN
	IF (TXTSTR(1:5).NE.'GENIO') THEN
	   CALL WRITEF('Missing GENIO line')
	   GOTO 260
	ENDIF
C
	OK = FLRLIN(TXT,,80,)
	IF (OK.EQ.LSL__EOF) GOTO 220
	CALL BSLN
	IF (TXTSTR(1:9).NE.'001FORMAT') THEN
	   CALL WRITEF('Missing 001 FORMAT record')
	   GOTO 260
	ENDIF
C
C Interpret 001, format record
C
1	IF (TXTSTR(1:3).EQ.'999'.OR.TXTSTR(1:6).EQ.'FINISH') GOTO 400
C
	IF (TXTSTR(1:9).EQ.'001FORMAT') THEN
	   DO 6 I = 1,10
	      DO 5 J = 1,10
		 IF (J.LT.5) DTYPES(I,J) = 0
		 LINES(I,J) = 0
 5	      CONTINUE
 6	   CONTINUE
	   NCOL = 0
	   NLINE = 1
	   NUM_DTYPES = 0
	   CALL SETAUX(TXT,80)
	   LEN = READSTR(STR,'(',ON_CHAR,,)
	   IF (LEN.GT.0) THEN
	      LEN = READSTR(STR,')',ON_CHAR,,)
	      IF (LEN.GT.0) THEN
		 CALL SETAUX(STRBUF,LEN)
 10		 NEXT = INDEX(STR(1:LEN),',')
		 IF (NEXT.GT.0) LEN = NEXT -1
		 P = INDEX(STR(1:LEN),'D')
		 IF (P.GT.0) THEN
		    CALL SETWIN(1,P-1)
		    IF (RDINT(R)) R = 1
		    PNT = INDEX(STR(1:LEN),'.')
		    IF (PNT.GT.0) THEN
		       CALL SETWIN(P+1,PNT-P-1)
		       IF (RDINT(WID)) WID = 23
		       CALL SETWIN(PNT+1,LEN-PNT)
		       IF (RDINT(DEC)) DEC = 17
		    ENDIF
		    NUM_DTYPES = NUM_DTYPES + 1
		    DTYPES(NUM_DTYPES,1) = TYPE_REAL
		    DTYPES(NUM_DTYPES,2) = R
		    DTYPES(NUM_DTYPES,3) = WID
		    DTYPES(NUM_DTYPES,4) = DEC
		    DO 25 I = 1,R
		       NCOL = NCOL + 1
		       LINES(NLINE,NCOL) = NUM_DTYPES
 25		    CONTINUE
		 ELSE
		    P = INDEX(STR(1:LEN),'A')
		    IF (P.GT.0) THEN
		       CALL SETWIN(1,P-1)
		       IF (RDINT(R)) R = 1
		       CALL SETWIN(P+1,LEN)
		       IF (RDINT(WID)) WID = 4
		       NUM_DTYPES = NUM_DTYPES + 1
		       DTYPES(NUM_DTYPES,1) = TYPE_ASC
		       DTYPES(NUM_DTYPES,3) = WID * R
		       NCOL = NCOL + 1
		       LINES(NLINE,NCOL) = NUM_DTYPES
		    ELSE
		       P = INDEX(STR(1:LEN),'/')
		       IF (P.GT.0) THEN		    
			  NLINE = NLINE + 1
			  NCOL = 0
		       ENDIF
		    ENDIF
		 ENDIF
		 IF (NEXT.GT.0) THEN
		    STR(1:) = STR(NEXT+1:)
		    LEN = 80
		    GOTO 10
		 ENDIF
	      ENDIF
	   ENDIF
	   CALL WRITEF('Format record %S',TXTSTR(1:40))
	   OK = FLRLIN(TXT,,80,)
	   IF (OK.EQ.LSL__EOF) GOTO 220
	   CALL BSLN
	ENDIF
C
	IF (TXTSTR(1:3).EQ.'003') THEN
C
C Interpret 003, order record
C
	   
C
C Read next line
C
	   OK = FLRLIN(TXT,,80,)
	   IF (OK.EQ.LSL__EOF) GOTO 220
	   CALL BSLN
	ENDIF
C
C produce list of feature codes
C
	IF (TXTSTR(1:3).EQ.'080') THEN
!	   FOUND = .FALSE.
!	   DO 90 I = 1,NUM_FCODES
!	      IF (FCODE(I)(1:4).EQ.TXTSTR(5:8)) THEN
!		 FOUND=.TRUE.
!		 GOTO 91
!	      ENDIF
!90	   CONTINUE
!91	   IF (.NOT.FOUND) THEN
!	      NUM_FCODES = NUM_FCODES + 1
!	      FCODE(NUM_FCODES)(1:4) = TXTSTR(5:8)
!	   ENDIF
	   CODE(1:4) = TXTSTR(5:8)
	   IF (NF.GT.0) THEN 
	      CALL EXPAND('EF')
	      CALL FLWLIN(EXPBUF)
	   ENDIF
	   NF = NF + 1
	   CALL FLWSEL(TXTLUN)
	   CALL EXPAND('NF %^W%I0 %^W%I0',NF,NF)
	   CALL FLWLIN(EXPBUF)
	   OK = FLRLIN(TXT,,80,)
	   IF (OK.EQ.LSL__EOF) GOTO 220
	   CALL BSLN
	ELSE
	   NUM = NUM + 1
	   DO 200 I = 1,NLINE	! only two lines for jiffy
	      PTR = 1
	      CALL SETAUX(TXT,80)
	      DO 300 J = 1,3	! only three values per line for jiffy
		 IF (LINES(I,J).NE.0)  THEN
		    RVAL = 0.0
		    CALL SETWIN(PTR,DTYPES(LINES(I,J),3))
		    IF (DTYPES(LINES(I,J),1).EQ.TYPE_REAL) THEN
		       IF (RREAL8(RVAL)) GOTO 240
		    ELSEIF (DTYPES(LINES(I,J),1).EQ.TYPE_ASC) THEN
		       LEN = READSTR(SVAL,,,,)
		    ENDIF
		    PTR = PTR + DTYPES(LINES(I,J),3)
		    IF (I.EQ.1) THEN
		       COORD(NUM,J) = REAL(RVAL)
		       COORD(NUM,1)=ABS(COORD(NUM,1))
		       COORD(NUM,2)=ABS(COORD(NUM,2))
		    ELSEIF (I.EQ.2) THEN
		       IF (DTYPES(LINES(I,J),1).EQ.TYPE_ASC) THEN
			  IF (LEN.GT.0) TXTAC(NUM)(1:LEN) = SVAL(1:LEN)
		       ELSE
			  RAC(NUM,J) = REAL(RVAL)
		       ENDIF
		    ENDIF
		 ENDIF
 300	      CONTINUE
	      OK = FLRLIN(TXT,,80,)
	      IF (OK.EQ.LSL__EOF) GOTO 220
	      CALL BSLN
 200	   CONTINUE
	   IF (COORD(NUM,1).EQ.0.0.AND.COORD(NUM,2).EQ.0.0) THEN
	      NUM = NUM - 1
	      IF (NUM.EQ.1) THEN
		 CALL EXPAND('FS 2 0 0 0')
	      ELSE
		 CALL EXPAND('FS 1 0 0 0')
	      ENDIF
	      CALL FLWLIN(EXPBUF)
	      CALL EXPAND('AC 1 0 "%S"',CODE(1:4))
	      CALL FLWLIN(EXPBUF)
	      P = 1
	      PEN = 0
 201	      CALL EXPAND('CB FL %^W%I0',PEN)
	      CALL FLWLIN(EXPBUF)
	      IF (NUM.EQ.1) THEN 
		 CALL EXPAND('   GT 7')
	      ELSE
		 CALL EXPAND('   GT 1')
	      ENDIF
	      CALL FLWLIN(EXPBUF)
	      IF (NUM.LE.200) THEN
		 CALL EXPAND('   NR %^W%I0',NUM)
	      ELSEIF (NUM-P.GT.200) THEN
		    CALL EXPAND('   NR 200')
	         ELSE
		    CALL EXPAND('   NR %^W%I0',NUM-P+1)
	      ENDIF
	      CALL FLWLIN(EXPBUF)
	      CALL EXPAND('   NC %^W%I0',DTYPES(1,2))
	      CALL FLWLIN(EXPBUF)
!	      CALL EXPAND('   NA %^W%I0',2)
!	      CALL FLWLIN(EXPBUF)
	      IF (DTYPES(1,2).EQ.3) THEN 
		 CALL EXPAND('   HC 91 92 93')
		 CALL FLWLIN(EXPBUF)
		 CALL EXPAND('   DA %F11.4 %F11.4 %F11.4',COORD(P,1),
     &		                                          COORD(P,2),
     &		                                          COORD(P,3))
		 CALL FLWLIN(EXPBUF)
	      ENDIF
	      IF (DTYPES(1,2).EQ.2) THEN
		 CALL EXPAND('   HC 91 92')
		 CALL FLWLIN(EXPBUF) 
		 CALL EXPAND('   DA %F11.4 %F11.4',COORD(P,1),
     &		                                   COORD(P,2))
		 CALL FLWLIN(EXPBUF)
	      ENDIF
	      IF (NUM.GT.1) THEN 
 202		 P = P + 1
		 IF (P.GT.NUM) GOTO  205
		 IF (MOD(P,200).EQ.1) THEN
		    PEN = 1
		    GOTO  201
		 ENDIF
		 IF (DTYPES(1,2).EQ.3) THEN 
		    CALL EXPAND('      %F11.4 %F11.4 %F11.4',COORD(P,1),
     &			                                     COORD(P,2),
     &			                                     COORD(P,3))
		    CALL FLWLIN(EXPBUF)
		 ENDIF
		 IF (DTYPES(1,2).EQ.2) THEN 
		    CALL EXPAND('      %F11.4 %F11.4',COORD(P,1),
     &			                              COORD(P,2))
		    CALL FLWLIN(EXPBUF)
		 ENDIF
		 GOTO 202
 205		 CONTINUE
 	      ENDIF
	      NUM = 0
	   ENDIF
	ENDIF
C
C Got round again
C
	GOTO 1
C
C
C ......................................................................
C
C			E R R O R S 
C
C Unexpected end of file
220	CALL WRITEF('Unexpected EOF')
!221	DO 225 I = 1,NUM_FCODES
!	   CALL FLWSTR(FCODE(I)(1:4),)
!225	CONTINUE
	GOTO 260
C
C Failed to read a line from input file
230	CALL WRITEF('Failed to read line from input file')
	GOTO 260
C
C Error reading coords
C
240	CALL WRITEF('Error reading coords from input file')
	GOTO 260
C
C Error reading text
C
250	CALL WRITEF('Error reading text from input file')
	GOTO 260
C
C Error opening GEN file for output
C
255	CALL WRITEF('Error opening an output file')
	GOTO 260
C
C ......................................................................
C
260	PROCESS_GR = .FALSE.
400	IF (PROCESS_GR) PROCESS_GR=%LOC(SS$_NORMAL)
	RETURN
	END
