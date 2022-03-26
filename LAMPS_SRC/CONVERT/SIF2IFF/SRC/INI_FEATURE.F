        SUBROUTINE INI_FEATURE
C
CDEC$	IDENT   '06FE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	14-Jan-1990
C
C	CONVERT SIF2IFF Utility - Initialisation for a new feature
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
C
C Arguments
C
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! feature details
	INCLUDE	'CMN:IFF_POINTS.CMN'	! points in the feature
	INCLUDE 'CMN:TEXT.CMN'		! text data
C
C Functions called
C
C
C Local Variables
C
C
C Initialise flags for type of feature (to be set later)
C
	IS_LINE   = .FALSE.
	IS_CURVE  = .FALSE.
	IS_CIRCLE = .FALSE.
	IS_ARC    = .FALSE.
	IS_SYMBOL = .FALSE.
	IS_TEXT   = .FALSE.
	IS_AREA   = .FALSE.
C
	ORI_SYM   = .FALSE.
	SCA_SYM   = .FALSE.
C
C Haven't started yet
C
	DONE_START_FEATURE = .FALSE.
C
C Initialise data
C
	ANGLE    = 0.0
	STYLE    = 0
	JUSTIF   = 0
C
C and the points, just for safety
C
	STPTR = 0
	STBUF(1,0) = 0.0
	STBUF(2,0) = 0.0
C
C Return
C
	RETURN
        END
