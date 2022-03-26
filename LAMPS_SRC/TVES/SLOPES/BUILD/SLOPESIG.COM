$	link/exe=slopesig  SLOPES,OPNFIL,GRADIENT,DTIHGT,-
			TABS,SHDRAW,SHADES,ICOL,SLPCMD,LUTSET,-
			lsl$library:tablib/lib,- 
			lsl$disk:[tves.vssiglib]vssiglib/lib,-
			lsl$disk:[lites2.sigma6100.gks]gkssiglib/lib,-
			lsl$disk:[lites2.sigma6100.wkslib]wkslib/lib,-
			lsl$library:cmdlib/lib,-
			lsl$library:violib/lib
