C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1997-03-25 15:41:02.000000000 +0000
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
	LOGICAL FUNCTION EXTRACT_TILE(TILE_NAME,TILE_LEN,
     &	                              TILE_PATH,TILE_PATHLEN)
C
CDEC$	IDENT	'25MR97'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	21-May-1992
C
C Description:
C
C       Routine to start extracting tables once at the TILE level
C       Incoming filename is of the form "device:[DCW.SASAUS.CL.X.E.12]"
C       or "device:[DCW.SASAUS.CL]" if library is BROWSE
C       which has been tested for existance
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C Common blocks
C
	INCLUDE 'TABLES.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNIFF:MHDMB.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE 'LSL$CMNLSL:EXPC.CMN'
C
C Arguments
C
	CHARACTER*8	TILE_NAME		! working tile name
	INTEGER*4	TILE_LEN		! length of the above
	CHARACTER*(*)	TILE_PATH		! working path name
	INTEGER*4	TILE_PATHLEN		! length of the above
C
C Functions
C
	LOGICAL		FILE_EXISTS		! check for files
	INTEGER*4	IFFCREATE		! create IFF file
	INTEGER*4	LIB$SHOW_VM		! show virtual mem statistics
	INTEGER*4	LIB$DELETE_FILE		! delete a file
	INTEGER*4	CREATE_AREA_FEATURES	! write area features to file
	INTEGER*4	CREATE_LINE_FEATURES	! write line features to file
	INTEGER*4	CREATE_POINT_FEATURES	! write point features to file
	INTEGER*4	CREATE_TEXT_FEATURES	! write text features to file
	INTEGER*4	HOW_MANY_FEATURES	! find the num features written
C
C Local workspace
C
	BYTE		DATBUF(10)		! to hold the date
	BYTE		TIMBUF(9)		! and the time
	INTEGER*4	I,J,K,X,Y	     	! loopy
	INTEGER*4	OK		     	! status
	CHARACTER*255	PATH			! working path name
	INTEGER*4	PATHLEN	     		! length of the above
	CHARACTER*12	TABLE			! table name
	INTEGER*4	TABLELEN		! table name length
	INTEGER*4	NUM_FEATURES		! number of features written
	INTEGER*4	LPOSRA
	INTEGER*4	LPOSNO
	INTEGER*2	IECODE
	INTEGER*2	IELEN
	REAL*4		RANGE(4)
	REAL*4		CP(4,4)
	REAL*4		CC(10,2)
C
C ......................................................................
C
	EXTRACT_TILE = .TRUE.		! assume success
C
C See if coverage directory already exists and create it if is does not
C
	IF (.NOT.FILE_EXISTS(TARGETNAM(1:TARGETLEN)//
     &	                     COV_SEL(COVSEL)(1:2)//'.DIR')) THEN
	   CALL LIB$CREATE_DIR(TARGETNAM(1:TARGETLEN-1)//'.'//
     &	                     COV_SEL(COVSEL)(1:2)//']')
	ENDIF
C
C Create IFF file
C
	OK = IFFCREATE(IFFLUN,TARGETNAM(1:TARGETLEN-1)//'.'//
     &	                      COV_SEL(COVSEL)(1:2)//']'//
     &	                      TILE_NAME(1:TILE_LEN)//'.IFF',,,,)
	IF (.NOT.OK) THEN
	   GOTO 999
	ENDIF
C
C Report it
C
	IF (HAD_ENA_VERB) CALL WRITEF
	CALL WRITEF('Creating IFF file %S',TARGETNAM(1:TARGETLEN-1)//'.'//
     &	                                  COV_SEL(COVSEL)(1:2)//']'//
     &	                                  TILE_NAME(1:TILE_LEN)//'.IFF')
C
C Select this file for writing
C
	CALL IFFSEL(IFFLUN)
C
C Find origin of SW of current GEOREF
C
	CALL SET_MAPDES()
C	IF (HAD_ENA_VERB) THEN
C	   CALL WRITEF('Origin offset is %F5.1 %F5.1',ORIGIN(1),ORIGIN(2))
C	ENDIF
C
C Write header entries
C
	LPOSRA = LPOSE
	CALL IFFRA(RANGE)
	CALL IFFHI
	CALL IFFMH(MHARR,MHI4SZ)
	CALL IFFMD(MD2ARR,MD2LEN)
C
C Create New Section string
C
	CALL TIME(TIMBUF)
	TIMBUF(9) = 0
	CALL DATE(DATBUF)
	DATBUF(10) = 0
C
C lower-case 2nd and 3rd letters of month name
C
	DATBUF(5) = DATBUF(5)-'A'+'a'
	DATBUF(6) = DATBUF(6)-'A'+'a'
C
	CALL EXPAND ('Created by DCW2I on %AZ at %AZ',
     &					  DATBUF, TIMBUF)
C
C and thus we have our New Section declaration
C
	CALL IFFNS(EXPBUF,EXPLEN)
C
	CALL IFFCC(CC)
C
C Set control points
C
	DO 100 I = 1,4
	   DO 200 J = 1,4
	      CP(I,J) = 0.0
200	   CONTINUE
100	CONTINUE
	CP(1,3) = 5.0
	CP(1,4) = 5.0
	CP(2,1) = 5.0
	CP(2,4) = 5.0
	CP(3,3) = 5.0
	CP(3,4) = 5.0
	CP(4,1) = 5.0
	CP(4,4) = 5.0
	CALL IFFCP(CP)
	LPOSNO = LPOSE
	CALL IFFNO(1,0,0)
C
C Initialise various values
C
	CALL INIT_VALUES(%REF(ORIGIN(1)),
     &	                 %REF(ORIGIN(2)),
     &	                 %REF(TEXTGAP),
     &	                 %REF(HAD_ENA_VERB))
C
C CHAR(0) is appended to end of strings because C routines need strings to be
C NULL terminated.
C
C Create AREA features
C
	IF (HAD_AFT) THEN
	   PATHLEN = TILE_PATHLEN + 5
	   PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'FAC.;'
	   IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
	      PATHLEN = TILE_PATHLEN + 5
	      PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'RNG.;'
	      IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
		 PATHLEN = TILE_PATHLEN + 5
		 PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'EDG.;'
		 IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
		    PATHLEN = TILE_PATHLEN + 1
		    PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//CHAR(0)
		    TABLELEN = 11
		    TABLE(1:TABLELEN)=COV_SEL(COVSEL)(1:2)//'AREA.AFT'//CHAR(0)
		    OK = CREATE_AREA_FEATURES(%REF(TABLE),%REF(PATH))
		    IF (.NOT.OK) THEN
		       PATHLEN = TILE_PATHLEN + 5
		       PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'FAC.;'
		       CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
		       GOTO 998
		    ENDIF
		 ELSE
		    CALL LSL_PUTMSG(DCW2I__MISSINGTABLE,'EDG','area',
     &			            TILE_NAME(1:TILE_LEN))
C		    GOTO 998
		 ENDIF
	      ELSE
		 CALL LSL_PUTMSG(DCW2I__MISSINGTABLE,'RNG','area',
     &		                 TILE_NAME(1:TILE_LEN))
C		 GOTO 998
	      ENDIF
	   ELSE
	      CALL LSL_PUTMSG(DCW2I__MISSINGTABLE,'FAC','area',
     &		              TILE_NAME(1:TILE_LEN))
C	      GOTO 998
	   ENDIF
	ENDIF
C
C Create LINE features
C
	IF (HAD_LFT) THEN
	   PATHLEN = TILE_PATHLEN + 5
	   PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'EDG.;'
	   IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
	      PATHLEN = TILE_PATHLEN + 1
	      PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//CHAR(0)
	      TABLELEN = 11
	      TABLE(1:TABLELEN)=COV_SEL(COVSEL)(1:2)//'LINE.LFT'//CHAR(0)
	      OK = CREATE_LINE_FEATURES(%REF(TABLE),%REF(PATH))
	      IF (.NOT.OK) THEN
		 PATHLEN = TILE_PATHLEN + 5
		 PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'EDG.;'
		 CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
		 GOTO 998
	      ENDIF
	   ELSE
	      CALL LSL_PUTMSG(DCW2I__MISSINGTABLE,'EDG','line',
     &		              TILE_NAME(1:TILE_LEN))
C	      GOTO 998
	   ENDIF
	ENDIF
C       
C       Create POINT features
C       
	IF (HAD_PFT) THEN
	   PATHLEN = TILE_PATHLEN + 5
	   PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'END.;'
	   IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
	      PATHLEN = TILE_PATHLEN + 1
	      PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//CHAR(0)
	      TABLELEN = 12
	      TABLE(1:TABLELEN)=COV_SEL(COVSEL)(1:2)//'POINT.PFT'//CHAR(0)
	      OK = CREATE_POINT_FEATURES(%REF(TABLE),%REF(PATH))
	      IF (.NOT.OK) THEN
		 PATHLEN = TILE_PATHLEN + 5
		 PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'END.;'
		 CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
		 GOTO 998
	      ENDIF
	   ELSE
	      CALL LSL_PUTMSG(DCW2I__MISSINGTABLE,'END','point',
     &		              TILE_NAME(1:TILE_LEN))
C	      GOTO 998
	   ENDIF
	ENDIF
C
C Create TEXT features
C
	IF (HAD_TFT) THEN
	   PATHLEN = TILE_PATHLEN + 5
	   PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'TXT.;'
	   IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
	      PATHLEN = TILE_PATHLEN + 1
	      PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//CHAR(0)
	      TABLELEN = 11
	      TABLE(1:TABLELEN)=COV_SEL(COVSEL)(1:2)//'TEXT.TFT'//CHAR(0)
	      OK = CREATE_TEXT_FEATURES(%REF(TABLE),%REF(PATH))
	      IF (.NOT.OK) THEN
		 PATHLEN = TILE_PATHLEN + 5
		 PATH(1:PATHLEN) = TILE_PATH(1:TILE_PATHLEN)//'TXT.;'
		 CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
		 GOTO 998
	      ENDIF
	   ELSE
	      CALL LSL_PUTMSG(DCW2I__MISSINGTABLE,'TXT','text',
     &		              TILE_NAME(1:TILE_LEN))
C	      GOTO 998
	   ENDIF
	ENDIF
C
C Check if any features were written
C
	NUM_FEATURES = HOW_MANY_FEATURES()
	IF (NUM_FEATURES.GT.0) THEN
C
C Update overlay address
C
	   CALL IFFUNO(LPOSNO)
	   CALL IFFEO
	   CALL IFFEM
	   CALL IFFEJ
C
C Update range
C
	   CALL GET_RANGE(%REF(RANGE(1)),
     &		          %REF(RANGE(2)),
     &	                  %REF(RANGE(3)),
     &		          %REF(RANGE(4)))
	   CALL IFFPKE(IECODE,IELEN,LPOSRA)
	   CALL EIHWR(RANGE,4,1)
	ENDIF
C
C Close file
C
	CALL IFFCLO(IFFLUN)
C
C If no features were written, delete the IFF file
C
	IF (NUM_FEATURES.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__ZEROFEAT)
	   CALL LIB$DELETE_FILE(TARGETNAM(1:TARGETLEN-1)//'.'//
     &	                      COV_SEL(COVSEL)(1:2)//']'//
     &	                      TILE_NAME(1:TILE_LEN)//'.IFF',,,,,,,,)
	ELSE
	   IF (HAD_ENA_VERB) THEN
	      CALL WRITEF('%^L%I0 Feature(s) written to file',NUM_FEATURES)
	   ENDIF
	ENDIF
C
C Free tables
C
C	CALL WRITEF('Before freeing primitive tables......')
C	CALL LIB$SHOW_VM
	CALL FREE_PRIMITIVE_TABLES()
C	CALL WRITEF('After freeing primitive tables......')
C	CALL LIB$SHOW_VM
C
	GOTO 1000
C
C ......................................................................
C
998	CALL IFFCLO(IFFLUN)
999	EXTRACT_TILE = .FALSE.
1000	RETURN
	END
