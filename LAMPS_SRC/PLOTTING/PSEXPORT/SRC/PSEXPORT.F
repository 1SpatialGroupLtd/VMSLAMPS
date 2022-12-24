C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1996-05-14 11:35:16.000000000 +0100
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
	PROGRAM	PSEXPORT
C
CDEC$	IDENT	'14MY96'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	12-January-1994
C
C Process PS file producing output suitable for Adobe Illustrator
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:CLD.CMN'
	INCLUDE		'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE		'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
	INCLUDE		'PSEXPORTMSG.PAR'
	INCLUDE		'PSEXPORT.CMN'
C
C Functions
	EXTERNAL	PSEXPORT_CLD
	INTEGER		FLROPN,FLWOPN
	INTEGER		FLRLIN
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	INTEGER		EXPAND
	INTEGER		SKIP_UNTIL
	INTEGER 	PROCESS_SETUP
	INTEGER		PROCESS_PLOT
	LOGICAL		TRNALL
	INTEGER		DCL_STARTUP
	INTEGER		DCL_QUAL
	INTEGER		DCL_STR
	INTEGER		DCL_FILE
C
C Workspace
	INTEGER	OK
	INTEGER	I
	INTEGER	PS_SF
	CHARACTER*10	TRAN
	LOGICAL	  	ABSENT			! true if absent
	LOGICAL	  	LOCAL			! true if local
	LOGICAL	  	LOCNEG			! true if locally negated
	LOGICAL		QUAL			! qualifier present
	INTEGER		IERR			! error return
	REAL		LLX,LLY,URX,URY
	RECORD	/DDSC/	INFIL,OUTFIL,OUTDEF
	CHARACTER*(MAX_TXTLIM)	TXTSTR
	EQUIVALENCE	(TXTBUF,TXTSTR)
C
	CALL LSL_INIT(.TRUE.)
C
C Get and parse the command line using LSLLIB routines
	OK = DCL_STARTUP('PSEXPORT',	! command verb
     &			 .FALSE.,	! don't split parameter lists
     &			 PSEXPORT_CLD,	! CLD module name
     &			 .TRUE.)	! .T. - local error reporting
	IF (.NOT.OK) GOTO 999
C
C Get the name of the input file
	OK = DCL_FILE('P1','.PS',ABSENT,.TRUE.,.TRUE.)
	IF (.NOT.OK) GOTO 999
	CALL STR$COPY_DX(INFIL,FILARY(1)(:FIL_LEN(1)))
	IF (HAD_NAM) CALL STR$COPY_DX(OUTDEF,STR_NAM(:LEN_NAM))
C
C get format - qualifier is compulsory in CLD, so should not
C need to set default
	FORMAT = F_AI88
	OK = DCL_QUAL('FORMAT.AI88',QUAL,LOCAL,LOCNEG,.TRUE.)
	IF (.NOT.OK) GOTO 999
	IF (QUAL) FORMAT=F_AI88
	OK = DCL_QUAL('FORMAT.EPS',QUAL,LOCAL,LOCNEG,.TRUE.)
	IF (.NOT.OK) GOTO 999
	IF (QUAL) FORMAT=F_EPS
C
C Get the name of the output file
	IF (FORMAT.EQ.F_AI88) THEN
	   CALL STR$APPEND(OUTDEF,EXT_AI88)
	ELSEIF (FORMAT.EQ.F_EPS) THEN
	   CALL STR$APPEND(OUTDEF,EXT_EPS)
	ENDIF
	OK = DCL_FILE('P2',OUTDEF,ABSENT,.TRUE.,.TRUE.)
	
	IF (.NOT.OK) GOTO 999
	IF (ABSENT) THEN
	   CALL STR$COPY_DX(OUTFIL,OUTDEF)
	ELSE
	   CALL STR$COPY_DX(OUTFIL,FILARY(1)(:FIL_LEN(1)))
	ENDIF
	CALL STR$FREE1_DX(OUTDEF)
C
	OK = DCL_QUAL('LOG',LOG,LOCAL,LOCNEG,.TRUE.)
C
	OK = FLROPN(ILUN,INFIL)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__ERROPIN,INFIL)
	   CALL LSL_ADDMSG(OK)
	   GOTO 999
	ENDIF
	IF (LOG) CALL LSL_PUTMSG(PSEXP__OPENIN,INFIL)
	CALL STR$FREE1_DX(INFIL)
C
	OK = FLWOPN(OLUN,OUTFIL)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__ERROPOUT,OUTFIL)
	   CALL LSL_ADDMSG(OK)
	   GOTO 999
	ENDIF
	IF (LOG) CALL LSL_PUTMSG(PSEXP__OPENOUT,OUTFIL)
	CALL STR$FREE1_DX(OUTFIL)
C
C check for number of sig. figs. - LSL$PS_SIGFIG
	PS_SF = 6
	IF (TRNALL('LSL$PS_SIGFIG',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(PS_SF)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$PS_SIGFIG - using default value')
	      PS_SF = 6
	   ENDIF
	   IF (PS_SF.LE.0.OR.PS_SF.GT.8) THEN
	      CALL TTWSTR(
     &	'Value of LSL$PS_SIGFIG must be 1-8 - using default value')
	      PS_SF = 6
	   ENDIF
	ENDIF
	PS_GLIMIT = 10**PS_SF
	GFLEN = EXPAND('%WS%%G0.%N ',PS_GFORMAT,PS_SF)
	FFLEN = EXPAND('%WS%%F0.%N ',PS_FFORMAT,PS_SF+2)
C
C write out first bit of output file
	IF (FORMAT.EQ.F_AI88) THEN
	   CALL FLWSTR('%!PS-Adobe-2.0 EPSF-1.2')
	   CALL FLWSTR('%%Creator: Adobe Illustrator(TM) 88')
	ELSEIF (FORMAT.EQ.F_EPS) THEN
	   CALL FLWSTR('%!PS-Adobe-3.0 EPSF-3.0')
	ENDIF
C
C find a bounding box in the input file
10	OK = SKIP_UNTIL('%%BoundingBox:')
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__NOBBOX)
	   GOTO 999
	ENDIF
	IF (TXTPTR.LE.14) GOTO 10	! no arguments
	CALL BSLN
	CALL SETWIN(15)
	IF (RDREAL(LLX)) GOTO 10	! argument not numeric
	CALL RDREAL(LLY)
	CALL RDREAL(URX)
	CALL RDREAL(URY)
	CALL FLWSTR(TXTDSC)		! OK, copy line to output
C
C rewind the input
	CALL FLRREW
C
C for EPS, just copy everything except %!PS and %%BoundingBox
	IF (FORMAT.EQ.F_EPS) THEN
20	   OK = FLRLIN()
	   IF (.NOT.OK) THEN
	      IF (OK.NE.LSL__EOF) CALL LSL_PUTMSG(OK)
	      GOTO 999
	   ENDIF
	   IF (TXTPTR.GE.4.AND.TXTSTR(:4).EQ.'%!PS') GOTO 20
	   IF (TXTPTR.GE.13.AND.TXTSTR(:13).EQ.'%%BoundingBox') GOTO 20
	   CALL FLWSTR(TXTDSC)
	   GOTO 20
	ENDIF
C
C otherwise must be AI88
	OK = NINT((LLX+URX)/2.0)	! horrid use of variable!
	I = NINT((LLY+URY)/2.0)
	CALL FLWRTF('%%TemplateBox: %N %N %N %N',OK,I,OK,I)
	CALL FLWSTR('%%EndComments')
	CALL FLWSTR('%%EndProlog')
C
C skip to the setup section
	OK = SKIP_UNTIL('%%BeginSetup')
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__NOSETUP)
	   GOTO 999
	ENDIF
C	
C now read until %%EndSetup looking for fonts and colours
	OK = PROCESS_SETUP()
	IF (.NOT.OK) GOTO 999
C
C now skip to the start of the actual plot data
	OK = SKIP_UNTIL('%%EndPageSetup')
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__NOPLOT)
	   GOTO 999
	ENDIF
C
C process plot data until we hit %%Trailer or %%Page
	OK = PROCESS_PLOT()
	IF (.NOT.OK) GOTO 999
C
C output trailer line, and we're done
	CALL FLWSTR('%%Trailer')
C
999	CALL FLRCLO(ILUN)
	CALL FLWCLO(OLUN)
C
	CALL LSL_EXIT
C
	END
C
	INTEGER	FUNCTION SKIP_UNTIL(STRING)
C
CDEC$	IDENT	'12JA94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	12-January-1994
C
C Skip file until line with leading string found
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
C
C Arguments
	CHARACTER*(*)	STRING	! string to skip until
C
C Functions
	INTEGER		FLRLIN
C
C workspace
	INTEGER		OK
	CHARACTER*(MAX_TXTLIM)	TXTSTR
	EQUIVALENCE	(TXTBUF,TXTSTR)
C
10	OK = FLRLIN()
	IF (.NOT.OK) GOTO 999
C
	IF (TXTPTR.LT.LEN(STRING)) GOTO 10		! too short
	IF (TXTSTR(:LEN(STRING)).NE.STRING) GOTO 10	! wrong
C
999	SKIP_UNTIL = OK
	RETURN
	END
