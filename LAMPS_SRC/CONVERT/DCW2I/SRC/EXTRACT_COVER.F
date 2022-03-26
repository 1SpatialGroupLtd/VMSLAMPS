	LOGICAL FUNCTION EXTRACT_COVER(COV_PATH,COV_PATHLEN)
C
CDEC$	IDENT	'21MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	21-May-1992
C
C Description:
C
C       Routine to start extracting tables once at the coverage level
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
C
C Arguments
C
	CHARACTER*(*)	COV_PATH		! working path name
	INTEGER*4	COV_PATHLEN		! length of the above
C
C Functions
C
	LOGICAL		FILE_EXISTS		! check for files
	INTEGER*4	READ_FCS_TABLE		! read FCS
	INTEGER*4	READ_AREA_TABLE		! read xxAREA.AFT
	INTEGER*4	READ_LINE_TABLE		! read xxLINE.LFT
	INTEGER*4	READ_POINT_TABLE	! read xxPOINT.PFT
	INTEGER*4	READ_TEXT_TABLE		! read xxTEXT.TFT
	INTEGER*4	FREE_FEATURE_TABLES	! free feature table memory
	LOGICAL*4	EXTRACT_GEOREF		! extract data from GEOREF
	LOGICAL*4	EXTRACT_TILE		! extract data from tile
C
C Local workspace
C
	INTEGER*4	I,J,K,X,Y	     	! loopy
	INTEGER*4	OK		     	! status
	CHARACTER*8	GEO_NAME		! working GEOREF name
	CHARACTER*255	PATH			! working path name
	INTEGER*4	PATHLEN	     		! length of the above
	INTEGER*4	TMPLEN	     		! temp working length
C
C ......................................................................
C
	EXTRACT_COVER = .TRUE.		! assume success
	HAD_AFT = .FALSE.
	HAD_LFT = .FALSE.
	HAD_PFT = .FALSE.
	HAD_TFT = .FALSE.
C
C       read FCS - if doesn't exist, complain and exit
C       read all tables listed in FCS of form xxAREA,xxLINE,xxPOINT,xxTEXT
C       read INT.VDT and CHAR.VDT if exist
C       if BROWSE then
C          read all primitives tables in FCS from current directory
C          - types FAC,RNG,EDG,EDX,END,TXT,TXX
C       else
C          for each listed GEOREF
C              if GEOREF doesn't exist, complain and skip to next
C              for each tile 1,1 to 3,3
C                  if tile doesn't exist, complain and skip to next
C                  set the path of form COV_PATH//'X.E.11'
C                  read all primitives tables in FCS from current directory
C                  -types FAC,RNG,EDG,EDX,END,TXT,TXX
C              endfor
C          endfor
C       endif
C
C
C CHAR(0) is appended to end of strings because C routines need strings to be
C NULL terminated.
C
C Read table FCS into memory. Fail if it does not exist
C
	PATHLEN = COV_PATHLEN + 5 + 1
	PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN)//'FCS.;'//CHAR(0)
	IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
	   PATHLEN = COV_PATHLEN + 3 + 1
	   PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN)//'FCS'//CHAR(0)
	   OK = READ_FCS_TABLE(%REF(PATH))
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
	      GOTO 999
	   ENDIF
	ELSE
	   CALL LSL_PUTMSG(DCW2I__NOSUCHFILE,PATH(1:PATHLEN))
	   GOTO 999
	ENDIF
C
C Read AREA Feature Table if it exists
C
	PATHLEN = COV_PATHLEN + 2 + 8 + 1
	PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN)//
     &	                  COV_SEL(COVSEL)(1:2)//
     &	                  'AREA.AFT'//
     &	                  CHAR(0)
	IF (FILE_EXISTS(PATH(1:PATHLEN)) .AND. WANT_AREAS) THEN
	   OK = READ_AREA_TABLE(%REF(PATH))
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
	      GOTO 999
	   ENDIF
	   HAD_AFT = .TRUE.
	ENDIF
C
C Read LINE Feature Table if it exists
C
	PATHLEN = COV_PATHLEN + 2 + 8 + 1
	PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN)//
     &	                  COV_SEL(COVSEL)(1:2)//
     &	                  'LINE.LFT'//
     &	                  CHAR(0)
	IF (FILE_EXISTS(PATH(1:PATHLEN)) .AND. WANT_LINES) THEN
	   OK = READ_LINE_TABLE(%REF(PATH))
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
	      GOTO 999
	   ENDIF
	   HAD_LFT = .TRUE.
	ENDIF
C
C Read POINT Feature Table if it exists
C
	PATHLEN = COV_PATHLEN + 2 + 9 + 1
	PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN)//
     &	                  COV_SEL(COVSEL)(1:2)//
     &	                  'POINT.PFT'//
     &	                  CHAR(0)
	IF (FILE_EXISTS(PATH(1:PATHLEN)) .AND. WANT_POINTS) THEN
	   OK = READ_POINT_TABLE(%REF(PATH))
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
	      GOTO 999
	   ENDIF
	   HAD_PFT = .TRUE.
	ENDIF
C
C Read TEXT Feature Table if it exists
C
	PATHLEN = COV_PATHLEN + 2 + 8 + 1
	PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN)//
     &	                  COV_SEL(COVSEL)(1:2)//
     &	                  'TEXT.TFT'//
     &	                  CHAR(0)
	IF (FILE_EXISTS(PATH(1:PATHLEN)) .AND. WANT_TEXT) THEN
	   OK = READ_TEXT_TABLE(%REF(PATH))
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(DCW2I__TABLEFAIL,PATH(1:PATHLEN))
	      GOTO 999
	   ENDIF
	   HAD_TFT = .TRUE.
	ENDIF
C
C Read Primitive Tables
C
	IF (LIBRARY.EQ.BROWSE) THEN
	   GEO_NAME(1:8) = COV_SEL(COVSEL)(1:2)//'BROWSE'
	   CURRGEO(1:2)='  '
	   OK = EXTRACT_TILE(GEO_NAME,8,COV_PATH,COV_PATHLEN)
C
C Continue to next coverage if failed
C
	   IF (.NOT.OK) THEN
	      CALL LSL_ADDMSG(DCW2I__SKIPTILE,GEO_NAME(1:8))
	   ENDIF
C
	ELSE
C
C Check if directory of form [DCW.SASAUS.CL.X]E.DIR exists
C
	   IF (ALL_GEO_SEL) THEN
	      DO 200 X = 1,NUM_LONG_GEO
		 DO 100 Y = 1,NUM_LAT_GEO
		    IF (FILE_EXISTS(COV_PATH(1:COV_PATHLEN-1)//'.'//
     &			            LONG_GEOREF(X:X)//']'//
     &			            LAT_GEOREF(Y:Y)//'.DIR')) THEN
		       PATHLEN = COV_PATHLEN - 1 + 1 + 4
		       PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN-1)//'.'//
     &			                 LONG_GEOREF(X:X)//'.'//
     &			                 LAT_GEOREF(Y:Y)//'.'
		       GEO_NAME(1:4) = COV_SEL(COVSEL)(1:2)//
     &			               LONG_GEOREF(X:X)//
     &			               LONG_GEOREF(Y:Y)
		       CURRGEO(1:2)=LONG_GEOREF(X:X)//LONG_GEOREF(Y:Y)
		       OK = EXTRACT_GEOREF(0,GEO_NAME,4,PATH,PATHLEN)
C
C Continue to next if GEOREF failed
C
		       IF (.NOT.OK) THEN
			  CALL LSL_ADDMSG(DCW2I__SKIPGEO,GEO_NAME(1:4))
			  CALL WRITEF
		       ENDIF
		    ENDIF
100		 CONTINUE
200	      CONTINUE
	   ELSE
	      DO 300 I = 1,NUM_GEO_SEL
		 IF (FILE_EXISTS(COV_PATH(1:COV_PATHLEN-1)//'.'//
     &		                 GEO_SEL(I)(1:1)//']'//
     &		                 GEO_SEL(I)(2:2)//'.DIR')) THEN
		    PATHLEN = COV_PATHLEN - 1 + 1 + 4
		    PATH(1:PATHLEN) = COV_PATH(1:COV_PATHLEN-1)//'.'//
     &		                      GEO_SEL(I)(1:1)//'.'//
     &		                      GEO_SEL(I)(2:2)//'.'
		    GEO_NAME(1:4) = COV_SEL(COVSEL)(1:2)//GEO_SEL(I)(1:2)
		    CURRGEO(1:2)=GEO_SEL(I)(1:2)
		    OK = EXTRACT_GEOREF(I,GEO_NAME,4,PATH,PATHLEN)
C
C Continue to next if GEOREF failed
C
		    IF (.NOT.OK) THEN
		       CALL LSL_ADDMSG(DCW2I__SKIPGEO,GEO_NAME(1:4))
		       CALL WRITEF
		    ENDIF
C
		 ENDIF
300	      CONTINUE

	   ENDIF
	ENDIF
C
	GOTO 1000
C
C ......................................................................
C
999	EXTRACT_COVER = .FALSE.
C
1000	RETURN
	END
