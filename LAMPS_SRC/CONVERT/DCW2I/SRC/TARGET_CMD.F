	LOGICAL FUNCTION TARGET_CMD()
C
CDEC$	IDENT	'25MR97'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	22-June-1992
C
C Description:
C
C	Function to read the target directory for the IFF files
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
C
C Functions
C
	INTEGER*4	LIB$DELETE_FILE	! delete file
	INTEGER*4	LIB$GET_LUN	! get LUN for TMP file
	INTEGER*4	LIB$FREE_LUN	! free the LUN of TMP file
	LOGICAL		FILE_EXISTS	! check if dir path is valid
	LOGICAL		GETFILNAM	! read file-spec
	INTEGER*4	FLWOPN		! open file write only
	INTEGER*4	FLWCLO		! close file
C
C Local workspace
C
	INTEGER*4	TMPLUN		! working LUN
	INTEGER*4	TMPLEN		! working dir name
	CHARACTER*128   TMPNAM		! length of above
	CHARACTER*12	DEFNAM		! default directory
	INTEGER*4	OK		! success status
C
C ......................................................................
C
	TARGET_CMD=.TRUE.		! assume success
C
	DEFNAM=' '
	OK = GETFILNAM(TARGETNAM,TARGETLEN,DEFNAM(1:1),.TRUE.,%REF(' !'))
C
C Upper case the original directory
C
	CALL STR$UPCASE(TARGETNAM,TARGETNAM)
C
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
C It is only valid if it GETFILNAM parsed a directory name
C and nothing else is true.
C
	OK = (HAD_DIR.AND.
     &	     .NOT.HAD_NAM.AND.
     &	     .NOT.HAD_EXT.AND.
     &	     .NOT.HAD_VER)
C
	IF (.NOT.OK) THEN
	   TARGET_CMD = .FALSE.
	   CALL LSL_PUTMSG(DCW2I__ILLEGALDIR)
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
C Check for zero length filename
C	   
	IF (TARGETLEN.LT.1) THEN
	   TARGET_CMD = .FALSE.
	   CALL LSL_PUTMSG(LSL__SRCFILNAM)
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
C Check if directory exists by trying to open a file there but this would fail
C if a directory was read-only as well as if didn't exist. If the directory
C exists but is read-only, then we shouldn't be trying to put IFF file there
C anyway. So either way complain.
C
	TMPLEN = TARGETLEN + 7
	TMPNAM(1:TMPLEN) = TARGETNAM(1:TARGETLEN)//'TMP.DAT'
C
C Get LUN and try to open file
C
	CALL LIB$GET_LUN(TMPLUN)
	HAD_TARGET = FLWOPN(TMPLUN,TMPNAM(1:TMPLEN))
C
C And complain if not
C
	IF (.NOT.HAD_TARGET) THEN
	   CALL LSL_PUTMSG(DCW2I__BADDIR,TARGETNAM(1:TARGETLEN))
	   CALL WRITEF
	   TARGETLEN = 0
	   GOTO 50
	ELSE
	   CALL FLWCLO(TMPLUN)
	   CALL LIB$DELETE_FILE(TMPNAM(1:TMPLEN),,,,,,,,)
	ENDIF
C
C Free the LUN
C
	CALL LIB$FREE_LUN(TMPLUN)
C
C Accept name and report it
C
	CALL WRITEF ('Target directory : %S',TARGETNAM(1:TARGETLEN))
	CALL WRITEF
C
C ......................................................................
C
50	RETURN
	END
