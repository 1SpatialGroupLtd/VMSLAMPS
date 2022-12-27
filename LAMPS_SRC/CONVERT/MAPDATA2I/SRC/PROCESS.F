	SUBROUTINE 	PROCESS
CDEC$	IDENT	'18AU94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Process the MAPDATA file
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! current position in IFF file
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
C
	INCLUDE 'CMN:MAPDATA.CMN'
	INCLUDE 'CMN:LINES.CMN'
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
	LOGICAL		OK
C
	INTEGER		LEN
	INTEGER		I
	BYTE		ICH
	BYTE		STAR
C
	INTEGER*2	FC_PART1
	INTEGER*2	FC_PART2
	INTEGER*2	OLDLAYER
	INTEGER*2	LAYER
C
	REAL*4		MD_FC
	INTEGER		XYVAL
	REAL*8		X,Y,Z
	LOGICAL		FIRST_FEATURE
	LOGICAL		HAD_H_OR_L
	LOGICAL		EOF
C
	INTEGER*4	SEGMENT_NUMBER
	CHARACTER*1	CURR_FLAG,PREV_FLAG
C       
	BYTE		CHARBYTE
	INTEGER*4	CHARINT
	EQUIVALENCE	(CHARINT,CHARBYTE)
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
C------------------------------------------------------------------------------
C
!	text_ac = 1001
!	curve_ac = 1002
!	priority_ac = 1003
C
	EOF = .FALSE.
	FIRST_FEATURE = .TRUE.
	HAD_RANGE_SET = .FALSE.
	HAD_H_OR_L    = .FALSE.
C
	SEGMENT = 'SEGMENT'
	CODE    = 'CODE'
C
C Read and discard the first two header lines
C
	CALL FLRSEL(MAPDATALUN)
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
	   EOF = .TRUE.
	   STATUS = LSL__NORMAL			! not an error
	   GOTO 900
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
	   STATUS = RDINT(SEGMENT_NUMBER)
C	   CALL WRITEF( 'FSN #%^W%I0', FSN)
C
	   FSN = FSN + 1
	   NPTS = 0
	   PEN_UP  = .TRUE.
	   DONE_ZS = .FALSE.
	   HAD_AC  = .FALSE.
	   IS_SYMBOL = .FALSE.
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
	   LEN = READSTR(ACTEXT,STAR,ON_CHAR) - 2
	   ACLEN = MAX(0,LEN)
C
C Prevent an integer overflow by first assigning the result of ICHAR to a
C 4 byte int since this can be negative for composite characters and use an
C equivalenced byte when copying the character to the ACBYTE array.
C
	   DO 11 I = 1,ACLEN
	      CHARINT = ICHAR(ACTEXT(I:I))
	      ACBYTE(I) = CHARBYTE
11	   CONTINUE
	   HAD_AC = ACLEN.GT.0
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
C Get first part of real MAPDATA FC
C
	   IF (HAD_PAR) THEN
	      DEFAULT_FC = .FALSE.
!	      LEN = READSTR(ACODE,,ON_SPACE)
	      OK = RDREAL(MD_FC)
C
	      DO 99 I = 1,FC_CNT
!		 IF (ACODE(1:LEN).EQ.MAPDATA_CODE(I)(1:MAPDATA_LEN(I)) ) THEN
		 IF (MD_FC.EQ.MAPDATA_FC(I)) THEN
		    FC_INDEX = I
		    FC = IFF_FC(1,I)
		    GOTO 500
		 ENDIF
99	      CONTINUE
C
C No FC matching found, use default of 0
C
	      IF (HAD_LOG) CALL LSL_PUTMSG
     &			(MD2I__FCDEFAULT,ACODE(1:LEN),CODENUM)
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
C
C Read the X coord
Cxxx
50	   CALL BSLN
	   STATUS = RDDBLE(X)
	   IF (STATUS) THEN				! no coord
	      IF (NPTS.EQ.0) THEN
		 CALL LSL_PUTMSG(MD2I__NOCOORD,RECNUM)
		 GOTO 501				! go back and re-read
	      ELSE
		 GOTO 100				! deal with pts so far
	      ENDIF
	   ENDIF
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C
C Check for any status flags: C for curve, S for straight
C                           : H for high, L for low priority
C
	   CURR_FLAG = ' '
	   EOLN = RDCHS(ICH)
	   IF (.NOT.EOLN) THEN
	      CHARVAL = CHAR(ICH)
	      CURR_FLAG = CHARVAL
	      IF (CHARVAL.EQ.'C') FLAGS(NPTS) = FLAGS(NPTS).OR.'0004'X
	      IF (CHARVAL.EQ.'L') FLAGS(NPTS) = FLAGS(NPTS).OR.'0002'X
	      IF (CHARVAL.EQ.'H') FLAGS(NPTS) = FLAGS(NPTS).OR.'0001'X
	      EOLN = RDCHS(ICH)
	      IF (.NOT.EOLN) THEN
		 CHARVAL = CHAR(ICH)
		 IF (CHARVAL.EQ.'C') FLAGS(NPTS) = FLAGS(NPTS).OR.'0004'X
		 IF (CHARVAL.EQ.'L') FLAGS(NPTS) = FLAGS(NPTS).OR.'0002'X
		 IF (CHARVAL.EQ.'H') FLAGS(NPTS) = FLAGS(NPTS).OR.'0001'X
	      ENDIF
	   ENDIF
C
C Get the next line
C
	   STATUS = FLRLIN()
	   RECNUM = RECNUM + 1
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      EOF = .TRUE.
	      STATUS = LSL__NORMAL
	      CALL COORD( X,Y,Z )
	      GOTO 100
	   ENDIF
C
C If we are to split this feature on a change of interpolation, we should
C process what we've got and create a new feature
C
	   IF (NPTS.EQ.0) PREV_FLAG = CURR_FLAG
	   IF (INTERP(FC_INDEX).EQ.INTERP_BREAK.AND.
     &		      PREV_FLAG.NE.CURR_FLAG) THEN
	      CALL WRITE_FEATURE
	   ENDIF
	   PREV_FLAG = CURR_FLAG
C
C Put the coords into array read for smoothing.
C
	   CALL COORD( X,Y,Z )
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
C
	   GOTO 50
C
C Deal with points so far
C
100	   IF (NPTS.GT.0) CALL WRITE_FEATURE
C
	ENDIF
	IF (.NOT.EOF) GOTO 501
C
C Tidy up
C
900	CONTINUE
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
C and close the MAPDATA file
C
	STATUS = FLRCLO(MAPDATALUN)
C
	RETURN
	END
C
