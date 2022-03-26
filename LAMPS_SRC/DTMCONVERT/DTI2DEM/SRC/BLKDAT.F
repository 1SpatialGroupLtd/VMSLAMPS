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
