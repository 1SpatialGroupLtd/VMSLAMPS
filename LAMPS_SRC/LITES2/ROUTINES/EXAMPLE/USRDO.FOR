	SUBROUTINE USRDO(RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example user routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call USRRET
					! = 4 for abort, call USRRET
					! = 5 to create a new feature
					!     (and keep old one if there
					!      was one)
					! = 6 to create a new feature
					!     and delete old one
C
C RETCOD should be set to the required value in this routine
C
C working storage
C
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
	INTEGER*4	IABSENT
	PARAMETER	(IABSENT = '80000000'X)
C
	REAL		DELX,DELY,R
	INTEGER*4	I,J,K
	INTEGER*4	LEN	
	REAL		RVALUE
	INTEGER*4	IVALUE
	EQUIVALENCE	(IVALUE,RVALUE)
	CHARACTER	TMPCH
	CHARACTER*80	STR
	LOGICAL		TO_FILE
C
	GOTO (9000,200,9000,9000,9000,600,700,800,900,1000,
     &	      1100,200) USR_ACTION
	GOTO 9000
C
C listing found object: if there is one, it is done by now, so write
C out a blank line to avoid the LITES2 prompt
C
  200	CONTINUE
	TO_FILE = USR_ACTION .EQ. 12
	IF (TO_FILE) THEN
	   WRITE(6, *) ' '
	   CLOSE(6)
	ELSE
	   PRINT *,' '
	ENDIF
	RETCOD=0			! finished with this action now
	GOTO 9999
C
C setting condition flag.  The current setting has been displayed.
C go onto USRRET to do the rest
C
  600	CONTINUE
	RETCOD=4
	GOTO 9999
C
C altering the position of the current feature.
C
  700	CONTINUE
C
C ask for the vector to move it by
C
	PRINT 728
  728	FORMAT(/'$Enter amount to offset coords in x:- ')
	READ(*,835,END=8000),LEN,STR
	IF (LEN.LE.0) THEN
	   RETCOD = 0
	   GOTO 9999
	ENDIF
	READ (STR,*),DELX
	PRINT 729
  729	FORMAT('$Enter amount to offset coords in y:- ')
	READ(*,835,END=8000),LEN,STR
	IF (LEN.LE.0) THEN
	   RETCOD = 0
	   GOTO 9999
	ENDIF
	READ (STR,*),DELY
	DO 730, I=1,NHPTS
	   COORD(1,I)=COORD(1,I)+DELX
	   COORD(2,I)=COORD(2,I)+DELY
  730	CONTINUE
C
C now join up with action 8
C
	GOTO 1740
C
C action 8
C
  800	CONTINUE
C
C get some ACs from the operator
C
	PRINT 805,NUMACS
  805	FORMAT(' Enter data for up to',I4,' ACs, TCs and CHs'/
     &	       ' Give a C/R to "Type" to exit.'/
     &	       ' (Note: TCs are AC type -1, and CHs are AC type -2)')
  810	FORMAT(/' AC number',I3/)
  815	FORMAT('$Type : ')
  820	FORMAT(Q,I6)
  821	FORMAT(Q,F12.0)
  825	FORMAT('$AC Value : ')
  830	FORMAT('$AC Text  : ')
  835	FORMAT(Q,A)
	DO 845, I=1,NUMACS
	   PRINT 810,I
  840	   PRINT 815
	   READ(*,820,ERR=840),LEN,TYPE(I)
C
C exit condition; C/R
C
	   IF (LEN.EQ.0) THEN
	      NHACS=I-1
	      GOTO 1740
	   ENDIF
C
C check that it is valid type of AC
C
	   IF (TYPE(I).EQ.0.OR.TYPE(I).LT.-2.OR.TYPE(I).GT.32767) THEN
	      PRINT *,'Invalid TYPE'
	      GOTO 840
	   ENDIF
C
C get value for ACs (not for TCs or CHs)
C
  842	   IF (TYPE(I).GT.0) THEN
	      PRINT 825
	      IF (TYPE(I).EQ.3) THEN	! want a real value for AC 3
	         READ(*,821),LEN,RVALUE
	         IF (LEN.EQ.0) GOTO 842
	         VALUE(I)=IVALUE
	      ELSE
	         READ(*,820),LEN,VALUE(I)
	         IF (LEN.EQ.0) GOTO 842
	      ENDIF
	   ENDIF
	   PRINT 830
	   READ (*,835) TXTL(I),TXT(I)
  845	CONTINUE	   
	NHACS=NUMACS	
C
C ask whether to delete original feature or not
C
 1740	CONTINUE
	PRINT 1750
 1750	FORMAT(/'$Retain old feature? (Y/N):- ')
	READ(*,1760,ERR=1740),I,TMPCH
 1760	FORMAT(Q,A)
C
C only accept y,n,Y or N in reply
C
	IF (I.EQ.1.AND.
     &	   (TMPCH.EQ.'Y'.OR.TMPCH.EQ.'N'.OR.
     &	    TMPCH.EQ.'y'.OR.TMPCH.EQ.'n')) THEN
	   IF (TMPCH.EQ.'Y'.OR.TMPCH.EQ.'y') THEN
	      RETCOD=5
	   ELSE
	      RETCOD=6
	   ENDIF
	ELSE
	   GOTO 1740
	ENDIF	   
C
C set up variables for USRSTO
C
	USR_NCOORD=NHPTS
	USR_NACS=NHACS
C
C get new data for feature
C C/R = use current value
C  -1 = use current default for feature construction
C
 1771	FORMAT('$Enter FSN   [',I5,
     &		']  to use (-1 for use attribute set): ')
 1772	FORMAT('$Enter FC(',I1,') [',I5,
     &		']  to use (-1 for use attribute set): ')
 1773	FORMAT('$Enter Map   [',I5,
     &		']  to use (-1 for use attribute set): ')
 1774	FORMAT('$Enter Layer [',I5,
     &		']  to use (-1 for use attribute set): ')
 1775	FORMAT('$Enter TH    [',I5,
     &	        ']  to use (-1 for use attribute set): ')
 1776	FORMAT('$Enter ROT   [',F5.3,
     &	        ']  to use (-1 for use attribute set): ')
C
C feature serial number
C
	PRINT 1771,USR_FSN
	READ(*,820,END=8000),LEN,I
	IF (LEN.GT.0) USR_FSN=I
C
C feature status
C
	DO 1780, J=1,4
	   PRINT 1772,J,USR_FC(J)
	   READ(*,820,END=8000),LEN,I
	   IF (LEN.GT.0) USR_FC(J)=I
 1780	CONTINUE
C
C map
C
	PRINT 1773, USR_MAP
	READ(*,820,END=8000),LEN,I
	IF (LEN.GT.0) USR_MAP=I
C
C layer
C
	PRINT 1774, USR_LAYER
	READ(*,820,END=8000),LEN,I
	IF (LEN.GT.0) USR_LAYER=I
C
C text height
C
	PRINT 1775, USR_THK
	READ(*,820,END=8000),LEN,I
	IF (LEN.GT.0) USR_THK=I
C
C rotation for text or oriented symbols
C
	PRINT 1776, USR_ROTAT
	READ(*,821,END=8000),LEN,R
	IF (LEN.GT.0) THEN
	   USR_ROTAT=R
C
	   DO 1791, I = 1,NHTXTS
	      FEATTXRO(I) = R
1791	   CONTINUE
	ENDIF
C
	PRINT *,' '
	PRINT *,' '
	GOTO 9999			! finished
C
C send a command line to LITES2. Go straight to USRRET
C
  900	CONTINUE
	RETCOD=4
	GOTO 9999
C
C construct several features
C
 1000	CONTINUE
C
C have we been passed the window?
	GOT_WIN = .FALSE.
	IF (USR_STRL.GT.0) THEN
	   READ (USR_STR(1:USR_STRL),*,ERR=1050),LXWIN,UXWIN,LYWIN,UYWIN
	   GOT_WIN = .TRUE.
	ENDIF
C
C ask for number of features to create
	IF (GOT_WIN.AND.FIRST_DO) THEN
 1001	   FORMAT('$Number of new features to create [',I1,']: ')
	   NEW_FEAT = 2
	   PRINT 1001,NEW_FEAT
	   READ(*,820,END=8000),LEN,I
	   IF (LEN.GT.0) NEW_FEAT = I
	   NEW_FEAT_COUNT = -1
	   FIRST_DO = .FALSE.
	ENDIF
 1050	IF (FIRST_DO) THEN
	   RETCOD=4
	ELSE
	   RETCOD = 5			! call USRSTO
	ENDIF
	GOTO 9999
C
C set a LITES2 variable. Go straight to USRRET
C
 1100	CONTINUE
	RETCOD=4
	GOTO 9999
C
C had an CTRL Z
 8000	CONTINUE
	RETCOD = 0
	GOTO 9999
C
C invalid action
C
 9000	CONTINUE
	PRINT 9010,USR_ACTION
 9010	FORMAT(' Unknown action',I6,' for user routine USRDO'//
     &	       ' User routine being aborted'/)
C
	RETCOD=0
C
 9999	CONTINUE
	RETURN
	END
