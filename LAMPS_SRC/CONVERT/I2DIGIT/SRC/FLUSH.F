	SUBROUTINE FLUSH
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Flushes the contents of the DISKBLOCK buffer to disk each 
C       time it is filled and resets the pointer to the beginning.
C
        IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE	'COMMANDS.CMN'			! Command line switches
	INCLUDE	'GENERAL.CMN'			! General stuff
	INCLUDE	'FILES.CMN'			! File LUNs
C
C Function calls
C
	INTEGER*4	FLWSEL		! select disk file for write
	INTEGER*4	FLWBLK		! write line to disk file
C
C Local Variables
C
	INTEGER*4	STATUS
	INTEGER*4	I,J,K
C
C------------------------------------------------------------------------------
C
C	   DO 100 K = 1,DISKBLOCKNUM
C	      DO 150 J = 1,DISKBLOCKSIZE,8
C		 CALL WRITEF('%^W%I6%I6%I6%I6%I6%I6%I6%I6',
C     &		      DISKBLOCK(J,K),DISKBLOCK(J+1,K),DISKBLOCK(J+2,K),
C     &		      DISKBLOCK(J+3,K),DISKBLOCK(J+4,K),DISKBLOCK(J+5,K),
C     &		      DISKBLOCK(J+6,K),DISKBLOCK(J+7,K))
C150	      CONTINUE
C100	   CONTINUE
C
	STATUS = FLWSEL(TMPLUN)
	IF (.NOT.STATUS) THEN
	   STATUS = I2DIGIT__ERRSELTMP
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
	DO 200 I = 1,DISKBLOCKNUM
	   STATUS = FLWBLK(0,DISKBLOCK(1,I))
	   IF (.NOT.STATUS) THEN
	      STATUS = I2DIGIT__ERRWRITETMP
	      CALL WRITEF(STATUS)
	      GOTO 999
	   ENDIF
200	CONTINUE
C
	CALL IFFSEL(IFFLUN)
C
C Adjust pointers
C
	NUMBLOCKS = NUMBLOCKS + 1
	TOTBUFSIZE = TOTBUFSIZE + DISKBUFPTR - 1
	DISKBUFPTR = 1
C
999	RETURN
	END
