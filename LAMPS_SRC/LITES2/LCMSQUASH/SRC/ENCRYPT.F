	SUBROUTINE ENCRYPT(KEY,STRING)
C
CDEC$	IDENT	'03JN94'
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author: Clarke Brunt, 25 May 1994
C
C To encrypt/decrypt a string
C Must match routine in LITES2
C
C Only characters in the range 32-126 are encrypted - others are
C left unchanged.
C
	IMPLICIT NONE
C
C arguments
	CHARACTER*(*)	KEY	! NB modified by this routine
	CHARACTER*(*)	STRING	! NB modified by this routine
C
C workspace
	INTEGER	I
	INTEGER	ICH
	INTEGER	K,KC
C
	K = 0
C
	DO 10 I=1,LEN(STRING)
C
C select next character of key KC, and modify it by adding an odd number
C (1,3,5...) according to position in string
C
	   K = K+1
	   IF (K.GT.LEN(KEY)) K=1
	   KC = ICHAR(KEY(K:K))
	   KC = (KC+2*I-1) .AND. 255
	   KEY(K:K) = CHAR(KC)
C
C get next character of string ICH, and change to KC-ICH, always keeping
C it within 32-126, unless outside that range to start with
C
	   ICH = ICHAR(STRING(I:I))
	   IF (ICH.GE.32.AND.ICH.LE.126) THEN
	      ICH = ICH-32		! now in 0-94
	      ICH = MOD( KC-ICH, 95 )
	      IF (ICH.LT.0) ICH = ICH+95
	      ICH = ICH+32
	      STRING(I:I) = CHAR(ICH)
	   ENDIF
10	CONTINUE
C
	RETURN
	END
