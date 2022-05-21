C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-10-29 17:32:24.000000000 +0000
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
        INTEGER*4 FUNCTION CMDLIN()
C
CDEC$	IDENT	'22AP91'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'PARAMS.PAR'
	INCLUDE '($SSDEF)/NOLIST'
C
C Common
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'COMMAND.CMN'
C
C Command Language Definitions
C
	EXTERNAL	I2GEN_CLD
C
C Longword
C
	INTEGER		I	   ! tmp var.
	INTEGER		TMP_LEN	   ! length of tmp. file-spec
C
C Logical*4
C
	LOGICAL		ABSENT	   ! .T. if file param. not found
	LOGICAL		HAD_AC	   ! had /HEIGHT_AC qualifier
	LOGICAL		HAD_BLK	   ! had /BLOCK_SIZE qualifier
	LOGICAL		HAD_DEN	   ! had /DENSITY qualifier
	LOGICAL		HAD_NAME   ! had /NAME qualifier
	LOGICAL		HAD_TER	   ! had /TERMINATOR qualifier
 	LOGICAL		LOCAL      ! .T. if qual. is local
	LOGICAL		LOCNEG     ! set .T. if qual. locally negated
        LOGICAL		WHINGE     ! .T. - local error reporting
C
C Functions called:
	INTEGER*4	DCL_FILE   ! reads & parses file title from DCL 
C			           ! command line
	INTEGER*4	DCL_INT	   ! looks for qualifier integer args.
	INTEGER*4	DCL_QUAL   ! looks for specified qualifier
	INTEGER*4	DCL_REAL   ! looks for qualifier real args.
        INTEGER*4       DCL_STARTUP! looks for command line
        INTEGER*4       DCL_STR	   ! looks for qualifier string args.
C
C Character:
	CHARACTER*256	TMP_FIL	   ! temp file-spec for parsing
C
C...................................................................
C
C	    I N I T I A L I S E   T H I N G S 
C
	WHINGE=.TRUE.		 ! local error reporting
C
C....................................................................
C
C	    G E T   C O M M A N D   L I N E
C
	CMDLIN=DCL_STARTUP('I2GEN',.FALSE.,I2GEN_CLD,WHINGE)
C
C DCL_STARTUP will return set to SS$_NORMAL if all well.
C
        IF (.NOT.CMDLIN) GOTO 10 		! return
C
C....................................................................
C
C	     C H E C K   F O R   Q U A L I F I E R S
C
C Check for /PARAMETER
C
	CMDLIN=DCL_QUAL('PARAMETER',HAD_PAR,LOCAL,LOCNEG,WHINGE)
	IF (HAD_PAR) THEN    	  
	  CMDLIN=DCL_FILE('PARAMETER','GENCODE.DAT',
     &	            ABSENT,.FALSE.,WHINGE)
	  IF (.NOT.CMDLIN) GOTO 10 	! return
          PAR_FIL=FILARY(1)(1:FIL_LEN(1))
	  PAR_LEN=FIL_LEN(1)
	ELSE
	  CMDLIN = .FALSE.
	  GOTO 10
	ENDIF
C
C Get input file-spec
C
	CMDLIN=DCL_FILE('P1','LSL$IF:IFF.IFF;0',ABSENT,.FALSE.,WHINGE)
C
C Transfer file-spec to a local variable
C
        IF (CMDLIN) THEN
          P1_FIL=FILARY(1)(1:FIL_LEN(1))
	  P1_LEN=FIL_LEN(1)
        ELSE
          GOTO 10 			! return
        ENDIF 
C
C Generate output default file-spec based on input file. Strip version
C if specified.
C
	HAD_DEV=.FALSE.
	HAD_DIR=.FALSE.
	STR_EXT='GENVECT'
	LEN_EXT=4
	STR_VER='0'
	LEN_VER=1
	CALL EXPFLN(TMP_FIL,TMP_LEN)
C
C Get output filename
C
	CMDLIN=DCL_FILE('P2',TMP_FIL,ABSENT,.FALSE.,WHINGE)
C
C Transfer file-spec to a local variable
	IF (CMDLIN) THEN
	  P2_FIL=TMP_FIL(1:TMP_LEN)
	  P2_LEN=TMP_LEN
	ENDIF
C
C Check for /OFFSET
C
	CMDLIN=DCL_QUAL('OFFSET',HAD_OFFSET,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.CMDLIN) GOTO 10 	! return
C			
10	IF (CMDLIN) CMDLIN=SS$_NORMAL
	RETURN
   	END
