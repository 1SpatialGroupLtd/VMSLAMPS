	PROGRAM I2SXF
C
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	09-May-1990
C
C	CONVERT I2SXF Utility - Main Program
C
C Description
C
C	IFF to SXF Conversion
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		RDPAR		! read parameter file
	LOGICAL		FRTINI		! read FRT file
	INTEGER*4	IFFOPEN		! open IFF file
	LOGICAL		CLOSE_IFF	! close IFF file
C
C Initialise LSL libraries
C
	CALL LSL_INIT(.TRUE.)
C
C Get and decode the command line
C
	IF (GET_COMMAND()) THEN
	   CALL REPORT
C
C Now for the FRT if it was requested
C
	   IF (HAD_FRT) THEN
	      IF (FRTINI(FRTFIL(1:FRTLEN))) THEN
	         CALL LSL_PUTMSG(I2SXF__ERRRDFRT,FRTFIL(1:FRTLEN))
	         GOTO 9000
	      ENDIF
C
C otherwise set up the standard ACD definitions
C
	   ELSE
	      CALL FRT_ACDINI
	   ENDIF
C
C Read the code table
C
	   IF (RDPAR()) THEN
C
C Open IFF file and SXF file
C
	      IF (IFFOPEN(IFFLUN,IFFFIL(:IFFLEN),,HAD_LOG)) THEN
C ***** open SXF file
C
C Process the IFF file
C
C *****	         CALL PROCESS
C
C Close IFF file and SXF file
C
	         CALL CLOSE_IFF
C ***** close SXF file
	      ENDIF
	   ENDIF
	ENDIF
C
C Set the return status and finish up
C
9000	CALL LSL_EXIT
	END
