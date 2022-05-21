C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-30 12:21:08.000000000 +0000
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
        INTEGER*4 FUNCTION GET_COMMAND()
C
CDEC$	IDENT	'30JA92'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB 11-August-1989
C                                     
C	The command decoder for I2DLG
C
	IMPLICIT NONE
C
C Parameters:
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
	INCLUDE '($SSDEF)/NOLIST'
C
C Common:
	INCLUDE 'LSL$CMNLSL:CLD.CMN/LIST'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN/LIST'
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN/LIST'
C
C Command Language Definitions:
	EXTERNAL	I2DLG_CLD
C
C Integer:
	INTEGER*2	RECORD_OVER	! remainder of blocksize/recordsize
C
C Longword:
	INTEGER		I	   ! tmp var.
	INTEGER		TMP_LEN	   ! length of tmp. file-spec
C
C Logical*4                                   
	LOGICAL		ABSENT	   ! .T. if file param. not found
	LOGICAL		HAD_FRT    ! had /FRT qualifier
	LOGICAL		HAD_FC	   ! had /FC qualifier
 	LOGICAL		LOCAL      ! .T. if qual. is local
	LOGICAL		LOCNEG     ! set .T. if qual. locally negated
        LOGICAL		WHINGE     ! .T. - local error reporting
C
C Character:
	CHARACTER*256	TMP_FIL	   ! temp file-spec for parsing
C
C Functions called:
	INTEGER*4	DCL_FILE   ! reads & parses file title from DCL 
C			           ! command line
	INTEGER*4	DCL_QUAL   ! looks for specified qualifier
        INTEGER*4       DCL_STARTUP! looks for command line
        INTEGER*4       DCL_STR	   ! looks for qualifier string args.
        INTEGER*4       DCL_INT	   ! looks for qualifier integer args.
        INTEGER*4       PARFILN    ! parses a filename
C
C
C...................................................................
C
C	    I N I T I A L I S E   T H I N G S 
C
	WHINGE=.TRUE.		   ! local error reporting
C
C....................................................................
C
C	    G E T   C O M M A N D   L I N E
C
	GET_COMMAND=DCL_STARTUP('I2DLG',.FALSE.,I2DLG_CLD,WHINGE)
C
C DCL_STARTUP will return set to SS$_NORMAL if all well.
C
        IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C....................................................................
C
C	     C H E C K   F O R   Q U A L I F I E R S
C
C We could have /AREA=fc, /BLOCK_SIZE=n, /BY_LAYER,
C		/FRT=filename,
C		/LINE=fc, /LIST, /LOG, /NODE=fc, /POINT=fc, 
C		/REWIND,
C
C Now /AREA
	GET_COMMAND=DCL_QUAL('AREA',HAD_FC,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /AREA arguments
	IF (HAD_FC) THEN
	   GET_COMMAND=DCL_INT('AREA',WHINGE)
	   IF (GET_COMMAND) THEN
	      NUM_FC_AREA=NUMINT
	      DO 110 I=1,NUM_FC_AREA
		 IF (IARRAY(I).LT.0.OR.IARRAY(I).GT.32767) THEN
		    GET_COMMAND=I2DLG__INVALFCA
		    CALL LSL_PUTMSG(GET_COMMAND,IARRAY(I))
	            GOTO 10			! return
		 ELSE
	            AREA_FC(I)=IARRAY(I)
		 ENDIF
110	      CONTINUE
	   ELSE
	      GOTO 10				! return
	   ENDIF
	ENDIF
C
C Now /BLOCK_SIZE
	BLK_LEN = RECSIZ            ! default is 1 record
	GET_COMMAND=DCL_QUAL('BLOCK_SIZE',HAD_BLOCK,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /BLOCK_SIZE argument ( number of bytes per block )
	IF (HAD_BLOCK) THEN
	   GET_COMMAND=DCL_INT('BLOCK_SIZE',WHINGE)
	   IF (GET_COMMAND) THEN
C
C Validate
	       IF((IARRAY(1) .GT. MAXBLK) .OR. 
     &		  (IARRAY(1) .LT. RECSIZ)     )THEN
		   GET_COMMAND=I2DLG__INVALBLK
		   CALL LSL_PUTMSG(GET_COMMAND,IARRAY(1))
	           GOTO 10			! return
	       ENDIF		
	       RECORD_OVER = MOD(IARRAY(1),RECSIZ)
	       IF(RECORD_OVER .NE. 0)THEN
		   GET_COMMAND=I2DLG__NOTMULTREC
		   CALL LSL_PUTMSG(GET_COMMAND,IARRAY(1))
	           GOTO 10			! return
	       ENDIF		
	       BLK_LEN = IARRAY(1)
	   ENDIF
	ENDIF
C
C Try /BY_LAYER
	GET_COMMAND=DCL_QUAL('BY_LAYER',BY_LAYER,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Now /FRT
	GET_COMMAND=DCL_QUAL('FRT',HAD_FRT,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /FRT filename
	IF (HAD_FRT) THEN
	   GET_COMMAND=DCL_FILE('FRT','LSL$FRT:DLG.FRT;0',
     &				ABSENT,.FALSE.,WHINGE)
	   IF (.NOT. GET_COMMAND) GOTO 10
	   FRT_FILE=FILARY(1)(1:FIL_LEN(1))
	   FRT_FILE_LEN=FIL_LEN(1)
	ENDIF
C
C Now /LINE
	GET_COMMAND=DCL_QUAL('LINE',HAD_FC,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /LINE arguments
	IF (HAD_FC) THEN
	   GET_COMMAND=DCL_INT('LINE',WHINGE)
	   IF (GET_COMMAND) THEN
	      NUM_FC_LINE=NUMINT
	      DO 120 I=1,NUM_FC_LINE
		 IF (IARRAY(I).LT.0.OR.IARRAY(I).GT.32767) THEN
		    GET_COMMAND=I2DLG__INVALFCL
		    CALL LSL_PUTMSG(GET_COMMAND,IARRAY(I))
	            GOTO 10			! return
		 ELSE
	            LINE_FC(I)=IARRAY(I)
		 ENDIF
120	      CONTINUE
	   ELSE
	      GOTO 10				! return
	   ENDIF
	ENDIF
C
C Try /LIST
	HAD_LIST=.FALSE.
	GET_COMMAND=DCL_QUAL('LIST',HAD_LIST,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Try /LOG
	HAD_LOG=.TRUE.
	GET_COMMAND=DCL_QUAL('LOG',HAD_LOG,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Now /NODE
	GET_COMMAND=DCL_QUAL('NODE',HAD_FC,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /NODE arguments
	IF (HAD_FC) THEN
	   GET_COMMAND=DCL_INT('NODE',WHINGE)
	   IF (GET_COMMAND) THEN
	      NUM_FC_NODE=NUMINT
	      DO 130 I=1,NUM_FC_NODE
		 IF (IARRAY(I).LT.0.OR.IARRAY(I).GT.32767) THEN
		    GET_COMMAND=I2DLG__INVALFCN
		    CALL LSL_PUTMSG(GET_COMMAND,IARRAY(I))
	            GOTO 10			! return
		 ELSE
	            NODE_FC(I)=IARRAY(I)
		 ENDIF
130	      CONTINUE
	   ELSE
	      GOTO 10				! return
	   ENDIF
	ENDIF
C
C Now /POINT
	GET_COMMAND=DCL_QUAL('POINT',HAD_FC,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /POINT arguments
	IF (HAD_FC) THEN
	   GET_COMMAND=DCL_INT('POINT',WHINGE)
	   IF (GET_COMMAND) THEN
	      NUM_FC_POINT=NUMINT
	      DO 140 I=1,NUM_FC_POINT
		 IF (IARRAY(I).LT.0.OR.IARRAY(I).GT.32767) THEN
		    GET_COMMAND=I2DLG__INVALFCP
		    CALL LSL_PUTMSG(GET_COMMAND,IARRAY(I))
	            GOTO 10			! return
		 ELSE
	            POINT_FC(I)=IARRAY(I)
		 ENDIF
140	      CONTINUE
	   ELSE
	      GOTO 10				! return
	   ENDIF
	ENDIF
C
C Try /REWIND
	GET_COMMAND=DCL_QUAL('REWIND',REWIND,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Try /DATUM
	HAD_DATUM=.FALSE.
	GET_COMMAND=DCL_QUAL('DATUM',HAD_DATUM,LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Try /DECIMAL_HEIGHTS
	HAD_DECIMAL_HEIGHTS=.FALSE.
	GET_COMMAND=DCL_QUAL('DECIMAL_HEIGHTS',HAD_DECIMAL_HEIGHTS,
     &				LOCAL,LOCNEG,WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Now /HEIGHT_UNITS
	GET_COMMAND=DCL_QUAL('HEIGHT_UNITS',HAD_HEIGHT_UNITS,LOCAL,LOCNEG,
     &				WHINGE)
	IF (.NOT.GET_COMMAND) GOTO 10 		! return
C
C Get /HEIGHT_UNITS arguments
	IF (HAD_HEIGHT_UNITS) THEN
	   GET_COMMAND=DCL_STR('HEIGHT_UNITS',WHINGE)
	   IF (.NOT.GET_COMMAND) GOTO 10 		! return
	   HEIGHT_UNITS = CARRAY(1)
	ENDIF
C                                       
C Get input file
	GET_COMMAND=DCL_FILE('P1','LSL$IF:IFF.IFJ;0',ABSENT,.FALSE.,WHINGE)
C
C Transfer file-spec to a local variable
	IF (GET_COMMAND) THEN
	   IFF_FILE=FILARY(1)(1:FIL_LEN(1))
	   IFF_FILE_LEN=FIL_LEN(1)
	ELSE
	   GOTO 10
	ENDIF
C
C
C Get output filename
	GET_COMMAND=DCL_FILE('P2',' ',ABSENT,.FALSE.,WHINGE)
	IF (.NOT. GET_COMMAND) GOTO 10 		! return
C
C Assume mag tape output if name ends with a colon
	HAD_DEVICE = FILARY(1)(FIL_LEN(1):FIL_LEN(1)) .EQ. ':'
C
	IF (HAD_DEVICE) THEN
	   DEV_LEN = FIL_LEN(1)
	   DEV_NAM(1:DEV_LEN) = FILARY(1)(1:FIL_LEN(1))
	ELSE
C
C Generate full output file-spec
	   GET_COMMAND = PARFILN(DLG_FILE,DLG_FILE_LEN,
     &				 FILARY(1)(1:FIL_LEN(1)),
     &			 	 'HERE:DLG.DLG;0',.TRUE.)
	   IF (.NOT. GET_COMMAND) GOTO 10 		! return
C
	ENDIF
C			
10	IF (GET_COMMAND) GET_COMMAND=SS$_NORMAL
C
C Finish
	RETURN
	END
