C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-03-04 12:42:24.000000000 +0000
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
	LOGICAL FUNCTION GET_TXTSIX
C
CDEC$	IDENT	'04MR93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created	from GET_TXT				ST	17-Feb-1993
C
C Description:
C
C	Function GET_TXTSIX called from PROCESS in ARC2I
C	It gets the VERSION 6.0 text features from the TX6 section in the
C	EXPORT file. If a .TAT table exists in the IFO section it is ignored.
C
C A TX6 entry looks like:
C
C       id?     level     ncrds1 + ncrds2   symbol   no.comps no.chars
C	int      int      int      int      int      int      int
C	int      int      int      int      int      int      int
C	int      int      int      int      int      int
C       comp-pt  comp-pt  comp-pt  int      int      int      int
C	int      int      int      int      int      int      int
C	int      int      int      int      int      int
C       real
C       ht(real) real     real
C       pt       pt
C       ..       ..
C       ..       ..
C       pt       pt
C       text
C
C where: the first line are all integers
C        no.comps defines how many components there are in banked text and
C        the comp-pts identify the start point of each component.
C	 ht is the text height
C	 text is the text string of length, no.chars
C
C        ints and reals are unknown fields.
C
C------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'	! For READSTR parameters
	INCLUDE	'ARC2IMSG.PAR'			! ARC2I messages
	INCLUDE 'LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:EXCEPTION.CMN'	! LSLLIB exceptions
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'FILES.CMN'			! ARC2I filenames
	INCLUDE	'COMMANDS.CMN'			! Command line results
	INCLUDE	'EXTENSIONS.CMN'		! Search strings
	INCLUDE	'IFFINFO.CMN'			! IFF information
	INCLUDE	'GENERAL.CMN'			! General information
C
C Functions
C
	INTEGER*4	GET_EXP_LINE		! Read a line from EXPORT file
	LOGICAL		REWIND_FILE		! Rewind a file
	LOGICAL		RDLONG			! Read long integer
	LOGICAL		RDREAL			! Read real
	INTEGER*4	READSTR			! Read a string
C
C Local Variables
C
	INTEGER*4	OK			! Success/failure of calls
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	I,J,K			! Loop counters and general
	INTEGER*4	IND			! Index position
	INTEGER*4	RETVAL			! Return error value of READSTR
	INTEGER*4	STRLEN			! String length of READSTR
	LOGICAL		NODIG			! Reading digit status
	LOGICAL		MINUSONE		! Did we have -1 line
	LOGICAL		OUT_MESS		! To output a message
	INTEGER*4	TXTSTATUS(7)		! Info about text
	REAL		DUMMY			! Dummy value
	REAL		XY(2,200)		! Coords of spline or point
	REAL		TXTROT			! Calculated text rotation
	REAL		TXTHT			! Text height
	CHARACTER*80	EXPLINE			! Line from EXPORT file
	CHARACTER*80	MSG			! Message string for PUTMSG
	CHARACTER*80	CLASS			! Annotation sub-class
	INTEGER*4	CLASSLEN		! Annotation sub-class length
	INTEGER*4	MSGLEN			! Message length
	INTEGER*4	END_PT			! Point to calculate angle from
	INTEGER*4	TLEV			! Text level
	INTEGER*4	TEMP			! Temporary counter
	INTEGER*4	TPTS			! Number pts in text arc
	INTEGER*4	TNCOMP			! Number of text components
	INTEGER*4	TCOMP(20)		! Start pts of text components
	INTEGER*4	TSYM			! Text symbol number
	INTEGER*4	TLEN			! Text string length
	INTEGER*4	NUMCOMP			! Actual num of text components
	INTEGER*4	COMPLEN			! Text component length
	CHARACTER*321	TXTCOMP			! The text string components
	BYTE		BCOMP(321)		! The text comp as byte array
	CHARACTER*321	TSTR			! The text string
	BYTE		BSTR(321)		! The text string as byte array
	INTEGER*4	POSN			! Character count
C IFF stuff
	INTEGER*2	FC			! Feature code
	INTEGER*2	ISQ			! Feature number
	INTEGER*2	ISTAT(4)		! Feature Status
	INTEGER*2	ITHK			! Line thickness
	INTEGER*2	IENDS			! Line status
	REAL		STBUF(2,1)		! STring array
	REAL		XDIFF,YDIFF,ANG		! Rotation calculations
C
	EQUIVALENCE(TXTBUF(1),EXPLINE)
	EQUIVALENCE(BSTR,TSTR)
	EQUIVALENCE(BCOMP,TXTCOMP)
C
C------------------------------------------------------------------------------
C
	OUT_MESS = .FALSE.
	MINUSONE = .FALSE.
	ISTAT(2) = 0
	ISTAT(3) = '8000'X	! set bits 14,15 to 2 for text feature
	ISTAT(4) = 0
C
C Find TXT section in EXPORT file
C
10	STATUS = GET_EXP_LINE(.TRUE.)		       ! Disable message on EOF
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	IND = INDEX(EXPLINE(1:3),'TX6')
	IF (IND.LE.0) GOTO 10
C
	IF (HAD_LOG) CALL WRITEF('Reading v6.0 text from TX6 section of EXPORT file.')
C
C Since we don't know if a TX6 section containing no text looks like:
C
C TX6  2
C         -1         0         0         0         0         0         0
C or like:
C
C TX6  2
C <null-class-name>
C         -1         0         0         0         0         0         0
C
C we should test for both.
C
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	CALL SETWIN(1,10)
	NODIG = RDLONG(TXTSTATUS(1))
	IF (NODIG) THEN
	   GOTO 110				! not -1 so read the sub-class
	ELSE
	   IF (TXTSTATUS(1).EQ.-1) GOTO 215     ! exit neatly
	ENDIF
C
C Get the annotation sub-class
C
100	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
110	CALL SETAUX(%REF(EXPLINE),80)
	CLASSLEN = READSTR(CLASS)
	IF (CLASSLEN.LE.0) THEN
	   CLASSLEN = 9
	   CLASS(1:CLASSLEN) = '<NO NAME>'
	ENDIF
	OUT_MESS = .TRUE.
	CALL BSLN
C
C Read text entry
C
200	CONTINUE
C
C Setup a message string to pass to PUTMSG, in case an error occurs, giving the
C location within the EXPORT file that it happened
C
	MSGLEN = 30
	MSG(1:MSGLEN) = 'TX6 section of the EXPORT file'
C
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	DO 210 I = 1,7
	   CALL SETWIN(I*10-9,10)
	   NODIG = RDLONG(TXTSTATUS(I))
	   IF (MINUSONE .AND. NODIG) GOTO 9000
	   IF (NODIG) GOTO 8000
210	CONTINUE
	IF (MINUSONE) MINUSONE = .FALSE.
C
215	IF (TXTSTATUS(1).EQ.-1) THEN
	   MINUSONE = .TRUE.
	   GOTO 100				! all points in class read
	ENDIF
	IF (HAD_LOG .AND. OUT_MESS) THEN
	   CALL WRITEF('...reading text annotation class %S',CLASS(1:CLASSLEN))
	   OUT_MESS = .FALSE.
	ENDIF
C
	TLEV   = TXTSTATUS(2)			! give more meaningful names
	TPTS   = TXTSTATUS(3)+TXTSTATUS(4)	! to status info
	TSYM   = TXTSTATUS(5)
	TNCOMP = TXTSTATUS(6)
	TLEN   = TXTSTATUS(7)
C
C Ignore 20 integers on next 3 lines.
C
	DO 220 I = 1,3
	   STATUS = GET_EXP_LINE()
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
220	CONTINUE
C
C Get start points for text components
C
	TEMP = 7
	DO 240 I = 1,3
	   STATUS = GET_EXP_LINE()
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	   IF (I.EQ.3) TEMP = 6
	   DO 230 J = 1,TEMP
	      CALL SETWIN(J*10-9,10)
	      K = (I-1)*7+J
	      NODIG = RDLONG(TCOMP(K))
	      IF (NODIG) GOTO 8000
	      TCOMP(K) = MAX(1,TCOMP(K))		! don't allow 0's
230	   CONTINUE
240	CONTINUE
C
	IF (TNCOMP.EQ.0) TNCOMP = 1
	TCOMP(MIN(20,TNCOMP+1)) = TPTS
C
	CALL SETWIN(1,80)
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
C Text height
C
	NODIG = RDREAL(TXTHT)
	IF (NODIG) GOTO 8000
C
C Read all points 
C
	DO 250 I = 1,TPTS
	   STATUS = GET_EXP_LINE()
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	   CALL SETWIN(1,80)
	   NODIG = RDREAL(XY(1,I))
	   IF (NODIG) GOTO 8000
	   NODIG = RDREAL(XY(2,I))
	   IF (NODIG) GOTO 8000
250	CONTINUE
C
C Text could be upto 320 characters. May need to read up to 4 lines
C
	CALL SETWIN(1,80)
	POSN = 1
	DO 300 I = 1,(TLEN / 81)+1
	   STATUS = GET_EXP_LINE()		! Get line containing text
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	   IF (TLEN.EQ.0) GOTO 200
	   TSTR(POSN:POSN+TXTPTR ) = EXPLINE(1:TXTPTR)
	   POSN = POSN + TXTPTR
300	CONTINUE
C
C Obtain FC
C
	CALL TEXT_FCODE(FC,TLEV,TSYM)
	ISTAT(1) = FC
C
C Adjust text height to 1/100ths mm on sheet
C
C TXTHT/SCALE	= metres on sheet
C x 1000	= mm on sheet
C x 100		= 1/100 mm on sheet
C
	IF ( HAD_SCALE .AND. SCALE.GT.0.0 ) THEN
	   TXTHT = TXTHT / SCALE * 1000 * 100
	ENDIF
C
C Count how many components there really are. Because BARTs data lies.
C
	IF (TNCOMP.GT.1) THEN
	   NUMCOMP = 0
	   CALL SETAUX(BSTR,TLEN)
350	   COMPLEN = READSTR(TXTCOMP,0,ON_SPACE,.TRUE.,)
	   IF (COMPLEN.GT.0) THEN
	      NUMCOMP = NUMCOMP + 1
	      GOTO 350
	   ENDIF
	   IF (NUMCOMP.GT.0) TNCOMP = NUMCOMP
	ENDIF
C
C Create new feature
C
	CALL IFFNF(INF,INF)
C
	CALL SETAUX(BSTR,TLEN)
	DO 400 I = 1,TNCOMP
C
C Read text component string
C
	   IF (TNCOMP.EQ.1) THEN
	      TXTCOMP(1:TLEN) = EXPLINE(1:TLEN)
	      COMPLEN = TLEN
	   ELSE
	      COMPLEN = READSTR(TXTCOMP,0,ON_SPACE,.TRUE.,)
	   ENDIF
	   IF (COMPLEN.LE.0) GOTO 410	! get next text feature
C
	   TOTFEAT = TOTFEAT + 1
	   INF4 = INF4 + 1
C
C Check for overflow before it happens. INF is INT*2 and INF4 is INT*4. So
C we check INT4 does not exceed what INF can hold before assigning it.
C Feature code starts from 1 again. This does produce duplicate FSNs.
C
	   IF (INF4.GT.32767) THEN
	      CALL LSL_PUTMSG( ARC2I__MAXFSN )
	      INF4 = 1
	   ENDIF
	   INF = INF4
C
C Order for component text entries is:
C NF FS   TS TH ST RO TX   TS TH ST RO TX  etc EF
C
	   IF (I.EQ.1) CALL IFFFS(ISTAT)
	   IF (TNCOMP.GT.1) CALL IFFTS(ISTAT)	
C
	   CALL IFFTH(INT(TXTHT))
C
	   STBUF(1,1) = XY(1,TCOMP(I))
	   STBUF(2,1) = XY(2,TCOMP(I))
	   CALL CHECK_RANGE(STBUF(1,1),STBUF(2,1))
	   CALL IFFST(STBUF,1,IENDS)
C
C If we have only one point for annotation, the rotation is zero 
C
	   IF (TPTS.EQ.1) THEN
	      ANG = 0.0
	      GOTO 500
	   ENDIF
C
C any more points and we use the first two points for the angle.
C This is temporary and will only apply when two points are given. If 3 or 4
C points are given then the annotation will be broken up along the spline
C formed by the points
C
	   END_PT = TCOMP(MIN(20,I+1))
	   IF (I.LT.TNCOMP) END_PT = END_PT - 1
	   END_PT = MAX(1,END_PT)
	   XDIFF = XY(1,TCOMP(I)) - XY(1,END_PT)
	   YDIFF = XY(2,TCOMP(I)) - XY(2,END_PT)
	   IF (XDIFF.EQ.0) THEN
	      IF (YDIFF.LT.0) THEN
		 ANG = 90.0
	      ELSEIF (YDIFF.GT.0) THEN
		 ANG = 270.0
	      ELSE
		 ANG = 0.0
	      ENDIF
	      GOTO 500
	   ENDIF
	   ANG = ATAND(YDIFF/XDIFF)
	   IF (XDIFF.GE.0) THEN
	      ANG=ANG+180.0
	   ELSEIF (XDIFF.LT.0.AND.YDIFF.GT.0) THEN
	      ANG=ANG+360.0
	   ENDIF
C
500	   CALL IFFRO(ANG/57.29578) ! convert to radians
	   CALL IFFTX(BCOMP,COMPLEN)
400	CONTINUE
410	CALL IFFEF
	CALL BSLN
C
C Get next point feature
C
	GOTO 200
C
8000	STATUS = ARC2I__ERRRDNUM
	CALL LSL_PUTMSG( STATUS,MSG(1:MSGLEN) )
	CALL LSL_ADDMSG( ERRNUM )             ! LSLLIB exception
	IF ( ERRNUM.EQ.LSL__HADEXCP ) CALL LSL_ADDMSG( LSL_EXCP )
C
9000	GET_TXTSIX = STATUS
	CALL BSLN
C
	RETURN
	END
