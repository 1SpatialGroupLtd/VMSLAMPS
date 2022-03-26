	INTEGER*4 FUNCTION WRITE_DIGIT_TO_TAPE()
C
CDEC$	IDENT	'12DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	12-Dec-1991
C
C Description:
C       The DIGIT file has now been written to disk and close. It must
C       therefore be re-opened for read, copied block by block to tape and
C       have various header fields patched in. An End-of-Volume (two tapemarks)
C       marker is written and the file closed. The temporary file is deleted.
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! Needed for FILES.CMN
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'		! Needed for MTOERR
	INCLUDE 'FILES.CMN'			! File LUNs, etc
	INCLUDE 'COMMANDS.CMN'			! Command line switches
	INCLUDE	'GENERAL.CMN'			! General stuff
	INCLUDE 'CODES.CMN'
C
C Functions
C
	INTEGER*4	FLROPB			! open file for block write
	INTEGER*4	FLRCLO			! close file
	INTEGER*4	FLRBLK			! block read
	INTEGER*4	MTOWRB			! block write 
	INTEGER*4	MTOEOF			! write tapemark
C
C Local Variables
C
	INTEGER*2	N,I,J
	INTEGER*2	SECTOR_COUNT
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
C
	BYTE		TAPEBUFFER(TAPEBUFSIZE)	! tape buffer
C
	EQUIVALENCE	(DISKBLOCK,TAPEBUFFER)	! fill it via DISKBLOCK
C
C------------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
C Open TMP file for block read
C
	TMP_OPEN = FLROPB(TMPLUN,TMPFILE(1:TMPLEN),IERR)
	IF (.NOT.TMP_OPEN) THEN
	   STATUS = I2DIGIT__ERRREOPNTMP
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
	IF (HAD_LOG) CALL WRITEF('Writing DIGIT to tape...')
C
C Read block back off disk and write to tape. For first block, we must insert
C file and partition sizes. It would be quicker not to read back from tape if
C the number of blocks is only 1 (since the buffer contains the whole file) but
C lets just keep the code tidy for now.
C
	DO 250 J = 1,NUMBLOCKS
	   DO 200 I = 1,DISKBLOCKNUM
	      STATUS = FLRBLK(0,DISKBLOCK(1,I))
	      IF (.NOT.STATUS) THEN
		 STATUS = I2DIGIT__ERRREADTMP
		 CALL LSL_PUTMSG(STATUS)
		 GOTO 999
	      ENDIF
200	   CONTINUE
C
C For first block, we need to insert the sector lengths into the header
C
	   IF (J.EQ.1) CALL PATCH_HEADER()
C
C Write a full block to tape
C
	   STATUS = MTOWRB(TAPEBUFFER,TAPEBUFSIZE)
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG(I2DIGIT__ERRWRTTAPE)
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      GOTO 900
	   ENDIF
250	CONTINUE
C
C Write two tapemarks
C
	STATUS = MTOEOF()
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERRWRTTAPEMK)
	   IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	   GOTO 900
	ENDIF
	STATUS = MTOEOF()
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERRWRTTAPEMK)
	   IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	   GOTO 900
	ENDIF
C
C Close TMP disk file.
C
900	IF (TMP_OPEN) THEN
	   OK = FLRCLO(TMPLUN,IERR)
	   IF (OK) THEN
	      TMP_OPEN = .FALSE.
	   ELSE
	      STATUS = I2DIGIT__ERRCLOTMP
	      CALL LSL_PUTMSG(STATUS)
	      CALL LSL_ADDMSG(OK)
	      IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	   ENDIF
	ENDIF
C
C There is no LSLLIB routine to delete a file opened for read. (only write)
C We must therefore use LIB$DELETE_FILE.
C
	CALL LIB$DELETE_FILE(TMPFILE(1:TMPLEN)//';*')
C
	IF (STATUS) CALL WRITEF('Operation successfully completed.')
C
999	WRITE_DIGIT_TO_TAPE = STATUS
C
	RETURN
	END
