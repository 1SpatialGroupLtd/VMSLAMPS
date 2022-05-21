C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-06-26 13:49:02.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	SUBROUTINE USRRET(CNDFLG,RTSTRL,RTSTR,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example user routine
C
        IMPLICIT NONE
C
C Arguments
C
	LOGICAL		CNDFLG		! LITES2 conditional flag
	INTEGER*4	RTSTRL		!  input: maximum size of RTSTR
					! output: size of RTSTR
	CHARACTER*(*)	RTSTR		! LITES2 command line, to be 
					! executed before any other
					! command
	INTEGER*4	RETCOD		! return code
					! = 0 for abort
					! = 1 for CNDFLG to be set
					!     and command to be executed
					! = 2 for call USRDO again
					! = 3 for call USRDEF, then call
					!     USRRET again
					! = 4 for call USRANO, then call
					!     USRRET again
					! = 5 for call USRDRW, then call
					!     USRRET again
C
C working storage
C
	INCLUDE	'USRKEEP.CMN'
C
C
	CHARACTER*(*)	ROUTINE
	PARAMETER	(ROUTINE = 'ROUTINE 1')
C
	LOGICAL		TMP
	CHARACTER*1	ANS
	INTEGER*4	I
C
	GOTO (9000,9000,9000,9000,9000,600,700,700,900,1000,1100) USR_ACTION
	GOTO 9000
C
C allowing condition flag to be set
C C/R means don't change CNDFLG
C
  600	CONTINUE
  610	CONTINUE
	PRINT 620
  620	FORMAT(/'$Enter new value (F/T):- ')
	READ(*,630,ERR=610),I,TMP
  630	FORMAT(Q,L)
	IF (I.EQ.1) THEN
	   CNDFLG=TMP
	ELSEIF (I.GT.1) THEN
	   GOTO 610
	ENDIF	   
	RETCOD=1
	GOTO 9999
C
C have just constructed a feature, don't do anything else
C
  700	CONTINUE
	RETCOD=0
	GOTO 9999
C
C send a command line to LITES2.
C
  900	CONTINUE
	PRINT 910
  910	FORMAT(/'$Enter required command:- ')
	ACCEPT 920,RTSTR
  920	FORMAT(A255)
	RETCOD=1
	GOTO 9999
C
C create several features
 1000	CONTINUE
C
C if we do not have window yet, call this command again to get
C the window
	IF (.NOT.GOT_WIN) THEN
	   RTSTR = '%ENABLE SUBSTITUTION#'//ROUTINE//
     &	           ' 10 ''$WINDOW 1 ''$WINDOW 2 ''$WINDOW 3 ''$WINDOW 4'
	   RETCOD = 1
C
	ELSE
	   NEW_FEAT_COUNT = NEW_FEAT_COUNT + 1
	   IF (NEW_FEAT_COUNT .GE.NEW_FEAT) THEN
	      RETCOD = 0		! finished
	   ELSE
	      RETCOD = 2		! call USDO again.
	   ENDIF
	ENDIF
	GOTO 9999
C
C set a specified variable
1100	CONTINUE
	PRINT 1120
1120	FORMAT(/'$Do you want to alter a variable (Y/N):- ')
	READ(*,1130,ERR=1100),I,ANS
1130	FORMAT(Q,A1)
	IF (I.EQ.1) THEN
	   CALL STR$UPCASE(ANS,ANS)
	   IF (ANS.EQ.'Y') THEN
	      RETCOD = 3
	      GOTO 9999
	   ELSE
	      GOTO 900			! ask for command to return
	   ENDIF
	ELSEIF (I.GT.1) THEN
	   GOTO 1100
	ENDIF	   
C
	RETCOD = 3
	GOTO 9999		! default
C
C invalid action
C
 9000	CONTINUE
	PRINT 9010,USR_ACTION
 9010	FORMAT(' Unknown action',I6,' for user routine USRRET'//
     &	       ' User routine being aborted'/)
C
	RETCOD=0
C
 9999	CONTINUE
	RETURN
	END
