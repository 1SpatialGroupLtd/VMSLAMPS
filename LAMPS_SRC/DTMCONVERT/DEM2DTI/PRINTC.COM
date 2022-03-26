$ write sys$output "Printing common block files for DTMCONVERT/DEM2DTI"
$ lnp	commands.cmn,-
	dema.cmn,-
	demb.cmn,-
	dti.cmn,-
	file.cmn
