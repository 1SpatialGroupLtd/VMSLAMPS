	PROGRAM HELPGEN
C
***	MODULE	HELPGEN
***	IDENT	08OC84
C
C Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
C Author Paul Hardy			Created 5-Oct-1984
C
C LITES2 Help file generator
C
	IMPLICIT NONE
C
	CHARACTER	FILENAME*60	! used for both input and output
	CHARACTER	LINE*132	! input line
	CHARACTER	STATES*132	! allowable states
	CHARACTER	LETTERS*50	! command state or arg letters
	CHARACTER	ARGS*50		! command arguments
	CHARACTER	CH*1		! character
	INTEGER		ITAB		! index of first tab
	INTEGER		ITAB2		! index of second tab
	INTEGER		ICOMMA		! index of first comma
	INTEGER		ICOMMA2		! index of second comma
	INTEGER		ISEMI		! index of first semicolon
	INTEGER		IENAM		! end of name
	INTEGER		LINLEN		! line length
	INTEGER		STATLEN		! state table length
	INTEGER		STATNUM		! no of states
	INTEGER		ARGLEN		! argument table length
	INTEGER		IERR		! function error return code
	INTEGER		NAMLEN		! name length or error
	INTEGER		I		! do loop variable
C
C functions called
	INTEGER*2	TXTCML		! read from command line
	LOGICAL*1	RDFILT		! read file title
C
C
C open input file
C
50	OPEN (UNIT=1,NAME='INPUT',TYPE='OLD',READONLY,SHARED,
     &     CARRIAGECONTROL='LIST')
C
C and output
C
	OPEN (UNIT=2,NAME='OUTPUT',TYPE='NEW',CARRIAGECONTROL='LIST')
C
C Now loop reading lines from source
C
100	READ(1,1000,END=999)LINLEN,LINE
1000	FORMAT(Q,A)
	IF (LINLEN.LE.0) GOTO 100	! skip blank lines
	IF (LINE(1:6).NE.'	$CMD	') GOTO 100	! skip crud
C
C skip up to after second tab for name, and comma for end of name
C
	ITAB=INDEX(LINE(1:LINLEN),'	')
	IF (ITAB.LE.0) GOTO 900
	IF (ITAB.GE.LINLEN) GOTO 900
	ITAB2=INDEX(LINE(ITAB+1:LINLEN),'	')+ITAB
	ICOMMA=INDEX(LINE(ITAB2+1:LINLEN),',')+ITAB2
	IENAM=ICOMMA-1
	IF (LINE(ITAB2+1:ITAB2+1).EQ.'<') THEN
	   ITAB2=ITAB2+1
	   LINE(ICOMMA:ICOMMA)=' '
	ENDIF
C
C then comma for start of args and next for start of states
C
	ICOMMA=INDEX(LINE(ITAB2+1:LINLEN),',')+ITAB2
	ICOMMA2=INDEX(LINE(ICOMMA+1:LINLEN),',')+ICOMMA
C
C then semicolon for description
C
	ISEMI=INDEX(LINE(ICOMMA2+1:LINLEN),';')+ICOMMA2
C
C uppercase first char of comment
C
	CALL STR$UPCASE(LINE(ISEMI+2:ISEMI+2),LINE(ISEMI+2:ISEMI+2))
C
C put together state description
C
	LETTERS=LINE(ICOMMA2+2:ISEMI-1)
	STATLEN=1
	STATNUM=0
	STATES=' '
	IF (INDEX(LETTERS,'I').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' INIT'
	   STATLEN = STATLEN+5
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'R').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' READY'
	   STATLEN = STATLEN+6
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'L').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' LINE'
	   STATLEN = STATLEN+5
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'T').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' TEXT'
	   STATLEN = STATLEN+5
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'S').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' SYMBOL'
	   STATLEN = STATLEN+7
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'E').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' EDIT'
	   STATLEN = STATLEN+5
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'M').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' MODIFY'
	   STATLEN = STATLEN+7
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'O').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' ON'
	   STATLEN = STATLEN+3
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'V').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' WINDOW'
	   STATLEN = STATLEN+7
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'C').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' CONSTRUCT'
	   STATLEN = STATLEN+10
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'A').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' AC'
	   STATLEN = STATLEN+3
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'D').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' DEBUG'
	   STATLEN = STATLEN+6
	   STATNUM = STATNUM+1
	ENDIF
	IF (INDEX(LETTERS,'G').NE.0) THEN
	   STATES=STATES(1:STATLEN)//' RECOVER'
	   STATLEN = STATLEN+8
	   STATNUM = STATNUM+1
	ENDIF
C
C put together argument description
C
	ARGLEN=1
	ARGS=' '
	DO 200 I=1,ISEMI-ICOMMA2+2
	   IF (LETTERS(I:I).EQ.'1') THEN
	      ARGS=ARGS(1:ARGLEN)//' filename'
	      ARGLEN = ARGLEN+9
	   ENDIF
	   IF (LETTERS(I:I).EQ.'3') THEN
	      ARGS=ARGS(1:ARGLEN)//' text'
	      ARGLEN = ARGLEN+5
	   ENDIF
	   IF (LETTERS(I:I).EQ.'4') THEN
	      ARGS=ARGS(1:ARGLEN)//' text'
	      ARGLEN = ARGLEN+5
	   ENDIF
200	   CONTINUE
	LETTERS=LINE(ICOMMA+1:ICOMMA2-1)
	DO 300 I=1,ICOMMA2-ICOMMA-1
	   IF (LETTERS(I:I).EQ.'I') THEN
	      ARGS=ARGS(1:ARGLEN)//' integer'
	      ARGLEN = ARGLEN+8
	   ENDIF
	   IF (LETTERS(I:I).EQ.'R') THEN
	      ARGS=ARGS(1:ARGLEN)//' real'
	      ARGLEN = ARGLEN+5
	   ENDIF
	   IF (LETTERS(I:I).EQ.'M') THEN
	      ARGS=ARGS(1:ARGLEN)//' subcommand'
	      ARGLEN = ARGLEN+11
	   ENDIF
300	   CONTINUE
C
C output it all
C
	WRITE(2,2001)LINE(ITAB2+1:IENAM)
2001	FORMAT(/'1 ',A)
	WRITE(2,2006)LINE(ISEMI+2:LINLEN)
2006	FORMAT(A)
	WRITE(2,2002)LINE(ITAB2+1:IENAM),ARGS
2002	FORMAT(/'Format:  ',A,A)
	IF (STATLEN.LE.60) THEN
	   IF (STATNUM.LE.1) THEN
	      WRITE(2,2003)STATES(1:STATLEN)
2003	      FORMAT(/'Valid in state',A)
	   ELSE
	      WRITE(2,2004)STATES(1:STATLEN)
2004	      FORMAT(/'Valid in states',A)
	   ENDIF
	ELSE
	   WRITE(2,2004)':'
	   WRITE(2,2005)STATES(3:STATLEN)
2005	   FORMAT(A)
	ENDIF
	GOTO 100
C
C error in message layout
C
900	TYPE *,'Error in message layout'
	TYPE *,LINE(1:LINLEN)
	GOTO 100
C
C Here at end of file
C
999	CLOSE(UNIT=1)
	CLOSE(UNIT=2)
	CALL EXIT
	END
