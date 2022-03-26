        SUBROUTINE REPORT
C
CDEC$	IDENT   '28SE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	16-Jan-1990
C
C	CONVERT SIF2IFF Utility - Report on what we are doing
C
C Description
C
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'		! filenames
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
C
C Report on things we get straight from the command line
C
	CALL WRITEF(' ')
	CALL WRITEF('Parameter file         : %S',PARFIL(1:PARLEN))
C
	CALL WRITEF('SIF file               : %S',SIFFIL(1:SIFLEN))
C
	CALL WRITEF('IFF output file        : %S',IFFFIL(1:IFFLEN))
C
	IF (HAD_OFFSET) THEN
	   CALL WRITEF(' ')
	   IF (HAD_OFFSET) THEN
	      CALL WRITEF('Offsets                : %^D%G10.8, %G10.8',
     &	         XOFF,YOFF)
	   ENDIF
	   CALL WRITEF(' ')
	ELSE
	   CALL WRITEF(' ')
	ENDIF
C
C Return
C
	RETURN
        END
