	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	23-Jul-1990
C
C Description:
C
C	Module OPEN_FILES called by MNT2DTI in package DTMCONVERT
C	Opens the files specified on the command line
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$MNT2DTI:MNT2DTIMSG.PAR'	! MNT2DTI messages
	INCLUDE 'LSL$MNT2DTI:LUN.PAR'		! Logical units for file I/O
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'		! DTILIB parameters
	INCLUDE 'LSL$CMNDTI:DTILIBMSG.PAR'	! DTILIB messages
	INCLUDE 'LSL$CMNLSL:READANG.PAR'	! READANG parameters
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:CLD.CMN'		! LSLLIB command language
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$MNT2DTI:DTI.CMN'		! DTI file specifics
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header information
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'		! DTI file header
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'	! DTI projection record
C
C Functions
C
	LOGICAL		DTI_CREATE		! Open a new DTI file 
	LOGICAL		DTI_WRITE_PROJ_REC	! Write projection record
	LOGICAL		DTI_PRINT_HEADER	! Print DTI header record
	LOGICAL		DTI_PRINT_PROJECTION	! Print DTI projection record
	LOGICAL		READ_HEADER		! Read MNT header record
	CHARACTER*14	DISPANG			! Convert from secs to Lat-Long
C
C Local variables
C
	INTEGER		STATUS			! Return status
	INTEGER		ERROR			! System error status
	INTEGER*4	PROJ_OFFSET		! Byte offset for proj. record
	INTEGER*4	HEADER_SIZE		! Size of DTI header
	CHARACTER*14	SWLAT,SWLONG		! Lat & Long of SW corner
	CHARACTER*2	DTIPART			! Part of DTI filename
	BYTE		MTBUF(MAXBLK)		! Buffer for data
	INTEGER*4	MTBYTES			! Number of bytes read
	INTEGER		I,SIZE			! Loop counter, Size of DTIPART
C
C-------------------------------------------------------------------------------
C
C  Open the DTI file for writing which should be ok
C  Create a LSLA header type DTI file with word data type
C
	DTI_HTYPE = DTI_LSLA			! LSLA type header
	DTI_DTYPE = DATA_WORD			! Word data
C
C The MNT file header must now be scanned to determine the size of the data area
C required (DTI_XSIZE & DTI_YSIZE) and the grid intervals (X_GRID & Y_GRID),
C and the min and max data values (MIN_WVALUE & MAX_WVALUE).
C
	STATUS = READ_HEADER( .TRUE. )		! Read header record
	IF ( .NOT.STATUS ) GOTO 999
C
	IF ( MNTCORN(1,2).GT.MNTCORN(3,2) ) THEN
	   MNTSN = .FALSE.
	   X_OFFSET( DTILUN ) = MNTCORN(3,1)
	   Y_OFFSET( DTILUN ) = MNTCORN(3,2)
	ELSE
	   MNTSN = .TRUE.
	   X_OFFSET( DTILUN ) = MNTCORN(1,1)
	   Y_OFFSET( DTILUN ) = MNTCORN(1,2)
	ENDIF
C
	X_GRID( DTILUN ) = MNTPTSEP
	Y_GRID( DTILUN ) = MNTPRSEP
C
	DTI_XSIZE = MNTPOINTS
	DTI_YSIZE = MNTPROFS
C
	MIN_WVALUE( DTILUN ) = MNTZRNG(1)
	MAX_WVALUE( DTILUN ) = MNTZRNG(2)
C
C Create DTI file with name according to the source of the MNT file.
C If disk then the name is known. If from tape, then the output filename
C will contain the file number by which it was selected using /SELECT
C Eg. LSL$DTI:output_file_3.DTI;0 for the 3rd file on the tape
C
	IF ( MAGTAPE ) THEN
C
C If selected 1 output-file only then don't put '_num.dti;0' on the end
C
	   IF ( SELECT.AND.NUMINT.EQ.1 ) GOTO 110
C
	   IF (MNTNUM.LE.9) DTIPART(1:1) = CHAR(MNTNUM+48)
	   IF (MNTNUM.GT.9) DTIPART(1:2) = CHAR((MNTNUM/10)+48)//
     &	                                   CHAR(MOD(MNTNUM,10)+48)
C
	   DTILEN = FIL_LEN(1)
	   DTIFILE = FILARY(1)(1:DTILEN)
C
C Add underscore and select number to filename
C
	   SIZE = 1
	   IF (MNTNUM.GT.9) SIZE = 2
	   DO 100 I = 1,DTILEN-1
	      IF (DTIFILE(DTILEN-I:DTILEN-I).EQ.'.') THEN
	         DTIFILE(DTILEN-I:DTILEN-I+8) = ('_'//DTIPART(1:SIZE)//'.DTI;0')
	         DTILEN = DTILEN + 3
	         IF (MNTNUM.GT.9) DTILEN = DTILEN + 1
	         GOTO 110
	      ENDIF
100	   CONTINUE
	ENDIF
C
110	CALL WRITEF('Creating DTI file %S with LSLA type header',
     &               DTIFILE(1:DTILEN) )
	IF ( LOG ) THEN 
	   CALL LSL_PUTMSG( MNT2DTI__DTICRMAT,DTI_XSIZE,DTI_YSIZE )
	ENDIF
C
C Create the file with a header size to contain a projection record
C
	HEADER_SIZE = DEFAULT_LSLA_HEADER + DTIPROJ_RECORD_LENGTH
	STATUS = DTI_CREATE( DTILUN,DTIFILE(1:DTILEN),DTILEN,
     &			     DTI_HTYPE,HEADER_SIZE,
     &			     DTI_DTYPE,DTI_XSIZE,DTI_YSIZE,
     &                       ERROR )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( MNT2DTI__FILOPEN,DTIFILE(1:DTILEN) )
	   CALL LSL_ADDMSG( STATUS )
	ENDIF
C
C Write the projection record to the DTI file
C
C Projection units - 2 => metres
C
	IF (MNTXYUN .EQ. 'METRES') THEN
	   DTIPROJ_UNITS( DTILUN ) = 2			! Metres
	ELSE
	   DTIPROJ_UNITS( DTILUN ) = 0			! Unset
	ENDIF
C
C Coordinates of matrix origin - assumes SW corner
C Units as defined in DTIPROJ_UNITS
C
	DTIPROJ_ORIGIN( 1,DTILUN ) = X_OFFSET(DTILUN)	! X-value
	DTIPROJ_ORIGIN( 2,DTILUN ) = Y_OFFSET(DTILUN)	! Y-value
C
C Grid intervals
C
	DTIPROJ_SAMPLE( 1,DTILUN ) = X_GRID( DTILUN )	! X-interval
	DTIPROJ_SAMPLE( 2,DTILUN ) = Y_GRID( DTILUN )	! Y-interval
C
C Now write the record
C
	PROJ_OFFSET = DEFAULT_LSLA_HEADER 		! Byte offset in header
C
	STATUS = DTI_WRITE_PROJ_REC( DTILUN,PROJ_OFFSET,ERROR ) 
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS )
	   IF ( STATUS .EQ. DTI__SYSERR ) CALL LSL_ADDMSG( ERROR )
	   GOTO 999	
	ENDIF
	HAD_PROJ_RECORD(DTILUN) = .TRUE.
C
	IF ( LOG ) THEN 
C
C Detailed information about the file created i.e. header and projection record
C
	   CALL LSL_PUTMSG( MNT2DTI__DTIOPEN,DTIFILE(1:DTILEN) )
C
	   STATUS = DTI_PRINT_HEADER( DTILUN,DTIPROJ_UNITS(DTILUN) )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      GOTO 999
	   ENDIF
C
	ENDIF
C
999	CONTINUE
	OPEN_FILES = STATUS
C
	RETURN
	END
