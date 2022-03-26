$! LSDEFNS_LOCAL.COM - define node-specific LSL logical names.
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Sets up node-specific logical names for LSL software.
$! This file is only used on a VAXcluster satellite, to redirect logicals
$! such as LSL$LOCAL_ROOT to a local disk. It is to be placed in the
$! node-specific system manager directory SYS$SPECIFIC:[SYSMGR] for each
$! satellite
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!
$!!!	DEASSIGN/SYSTEM LSL$LOCAL_ROOT	! to avoid message when replaced
$!!!	DEFINE/SYSTEM/TRANS=(CONCEALED,TERMINAL) LSL$LOCAL_ROOT -
$!!!		MYNODE$DKB200:[LSLLOCAL.]
$!
$	EXIT

