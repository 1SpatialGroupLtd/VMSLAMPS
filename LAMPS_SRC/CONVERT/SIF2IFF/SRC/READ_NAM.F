	LOGICAL FUNCTION READ_NAM(NAME_OUT,LEN_OUT)
C
CDEC$	IDENT	'10JA90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from IMAP2I and modified	JMC	10-Jan-1990
C	Created					RJH	 6-Jun-1989
C
C	CONVERT SIF2IFF Utility - Read name from FDF file
C
C Description
C
C	Reads a symbol name from the FDF file
C
C	Expects the FDF file to be open, the current input line 
C	to be in TXTBUF, and the command line decoding pointer to be in 
C	position before the name to be read
C
C	Returns FALSE if something goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'		! message definitions
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
C Assume success
C
	READ_NAM = .TRUE.
C
C Initialise the string
C
	NAME_OUT = ' '
C
C Now read it in the name
C
	LEN_OUT = READSTR(NAME_OUT,,ON_SPACE,,RETVAL)
C
C and check that was sucessful
C
	IF (LEN_OUT .EQ. 0) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NOSYMNAM)
	   CALL LSL_ADDMSG(RETVAL)
	   READ_NAM = .FALSE.
	ELSEIF (.NOT. RETVAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADSYMNAM,NAME_OUT(1:LEN_OUT))
	   CALL LSL_ADDMSG(RETVAL)
	   READ_NAM = .FALSE.
	ENDIF
C
C Return
C
	RETURN
	END
