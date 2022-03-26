	LOGICAL FUNCTION READLL(RESULT,NUMVAL)
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					DRC	28-Oct-1985
C
C		Modified version of RDFANG
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C
C	To read lat/long values and convert to seconds of arc.
C 	Reads a free format angle from TXTC the current text buffer
C 	returning TRUE if an error occurs, FALSE if it all works
C
C 	The required format is 
C	[DD]D [MM] [SS] H	where H is hemisphere
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 	'LSL$CMNLSL:TXTC.CMN'
C
C Arguments
C
	INTEGER*4	NUMVAL
	INTEGER*4	RESULT(NUMVAL)	! lat and long in seconds
C
C Functions
C
	LOGICAL		RDCHS	! read a char, exact
	LOGICAL		RDINT	! read a number (int*2)
C
C Local variables
C
	INTEGER*4	I,J	! counter
	INTEGER*4	LAT,LONG
	INTEGER*4	ACCUM	! accumulate angle in here
	INTEGER*4	NUMBER
	INTEGER*2	NUM	! an integer
	BYTE		CH	! a character
C
	EQUIVALENCE	(NUM,NUMBER)
C
C------------------------------------------------------------------------------
C
	READLL = .TRUE.		! be pessimistic
	LAT=1			! results to be in order LAT,LONG etc	
	LONG=2
C
	CALL BSLN
C
	DO 500 I=1,NUMVAL
C
C	Set to first numeric character (ie skip ',', '-' etc)
C
	   DO 100 J=DCPTR,TXTPTR
	      IF (RDCHS(CH)) GOTO 999	! error
	      IF (CH.GT.47.AND.CH.LT.58) GOTO 150
100	   CONTINUE
C
150	CONTINUE
	CALL BSCH
C
C	Read degree part - occupying 3 characters
C
	ACCUM = 0
C
	IF ( RDINT(NUM) ) GOTO 999
C
C 	and accumulate our result...
C
	ACCUM = NUMBER * 3600		! in seconds
C
C	Test if minutes is present
C
250	IF(RDCHS(CH))THEN
	  GOTO 999
	ELSE
	  IF(CH.GT.64) GOTO 300		! alpha character
	  IF(CH.LT.48.OR.CH.GT.57) GOTO 999
	  CALL BSCH
	ENDIF
C
C 	Minutes
C
	IF ( RDINT(NUM) ) GOTO 999
C
C 	and accumulate...
C
	ACCUM = ACCUM + NUMBER*60	! in seconds
C
C	Test if seconds is present
C
270	IF(RDCHS(CH))THEN
	  GOTO 999
	ELSE
	  IF(CH.GT.64) GOTO 300		! alpha character
	  IF(CH.LT.48.OR.CH.GT.57) GOTO 999
	  CALL BSCH
	ENDIF
C
C 	Seconds
C
	IF ( RDINT(NUM) ) GOTO 999
C
C 	otherwise, accumulate this too
C
	ACCUM = ACCUM + NUMBER		! seconds
C
C	Hemisphere character
C
280	IF (RDCHS(CH)) GOTO 999
C
C Check that entries are LAT LONG and put in RESULT
C
300    	IF (CH.EQ.'E'.OR.CH.EQ.'e'.OR.CH.EQ.'W'.OR.CH.EQ.'w') THEN
	   IF (CH.EQ.'W'.OR.CH.EQ.'w') ACCUM= -ACCUM
	   RESULT(LONG)=ACCUM
	   IF ((LONG+2).LE.NUMVAL) LONG=LONG+2
	ELSEIF (CH.EQ.'N'.OR.CH.EQ.'n'.OR.CH.EQ.'S'.OR.CH.EQ.'s') THEN
	   IF (CH.EQ.'S'.OR.CH.EQ.'s') ACCUM= -ACCUM 
	   RESULT(LAT)=ACCUM
	   IF ((LAT+2).LE.(NUMVAL-1)) LAT=LAT+2
	ELSE
	   GOTO 999
	ENDIF
C
500	CONTINUE
C
	READLL = .FALSE.
C
999     RETURN
C
	END
