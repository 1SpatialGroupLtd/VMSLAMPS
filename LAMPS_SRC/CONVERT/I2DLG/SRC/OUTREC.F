        INTEGER*4  FUNCTION OUTREC(FINAL)
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Laboratories Ltd., Cambridge, England
C
C Created.					  FJB  23-Aug-1989
C
C Assembles and then writes a block of data to mag tape
C
	IMPLICIT NONE
C
C Parameters:                                          
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
  	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C Common:
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'
  	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
  	INCLUDE 'LSL$CMNI2DLG:MAGBUF.CMN'
C
C Workspace:
	LOGICAL		FINAL		! .TRUE. if last record output
					! ie flush buffers
C
C Functions:
	INTEGER*4	MTOWRB
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C ....................................................................
C
C Assume the best
	OUTREC=%LOC(SS$_NORMAL)
C
	IF(HAD_LIST)THEN
C
C  same layout as the USGS Data Users Guide
	   CALL WRITEF('%S72',OUTSTR(1:72))
	   CALL WRITEF('%S72',OUTSTR(73:144))
	ENDIF
C
	IF (IS_TAPE) THEN
	   BLKSIZ = BLKPTR-1+RECSIZ
	   WRITE(OUTBLK(BLKPTR:BLKSIZ),10) OUTSTR
   10	   FORMAT(A)
	   BLKPTR=BLKPTR+RECSIZ
	   IF ((BLKPTR.GE.BLK_LEN).OR.FINAL) THEN
	      OUTREC=MTOWRB(%REF(OUTBLK),BLKSIZ)
	      IF (.NOT. OUTREC) THEN
		 CALL LSL_PUTMSG(I2DLG__MTBLK)
	         CALL LSL_ADDMSG(OUTREC)
	         IF (MTOERR.NE.0) THEN
	            CALL LSL_ADDMSG(MTOERR)
		 ENDIF
	         OUTREC=I2DLG__MTBLK
	         GOTO 20
	      ENDIF
C
C reset output block buffer
C
	      BLKPTR=1
	      OUTBLK=' '
	   ENDIF
	ELSE
	   WRITE (DLGLUN,2000) OUTSTR(:RECSIZ)
2000	   FORMAT(A)
	ENDIF
C
C reset output record buffer
C
	OUTSTR=' '
C
C ......................................................................
C
20	IF (OUTREC) OUTREC=%LOC(SS$_NORMAL)
	RETURN
C
C ......................................................................
C
	END
