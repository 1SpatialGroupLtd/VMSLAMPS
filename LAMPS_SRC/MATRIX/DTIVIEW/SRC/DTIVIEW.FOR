C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1999-11-08 19:32:40.000000000 +0000
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
	PROGRAM DTIVIEW
	IMPLICIT NONE
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
	INCLUDE 	'($DVIDEF)'
	INCLUDE		'($DCDEF)'
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
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
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
	BYTE		BUTTON		! puck button number
	INTEGER		IERR		! error number
	LOGICAL*1	ERR		! error?
	LOGICAL*1	HAD_VDU		! had keyboard input?	
	LOGICAL*1	TABLE		! got a table?
	INTEGER		EF_POINT	! EF for puck-button input
	INTEGER		EF_STREAM	! EF for stream-button input
	INTEGER		EF_ERROR	! EF for table monitor error
	INTEGER		EF_VDU		! event flag for input from kybd
	INTEGER		EF_LAST		! not used here -dummy
	COMMON/TAB/	EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST,
     +			IERR,BUTTON,ERR,HAD_VDU,TABLE
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
	INTEGER		MAX_SYMBOLS
	PARAMETER	(MAX_SYMBOLS = 15)
	LOGICAL		SYMBOLS		! TRUE if enabled symbols
	LOGICAL		MOVE_SYMBOLS	! TRUE if currently moving symbols
	INTEGER		SYMBOLS_DEFINED	! number of symbols defined
	INTEGER		SYMBOLS_USED	! number of symbols used
	INTEGER*4	SYMBOL_IDATA(9,MAX_SYMBOLS)	!integer form 
	LOGICAL*4	SYMBOL_LDATA(9,MAX_SYMBOLS)	!logical form 
	REAL*4		SYMBOL_RDATA(9,MAX_SYMBOLS)	!real form 
	EQUIVALENCE 	(SYMBOL_IDATA,SYMBOL_LDATA,SYMBOL_RDATA)
	COMMON/USER_SYMBOLS/ 
     &		SYMBOLS,
     &		MOVE_SYMBOLS,
     &		SYMBOLS_DEFINED,
     &		SYMBOLS_USED,
     &		SYMBOL_IDATA
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
	INTEGER*4	CMD			! decoded command number
	INTEGER		I			! integer
	INTEGER*4	IQUAD			! quadrant to clear
	INTEGER*4	NAMLEN			! filename length
	INTEGER*4	RETVAL			! function return code
	INTEGER*4	ERROR			! system error code
	INTEGER*4	VAL			! for GETDVI
	INTEGER*4	X1,Y1,X2,Y2		! two DTI points
	INTEGER*4	X_TAB,Y_TAB		! table coords
	INTEGER*4	SYM_NUM			! symbol
	INTEGER*4	OLD_DTI(2,2)		! old DTI file window
	INTEGER*4	NEW_DTI(2,2)		! new DTI file window
	INTEGER*4	MAX_ZSTEP		! maximum value for zstep 
	LOGICAL		OK			! return code
	LOGICAL		MCMD			! true if command from menu
	LOGICAL		CRT			! output to CRT?
	BYTE		CH
	CHARACTER*7	PROMPT			! program prompt
	CHARACTER*80	LINE
	CHARACTER*5	COMPASS(4)		! 4 viewing points
	CHARACTER*7	UNITS_TYPE(5)		! 4 units type
	LOGICAL		SYMBOL_UNDEFINE_MESS	! symbol undefine message
	REAL		XT1,XT2,YT1,YT2		! temp IFF window values
	CHARACTER*1	TRANSLATION		! log name translation
	LOGICAL		DEFAULT_WINDOW		! default windows
	EXTERNAL	DTIVIEW_CMD_TABLE
	EXTERNAL	ENABLE_CMD_TABLE	! enable/disable qualifiers
	EXTERNAL	LABEL_CMD_TABLE		! label qualifiers
	EXTERNAL	LEGEND_CMD_TABLE	! legend qualifiers
	EXTERNAL	SETUP_CMD_TABLE		! setup qualifiers
	EXTERNAL	SET_CMD_TABLE		! set commands
	EXTERNAL	DEFAULT_CMD_TABLE	! default commands
	EXTERNAL	SHOW_CMD_TABLE		! show qualifiers
	EXTERNAL	COMPASS_CMD_TABLE	! compass points
	EXTERNAL	SEL_CMD_TABLE		! select qualifiers
	EXTERNAL	UNIT_CMD_TABLE		! units qualifiers
	EXTERNAL	DRAW_CMD_TABLE		! draw qualifiers
	EXTERNAL	CLEAR_CMD_TABLE		! clear qualifiers
	EXTERNAL	CTRLCAST
	EXTERNAL 	PUT_OUTPUT
	INTEGER*4	DTI_PRINT_HEADER	! to print DTI header details
	INTEGER*4	DTI_CLOSE		! to unmap a DTI file
	INTEGER*4	DTI_CREATE		! to create a DTI file
	INTEGER*4	DTI_UNITS		! tests for valid units
	INTEGER		SYS$ASSIGN		! assign I/O channels
	INTEGER*4	LIB$SPAWN		! spawns DCL operations
	INTEGER*4	LIB$DELETE_FILE		! to delete temporary files 
						! created by culture overlay 
						! option
	INTEGER		LIB$GETDVI		! get term characteristics etc.
	INTEGER*4	LIB$FIND_FILE		! to test for presence of
	INTEGER*4	GETFILNAM		! filename parsing
	INTEGER*4	TEST_TERM		! input a terminal?
	INTEGER*4 	FLRSEL			! select unit
	INTEGER*4 	FLRLIN			! read line from a command file
	INTEGER*4	FLRCLO			! to close indirect command file
	INTEGER*4	TRNALL			! translate logical name
	INTEGER*4	RDCOMM			! parse command against command
	LOGICAL		DTMJPI			! process info introduction
	LOGICAL		RDREAL			! read real
	LOGICAL		RDLONG			! read long
	LOGICAL		RDCHS			! read character
	LOGICAL		RDCH			! read character
	LOGICAL		HAD_PUCK		! had puck input?
	LOGICAL		READ_PUCK		! read puck input
	LOGICAL		IN_MENU			! table coords in menu area?
	LOGICAL		INIT_TAB		! initialise table monitor
	LOGICAL		WAIT_INPUT		! wait for kybd or table input
	LOGICAL		FRTINI			! to read FRT file
	LOGICAL		SRIINI			! to read SRI file
	LOGICAL		RDSEL			! read fc selection
	LOGICAL		RDLAY			! read layer selection
	LOGICAL		RDFSN			! read fsn. selection
	LOGICAL		TSTWK			! returns availability of a
						! primary or sec device and id
	LOGICAL		GET_DTI_COORDS		! do that
	LOGICAL		OPEN_FILE		! routine to map DTI file
	LOGICAL		OPEN_IFF_FILE		! routine to open input IFF 
	LOGICAL		CREATE_IFF_FILE		! routine to create an output
						! IFF file
	LOGICAL		GET_PROFILE_POINTS	! read profile start and end
	LOGICAL		GET_WINDOW_POINTS	! read window coordinates
	LOGICAL		PROCESS_SYMBOLS		! process symbols
	LOGICAL		CLEAR_SYM_CMD		! clear symbol 
	LOGICAL		SYMBOL_CMD		! symbol parameters
	LOGICAL		FOG_CMD			! fog parameters
	LOGICAL		EXTRA_OK		! .t. if extra DTIVIEW options
	DATA BOXMAP/ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     +	             1, 2, 3, 4, 5, 6, 7, 8, 0,17,18,11, 0,
     +		    12,13,14,15, 0,16, 9,10, 0,19,20,21, 0,
     +		     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     +		    25,24,35,36,26,27,28,29,30,31,32,33,34,
     +		    22,23,37,38,39,40, 0, 0, 0, 0, 0, 0, 0,
     +		     0, 0,41,42,43,44,49,50,53,54,55,58,59,
     +		     0, 0,45,46,47,48,52,51, 0,57,56,60,61/
	CALL LSL_INIT(.TRUE.)		! initialise LSLLIB
	CALL SET_TXTLIM(80)		! set max line length
	CALL LSL_SET_OUTPUT(PUT_OUTPUT)
	CALL DTI_INIT
	OK = DTMJPI()
	CALL GOPKS(6)
	PROMPT = 'DTIVIEW'
	COMPASS(1) = 'WEST'
	COMPASS(2) = 'SOUTH'
	COMPASS(3) = 'EAST'
	COMPASS(4) = 'NORTH'
	UNITS_TYPE(1)='MATRIX'
	UNITS_TYPE(2)='METRES'
	UNITS_TYPE(3)='SECONDS'
	UNITS_TYPE(4)='LATLONG'
	UNITS_TYPE(5)='PROJECTION'
	UNITS=1
	DEFHOV = 300.0			! height of view (metres)
	DOV    = 300.0			! distance (metres)
	DEFPHI = 45.0			! phi (x rotation)
	DEFTHT = -30.0			! theta (y rotation)
	DEFZSC = 1.0			! vertical exaggeration
	DIRECT = 1			! viewing direction from west
	X_SAMPLE = 1                    ! x sampling interval
	Y_SAMPLE = 1                    ! y sampling interval
	FOG_COLOUR     = 0		! black
	FOG_VISIBILITY = 1000.0		! visibility 1000.0 metres
	PICTURE(1)	= .TRUE.	! picture 1 enabled
	PICTURE(2)	= .TRUE.	! picture 2 enabled
	NOPLNS    	= 5
	PLANE_MASK 	= 2**NOPLNS-1
        LNDCOL 		= (2**NOPLNS)-3
	OVERLAY_COLOURS = (2**(8-NOPLNS))-1
	MAXCOL 		= LNDCOL
	STEPS 		= LNDCOL	! number of display colours
	SEACOL		= 14		! max sea colours
	LYSMOD = .FALSE.
	FCSMOD = .FALSE.
	FSNMOD = .FALSE.
	CALL VIOCLR(LAYMAP,LAYMAX*4,-1)	! reset the whole bit-map.
	CALL VIOCLR(FCMAP,FCMAX*4,-1)	! reset the whole bit-map.
	CALL VIOCLR(FSNMAP,FSNMAX*4,-1)	! reset the whole bit-map.
	AUTO    = .TRUE.		! ENABLE AUTOSCALE
	FISHNET = .FALSE.		! no fishnet representation
	DTICOL  = .TRUE.		! colours over whole DTI
	HADSTP  = .FALSE.		! not had STEP command
	BATH    = .FALSE.		! bathymetry option not selected
	COLOUR_IFF = .FALSE.		! don't create a new IFF feature
	HAD_ABSOLUTE = .TRUE.		! absolute coordinates
	HADFRT       = .FALSE.
	LAND_FC  = 1			! fc. for land profiles
	SEA_FC   = 2			! fc. for sea profiles
	LAYER    = 1                    ! layer in output IFF file
	NULL_FC  = 3			! fc for points outside ZLIMITS
	TEXT_FC  = 64			! fc. for text
	MASK  = .TRUE.			! don't mask below culture
	SYMSF = 1.0			! symbol scaling factor
	TK_LINESTYLE = 1		! TEK 4000 linestyle index
	LABSIZ = 1
	LABX   = 0.5			! centre of
	LABY   = 0.5			! screen
	LABCOL = 1
	LEGSIZ = 0.25
	LEGX   = 0.005
	LEGY   = 0.15
	NX_MNU = 13			! menu has 13 columns
	NY_MNU = 8			! menu has 8 rows
	PRIMARY          =.FALSE.	! primary device not enabled
	SECONDARY        =.FALSE.	! secondary device not enabled
	INIT_PRIMARY     =.FALSE.	! primary device not initialised	
	INIT_SECONDARY   =.FALSE.	! secondary device not intialised
	PRIMARY_DEVICE   =.FALSE.	! primary device supported?
	SECONDARY_DEVICE =.FALSE.       ! secondary device supported?
	PLOT_IFF         =.FALSE.	! DISABLE IFF_OUTPUT
	MENU_SET = .FALSE.		! menu not yet located
	MAP_SET  = .FALSE.		! map not yet located
	QUAD   = 0			! full
	SPLIT  = .FALSE.		! screen
	HADTMP = .FALSE.		! no temporary files
	HADIFF = .FALSE.		! input IFF file not yet 
	DEBUG  = .FALSE.		! internal debug messages
					! switched off
	OVERLAY = .FALSE.		! culture overlay option is
	CMDFIL = .TRUE.			! assume so
	RETVAL = TEST_TERM('SYS$INPUT',TERM,IERR)
	IF (.NOT.RETVAL) THEN
	   IF (RETVAL.EQ.LSL__SYSERR) THEN
	      CALL LSL_PUTMSG(IERR)
	   ELSE
	      CALL LSL_PUTMSG(RETVAL)
	   ENDIF
	ELSE
	   CMDFIL = .NOT.TERM		! input from command file
	ENDIF
	CTRLC = .FALSE.
	IF (.NOT.CMDFIL) THEN
	  IERR = SYS$ASSIGN('SYS$INPUT',IN_CHAN,,)
	  IF (.NOT.IERR) THEN
	    CALL LSL_PUTMSG(IERR)
	    GOTO 9000		! exit
	  ENDIF
	  CALL SET_OUTBAND_AST(CTRLCAST,8)
	ENDIF
	HADQIO = .FALSE.	! no QIO active
	IERR=LIB$GETDVI(DVI$_DEVCLASS,,'SYS$OUTPUT',VAL,,)
	IF (IERR) THEN			! success
	   IF (VAL.EQ.DC$_TERM)TERM=.TRUE. ! it is a terminal
	ELSE
	   CALL LIB$SIGNAL(%VAL(IERR))
	ENDIF
	IF(TERM)THEN
	  IERR=LIB$GETDVI(DVI$_TT_SCOPE,,'SYS$OUTPUT',VAL,,)
	  IF (IERR) THEN
	     CRT=VAL.EQ.1
	  ELSE
	     CALL LIB$SIGNAL(%VAL(IERR))
	  ENDIF	
	  IERR = SYS$ASSIGN('SYS$OUTPUT',OUT_CHAN,,)
	  IF (.NOT.IERR) THEN
	    CALL LSL_PUTMSG(IERR)
	    GOTO 9000		! exit
	  ENDIF
	ELSE
	  CRT=.FALSE.
	ENDIF
	TABLE=.TRUE.			! initial assumption
	RETVAL = TRNALL('LSL$AUTO_ENABLE_TABLE',TRANSLATION)
	IF(.NOT.RETVAL.OR.TRANSLATION.NE.'1')THEN
	   TABLE = .FALSE.
	   GOTO 5
	ELSE
	   TABLE = .TRUE.
	ENDIF
	IF(TABLE) THEN
	   IF (INIT_TAB(,IERR)) THEN
	      CALL WRITEF
     &	      ('%S Error initialising table monitor',WARN_BELL)
	       CALL WRITEF
     &        ('DTIVIEW will assume no table is available')
	      TABLE=.FALSE.
	      GOTO 4
	   ENDIF
	ENDIF
	CALL RETURN_EFN(EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST)
	GOTO 5
4	EF_VDU=4
5	TXTPTR = 80
10	CTRLC = .FALSE.			! clear any CTRL/C
	IF(HAD_INDIRECT_FILE)THEN
	  RETVAL = FLRSEL(9)
	  RETVAL = FLRLIN()
	  IF(RETVAL.NE.LSL__NORMAL)THEN
	    IF(RETVAL.NE.LSL__EOF)THEN
	      CALL WRITEF('%S Reading from command file',ERROR_BELL)
              CALL WRITEF('Returning to terminal input')
	    ELSE
	      CALL WRITEF('End of command file detected')
	    ENDIF
	    GOTO 4850		!to close the file 
	  ELSE
	    CALL BSLN
	    CALL EXPAND('DTIVIEW> ')
	    CALL APPEND(TXTDSC)
	    CALL TTWSTR
	  ENDIF
	  HAD_VDU=.TRUE.	!treat as though cmd read from terminal
	  GOTO 20
	ENDIF
	IF (.NOT.WAIT_INPUT(PROMPT,.TRUE.,.TRUE.)) GOTO 9000
20	CONTINUE
	IF (HAD_VDU) THEN
	  MOVE_SYMBOLS = .FALSE.
	  MCMD=.FALSE.
	  NOMESS=.FALSE.
	  IF (RDCHS(CH)) GOTO 10	! empty line
	  IF (CH.EQ.'!') GOTO 10	! comment!
	  IF (CH.EQ.'@') GOTO 8000	! open indirect command file
	  CALL BSLN
	  CMD = RDCOMM(DTIVIEW_CMD_TABLE)	! read keyboard command line
	  IF(CMD.LE.0)THEN
	    CALL WRITEF('%S Specifying DTIVIEW command',ERROR_BELL)
            GOTO 10		! unrecognised command
	  ENDIF
	  NOMESS=.TRUE.
	  GOTO (
     &	  100,       200,      300,      400,   
     &	  9000,      500,      600,      700,
     &	  800,       900,      1000,     1100,
     &    1200,      1300,     1400,     1500,
     &    1600,      1700,     1800,     
     &	  2100,      2200,     2300,
     &    2600,      2700,     2800,     2900,
     &    3000,      3100,     3200,     3300,
     &	  3400,      3500,     3600,     3700, 
     &    3900,      4000,     4100,
     &    4300,      4400,     4500,     4600,
     &	  4700,      4800,     4900), CMD
	ELSEIF (HAD_PUCK(IERR)) THEN
	  IF (READ_PUCK(BUTTON,X_TAB,Y_TAB,IERR)) THEN
	    CALL SHOW_ERROR(IERR)
	    GOTO 10
	  ENDIF
	  IF(IN_MENU(X_TAB,Y_TAB,CMD)) THEN	!from menu
	    MOVE_SYMBOLS = .FALSE.
	    MCMD=.TRUE. 
	  GOTO (
     &   610,    620,    630,    695,   		!4
     &   670,    615,   3900,   3900,			!8
     &  3900,   3900,    350,    640,   		!12
     &   680,	 690,    645,    615,			!16
     &   100,    200,   3100,   3200,  3400,		!21
     &   800,    800,    800,    800,			!25
     &  1100,	1200,					!27
     &  1500,   1400,   1600,   3300,  2600,		!32
     &  2600,   2700,   1000,    900,  1300,		!37
     &  1700,   1800,   3030,    510,   570,		!42
     &   520,    530,    540,    550,   580,		!47
     &   560,    2100,   2100,  2100,   2100,   	!52
     &  2200,    2200,   2200,  2200,   2200,		!57
     &  4400,    4400,   4400,  4400) CMD		!61
	  ELSE
	     SYM_NUM = BUTTON
	     OK = PROCESS_SYMBOLS(SYM_NUM,X_TAB,Y_TAB,.TRUE.)  
	  ENDIF
	ENDIF
	GOTO 10
100	IF(MCMD)THEN
          CALL WRITEF('%S> FILEIN',PROMPT)
	  GOTO 102
	ENDIF
	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command FILEIN',ERROR_BELL)
	  CALL WRITEF('Input DTI filename is missing')
	  GOTO 102
	ELSE
	  CALL BSCH
	ENDIF
101	IF(.NOT.OPEN_FILE(1))THEN
102	  CALL BSLN
	  IF(.NOT.WAIT_INPUT('Input DTI filename',.FALSE.,.TRUE.))
     &    GOTO 10
	  GOTO 101
	ENDIF
	ZLOWER=MIN_WVALUE(1)
	ZUPPER=MAX_WVALUE(1)
	HADSTP=.FALSE.
	CALL SETCOL
	RETVAL = TRNALL('LSL$MATRIX_DEFAULT_WINDOW',TRANSLATION)
	IF(.NOT. RETVAL.OR.TRANSLATION.NE.'1')THEN
	   DEFAULT_WINDOW=.FALSE.
	ELSE
	   DEFAULT_WINDOW=.TRUE.
	ENDIF
	DTI_WINDOW_SWX(1) = 1
	DTI_WINDOW_SWY(1) = 1
	IF(DEFAULT_WINDOW)THEN
	   DTI_WINDOW_NEX(1) = MIN(200,X_EXTENT(1))
	   DTI_WINDOW_NEY(1) = MIN(200,Y_EXTENT(1))
	ELSE
	   DTI_WINDOW_NEX(1) = X_EXTENT(1)
	   DTI_WINDOW_NEY(1) = Y_EXTENT(1)
	ENDIF	   
	CALL WRITEF(' ')
	IERR=DTI_PRINT_HEADER(1,UNITS,HAD_ABSOLUTE)
	IF(.NOT.IERR)CALL LSL_PUTMSG(IERR)
	NLINES  = DTI_WINDOW_NEX(1)
	NPTS    = DTI_WINDOW_NEY(1)
	DTMOFX  = 0
	DTMOFY  = 0
	MODMIN  = 0
	MODMAX  = 0
	IF(SYMBOLS_DEFINED.GT.0) THEN
	   CALL WRITEF('%S symbols in current view will be '//
     &	   'flagged as unused',WARN_BELL)
	   CALL WRITEF('If you attempt to move symbol '//
     &	   'it will not be cleared prior to redrawing')
	   DO 110 I = 1,MAX_SYMBOLS
	      IF(SYMBOL_LDATA(6,I)) THEN
	         SYMBOL_LDATA(6,I) = .FALSE.
	         SYMBOLS_USED = SYMBOLS_USED - 1
	      ENDIF
110	   CONTINUE
	ENDIF
	IF (HADIFF .AND. (.NOT.HADWIN)) THEN
	   CALL SET_IFFWIN	! set up default IFF window
	ENDIF
	IF (HADIFF) CALL IFFTRN	! set up IFF/DTI transformation matrix
	GOTO 10
200	IF(MCMD)CALL WRITEF('%S> WINDOW',PROMPT)
	IF(.NOT.DTILUN_INUSE(1))THEN
	  CALL WRITEF('%S Specifying command WINDOW',ERROR_BELL)	  
	  CALL WRITEF('The input DTM must be specified before WINDOW')
	  GOTO 10
	ENDIF
	OLD_DTI(1,1) = DTI_WINDOW_SWX(1)
	OLD_DTI(2,1) = DTI_WINDOW_NEX(1)
	OLD_DTI(1,2) = DTI_WINDOW_SWY(1)
	OLD_DTI(2,2) = DTI_WINDOW_NEY(1)
	IF(.NOT.GET_WINDOW_POINTS(MCMD))GOTO 10
	NEW_DTI(1,1) = DTI_WINDOW_SWX(1)
	NEW_DTI(2,1) = DTI_WINDOW_NEX(1)
	NEW_DTI(1,2) = DTI_WINDOW_SWY(1)
	NEW_DTI(2,2) = DTI_WINDOW_NEY(1)
        NLINES = (DTI_WINDOW_NEX(1)-DTI_WINDOW_SWX(1))+1
	NPTS   = (DTI_WINDOW_NEY(1)-DTI_WINDOW_SWY(1))+1
	DTMOFX = DTI_WINDOW_SWX(1)-1
	DTMOFY = DTI_WINDOW_SWY(1)-1
	MODMIN = 0		! new window, so window
	MODMAX = 0		! height limits not yet known
	IF(HADIFF)THEN 
	   CALL RESET_IFFWIN(OLD_DTI,NEW_DTI,WIND,WIND)	
	   CALL IFFTRN	! set up IFF/DTI transformation matrix
	ENDIF
	GOTO 10
300	IF(.NOT.TABLE)THEN
	  CALL WRITEF('%S Specifying command SETUP',ERROR_BELL)
	  CALL WRITEF
     &	  ('Command is invalid if the table has not been initialised')
	  GOTO 10
	ENDIF
	CMD = RDCOMM(SETUP_CMD_TABLE)	
	IF (CMD.LE.0) THEN	! qualifier unrecognised
	  CALL WRITEF('%S Specifying command SETUP',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are MAP or MENU')
	  GOTO 10 
	ENDIF
	IF(CMD.EQ.1)THEN		!map
350	  IF(MCMD)CALL WRITEF('%S> SETUP MAP',PROMPT)
	  IF(.NOT.DTILUN_INUSE(1))THEN
	    CALL WRITEF('%S Specifying command SETUP MAP',ERROR_BELL)
	    CALL WRITEF
     &      ('The input DTM must be specified before SETUP MAP')
	    GOTO 10
	  ENDIF
	  CALL SET_MAP
	  GOTO 10
	ENDIF
	IF(CMD.EQ.2)THEN		!menu
	  CALL SET_MENU
	  GOTO 10
	ENDIF
400	CALL HELP
	GOTO 10
500	CMD = RDCOMM(SHOW_CMD_TABLE)	
	IF (CMD.LE.0) THEN	! qualifier unrecognised
	  CALL WRITEF('%S Specifying command SHOW',ERROR_BELL)
	  CALL WRITEF('SHOW options are
     & ANNOTATION, DEVICE, ENABLE, IFF, FILEIN')
	  CALL WRITEF('                 SELECTIONS, SETTINGS, '//
     &    'SYMBOLS or VIEW')
	  GOTO 10 
	ENDIF
	GOTO (510,520,530,540,550,560,570,580,590)CMD	
510	IF(MCMD)CALL WRITEF('%S> SHOW ANNOTATION',PROMPT)
	CALL WRITEF
	CALL WRITEF('Label Position  : %F5.3 %F5.3',LABX,LABY)
	CALL WRITEF('Label Size      : %N',LABSIZ)
	CALL WRITEF('Label Colour    : %N',LABCOL)
	CALL WRITEF
	CALL WRITEF('Legend Position : %F5.3 %F5.3',LEGX,LEGY)
	CALL WRITEF('Legend Size     : %F3.2',LEGSIZ)
	CALL WRITEF
	GOTO 10
520	IF(MCMD)CALL WRITEF('%S> SHOW ENABLE',PROMPT)
	CALL WRITEF
	CALL WRITEF('Current status:')
	CALL WRITEF(' ')
	CALL EXPAND('ABSOLUTE       ')
	IF(HAD_ABSOLUTE)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('AUTOSCALE      ')
	IF(AUTO)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('BATHYMETRY     ')
	IF(BATH)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL EXPAND ('COLOUR_IFF     ')
	IF(COLOUR_IFF)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('DIVIDE         ')
	IF(SPLIT)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('FISHNET        ')
	IF(FISHNET)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL EXPAND('FOG            ')
	IF(HAD_FOG)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('GRAPHICS       ')
	IF(PRIMARY.OR.SECONDARY)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('IFF_OUTPUT     ')
	IF(PLOT_IFF)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL EXPAND('OVERLAY        ')
	IF(OVERLAY)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('PICTURE 1      ')
	IF(PICTURE(1))THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('PICTURE 2      ')
	IF(PICTURE(2))THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL EXPAND('PRIMARY        ')
	IF(PRIMARY)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('SECONDARY      ')
	IF(SECONDARY)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('SYMBOLS        ')
	IF(SYMBOLS)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL EXPAND('TABLE          ')
	IF(TABLE)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL WRITEF(' ')
	GOTO 10
530	IF(MCMD)CALL WRITEF('%S> SHOW IFF',PROMPT)
	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command SHOW IFF',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
	CALL WRITEF
	IF(.NOT.HADIFF)THEN
	  CALL WRITEF
	  CALL WRITEF
     &    ('%S The input IFF file is undefined',WARN_BELL)
	  CALL WRITEF
	  GOTO 10
	ENDIF
	CALL WRITEF
	CALL WRITEF('%S',INPUT_IFF_NAME(1:INPUT_IFF_LENGTH))
	CALL WRITEF
	CALL WRITEF('IFF file range:')
	IF (HAD_ABSOLUTE)THEN
	   CALL WRITEF
     &          ('SW: %F9.1 %F9.1  NE: %F9.1 %F9.1',
     &          RANGE_VALUES(1)+ORIGIN_OFFSET(1),
     &          RANGE_VALUES(3)+ORIGIN_OFFSET(2),
     &	        RANGE_VALUES(2)+ORIGIN_OFFSET(1),
     &          RANGE_VALUES(4)+ORIGIN_OFFSET(2))
	ELSE
	   CALL WRITEF
     &          ('SW: %F9.1 %F9.1  NE: %F9.1 %F9.1',
     &          RANGE_VALUES(1),
     &          RANGE_VALUES(3),
     &	        RANGE_VALUES(2),
     &          RANGE_VALUES(4))
	ENDIF
	CALL WRITEF('IFF file window :')
	IF (HAD_ABSOLUTE) THEN
	   CALL WRITEF
     &          ('SW: %F9.1 %F9.1  NE: %F9.1 %F9.1',
     &          WIND(1,1)+ORIGIN_OFFSET(1),
     &          WIND(1,2)+ORIGIN_OFFSET(2),
     &	        WIND(2,1)+ORIGIN_OFFSET(1),
     &          WIND(2,2)+ORIGIN_OFFSET(2))
	ELSE
	   CALL WRITEF
     &          ('SW: %F9.1 %F9.1  NE: %F9.1 %F9.1',
     &          WIND(1,1),
     &          WIND(1,2),
     &	        WIND(2,1),
     &          WIND(2,2))
	ENDIF
	CALL WRITEF
	GOTO 10
540	IF(MCMD)CALL WRITEF('%S> SHOW FILEIN',PROMPT)
	IF(.NOT.DTILUN_INUSE(1))THEN
	  CALL WRITEF
	  CALL WRITEF
     &    ('%S The input DTI file is undefined',WARN_BELL)
	  CALL WRITEF
	  GOTO 10
	ENDIF
	CALL WRITEF
	RETVAL=DTI_PRINT_HEADER(1,UNITS,HAD_ABSOLUTE)
	IF(.NOT.RETVAL)CALL LSL_PUTMSG(RETVAL)
	GOTO 10
550	IF(MCMD)CALL WRITEF('%S> SHOW SELECTIONS',PROMPT)
	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command SHOW SELECTIONS',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
	CALL SHSELE			! to show selections
	GOTO 10
560	IF(MCMD)CALL WRITEF('%S> SHOW VIEW',PROMPT)
	CALL WRITEF
	CALL WRITEF('Theta                : %F0.2', DEFTHT)
	CALL WRITEF('Phi                  : %F0.2', DEFPHI)
	CALL WRITEF('Viewing direction    : From the %S',COMPASS(DIRECT))
	CALL WRITEF('Vertical exaggeration: %F0.2', DEFZSC)
	CALL WRITEF('Viewing distance     : %F0.2', DOV)    
	CALL WRITEF('Height of view       : %F0.2', DEFHOV)
	IF(HAD_FOG) THEN
	   CALL WRITEF
	   CALL WRITEF('Fog colour index     : %I0',FOG_COLOUR)
	   CALL WRITEF('Visibility distance  : %F0.2',FOG_VISIBILITY)
	ENDIF
	CALL WRITEF
	CALL WRITEF('Z Limits             : %N to %N',ZLOWER,ZUPPER)
	CALL WRITEF('Z Step               : %N',STPINT)
	CALL WRITEF
	CALL WRITEF('Sampling interval along columns : %N',X_SAMPLE)
	CALL WRITEF('Sampling interval along rows    : %N',Y_SAMPLE)
	CALL WRITEF
	GOTO 10
570	IF(MCMD)CALL WRITEF('%S> SHOW DEVICE',PROMPT)
	CALL WRITEF(' ')
	CALL EXPAND('PRIMARY        ')
	IF(PRIMARY)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL APPEND('SECONDARY      ')
	IF(SECONDARY)THEN
	  CALL APPEND('   On       ')
	ELSE
	  CALL APPEND('  Off       ')
	ENDIF
	CALL TTWLIN
	CALL WRITEF
	CALL WRITEF('%N Planes allocated to PICTURE 1',NOPLNS)
	IF(NOPLNS.NE.4)
     &  CALL WRITEF('%N Planes allocated to PICTURE 2',8-NOPLNS)
	CALL WRITEF
	CALL WRITEF('Maximum number of colours  for terrain view : %N',
     &  MAXCOL)
	CALL WRITEF('Number of colours selected for terrain view : %N',
     &	STEPS)
	CALL WRITEF('Maximum number of overlay colours           : %N',
     &  OVERLAY_COLOURS)        
	CALL WRITEF
	IF(SPLIT)THEN
	  CALL WRITEF('Divided screen is enabled')
	  CALL WRITEF('Current quadrant number : %N',QUAD)
	ELSE
	  CALL WRITEF('Full screen is enabled')
	ENDIF
	CALL WRITEF
	IF(AUTO)THEN
	  CALL WRITEF('AUTOSCALE is enabled')
	ELSE
	  CALL WRITEF('AUTOSCALE is disabled')
          CALL WRITEF
     &    ('Origin (NDC)    : %F0.2 %F0.2', MAT(5),MAT(6))
	  CALL WRITEF
     &    ('Scale factor    : %F0.2',MAT(1))
	ENDIF
	CALL WRITEF
	GOTO 10
580	IF(MCMD)CALL WRITEF('%S> SHOW SETTINGS',PROMPT)
	CALL WRITEF(' ')
	CALL WRITEF('Current Settings:')
	CALL WRITEF
	CALL EXPAND('LAND_FC      ')
	CALL APPEND('%^W%I5       ',LAND_FC)
	CALL APPEND('LAYER        ')
	CALL APPEND('%^W%I5       ',LAYER)
	CALL APPEND('LINE_STYLE   ')
	CALL APPEND('%I5',TK_LINESTYLE)
	CALL TTWLIN
	CALL WRITEF
	CALL EXPAND('ORIGIN     ')
	CALL APPEND('%F5.2 %F5.2   ',MAT(5),MAT(6))
	CALL APPEND('NULL_FC      ')
	CALL APPEND('%^W%I5       ',NULL_FC)
	CALL APPEND('SCALE        ')
	CALL APPEND('%F5.2',MAT(1))
	CALL TTWLIN
	CALL WRITEF
	CALL EXPAND('SEA_FC       ')
	CALL APPEND('%^W%I5       ',SEA_FC)
	CALL APPEND('SYMBOL_SCALE ')
	CALL APPEND('%F5.2       ',SYMSF)
	CALL APPEND('TEXT_FC      ')
	CALL APPEND('%^W%I5',TEXT_FC)
	CALL TTWLIN
	CALL WRITEF
	GOTO 10
590	CONTINUE
	CALL SHOW_SYMBOLS
	GOTO 10
600	CMD = RDCOMM(ENABLE_CMD_TABLE)
	GOTO
     &  (610,620,630,640,650,670,680,690,695,615,625,635,665,685,675)
     &  CMD	
	CALL WRITEF('%S Specifying command ENABLE',ERROR_BELL)
	CALL WRITEF
     &  ('Command qualifiers are '// 
     &  'ABSOLUTE, AUTOSCALE, BATHYMETRY, COLOUR_IFF, DIVIDE ')
	CALL WRITEF
     &  ('                       '//
     &  'FISHNET, FOG, GRAPHICS, IFF_OUTPUT, OVERLAY')
	CALL WRITEF
     &  ('                       '//
     &  'PICTURE, PRIMARY, SECONDARY, SYMBOLS or TABLE')
	GOTO 10
610	IF(MCMD.AND.AUTO)GOTO 710
	AUTO=.TRUE.
	IF(MCMD)CALL WRITEF('%S> ENABLE AUTOSCALE',PROMPT)
	GOTO 10
615	IF(MCMD)THEN
	  IF(CMD.EQ.6)THEN
	    INTARG(1)=1
	    IF(PICTURE(1))GOTO 715
	    CALL WRITEF('%S> ENABLE PICTURE 1',PROMPT)
	  ELSE
	    INTARG(1)=2
	    IF(PICTURE(2))GOTO 715
	    CALL WRITEF('%S> ENABLE PICTURE 2',PROMPT)
	  ENDIF
	ENDIF
	IF(.NOT.(PRIMARY.OR.SECONDARY))THEN
	  CALL WRITEF('%S Specifying command ENABLE PICTURE',ERROR_BELL)
	  CALL WRITEF('No graphics device is currently enabled')
	  GOTO 10
	ENDIF
	IF(NOPLNS.EQ.4)THEN
	  CALL WRITEF('%S Specifying command ENABLE PICTURE',ERROR_BELL)
	  CALL WRITEF
     &    ('Command is not valid for a 4 planes graphics device')
	  GOTO 10
	ENDIF
	IF(MCMD)GOTO 617
	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command ENABLE PICTURE',ERROR_BELL)
	  CALL WRITEF('Command requires an integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.2)THEN
	  CALL WRITEF('%S Specifying command ENABLE PICTURE',ERROR_BELL)
	  CALL WRITEF('Command requires a picture number of 1 or 2')
	  GOTO 10
	ENDIF
617	IF(INTARG(1).EQ.1)THEN
	  IF(PICTURE(2))THEN
	    IF(PRIMARY.AND.(WTYPE(1).NE.9900))CALL LSG_PLANE_VISIBLE(1,-1)
	    IF(SECONDARY)CALL LSG_PLANE_VISIBLE(2,-1)
	    PICTURE(1)=.TRUE.
	    PICTURE(2)=.TRUE.
	  ELSE
	    IF(PRIMARY.AND.(WTYPE(1).NE.9900))
     &         CALL LSG_PLANE_VISIBLE(1,PLANE_MASK)
	    IF(SECONDARY)CALL LSG_PLANE_VISIBLE(2,PLANE_MASK)
	    PICTURE(1)=.TRUE.
	    PICTURE(2)=.FALSE.
	  ENDIF
	ENDIF
	IF(INTARG(1).EQ.2)THEN
	  IF(NOPLNS.EQ.4)GOTO 10
	  IF(PICTURE(1))THEN
	    IF(PRIMARY.AND.(WTYPE(1).NE.9900))CALL LSG_PLANE_VISIBLE(1,-1)
	    IF(SECONDARY)CALL LSG_PLANE_VISIBLE(2,-1)
	    PICTURE(1)=.TRUE.
	    PICTURE(2)=.TRUE.
	  ELSE
	    IF(PRIMARY.AND.(WTYPE(1).NE.9900))
     &         CALL LSG_PLANE_VISIBLE(1,.NOT.PLANE_MASK)
	    IF(SECONDARY)CALL LSG_PLANE_VISIBLE(2,.NOT.PLANE_MASK)
	    PICTURE(2)=.TRUE.
	    PICTURE(1)=.FALSE.
	  ENDIF
	ENDIF
	GOTO 10
620     IF(MCMD.AND.BATH)GOTO 720
	BATH=.TRUE.
	IF(MCMD)CALL WRITEF('%S> ENABLE BATHYMETRY',PROMPT)
	IF(MIN_WVALUE(1).GE.0)CALL WRITEF
     &	  ('%S Current DTM does not contain any negative heights',
     &    WARN_BELL)
	IF(INIT_PRIMARY)
     &     CALL LSG_SET_LUT(1,'LSL$LOOKUP:UNDERSEA.DAT')
	IF(INIT_SECONDARY)
     &     CALL LSG_SET_LUT(2,'LSL$LOOKUP:UNDERSEA.DAT')
	MAXCOL = SEACOL
	STEPS = SEACOL
	HADSTP = .FALSE.		! cancel any STEP command
	CALL SETCOL			! and reset colours
	GOTO 10
625	COLOUR_IFF=.TRUE.
	GOTO 10
630     IF(MCMD.AND.SPLIT)GOTO 730
	SPLIT = .TRUE.
        QUAD = 1			! default quadrant
	IF(MCMD)CALL WRITEF('%S> ENABLE DIVIDE',PROMPT)
        IF(PRIMARY)VIEW_SHOWN(1,QUAD) = .FALSE.
	IF(SECONDARY)VIEW_SHOWN(2,QUAD)=.FALSE.
	GOTO 10
635	IF(.NOT.EXTRA_OK)THEN
	  IERR=0
	  RETVAL = LIB$FIND_FILE('LSL$EXE:DTIVIEWEXTRA.EXE'
     &                           ,LINE,IERR,,,,0)
	  IF(RETVAL)EXTRA_OK=.TRUE.
	ENDIF
	IF(.NOT.EXTRA_OK)THEN
	  CALL WRITEF('%S Specifying command ENABLE SYMBOLS',ERROR_BELL)
	  CALL WRITEF('Symbols option cannot be activated')
	  GOTO 10
	ENDIF
	SYMBOLS=.TRUE.
	GOTO 10
640 	IF(MCMD.AND.(PRIMARY.OR.SECONDARY))GOTO 740
	PRIMARY_DEVICE = TSTWK(1,WTYPE(1))
	IF(.NOT.PRIMARY_DEVICE)THEN
	  PRIMARY=.FALSE.
	ELSE
	  PRIMARY=.TRUE.
	  IF(.NOT.INIT_PRIMARY)CALL INIT_DEVICE(1)
	  CALL GACWK(1)
	ENDIF
	SECONDARY_DEVICE = TSTWK(2,WTYPE(2))
	IF(.NOT.SECONDARY_DEVICE)THEN
	  SECONDARY=.FALSE.
	ELSE
	  SECONDARY=.TRUE.
	  IF(.NOT.INIT_SECONDARY)CALL INIT_DEVICE(2)
	  CALL GACWK(2)
	ENDIF
	IF(MCMD)CALL WRITEF('%S> ENABLE GRAPHICS',PROMPT)
	GOTO 10
645	IF(MCMD)THEN
          CALL WRITEF('%S> ENABLE IFF_OUTPUT',PROMPT)
	  GOTO 660
	ENDIF
	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command IFF_OUTPUT',ERROR_BELL)
	  CALL WRITEF('Output IFF filename is missing')
	  GOTO 660
	ELSE
	  CALL BSCH
	ENDIF
650	IF(.NOT.CREATE_IFF_FILE())THEN
660	  CALL BSLN
	  IF(.NOT.WAIT_INPUT('Output IFF filename',.FALSE.,.TRUE.))GOTO 10
	  GOTO 650
	ENDIF
	PLOT_IFF=.TRUE.
	ACTIVE_IFF=.TRUE.
	GOTO 10
665	HAD_FOG=.TRUE.
	GOTO 10
670	IF(MCMD.AND.OVERLAY)GOTO 770
	IF(MCMD)CALL WRITEF('%S> ENABLE OVERLAY',PROMPT)
	IF(.NOT.EXTRA_OK)THEN
	  IERR=0
	  RETVAL = LIB$FIND_FILE('LSL$EXE:DTIVIEWEXTRA.EXE'
     &                           ,LINE,IERR,,,,0)
	  IF(RETVAL)EXTRA_OK=.TRUE.
	ENDIF
	IF(.NOT.EXTRA_OK)THEN
	  CALL WRITEF('%S Specifying command ENABLE OVERLAY',ERROR_BELL)
	  CALL WRITEF('Vector overlay option cannot be activated')
	  GOTO 10
	ENDIF
	IF (X_SAMPLE.NE.1 .OR. Y_SAMPLE.NE.1)THEN
	  CALL WRITEF('%S Specifying command ENABLE OVERLAY',ERROR_BELL)
	  CALL WRITEF('Overlay options are currently only available')
	  CALL WRITEF('with a column and row sampling interval of 1')
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
        OVERLAY=.TRUE.
	GOTO 10
675	IF (.NOT.TABLE) THEN
	   IF (INIT_TAB(,IERR)) THEN
	      CALL WRITEF
     &	      ('%S Error initialising table monitor',WARN_BELL)
	       CALL WRITEF
     &        ('DTIVIEW will assume no table is available')
	      TABLE=.FALSE.
	      GOTO 10
	   ENDIF
	   TABLE = .TRUE.
	   CALL RETURN_EFN(EF_POINT,EF_STREAM,EF_ERROR,EF_VDU,EF_LAST)
	ENDIF
	GOTO 10
680	IF(MCMD.AND.PRIMARY)GOTO 780
	IF(MCMD)CALL WRITEF('%S> ENABLE PRIMARY',PROMPT)
	PRIMARY_DEVICE = TSTWK(1,WTYPE(1))
	IF(.NOT.PRIMARY_DEVICE)THEN
	  PRIMARY=.FALSE.
	  CALL WRITEF('%S Specifying command ENABLE PRIMARY',ERROR_BELL)
	  CALL WRITEF('A PRIMARY graphics device is not supported')
	  GOTO 10
	ENDIF
	PRIMARY=.TRUE.
	IF(.NOT.INIT_PRIMARY)CALL INIT_DEVICE(1)
	CALL GACWK(1)
	GOTO 10
685	HAD_ABSOLUTE = .TRUE.
	GOTO 10
690	IF(MCMD.AND.SECONDARY)GOTO 790
	IF(MCMD)CALL WRITEF('%S> ENABLE SECONDARY',PROMPT)
	SECONDARY_DEVICE = TSTWK(2,WTYPE(2))
	IF(.NOT.SECONDARY_DEVICE)THEN
	  SECONDARY=.FALSE.
	  CALL WRITEF('%S Specifying command ENABLE SECONDARY',ERROR_BELL)
	  CALL WRITEF('A SECONDARY graphics device is not supported')
	  GOTO 10
	ENDIF
	SECONDARY=.TRUE.
	IF(.NOT.INIT_SECONDARY)CALL INIT_DEVICE(2)
	CALL GACWK(2)
	GOTO 10
695	IF(MCMD.AND.FISHNET)GOTO 795
	IF (X_SAMPLE.NE.Y_SAMPLE) THEN
	  CALL WRITEF('%S Specifying command ENABLE FISHNET',ERROR_BELL)
	  CALL WRITEF
     & ('Fishnet representation is currently only available with')
	  CALL WRITEF
     & ('an equal sampling interval along the columns and rows')
	  CALL WRITEF('Fishnet option is not enabled')
	  FISHNET = .FALSE.
	  GOTO 10
	ENDIF
	FISHNET = .TRUE.
	IF (MCMD) CALL WRITEF('%S> ENABLE FISHNET',PROMPT)
	GOTO 10
700	CMD = RDCOMM(ENABLE_CMD_TABLE)
	GOTO
     &  (710,720,730,740,750,770,780,790,795,715,725,735,765,785,775)
     &  CMD	
	CALL WRITEF('%S Specifying command DISABLE',ERROR_BELL)
	CALL WRITEF
     &  ('Command qualifiers are '// 
     &  'ABSOLUTE, AUTOSCALE, BATHYMETRY, COLOUR_IFF, DIVIDE ')
	CALL WRITEF
     &  ('                       '//
     &  'FISHNET, FOG, GRAPHICS, IFF_OUTPUT, OVERLAY')
	CALL WRITEF
     &  ('                       '//
     &  'PICTURE, PRIMARY, SECONDARY, SYMBOLS or TABLE')
	GOTO 10
710	AUTO=.FALSE.
	IF(MCMD)CALL WRITEF('%S> DISABLE AUTOSCALE',PROMPT)
	GOTO 10
715	IF(MCMD)CALL WRITEF('%S> DISABLE PICTURE %N',PROMPT,INTARG(1))
	IF(.NOT.(PRIMARY.OR.SECONDARY))THEN
	  CALL WRITEF('%S Specifying command DISABLE PICTURE',ERROR_BELL)
	  CALL WRITEF('No graphics device is currently enabled')
	  GOTO 10
	ENDIF
	IF(NOPLNS.EQ.4)THEN
	  CALL WRITEF('%S Specifying command DISABLE PICTURE',ERROR_BELL)
	  CALL WRITEF
     &    ('Command is not valid for a 4 planes graphics device')
	  GOTO 10
	ENDIF
	IF(MCMD)GOTO 717
	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command DISABLE PICTURE',ERROR_BELL)
	  CALL WRITEF('Command requires an integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.2)THEN
	  CALL WRITEF('%S Specifying command DISABLE PICTURE',ERROR_BELL)
	  CALL WRITEF('Command requires a picture number of 1 or 2')
	  GOTO 10
	ENDIF
717	IF(INTARG(1).EQ.1)THEN
	  IF(PRIMARY.AND.(WTYPE(1).NE.9900))
     &    CALL LSG_PLANE_VISIBLE(1,.NOT.PLANE_MASK)
	  IF(SECONDARY)CALL LSG_PLANE_VISIBLE(2,.NOT.PLANE_MASK)
	  PICTURE(1)=.FALSE.
	  PICTURE(2)=.TRUE.
	ENDIF
	IF(INTARG(1).EQ.2)THEN
	  IF(NOPLNS.EQ.4)GOTO 10
	  IF(PRIMARY.AND.(WTYPE(1).NE.9900))
     &    CALL LSG_PLANE_VISIBLE(1,PLANE_MASK)
	  IF(SECONDARY)CALL LSG_PLANE_VISIBLE(2,PLANE_MASK)
	  PICTURE(2)=.FALSE.
	  PICTURE(1)=.TRUE.
	ENDIF
	GOTO 10
720     BATH=.FALSE.
	IF(MCMD)CALL WRITEF('%S> DISABLE BATHYMETRY',PROMPT)
	IF(INIT_PRIMARY)
     &     CALL LSG_SET_LUT(1,'LSL$LOOKUP:DTIVIEW5.DAT')
	IF(INIT_SECONDARY)
     &     CALL LSG_SET_LUT(2,'LSL$LOOKUP:DTIVIEW5.DAT')
	MAXCOL = LNDCOL
	STEPS = LNDCOL
	HADSTP = .FALSE.		! cancel any STEP command
	CALL SETCOL			! and reset colours
	GOTO 10
725	COLOUR_IFF = .FALSE.
	GOTO 10
730     SPLIT = .FALSE.
        QUAD = 0
	IF(MCMD)CALL WRITEF('%S> DISABLE DIVIDE',PROMPT)
        IF(PRIMARY)VIEW_SHOWN(1,QUAD) = .FALSE.
	IF(SECONDARY)VIEW_SHOWN(2,QUAD)=.FALSE.
	GOTO 10
735	SYMBOLS=.FALSE.
	GOTO 10
740	IF(MCMD)CALL WRITEF('%S> DISABLE GRAPHICS',PROMPT)
	PRIMARY=.FALSE.
	CALL GDAWK(1)
	SECONDARY=.FALSE.
	CALL GDAWK(2)
	GOTO 10
750	IF(MCMD)CALL WRITEF('%S> DISABLE IFF_OUTPUT',PROMPT)
	IF(PLOT_IFF)THEN
          CALL ENDIFF
	  ACTIVE_IFF=.FALSE.
	ENDIF
	PLOT_IFF=.FALSE.
	GOTO 10
765	HAD_FOG=.FALSE.
	GOTO 10
770     IF(MCMD)CALL WRITEF('%S> DISABLE OVERLAY',PROMPT)
	OVERLAY=.FALSE.
	GOTO 10
775     IF(TABLE)CALL CLOSE_TAB (IERR)
	TABLE = .FALSE.
	EF_VDU=4
	CALL SYS$CANCEL(%VAL(IN_CHAN))
	HADQIO=.FALSE.
	GOTO 10
780	IF(MCMD)CALL WRITEF('%S> DISABLE PRIMARY',PROMPT)
	PRIMARY=.FALSE.
	CALL GDAWK(1)
	GOTO 10
785	HAD_ABSOLUTE = .FALSE.
	GOTO 10
790	IF(MCMD)CALL WRITEF('%S> DISABLE SECONDARY',PROMPT)
	SECONDARY=.FALSE.
	CALL GDAWK(2)
	GOTO 10
795	IF(MCMD)CALL WRITEF('%S> DISABLE FISHNET',PROMPT)
	FISHNET=.FALSE.
	GOTO 10
800	IF (MCMD) THEN
	  DIRECT = CMD-21
	  CALL WRITEF('%S> DIRECTION %S',PROMPT,COMPASS(DIRECT))
	  GOTO 10
	ENDIF
	CMD = RDCOMM(COMPASS_CMD_TABLE)
	IF (CMD.LE.0) THEN
	   CALL WRITEF('*** ERROR *** Specifying direction of view')
	   CALL WRITEF
     &  ('Command should be followed by NORTH, SOUTH, EAST or WEST')
	ELSE
	   DIRECT = CMD
	ENDIF
	GOTO 10
900	IF(MCMD)THEN
	  CALL WRITEF('%S> HEIGHT',PROMPT)
910	  IF (.NOT.WAIT_INPUT('Height of viewpoint',.FALSE.,.TRUE.)
     &							) GOTO 10
	  IF (RDREAL(REALAR(1))) GOTO 910
	  DEFHOV=REALAR(1)
	  GOTO 10
	ENDIF
	IF(CMDRCT.NE.1)THEN
	  CALL WRITEF('%S Specifying command HEIGHT',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	DEFHOV = REALAR(1)
	GOTO 10
1000	IF(MCMD)THEN
	  CALL WRITEF('%S> DISTANCE',PROMPT)
1010	  IF (.NOT.WAIT_INPUT('Distance of viewpoint',.FALSE.,.TRUE.)
     &							) GOTO 10
	  IF (RDREAL(REALAR(1))) GOTO 1010
	  CMDRCT=1
	ENDIF
	IF(CMDRCT.NE.1)THEN
	  CALL WRITEF('%S Specifying command DISTANCE',ERROR_BELL) 
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	IF(REALAR(1).LE.0)THEN
	  CALL WRITEF('%S Specifying command DISTANCE',ERROR_BELL)
	  CALL WRITEF('Command requires a real argument greater than 1')
	  GOTO 10
	ENDIF
	DOV = REALAR(1)
	GOTO 10
1100	IF(MCMD)THEN
	  CALL WRITEF('%S> PHI',PROMPT)
1110	  IF (.NOT.WAIT_INPUT('PHI (degrees)',.FALSE.,.TRUE.)) GOTO 10
	  IF (RDREAL(REALAR(1))) GOTO 1110
	  CMDRCT=1
	ENDIF
	IF(CMDRCT.NE.1)THEN
	  CALL WRITEF('%S Specifying command PHI',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	IF(ABS(REALAR(1)).GT.80)THEN
	  CALL WRITEF('%S Specifying command PHI',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires a rotation value in the range -80 to 80')
	  GOTO 10
	ENDIF
	DEFPHI = REALAR(1)	
	GOTO 10
1200	IF(MCMD)THEN
	  CALL WRITEF('%S> THETA',PROMPT)
1210	  IF (.NOT.WAIT_INPUT('THETA (degrees)',.FALSE.,.TRUE.)) GOTO 10
	  IF (RDREAL(REALAR(1))) GOTO 1210
	  CMDRCT = 1
	ENDIF
	IF(CMDRCT.NE.1)THEN
	  CALL WRITEF('%S Specifying command THETA',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	IF(REALAR(1).LT.-90.OR.REALAR(1).GT.0)THEN
	  CALL WRITEF('%S Specifying command THETA',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires a rotation value in the range 0 to -90')
	  GOTO 10
	ENDIF
	DEFTHT = REALAR(1)	
	GOTO 10
1300	IF(MCMD)THEN
	  CALL WRITEF('%S> ZSCALE',PROMPT)
1310	  IF (.NOT.WAIT_INPUT
     &    ('Vertical exaggeration',.FALSE.,.TRUE.)) GOTO 10
	  IF (RDREAL(REALAR(1))) GOTO 1310
	  DEFZSC = REALAR(1)
	  GOTO 10
	ENDIF
	IF(CMDRCT.NE.1)THEN
	  CALL WRITEF('%S Specifying command ZSCALE',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	DEFZSC = REALAR(1)	
	GOTO 10
1400	IF (MCMD) CALL WRITEF('%S> PERSPECTIVE',PROMPT)
	IF (.NOT.DTILUN_INUSE(1)) THEN
	  CALL WRITEF('%S Specifying command PERSPECTIVE',ERROR_BELL)	  
	  CALL WRITEF('The input DTM is undefined')
	  GOTO 10
	ENDIF
	IF (.NOT.(PRIMARY.OR.SECONDARY.OR.PLOT_IFF)) THEN
	  CALL WRITEF('%S Specifying command PERSPECTIVE',ERROR_BELL)	  
	  CALL WRITEF
     &    ('No graphics device or output IFF file is enabled')
	  GOTO 10
	ENDIF
	PRSPVW = .TRUE.
	IF(HADTMP)THEN
	  RETVAL=DTI_CLOSE(2,.FALSE.,.TRUE.,ERROR)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	  ENDIF
	  RETVAL=LIB$DELETE_FILE ('LSL$DTI:VISIBILITY.GRD;*')
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	    CALL WRITEF
     &      ('*** WARNING *** Error deleting temporary visibility grid')
	  ENDIF
	  HADTMP=.FALSE.
	ENDIF
	IF(OVERLAY.OR.FISHNET.OR.SYMBOLS)THEN
	  RETVAL=DTI_CREATE (2,'LSL$DTI:VISIBILITY.GRD',22,
     &                       4,32,1,NLINES,NPTS,ERROR)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	    IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	    CALL WRITEF('%S Creating visibility matrix',ERROR_BELL)
	    HADTMP=.FALSE.
	    IF(OVERLAY)CALL WRITEF('OVERLAY option is disabled')
	    OVERLAY=.FALSE.
	    IF(FISHNET)CALL WRITEF('FISHNET option is disabled')
	    FISHNET=.FALSE.
	    IF(SYMBOLS)CALL WRITEF('SYMBOL option is disabled')
	    SYMBOLS=.FALSE.
	  ELSE
	    HADTMP=.TRUE.
	  ENDIF	  
	ENDIF
	CALL MODEL
	GOTO 10
1500	IF(MCMD)CALL WRITEF('%S> ISOMETRIC',PROMPT)
	IF (.NOT.DTILUN_INUSE(1)) THEN
	  CALL WRITEF('%S Specifying command ISOMETRIC',ERROR_BELL)	  
	  CALL WRITEF('The input DTM is undefined')
	  GOTO 10
	ENDIF
	IF (.NOT.(PRIMARY.OR.SECONDARY.OR.PLOT_IFF)) THEN
	  CALL WRITEF('%S Specifying command ISOMETRIC',ERROR_BELL)	  
	  CALL WRITEF
     &    ('No graphics device or output IFF file is enabled')
	  GOTO 10
	ENDIF
	PRSPVW = .FALSE.
	IF(HADTMP)THEN
	  RETVAL=DTI_CLOSE(2,.FALSE.,.TRUE.,ERROR)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	  ENDIF
	  RETVAL=LIB$DELETE_FILE ('LSL$DTI:VISIBILITY.GRD;0')
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	    CALL WRITEF
     &      ('%S Error deleting temporary visibility grid',WARN_BELL)
	  ENDIF
	  HADTMP=.FALSE.
	ENDIF
	IF(OVERLAY.OR.FISHNET.OR.SYMBOLS) THEN
	  RETVAL=DTI_CREATE (2,'LSL$DTI:VISIBILITY.GRD',22,
     &                       4,32,1,NLINES,NPTS,ERROR)
	  IF(.NOT.RETVAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	    IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	    CALL WRITEF('%S Creating visibility matrix',ERROR_BELL)
	    HADTMP=.FALSE.
	    IF(OVERLAY)CALL WRITEF('OVERLAY option is disabled')
	    OVERLAY=.FALSE.
	    IF(FISHNET)CALL WRITEF('FISHNET option is disabled')
	    FISHNET=.FALSE.
	    IF(SYMBOLS)CALL WRITEF('SYMBOL option is disabled')
	    SYMBOLS=.FALSE.
	  ELSE
	    HADTMP=.TRUE.
	  ENDIF	  
	ENDIF
	CALL MODEL
	GOTO 10
1600	IF(MCMD)CALL WRITEF('%S> PROFILE',PROMPT)
	IF (.NOT.DTILUN_INUSE(1)) THEN
	  CALL WRITEF('%S Specifying command PROFILE',ERROR_BELL)	  
	  CALL WRITEF('The input DTM is undefined')
	  GOTO 10
	ENDIF
	IF (.NOT.(PRIMARY.OR.SECONDARY.OR.PLOT_IFF)) THEN
	  CALL WRITEF('%S Specifying command PROFILE',ERROR_BELL)	  
	  CALL WRITEF
     &    ('No graphics device or output IFF file is enabled')
	  GOTO 10
	ENDIF
	IF(.NOT.GET_PROFILE_POINTS(MCMD,X1,Y1,X2,Y2))GOTO 10
	CALL PROFILE(X1,Y1,X2,Y2)
	GOTO 10
1700	IF(MCMD)THEN
	  CALL WRITEF('%S> ZSTEP',PROMPT)
1710	  IF (.NOT.WAIT_INPUT('Height step',.FALSE.,.TRUE.)) GOTO 10
	  IF (RDLONG(INTARG(1))) GOTO 1710
	ENDIF
	IF (CMDICT.NE.1) THEN
	  CALL WRITEF('%S Specifying command ZSTEP',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument') 
	  GOTO 10
	ENDIF
	IF (BATH) THEN
	   MAX_ZSTEP = ABS(MAX_WVALUE(1)) + ABS(MIN_WVALUE(1))
	ELSE
	   MAX_ZSTEP = ABS(MAX_WVALUE(1))
	ENDIF
	IF (INTARG(1).LT.1.OR.INTARG(1).GT.MAX_ZSTEP) THEN
	  CALL WRITEF('%S Specifying command ZSTEP',ERROR_BELL)
	  CALL WRITEF(
     & 'Height value should be in the range 1 to %^W%N',MAX_ZSTEP)
	  GOTO 10
	ENDIF
	STPINT = INTARG(1)
	HADSTP = .TRUE.				! had STEP command
	CALL SETCOL				! set colour
	GOTO 10
1800	IF(MCMD)THEN
	  CALL WRITEF('%S> ZLIMITS',PROMPT)	  
1810	  IF (.NOT.WAIT_INPUT
     &       ('Lower and Upper Z Values',.FALSE.,.TRUE.)) GOTO 10
	  IF (RDLONG(INTARG(1))) GOTO 1810
	  IF (RDLONG(INTARG(2))) GOTO 1810
	  CMDICT=2
	ENDIF
	IF (CMDICT.NE.2) THEN
	  CALL WRITEF('%S Specifying colour ZLIMITS',ERROR_BELL)
	  CALL WRITEF('Command requires 2 integer arguments') 
	  GOTO 10
	ENDIF
	IF(INTARG(2).LE.INTARG(1))THEN
	  CALL WRITEF('%S Specifying command ZLIMITS',ERROR_BELL)
	  CALL WRITEF('Upper Z value must exceed lower Z value')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.MIN_WVALUE(1).OR.
     &     INTARG(1).GT.MAX_WVALUE(1).OR.
     &     INTARG(2).LT.MIN_WVALUE(1).OR.
     &     INTARG(2).GT.MAX_WVALUE(1))THEN
	  CALL WRITEF('%S Specifying command ZLIMITS',ERROR_BELL)
	  CALL WRITEF(
     & 'Z Limits must lie within the range %^W%N to %^W%N',
     &  MIN_WVALUE(1),MAX_WVALUE(1))  
	  GOTO 10
	ENDIF
	ZLOWER=INTARG(1)
	ZUPPER=INTARG(2)
	HADSTP=.TRUE.
	CALL SETCOL				! set colour
	GOTO 10
2100	IF(MCMD)THEN
	  INTARG(1)=CMD-48
	  CALL WRITEF('%S> QUADRANT %N',PROMPT,INTARG(1))
	ENDIF
	IF (.NOT.SPLIT) THEN	! not allowed
	  CALL WRITEF('%S Specifying command QUADRANT',ERROR_BELL)
	  CALL WRITEF('Divided screen is not enabled')
	  GOTO 10
	ENDIF
	IF(MCMD)GOTO 2150
        IF (CMDICT.NE.1)THEN
           CALL WRITEF('%S Specifying command QUADRANT',ERROR_BELL)
           CALL WRITEF('Command requires 1 integer argument')
           GOTO 10
	ENDIF
	IF (INTARG(1).GT.4.OR.INTARG(1).LE.0) THEN
	   CALL WRITEF('%S Specifying command QUADRANT',ERROR_BELL)
	   CALL WRITEF('Quadrant number should be in range 1 to 4')
	   GOTO 10
	ENDIF
2150	QUAD = INTARG(1)		! set up quad.
	IF(PRIMARY)VIEW_SHOWN(1,QUAD) = .FALSE.
	IF(SECONDARY)VIEW_SHOWN(2,QUAD) = .FALSE.
	GOTO 10
2200	IF(MCMD)THEN
	  INTARG(1)=CMD-53
	  IF(INTARG(1).EQ.0)THEN
            CALL WRITEF('%S> CLEAR',PROMPT)
	  ELSE
	    CALL WRITEF('%S> CLEAR QUADRANT %N',PROMPT,INTARG(1))
	  ENDIF
	  IF(.NOT.(PRIMARY.OR.SECONDARY))THEN
	    CALL WRITEF('%S Specifying command CLEAR',ERROR_BELL)
	    CALL WRITEF('No graphics device is currently enabled')
	    GOTO 10
	  ENDIF
	  IF(INTARG(1).GT.0.AND.(.NOT.SPLIT))THEN
	    CALL WRITEF('%S Specifying command CLEAR QUADRANT',ERROR_BELL)
	    CALL WRITEF('A divided screen is not enabled')
	    GOTO 10
	  ENDIF
	  IQUAD=INTARG(1)
	  GOTO 2240
	ENDIF
	IF(.NOT.(PRIMARY.OR.SECONDARY))THEN
	  CALL WRITEF('%S Specifying command CLEAR',ERROR_BELL)
	  CALL WRITEF('No graphics device is currently enabled')
	  GOTO 10
	ENDIF
	IF(RDCHS(CH))THEN
	  IQUAD=0
	  GOTO 2240
	ELSE
	  CALL BSCH
	ENDIF
	CMD=RDCOMM(CLEAR_CMD_TABLE)
	IF(CMD.LE.0)THEN
	  CALL WRITEF('%S Specifying command CLEAR',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are PICTURE, QUADRANT '//
     &	  'or SYMBOL')
	  GOTO 10
	ENDIF
	GOTO (2220,2250)CMD
2220	IF(.NOT.SPLIT)THEN
	  CALL WRITEF('%S Specifying command CLEAR QUADRANT',ERROR_BELL)
	  CALL WRITEF('A divided screen is not enabled')
	  GOTO 10
	ENDIF
	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command CLEAR QUADRANT',ERROR_BELL)
          CALL WRITEF
     &    ('Command requires a quadrant nunmber in the range 1 to 4')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.4)THEN
	  CALL WRITEF('%S Specifying command CLEAR QUADRANT',ERROR_BELL)
          CALL WRITEF
     &    ('Command requires a quadrant nunmber in the range 1 to 4')
	  GOTO 10
	ENDIF	
	IQUAD=INTARG(1)
2240	CALL CLEAR(IQUAD,-1)
	IF((PRIMARY.AND.INIT_PRIMARY).AND.(WTYPE(1).EQ.9900))THEN
          CALL GSLN(TK_LINESTYLE)
	ENDIF
	GOTO 10
2250	IF(NOPLNS.EQ.4)THEN
	  CALL WRITEF('%S Specifying command CLEAR PICTURE',ERROR_BELL)
	  CALL WRITEF
     &    ('Command is not valid for a 4 planes graphics device')
	  GOTO 10
	ENDIF
	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command CLEAR PICTURE',ERROR_BELL)
	  CALL WRITEF('Command requires an integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.2)THEN
	  CALL WRITEF('%S Specifying command CLEAR PICTURE',ERROR_BELL)
	  CALL WRITEF('Command requires a picture number of 1 or 2')
	  GOTO 10
	ENDIF
	IQUAD=QUAD
	CALL CLEAR(IQUAD,INTARG(1))
	GOTO 10
2300	IF (CMDICT.NE.1)THEN
	   CALL WRITEF('%S Specifying command COLOURS',ERROR_BELL)
	   CALL WRITEF('Command requires 1 integer argument')
	   GOTO 10
	ENDIF
2350	IF (INTARG(1).GT.MAXCOL.OR.INTARG(1).LT.1) THEN
	   CALL WRITEF('%S Specifying command COLOURS',ERROR_BELL)
	   CALL WRITEF('Number of colours should be in the range 1 to %N'
     &	  ,MAXCOL)
	  GOTO 10
	ENDIF
	STEPS = INTARG(1)	! save number of colour steps requested
	HADSTP = .FALSE.	! not had a STEP command
	CALL SETCOL		! set colours
	GOTO 10
2600	IF(MCMD)THEN
	  CMD=CMD-31
	  IF(CMD.EQ.1)CALL WRITEF('%S> DRAW LABEL',PROMPT)
	  IF(CMD.EQ.2)CALL WRITEF('%S> DRAW LEGEND',PROMPT)
	ENDIF
	IF(.NOT.(PRIMARY.OR.SECONDARY))THEN
	  CALL WRITEF('%S Specifying command DRAW',ERROR_BELL)
	  CALL WRITEF('No graphics device is currently enabled')
	  GOTO 10
	ENDIF
	IF(MCMD)GOTO 2640
	CMD=RDCOMM(DRAW_CMD_TABLE)
	IF(CMD.LE.0)THEN
	  CALL WRITEF('%S Specifying command DRAW',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are LABEL, LEGEND '//
     &	  'or SYMBOL')	
	ENDIF
2640	IF(CMD.EQ.1)THEN
	  IF(MCMD)THEN
2645        IF(.NOT.WAIT_INPUT('Label text',.FALSE.,.TRUE.)) GOTO 10
	  ENDIF
	  IF(RDCH(CH))THEN
	    CALL WRITEF('%S Specifying command DRAW LABEL',ERROR_BELL)
	    CALL WRITEF
     &      ('Command requires a text string of up to 80 characters')
	    IF(MCMD)THEN
	      GOTO 2645
	    ELSE
	      GOTO 10
	    ENDIF
	  ELSE
	    CALL BSCH	!backspace over read character
	  ENDIF
	  IF((TXTPTR-DCPTR+1).GT.80)THEN
	    CALL WRITEF
     &      ('%S Specifying command DRAW LABEL',ERROR_BELL)
	    CALL WRITEF('More than 80 characters in text string')
	    IF(MCMD)THEN
              GOTO 2645
	    ELSE
              GOTO 10
	    ENDIF
	  ENDIF
	  CALL ANNOTATE	  		! to anotate display
	  TEXT_SHOWN(QUAD) = .TRUE.
	  GOTO 10
	ENDIF
	IF(CMD.EQ.2)THEN
2660	  IF((PRIMARY.AND.WTYPE(1).EQ.9900).AND.(.NOT.SECONDARY))THEN
	    CALL WRITEF('%S Specifying command DRAW LEGEND')
	    CALL WRITEF('No legend can be shown on a TEKTRONIX 4014')
	    GOTO 10
	  ENDIF
	  CALL PLTPOS(.FALSE.,.FALSE.)
	  LEGEND_SHOWN(QUAD) = .TRUE.
	  CALL GSSGT		! set segment transformation
	  IF(BATH)THEN
	    CALL LEGBAT		! generate legend for bathymetric option
	  ELSE
	    CALL DRAW_LEGEND		! generate normal legend
          ENDIF
	  GOTO 10
	ENDIF
	IF(CMD.EQ.3) THEN
	   OK = PROCESS_SYMBOLS(0,1,1,.FALSE.)	! redraws all symbols
	   GOTO 10
	ENDIF
	GOTO 10
2700	IF(MCMD)CALL WRITEF('%S> LUT',PROMPT)
	IF(.NOT.(PRIMARY.OR.SECONDARY))THEN
	  CALL WRITEF('%S Specifying command LUT',ERROR_BELL)
	  CALL WRITEF('No graphics device is currently enabled')
	  GOTO 10
	ENDIF
        IF((PRIMARY.AND.WTYPE(1).EQ.9900).AND.(.NOT.SECONDARY))THEN
	  CALL WRITEF('%S Specifying command LUT',ERROR_BELL)
	  CALL WRITEF('Command not valid for a TEKTRONIX 4014')
	  GOTO 10
	ENDIF
	IF(MCMD)THEN
	  IF(.NOT.WAIT_INPUT('LUT Filename',.FALSE.,.TRUE.))GOTO 10
	ENDIF
	IF(PRIMARY.AND.WTYPE(1).NE.9900)CALL LUTSET(1)
	IF(SECONDARY.AND.SECONDARY_DEVICE)CALL LUTSET(2)
	GOTO 10
2800	CMD=RDCOMM(LEGEND_CMD_TABLE)
	IF(CMD.LE.0)THEN
	  CALL WRITEF('%S Specifying command LEGEND',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are POSITION or SIZE')
	  GOTO 10
	ENDIF
	GOTO (2810,2850)CMD	
2810	IF(CMDACT.NE.2)THEN
	  CALL WRITEF('%S Specifying command LEGEND POSITION',ERROR_BELL)
	  CALL WRITEF('Command requires 2 real arguments')
	  GOTO 10
	ENDIF
2840	IF(REALAR(1).LT.0.0.OR.REALAR(1).GT.1.0.OR.
     &     REALAR(2).LT.0.0.OR.REALAR(2).GT.1.0)THEN
	  CALL WRITEF('%S Specifying command LEGEND POSITION',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires 2 real arguments in the range 0 to 1')
	  GOTO 10
	ENDIF
	LEGX = REALAR(1)
	LEGY = REALAR(2)
	GOTO 10
2850	IF(CMDACT.NE.1)THEN
	  CALL WRITEF('%S Specifying command LEGEND SIZE',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
2860	IF (REALAR(1).LT.0.0.OR.REALAR(1).GT.1.0) THEN
	  CALL WRITEF('%S Specifying command LEGEND SIZE',ERROR_BELL)
	  CALL WRITEF
     &	  ('Command requires a real argument in the range 0 to 1')
	  GOTO 10
	ENDIF
	LEGSIZ = REALAR(1)
	GOTO 10
2900	CMD=RDCOMM(LABEL_CMD_TABLE)
	IF(CMD.LE.0)THEN
	  CALL WRITEF('%S Specifying command LABEL',ERROR_BELL)
	  CALL WRITEF
     &    ('Command qualifiers are CLEAR, COLOUR, POSITION or SIZE')
	  GOTO 10
	ENDIF
	GOTO (2910,2920,2940,2970)CMD	
2910	IF (.NOT.(PRIMARY.OR.SECONDARY))THEN
	   CALL WRITEF('%S Specifying command LABEL CLEAR',ERROR_BELL)
	   CALL WRITEF('No graphics device is currently enabled')
	   GOTO 10
	ENDIF
        IF((PRIMARY.AND.WTYPE(1).EQ.9900).AND.(.NOT.SECONDARY))THEN
	   CALL WRITEF('%S Specifying command LABEL CLEAR',ERROR_BELL)
	   CALL WRITEF('Command is not valid for a TEKTRONIX 4014')
	   GOTO 10
	ENDIF
	IF (NOPLNS.EQ.4)THEN
	   CALL WRITEF('%S Specifying command LABEL CLEAR',ERROR_BELL)
	   CALL WRITEF
     &     ('Command is not valid for a 4 planes graphics device')
	   GOTO 10
	ENDIF
	CALL CLEAR(QUAD,2)
 	GOTO 10 
2920	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command LABEL COLOUR',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF (NOPLNS.EQ.4)THEN
	   CALL WRITEF('%S Specifying command LABEL CLEAR',ERROR_BELL)
	   CALL WRITEF
     &     ('Command is not valid for a 4 planes graphics device')
	   GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.OVERLAY_COLOURS)THEN
	  CALL WRITEF('%S Specifying command LABEL COLOUR',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires an integer in the range 1 to %N',
     &    OVERLAY_COLOURS)
	  GOTO 10
	ENDIF
	LABCOL=INTARG(1)
	GOTO 10
2940	IF(CMDACT.NE.2)THEN
	  CALL WRITEF('%S Specifying command LABEL POSITION',ERROR_BELL)
	  CALL WRITEF('Command requires 2 real arguments')
	  GOTO 10
	ENDIF
	IF(REALAR(1).LT.0.0.OR.REALAR(1).GT.1.0.OR.
     &     REALAR(2).LT.0.0.OR.REALAR(2).GT.1.0)THEN
	  CALL WRITEF('%S Specifying command LABEL POSITION',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires 2 real arguments in the range 0 to 1')
	  GOTO 10
	ENDIF
	LABX = REALAR(1)
	LABY = REALAR(2)
	GOTO 10
2970	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command LABEL SIZE',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.4)THEN
	  CALL WRITEF('%S Specifying command LABEL SIZE',ERROR_BELL)
	  CALL WRITEF('Command requires an integer in the range 1 to 4')
	  GOTO 10
	ENDIF
	LABSIZ = INTARG(1)
	GOTO 10 
3000	CMD=RDCOMM(SET_CMD_TABLE)
	IF(CMD.LE.0)THEN
	  CALL WRITEF('%S Specifying command SET',ERROR_BELL)
	  CALL WRITEF
     &    ('Command qualifiers are DEFAULT, LAND_FC, LAYER, '//
     &	  'LINE_STYLE')
	  CALL WRITEF
     &    ('                       NULL_FC, ORIGIN, SCALE, SEA_FC,
     & SYMBOL_SCALE,')
	  CALL WRITEF
     &    ('                       TEXT_FC')
	  GOTO 10
	ENDIF
	GOTO(3010,3040,3050,3060,3070,3080,3090,3095,3075,3085)CMD
3010	CMD=RDCOMM(DEFAULT_CMD_TABLE)
	IF(CMD.LE.0)THEN
	  CALL WRITEF('%S Specifying command SET DEFAULT',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are ANNOTATION or VIEW')
	  GOTO 10
	ENDIF
	GOTO (3020,3030)CMD
3020	LABSIZ = 1			! label size
	LABX   = 0.5			! label x position
	LABY   = 0.5			! label y position
	LABCOL = 1			! label colour
	LEGSIZ = 0.25			! legend scaling factor
	LEGX   = 0.005			! legend x position
	LEGY   = 0.15			! legend y position
	GOTO 10
3030	IF(MCMD)CALL WRITEF('%S> SET DEFAULT VIEW',PROMPT)
	DEFHOV   = 300.0		! height of view 
	DEFPHI   = 45.0			! phi
	DEFTHT   = -30.0		! theta
	DEFZSC   = 1.0			! vertical exaggeration
	DOV      = 300.0		! distance
	DIRECT   = 1			! west
	X_SAMPLE = 1			! sampling along cols
	Y_SAMPLE = 1			! sampling along rows
	GOTO 10 
3040	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SET LAND_FC',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.0.OR.INTARG(1).GT.32767)THEN	    
	  CALL WRITEF('%S Specifying command SET LAND_FC',ERROR_BELL)
	  CALL WRITEF
     & ('Command requires a feature code value in the range 0 to 32767')
	  GOTO 10
	ENDIF
	LAND_FC=INTARG(1)
	GOTO 10
3050	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SET SEA_FC',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.0.OR.INTARG(1).GT.32767)THEN	    
	  CALL WRITEF('%S Specifying command SET SEA_FC',ERROR_BELL)
	  CALL WRITEF
     & ('Command requires a feature code value in the range 0 to 32767')
	  GOTO 10
	ENDIF
	SEA_FC=INTARG(1)
	GOTO 10
3060	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SET LAYER',ERROR_BELL)	  
	  CALL WRITEF('Command requires an integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.32767)THEN
	  CALL WRITEF('%S Specifying command SET LAYER',ERROR_BELL)	  
	  CALL WRITEF
     &    ('Command requires a layer number  in the range 1 to 32767')
	  GOTO 10
	ENDIF
	LAYER = INTARG(1)
	GOTO 10
3070	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SET NULL_FC',ERROR_BELL)	  
	  CALL WRITEF('Command requires an integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.32767)THEN
	  CALL WRITEF('%S Specifying command SET NULL_FC',ERROR_BELL)	  
	  CALL WRITEF
     &    ('Command requires a layer number  in the range 1 to 32767')
	  GOTO 10
	ENDIF
	NULL_FC = INTARG(1)
	GOTO 10
3075	PRIMARY_DEVICE = TSTWK(1,WTYPE(1))
	IF((.NOT.PRIMARY_DEVICE).OR.(WTYPE(1).NE.9900))THEN
	  CALL WRITEF('%S Specifying command TKSTYLE',ERROR_BELL)
	  CALL WRITEF('Primary graphics device is not a TEKTRONIX 4014')
	  GOTO 10
	ENDIF
	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command TKSTYLE',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(1).GT.5)THEN
	  CALL WRITEF('%S Specifying command TKSTYLE',ERROR_BELL)
	  CALL WRITEF('Command requires an integer in the range 1 to 5')
	  GOTO 10
	ENDIF
	TK_LINESTYLE=INTARG(1)+1
        CALL GSLN(TK_LINESTYLE)
	GOTO 10
3080	IF(CMDACT.NE.2)THEN
	  CALL WRITEF('%S Specifying command ORIGIN',ERROR_BELL)
	  CALL WRITEF('Command requires 2 real arguments')
	  GOTO 10
	ENDIF
	CALL G3ORIGIN(REALAR(1),REALAR(2))
	IF(AUTO)AUTO=.FALSE.
	GOTO 10
3085	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SET TEXT_FC',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.0.OR.INTARG(1).GT.32767)THEN	    
	  CALL WRITEF('%S Specifying command SET TEXT_FC',ERROR_BELL)
	  CALL WRITEF
     & ('Command requires a feature code value in the range 0 to 32767')
	  GOTO 10
	ENDIF
	TEXT_FC=INTARG(1)
	GOTO 10
3090	IF(CMDACT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SCALE',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	CALL G3UNIT(REALAR(1))
	IF (AUTO) AUTO=.FALSE.
	GOTO 10
3095	IF(CMDACT.NE.1)THEN
	  CALL WRITEF('%S Specifying command SET SYMBOL_SCALE',ERROR_BELL)
	  CALL WRITEF('Command requires 1 real argument')
	  GOTO 10
	ENDIF
	SYMSF = REALAR(1)
	HADSF = .TRUE.
	GOTO 10
3100	IF(MCMD)CALL WRITEF('%S> IFF',PROMPT)
	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command IFF',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
	IF(MCMD)GOTO 3120
	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command IFF',ERROR_BELL)
	  CALL WRITEF('Input IFF filename is missing')
	  GOTO 3120
	ELSE
	  CALL BSCH
	ENDIF
3110	IF(.NOT.OPEN_IFF_FILE())THEN
3120	  CALL BSLN
	  IF(.NOT.WAIT_INPUT('Input IFF filename',.FALSE.,.TRUE.))GOTO 10
	  GOTO 3110
	ENDIF
	HADIFF=.TRUE.
	IF(DTILUN_INUSE(1))CALL IFFTRN	
	GOTO 530		!print out IFF details (as SHOW IFF)
3200	IF(MCMD)CALL WRITEF('%S> IFFWINDOW',PROMPT)
	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command IFFWINDOW',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
	IF(.NOT.HADIFF)THEN
	  CALL WRITEF('%S Specifying command IFFWINDOW',ERROR_BELL)
	  CALL WRITEF('No input IFF has been specified')
	  GOTO 10
	ENDIF
	IF(MCMD)THEN
3250	  IF(.NOT.WAIT_INPUT
     &      ('IFF Window SW corner',.FALSE.,.TRUE.))GOTO 10
	  IF(RDREAL(REALAR(1)))GOTO 3250
	  IF(RDREAL(REALAR(2)))GOTO 3250
3260	  IF(.NOT.WAIT_INPUT
     &      ('IFF Window NE corner',.FALSE.,.TRUE.))GOTO 10
	  IF(RDREAL(REALAR(3)))GOTO 3260
	  IF(RDREAL(REALAR(4)))GOTO 3260
	  CMDACT=4		!4 arguments
	ENDIF
	IF(CMDACT.NE.4)THEN		!prompt for window values
	  CALL WRITEF('%S Specifying command IFFWINDOW',ERROR_BELL)
	  CALL WRITEF('Command requires 4 real arguments')
	  GOTO 10
	ENDIF
3230	IF((REALAR(1).GE.REALAR(3)).OR.(REALAR(2).GE.REALAR(4)))THEN
	  CALL WRITEF('%S Specifying command IFFWINDOW',ERROR_BELL)
	  CALL WRITEF('NE corner should exceed SW corner')
	  IF(MCMD)GOTO 3250
	  GOTO 10
	ENDIF
	IF (HAD_ABSOLUTE) THEN
	   XT1 = REALAR(1)-ORIGIN_OFFSET(1)
	   YT1 = REALAR(2)-ORIGIN_OFFSET(2)
	   XT2 = REALAR(3)-ORIGIN_OFFSET(1)
	   YT2 = REALAR(4)-ORIGIN_OFFSET(2)
	ELSE
	   XT1 = REALAR(1)
	   YT1 = REALAR(2)
	   XT2 = REALAR(3)
	   YT2 = REALAR(4)
	ENDIF
	IF(XT1.LT.RANGE_VALUES(1).OR.
     &     YT1.LT.RANGE_VALUES(3).OR.
     &     XT2.GT.RANGE_VALUES(2).OR.
     &     YT2.GT.RANGE_VALUES(4))THEN
	  CALL WRITEF
     &    ('%S Specified window outside IFF file coordinate range',
     &    WARN_BELL)
	ENDIF
	WIND(1,1)=XT1
	WIND(1,2)=YT1
	WIND(2,1)=XT2
	WIND(2,2)=YT2
	HADWIN=.TRUE.
	CALL IFFTRN	!recalculate IFF to DTI transformation
	GOTO 10
3300	IF(MCMD)CALL WRITEF('%S> OVERLAY',PROMPT)
	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command OVERLAY',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
	IF(.NOT.HADTMP)THEN
	  CALL WRITEF('%S Specifying command OVERLAY',ERROR_BELL)
          CALL WRITEF
     &    ('Before overlay it is necessary to generate a terrain view')
	  CALL WRITEF('Use the command ISOMETRIC or PERSPECTIVE')
          GOTO 10
	ENDIF
	IF(NOPLNS.EQ.8)THEN
	  CALL WRITEF('%S Specifying command OVERLAY',ERROR_BELL)
	  CALL WRITEF('Overlay not possible with a planes setting of 8')
	  GOTO 10
	ENDIF
	IF(.NOT.HADIFF)THEN
	  CALL WRITEF('%S Specifying command OVERLAY',ERROR_BELL)
	  CALL WRITEF('No IFF file has been specified')
	  GOTO 10
	ENDIF
	IF(.NOT.HADFRT)THEN
	  CALL WRITEF('%S Specifying command OVERLAY',ERROR_BELL)
	  CALL WRITEF('No FRT file has been specified')
	  GOTO 10
	ENDIF
	CALL TRANSFORM_IFF		! perform overlay
	GOTO 10	 
3400	IF(MCMD)CALL WRITEF('%S> FRT',PROMPT)
	IF (.NOT.OVERLAY .AND. .NOT.SYMBOLS) THEN
	  CALL WRITEF('%S Specifying command FRT',ERROR_BELL)
	  CALL WRITEF('Overlay or symbol options are not enabled')
	  GOTO 10
	ENDIF
	IF(MCMD)GOTO 3455
3450	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command FRT',ERROR_BELL)
	  CALL WRITEF('Input FRT filename is missing')
3455	  IF(.NOT.WAIT_INPUT('Input FRT filename',.FALSE.,.TRUE.))GOTO 10
	ELSE
	  CALL BSCH
	ENDIF
	RETVAL = GETFILNAM(FRTTIT,NAMLEN,'LSL$FRT:FRT.FRT;0',.TRUE.)
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(RETVAL)
	  GOTO 10
	ENDIF
	IF(HADFRT .AND. SYMBOLS_DEFINED.GT.0) THEN
	   SYMBOL_UNDEFINE_MESS = .TRUE.
	   DO 3460 I = 1,MAX_SYMBOLS
	      IF (SYMBOL_LDATA(5,I)) THEN
		 IF (SYMBOL_UNDEFINE_MESS) THEN
	            CALL WRITEF('%S symbols are being undefined',
     &		    WARN_BELL)
		    SYMBOL_UNDEFINE_MESS = .FALSE.
		 ENDIF
	         SYMBOL_LDATA(5,I) = .FALSE.
		 IF(SYMBOL_LDATA(6,I)) THEN
	            SYMBOLS_USED = SYMBOLS_USED - 1
	            SYMBOL_LDATA(6,I) = .FALSE.
		 ENDIF
	         SYMBOL_LDATA(7,I) = .FALSE.
	         SYMBOL_LDATA(8,I) = .FALSE.
		 SYMBOLS_DEFINED = SYMBOLS_DEFINED - 1
	      ENDIF
3460	   CONTINUE
	ENDIF
	HADFRT = .FALSE.
	IF (FRTINI(FRTTIT(:NAMLEN))) GOTO 3455
	CALL FRT_GRAPH_INIT
	HADFRT = .TRUE.
	GOTO 10
3500	IF(.NOT.OVERLAY .AND. .NOT.SYMBOLS) THEN
	  CALL WRITEF('%S Specifying command SRI',ERROR_BELL)
	  CALL WRITEF('Overlay and symbol options are not enabled')
	  GOTO 10
	ENDIF
3550	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command SRI',ERROR_BELL)
	  CALL WRITEF('Input SRI filename is missing')
3555	  IF(.NOT.WAIT_INPUT('Input SRI filename',.FALSE.,.TRUE.))GOTO 10
	ELSE
	  CALL BSCH
	ENDIF
	RETVAL = GETFILNAM(SRITIT,NAMLEN,'LSL$FRT:SRI.SRI;0',.TRUE.)
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(RETVAL)
	  GOTO 10
	ENDIF
	IF (HADSRI .AND. SYMBOLS_DEFINED.GT.0) THEN
	   SYMBOL_UNDEFINE_MESS = .TRUE.
	   DO 3560 I = 1,MAX_SYMBOLS
	      IF (SYMBOL_LDATA(5,I)) THEN
		 IF(SYMBOL_UNDEFINE_MESS) THEN
	            CALL WRITEF('%S symbols are being undefined',
     &		    WARN_BELL)
		    SYMBOL_UNDEFINE_MESS = .FALSE.
		 ENDIF
	         SYMBOL_LDATA(5,I) = .FALSE.
		 IF(SYMBOL_LDATA(6,I)) THEN
	            SYMBOLS_USED = SYMBOLS_USED - 1
	            SYMBOL_LDATA(6,I) = .FALSE.
		 ENDIF
	         SYMBOL_LDATA(7,I) = .FALSE.
	         SYMBOL_LDATA(8,I) = .FALSE.
		 SYMBOLS_DEFINED = SYMBOLS_DEFINED - 1
	      ENDIF
3560	   CONTINUE
	ENDIF	
	HADSRI = .FALSE.
	IF (SRIINI(SRITIT(:NAMLEN))) GOTO 3555
	HADSRI = .TRUE.
	GOTO 10
3600	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command SELECT',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled')
	  GOTO 10
	ENDIF
	CMD = RDCOMM(SEL_CMD_TABLE)	! look for qualifier
	IF (CMD.LE.0) THEN
	  CALL WRITEF('%S Specifying command SELECT',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are ALL, FC, FSN or LAYER')
	  GOTO 10
	ENDIF
	GOTO (3610,3620,3630,3640) CMD
3610	IF (RDSEL(.TRUE.,.FALSE.)) GOTO 10
	GOTO 10
3620	IF (RDLAY(.TRUE.)) GOTO 10
	GOTO 10
3630	IF (RDFSN(.TRUE.)) GOTO 10
	GOTO 10
3640	LYSMOD = .FALSE.
	FCSMOD = .FALSE.
	FSNMOD = .FALSE.
	CALL VIOCLR(LAYMAP,LAYMAX*4,-1)	 ! reset the whole bit-map.
	CALL VIOCLR(FCMAP,FCMAX*4,-1)	 ! reset the whole bit-map.
	CALL VIOCLR(FSNMAP,FSNMAX*4,-1)	 ! reset the whole bit-map.
	GOTO 10
3700	IF(.NOT.OVERLAY)THEN
	  CALL WRITEF('%S Specifying command DESELECT',ERROR_BELL)
	  CALL WRITEF('Overlay options are not enabled') 
	  GOTO 10
	ENDIF
	CMD = RDCOMM(SEL_CMD_TABLE)
	IF(CMD.LE.0.OR.CMD.EQ.4)THEN
	  CALL WRITEF('%S Specifying command DESELECT',ERROR_BELL)
	  CALL WRITEF('Command qualifiers are  FC, FSN or LAYER')
	  GOTO 10
	ENDIF
	GOTO (3710,3720,3730) CMD
3710	IF (RDSEL(.FALSE.,.FALSE.)) GOTO 10
	GOTO 10
3720	IF (RDLAY(.FALSE.)) GOTO 10
	GOTO 10
3730	IF (RDFSN(.FALSE.)) GOTO 10
	GOTO 10
3900	IF(MCMD)THEN
	  CMD=CMD-6
	  CALL WRITEF('%S> UNITS %S',PROMPT,UNITS_TYPE(CMD))
	ELSE
	  CMD=RDCOMM(UNIT_CMD_TABLE)	
	  IF(CMD.LE.0) THEN! unrecognised command
	    CALL WRITEF('%S Specifying command UNITS',ERROR_BELL)
	    CALL WRITEF
     &	 ('Command qualifiers are MATRIX, METRES, SECONDS,  LATLONG '//
     &   'or PROJECTION')
	    GOTO 10
	  ENDIF
	ENDIF
	IF (DTILUN_INUSE(1)) THEN
	   RETVAL = DTI_UNITS(1,CMD)
	   IF (.NOT. RETVAL) THEN
	      IF (RETVAL .EQ. DTI__INVUNITS) THEN
	         CALL WRITEF('%S Specifying command UNITS',ERROR)
		 CALL WRITEF
     &          ('Command qualifier is invalid for the input file')
	      ELSE
		 CALL LSL_PUTMSG(RETVAL)
	      ENDIF
	      GOTO 10
	   ENDIF
	ENDIF
	UNITS=CMD
	GOTO 10
4000	IF(CMDRCT.NE.1)THEN
	  CALL WRITEF('%S Specifying command WAIT',ERROR_BELL)
	  CALL WRITEF('Command requires a real argument')
	  GOTO 10
	ENDIF
	CALL LIB$WAIT (REALAR(1))
	GOTO 10
4100	I=0
4110	IF(RDCH(CH))THEN
	  GOTO 4120
	ELSE	
	  I=I+1
	  IF(I.GT.80)THEN
	    CALL WRITEF('%S Specifying command SPAWN',ERROR_BELL)
	    CALL WRITEF('DCL command line cannot exceed 80 characters')
	    GOTO 10
	  ENDIF	  
	  LINE(I:I)=CHAR(CH)
	  GOTO 4110
	ENDIF
4120	IF(I.EQ.0)THEN
	  CALL WRITEF('%S Specifying command SPAWN',ERROR_BELL)
	  CALL WRITEF('Command requires a valid DCL command')
	  GOTO 10
	ENDIF
	IF (.NOT.CMDFIL) CALL SET_OUTBAND_AST
	IERR= LIB$SPAWN (LINE(1:MIN(I,80)))
	IF (.NOT.CMDFIL) CALL SET_OUTBAND_AST(CTRLCAST,8)
	IF(.NOT.IERR)THEN
          CALL LIB$SIGNAL(%VAL(IERR)) !error
	  CALL WRITEF('%S Unable to spawn command, returning to DTIVIEW',
     &              ERROR_BELL)
	ENDIF
	CALL WRITEF
	GOTO 10
4300	IF(CMDNEG)THEN
	  DEBUG=.FALSE.
	ELSE
	  DEBUG=.TRUE.
	ENDIF
	GOTO 10
4400	IF(MCMD)THEN
	  INTARG(1)=CMD-53
	  CALL WRITEF('%S> PLANES %N',PROMPT,INTARG(1))
	  GOTO 4450
	ENDIF
	IF(CMDICT.NE.1)THEN
	  CALL WRITEF('%S Specifying command PLANES',ERROR_BELL)
	  CALL WRITEF('Command requires 1 integer argument')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.4.OR.INTARG(1).GT.8)THEN
	  CALL WRITEF('%S Specifying command PLANES',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires 1 integer argument in the range 4 to 8')
	  GOTO 10
	ENDIF
4450	NOPLNS = INTARG(1)
	PLANE_MASK = 2**NOPLNS-1
        LNDCOL = (2**NOPLNS)-3
	MAXCOL = LNDCOL
	STEPS = MAXCOL
	IF(NOPLNS.GT.4)THEN
	   OVERLAY_COLOURS=(2**(8-NOPLNS))-1
	ELSE
	   OVERLAY_COLOURS=0
	ENDIF
	IF(PRIMARY .AND. INIT_PRIMARY)CALL INIT_DEVICE(1)
	IF(SECONDARY .AND. INIT_SECONDARY)CALL INIT_DEVICE(2)
	IF(MCMD)CALL WRITEF
     &		('Use of %N planes for Picture 1 selected',NOPLNS)
	GOTO 10
4500	IF(CMDICT.NE.2)THEN
	  CALL WRITEF('%S Specifying command SAMPLE',ERROR_BELL)
	  CALL WRITEF('Command requires 2 integer arguments')
	  GOTO 10
	ENDIF
	IF(INTARG(1).LT.1.OR.INTARG(2).LT.1)THEN
	  CALL WRITEF('%S Specifying command SAMPLE',ERROR_BELL)
	  CALL WRITEF
     &    ('Command requires 2 positive integer arguments')
	  GOTO 10
	ENDIF
	IF (FISHNET .AND. INTARG(1).NE.INTARG(2)) THEN
	  CALL WRITEF('%S Specifying command SAMPLE',ERROR_BELL)
	  CALL WRITEF
     & ('Fishnet representation is currently only available with')
	  CALL WRITEF
     & ('an equal sampling interval along the columns and rows')
	  CALL WRITEF('Fishnet option is disabled')
	  FISHNET=.FALSE.
	ENDIF
	IF (OVERLAY .AND. (INTARG(1).NE.1 .OR. INTARG(2).NE.1)) THEN
	  CALL WRITEF('%S Specifying command SAMPLE',ERROR_BELL)
	  CALL WRITEF
     &    ('Enable overlay options are only available with
     & sample intervals of 1')
	  CALL WRITEF('Overlay options have been disabled')
	  OVERLAY=.FALSE.
	ENDIF
	X_SAMPLE=INTARG(1)
	Y_SAMPLE=INTARG(2)
	GOTO 10
4600	CALL DTIV_PAUSE
	GOTO 10
4700	CONTINUE
	OK = SYMBOL_CMD()
	GOTO 10
4800	CONTINUE
	IF(.NOT.HAD_INDIRECT_FILE)THEN
	  CALL WRITEF('%S Specifying command RETURN',ERROR_BELL)
	  CALL WRITEF
     &    ('The RETURN command is only valid in a command file')
	  GOTO 10
	ENDIF
	CALL WRITEF('Returning to terminal input')
4850	RETVAL=FLRCLO(9)
	IF(.NOT.RETVAL)CALL LSL_PUTMSG(RETVAL)
	HAD_INDIRECT_FILE=.FALSE.
	GOTO 10
4900	CONTINUE
	OK = FOG_CMD()
	GOTO 10
8000	CONTINUE
	CALL OPEN_COMMAND_FILE
	GOTO 10
9000	IF(DTILUN_INUSE(1))THEN
	  RETVAL= DTI_CLOSE(1,.FALSE.,.FALSE.,ERROR)
	  IF(RETVAL.NE.DTI__NORMAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	    IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	  ENDIF
	ENDIF
	IF(DTILUN_INUSE(2))THEN
	  RETVAL= DTI_CLOSE(2,.FALSE.,.FALSE.,ERROR)
	  IF(RETVAL.NE.DTI__NORMAL)THEN
	    CALL LSL_PUTMSG(RETVAL)
	    IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	  ENDIF
	ENDIF
	RETVAL=LIB$DELETE_FILE ('LSL$DTI:VISIBILITY.GRD;*')
	IF(PRIMARY.AND.INIT_PRIMARY)    CALL GDAWK(1)
	IF(SECONDARY.AND.INIT_SECONDARY)CALL GDAWK(2)
	IF(PLOT_IFF)CALL ENDIFF
	CALL GCLKS
	IF(TABLE)CALL CLOSE_TAB (IERR)
	END

	LOGICAL FUNCTION OPEN_FILE(DTI_LUN)
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
	INTEGER*4	DTIPROJ_IDENT1
	PARAMETER	(DTIPROJ_IDENT1='*DTI')
	INTEGER*4	DTIPROJ_IDENT2
	PARAMETER	(DTIPROJ_IDENT2='PROJ')
	INTEGER*4	NUM_DTI
	PARAMETER	(NUM_DTI=9)
	INTEGER*4	DTIPROJ_RECORD_LENGTH	
	PARAMETER	(DTIPROJ_RECORD_LENGTH=1600)
	INTEGER*4	DTIPROJ_RECORD_OFFSET(NUM_DTI)
	REAL*8		DTIPROJ_ORIGIN(2,NUM_DTI)
	REAL*4 		DTIPROJ_SAMPLE(2,NUM_DTI)
	INTEGER*4	DTIPROJ_UNITS(NUM_DTI)
	INTEGER*4	DTIPROJ_SPHEROID(NUM_DTI)
	INTEGER*4	DTIPROJ_PROJECTION(NUM_DTI)
	REAL*8		DTIPROJ_USER_SPHEROID(2,NUM_DTI)
	REAL*8		DTIPROJ_PROJ_PARAMS(15,NUM_DTI)
	COMMON/DTIPROJ/	
     &			DTIPROJ_RECORD_OFFSET,
     &			DTIPROJ_ORIGIN,DTIPROJ_SAMPLE,
     &			DTIPROJ_UNITS,DTIPROJ_SPHEROID,
     &			DTIPROJ_PROJECTION,
     &			DTIPROJ_USER_SPHEROID,
     &			DTIPROJ_PROJ_PARAMS
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
	INTEGER*4	DTI_LUN		! channel number
	INTEGER*4	PSDSTR(2)	! Pseudo string descriptor
	INTEGER*4	ERROR		! function system errir code
	INTEGER*4	RETVAL		! function return code
	INTEGER*4	FAKSTR(2)	! fake string
	INTEGER*2	FAKLEN		! fake string length
	BYTE		FAKBUF(128)
	BYTE		CH		! single character
	EQUIVALENCE	(FAKLEN,FAKSTR(1))
	INTEGER*4	DTI_UNITS	! set up default units
	INTEGER*4	DTI_OPEN	! open and map a file
	INTEGER*4	DTI_CLOSE	! to unmap and close a file
	INTEGER*4	READSTR		! read string
	LOGICAL		PARFILN		! parse filename
	LOGICAL		RDCHS		! read character
	OPEN_FILE=.FALSE.	! Assume function is unsuccessful
	IF(DTILUN_INUSE(DTI_LUN))THEN
	  RETVAL = DTI_CLOSE (DTI_LUN, .FALSE., .TRUE., ERROR)	
	  IF(RETVAL.NE.DTI__NORMAL)THEN
	     CALL LSL_PUTMSG(RETVAL)
	     IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	     GOTO 999			!return
	  ENDIF	  
	ENDIF
	FAKSTR(2)=%LOC(FAKBUF)	! set up fake string descriptor
	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S DTI Filename missing',ERROR_BELL)
	  CALL BSLN
	  GOTO 999	  
	ELSE
	  FAKLEN=128
	  IF(CH.EQ.34.OR.CH.EQ.39)THEN
	    FAKLEN=READSTR(FAKSTR,CH,ON_CHAR2,.FALSE.)
	  ELSE
	    CALL BSCH
	    FAKLEN=READSTR(FAKSTR,' ',ON_CHAR2,.FALSE.)
	  ENDIF
	ENDIF
	RETVAL=PARFILN(DTI_NAME(DTI_LUN),
     &                 DTI_NAME_LENGTH(DTI_LUN),
     &	               FAKSTR,
     &	               'LSL$DTI:.DTI',
     &	               .TRUE.)
	IF(RETVAL.NE.LSL__NORMAL)THEN
	  CALL LSL_PUTMSG(RETVAL)
	  GOTO 999			!return
	ENDIF
	RETVAL = DTI_OPEN (DTI_LUN, 
     &                     DTI_NAME(DTI_LUN), 
     &                     DTI_NAME_LENGTH(DTI_LUN),
     &                     .FALSE.,
     &	                   ERROR,
     &  		   .TRUE.)	! report rotated matrix
	IF(RETVAL.NE.DTI__NORMAL)THEN
	  CALL LSL_PUTMSG(RETVAL)
	  IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	  GOTO 999			!return
	ENDIF
	IF(DATA_TYPE(DTI_LUN).NE.DATA_WORD)THEN
	  CALL WRITEF
     &	  ('%S Specifying command FILEIN',ERROR_BELL)
	  CALL WRITEF
     &    ('DTIVIEW currently accepts only a DTM containing WORD data')
	  RETVAL = DTI_CLOSE (DTI_LUN, .FALSE., .TRUE., ERROR)	
	  IF(RETVAL.NE.DTI__NORMAL)THEN
	     CALL LSL_PUTMSG(RETVAL)
	     IF(RETVAL.EQ.DTI__SYSERR)CALL LSL_PUTMSG(ERROR)
	  ENDIF
	  GOTO 999
	ENDIF
	UNITS = 0
	RETVAL = DTI_UNITS(DTI_LUN,UNITS)
	IF (.NOT. RETVAL) THEN
	   CALL LSL_PUTMSG(RETVAL)
	   GOTO 999
	ENDIF
	OPEN_FILE=.TRUE.		!signal success
999	RETURN
	END

	SUBROUTINE DTIV_PAUSE
	IMPLICIT NONE
	LOGICAL		OK,IERR,LTERM   ! in case of error
        INTEGER         ITERM   
	INTEGER		TTRSTR		! read from TT:
        INTEGER         TEST_TERM       ! test if reading from terminal
        ITERM = TEST_TERM('SYS$COMMAND',LTERM,IERR)
        PRINT*, 'ITERM = ',ITERM,' LTERM = ',LTERM,' IERR = ',IERR
        IF(.NOT.LTERM) GO TO 9990
	CALL WRITEF
	CALL WRITEF
	OK=TTRSTR(,,'Press <RETURN> to continue ',IERR)
	IF (.NOT.OK) THEN
	    CALL LSL_PUTMSG(OK)
	    CALL LSL_ADDMSG(IERR)
	ENDIF
9990	RETURN
	END
	LOGICAL FUNCTION HELP
	IMPLICIT NONE
	INTEGER		OLDPTR	! for storing DCPTR for HELP 
	INTEGER		I	! loop counter
	INTEGER*4       CMD     ! decoded command number
	INTEGER*4       TEXLEN	! length of user requested string
	BYTE		CH	! for decoding user requested string
	LOGICAL		EOLN	!  "	"	"	"	"
	CHARACTER*80	LINE	! the users requested string
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
	INTEGER		LINLEN	! max. length of help text string
	PARAMETER	(LINLEN=80)
	INTEGER		SS$_ABORT
	EXTERNAL	SS$_ABORT
	INTEGER		SS$_NORMAL
	EXTERNAL	SS$_NORMAL
	INTEGER		HELP_CMD_TABLE
	EXTERNAL	HELP_CMD_TABLE
	INTEGER		RDCOMM
	INTEGER		LBR$OUTPUT_HELP
	INTEGER		LIB$PUT_OUTPUT
	EXTERNAL	LIB$PUT_OUTPUT
	LOGICAL		RDCH
	EXTERNAL HLP_ERRET
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'
	INCLUDE 'LSL$CMNLSL:EXCEPTION.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
	HELP = %LOC(SS$_ABORT)	! assume we fail
	CALL LIB$ESTABLISH( HLP_ERRET )
	TEXLEN=0
	OLDPTR = DCPTR		! save old cmd decode pointer for now
	NOMESS = .TRUE.		! suppress CMDLIB's messages
	CMD=RDCOMM(HELP_CMD_TABLE)
	IF(ERRNUM.NE.LSL__NORMAL) DCPTR = OLDPTR
	NOMESS = .FALSE.	
	GOTO (10, 10, 20, 10), CMD+1
10	CONTINUE
	LINE='MATRIX DTIVIEW'
	TEXLEN=14
	GOTO 30
20	CONTINUE
	LINE='MATRIX'
	TEXLEN=6
30	CONTINUE
	EOLN = RDCH(CH)
	DO 50 I = 1,LINLEN
	   IF(EOLN.OR.CH.EQ.13) GOTO 100	! end loop on EOLN or <CR>
	   TEXLEN=TEXLEN+1
	   LINE(TEXLEN:TEXLEN) = CHAR(CH)
	   EOLN = RDCH(CH)
50	CONTINUE
	CALL WRITEF(
     &	'HELP command string too long - maximum %N characters',
     &					LINLEN)
	GOTO 999
100	CONTINUE
	IF (TEXLEN.EQ.0) THEN
	   LINE='MATRIX DTIVIEW'
	   TEXLEN=14
	ENDIF
	HELP = LBR$OUTPUT_HELP(LIB$PUT_OUTPUT,! output_routine
     &                       ,			! output_width
     &                       LINE(1:TEXLEN),	! line_descr
     &                       'LSL$HELP:MATRIX',	! library_name
     &                       0,			! flags
     &                       )			! input_routine
	CALL WRITEF(' ')
	IF (HELP) THEN 
	   HELP = %LOC(SS$_NORMAL)
	ENDIF
999	CONTINUE
	CALL LIB$REVERT
	RETURN
	END

	LOGICAL FUNCTION READLL(RESULT,NUMVAL,BYPASS_ARG)
	IMPLICIT NONE
	INTEGER*4	RESULT(4)	! lat and long in seconds
	INTEGER*4	NUMVAL
	LOGICAL 	BYPASS_ARG	! bypass first argument
	PARAMETER	POSN = 'N'	! upper case hemisphere letters
	PARAMETER	POSE = 'E'
	PARAMETER	NEGS = 'S'
	PARAMETER	NEGW = 'W'
	PARAMETER	POSNLC = 'n'	! lower case hemisphere letters
	PARAMETER	POSELC = 'e'
	PARAMETER	NEGSLC = 's'
	PARAMETER	NEGWLC = 'w'
	LOGICAL		RDCH	! read a char
	LOGICAL		RDLONG	! read a number
	INTEGER*4	I	! counter
	INTEGER*4	ACCUM	! accumulate angle in here
	INTEGER*4	NUMBER
	BYTE		CH	! a character
	READLL = .TRUE.		! be pessimistic
	CALL BSLN
50	IF (RDCH(CH)) GOTO 999	! error
	IF (CH.LT.'0'.OR.CH.GT.'9') GOTO 50
	IF(BYPASS_ARG) THEN		! bypass first argument
60	   IF (RDCH(CH)) GOTO 999	! error
	   IF (CH.NE.' ') GOTO 60
70	   IF (RDCH(CH)) GOTO 999	! error
	   IF (CH.LT.'0'.OR.CH.GT.'9') GOTO 70
	ENDIF
	DO 500 I=1,NUMVAL
	CALL BSCH
	ACCUM = 0
	IF (RDLONG(NUMBER)) GOTO 999
	ACCUM = NUMBER * 3600		! in seconds
250	IF (RDCH(CH)) GOTO 999
	IF(CH.EQ.' ')GOTO 250		! space
	IF(CH.GT.'@')GOTO 300		! alpha character
	IF(CH.LT.'0'.OR.CH.GT.'9')GOTO 999
	CALL BSCH
	IF ( RDLONG(NUMBER) ) GOTO 999
	ACCUM = ACCUM + NUMBER*60	! in seconds
270	IF(RDCH(CH))GOTO 999
	IF(CH.EQ.' ')GOTO 270		! space
	IF(CH.GT.'@')GOTO 300		! alpha character
	IF(CH.LT.'0'.OR.CH.GT.'9')GOTO 999
	CALL BSCH
	IF (RDLONG(NUMBER)) GOTO 999
	ACCUM = ACCUM + NUMBER		! seconds
280	IF (RDCH(CH)) GOTO 999
	IF(CH.EQ.' ')GOTO 280
300	IF(I.EQ.1.OR.I.EQ.3)THEN
	  IF(CH.EQ.'W'.OR.CH.EQ.'w'.OR.CH.EQ.'E'.OR.CH.EQ.'e')THEN
	    CALL WRITEF('Lat and Long values supplied in wrong order')
	    GOTO 999
	  ENDIF
	ELSE
	  IF(CH.EQ.'N'.OR.CH.EQ.'n'.OR.CH.EQ.'S'.OR.CH.EQ.'s')THEN
	    CALL WRITEF('Lat and Long values supplied in wrong order')
	    GOTO 999
	  ENDIF
	ENDIF
    	IF (CH.EQ.'S'.OR.CH.EQ.'s')THEN
	   ACCUM= -ACCUM 
	   GOTO 450
	ENDIF
	IF (CH.EQ.'W'.OR.CH.EQ.'w')THEN
	   ACCUM= -ACCUM
	   GOTO 450
	ENDIF
	IF (CH.EQ.'N'.OR.CH.EQ.'n')GOTO 450
	IF (CH.EQ.'E'.OR.CH.EQ.'e')GOTO 450
	GOTO 999
450	RESULT(I)=ACCUM
	IF(I.NE.NUMVAL)THEN
460	  IF(RDCH(CH))GOTO 999
	  IF (CH.LT.'0'.OR.CH.GT.'9')GOTO 460
	ENDIF
500	CONTINUE
	READLL = .FALSE.
999     RETURN
	END

8	SUBROUTINE SET_IFFWIN
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
	INTEGER*4	DTIPROJ_IDENT1
	PARAMETER	(DTIPROJ_IDENT1='*DTI')
	INTEGER*4	DTIPROJ_IDENT2
	PARAMETER	(DTIPROJ_IDENT2='PROJ')
	INTEGER*4	NUM_DTI
	PARAMETER	(NUM_DTI=9)
	INTEGER*4	DTIPROJ_RECORD_LENGTH	
	PARAMETER	(DTIPROJ_RECORD_LENGTH=1600)
	INTEGER*4	DTIPROJ_RECORD_OFFSET(NUM_DTI)
	REAL*8		DTIPROJ_ORIGIN(2,NUM_DTI)
	REAL*4 		DTIPROJ_SAMPLE(2,NUM_DTI)
	INTEGER*4	DTIPROJ_UNITS(NUM_DTI)
	INTEGER*4	DTIPROJ_SPHEROID(NUM_DTI)
	INTEGER*4	DTIPROJ_PROJECTION(NUM_DTI)
	REAL*8		DTIPROJ_USER_SPHEROID(2,NUM_DTI)
	REAL*8		DTIPROJ_PROJ_PARAMS(15,NUM_DTI)
	COMMON/DTIPROJ/	
     &			DTIPROJ_RECORD_OFFSET,
     &			DTIPROJ_ORIGIN,DTIPROJ_SAMPLE,
     &			DTIPROJ_UNITS,DTIPROJ_SPHEROID,
     &			DTIPROJ_PROJECTION,
     &			DTIPROJ_USER_SPHEROID,
     &			DTIPROJ_PROJ_PARAMS
	REAL*8		ABS_S_X_WIN,ABS_S_Y_WIN
	REAL*8		ABS_N_X_WIN,ABS_N_Y_WIN
	IF (.NOT. DTILUN_INUSE(1)) GOTO 999
	IF ((.NOT. HAD_PROJ_RECORD(1)) .AND. (HEADER_TYPE(1).NE. 
     &  DTI_UHL1) .AND. (HEADER_TYPE(1) .NE. DTI_TED4).OR. 
     &  (.NOT. HAD_ABSOLUTE).OR.(.NOT. DTILUN_INUSE(1))) THEN
	   WIND(1,1)=RANGE_VALUES(1)
	   WIND(1,2)=RANGE_VALUES(3)
	   WIND(2,1)=RANGE_VALUES(2)
	   WIND(2,2)=RANGE_VALUES(4)
	   GOTO 999
	ENDIF
	IF (HEADER_TYPE(1).EQ.DTI_TED4 .OR. HEADER_TYPE(1).EQ.DTI_UHL1)
     &  THEN
	   ABS_S_X_WIN = (DTI_WINDOW_SWX(1)-1)*LONINT(1)+LONREC(1,1) 
	   ABS_S_Y_WIN = (DTI_WINDOW_SWY(1)-1)*LATINT(1)+LATREC(1,1) 
	   ABS_N_X_WIN = (DTI_WINDOW_NEX(1)-1)*LONINT(1)+LONREC(1,1) 
	   ABS_N_Y_WIN = (DTI_WINDOW_NEY(1)-1)*LATINT(1)+LATREC(1,1) 
	ELSE
	   ABS_S_X_WIN = (DTI_WINDOW_SWX(1)-1)*DTIPROJ_SAMPLE(1,1)+
     &     DTIPROJ_ORIGIN(1,1)
	   ABS_S_Y_WIN = (DTI_WINDOW_SWY(1)-1)*DTIPROJ_SAMPLE(2,1)+
     &     DTIPROJ_ORIGIN(2,1)
	   ABS_N_X_WIN = (DTI_WINDOW_NEX(1)-1)*DTIPROJ_SAMPLE(1,1)+
     &     DTIPROJ_ORIGIN(1,1)
	   ABS_N_Y_WIN = (DTI_WINDOW_NEY(1)-1)*DTIPROJ_SAMPLE(2,1)+
     &     DTIPROJ_ORIGIN(2,1)
	ENDIF
	WIND(1,1) = ABS_S_X_WIN-ORIGIN_OFFSET(1)
	WIND(1,2) = ABS_S_Y_WIN-ORIGIN_OFFSET(2)
	WIND(2,1) = ABS_N_X_WIN-ORIGIN_OFFSET(1)
	WIND(2,2) = ABS_N_Y_WIN-ORIGIN_OFFSET(2)
999	RETURN
	END

	SUBROUTINE RESET_IFFWIN(OLD_DTI,NEW_DTI,OLD_IFF,NEW_IFF)
	IMPLICIT NONE
	INTEGER*4	OLD_DTI(2,2)	! IN - old DTI file window
	INTEGER*4	NEW_DTI(2,2)	! IN - new DTI file window
	REAL*4		OLD_IFF(2,2)	! IN - old IFF file window
	REAL*4		NEW_IFF(2,2)	! OUT - new IFF window		
	REAL		X_SCALE,Y_SCALE	! scale factors
	INTEGER*4	DTI_TRANSLATION_X	! translations
	INTEGER*4	DTI_TRANSLATION_Y 
	DTI_TRANSLATION_X =  OLD_DTI(1,1) - NEW_DTI(1,1)
	DTI_TRANSLATION_Y =  OLD_DTI(1,2) - NEW_DTI(1,2)
	X_SCALE = (OLD_IFF(2,1)-OLD_IFF(1,1))
     &	             /REAL(OLD_DTI(2,1)-OLD_DTI(1,1))
	Y_SCALE = (OLD_IFF(2,2)-OLD_IFF(1,2))
     &	             /REAL(OLD_DTI(2,2)-OLD_DTI(1,2))
	NEW_IFF(1,1) = OLD_IFF(1,1) - DTI_TRANSLATION_X*X_SCALE
	NEW_IFF(1,2) = OLD_IFF(1,2) - DTI_TRANSLATION_Y*Y_SCALE
	NEW_IFF(2,1) = OLD_IFF(1,1) + 
     &  X_SCALE*(NEW_DTI(2,1)-NEW_DTI(1,1))
	NEW_IFF(2,2) = OLD_IFF(1,2) + 
     &  Y_SCALE*(NEW_DTI(2,2)-NEW_DTI(1,2))
	RETURN
	END
