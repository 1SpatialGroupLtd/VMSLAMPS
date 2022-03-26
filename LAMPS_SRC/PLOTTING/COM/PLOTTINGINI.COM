$!
$! PLOTTINGINI.COM - Command file to set up PLOTTING foreign commands
$!
$! are we on a VAX or an AXP system ?
$!
$	LSL_ARCH_NAME==F$GETSYI("ARCH_NAME")
$	IF LSL_ARCH_NAME.EQS."Alpha"
$	THEN
$	  TVS="_TV"
$	  AXPS="_AXP"
$	ELSE
$	  TVS=""
$	  AXPS=""
$	ENDIF
$!
$ FPPAEG	== "$LSL$EXE:FPPAEG"+TVS	! AEG flatbed
$ FPPBEN	== "$LSL$EXE:FPPBEN"+TVS	! (old) Benson pen plotter
$ FPPBEN1600	== "$LSL$EXE:FPPBEN1600"+TVS	! Benson pen plotter
$ FPPBEN3000	== "$LSL$EXE:FPPBEN3000"+TVS	! Benson electrostatic
$ FPPCAL*907	== "$LSL$EXE:FPPCAL907"+TVS	! Calcomp pen plotter
$ FPPCAL925	== "$LSL$EXE:FPPCAL925"+TVS	! Calcomp offline magtape
$ FPPCAL5800	== "$LSL$EXE:FPPCAL5800"+TVS	! Calcomp electrostatic
$ FPPFER	== "$LSL$EXE:FPPFER"+TVS	! Ferranti Master Plotter
$ FPPGERB	== "$LSL$EXE:FPPGERB"+TVS	! Gerber plotter
$ FPPHCBS	== "$LSL$EXE:FPPHCBS"+TVS	! Calcomp lookalikes
$ FPPHP		== "$LSL$EXE:FPPHP"+TVS		! Hewlett-Packard plotter
$ FPPHPGL2	== "$LSL$EXE:FPPHPGL2"+TVS	! Hewlett-Packard plotter
$ FPPHRD	== "$LSL$EXE:FPPHRD"+TVS	! HRD-1 plotter
$ FPPKERNGP1	== "$LSL$EXE:FPPKERNGP1"+TVS	! KERN GP1 flatbed
$ FPPKONG	== "$LSL$EXE:FPPKONG"+TVS	! KONGSBERG magtape
$ FPPLP		== "$LSL$EXE:FPPLP"+TVS		! Laserplot plotter
$ FPPMOTIF	== "$LSL$EXE:FPPMOTIF"+TVS	! X-windows display
$ FPPPI448	== "$LSL$EXE:FPPPI448"+TVS	! Precision Image electrostatic
$ FPPPRIM	== "$LSL$EXE:FPPPRIM"+TVS	! primitive IFF file
$ FPPPOSTSCRIPT	== "$LSL$EXE:FPPPOSTSCRIPT"+TVS	! PostScript
$ FPPPS		== FPPPOSTSCRIPT		! an alias
$ FPPSIG6000	== "$LSL$EXE:FPPSIG6000"+TVS	! Sigmex display
$ FPPTEK_ARGS	== "$LSL$EXE:FPPTEK_ARGS"+TVS	! TEK DVST / Sigmex ARGS
$ FPPUIS	== "$LSL$EXE:FPPUIS"+TVS	! VAX workstation display
$ FPPVERS	== "$LSL$EXE:FPPVERS"+TVS	! Versatec plotter
$ FPPVRSC2V1	== "$LSL$EXE:FPPVRSC2V1"+TVS	! Versatec (COL2V1 library)
$ FPPVRSVGS	== "$LSL$EXE:FPPVRSVGS"+TVS	! Versatec (VGS library)
$ FPPWILD	== "$LSL$EXE:FPPWILD"+TVS	! WILD TA2 plotter
$ FPPXYNETICS	== "$LSL$EXE:FPPXYNETICS"+TVS	! Xynetics plotter
$!
$ PRIM2RASTER	== "$LSL$EXE:PRIM2RASTER"+TVS	! prim IFF to raster
$ PSEXPORT	== "$LSL$EXE:PSEXPORT"+TVS	! PostScript export
