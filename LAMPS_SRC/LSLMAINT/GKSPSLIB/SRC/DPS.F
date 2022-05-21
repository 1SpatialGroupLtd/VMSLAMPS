C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1995-04-03 14:19:54.000000000 +0100
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
	SUBROUTINE GKS_SET_PS_FONT(LOGNAM)
C
CDEC$	IDENT	'03AP95'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-Oct-1992
C
C Set list of fonts from logical name
C
	IMPLICIT NONE
C
	INCLUDE	'($LNMDEF)'
	INCLUDE	'LSL$CMNLSL:TXTC.CMN'
	INCLUDE	'DDSC.PAR'
C
C Arguments
	CHARACTER*(*)	LOGNAM
C
C Functions
	INTEGER		SYS$TRNLNM
	LOGICAL		RDLONG,RDCHS
	INTEGER		GETFILNAM
C
C workspace
	STRUCTURE	/LNMITM/
	   INTEGER*2	BUFLEN/0/
	   INTEGER*2	ITMCOD/0/
	   INTEGER*4	BUFADR/0/
	   INTEGER*4	RETADR/0/
	END STRUCTURE
	RECORD	/LNMITM/ ITMLST(4)
	RECORD	/DDSC/	FFILE
C
	INTEGER		OK,IND,MAXIND,FNUM
	INTEGER		FLEN
	BYTE		CH
	INTEGER*4	FDESC(2)
C
	IND = 0
	ITMLST(1).BUFLEN = 4
	ITMLST(1).ITMCOD = LNM$_INDEX
	ITMLST(1).BUFADR = %LOC(IND)

	ITMLST(2).BUFLEN = MAX_TXTLIM
	ITMLST(2).ITMCOD = LNM$_STRING
	ITMLST(2).BUFADR = TXTDSC(2)
	ITMLST(2).RETADR = %LOC(TXTPTR)

	ITMLST(3).BUFLEN = 4
	ITMLST(3).ITMCOD = LNM$_MAX_INDEX
	ITMLST(3).BUFADR = %LOC(MAXIND)
C
10	OK = SYS$TRNLNM(LNM$M_CASE_BLIND,'LNM$FILE_DEV',LOGNAM,,ITMLST)
	IF (.NOT.OK) THEN
	   CALL WRITEF('Error translating %S',LOGNAM)
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
	IF (TXTPTR.NE.0) THEN
	   CALL BSLN
C
C try for a number - if not, then assume .PSFONTLIST file
	   IF (RDLONG(FNUM)) THEN
	      IF (IND.EQ.0) THEN
	         CALL BSLN
	         CALL STR$GET1_DX(MAX_TXTLIM,FFILE)
	         FLEN = 0
	         OK = GETFILNAM( FFILE, FLEN, 'LSL$FRT:.PSFONTLIST', .TRUE.)
	         IF (.NOT.OK) THEN
	            CALL STR$FREE1_DX(FFILE)
	            CALL WRITEF('Bad PSFONTLIST file name in %S',LOGNAM)
	            CALL LSL_PUTMSG(OK)
	            GOTO 999
	         ENDIF
	         CALL STR$LEFT(FFILE,FFILE,FLEN)
	         CALL GKS_READ_FONT_LIST(FFILE)
	         CALL STR$FREE1_DX(FFILE)
	         MAXIND = 0
	      ELSE
	         CALL WRITEF('Font number missing in %S',LOGNAM)
	      ENDIF
	   ELSE
C
C look for find procedure, and strip off outer { }
	      IF (RDCHS(CH)) GOTO 900
	      IF (CH.EQ.'{') THEN
	         IF (RDCHS(CH)) GOTO 900
100	         CH = TXTBUF(TXTPTR)
	         TXTPTR = TXTPTR-1
	         IF (CH.EQ.' '.OR.CH.EQ.9) GOTO 100
	         IF (CH.NE.'}') GOTO 900
	      ENDIF
	      FDESC(1) = TXTPTR-DCPTR+2
	      FDESC(2) = %LOC(TXTBUF(DCPTR-1))
	      IF (FDESC(1).LE.0) GOTO 900
	      CALL GKS_WRITE_PS_FONT(
     &			FNUM,.FALSE.,
     &			0,	' ',
     &			FDESC(1),FDESC,
     &			0,	' ',
     &			0,	' ',
     &			0,	' ',
     &			1.0,	.FALSE.,
     &			.FALSE.,%VAL(0))
	      GOTO 901
900	      CALL WRITEF('Font procedure missing in %S',LOGNAM)
901	      CONTINUE
	   ENDIF
	ENDIF
	IF (IND.LT.MAXIND) THEN
	   IND = IND+1
	   GOTO 10
	ENDIF
C
999	RETURN
	END
C
	SUBROUTINE GKS_READ_FONT_LIST(FILENAME)
C
CDEC$	IDENT	'03SE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-Oct-1992
C
C Read .PSFONTLIST file
C
	IMPLICIT NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:CMDCOM.CMN'
	INCLUDE	'LSL$CMNLSL:EXPC.CMN'
	INCLUDE	'LSL$CMNLSL:TXTC.CMN'
	INCLUDE	'DDSC.PAR'
C
C Arguments
	CHARACTER*(*)	FILENAME
C
C Functions
	INTEGER		FLROPN,FLRCLO,FLRLIN
	INTEGER		RDCOMM
	LOGICAL		RDLONG,RDCHS
	INTEGER		GETFILNAM
	INTEGER		READSTR
	INTEGER		LIB$GET_LUN
	INTEGER		LIB$FREE_LUN
	EXTERNAL	GKS_PSFONT_CMD_TABLE
C
C workspace
	RECORD	/DDSC/	FNAME,FINDPROC,NEWNAME,ENCOD,AFMFIL,HEADER
	INTEGER		FLEN,FINDLEN,NEWLEN,ENCLEN,AFMLEN,HEADLEN
C
	INTEGER		OK,ERROR
	BYTE		CH
	INTEGER		LUN
	INTEGER		CMD
	LOGICAL*1	SAV_NOMESS
	INTEGER		FNUM
	INTEGER		NEWNUM
	REAL		SCALE
	LOGICAL		KERN_PAIR
	LOGICAL		R_TO_L
	LOGICAL		ARABIC
	INTEGER*4	ARATAB
	INTEGER		SAVBUF
	INTEGER*2	SAVLEN,SAVDCP
	INTEGER		LINENO
	INTEGER		I
C
	SAV_NOMESS = NOMESS
	NOMESS = .FALSE.
	ARATAB = 0
C
C get a LUN to read the file on
	OK = LIB$GET_LUN(LUN)
	IF (.NOT.OK) THEN		! failed
	   CALL LSL_PUTMSG(OK)
	   GOTO 10000
	ENDIF
C
C open up the file (just give up on error)
	OK = FLROPN(LUN,FILENAME)	! open file
	IF (.NOT.OK) THEN
	   CALL WRITEF('Failed to open .PSFONTLIST file "%S"',FILENAME)
	   CALL LSL_PUTMSG(OK)
	   GOTO 9999
	ENDIF
	FNUM = 0
	LINENO = 0
C
50	OK =  FLRLIN(,,,ERROR) 	! read into TXTBUF
	LINENO = LINENO+1
	IF (.NOT.OK) THEN
	   IF (OK.EQ.LSL__EOF) GOTO 100	! end of file
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	   GOTO 9998
	ENDIF
C
C we have a line - what is it ?
	CALL BSLN				! start of line
	IF (RDCHS(CH)) GOTO 50			! empty line
	IF (CH.EQ.'!') GOTO 50			! comment line
	CALL BSCH
	CMD = RDCOMM(GKS_PSFONT_CMD_TABLE)		! what is it ?
	IF (CMD.LE.0) GOTO 60			! error reading command.
C
	GOTO (100,200,300,400,500,600,700,800,900,1000), CMD
60	CALL WRITEF('Error in line %N of .PSFONTLIST file "%S"',
     &					LINENO,FILENAME)
	GOTO 50
C
C FONT n name (or EOF)
100	NEWNUM = INTARG(1)
	IF (FNUM.NE.0) THEN
	   IF (OK.NE.LSL__EOF) THEN
	      CALL LIB$GET_VM(TXTPTR,SAVBUF)
	      CALL SAVE_TXTC(%VAL(SAVBUF),SAVLEN,TXTPTR)
	      CALL DCPSAV(SAVDCP)
	   ENDIF
	   CALL GKS_WRITE_PS_FONT(
     &			FNUM,KERN_PAIR,
     &			FLEN,	FNAME,
     &			FINDLEN,FINDPROC,
     &			NEWLEN,	NEWNAME,
     &			ENCLEN,	ENCOD,
     &			AFMLEN,	AFMFIL,
     &			SCALE, R_TO_L,
     &			ARABIC,	%VAL(ARATAB))
	   IF (OK.NE.LSL__EOF) THEN
	      CALL RESTORE_TXTC(%VAL(SAVBUF),SAVLEN,SAVLEN)
	      CALL DCPSET(SAVDCP)
	      CALL LIB$FREE_VM(TXTPTR,SAVBUF)
	   ENDIF
	   FNUM = 0
	   CALL FLRSEL(LUN)
	ENDIF
	IF (OK.EQ.LSL__EOF) GOTO 9998
	SCALE = 1.0
	FINDLEN = 0
	NEWLEN = 0
	ENCLEN = 0
	CALL STR$FREE1_DX(ENCOD)	! free, so can append below
	KERN_PAIR = .FALSE.
	AFMLEN = 0
	R_TO_L = .FALSE.
	ARABIC = .FALSE.
	IF (NEWNUM.LE.0) THEN
	   CALL TTWSTR('Font number must be >0')
	   GOTO 60
	ENDIF
	IF (RDCHS(CH)) THEN
	   CALL WRITEF('Font name missing for font %N',NEWNUM)
	   GOTO 60
	ENDIF
	CALL BSCH
	FNUM = NEWNUM
	CALL STR$GET1_DX(TXTLIM,FNAME)
	FLEN = READSTR(FNAME,,ON_SPACE)
	CALL STR$LEFT(FNAME,FNAME,FLEN)
	GOTO 50
C
C FIND string
200	IF (FNUM.EQ.0) GOTO 9950
	IF (RDCHS(CH)) THEN
	   CALL WRITEF('Font FIND procedure missing for font %N',FNUM)
	   GOTO 60
	ENDIF
	CALL BSCH
	CALL STR$GET1_DX(TXTLIM,FINDPROC)
	FINDLEN = READSTR(FINDPROC)
	CALL STR$LEFT(FINDPROC,FINDPROC,FINDLEN)
	GOTO 50
C
C SCALE fac
300	IF (FNUM.EQ.0) GOTO 9950
	IF (REALAR(1).LE.0) THEN
	   CALL WRITEF('Font SCALE must be >0 for font %N',FNUM)
	   GOTO 60
	ENDIF
	SCALE = REALAR(1)
	GOTO 50
C
C NEWNAME name
400	IF (FNUM.EQ.0) GOTO 9950
	IF (RDCHS(CH)) THEN
	   CALL WRITEF('Font NEWNAME string missing for font %N',FNUM)
	   GOTO 60
	ENDIF
	CALL BSCH
	CALL STR$GET1_DX(TXTLIM,NEWNAME)
	NEWLEN = READSTR(NEWNAME,,ON_SPACE)
	CALL STR$LEFT(NEWNAME,NEWNAME,NEWLEN)
	GOTO 50
C
C ENCODING string
500	IF (FNUM.EQ.0) GOTO 9950
	IF (RDCHS(CH)) THEN
	   CALL WRITEF('Font ENCODING string missing for font %N',FNUM)
	   GOTO 60
	ENDIF
	CALL BSCH
	EXPLEN = EXPMAX
	EXPLEN = READSTR(EXPDSC)
	IF (ENCLEN.NE.0) THEN
	   CALL STR$APPEND(ENCOD,CHAR(13))
	   ENCLEN = ENCLEN+1
	ENDIF 
	CALL STR$APPEND(ENCOD,EXPDSC)
	ENCLEN = ENCLEN+EXPLEN
	GOTO 50
C
C KERNING PAIR
600	IF (FNUM.EQ.0) GOTO 9950
	KERN_PAIR = .TRUE.
	GOTO 50
C
C AFM filename
700	IF (FNUM.EQ.0) GOTO 9950
	IF (RDCHS(CH)) THEN
	   CALL WRITEF('Font AFM filename missing for font %N',FNUM)
	   GOTO 60
	ENDIF
	CALL BSCH
	CALL STR$GET1_DX(TXTLIM,AFMFIL)
	AFMLEN = 0
	OK = GETFILNAM( AFMFIL, AFMLEN,
     &		'SYS$PS_FONT_METRICS:.AFM', .TRUE.)
	IF (.NOT.OK) THEN
	   AFMLEN = 0
	   CALL WRITEF('Bad AFM file name for font %N',FNUM)
	   GOTO 60
	ENDIF
	CALL STR$LEFT(AFMFIL,AFMFIL,AFMLEN)
	GOTO 50
C
C HEADER string
800	IF (RDCHS(CH)) GOTO 50
	CALL BSCH
	CALL STR$GET1_DX(TXTLIM,HEADER)
	HEADLEN = READSTR(HEADER)
	CALL STR$LEFT(HEADER,HEADER,HEADLEN)
	CALL FLWSTR(HEADER)
	CALL STR$FREE1_DX(HEADER)
	GOTO 50
C
C ARABIC Input  Isolate Final Medial Initial
900	IF (FNUM.EQ.0) GOTO 9950
	IF (INTARG(1).LT.0.OR.INTARG(1).GT.255 .OR.
     &	    INTARG(2).LT.0.OR.INTARG(1).GT.255 .OR.
     &	    INTARG(3).LT.0.OR.INTARG(1).GT.255 .OR.
     &	    INTARG(4).LT.0.OR.INTARG(1).GT.255 .OR.
     &	    INTARG(5).LT.0.OR.INTARG(1).GT.255) THEN
	   CALL TTWSTR('ARABIC glyphs must be in the range 0-255')
	   GOTO 60
	ENDIF
	IF (.NOT.ARABIC) THEN
	   ARABIC = .TRUE.
	   IF (ARATAB.EQ.0) CALL LIB$GET_VM(256*4,ARATAB)
	   CALL VIOCLR(%VAL(ARATAB),256*4)
	ENDIF
	DO 910 I=0,3
	   CALL LIB$INSV(INTARG(I+2),0,8,%VAL(ARATAB+4*INTARG(1)+I))
910	CONTINUE
	GOTO 50
C
C DIRECTION RIGHT_TO_LEFT
1000	IF (FNUM.EQ.0) GOTO 9950
	R_TO_L = .TRUE.
	GOTO 50
C
9950	CALL TTWSTR('FONT command missing')
	GOTO 60
C
9998	OK = FLRCLO(LUN,ERROR)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	ENDIF
	CALL STR$FREE1_DX(FNAME)
	CALL STR$FREE1_DX(FINDPROC)
	CALL STR$FREE1_DX(NEWNAME)
	CALL STR$FREE1_DX(ENCOD)
	CALL STR$FREE1_DX(AFMFIL)
	IF (ARATAB.NE.0) THEN
	   CALL LIB$FREE_VM(256*4,ARATAB)
	   ARATAB = 0
	ENDIF
C
9999	OK = LIB$FREE_LUN(LUN)	! free LUN
	IF (.NOT.OK) CALL LSL_PUTMSG(OK)
C
10000	NOMESS = SAV_NOMESS
	RETURN
C
	END
C
	SUBROUTINE GKS_WRITE_PS_FONT(FNUM,KERN_PAIR,
     &			FLEN,	FNAME,
     &			FINDLEN,FINDPROC,
     &			NEWLEN,	NEWNAME,
     &			ENCLEN,	ENCOD,
     &			AFMLEN,	AFMFIL,
     &			SCALE,	R_TO_L,
     &			ARABIC,	ARATAB)
C
CDEC$	IDENT	'03SE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	9-July-1993
C
C Write info derived from .PSFONTLIST file
C
	IMPLICIT NONE
C
	INCLUDE	'LSL$CMNLSL:EXPC.CMN'
C
C Arguments
	INTEGER		FNUM
	LOGICAL		KERN_PAIR
	INTEGER		FLEN
	CHARACTER*(*)	FNAME
	INTEGER		FINDLEN
	CHARACTER*(*)	FINDPROC
	INTEGER		NEWLEN
	CHARACTER*(*)	NEWNAME
	INTEGER		ENCLEN
	CHARACTER*(*)	ENCOD
	INTEGER		AFMLEN
	CHARACTER*(*)	AFMFIL
	REAL		SCALE
	LOGICAL		R_TO_L
	LOGICAL		ARABIC
	BYTE		ARATAB(*)
C
C functions
	INTEGER*4	GKS_C_ALLOC_FONT
C
C workspace
	LOGICAL		KERNED
	INTEGER*4	FPTR
	INTEGER		I,J
C
	KERNED = KERN_PAIR
	IF (KERN_PAIR.AND.AFMLEN.EQ.0) THEN
	   CALL WRITEF('No AFM file for font %N, kerning disabled',FNUM)
	   KERNED = .FALSE.
	ENDIF
C
	FPTR = GKS_C_ALLOC_FONT(FNUM,SCALE,KERNED,R_TO_L,ARABIC,ARATAB)
C
C read the AFM
	IF (AFMLEN.GT.0.AND.FPTR.NE.0) THEN
	   CALL GKS_READ_AFM_FILE(AFMFIL,FPTR)
	ENDIF
C
C write out info for font
C Define Fn as procedure to find the font
	CALL FLWRTF('FNTDICT begin /F%N {',FNUM)
C
C use supplied find procedure, or findfont on the name
	IF (FINDLEN.EQ.0) THEN	! no find, so use name
	   CALL FLWRTF('/%S findfont',FNAME)
	ELSE
	   CALL FLWSTR(FINDPROC)
	ENDIF
C
C Scale the font
	IF (SCALE.NE.1.0) THEN
	   CALL FLWRTF('%F0.2 scalefont',SCALE)
	ENDIF
C
C Re-encode the font, using new name or derived name
	IF (ENCLEN.GT.0) THEN
	   IF (NEWLEN.GT.0) THEN
	      CALL FLWRTF('/%S',NEWNAME)
	   ELSE
	      CALL FLWRTF('/%S-ReENC',FNAME)
	   ENDIF
C
C write out the encoding string in C/R delimited chunks
	   I = 1
10	   J = INDEX(ENCOD(I:),CHAR(13))+I-1	! pos of C/R
	   IF (J.LT.I) J = ENCLEN+1
	   J = J-1
	   IF (J.GE.I) CALL FLWSTR(ENCOD(I:J))
	   I = J+2
	   IF (I.LE.ENCLEN) GOTO 10
C
	   CALL FLWSTR('ReENCODE')
	ENDIF
	CALL FLWSTR('} def end')
C
	RETURN
	END
C
	SUBROUTINE GKS_READ_AFM_FILE(FILENAME,FPTR)
C
CDEC$	IDENT	'03SE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-Oct-1992
C
C Read .AFM file
C
	IMPLICIT NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:TBLFLG.PAR'
	INCLUDE	'LSL$CMNLSL:CMDCOM.CMN'
	INCLUDE	'LSL$CMNLSL:EXPC.CMN'
	INCLUDE	'LSL$CMNLSL:TXTC.CMN'
	INCLUDE	'DDSC.PAR'
C
C Arguments
	CHARACTER*(*)	FILENAME	! AFM filename
	INTEGER*4	FPTR		! font structure
C
C Functions
	INTEGER		FLROPN,FLRCLO,FLRLIN
	INTEGER		RDCOMM,ADDNAM
	LOGICAL		RDCHS,RDREAL
	INTEGER		READSTR
	INTEGER		LIB$GET_LUN
	INTEGER		LIB$FREE_LUN
	INTEGER		LIB$EXTZV
	EXTERNAL	GKS_AFM_CMD_TABLE
	EXTERNAL	GKS_MET_CMD_TABLE
	EXTERNAL	GKS_COMP_CMD_TABLE
C
C workspace
	RECORD	/DDSC/	CNAME
	INTEGER		CLEN
C
	INTEGER		OK,ERROR
	BYTE		CH
	INTEGER		LUN
	INTEGER		CMD
	LOGICAL*1	SAV_NOMESS
	INTEGER		CHARNO
	REAL		WIDTH,BOX(4)
	REAL		KPX
	REAL		DELTAX,DELTAY
	INTEGER		C1,C2
	INTEGER*4	NAMTAB
	INTEGER		TABSIZ
	INTEGER		UNENC
	LOGICAL		HAD_CHAR_METRICS
C
	SAV_NOMESS = NOMESS
	NOMESS = .TRUE.
	NAMTAB = 0
	UNENC = 0	! number of un-encoded characters
	HAD_CHAR_METRICS = .FALSE.
C
C get a LUN to read the file on
	OK = LIB$GET_LUN(LUN)
	IF (.NOT.OK) THEN		! failed
	   CALL LSL_PUTMSG(OK)
	   GOTO 10000
	ENDIF
C
C open up the file (just give up on error)
	OK = FLROPN(LUN,FILENAME)	! open file
	IF (.NOT.OK) THEN
	   CALL WRITEF('Failed to open .AFM file "%S"',FILENAME)
	   CALL LSL_PUTMSG(OK)
	   GOTO 9999
	ENDIF
C
50	OK =  FLRLIN(,,,ERROR) 	! read into TXTBUF
	IF (.NOT.OK .AND. OK.NE.LSL__RECTOOBIG) THEN
	   IF (OK.EQ.LSL__EOF) GOTO 9998	! end of file
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	   GOTO 9998
	ENDIF
C
C we have a line - what is it ?
	CALL BSLN				! start of line
	IF (RDCHS(CH)) GOTO 50			! empty line
	CALL BSCH
	CMD = RDCOMM(GKS_AFM_CMD_TABLE)		! what is it ?
	IF (CMD.EQ.0) GOTO 50			! error reading command.
C
	GOTO (100,200,300,400,500,600,700,800,900), CMD
	GOTO 50
C
C StartCharMetrics
100	IF (INTARG(1).LE.0) GOTO 50
	IF (HAD_CHAR_METRICS) GOTO 50
	HAD_CHAR_METRICS = .TRUE.
	TABSIZ = INTARG(1)*2+2
C
	CALL LIB$GET_VM(TABSIZ*4,NAMTAB)
	CALL INITAB(%VAL(NAMTAB),TABSIZ)
C
C Remove the 'upcase' bit and set the 'exact' bit in the table header,
C by saving, changing, save array, and selecting again
	CALL SAVTAB(TXTBUF)
        CALL LIB$INSV(0,CMT$V_UPCASE,1,TXTBUF(31))
        CALL LIB$INSV(1,CMT$V_EXACT,1,TXTBUF(31))
	CALL LIB$INSV(1,CMT$V_DIGOK,1,TXTBUF(31))
	CALL SELTAB(TXTBUF)
	CALL GKS_C_SET_TAB_SIZE(%VAL(FPTR),INTARG(1),%VAL(NAMTAB))
	GOTO 50
C
C EndCharMetrics
200	IF (.NOT.HAD_CHAR_METRICS) GOTO 50
	CALL GKS_C_TRIM_TAB(%VAL(FPTR),256+UNENC)
	GOTO 50
C
C StartKernPairs
300	GOTO 50
C
C EndKernPairs
400	GOTO 50
C
C StartComposites
500	GOTO 50
C
C EndComposites
600	GOTO 50
C
C C (character number in CharMetrics)
700	IF (.NOT.HAD_CHAR_METRICS) GOTO 50
	CHARNO = INTARG(1)
	IF (CHARNO.LT.0.OR.CHARNO.GT.255) THEN	! not encoded
	   UNENC = UNENC+1
	   CHARNO = UNENC+255
	ENDIF
	WIDTH = 0.0
	BOX(1) = 0.0
	BOX(2) = 0.0
	BOX(3) = 0.0
	BOX(4) = 0.0
	CLEN = 0
C skip over semi-colon
710	IF (RDCHS(CH)) GOTO 790
	IF (CH.NE.';') GOTO 710
	CMD = RDCOMM(GKS_MET_CMD_TABLE)	! what is it ?
	IF (CMD.EQ.0) GOTO 710			! error reading command.
	GOTO (711,712,713),CMD
	GOTO 710
C
C WX (width in CharMetrics)
711	WIDTH = REALAR(1)
	GOTO 710
C
C N (character name in CharMetrics)
712	CALL STR$GET1_DX(TXTLIM,CNAME)
	CLEN = READSTR(CNAME,,ON_SPACE)
	CALL STR$LEFT(CNAME,CNAME,CLEN)
	GOTO 710
C
C B (bounding box in CharMetrics, llx lly urx ury)
713	BOX(1) = REALAR(1)
	BOX(2) = REALAR(2)
	BOX(3) = REALAR(3)
	BOX(4) = REALAR(4)
	GOTO 710
C
C define this character's width and name
790	CALL GKS_C_SET_CHAR_METRICS(%VAL(FPTR),CHARNO,WIDTH,BOX)
	IF (CLEN.GT.0) THEN
C
C Unfortunately, ADDNAM upper cases the name and removes numbers,
C so horrible code to change to what we really want.
C Just add a dummy name for now, since a name comprising
C completely numbers causes an error in ADDNAM
	   CMD = ADDNAM('A',1,CHARNO+1)
	   IF (CMD.LE.0) THEN
	      CALL WRITEF(
     &		'Error adding character name "%S" to table',CNAME)
	   ELSE
C
C get number of commands in table
C clear out command number so don't confuse STR$...
C check string long enough (allow for digits, lost by ADDNAM)
C copy the string in
C put the command number back
	      CMD = LIB$EXTZV(0,15,%VAL(NAMTAB))
	      C2 = NAMTAB+CMD*8	! address of command desc
	      CALL LIB$INSV(0,16,16,%VAL(C2))
	      C1 = LIB$EXTZV(0,16,%VAL(C2))
	      IF (C1.NE.CLEN) THEN
	         CALL LIB$INSV(CLEN,0,16,%VAL(C2))
	         IF (C1.GT.0) CALL LIB$FREE_VM(C1,%VAL(C2+4))
	         CALL LIB$GET_VM(CLEN,%VAL(C2+4))
	      ENDIF
	      CALL STR$COPY_DX(%VAL(C2),CNAME)
	      CALL LIB$INSV(CHARNO+1,16,16,%VAL(C2))
	   ENDIF
	ENDIF
	CALL STR$FREE1_DX(CNAME)
	GOTO 50
C
C KPX (Kerning amount in KernPairs)
800	IF (.NOT.HAD_CHAR_METRICS) GOTO 50
	CMD = RDCOMM(%VAL(NAMTAB))
	IF (CMD.LE.0) GOTO 50
	C1 = CMD-1
	CMD = RDCOMM(%VAL(NAMTAB))
	IF (CMD.LE.0) GOTO 50
	C2 = CMD-1
	IF (RDREAL(KPX)) GOTO 50
C
C set kern value
	CALL GKS_C_SET_KERN_PAIR(%VAL(FPTR),C1,C2,KPX)
	GOTO 50
C
C CC (Composite char in Composites)
900	IF (.NOT.HAD_CHAR_METRICS) GOTO 50
	CMD = RDCOMM(%VAL(NAMTAB))
	IF (CMD.LE.256) GOTO 50	! doesn't exist, or is encoded anyway
	C1 = CMD-1
C skip over semi-colon
910	IF (RDCHS(CH)) GOTO 50
	IF (CH.NE.';') GOTO 910
	CMD = RDCOMM(GKS_COMP_CMD_TABLE)	! what is it ?
	IF (CMD.EQ.0) GOTO 910			! error reading command.
	GOTO (911),CMD
	GOTO 910
C
C PCC (composite part in Composites)
911	CMD = RDCOMM(%VAL(NAMTAB))
	IF (CMD.LE.0.OR.CMD.GT.256) GOTO 910
	C2 = CMD-1
	IF (RDREAL(DELTAX)) GOTO 910
	IF (RDREAL(DELTAY)) GOTO 910
C
C set kern value
	CALL GKS_C_SET_COMPONENT(%VAL(FPTR),C1,C2,DELTAX,DELTAY)
	GOTO 910
C
9998	OK = FLRCLO(LUN,ERROR)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	ENDIF
C
9999	OK = LIB$FREE_LUN(LUN)	! free LUN
	IF (.NOT.OK) CALL LSL_PUTMSG(OK)
C
10000	NOMESS = SAV_NOMESS
	RETURN
C
	END
C
	SUBROUTINE GKS_FREE_NAME_TABLE(SIZE,NAMTAB)
C
CDEC$	IDENT	'03SE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-Oct-1992
C
C Free a dynamic command table (called from DPS_C.C)
C
C argument
	INTEGER		SIZE
	INTEGER*4	NAMTAB(*)
C
C workspace
	INTEGER		NCMD,CMD,CLEN
C
C free command descriptors (REMCMD takes rather a long time,
C so do it ourselves)
	NCMD = NAMTAB(1).AND.'7FFF'X
	DO 9001 CMD=1,NCMD
	   CLEN = NAMTAB(1+CMD*2).AND.'FFFF'X
	   CALL LIB$FREE_VM(CLEN,NAMTAB(2+CMD*2))
9001	CONTINUE
	CALL LIB$FREE_VM((SIZE*2+2)*4,%LOC(NAMTAB))
	RETURN
	END
