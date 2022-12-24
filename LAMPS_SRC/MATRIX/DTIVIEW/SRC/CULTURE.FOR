C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1999-11-08 18:33:30.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	INTEGER*4 FUNCTION OPEN_IFF_FILE
	IMPLICIT NONE
	INTEGER*4	MIKE_MAKE		!historical
	INTEGER*4	UHL1_MAKE		!historical
	INTEGER*4	TED4_MAKE
	INTEGER*4	ALVY_MAKE		!historical
	INTEGER*4	LSLA_MAKE
	PARAMETER (MIKE_MAKE='MIKE')
	PARAMETER (UHL1_MAKE='UHL1')
	PARAMETER (TED4_MAKE='TED4')
	PARAMETER (ALVY_MAKE='ALVY')
	PARAMETER (LSLA_MAKE='LSLA')
	INTEGER*4		DTI_MIKE	!historical
	INTEGER*4		DTI_UHL1	!historical
	INTEGER*4		DTI_TED4	
	INTEGER*4		DTI_ALVY	!historical
	INTEGER*4		DTI_LSLA
	PARAMETER (DTI_MIKE = 1)	! FILE_TYPE for MIKE DTI
	PARAMETER (DTI_UHL1 = 2)	! FILE_TYPE for UHL1 DTI
	PARAMETER (DTI_TED4 = 3)	! FILE_TYPE for TED4 DTI
	PARAMETER (DTI_ALVY = 4)	! FILE_TYPE for ALVY DTI
	PARAMETER (DTI_LSLA = 5)	! FILE_TYPE for LSLA DTI
	INTEGER*4		DATA_BYTE	
	INTEGER*4		DATA_WORD
	INTEGER*4		DATA_LONG
	INTEGER*4		DATA_REAL
	INTEGER*4		DATA_BIT
	PARAMETER (DATA_BYTE = 1)
	PARAMETER (DATA_WORD = 2)
	PARAMETER (DATA_LONG = 3)
	PARAMETER (DATA_REAL = 4)
	PARAMETER (DATA_BIT  = 5)
	BYTE		DTI_NULL_BYTE
	INTEGER*2	DTI_NULL_WORD
	INTEGER*4	DTI_NULL_LONG
	REAL*4		DTI_NULL_REAL
	PARAMETER (DTI_NULL_BYTE = 0)
	PARAMETER (DTI_NULL_WORD = -32767)
	PARAMETER (DTI_NULL_LONG = '80000000'X)	
	PARAMETER (DTI_NULL_REAL = -1.0E-38)
	INTEGER*4	UNITS_DTI
	INTEGER*4	UNITS_MET
	INTEGER*4	UNITS_SEC
	INTEGER*4	UNITS_DEG
	INTEGER*4	UNITS_PROJ
	PARAMETER (UNITS_DTI = 1)
	PARAMETER (UNITS_MET = 2)
	PARAMETER (UNITS_SEC = 3)
	PARAMETER (UNITS_DEG = 4)
	PARAMETER (UNITS_PROJ = 5)
	INTEGER*4		DEFAULT_LSLA_HEADER
	PARAMETER (DEFAULT_LSLA_HEADER = 32)
	INTEGER*4		MAX_HEADER
	PARAMETER (MAX_HEADER=65535)
	INTEGER*4		DTI_MAX_COLUMNS
	INTEGER*4		DTI_MAX_ROWS
	PARAMETER (DTI_MAX_COLUMNS = 65535)
	PARAMETER (DTI_MAX_ROWS    = 65535)
	INTEGER*4	DTI_ORDER_SW	
	INTEGER*4	DTI_ORDER_NW
	INTEGER*4	DTI_ORDER_NE
	INTEGER*4	DTI_ORDER_SE
	PARAMETER (DTI_ORDER_SW = 0)
	PARAMETER (DTI_ORDER_NW = 1)
	PARAMETER (DTI_ORDER_NE = 2)
	PARAMETER (DTI_ORDER_SE = 3)
	INTEGER*4	DTI_ORDER_CLOCKWISE
	INTEGER*4	DTI_ORDER_ANTICLOCKWISE
	PARAMETER (DTI_ORDER_CLOCKWISE = 0)
	PARAMETER (DTI_ORDER_ANTICLOCKWISE = 1)
        INTEGER    DTI__NORMAL                    
        PARAMETER (DTI__NORMAL                    =   201555979)
        INTEGER    DTI__NONSTDROT                 
        PARAMETER (DTI__NONSTDROT                 =   201555984)
        INTEGER    DTI__UNEXPRESULTS              
        PARAMETER (DTI__UNEXPRESULTS              =   201555992)
        INTEGER    DTI__ORIGOVERRUN               
        PARAMETER (DTI__ORIGOVERRUN               =   201556000)
        INTEGER    DTI__SAMPOVERRUN               
        PARAMETER (DTI__SAMPOVERRUN               =   201556008)
        INTEGER    DTI__BADDATAEXT                
        PARAMETER (DTI__BADDATAEXT                =   201556018)
        INTEGER    DTI__BADDATAPOS                
        PARAMETER (DTI__BADDATAPOS                =   201556026)
        INTEGER    DTI__BADDATAVALUE              
        PARAMETER (DTI__BADDATAVALUE              =   201556034)
        INTEGER    DTI__BADDSI                    
        PARAMETER (DTI__BADDSI                    =   201556042)
        INTEGER    DTI__BADEXTENT                 
        PARAMETER (DTI__BADEXTENT                 =   201556050)
        INTEGER    DTI__BADHEADER                 
        PARAMETER (DTI__BADHEADER                 =   201556058)
        INTEGER    DTI__BADHEADOFF                
        PARAMETER (DTI__BADHEADOFF                =   201556066)
        INTEGER    DTI__BADHEADSIZE               
        PARAMETER (DTI__BADHEADSIZE               =   201556074)
        INTEGER    DTI__BADLUN                    
        PARAMETER (DTI__BADLUN                    =   201556082)
        INTEGER    DTI__BADROTATION               
        PARAMETER (DTI__BADROTATION               =   201556090)
        INTEGER    DTI__BADUHL                    
        PARAMETER (DTI__BADUHL                    =   201556098)
        INTEGER    DTI__BADUNITS                  
        PARAMETER (DTI__BADUNITS                  =   201556106)
        INTEGER    DTI__BADWINDOW                 
        PARAMETER (DTI__BADWINDOW                 =   201556114)
        INTEGER    DTI__DATAMISMATCH              
        PARAMETER (DTI__DATAMISMATCH              =   201556122)
        INTEGER    DTI__HEADMISMATCH              
        PARAMETER (DTI__HEADMISMATCH              =   201556130)
        INTEGER    DTI__HEADTOOSMALL              
        PARAMETER (DTI__HEADTOOSMALL              =   201556138)
        INTEGER    DTI__INVDATA                   
        PARAMETER (DTI__INVDATA                   =   201556146)
        INTEGER    DTI__INVFILESIZE               
        PARAMETER (DTI__INVFILESIZE               =   201556154)
        INTEGER    DTI__INVHEAD                   
        PARAMETER (DTI__INVHEAD                   =   201556162)
        INTEGER    DTI__INVORDER                  
        PARAMETER (DTI__INVORDER                  =   201556170)
        INTEGER    DTI__INVUNITS                  
        PARAMETER (DTI__INVUNITS                  =   201556178)
        INTEGER    DTI__INVYEXTENT                
        PARAMETER (DTI__INVYEXTENT                =   201556186)
        INTEGER    DTI__INVYSTART                 
        PARAMETER (DTI__INVYSTART                 =   201556194)
        INTEGER    DTI__LUNINUSE                  
        PARAMETER (DTI__LUNINUSE                  =   201556202)
        INTEGER    DTI__LUNUNUSED                 
        PARAMETER (DTI__LUNUNUSED                 =   201556210)
        INTEGER    DTI__MISSARGS                  
        PARAMETER (DTI__MISSARGS                  =   201556218)
        INTEGER    DTI__NOFREELUN                 
        PARAMETER (DTI__NOFREELUN                 =   201556226)
        INTEGER    DTI__NOPROJREC                 
        PARAMETER (DTI__NOPROJREC                 =   201556234)
        INTEGER    DTI__READONLY                  
        PARAMETER (DTI__READONLY                  =   201556242)
        INTEGER    DTI__SYSERR                    
        PARAMETER (DTI__SYSERR                    =   201556250)
        INTEGER    DTI__WRITEHEAD                 
        PARAMETER (DTI__WRITEHEAD                 =   201556258)
	INTEGER		MD2LEN		! length of common 
	PARAMETER	(MD2LEN=200)
	INTEGER*2	MD2ARR(MD2LEN) ! common block as words
	INTEGER*2	MATV2		! note I*2, for compatability
	INTEGER*2	MD2DUM		! and a dummy for longword
					! alignment
	REAL*8		MD2LOC(2)	! local origin
	REAL*8		MD2SCL		! scale of map
	INTEGER*4	MD2PRJ		! projection system
	INTEGER*4	MD2UNT		! units that IFF file is in
	INTEGER*4	MD2SPH		! spheroid
	REAL*8		MD2USP(2)	! description of user defined
					! spheroid
	REAL*8		MD2PAR(15)	! parameters for projection
	LOGICAL*4	MD2FLP		! perhaps flip LAT LONG
	COMMON/MD2DES/MD2ARR
	EQUIVALENCE	(MATV2 ,MD2ARR(1)),
     &			(MD2DUM,MD2ARR(2)),
     &			(MD2LOC,MD2ARR(3)),
     &			(MD2SCL,MD2ARR(11)),
     &			(MD2PRJ,MD2ARR(15)),
     &			(MD2UNT,MD2ARR(17)),
     &			(MD2SPH,MD2ARR(19)),
     &			(MD2USP,MD2ARR(21)),
     &			(MD2PAR,MD2ARR(29)),
     &			(MD2FLP,MD2ARR(89))
	INTEGER		 ON_CMD,ON_CHAR,ON_CHAR2,ON_SPACE,ON_EOL,ON_CMD2
	PARAMETER	(ON_CMD=1,ON_CHAR=2,ON_CHAR2=3,ON_SPACE=4)
	PARAMETER	(ON_EOL=5,ON_CMD2=6)
        INTEGER    LSL__CREATED                   
        PARAMETER (LSL__CREATED                   =   201424905)
        INTEGER    LSL__NORMAL                    
        PARAMETER (LSL__NORMAL                    =   201424913)
        INTEGER    LSL__SIGSUCC                   
        PARAMETER (LSL__SIGSUCC                   =   201424921)
        INTEGER    LSL__STREOL                    
        PARAMETER (LSL__STREOL                    =   201424929)
        INTEGER    LSL__STRCHAR                   
        PARAMETER (LSL__STRCHAR                   =   201424937)
        INTEGER    LSL__STRCMD                    
        PARAMETER (LSL__STRCMD                    =   201424945)
        INTEGER    LSL__STRSPACE                  
        PARAMETER (LSL__STRSPACE                  =   201424953)
        INTEGER    LSL__DUMMY1                    
        PARAMETER (LSL__DUMMY1                    =   201424961)
        INTEGER    LSL__DUMMY2                    
        PARAMETER (LSL__DUMMY2                    =   201424969)
        INTEGER    LSL__DUMMY3                    
        PARAMETER (LSL__DUMMY3                    =   201424977)
        INTEGER    LSL__DUMMY4                    
        PARAMETER (LSL__DUMMY4                    =   201424985)
        INTEGER    LSL__DUMMY5                    
        PARAMETER (LSL__DUMMY5                    =   201424993)
        INTEGER    LSL__DUMMY6                    
        PARAMETER (LSL__DUMMY6                    =   201425001)
        INTEGER    LSL__DUMMY7                    
        PARAMETER (LSL__DUMMY7                    =   201425009)
        INTEGER    LSL__DUMMY8                    
        PARAMETER (LSL__DUMMY8                    =   201425017)
        INTEGER    LSL__DUMMY9                    
        PARAMETER (LSL__DUMMY9                    =   201425025)
        INTEGER    LSL__DUMMY10                   
        PARAMETER (LSL__DUMMY10                   =   201425033)
        INTEGER    LSL__DEFTOOBIG                 
        PARAMETER (LSL__DEFTOOBIG                 =   201425040)
        INTEGER    LSL__EOF                       
        PARAMETER (LSL__EOF                       =   201425048)
        INTEGER    LSL__FILTOOLONG                
        PARAMETER (LSL__FILTOOLONG                =   201425056)
        INTEGER    LSL__NEGPOSNMK                 
        PARAMETER (LSL__NEGPOSNMK                 =   201425064)
        INTEGER    LSL__POSNMKOVF                 
        PARAMETER (LSL__POSNMKOVF                 =   201425072)
        INTEGER    LSL__RANREV                    
        PARAMETER (LSL__RANREV                    =   201425080)
        INTEGER    LSL__RECTOOBIG                 
        PARAMETER (LSL__RECTOOBIG                 =   201425088)
        INTEGER    LSL__SIGWARN                   
        PARAMETER (LSL__SIGWARN                   =   201425096)
        INTEGER    LSL__SRCTOOBIG                 
        PARAMETER (LSL__SRCTOOBIG                 =   201425104)
        INTEGER    LSL__NOFIELD                   
        PARAMETER (LSL__NOFIELD                   =   201425112)
        INTEGER    LSL__DUMMYW2                   
        PARAMETER (LSL__DUMMYW2                   =   201425120)
        INTEGER    LSL__DUMMYW3                   
        PARAMETER (LSL__DUMMYW3                   =   201425128)
        INTEGER    LSL__DUMMYW4                   
        PARAMETER (LSL__DUMMYW4                   =   201425136)
        INTEGER    LSL__DUMMYW5                   
        PARAMETER (LSL__DUMMYW5                   =   201425144)
        INTEGER    LSL__DUMMYW6                   
        PARAMETER (LSL__DUMMYW6                   =   201425152)
        INTEGER    LSL__DUMMYW7                   
        PARAMETER (LSL__DUMMYW7                   =   201425160)
        INTEGER    LSL__DUMMYW8                   
        PARAMETER (LSL__DUMMYW8                   =   201425168)
        INTEGER    LSL__DUMMYW9                   
        PARAMETER (LSL__DUMMYW9                   =   201425176)
        INTEGER    LSL__DUMMYW10                  
        PARAMETER (LSL__DUMMYW10                  =   201425184)
        INTEGER    LSL__AMBIG                     
        PARAMETER (LSL__AMBIG                     =   201425194)
        INTEGER    LSL__AMBINEQ                   
        PARAMETER (LSL__AMBINEQ                   =   201425202)
        INTEGER    LSL__AMBIG2                    
        PARAMETER (LSL__AMBIG2                    =   201425210)
        INTEGER    LSL__BADEXCEP                  
        PARAMETER (LSL__BADEXCEP                  =   201425218)
        INTEGER    LSL__BADINEQ                   
        PARAMETER (LSL__BADINEQ                   =   201425226)
        INTEGER    LSL__BADPARSE                  
        PARAMETER (LSL__BADPARSE                  =   201425234)
        INTEGER    LSL__BADTCOND                  
        PARAMETER (LSL__BADTCOND                  =   201425242)
        INTEGER    LSL__BASECH                    
        PARAMETER (LSL__BASECH                    =   201425250)
        INTEGER    LSL__BUFOVFLW                  
        PARAMETER (LSL__BUFOVFLW                  =   201425258)
        INTEGER    LSL__BUFFEROVF                 
        PARAMETER (LSL__BUFFEROVF                 =   201425266)
        INTEGER    LSL__COMMA                     
        PARAMETER (LSL__COMMA                     =   201425274)
        INTEGER    LSL__DEFFILNAM                 
        PARAMETER (LSL__DEFFILNAM                 =   201425282)
        INTEGER    LSL__DEFVERNUM                 
        PARAMETER (LSL__DEFVERNUM                 =   201425290)
        INTEGER    LSL__DEVALLOC                  
        PARAMETER (LSL__DEVALLOC                  =   201425298)
        INTEGER    LSL__ENDOFTAPE                 
        PARAMETER (LSL__ENDOFTAPE                 =   201425306)
        INTEGER    LSL__ENDOFVOL                  
        PARAMETER (LSL__ENDOFVOL                  =   201425314)
        INTEGER    LSL__FAC                       
        PARAMETER (LSL__FAC                       =   201425322)
        INTEGER    LSL__FILINUSE                  
        PARAMETER (LSL__FILINUSE                  =   201425330)
        INTEGER    LSL__FLTDIV                    
        PARAMETER (LSL__FLTDIV                    =   201425338)
        INTEGER    LSL__FLTOVF                    
        PARAMETER (LSL__FLTOVF                    =   201425346)
        INTEGER    LSL__FLTUND                    
        PARAMETER (LSL__FLTUND                    =   201425354)
        INTEGER    LSL__HADEXCP                   
        PARAMETER (LSL__HADEXCP                   =   201425362)
        INTEGER    LSL__ILLEGLUN                  
        PARAMETER (LSL__ILLEGLUN                  =   201425370)
        INTEGER    LSL__INTPARSERR                
        PARAMETER (LSL__INTPARSERR                =   201425378)
        INTEGER    LSL__INTDIV                    
        PARAMETER (LSL__INTDIV                    =   201425386)
        INTEGER    LSL__INTOVF                    
        PARAMETER (LSL__INTOVF                    =   201425394)
        INTEGER    LSL__INVALSPEC                 
        PARAMETER (LSL__INVALSPEC                 =   201425402)
        INTEGER    LSL__LUNINUSE                  
        PARAMETER (LSL__LUNINUSE                  =   201425410)
        INTEGER    LSL__MAXPAREX                  
        PARAMETER (LSL__MAXPAREX                  =   201425418)
        INTEGER    LSL__MISSARGS                  
        PARAMETER (LSL__MISSARGS                  =   201425426)
        INTEGER    LSL__MSGNOTFND                 
        PARAMETER (LSL__MSGNOTFND                 =   201425434)
        INTEGER    LSL__NOLUNS                    
        PARAMETER (LSL__NOLUNS                    =   201425442)
        INTEGER    LSL__NONUM                     
        PARAMETER (LSL__NONUM                     =   201425450)
        INTEGER    LSL__NOSUCHDEV                 
        PARAMETER (LSL__NOSUCHDEV                 =   201425458)
        INTEGER    LSL__NOSUCHLUN                 
        PARAMETER (LSL__NOSUCHLUN                 =   201425466)
        INTEGER    LSL__NOSUCHFILE                
        PARAMETER (LSL__NOSUCHFILE                =   201425474)
        INTEGER    LSL__RESPARSOVF                
        PARAMETER (LSL__RESPARSOVF                =   201425482)
        INTEGER    LSL__SIGERR                    
        PARAMETER (LSL__SIGERR                    =   201425490)
        INTEGER    LSL__SRCFILNAM                 
        PARAMETER (LSL__SRCFILNAM                 =   201425498)
        INTEGER    LSL__SRCVERNUM                 
        PARAMETER (LSL__SRCVERNUM                 =   201425506)
        INTEGER    LSL__STRTOOLONG                
        PARAMETER (LSL__STRTOOLONG                =   201425514)
        INTEGER    LSL__SYNTAXERR                 
        PARAMETER (LSL__SYNTAXERR                 =   201425522)
        INTEGER    LSL__SYSCLOSE                  
        PARAMETER (LSL__SYSCLOSE                  =   201425530)
        INTEGER    LSL__SYSERR                    
        PARAMETER (LSL__SYSERR                    =   201425538)
        INTEGER    LSL__SYSFIND                   
        PARAMETER (LSL__SYSFIND                   =   201425546)
        INTEGER    LSL__SYSREAD                   
        PARAMETER (LSL__SYSREAD                   =   201425554)
        INTEGER    LSL__SYSREW                    
        PARAMETER (LSL__SYSREW                    =   201425562)
        INTEGER    LSL__SYSUPD                    
        PARAMETER (LSL__SYSUPD                    =   201425570)
        INTEGER    LSL__SYSWRITE                  
        PARAMETER (LSL__SYSWRITE                  =   201425578)
        INTEGER    LSL__SYSOPEN                   
        PARAMETER (LSL__SYSOPEN                   =   201425586)
        INTEGER    LSL__UNEXPCH                   
        PARAMETER (LSL__UNEXPCH                   =   201425594)
        INTEGER    LSL__UNEXPCMD                  
        PARAMETER (LSL__UNEXPCMD                  =   201425602)
        INTEGER    LSL__UNEXPCMD2                 
        PARAMETER (LSL__UNEXPCMD2                 =   201425610)
        INTEGER    LSL__UNEXPEOF                  
        PARAMETER (LSL__UNEXPEOF                  =   201425618)
        INTEGER    LSL__UNEXPEOL                  
        PARAMETER (LSL__UNEXPEOL                  =   201425626)
        INTEGER    LSL__FILNOLEN                  
        PARAMETER (LSL__FILNOLEN                  =   201425634)
        INTEGER    LSL__SYSFLUSH                  
        PARAMETER (LSL__SYSFLUSH                  =   201425642)
        INTEGER    LSL__DUMMYE3                   
        PARAMETER (LSL__DUMMYE3                   =   201425650)
        INTEGER    LSL__DUMMYE4                   
        PARAMETER (LSL__DUMMYE4                   =   201425658)
        INTEGER    LSL__DUMMYE5                   
        PARAMETER (LSL__DUMMYE5                   =   201425666)
        INTEGER    LSL__DUMMYE6                   
        PARAMETER (LSL__DUMMYE6                   =   201425674)
        INTEGER    LSL__DUMMYE7                   
        PARAMETER (LSL__DUMMYE7                   =   201425682)
        INTEGER    LSL__DUMMYE8                   
        PARAMETER (LSL__DUMMYE8                   =   201425690)
        INTEGER    LSL__DUMMYE9                   
        PARAMETER (LSL__DUMMYE9                   =   201425698)
        INTEGER    LSL__DUMMYE10                  
        PARAMETER (LSL__DUMMYE10                  =   201425706)
        INTEGER    LSL__SIGSEVER                  
        PARAMETER (LSL__SIGSEVER                  =   201425716)
        INTEGER    LSL__DUMMYS1                   
        PARAMETER (LSL__DUMMYS1                   =   201425724)
        INTEGER    LSL__DUMMYS2                   
        PARAMETER (LSL__DUMMYS2                   =   201425732)
        INTEGER    LSL__DUMMYS3                   
        PARAMETER (LSL__DUMMYS3                   =   201425740)
        INTEGER    LSL__DUMMYS4                   
        PARAMETER (LSL__DUMMYS4                   =   201425748)
        INTEGER    LSL__DUMMYS5                   
        PARAMETER (LSL__DUMMYS5                   =   201425756)
        INTEGER    LSL__DUMMYS6                   
        PARAMETER (LSL__DUMMYS6                   =   201425764)
        INTEGER    LSL__DUMMYS7                   
        PARAMETER (LSL__DUMMYS7                   =   201425772)
        INTEGER    LSL__DUMMYS8                   
        PARAMETER (LSL__DUMMYS8                   =   201425780)
        INTEGER    LSL__DUMMYS9                   
        PARAMETER (LSL__DUMMYS9                   =   201425788)
        INTEGER    LSL__DUMMYS10                  
        PARAMETER (LSL__DUMMYS10                  =   201425796)
        INTEGER    LSL__SIGINFO                   
        PARAMETER (LSL__SIGINFO                   =   201425803)
        INTEGER    LSL__DUMMYI1                   
        PARAMETER (LSL__DUMMYI1                   =   201425811)
        INTEGER    LSL__DUMMYI2                   
        PARAMETER (LSL__DUMMYI2                   =   201425819)
        INTEGER    LSL__DUMMYI3                   
        PARAMETER (LSL__DUMMYI3                   =   201425827)
        INTEGER    LSL__DUMMYI4                   
        PARAMETER (LSL__DUMMYI4                   =   201425835)
        INTEGER    LSL__DUMMYI5                   
        PARAMETER (LSL__DUMMYI5                   =   201425843)
        INTEGER    LSL__DUMMYI6                   
        PARAMETER (LSL__DUMMYI6                   =   201425851)
        INTEGER    LSL__DUMMYI7                   
        PARAMETER (LSL__DUMMYI7                   =   201425859)
        INTEGER    LSL__DUMMYI8                   
        PARAMETER (LSL__DUMMYI8                   =   201425867)
        INTEGER    LSL__DUMMYI9                   
        PARAMETER (LSL__DUMMYI9                   =   201425875)
        INTEGER    LSL__DUMMYI10                  
        PARAMETER (LSL__DUMMYI10                  =   201425883)
        INTEGER    LSL__IFFOPENED                 
        PARAMETER (LSL__IFFOPENED                 =   201425891)
        INTEGER    LSL__IFFPARSE                  
        PARAMETER (LSL__IFFPARSE                  =   201425898)
        INTEGER    LSL__IFFVERNUM                 
        PARAMETER (LSL__IFFVERNUM                 =   201425906)
        INTEGER    LSL__IFFSIZE                   
        PARAMETER (LSL__IFFSIZE                   =   201425914)
        INTEGER    LSL__IFFOPEN                   
        PARAMETER (LSL__IFFOPEN                   =   201425922)
        INTEGER    LSL__IFFCREATE                 
        PARAMETER (LSL__IFFCREATE                 =   201425930)
        INTEGER    LSL__IFFMODIFY                 
        PARAMETER (LSL__IFFMODIFY                 =   201425938)
        INTEGER    LSL__LCMOPNOUT                 
        PARAMETER (LSL__LCMOPNOUT                 =   201425947)
        INTEGER    LSL__LOGOPNOUT                 
        PARAMETER (LSL__LOGOPNOUT                 =   201425955)
        INTEGER    LSL__OPLCM                     
        PARAMETER (LSL__OPLCM                     =   201425962)
        INTEGER    LSL__OPLOG                     
        PARAMETER (LSL__OPLOG                     =   201425970)
        INTEGER    LSL__IFFINREV                  
        PARAMETER (LSL__IFFINREV                  =   201425978)
        INTEGER    LSL__IFFOUTREV                 
        PARAMETER (LSL__IFFOUTREV                 =   201425986)
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER*2	IELEN
	BYTE		CH
	INTEGER*4	I,J		
	INTEGER*4	ERROR		! function system errir code
	INTEGER*4	RETVAL		! function return code
	INTEGER*4	GETFILNAM	! parse filename
	INTEGER*4	IFFOPEN		! open IFF file
	LOGICAL		RDCHS		! read character
	OPEN_IFF_FILE=.TRUE.	! Assume function is successful
	IF (CH.EQ.''''.OR.CH.EQ.'"') THEN
	  RETVAL = GETFILNAM(INPUT_IFF_NAME,
     &                       INPUT_IFF_LENGTH,
     &                       'LSL$IF:.IFF',
     &                       .TRUE.,
     &                       CH)
	ELSE
	  CALL BSCH
	  RETVAL = GETFILNAM(INPUT_IFF_NAME,
     &                       INPUT_IFF_LENGTH,
     &                       'LSL$IF:.IFF',
     &                       .TRUE.)
	ENDIF
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(RETVAL)
	  OPEN_IFF_FILE=.FALSE.
	  GOTO 999
	ENDIF
	IF (HADIFF) CALL IFFCLO(3)
	RETVAL = IFFOPEN(3,INPUT_IFF_NAME(1:INPUT_IFF_LENGTH),,.TRUE.,1)
	IF (.NOT.RETVAL)THEN
	   OPEN_IFF_FILE=.FALSE.
	   CALL WRITEF
           GOTO 999
	ENDIF
	HADIFF =.TRUE.
	CALL IFFNXC ('RA',IELEN)
	CALL EIHRR(RANGE_VALUES,IELEN/2,1)
	HADWIN=.FALSE.
        CALL IFFNXC('MD',IELEN)
	ORIGIN_OFFSET(1) = 0.0
	ORIGIN_OFFSET(2) = 0.0
	IF (IELEN .EQ. MD2LEN) THEN		! type 2 MD
	   CALL EIHR(MD2ARR,MD2LEN,1)		! read entry
	   ORIGIN_OFFSET(1) = MD2LOC(1)
	   ORIGIN_OFFSET(2) = MD2LOC(2)
	ENDIF
	CALL SET_IFFWIN
999	RETURN
	END

      	SUBROUTINE TRANSFORM_IFF
	IMPLICIT NONE
	INTEGER*4	IFF_MAXCBCOL		! max number of columns
	PARAMETER	(IFF_MAXCBCOL=20)
	INTEGER*4	IFF_MAXCBROW		! max number of rows
	PARAMETER	(IFF_MAXCBROW=200)
	INTEGER*4	IFF_MAXCBDATA		! max longwords of data
	PARAMETER	(IFF_MAXCBDATA=IFF_MAXCBCOL*IFF_MAXCBROW)
	INTEGER*4	IFF_MAXCBATT		! max fixed attributes
	PARAMETER	(IFF_MAXCBATT=20)
	INTEGER*4	IFF_ABSENT		! absent value
	PARAMETER	(IFF_ABSENT='80000000'X) 
	INTEGER		IFF_C_X,IFF_C_Y,IFF_C_Z
	PARAMETER	(IFF_C_X=91)
	PARAMETER	(IFF_C_Y=92)
	PARAMETER	(IFF_C_Z=93)
	STRUCTURE	/IFF_CBATT/
	  INTEGER*4	ATTC		! attribute code
	  UNION
	    MAP
	      INTEGER*4	IATTV		! attribute value (integer)
	    END MAP
	    MAP
	      REAL	RATTV		! attribute value (real)
	    END MAP
	    MAP
	      CHARACTER*4 CATTV		! attribute value (char*4)
	    END MAP
	  END UNION
	END STRUCTURE
	STRUCTURE	/IFF_CBH/
	  INTEGER*4	FLAGS			! flags (from IENDS now)
	  INTEGER*4	GTYPE			! graphical type
	  INTEGER*4	NROW			! number of rows
	  INTEGER*4	NCOL			! number of data columns
	  INTEGER*4	COLH(IFF_MAXCBCOL)	! column headers
	  INTEGER*4	NATT			! number of attributes
	  RECORD	/IFF_CBATT/ATT(IFF_MAXCBATT)	! attributes
	END STRUCTURE
	STRUCTURE	/IFF_CBD/
	  UNION
	    MAP
	      INTEGER*4		I(IFF_MAXCBDATA)	! integer value
	    END MAP
	    MAP
	      REAL		R(IFF_MAXCBDATA)	! real value
	    END MAP
	    MAP
	      CHARACTER*4	C(IFF_MAXCBDATA)	! char value
	    END MAP
	  END UNION
	END STRUCTURE
	STRUCTURE	/IFF_CBITEM/
	  UNION
	    MAP
	      INTEGER*4		I	! integer value
	    END MAP
	    MAP
	      REAL		R	! real value
	    END MAP
	    MAP
	      CHARACTER*4	C	! char value
	    END MAP
	  END UNION
	END STRUCTURE
	LOGICAL*4 SIMPLE_XY
	LOGICAL*4 SIMPLE_XYZ
	COMMON /IFFSTR/ SIMPLE_XY,SIMPLE_XYZ
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4 LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF
	INTEGER*4 IERCD,IERAD,IERNM
	INTEGER*2 IFOREL
	LOGICAL*2 WATEOF
	INTEGER*4 IRVLEV,ORVLEV
	COMMON /IFFHAN/ LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF,
     +   IERCD,IERAD,IERNM,WATEOF,IFOREL,IRVLEV,ORVLEV
	PARAMETER FRTMAX_DEF=1000	! def number of FCs
	PARAMETER LINTYP = 1		! line string
	PARAMETER CLOTYP = 2		! clockwise circle arc
	PARAMETER ANTTYP = 3		! anti-clockwise circle arc
	PARAMETER CIRTYP = 4		! circum-circle arc
	PARAMETER FULTYP = 5		! full circumcircle
	PARAMETER CURTYP = 6		! interpolated curve
	PARAMETER UNOTYP = 7		! unoriented symbol
	PARAMETER ORITYP = 8		! oriented symbol
	PARAMETER SCATYP = 9		! scaled symbol
	PARAMETER TEXTYP = 10		! text
	PARAMETER STRTYP = 11		! symbol string
	PARAMETER ARETYP = 12		! fill area
	INTEGER		FRTMAX		! number of FCs
	INTEGER*4	FRTCNT		! count of defined FCs
	INTEGER*4	FRTIND		! index of selected FC
	INTEGER*4	FRTFC		! the selected FC
	INTEGER*4	FRTGT		! its Graphical Type
	INTEGER*4	FRTCOL		! its colour
	REAL		FRTWID		! its width
	REAL		FRTSIZ		! its size
	INTEGER*4	FRTSC		! its Secondary Code
	INTEGER*4	FRTFLG		! flags word
	INTEGER*4	FRTHW		! symbol for hardware line
	INTEGER*4	FRTHWL		! hardware line style
	INTEGER*4	FRTAST		! fill area internal style
	INTEGER*4	FRTAIX		! fill area style index
	LOGICAL*4	FRTHWS		! true if to use hardware symbol
	LOGICAL*4	FRTLIN		! true if linear
	LOGICAL*4	FRTSYM		! true if symbol
	LOGICAL*4	FRTARC		! true if circle arc
	LOGICAL*4	FRTCUR		! true if curve
	LOGICAL*4	FRTTEX		! true if text
	LOGICAL*4	FRTARE		! true if fill area
	INTEGER*4	FRTINT_LOC	! ptr to integers
	INTEGER*4	FRTFLT_LOC	! ptr to floats (reals)
	LOGICAL*4	FRTHKS		! true if thick lines supressed
	LOGICAL*4	FRTCLP		! true if to clip symbols in
					! patterened fill areas
	COMMON/FRTCOM/FRTMAX,FRTCNT,FRTIND,FRTFC,FRTGT,FRTCOL,
     &                FRTWID,FRTSIZ,FRTSC,FRTFLG,FRTHW,FRTHWL,
     &		      FRTAST,FRTAIX,FRTHWS,
     &                FRTLIN,FRTARC,FRTCUR,FRTSYM,FRTTEX,FRTARE,
     &	              FRTHKS,FRTCLP,
     &		      FRTINT_LOC,FRTFLT_LOC
	INTEGER		COLHXY(2)
	RECORD/IFF_CBH/	CBH
	RECORD/IFF_CBD/	CBD
	COMMON/CB/COLHXY,CBH,CBD
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER MAXLAY		! max number of layers allowed.
	INTEGER LAYMAX		! number of longwords for layer bit map.
	INTEGER MAXFC		! max number of feature codes.
	INTEGER FCMAX		! number of longwords for FC bit map.
	INTEGER SELMAX		! max number of SEL/DES cmds allowed.
	INTEGER MAXFSN		! maximum number of FSNs allowed
	INTEGER FSNMAX		! number of longwords in FSN bit map
	PARAMETER (MAXLAY=32767)
	PARAMETER (LAYMAX=1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (MAXFC =32767)
	PARAMETER (FCMAX =1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (SELMAX=10)
	PARAMETER (MAXFSN=65535)
	PARAMETER (FSNMAX=(MAXFSN+1)/32)
	INTEGER*4 NOVRRD	! number of layer FC overrides
	INTEGER*4 LAYMAP(LAYMAX) ! bit-map for layer selection.
	INTEGER*4 FCMAP(FCMAX)	! bit-map for ft code selection.
	INTEGER*4 FSNMAP(FSNMAX)! bit-map for FSN selection
	INTEGER*4 WORD		! word position in bit-map.
	INTEGER*4 OFFSET	! bit offset in WORD.
	INTEGER	OVRDMX		! max number of overrides
	PARAMETER (OVRDMX=256)
	INTEGER*4 OVERRD(2,OVRDMX)! overriding layer/FC pairs
	INTEGER*4 PAIRS(2,40)	! range pairs read for LAY/NOL command.
	INTEGER*2 SELPTR	! pointer to last entry in SELBUF.
	BYTE SELBUF(80,SELMAX)	! for storing SEL/DES commands args in.
	BYTE SELDES(SELMAX)	! commands corresponding to SELBUF.
	LOGICAL*1 LYSMOD	! layer selection mode.
	LOGICAL*1 FCSMOD	! feature code selection mode.
	LOGICAL*1 FSNMOD	! FSN selection mode
	COMMON/SELECT/LAYMAP,FCMAP,FSNMAP,WORD,OFFSET,PAIRS,SELPTR,
     &		     SELBUF,SELDES,NOVRRD,LYSMOD,FCSMOD,OVERRD,
     &	             FSNMOD
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP,GSOLID
	PARAMETER (GASTI=3)		! deferral At Some TIme
	PARAMETER (GSUPPD=0)		! regeneration suppressed
	PARAMETER (GBUNDL=0)		! GKS ASF bundled
	PARAMETER (GINDIV=1)		! GKS ASF individual
	PARAMETER (GMETRE=0)		! device coords metres
	PARAMETER (GSUPP=0)		! suppress update regeneration
	PARAMETER (GALWAY=1)		! clear always
	PARAMETER (GNONE=0)		! no input
	PARAMETER (GOK=1)		! input OK
	PARAMETER (GNPICK=2)		! no segment picked
	PARAMETER (GINVIS=0)		! invisible
	PARAMETER (GVISI=1)		! visible
	PARAMETER (GNORML=0)		! normal
	PARAMETER (GHILIT=1)		! highlighted
	PARAMETER (GNCLIP=0)		! no clipping
	PARAMETER (GCLIP=1)		! clipping
	PARAMETER (GSOLID=1)		! solid 
	PARAMETER	MAXPTS=16392
	REAL		RANGEX,RANGEY	! X and Y IFF ranges
	REAL		IFF_COORDS(MAXPTS)! line coords 
	REAL		X1_IFF,Y1_IFF	! FROM IFF coord pair
	REAL		X2_IFF,Y2_IFF	! TO   IFF coord pair
	INTEGER*4	X1_DTI,Y1_DTI	! FROM DTI coord pair	
	INTEGER*4	X2_DTI,Y2_DTI	! TO   DTI coord pair
	INTEGER*4	LAST_POINTS
	INTEGER*4	POINTS		! Number of points in ST
	INTEGER*4	TOTPTS		! Total no. of pts in feature
	INTEGER*4	I		! counter
	INTEGER*2	FVALUE		! feature code value
	INTEGER*2	LAYNUM		! layer number
	INTEGER*2	IECODE		! IFF entry code
	INTEGER*2	IELEN		! IFF entry length
        INTEGER*2       IENDS           ! additional string variable
	LOGICAL		NEWLIN		! true if start of a new line?
	LOGICAL		WANTED		! this item is wanted
	LOGICAL		HAD_INVIS 	! invisible move to next coord
	LOGICAL		FIRST_CB	! first CB of feature
	LOGICAL		HADCTRLC
	LOGICAL 	LIB$EXTZV	! test bit-map
	LOGICAL		FRTFND
	NULL_FEATURE=.FALSE.
	COLHXY(1)=IFF_C_X
	COLHXY(2)=IFF_C_Y
	IF(PRIMARY.OR.SECONDARY)THEN
	  CALL PLTPOS(.FALSE.,.FALSE.)
	  CALL GSSGT
	ENDIF
	IF(PRIMARY)THEN
	  IF(WTYPE(1).EQ.9900.OR.NOPLNS.EQ.4)THEN
	    CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(1,0)
	    CALL LSG_PLANE_VISIBLE(1,-1)
	  ELSE
	    CALL LSG_PLANE_SELECT(1,.NOT.PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(1,NOPLNS)
	    CALL LSG_PLANE_VISIBLE(1,-1)
	  ENDIF
	ENDIF
	IF(SECONDARY)THEN
          IF(NOPLNS.EQ.4)THEN
	    CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(2,0)
	    CALL LSG_PLANE_VISIBLE(2,-1)
	  ELSE
	    CALL LSG_PLANE_SELECT(2,.NOT.PLANE_MASK)
	    CALL LSG_PLANE_OFFSET(2,NOPLNS)
	    CALL LSG_PLANE_VISIBLE(2,-1)
	  ENDIF
	ENDIF
	IF(PLOT_IFF)THEN
	   CALL IFFSEL(1)
	   LPOSNO = LPOSE
	   CALL IFFNO(LAYER,0,0)
	   INFT = .FALSE.		! not in a feature
	   VRTPT = 0			! (and none buffered)
	   PLOT_IFF=.TRUE.		! 'IFF output'
	ENDIF
	CALL IFFSEL(3)			! select input IFF file
	CALL IFFRWD			! set to beginning
100	CALL IFFSEL(3)
	CALL IFFNXT(IECODE,IELEN)
	IF(IELEN.EQ.-1)   GOTO 999
	IF(IECODE.EQ.'EJ')GOTO 999
	IF(IECODE.EQ.'NO')THEN
	   CALL EIHRI(LAYNUM,1,1)
	   IF(LAYNUM.EQ.0)THEN
	     CALL IFFNXC('EO',IELEN)
	     IF(IELEN.EQ.-1)GOTO 999
	     GOTO 100
	   ENDIF
	   I = LAYNUM				! convert to long
	   WANTED=LIB$EXTZV(I,1,LAYMAP)
	   IF(.NOT.WANTED)THEN
	     CALL IFFNXC('EO',IELEN)		! Skip by setting to EO
	     IF(IELEN.EQ.-1)   GOTO 999
	   ENDIF
	   GOTO 100
	ENDIF
	IF(IECODE.EQ.'NF')THEN		! new feature
	  IF (HADCTRLC()) GOTO 999
	  CALL EIHRI(FTNUM,1,1)		! read feature number
	  FTNUM = IAND(FTNUM,65535) 	! convert to unsigned longword
	  IF (FTNUM.EQ.0) GOTO 140	! skip dummy feature
	  WANTED=LIB$EXTZV(FTNUM,1,FSNMAP)
	  IF (.NOT.WANTED) GOTO 140
	  NEWLIN=.TRUE.			! new line
	  TOTPTS=0			! initialise pt count
	  GOTO 100
	ENDIF
	IF(IECODE.EQ.'FS')THEN		! feature status
	  CALL EIHRI(FVALUE,1,1)	! retrieve feature code
	  I = FVALUE			! convert to long
	  WANTED=LIB$EXTZV(I,1,FCMAP)
	  IF (.NOT.WANTED) GOTO 140	! skip this feature
130	  IF(FRTFND(FVALUE))THEN
	    CALL WRITEF('Unable to find entry in FRT for fc %^W%N',FVALUE)
	    CALL WRITEF('Item will be skipped')
140	    CALL IFFNXC('EF',IELEN)
	    IF(IELEN.EQ.-1)GOTO 999
	    GOTO 100
	  ENDIF
	  CURFC=FVALUE
	ENDIF
	IF(IECODE.EQ.'CB')THEN	
	  LAST_POINTS=0
	  TOTPTS=0
	  FIRST_CB=.TRUE.
	  HAD_INVIS=.FALSE.
150	  CALL EIHRCB_HEAD(CBH)
	  POINTS=CBH.NROW
	  IENDS =CBH.FLAGS
	  IF(POINTS.LE.0)GOTO 100
	  IF(FIRST_CB)THEN
	    FIRST_CB=.FALSE.
	    GOTO 155
	  ENDIF
	  IF(IENDS.EQ.0)THEN		!invisible move
	    LAST_POINTS=POINTS
	    HAD_INVIS=.TRUE.
	    GOTO 160
	  ENDIF
155	  IF(SIMPLE_XY)THEN
	    CALL EIHRCB_DATA(IFF_COORDS(TOTPTS+1))
	    TOTPTS=TOTPTS+POINTS*2
	  ELSE
	    CALL EIHRCB_DATA(CBD)
	    CALL IFS_CB_READ(CBH,CBD,IFF_COORDS(TOTPTS+1),2,
     &                       COLHXY,1,POINTS)
	    TOTPTS=TOTPTS+POINTS*2
	  ENDIF
	  CALL IFFNXT(IECODE,IELEN)
	  IF(IELEN.EQ.-1)GOTO 999
	  IF(IECODE.EQ.'CB')GOTO 150	! yes
	  IF(TOTPTS.EQ.0)GOTO 999
160	  POINTS=0
	  DO 170 I=1,TOTPTS,2
	    POINTS=POINTS+1
	    XPTS(POINTS)=IFF_COORDS(I)
	    YPTS(POINTS)=IFF_COORDS(I+1)
170	  CONTINUE
	  IF(FRTGT.EQ.STRTYP)THEN
	    IF(DEBUG)
     &      CALL WRITEF('*** New symbol string with %N symbols ***',
     &      POINTS)
	    DO 200 I=1,POINTS
	      IF(XPTS(I).LT.WIND(1,1).OR.
     & 	         XPTS(I).GT.WIND(2,1).OR.
     &           YPTS(I).LT.WIND(1,2).OR.
     &           YPTS(I).GT.WIND(2,2))GOTO 190
	      IF(DEBUG)CALL WRITEF('Symbol inside  window')
	      CALL PLOT_SYMBOL(FVALUE,XPTS(I),YPTS(I),.TRUE.,.FALSE.,-1)
	      GOTO 200
190	      IF(DEBUG)CALL WRITEF('Symbol outside window')
200         CONTINUE
	    GOTO 100
	  ENDIF
	  IF(FRTSYM)THEN
	    IF(DEBUG)CALL WRITEF('*** New Point ***')
	    IF(POINTS.NE.1)THEN
	      CALL WRITEF
     &		   ('Point symbol with more than 1 coordinate point')
	      CALL WRITEF('Item will be skipped')
	      GOTO 100
	    ENDIF	    
	    IF(HADWIN)THEN		! test if inside IFF window
	      IF(XPTS(1).LT.WIND(1,1).OR.
     & 	         XPTS(1).GT.WIND(2,1).OR.
     &           YPTS(1).LT.WIND(1,2).OR.
     &           YPTS(1).GT.WIND(2,2))GOTO 100
	    ENDIF	    
	    CALL PLOT_SYMBOL(FVALUE,XPTS(1),YPTS(1),.TRUE.,.FALSE.,-1)
	    GOTO 100
	  ENDIF
	  IF(FRTLIN.AND.DEBUG)CALL WRITEF('*** New line ***')
	  IF(FRTCUR.AND.DEBUG)CALL WRITEF('*** New curved line ***')
	  IF(FRTARE.AND.DEBUG)CALL WRITEF('*** New area ***')
	  IF(FRTLIN.OR.FRTCUR)THEN
            CALL PLOT_LINE(FVALUE,POINTS)
            IF(HAD_INVIS)THEN
	      TOTPTS=0
	      HAD_INVIS=.FALSE.
	      POINTS=LAST_POINTS
              CALL IFFSEL(3)
	      GOTO 155
	    ELSE
	      GOTO 100
	    ENDIF
	  ENDIF
	  IF(FRTARE)THEN
            CALL PLOT_AREA(FVALUE,POINTS)
            IF(HAD_INVIS)THEN
	      TOTPTS=0
	      HAD_INVIS=.FALSE.
	      POINTS=LAST_POINTS
              CALL IFFSEL(3)
	      GOTO 155
	    ELSE
	      GOTO 100
	    ENDIF
	  ENDIF
	ENDIF
	GOTO 100
999	IF(PRIMARY)CALL GUWK(1,GSUPP)
	IF(SECONDARY)CALL GUWK(2,GSUPP)
	IF(PLOT_IFF)THEN
	  CALL EOPIC
	  CALL ENDIFF
	  PLOT_IFF=.FALSE.
	ENDIF
	IF(PRIMARY.AND.(PRIMARY.NE.9900))THEN
	  CALL LSG_PLANE_SELECT(1,PLANE_MASK)
	  CALL LSG_PLANE_OFFSET(1,0)
	  CALL LSG_PLANE_VISIBLE(1,-1)
	ENDIF
	IF(SECONDARY)THEN
	  CALL LSG_PLANE_SELECT(2,PLANE_MASK)
	  CALL LSG_PLANE_OFFSET(1,0)
	  CALL LSG_PLANE_VISIBLE(1,-1)
	ENDIF
	RETURN
	END

	SUBROUTINE VSBLTY (XCELL,YCELL)
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER*4	HORPT1		! end of horizon list (1)
	INTEGER*4	HORPT2		!		      (2)
	INTEGER*4	HORPTX, HORPTY	! ptrs to coords in hor'n array
	INTEGER*4	OLDPTX, OLDPTY	! ptrs to old ditto
	INTEGER*4	HOREMP		! old hor'n 'empty' ptr
	INTEGER		ALZSIZ,HORSIZ
	PARAMETER	(ALZSIZ = 401)	! max points buffered per axis
	PARAMETER	(HORSIZ = ALZSIZ*ALZSIZ) ! size of node array
	REAL		HORIZN(4, HORSIZ)
	REAL		OLDX1, OLDY1	! ) current vector
	REAL		OLDX2, OLDY2	! )  of old horizon
	REAL		NEWX1, NEWY1	! last point, new horizon coords
	LOGICAL*1	INIHOR		! TRUE => 1st horizon of pic
	BYTE		DANGLE		! <0 => to left of picture
	BYTE		MASKED		! <0 => below horizon
	LOGICAL*1	HORADV		! TRUE => horizon has advanced
	LOGICAL*1	NDCOPY		! TRUE => copy node as we go
	BYTE		HOBPAD		! byte padding
	INTEGER*2	HOWPAD		! word padding
	COMMON/HORIZN/HORPT1,HORPT2,
     & HORPTX,HORPTY,OLDPTX,OLDPTY,HOREMP,
     & OLDX1,OLDY1,OLDX2,OLDY2,NEWX1,NEWY1,
     & INIHOR,DANGLE,MASKED,HORADV,
     & NDCOPY,HOBPAD,HOWPAD,
     & HORIZN
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
	INTEGER*4 	XCELL		!col in DTI file	
	INTEGER*4	YCELL		!row in DTI file
	INTEGER*4	X_DTI,Y_DTI	!corrected bitmap coordinates
	INTEGER*4	RETVAL		!function return
	INTEGER*4	DTI_WRITE_BYTE_DATA	!to encode      bit map
	Y_DTI=XCELL-DTMOFY
	X_DTI=YCELL-DTMOFX
	IF(X_DTI.LT.1.OR.X_DTI.GT.X_EXTENT(2).OR.
     &     Y_DTI.LT.1.OR.Y_DTI.GT.Y_EXTENT(2))GOTO 999
	IF(MASKED.LT.0)THEN
	  RETVAL=DTI_WRITE_BYTE_DATA(2,0,X_DTI,Y_DTI)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
            GOTO 999
	  ENDIF
	ELSEIF(IN_FOG) THEN
	  RETVAL=DTI_WRITE_BYTE_DATA(2,2,X_DTI,Y_DTI)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
            GOTO 999
	  ENDIF
	ELSE
	  RETVAL=DTI_WRITE_BYTE_DATA(2,1,X_DTI,Y_DTI)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
            GOTO 999
	  ENDIF
	ENDIF
999	RETURN
	END

	LOGICAL FUNCTION POINT_VISIBLE()
	IMPLICIT NONE
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
	REAL 		X_DIFF		!X difference
	REAL 		Y_DIFF		!Y difference
	REAL 		Z_DIFF		!Z difference
	REAL 		DISTANCE 	!distance betwwen DTI node and observer
	X_DIFF = ABS_X - ABS_OBS_X
	Y_DIFF = ABS_Y - ABS_OBS_Y
	Z_DIFF = ABS_Z - ABS_OBS_Z
	DISTANCE = SQRT(X_DIFF**2 + Y_DIFF**2 + Z_DIFF**2)
	IF(DISTANCE.GT.FOG_VISIBILITY) THEN
	   POINT_VISIBLE = .FALSE.	! point in fog
	ELSE
	   POINT_VISIBLE = .TRUE.	! point not in fog
	ENDIF
	RETURN
	END
	INTEGER*4 FUNCTION CREATE_IFF_FILE
	IMPLICIT NONE
	INTEGER*4	MIKE_MAKE		!historical
	INTEGER*4	UHL1_MAKE		!historical
	INTEGER*4	TED4_MAKE
	INTEGER*4	ALVY_MAKE		!historical
	INTEGER*4	LSLA_MAKE
	PARAMETER (MIKE_MAKE='MIKE')
	PARAMETER (UHL1_MAKE='UHL1')
	PARAMETER (TED4_MAKE='TED4')
	PARAMETER (ALVY_MAKE='ALVY')
	PARAMETER (LSLA_MAKE='LSLA')
	INTEGER*4		DTI_MIKE	!historical
	INTEGER*4		DTI_UHL1	!historical
	INTEGER*4		DTI_TED4	
	INTEGER*4		DTI_ALVY	!historical
	INTEGER*4		DTI_LSLA
	PARAMETER (DTI_MIKE = 1)	! FILE_TYPE for MIKE DTI
	PARAMETER (DTI_UHL1 = 2)	! FILE_TYPE for UHL1 DTI
	PARAMETER (DTI_TED4 = 3)	! FILE_TYPE for TED4 DTI
	PARAMETER (DTI_ALVY = 4)	! FILE_TYPE for ALVY DTI
	PARAMETER (DTI_LSLA = 5)	! FILE_TYPE for LSLA DTI
	INTEGER*4		DATA_BYTE	
	INTEGER*4		DATA_WORD
	INTEGER*4		DATA_LONG
	INTEGER*4		DATA_REAL
	INTEGER*4		DATA_BIT
	PARAMETER (DATA_BYTE = 1)
	PARAMETER (DATA_WORD = 2)
	PARAMETER (DATA_LONG = 3)
	PARAMETER (DATA_REAL = 4)
	PARAMETER (DATA_BIT  = 5)
	BYTE		DTI_NULL_BYTE
	INTEGER*2	DTI_NULL_WORD
	INTEGER*4	DTI_NULL_LONG
	REAL*4		DTI_NULL_REAL
	PARAMETER (DTI_NULL_BYTE = 0)
	PARAMETER (DTI_NULL_WORD = -32767)
	PARAMETER (DTI_NULL_LONG = '80000000'X)	
	PARAMETER (DTI_NULL_REAL = -1.0E-38)
	INTEGER*4	UNITS_DTI
	INTEGER*4	UNITS_MET
	INTEGER*4	UNITS_SEC
	INTEGER*4	UNITS_DEG
	INTEGER*4	UNITS_PROJ
	PARAMETER (UNITS_DTI = 1)
	PARAMETER (UNITS_MET = 2)
	PARAMETER (UNITS_SEC = 3)
	PARAMETER (UNITS_DEG = 4)
	PARAMETER (UNITS_PROJ = 5)
	INTEGER*4		DEFAULT_LSLA_HEADER
	PARAMETER (DEFAULT_LSLA_HEADER = 32)
	INTEGER*4		MAX_HEADER
	PARAMETER (MAX_HEADER=65535)
	INTEGER*4		DTI_MAX_COLUMNS
	INTEGER*4		DTI_MAX_ROWS
	PARAMETER (DTI_MAX_COLUMNS = 65535)
	PARAMETER (DTI_MAX_ROWS    = 65535)
	INTEGER*4	DTI_ORDER_SW	
	INTEGER*4	DTI_ORDER_NW
	INTEGER*4	DTI_ORDER_NE
	INTEGER*4	DTI_ORDER_SE
	PARAMETER (DTI_ORDER_SW = 0)
	PARAMETER (DTI_ORDER_NW = 1)
	PARAMETER (DTI_ORDER_NE = 2)
	PARAMETER (DTI_ORDER_SE = 3)
	INTEGER*4	DTI_ORDER_CLOCKWISE
	INTEGER*4	DTI_ORDER_ANTICLOCKWISE
	PARAMETER (DTI_ORDER_CLOCKWISE = 0)
	PARAMETER (DTI_ORDER_ANTICLOCKWISE = 1)
        INTEGER    DTI__NORMAL                    
        PARAMETER (DTI__NORMAL                    =   201555979)
        INTEGER    DTI__NONSTDROT                 
        PARAMETER (DTI__NONSTDROT                 =   201555984)
        INTEGER    DTI__UNEXPRESULTS              
        PARAMETER (DTI__UNEXPRESULTS              =   201555992)
        INTEGER    DTI__ORIGOVERRUN               
        PARAMETER (DTI__ORIGOVERRUN               =   201556000)
        INTEGER    DTI__SAMPOVERRUN               
        PARAMETER (DTI__SAMPOVERRUN               =   201556008)
        INTEGER    DTI__BADDATAEXT                
        PARAMETER (DTI__BADDATAEXT                =   201556018)
        INTEGER    DTI__BADDATAPOS                
        PARAMETER (DTI__BADDATAPOS                =   201556026)
        INTEGER    DTI__BADDATAVALUE              
        PARAMETER (DTI__BADDATAVALUE              =   201556034)
        INTEGER    DTI__BADDSI                    
        PARAMETER (DTI__BADDSI                    =   201556042)
        INTEGER    DTI__BADEXTENT                 
        PARAMETER (DTI__BADEXTENT                 =   201556050)
        INTEGER    DTI__BADHEADER                 
        PARAMETER (DTI__BADHEADER                 =   201556058)
        INTEGER    DTI__BADHEADOFF                
        PARAMETER (DTI__BADHEADOFF                =   201556066)
        INTEGER    DTI__BADHEADSIZE               
        PARAMETER (DTI__BADHEADSIZE               =   201556074)
        INTEGER    DTI__BADLUN                    
        PARAMETER (DTI__BADLUN                    =   201556082)
        INTEGER    DTI__BADROTATION               
        PARAMETER (DTI__BADROTATION               =   201556090)
        INTEGER    DTI__BADUHL                    
        PARAMETER (DTI__BADUHL                    =   201556098)
        INTEGER    DTI__BADUNITS                  
        PARAMETER (DTI__BADUNITS                  =   201556106)
        INTEGER    DTI__BADWINDOW                 
        PARAMETER (DTI__BADWINDOW                 =   201556114)
        INTEGER    DTI__DATAMISMATCH              
        PARAMETER (DTI__DATAMISMATCH              =   201556122)
        INTEGER    DTI__HEADMISMATCH              
        PARAMETER (DTI__HEADMISMATCH              =   201556130)
        INTEGER    DTI__HEADTOOSMALL              
        PARAMETER (DTI__HEADTOOSMALL              =   201556138)
        INTEGER    DTI__INVDATA                   
        PARAMETER (DTI__INVDATA                   =   201556146)
        INTEGER    DTI__INVFILESIZE               
        PARAMETER (DTI__INVFILESIZE               =   201556154)
        INTEGER    DTI__INVHEAD                   
        PARAMETER (DTI__INVHEAD                   =   201556162)
        INTEGER    DTI__INVORDER                  
        PARAMETER (DTI__INVORDER                  =   201556170)
        INTEGER    DTI__INVUNITS                  
        PARAMETER (DTI__INVUNITS                  =   201556178)
        INTEGER    DTI__INVYEXTENT                
        PARAMETER (DTI__INVYEXTENT                =   201556186)
        INTEGER    DTI__INVYSTART                 
        PARAMETER (DTI__INVYSTART                 =   201556194)
        INTEGER    DTI__LUNINUSE                  
        PARAMETER (DTI__LUNINUSE                  =   201556202)
        INTEGER    DTI__LUNUNUSED                 
        PARAMETER (DTI__LUNUNUSED                 =   201556210)
        INTEGER    DTI__MISSARGS                  
        PARAMETER (DTI__MISSARGS                  =   201556218)
        INTEGER    DTI__NOFREELUN                 
        PARAMETER (DTI__NOFREELUN                 =   201556226)
        INTEGER    DTI__NOPROJREC                 
        PARAMETER (DTI__NOPROJREC                 =   201556234)
        INTEGER    DTI__READONLY                  
        PARAMETER (DTI__READONLY                  =   201556242)
        INTEGER    DTI__SYSERR                    
        PARAMETER (DTI__SYSERR                    =   201556250)
        INTEGER    DTI__WRITEHEAD                 
        PARAMETER (DTI__WRITEHEAD                 =   201556258)
	INTEGER*4 LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF
	INTEGER*4 IERCD,IERAD,IERNM
	INTEGER*2 IFOREL
	LOGICAL*2 WATEOF
	INTEGER*4 IRVLEV,ORVLEV
	COMMON /IFFHAN/ LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF,
     +   IERCD,IERAD,IERNM,WATEOF,IFOREL,IRVLEV,ORVLEV
	INTEGER		MD2LEN		! length of common 
	PARAMETER	(MD2LEN=200)
	INTEGER*2	MD2ARR(MD2LEN) ! common block as words
	INTEGER*2	MATV2		! note I*2, for compatability
	INTEGER*2	MD2DUM		! and a dummy for longword
					! alignment
	REAL*8		MD2LOC(2)	! local origin
	REAL*8		MD2SCL		! scale of map
	INTEGER*4	MD2PRJ		! projection system
	INTEGER*4	MD2UNT		! units that IFF file is in
	INTEGER*4	MD2SPH		! spheroid
	REAL*8		MD2USP(2)	! description of user defined
					! spheroid
	REAL*8		MD2PAR(15)	! parameters for projection
	LOGICAL*4	MD2FLP		! perhaps flip LAT LONG
	COMMON/MD2DES/MD2ARR
	EQUIVALENCE	(MATV2 ,MD2ARR(1)),
     &			(MD2DUM,MD2ARR(2)),
     &			(MD2LOC,MD2ARR(3)),
     &			(MD2SCL,MD2ARR(11)),
     &			(MD2PRJ,MD2ARR(15)),
     &			(MD2UNT,MD2ARR(17)),
     &			(MD2SPH,MD2ARR(19)),
     &			(MD2USP,MD2ARR(21)),
     &			(MD2PAR,MD2ARR(29)),
     &			(MD2FLP,MD2ARR(89))
	PARAMETER MHLEN = 350
	INTEGER*2 MHARR(MHLEN)
	COMMON/MAPHDR/MHARR
	LOGICAL*1 MHDESC(10)
	EQUIVALENCE (MHARR(1),MHDESC)
	INTEGER		 ON_CMD,ON_CHAR,ON_CHAR2,ON_SPACE,ON_EOL,ON_CMD2
	PARAMETER	(ON_CMD=1,ON_CHAR=2,ON_CHAR2=3,ON_SPACE=4)
	PARAMETER	(ON_EOL=5,ON_CMD2=6)
        INTEGER    LSL__CREATED                   
        PARAMETER (LSL__CREATED                   =   201424905)
        INTEGER    LSL__NORMAL                    
        PARAMETER (LSL__NORMAL                    =   201424913)
        INTEGER    LSL__SIGSUCC                   
        PARAMETER (LSL__SIGSUCC                   =   201424921)
        INTEGER    LSL__STREOL                    
        PARAMETER (LSL__STREOL                    =   201424929)
        INTEGER    LSL__STRCHAR                   
        PARAMETER (LSL__STRCHAR                   =   201424937)
        INTEGER    LSL__STRCMD                    
        PARAMETER (LSL__STRCMD                    =   201424945)
        INTEGER    LSL__STRSPACE                  
        PARAMETER (LSL__STRSPACE                  =   201424953)
        INTEGER    LSL__DUMMY1                    
        PARAMETER (LSL__DUMMY1                    =   201424961)
        INTEGER    LSL__DUMMY2                    
        PARAMETER (LSL__DUMMY2                    =   201424969)
        INTEGER    LSL__DUMMY3                    
        PARAMETER (LSL__DUMMY3                    =   201424977)
        INTEGER    LSL__DUMMY4                    
        PARAMETER (LSL__DUMMY4                    =   201424985)
        INTEGER    LSL__DUMMY5                    
        PARAMETER (LSL__DUMMY5                    =   201424993)
        INTEGER    LSL__DUMMY6                    
        PARAMETER (LSL__DUMMY6                    =   201425001)
        INTEGER    LSL__DUMMY7                    
        PARAMETER (LSL__DUMMY7                    =   201425009)
        INTEGER    LSL__DUMMY8                    
        PARAMETER (LSL__DUMMY8                    =   201425017)
        INTEGER    LSL__DUMMY9                    
        PARAMETER (LSL__DUMMY9                    =   201425025)
        INTEGER    LSL__DUMMY10                   
        PARAMETER (LSL__DUMMY10                   =   201425033)
        INTEGER    LSL__DEFTOOBIG                 
        PARAMETER (LSL__DEFTOOBIG                 =   201425040)
        INTEGER    LSL__EOF                       
        PARAMETER (LSL__EOF                       =   201425048)
        INTEGER    LSL__FILTOOLONG                
        PARAMETER (LSL__FILTOOLONG                =   201425056)
        INTEGER    LSL__NEGPOSNMK                 
        PARAMETER (LSL__NEGPOSNMK                 =   201425064)
        INTEGER    LSL__POSNMKOVF                 
        PARAMETER (LSL__POSNMKOVF                 =   201425072)
        INTEGER    LSL__RANREV                    
        PARAMETER (LSL__RANREV                    =   201425080)
        INTEGER    LSL__RECTOOBIG                 
        PARAMETER (LSL__RECTOOBIG                 =   201425088)
        INTEGER    LSL__SIGWARN                   
        PARAMETER (LSL__SIGWARN                   =   201425096)
        INTEGER    LSL__SRCTOOBIG                 
        PARAMETER (LSL__SRCTOOBIG                 =   201425104)
        INTEGER    LSL__NOFIELD                   
        PARAMETER (LSL__NOFIELD                   =   201425112)
        INTEGER    LSL__DUMMYW2                   
        PARAMETER (LSL__DUMMYW2                   =   201425120)
        INTEGER    LSL__DUMMYW3                   
        PARAMETER (LSL__DUMMYW3                   =   201425128)
        INTEGER    LSL__DUMMYW4                   
        PARAMETER (LSL__DUMMYW4                   =   201425136)
        INTEGER    LSL__DUMMYW5                   
        PARAMETER (LSL__DUMMYW5                   =   201425144)
        INTEGER    LSL__DUMMYW6                   
        PARAMETER (LSL__DUMMYW6                   =   201425152)
        INTEGER    LSL__DUMMYW7                   
        PARAMETER (LSL__DUMMYW7                   =   201425160)
        INTEGER    LSL__DUMMYW8                   
        PARAMETER (LSL__DUMMYW8                   =   201425168)
        INTEGER    LSL__DUMMYW9                   
        PARAMETER (LSL__DUMMYW9                   =   201425176)
        INTEGER    LSL__DUMMYW10                  
        PARAMETER (LSL__DUMMYW10                  =   201425184)
        INTEGER    LSL__AMBIG                     
        PARAMETER (LSL__AMBIG                     =   201425194)
        INTEGER    LSL__AMBINEQ                   
        PARAMETER (LSL__AMBINEQ                   =   201425202)
        INTEGER    LSL__AMBIG2                    
        PARAMETER (LSL__AMBIG2                    =   201425210)
        INTEGER    LSL__BADEXCEP                  
        PARAMETER (LSL__BADEXCEP                  =   201425218)
        INTEGER    LSL__BADINEQ                   
        PARAMETER (LSL__BADINEQ                   =   201425226)
        INTEGER    LSL__BADPARSE                  
        PARAMETER (LSL__BADPARSE                  =   201425234)
        INTEGER    LSL__BADTCOND                  
        PARAMETER (LSL__BADTCOND                  =   201425242)
        INTEGER    LSL__BASECH                    
        PARAMETER (LSL__BASECH                    =   201425250)
        INTEGER    LSL__BUFOVFLW                  
        PARAMETER (LSL__BUFOVFLW                  =   201425258)
        INTEGER    LSL__BUFFEROVF                 
        PARAMETER (LSL__BUFFEROVF                 =   201425266)
        INTEGER    LSL__COMMA                     
        PARAMETER (LSL__COMMA                     =   201425274)
        INTEGER    LSL__DEFFILNAM                 
        PARAMETER (LSL__DEFFILNAM                 =   201425282)
        INTEGER    LSL__DEFVERNUM                 
        PARAMETER (LSL__DEFVERNUM                 =   201425290)
        INTEGER    LSL__DEVALLOC                  
        PARAMETER (LSL__DEVALLOC                  =   201425298)
        INTEGER    LSL__ENDOFTAPE                 
        PARAMETER (LSL__ENDOFTAPE                 =   201425306)
        INTEGER    LSL__ENDOFVOL                  
        PARAMETER (LSL__ENDOFVOL                  =   201425314)
        INTEGER    LSL__FAC                       
        PARAMETER (LSL__FAC                       =   201425322)
        INTEGER    LSL__FILINUSE                  
        PARAMETER (LSL__FILINUSE                  =   201425330)
        INTEGER    LSL__FLTDIV                    
        PARAMETER (LSL__FLTDIV                    =   201425338)
        INTEGER    LSL__FLTOVF                    
        PARAMETER (LSL__FLTOVF                    =   201425346)
        INTEGER    LSL__FLTUND                    
        PARAMETER (LSL__FLTUND                    =   201425354)
        INTEGER    LSL__HADEXCP                   
        PARAMETER (LSL__HADEXCP                   =   201425362)
        INTEGER    LSL__ILLEGLUN                  
        PARAMETER (LSL__ILLEGLUN                  =   201425370)
        INTEGER    LSL__INTPARSERR                
        PARAMETER (LSL__INTPARSERR                =   201425378)
        INTEGER    LSL__INTDIV                    
        PARAMETER (LSL__INTDIV                    =   201425386)
        INTEGER    LSL__INTOVF                    
        PARAMETER (LSL__INTOVF                    =   201425394)
        INTEGER    LSL__INVALSPEC                 
        PARAMETER (LSL__INVALSPEC                 =   201425402)
        INTEGER    LSL__LUNINUSE                  
        PARAMETER (LSL__LUNINUSE                  =   201425410)
        INTEGER    LSL__MAXPAREX                  
        PARAMETER (LSL__MAXPAREX                  =   201425418)
        INTEGER    LSL__MISSARGS                  
        PARAMETER (LSL__MISSARGS                  =   201425426)
        INTEGER    LSL__MSGNOTFND                 
        PARAMETER (LSL__MSGNOTFND                 =   201425434)
        INTEGER    LSL__NOLUNS                    
        PARAMETER (LSL__NOLUNS                    =   201425442)
        INTEGER    LSL__NONUM                     
        PARAMETER (LSL__NONUM                     =   201425450)
        INTEGER    LSL__NOSUCHDEV                 
        PARAMETER (LSL__NOSUCHDEV                 =   201425458)
        INTEGER    LSL__NOSUCHLUN                 
        PARAMETER (LSL__NOSUCHLUN                 =   201425466)
        INTEGER    LSL__NOSUCHFILE                
        PARAMETER (LSL__NOSUCHFILE                =   201425474)
        INTEGER    LSL__RESPARSOVF                
        PARAMETER (LSL__RESPARSOVF                =   201425482)
        INTEGER    LSL__SIGERR                    
        PARAMETER (LSL__SIGERR                    =   201425490)
        INTEGER    LSL__SRCFILNAM                 
        PARAMETER (LSL__SRCFILNAM                 =   201425498)
        INTEGER    LSL__SRCVERNUM                 
        PARAMETER (LSL__SRCVERNUM                 =   201425506)
        INTEGER    LSL__STRTOOLONG                
        PARAMETER (LSL__STRTOOLONG                =   201425514)
        INTEGER    LSL__SYNTAXERR                 
        PARAMETER (LSL__SYNTAXERR                 =   201425522)
        INTEGER    LSL__SYSCLOSE                  
        PARAMETER (LSL__SYSCLOSE                  =   201425530)
        INTEGER    LSL__SYSERR                    
        PARAMETER (LSL__SYSERR                    =   201425538)
        INTEGER    LSL__SYSFIND                   
        PARAMETER (LSL__SYSFIND                   =   201425546)
        INTEGER    LSL__SYSREAD                   
        PARAMETER (LSL__SYSREAD                   =   201425554)
        INTEGER    LSL__SYSREW                    
        PARAMETER (LSL__SYSREW                    =   201425562)
        INTEGER    LSL__SYSUPD                    
        PARAMETER (LSL__SYSUPD                    =   201425570)
        INTEGER    LSL__SYSWRITE                  
        PARAMETER (LSL__SYSWRITE                  =   201425578)
        INTEGER    LSL__SYSOPEN                   
        PARAMETER (LSL__SYSOPEN                   =   201425586)
        INTEGER    LSL__UNEXPCH                   
        PARAMETER (LSL__UNEXPCH                   =   201425594)
        INTEGER    LSL__UNEXPCMD                  
        PARAMETER (LSL__UNEXPCMD                  =   201425602)
        INTEGER    LSL__UNEXPCMD2                 
        PARAMETER (LSL__UNEXPCMD2                 =   201425610)
        INTEGER    LSL__UNEXPEOF                  
        PARAMETER (LSL__UNEXPEOF                  =   201425618)
        INTEGER    LSL__UNEXPEOL                  
        PARAMETER (LSL__UNEXPEOL                  =   201425626)
        INTEGER    LSL__FILNOLEN                  
        PARAMETER (LSL__FILNOLEN                  =   201425634)
        INTEGER    LSL__SYSFLUSH                  
        PARAMETER (LSL__SYSFLUSH                  =   201425642)
        INTEGER    LSL__DUMMYE3                   
        PARAMETER (LSL__DUMMYE3                   =   201425650)
        INTEGER    LSL__DUMMYE4                   
        PARAMETER (LSL__DUMMYE4                   =   201425658)
        INTEGER    LSL__DUMMYE5                   
        PARAMETER (LSL__DUMMYE5                   =   201425666)
        INTEGER    LSL__DUMMYE6                   
        PARAMETER (LSL__DUMMYE6                   =   201425674)
        INTEGER    LSL__DUMMYE7                   
        PARAMETER (LSL__DUMMYE7                   =   201425682)
        INTEGER    LSL__DUMMYE8                   
        PARAMETER (LSL__DUMMYE8                   =   201425690)
        INTEGER    LSL__DUMMYE9                   
        PARAMETER (LSL__DUMMYE9                   =   201425698)
        INTEGER    LSL__DUMMYE10                  
        PARAMETER (LSL__DUMMYE10                  =   201425706)
        INTEGER    LSL__SIGSEVER                  
        PARAMETER (LSL__SIGSEVER                  =   201425716)
        INTEGER    LSL__DUMMYS1                   
        PARAMETER (LSL__DUMMYS1                   =   201425724)
        INTEGER    LSL__DUMMYS2                   
        PARAMETER (LSL__DUMMYS2                   =   201425732)
        INTEGER    LSL__DUMMYS3                   
        PARAMETER (LSL__DUMMYS3                   =   201425740)
        INTEGER    LSL__DUMMYS4                   
        PARAMETER (LSL__DUMMYS4                   =   201425748)
        INTEGER    LSL__DUMMYS5                   
        PARAMETER (LSL__DUMMYS5                   =   201425756)
        INTEGER    LSL__DUMMYS6                   
        PARAMETER (LSL__DUMMYS6                   =   201425764)
        INTEGER    LSL__DUMMYS7                   
        PARAMETER (LSL__DUMMYS7                   =   201425772)
        INTEGER    LSL__DUMMYS8                   
        PARAMETER (LSL__DUMMYS8                   =   201425780)
        INTEGER    LSL__DUMMYS9                   
        PARAMETER (LSL__DUMMYS9                   =   201425788)
        INTEGER    LSL__DUMMYS10                  
        PARAMETER (LSL__DUMMYS10                  =   201425796)
        INTEGER    LSL__SIGINFO                   
        PARAMETER (LSL__SIGINFO                   =   201425803)
        INTEGER    LSL__DUMMYI1                   
        PARAMETER (LSL__DUMMYI1                   =   201425811)
        INTEGER    LSL__DUMMYI2                   
        PARAMETER (LSL__DUMMYI2                   =   201425819)
        INTEGER    LSL__DUMMYI3                   
        PARAMETER (LSL__DUMMYI3                   =   201425827)
        INTEGER    LSL__DUMMYI4                   
        PARAMETER (LSL__DUMMYI4                   =   201425835)
        INTEGER    LSL__DUMMYI5                   
        PARAMETER (LSL__DUMMYI5                   =   201425843)
        INTEGER    LSL__DUMMYI6                   
        PARAMETER (LSL__DUMMYI6                   =   201425851)
        INTEGER    LSL__DUMMYI7                   
        PARAMETER (LSL__DUMMYI7                   =   201425859)
        INTEGER    LSL__DUMMYI8                   
        PARAMETER (LSL__DUMMYI8                   =   201425867)
        INTEGER    LSL__DUMMYI9                   
        PARAMETER (LSL__DUMMYI9                   =   201425875)
        INTEGER    LSL__DUMMYI10                  
        PARAMETER (LSL__DUMMYI10                  =   201425883)
        INTEGER    LSL__IFFOPENED                 
        PARAMETER (LSL__IFFOPENED                 =   201425891)
        INTEGER    LSL__IFFPARSE                  
        PARAMETER (LSL__IFFPARSE                  =   201425898)
        INTEGER    LSL__IFFVERNUM                 
        PARAMETER (LSL__IFFVERNUM                 =   201425906)
        INTEGER    LSL__IFFSIZE                   
        PARAMETER (LSL__IFFSIZE                   =   201425914)
        INTEGER    LSL__IFFOPEN                   
        PARAMETER (LSL__IFFOPEN                   =   201425922)
        INTEGER    LSL__IFFCREATE                 
        PARAMETER (LSL__IFFCREATE                 =   201425930)
        INTEGER    LSL__IFFMODIFY                 
        PARAMETER (LSL__IFFMODIFY                 =   201425938)
        INTEGER    LSL__LCMOPNOUT                 
        PARAMETER (LSL__LCMOPNOUT                 =   201425947)
        INTEGER    LSL__LOGOPNOUT                 
        PARAMETER (LSL__LOGOPNOUT                 =   201425955)
        INTEGER    LSL__OPLCM                     
        PARAMETER (LSL__OPLCM                     =   201425962)
        INTEGER    LSL__OPLOG                     
        PARAMETER (LSL__OPLOG                     =   201425970)
        INTEGER    LSL__IFFINREV                  
        PARAMETER (LSL__IFFINREV                  =   201425978)
        INTEGER    LSL__IFFOUTREV                 
        PARAMETER (LSL__IFFOUTREV                 =   201425986)
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	REAL		CPARR(4,4)	! control points
	REAL		CCARR(2,10)	! calib coeffs
	INTEGER*2	IELEN
	CHARACTER*80	FILNAM
	INTEGER		FILLEN
	BYTE		CH
	INTEGER*4	I,J		
	INTEGER*4	ERROR		! function system errir code
	INTEGER*4	RETVAL		! function return code
	INTEGER*4	GETFILNAM	! parse filename
	INTEGER*4	IFFCREATE	! create IFF file
	LOGICAL		RDCHS		! read character
	DATA		CCARR/0.0,1.0,8*0.0,
     &			      2*0.0,1.0,7*0.0/
	DATA		CPARR/0.0,1.0,0.0,1.0,
     &			      4*0.0,1.0,0.0,1.0,
     &			      0.0,4*1.0/
	CREATE_IFF_FILE=.TRUE.	! Assume function is successful
	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command IFF',ERROR_BELL)
	  CALL WRITEF('IFF filename is missing')
	  CREATE_IFF_FILE=.FALSE.
	  CALL BSLN
	  GOTO 999	  
	ENDIF
	IF (CH.EQ.''''.OR.CH.EQ.'"') THEN
	  RETVAL = GETFILNAM(FILNAM,FILLEN,'LSL$IF:.IFF',.TRUE.,CH)
	ELSE
	  CALL BSCH
	  RETVAL = GETFILNAM(FILNAM,FILLEN,'LSL$IF:.IFF',.TRUE.)
	ENDIF
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(RETVAL)
	  CREATE_IFF_FILE=.FALSE.
	  GOTO 999
	ENDIF
	IF(PLOT_IFF)THEN
          CALL ENDIFF
	  PLOT_IFF=.FALSE.
	  ACTIVE_IFF=.FALSE.
	ENDIF
	RETVAL = IFFCREATE(1,FILNAM(:FILLEN),'Output',,.TRUE.)
	IF(.NOT.RETVAL)THEN
	  CALL LSL_PUTMSG(RETVAL)
	  CREATE_IFF_FILE=.FALSE.
	  GOTO 999
	ENDIF
	CALL IFFRA(RANGE)
	CALL IFFHI
	CALL IFFMH(MHARR,MHLEN)
	MATV2 = -1		! unset descriptor
	CALL IFFMD(MD2ARR,MD2LEN)
	CALL IFFNS('DTM file')
	CALL IFFCC(CCARR)
	CALL IFFCP(CPARR)
	LPOSNO = LPOSE
	CALL IFFNO(LAYER,0,0)
	LAYER=LAYER+1
	INFT = .FALSE.		! not in a feature
	FTNUM = 1		! initialise feature counter
	VRTPT = 0		! (and none buffered)
999	RETURN
	END

	SUBROUTINE ENCODE_IFF(XFROM,YFROM,XTO,YTO,IVAL,DIR)
	IMPLICIT NONE
	INTEGER*4	XFROM		!start DTI x coordinate
	INTEGER*4	YFROM		!start DTI y coordinate
	INTEGER*4	XTO		!end   DTI x coordinate
	INTEGER*4	YTO		!end   DTI y coordinate
	INTEGER*2	IVAL		!feature code value
	INTEGER*4	DIR		!direction to scan
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
	INTEGER*4	DTI_READ_BYTE_DATA ! to test visibility of cell
	BYTE		VIS		! visibility status
	REAL		XIN		! scan line x and y
	REAL		RSAMPLE
	REAL		RLINE
	REAL		YIN		! intersection points.
	INTEGER*4	RETVAL		! function return code
	INTEGER*4	XVALUE
	INTEGER*4	YVALUE
	INTEGER*4	STEP		! scan line incremental step
	INTEGER*4	DIFFX		! abs. diff between XFROM,XTO
	INTEGER*4	DIFFY		! abs. diff between YFROM,YTO
	INTEGER*4	SAMPLE		! scan line
	INTEGER*4	LINE		! counters
	INTEGER*4	XPOS		! nearest int. of XIN
	INTEGER*4	YPOS		! nearest int. of YIN
	DIFFX = ABS(XFROM-XTO)	
	DIFFY = ABS(YFROM-YTO)
	IF(DIFFX.EQ.0.AND.DIFFY.EQ.0)GOTO 999
	IF(DIFFY.EQ.0)THEN	
	  STEP=X_SAMPLE				! ------> 
	  IF(XFROM.GT.XTO)STEP=-X_SAMPLE	! <------ 
	  DO 100 SAMPLE=XFROM,XTO,STEP
50	     XVALUE=SAMPLE-DTMOFX
	     YVALUE=YFROM-DTMOFY
	     IF(XVALUE.LT.1.OR.XVALUE.GT.X_EXTENT(2).OR.
     &          YVALUE.LT.1.OR.YVALUE.GT.Y_EXTENT(2))THEN
	        VIS=0
	     ELSE
	        RETVAL=DTI_READ_BYTE_DATA(2,VIS,XVALUE,YVALUE)
	        IF(.NOT.RETVAL)THEN
	          CALL LSL_PUTMSG(RETVAL)
	          GOTO 999
	        ENDIF
	     ENDIF
	     IN_FOG = .FALSE.
	     IF(VIS.EQ.1)THEN		! visible
                CALL CULPLT(SAMPLE,YFROM,IVAL)
	     ELSEIF(VIS.EQ.2)THEN		! in fog
		IN_FOG = .TRUE.
                CALL CULPLT(SAMPLE,YFROM,IVAL)
	     ELSE
	        STALIN=.TRUE.
	     ENDIF
100       CONTINUE			! get next pt
	  IF((STEP.LT.-1.AND.SAMPLE.GT.XTO).OR.
     &       (STEP.GT.1. AND.SAMPLE.LT.XTO))THEN
	     SAMPLE=XTO
	     GOTO 50		!jump back into the loop
	  ENDIF
	GOTO 999			! all done
	ENDIF
	IF(DIFFX.EQ.0)THEN
	  STEP=Y_SAMPLE				! upwards
	  IF(YFROM.GT.YTO)STEP=-Y_SAMPLE	! downwards
	  DO 200 LINE=YFROM,YTO,STEP
150	     XVALUE=XFROM-DTMOFX
	     YVALUE=LINE-DTMOFY
	     IF(XVALUE.LT.1.OR.XVALUE.GT.X_EXTENT(2).OR.
     &          YVALUE.LT.1.OR.YVALUE.GT.Y_EXTENT(2))THEN
	        VIS=0
	     ELSE
	        RETVAL=DTI_READ_BYTE_DATA(2,VIS,XVALUE,YVALUE)
	        IF(.NOT.RETVAL)THEN
	          CALL LSL_PUTMSG(RETVAL)
	          GOTO 999
	        ENDIF
	     ENDIF
	     IN_FOG = .FALSE.
	     IF(VIS.EQ.1)THEN		! visible
	        CALL CULPLT(XFROM,LINE,IVAL)
	     ELSEIF(VIS.EQ.2)THEN		! in fog
		IN_FOG = .TRUE.
	        CALL CULPLT(XFROM,LINE,IVAL)
	     ELSE
	        STALIN=.TRUE.
	     ENDIF
200	  CONTINUE			! get next pt
	  IF((STEP.LT.-1.AND.LINE.GT.YTO).OR.
     &       (STEP.GT.1. AND.LINE.LT.YTO))THEN
	     LINE=YTO
	     GOTO 150		!jump back into the loop
	  ENDIF
	  GOTO 999			! all done
	ENDIF
	IF(DIR.EQ.2)GOTO 350
	IF(DIR.EQ.1)GOTO 210
	IF(DIFFY.GT.DIFFX)GOTO 350	! scan horizontally
210	STEP=X_SAMPLE			! ----->
	IF(XFROM.GT.XTO)STEP=-X_SAMPLE	! <-----
	DO 300 SAMPLE =XFROM,XTO,STEP	
	   RSAMPLE=FLOAT(SAMPLE)+0.001
	   YIN =(YFROM+(YTO-YFROM)*(RSAMPLE-XFROM)/(XTO-XFROM))
	   YPOS=NINT(YIN)
	   XVALUE=SAMPLE-DTMOFX
	   YVALUE=YPOS-DTMOFY
	   IF(XVALUE.LT.1.OR.XVALUE.GT.X_EXTENT(2).OR.
     &       YVALUE.LT.1.OR.YVALUE.GT.Y_EXTENT(2))THEN
	     VIS=0
	   ELSE
	     RETVAL=DTI_READ_BYTE_DATA(2,VIS,XVALUE,YVALUE)
	     IF(.NOT.RETVAL)THEN
	       CALL LSL_PUTMSG(RETVAL)
	       GOTO 999
	     ENDIF
	   ENDIF
	   IN_FOG = .FALSE.
	   IF(VIS.EQ.1)THEN		! visible 
	      CALL CULPLT(SAMPLE,YPOS,IVAL)
	   ELSEIF(VIS.EQ.2)THEN		! in fog
	      IN_FOG = .TRUE.
	      CALL CULPLT(SAMPLE,YPOS,IVAL)
	   ELSE
	     STALIN=.TRUE.
	   ENDIF
300     CONTINUE			! next pt
        GOTO 999			! all done
350	STEP=Y_SAMPLE			! upwards
	IF(YFROM.GT.YTO)STEP=-Y_SAMPLE	! downwards
	DO 400 LINE =YFROM,YTO,STEP	
	   RLINE=FLOAT(LINE)+0.001
	   XIN =(XFROM+(XTO-XFROM)*(RLINE-YFROM)/(YTO-YFROM))
	   XPOS=NINT(XIN)
	   XVALUE=XPOS-DTMOFX
	   YVALUE=LINE-DTMOFY
	   IF(XVALUE.LT.1.OR.XVALUE.GT.X_EXTENT(2).OR.
     &        YVALUE.LT.1.OR.YVALUE.GT.Y_EXTENT(2))THEN
	      VIS=0
	   ELSE
	      RETVAL=DTI_READ_BYTE_DATA(2,VIS,XVALUE,YVALUE)
	      IF(.NOT.RETVAL)THEN
	        CALL LSL_PUTMSG(RETVAL)
	        GOTO 999
	      ENDIF
	   ENDIF
	   IN_FOG = .FALSE.
	   IF(VIS.EQ.1)THEN		! visible
	      CALL CULPLT(XPOS,LINE,IVAL)
	   ELSEIF(VIS.EQ.2)THEN		! in fog
	      IN_FOG = .TRUE.
	      CALL CULPLT(XPOS,LINE,IVAL)
	   ELSE
	     STALIN=.TRUE.
	   ENDIF
400     CONTINUE			! next pt
999	RETURN				
	END

	SUBROUTINE CULPLT(XPT,YPT,FC)
	IMPLICIT NONE
	INTEGER*4		XPT	!DTI coordinate
	INTEGER*4		YPT	!pair
	INTEGER*2		FC	!feature code
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	PARAMETER FRTMAX_DEF=1000	! def number of FCs
	PARAMETER LINTYP = 1		! line string
	PARAMETER CLOTYP = 2		! clockwise circle arc
	PARAMETER ANTTYP = 3		! anti-clockwise circle arc
	PARAMETER CIRTYP = 4		! circum-circle arc
	PARAMETER FULTYP = 5		! full circumcircle
	PARAMETER CURTYP = 6		! interpolated curve
	PARAMETER UNOTYP = 7		! unoriented symbol
	PARAMETER ORITYP = 8		! oriented symbol
	PARAMETER SCATYP = 9		! scaled symbol
	PARAMETER TEXTYP = 10		! text
	PARAMETER STRTYP = 11		! symbol string
	PARAMETER ARETYP = 12		! fill area
	INTEGER		FRTMAX		! number of FCs
	INTEGER*4	FRTCNT		! count of defined FCs
	INTEGER*4	FRTIND		! index of selected FC
	INTEGER*4	FRTFC		! the selected FC
	INTEGER*4	FRTGT		! its Graphical Type
	INTEGER*4	FRTCOL		! its colour
	REAL		FRTWID		! its width
	REAL		FRTSIZ		! its size
	INTEGER*4	FRTSC		! its Secondary Code
	INTEGER*4	FRTFLG		! flags word
	INTEGER*4	FRTHW		! symbol for hardware line
	INTEGER*4	FRTHWL		! hardware line style
	INTEGER*4	FRTAST		! fill area internal style
	INTEGER*4	FRTAIX		! fill area style index
	LOGICAL*4	FRTHWS		! true if to use hardware symbol
	LOGICAL*4	FRTLIN		! true if linear
	LOGICAL*4	FRTSYM		! true if symbol
	LOGICAL*4	FRTARC		! true if circle arc
	LOGICAL*4	FRTCUR		! true if curve
	LOGICAL*4	FRTTEX		! true if text
	LOGICAL*4	FRTARE		! true if fill area
	INTEGER*4	FRTINT_LOC	! ptr to integers
	INTEGER*4	FRTFLT_LOC	! ptr to floats (reals)
	LOGICAL*4	FRTHKS		! true if thick lines supressed
	LOGICAL*4	FRTCLP		! true if to clip symbols in
					! patterened fill areas
	COMMON/FRTCOM/FRTMAX,FRTCNT,FRTIND,FRTFC,FRTGT,FRTCOL,
     &                FRTWID,FRTSIZ,FRTSC,FRTFLG,FRTHW,FRTHWL,
     &		      FRTAST,FRTAIX,FRTHWS,
     &                FRTLIN,FRTARC,FRTCUR,FRTSYM,FRTTEX,FRTARE,
     &	              FRTHKS,FRTCLP,
     &		      FRTINT_LOC,FRTFLT_LOC
	REAL		XSCALE		! viewing
	REAL		YSCALE		! scaling
	REAL		ZSCALE		! factors
	REAL		DOV		! positions of view
	REAL		DOVSC		! scaled ditto
	REAL		DEFZSC		! default height exaggeration
	REAL		DEFHOV		! 'default' height of view
	REAL		HOV		! height of view * exag'n.
	REAL*8		DEFPHI,DEFTHT	! default angles of view
	REAL*8		PHI, THETA	! angles
	REAL*8		SPHI, STHETA	! sines
	REAL*8		CPHI, CTHETA	! cosines
	REAL*8		A1, A2		! coefficients for perspective
	REAL*8		A11, A13	! coefficients for
	REAL*8		A21, A22, A23	! isometric views
	REAL		DIST, Z0	! projn values for perspective
	REAL		VWMINX, VWMINY	! range of
	REAL		VWMAXX, VWMAXY	! plotted view
	INTEGER*4	DIRECT		! direction of view
	INTEGER*4	INDINC		! index increment
	LOGICAL*1	PRSPVW		! view is true perspective
	COMMON /DTMBUF/ DOV,DOVSC,DEFPHI,DEFTHT,DEFZSC,DEFHOV,DIRECT,PRSPVW,
     &			PHI,THETA,SPHI,STHETA,CPHI,CTHETA,
     &			A1,A2,A11,A13,A21,A22,A23,DIST,Z0,
     &                	VWMINX,VWMINY,VWMAXX,VWMAXY,
     &		      	INDINC,HOV,XSCALE,YSCALE,ZSCALE
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	REAL		LABX,LABY	! label position in cms.
	REAL		LEGX,LEGY	! legend position in cms.
	REAL		LEGSIZ		! legend scaling factor
	REAL		EX(2,0:4)		!outside limits of each
	REAL		EY(2,0:4)		!quadrant
	REAL		SX(2,0:4)
	REAL		SY(2,0:4)
	INTEGER*4	QUAD		! quadrant to draw in
	INTEGER*4	LABSIZ		! label size 1-4
	INTEGER*4	LABCOL		! label colour
	INTEGER*2	TK_LINESTYLE	! TEK 4000 linestyle
	LOGICAL		PRIMARY_DEVICE	! supports primary device
	LOGICAL		SECONDARY_DEVICE ! Supports secondary device
	LOGICAL		PRIMARY		! primary device enabled
	LOGICAL		SECONDARY	! secondary device enabled
	LOGICAL		INIT_PRIMARY	! primary device initialised
	LOGICAL		INIT_SECONDARY	! secondary device initialised
	LOGICAL		PLOT_IFF	! output to IFF file
	LOGICAL*1	AUTO		! auto scaling of view on/off
	LOGICAL*1	SPLIT		! split screen selected?
	LOGICAL*1	ACTIVE_IFF
	LOGICAL		PICTURE(2)
	COMMON /DEVICE/ LABX,LABY,LEGX,LEGY,LEGSIZ,LABSIZ,LABCOL,
     &			AUTO,SPLIT,QUAD,
     &			TK_LINESTYLE,ACTIVE_IFF,
     &                  PRIMARY_DEVICE,SECONDARY_DEVICE,
     & 			PRIMARY,SECONDARY,INIT_PRIMARY,INIT_SECONDARY,
     &			PLOT_IFF,
     &                  SX,EX,SY,EY,PICTURE
	INTEGER		SIGMA,TEK
	PARAMETER(	SIGMA = 1,	TEK = 2)
	INTEGER	NDEVS
	PARAMETER(	NDEVS = 2)
	INTEGER		WTYPE(2)	! workstation type
	INTEGER		CONID(2)	! workstation conection ID
	INTEGER		DCUNIT		! device units -always = 0
	INTEGER		RASTSZ(2,2)	! unused arg for GQMDS
	INTEGER		VSCHHI		! SIGMA char hgt index
	INTEGER		VSCHD		! SIGMA text direction index	
	INTEGER		TKCHHI		! TEK char hgt index
	INTEGER		IFONT		! character font index
	INTEGER		IPREC		! character precision index
	INTEGER		TXTCOL		! text colour index
	INTEGER		ITX		! text segment index
	INTEGER		PLANE_MASK	! plane mask derived from NOPLNS
	INTEGER		NOPLNS		! no. of planes for terrain view
	INTEGER		OVERLAY_COLOURS	! number of overlay colours
	REAL		WMAT(6)		! segment WC transf matrix
	REAL		SCRNDX(2)	! device screen X-ranges
	REAL		SCRNDY(2)	! device screen Y-ranges
	REAL		WXMIN,WXMAX	! world window X limits
	REAL		WYMIN,WYMAX	! world window Y limits
	REAL		XCUR,YCUR	! current pen world-position
	REAL		CHUX,CHUY	! char UP-vector
	REAL		UPLEN		! length of UP-vector
	REAL		TKCHX,TKCHY	! TEK char spacing vector
	REAL		TKCHH		! TEK char height
	REAL		TKCHSP		! TEK spacing ratio
	REAL		TKCHHT(4)	! set char hgts for TEK
	REAL		VSCHHT(4)	! set char hgts for SIGMA
	REAL		MAT(6)		! segment NDC transf matrix
	REAL		NDCX,NDCY	! extent in NDC
	LOGICAL*1	VIEW_SHOWN(2,0:4)   ! had view in quad ?
	LOGICAL*1	LEGEND_SHOWN(0:4) ! had legend in quad ?
	LOGICAL*1	TEXT_SHOWN(0:4)	  ! had text in quad
	LOGICAL*1	TRANSF		! seg transformation active?
	COMMON/GKSCMN/	WTYPE,CONID,DCUNIT,RASTSZ,
     &			VSCHHI,VSCHD,TKCHHI,
     &			IFONT,IPREC,TXTCOL,ITX,
     &			WMAT,SCRNDX,SCRNDY,
     &			WXMIN,WXMAX,WYMIN,WYMAX,
     &			XCUR,YCUR,CHUX,CHUY,UPLEN,
     &			TKCHX,TKCHY,TKCHH,TKCHSP,TKCHHT,VSCHHT,
     &			VIEW_SHOWN,LEGEND_SHOWN,TRANSF,MAT,TEXT_SHOWN,
     &			PLANE_MASK,NOPLNS,NDCX,NDCY,OVERLAY_COLOURS
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
	REAL		X,Y,Z		!untransformed coords
	REAL		XX,YY		!plot (transfromed) coords
	INTEGER*4	COL		!colour index for item
	INTEGER*2	THISY		!cell height
	INTEGER*2	PREVY		!previous cell height
	INTEGER*4	RETVAL		!function return value
	INTEGER*4	DTI_READ_WORD_DATA
	INTEGER*4	ICOL
	IF(XPT.LT.DTI_WINDOW_SWX(1).OR.
     &     XPT.GT.DTI_WINDOW_NEX(1))THEN
	  STALIN=.TRUE.		!pen up ie. start new feature
          GOTO 999
	ENDIF
	IF(YPT.LT.DTI_WINDOW_SWY(1).OR.
     &     YPT.GT.DTI_WINDOW_NEY(1))THEN
	  STALIN=.TRUE.		!pen up ie. start new feature
          GOTO 999
	ENDIF
	RETVAL=DTI_READ_WORD_DATA(1,THISY,XPT,YPT)
	IF(.NOT.RETVAL)THEN
	  CALL LSL_PUTMSG(RETVAL)
	  GOTO 999
	ENDIF
	IF(BATH)THEN
	  IF(THISY.GT.0)THISY=1
	ENDIF
	IF(THISY.EQ.-32767)THEN
	  STALIN=.TRUE.
	  GOTO 999
	ENDIF
	Y = FLOAT(THISY) * YSCALE
	IF(DIRECT.EQ.1)THEN			!west
	  Z = FLOAT((XPT-1)-DTMOFX)  * ZSCALE
	  X = FLOAT(YPT-DTMOFY)  * XSCALE
	ENDIF
	IF(DIRECT.EQ.3)THEN			!east (reverse of west)
	  Z = FLOAT(NLINES-(XPT-DTMOFX))  * ZSCALE
	  X = FLOAT((NPTS+1)-(YPT-DTMOFY))  * XSCALE
	ENDIF
	IF(DIRECT.EQ.2)THEN			!south
	  Z = FLOAT((YPT-1)-DTMOFY)  * ZSCALE
	  X = FLOAT(NLINES-((XPT-1)-DTMOFX))  * XSCALE
	ENDIF
	IF(DIRECT.EQ.4)THEN			!north
	  Z = FLOAT(NPTS-(YPT-DTMOFY))  * ZSCALE
	  X = FLOAT(XPT-DTMOFX)  * XSCALE
	ENDIF
	CALL CORDTF(X,Y,Z,XX,YY)
	IF(STALIN)THEN				!invisible move required
	  IF(DEBUG)CALL WRITEF('Invisible move to %F %F',XX,YY)
          CALL G3MVTO(XX,YY)			!first pt - invis move
	  STFEAT=.FALSE.			!not yet drawn vector
	  STALIN=.FALSE.
	  PREVY=THISY
	  IF(FC.NE.-1)CURFC=FC
	ELSE
	  IF(FC.EQ.-1)THEN
	     IF(HAD_FOG.AND.PRSPVW) THEN
		IF(IN_FOG) THEN
		   COLOUR_INDEX = FOG_COLOUR
		ELSE
		   COLOUR_INDEX=ICOL(MAX(THISY,PREVY))
		ENDIF
	     ELSE
	        COLOUR_INDEX=ICOL(MAX(THISY,PREVY))
	     ENDIF	
	     CALL SET_COLOUR(COLOUR_INDEX)
	     PREVY=THISY
	  ELSE
	     IF(HAD_FOG.AND.PRSPVW) THEN
		IF(IN_FOG) THEN
		   COL = 0
		ELSE
	           COL=FRTCOL			!required colour of feature
	    	   COL=MIN(COL,OVERLAY_COLOURS)
		ENDIF
	     ELSE 
	        COL=FRTCOL			!required colour of feature
	        IF(NOPLNS.GT.4)THEN
	    	  COL=MIN(COL,OVERLAY_COLOURS)
	        ELSE
	          COL=MIN(COL,MAXCOL)
	        ENDIF
	     ENDIF
             CALL GSPLCI(COL)			!set colour index
	  ENDIF
	  IF(DEBUG)CALL WRITEF
     &      ('Visible move to %F %F - colour %N',XX,YY,COL)
          CALL G3LNTO(XX,YY)			!draw vector
	  STFEAT=.TRUE.				!now drawing feature
	  STALIN=.FALSE.
	ENDIF
999	RETURN
	END	

	SUBROUTINE IFFTRN
	IMPLICIT NONE
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	REAL		XPTS(8196)	!x coords (IFF feature)
	REAL		YPTS(8196)	!y coords (IFF feature)
	REAL		RANGE_VALUES(4)	!Map range
	REAL		WIND(2,2)	!Map window (SW,NE)
	REAL		SYMSF		!symbol scaling factor
	REAL		ORIGIN_OFFSET(2)
	INTEGER*2	PTS
	INTEGER*4	SYMX		!symbol x position (DTM units)
	INTEGER*4	SYMY		!symbol y position (DTM units)
	INTEGER*2	SYMHGT		!height at symbol position
	LOGICAL		SYMVIS		!is symbol base visible or not?
	LOGICAL		OVERLAY		!culture overlay selected?
	LOGICAL		HADIFF		!had an input IFF file
	LOGICAL		HADWIN		!true if IFF window has been
	LOGICAL		HADTMP		!temp vis grid opened on chan 2
	LOGICAL		DEBUG		!internal debug messages 
	LOGICAL		HADFRT		!we've read an FRT
	LOGICAL		HADSRI		!we've read an SRI
	LOGICAL		STFEAT
	CHARACTER*72	FRTTIT		!FRT filename
	CHARACTER*72	SRITIT		!SRI filename
	CHARACTER*255	INPUT_IFF_NAME
	INTEGER*4	INPUT_IFF_LENGTH	
	LOGICAL		MASK
	LOGICAL		HADSF		!user specified symbol scaling fac
	LOGICAL	        STALIN		!true if invisible mover required
	INTEGER*2	LAND_FC		!feature code for land profiles
	INTEGER*2	SEA_FC		!feature code for sea profiles
	INTEGER*2	LAYER		!layer for profiles
	INTEGER*2	NULL_FC		!feature code for null profiles
	INTEGER*2	TEXT_FC		!feature code for text
	COMMON/CULTRE/PTS,HADIFF,RANGE_VALUES,
     &		      WIND,HADWIN,HADTMP,DEBUG,
     &		      FRTTIT,SRITIT,HADFRT,HADSRI,STFEAT,XPTS,YPTS,
     &		      SYMHGT,SYMX,SYMY,MASK,SYMSF,HADSF,STALIN,
     &                LAND_FC,SEA_FC,LAYER,OVERLAY,NULL_FC,
     &		      TEXT_FC,INPUT_IFF_NAME,INPUT_IFF_LENGTH,
     &		      ORIGIN_OFFSET
	REAL		X_EW		! east to west IFF
	REAL		Y_NS		! north to south IFF
	X_EW = WIND(2,1)-WIND(1,1)+1
	Y_NS = WIND(2,2)-WIND(1,2)+1
	IFF_DTI(1,1) = NLINES/X_EW
	IFF_DTI(1,2) = NPTS  /Y_NS
	RETURN
	END

	SUBROUTINE INWORD(LONGWORD,WORD,MSG)
	IMPLICIT NONE
	INTEGER*4	LONGWORD	! word of bitmap to be examined
	INTEGER*4	WORD		! position of LONGWORD in bitmap
	CHARACTER*(*)	MSG		! message to pass to OTPLSTRG
	LOGICAL		STARTD		! used to flag whether output
					! has started or not
	LOGICAL		INRANGE		! used to flag whether we are
					! within a range, or not
	INTEGER*4	FIRST,SECOND	! start and end of range
	INTEGER*4	TOPBITMP	! top bit of bitmap
					! ie map goes from 0-TOPBITMP
	INTEGER*4	TOPWORD		! word of bitmap that contains
					! TOPBITMP
	INTEGER*2 OUTPTR  ! end of line pointer
	INTEGER*2 OUTTYP  ! string descriptor guff
	INTEGER*4 OUTADD  ! address part of string descriptor
	INTEGER*2 OUTLIM  ! maximum size of buffer
	BYTE OUTBUF(80)
	INTEGER OUTDSC  ! alias for OUTPTR as string descriptor
	EQUIVALENCE (OUTDSC,OUTPTR)
	COMMON/BTMAPDIS/STARTD,INRANGE,FIRST,SECOND,
     &			TOPBITMP,TOPWORD,
     &			OUTPTR,OUTTYP,OUTADD,OUTLIM,OUTBUF
					! of bit map
	INTEGER*4	LIB$EXTZV
	INTEGER*4	I		! counter
	INTEGER*4	BIT		! current bit
	INTEGER*4	NUMBER		! number represented by BIT
	NUMBER=WORD*32-33		! zero number for this word
	DO 10, I=0,31			! examine each bit in turn
	   NUMBER=NUMBER +1		! increment number
	   IF (NUMBER.GT.TOPBITMP) THEN
	      IF (INRANGE) SECOND=NUMBER-1
	      GOTO 20
	   ENDIF
	   BIT=LIB$EXTZV(I,1,LONGWORD)	! extract bit
	   IF (BIT.EQ.1) THEN		! bit is set
	      IF (.NOT.INRANGE) THEN	! change of state
		 CALL OTPLSTRG(MSG)	! output last range
		 FIRST=NUMBER		! and start a new range
		 INRANGE=.TRUE.
	      ENDIF
	   ELSE				! bit is not set
	      IF (INRANGE) THEN		! change of state
		 SECOND=NUMBER-1	! last number was end of range
		 INRANGE=.FALSE.
	      ENDIF
	   ENDIF
   10	CONTINUE			! end of loop
   20	CONTINUE
	RETURN
	END
	LOGICAL FUNCTION RDSEL(SELCMD,SAVE)
	IMPLICIT NONE
	LOGICAL*1 SELCMD	! TRUE is SEL cmd, FALSE if DES cmd.
	LOGICAL*1 SAVE		! store away the command until group
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	INTEGER*4	MAX_TXTLIM	! maximum possible buffer length
	PARAMETER	(MAX_TXTLIM = 1024)
	INTEGER*4	DEF_TXTLIM	! default buffer length
	PARAMETER	(DEF_TXTLIM = 255)
	INTEGER*2 	DCPTR   	! decode pointer
	INTEGER*2 	TXTPTR  	! end of line pointer
	BYTE		TXTTYP  	! type of fake string
	BYTE		TXTCLA  	! class of fake string
	INTEGER*4 	TXTADD  	! address of buffer
	INTEGER*2 	TXTLIM  	! actual buffer length
	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer
	INTEGER*4	TXTDSC(2)	! fake string descriptor
	EQUIVALENCE	(TXTDSC,TXTPTR)
	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF
	PARAMETER	GRPMAX_DEF = 30		! def no of groups
	PARAMETER	GRPMXC = 32768		! max FCs (0-32767)
	INTEGER*4	GRPCNT			! no of defined groups
	INTEGER*4	GRPMAX			! max no of groups
	INTEGER*4	GRPCMT_LOC		! ptr to command table
	INTEGER*4	GRPFCT_LOC		! ptr to bitmap of FCs
	INTEGER*4	GRPSAV(12)		! to save command table
	COMMON/FRTGRP/GRPMAX,GRPCNT,GRPCMT_LOC,GRPFCT_LOC,GRPSAV
	INTEGER MAXLAY		! max number of layers allowed.
	INTEGER LAYMAX		! number of longwords for layer bit map.
	INTEGER MAXFC		! max number of feature codes.
	INTEGER FCMAX		! number of longwords for FC bit map.
	INTEGER SELMAX		! max number of SEL/DES cmds allowed.
	INTEGER MAXFSN		! maximum number of FSNs allowed
	INTEGER FSNMAX		! number of longwords in FSN bit map
	PARAMETER (MAXLAY=32767)
	PARAMETER (LAYMAX=1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (MAXFC =32767)
	PARAMETER (FCMAX =1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (SELMAX=10)
	PARAMETER (MAXFSN=65535)
	PARAMETER (FSNMAX=(MAXFSN+1)/32)
	INTEGER*4 NOVRRD	! number of layer FC overrides
	INTEGER*4 LAYMAP(LAYMAX) ! bit-map for layer selection.
	INTEGER*4 FCMAP(FCMAX)	! bit-map for ft code selection.
	INTEGER*4 FSNMAP(FSNMAX)! bit-map for FSN selection
	INTEGER*4 WORD		! word position in bit-map.
	INTEGER*4 OFFSET	! bit offset in WORD.
	INTEGER	OVRDMX		! max number of overrides
	PARAMETER (OVRDMX=256)
	INTEGER*4 OVERRD(2,OVRDMX)! overriding layer/FC pairs
	INTEGER*4 PAIRS(2,40)	! range pairs read for LAY/NOL command.
	INTEGER*2 SELPTR	! pointer to last entry in SELBUF.
	BYTE SELBUF(80,SELMAX)	! for storing SEL/DES commands args in.
	BYTE SELDES(SELMAX)	! commands corresponding to SELBUF.
	LOGICAL*1 LYSMOD	! layer selection mode.
	LOGICAL*1 FCSMOD	! feature code selection mode.
	LOGICAL*1 FSNMOD	! FSN selection mode
	COMMON/SELECT/LAYMAP,FCMAP,FSNMAP,WORD,OFFSET,PAIRS,SELPTR,
     &		     SELBUF,SELDES,NOVRRD,LYSMOD,FCSMOD,OVERRD,
     &	             FSNMOD
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER	CMD		! command number
	INTEGER I		! loop controls.
	INTEGER GRPNUM		! number of group in group name table.
	INTEGER*4 TMPMAP(FCMAX)	! temporary bit-map holding 1's for the
				! selected/deselected bits for SEL/DES
				! commands respectively.
	INTEGER*2 STRPOS,ENDPOS ! start/end positions of argument list.
	BYTE COMMA		! ASCII constant
	PARAMETER	(COMMA=44)
	BYTE CHR
	INTEGER	COUNT
	INTEGER		RDCOMM
	INTEGER*4	GRPFCT		! FRTLIB
	LOGICAL*1	RDRANG,RDCHS,RDCH
	RDSEL=.FALSE.
	COUNT = 0
	CALL VIOCLR(TMPMAP,FCMAX*4)
	IF (.NOT.SAVE) GOTO 10
	IF (RDCHS(CHR)) GOTO 100
	CALL BSCH
	STRPOS=DCPTR
10	IF (RDCHS(CHR)) GOTO 50
	COUNT = COUNT+1
	IF ((CHR.GE.48).AND.(CHR.LE.57)) GOTO 20	! 0 - 9
	IF (((CHR.GE.65).AND.(CHR.LE.90)).OR.		! A - Z
     &	    ((CHR.GE.97).AND.(CHR.LE.122))) GOTO 30	! a - z
	CALL BSCH	! assume it is the next command.
	GOTO 94
20	IF (RDRANG(PAIRS(1,1),PAIRS(2,1))) GOTO 100
	IF ((PAIRS(1,1).LT.0).OR.(PAIRS(1,1).GT.MAXFC)) GOTO 97
	IF ((PAIRS(2,1).LT.0).OR.(PAIRS(2,1).GT.MAXFC)) GOTO 98
	IF (SAVE) GOTO 10
	DO 25 I=PAIRS(1,1),PAIRS(2,1)
	   WORD=I/32
	   OFFSET=I-WORD*32
	   CALL LIB$INSV(1,OFFSET,1,TMPMAP(WORD+1))
25	CONTINUE
	GOTO 10
30	IF (.NOT.SAVE) GOTO 35
31	IF (RDCH(CHR)) GOTO 50
	IF (((CHR.GE.65).AND.(CHR.LE.90)).OR.		! A - Z
     &	    ((CHR.GE.97).AND.(CHR.LE.122))) GOTO 31	! a - z
	IF ((CHR.GE.48).AND.(CHR.LE.57)) GOTO 31	! 0 - 9
	IF (CHR.EQ.COMMA) GOTO 10	! check the delimiter.
	CALL BSCH
	IF (RDCHS(CHR)) GOTO 50
	IF (CHR.EQ.COMMA) GOTO 10
	CALL BSCH
	GOTO 10
35	CALL BSCH
	IF (GRPCNT.LE.0) GOTO 95	! no groups defined for FRT
	GRPNUM=RDCOMM(%VAL(GRPCMT_LOC))
	IF (GRPNUM.LE.0) GOTO 99	! bad group name
	DO 48 I=1,FCMAX
	   TMPMAP(I)=TMPMAP(I).OR.GRPFCT(I,GRPNUM)
48	CONTINUE
	IF (RDCHS(CHR)) GOTO 50
	IF (CHR.EQ.COMMA) GOTO 10	! check the delimiter.
	CALL BSCH
	GOTO 10
50	IF (COUNT .EQ. 0) GOTO 94
	IF (SAVE) GOTO 80
	IF (SELCMD) GOTO 60
	DO 55 I=1,FCMAX
	   FCMAP(I)=FCMAP(I).AND..NOT.TMPMAP(I)
55	CONTINUE
	GOTO 1000
60	IF (FCSMOD) GOTO 70
	FCSMOD=.TRUE.		! setting to select mode.
	CALL VIOMV3(TMPMAP,FCMAX*4,FCMAP)
	GOTO 1000
70	DO 75 I=1,FCMAX
	   FCMAP(I)=FCMAP(I).OR.TMPMAP(I)
75	CONTINUE
	GOTO 1000
80	ENDPOS=DCPTR		! position of the end of command.
	IF (SELPTR.GE.SELMAX) GOTO 96
	SELPTR=SELPTR+1
	SELDES(SELPTR)=SELCMD	! remember which command it is.
	DO 90 I=1,ENDPOS-STRPOS	! store the argument list.
	   SELBUF(I,SELPTR)=TXTBUF(I+STRPOS-1)
90	CONTINUE
	GOTO 1000
94	IF(SELCMD)THEN
	   CALL WRITEF('%S Specifying command SELECT FC',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FC',ERROR_BELL)
	ENDIF
	CALL WRITEF('Unable to read FC value')
	GOTO 100
95	IF (SELCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FC',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FC',ERROR_BELL)
	ENDIF
	CALL WRITEF('No groups have been defined in the FRT.')
	GOTO 100
96	IF (SELCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FC',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FC',ERROR_BELL)
	ENDIF
	CALL WRITEF('Max number of SEL/DES commands allowed exceeded.')
	GOTO 1000
97	IF (SELCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FC',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FC',ERROR_BELL)
	ENDIF
	CALL WRITEF('Illegal feature code %^L%N.',PAIRS(1,1))
	GOTO 100
98	IF (SELCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FC',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FC',ERROR_BELL)
	ENDIF
	CALL WRITEF('Illegal feature code %^L%N.',PAIRS(2,1))
	GOTO 100
99	IF (SELCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FC',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FC',ERROR_BELL)
	ENDIF
	CALL WRITEF('Bad group name ''%S''',CMDNST)
100	RDSEL=.TRUE.		! reject the rest of the command line.
1000	RETURN
	END

	LOGICAL FUNCTION RDFSN(FSNCMD)
	IMPLICIT NONE
	LOGICAL*1 FSNCMD
	INTEGER MAXLAY		! max number of layers allowed.
	INTEGER LAYMAX		! number of longwords for layer bit map.
	INTEGER MAXFC		! max number of feature codes.
	INTEGER FCMAX		! number of longwords for FC bit map.
	INTEGER SELMAX		! max number of SEL/DES cmds allowed.
	INTEGER MAXFSN		! maximum number of FSNs allowed
	INTEGER FSNMAX		! number of longwords in FSN bit map
	PARAMETER (MAXLAY=32767)
	PARAMETER (LAYMAX=1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (MAXFC =32767)
	PARAMETER (FCMAX =1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (SELMAX=10)
	PARAMETER (MAXFSN=65535)
	PARAMETER (FSNMAX=(MAXFSN+1)/32)
	INTEGER*4 NOVRRD	! number of layer FC overrides
	INTEGER*4 LAYMAP(LAYMAX) ! bit-map for layer selection.
	INTEGER*4 FCMAP(FCMAX)	! bit-map for ft code selection.
	INTEGER*4 FSNMAP(FSNMAX)! bit-map for FSN selection
	INTEGER*4 WORD		! word position in bit-map.
	INTEGER*4 OFFSET	! bit offset in WORD.
	INTEGER	OVRDMX		! max number of overrides
	PARAMETER (OVRDMX=256)
	INTEGER*4 OVERRD(2,OVRDMX)! overriding layer/FC pairs
	INTEGER*4 PAIRS(2,40)	! range pairs read for LAY/NOL command.
	INTEGER*2 SELPTR	! pointer to last entry in SELBUF.
	BYTE SELBUF(80,SELMAX)	! for storing SEL/DES commands args in.
	BYTE SELDES(SELMAX)	! commands corresponding to SELBUF.
	LOGICAL*1 LYSMOD	! layer selection mode.
	LOGICAL*1 FCSMOD	! feature code selection mode.
	LOGICAL*1 FSNMOD	! FSN selection mode
	COMMON/SELECT/LAYMAP,FCMAP,FSNMAP,WORD,OFFSET,PAIRS,SELPTR,
     &		     SELBUF,SELDES,NOVRRD,LYSMOD,FCSMOD,OVERRD,
     &	             FSNMOD
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER I,J		! loop controls.
	INTEGER COUNT		! number of range pairs read.
	INTEGER MASK		! value to be put into bit-map.
	BYTE CHR
	LOGICAL*1 RDRANG,RDCHS
	RDFSN=.FALSE.
	COUNT=0
	MASK=0
	IF (FSNCMD) MASK=1
10	IF (RDCHS(CHR)) GOTO 30
	IF ((CHR.GE.48).AND.(CHR.LE.57)) GOTO 20	! end of cmd ?
	CALL BSCH
	GOTO 96
20	COUNT=COUNT+1
	IF (RDRANG(PAIRS(1,COUNT),PAIRS(2,COUNT))) GOTO 99
	IF ((PAIRS(1,COUNT).LT.0).OR.(PAIRS(1,COUNT).GT.MAXFSN)) GOTO 97
	IF ((PAIRS(2,COUNT).LT.0).OR.(PAIRS(2,COUNT).GT.MAXFSN)) GOTO 98
	GOTO 10
30	IF (COUNT.EQ.0) GOTO 96
	IF (.NOT.FSNCMD) GOTO 40 ! is it a SELECT or DESELECT command?
	IF (FSNMOD) GOTO 40	 ! are we in select or deselect mode?
	FSNMOD=.TRUE.
	CALL VIOCLR(FSNMAP,FSNMAX*4)	 ! reset the whole bit-map.
40	DO 60 I=1,COUNT
	   DO 50 J=PAIRS(1,I),PAIRS(2,I)
	      WORD=J/32		! which word (0-n) the bits in.
	      OFFSET=J-WORD*32	! offset into word.
	      CALL LIB$INSV(MASK,OFFSET,1,FSNMAP(WORD+1))
50	   CONTINUE
60	CONTINUE
	GOTO 1000
96	IF(FSNCMD)THEN
	   CALL WRITEF('%S Specifying command SELECT FSN',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FSN',ERROR_BELL)
	ENDIF
	CALL WRITEF('Unable to read FSN value')
	GOTO 99
97	IF (FSNCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FSN',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FSN',ERROR_BELL)
	ENDIF
	CALL WRITEF('Illegal FSN number %^L%N.',PAIRS(1,COUNT))
	GOTO 99
98	IF (FSNCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT FSN',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT FSN',ERROR_BELL)
	ENDIF
	CALL WRITEF('Illegal FSN number %^L%N.',PAIRS(2,COUNT))
99	RDFSN=.TRUE.		! reject the rest of the command line.
1000	RETURN
	END

	LOGICAL FUNCTION RDLAY(LAYCMD)
	IMPLICIT NONE
	LOGICAL*1 LAYCMD
	INTEGER MAXLAY		! max number of layers allowed.
	INTEGER LAYMAX		! number of longwords for layer bit map.
	INTEGER MAXFC		! max number of feature codes.
	INTEGER FCMAX		! number of longwords for FC bit map.
	INTEGER SELMAX		! max number of SEL/DES cmds allowed.
	INTEGER MAXFSN		! maximum number of FSNs allowed
	INTEGER FSNMAX		! number of longwords in FSN bit map
	PARAMETER (MAXLAY=32767)
	PARAMETER (LAYMAX=1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (MAXFC =32767)
	PARAMETER (FCMAX =1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (SELMAX=10)
	PARAMETER (MAXFSN=65535)
	PARAMETER (FSNMAX=(MAXFSN+1)/32)
	INTEGER*4 NOVRRD	! number of layer FC overrides
	INTEGER*4 LAYMAP(LAYMAX) ! bit-map for layer selection.
	INTEGER*4 FCMAP(FCMAX)	! bit-map for ft code selection.
	INTEGER*4 FSNMAP(FSNMAX)! bit-map for FSN selection
	INTEGER*4 WORD		! word position in bit-map.
	INTEGER*4 OFFSET	! bit offset in WORD.
	INTEGER	OVRDMX		! max number of overrides
	PARAMETER (OVRDMX=256)
	INTEGER*4 OVERRD(2,OVRDMX)! overriding layer/FC pairs
	INTEGER*4 PAIRS(2,40)	! range pairs read for LAY/NOL command.
	INTEGER*2 SELPTR	! pointer to last entry in SELBUF.
	BYTE SELBUF(80,SELMAX)	! for storing SEL/DES commands args in.
	BYTE SELDES(SELMAX)	! commands corresponding to SELBUF.
	LOGICAL*1 LYSMOD	! layer selection mode.
	LOGICAL*1 FCSMOD	! feature code selection mode.
	LOGICAL*1 FSNMOD	! FSN selection mode
	COMMON/SELECT/LAYMAP,FCMAP,FSNMAP,WORD,OFFSET,PAIRS,SELPTR,
     &		     SELBUF,SELDES,NOVRRD,LYSMOD,FCSMOD,OVERRD,
     &	             FSNMOD
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	INTEGER I,J		! loop controls.
	INTEGER COUNT		! number of range pairs read.
	INTEGER MASK		! value to be put into bit-map.
	BYTE CHR
	LOGICAL*1 RDRANG,RDCHS
	RDLAY=.FALSE.
	COUNT=0
	MASK=0
	IF (LAYCMD) MASK=1
10	IF (RDCHS(CHR)) GOTO 30
	IF ((CHR.GE.48).AND.(CHR.LE.57)) GOTO 20	! end of cmd ?
	CALL BSCH
	GOTO 96
20	COUNT=COUNT+1
	IF (RDRANG(PAIRS(1,COUNT),PAIRS(2,COUNT))) GOTO 99
	IF ((PAIRS(1,COUNT).LT.0).OR.(PAIRS(1,COUNT).GT.MAXLAY)) GOTO 97
	IF ((PAIRS(2,COUNT).LT.0).OR.(PAIRS(2,COUNT).GT.MAXLAY)) GOTO 98
	GOTO 10
30	IF (COUNT.EQ.0) GOTO 96
	IF (.NOT.LAYCMD) GOTO 40 ! is it a LAY or NOL command?
	IF (LYSMOD) GOTO 40	 ! are we in select or deselect mode?
	LYSMOD=.TRUE.
	CALL VIOCLR(LAYMAP,LAYMAX*4)	 ! reset the whole bit-map.
40	DO 60 I=1,COUNT
	   DO 50 J=PAIRS(1,I),PAIRS(2,I)
	      WORD=J/32		! which word (0-n) the bits in.
	      OFFSET=J-WORD*32	! offset into word.
	      CALL LIB$INSV(MASK,OFFSET,1,LAYMAP(WORD+1))
50	   CONTINUE
60	CONTINUE
	GOTO 1000
96	IF(LAYCMD)THEN
	   CALL WRITEF('%S Specifying command SELECT LAYER',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT LAYER',ERROR_BELL)
	ENDIF
	CALL WRITEF('Unable to read layer value')
	GOTO 99
97	IF (LAYCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT LAYER',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT LAYER',ERROR_BELL)
	ENDIF
	CALL WRITEF('Illegal layer number %^L%N.',PAIRS(1,COUNT))
	GOTO 99
98	IF (LAYCMD) THEN
	   CALL WRITEF('%S Specifying command SELECT LAYER',ERROR_BELL)
	ELSE
	   CALL WRITEF('%S Specifying command DESELECT LAYER',ERROR_BELL)
	ENDIF
	CALL WRITEF('Illegal layer number %^L%N.',PAIRS(2,COUNT))
99	RDLAY=.TRUE.		! reject the rest of the command line.
1000	RETURN
	END

	LOGICAL FUNCTION RDRANG(INT1,INT2)
	IMPLICIT NONE
	INTEGER  INT1,INT2		! integer pairs read in.
	INTEGER  COMMA,MINUS		! ascii constants.
	INTEGER*2 TEMPOS		! temporary copy of DCPTR.
	BYTE      CHAR			! last character read.
	LOGICAL*1 RDCHS,RDCH,RDLONG
	DATA COMMA,MINUS/44,45/
	RDRANG=.FALSE.
	CALL BSCH
	IF (RDCHS(CHAR)) GOTO 1000
	IF ((CHAR.LT.48).OR.(CHAR.GT.57)) GOTO 98   ! is it a digit ?
	CALL BSCH
	IF (RDLONG(INT1)) GOTO 97
	INT2=INT1
	IF (RDCHS(CHAR)) GOTO 1000
	IF ((CHAR.GE.48).AND.(CHAR.LE.57)) GOTO 5
	IF (CHAR.EQ.COMMA) GOTO 1000
	CALL DCPSAV(TEMPOS)
	IF (CHAR.EQ.MINUS) GOTO 10
5	CALL BSCH
	GOTO 1000
10	IF (RDCHS(CHAR)) GOTO 99
	IF ((CHAR.GE.48).AND.(CHAR.LE.57)) GOTO 20
	CALL DCPSET(TEMPOS-1)	! reposition to the minus sign.
	GOTO 1000
20	CALL BSCH
	IF (RDLONG(INT2)) GOTO 97
	IF (INT1.GT.INT2) GOTO 96
50	IF (RDCHS(CHAR)) GOTO 1000
	IF (CHAR.EQ.COMMA) GOTO 50
	CALL BSCH
	GOTO 1000
96	CALL WRITEF('Illegal range (%N-%N).',INT1,INT2)
	GOTO 100
97	CALL WRITEF('Error reading integer value.')
	GOTO 100
98	CALL WRITEF('Unexpected "%^B%C" character found.',CHAR)
	GOTO 100
99	CALL WRITEF('Unexpected end of line.')
100	RDRANG=.TRUE.
1000	RETURN
	END

	LOGICAL FUNCTION FOG_CMD()
	IMPLICIT NONE
	INTEGER*4	INTARG(8)
	REAL		REALAR(8)
	INTEGER*2	CMDNLE,SECNLE,STARLE
	INTEGER*4	CMDNST(2),SECNST(2),STARST(2)
	INTEGER*4	CMDFST(2)	! copy of 'descriptor' for
	INTEGER*4	CMSFST(2)	! ditto for secondary command
	INTEGER*4	CMDAST(2)	! copy of same for subject
	INTEGER*4	CMDNUM
	INTEGER*4	TABFLG,CMDFLG
	INTEGER*4	SECMDN		! secondary command number
	INTEGER*4	SECTAB		! table secondary command is to
	INTEGER*4	CMDACT,CMDICT,CMDRCT
	INTEGER*4	DEFBASE
	LOGICAL*1	ARGMSG,CMDNEG,HADDOT,NOMESS
	BYTE		INEQUAL
	LOGICAL*1	NOUFLG		! TRUE => no user flags with
	LOGICAL*1	NSUFLG		! ditto for 2ndary table
	BYTE		UNXCHR		! 'unexpected character' that
	INTEGER*4	UFLAG		! user flag found, if any
	INTEGER*4	SUFLAG		! secondary table user flag
	COMMON /LSL_CMDCOM/	INTARG,REALAR,
     &				CMDNST,SECNST,STARST,
     &				CMDFST,CMSFST,CMDAST,
     &				CMDNUM,TABFLG,CMDFLG,
     &				SECMDN,SECTAB,
     &				CMDACT,CMDICT,CMDRCT,
     &				DEFBASE,
     &				ARGMSG,CMDNEG,HADDOT,NOMESS,
     &				INEQUAL,
     &				NOUFLG,NSUFLG,UNXCHR,UFLAG,SUFLAG
	EQUIVALENCE (CMDNLE,CMDNST)
	EQUIVALENCE (SECNLE,SECNST)
	EQUIVALENCE (STARLE,STARST)
	INTEGER*4	MAX_TXTLIM	! maximum possible buffer length
	PARAMETER	(MAX_TXTLIM = 1024)
	INTEGER*4	DEF_TXTLIM	! default buffer length
	PARAMETER	(DEF_TXTLIM = 255)
	INTEGER*2 	DCPTR   	! decode pointer
	INTEGER*2 	TXTPTR  	! end of line pointer
	BYTE		TXTTYP  	! type of fake string
	BYTE		TXTCLA  	! class of fake string
	INTEGER*4 	TXTADD  	! address of buffer
	INTEGER*2 	TXTLIM  	! actual buffer length
	BYTE 		TXTBUF(MAX_TXTLIM)  	! text buffer
	INTEGER*4	TXTDSC(2)	! fake string descriptor
	EQUIVALENCE	(TXTDSC,TXTPTR)
	COMMON/LSL_TXTC/DCPTR,TXTPTR,TXTTYP,TXTCLA,TXTADD,TXTLIM,TXTBUF
	PARAMETER	MAXVRT = 200	! number of vertices to buffer
	INTEGER*4	VRTPT		! pointer on vrtx
	INTEGER*4	FTNUM		! last feature number used
	INTEGER*4	LSTCOL		! last colour plotted
	INTEGER*4	STEPS		! number of colour steps
	INTEGER*4	CSTEP		! colour step
	INTEGER*4	STPINT		! step interval
	INTEGER*4	MAXCOL		! max colours allowed
	INTEGER*4	RAPNT		! pointer to range entry
	INTEGER*4	HGTSTP(2,14)	! bathymetric height/col array
	INTEGER*4	SEABOT		! sea bottom depth
	INTEGER*4	LPOSNO		! NO position
	INTEGER*2	CURFC		! fc of current feature
	REAL		LASTX,LASTY	! current position (for IFF)
	REAL		RANGE(4)	! range (of IFF drawing)
	REAL		VRTX(2,MAXVRT)	! number of vertices
	LOGICAL*1	INFT		! in IFF feature
	LOGICAL*1	FTFLSH		! IFF ft has been flushed
	LOGICAL*1	DTICOL		! colour range DTI (or MODEL)
	LOGICAL*1	HADSTP		! had a STEP command?
	LOGICAL*1	BATH		! bath option on or off
	INTEGER*4	LNDCOL		! number of land colours
	INTEGER*4	SEACOL		! number of sea colours
	INTEGER*4	ZLOWER		! lower z limit
	INTEGER*4	ZUPPER		! upper z limit
	INTEGER*4	COLOUR_INDEX	! current colour index
	INTEGER*4	PREV_INDEX	! previous colour index
	LOGICAL		COLOUR_IFF	! start new IFF feature everytime
	LOGICAL		NULL_FEATURE	! true if null IFF feature
	INTEGER*4	TOTVRT		! total number of verts for feature
	COMMON/DRCTRL/VRTPT,FTNUM,LSTCOL,STEPS,CSTEP,STPINT,
     &		      MAXCOL,RAPNT,LASTX,LASTY,RANGE,VRTX,
     &		      INFT,FTFLSH,DTICOL,HADSTP,BATH,HGTSTP,SEABOT,
     &		      CURFC,LPOSNO,LNDCOL,SEACOL,ZLOWER,ZUPPER,
     &                COLOUR_INDEX,PREV_INDEX,COLOUR_IFF,NULL_FEATURE,
     &                TOTVRT
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	REAL		ABS_OBS_X	! absolute x coord of observer in metres
	REAL		ABS_OBS_Y	! absolute y coord of observer in metres
	REAL		ABS_OBS_Z	! absolute z coord of observer in metres
	REAL		ABS_X		! absolute x coord of DTM node in metres
	REAL		ABS_Y		! absolute y coord of DTM node in metres
	REAL		ABS_Z		! absolute z coord of DTM node in metres
	REAL		ABS_X_GRID	! x grid matrix interval in metres
	REAL		ABS_Z_GRID	! y grid matrix interval in metres
	INTEGER		FOG_COLOUR	! colour of the fog
	REAL		FOG_VISIBILITY	! visibility distance
	LOGICAL		HAD_FOG		! fog enabled
	LOGICAL		IN_FOG		! DTM node in fog
	COMMON/FOG/ 
     &		ABS_OBS_X,
     &		ABS_OBS_Y,
     &		ABS_OBS_Z,
     &		ABS_X,
     &		ABS_Y,
     &		ABS_Z,
     &		ABS_X_GRID,
     &		ABS_Z_GRID,
     &		FOG_COLOUR,
     &		FOG_VISIBILITY,
     &		HAD_FOG,
     &		IN_FOG
	LOGICAL 	OK		! return code
	INTEGER		CMD		! command number
	INTEGER 	I		! loop controls.
	EXTERNAL 	FOG_CMD_TABLE
	INTEGER 	FOG_CMD_TABLE
	INTEGER		RDCOMM
	FOG_CMD=.TRUE.		! assume success
	IF(.NOT.HAD_FOG)THEN
	   CALL WRITEF('%S Specifying command FOG',ERROR_BELL)
	   CALL WRITEF('Fog has not been enabled')
	   CALL WRITEF('Use ENABLE FOG command')
	   FOG_CMD=.FALSE.
	   GOTO 999
	ENDIF
	CMD=RDCOMM(FOG_CMD_TABLE)	
	GOTO (		100,		! unrecognised command
     &			200,		! set colour of fog
     &			300)CMD+1	! set visibility distance
100	CONTINUE
	CALL WRITEF('%S Specifying command FOG',ERROR_BELL)
	CALL WRITEF('Command qualifier are COLOUR or VISIBILITY')
	FOG_CMD=.FALSE.
	GOTO 999
200	CONTINUE
	IF((CMDICT.LT.1).OR.
     &	(INTARG(1).LT.0.OR.INTARG(1).GT.MAXCOL+2)) THEN
	   CALL WRITEF('%S Specifying command FOG COLOUR',ERROR_BELL)
	   CALL WRITEF('command requires integer colour index '//
     &	   'in the range 0 to %I0',MAXCOL+2)
	   FOG_CMD=.FALSE.
	   GOTO 999
	ENDIF
	FOG_COLOUR = INTARG(1)
	GOTO 1000
300	CONTINUE
	IF((CMDRCT.LT.1).OR.(REALAR(1).LT.0.0)) THEN
	   CALL WRITEF('%S Specifying command FOG VISIBILITY',ERROR_BELL)
	   CALL WRITEF('command requires one real argument '//
     &	   'greater than 0.0')
	   FOG_CMD=.FALSE.
	   GOTO 999
	ENDIF
	FOG_VISIBILITY = REALAR(1)
	GOTO 1000
999	CONTINUE
1000	CONTINUE
	RETURN
	END

	SUBROUTINE SHSELE
	IMPLICIT NONE
	INTEGER MAXLAY		! max number of layers allowed.
	INTEGER LAYMAX		! number of longwords for layer bit map.
	INTEGER MAXFC		! max number of feature codes.
	INTEGER FCMAX		! number of longwords for FC bit map.
	INTEGER SELMAX		! max number of SEL/DES cmds allowed.
	INTEGER MAXFSN		! maximum number of FSNs allowed
	INTEGER FSNMAX		! number of longwords in FSN bit map
	PARAMETER (MAXLAY=32767)
	PARAMETER (LAYMAX=1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (MAXFC =32767)
	PARAMETER (FCMAX =1024)	! 32768 / 32		(0 to 32767)
	PARAMETER (SELMAX=10)
	PARAMETER (MAXFSN=65535)
	PARAMETER (FSNMAX=(MAXFSN+1)/32)
	INTEGER*4 NOVRRD	! number of layer FC overrides
	INTEGER*4 LAYMAP(LAYMAX) ! bit-map for layer selection.
	INTEGER*4 FCMAP(FCMAX)	! bit-map for ft code selection.
	INTEGER*4 FSNMAP(FSNMAX)! bit-map for FSN selection
	INTEGER*4 WORD		! word position in bit-map.
	INTEGER*4 OFFSET	! bit offset in WORD.
	INTEGER	OVRDMX		! max number of overrides
	PARAMETER (OVRDMX=256)
	INTEGER*4 OVERRD(2,OVRDMX)! overriding layer/FC pairs
	INTEGER*4 PAIRS(2,40)	! range pairs read for LAY/NOL command.
	INTEGER*2 SELPTR	! pointer to last entry in SELBUF.
	BYTE SELBUF(80,SELMAX)	! for storing SEL/DES commands args in.
	BYTE SELDES(SELMAX)	! commands corresponding to SELBUF.
	LOGICAL*1 LYSMOD	! layer selection mode.
	LOGICAL*1 FCSMOD	! feature code selection mode.
	LOGICAL*1 FSNMOD	! FSN selection mode
	COMMON/SELECT/LAYMAP,FCMAP,FSNMAP,WORD,OFFSET,PAIRS,SELPTR,
     &		     SELBUF,SELDES,NOVRRD,LYSMOD,FCSMOD,OVERRD,
     &	             FSNMOD
	INTEGER		I		! loop counter
	CALL WRITEF
	DO 10, I=1,LAYMAX
	   IF (LAYMAP(I).NE.-1) THEN	! something not set
	      CALL DISPLBTMP('Following layers selected:',
     &	         'No layers selected',MAXLAY,LAYMAP)
	      GOTO 20
	   ENDIF
   10	CONTINUE
	CALL WRITEF('All layers selected')
20      DO 30, I=1,FCMAX
           IF (FCMAP(I).NE.-1) THEN	! something not set
           CALL DISPLBTMP('Following feature codes selected:',
     &	         'No feature codes selected',MAXFC,FCMAP)
	      GOTO 40
	   ENDIF
30	CONTINUE
        CALL WRITEF('All feature codes selected')
   40	DO 50, I=1,FSNMAX
	   IF (FSNMAP(I).NE.-1) THEN	! something not set
	      CALL DISPLBTMP('Following FSNs selected:',
     &	         'No FSNs selected',MAXFSN,FSNMAP)
	      GOTO 60
	   ENDIF
   50	CONTINUE
	CALL WRITEF('All FSNs selected')
   60	CALL WRITEF
	RETURN
	END
