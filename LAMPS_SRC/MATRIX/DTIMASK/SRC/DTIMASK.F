	PROGRAM DTIMASK
C
CDEC$	IDENT	'19JN91'
C
C Copyright Laser-Scan Laboratories Limited, Cambridge, England.
C
C	Created					CCB 	17-Jun-1991
C
C DTIMASK is a MATRIX jiffy utility to combine up to 255 byte DTI files,
C setting given values in the output file wherever an input file is non-zero.
C
	IMPLICIT NONE
C
C Parameters
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'
	INCLUDE 'LSL$CMNDTI:DTILIBMSG.PAR'
C
C Common:
	INCLUDE	'HERE:FILES.CMN'
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'
	INCLUDE	'LSL$CMNLSL:CMDCOM.CMN'
C
	INTEGER	DTI_OPEN
	INTEGER	DTI_CREATE
	INTEGER	DTI_CLOSE
	INTEGER	DTI_COPY_HEADER
	INTEGER	DTI_MINMAX_DATA
	INTEGER	TTRSTR
	INTEGER	GETFILNAM	! read file-spec
	LOGICAL RDCHS		! read character from line
	INTEGER	RDCOMM		! decode command
C
C workspace
	INTEGER	NFIL			! number of files
	INTEGER	OK,IERR			! function returns
	INTEGER	XSIZE,YSIZE
	LOGICAL	HEADER
C
	INTEGER	I			! loop var
	INTEGER	CMD			! command number
	BYTE	CH			! a character
C
C Command tables
	EXTERNAL	DTIMASK_CMD_TABLE
C
C.......................................................................
C
C Init libraries
	CALL LSL_INIT(.TRUE.)
	CALL DTI_INIT
	NFIL = 0
	HEADER = .FALSE.
C
C ......................................................................
C
C Get an input line from the terminal
10	OK = TTRSTR(,,'DTIMASK> ')
	IF (.NOT.OK) GOTO 999
C
C decode the line
	CALL BSLN
C
C Look for comment
	IF (RDCHS(CH)) GOTO 10		! substantially empty line
	IF (CH.EQ.'!') GOTO 10		! comment
	CALL BSCH
C
	CMD = RDCOMM(DTIMASK_CMD_TABLE)
	GOTO (
     &		110,			! file n
     &		120,			! fileout
     &		999,			! quit
     &		140			! go
     &	      		), CMD
C
C command number out of range
	GOTO 10
C
C ......................................................................
C FILEIN n infile-spec
110	IF (NFIL.GE.MAXFIL) THEN
	   CALL WRITEF('Too many FILEIN commands, %N specified already',
     &				MAXFIL)
	   GOTO 10
	ENDIF
	IF (INTARG(1).LT.0.OR.INTARG(1).GT.255) THEN
	   CALL TTWSTR('FILEIN value must be in the range 0-255')
	   GOTO 10
	ENDIF
C
	IF (RDCHS(CH)) THEN
	   OK = 0
	ELSE
	   CALL BSCH
	   OK = GETFILNAM(INFIL(NFIL+1),INLEN(NFIL+1),
     &			'LSL$DTI:.DTI',.TRUE.,%REF('!'))
	ENDIF
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Error in filename in FILEIN command')
	   CALL LSL_PUTMSG(OK)
	   GOTO 10
	ENDIF
C
C open first DTI file (just to get header for now)
	IF (NFIL.EQ.0) THEN
	   OK = DTI_OPEN(INLUN,INFIL(1),INLEN(1),.FALSE.,IERR)
	   IF (.NOT.OK) THEN
	      CALL WRITEF('Error opening input file "%S"',
     &				INFIL(1)(:INLEN(1)))
	      CALL LSL_PUTMSG(OK)
	      IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	      CALL DTI_CLOSE(INLUN,.FALSE.,.FALSE.,IERR)
	      GOTO 10
	   ENDIF
C
C close it again, but retaining values in common
	   OK = DTI_CLOSE(INLUN,.FALSE.,.FALSE.,IERR)
	   IF (.NOT.OK) THEN
	      CALL TTWSTR('Error closing input file 1')
	      IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	   ENDIF
C
C check various things
	   IF (DATA_TYPE(INLUN).NE.DATA_BYTE) THEN
	      CALL TTWSTR('File 1 is not byte data type')
	      GOTO 10
	   ENDIF
C
	   XSIZE = X_EXTENT(INLUN)
	   YSIZE = Y_EXTENT(INLUN)
	ENDIF
	NFIL = NFIL+1
	GOTO 10
C
C ......................................................................
C FILEOUT [filespec]   - get output file-spec 
C
120	OK = GETFILNAM(OUTFIL,OUTLEN,
     &		'LSL$DTI:.DTI',.TRUE.,%REF('!'))
	IF (.NOT.OK) THEN
	   OUTLEN = 0
	   CALL TTWSTR('Error in filename in FILEOUT command')
	   CALL LSL_PUTMSG(OK)
	   GOTO 10
	ENDIF
	GOTO 10
C
C ......................................................................
C GO
140	IF (OUTLEN.LE.0) THEN
	   CALL TTWSTR('No FILEOUT command has been given')
	   GOTO 10
	ENDIF
	IF (NFIL.LE.0) THEN
	   CALL TTWSTR('No FILEIN commands have been given')
	   GOTO 10
	ENDIF
C
C open the output file, using header values left in common block
C from the temporary opening of file 1 above.
	OK = DTI_CREATE(OUTLUN,OUTFIL,OUTLEN,
     &			HEADER_TYPE(INLUN),	! header type
     &			DATA_OFFSET(INLUN),	! header size
     &			DATA_BYTE,		! data type
     &			XSIZE,YSIZE,
     &			IERR)
	IF (.NOT.OK) THEN
	   CALL WRITEF('Error creating output file "%S"',OUTFIL(:OUTLEN))
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	   CALL DTI_CLOSE(OUTLUN,.FALSE.,.FALSE.,IERR)
	   GOTO 10
	ENDIF
C
	CALL WRITEF('Created output file "%S"',OUTFIL(:OUTLEN))
C
C now open each file in order and process them
	DO 145 I=1,NFIL
C
	   OK = DTI_OPEN(INLUN,INFIL(I),INLEN(I),
     &			.FALSE.,IERR)
	   IF (.NOT.OK) THEN
	      CALL WRITEF('Error opening input file %N "%S"',
     &					I,INFIL(I)(:INLEN(I)))
	      CALL LSL_PUTMSG(OK)
	      IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	      CALL WRITEF('File %N will not be processed',I)
	      CALL DTI_CLOSE(INLUN,.FALSE.,.FALSE.,IERR)
	      GOTO 145
	   ENDIF
C
	   CALL WRITEF('Processing file %N "%S"',I,INFIL(I)(:INLEN(I)))
C
C check various things
	   IF (DATA_TYPE(INLUN).NE.DATA_BYTE) THEN
	      CALL WRITEF(
     &'File %N is not byte data type - it will not be processed',I)
	      GOTO 142
	   ENDIF
	   IF (XSIZE.NE.X_EXTENT(INLUN).OR.YSIZE.NE.Y_EXTENT(INLUN)) THEN
	      CALL WRITEF(
     &			'File %N has different dimensions to file 1 - '//
     &			'it will not be processed',I)
	      GOTO 142
	   ENDIF
C
C copy header from first input file to output
	   IF (.NOT.HEADER) THEN
	      IF (HEADER_TYPE(INLUN).NE.DTI_MIKE) THEN
	         OK = DTI_COPY_HEADER(INLUN,OUTLUN,IERR)
	         IF (.NOT.OK) THEN
	            CALL WRITEF('Error copying header from file %N',I)
	            CALL LSL_PUTMSG(OK)
	            IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	         ELSE
	            HEADER = .TRUE.
	         ENDIF
	      ENDIF
	   ENDIF
C
	   CALL PROCESS(I,XSIZE*YSIZE,
     &			%VAL(SEC_ADDR( INLUN)+DATA_OFFSET( INLUN)),
     &			%VAL(SEC_ADDR(OUTLUN)+DATA_OFFSET(OUTLUN)) )
C
C close it again, but retaining values in common
142	   OK = DTI_CLOSE(INLUN,.FALSE.,.FALSE.,IERR)
	   IF (.NOT.OK) THEN
	      CALL TTWSTR('Error closing input file %N',I)
	      CALL LSL_PUTMSG(OK)
	      IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	      GOTO 145
	   ENDIF
C
145	CONTINUE
C
C done
	OK = DTI_MINMAX_DATA(OUTLUN,.FALSE.,IERR)
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Error finding min and max of data')
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	ENDIF
	OK = DTI_CLOSE(OUTLUN,.TRUE.,.FALSE.,IERR)
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Error closing output file')
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	ENDIF
	GOTO 999
C
C ......................................................................
999	CALL LSL_EXIT(OK)
	END
