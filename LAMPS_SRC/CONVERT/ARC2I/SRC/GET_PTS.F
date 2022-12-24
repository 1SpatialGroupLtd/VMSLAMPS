C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-01-20 16:38:52.000000000 +0000
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
	LOGICAL FUNCTION GET_PTS
C
CDEC$	IDENT	'20JA94'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	12-Dec-1990
CMOD	Routine now sets field width of 2 byte		ST	20-Jan-1994
C	integers (type 5) to be 6. Mod 1334.
C
C Description:
C
C	Function GET_PTS called from PROCESS in ARC2I
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
	INCLUDE	'HERE:TABLES.CMN'		! Parameter file tables
	INCLUDE	'HERE:ATTRDATA.CMN'		! EXPORT attribute info
	INCLUDE	'HERE:GENERAL.CMN'		! General information
C
C Functions
C
	INTEGER*4	GET_EXP_LINE		! Read a line from EXPORT file
	INTEGER*4	GET_TMP_LINE		! Read a line from TMP file
	LOGICAL		GET_ACS			! Read attributes
	LOGICAL		REWIND_FILE		! Rewind a file
	LOGICAL		RDLONG			! Read long integer
	LOGICAL		RDREAL			! Read real
	INTEGER*4	READSTR			! Read a string
C
C Local Variables
C
	INTEGER*4	OK			! Success/failure of calls
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	ERROR			! System error status
	INTEGER*4	I,J,K			! Loop counters and general
	INTEGER*4	IND			! Index position
	INTEGER*4	NUM_PTS			! Number of entries in .PAT
	INTEGER*4	RETVAL			! Return error value of READSTR
	INTEGER*4	STRLEN			! String length of READSTR
	LOGICAL		NODIG			! Reading digit status
	LOGICAL		WRITE_FEAT		! Whether to write feature
	CHARACTER*80	EXPLINE			! Line from EXPORT file
	CHARACTER*80	TMPLINE			! Line from TMP file
	CHARACTER*80	MSG			! Message string for PUTMSG
	INTEGER*4	MSGLEN			! Message length
	INTEGER*4	DUMMY			! Dummy value
	INTEGER*4	LABID			! Label point ID from LAB !2
	INTEGER*4	PREVLABID		! Previous LABID !2
	INTEGER*4	PATID			! Label point ID from .PAT !2
	INTEGER*4	PREVPATID		! Previous PATID !2
	INTEGER*4	IDDIFF			! Differnce between IDs !2
	INTEGER*4	START_POS		! Temp start pos of attribute
C IFF stuff
	INTEGER*2	ISQ			! Feature number
	INTEGER*2	ISTAT(4)		! Feature Status
	INTEGER*2	ITHK			! Line thickness
	INTEGER*2	IENDS			! Line status
	REAL		STBUF(2,1)		! STring array
C
	EQUIVALENCE(TXTBUF(1),EXPLINE,TMPLINE)
C
C-------------------------------------------------------------------------------
C
C Find beginning of LAB section in EXPORT file
C
10	STATUS = GET_EXP_LINE(.TRUE.)		! Disable message on EOF
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	IND = INDEX(EXPLINE(1:3),'LAB')
	IF (IND.LE.0) GOTO 10
C
C Find start of .PAT section in TMP file
C
20	STATUS = GET_TMP_LINE(.TRUE.)		! disable EOF message
	IF ( .NOT.STATUS ) THEN
	   IF ( STATUS.EQ.LSL__EOF ) THEN
C
C EOF doesn't mean failure, but that there was no .PAT section. A missing .PAT
C is permitted only if there are no points in the LAB section.
C
	      STATUS = LSL__NORMAL
C
C We should rewind the temporary file as we may have passed some needed tables
C
	      STATUS = REWIND_FILE( TMPLUN )
	      IF (.NOT.STATUS) GOTO 9000
C
C Process LAB section with no .PAT
C
	      IF (HAD_LOG) CALL WRITEF('Reading label points from LAB section of EXPORT file.')
	      NUM_ATT = 0
	      GOTO 200
	   ENDIF
	   GOTO 9000
	ENDIF
	IND = INDEX(TMPLINE(1:32),PAT(1:4))
	IF (IND.LE.0) GOTO 20
C
	IF (HAD_LOG) CALL WRITEF('Reading label points from LAB section of EXPORT file.')
C
C Set up message string to pass to PUTMSG, if an error occurs, giving the 
C section within the EXPORT file where the problem happened
C
	MSGLEN = 25
	MSG(1:MSGLEN) = '.PAT table in IFO section'
C
C Extract number of points held in .PAT table
C
	CALL SETWIN(51,)
	NODIG = RDLONG( NUM_PTS )
	IF (NODIG) GOTO 8000
	IF ( NUM_PTS.EQ.0 ) GOTO 9000		! no entries in .PAT
C
C Extract number of normal attributes (ie not redefined ones)
C
	CALL SETWIN(35,4)
	NODIG = RDLONG( NUM_ATT_NOT_REDEFINED )
	IF (NODIG) GOTO 8000
	NUM_ATT_NOT_REDEFINED = NUM_ATT_NOT_REDEFINED - 4
C
C Extract total number of attributes in table (including redefined ones)
C
	CALL SETWIN(39,4)
	NODIG = RDLONG( NUM_ATT )
	IF (NODIG) GOTO 8000
	NUM_ATT	= NUM_ATT - 4
C
C Check no info default attributes were missing
C
	IF (NUM_ATT_NOT_REDEFINED.LT.0 .OR. NUM_ATT.LT.0) THEN
	   STATUS = ARC2I__MISSINGINFO
	   CALL LSL_PUTMSG( STATUS,'.PAT' )
	   GOTO 9000
	ENDIF
C
C Skip first set of 4 points attributes (these are fixed)
C
	DO 50 I = 1,4
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
C     2                   n             n is taken from .PAT
C     3                   n             n is taken from .PAT
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
C Set up message string to pass to PUTMSG, if an error occurs, giving the
C section within the EXPORT file where the problem happened
C
200	MSGLEN = 26
	MSG(1:MSGLEN) = 'LAB section of EXPORT file'
C
C Initialise number of times we've read from the .PAT table - so we dont overrun
C
	J = 0
	LABID = -1
	PATID = -1
C
C Start reading points from EXPORT LAB section and the attributes from TMP
C .PAT section
C
300	PREVLABID = LABID
	WRITE_FEAT = .TRUE.
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
	CALL SETWIN(1,80)
C
C Read next value (User-Id)
C
	IF (POINT_ID.EQ.USER_ID) THEN
	   NODIG = RDLONG(LABID)
	   IF (NODIG) GOTO 8000
	   NODIG = RDLONG(DUMMY)
	   IF (NODIG) GOTO 8000
	   DUMMY = LABID
	ELSEIF (POINT_ID.EQ.INTERNAL_ID) THEN
	   NODIG = RDLONG(DUMMY)
	   IF (NODIG) GOTO 8000
	   NODIG = RDLONG(LABID) ! BARTS data will contain FC in internal ID
	   IF (NODIG) GOTO 8000
	ENDIF
C
	IF (DUMMY.EQ.-1) GOTO 9000		! all points read
C
C Read point from the LAB section
C
	NODIG = RDREAL(STBUF(1,1))		! get X
	IF (NODIG) GOTO 8000
C
	NODIG = RDREAL(STBUF(2,1))		! get Y
	IF (NODIG) GOTO 8000
C
C Read any additional line from LAB containing redundant information
C
	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
C
C If file contains wide reals (field width of 24), then read an extra line
C
	IF ( WIDEREALS ) THEN
	   STATUS = GET_EXP_LINE()
	   IF ( .NOT.STATUS .OR. LAST_LINE ) GOTO 9000
	ENDIF
C
C Internal LAB ID should be unique. If it is not get next label point.
C
	   IF (J.GT.0) THEN     ! not the first time
	      IF (LABID.EQ.PREVLABID) THEN
	         IF (HAD_VERBOSE) THEN
		    CALL WRITEF('Internal LAB ID %N not unique',LABID)
CCC		    CALL WRITEF('Internal LAB ID %N not unique. Occurance ignored',LABID)
		 ENDIF
CCC	         GOTO 300	! dont skip point! Keep points but throw atts
	      ENDIF
C
C If there is a problem and we want a description, give it
C
	      IF (HAD_VERBOSE) THEN
		 IDDIFF = LABID - PREVLABID
	         IF (IDDIFF.LT.0) THEN
		    CALL WRITEF('Internal LAB ID %N not in ascending order',LABID)
	         ELSEIF(IDDIFF.GE.2) THEN
		    CALL WRITEF('Internal LAB ID %N missing or out of sequence',PREVLABID+1)
	         ENDIF
	      ENDIF
	   ENDIF
C
C Do not output any BARTS features with FC of 0
C
	IF (HAD_ID_TO_FC .AND. LABID.EQ.0) THEN       ! dont write FC 0 
	   WRITE_FEAT = .FALSE.
	ENDIF
C
C Update the range info
C
	IF (WRITE_FEAT) CALL CHECK_RANGE(STBUF(1,1),STBUF(2,1))
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
	   CALL IFFNF(INF4,INF4)
	   IF (HAD_ID_TO_FC) THEN
C
C FC is held in internal ID field
C
C BARTS ID of 0 is thrown away
C BARTS IDs <32768 require no change
C BARTS IDs 32768-139000 require removal of first 3 digits
C BARTS IDs >139000 require removal of first 2 digits
C
C Note: ISTAT(1) should not exceed 32767
C
	      IF (LABID.LT.32768) THEN
	         ISTAT(1) = LABID
	      ELSEIF (LABID.GE.32768 .AND. LABID.LE.139000) THEN
	         ISTAT(1) = LABID - ((LABID/1000)*1000)
	      ELSEIF (LABID.GT.139000) THEN
	         ISTAT(1) = LABID - ((LABID/10000)*10000)
	      ENDIF
	   ELSE
	      ISTAT(1) = SYMB_FC
	   ENDIF
	   ISTAT(2) = 0
	   ISTAT(3) = '4000'X		! set bits 14,15 to 1 for symbol feature
	   ISTAT(4) = 0
	   CALL IFFFS(ISTAT)	
	ENDIF
C
350	IF ( HAD_PNTATT .AND. NUM_ATT.GT.0 ) THEN
C
C Read attibutes from .PAT if there are any
C
	   IF ( J.LT.NUM_PTS ) THEN
	      PREVPATID = PATID
	      STATUS = GET_ACS(2,LABID,PATID,WRITE_FEAT) ! 2 denotes .PAT table
	      IF ( .NOT.STATUS ) GOTO 9000
C
C Here's a temporary bodge to always write the feature even if we couldn't
C get attributes for it. More important to keep the feature than to throw it
C away because the attribute extraction failed.
C
	      WRITE_FEAT = .TRUE.
C
	      J = J + 1
C
C Internal .PAT ID should be unique. If it is not get next PAT entry.
C
	      IF (J.GT.1) THEN     ! not the first time
	         IF (PATID.EQ.PREVPATID) THEN
	            IF (HAD_VERBOSE) THEN
	               CALL WRITEF('Internal PAT ID %N not unique. Occurance ignored',PATID)
		    ENDIF
	            GOTO 350
	         ENDIF
C
C If there is a problem and we want a description, give it
C
	         IF (HAD_VERBOSE) THEN
		    IDDIFF = PATID - PREVPATID
 		    IF (IDDIFF.LT.0) THEN
		       CALL WRITEF('Internal PAT ID %N not in ascending order',PATID)
	            ELSEIF(IDDIFF.GE.2) THEN
		       CALL WRITEF('Internal PAT ID %N missing or out of sequence',PREVPATID+1)
	            ENDIF
	         ENDIF
	      ENDIF
C
	      IF (PATID.EQ.0 .OR.
     &	          PATID.LT.LABID) GOTO 350         ! get next set of attributes
C
	      IF (LABID.NE.PATID) THEN
	         CALL LSL_PUTMSG( ARC2I__NOPNTATT,LABID )    ! give warning
	      ELSE
	         IF (HAD_VERBOSE .AND. NUM_ATT.GT.0) CALL WRITEF('Label point with LAB ID %N given attribute(s).',LABID)
	      ENDIF
	   ELSE
C
C We have run out of attributes with more points to come
C
	      CALL LSL_PUTMSG( ARC2I__NOPNTATT,LABID )    ! give warning
	   ENDIF
C
	ENDIF
C
	IF (WRITE_FEAT) THEN
	   CALL IFFTH(ITHK)
	   CALL IFFST(STBUF,1,IENDS)
	   CALL IFFEF
	ENDIF
C
C Get next feature
C
	GOTO 300
C
8000	STATUS = ARC2I__ERRRDNUM
	CALL LSL_PUTMSG( STATUS,MSG(1:MSGLEN) )
	CALL LSL_ADDMSG( ERRNUM )             ! LSLLIB exception
	IF ( ERRNUM.EQ.LSL__HADEXCP ) CALL LSL_ADDMSG( LSL_EXCP )
C
9000	GET_PTS = STATUS
C
	RETURN
	END
