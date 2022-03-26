	LOGICAL FUNCTION WRITE_DTI
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	25-Jul-1990
C
C Description:
C
C	Module WRITE_DTI called from MNT2DTI in package DTMCONVERT.
C	Takes the data from the MNT file currently open and writes
C	it to the data area of the DTI file.
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$MNT2DTI:MNT2DTIMSG.PAR'	! MNT2DTI messages
	INCLUDE 'LSL$MNT2DTI:LUN.PAR'		! Logical units for file I/O
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'		! DTI parameters
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'		! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$MNT2DTI:DTI.CMN'		! DTI file specifics
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'		! DTI file header
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header record
	INCLUDE 'LSL$MNT2DTI:MNT_DATA.CMN'	! MNT data record
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'	! DTI projection record
C
C Functions
C
	LOGICAL		MTIRWD			! Rewind tape
	LOGICAL		FLRREW			! Rewind disk file
	LOGICAL		DTI_INIT_WORD_DATA	! Initialise DTI data area
	LOGICAL		DTI_WRITE_WORD_DATA	! Write a word to DTI file
	LOGICAL		READ_DATA		! Read MNT data record
	LOGICAL		DTI_UNITS_TO_MATRIX 	! Convert from MNT coords
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER		ERROR		! System error status
	INTEGER*2	PROFILE		! Number of data profile
	INTEGER*2	I		! Number of datum in profile
	REAL*4		COLUMN		! Number of column in DTI
	REAL*4		ROW		! Number of row in DTI
	INTEGER*4	ICOL		! Integer column number
	INTEGER*4	MATRIX_COL	! Column in DTI matrix
	INTEGER*4	MATRIX_ROW	! Row in DTI matrix
	REAL*8		XGP,XGP0	! X ground point in MNT coordinates
	REAL*8		YGP,YGP0	! Y ground point in MNT coordinates
	REAL*8		YP		! Local y coordinate in profile
	INTEGER*4	UNITS		! Units code (5 => projection)
	INTEGER*4	ROTATE		! Rotation (0 => SW)
	LOGICAL		ABSOLUTE	! Absolute coordinates
	INTEGER*2	ZMIN,ZMAX	! Word z-range
C
C-------------------------------------------------------------------------------
C
C The MNT may not be a rectangular region so the DTI file must be 
C initialised to nulls
C
	CALL WRITEF( 'Initialising DTI data area' )
	STATUS = DTI_INIT_WORD_DATA( DTILUN,DTI_NULL_WORD )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS)
	   GOTO 999
	ENDIF
C
C Loop through the file reading the data records and writing the profiles
C to the DTI file
C
	CALL WRITEF( 'Reading data records from MNT file' )
	UNITS = UNITS_MET
	ROTATE = DTI_ORDER_SW
	ABSOLUTE = .TRUE.
	ZMIN = INT(MNTZRNG(1))
	ZMAX = INT(MNTZRNG(2))
C
	LOGREC = BLKSIZ
	DO 100 PROFILE = 1, DTI_YSIZE
C
C The current profile is stored in the common block MNTDATAREC in MNT_DATA.CMN
C
	   STATUS = READ_DATA( PROFILE )
	   IF ( .NOT.STATUS ) GOTO 999
C
C Write the profile to the DTI file
C
C Compute the coordinate of the first point in this profile
C
	   XGP0 = X_OFFSET( DTILUN )
	   IF ( MNTSN ) THEN
	      YGP0 = MNTCORN(1,2)+((PROFILE-1)*MNTPRSEP)
	   ELSE
	      YGP0 = MNTCORN(1,2)-((PROFILE-1)*MNTPRSEP)
	   ENDIF
C
	   IF ( LOG .AND. MOD(PROFILE,50) .EQ. 0 ) THEN
	      CALL EXPAND( 'Writing profile #%^W%I0%^L ',PROFILE )
	      CALL WRITAP( 'at coordinate x:%F0.5, y:%F0.5',XGP0,YGP0 )
	   ENDIF
C
	   YGP = YGP0
C
	   DO 50 I = 1, DTI_XSIZE
C
C Compute the matrix point from the ground coordinates
C
	      YP = DBLE(I-1)*MNTPTSEP
	      XGP = XGP0 + YP
C
C	      YP = DBLE(I-1)*MNTPRSEP
C	      XGP = XGP0 + YP*MNTCOS
C	      YGP = YGP0 - YP*MNTSIN
C
	      STATUS = DTI_UNITS_TO_MATRIX( DTILUN,XGP,YGP,
     &                                      UNITS,ROTATE,ABSOLUTE,
     &                                      COLUMN,ROW )
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( STATUS )
	         GOTO 999
	      ENDIF
C
	      MATRIX_ROW = NINT( COLUMN )
	      MATRIX_COL = NINT( ROW )
C
C Validate the datum if /VALIDATE specified on command line
C The datum is checked to see if it lies within the limits found in
C the MNT header record variable MNTZRNG
C
	      IF ( VALIDATE ) THEN
	         IF ( MNTELEV(I) .LT. ZMIN  .OR.
     &                MNTELEV(I) .GT. ZMAX ) THEN
	            CALL LSL_PUTMSG( MNT2DTI__OUTOFRNG,
     &                               MATRIX_ROW,MATRIX_COL )
	            CALL LSL_ADDMSG( MNT2DTI__MNTELEVAL,MNTELEV(I) )
	         ENDIF
	      ENDIF
C
C and write the datum to the DTI file
C
	      STATUS = DTI_WRITE_WORD_DATA( DTILUN,MNTELEV(I),
     &						MATRIX_ROW,MATRIX_COL)
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( STATUS )
	         GOTO 999
	      ENDIF
C
50	   CONTINUE
C
100	CONTINUE
C
999	CONTINUE
	WRITE_DTI = STATUS
C
	RETURN
	END
