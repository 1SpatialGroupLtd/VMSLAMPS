$!	ELEMENT_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWS Reid	6th October 1988
$!
$!	An example element command file.
$!
$! Set up filename symbols required for the procedure. These are 
$! created from job-wide symbols set up in the job command file.
$!
$	DIG_IFF == DF_POINT_PREFIX + DFAD_FILE + DF_POINT_SUFFIX
$	RAW_IFF  == DIG_IFF + DF_RAW_PLA_SUFFIX 
$	ISTART_TEMP == DF_WORK_PREFIX + DFAD_FILE + DF_RAW_PLA_SUFFIX + DF_POINT_SUFFIX
$	LTRAK = ""
$	LAY_NUM = 3
$!
$! Execute procedure command procedure
$!
$ 	@'FLN_PROCEDURE_COMPROC'
$!
$! Exit
$!
