$! Setup file for dummy Display PostScript libraries
$! Author Paul Hardy, September 2002	PGH	23-Sep-2002
$! Modified				PGH	17-Oct-2002
$!
$! Only for use of VMS 7.3 or later, without Display PostScript support
$!
$! Invoke from LSDEFNS.COM, or remove /System and call at login time.
$!
$ Define/System XDPS$DPSBINDINGSSHR LSL$LIBRARY:DPSDUMMYSHR
$ Define/System XDPS$DPSBINDINGSSHR_TV LSL$LIBRARY:DPSDUMMYSHR_TV
$ Define/System XDPS$DPSCLIENTSHR LSL$LIBRARY:DPSDUMMYSHR
$ Define/System XDPS$DPSCLIENTSHR_TV LSL$LIBRARY:DPSDUMMYSHR_TV
$ Define/System XDPS$DPSLIBSHR LSL$LIBRARY:DPSDUMMYSHR
$ Define/System XDPS$DPSLIBSHR_TV LSL$LIBRARY:DPSDUMMYSHR_TV
$!
