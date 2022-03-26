$ write sys$output "Printing source files for DTMCONVERT/DEM2DTI"
$ lnp 	dem2dti.f,-
	obey.f,-
	open_files.f,-
	dem_off.f,-
	dem_scan.f,-
	read_reca.f,-
	read_recb.f,-
	write_dti.f,-
	close_files.f	
