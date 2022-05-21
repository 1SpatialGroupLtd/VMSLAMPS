C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1980-06-24 16:38:52.000000000 +0100
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
C
C Tests the refresh and stored-mode buffering, and drawing, of
C  the TMU board.
C
C Author J.Rees
C Date 13/Jun/80
C
	REAL OX(18),OY(18)
	DATA OX/-5.0, -5.0, 10.0, 10.0, -5.0
     &		,-5.0, 0.0, 15.0, 15.0, 10.0
     &		,10.0, 15.0
     &		,0.0, 0.0, 5.0, 5.0, 0.0, 5.0/
C
	DATA OY/-10.0, 10.0, 10.0, -10.0, -10.0
     &		,10.0, 12.5, 12.5, -7.5, -10.0
     &		,10.0, 12.5
     &		,-5.0, 5.0, 5.0, -5.0, -5.0, -2.5/
C
C initialise Tek.
	CALL TKINIT(7,3)
	CALL DISMOD(1)
C
C draw an 'O' on the screen
	CALL MOVTO(OX(1),OY(1))
	  DO 200 I=2,5
	    CALL LINTO(OX(I),OY(I))
200	  CONTINUE
	CALL MOVTO(OX(6),OY(6))
	  DO 220 J=7,10
	    CALL LINTO(OX(J),OY(J))
220	  CONTINUE
	CALL MOVTO(OX(11),OY(11))
	CALL LINTO(OX(12),OY(12))
	CALL MOVTO(OX(13),OY(13))
	  DO 240 K=14,18
	    CALL LINTO(OX(K),OY(K))
240	  CONTINUE
	CALL REFRSH
	CALL LDCMPL
C
	CALL EXIT
	END
