        INTEGER*4  FUNCTION OPEN_IFF()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB  10-Aug-1989
C
C Get input IFF file and open on lun IFFLUN.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
C
C
C System parameters
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C Functions:
C
	INTEGER*4	IFFOPEN		! open IFF file for readonly
C
C Workspace:
C
C
C ......................................................................
C
C
	OPEN_IFF=%LOC(SS$_NORMAL)
C
C Open IFF input file
C
	OPEN_IFF=IFFOPEN(IFFLUN,IFF_FILE(:IFF_FILE_LEN),,HAD_LOG)
C
C Flag that we have got the input file open
	IF (OPEN_IFF) IFF_IS_OPEN = .TRUE.
C
C ......................................................................
C
30	IF (OPEN_IFF) OPEN_IFF=%LOC(SS$_NORMAL)     ! normal completion?
	RETURN
	END
