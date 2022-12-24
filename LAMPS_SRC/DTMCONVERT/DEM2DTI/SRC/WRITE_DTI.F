C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-16 12:03:10.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	LOGICAL FUNCTION WRITE_DTI
C
CDEC$	IDENT	'31OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	09-Oct-1989
C
C Description:
C
C	Module WRITE_DTI called from DEM2DTI in package DTMCONVERT.
C	Takes the elevation data from the DEM file currently open
C	and writes it to the data area of the DTI file 
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'	! DEM2DTI messages
	INCLUDE 'LSL$DEM2DTI:LUN.PAR'		! Logical units for file I/O
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'		! DTI parameters
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'		! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$DEM2DTI:DTI.CMN'		! DTI file specifics
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'		! DTI file header
	INCLUDE 'LSL$DEM2DTI:DEMA.CMN'		! DEM A record
	INCLUDE 'LSL$DEM2DTI:DEMB.CMN'		! DEM B record
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'	! DTI projection record
C
C Functions
C
	LOGICAL		MTIRWD			! Rewind tape
	LOGICAL		FLRREW			! Rewind disk file
	LOGICAL		DTI_INIT_WORD_DATA	! Initialise DTI data area
	LOGICAL		DTI_WRITE_WORD_DATA	! Write a word to DTI file
	LOGICAL		READ_RECA		! Read DEM header record A	
	LOGICAL		READ_RECB		! Read DEM B record
	LOGICAL		DTI_UNITS_TO_MATRIX 	! Convert from DEM coords
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER		ERROR		! System error status
	INTEGER*2	PROFILE		! Number of Record B profile
	INTEGER*2	I		! Number of datum in profile
	REAL*4		COLUMN		! Number of column in DTI
	REAL*4		ROW		! Number of row in DTI
	INTEGER*4	ICOL		! Integer column number
	INTEGER*4	MATRIX_COL	! Column in DTI matrix
	INTEGER*4	MATRIX_ROW	! Row in DTI matrix
	REAL*8		XGP,XGP0	! X ground point in DEM coordinates
	REAL*8		YGP,YGP0	! Y ground point in DEM coordinates
	REAL*8		YP		! Local y coordinate in profile
	INTEGER*4	UNITS		! Units code (5 => projection)
	INTEGER*4	ROTATE		! Rotation (0 => SW)
	LOGICAL		ABSOLUTE	! Absolute coordinates
	REAL*8		SINTHETA	! Sine of rotation angle
	REAL*8		COSTHETA	! Cosine of rotation angle
	INTEGER*2	ZMIN,ZMAX	! Word z-range
C
C-------------------------------------------------------------------------------
C
C The DEM file has already been scanned once so the file pointer needs resetting
C to the start of the file
C
	IF ( MAGTAPE ) THEN
C
C Rewind the tape 
C
	   CALL WRITEF( 'Rewinding tape - Please wait.' )
	   STATUS = MTIRWD( )		! Make sure tape is at the beginning
	   IF ( .NOT.STATUS ) THEN	! Error rewinding tape
	      CALL LSL_PUTMSG( MTIERR )
	      GOTO 999
	   ENDIF
	ELSE
	   STATUS = FLRREW()			! Rewind the disk file
	   IF ( .NOT.STATUS) THEN
	      CALL LSL_PUTMSG( STATUS )		! Error rewinding file
	      GOTO 999
	   ENDIF
	ENDIF
C
C The DEM may not be a rectangular region (7.5-minute DEM's) so the DTI file
C must be initialised to nulls
C
	CALL WRITEF( 'Initialising DTI data area' )
	STATUS = DTI_INIT_WORD_DATA( DTILUN,DTI_NULL_WORD )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS)
	   GOTO 999
	ENDIF
C
C Now read the DEM file
C
	CALL WRITEF('Reading DEM file for transfer to DTI file' )
	STATUS = READ_RECA( .FALSE. )		! Read header record A
	IF ( .NOT.STATUS ) GOTO 999
C
C Loop through the file reading the B records and writing the profiles
C to the DTI file
C
	CALL WRITEF( 'Reading type B records from DEM file' )
	UNITS = UNITS_PROJ			! Projection units
	ROTATE = DTI_ORDER_SW
	ABSOLUTE = .TRUE.
	SINTHETA = SIN(DEMDIR)	
	COSTHETA = COS(DEMDIR)
	ZMIN = INT(DEMZRNG(1))
	ZMAX = INT(DEMZRNG(2))
C
	LOGREC = BLKSIZ
	DO 100 PROFILE = 1, DTI_XSIZE
C
C The current profile is stored in the common block DEMBREC in DEMA.CMN
C
	   STATUS = READ_RECB( PROFILE )
	   IF ( .NOT.STATUS ) GOTO 999
C
C Write the profile to the DTI file
C
C
C Compute the coordinate of the first point in this profile
C
	   XGP0 = DEMFIRST(1)
	   YGP0 = DEMFIRST(2)
C
	   IF ( LOG .AND. MOD(PROFILE,50) .EQ. 0 ) THEN
	      CALL EXPAND( 'Writing profile #%^W%I0%^L ',PROFILE )
	      CALL WRITAP( 'at coordinate x:%F0.5, y:%F0.5',XGP0,YGP0 )
	   ENDIF
	   DO 50 I = 1, DEMNROW(1)
C
C Add the local datum elevation to this element
C
	      DEMELEV(I) = DEMELEV(I) + DEMDATUM  
C
C Compute the matrix point from the ground coordinates
C
	      YP = DBLE(I-1)*DEMRES(2)
	      XGP = XGP0 - YP*SINTHETA
 	      YGP = YGP0 + YP*COSTHETA
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
C the DEM A header record variable DEMZRNG
C
	      IF ( VALIDATE ) THEN
	         IF ( DEMELEV(I) .LT. ZMIN  .OR.
     &                DEMELEV(I) .GT. ZMAX ) THEN
	            CALL LSL_PUTMSG( DEM2DTI__OUTOFRNG,
     &                               MATRIX_ROW,MATRIX_COL )
	            CALL LSL_ADDMSG( DEM2DTI__DEMELEVAL,DEMELEV(I) )
	         ENDIF
	      ENDIF
C
C and write the datum to the DTI file
C
	      STATUS = DTI_WRITE_WORD_DATA( DTILUN,DEMELEV(I),
     &                                      MATRIX_ROW,MATRIX_COL )
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
C
