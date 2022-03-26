	SUBROUTINE XXXXX
C
CDEC$	IDENT	'09MY90'
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
	INCLUDE 'LSL$CMNI2SXF:FILES.CMN'	! filenames
C
C Arguments
C
	...
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		RDPAR		! read parameter file
	LOGICAL		FRTINI		! read FRT file
	INTEGER*4	IFFOPEN		! open IFF file
	LOGICAL		CLOSE_IFF	! close IFF file
C
C Local variables
C




	RETURN
	END
