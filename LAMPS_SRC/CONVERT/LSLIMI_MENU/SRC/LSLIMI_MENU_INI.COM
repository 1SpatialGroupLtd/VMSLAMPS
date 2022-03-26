$!
$! LSLIMI_MENU_INI.COM - a command file to set up some menu options for the 
$!			 DEC/British Gas OSTF/NTF to INFORMAP transfer demo
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author R J Hulme, 6 October 1988
$!
$! Modifications
$! ............................................................................
$! 24-Oct-1988	R J Hulme (Laser-Scan Labs)
$! renamed from IMENU_INI.COM
$! ............................................................................
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! values used in managing our input/output
$!
$	IMENU$v_drive           == "MUA0:"	! tape drive name
$	IMENU$v_file		== "TEST"	! file name
$	IMENU$v_is_tape         == "FALSE"	! don't use tape drive
$	IMENU$v_schema          == "DEMO"	! schema name
$!
$! INITIAL value for parameter file
$!
$ 	IMENU$v_params          == "DEMO"	! parameter file
$!
$! and some NTF specific values
$!
$	IMENU$v_ntf_recipient	== "Laser-Scan Labs"	! to whom the data goes
$	IMENU$v_ntf_donor	== "Laser-Scan Labs"	! NTF donor - ourselves
$!
