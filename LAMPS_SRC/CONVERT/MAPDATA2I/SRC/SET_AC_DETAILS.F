	INTEGER*4 FUNCTION SET_AC_DETAILS()
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Set up AC codes and names
C
C Description
C
C	Sets up the codes and names for ACs whose associated qualifier was
C	present on the command line, or whose keyword was present in the
C	parameter file. For each AC type, either the code or name is found,
C	depending on what was specified on the command line or in the
C	parameter file.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE 'CMN:FILE.CMN'			! control variables
C
C Functions called
C
	INTEGER*4	GET_AC_CODE		! get AC code from name
	INTEGER*4	GET_AC_NAME		! get AC name from code
C
C------------------------------------------------------------------------------
C Assume success
C
	SET_AC_DETAILS = LSL__NORMAL
C
C Deal with the AC details for curve flags
C
	IF ( HAD_CURVE_AC ) THEN		! if had qualifier or keyword,
C
	   IF ( CURVE_AC_CODE.LT.0 ) THEN	! and if with the AC name,
	      IF (.NOT. GET_AC_CODE( 		! get the AC code
     &		  CURVE_AC_CODE,CURVE_AC_NAME(1:CURVE_AC_LEN) )) THEN
		 IF (.NOT. HAD_FRT) CALL LSL_ADDMSG(MD2I__NOFRT)
		 GOTO 9999
	      ENDIF
C
	   ELSEIF ( HAD_FRT .OR. CURVE_AC_CODE.LT.100 ) THEN	! otherwise
	      IF (.NOT. GET_AC_NAME( 		! get the AC name if possible
     &		  CURVE_AC_NAME,CURVE_AC_LEN,CURVE_AC_CODE )) GOTO 9999
	   ENDIF
C
	ENDIF
C
C Deal with the AC details for priority flags
C
	IF ( HAD_PRIO_AC ) THEN			! if had qualifier or keyword,
C
	   IF ( PRIO_AC_CODE.LT.0 ) THEN	! and if with the AC name,
	      IF (.NOT. GET_AC_CODE( 		! get the AC code
     &		  PRIO_AC_CODE,PRIO_AC_NAME(1:PRIO_AC_LEN) )) THEN
		 IF (.NOT. HAD_FRT) CALL LSL_ADDMSG(MD2I__NOFRT)
		 GOTO 9999
	      ENDIF
C
	   ELSEIF ( HAD_FRT .OR. PRIO_AC_CODE.LT.100 ) THEN	! otherwise
	      IF (.NOT. GET_AC_NAME( 		! get the AC name if possible
     &		  PRIO_AC_NAME,PRIO_AC_LEN,PRIO_AC_CODE )) GOTO 9999
	   ENDIF
C
	ENDIF
C
C Deal with the AC details for text flags
C
	IF ( HAD_TEXT_AC ) THEN			! if had qualifier or keyword,
C
	   IF ( TEXT_AC_CODE.LT.0 ) THEN	! and if with the AC name,
	      IF (.NOT. GET_AC_CODE( 		! get the AC code
     &		  TEXT_AC_CODE,TEXT_AC_NAME(1:TEXT_AC_LEN) )) THEN
		 IF (.NOT. HAD_FRT) CALL LSL_ADDMSG(MD2I__NOFRT)
		 GOTO 9999
	      ENDIF
C
	   ELSEIF ( HAD_FRT .OR. TEXT_AC_CODE.LT.100 ) THEN	! otherwise
	      IF (.NOT. GET_AC_NAME( 		! get the AC name if possible
     &		  TEXT_AC_NAME,TEXT_AC_LEN,TEXT_AC_CODE )) GOTO 9999
	   ENDIF
C
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	SET_AC_DETAILS = LSL_STATUS
C
C------------------------------------------------------------------------------
C Return
C
10000	RETURN
	END
