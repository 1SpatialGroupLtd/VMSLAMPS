$! MONOPLOTTING_DEMO.COM
$!
$! Created 					CCB	15-Oct-1994
$! Layout standardised 				PGH	17-Oct-1994
$!
$! Procedure for demonstration of OSGB monoplotting
$!
$! Note that this is an example template file, for the user to adapt to fit the 
$! local environment. As such, names and locations may need to be 
$! changed to avoid conflicts.
$!
$ DEFINE/USER LSL$FILL_POINTSMAX 32768	! needs doing before LITES2 starts
$ DEFINE/USER LSL$LITES2TERMINAL " "	! prevent this from running
$ DEFINE/USER THIS_DIR 'F$ELEMENT(0,"]",F$ENVIRONMENT("PROCEDURE"))']
$ DEFINE/USER LSL$UIL THIS_DIR:
$ DEFINE/USER SYS$INPUT SYS$COMMAND
$ LITES2 @THIS_DIR:M.LCM
$!
$! end of MONOPLOTTING_DEMO.COM
