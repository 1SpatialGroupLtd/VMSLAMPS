$ ver = f$verify(0)
$ set verify
$ MACRO IFFVEC
$ MACRO IFFGLOB
$ LINK/SHARE/EXE=IFFSHR/MAP=IFFSHR/FULL SYS$INPUT:/OPT
!
! Place the transfer vector first in its own cluster
cluster=TRANSFER,,,IFFVEC.OBJ
!
! Then a cluster into which public common blocks are collected
collect=CMNPUB,IFFHAN,IFFJUN,IFFSTR
universal=IFFHAN
universal=IFFJUN
universal=IFFSTR
!
! Allow the rest to go into the default cluster
IFFGLOB.OBJ
LSL$LIBRARY:IFFLIB/lib
LSL$LIBRARY:LSLLIB/lib
!
! The LSLLIB shareable image is required for the IFF utility routines
LSL$LSLSHR/share
!
! Set the global section match parameters (major id., minor id.)
! If the major id. is incremented, then programs linked with the old
! version of IFFSHR will not be able to use the new version - this
! should be done if the new version is incompatible with the old.
! If the minor id. is incremented, then programs linked with the old
! version of IFFSHR will still be able to use the new version, but
! not vice-versa - this should be done if an upwards compatible change
! has been made, such as the addition of a new routine, or the addition
! of extra optional arguments to existing routines.
! For changes which are simply bug fixes, the parameters should not be
! changed.
gsmatch=lequal,1,1
!
! Set all the common blocks to be non-shareable
! The public ones are aligned long since Fortran started to default
! to quad, which caused IFFSTR to move.
psect_attr=IFFCB,noshr
psect_attr=IFFHAN,noshr,long
psect_attr=IFFJUN,noshr,long
psect_attr=IFFPVT,noshr
psect_attr=IFFSTR,noshr,long
psect_attr=IFFWS,noshr
psect_attr=LSL_FNAM_LEN,noshr
psect_attr=LSL_FNAM_LOG,noshr
psect_attr=LSL_FNAM_STR,noshr
$ purge/log
$!
$! 'f$verify(ver)
