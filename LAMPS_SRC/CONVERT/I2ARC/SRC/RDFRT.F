	LOGICAL FUNCTION RDFRT(FRTFILE)
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	8-Feb-1991
C
C Description:
C
C	This function reads the parameter file which translates 
C	ARC/INFO attributes into IFF AC codes and visa-versa
C       It is put into its own small Fortran routine and called from I2ARC
C       because FRTINI needs to fill the common block so that other Fortran
C       routines can access it and so that C can access the FRTCOM.H which
C       maps onto it.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:I2ARCMSG.PAR'		! I2ARC messages
C
C Common blocks
C
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'		! FRT info
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRT ACD info
C
	CHARACTER*(*)	FRTFILE
C
C Functions called
C
	LOGICAL		FRTINI
C
C-------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	RDFRT = .TRUE.
C
	IF (FRTINI(FRTFILE)) RDFRT = .FALSE.
C
C Return
C
	RETURN
	END
