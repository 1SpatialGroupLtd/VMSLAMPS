C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-11-02 10:04:46.000000000 +0000
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
	SUBROUTINE PROCESS
C
CDEC$	IDENT	'02NO94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	22-Sep-1994
C
C       MOD 1417. The orientation vector length for	ST	2-Nov-1994
C       symbols, SYM_LEN, is derived from the scale if
C	present, otherwise a message is given.
C
C	CONVERT I2MAPDATA Utility - Process IFF file
C
C Description
C
C	Processes the IFF file, writing the appropriate entries to the MAPDATA
C       output file as it goes along.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'		! MD common block
	INCLUDE	'LSL$CMNIFF:IFFHAN.CMN'   	! IFF handling 
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB filename expansion
	INCLUDE	'CMN:IFF.CMN'      		! IFF specific things
	INCLUDE	'CMN:FILES.CMN'      		! filenames
	INCLUDE 'CMN:CONTROL.CMN'		! control variables
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
C
C Functions
C
	LOGICAL		FIND_FC
	INTEGER*4	SIGCHS
C
C Local variables
C
	LOGICAL		HAD_AC		! true if had the correct AC in feature
	LOGICAL		HAD_RO		! true if had RO in feature
	LOGICAL		HAD_MD		! true if had the Map Descriptor
C
	INTEGER*2	IECODE		! IFF entry code
	INTEGER*2	IELEN		! length of IFF entry
	INTEGER*2	LAYER		! layer number
	INTEGER*2	FSTAT(4)	! feature status
	INTEGER*2	IENDS		! pen up/down marker
	INTEGER*2	NCOORD		! twice no of points in ST entry
C
	INTEGER*2	ACTYPE		! type of AC
	INTEGER*4	ACVAL		! value of AC
C
	INTEGER*4	FC		! feature code
	CHARACTER*7	MD_FC		! MapData feature code
	REAL*4		ORIENT		! Orientation
C
C------------------------------------------------------------------------------
C Initialise some things
C
	XOFF = 0.0
	YOFF = 0.0
	HAD_MD = .FALSE.
C
C Write the MapData header
C
	CALL WRITE_MD_HEAD
C
C Get next IFF entry into hand
C
10	CALL IFFNXT(IECODE,IELEN)
C
	IF (IERCD.NE.0) THEN			! error reading IFF file
	   CALL LSL_PUTMSG(I2MD__IFFREADERR,IFFFIL(1:IFFLEN))
	   GOTO 10000				! so abort
	ELSEIF (IELEN.EQ.-1) THEN		! unexpected end of IFF file
	   CALL LSL_PUTMSG(I2MD__UNEXPENDIFF)
	   GOTO 9000				! but try to tidy up
	ENDIF
C
C Despatch table for entries to be processed
C
	IF (IECODE .EQ. 'MD') GOTO 100
	IF (IECODE .EQ. 'NO') GOTO 200
	IF (IECODE .EQ. 'NF') GOTO 300
	IF (IECODE .EQ. 'FS') GOTO 400
	IF (IECODE .EQ. 'AC') GOTO 500
	IF (IECODE .EQ. 'CB') GOTO 600
	IF (IECODE .EQ. 'RO') GOTO 700
	IF (IECODE .EQ. 'EF') GOTO 800
	IF (IECODE .EQ. 'EJ') GOTO 900
	IF (IECODE .EQ. 'EM') GOTO 900		! in case there is no EJ
C
C Get next entry
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process Map Descriptor MD
C
100	SYM_LEN = 10.0				! default 10 IFF untis
	IF (IELEN.NE.MD2LEN) THEN		! not type 2 MD 
           CALL LSL_PUTMSG (I2MD__UNSETMD)
	   CALL LSL_PUTMSG(I2MD__UNSETSCALE,SYM_LEN)
        ELSE
	   CALL EIHR(MD2ARR,MD2LEN,1)
	   IF (MATV2.EQ.2) THEN
	      IF (HAD_OFFSET) THEN
		 XOFF = MD2LOC(1)
		 YOFF = MD2LOC(2)
	      ENDIF
	      HAD_MD = .TRUE.
C
C Calculate the distance to be used to generate the second point of a
C rotated symbol. If the scale is unset in the MD, use the default of 10 IFF
C units.
C
	      IF (MD2SCL.EQ.0.0) THEN
		 CALL LSL_PUTMSG(I2MD__UNSETSCALE,SYM_LEN)
	      ELSE
		 SYM_LEN = MD2SCL * 0.004	! Make segment 4 sheet mms
	      ENDIF
	   ELSE
	      CALL LSL_PUTMSG (I2MD__UNSETMD)
	      CALL LSL_PUTMSG(I2MD__UNSETSCALE,SYM_LEN)
	   ENDIF
        ENDIF
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process new layer NO
C
200	IF (.NOT.HAD_MD) THEN
	   CALL LSL_PUTMSG(I2MD__NOMD)
	   GOTO 9000
	ENDIF
C
	CALL EIHR(LAYER,1,1)
C
	IF (LAYER.EQ.0) THEN
	   CALL IFFNXC('EO',IELEN)
	   IF (IELEN.EQ.-1) THEN		! unexpected end of IFF file
	      CALL LSL_PUTMSG(I2MD__UNEXPENDIFF)
	      GOTO 9000				! but try to tidy up
	   ENDIF
	   IF (HAD_LOG) CALL LSL_PUTMSG(I2MD__IGNLAY)
	   GOTO 10
	ELSE
	   IF (HAD_LOG) CALL LSL_PUTMSG(I2MD__LAYER,LAYER)
	ENDIF
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process New Feature NF
C
300	CALL VIOCLR(AC_BYTE,255,0)	! clear the attribute array
	AC_LEN = 0			! length of attribute string
	POINTNUM = 0 			! initialise the point number
	STARTED_FEATURE = .FALSE.	! havent stared the MapData feature yet
	HAD_AC = .FALSE.		! clear presence of AC for this feat
	HAD_RO = .FALSE.		! clear presence of RO for this feat
	FSN = 0				! clear top word
	CALL EIHR(FSN,1,1)		! extract feature serial number
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process Feature Status FS
C
400	CALL EIHR(FSTAT,4,1)		! extract feature status
	FC = FSTAT(1)			! and set the feature code
C
	IS_TEXT = (FSTAT(3).AND.'8000'X).EQ.'8000'X	! set flags depending
	IS_SYM  = (FSTAT(3).AND.'4000'X).EQ.'4000'X	! on the FS bits
C
C Ignore text features 
C
	IF (IS_TEXT) THEN
	   CALL IFFNXC('EF',IELEN)
	   IF (IELEN.EQ.-1) THEN		! unexpected end of IFF file
	      CALL LSL_PUTMSG(I2MD__UNEXPENDIFF)
	      GOTO 9000				! but try to tidy up
	   ENDIF
	   GOTO 10
	ENDIF
C
C If there is no feature code mapping, ignore the feature
C
	IF (.NOT.FIND_FC(FC)) THEN		! doing FIND_FC sets FC_IND
	   CALL IFFNXC('EF',IELEN)
	   IF (IELEN.EQ.-1) THEN		! unexpected end of IFF file
	      CALL LSL_PUTMSG(I2MD__UNEXPENDIFF)
	      GOTO 9000				! but try to tidy up
	   ENDIF
C
	   CALL LSL_PUTMSG(I2MD__UNKFC,FC,FSN)
	   GOTO 10
	ENDIF

	GOTO 10
C
C------------------------------------------------------------------------------
C Process Attribute Code AC
C
500	CALL EIHRI(ACTYPE,1,1)
	CALL EIHRL(ACVAL,1,2)
	IF (HAD_TEXT_AC .AND. ACTYPE.EQ.TEXT_AC_CODE) THEN
	   AC_LEN = IELEN-3
	   IF (AC_LEN.GT.0) CALL EIHR(AC_BYTE(1),AC_LEN,4)
	ENDIF
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process Coordinate Block CB
C
600	CALL READ_POINTS(IENDS)
C
C Check that a symbol has the correct number of points
C
	IF (IS_SYM .AND. NPTS.GT.2) THEN
	   CALL LSL_PUTMSG(I2MD__TOOMANYPTS,NPTS,FSN)
	   CALL IFFNXC('EF',IELEN)		! find end of this feature
	   IF (IELEN.EQ.-1) THEN		! unexpected end of IFF file
	      CALL LSL_PUTMSG(I2MD__UNEXPENDIFF)
	      GOTO 9000				! but try to tidy up
	   ENDIF
	   GOTO 10
	ENDIF
C
C A pen-up will always result in a new feature
C
	IF (IENDS.EQ.0) STARTED_FEATURE = .FALSE.
C
C Write the SEGMENT and CODE lines if not already done so
C
	IF (.NOT.STARTED_FEATURE) CALL START_FEATURE()
C
C Write the points if this is a line feature. Symbol features are delayed
C until the EF as we may find an RO on the way.
C
	IF (.NOT.IS_SYM) CALL WRITE_POINTS(IENDS)
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process ROtation RO
C
700	CALL EIHRR(ORIENT,1,1)
	HAD_RO = .TRUE.
C
C Create a second point for the point feature from rotation
C
	IF (IS_SYM) CALL ROTATION_TO_POINT(ORIENT)
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process End Feature EF
C
800	IF (IS_SYM) CALL WRITE_POINTS(IENDS)
C
	GOTO 10
C
C------------------------------------------------------------------------------
C Process End Job EJ or EM
C
900	CONTINUE
C
C------------------------------------------------------------------------------
C Tidy up
C
9000	CONTINUE
C
C Return
C
10000	RETURN
	END
