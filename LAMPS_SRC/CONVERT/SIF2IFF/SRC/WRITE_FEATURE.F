	SUBROUTINE WRITE_FEATURE
C
CDEC$	IDENT	'31JA90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Write feature to IFF file
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
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! global variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! feature details
	INCLUDE 'CMN:TEXT.CMN'		! text data
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
C
C Local variables
C
	INTEGER	I 			! loop counter
	BYTE	TEXT_BUFF(MAX_BUF_SIZE)	! text buffer for IFFTX
C
C...............................................................................
C
	IF (.NOT.DONE_START_FEATURE) CALL START_FEATURE	!start the feature

	CALL FLUSH					!output coordinates

	IF (ORI_SYM.OR.IS_TEXT) CALL IFFRO( ANGLE )	!orientation

	IF (IS_TEXT) THEN				!text

	   IF (NCHS.GT.MAX_BUF_SIZE) NCHS=MAX_BUF_SIZE	!BUGFIX,prevent overflow

	   DO 200 I = 1, NCHS				!convert to byte array
	     READ ( TEXT(I:I),100 ) TEXT_BUFF(I)
100	     FORMAT( A )
200	   CONTINUE

	   CALL IFFTX( TEXT_BUFF, NCHS )		!write text out
	ENDIF

	CALL IFFEF					!end the feature
C
C...............................................................................
C Return
C
	RETURN
	END
