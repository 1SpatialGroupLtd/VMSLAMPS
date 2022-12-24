C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-14 11:02:20.000000000 +0100
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
        INTEGER*4 FUNCTION RD_PAR()
C
CDEC$	IDENT	'22AP91'
C
C Copyright Laser-Scan Laboratories Ltd.,Cambridge,England
C 
C	Created.					ST    22-Apr-1991
C
	IMPLICIT NONE
C
	INCLUDE 'PARAMS.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'COMMAND.CMN'
	INCLUDE 'LSL$CMNLSL:EXCEPTION.CMN'
C
C Longword:
	INTEGER	 I			! tmp. var.
	INTEGER  LINE			! /PARAMETER file line number
	INTEGER  IFC			! IFF feature code
	INTEGER	 RET			! for error return	
	INTEGER	 IERR			! for error return	
	INTEGER	 LABLEN			! length of GEN label	
C
C Logical:
	LOGICAL	PAROPEN			! /PARAMETER file now open
C
C Byte:
	BYTE	 ICH			! one character of TXTBUF
C
	INTEGER  SS$_NORMAL
	EXTERNAL SS$_NORMAL		! normal successful completion
C
C Functions:
	LOGICAL   FLROPN		! open file for FILEO	
	LOGICAL	  FLRSTR		! read line from file
	LOGICAL	  RDCHS			! read character - miss spaces
	INTEGER	  READSTR		! read a string from TXTBUF
	INTEGER	  RDLONG		! read a longword from TXTBUF
C
C Character:
	CHARACTER*80	LABEL		! the GEN string label
C
C ......................................................................
C
C Open parameter file?
C
C Was a parameter file specified at all?
	IF (HAD_PAR) THEN
C
C Open the /PARAMETER file
	   RD_PAR=FLROPN(PARLUN,PAR_FIL(:PAR_LEN),IERR)
           IF (RD_PAR) THEN			! did it open ok?
	      PAROPEN=.TRUE.			! file now open
C
C ......................................................................
C
C		M A I N   R E A D / D E C O D I N G   L O O P
C
C If the file opened OK read it line by line getting IFF feature code/
C GEN string labels pair by pair, one pair per record.
C
	      NUMC=0
	      LINE=0
C
 10	      LINE=LINE+1
	      RET=FLRSTR( ,, IERR )		! read a line from file
C
	      IF (RET.EQ.LSL__NORMAL) THEN
	         CALL BSLN
		 IF (RDCHS(ICH)) GOTO 10
	         IF (ICH.EQ.'!') GOTO 10	! comment line
		 CALL BSCH
C
C ......................................................................
C
C Read IFF feature code
C
		 IF (RDLONG(IFC)) THEN
		    CALL WRITEF('Error read FC from parameter file')
		    IF (ERRNUM.NE.LSL__NORMAL) THEN
		       IF (ERRNUM.EQ.LSL__HADEXCP) THEN
	                 GOTO 30
		       ENDIF
		    ENDIF
	         ENDIF
C
C ......................................................................
C
C Then find, read, uppercase and pad to 4 bytes the associated GEN 
C string label
C ......................................................................
C
		LABLEN=READSTR(LABEL,0,ON_SPACE,.TRUE.,IERR)
C
C Check for rogue comment delimiter ie "   n   ! string_label  "
C or "  n  !string_label "
C
	        IF (LABEL(1:1).EQ.'!') THEN
		   CALL WRITEF('Comment in parameter file is invalid')
		   GOTO 30
	        ENDIF
C
C Check for comment delimiter tacked onto end of label 
C ie  "  n   string_label!   "
C
	        IF (LABEL(LABLEN:LABLEN).EQ.'!') THEN
		   LABLEN=LABLEN-1		! remove if present.
	        ENDIF
C
C Check string label length
C
		IF (LABLEN.EQ.0.OR.LABLEN.GT.32) THEN
		   IF (.NOT.IERR) THEN
	              CALL LSL_ADDMSG(IERR)
		   ENDIF
		   CALL WRITEF('Feature description too long')
	   	   GOTO 30
		ENDIF
C
		CALL STR$UPCASE(LABEL(:LABLEN),LABEL(:LABLEN))
C
		DO 20 I=LABLEN+1,32
		   LABEL(I:I)=' '
20		CONTINUE
C
C ......................................................................
C
C Transfer our spoils into common for use in PROCESS
C
		NUMC=NUMC+1
	        IF (NUMC.GT.MAXLAB) THEN
		   CALL WRITEF('Too many parameter file entries')
		   GOTO 30
		ELSE
		   PAR_FC(NUMC)=IFC
		   PAR_LAB(NUMC)=LABEL(1:32)
		   GOTO 10
		ENDIF
C
C ......................................................................
C
C End of /PARAMETER file detected
C
	      ELSEIF (RET.EQ.LSL__EOF) THEN
C
C Had we got anthing from the file?
C
		 IF (NUMC.EQ.0) THEN		! no, disaster
		    CALL WRITEF('No parameter file entries')
	            CALL LSL_ADDMSG(RET)
	         ELSE				! yes, probably OK!
	           GOTO 30			! tidy up and return
	         ENDIF
C
C ......................................................................
C
C Some error rather than EOF while reading the /PARAMETER file
C
	      ELSE
	         CALL LSL_ADDMSG(RET)
	         IF (RET.EQ.LSL__SYSREAD) CALL LSL_PUTMSG(IERR)
	      ENDIF
C
C ......................................................................
C
C Couldn't get the /PARAMETER file to open
C
	   ELSE					! file open error
	      CALL WRITEF('Unable to open parameter file')
	      CALL LSL_ADDMSG(IERR)		! give any 2ndary error
           ENDIF
C
C ......................................................................
C
C We did'nt need to do anthing, all is well
C
	ELSE
	   RD_PAR=%LOC(SS$_NORMAL)
	ENDIF
C
C ......................................................................
C
C		T I D Y  U P   A N D  R E T U R N
C
C Ensure RD_PAR returns with the expected success code
C
30	IF (RD_PAR) RD_PAR=%LOC(SS$_NORMAL)
C
C If open, close /PARAMETER file
	IF (PAROPEN) CALL FLRCLO(PARLUN)
C
	RETURN
	END
