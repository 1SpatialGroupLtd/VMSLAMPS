	LOGICAL FUNCTION OUTRECA
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	27-Jan-1986
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C
C	Outputs first record of DEM
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNLSL:MTOVCM.CMN'
C
C Function
C
	LOGICAL		OUTREC
C
C-------------------------------------------------------------------------------
C
C Write data for record A into OUTSTR, using FORTRAN write
C
   10	FORMAT(A144,4I6,15D24.15,3I6,11D24.15,I6,3E12.6,2I6)
C
	WRITE(OUTSTR,10) DEMNAM,DEMLEVEL,DEMPATT,DEMREF,DEMZONE,
     &	                      DEMTCONSTS,DEMXYUN,DEMZUN,DEMPOL,
     &	                      DOMAIN,DEMZRNG,DEMDIR,DEMACC,DEMDELX,
     &	                      DEMDELY,DEMDELZ,DEMNCOL
C
C Now output it
C
	OUTRECA=OUTREC(.FALSE.)
C
  100	CONTINUE
	RETURN
	END
