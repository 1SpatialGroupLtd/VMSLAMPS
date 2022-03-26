	SUBROUTINE WRITE_END
C
CDEC$	IDENT	'06FE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Pinched from IMAP2I			JMC	11-Jan-1990
C	Created					RJH	21-Oct-1987
C
C	CONVERT SIF2IFF Utility - Write final data to IFF file
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
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
C
C Local Variables
C
	INTEGER*2	IECODE		! IFF entry type
	INTEGER*2	IELEN		! IFF entry length
C
C Make sure we have started the map and there have been no IFF errors, 
C even although we may be giving up due to other types of error
C
	IF (DONE_START_MAP .AND.
     &	    (IERCD .EQ. 0) .AND. (IERNM .EQ. 1)) THEN
C
C Warn if no data has been written to the IFF file
C
	   IF (FSN .EQ. 0) CALL LSL_PUTMSG(SIF2IFF__NODATA)
C
C Finish off the IFF file
C
	   CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	   CALL IFFEO			! end the layer
	   CALL IFFEM			! end the map
	   CALL IFFEJ			! end the 'job'
C
C Now go back and set the RA entry
C
CCC	   IF (.NOT.HAD_RANGE) THEN
	      CALL IFFPKE( IECODE, IELEN, LPOSRA )
	      IF ( IECODE.NE.'RA' ) THEN
	         CALL LSL_PUTMSG( SIF2IFF__NORA )
C	         GIVE_UP = .TRUE.
	      ELSE
	         CALL EIHWR( RANGE, 4, 1 )
	      ENDIF
CCC	   ENDIF
	ENDIF
C
C Check that the data was written successfully
C
C	IF (.NOT. GIVE_UP) THEN
C	   IF ((IERCD .NE. 0) .OR. (IERNM .NE. 1)) THEN
C	      CALL LSL_PUTMSG(SIF2IFF__IFFABORTED)
C	      GIVE_UP = .TRUE.
C	   ENDIF
C	ENDIF
C
C Return
C
	RETURN
	END