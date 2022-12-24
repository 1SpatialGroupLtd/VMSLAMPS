C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-24 14:29:56.000000000 +0100
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

	LOGICAL FUNCTION RDSIF
C
CDEC$	IDENT	'02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read SIF file
C
C Description
C
C	This function reads a SIF command file
C
C	For ordinary errors, we attempt to continue with the file
C
C	Returns FALSE if something drastic goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'CMN:LUN.PAR'		    ! logical unit numbers
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! LSLLIB text buffer
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:IFF_MAP.CMN'	! MD parameters
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF feature
	INCLUDE 'CMN:LUT.CMN'		! CCSM LUT
	INCLUDE 'CMN:FILES.CMN'		! files
	INCLUDE 'CMN:FLAGS.CMN'		! various flags
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'	! for reading magtape
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
C
C Functions called
C
	INTEGER*4	MTINIT		! initialise magtape
	INTEGER*4	MTIRWD		! rewind magtape
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	READLINE	! read line from file or tape
	INTEGER*4	MTIRDB		! read block from tape
	INTEGER*4	FLRLIN		! read line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDLONG		! read a longword integer
	LOGICAL		RDINT		! read a word integer
	LOGICAL		RDCH		! read a character
	LOGICAL		RDCHS		! read a character skipping blanks
	LOGICAL		READSTR		! read a string
	LOGICAL		READ_SEP	! read a longword integer
	LOGICAL		SKIP_CONTLIN	! skip continuation lines
	INTEGER		TEST_FOREIGN	! test device mounted /FOREIGN
C
	LOGICAL		RDDID		! SIF DID command
	LOGICAL		RDLAC		! SIF LAC command
	LOGICAL		RDLST		! SIF LST command
	LOGICAL		RDTXT		! SIF TXT command
	LOGICAL		RDSYM		! SIF SYM command
	LOGICAL		RDCIR		! SIF CIR command
	LOGICAL		RDARC		! SIF ARC command
	LOGICAL		RDPTN		! SIF PTN command
	LOGICAL		RDTX3		! SIF TX3 command
	LOGICAL		RDTPC		! SIF TPC command
	LOGICAL		RDPG		! SIF PAR command
	LOGICAL		RDPLN		! SIF PLN command
	LOGICAL		RDCLP		! SIF CLP command
	LOGICAL		RDACZ		! SIF ACZ command
	LOGICAL		RDMTX		! SIF MTX command
	LOGICAL		RDPA3		! SIF PA3 command
	LOGICAL		RDOVR		! SIF OVR command
	LOGICAL		RDIDE		! SIF IDE command
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! counter
	INTEGER*4	J		! counter
	INTEGER*4	STATUS		! function return status
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	CHARACTER*12	CCSM		! CCSM code
	CHARACTER*80	DUMSTR		! dummy string
	CHARACTER*20	HDR_FIELD	! CCG file header
	CHARACTER*10	FIELD		! ident field
	INTEGER*4	IDENT		! IDE ident
	INTEGER*4	USER1		! IDE user1
	INTEGER*4	USER2		! IDE user2
	INTEGER*2	LAYER		! layer number
	LOGICAL		FOREIGN		! tape mounted foreign flag
	LOGICAL		NOLONG		! longword integer return status
	LOGICAL		NOINT		! word integer return status
	LOGICAL		OK		! function return status
	BYTE		ICH		! character read
C
C External declaration
C
	INTEGER*4	SIFCMD_CMD_TABLE
	EXTERNAL	SIFCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDSIF = .TRUE.
C
C Initialise tapedrive to Read SIF file from mag tape
C
	IF (MAGTAPE) THEN
	   STATUS = TEST_FOREIGN( TAPEDEV(1:TAPEDEVLEN),FOREIGN,ERRCOD )
C
C Test if the tape is mounted /FOREIGN
C
	   IF ( STATUS .EQ. LSL__NORMAL .AND. FOREIGN ) THEN
	      ERRCOD = MTINIT( TAPEDEV(1:TAPEDEVLEN), .FALSE., )
C
C Either the tape is not mounted foreign or the user specified a device name
C that isn't a tape device, in which case the filename is missing
C
	   ELSEIF ( STATUS .EQ. LSL__NORMAL .AND. .NOT.FOREIGN ) THEN
	      CALL LSL_PUTMSG( SIF2IFF__NOTMNTFOR,TAPEDEV(1:TAPEDEVLEN) )
	      GOTO 9999
C
C Error in device name
C
	   ELSEIF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( SIF2IFF__NODEVICE,TAPEDEV(1:TAPEDEVLEN) )
	      GOTO 9999
	   ENDIF
	ELSE
C
C Open our SIF file, read only
C
	  ERRCOD = FLROPN(SIFLUN,SIFFIL,RETCOD)
	ENDIF
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   IF (MAGTAPE) THEN
	      CALL LSL_PUTMSG(SIF2IFF__ERRINIMAG,TAPEDEV(1:TAPEDEVLEN))
	   ELSE
	      CALL LSL_PUTMSG(SIF2IFF__ERROPNSIF,SIFFIL(1:SIFLEN))
	   ENDIF
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
C
C Otherwise let them know what we are doing.
C
	ELSE
	   IF (MAGTAPE) THEN
	      IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__READMAG)
	   ELSE
	      IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__READSIF)
	   ENDIF
	ENDIF
C
C Some CCG tapes may contain a cell file before the SIF file proper,
C so skip this.
C
	IF (HAD_CCG.AND.HAD_CELL) THEN
50	   ERRCOD = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	   IF (ERRCOD .EQ. LSL__EOF) GOTO 51
	   IF (.NOT. ERRCOD) THEN
	      CALL LSL_PUTMSG(SIF2IFF__ERRRDMAG,TAPEDEV(1:TAPEDEVLEN))
	      CALL LSL_ADDMSG(ERRCOD)
	      GOTO 9999
	   ENDIF
	   GOTO 50
	ENDIF
51	CONTINUE
C
C Haven't got a line yet
C
	RECSIZ = 72
	LINE = 0
C
	IF (HAD_CCG) THEN
C
C Read the header record first
C
	   MTPTR = 1
	   REC_COUNT = 0
	   RECSIZ = 216
	   ERRCOD = READLINE(RETCOD)
	   IF (ERRCOD .EQ. LSL__EOF) GOTO 800
	   LINE = LINE+1
	   DO 100 I = 1, 3
	      LEN = READSTR(HDR_FIELD,',',ON_CHAR,.TRUE.)
100	   CONTINUE
C
200	   CONTINUE
	   STATUS = RDCH( ICH )
	   IF ( CHAR(ICH) .NE. '=' ) GOTO 200
C
	   STATUS = RDLONG( XMIN )
	   STATUS = RDCH( ICH )
	   STATUS = RDLONG( YMIN )
	   STATUS = RDCH( ICH )
	   STATUS = RDLONG( XMAX )
	   STATUS = RDCH( ICH )
	   STATUS = RDLONG( YMAX )
C
C Control points for IFF section
C
 	   CPS(1,1) = REAL(XMIN - XMIN) / UNITS
 	   CPS(2,1) = REAL(YMAX - YMIN) / UNITS
 	   CPS(1,2) = REAL(XMIN - XMIN) / UNITS
 	   CPS(2,2) = REAL(YMIN - YMIN) / UNITS
 	   CPS(1,3) = REAL(XMAX - XMIN) / UNITS
 	   CPS(2,3) = REAL(YMIN - YMIN) / UNITS
 	   CPS(1,4) = REAL(XMAX - XMIN) / UNITS
 	   CPS(2,4) = REAL(YMAX - YMIN) / UNITS
	   IF (MAGTAPE) THEN
	      REC_COUNT = 3
	      RECSIZ = 72
	   ENDIF
	ENDIF	      
C
C So let us read in the lines, one by one
C
500	LINE = LINE+1
C
	ERRCOD = READLINE(RETCOD)
	IF (ERRCOD .EQ. LSL__EOF) GOTO 800
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   IF (MAGTAPE) THEN
	      CALL LSL_PUTMSG(SIF2IFF__ERRRDMAG,TAPEDEV(1:TAPEDEVLEN))
	      CALL LSL_ADDMSG(ERRCOD)
	   ELSE
	      CALL LSL_PUTMSG(SIF2IFF__ERRRDSIF,SIFFIL(1:SIFLEN),LINE)
	      CALL LSL_ADDMSG(ERRCOD)
	      IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	   ENDIF
	   GOTO 9999
	ENDIF
C
C Check for a blank line. If it is, ignore it
C
501	IF (RDCHS(ICH)) THEN
	   GOTO 500
	ELSE
	   CALL BSLN
	ENDIF
C
C Now, read the command from the line
C
	RESULT = RDCOMM(SIFCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) GOTO 5555
C
C Look for '/' seperator - send warning mess if not found
C
	IF (RESULT.EQ.19) OK = RDCH(ICH)
	OK = READ_SEP('/')
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(SIF2IFF__SEPNOTFOU)	!warning mess
	   GOTO 5555
	ENDIF
C
C Despatch according to command
C
	GOTO (510,520,530,540,550,560,570,580,590,600,540,
     &	      610,620,630,640,650,660,670,680,640,690,700,
     &	      680,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888,
     &	      8888,8888,8888,8888,8888) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 5555
C
C DID -
C
510	IF ( .NOT. RDDID() ) GOTO 5555
	GOTO 500
C
C OVR - 
C
520	CONTINUE
	NOINT = RDINT(LAYER)
C
C If there's an error output message and carry on using old layer 
C number.
C
	IF (NOINT) THEN
	   CALL LSL_PUTMSG( SIF2IFF__NOOVRNUM )
	   GOTO 5555
	ELSE
	   CALL IFFUNO(LPOSNO)			! update NO/EO pointer
	   CALL IFFEO				! end the previous layer
C
	   LPOSNO = LPOSE
	   CALL IFFNO(LAYER,0,0)		! start new layer
	ENDIF	
	GOTO 500
C
C LAC -
C
530	IF ( .NOT. RDLAC() ) GOTO 5555
	GOTO 500
C
C LST -
C
540	IF ( .NOT. RDLST() ) GOTO 5555
	GOTO 500
C
C SYM -
C
550	IF ( .NOT. RDSYM() ) GOTO 5555
	GOTO 500
C
C TXT -
C
560	IF ( .NOT. RDTXT() ) GOTO 5555
	IF (LINE_IN_HAND) THEN
	   LINE_IN_HAND = .FALSE.
	   GOTO 501
	ENDIF
	GOTO 500
C
C FNT -
C
570	NOLONG = RDLONG(FONT)
	IF (NOLONG) GOTO 5555
	GOTO 500
C
C IDE - ignore unless CCG qualifier is used
C
580	CONTINUE
C
C IDE/ - Ident field containing CCSM code. Lookup table gives IFF FC
C
	   IF (HAD_CCG) THEN
	      LEN = READSTR( FIELD,',',ON_CHAR,.TRUE.)
	      LEN = READSTR( FIELD,',',ON_CHAR,.TRUE.)
400	      CONTINUE
	         STATUS = RDCH( ICH )
	         IF ( CHAR(ICH) .NE. '=' ) GOTO 400
	      STATUS = RDLONG( IDENT )
	      STATUS = RDCH( ICH )
	      STATUS = RDLONG( USER1 )
	      STATUS = RDCH( ICH )
	      STATUS = RDLONG( USER2 )
	      CALL ID_CCSM( IDENT,USER1,USER2,CCSM )
C
C Lookup feature code in LUT
C	      
	      FC = 0
	      DO 581 I = 1, NUMFC
	         IF ( FC_CCSM_LUT(I).CCSM .EQ. CCSM ) THEN	! Found it
	            FC = FC_CCSM_LUT(I).FC
	            GOTO 500
	         ENDIF
581	      CONTINUE
C
C If the FC was not found add it to the LUT
C
	      IF ( FC .EQ. 0 ) THEN
	         NUMFC = NUMFC + 1
	         FC_CCSM_LUT(NUMFC).FC = 0
	         FC_CCSM_LUT(NUMFC).CCSM = CCSM
	      ENDIF
C
C IDE not supported for non CCG data.
C
	   ELSE
	     GOTO 8888
	   ENDIF
C
	GOTO 500
C
C CIR -
C
590	IF ( .NOT. RDCIR() ) GOTO 5555
	GOTO 500
C
C ARC -
C
600	IF ( .NOT. RDARC() ) GOTO 5555
	GOTO 500
C
C BST -
C
610	CONTINUE
CCC	IF (.NOT.HAD_CCG) HAD_BST = .TRUE.			! now in a complex string
	GOTO 500
C
C EST - flag end complex, then treat as a line string
C
620	CONTINUE
CCC	IF (.NOT.HAD_CCG) HAD_BST = .FALSE.
CCC	IF (.NOT.HAD_CCG) HAD_EST = .TRUE.
CCC	IF (.NOT.HAD_CCG) THEN
CCC	   GOTO 540
CCC	ELSE
	   GOTO 500
CCC	ENDIF
C
C PTN - 
C
630	IF ( .NOT. RDPTN() ) GOTO 5555
	GOTO 500
C
C TPC - 
C
640	IF ( .NOT. RDTPC() ) GOTO 5555
	GOTO 500
C
C PAR - paragraphing
C
650	IF ( .NOT. RDPG() ) GOTO 5555
	GOTO 500
C
C PLN - 
C
660	IF ( .NOT. RDPLN() ) GOTO 5555
	GOTO 500
C
C CLP - Close a paragraph, reset default no. of lines in a paragraph
C
670	PARLIN = 1
	GOTO 500
C
C TX3 - 
C
680	IF ( .NOT. RDTX3() ) GOTO 5555
	GOTO 500
C
C ACZ - 
C
690	IF ( .NOT. RDACZ() ) GOTO 5555
	GOTO 500
C
C MTX - 
C
700	IF ( .NOT. RDMTX() ) GOTO 5555
	GOTO 500
C
C Unsupported commands. Output a message only for first occurrance.
C
8888	CONTINUE
C
C Check to see if in list of unsupported commands already had. If so, 
C dont output message.
C
	CALL BSLN
	LEN = READSTR(UNSUP,'/',ON_CHAR)
	DO 8000 I = 1,IUNSUP
	   IF (UNSUPLIST(I).EQ.UNSUP) THEN
	      IF (.NOT.SKIP_CONTLIN()) GOTO 9999	
	      GOTO 500
	   ENDIF
8000	CONTINUE	      
C
C If this is first occurence add to list and output message.
C
	IUNSUP = IUNSUP + 1
	UNSUPLIST(IUNSUP) = UNSUP
	IF (HAD_LOG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__UNSUPCMD,CMDNST)
	ELSE
	   NOLINEMESS = .TRUE.
	ENDIF
C
C Skip any continuation lines
C
	IF (.NOT.SKIP_CONTLIN()) GOTO 9999
	GOTO 5555
C
C Error decoding line. This is output if NOLINEMESS is false.
C
5555	IF (NOLINEMESS) THEN
C
C Don't output message this time, but set NOLINEMESS back to false.
C
	   NOLINEMESS = .FALSE.
	ELSE
	   CALL LSL_ADDMSG(SIF2IFF__LINEINSIF,LINE)
	   LSL_STATUS = SIF2IFF__LINEINSIF		! reduce error status
	ENDIF
	GOTO 500
C
C Close the file
C
800	IF (MAGTAPE) THEN
	   ERRCOD = MTIRWD()
	ELSE
	   ERRCOD = FLRCLO(SIFLUN,RETCOD)
	ENDIF
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   IF (MAGTAPE) THEN
	      CALL LSL_PUTMSG(SIF2IFF__ERRRWDMAG,TAPEDEV(1:TAPEDEVLEN))
	   ELSE
	      CALL LSL_PUTMSG(SIF2IFF__ERRCLOSIF,SIFFIL(1:SIFLEN))
	   ENDIF
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
	GOTO 9000
C
C Failure
C
9999	RDSIF = .FALSE.
C
C Return
C
9000	RETURN
	END
