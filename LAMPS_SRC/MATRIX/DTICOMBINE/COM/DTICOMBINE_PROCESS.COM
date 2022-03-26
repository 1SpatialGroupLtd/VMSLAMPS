$! FILE: DTICOMBINE_PROCESS.COM
$!
$! *** This command file takes the input DTI file ORIGINAL.DTI, which has a
$! *** Matrix range of 0 - 360 and produces a draughtsmans idea of hill 
$! *** Shading.
$! 
$! *** It is done by using DTICOMBINE in the matrix package
$!
$! *** Initialise matrix
$!
$	ws :== "write sys$output"
$	@lsl$com:matrixini
$!
$! *** Run DTICOMBINE to produce a file with values less than 180 = 0 and 
$! *** Values greater than 180 = 180
$!
$	ws " "
$	ws "*** Run DTICOMBINE to produce a file with values less than 180 = 0"
$	ws "*** And values greater than 180 = 180"
$	ws " "
$!
$	dticombine
		filea here:original
		fileout here:up180
		ena class
		class 180
		include >= 180
		class 0
		include <= 179
		word = a * 1
	go
$!
$! *** Run DTICOMBINE to produce a file with values less than 180 = 1 and 
$! *** Values greater than 180 = 0
$!
$	ws  " "
$	ws "*** Run DTICOMBINE to produce a file with values less than 180 = 1"
$	ws "*** And values greater than 180 = 0"
$	ws  " "
$!
$	dticombine
		filea here:original
		fileout here:down180
		ena class
		class 1
		include <= 179
		class 0
		include >= 180
		word = a * 1
	go
$!
$! *** Run DTICOMBINE to produce a file that takes the original and multiplies
$! *** It with down180 and then adds the result to up180
$!
$	ws " "
$	ws "*** Run DTICOMBINE to produce a file that takes the original and"
$	ws "*** Multiplies it with down180 and then adds the result to up180"
$	ws " "
$!
$	dticombine
		filea here:original
		fileb here:up180
		filec here:down180
		fileout here:result
		word = ( a * c ) + b
	go
$!
$	delete/nocon here:up180.dti;*
$	delete/nocon here:down180.dti;*
$	purge/nolog here:*.dti
$	ws " "
$	ws "*** Job complete, you can now use LITES2 @HERE:ORIGINAL to view "
$	ws "*** The original file, and LITES2 @HERE:RESULT to view the results"
$	ws " "
$	ws " "
$!
$!
$! *** The End
