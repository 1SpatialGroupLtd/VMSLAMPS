	LOGICAL FUNCTION GET_CP
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Nov-1990
C
C Description:
C
C	Module GET_CP called by ARC2I in package CONVERT.
C	Reads the Corner Point information from the .BND section in the EXPORT
C	file. It is called from CREATE_TEMP when copying IFO section across.
C	If there are 4 points then they are used but if there are more than 4
C	then a polygon around data was used. In this case a Max-Min box is 
C	calculated.
C	
C-------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:EXCEPTION.CMN'	! LSLLIB exceptions
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:IFFINFO.CMN'		! IFF information
	INCLUDE	'HERE:GENERAL.CMN'		! General information
C
C Functions
C
	INTEGER*4	GET_EXP_LINE		! Get EXPORT line into TXTBUF
	LOGICAL		RDINT			! Read integer
	LOGICAL		RDREAL			! Read real
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
	INTEGER*4	NUMLINES		! Number of table lines
	INTEGER*4	NUMENT			! Number of table entries
	INTEGER*4	I,J			! Loop counts
	LOGICAL		NODIG			! Success of reading digit
	CHARACTER*80	LINE			! The current EXPORT line
	CHARACTER*80	MSG			! Message string for PUTMSG
	INTEGER*4	MSGLEN			! Message length
	REAL		RX,RY			! X and Y of each control pt
	REAL		XMIN,XMAX		! Max and Min in X
	REAL		YMIN,YMAX		! Max and Min in Y
C
	EQUIVALENCE	(TXTBUF(1),LINE)
C
C------------------------------------------------------------------------------
C
C Add /LOG messages....
C
C Initial values for Corner Points.
C
	XMIN =  1.0E+30
	XMAX = -1.0E+30
	YMIN =  1.0E+30
	YMAX = -1.0E+30
C
C Assume success
C
	STATUS = .TRUE.
C
C Reset buffer and pointer to TXTBUF
C
	CALL BSLN
C
C If we get an error, give some helpful info to PUTMSG..
C
	MSGLEN = 25
	MSG(1:MSGLEN) = '.BND table in IFO section'
C
	CALL SETWIN(36,3)		! number of table lines
	NODIG = RDINT(NUMLINES)
	IF (NODIG) GOTO 8000
C
	CALL SETWIN(53,4)		! number of table entries
	NODIG = RDINT(NUMENT)
	IF (NODIG) GOTO 8000
C
C Skip informational lines in table ... and read next line
C
	DO 100 I = 1,NUMLINES
	   STATUS = GET_EXP_LINE()
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
100	CONTINUE
C
C Now read control points
C
	DO 200 I = 1,NUMENT
	   STATUS = GET_EXP_LINE()
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	   IF (I.GT.1) GOTO 200		! still need to read off lines
C
	   CALL DCPSET(1)               ! set decode ptr to read free-format
C
	   NODIG = RDREAL(XMIN)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(YMIN)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(XMAX)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(YMAX)
	   IF (NODIG) GOTO 8000
C
200	CONTINUE
C
	RANGE(1) = XMIN
	RANGE(2) = XMAX
	RANGE(3) = YMIN
	RANGE(4) = YMAX
C
	CPS(1,1) = XMIN
	CPS(2,1) = YMAX
	CPS(1,2) = XMIN
	CPS(2,2) = YMIN
	CPS(1,3) = XMAX
	CPS(2,3) = YMIN
	CPS(1,4) = XMAX
	CPS(2,4) = YMAX
C
C and copy over to the destination side of the CPs
C
	DO 400 I=3,4
	   DO 300 J=1,4
	      CPS(I,J) = CPS(I-2,J)
300	   CONTINUE
400	CONTINUE
C
	GOTO 9000
C
C Errors
C
8000	STATUS = ARC2I__ERRRDNUM
	CALL LSL_PUTMSG( STATUS,MSG(1:MSGLEN) )
	CALL LSL_ADDMSG( ERRNUM )             ! LSLLIB exception
	IF ( ERRNUM.EQ.LSL__HADEXCP ) CALL LSL_ADDMSG( LSL_EXCP )
C
9000	GET_CP = STATUS
C
	RETURN
	END
