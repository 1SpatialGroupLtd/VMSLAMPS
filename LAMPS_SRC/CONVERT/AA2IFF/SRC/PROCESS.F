	SUBROUTINE 	PROCESS
CDEC$	IDENT	'19AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Process the AA file
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:AA2IFFMSG.PAR'		! AA2IFF messages
C
	INCLUDE 'CMN:AA.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
	INTEGER		EOLN
	INTEGER		STATUS
	INTEGER*2	IECODE		! IFF entry type
	INTEGER*2	IELEN		! IFF entry length
C
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		READSTR
	LOGICAL		RDCHS
	LOGICAL		RDCH
	LOGICAL		RDINT
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	LOGICAL		RDDBLE
C
	INTEGER		LEN
	INTEGER*2	ACLEN
	INTEGER		I
	BYTE		ICH
	BYTE		ACBYTE(80)
	BYTE		STAR
C
	INTEGER*2	FC_PART1
	INTEGER*2	FC_PART2
	INTEGER*2	OLDLAYER
	INTEGER*2	LAYER
C
	INTEGER		XYVAL
	REAL*8		X,Y,Z
	LOGICAL		FIRST_FEATURE
	LOGICAL		HAD_H_OR_L
	LOGICAL		HAD_AC
C
C Record types
C
	CHARACTER*7	RECTYPE
	CHARACTER*7	SEGMENT
	CHARACTER*4	CODE
	CHARACTER*1	CHARVAL
	CHARACTER*1	CHARNUM
	CHARACTER*80	ACTEXT
	CHARACTER*32	ACODE
C
C-------------------------------------------------------------------------------
C
	FIRST_FEATURE = .TRUE.
	HAD_RANGE_SET = .FALSE.
	HAD_H_OR_L    = .FALSE.
C
	SEGMENT = 'SEGMENT'
	CODE    = 'CODE'
C
C Read and discard the first two header lines
C
	CALL FLRSEL(AALUN)
C
	RECNUM = 0
	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
	STAR   = '*'
C
C Read the range record
C
	CALL SET_TXTLIM(80)
	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
C
	CALL BSLN
	STATUS = RDREAL(XMAX)
	STATUS = RDREAL(YMAX)
	XMIN = XMAX
	YMIN = YMAX
C
	CALL IFF_START			! Write start of IFF file
C
	IF (HAD_PAR) CALL IFFNO(1,0,0)	! start new single layer
C	
C Now read the data for real
C
	CALL SET_TXTLIM(80)
C
C Read next line
C
500	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
	IF (STATUS .EQ. LSL__EOF) THEN
	   STATUS = LSL__NORMAL			! not an error
	   GOTO 999
	ENDIF
C
501	CALL BSLN
	HAD_H_OR_L = .FALSE.
	LEN = READSTR(RECTYPE,,ON_SPACE)
C	CALL WRITEF( 'Record #%^L%I0 is type %S',RECNUM,RECTYPE(1:LEN) )
C
C SEGMENT command
C
	IF ( RECTYPE(1:LEN) .EQ. SEGMENT) THEN
	   STATUS = RDINT(FSN)
C	   CALL WRITEF( 'FSN #%^W%I0', FSN)
C
	   ZSPTR = 0
	   PEN_UP  = .TRUE.
	   DONE_ZS = .FALSE.
	   HAD_AC  = .FALSE.
	   IS_SYMBOL = .FALSE.
	   DONE_START_FEATURE = .FALSE.
C
	   STATUS = RDCHS(ICH)
	   IF (STATUS) GOTO 500		! no char found
C
	   IF (ICH.NE.'*') GOTO 500	! no '*' found
C
C Found first '*', get second
C
	   STATUS = RDCHS(ICH)
	   IF (STATUS) GOTO 500		! no char found
C
	   IF (ICH.NE.'*') GOTO 500	! no '*' found
C
C Found second '*', get text string for AC
C
	   STATUS = RDCHS(ICH)
	   IF (STATUS) GOTO 500		! no char found
C
	   IF (ICH.EQ.'*') GOTO 500	! '*' found, no text present
C
C Get text string
C
	   CALL BSCH
	   LEN = READSTR(ACTEXT,STAR,ON_CHAR)
	   ACLEN = LEN
	   DO 11 I = 1,LEN
	      ACBYTE(I) = ICHAR(ACTEXT(I:I))
11	   CONTINUE
	   HAD_AC = .TRUE.
C
	   GOTO 500
C
C CODE command
C
	ELSEIF( RECTYPE(1:LEN) .EQ. CODE) THEN
C
C Store line number of code
C
	   CODENUM = RECNUM
C
C Get first part of real AA FC
C
	   IF (HAD_PAR) THEN
	      DEFAULT_FC = .FALSE.
	      LEN = READSTR(ACODE,,ON_SPACE)
C
	      DO 99 I = 1,FC_CNT
		 IF (ACODE(1:LEN).EQ.AA_CODE(I)(1:AA_LEN(I)) ) THEN
		    FC = IFF_FC(I)
		    GOTO 500
		 ENDIF
99	      CONTINUE
C
C No FC matching found, use default of 0
C
	      if (had_log) CALL LSL_PUTMSG
     &			(AA2I__FCDEFAULT,ACODE(1:LEN),CODENUM)
C
C Set default FC flag to set depending on no. of coords found later
C
	      DEFAULT_FC = .TRUE.
	      GOTO 500
	   ELSE
C
C read 1st digit - first part of FC ** SHOULD BE RDCHS? **
C
	      STATUS = RDCH(ICH)
	      STATUS = RDCH(ICH)
	      CHARNUM = CHAR(ICH)
	      READ(CHARNUM,*) FC_PART1
C	      CALL WRITEF( 'FC_PART1 #%^W%I0',FC_PART1 )
C
C read 2nd digit - layer number
C
	      STATUS = RDCH(ICH)
	      CHARNUM = CHAR(ICH)
	      READ(CHARNUM,*) LAYER
	      IF (FIRST_FEATURE) THEN
	         CALL IFFNO(LAYER,0,0)		! start new layer
	         OLDLAYER = LAYER
C	         CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	      ENDIF   
C
	      IF (OLDLAYER.NE.LAYER) THEN
	         CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	         CALL IFFEO			! end the layer
C
	         LPOSNO = LPOSE
	         CALL IFFNO(LAYER,0,0)		! start new layer
	         OLDLAYER = LAYER
C	         CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	      ENDIF
C
C read 3rd digit - skip the point
C
	      STATUS = RDCH(ICH)
C
C read last two digits as a number - second part of FC
C
	      STATUS = RDINT(FC_PART2)
C
	      FC = (FC_PART1*1000) + FC_PART2
C	      CALL WRITEF( 'FC_PART2 #%^W%I0',FC_PART2 )
C
	      IF (FIRST_FEATURE) FIRST_FEATURE = .FALSE.
C
	      GOTO 500
	   ENDIF
C
C Read block of coords.
C
	ELSE
	   CALL BSLN
	   STATUS = RDDBLE(X)
	   IF (STATUS) THEN				! no coord
	      CALL LSL_PUTMSG(AA2I__NOCOORD,RECNUM)
	      GOTO 501					! go back and re-read
	   ENDIF
C
C Set ISQ to 0 to count ISN and start feature
C
	   ISQ = 0
	   CALL IFFNF(FSN, ISQ)
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
	   CALL COORD( X,Y,Z )
C
	   STATUS = FLRLIN()
	   RECNUM = RECNUM + 1
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      STATUS = LSL__NORMAL
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
	      CALL IFFEF
	      GOTO 999
	   ENDIF
C
C Try to read second line as coord 
C
	   CALL BSLN
	   STATUS = RDDBLE(X)
C
	   IF (STATUS) THEN		! not a second coord - Symbol
	      IS_SYMBOL = .TRUE.
	      IF (DEFAULT_FC) FC = 999
	   ELSE
	      IS_SYMBOL = .FALSE.
	      IF (DEFAULT_FC) FC = 0
	   ENDIF
C
	   CALL START_FEATURE
	   I = ACLEN
	   IF (HAD_AC) CALL IFFAC(1,I,ACBYTE,ACLEN)
C
	   IF (STATUS) THEN		! not a second coord
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
	      CALL IFFEF
	      GOTO 501			! go back and re-read the line
	   ENDIF
C
C Was a second coord line, continue reading y,z
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
	   CALL COORD( X,Y,Z )
C
C Cycle round further coord lines
C
20	   STATUS = FLRLIN()
	   RECNUM = RECNUM + 1
	   IF (STATUS .EQ. LSL__EOF) THEN
	      STATUS = LSL__NORMAL
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
	      CALL IFFEF
	      GOTO 999
	   ENDIF
C
	   CALL BSLN
	   STATUS = RDDBLE(X)
	   IF (STATUS) THEN		! not a coord
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
C	      CALL IFFEF
	      GOTO 501			! go back and re-read the line
	   ENDIF
C
C Was a second coord line, continue reading y,z
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
	   CALL COORD( X,Y,Z )
C
	   GOTO 20
	ENDIF
C
C
C	   IF (.NOT.HAD_H_OR_L) THEN
C	      STATUS = RDCHS(ICH)
C	      EOLN = RDCHS(ICH)
C	      IF (.NOT.EOLN) THEN
C		 CHARVAL = CHAR(ICH)
C		 IF (CHARVAL.NE.'C') THEN
C		    CALL IFFAC(2,1)
C		    HAD_H_OR_L = .TRUE.
C		 ELSE
C		    STATUS = RDCHS(ICH)
C	            EOLN = RDCHS(ICH)
C		    IF (.NOT.EOLN) THEN
C		       CALL IFFAC(2,1)
C		       HAD_H_OR_L = .TRUE.
C		    ENDIF
C		 ENDIF
C	      ENDIF
C	   ENDIF
C
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
	CALL IFFCLO(IFFLUN)
C
C and close the AA file
C
	STATUS = FLRCLO(AALUN)
C
	RETURN
	END
C
