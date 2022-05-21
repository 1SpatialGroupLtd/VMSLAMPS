C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-01-20 17:38:54.000000000 +0000
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
	LOGICAL FUNCTION GET_ARCS
C
CDEC$	IDENT	'20JA94'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Dec-1990
CMOD	Routine now sets field width of 2 byte		ST	20-Jan-1994
C	integers (type 5) to be 6. Mod 1334.
C
C Description:
C
C	Function GET_ARCS called from PROCESS in ARC2I
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
	include 'lsl$cmniff:iffhan.cmn'
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
	INCLUDE	'HERE:TABLES.CMN'		! Parameter file tables
	INCLUDE	'HERE:ATTRDATA.CMN'		! EXPORT attribute data
	INCLUDE	'HERE:GENERAL.CMN'		! General information
C
C Functions
C
	INTEGER*4	GET_EXP_LINE		! Read a line from EXPORT file
	INTEGER*4	GET_TMP_LINE		! Read a line from TMP file
	LOGICAL		GET_ACS			! Read attributes
	LOGICAL		REWIND_FILE		! Rewind file
	LOGICAL		RDLONG			! Read long integer
	LOGICAL		RDREAL			! Read real
	INTEGER*4	READSTR			! Read a string
C
C Local Variables
C
	INTEGER*4	OK			! Success/failure of calls
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	ERROR			! System error status
	INTEGER*4	I,J,K,AATLOOP		! Loop counters and general
	INTEGER*4	IND			! Index position
	INTEGER*4	NUM_ARCS		! Number of entries in .AAT
	INTEGER*4	RETVAL			! Return error value of READSTR
	INTEGER*4	STRLEN			! String length of READSTR
	LOGICAL		NODIG			! Reading digit status
	LOGICAL		ODDPTS			! An odd number of pts in line
	INTEGER*4	TOTAL			! Total points per feature
	INTEGER*4	NLINES			! Number of coord lines
	INTEGER*4	NPTS			! Cumulative number of points
	INTEGER*4	F			! Offset factor for STBUF
	INTEGER*4	P1,P2			! Resultant indices for STBUF
	INTEGER*4	LINEINFO(7)		! Line information !2
	CHARACTER*80	EXPLINE			! Line from EXPORT file
	CHARACTER*80	TMPLINE			! Line from TMP file
	CHARACTER*80	MSG			! Message string for PUTMSG
	INTEGER*4	MSGLEN			! Message length
	INTEGER*4	ARCNUM			! Number of arcs read !2
	INTEGER*4	ARCID			! Arc ID from ARC section !2
	INTEGER*4	PREVARCID		! Previous ARCID !2
	INTEGER*4	AATID			! Arc ID from .AAT !2
	INTEGER*4	PREVAATID		! Previous AATID !2
	INTEGER*4	IDDIFF			! Differnce between IDs !2
	INTEGER*4	START_POS		! Temp start pos of attribute
	LOGICAL 	WRITE_FEAT		! Do we write the feature
C IFF stuff
	INTEGER*2	ISQ			! Feature number
	INTEGER*2	ISTAT(4)		! Feature Status
	INTEGER*2	ITHK			! Line thickness
	INTEGER*2	IENDS			! Line status
	REAL		STBUF(2,200)		! STring array
C
	EQUIVALENCE(TXTBUF(1),EXPLINE,TMPLINE)
C
C-------------------------------------------------------------------------------
C
C Find ARC section in EXPORT file
C
10	STATUS = GET_EXP_LINE(.TRUE.)			! disable message on EOF
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	IND = INDEX(EXPLINE(1:3),'ARC')
	IF (IND.LE.0) GOTO 10
C
C Find start of .AAT section in TMP file
C
20	STATUS = GET_TMP_LINE(.TRUE.)		! disable EOF message
	IF ( .NOT.STATUS ) THEN
	   IF ( STATUS.EQ.LSL__EOF) THEN
C
C EOF doesn't mean failure, but that there was no .AAT section. A missing .AAT
C is permitted only if there are no arcs in the ARC section.
C
	      STATUS = LSL__NORMAL
C
C we must rewind the temporary file so that GET_PTS can find the .PAT
C
	      STATUS = REWIND_FILE( TMPLUN )
	      IF ( .NOT.STATUS ) GOTO 9000
C
C Process ARC section with no .AAT
C
	      IF (HAD_LOG) CALL WRITEF('Reading arcs from ARC section of EXPORT file.')
	      NUM_ATT = 0
	      GOTO 200
	   ENDIF
	   GOTO 9000
	ENDIF
	IND = INDEX(TMPLINE(1:32),AAT(1:4))
	IF (IND.LE.0) GOTO 20
C
	IF (HAD_LOG) CALL WRITEF('Reading arcs from ARC section of EXPORT file.')
C
C Set up a message string for PUTMSG, in case an error occurs, giving the
C the position within the EXPORT file where it happened.
C
	MSGLEN = 25
	MSG(1:MSGLEN) = '.AAT table in IFO section'
C
C Extract number of arcs held in .AAT table
C
	CALL SETWIN(51,)
	NODIG = RDLONG( NUM_ARCS )
	IF (NODIG) GOTO 8000
C
C Extract number of normal attributes (ie not redefined ones)
C
	CALL SETWIN(35,4)
	NODIG = RDLONG( NUM_ATT_NOT_REDEFINED )
	IF (NODIG) GOTO 8000
	NUM_ATT_NOT_REDEFINED = NUM_ATT_NOT_REDEFINED - 7
C
C Extract total number of attributes in table (including redefined ones)
C
	CALL SETWIN(39,4)
	NODIG = RDLONG( NUM_ATT )
	IF (NODIG) GOTO 8000
	NUM_ATT	= NUM_ATT - 7
C
C Check no info default attributes were missing
C
	IF (NUM_ATT_NOT_REDEFINED.LT.0 .OR. NUM_ATT.LT.0) THEN
	   STATUS = ARC2I__MISSINGINFO
	   CALL LSL_PUTMSG( STATUS,'.AAT' )
	   GOTO 9000
	ENDIF
C
C Skip first set of 7 line attributes (these are fixed)
C
	DO 50 I = 1,7
	   STATUS = GET_TMP_LINE()
	   IF ( .NOT.STATUS ) GOTO 9000
50	CONTINUE
C
	IF (NUM_ATT.EQ.0) GOTO 200 		! No additional attributes
C
C Read additional attributes
C
	DO 100 I = 1,NUM_ATT
	   STATUS = GET_TMP_LINE()
	   IF ( .NOT.STATUS ) GOTO 9000
C
C Get item type
C
	   CALL SETWIN(35,2)
	   NODIG = RDLONG(ATT_TYPE(I))
	   IF (NODIG) GOTO 8000
C
C Attribute field widths are:
C
C  datatype          field width
C     1                   8             date
C     2                   n             n is taken from .AAT
C     3                   n             n is taken from .AAT
C     4                  14 (or 24)     4 byte floating point (or 8 byte)
C     5                  11 (or 6)      4 byte integer (or 2 byte)
C     6                  14 (or 24)     4 byte floating point (or 8 byte)
C
C
	   CALL SETWIN(17,3)
C
C Get field width
C
	   NODIG = RDLONG(ATT_WIDTH(I))
	   IF (NODIG) GOTO 8000
C
C Adjust to true width
C
	   IF ( ATT_TYPE(I).EQ.2 .OR. ATT_TYPE(I).EQ.3 ) THEN
C
C Value already in ATT_WIDTH(I)
C
	   ELSEIF ( ATT_TYPE(I).EQ.4 ) THEN
	      ATT_WIDTH(I) = 14
	   ELSEIF ( ATT_TYPE(I).EQ.6 ) THEN
	      IF ( ATT_WIDTH(I).EQ.8 ) THEN
	         ATT_WIDTH(I) = 24
	      ELSE
	         ATT_WIDTH(I) = 14
	      ENDIF
	   ELSEIF ( ATT_TYPE(I).EQ.1 ) THEN
	      ATT_WIDTH(I) = 8
	   ELSEIF ( ATT_TYPE(I).EQ.5 ) THEN
	      IF ( ATT_WIDTH(I).EQ.4 ) THEN
	         ATT_WIDTH(I) = 11		! upto "-2147483647"
	      ELSE
	         ATT_WIDTH(I) = 6		! upto "-32767"
	      ENDIF
	   ENDIF
C
C Get attribute name
C
	   CALL SETWIN(1,16)
	   STRLEN = READSTR(ATT_NAME(I),,,,RETVAL)
	   IF (STRLEN.EQ.0) THEN
	      STATUS = ARC2I__ERRRDSTR
	      CALL LSL_PUTMSG( STATUS,MSG(1:MSGLEN) )
	      CALL LSL_ADDMSG( RETVAL )
	      GOTO 9000
	   ENDIF
C
C Get attribute start position
C
	   CALL SETWIN(23,3)
	   NODIG = RDLONG(ATT_STARTPOS(I))
	   IF (NODIG) GOTO 8000
C
100	CONTINUE
C
C
C Adjust start position if the field width was altered above
C
	DO 101 I = 2,NUM_ATT_NOT_REDEFINED
	   IF (ATT_STARTPOS(I)-ATT_WIDTH(I-1).NE.ATT_STARTPOS(I-1)) THEN
	      ATT_STARTPOS(I) = ATT_STARTPOS(I-1) + ATT_WIDTH(I-1)
	   ENDIF
101	CONTINUE
C
C
C Set up a message string for PUTMSG, in case an error occurs, giving the
C the position within the EXPORT file where it happened.
C
200	MSGLEN = 26
	MSG(1:MSGLEN) = 'ARC section of EXPORT file'
C
C Initialise number of times we've read from the .AAT table - so we dont overrun
C
	ARCNUM = 0
	ARCID = -1
	AATID = -1
C
C Start reading arcs from EXP ARC section and attributes from TMP .AAT section
C
300	PREVARCID = ARCID
	WRITE_FEAT = .TRUE.
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	DO 301 I = 1,7
	   CALL SETWIN(I*10-9,10)
	   NODIG = RDLONG(LINEINFO(I))
	   IF (NODIG) GOTO 8000
301	CONTINUE
C
C Save Internal-ID
C
	IF (ARC_ID.EQ.INTERNAL_ID) THEN
	   ARCID = LINEINFO(1)
	ELSEIF (ARC_ID.EQ.USER_ID) THEN
	   ARCID = LINEINFO(2)
	ENDIF
C
	IF (LINEINFO(1).EQ.-1) GOTO 9000		! all arcs read
C
C Internal ARC ID should be unique. If it is not, read it but dont write feature.
C
	IF (ARCNUM.GT.0) THEN     ! not the first time
	   IF (ARCID.EQ.PREVARCID) THEN
	      IF (HAD_VERBOSE) THEN
	      CALL WRITEF('Internal AAT ID %N not unique.',ARCID)
CCC	      CALL WRITEF('Internal AAT ID %N not unique. Occurance ignored',ARCID)
	      ENDIF
	      WRITE_FEAT = .FALSE.
	   ENDIF
C
C If there is a problem and we want a description, give it
C
	   IF (HAD_VERBOSE) THEN
	      IDDIFF = ARCID - PREVARCID
	      IF (IDDIFF.LT.0) THEN
		 CALL WRITEF('Internal AAT ID %N not in ascending order',ARCID)
	      ELSEIF(IDDIFF.GE.2) THEN
		 CALL WRITEF('Internal AAT ID %N missing or out of sequence',PREVARCID+1)
	      ENDIF
	   ENDIF
	ENDIF
C
C Do not output any BARTS features with FC of 0
C
	IF (HAD_ID_TO_FC .AND. LINEINFO(2).EQ.0) THEN
	   WRITE_FEAT = .FALSE.
	ENDIF
C
C Update the range info (but only if points will appear in output file)
C
CCC What the hell is his doing here?
CCC
CCC	IF (WRITE_FEAT) CALL CHECK_RANGE(STBUF(1,1),STBUF(2,1))
CCC
C
C Create new feature
C
	IF (WRITE_FEAT) THEN
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
	   IF (HAD_ID_TO_FC) THEN
C
C BARTS FC is held in internal ID field
C
C BARTS ID of 0 is thrown away
C BARTS IDs <32768 require no change
C BARTS IDs 32768-139000 require removal of first 3 digits
C BARTS IDs >139000 require removal of first 2 digits
C
C Note: ISTAT(1) should not exceed 32767
C
	      IF (LINEINFO(2).LT.32768) THEN
		 ISTAT(1) = LINEINFO(2)
	      ELSEIF (LINEINFO(2).GE.32768 .AND. LINEINFO(2).LE.139000) THEN
		 ISTAT(1) = LINEINFO(2) - ((LINEINFO(2)/1000)*1000)
	      ELSEIF (LINEINFO(2).GT.139000) THEN
		 ISTAT(1) = LINEINFO(2) - ((LINEINFO(2)/10000)*10000)
	      ENDIF
	   ELSE
	      ISTAT(1) = LINE_FC
	   ENDIF
	   ISTAT(2) = 0
	   ISTAT(3) = 0
	   ISTAT(4) = 0
	   CALL IFFFS(ISTAT)	
	ENDIF
C
350	IF ( HAD_ARCATT .AND. NUM_ATT.GT.0 ) THEN
C
C Extract any attributes from .AAT table in TMP file
C
	   IF ( ARCNUM.LT.NUM_ARCS ) THEN
	      PREVAATID = AATID
	      STATUS = GET_ACS(1,ARCID,AATID,WRITE_FEAT) ! 1 denotes .AAT table
	      IF ( .NOT.STATUS ) GOTO 9000
C
C Here's a temporary bodge to always write the feature even if we couldn't
C get attributes for it. More important to keep the feature than to throw it
C away because the attribute extraction failed.
C
	      WRITE_FEAT = .TRUE.
C
	      ARCNUM = ARCNUM + 1
C
C Internal .AAT ID should be unique. If it is not get next AAT entry.
C
	      IF (ARCNUM.GT.1) THEN     ! not the first time
	         IF (AATID.EQ.PREVAATID) THEN
	            IF (HAD_VERBOSE) THEN
	               CALL WRITEF('Internal AAT ID %N not unique. Occurance ignored',AATID)
		    ENDIF
	            GOTO 350
	         ENDIF
C
C If there is a problem and we want a description, give it
C
	         IF (HAD_VERBOSE) THEN
		    IDDIFF = AATID - PREVAATID
	            IF (IDDIFF.LT.0) THEN
		       CALL WRITEF('Internal AAT ID %N not in ascending order',AATID)
	            ELSEIF(IDDIFF.GE.2) THEN
		       CALL WRITEF('Internal AAT ID %N missing or out of sequence',PREVAATID+1)
	            ENDIF
	         ENDIF
	      ENDIF
C
	      IF (AATID.EQ.0 .OR.
     &	          AATID.LT.ARCID) GOTO 350         ! get next set of attributes
C
	     IF (ARCID.NE.AATID) THEN
	         CALL LSL_PUTMSG( ARC2I__NOARCATT,ARCID )    ! give warning
	      ELSE
	         IF (HAD_VERBOSE .AND. NUM_ATT.GT.0) CALL WRITEF('Arc with internal ID %N given attribute(s).',ARCID)
	      ENDIF
	   ELSE
C
C We have run out of attributes with more arcs to come
C
	      CALL LSL_PUTMSG( ARC2I__NOARCATT,ARCID ) ! give warning
	   ENDIF
C
	ENDIF
C
C Read points into ST entry...
C
	ITHK = 0
	IENDS = 0
	IF (WRITE_FEAT) CALL IFFTH(ITHK)
C
C With wide reals processing is simple because there is one point (x and y)
C per line.
C
	IF ( WIDEREALS ) THEN
	   P2 = 0
	   NLINES = LINEINFO(7)
C
	   DO 400 I = 1, NLINES
C
C get next line from ARC section
C
	      STATUS = GET_EXP_LINE()
	      IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C count it
	      P2 = P2 + 1
C
C set current buffer pointer
C
	      CALL SETWIN(1,80)
C get X
	      NODIG = RDREAL(STBUF(1,P2))
	      IF (NODIG) GOTO 8000
C get Y
	      NODIG = RDREAL(STBUF(2,P2))
	      IF (NODIG) GOTO 8000
C
C Update RAnge values
C
	      IF (WRITE_FEAT) CALL CHECK_RANGE(STBUF(1,P2),STBUF(2,P2))
C
C write out a full buffer of 200 points
C
	      IF (P2.EQ.200) THEN
	         IF (WRITE_FEAT) CALL IFFST(STBUF,P2,IENDS)
		 IENDS = 1
	         P2 = 0
	      ENDIF
400	   CONTINUE
C
C write ST entry ( or any left over from last full buffer of 200 points )
C
	   IF (P2.GT.0 .AND. WRITE_FEAT) CALL IFFST(STBUF,P2,IENDS)
	ELSE
C
C Read ARC section, with four 2 points (4 values) per line
C
	   TOTAL = LINEINFO(7)
	   NLINES = (LINEINFO(7)-1)/2
	   ODDPTS = .FALSE.
	   IF ( MOD(TOTAL,2).EQ.1 ) ODDPTS = .TRUE.
	   K = 4				! number of points on a line
	   NPTS = 0				! number of points read
C
	   DO 500 I = 0, NLINES
	      STATUS = GET_EXP_LINE()
	      IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
C If number of points is odd, k = 2 ie. the number of coords on the last line
C
	      IF (ODDPTS.AND.I.EQ.NLINES) K = 2
	      NPTS = NPTS + K / 2
C
C F is an offest factor taken outside J loop to speed up the operation.
C It resets the STBUF index to 0 when 100 lines (199 or 200 points) are read
C
	      F = MOD(I,100)*2
C
C Read 4 (or 2) coords off a line
C
	      DO 510 J = 1,K
C
C Set window in sequences of (1,14) (15,14) (29,14) (43,14) to read coords
C
	         CALL SETWIN(J*14-13,14)
C
C The points are put into STBUF as follows:
C EXPORT line:		x1	y1	x2	y2
C	STBUF:	      (1,1)   (2,1)   (1,2)   (2,2)
C		      (1,3)   (2,3)   (1,4)   (2,4)
C		      (1,5)   (2,5)   (1,6)   (2,6)
C		                  etc
C
	         P1 = 2-(MOD(J,2))
	         P2 = F+((J+1)/2)
	         NODIG = RDREAL(STBUF(P1,P2))
	         IF (NODIG) GOTO 8000
C
C These previous lines are complex, but make for a tight loop and nothing of
C significance can be taken outside.
C Debugging this would be a nightmare, so here is an explanation:
C
C The first index, 2-(MOD(J,2)) forces the first array index of STBUF to
C go in the sequence: 1,2,1,2,1,2,1,2,... as J progresses: 1,2,3,4,1,2,3,4,...
C
C The second index, (J+1)/2 forces the second array index of STBUF to go in the
C sequence 1,1,2,2,3,3,4,4,1,1... as J progresses 1,2,3,4,1,2,3,4,1,2,...
C Added onto this is F to offset the value and make it appear inside STBUF in
C the sequence: 1,1,2,2,3,3,4,4,5,5,6,6,7,7...upto a possible..200,200. This
C is in conjuction with the first index.
C
! for testing...
!	      call writef('N=%^L%I0 I=%^L%I0 K=%^L%I0 ST=%F',
!     &	2-(MOD(J,2)),I*2+((J+1)/2),K,STBUF(2-MOD(J,2),F+((J+1)/2)))
C
C Adjust RANGE if point lies outside
C
	         IF (MOD(J,2).EQ.0 .AND. WRITE_FEAT) CALL CHECK_RANGE(STBUF(1,P2),STBUF(2,P2))
C
510	      CONTINUE
C
C Write out a full ST entry.
C
	      IF (NPTS.EQ.200) THEN
	         IF (WRITE_FEAT) CALL IFFST(STBUF,NPTS,IENDS)
		 IENDS = 1
	         NPTS = 0
	      ENDIF
500	   CONTINUE
C
C Write the ST entry. But not if the total is a factor of 200 (in which case
C NPTS has been set to zero )
C
	   IF (NPTS.GT.0 .AND. WRITE_FEAT) CALL IFFST(STBUF,NPTS,IENDS)
	   ENDIF
	   IF (WRITE_FEAT) CALL IFFEF
C
C Get next line feature
C
	GOTO 300
C
8000	STATUS = ARC2I__ERRRDNUM
	CALL LSL_PUTMSG( STATUS,MSG(1:MSGLEN) )
	CALL LSL_ADDMSG( ERRNUM )             ! LSLLIB exception
	IF ( ERRNUM.EQ.LSL__HADEXCP ) CALL LSL_ADDMSG( LSL_EXCP )
C
9000	GET_ARCS = STATUS
C
	RETURN
	END
