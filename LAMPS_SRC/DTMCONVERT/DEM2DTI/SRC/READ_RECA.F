C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-16 11:59:02.000000000 +0100
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
	LOGICAL FUNCTION READ_RECA( MESSAGES )
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
C	Module READ_RECA called by DEM_SCAN in program DEM2DTI
C	Reads the A record of a DEM file
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
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input 
	INCLUDE 'LSL$DEM2DTI:DEMA.CMN'		! DEM A record
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'		! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'	! Command line results
C
C Argument
C
	LOGICAL		MESSAGES	! (IN) Echo messages to screen
C
C Functions
C	
	LOGICAL		MTIRDB		! Read from magtape
	LOGICAL		MTIBCK		! Backspace one block on tape
	LOGICAL		FLRLIN		! Read from file into TXTBUF
	INTEGER		READSTR		! Read string from TXTBUF
	LOGICAL		RDINT		! Read word integer from TXTBUF
	LOGICAL		RDREAL		! Read single precision real
	LOGICAL		RREAL8		! Read double precision real
C
C Local variables
C
	INTEGER		STATUS		! Return status
	INTEGER*2	LENGTH		! Number of bytes in record A
	INTEGER 	MTHLEN		! Length of magtape header block(s)
	BYTE		MTBUF( MAXBLK )	! Tape buffer
	INTEGER		MTBYTES		! No. of bytes read from tape
	LOGICAL		NONUM		! Flag if number not read from TXTBUF
	INTEGER*2	I,J		! Loop counters
	INTEGER*2	OFFSET		! Offset within element
C
	DATA		MTHLEN  / 80 /	
	DATA		LENGTH	/ 1024 /
C
C-------------------------------------------------------------------------------
C
C Read the A record into the LSLLIB text buffer
C
	CALL WRITEF( 'Reading type A record from DEM file ' )
C
C If input DEM is magtape 
C
	IF ( MAGTAPE ) THEN		
	   CALL SET_TXTLIM( MTHLEN )	
	   CALL BSLN
C
C Skip the header records (80 byte blocks) if required.
C
10	   CONTINUE
	   IF ( .NOT.HEADER ) GOTO 50
	   STATUS = MTIRDB( TXTBUF,MTHLEN,MTBYTES )
	   IF ( STATUS ) GOTO 10
C
	   IF ( STATUS .NE. LSL__EOF .AND. STATUS .NE. LSL__NORMAL ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
C
C Now read the block containing the A record. 
C
50	   CONTINUE
	   STATUS = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	   STATUS = MTIBCK()		! Backspace to beginning of DEM
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF
	   CALL SETAUX( MTBUF,BLKSIZ )	! Set buffer to read from
C
C otherwise input DEM is a disk file
C
	ELSE			
	   CALL SET_TXTLIM( LENGTH )	! Number of bytes in text buffer	
	   STATUS = FLRLIN()		! Read A record into TXTBUF
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( DEM2DTI__ERRRDRECA )
	      CALL LSL_ADDMSG( STATUS )
	      GOTO 999
	   ENDIF
	ENDIF
C
C The record has been read successfully so now decode it into the DEMA 
C common variables
C
C Element (1) DEMNAM   - name of DEM file
C
	CALL SETWIN( DEMAOFF(1),DEMABYT(1) )
	DEMNAML = READSTR( DEMNAM )
	IF ( LOG .AND. MESSAGES ) 
     &     CALL LSL_PUTMSG( DEM2DTI__DEMFILNAM,DEMNAM(1:DEMNAML) )
C
C Element (2) DEMLEVEL - level of DEM 
C
	CALL SETWIN( DEMAOFF(2),DEMABYT(2) )
	NONUM = RDINT( DEMLEVEL )
	IF ( LOG .AND. MESSAGES ) THEN
	   CALL LSL_PUTMSG( DEM2DTI__DEMLVLCODE,DEMLEVEL )
	ENDIF
C
C Element (3) DEMPATT - Elevation pattern code : 1 => regular
C
	CALL SETWIN( DEMAOFF(3),DEMABYT(3) )
	NONUM = RDINT( DEMPATT )
C
C Element (4) DEMREF - Planimetric ref. system : 
C			0 => Geographic
C			1 => UTM
C			2 => State plane
C			3-20 see App. F of USGS DEM users guide 
C
	CALL SETWIN( DEMAOFF(4),DEMABYT(4) )
	NONUM = RDINT( DEMREF )
C
C Element (5) DEMZONE - Zone code in ref. system (see USGS DEM guide App. D & E)
C
	CALL SETWIN( DEMAOFF(5),DEMABYT(5) )
	NONUM = RDINT( DEMZONE )
C
C Element (6) DEMPROJ - Map projection parameters: 0 for DEMREF = 0,1,2
C
	DO 100 I = 1, 15
	   CALL SETWIN( DEMAOFF(6) + DEMABYT(6)*(I-1),DEMABYT(6) )
	   NONUM = RREAL8( DEMPROJ(I) )
100	CONTINUE
C
C Element (7) DEMXYUN - Ground units: 
C			 0 => radians
C			 1 => feet
C			 2 => meters (7.5-mins DEM's)
C			 3 => arc-seconds (1-degree DEM's)
C
	CALL SETWIN( DEMAOFF(7),DEMABYT(7) )
	NONUM = RDINT( DEMXYUN )
C
C Element (8) DEMZUN - Elevation units: 
C			1 => feet 
C			2 => metres (7.5-min & 1-degree DEM's)
C
	CALL SETWIN( DEMAOFF(8),DEMABYT(8) )
	NONUM = RDINT( DEMZUN )
C
C Element (9) DEMPOL - Number of sides of map polygon = 4
C
	CALL SETWIN( DEMAOFF(9),DEMABYT(9) )
	NONUM = RDINT( DEMPOL )
C
C Element (10) DEMCORN - Coordinates of corners of map
C			 Corners are ordered clockwise from SW corner
C
	OFFSET = 0
	DO 200 I = 1,4
	   DO 200 J = 1,2
	      CALL SETWIN( DEMAOFF(10) + DEMABYT(10)*OFFSET,DEMABYT(10) )
	      NONUM = RREAL8( DEMCORN(I,J) )
	      OFFSET = OFFSET + 1		
200	CONTINUE
C
C Element (11) DEMZRNG - Minimum and maximum elevations
C
	DO 300 I = 1,2
	   CALL SETWIN( DEMAOFF(11) + DEMABYT(11)*(I-1),DEMABYT(11) )
	   NONUM = RREAL8( DEMZRNG(I) )
300	CONTINUE
C
C Element (12) DEMDIR - Direction of DEM (in radians) with respect to 
C			primary axis of the ground planimetric system
C
	CALL SETWIN( DEMAOFF(12),DEMABYT(12) )
	NONUM = RREAL8( DEMDIR )
C
C Element (13) DEMACC - Indicator if accuracy record present (0-no,1-yes)
C
	CALL SETWIN( DEMAOFF(13),DEMABYT(13) )
	NONUM = RDINT( DEMACC )
C
C Element (14) DEMRES  - Spatial resolution of DEM:
C			  (30,30,1) for 7.5-min DEM's
C			  (3,3,1) for 1-degree DEM's
C
	DO 400 I = 1,3
 	   CALL SETWIN( DEMAOFF(14) + DEMABYT(14)*(I-1),DEMABYT(14) )
 	   NONUM = RDREAL( DEMRES(I) )
400	CONTINUE
C
C Element (15) DEMNCOL - Number of rows and columns in profiles
C			  row = 1, column = number of columns in DEM
C
	DO 500 I = 1,2
	   CALL SETWIN( DEMAOFF(15) + DEMABYT(15)*(I-1),DEMABYT(15) )
	   NONUM = RDINT( DEMNCOL(I) )
500	CONTINUE
C
C Report on the type of DEM. Either 1-degree or 7.5-minute
C
	IF ( LOG .AND. MESSAGES ) THEN
	   IF ( DEMREF .EQ. 0 .AND. DEMZONE .EQ. 0 .AND. DEMXYUN .EQ. 3 ) THEN
	      CALL LSL_ADDMSG( DEM2DTI__ONEDEGDEM )
	      DEMTYPE = 1
	   ELSE
	      CALL LSL_ADDMSG( DEM2DTI__SVNMINDEM )
	      DEMTYPE = 2
	   ENDIF
	ENDIF
C
999	CONTINUE
	READ_RECA = STATUS
C
	RETURN
	END
C
