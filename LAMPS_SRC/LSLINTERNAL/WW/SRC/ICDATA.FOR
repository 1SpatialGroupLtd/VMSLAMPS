C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1980-07-16 11:48:58.000000000 +0100
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
C--------------------------------------------
C READS IC LIBRARY FROM ICLIB.DAT
C Ouputs the library in human-readable form
C	DRG.  16 Jul 80
C---------------------------------------------
	PROGRAM ICDATA
	BYTE SLASH,NAME(10),FROM,LINE(72)
	INTEGER LENGTH
	DATA SLASH / '/' /
	DATA FROM/'<'/
	INTEGER IC(64)

	WRITE (6,601)
601	FORMAT(' IC library filename: ',$)
	READ  (5,501,END=9999,ERR=9999) LENGTH,(LINE(I),I=1,LENGTH)
501	FORMAT(Q,<LENGTH>A1)

	LINE(LENGTH+1) = 0
	OPEN (UNIT=4,NAME=LINE,TYPE='OLD',READONLY,ERR=9998)
	OPEN (UNIT=7,NAME='ICDATA.LIS')
	WRITE (7,701) (LINE(I),I=1,LENGTH)
701	FORMAT(' Contents of IC library  ',<LENGTH>A1,///)

	KPT=81
	
C	Read next IC from library

1000	DO 1001 I=1,10
1001		NAME(I) = ' '

	DO 1005 I=1,10
1002		CALL CHARZ(4,ICHAR,KPT)
		IF (ICHAR.EQ.-10) GOTO 9999
		IF (ICHAR.EQ.0) GOTO 1002
		IF (ICHAR.EQ.SLASH) GOTO 1010

		NAME (I) = ICHAR
1005	CONTINUE
	CALL CHARZ(4,ICHAR,KPT)
1010	CONTINUE

C	Found IC name. Print it.

	WRITE (7,702) NAME
702	FORMAT(' IC Type  ',10A1,///)

	IPIN = 0
500	CONTINUE

C	Here we are reading in IC which we want.

	CALL GETPIN(ICHAR,KPT,IPINVAL)
	IF (ICHAR.EQ.-10) GOTO 600
	IF (ICHAR.NE.0) GOTO 520

C	End of line
510	CALL CHARZ(4,ICHAR,KPT)
	IF (ICHAR)600,510,515
515	IF (ICHAR.NE.FROM) GOTO 600 !! no continuation
	CALL CHARZ(4,ICHAR,KPT)
	GOTO 500

520	IPIN = IPIN+1
	IF (IPIN.GT.64) CALL MOAN('too many legs on IC')
	IC(IPIN) = IPINVAL
	GOTO 500

600	CONTINUE

C	Now we have the entire IC : output it

	IHALF = IPIN/2
	IF (IHALF*2 .NE. IPIN) THEN
		IHALF=IHALF+1
		IC(IPIN+1) = 0
		WRITE(6,609) NAME
609		FORMAT(' *** IC  ',10A1,'  has an odd number of legs')
		WRITE (7,709)
709		FORMAT(' *** IC has an odd number of legs',///)
	ENDIF

	DO 700 I=1,IHALF

		DO 750 J=1,72
750			LINE(J) = ' '

		CALL PUTPIN(IC,IPIN,I,LINE,1)
		CALL PUTPIN(IC,IPIN,I+IHALF,LINE,37)

		WRITE (7,703) LINE
703		FORMAT(' ',72A1)

700	CONTINUE

	WRITE (7,704)
704	FORMAT(////)

	KPT = 0   !! has the effect of backspacing to the start of
C			the line
	IF (ICHAR.NE.-10) GOTO 1000


9999	CALL EXIT
9998	WRITE (6,602)
602	FORMAT(' File unavailable')
	END
	SUBROUTINE GETPIN(ICHAR,KPT,IPINVAL)
	BYTE  SLASH,MINUS,STAR,LTRG,LTRV
	PARAMETER PINPUT=16384,TRIST=8192
	PARAMETER VCC=32766,GND=32767,NOCHK=32765
	DATA  SLASH,MINUS,STAR,LTRG,LTRV / '/','-','*','G','V'/
	BYTE  LTR0,LTR9,DOT
	DATA  LTR0,LTR9,DOT/ '0','9','.' /
	LOGICAL INPUTPIN,TRISTATE
	INPUTPIN = .FALSE.
	TRISTATE = .FALSE.
	IPINVAL = 0

	IF (ICHAR.NE.SLASH) CALL MOAN('fault in IC library')
10	CALL CHARZ(4,ICHAR,KPT)
	IF (ICHAR.LT.1) RETURN

	IF (ICHAR.EQ.MINUS) GOTO 300
	IF (ICHAR.EQ.STAR)  GOTO 400

	IF (ICHAR.EQ.LTRV) GOTO 100
	IF (ICHAR.EQ.DOT) GOTO 150
	IF (ICHAR.EQ.LTRG) GOTO 200

	IF (ICHAR.EQ.SLASH) GOTO 900

C	Else number
	IF (ICHAR.LT.LTR0 .OR. ICHAR.GT.LTR9) CALL MOAN(
     &     'fault in IC library')
	IPINVAL = IPINVAL*10 + (ICHAR-LTR0)

	GOTO 10
900	IF (INPUTPIN.AND.TRISTATE) CALL MOAN('pin is tristate & input')
	IF (INPUTPIN) IPINVAL=IPINVAL + PINPUT
	IF (TRISTATE) IPINVAL=IPINVAL + TRIST
	RETURN

300	INPUTPIN=.TRUE.
	GOTO 10

400	TRISTATE=.TRUE.
	GOTO 10

100	IPINVAL = VCC
	GOTO 800

150	IPINVAL = NOCHK
	GOTO 800

200	IPINVAL = GND
	GOTO 800

800	CALL CHARZ(4,ICHAR,KPT)
	RETURN
	END
	SUBROUTINE PUTPIN(IC,MAXPIN,PINNO,LINE,POS)
	INTEGER IC(64),MAXPIN,PINNO,POS
	BYTE LINE(72)

	PARAMETER PINPUT=16384,TRIST=8192
	PARAMETER VCC=32766,GND=32767,NOCHK=32765

	IF (PINNO.GT.MAXPIN .OR. MAXPIN.GT.64) RETURN

	II = IC(PINNO)
	ENCODE(8,101,LINE(POS)) PINNO
101	FORMAT('Pin',I3,': ')
102	FORMAT(A20)

	IF (II.EQ.0) THEN
		ENCODE (20,102,LINE(POS+8)) 'No Connection'
	ELSE IF (II.EQ.NOCHK) THEN
		ENCODE (20,102,LINE(POS+8)) 'Undefined'
	ELSE IF (II.EQ.VCC) THEN
		ENCODE (20,102,LINE(POS+8)) '  Vcc'
	ELSE IF (II.EQ.GND) THEN
		ENCODE (20,102,LINE(POS+8)) 'Ground'
	ELSE IF ((II.AND.TRIST) .NE. 0) THEN
		ENCODE (24,103,LINE(POS+8)) II-TRIST
103		FORMAT ('Tristate, sink   ',I4,' mA')
	ELSE IF ((II.AND.PINPUT) .NE. 0) THEN
		X = II-PINPUT
		ENCODE (24,104,LINE(POS+8)) X/10.0
104		FORMAT ('Input, source   ',F5.1,' mA')
	ELSE
		ENCODE (24,105,LINE(POS+8)) II
105		FORMAT ('Output,  sink    ',I4,' mA')
	ENDIF
	END
C----------------------------------------------------
C	OBTAINS NEXT CHAR FROM INPUT STREAM
C-------------------------------------------------
	SUBROUTINE CHARZ(ISTR,I,J)
	BYTE CH(80)
	BYTE SPACE
	DATA SPACE/' '/
9	IF(J.EQ.80)GOTO 10
	IF(J.GT.80)GOTO 11
	J=J+1
	I=CH(J)
	IF(I.EQ.SPACE)GOTO 9
	RETURN

10	I = 0
	J = 81
	RETURN

11	READ(ISTR,999,END=1000)(CH(II),II=1,80)
	J=0
	GOTO 9
999	FORMAT(80A1)
1000	I = -10
	RETURN
	ENTRY ERRECH
	WRITE (6,998) CH
	WRITE (7,998) CH
998	FORMAT(' ',80A1)
	END
	SUBROUTINE MOAN(MESS)
	CHARACTER*(*) MESS
	WRITE (6,*) '***Error*** ',MESS
	WRITE (7,*) '***Error*** ',MESS
	CALL ERRECH
	RETURN
	END
