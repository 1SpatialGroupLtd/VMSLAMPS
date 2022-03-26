	LOGICAL FUNCTION DEM_SCAN
C
CDEC$	IDENT	'31OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	05-Oct-1989
C
C Description:
C
C	Module DEM_SCAN called from OPEN_FILES in program DEM2DTI 
C	Scans through the DEM input file (disk or tape) reading header
C	information to be passed to the DTI output file
C
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'	! DEM2DTI messages
	INCLUDE 'LSL$DEM2DTI:LUN.PAR'		! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'		! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$DEM2DTI:DTI.CMN'		! DTI file specifics
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'		! DTI file header
	INCLUDE 'LSL$DEM2DTI:DEMA.CMN'		! DEM A record
	INCLUDE 'LSL$DEM2DTI:DEMB.CMN'		! DEM B record
C
C Functions
C
	LOGICAL		READ_RECA	! Read DEM header record A	
	LOGICAL		READ_RECB	! Read DEM B record
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER		ERROR		! System error status
	INTEGER*2	PROFILE		! Record B profile
	REAL*8		UTMMERID	! Meridian in UTM 
	PARAMETER      (UTMMERID = 500000.0)
	LOGICAL		WEST		! True if west of meridian
	REAL*8		M		! Slope of DEM
	REAL		PREV_YSTART	! Previous y starting coordinate
	INTEGER*2	PREV_YSIZE	! No. of rows in previous profile
C
C-------------------------------------------------------------------------------
C
C The DEM file has been opened at this stage either as a sequential disk file
C or as a tape file. The method of reading depends on which type it is
C
C Read the DEM file
C
	CALL WRITEF('Scanning DEM file to determine size of map')
	STATUS = READ_RECA( .TRUE. )		! Read header record A
	IF ( .NOT.STATUS ) GOTO 999
C
C If the DEM is a 1-degree then the number of rows and columns are known,
C and the SW grid coordinate corresponds exactly with the SW corner of the 
C DEM
C
	IF ( DEMTYPE .EQ. 1 ) THEN
	   DTI_XSIZE = DEMRMAX			! x/columns = 1201
	   DTI_YSIZE = DEMRMAX			! y/rows = 1201
	   X_OFFSET( DTILUN ) = DEMCORN(1,1)	! X-value (Latitude)
	   Y_OFFSET( DTILUN ) = DEMCORN(1,2)	! Y-value (Longitude)
C
C The x and y grid intervals in units specified in DEMXYUN.
C X/Y-interval = 3 arc-seconds (1-degree)
C
	   X_GRID( DTILUN ) = DEMRES( 1 )
	   Y_GRID( DTILUN ) = DEMRES( 2 )
C
C otherwise (7.5-minute DEM) it is necessary to scan the DEM file and 
C record the maximum number of rows in the profiles
C
	ELSE
C
C For a 7.5-minute DEM the origin of the grid does not correspond 
C with the SW corner of the DEM. The origin is calculated according to the
C formulae in Fig.3 (for a DEM west of the UTM meridian) or Fig.4 (for a DEM
C east of the meridian) of the USGS DEM Data Users Guide
C
	   WEST = .FALSE.
	   IF ( DEMCORN(3,1) .LE. UTMMERID ) THEN ! West of (or on) UTM meridian
	      WEST = .TRUE.
	      X_OFFSET(DTILUN) = (INT( DEMCORN(1,1)/DEMRES(1) ) + 1)*DEMRES(1)
	      M = (DEMCORN(4,2) - DEMCORN(1,2))/
     &            (DEMCORN(4,1) - DEMCORN(1,1))
	   ELSE					  ! East of UTM meridian
	      X_OFFSET(DTILUN) = (INT( DEMCORN(2,1)/DEMRES(1) ) + 1)*DEMRES(1)
	      M = (DEMCORN(2,2) - DEMCORN(1,2))/
     &            (DEMCORN(2,1) - DEMCORN(1,1))
	   ENDIF
C
C The y-coordinate for the DTI matrix origin is the y coordinate of the
C start of a DEM profile which contains the maximum number of data points.
C Set to a large number to start with (NW corner)
C
	   IF (WEST) THEN
	      Y_OFFSET(DTILUN) = DEMCORN(2,2)
	   ELSE
	      Y_OFFSET(DTILUN) = (INT( DEMCORN(1,2)/DEMRES(2) ) + 1)*DEMRES(2)
	   ENDIF
C
	   DTI_XSIZE = DEMNCOL(2)		! Number of columns
	   DTI_YSIZE = 0			! Number of rows
C
C Loop through the file reading the B records
C
	   CALL WRITEF( 'Reading type B records from DEM file' )
	   LOGREC = BLKSIZ
	   PREV_YSIZE = 0
	   PREV_YSTART = Y_OFFSET(DTILUN)
	   DO 100 PROFILE = 1, DTI_XSIZE
	      IF ( LOG .AND. ( REAL(PROFILE)/50 - PROFILE/50 .EQ. 0 ) ) THEN
	         CALL WRITEF( '...record #%^W%I0%^L ',PROFILE )
	      ENDIF
	      STATUS = READ_RECB( PROFILE )
	      IF ( .NOT.STATUS ) GOTO 999
C
C Store the max value of number of nodes in a profile in the DTI x-size and the 
C start y-coordinate for the matrix
C
	      IF ( DEMNROW(1) .GT. DTI_YSIZE ) THEN
	         DTI_YSIZE = DEMNROW(1)
	      ENDIF
C
C For a DEM west of the UTM meridian
C
	      IF (WEST) THEN
	         IF ( REAL(DEMFIRST(2)) .LT. Y_OFFSET(DTILUN) .AND.
     &                DEMNROW(1) .EQ. PREV_YSIZE ) THEN
	            Y_OFFSET(DTILUN) = DEMFIRST(2)
	            DTI_YSIZE = DTI_YSIZE + 1
	         ENDIF
	      ELSE
C
C or a DEM east of the UTM meridian
C
	         IF ( (REAL(DEMFIRST(2)) .GT. PREV_YSTART .AND.
     &                 DEMNROW(1) .EQ. PREV_YSIZE) .OR.
     &                (DEMNROW(1) .GT. PREV_YSIZE .AND.
     &                 REAL(DEMFIRST(2)) .EQ. PREV_YSTART) ) THEN
	            DTI_YSIZE = DTI_YSIZE + 1
	         ENDIF
	      ENDIF
C
	      PREV_YSTART = DEMFIRST(2)
	      PREV_YSIZE = DEMNROW(1)
C
100	   CONTINUE
C
C
C The x and y grid intervals in units specified in DEMXYUN.
C X/Y-interval = 30 metres (7.5-minutes)
C
	   X_GRID( DTILUN ) = DEMRES( 1 )
	   Y_GRID( DTILUN ) = DEMRES( 2 )
	ENDIF
C
C Now write the minimum and maximum elevation values to the DTI header
C common variables,( Units are those specified in DEMZUN (element 8 of A
C record))
C
	MIN_WVALUE( DTILUN ) = DEMZRNG(1)
	MAX_WVALUE( DTILUN ) = DEMZRNG(2)
C
999	CONTINUE
	DEM_SCAN = STATUS
C
	RETURN
	END
C
