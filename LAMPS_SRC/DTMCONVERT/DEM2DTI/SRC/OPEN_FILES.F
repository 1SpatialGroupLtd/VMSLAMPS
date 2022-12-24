C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-16 11:55:08.000000000 +0100
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
	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'26OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	04-Oct-1989
C
C Description:
C
C	Module OPEN_FILES called by DEM2DTI in package DTMCONVERT
C	Opens the files specified on the command line
C	
	IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'	! DEM2DTI messages
	INCLUDE 'LSL$DEM2DTI:LUN.PAR'		! Logical units for file I/O
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'		! DTILIB parameters
	INCLUDE 'LSL$CMNDTI:DTILIBMSG.PAR'	! DTILIB messages
	INCLUDE 'LSL$CMNLSL:READANG.PAR'	! READANG parameters
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'		! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'	! Command line results
	INCLUDE 'LSL$DEM2DTI:DTI.CMN'		! DTI file specifics
	INCLUDE 'LSL$DEM2DTI:DEMA.CMN'		! DEM header information
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'		! DTI file header
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'	! DTI projection record
C
C Functions
C
	LOGICAL		FLROPN			! Open a file for read
	LOGICAL		DTI_CREATE		! Open a new DTI file 
	LOGICAL		DTI_WRITE_PROJ_REC	! Write projection record
	LOGICAL		DTI_PRINT_HEADER	! Print DTI header record
	LOGICAL		DTI_PRINT_PROJECTION	! Print DTI projection record
	LOGICAL		MTINIT			! Initialise a tape for read
	LOGICAL		TEST_FOREIGN		! Test if DEM file is magtape
	LOGICAL		DEM_SCAN		! Scan DEM file
	CHARACTER*14	DISPANG			! Convert from secs to Lat-Long
C
C Local variables
C
	INTEGER		STATUS			! Return status
	INTEGER		ERROR			! System error status
	LOGICAL		FOREIGN			! True if DEM is magtape/FOREIGN
	INTEGER*4	PROJ_OFFSET		! Byte offset for proj. record
	INTEGER*4	HEADER_SIZE		! Size of DTI header
	CHARACTER*14	SWLAT,SWLONG		! Lat & Long of SW corner
C
C-------------------------------------------------------------------------------
C
C Check to see if the specified DEM input file is magtape or disk
C
	IF ( MAGTAPE ) THEN
	   STATUS = TEST_FOREIGN( DEMFILE,FOREIGN,ERROR )
	   IF ( STATUS .EQ. LSL__NORMAL .AND. FOREIGN ) THEN
C
C Get the tape file ready for read. 
C
C Assume user specified a magtape device
C
	      MAGTAPE = .TRUE.		
C
C Try initializing the tape
C
	      CALL WRITEF( 'Initializing tape for read - Please wait.' )
C
C Rewind the tape if necessary
C
	      STATUS = MTINIT( DEMFILE(1:DEMLEN), .FALSE., )
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( DEM2DTI__MAGTAPE,DEMFILE(1:DEMLEN) )
	         CALL LSL_ADDMSG( STATUS )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	         GOTO 999
	      ENDIF
C
C Either the tape is not mounted foreign or the user specified a device name
C that isn't a tape device, in which case the filename is missing
C
	   ELSEIF ( STATUS .EQ. LSL__NORMAL .AND. .NOT.FOREIGN ) THEN
	      IF ( DEMFILE(1:1) .EQ. 'M' .OR. DEMFILE(1:1) .EQ. 'm' ) THEN
	         STATUS = DEM2DTI__NOTMNTFOR
	         CALL LSL_PUTMSG( STATUS,DEMFILE(1:DEMLEN) )
	         GOTO 999
	      ELSE
C
C Disk device name only
C
	         STATUS = DEM2DTI__NOFILNAM
	         CALL LSL_PUTMSG( STATUS,DEMFILE(1:DEMLEN) )
	         GOTO 999
	      ENDIF
C
C Error in device name
C
	   ELSEIF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( DEM2DTI__NODEVICE,DEMFILE(1:DEMLEN) )
	      GOTO 999
	   ENDIF
C
	ELSE					! Read DEM file from disk	
C	
C DEM must be a disk file so open it for read
C
	   MAGTAPE = .FALSE.
	   STATUS = FLROPN( DEMLUN,DEMFILE(1:DEMLEN) )
	   IF ( STATUS ) THEN
	     IF ( LOG ) CALL LSL_PUTMSG( DEM2DTI__DEMOPEN,DEMFILE(1:DEMLEN) )
	   ELSE
	     CALL LSL_PUTMSG( DEM2DTI__FILOPEN,DEMFILE(1:DEMLEN) )
	     CALL LSL_ADDMSG( STATUS )
	     GOTO 999
	   ENDIF
	ENDIF
C
C  Now open the DTI file for writing which should be ok
C  Create a LSLA header type DTI file with word data type
C
	DTI_HTYPE = DTI_LSLA			! LSLA type header
	DTI_DTYPE = DATA_WORD			! Word data
C
C The DEM file must now be scanned to determine the size of the data area
C required (DTI_XSIZE & DTI_YSIZE) and the grid intervals (X_GRID & Y_GRID),
C and the min and max data values (MIN_WVALUE & MAX_WVALUE).
C 
	STATUS = DEM_SCAN()
	IF ( .NOT.STATUS ) GOTO 999
C
	CALL WRITEF('Creating DTI file %S with LSLA type header',
     &               DTIFILE(1:DTILEN) )
	IF ( LOG ) THEN 
	   CALL LSL_PUTMSG( DEM2DTI__DTICRMAT,DTI_XSIZE,DTI_YSIZE )
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
	   CALL LSL_PUTMSG( DEM2DTI__FILOPEN,DTIFILE(1:DTILEN) )
	   CALL LSL_ADDMSG( STATUS )
	ENDIF
C
C Write the projection record to the DTI file
C
C Projection units - 
C		0 => radians (-> 5)
C		1 => feet
C		2 => metres		( 7.5-minute DEM's)
C		3 => arc-seconds	( 1-degree DEM's )
C
	IF ( DEMXYUN .EQ. 0 ) THEN
	   DTIPROJ_UNITS( DTILUN ) = 5			! Radians
	ELSE
	   DTIPROJ_UNITS( DTILUN ) = DEMXYUN		! Others
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
C Projection code, spheroid and projection parameters
C
	IF ( DEMTYPE .EQ. 1 ) THEN
	   DTIPROJ_PROJECTION( DTILUN ) = 100		! Geographic
	   DTIPROJ_SPHEROID( DTILUN ) = 5		! WGS 72 
	ELSE
	   DTIPROJ_PROJECTION( DTILUN ) = DEMREF	! UTM or state plane
	   DTIPROJ_SPHEROID( DTILUN ) = 0		! Clarke 1866 = NAD 27
	   DTIPROJ_PROJ_PARAMS( 1,DTILUN ) = 0.0
	   DTIPROJ_PROJ_PARAMS( 2,DTILUN ) = 0.0
	   DTIPROJ_PROJ_PARAMS( 3,DTILUN ) = DBLE( DEMZONE ) ! UTM zone code
	ENDIF
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
	   CALL LSL_PUTMSG( DEM2DTI__DTIOPEN,DTIFILE(1:DTILEN) )
C
	   IF ( DEMTYPE .EQ. 1 ) THEN
	      STATUS = DTI_PRINT_HEADER( DTILUN,1 )	! Matrix units
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( STATUS )
	         GOTO 999
	      ENDIF
	      SWLONG = DISPANG( DTIPROJ_ORIGIN(1,DTILUN),READANG_LONGITUDE )
	      SWLAT  = DISPANG( DTIPROJ_ORIGIN(2,DTILUN),READANG_LATITUDE )
	      CALL WRITEF( 'SW corner - Latitude: %S, Longitude: %S',
     &                      SWLAT,SWLONG )
	   ELSE	     
	      STATUS = DTI_PRINT_HEADER( DTILUN,DTIPROJ_UNITS(DTILUN) )
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( STATUS )
	         GOTO 999
	      ENDIF
	   ENDIF
C
	   STATUS = DTI_PRINT_PROJECTION( DTILUN )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      GOTO 999
	   ENDIF
	ENDIF
C
999	CONTINUE
	OPEN_FILES = STATUS
C
	RETURN
	END
C
