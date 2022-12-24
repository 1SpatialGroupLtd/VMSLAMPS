C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-21 14:19:38.000000000 +0100
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
	INTEGER*4 FUNCTION PROCESS()
C
CDEC$	IDENT	'27NO91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	06-Dec-1991
C
C Description:
C       The main loop which reads the IFF file, converts the selected
C       feature to DIGIT and adds them to the buffer.
C
C	Function PROCESS in package I2DIGIT
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common:
	INCLUDE 'CODES.CMN'
	INCLUDE 'COMMANDS.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
	INTEGER*2	WORDX,WORDY
	INTEGER*2	N,I,WORD	! temporary/loop variable
	INTEGER*2	JJ,KK		! temporary/loop variable
	INTEGER*2	IENDS		! pen control for ST
	INTEGER*2  	NPTS		! points in line
	INTEGER*2  	IFC		! current feature code 
	INTEGER*2  	ISTAT(4)	! current feature code
	INTEGER*2	IELEN		! length of
	INTEGER*2	IECODE  	! ... current iff entry
	INTEGER*2	ITYPE		! current type of AC entry
	INTEGER*2	LAYER		! layer number
	INTEGER*2	DBX,DBY		! temps
C
	INTEGER*4	X,Y
	INTEGER*4	OK,IERR		! for error return
	INTEGER*4	FSN		! feature number
	INTEGER*4	STATUS		! function success/failure
	INTEGER*4	TOTPTS		! total points in feature
	INTEGER*4  	PARENTRY	! position in parlist of current FC
	INTEGER*4  	PREVENTRY	! prev value of PARENTRY
	INTEGER*4	TX,TY
C
	REAL*4		STBUF(2,200)	! buffer for points
	REAL*4		OFF(2)		! offset to bring coords positive
	REAL*4		RA(4)		! IFF range
	REAL*4		CPARR(16)	! Hold CP entry
	REAL*4		FACTOR		! Multiplication factor
C
	LOGICAL*4	HAD_ST		! had correct ST entry
	LOGICAL*4	HAD_MD		! had MD entry for scale
	LOGICAL*4	GOT_MATCH1	! true if feature in FC list
	LOGICAL*4	GOT_MATCH2	! true if feature in parameter list
C
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
	INTEGER*4	LIB$EXTV
C
C Functions:
	INTEGER*4	FIND_ENTRY	! find feature entry in parameter list
	LOGICAL*4	CHECK_RANGE	! test if range is outside 1..32767
C
C ......................................................................
C
C Assume success
C
	STATUS = .TRUE.
	HAD_MD = .FALSE.
	PREVENTRY = UNDEFINED
C
C Write sector and partition headers
C
	CALL WRITE_SECTOR_HEADER
	CALL WRITE_PARTITION_HEADER
C
	CALL WRITEF('Processing IFF file...')
C
C-----------------------------------------------------------------------------
C			M A I N   L O O P
C
C Read the IFF file entry by entry and take action on certain types of entry
C
C Assumes:
C	Only ST entries used for coords.
C	
10	CALL IFFNXT(IECODE,IELEN)
11	IF (IELEN.EQ.-1) GOTO 999
	IF (IECODE.EQ.'RA') GOTO 40
	IF (IECODE.EQ.'CP') GOTO 30
	IF (IECODE.EQ.'MD') GOTO 45
	IF (IECODE.EQ.'NF') GOTO 50
	IF (IECODE.EQ.'EF') GOTO 130
	IF (IECODE.EQ.'FS') GOTO 60
	IF (IECODE.EQ.'ST') GOTO 110
	IF (IECODE.EQ.'NO') GOTO 20
	IF (IECODE.EQ.'EJ') GOTO 140
	GOTO 10
C
C ......................................................................
C
C NO - New Overlay
C
20	CALL EIHRI(LAYER,1,1)		! read layer number
C
	IF (HAD_LAYER) THEN
	   DO 25 JJ=1,NUM_LAYER
	      IF (LAYER.EQ.LAYER_LIST(JJ)) GOTO 10 ! we want this layer
25	   CONTINUE
C
C Skip this layer as it was not in the layer list
C
	   CALL IFFNXC('EO',IELEN)
	   IF (IELEN.EQ.-1) THEN
	      STATUS = I2DIGIT__MISSINGENTRY
	      CALL LSL_PUTMSG(STATUS,'EO')
	      GOTO 999
	   ENDIF
	ENDIF
C
	GOTO 10				! get next IFF entry
C
C ......................................................................
C
C CP - Control Points for map extent if needed
C
30	IF (GET_CPS) THEN
	   CALL EIHRR (CPARR(1),4,1)
	   CALL EIHRR (CPARR(5),4,9)
	   CALL EIHRR (CPARR(9),4,17)
	   CALL EIHRR (CPARR(13),4,25)
	   XMIN = CPARR(5)
	   XMAX = CPARR(13)
	   YMIN = CPARR(6)
	   YMAX = CPARR(14)
	   IF (XMIN.GE.XMAX .OR. YMIN.GE.YMAX) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADCP)
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
C Calculate the height and width of the map extent
C
	IF (HAD_SCALEFACTOR) THEN
	   FACTOR = SCALEFACTOR
	ELSE
	   FACTOR = SCALEIFF / SCALESHEET
	ENDIF
	HEIGHT = INT(((YMAX-YMIN)*FACTOR*RESOLUTION) + (2*BORDER))
	WIDTH  = INT(((XMAX-XMIN)*FACTOR*RESOLUTION) + (2*BORDER))
C
	GOTO 10
C
C ......................................................................
C
C RA - Range
C
40	CONTINUE
	CALL EIHRR(RA,4,1)
	OFF(1) = - RA(1)
	OFF(2) = - RA(3)
	GOTO 10
C ......................................................................
C
C MD - Map Descriptor for scale
C
45	IF (HAD_SCALEFACTOR .OR. HAD_SCALESHEET) GOTO 10	!ignore MD
C
	IF (IELEN.NE.MD2LEN) THEN	    ! not type 2 MD 
          CALL LSL_PUTMSG (I2DIGIT__UNSETMD)
	   PROCESS = .FALSE.
	   GOTO 999
        ELSE
	   CALL EIHR (MD2ARR, MD2LEN, 1)
        ENDIF
C
        IF (MATV2.NE.2) THEN
           CALL LSL_PUTMSG (I2DIGIT__MDNOT2)
	   PROCESS = .FALSE.
	   GOTO 999
        ENDIF
C
	IF (MD2SCL.LE.0.0) THEN
	   CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'MD scale')
	   PROCESS = .FALSE.
	   GOTO 999
	ENDIF
C
	IF (.NOT.HAD_SCALESHEET) SCALESHEET = MD2SCL
C
	GOTO 10
C
C ......................................................................
C
C NF - New Feature
C
50	CALL EIHRI(FSN,1,1)		! read fsn
	HAD_ST=.FALSE.			! reset string flag
C
	GOTO 10				! get next IFF entry
C
C ......................................................................
C
C FS - Feature Code
C
60	CALL EIHRI(ISTAT,4,1)		! read feature code
	IFC = ISTAT(1)
C
	GOT_MATCH1 = .FALSE.
	GOT_MATCH2 = .FALSE.
C
C Check that the current feature code does match the one
C specified by the /FC qualifier. IF /FC was not given, process all features
C that were specified in parameter file
C
	IF (HAD_FC) THEN
	   DO 65 JJ=1,NUM_FC
	      IF (IFC.EQ.FC_LIST(JJ)) THEN ! we have a match
		 IF (ABS(LIB$EXTV(14,2,ISTAT(3))).EQ.2) GOTO 70 ! ignore text
		 GOT_MATCH1 = .TRUE.	! got a match
	      ENDIF
65	   CONTINUE
	ELSE
	   GOT_MATCH1 = .TRUE.		! process all features
	ENDIF
C
C Check it was in parameter file
C
	PARENTRY = FIND_ENTRY(IFC)
	IF (PARENTRY.GT.0) GOT_MATCH2 = .TRUE.
C
70	IF (GOT_MATCH1.AND.GOT_MATCH2) THEN
C
C Get next entry
C
	   GOTO 10
	ELSE
C
C Skip this feature as it was not in the FC list or parameter file (or text)
C
	   CALL IFFNXC('EF',IELEN)
	   IF (IELEN.EQ.-1) THEN
	      STATUS = I2DIGIT__MISSINGENTRY
	      CALL LSL_PUTMSG(STATUS,'EF')
	      GOTO 999
	   ENDIF
	   GOTO 10
	ENDIF
C
C ......................................................................
C
C ST - string
C
C Put coordinate data into buffer
C
110	TOTPTS=0
C
C Start new feature
C
	CALL WRITE_NEW_FEATURE(PARENTRY,PREVENTRY)
	PREVENTRY = PARENTRY
C
	HAD_ST=.TRUE.
115	CONTINUE
	IF(IECODE.EQ.'ST')THEN
	   CALL EIHRS( NPTS, IENDS)
	   IF (TOTPTS.GT.0.AND.IENDS.EQ.0) GOTO 125    ! ignore invisible lines
	   CALL EIHRR(STBUF(1,1),NPTS*2,1)
	   DO 120 JJ=1,NPTS
	      X = INT(((STBUF(1,JJ)-XMIN)*FACTOR*RESOLUTION)+OFFSET(1)+BORDER)
	      Y = INT(((YMAX-STBUF(2,JJ))*FACTOR*RESOLUTION)+OFFSET(2)+BORDER)
	      IF (CHECK_RANGE(X,Y,FSN)) THEN
		 WORDX = X
		 WORDY = Y
		 CALL ADD_WORD(WORDY)
		 CALL ADD_WORD(WORDX)
	      ELSE
		 STATUS = .FALSE.
		 GOTO 999
	      ENDIF
120	   CONTINUE
	   TOTPTS=TOTPTS+NPTS
125	   CALL IFFNXT(IECODE,IELEN)
	   GOTO 115
	ELSE
	   IF (TOTPTS.EQ.1) THEN	! output single points as lines
	      IF (CHECK_RANGE(X+2,Y,FSN)) THEN
		 WORDY = Y
		 WORDX = X+2
		 CALL ADD_WORD(WORDY)
		 CALL ADD_WORD(WORDX)
	      ELSE
		 STATUS = .FALSE.
		 GOTO 999
	      ENDIF
	   ENDIF
	   GOTO 11
	ENDIF
C
C ......................................................................
C
C EF - End Feature
C
130	GOTO 10
C                        
C ......................................................................
C
C EJ - End Job
C
C If a data block has been started fill with unspecified records
C
140	CALL ADD_WORD(END_OF_DATA)
	IF (DISKBUFPTR.GT.1) THEN
	   DO 150 KK = DISKBUFPTR,DISKBUFSIZE
	      DBY = (KK-1) / DISKBLOCKSIZE + 1
	      DBX = (KK-((DBY-1)*DISKBLOCKSIZE))
	      DISKBLOCK(DBX,DBY)=0
150	   CONTINUE
	ENDIF
	CALL FLUSH()
C
C And finish..
C
999	PROCESS = STATUS
	RETURN
	END
