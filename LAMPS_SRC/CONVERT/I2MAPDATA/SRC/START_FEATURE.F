	SUBROUTINE START_FEATURE()
C
CDEC$	IDENT	'12OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					ST	06-Oct-1994
C
C	CONVERT I2MAPDATA Utility - Start MapData feature
C
C Description
C
C	Write the SEGMENT abd CODE lines of the current MapData feature.
C
	IMPLICIT NONE
C
C Parameter Files
C
!	INCLUDE	'LSL$CMNIFF:CB.STR'		! record structure definition
C
!	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE	'CMN:IFF.CMN'      		! IFF specific things
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
C
C------------------------------------------------------------------------------
C
	IF (.NOT.STARTED_FEATURE) THEN
	   SEGNUM = SEGNUM + 1
	   CALL WRITE_MD_SEG(SEGNUM)	 	! Write the `SEGMENT' line
	   CALL WRITE_MD_CODE(FC_STR(FC_IND))	! Write the `CODE' line
	   STARTED_FEATURE = .TRUE.
	ENDIF
C
	RETURN
	END
