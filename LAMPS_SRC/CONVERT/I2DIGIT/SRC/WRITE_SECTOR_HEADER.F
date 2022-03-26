	SUBROUTINE WRITE_SECTOR_HEADER()
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Create a sector header with one partition name and other information.
C       Various unknown details will be filled in later when known.
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'		! General variables
C
C Parameters
C
	PARAMETER	MAX_PARTITIONS = 15
C
C Local Variables
C
	INTEGER*2	NUM_PARTITIONS
	INTEGER*2	I
C
C------------------------------------------------------------------------------
C
C At present the whole file is being written to one partition
C
	NUM_PARTITIONS = 1
C
C Words 1..8
C
	CALL ADD_WORD(310)	! File type
	CALL ADD_WORD(0)	! Number of sectors (unknown at present)
	CALL ADD_WORD(1)	! Number of headers
	CALL ADD_WORD(1)	! Number of partitions
	CALL ADD_WORD(9)	! Directory location
	CALL ADD_WORD(0)	! Reserved
	CALL ADD_WORD(0)	! Reserved
	CALL ADD_WORD(0)	! Reserved
C
C Words 9..16 (1st partition)
C
	CALL ADD_NAME(PARTNAME(1:10),10)
	CALL ADD_WORD(1)
	CALL ADD_WORD(0)	! sector size (unknown at present)
	CALL ADD_WORD(0)
C
C Fill rest of header sector with zeros. Probably quicker not to use ADD_WORD
C but lets keep it neat and tidy.
C
	DO 100 I = 1,8*(MAX_PARTITIONS-NUM_PARTITIONS)
	   CALL ADD_WORD(0)
100	CONTINUE
C
	RETURN
	END
