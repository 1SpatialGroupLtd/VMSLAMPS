	SUBROUTINE 	PROCESS
CDEC$	IDENT	'28SE94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C       Mod 1400. Now part of MAPDATA2I		01-Sep-1994	Steve Townrow
C
C Description:
C
C	Process the MAPDATA file. Once we have all the point of a feature,
C       we call PROCESS_LINE to deal this it.
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
C Functions
C
	LOGICAL		COORD
	LOGICAL		PROCESS_LINE
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		READSTR
	LOGICAL		RDCHS
	LOGICAL		RDCH
	LOGICAL		RDINT
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	LOGICAL		SIGCHS
C
C Workspace
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
	CHARACTER*8	MD_FC
	INTEGER		XYVAL
	REAL*4		X,Y,Z
	LOGICAL		FIRST_FEATURE
	LOGICAL		HAD_H_OR_L
	LOGICAL		EOF
	LOGICAL		OK
C
	INTEGER*4	NUM
	INTEGER*4	SEGMENT_NUMBER
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
C
C------------------------------------------------------------------------------
C
C Clear the first element of the MapData -> IFF FC mapping array
C
	MAPDATA_FC(0) = '        '
	IFF_FC(1,0) = 0
	IFF_FC(2,0) = 0
	INTERP(0) = INTERP_UNDEFINED
C
C Set up some things
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
	CALL IFFNO(1,0,0)		! start a new layer
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
C Interpret the current line
C
501	CALL BSLN
	HAD_H_OR_L = .FALSE.
	LEN = READSTR(RECTYPE,,ON_SPACE)
C
C------------------------------------------------------------------------------
C SEGMENT command
C
	IF ( RECTYPE(1:LEN) .EQ. SEGMENT) THEN
	   STATUS = RDINT(SEGMENT_NUMBER)
C
C Count the segment
C
	   IF (FSN.EQ.32767) FSN = 1
	   FSN = FSN + 1
	   NPTS = 0
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
C Get text string, removing the trailing two spaces
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
C------------------------------------------------------------------------------
C CODE command
C
	ELSEIF( RECTYPE(1:LEN) .EQ. CODE) THEN
C
C Store line number of code
C
	   CODENUM = RECNUM
C
C Get the real MAPDATA FC
C
	   DEFAULT_FC = .FALSE.
	   MD_FC = '       '
	   LEN = READSTR(MD_FC,,,,)
	   IF (LEN.EQ.0) GOTO 99
C
C Find it's position in the list
C
	   DO 98 I = 1,FC_CNT
	      IF (MD_FC(1:LEN).EQ.MAPDATA_FC(I)(1:SIGCHS(MAPDATA_FC(I)))) THEN
		 FC_INDEX = I
		 FC = IFF_FC(1,I)
		 GOTO 500
	      ENDIF
98	   CONTINUE
C
C No FC matching found, use default of 0
C
99	   IF (HAD_LOG) CALL LSL_PUTMSG
     &			(MD2I__FCDEFAULT,MD_FC(1:LEN),CODENUM)
C
C Set default FC flag to set depending on no. of coords found later
C
	   DEFAULT_FC = .TRUE.
	   GOTO 500
C
C------------------------------------------------------------------------------
C Read block of coords.
C
	ELSE
C
C Read the X coord
C
50	   CALL BSLN
	   STATUS = RDREAL(X)
	   IF (STATUS) THEN				! no coord
	      IF (NPTS.EQ.0) THEN
		 CALL LSL_PUTMSG(MD2I__NOCOORD,RECNUM)
		 GOTO 501				! go back and re-read
	      ELSE
		 GOTO 100				! deal with pts so far
	      ENDIF
	   ENDIF
C
	   STATUS = RDREAL(Y)
	   STATUS = RDREAL(Z)
C
C Store the point
C
	   STATUS = COORD( X,Y,Z )
	   IF (.NOT.STATUS) GOTO 999
C
C Check for any status flags: C for curve
C                           : H for high, L for low priority
C And store it.
C
	   EOLN = RDCHS(ICH)
	   IF (.NOT.EOLN) THEN
	      CHARVAL = CHAR(ICH)
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
C
C Check for End-of-File
C
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      EOF = .TRUE.
	      STATUS = LSL__NORMAL
	      GOTO 100
	   ELSE
	      GOTO 50
	   ENDIF
C
C Deal with points so far
C
100	   IF (NPTS.GT.0) THEN
	      OK = PROCESS_LINE()
	      IF (.NOT.OK) GOTO 999
	   ENDIF
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
999	RETURN
	END
C
