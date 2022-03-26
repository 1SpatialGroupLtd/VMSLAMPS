$	ASSIGN EXE:LITES2TR.MAR TR
$	SAVDIR = f$environment("DEFAULT")
$	set def OBJ:
$	LIBR/CREATE MOTIF
$	PURGE/KEEP=2 MOTIF.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT MOTIF
$	clites2 BITINIT MOTIF
$	clites2 GTDGXY MOTIF
$	clites2 CTRLCAST MOTIF
$	clites2 LCLSG MOTIF
$	clites2 LCRSG MOTIF
$	clites2 LDSG MOTIF
$	clites2 LSVIS MOTIF
$	clites2 SCRINIT MOTIF
$	clites2 LSALLV MOTIF
$	clites2 LSALLI MOTIF
$	clites2 LRSGWK MOTIF
$	clites2 CLSWK MOTIF
$	clites2 DSRINIT MOTIF
$	clites2 KRSINIT MOTIF
$	clites2 SAVDIS MOTIF
$	clites2 SAVLUT MOTIF
$	clites2 FOLLOW_COORD MOTIF
$	clites2 DISPLAY MOTIF
$	clites2 VIEW MOTIF
$	clites2 DOSPAW MOTIF
$	clites2 PLOT MOTIF
$	clites2 ABORTAST MOTIF
$	clites2 STDINI MOTIF
$	clites2 HARCOP MOTIF
$	clites2 BALINIT MOTIF
$	clites2 MOUSE MOTIF
$	clites2 BUTINIT MOTIF
$	clites2 BUTTONS MOTIF
$	clites2 LUWK MOTIF
$	clites2 LITSRI MOTIF
$	clites2 INTERACT MOTIF
$	clites2 RFDRAW MOTIF
$	clites2 TSTWK MOTIF
$	clites2 TSTSEG MOTIF
$	clites2 PICT MOTIF
$	clites2 BOXTXT MOTIF
$	clites2 INIWK MOTIF
$	clites2 PING MOTIF
$	clites2 LSCR MOTIF
$	clites2 RFMOVE MOTIF
$!
$	MACRO/NOLIST LSL$LITES2_ROOT:[MOTIF]MOTIF_DUMMY
$	PURGE MOTIF_DUMMY.OBJ
$	LIBR/REPLACE MOTIF  MOTIF_DUMMY
$	DELETE MOTIF_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
