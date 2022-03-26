	BLOCK DATA GKSBLK
C
CDEC$	IDENT	'20JA94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-Apr-1984
C
	INCLUDE 'GFABUF.CMN'
	INCLUDE	'GKSDAT1.CMN'
	INCLUDE	'GFADAT1.CMN'
C
C Initialisation Normalisation Transformations
	DATA	WINDOW/0.0,1.0,0.0,1.0,0.0,1.0,0.0,1.0/
	DATA	VIEWPT/0.0,1.0,0.0,1.0,0.0,1.0,0.0,1.0/
	DATA	WSWIN /0.0,1.0,0.0,1.0/
	DATA	WSVIEW/0.0,1.0,0.0,1.0/
C
C Set aspect source flags to bundled
	DATA	GASF/ASFMAX*GBUNDL/
C
C Initialise Polyline Bundle Tables and associated data
	DATA	PLTYPE,PLWDTH,PLCOL/1,2,3,4,
     &			1.0,1.0,1.0,1.0,
     &			1,1,1,1/
C
C Initialise individual polyline attributes
	DATA	ILTYPE,ILWID,ICOLI,ISYM/1,1.0,1,1/
C
C Initialise Fill Area Bundle Tables and associated data
C NB that GPATRN (PATTERN) is not implemented on these workstations
	DATA	FAISTY,FASTYI,FACOL/GHOLOW,GSOLID,GHATCH,GHATCH,
     &				1,1,1,2,
     &				1,1,1,1/
C
C Initialise individual fill area attributes
	DATA	IFASTY,IFASTX,IFACOL,IFAROT/GHOLOW,1,1,0.0/
C
C Initialise individual text attributes
	DATA	ITXCOL,ICHHGT,ICHANG,ICHFNT/1,1.0,0.0,1/
C
	DATA	RASTX,RASTY/0.0,0.0/
C
C and current line attributes
C NB current width = 0.0 because 0.0 means non-thick in LDLIB
C set current colour -1 to ensure that the colour is set first
C time round
	DATA	CLTYPE,CLWID,CCOLI,CACOLI/1,0.0,-1,-1/
	DATA	CCAP,CJOIN/-1,-1/
	DATA	CFASTY,CFASTX/GHOLOW,1/
	DATA	CCHHGT,CCHANG,CCHFNT/1.0,0.0,-1/
C
C and fill area (user) specific from GFADAT
C Hatching line width of 0.0 (metres) will cause nominal width to be used
C Hatching line gap defaults to 0.005 metres (5mm)
C
	DATA	GFAWID,GFAGAP/0.0,0.005/
C
	DATA	POFF/0/			! no plane offset
	DATA	PSEL/'FF'X/		! all planes selected
	DATA	PVIS/'FF'X/		! all planes visible
	DATA	PIXROT/.FALSE./		! don't rotate pixels
	DATA	PACK/8/			! packing mode byte
C
C fill area memory management
	DATA	GFAMAX,GFASCT,BMAX/0,0,0/
	DATA	MEMORY_FAIL/.FALSE./
	DATA	FILL_ZONE/0/
C 
	END
