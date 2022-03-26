$!CMOD  5-Nov-1993					R.W. Russell
$!	Include new common blocks in gctplib, used to speed up transformation
$!	Include gctp_cf_proj
$!CMOD  5-Jul-1995					T.J. Mulcahy
$!	Include new common blocks WORK29$0, WORK29$1
$!
$	adc gctp = lsl$cmniff:md2dat
$	fort/nolist gctp
$	pvv gctp
$	delete	adc.ide;*,gctp.for;*
$	purge/nolog gctp.obj
$	link/share/exe=lites2geogshr-
	    /map=lites2geogshr/full sys$input:/opt
gctp,-
lsl$library:gctplib/include=(gctp_trans,gctp_parinit,-
                             gctp_print,gtrnerr,gctp_cf_proj)/lib
!
UNIVERSAL = gctp_trans
UNIVERSAL = gctp_parinit
UNIVERSAL = gctp_print
UNIVERSAL = gtrnerr
UNIVERSAL = gctp_cf_proj
!
psect_attr=AXES,noshr
psect_attr=ELLP,noshr
psect_attr=ERRM,noshr
psect_attr=MD2DES,noshr
psect_attr=MD2NAM,noshr
psect_attr=MD2NAMC,noshr
psect_attr=PRIN,noshr
psect_attr=PROJ,noshr
psect_attr=SPHR,noshr
psect_attr=SW09F,noshr
psect_attr=SW09I,noshr
psect_attr=SW21F,noshr
psect_attr=SW21I,noshr
psect_attr=SW22F,noshr
psect_attr=SW22I,noshr
psect_attr=SW24F,noshr
psect_attr=SW24I,noshr
psect_attr=SW25F,noshr
psect_attr=SW25I,noshr
psect_attr=SW26F,noshr
psect_attr=SW26I,noshr
psect_attr=SW27F,noshr
psect_attr=SW27I,noshr
psect_attr=SW28F,noshr
psect_attr=SW28I,noshr
psect_attr=WRK0,noshr
psect_attr=WRK1,noshr
psect_attr=WRK1A,noshr
psect_attr=WRK21F,noshr
psect_attr=WRK21I,noshr
psect_attr=WRK22F,noshr
psect_attr=WRK24F,noshr
psect_attr=WRK24I,noshr
psect_attr=WRK25F,noshr
psect_attr=WRK25I,noshr
psect_attr=WRK26F,noshr
psect_attr=WRK26I,noshr
psect_attr=WRK27F,noshr
psect_attr=WRK27I,noshr
psect_attr=WRK28F,noshr
psect_attr=WRK28I,noshr
psect_attr=WRK29F,noshr
psect_attr=WRK29I,noshr
$ purge lites2geogshr.map,lites2geogshr.exe
$ delete gctp.obj;*
