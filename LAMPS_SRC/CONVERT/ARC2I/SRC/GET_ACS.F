C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-23 13:53:52.000000000 +0100
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
	LOGICAL FUNCTION GET_ACS( TABLE,INTID,TABLEID,WRITE_ATT )
C
CDEC$	IDENT	'23AU93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	11-Jan-1991
CMOD	When double precision coords present in		ST	23-Aug-1993
C	the AAT or PAT, the correct offset is used
C	when calculating the start position for
C	remaining attributes.
C
C Description:
C
C	Function GET_ACS called from PROCESS in ARC2I
C	Gets any attributes associated with an arc or point.
C	The TABLE argument to the function denotes which table is to be read.
C	Number 1 is the .AAT table and 2 is the .PAT table
C
C
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:EXCEPTION.CMN'	! LSLLIB exceptions
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRT Common block
	INCLUDE	'HERE:IFFINFO.CMN'		! IFF information
	INCLUDE	'HERE:TABLES.CMN'		! Parameter file tables
	INCLUDE	'HERE:ATTRDATA.CMN'		! EXPORT attribute info
	INCLUDE 'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:GENERAL.CMN'		! General information
C
C Arguments
C
	INTEGER*4	TABLE			! .AAT or .PAT table to be read
	INTEGER*4	INTID			! Internal ID from LAB or ARC
	INTEGER*4	TABLEID			! ID from .PAT or .AAT
	LOGICAL		WRITE_ATT		! Write out the attributes?
C
C Functions
C
	INTEGER*4	GET_TMP_LINE		! Read line from temporary file
	INTEGER*4	FIND_TAB_POSN		! Position in table of attribute
	INTEGER*4	CVT_DMY_DAY		! Convert to VAX date
	LOGICAL		RDLONG			! Read longword integer
	LOGICAL		RDLOND			! Read long integer
	LOGICAL		RDREAL			! Read real
C
C Local Variables
C
	INTEGER*4	STRSZ
	PARAMETER	(STRSZ=1024)
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	I,J,K			! Loop counters and general
	LOGICAL		NODIG			! Reading digit status
	LOGICAL		READ_NEXT_LINE		! The next line is in hand
	CHARACTER*80	EXPLINE			! Line from EXPORT file
	CHARACTER*80	TMPLINE			! Line from TMP file
	CHARACTER*1024	STR			! All attributes
	INTEGER*4	ATT_INT_VAL		! Actual attribute value
	REAL		ATT_REAL_VAL		! Actual attribute value
	INTEGER*4	ATT_NAME_LEN		! Length of attribute name
	BYTE		STR_BUF(STRSZ)		! The buffer equivalent of STR
	INTEGER*4	START_POS		! True start posn of att in STR
	INTEGER*4	REMAINDER		! Part of attr at end of line
	INTEGER*4	TOTWIDTH		! Working copy of ATT_WIDTH
	INTEGER*4	PTR			! Position in TMPLINE of attr
	INTEGER*4	POSN			! Pointer into STR
	INTEGER*4	TABPOS			! Attribute position in table
	INTEGER*4	AT_FLD			! Attribute field
	INTEGER*4	AT_TYP			! Attribute type
	CHARACTER*80	MSG			! Message if error occurred
	INTEGER*4	MSGLEN			! Length of the above
	INTEGER*4	DD,MM,YY		! Date components
	INTEGER*4	CH			! Integer value of character
C IFF stuff
	INTEGER*2	ACTYPE			! Type of AC
	INTEGER*4	LCODE			! AC value field
C
	EQUIVALENCE(TXTBUF(1),EXPLINE,TMPLINE)
	EQUIVALENCE(STR_BUF,STR)
C
C------------------------------------------------------------------------------
C
	STATUS = .TRUE.
	READ_NEXT_LINE = .FALSE.
C
C Read next line from PAT or AAT
C
	STATUS = GET_TMP_LINE()
	IF ( .NOT.STATUS ) GOTO 9000
C
	MSGLEN = 25
	IF (TABLE.EQ.1) THEN
	   IF ( WIDEREALS ) THEN
	      PTR = 11
	      IF (ARC_ID.EQ.INTERNAL_ID) THEN
		 CALL SETWIN(69,11)
	      ELSEIF (ARC_ID.EQ.USER_ID) THEN
		 STATUS = GET_TMP_LINE()
		 IF ( .NOT.STATUS ) GOTO 9000
		 CALL SETWIN(1,10)
		 READ_NEXT_LINE = .TRUE.
	      ENDIF
	   ELSE
	      PTR = 1		! position in TMPLINE of 1st attr (.AAT)
	      IF (ARC_ID.EQ.INTERNAL_ID) THEN
		 CALL SETWIN(59,11)
	      ELSEIF (ARC_ID.EQ.USER_ID) THEN
		 CALL SETWIN(70,11)
	      ENDIF
	   ENDIF
C
C Get ID
C
	   NODIG = RDLONG(TABLEID)
	   IF (NODIG) GOTO 8000
C
C Need to read an additional line from TABLE 1 (.AAT) because first line
C contains the standard fixed info.
C
	   IF (.NOT.READ_NEXT_LINE) THEN
	      STATUS = GET_TMP_LINE()
	      IF ( .NOT.STATUS ) GOTO 9000
	   ENDIF
C
	   MSG(1:MSGLEN) = '.AAT table in IFO section'
C
	ELSEIF (TABLE.EQ.2) THEN
C
	   IF ( WIDEREALS ) THEN
	      PTR = 71
	      IF (POINT_ID.EQ.INTERNAL_ID) THEN
		 CALL SETWIN(49,11)
	      ELSEIF (POINT_ID.EQ.USER_ID) THEN
		 CALL SETWIN(60,11)
	      ENDIF
	   ELSE
	      PTR = 51		! position in TMPLINE of 1st attr (.PAT)
	      IF (POINT_ID.EQ.INTERNAL_ID) THEN
		 CALL SETWIN(29,11)
	      ELSEIF (POINT_ID.EQ.USER_ID) THEN
		 CALL SETWIN(40,11)
	      ENDIF
	   ENDIF
C
C Get ID
C
	   NODIG = RDLONG(TABLEID)
	   IF (NODIG) GOTO 8000
C
	   MSG(1:MSGLEN) = '.PAT table in IFO section'
C
	ENDIF
C
	IF (TABLEID.NE.INTID .OR. TABLEID.EQ.0) THEN
	   WRITE_ATT = .FALSE.
	ELSE
	   WRITE_ATT = .TRUE.
	ENDIF
C
C One attribute may be split over two or more lines so set up a string of max
C length 999 (3 digits for width) to read attribute from.
C
	DO 510 J = 1,STRSZ
 	   STR(J:J)=' '		! clear string
510	CONTINUE
C
C Find total width of all attributes (excluding any redfined ones)
C
	TOTWIDTH = 0
	DO 515 J = 1,NUM_ATT_NOT_REDEFINED
	   TOTWIDTH = TOTWIDTH + ATT_WIDTH(J)
515	CONTINUE
C
C Accumulate all attributes into one string to ease the extraction of any
C redefined items.
C
	POSN = 1
550	IF ((PTR+TOTWIDTH).GT.80) THEN
	   REMAINDER = 81-PTR
	   TOTWIDTH = TOTWIDTH - REMAINDER
	   STR(POSN:POSN+REMAINDER-1) = TMPLINE(PTR:80)
	   POSN = POSN + REMAINDER
	   STATUS = GET_TMP_LINE()
	   IF ( .NOT.STATUS ) GOTO 9000
	   PTR = 1
	   GOTO 550
	ELSE
	   STR(POSN:POSN+TOTWIDTH-1) = TMPLINE(PTR:PTR+TOTWIDTH-1)
	   PTR = PTR + TOTWIDTH
	ENDIF
C
C Now consider each attribute in turn.
C
	DO 580 I = 1,NUM_ATT
C
C Check if attribute was defined in parameter file table. If it was not, we
C just ignore the value read.
C
C First, detemine attribute name length
C
	   DO 560 J = 1,16
	      IF (ATT_NAME(I)(17-J:17-J).NE.' ') THEN
	         ATT_NAME_LEN = 17-J
	         GOTO 565
	      ENDIF
560	   CONTINUE
	   IF (ATT_NAME_LEN.EQ.0) GOTO 9000
C
C Is it in the table?
C
565	   TABPOS = FIND_TAB_POSN(TABLE,ATT_NAME(I),ATT_NAME_LEN)
	   IF ( TABPOS.LE.0 ) GOTO 570	! attribute not in par file - skip it.
C
	   ACTYPE = ATTR_TAB(ATTR_COD,TABPOS)
	   AT_FLD = ATTR_TAB(ATTR_FLD,TABPOS)
	   AT_TYP = ATTR_TAB(ATTR_TYP,TABPOS)
C
C Set read buffer to STR_BUF (filled when STR is set due to equivalence)
C
	   CALL SETAUX(STR_BUF,STRSZ)
C
	   IF (TABLE.EQ.1) THEN
	      IF (WIDEREALS) THEN
		 START_POS = ATT_STARTPOS(I)-32
	      ELSE
		 START_POS = ATT_STARTPOS(I)-28
	      ENDIF
	   ELSE
	      IF (WIDEREALS) THEN
		 START_POS = ATT_STARTPOS(I)-24
	      ELSE
		 START_POS = ATT_STARTPOS(I)-16
	      ENDIF
	   ENDIF
	   CALL SETWIN(START_POS,ATT_WIDTH(I))
C
C See which field type the attribute is to go into, TEXT or VALUE
C
	   IF (AT_FLD.EQ.2) THEN
C
C Specified in PAR as going into text field
C
C Even if it will fit into the 4 chars of ACD_DATATYPE_C, it is still put into
C the optional text field. This way the size can be determined when going from
C I2ARC. Eg. if a field of 2 chars is put into the 4 char slot then when going
C back to ARC, it's true size will not be known.
C
	      LCODE = 0
	      IF (WRITE_ATT) CALL IFFAC(ACTYPE,LCODE,
     &		                        STR_BUF(START_POS),ATT_WIDTH(I))
	   ELSE
CC
CC FRT type     :    D   C   I   R   I   R
CC EXPORT type  :    D   C   I   N   B   F
CC EXPORT repsn :    1   2   3   4   5   6
CC                   :   :   :   :   :   :
	      GOTO (610,620,630,640,630,640) ATT_TYPE(I)
	   ENDIF
C
570	   CONTINUE	! return point for above GOTO
C
580	CONTINUE
	GOTO 8500
C
C
C Item type 'D' stored in EXPORT file as '1'
C Read a date (char*8) of the form YYYYMMDD
C
C
610	IF (AT_FLD.NE.2) THEN
C
C Specified in PAR as going into value field
C
	   IF (AT_TYP.NE.ACD_DATATYPE_D ) THEN
	      IF (WRITE_ATT) CALL LSL_PUTMSG( ARC2I__ATTRTYPE,
     &		                              ATT_NAME(I)(1:ATT_NAME_LEN),
     &		                              'date')
	   ELSE
C Get year
	      CALL SETWIN(START_POS,4)
	      NODIG = RDLONG(YY)
	      IF (NODIG) GOTO 615
C Get month
	      CALL SETWIN(START_POS+4,2)
	      NODIG = RDLONG(MM)
	      IF (NODIG) GOTO 615
C Get day
	      CALL SETWIN(START_POS+6,2)
	      NODIG = RDLONG(DD)
	      IF (NODIG) GOTO 615
C No error
	      GOTO 616
C
C If an error occurred in reading the date field (eg the date is made up of 
C blanks) then set the date to the minimun default
C
615	      IF (WRITE_ATT) CALL LSL_PUTMSG( ARC2I__ERRDATE,
     &	                                      ATT_NAME(I)(1:ATT_NAME_LEN),
     &					      STR(START_POS:START_POS+7) )
	      DD = 17
	      MM = 11
	      YY = 1858
C
616	      IF ( .NOT.CVT_DMY_DAY(LCODE,DD,MM,YY) ) THEN
	         IF (WRITE_ATT) CALL LSL_PUTMSG( ARC2I__ERRDATE,
     &		                                 ATT_NAME(I)(1:ATT_NAME_LEN),
     &						 STR(START_POS:START_POS+7) )
C
C This message will not appear twice because the above defaults will not fail
C
	         DD = 17
	         MM = 11
	         YY = 1858
	         CALL CVT_DMY_DAY(LCODE,DD,MM,YY)
	      ENDIF
	      IF (WRITE_ATT) CALL IFFAC(ACTYPE,LCODE )			! date
	   ENDIF
	ENDIF
	GOTO 570
C
C
C Item type 'C' stored in EXPORT file as '2'
C Read a character string (char*320)
C
C
620	IF (AT_FLD.NE.2) THEN
C
C Specified in PAR as going into value field
C
	   IF (WRITE_ATT) CALL LSL_PUTMSG( ARC2I__ATTFLD,ATT_NAME(I)(1:ATT_NAME_LEN) )
	ENDIF
	GOTO 570
C
C
C Item type 'I' stored in file as '3' AND
C Item type 'B' stored in file as '5'
C Read an integer (int*4)
C
C
630	IF (AT_FLD.NE.2) THEN
C
C Specified in PAR as going into value field
C
	   IF (AT_TYP.NE.ACD_DATATYPE_I) THEN
	      IF (WRITE_ATT) CALL LSL_PUTMSG( ARC2I__ATTRTYPE,ATT_NAME(I)(1:ATT_NAME_LEN),'integer')
	   ELSE
	      NODIG = RDLONG( ATT_INT_VAL )
	      IF (NODIG) GOTO 8000
	      IF (WRITE_ATT) CALL IFFAC( ACTYPE,ATT_INT_VAL )	! integer
	   ENDIF
	ENDIF
	GOTO 570
C
C
C Item type 'N' stored in file as '4' AND
C Item type 'F' stored in file as '6'
C Read a real (real)
C
C
640	IF (AT_FLD.NE.2) THEN
C
C Specified in PAR as going into value field
C
	   IF (AT_TYP.NE.ACD_DATATYPE_R) THEN
	      IF (WRITE_ATT) CALL LSL_PUTMSG( ARC2I__ATTRTYPE,ATT_NAME(I)(1:ATT_NAME_LEN),'real')
	   ELSE
	      NODIG = RDREAL( ATT_REAL_VAL )
	      IF (NODIG) GOTO 8000
	      IF (WRITE_ATT) CALL IFFAC( ACTYPE,ATT_REAL_VAL )		! real
	   ENDIF
	ENDIF
	GOTO 570
C
8000	STATUS = ARC2I__ERRRDNUM
	CALL LSL_PUTMSG( STATUS,MSG(1:MSGLEN) )
	CALL LSL_ADDMSG( ERRNUM )             ! LSLLIB exception
	IF ( ERRNUM.EQ.LSL__HADEXCP ) CALL LSL_ADDMSG( LSL_EXCP )
C
C Reset read buffer to TXTBUF
C
8500	CALL BSLN				
C
9000	GET_ACS = STATUS
C
	RETURN
	END
