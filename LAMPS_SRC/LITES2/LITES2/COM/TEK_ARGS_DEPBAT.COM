$	ASSIGN EXE:LITES2TR.MAR TR
$	SAVDIR = f$environment("DEFAULT")
$	set def OBJ:
$	LIBR/CREATE TEK_ARGS
$	PURGE/KEEP=2 TEK_ARGS.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT TEK_ARGS
$	clites2 BITINIT TEK_ARGS
$	clites2 GTDGXY TEK_ARGS
$	clites2 RFMOVE TEK_ARGS
$	clites2 LCLSG TEK_ARGS
$	clites2 LCRSG TEK_ARGS
$	clites2 LDSG TEK_ARGS
$	clites2 LSVIS TEK_ARGS
$	clites2 SCRINIT TEK_ARGS
$	clites2 BUTINIT TEK_ARGS
$	clites2 LUWK TEK_ARGS
$	clites2 DSRINIT TEK_ARGS
$	clites2 KRSINIT TEK_ARGS
$	clites2 FOLLOW_COORD TEK_ARGS
$	clites2 NOT_SUPPORTED TEK_ARGS
$	clites2 LSALLV TEK_ARGS
$	clites2 LSALLI TEK_ARGS
$	clites2 LRSGWK TEK_ARGS
$	clites2 CLSWK TEK_ARGS
$	clites2 STDINI TEK_ARGS
$	clites2 HARCOP TEK_ARGS
$	clites2 BALINIT TEK_ARGS
$	clites2 LSCR TEK_ARGS
$	clites2 INTERACT TEK_ARGS
$	clites2 RFDRAW TEK_ARGS
$	clites2 TSTWK TEK_ARGS
$	clites2 TSTSEG TEK_ARGS
$	clites2 BOXTXT TEK_ARGS
$	clites2 RFBAND TEK_ARGS
$	clites2 INIWK TEK_ARGS
$	clites2 PING TEK_ARGS
$!                                    
$	MACRO/NOLIST LSL$LITES2_ROOT:[TEK_ARGS]TEK_ARGS_DUMMY
$	PURGE TEK_ARGS_DUMMY.OBJ
$	LIBR/REPLACE TEK_ARGS  TEK_ARGS_DUMMY
$	DELETE TEK_ARGS_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
!
