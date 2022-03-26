	SUBROUTINE WRITE_PARTITION_HEADER()
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Write partition name and other information held in the partition
C       header.
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'		! General stuff
C
C Local Variables
C
	INTEGER*2	I,N
C
C------------------------------------------------------------------------------
C
C Words 1..16
C
	CALL ADD_NAME(PARTNAME(1:10),10)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(1)
	CALL ADD_WORD(1)
	CALL ADD_WORD(1)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(0)
	CALL ADD_WORD(0)
	CALL ADD_WORD(0)
	CALL ADD_WORD(0)
C
	RETURN
	END
