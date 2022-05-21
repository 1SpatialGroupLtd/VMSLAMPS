C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-07 15:44:48.000000000 +0100
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
	INTEGER*4 FUNCTION READ_LINE(UNIT)
C
CDEC$	IDENT	'07OC92'
C
C	Copyright Laser-Scan  Ltd., Cambridge, England.
C
C	Created	01-04-92	SG	loosely based on T2ILIN	RJH 23-MAR-1984
C
C Description
C	General purpose function to read a line from the specified unit
C	skips blank lines
C
	IMPLICIT NONE
C
C Argument
	INTEGER		UNIT			! file unit number
C
C Common blocks
	INCLUDE		'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE		'LSL$CMNLSL:STATUS.CMN'
C
C Functions called
	INTEGER*4	FLRLIN			! gets line from file
	LOGICAL		RDCHS			! reads next character
C
C Local variables
	INTEGER*4	RETCOD			! VAX error return code
	INTEGER*4	RETVAL			! return value of function
	LOGICAL		IS_EOLN
	BYTE		CH
C
C ..............................................................................
C
	RETVAL = LSL__NORMAL
	CALL FLRSEL(UNIT)				!select file
	IS_EOLN = .TRUE.
C
C ..............................................................................
C get lines while everything was ok and we read no characters
C
	DO WHILE (IS_EOLN.AND.(RETVAL.EQ.LSL__NORMAL))
	  RETVAL = FLRLIN(,,,RETCOD)			! read line into buffer
C
C	  ......................................................................
C	  Report all errors other than an end of file, then drop out of WHILE
C
	  IF (RETVAL.NE.LSL__NORMAL) THEN		! had an error
CMOD	    IF (RETVAL.NE.LSL__EOF) THEN
	      CALL LSL_PUTMSG(RETVAL)
	      CALL LSL_ADDMSG(RETCOD)			!supplementary message
CMOD	    ENDIF
C
C	  ......................................................................
C	  If there were no errors, check that the line wasnt blank.
C
	  ELSE
	    CALL BSLN					! go to start of line
	    IS_EOLN = RDCHS(CH)				! attempt to read chars
	    IF (.NOT.IS_EOLN) CALL BSLN			! reset to start of line
	  ENDIF
	END DO
C
C ......................................................................
C
	READ_LINE = RETVAL
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
C
	LOGICAL FUNCTION RDCHR(OUT_CHAR)
C
CDEC$	IDENT	'01AP92'
C
C	Copyright Laser-Scan  Ltd., Cambridge, England
C
C	Created 02-04-92	SG
C
C Description
C	reads a character not a flipping byte, and returns true on success
C
	IMPLICIT NONE
C
C Argument
	CHARACTER OUT_CHAR
C
C Functions called
	LOGICAL RDCH
C
C Local Vars
	BYTE	GOT_BYTE
C
C..............................................................................
C
	RDCHR = .NOT.RDCH(GOT_BYTE)
	OUT_CHAR = CHAR(GOT_BYTE)
C
C..............................................................................
C
	RETURN
	END

C
C----------------------------------------------------------------------------
C
C
	LOGICAL FUNCTION RDCHRS(OUT_CHAR)
C
CDEC$	IDENT	'01AP92'
C
C	Copyright Laser-Scan  Ltd., Cambridge, England
C
C	Created 02-04-92	SG
C
C Description
C	reads a character not a flipping byte, returns .true. on success
C	excluding spaces
C
	IMPLICIT NONE
C
C Argument
	CHARACTER OUT_CHAR
C
C Functions called
	LOGICAL RDCHS
C
C Local Vars
	BYTE	GOT_BYTE
C
C..............................................................................
C
	RDCHRS = .NOT.RDCHS(GOT_BYTE)
	OUT_CHAR = CHAR(GOT_BYTE)	
C
C..............................................................................
C
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	LOGICAL FUNCTION RDNCHRS (STR, NUM_CHARS)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	01-04-92	SG	based on READSTR
C
C definition
C	Reads the specified number of characters from the TXTC buffer
C	into the specified STR. Returns .TRUE. if success and
C	false if it was unsuccessful.
C	If it was unsuccessful, the TXTC pointer is reinstated
C
C Arguments
	CHARACTER*(*)	STR		!STR to be read into
	INTEGER		NUM_CHARS	!number of characters to read
C
C functions called
	LOGICAL		RDCHR		! read one character
C
C workspace
	INTEGER*4	LENGTH		! accumulates length of STR
	INTEGER*4	IN_LENGTH	! lengtH of input STR
	INTEGER*4	TXT_PTR		! position of pointer in TXTC
	CHARACTER	CH		! for reading characters
	LOGICAL		OK, IS_EOL
	
C
C *********************************************************************
C initialise things
C
	LENGTH = 0			! nothing output to STR
	IN_LENGTH = LEN(STR)		! maximum length to output

	OK = NUM_CHARS.LE.IN_LENGTH
	IF (.NOT.OK) GOTO 1000
C
C...............................................................................
C save the TXT pointer just in case it has to be restored later
C
	CALL DCPSAV (TXT_PTR)			!save the pointer
C
C	........................................................................
C	read the required number of characters into the STR
C	drop out if there was an error
C
	DO WHILE (OK.AND.(LENGTH.LT.NUM_CHARS))
	  OK = RDCHR(CH)
	  IF (OK) THEN
	    LENGTH = LENGTH +1
	    STR(LENGTH:LENGTH) = CH
	  ENDIF
	END DO
C
C	........................................................................
C	if there was an error then restore the pointer to its original value
C
	IF (.NOT.OK) CALL DCPSET (TXT_PTR)	!restore the pointer on error
C
C..........................................................................
C
1000	RDNCHRS = OK				! return result
	RETURN
	END

C
C
	INTEGER FUNCTION RDSTRING (STR)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	01-04-92	SG	based on READSTR
C
C definition
C	Reads all characters from TXTC into the specified STR
C	Returns number of charcaters read
C	if number of charcaters exceeds STR size, reads only as many spaces 
C	are in STR
C
C Arguments
	CHARACTER*(*)	STR		!STR to be read into
C
C functions called
	LOGICAL		RDCHR		! read one character
C
C workspace
	INTEGER*4	LENGTH		! accumulates length of STR
	INTEGER*4	IN_LENGTH	! lengtH of input STR
	CHARACTER	CH		! for reading characters
	LOGICAL		OK
	
C
C *********************************************************************
C initialise things
C
	LENGTH = 0			! nothing output to STR
	IN_LENGTH = LEN(STR)		! maximum length to output
	OK = .TRUE.

C
C	........................................................................
C	read the required number of characters into the STR
C	drop out if there was an error
C
	DO WHILE (OK.AND.(LENGTH.LT.IN_LENGTH))
	  OK = RDCHR(CH)
	  IF (OK) THEN
	    LENGTH = LENGTH +1
	    STR(LENGTH:LENGTH) = CH
	  ENDIF
	END DO
C
C..........................................................................
C
1000	RDSTRING = LENGTH				! return result
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	INTEGER FUNCTION WORD_START(STR, START)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	finds next non-space_characater in STR
C
C Arguments
	CHARACTER*(*)	STR		!STR to be read into
	INTEGER		START		!where to start searching
C
C workspace
	INTEGER		PTR
	INTEGER		LENGTH	
C
C Funcs
	LOGICAL		IS_SPACE
C
C *********************************************************************
C initialise things
C
	PTR = START				!start of STR
	LENGTH = LEN(STR)			!real length of STR
C
	DO WHILE ( (PTR.LE.LENGTH).AND.IS_SPACE(STR(PTR:PTR)) )
	  PTR = PTR +1
	END DO
C	
	IF (PTR.GT.LENGTH) PTR = 0	!all were spaces
C
C..........................................................................
C
	WORD_START = PTR
	RETURN
	END

C
C----------------------------------------------------------------------------
C
C
	INTEGER FUNCTION WORD_END(STR,START)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	finds first position of first non-space_characater in STR
C
C Arguments
	CHARACTER*(*)	STR		!STR to be read into
	INTEGER		START		!where to start searching
C
C workspace
	INTEGER		PTR
	INTEGER		LENGTH	
C
C Funcs
	LOGICAL		IS_SPACE
C
C *********************************************************************
C initialise things
C
	PTR = START				!start of STR
C
	LENGTH = LEN(STR)			!real length of STR
C
	DO WHILE ( (PTR.LE.LENGTH).AND.(.NOT.IS_SPACE(STR(PTR:PTR))) )
	  PTR = PTR +1
	END DO
C	
	PTR = PTR - 1
C
C..........................................................................
C
	WORD_END = PTR
	RETURN
	END

C
C----------------------------------------------------------------------------
C
C
	LOGICAL	FUNCTION IS_SPACE(CH)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	is the specified character white_space?
C
C Arguments
	CHARACTER	CH		!STR to be read into
C
C..........................................................................
C
	IS_SPACE = ( (CH.EQ.' ').OR.(CH.EQ.CHAR(9)) )
C
C..........................................................................
C
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	INTEGER FUNCTION FIND_DELIM (CH, STR, START)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	Look for the specified character in the STR from the specified 
C	starting position onwards
C
C Arguments
	CHARACTER	CH		!character to find
	CHARACTER*(*)	STR		!STR to read from
	INTEGER		START		!where to start searching
C
	INTEGER		PTR
C
C..........................................................................
C
	FIND_DELIM = INDEX(STR(START:),CH)
	IF (FIND_DELIM.GT.0) FIND_DELIM = FIND_DELIM + START - 1
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	INTEGER FUNCTION BACK_WORD_END (STR, START)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	11-06-92	SG
C
C definition
C	from the starting position work backwards along the STR until a 
C	non_space character is found
C
C Arguments
	CHARACTER*(*)	STR		!STR to read from
	INTEGER		START		!where to start searching
C
	INTEGER		LENGTH, PTR
C
	LOGICAL		IS_SPACE
C
C..........................................................................
C
	LENGTH = LEN(STR)
	PTR = 0
C
	PTR = START
	DO WHILE ( (PTR.GT.0).AND.IS_SPACE(STR(PTR:PTR)) )
	  PTR = PTR - 1
	END DO
C
C..........................................................................
C
	BACK_WORD_END = PTR	
	RETURN
	END
C----------------------------------------------------------------------------
C
C
	SUBROUTINE CHAR_TO_BYTE (STR, BYTE_ARRAY)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	14-06-92	SG
C
C definition
C	convert STR into a byte array. Assumes that byte array has 256
C	elements. Will append a NULL (acsii 0) to end of array as it will
C	be used to send to C routines eventually.
C
C Arguments
	CHARACTER*(*)	STR				!STR to read from
	BYTE		BYTE_ARRAY(256)
C
	INTEGER		LENGTH, PTR
C
C..........................................................................
C
	LENGTH = LEN(STR)				!length of input STR
	PTR = 1						!initalise
C
	IF (LENGTH.GT.255) LENGTH = 255			!truncate STR if necc

C
	DO WHILE (PTR.LE.LENGTH)			!for each character
	  BYTE_ARRAY(PTR) = ICHAR(STR(PTR:PTR))	!convert to ASCII
	  PTR = PTR+1					!move pointer on
	END DO
C
	BYTE_ARRAY(PTR) = 0				! append a NULL
C
C..........................................................................
C
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	INTEGER FUNCTION NEXT_WORD(STR,START)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	finds start of fresh word
C
C Arguments
	CHARACTER*(*)	STR		!STR to be read into
	INTEGER		START		!where to start searching
C
C workspace
	INTEGER		PTR
	INTEGER		LENGTH
C
C Funcs
	INTEGER		WORD_END
	INTEGER		WORD_START
C
C *********************************************************************
C initialise things
C
C
	LENGTH = LEN(STR)			!real length of STR
	PTR = WORD_END(STR,START)		!end of current word
	IF (PTR.NE.0) PTR = WORD_START(STR,PTR+1) !new word
C
C..........................................................................
C
	NEXT_WORD = PTR
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	LOGICAL FUNCTION IS_ALPHA(CH)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	is the current character alphabetic
C
C Arguments
	CHARACTER	CH
C
C..........................................................................
C
	IS_ALPHA = (   ((CH.GE.'a').AND.(CH.LE.'z'))
     &		   .OR.((CH.GE.'A').AND.(CH.LE.'Z'))
     &		   .OR.(CH.EQ.'_')	)
C
C..........................................................................
C
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	LOGICAL FUNCTION IS_DIGIT(CH)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	 7-10-92	CCB
C
C definition
C	is the current character a digit
C
C Arguments
	CHARACTER	CH
C
C..........................................................................
C
	IS_DIGIT = ( CH.GE.'0' .AND. CH.LE.'9' )
C
C..........................................................................
C
	RETURN
	END
C
C----------------------------------------------------------------------------
C
C
	INTEGER FUNCTION NAME_END(STR,START)
C
CDEC$	IDENT	'01AP92'
C
	IMPLICIT NONE
C
C Copyright Laser Scan  Ltd., Cambridge, England
C
C Created 	10-06-92	SG
C
C definition
C	finds first position of first non-space_characater in STR
C
C Arguments
	CHARACTER*(*)	STR		!STR to be read into
	INTEGER		START		!where to start searching
C
C workspace
	INTEGER		PTR
	INTEGER		LENGTH	
C
C Funcs
	LOGICAL		IS_ALPHA
C
C *********************************************************************
C initialise things
C
C
	PTR = 0
	LENGTH = LEN(STR)			!real length of STR
C
	IF (START.LE.LENGTH) THEN
	  PTR = START				!start of STR
	  DO WHILE ( (PTR.LE.LENGTH).AND.IS_ALPHA(STR(PTR:PTR))  ) 
	    PTR = PTR +1
	  END DO
C	
	  PTR = PTR-1
	  IF (PTR.LT.START) PTR = 0
	ENDIF
C
C..........................................................................
C
	NAME_END = PTR
	RETURN
	END
