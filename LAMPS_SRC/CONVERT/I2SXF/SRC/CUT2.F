C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-06-19 10:06:32.000000000 +0100
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
	IF (PLUS) THEN
	   CALL IFS_CB_READ(CBH,CBD,ZBUF,1,CODE_Z,1,STPTR)
	   CALL IFS_CB_READ(CBH,CBD,DZBUF,1,CODE_DZ,1,STPTR)
	   CALL IFS_CB_READ(CBH,CBD,CXYBUF,1,CODE_CAPXY,1,STPTR)
	   CALL IFS_CB_READ(CBH,CBD,CZBUF,1,CODE_CAPZ,1,STPTR)
	ELSEIF (.NOT. (SIMPLE_XY .OR. CHUCKED_OUT)) THEN
	   CALL LSL_PUTMSG(I2OSTF__CHUCKED)
	   CHUCKED_OUT = .TRUE.
	ENDIF
C
C remember the first point of the feature (for texts and symbols)
C
	IF (NEWF) THEN
	   SAV_X     = STBUF(1,1)
	   SAV_Y     = STBUF(2,1)
	   SAV_Z     = ZBUF(1)
	   SAV_DZ    = DZBUF(1)
	   SAV_CAPXY = CXYBUF(1)
	   SAV_CAPZ  = CZBUF(1)
	ENDIF
C
