$ ver = f$verify(0)
$ debug = ""
$ if p1.eqs."D" then debug="/DEBUG"
$ set verify
$ MACRO FRTVEC
$ MACRO FRTGLOB
$ LINK'debug'/SHARE/EXE=FRTSHR/MAP=FRTSHR/FULL SYS$INPUT:/OPT,-
				LSL$LIBRARY:IFFSHR/OPT,-
				LSL$LIBRARY:LSLSHR/OPT
!
! allow demand-zero compression in shareable image
unsupported=1
!
! Place the transfer vector first in its own cluster
cluster=TRANSFER,,,FRTVEC.OBJ
!
! Then a cluster into which public common blocks are collected
cluster=CMNPUB
collect=CMNPUB,FRTACD,FRTACDC,FRTCOM,FRTFIL,FRTGRP,FRTPAT,FRTPRIO,FRTSCT,-
	FRTSRI,FRTTRI,PATDEF,SRISCL,TRIEXT
!
! and another cluster for the vector of graphics routine addresses
cluster=SRIVEC
collect=SRIVEC,SRIVEC
!
! Make universal our symbols from FRTGLOB
universal=FRTACD,FRTACDC,FRTCOM,FRTFIL,FRTGRP,FRTPAT,FRTPRIO,FRTSCT,-
	FRTSRI,FRTTRI,PATDEF,SRISCL,TRIEXT
universal=SRIVEC
!
! Allow the rest to go into the default cluster
frtglob.obj
lsl$library:lslfrtlib/lib
!
! Set the global section match parameters (major id., minor id.)
! If the major id. is incremented, then programs linked with the old
! version of FRTSHR will not be able to use the new version - this
! should be done if the new version is incompatible with the old.
! If the minor id. is incremented, then programs linked with the old
! version of FRTSHR will still be able to use the new version, but
! not vice-versa - this should be done if an upwards compatible change
! has been made, such as the addition of a new routine, or the addition
! of extra optional arguments to existing routines.
! For changes which are simply bug fixes, the parameters should not be
! changed.
gsmatch=lequal,1,5
!
! Set all the common blocks to be non-shareable
psect_attr=CF_SIDE_CMN2,noshr
psect_attr=FFABUF,noshr
psect_attr=FRTACD,noshr
psect_attr=FRTACDC,noshr
psect_attr=FRTACD_P,noshr
psect_attr=FRTCOM,noshr
psect_attr=FRTFIL,noshr
psect_attr=FRTGRP,noshr
psect_attr=FRTPAT,noshr
psect_attr=FRTPRIO,noshr
psect_attr=FRTSCT,noshr
psect_attr=FRTSRI,noshr
psect_attr=FRTTMP,noshr
psect_attr=FRTTRI,noshr
psect_attr=FRTTRI_P,noshr
psect_attr=FRTWORK,noshr
psect_attr=PATDEF,noshr
psect_attr=SRIBFC,noshr
psect_attr=SRISCL,noshr
psect_attr=TRIEXT,noshr
$ purge/log
$!
$! 'f$verify(ver)
