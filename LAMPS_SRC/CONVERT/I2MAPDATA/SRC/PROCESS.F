	SUBROUTINE PROCESS
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	22-Sep-1994
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
	INCLUDE	'LSL$CMNIFF:CB.STR'		! record structure definition
C
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB filename expansion
	INCLUDE	'CMN:FILES.CMN'      		! filenames
	INCLUDE 'CMN:CONTROL.CMN'		! control variables
C
C Local variables
C
	LOGICAL		HAD_RO		! true if had RO in feature
C
	INTEGER*2	IECODE		! IFF entry code
	INTEGER*2	IELEN		! length of IFF entry
	INTEGER*2	LAYER		! layer number
	INTEGER*2	FSTAT(4)	! feature status
	INTEGER*2	NPTS		! no of points in ST entry
	INTEGER*2	IENDS		! pen up/down marker
	INTEGER*2	NCOORD		! twice no of points in ST entry
C
	REAL		XYZ(3,IFF_MAXCBROW)	! coordinates
	REAL*8		DBL_XYZ(3,IFF_MAXCBROW)	! coordinates with offset
C
	INTEGER*2	ACTYPE		! type of AC
	RECORD	/IFF_CBITEM/	ACVAL	! value of AC
	BYTE		ACTEXT(80)	! text of AC
	INTEGER*4	ACTLEN		! and its length
CCCCC	INTEGER*2	ACTLEN		! and its length
C
	INTEGER*4	FSN		! feature serial number
	INTEGER*4	FC		! feature code
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
C
C Get next entry
C
	GOTO 10
C
C Process Map Descriptor MD
C
 100	CONTINUE
C
C
	GOTO 10
C
C Process new layer NO
C
 200	CONTINUE
C
	CALL EIHR(LAYER,1,1)
C
CCCCC ignore if 0
C
	GOTO 10
C
C Process New Feature NF
C
 300	CONTINUE
C
	FSN = 0				! clear top word
	CALL EIHR(FSN,1,1)		! extract feature serial number
C
	HAD_RO = .FALSE.
C
	GOTO 10
C
C Process Feature Status FS
C
 400	CONTINUE
C
	CALL EIHR(FSTAT,4,1)		! extract feature status
	FC = FSTAT(1)			! and set the feature code
C
CCCCC check with FIND_FC
CCCCC find if line/text/symbol (see I2IMAP) and take action (ignore a text)
C
	GOTO 10
C
C Process Attribute Code AC
C
 500	CONTINUE
C
C
	GOTO 10
C
C Process Coordinate Block CB
C
 600	CONTINUE
C
CCCCC remember to add offset (see I2IMAP)
CCCCC for lines (see I2IMAP), invisible moves start new MD feature
C
	GOTO 10
C
C Process ROtation RO
C
 700	CONTINUE
C
C
	GOTO 10
C
C Process End Feature EF
C
 800	CONTINUE
C
C
	GOTO 10
C
C Process End Job EJ
C
 900	CONTINUE
C
C
	CONTINUE
C
C Tidy up
C
 9000	
C
C Return
C
10000	RETURN
	END
