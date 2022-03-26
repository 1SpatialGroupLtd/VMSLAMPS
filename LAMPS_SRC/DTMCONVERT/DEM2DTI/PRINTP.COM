$ write sys$output "Printing CLD, MES and PAR files for DTMCONVERT/DEM2DTI"
$ lnp	dem2dti_cld.cld,-
	dem2dti.mes,-
	dem2dtimsg.par,-
	lun.par
