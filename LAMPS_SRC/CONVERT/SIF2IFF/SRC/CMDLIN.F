C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-08-03 10:50:14.000000000 +0100
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
	LOGICAL FUNCTION CMDLIN
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	15-Jan-1990
C
C	CONVERT SIF2IFF Utility - Get and decode command line
C
C Description
C
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE '($STSDEF)/NOLIST'
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FILES.CMN'		! filenames
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	! DCL command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Functions called
C
        INTEGER*4       DCL_STARTUP	! looks for command line
	INTEGER*4	DCL_FILE	! reads & parses file title
	INTEGER*4	DCL_QUAL	! looks for specified qualifier
	INTEGER*4	DCL_INT		! read integers
	INTEGER*4	DCL_DBL		! read double precision reals
	INTEGER*4	DCL_STR		! read strings
	INTEGER*4	PARFILN		! parse filename
C
C Local variables
C
	INTEGER*4	OK		! error return
	INTEGER*4	I		! counter
	LOGICAL*4	ABSENT		! set if file param. not found
	LOGICAL*4	LOCAL		! set if qual. is local
	LOGICAL*4	LOCNEG		! set if qual. locally negated
        LOGICAL*4	WHINGE		! set-local error reporting
	LOGICAL*4	GOT_DRAW	! got /DRAWING qualifier ?
	LOGICAL*4	GOT_PAR		! got /PARAMETER qualifier ?
	LOGICAL*4	GOT_SCHEMA	! got /SCHEMA qualifier ?
	LOGICAL*4	GOT_W		! got /AREA WEST keyword ?
	LOGICAL*4	GOT_S		! got /AREA SOUTH keyword ?
	LOGICAL*4	GOT_E		! got /AREA EAST keyword ?
	LOGICAL*4	GOT_N		! got /AREA NORTH keyword ?
	LOGICAL*4	GOT_X		! got /OFFSET EAST keyword ?
	LOGICAL*4	GOT_Y		! got /OFFSET NORTH keyword ?
C
C Command Language Definitions
C
 	EXTERNAL	SIF2IFF_CLD
C
C..............................................................................
C Initialisation for command line decoding
C
	WHINGE = .TRUE.			! report errors locally
C
C	.......................................................................
C	Get command line. DCL_STARTUP will return SS$NORMAL if all well.
C
	OK=DCL_STARTUP('SIF2IFF', .FALSE., SIF2IFF_CLD, WHINGE)
        IF(.NOT.OK) GOTO 999
C
C	.......................................................................
C	SIF input file
C
	   OK=DCL_FILE('IN_FILESPEC', SIFTEM, ABSENT, .FALSE., WHINGE)	
	   IF(.NOT.OK) GOTO 999
C
C	.......................................................................
C	Set file-spec if there was one
C
	   IF (.NOT. ABSENT) THEN
	      SIFFIL = FILARY(1)(1:FIL_LEN(1))
	      SIFLEN = FIL_LEN(1)
	   ENDIF
C
C	.......................................................................
C	Check if SIF file-spec is a valid filename or a magtape device
C
	IF ( .NOT.HAD_DIR .AND. 		! No directory
     &       .NOT.HAD_NAM .AND.  		! No filename
     &	     .NOT.HAD_EXT .AND.			! No extension
     &       .NOT.HAD_VER      			! No version
     &	   ) THEN				! Possibly a magtape device
	   MAGTAPE = .TRUE.
	      TAPEDEV = STR_DEV(1:LEN_DEV)
	      TAPEDEVLEN = LEN_DEV
	ENDIF
C
C	.......................................................................
C	Get IFF output file-name 
C
	OK=DCL_FILE('OUT_FILESPEC', IFFTEM, ABSENT, .FALSE., WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	Transfer file-spec 
C
	IFFFIL = FILARY(1)(1:FIL_LEN(1))
	IFFLEN = FIL_LEN(1)
C
C	.......................................................................
C	/CCG qualifier
C
	OK=DCL_QUAL('CCG', HAD_CCG, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	.......................................................................
C	/CELL qualifier
C
	OK=DCL_QUAL('CELL', HAD_CELL, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	.......................................................................
C	/PARAMETER qualifier
C
	OK=DCL_QUAL('PARAMETER', GOT_PAR, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	If we have the qualifier, get the actual filename which is REQUIRED 
C	so must be there
C
	IF (GOT_PAR) THEN
	   OK=DCL_FILE('PARAMETER', PARTEM, ABSENT, .FALSE., WHINGE) 
	   IF(.NOT.OK) GOTO 999
C
C	Set file-spec - check if its a CCG LUT or an FDF file
C
	   IF (HAD_CCG) THEN
	      LUTFIL = FILARY(1)(1:FIL_LEN(1))
	      LUTLEN = FIL_LEN(1)
	   ELSE
	      PARFIL = FILARY(1)(1:FIL_LEN(1))
	      PARLEN = FIL_LEN(1)
	   ENDIF
	ENDIF
C
C	.......................................................................
C	/OFFSET qualifier
C
	OK=DCL_QUAL('OFFSET', HAD_OFFSET, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	** /OFFSET X keyword
C
	IF (HAD_OFFSET) THEN
	   OK=DCL_QUAL('OFFSET.X', GOT_X, LOCAL, LOCNEG, WHINGE) 
 	   IF(.NOT.OK) GOTO 999
C
C	Get the keyword value if present
C
	   IF (GOT_X) THEN
	      OK=DCL_DBL('OFFSET.X', WHINGE) 
	      IF(.NOT.OK) GOTO 999
	      XOFF = DBLRAY(1)
	   ENDIF
C
C	** /OFFSET Y keyword
C
	   OK=DCL_QUAL('OFFSET.Y', GOT_Y, LOCAL, LOCNEG, WHINGE) 
	   IF(.NOT.OK) GOTO 999
C
C	Get the keyword value if present
C
	   IF (GOT_Y) THEN
	      OK=DCL_DBL('OFFSET.Y', WHINGE) 
	      IF(.NOT.OK) GOTO 999
	      YOFF = DBLRAY(1)
	   ENDIF
C
C	Check that either none or both keywords have been supplied
C
	   IF (GOT_X .XOR. GOT_Y) THEN
	      CALL LSL_PUTMSG(SIF2IFF__MISSKEY, 'OFFSET')
	      OK = LSL_STATUS
	      GOTO 999
	   ELSE
	      NEED_OFFSET_VAL = .TRUE.
	   ENDIF
	ENDIF
C
C	.......................................................................
C	/DIMEN qualifier
C
	OK=DCL_QUAL('DIMEN', HAD_DIMEN, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	Get the dimension
C
	IF (HAD_DIMEN) THEN
	   OK=DCL_INT('DIMEN', WHINGE) 
	   IF(.NOT.OK) GOTO 999
	   DIMEN = IARRAY(1)
	ENDIF
C
C	.......................................................................
C	/UNITS qualifier - REQUIRED
C
	OK=DCL_QUAL('UNITS', HAD_UNITS, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	Get the dimension
C
	IF (HAD_UNITS) THEN
	   OK=DCL_INT('UNITS', WHINGE) 
	   IF(.NOT.OK) GOTO 999
	   UNITS = IARRAY(1)
	ENDIF
C
C	.......................................................................
C	/SCALE qualifier
C
	OK=DCL_QUAL('SCALE', HAD_SCALE, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	Get the scale
C
	SCALE = 1			! default
	IF (HAD_SCALE) THEN
	   OK=DCL_INT('SCALE', WHINGE) 
	   IF(.NOT.OK) GOTO 999
	   SCALE = IARRAY(1)
	ENDIF
C
C	.......................................................................
C	/LOG qualifier
C
	OK=DCL_QUAL('LOG', HAD_LOG, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C	.......................................................................
C	/DEBUG qualifier
C
	OK=DCL_QUAL('DEBUG', HAD_DEBUG, LOCAL, LOCNEG, WHINGE) 
	IF(.NOT.OK) GOTO 999
C
C...............................................................................
C	Assign function value
C
999	CMDLIN = OK
	RETURN
	END
