C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-02-19 15:59:50.000000000 +0000
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
	LOGICAL FUNCTION GET_TXT
C
CDEC$	IDENT	'19FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	13-Dec-1990
C
C Description:
C
C	Function GET_TXT called from PROCESS in ARC2I
C	It gets the text features from the TXT section in the EXPORT file
C	If a .TXT table exists in the IFO section it is ignored.
C
C The (loaded) TXT entry looks like:
C
C       lev     pts     arrows  sym     strlen
C	x1	x2	x3	x4	y1
C	y2	y3	y4	ax1	ax2
C	ax3	ay1	ay2	ay3	ht
C	textgap
C	text
C
C where: lev,pts,arrows,sym,strlen are integers
C
C and:	x1-x3,y1-y3 are the points on the curve which text follows
C	ax1-ax3,ay1-ay3 are arrow annotation points and are ignored
C	ht	is the text height
C	textgap	is the gap between characters
C	text	is the text string of length, strlen
C
C If, however, the file contains double precision reals, the format looks like:
C
C	x1	x2	x3
C       x4	y1	y2
C	y3	y4	ax1
C	ax2	ax3	ay1
C	ay2	ay3	ht
C	textgap
C	text
C
C------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:EXCEPTION.CMN'	! LSLLIB exceptions
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:EXTENSIONS.CMN'		! Search strings
	INCLUDE	'HERE:IFFINFO.CMN'		! IFF information
	INCLUDE	'HERE:GENERAL.CMN'		! General information
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
	INTEGER*4	TXTSTATUS(5)		! Info about text !2
	REAL		DUMMY			! Dummy value
	REAL		X(2)			! X coord read from EXPORT file
	REAL		Y(2)			! Y coord read from EXPORT file
	REAL		TXTROT			! Calculated text rotation
	REAL		TXTHT			! Text height
	CHARACTER*80	EXPLINE			! Line from EXPORT file
	CHARACTER*80	MSG			! Message string for PUTMSG
	INTEGER*4	MSGLEN			! Message length
	INTEGER*4	TLEVEL			! Text level !2
	INTEGER*4	TPTS			! Number pts in text arc !2
	INTEGER*4	TARROW			! Number of arrow pts !2
	INTEGER*4	TSYM			! Text symbol number !2
	INTEGER*4	TLEN			! Text string length !2
	CHARACTER*321	TSTR			! The text string
	BYTE		BSTR(321)		! The text string as byte array
	INTEGER*4	POSN			! Character count !2
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
C
C------------------------------------------------------------------------------
C
C Find TXT section in EXPORT file
C
10	STATUS = GET_EXP_LINE(.TRUE.)			! Disable message on EOF
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	IND = INDEX(EXPLINE(1:3),'TXT')
	IF (IND.LE.0) GOTO 10
C
	IF (HAD_LOG) CALL WRITEF('Reading text from TXT section of EXPORT file.')
C
C Read text entry
C
200	CONTINUE
C
C Setup a message string to pass to PUTMSG, in case an error occurs, giving the
C location within the EXPORT file that it happened
C
	MSGLEN = 30
	MSG(1:MSGLEN) = 'TXT section of the EXPORT file'
C
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	DO 201 I = 1,5
	   CALL SETWIN(I*10-9,10)	   
	   NODIG = RDLONG(TXTSTATUS(I))
	   IF (NODIG) GOTO 8000
201	CONTINUE
C
	IF (TXTSTATUS(1).EQ.-1) GOTO 9000		! all points read
C
	TLEVEL = TXTSTATUS(1)			! give more meaningful names
	TPTS   = TXTSTATUS(2)			! to status info
	TARROW = TXTSTATUS(3)
	TSYM   = TXTSTATUS(4)
	TLEN    = TXTSTATUS(5)
C
	STATUS = GET_EXP_LINE()			! Get 1st line (x1,x2, . . .)
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	CALL SETWIN(1,80)
C
	NODIG = RDREAL(X(1))
	IF (NODIG) GOTO 8000
C
	NODIG = RDREAL(X(2))
	IF (NODIG) GOTO 8000
C
	IF (WIDEREALS) THEN
C
	   STATUS = GET_EXP_LINE()		! Get 2nd line (x4,y1,y2)
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	   CALL SETWIN(1,80)
C
	   NODIG = RDREAL(DUMMY)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(Y(1))
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(Y(2))
	   IF (NODIG) GOTO 8000
C
	   STATUS = GET_EXP_LINE()		! Ignore 3rd line
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	   STATUS = GET_EXP_LINE()		! Ignore 4th line
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	   STATUS = GET_EXP_LINE()		! Get 5th line ( , ,ht)
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	   CALL SETWIN(1,80)
C
	ELSE
C
	   NODIG = RDREAL(DUMMY)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(DUMMY)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(Y(1))
	   IF (NODIG) GOTO 8000
C
	   STATUS = GET_EXP_LINE()		! Get 2nd line (y2, , , , )
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	   CALL SETWIN(1,80)
C
	   NODIG = RDREAL(Y(2))
	   IF (NODIG) GOTO 8000
	   STATUS = GET_EXP_LINE()		! Get 3rd line ( , , , ,ht)
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	   CALL SETWIN(1,80)
C
	   NODIG = RDREAL(DUMMY)
	   IF (NODIG) GOTO 8000
C
	   NODIG = RDREAL(DUMMY)
	   IF (NODIG) GOTO 8000
C
	ENDIF
C
	NODIG = RDREAL(DUMMY)
	IF (NODIG) GOTO 8000
C
	NODIG = RDREAL(DUMMY)
	IF (NODIG) GOTO 8000
C
	NODIG = RDREAL(TXTHT)
	IF (NODIG) GOTO 8000
C
	STATUS = GET_EXP_LINE()			! Get last line (with text gap)
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
C Text could be upto 320 characters. May need to read up to 4 lines
C
	CALL SETWIN(1,80)
	POSN = 1
	DO 400 I = 1,(TLEN / 81)+1
	   STATUS = GET_EXP_LINE()		! Get line containing text
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	   TSTR(POSN:POSN+TXTPTR ) = EXPLINE(1:TXTPTR)
	   POSN = POSN + TXTPTR
400	CONTINUE
C
C Create new feature
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
	CALL IFFNF(INF,INF)
C
C Obtain FC, using LEVEL and SYMBOL
C
	CALL TEXT_FCODE(FC,TLEVEL,TSYM)
	ISTAT(1) = FC
	ISTAT(2) = 0
	ISTAT(3) = '8000'X		! set bits 14,15 to 2 for text feature
	ISTAT(4) = 0
	CALL IFFFS(ISTAT)	
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
	CALL IFFTH(INT(TXTHT))
C
	STBUF(1,1) = X(1)
	STBUF(2,1) = Y(1)
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
	XDIFF = X(1) - X(2)
	YDIFF = Y(1) - Y(2)
	IF (XDIFF.EQ.0) THEN
	   IF (YDIFF.LT.0) THEN
	      ANG = 90
	   ELSE
	      ANG = 270
	   ENDIF
	   GOTO 500
	ENDIF
	ANG = ATAND(YDIFF/XDIFF)
	IF (XDIFF.GE.0) THEN
	   ANG=ANG+180
	ELSEIF (XDIFF.LT.0.AND.YDIFF.GT.0) THEN
	   ANG=ANG+360
	ENDIF
C
500	CALL IFFRO(ANG/57.29578)	! convert to radians
	CALL IFFTX(BSTR,TLEN)
	CALL IFFEF
C
C Give a warning message if there are more than 2 points which says that they
C are being ignored.
C
	IF (TPTS.GT.2) CALL LSL_PUTMSG( ARC2I__TXTPTS )
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
9000	GET_TXT = STATUS
C
	RETURN
	END
