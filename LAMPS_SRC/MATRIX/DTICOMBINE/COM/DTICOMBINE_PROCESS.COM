$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-06-19 14:27:14.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
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
