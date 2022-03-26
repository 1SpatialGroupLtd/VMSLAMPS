	LOGICAL FUNCTION RDNAM(NAME_OUT,LEN_OUT)
C
CDEC$	IDENT	'28JA91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Pinched from IMAP2I and modified	ST	14-Jan-1991
C	Created					RJH	 6-Jun-1989
C
C	CONVERT ARC2I Utility - Read name from parameter file
C
C Description
C
C	Reads an attribute name from the parameter file
C
C	Expects the parameter file to be open, the current input line 
C	to be in TXTBUF, and the command line decoding pointer to be in 
C	position before the name to be read
C
C	Returns FALSE if something goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'HERE:ARC2IMSG.PAR'		! message definitions
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'	! for string reading
C
C Arguments
C
	CHARACTER*(*)	NAME_OUT	! name to be returned
	INTEGER*4	LEN_OUT		! its lenghth
C
C Functions called
C
	INTEGER*4	READSTR		! reads a string
C
C Local Variables
C
	LOGICAL		RETVAL		! error return code
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	RDNAM = .TRUE.
C
C Initialise the string
C
	NAME_OUT = ' '
C
C Now read it in the attribute name
C
	LEN_OUT = READSTR(NAME_OUT,,ON_SPACE,,RETVAL)
C
C and check that was sucessful
C
	IF (LEN_OUT .EQ. 0) THEN
	   CALL LSL_PUTMSG(ARC2I__NOATTNAME)
	   CALL LSL_ADDMSG(RETVAL)
	   RDNAM = .FALSE.
	ELSEIF (.NOT. RETVAL) THEN
	   CALL LSL_PUTMSG(ARC2I__BADATTNAME,NAME_OUT(1:LEN_OUT))
	   CALL LSL_ADDMSG(RETVAL)
	   RDNAM = .FALSE.
	ENDIF
C
C Return
C
	RETURN
	END
