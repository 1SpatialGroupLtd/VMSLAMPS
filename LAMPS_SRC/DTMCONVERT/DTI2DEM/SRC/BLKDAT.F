C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-25 11:50:28.000000000 +0100
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
	BLOCK DATA BLKDAT
C
CDEC$	IDENT	'19OC89'
C
C	Copyright 			Laser-Scan Ltd., Cambridge, England.
C
C Presetting all the common blocks
C
	IMPLICIT NONE
C
C get the common blocks we are to preset
C
	INCLUDE 'LSL$DTI2DEM:DEMA.CMN'		! data for 1st DEM record
	INCLUDE 'LSL$DTI2DEM:GENERAL.CMN'	! general data
C
C preset /DEMA/
C
	DATA DEMNAM/'UNKNOWN'/	! hope that we get something better
	DATA DEMNAML/7/
	DATA DEMLEVEL/1/	! always produce RAW data
	DATA DEMPATT/1/		! always produce a regular DEM
	DATA DEMREF/1/		! always UTM
	DATA DEMTCONSTS/15*0.0D0/! not used for UTM
	DATA DEMXYUN/2/		! xy units - assume metres
	DATA DEMZUN/2/		! z units  - assume metres
	DATA DEMPOL/4/		! number of sides in map - always 4
	DATA DEMDIR/0.0D0/	! profile direction - DTI is already NS
	DATA DEMACC/0/		! there is no accuracy record
	DATA DEMDELX/30.0/	! grid interval in X
	DATA DEMDELY/30.0/	! and in Y
	DATA DEMDELZ/1.0/	! and in Z
	DATA DEMNCOL(1)/1/	! DEMCOL(2) will be computed
C
C preset /GENERAL/
C
	DATA INLUN,OUTLUN/1,2/
	DATA INOP,OUTOP/2*.FALSE./
	DATA FSTCOL,LSTCOL/2*-32768/
	DATA BLKSIZ,BLKPTR/4096,1/
	DATA OUTSTR,OUTBLK/2*' '/	
	DATA HEADER_NAMES/'MIKE','UHL1','TED4','ALVY','LSLA'/
C
	END
