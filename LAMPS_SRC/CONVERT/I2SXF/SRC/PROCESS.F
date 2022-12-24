C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-08-10 18:12:42.000000000 +0100
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
	INTEGER*4 FUNCTION PROCESS
C
CDEC$	IDENT	'11JN91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	09-May-1990
C
C	CONVERT I2SXF Utility - Main Loop
C
C Description
C
C	Read each feature in the IFF file and convert if to
C	output data in the SXF file
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! lib. messages def.
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'         ! FRT common
	INCLUDE	'LSL$CMNIFF:CB.STR'		! record structure definition
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNLSL:EXPC.CMN' 		! LSLLIB output buffer common
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		RDPAR		! read parameter file
	LOGICAL		FRTINI		! read FRT file
	LOGICAL		FRTFND		! find FRT valus for current FC
	INTEGER*4	FLWSEL		! select SXF file
	INTEGER*4	FLWLIN		! write to SXF file
	LOGICAL		CLOSE_IFF	! close IFF file
  	LOGICAL		USE_LAYER	! check if layer selected
	LOGICAL		USE_FC		! check if feature selected
	INTEGER*4	GET_SXF_CODE	! translation code lookup routine
	INTEGER*4	SXF_HEADING	! build heading part of SXF file
	INTEGER*2	EXPAND		! build output buffer
C
C
C Local variables
C
	RECORD	/IFF_CBH/ CBH		! CB header part
	RECORD	/IFF_CBD/ CBD		! CB data part
C
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	LAYER			! layer at hand
	INTEGER*2	IECODE			! entry type at hand
	INTEGER*2	IELEN			! length of entry at hand
C
	INTEGER*2	NFNUM			! feature serial number
	INTEGER*4	FSN			! and as longword
	EQUIVALENCE	(FSN,NFNUM)
C
	INTEGER*2	ISTAT(4)		! feature status words
	INTEGER*2	ITYPE			! temprary feature type word
	INTEGER*4	STPTR			! number of coordinates in CB

	INTEGER*2	ITEXTH			! integer form of text hight
	INTEGER*2	ACTYPE			! AC record type
	INTEGER*2	LENGTH			! output string length
	INTEGER*2	NUMB_CHR		! number of characters in text
	INTEGER*2	NUMB_TS			! number of text status entrys
C
	INTEGER*4	SXF_CODE		! SXF transfer code
	INTEGER*4	N_COLUMNS		! number of columns in CB
	INTEGER*4	LOOP			! local loop counter
C
	LOGICAL*4	LINE			! flag this is a line
	LOGICAL*4	TEXT			! flag this is a text
	LOGICAL*4	SYMBOL			! flag this is a symbol
	LOGICAL*4	NEW_FEATURE		! flag this is a new feature
	LOGICAL*4	HAD_AC_Z		! flag we have Z in AC
	LOGICAL*4	PLUS 			! more data in CB
	LOGICAL*4	LINE_START 		! flag first part of line
	LOGICAL*4	HAD_TEXTSTATUS		! flag TS in file
C
	REAL*4		ROTATION		! text or symbol rotation
	REAL*4		TEXT_HIGHT		! text or symbol hight
	REAL*4		SAV_X			! save first X coordinate
	REAL*4		SAV_Y			! save first Y coordinate
	REAL*4		SAV_Z			! save first Z coordinate
	REAL*4		AC_Z			! Z coordinate from AC record
	REAL*4		DELTAX			! diff. in X point 2 to point 1
	REAL*4		DELTAY			! diff. in Y point 2 to point 1
	REAL*4		PI			! PI
C
	INTEGER*4	STCOL(2)    		! code for X and y coord.
	INTEGER*4	OK			! SXF file status
	REAL*4		STBUF(2,200)            ! X and Y coordinates
	REAL*4          ZBUF(200)               ! Z coordinate
	BYTE		CHRS(80) 		! text buffer
C
	PARAMETER	(PI = 3.1415926535)
C
C...............................................................................
C Initiate local variables
C
	FC         	= -1			! Not valid
	LAYER       	= -1			! Not valid
	SXF_CODE   	= -1			! Not valid
	NUMB_TS   	= 0
	LINE       	= .FALSE.
	TEXT       	= .FALSE.
	SYMBOL     	= .FALSE.
	HAD_AC_Z   	= .FALSE.
	HAD_TEXTSTATUS	= .FALSE.
	PLUS       	= .FALSE.
	ROTATION   	= 0.0
	TEXT_HIGHT 	= 0.0
	AC_Z       	= 0.0
C
C...............................................................................
C	process the start of the IFF file to create the headier of the SXF file
C
	OK = FLWSEL(SXFLUN)
	IF(OK .NE. LSL__NORMAL) THEN
	    CALL LSL_PUTMSG(I2SXF__ERRSELSXF)
	    GO TO 9999
	ENDIF
C
C	........................................................................
C	Output SXF file heading data
C
	OK = SXF_HEADING(IECODE,IELEN)
	IF (OK .NE. LSL__NORMAL) GO TO 999
	GO TO 20					!an entry in hand?
C
C...............................................................................
C Main loop
C
10	CALL IFFNXT(IECODE,IELEN)			!next feature
20	IF (IELEN .EQ. -1 .OR. IERCD .NE. 0) GO TO 991	!error
	IF (IECODE .EQ. 'NO' ) GO TO 100
	IF (IECODE .EQ. 'NF' ) GO TO 200
	IF (IECODE .EQ. 'EO' ) GO TO 300
	IF (IECODE .EQ. 'FS' ) GO TO 400
	IF (IECODE .EQ. 'CB' ) GO TO 500
 	IF (IECODE .EQ. 'EF' ) GO TO 600
	IF (IECODE .EQ. 'AC' ) GO TO 700
	IF (IECODE .EQ. 'RO' ) GO TO 800
	IF (IECODE .EQ. 'TH' ) GO TO 840
	IF (IECODE .EQ. 'TX' ) GO TO 850
	IF (IECODE .EQ. 'TS' ) GO TO 860
	IF (IECODE .EQ. 'EJ' ) GO TO 900
C
C	........................................................................
C	These are entry types that we don't care about, so skip them.
C
	IF (IECODE .EQ. 'EM' ) GO TO 10
	IF (IECODE .EQ. 'NS' ) GO TO 10
	IF (IECODE .EQ. 'CC' ) GO TO 10
	IF (IECODE .EQ. 'CP' ) GO TO 10
C
C	........................................................................
C	These should have been dealtwith in heading processing, skip them
C
	IF (IECODE .EQ. 'RA' ) GO TO 10
	IF (IECODE .EQ. 'HI' ) GO TO 10
	IF (IECODE .EQ. 'MH' ) GO TO 10
	IF (IECODE .EQ. 'MD' ) GO TO 10
C
C
	GO TO 10						!next record
C	
C...............................................................................
C	New Layer check if we want to output this layer
C
100	CALL EIHR(LAYER,1,1)
	IF (HAD_LOG) CALL LSL_PUTMSG(I2SXF__LAYER,LAYER)
	IF(.NOT. USE_LAYER(LAYER)) THEN
	   IF (HAD_LOG) CALL LSL_PUTMSG(I2SXF__LAYSKIP,LAYER)
	   CALL IFFNXC('EO',IELEN)		! skip to end of layer
	ENDIF
	GO TO 10				! continue
C
C	........................................................................
C	New Feature read the FSN and set a flag that we got a new feature
C
200	CALL EIHR(NFNUM,1,1)
  	NEW_FEATURE = .TRUE.
	LINE_START  = .TRUE.
	GO TO 10
C
C	........................................................................
C	End of layer (overlay) mark that the layer is no longer valid
C
300	LAYER = -1				!mark layer as invalid
	GO TO 10
C
C	........................................................................
C	Feature status FS read the feature code FC and set feature type flags
C
400	CALL EIHR(ISTAT,4,1)
	FC = ISTAT(1)
C
C 	Check what type of feature is at hand
C
	IF(FRTFND(FC) .AND. HAD_FRT) THEN
	   CALL LSL_PUTMSG(I2SXF__NOFRT,FC)
	ENDIF
C
	ITYPE  = ISTAT(3) .AND. 'C000'X
	SYMBOL = (ITYPE .EQ. '4000'X)
	TEXT   = (ITYPE .EQ. '8000'X)
	LINE   = (ITYPE .EQ. '0000'X)
C
	IF ((TEXT.OR.SYMBOL).AND. HAD_FRT) THEN
	    TEXT_HIGHT = FRTSIZ
	ENDIF
C
	GO TO 10
C
C	........................................................................
C	Coordinate block CB. This is there the real processing takes place
C
500	IF(NEW_FEATURE) THEN
C
	   IF (LAYER .EQ. -1) THEN			!is layer valid?
	      CALL LSL_PUTMSG(I2SXF__ILLAYER)
	      GO TO 10
	   ENDIF
C
	   IF (FC .EQ. -1) THEN				!is FC valid
	      CALL LSL_PUTMSG(I2SXF__ILFC)
	      GO TO 10
	   ELSEIF(FC .EQ. -2) THEN			!valid but unwanted
	      GO TO 10
	   ENDIF
C
	   IF(.NOT. USE_FC(FC)) THEN			!dont want to use FC
	      IF (HAD_LOG) CALL LSL_PUTMSG(I2SXF__FCSKIP,FC)
	      FC = -2 					!mark as unwanted
	      GO TO 10
	   ENDIF
C
	   SXF_CODE = GET_SXF_CODE(FC)			!get SXF code
C
	   IF (SXF_CODE .EQ. -1) THEN			!code missing
	      CALL LSL_PUTMSG(I2SXF__UNKFC,FC,FSN)
	      CALL IFFNXC('EF',IELEN)			! skip to next feature
	      GO TO 10
	   ENDIF
C
	   NEW_FEATURE = .FALSE.			!no longer a new feature
	ENDIF
C
C	************************************************************************
C	CB entry - produce co-ord data units
C
	CALL EIHRCB_HEAD(CBH)
	CALL EIHRCB_DATA(CBD)
C
C	read the points into buffers for convenience
C
	STCOL(1)  = IFF_C_X
 	STCOL(2)  = IFF_C_Y
	STPTR     = CBH.NROW
	N_COLUMNS = CBH.NCOL
	PLUS      = (N_COLUMNS .GT. 2)
C
	IF (STPTR.EQ.0) THEN				!empty CB 
	    CALL LSL_PUTMSG(I2SXF__NOPTS,FSN)		
	    GOTO 10					!ignore it
	ENDIF
C
	CALL IFS_CB_READ(CBH,CBD,STBUF,2,STCOL,1,STPTR)
C
 	IF (PLUS) THEN
	    DO LOOP = 1,200
		ZBUF(LOOP) = 0.0
	    ENDDO
	    CALL IFS_CB_READ(CBH,CBD,ZBUF,1,IFF_C_Z,1,STPTR)
	ENDIF
C
	IF (HAD_AC_Z) THEN
	    DO LOOP = 1,STPTR
	        ZBUF(LOOP) = AC_Z		
            ENDDO
	    DO LOOP = STPTR+1,200
		ZBUF(LOOP) = 0.0
	    ENDDO
	ELSE
	    DO LOOP = 1,200
		ZBUF(LOOP) = 0.0
	    ENDDO
	ENDIF
C
C	************************************************************************
C	remember the first point of the feature (for texts and symbols)
C
	SAV_X     = STBUF(1,1)
	SAV_Y     = STBUF(2,1)
	SAV_Z     = ZBUF(1)
C
	IF (LINE) THEN
	    IF (LINE_START) THEN			! set up contin. flag
		LENGTH = EXPAND('L,%U%P0%I9,%P %I8,'//
     &				'%F5.2,%F5.2,%I1,%F6.2,'//
     &				'%F5.2,%F5.2,            ;',
     &				SXF_CODE,FSN,0.0,0.0,7,0.0,0.0,0.0)
	        OK = FLWLIN(EXPBUF)
	    ELSE
	        CALL APPEND('L;')     			! cont. on same line
	        OK = FLWLIN(EXPBUF)
	    ENDIF
C
C	Ouput all but the last coordnate triplet in the line
C
	    DO LOOP=1,STPTR-1
		LENGTH = EXPAND('M,K,%F11.3,%F11.3,%F8.3,L;',
     &                           STBUF(2,LOOP),STBUF(1,LOOP),
     &                           ZBUF(LOOP))
		OK = FLWLIN(EXPBUF)
	    ENDDO
C
C	Output last point in line leaving out record termination
C
	    LENGTH = EXPAND('M,K,%F11.3,%F11.3,%F8.3,',
     &			     STBUF(2,STPTR),STBUF(1,STPTR),
     &			     ZBUF(STPTR))
C
C
	ENDIF
	LINE_START = .FALSE.
	GO TO 10
C
C	........................................................................
C	End of feature. 
C
600	IF(TEXT .AND. FC .GE. 0) THEN
	    IF (HAD_TEXTSTATUS) THEN
 		CALL APPEND('%AZ62;',CHRS)
		NUMB_TS = 0
		HAD_TEXTSTATUS = .FALSE.
	    ELSE
C
C		Convert symbol rotation angle to GRADES and change direction
C
		IF(STPTR .EQ. 2 .AND. FRTGT .EQ. TEXTYP) THEN	 ! calculate 
		    TEXT_HIGHT = SQRT(DELTAX*DELTAX + DELTAY*DELTAY) ! scale
		ENDIF
C
		ROTATION = -63.67 * ROTATION
		IF (ROTATION .LT. 0.0) ROTATION = 400.0 + ROTATION
C
		LENGTH = EXPAND('T,%U%P0%I9,%P %I1,'//
     &			    '%F6.2,%F5.2,%F5.2,%F5.2,'//
     &                      'K,%F11.3,%F11.3,%F8.3;',
     &                      SXF_CODE,7,ROTATION,TEXT_HIGHT,
     &                      TEXT_HIGHT,0.0,SAV_Y,SAV_X,SAV_Z)
		OK = FLWLIN(EXPBUF)
C
		LENGTH = EXPAND('U,IS,%AZ62;',CHRS)
	    ENDIF
C
	    OK = FLWLIN(EXPBUF)
C
	ENDIF
C
C	************************************************************************
C	Output symbol
C	Convert symbol rotation angle to GRADES and change direction
C
	IF(SYMBOL .AND. FC .GE. 0) THEN
	    IF(STPTR .EQ. 2 .AND. (FRTGT .EQ. ORITYP .OR.
     &	    	FRTGT .EQ. SCATYP)) THEN			! calculate
		    DELTAX = STBUF(1,2) - STBUF(1,1)            ! rotation
		    DELTAY = STBUF(2,2) - STBUF(2,1)
		    IF (DELTAX .LT. 0.001) THEN
			ROTATION = PI/2.0
		    ELSE
			ROTATION = ATAN(DELTAY/DELTAX)
		    ENDIF
		    IF (DELTAX .LT. 0.0) ROTATION = ROTATION + PI
	    ENDIF
C
	    ROTATION = -63.67 * ROTATION
	    IF (ROTATION .LT. 0.0) ROTATION = 400.0 + ROTATION
C
	    IF(STPTR .EQ. 2 .AND. FRTGT .EQ. SCATYP) THEN	 ! calculate 
		TEXT_HIGHT = SQRT(DELTAX*DELTAX + DELTAY*DELTAY) ! scale
	    ENDIF
C
	    LENGTH = EXPAND('S,%U%P0%I9,'//
     &			    '%P %F6.2,%F5.2,%F5.2,'//
     &                      'K,%F11.3,%F11.3,%F8.3;',
     &                      SXF_CODE,ROTATION,TEXT_HIGHT,
     &                      TEXT_HIGHT,SAV_Y,SAV_X,SAV_Z)
	    OK = FLWLIN(EXPBUF)
C
	ENDIF
C
C	************************************************************************
C	Output line data termination
C
	IF (LINE .AND. FC .GE. 0) THEN 
	    CALL APPEND('E;')
	    OK = FLWLIN(EXPBUF)
	ENDIF
C
C	************************************************************************
C	Set FC to none valid (FC = -1)
C
	FC         = -1
	HAD_AC_Z   = .FALSE.
	TEXT_HIGHT = 0.0
	ROTATION   = 0.0
	GO TO 10
C
C	........................................................................
C	AC record
C
700	CALL EIHRI(ACTYPE,1,1)
	IF (ACTYPE .EQ. 3) THEN				! hight
	    CALL EIHRR(AC_Z,1,2)
	    HAD_AC_Z = .TRUE.
	ENDIF
	GO TO 10
C
C	........................................................................
C	Rotation
C
800	CALL EIHRR(ROTATION,1,1)
    	GO TO 10
C
C	........................................................................
C	Text hight
C
840	CALL EIHRI(ITEXTH,1,1)
	IF ((FRTGT .LT. UNOTYP .OR.
     &	    FRTGT .GT. SCATYP) .AND. ITEXTH .NE. 0) THEN 
		TEXT_HIGHT = FLOAT(ITEXTH) / 100.0
	ENDIF
	GO TO 10
C
C	........................................................................
C	Text
C
850	DO LOOP = 1,80
		CHRS(LOOP) = 0                  ! is this realy needed   ?
	ENDDO 					
C
	LOOP = 2 * IELEN
	CALL EIHRI(CHRS,IELEN,1)
	DO WHILE(CHRS(LOOP) .EQ. 0)
	  IF (CHRS(LOOP).EQ.0) LOOP = LOOP - 1	! remove padding null at end?
	ENDDO
	NUMB_CHR = LOOP
C
	GO TO 10
C
C	........................................................................
C	Text Status
C
860	NUMB_TS = NUMB_TS + 1
	IF(HAD_TEXTSTATUS) THEN
	    IF(NUMB_TS .EQ. 2) THEN
C
C		Convert symbol rotation angle to GRADES and change direction
C
		IF(STPTR .EQ. 2 .AND. FRTGT .EQ. TEXTYP) THEN	 ! calculate 
		    TEXT_HIGHT = SQRT(DELTAX*DELTAX + DELTAY*DELTAY) ! scale
		ENDIF
C
		ROTATION = -63.67 * ROTATION
		IF (ROTATION .LT. 0.0) ROTATION = 400.0 + ROTATION
C
		LENGTH = EXPAND('T,%U%P0%I9,%P %I1,'//
     &			    '%F6.2,%F5.2,%F5.2,%F5.2,'//
     &                      'K,%F11.3,%F11.3,%F8.3;',
     &                      SXF_CODE,7,ROTATION,TEXT_HIGHT,
     &                      TEXT_HIGHT,0.0,SAV_Y,SAV_X,SAV_Z)
		OK = FLWLIN(EXPBUF)
C
		LENGTH = EXPAND('U,IS,%AZ62',CHRS)	! start of text string
	    ELSE
		CALL APPEND('%AZ62',CHRS)	! add rest of text
	    ENDIF
	ELSE
	    HAD_TEXTSTATUS = .TRUE.		! flag what we had a TS entry
	ENDIF
	GO TO 10
C
C	........................................................................
C	End of job  output the terminationg character to output file and finish
C
900	LENGTH = EXPAND('E;')
	OK = FLWLIN(EXPBUF)
C
	PROCESS = LSL__NORMAL
	GO TO 9999
C
C...............................................................................
C Error handling
C
991	CONTINUE
C	
	CALL LSL_PUTMSG(I2SXF__ENDINMAP)	!IFF file structure error
	GO TO 9999
C
C...............................................................................
C
999	PROCESS = OK
9999	RETURN
	END
