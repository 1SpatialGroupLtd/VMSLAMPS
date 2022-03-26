	LOGICAL FUNCTION TABINIT(ON)
	IMPLICIT NONE
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	LOGICAL		ON		! turn on, or off
	LOGICAL		INIT_TABLE
	IF (.NOT.MONOPT) THEN
	   IF (ON) THEN
	      IF (PRIOPT.AND.WTYPES(1).NE.4014) THEN	
	         CALL TKIDEV(DIGLIN,2,0)
	         CALL LDWAIT
	         TABINIT = .TRUE.	! now on
	      ENDIF
	   ELSE
	      TAREAD = .FALSE.		! no table read up
	   ENDIF
	   GOTO 999
	ENDIF
	TABINIT = INIT_TABLE(ON,)	! no AST
999	RETURN
	END

	LOGICAL FUNCTION BITINIT(ON)
	IMPLICIT NONE
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	LOGICAL	ON			! turn on or off?
	REAL	BITMAT(5)
	DATA	BITMAT/-0.014,-0.07,0.0,1.0,0.00014/
	BITINIT = .FALSE.		! assume off
	IF (ON) THEN			! turn on
	   IF (PRIOPT.AND.WTYPES(1).NE.4014) THEN	
	      CALL TKIDEV(BITLIN,1,20)
	      CALL TKMAPT(BITLIN,BITMAT)
	      CALL TKTRAC(BITLIN,1)
	      CALL LDWAIT
	      BITINIT = .TRUE.		! now on
	   ELSEIF (PRIOPT.AND.WTYPES(1).EQ.4014) THEN
	      BITINIT = .TRUE.		! just set ON for 4014
	   ENDIF
	ENDIF
	RETURN
	END
	SUBROUTINE GTDGXY(LINE,BUTTON,XY,EXSTSU,ABORT)
	IMPLICIT NONE
	INTEGER*4	LOWB		! min. box number in any menu
	PARAMETER	(LOWB = 1)	! or button number on puck
	INTEGER*4	MNNLEN		! maximum length of menu
	PARAMETER	(MNNLEN=16)	! and puck names
	CHARACTER*(*)	MAXMAC_LOG_NAME
	PARAMETER	(MAXMAC_LOG_NAME = 'LSL$LITES2_MACROMAX')
	CHARACTER*(*)	MAXMENUSQU_LOG_NAME
	PARAMETER	(MAXMENUSQU_LOG_NAME = 'LSL$LITES2_MENUSQUAREMAX')
	INTEGER*4	DEFAULT_MAXUSR	! maximum number of user macros
	PARAMETER	(DEFAULT_MAXUSR = 600)
	INTEGER*4	DEFAULT_MAXMENU_SQUARES	! maximum number of menu squares
						! and puck buttons
	PARAMETER	(DEFAULT_MAXMENU_SQUARES = 500)
	INTEGER*4	MAXMEN		! maximum number of menus
	PARAMETER	(MAXMEN = 4)
	INTEGER*4	MAXPUK		! maximum number of pucks
	PARAMETER	(MAXPUK = 7)
	INTEGER*4	MAXTRK		! maximum tracking areas
	PARAMETER	(MAXTRK = 2)
	INTEGER*4	SAVSIZ		! size of save buffer
	PARAMETER	(SAVSIZ = 12)
	INTEGER*4	MAXINF		! max. no. of types of info
	PARAMETER	(MAXINF = 2)
	INTEGER*4	MAXNAM		! max. no. of menus and pucks
	PARAMETER	(MAXNAM = MAXMEN + MAXPUK)
	INTEGER*4	PTBASE		! for accessing MENINF array
	PARAMETER	(PTBASE=1)
	INTEGER*4	PTSIZE		! for accessing MENINF array
	PARAMETER	(PTSIZE=2)
	INTEGER*4	MSM		! max. macro string length
	PARAMETER	(MSM = 32767)
	INTEGER*4	MSCR_TIT
	PARAMETER	(MSCR_TIT = 20)
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	REAL		MNCRPT(4,4,MAXMEN)	! corner points of each
						! menu in form
						! x1,y1,x2,y2,NW,Menu
						! x1,y1,x2,y2,SW,Menu
						! etc
						! where 1 are table and
						! 2 are menu coords
	INTEGER*4	BOXINX(MAXMEN)		! number of boxes in 
						! x direction
	INTEGER*4	BOXMAX(MAXMEN)		! total number of boxes
						! in this menu
	INTEGER		MENLEN(MAXMEN)		! length of menu name
	INTEGER*4	MENDEV(MAXMEN)		! device that menu set
						! on (BITLIN or DIGLIN)
	LOGICAL*1	MENDEF(MAXMEN)		! .TRUE. when menu has 
					   	! been positioned
	INTEGER*4	MENTOP			! number of menus 
						! defined
	INTEGER*4	MNPTOP			! number of menus +
						! pucks defined
	INTEGER*4	PUKTOP		! number of pucks defined
	INTEGER*4	PUKBUT(MAXPUK)	! number of puck buttons defined
	INTEGER*4	PUKLEN(MAXPUK)	! length of puck name
	INTEGER*4	PUKDEV(MAXPUK)	! number of device that puck
					! buttons defined for
	INTEGER*4	PUKBAS(MAXPUK)	! base pointer for TRNTIP
	INTEGER*4	PUKPOS_ADDR
	LOGICAL		PUKALT(MAXPUK)	! default altered by PRI POS
	INTEGER*4	SCRMEN_INX	! number of boxes in X
	INTEGER*4	SCRMEN_INY	! and in Y
	REAL		SCRMEN_SIZX	! total size of menu in X (mm)
	REAL		SCRMEN_SIZY	! and in Y
	REAL		SCRMEN_ORGX	! location of orienting box
	REAL		SCRMEN_ORGY	! (as fraction of screen)
	REAL		SCRMEN_CPTS(2,4)! corner points of menu (in
					! the units that INTERACT gets
					! from tracking device)
	REAL		SCRMEN_BRDR(2,4)! corner points of complete menu
	REAL		SCRMEN_BOXX	! width of menu box
	REAL		SCRMEN_BOXY	! height of menu box
	INTEGER		SCRMEN_LOC	! locating code
	CHARACTER*(MSCR_TIT)	SCRMEN_TITLE	! title for menu
	INTEGER*4	SCRMEN_LTIT	! length of TITLE
	INTEGER*4	SCRMEN_BASE	! base of menu in macro table
	INTEGER		SCRMEN_PUKNO	! number of puck for screen menu
	LOGICAL		SCRMEN_DEF	! screen menu defined
	COMMON/MENUS/MNCRPT,SCRMEN_SIZX,SCRMEN_SIZY,		! R*4
     &	             SCRMEN_ORGX,SCRMEN_ORGY,SCRMEN_CPTS,
     &	             SCRMEN_BRDR,SCRMEN_BOXX,SCRMEN_BOXY,
     &	             BOXINX,BOXMAX,MENLEN,MENDEV,		! I*4
     &	             MENTOP,MNPTOP,PUKTOP,
     &	             PUKBUT,PUKLEN,PUKDEV,PUKBAS,
     &	             SCRMEN_LOC,SCRMEN_INX,SCRMEN_INY,
     &	             SCRMEN_LTIT,SCRMEN_BASE,SCRMEN_PUKNO,
     &	             PUKPOS_ADDR,PUKALT,
     &	             MENDEF,SCRMEN_DEF				! L*1
	CHARACTER*16	MENNAM(MAXMEN)		! names of menus
	CHARACTER*16	PUKNAM(MAXPUK)		! name of pucks
	COMMON/MENCHS/MENNAM,PUKNAM,SCRMEN_TITLE
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
	INTEGER*4	TABPUK	! for table monitor puck
	INTEGER*4	TABSTR	! for table monitor streaming mode
	INTEGER*4	TABERR	! for table monitor error
	INTEGER*4	TABFLG	! for wosplib table/bitpad
	INTEGER*4	TTIFLG	! for terminal input
	INTEGER*4	CLCFLG	! for control C event flag
	INTEGER*4	TBFLG	! for trackerball event flag
	INTEGER*4	FBFLG	! for trackerball button event flag
	INTEGER*4	TMOFLG	! for TEK timeout timer
	INTEGER*4	CSRFLG	! for TEK cursor timeout timer
	INTEGER*4	DTBFLG	! for direct table reading
	INTEGER*4	BUTFLG	! for reading function buttons
	INTEGER*4	AUXFLG	! for reading auxiliary inputs
	INTEGER*4	FOLFLG	! for streaming timer
	COMMON	/VAREFN/TABPUK,TABSTR,TABERR,TABFLG,TTIFLG,
     &			CLCFLG,TBFLG,FBFLG,TMOFLG,CSRFLG,DTBFLG,
     &	                BUTFLG,AUXFLG,FOLFLG
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INCLUDE '($SSDEF)'		! system paramaters
	INTEGER*4	LINE		! digitiser area that was
					! pressed
					! = 2 for bitpad
					! = 3 for digitiser
	INTEGER*4	BUTTON		! button that was pressed
	REAL		XY(2)		! table coordinates
	LOGICAL		EXSTSU		! .TRUE. if button pressed is
					! second highest defined
	LOGICAL		ABORT		! .TRUE. if button pressed
					! was highest defined, or
					! ^C has been pressed
	LOGICAL		STRDTB
	LOGICAL		DIGTRN
	LOGICAL		GTYPAC
	LOGICAL		HADBREAK
	INTEGER*4	TRNBUT
	LOGICAL		HAD_ERROR,READ_ERROR
	LOGICAL		HAD_PUCK,READ_PUCK
	LOGICAL*1	DIGBUF(12)	! buffer for info from TKREAD
	INTEGER*2	INLEN		! length of input buffer
	INTEGER*2	OUTLEN		! length of info returned
	INTEGER*2	ICHAN		! channel used
					! = 1 if read from keyboard
					! = 2 if read from tablet/table
	REAL		VXY(2)		! X and Y coords returned in
					! DIGBUF
	INTEGER*2	LIN,PRBUT	! line and button number
					! returned in DIGBUF
	INTEGER*2	IOSB(4)		! return status
	INTEGER*4	I		! counter
	INTEGER*4	BUFFLEN
	PARAMETER	(BUFFLEN=40)
	BYTE		BUFF(BUFFLEN)	! buffer for direct table reads
	INTEGER*4	COUNT		! no of chars in typeahead buff
	BYTE		BYTE1		! first byte
	INTEGER*4	MASK
	INTEGER*4	LENGTH		! I*4 value of buffer length
	EQUIVALENCE	(LIN,DIGBUF(1)),(PRBUT,DIGBUF(3))
	EQUIVALENCE	(VXY(1),DIGBUF(5))
	LOGICAL*1	TKUP		! to remember if there is a 
					! read to the TEK outstanding
	LOGICAL*1	DTBUP		! to remember if there is a
					! read to direct table up
	INTEGER*4	IERR		! return code
	LOGICAL*1	RMON		! .TRUE. if using table monitor
	BYTE		BU		! puck button number returned
					! by table montor
	INTEGER*4	IX,IY		! coordinates returned by
					! table monitor
	DATA		INLEN/12/	! This is always 12
	DATA		ICHAN/2/	! in this subroutine, always
					! want tablet or table
	EXSTSU = .FALSE.
	ABORT  = .FALSE.
	TKUP   = .FALSE.
	IF (DTRON.AND.DTBREAD) THEN
	   CALL DTBKIL(DTBCHN)
	   DTBREAD=.FALSE.
	ENDIF
	DTBUP  = .FALSE.
	RMON   = TABINI.AND.MONOPT.AND..NOT.DTRON
10	IF ((BITINI.OR..NOT.MONOPT).AND..NOT.TKUP) THEN	! if wosplib
	   CALL TKREAD(ICHAN,DIGBUF,INLEN,OUTLEN,TABFLG,IOSB)
	   TKUP=.TRUE.
	ENDIF
	IF (DTRON.AND..NOT.DTBUP) THEN
	   IF (GTYPAC(DTBCHN,COUNT,BYTE1)) THEN	! check type ahead buff
	      IF (COUNT.GT.MXTYPC) THEN
	         CALL INFORM(MSG_NOMOREBUTS,COUNT/15)
	      ENDIF
	   ENDIF
	   DTBUP=STRDTB(DTBFLG,DTBCHN,DTBOSB,,BUFFLEN,BUFF)
	ENDIF
	CALL SYS$CLREF(%VAL(CLCFLG))
	MASK = 0				! clear to start with
	CALL EFWM(MASK,CLCFLG)			! control C
	IF (TKUP) CALL EFWM(MASK,TABFLG)	! add WOSP table
	IF (DTBUP) CALL EFWM(MASK,DTBFLG)	! add direct table read
	IF (RMON) CALL EFWM(MASK,TABPUK,TABERR)	! monitor puck and error
	IF (BALINI) CALL EFWM(MASK,FBFLG)	! function buttons
	CALL SYS$WFLOR( %VAL(CLCFLG), %VAL(MASK) )
	IF (HADBREAK()) THEN			! check for ^C
	   ABORT=.TRUE.
	   IF (TKUP) CALL TKKILL(ICHAN)
	   GOTO 999
	ENDIF
	IF (BALINI) THEN
	   CALL VSFBRD(I)		! see which FB has been hit
	   IF (I.NE.0) THEN
	      BUTTON = I-1		! into range 0-3
	      LINE = 4			! on device 4
	      GOTO 600
	   ENDIF
	ENDIF
	IF (DTBUP.AND.DTBOSB(1).NE.0) GOTO 100
	IF (TKUP.AND.IOSB(1).NE.0) GOTO 200
	IF (RMON) THEN
	   IF (HAD_ERROR(IERR)) THEN
	      IF (.NOT.READ_ERROR(TXTBUF,TXTPTR,I,IERR)) THEN
	         CALL INFORM(MSG_TABMONERR,I)
	         CALL INFORM(MSG_STRING,TXTDSC)
	      ENDIF
	      GOTO 10					! try again
	   ELSEIF (HAD_PUCK(IERR)) THEN
	      IF (.NOT.READ_PUCK(BU,IX,IY,IERR)) THEN
	         LINE=DIGLIN
	         BUTTON=BU
	         VXY(1)=IX
	         VXY(2)=IY
	         IF (TKUP) CALL TKKILL(ICHAN)
	         IF (DTBUP) CALL DTBKIL(DTBCHN) 	! should not
							! happen 
	         GOTO 600
	      ELSE					! error reading
	         GOTO 10				! TRY AGAIN
	      ENDIF
	   ENDIF
	ENDIF
	CALL INFORM(MSG_NOINPUT)
	GOTO 10
100	DTBUP=.FALSE.
	IF (.NOT.DTBOSB(1)) THEN		! error
	   CALL LITES2_SIGNAL(DTBOSB(1))
	   GOTO 10
	ENDIF
	LENGTH=DTBOSB(2)			! I*2 -> I*4
	IF (LENGTH.LE.0) GOTO 10
	IF (DIGTRN(BUFF,LENGTH,BUTTON,IX,IY,USEFUN,%VAL(FUNADR))) THEN
	   CALL INFORM(MSG_TABERRREAD,BUFF)   ! error in string
	   GOTO 10
	ELSE
	   LINE=DIGLIN
	   VXY(1)=IX
	   VXY(2)=IY
	   IF (TKUP) CALL TKKILL(ICHAN)
	ENDIF
	GOTO 600
200	TKUP=.FALSE.
	IF (.NOT.IOSB(1)) THEN
	   CALL LITES2_SIGNAL(IOSB(1))
	   GOTO 10
	ENDIF
	LINE=LIN
	BUTTON=PRBUT
	IF (LINE.EQ.BITLIN) CALL LIB$FFS(0,4,PRBUT,BUTTON)
	IF (DTBUP) CALL DTBKIL(DTBCHN)
	GOTO 600
600	BUTTON=TRNBUT(BUTTON,LINE)	! normalise button number
	XY(1)=VXY(1)
	XY(2)=VXY(2)
	IF (BUTTON.NE.-1) THEN
	   DO 20, I=1,PUKTOP
	      IF (PUKDEV(I).EQ.LINE) THEN
	         IF (BUTTON.EQ.PUKBUT(I)) ABORT=.TRUE.
	         IF (BUTTON.EQ.(PUKBUT(I)-1)) EXSTSU=.TRUE.
	         GOTO 999
	      ENDIF
20	   CONTINUE
	ENDIF
999	TAREAD=.FALSE.
	IF (DTRON) THEN
	   CALL DTBKIL(DTBCHN)
	   DTBREAD=.FALSE.
	ENDIF
	RETURN
	END

	SUBROUTINE RFMOVE
	IMPLICIT NONE
	CHARACTER*(*)	STDBFM_LOG_NAME
	PARAMETER	(STDBFM_LOG_NAME = 'LSL$FILL_POINTSMAX')
	PARAMETER	DEFAULT_STDBFM = 8192
	INTEGER		STDBFM		! size of buffer
	INTEGER		STDBFP		! buffer pointer
	INTEGER*4	STDBFX_ADDR	! coords X
	INTEGER*4	STDBFY_ADDR	! coords Y
	INTEGER*4	STDBFZ_ADDR	! coords Z
	INTEGER		STDBFC_ZONE
	INTEGER		DTI_BMAX
	INTEGER		DTI_WMAX
	INTEGER		DTI_LMAX
	INTEGER*4	DTIL_ADDR
	INTEGER*4	DTIW_ADDR
	INTEGER*4	DTIB_ADDR
	COMMON/STDBFC/STDBFM,DTI_BMAX,DTI_WMAX,DTI_LMAX,STDBFP,
     &	              STDBFC_ZONE,
     &	              STDBFX_ADDR,STDBFY_ADDR,STDBFZ_ADDR,
     &	              DTIB_ADDR,DTIW_ADDR,DTIL_ADDR
	CALL RFMOVE_SUB(STDBFM,%VAL(STDBFX_ADDR),%VAL(STDBFY_ADDR))
	RETURN
	END
	SUBROUTINE RFMOVE_SUB(LENGTH,STDBFX,STDBFY)
	IMPLICIT NONE
	INCLUDE	'LSL$CMNIFF:CB.STR'
	PARAMETER AUXLEN = 8	! length of auxiliary array
	PARAMETER XCENI= 1	! x coord of centre
	PARAMETER YCENI= 2	! y coord of centre
	PARAMETER RADI = 3	! radius
	PARAMETER STAI = 4	! start angle
	PARAMETER TOTI = 5	! total angle
	PARAMETER ANGI = 1	! angle
	PARAMETER COSI = 2	! cosine
	PARAMETER SINI = 3	! sine
	PARAMETER SIZI = 4	! size
	PARAMETER MINXI= 5	! minimum x
	PARAMETER MAXXI= 6	! maximum x
	PARAMETER MINYI= 7	! minimum y
	PARAMETER MAXYI= 8	! maximum y
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	REAL*8		LINWDTH_FCTR
	PARAMETER	(LINWDTH_FCTR = 5.0E-7)
	REAL*8		LINWDTH		! the "width of a line" -
					! used for comparison with zero
	REAL		CSXY(3)		! current cursor position
	INTEGER		CSZI		! Z value of cursor position (as
					! INTEGER)
	EQUIVALENCE	(CSXY(3),CSZI)	! equivalenced
	REAL		XSECTW,YSECTW	! sector widths
	REAL		XOFF,YOFF	! SW corner of sector grid
	REAL		LIMITS(4)	! extent of sector grid
	REAL*8		ABS_LIMITS(4)	! absolute range of maps
	LOGICAL		HAD_RANGE_CMD	! true when had RANGE command 
	INTEGER XRANGE,YRANGE	! number of sectors in the y- and x-axes
	INTEGER	TOPSEC		! last sector being used
	INTEGER	NDMODE		! end mode - what to do on END command
	INTEGER	LASBUT		! last button used ($BUTTON)
	REAL	WINXY(2)	! saved SW corner of window
	INTEGER	WINREG		! region number for REGION n WINDOW
	LOGICAL	SCSARC		! constrain on arc/line?
	REAL	SCSAUX(5)	! aux array if circle (should use AUXLEN,
				!  but can't face including AUXDEF
	REAL	SCSTXY(2,2)	! ends of constraint line
	INTEGER	CUST		! customer number (as in map header)
				! = 0 for unknown
				! = 1 for MCE
				! = 2 for OS 
				! etc
	INTEGER	OTHFLG		! value to be set in PAKFLG for flushed
				! features when FSHCTR is TRUE
	LOGICAL	FSHCTR		! TRUE  when OTHFLG to be used in FLUSH
				! FALSE otherwise
	LOGICAL	CHASEL		! true if selections have been changed
	LOGICAL	ROLING		! cursor is constrained
	LOGICAL	POSCMD		! .TRUE. when last command was a
				! positioning command (FIND, VERTEX
				! etc)
	LOGICAL	SETING		! setup raster registration
	LOGICAL	FINDNG		! finding (set in FINREC - used in SCNSEC)
	LOGICAL	PNTING		! doing IMAGE PAINT
	INTEGER*4 RAN_SEED	! seed value for random number generator
	INTEGER	PRIV_ATTR_LIST	! list of attributes that may not be altered
	INTEGER	PRIV_PT_LIST	! list of attibutes of privileged points
	REAL	FAR_MOVE_MM	! tolerance for FAR_MOVE (mm)
	REAL	FAR_MOVE_IFF	! tolerance for FAR_MOVE (iff units)
	REAL	FORCE_COEFFS(4)	! defining plane
	REAL	FORCE_HEIGHT	! height of original point
	LOGICAL	FORCE_C_SETUP	! OK to use plane?
	LOGICAL	FORCE_H_SETUP	! OK to use height?
	INTEGER		ASK_INT_TOT
	PARAMETER	(ASK_INT_TOT = 3)
	INTEGER		ASK_REAL_TOT
	PARAMETER	(ASK_REAL_TOT = 3)
	INTEGER		ASK_CHAR_TOT
	PARAMETER	(ASK_CHAR_TOT = 2)
	INTEGER		ASK_INT(ASK_INT_TOT)	! value for system variable $ASK_INT
	INTEGER		ASK_CHAR(2,ASK_CHAR_TOT)! value for system variable $ASK_CHAR
						! (dynamic descriptor)
	REAL		ASK_REAL(ASK_REAL_TOT)
	INTEGER		ASK_INT_NUM
	INTEGER		ASK_REAL_NUM
	INTEGER		ASK_CHAR_NUM
	COMMON /MASTER/ ABS_LIMITS,LINWDTH,
     &			CSXY,XSECTW,YSECTW,XOFF,YOFF,LIMITS,
     &			XRANGE,YRANGE,TOPSEC,NDMODE,WINXY,SCSTXY,
     &			CUST,OTHFLG,LASBUT,RAN_SEED,PRIV_ATTR_LIST,
     &	                PRIV_PT_LIST,FORCE_COEFFS,FORCE_HEIGHT,
     &			FAR_MOVE_MM,FAR_MOVE_IFF,
     &	                ASK_INT,ASK_CHAR,ASK_REAL,
     &			ASK_INT_NUM,ASK_CHAR_NUM,ASK_REAL_NUM,
     &			FSHCTR,CHASEL,ROLING,POSCMD,SETING,
     &	                FORCE_C_SETUP,FORCE_H_SETUP,
     &			FINDNG,HAD_RANGE_CMD,
     &			WINREG,PNTING,
     &			SCSARC,SCSAUX
	REAL		OCSXY(2)	! old cursor position
	REAL		RUBARR(2,2)	! rubber band positions
	INTEGER		RFFULL	! (preset) number to refresh
	INTEGER		RFOFF	! (preset) target within RFFULL
	INTEGER		RFCRIT	! (preset) distance of cursor to end
	INTEGER*4	RFFSEG	! segment number of refreshed found item
	INTEGER		RFFVO	! vertex offset of refreshed found item
	INTEGER		RFFOFF	! vertex offset of actual refresh bit
	INTEGER		RFFTOP	! number of refreshed vertices
	INTEGER*4	RFFCTX	! address of CTX that has cursor on it
	INTEGER*4	RFHSEG	! refreshed object in hand segment
	INTEGER		RFHOFF	! vertex offset of actual refresh bit
	INTEGER		RFHTOP	! number of refreshed vertices
	INTEGER		RFCIND	! refreshed construction index
	LOGICAL		CURS	! true if cursor required
	LOGICAL		INTCUR	! true if cursor position initialised
	LOGICAL		RFCURS	! true if cursor presently drawn
	LOGICAL		RFFLIM	! refreshed found item is in limbo
	LOGICAL		REFNG	! true while executing RFDRAW
	LOGICAL*1	RUBLIN(2)	! want rubber bands?
	LOGICAL		RUBCHG	! rubber bands changed?
	LOGICAL		RFMOD	! have a 'modification' in refresh
	LOGICAL		RFRUB	! have rubber band in refresh
	LOGICAL		RFBIG	! got big cursor
	LOGICAL		RFBNK	! got blinking cursor
	LOGICAL		RFCSEG	! true if cursor segment exists
	LOGICAL		RFLSEG	! true if F/L segment exits
	LOGICAL		RFHSEP	! true separate segment for IH
	LOGICAL		RFFSEP	! true separate segment for FO
	INTEGER		RFCTYP	! cursor type
	REAL		RFCARG(2) ! additional cursor arguments
	INTEGER		RFCOL	! bit mask (colour)
	COMMON/RFCTRL/OCSXY,RUBARR,
     &	        RFFULL,RFOFF,RFCRIT,
     &		RFFSEG,RFFVO,RFFOFF,RFFTOP,
     &		RFHSEG,RFHOFF,RFHTOP,RFCIND,RFFCTX,
     &		CURS,INTCUR,RFCURS,RFFLIM,REFNG,
     &		RUBCHG,RFMOD,RFRUB,RFBIG,RFBNK,RFCSEG,RFLSEG,
     &		RFHSEP,RFFSEP,
     &		RFCTYP,RFCARG,RUBLIN,RFCOL
	CHARACTER*(*)	STDBFM_LOG_NAME
	PARAMETER	(STDBFM_LOG_NAME = 'LSL$FILL_POINTSMAX')
	PARAMETER	DEFAULT_STDBFM = 8192
	INTEGER		STDBFM		! size of buffer
	INTEGER		STDBFP		! buffer pointer
	INTEGER*4	STDBFX_ADDR	! coords X
	INTEGER*4	STDBFY_ADDR	! coords Y
	INTEGER*4	STDBFZ_ADDR	! coords Z
	INTEGER		STDBFC_ZONE
	INTEGER		DTI_BMAX
	INTEGER		DTI_WMAX
	INTEGER		DTI_LMAX
	INTEGER*4	DTIL_ADDR
	INTEGER*4	DTIW_ADDR
	INTEGER*4	DTIB_ADDR
	COMMON/STDBFC/STDBFM,DTI_BMAX,DTI_WMAX,DTI_LMAX,STDBFP,
     &	              STDBFC_ZONE,
     &	              STDBFX_ADDR,STDBFY_ADDR,STDBFZ_ADDR,
     &	              DTIB_ADDR,DTIW_ADDR,DTIL_ADDR
	INTEGER	OBJDEP,FOFULL,FOVOFF,FOCRIT,IHFULL,RIFULL
	PARAMETER	(OBJDEP=4)	! max number of struck objects
	PARAMETER	(FOFULL=1000)	! size of FOXY
	PARAMETER	(FOVOFF=FOFULL/2)	! centre of FOXY
	PARAMETER	(FOCRIT=10)	! minimum distance from ends
	PARAMETER	(IHFULL=1000)	! size of IHXY
	PARAMETER 	(RIFULL=200)	! size of RIXY
	INTEGER		STR_MAX_ATTR	! maximum size of CB arrays
	PARAMETER	(STR_MAX_ATTR = IFF_MAXCBCOL-2)
	INTEGER HITITC,HITITE,HITITP,WORST,BEST
	INTEGER QUORD(OBJDEP)
	INTEGER*4	OBJPAK( PAKLEN, OBJDEP )
	REAL		OBJAUX(AUXLEN,OBJDEP)	! auxiliary array
	INTEGER		OBJPTR(OBJDEP)		! lengths of texts
	CHARACTER*255	OBJTXT(OBJDEP)		! texts themselves
	REAL 		HITRAD(OBJDEP)		! squares of hit radii
	REAL 		OBJCXY(3,OBJDEP)	! cursor positions
	LOGICAL 	OBJNVT(OBJDEP)		! true if on vertex
	LOGICAL		OBJSTRT(OBJDEP)		! true if at start of arc
	LOGICAL		OBJEND(OBJDEP)		! true if at end of arc
	INTEGER*4	FOPAK(PAKLEN)
	REAL		FOAUX(AUXLEN)
	INTEGER		FOPTR		! length of text
	CHARACTER*255	FOTXT		! text itself
	REAL		FOCXY(3)	! cursor position
	INTEGER		FOCZI		! (as an integer)
	EQUIVALENCE	(FOCZI,FOCXY(3))
	REAL 		FOXY(2,FOFULL)	! some coordinates
	REAL		FOZ(FOFULL)
	INTEGER		FOZI(FOFULL)
	EQUIVALENCE	(FOZ,FOZI)
	INTEGER		FONATT		! number of attributes
	INTEGER		FOATTC(STR_MAX_ATTR)	! attribute codes
	INTEGER		FOATTV(STR_MAX_ATTR,FOFULL)! attribute values
	BYTE		FOFLG(FOFULL)	! flags
	INTEGER		FO_Z_COL	! z column index
	INTEGER*4	FOTC		! TC address (or 0)
	INTEGER*4	FOTCND		! end of TCs
	INTEGER*4	FOAC		! AC address (or 0)
	INTEGER*4	FOACND		! end of ACs
	INTEGER*4	FOEF		! EF address
	INTEGER		FOVO		! vertex offset of FOXY
	INTEGER		FOTOP		! last used index of FOXY
	INTEGER 	FOTH		! thickness
	INTEGER*2	FOFS(4)		! FS entry
	INTEGER		FOLST		! last vertex number
	INTEGER		FOVRT		! current vertex
	INTEGER		FOFC		! feature code of FO
	REAL		FOTHIS(3)	! coordinates of first vertex
	REAL		FOTHAT(3)	! coordinates of last vertex
	LOGICAL 	FONVRT		! true if on vertex
	LOGICAL		FOSTRT		! true when on start of arc
	LOGICAL		FOEND		! true when on end of arc
	LOGICAL 	FONLIN		! true if cursor on line
	LOGICAL 	FO		! true if we have a found object
	REAL		FOARCBX(4)	! limiting box for arc
	REAL		FOCOEFFS(4)	! plane of circle arcs
	LOGICAL		FOC_DEFINED	! set up
	REAL		FMCXY(3)	! cursor position
	INTEGER		FMCZI		! (as an integer)
	EQUIVALENCE	(FMCZI,FMCXY(3))
	INTEGER		FMVRT		! marked vertex
	LOGICAL 	FMNVRT		! true if on vertex
	LOGICAL		FMSTRT		! true if on start of arc
	LOGICAL		FMEND		! true if on end of arc
	INTEGER*4	IHPAK( PAKLEN )	! a data pack
	REAL		IHAUX( AUXLEN )	! auxiliary array
	INTEGER		IHPTR		! length of text
	CHARACTER*255	IHTXT		! text itself
	REAL		IHCXY(3)	! cursor position
	INTEGER		IHCZI		! and Z as an integer
	EQUIVALENCE	(IHCXY(3),IHCZI)
	REAL		IHXY(2,IHFULL)	! coordinates
	BYTE		IHFLG(IHFULL)	! flags
	REAL		IHZ(IHFULL)	! array of Z values for clipping
	INTEGER		IHZI(IHFULL)	! integer equivalent
	EQUIVALENCE	(IHZ,IHZI)
	INTEGER*4	IHTC		! TC address (or 0)
	INTEGER*4	IHAC		! AC address (or 0)
	INTEGER*4	IHEF		! EF address
	INTEGER		IHVO		! vertex offset of IHXY
	INTEGER		IHTOP		! last used index of IHXY
	INTEGER 	IHTH		! TH value
	INTEGER*2	IHFS(4)		! FS entry
	INTEGER		IHLST		! last vertex number
	INTEGER		IHVRT		! current vertex
	INTEGER		IHFC		! feature code
	LOGICAL 	IHNVRT		! true if on vertex
	LOGICAL		IHSTRT		! true when on start of arc
	LOGICAL		IHEND		! true when on end of arc
	LOGICAL 	IH		! true if object in hand
	REAL		IHCOEFFS(4)	! plane of circle arcs
	LOGICAL		IHC_DEFINED	! set up
	REAL		IMCXY(3)	! cursor position
	INTEGER		IMCZI		! and Z as an integer
	EQUIVALENCE	(IMCXY(3),IMCZI)
	INTEGER		IMVRT		! marked vertex
	LOGICAL	 	IMNVRT		! true if on vertex
	LOGICAL		IMSTRT		! true if on start of arc
	LOGICAL		IMEND		! true if on end of arc
	REAL		RIXY(2,RIFULL+1)! coordinates
	INTEGER		RINATT		! number of attributes
	INTEGER		RIATTC(STR_MAX_ATTR+1)	! attribute codes
	INTEGER		RIATTV(STR_MAX_ATTR+1,RIFULL+1)! attribute values
	BYTE		RIFLG(RIFULL+1)	! flags
	REAL		RIZ(RIFULL+1)	! array of Z values for FIND
	INTEGER		RIZI(RIFULL+1)	! integer equivalent
	EQUIVALENCE	(RIZ,RIZI)
	INTEGER		RI_Z_COL	! z column number
	INTEGER		RIMAP		! current read-in map
	INTEGER		RIPNF		! and NF pointer
	INTEGER		RIVO		! vertex offset
	INTEGER		RITOP		! last used index
	REAL CONTXY(2)
	REAL 		DSCRIT
	REAL 		DFCRIT
	REAL 		EFCRIT
	REAL 		CRITR2
	INTEGER		FNDSEC
	INTEGER 	NFRSTN
	INTEGER		MPRSTN
	INTEGER		FTXPTR
	CHARACTER*255	FTXCHR
	LOGICAL		SEADEL
	INTEGER*4	LASPAK,SEAPAK
	INTEGER		FNDMDE
	LOGICAL 	NSCND,NVRTX
	INTEGER		ITVRT
	LOGICAL 	CSSTIL
	LOGICAL 	SPIRAL
	LOGICAL 	INSPIR
	LOGICAL 	RECVRD
	LOGICAL 	MATFC
	LOGICAL 	MATFSN
	LOGICAL 	MATLAY
	LOGICAL 	MATMAP
	LOGICAL 	MATPC
	LOGICAL		MATAC
	LOGICAL 	JOINNG
	LOGICAL 	MENDNG
	LOGICAL 	FINDND
	LOGICAL 	JOIFST
	LOGICAL		SRCHNG
	LOGICAL		SEANEA
	COMMON/STRIKE/HITITC,HITITE,HITITP,WORST,QUORD,OBJPAK,OBJAUX,
     &		OBJPTR,HITRAD,OBJCXY,
     &		FOPAK,FOAUX,FOARCBX,FOPTR,FOCXY,FOTC,FOTCND,FOAC,
     &		FOACND,FOEF,FOXY,FOVO,FO_Z_COL,
     &	        FOCOEFFS,FOZ,
     &		FONATT,FOATTC,FOATTV,
     &	        FOTOP,FOTH,FOTHIS,FOTHAT,
     &		FOLST,FOVRT,FMCXY,FMVRT,
     &	        IHPAK,IHAUX,IHPTR,IHCXY,IHCOEFFS,IHZ,IHTC,IHAC,IHEF,
     &		IHXY,IHVO,IHTOP,IHTH,IHLST,IHVRT,IMCXY,IMVRT,FOFC,IHFC,
     &	        RIXY,RIZ,RINATT,RIATTC,RIATTV,RIMAP,RIPNF,RIVO,RITOP,
     &	        RI_Z_COL,
     &		CONTXY,DSCRIT,DFCRIT,EFCRIT,CRITR2,FNDSEC,NFRSTN,FTXPTR,
     &		ITVRT,LASPAK,SEAPAK,FNDMDE,
     &		FOFS,IHFS,
     &		FOC_DEFINED,IHC_DEFINED,
     &		OBJNVT,FOFLG,FONVRT,FO,FMNVRT,IHFLG,IHNVRT,IH,IMNVRT,
     &		RIFLG,NSCND,NVRTX,CSSTIL,SPIRAL,INSPIR,RECVRD,FONLIN,
     &		MATFC,MATFSN,MATLAY,MATMAP,MATPC,MATAC,
     &		JOINNG,FINDND,JOIFST,SRCHNG,SEADEL,MENDNG,
     &		OBJSTRT,OBJEND,FOSTRT,FOEND,IHSTRT,IHEND,
     &		FMSTRT,FMEND,IMSTRT,IMEND,SEANEA,
     &		BEST,MPRSTN
	COMMON/STRCHR/OBJTXT,FOTXT,IHTXT,FTXCHR
	LOGICAL*1	CHFSN
	INTEGER		NEWFSN
	LOGICAL*1	CHFC
	INTEGER		NEWFC
	INTEGER		NEWGT
	LOGICAL*1	CHPC
	INTEGER		NEWPC
	LOGICAL*1	CHMAP
	INTEGER		NEWMAP
	LOGICAL*1	CHLAY
	INTEGER		NEWLAY
	LOGICAL*1	CHPOS
	REAL		CHCSXY(3)
	INTEGER		CHCZI
	EQUIVALENCE	(CHCZI,CHCSXY(3))
	LOGICAL*1	CHOFF
	REAL		OFFDIS
	LOGICAL*1	CHREV			! reverse
	LOGICAL*1	LIMBO			! put into limbo
	LOGICAL*1	RECOVR			! recover from limbo
	LOGICAL*1	CHCOPY			! change copy of object
	LOGICAL*1	REFLSH			! needs re-flushing
	LOGICAL*1	CLREDT			! clear edit flag
	LOGICAL*1	SETEDT			! set edit flag
	LOGICAL*1	CHTRAN			! transform
	LOGICAL*1	CHFILT			! filter
	COMMON/VARIAT/
     &		NEWFSN,NEWFC,NEWGT,NEWPC,NEWMAP,NEWLAY,CHCSXY,OFFDIS,
     &		CHFSN,CHFC,CHPC,CHMAP,CHLAY,CHPOS,CHOFF,CHREV,LIMBO,
     &		RECOVR,CHCOPY,REFLSH,CLREDT,SETEDT,CHTRAN,CHFILT
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER	LENGTH
	REAL	STDBFX(LENGTH)
	REAL	STDBFY(LENGTH)
	REAL	DX,DY		! amount to shift by
	REAL	X,Y		! new coordinate
	INTEGER	I
	DX = CSXY(1) - CHCSXY(1)
	DY = CSXY(2) - CHCSXY(2)
	CALL STDBFF(0)				! clear buffer
	DO 20 I=1,MIN(RFHTOP,LENGTH)
	   STDBFP = STDBFP+1
	   STDBFX(STDBFP) = IHXY(1,RFHOFF-IHVO+I)+DX
	   STDBFY(STDBFP) = IHXY(2,RFHOFF-IHVO+I)+DY
20	CONTINUE
	IF (WKAC(1).AND.(WTYPES(1).NE.4014)) THEN
	   CALL MOVTOC
	   CALL GW2D(1,STDBFX(1)-CSXY(1),STDBFY(1)-CSXY(2),X,Y)
	   CALL MOVBY(X,Y)
	   DO 30 I=2,STDBFP
	     CALL GW2D(1,STDBFX(I)-STDBFX(I-1),STDBFY(I)-STDBFY(I-1),X,Y)
	     CALL LINBY(X,Y)
30	   CONTINUE
	ENDIF
	IF (WKAC(2)) THEN
	   IF (WKAC(1)) CALL GDAWK(1)
	   CALL STDBFF(2)		! flush them out
	   IF (WKOP(1)) CALL GACWK(1)
	ENDIF
	RETURN
	END
	SUBROUTINE LCLSG
	IMPLICIT NONE
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		SEGFUL
	PARAMETER	(SEGFUL=32767)	! max number of segments
	INTEGER		SEGLST		! last one used
	INTEGER		SEGCUR		! current open segment, or 0
	LOGICAL*1	SEGVIS		! visibility of current segment
	COMMON/SEGMNT/SEGLST,SEGCUR,SEGVIS
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	IF (NODISP) GOTO 999
	IF (WKOP(1)) THEN		! open
	   IF (WKACT(1)) THEN		! temporarily active
	      IF (SCBOPT.AND..NOT.SEGVIS) CALL SCRUB(0.0,0.0)
	   ELSE				! inactive
	      CALL GACWK(1)		! activate it
	      WKAC(1) = .TRUE.		! now active
	   ENDIF
	ENDIF
	IF (.NOT.WKACT(2)) THEN		! temporarily inactive
	   CALL GACWK(2)		! activate it
	ENDIF
	SEGCUR = 0			! no open segment
999	RETURN
	END

	SUBROUTINE LCRSG(PACK)
	IMPLICIT NONE
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
	INTEGER		SEGFUL
	PARAMETER	(SEGFUL=32767)	! max number of segments
	INTEGER		SEGLST		! last one used
	INTEGER		SEGCUR		! current open segment, or 0
	LOGICAL*1	SEGVIS		! visibility of current segment
	COMMON/SEGMNT/SEGLST,SEGCUR,SEGVIS
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER*4 PACK(PAKLEN)		! pack containing segment name
	IF (NODISP) GOTO 999
	SEGCUR = PACK(PAKSEG)		! current open segment
	SEGVIS = .TRUE.			! visible
	WKACT(1) = .TRUE.		! temporarily active
	WKACT(2) = .TRUE.		! (see LSVIS, LCLSG)
999	RETURN
	END

	SUBROUTINE LDSG(PACK,VISI)
	IMPLICIT NONE
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
	INTEGER		SEGFUL
	PARAMETER	(SEGFUL=32767)	! max number of segments
	INTEGER		SEGLST		! last one used
	INTEGER		SEGCUR		! current open segment, or 0
	LOGICAL*1	SEGVIS		! visibility of current segment
	COMMON/SEGMNT/SEGLST,SEGCUR,SEGVIS
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER*4	PACK(PAKLEN)
	LOGICAL*1	VISI		! true if visible
	IF (NODISP) GOTO 999
	IF (.NOT.VISI) GOTO 999
	IF (.NOT.WKAC(2)) GOTO 999
	WKACT(1) = .TRUE.
	IF (WKAC(1)) THEN
	   CALL GDAWK(1)
	   WKACT(1) = .FALSE.
	ENDIF
	OVCOL = 0			! overriding colour
	CALL DRAFTR(PACK)		! re-draw
	OVCOL = -1			! unset overriding colour
	IF (.NOT.WKACT(1)) THEN
	   CALL GACWK(1)
	ENDIF
999	RETURN
	END
	SUBROUTINE LSVIS(PACK,IVIS)
	IMPLICIT NONE
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP
	INTEGER	GHOLOW,GSOLID,GPATRN,GHATCH
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
	PARAMETER (GHOLOW = 0, GSOLID = 1, GPATRN = 2, GHATCH = 3)
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		SEGFUL
	PARAMETER	(SEGFUL=32767)	! max number of segments
	INTEGER		SEGLST		! last one used
	INTEGER		SEGCUR		! current open segment, or 0
	LOGICAL*1	SEGVIS		! visibility of current segment
	COMMON/SEGMNT/SEGLST,SEGCUR,SEGVIS
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER*4	PACK(PAKLEN)
	INTEGER		IVIS
	IF (NODISP) GOTO 999
	IF (SEGCUR.NE.0) THEN	! yes
	   IF (IVIS.EQ.GVISI) GOTO 999		! visible - do nothing
	   SEGVIS = .FALSE.
	   IF (WKAC(1).AND.SCBOPT) THEN
	      CALL DISMOD(0)	! turn off refresh to make SCRUB work
	      CALL SCRUB(EFSCMP,EFSCPL)
	   ENDIF
	   IF (WKAC(2)) THEN
	      CALL GDAWK(2)
	      WKACT(2) = .FALSE.		! temporarily inactive
	   ENDIF
	ELSE
	   IF (IVIS.EQ.GVISI) THEN		! visible
	      CALL DRAFTR(PACK)
	   ELSE					! invisible
	      WKACT(1) = .TRUE.
	      IF (WKAC(1)) THEN
	         IF (SCBOPT) THEN
	            CALL DISMOD(0) ! turn off refresh to make scrub work
	            CALL SCRUB(EFSCMP,EFSCPL)
	         ELSE
	            IF (.NOT.WKAC(2)) GOTO 999
	            CALL GDAWK(1)
	            WKACT(1) = .FALSE.
	         ENDIF
	      ENDIF
	      OVCOL = 0			! set overriding colour
	      CALL DRAFTR(PACK)		! redraw
	      OVCOL = -1		! unset overriding colour
	      IF (WKACT(1)) THEN
	         IF (SCBOPT) CALL SCRUB(0.0,0.0)
	      ELSE
	         CALL GACWK(1)
	      ENDIF
	   ENDIF
	ENDIF
999	RETURN
	END

	LOGICAL FUNCTION SCRINIT(ON)
	IMPLICIT NONE
	LOGICAL	ON			! turn on or off?
	SCRINIT = .FALSE.		! assume off
	RETURN
	END
	LOGICAL FUNCTION BUTINIT(ON)
	IMPLICIT NONE
	LOGICAL	ON			! turn on or off?
	BUTINIT = .FALSE.		! assume off
	RETURN
	END

	SUBROUTINE LUWK(WKID,REGFL)
	INTEGER	WKID			! workstation-identifier
	INTEGER	REGFL			! regeneration flag
	CALL GUWK(WKID,REGFL)
	RETURN
	END
	LOGICAL FUNCTION DSRINIT(ON)
	IMPLICIT NONE
	LOGICAL*1	ON		! turn on? or off
	DSRINIT = .FALSE.
	RETURN
	END

	LOGICAL FUNCTION KRSINIT(ON)
	IMPLICIT NONE
	LOGICAL*1	ON		! turn on? or off
	KRSINIT = .FALSE.
	RETURN
	END
	SUBROUTINE FOLLOW_COORD(WHERE,XYZ,TWOD)
	IMPLICIT NONE
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	INTEGER		FOLLOW_TABLE
	PARAMETER	(FOLLOW_TABLE = 1)
	INTEGER		FOLLOW_SCREEN
	PARAMETER	(FOLLOW_SCREEN = 2)
	INTEGER		FOLLOW_DSR
	PARAMETER	(FOLLOW_DSR = 3)
	REAL		FOLLOW_TIME	! time interval to read table
	REAL		FOLLOW_HIFFDIST
	REAL		FOLLOW_SIFFDIST
	REAL		FOLLOW_EIFFDIST
	REAL		FOLLOW_HMMDIST
	REAL		FOLLOW_SMMDIST
	REAL		FOLLOW_EMMDIST
	INTEGER		FOLLOW_WHERE	! device to digitise from
	LOGICAL		FOLLOW_JUST_STARTED
	REAL 		FOLLOWMIN,FOLLOWLAT,FOLLOWTIM
	PARAMETER 	(FOLLOWMIN = 0.5)
	PARAMETER 	(FOLLOWLAT = 0.1)
	PARAMETER	(FOLLOWTIM = 0.25)
	INTEGER		FOLLOW_BUF_SIZ
	PARAMETER	(FOLLOW_BUF_SIZ = 20)
	INTEGER		FOLLOW_BUF_PTR
	REAL		FOLLOW_BUF(3,FOLLOW_BUF_SIZ)
	REAL		FOLLOW_EL_TIME
	INTEGER		FOLLOW_EVENTS
	INTEGER		FOLLOW_E,FOLLOW_H,FOLLOW_S,FOLLOW_O
	COMMON	/FOLLOW/FOLLOW_BUF,FOLLOW_TIME,FOLLOW_HIFFDIST,
     &	                FOLLOW_SIFFDIST,FOLLOW_EIFFDIST,
     &	                FOLLOW_HMMDIST,FOLLOW_SMMDIST,
     &	                FOLLOW_EMMDIST,FOLLOW_WHERE,
     &	                FOLLOW_EL_TIME,FOLLOW_EVENTS,
     &	                FOLLOW_BUF_PTR,
     &	                FOLLOW_E,FOLLOW_H,FOLLOW_S,FOLLOW_O,
     &	                FOLLOW_JUST_STARTED
	INTEGER		WHERE		! device to get coords from
	REAL		XYZ(3)		! returned corrdinates
	LOGICAL		TWOD		! .TRUE. if 2d coord returned
	EXTERNAL	MOAN
	IF (WHERE.EQ.FOLLOW_TABLE) THEN
	   CALL ASKTABLE(XYZ)
	   TWOD = .TRUE.
	ELSE
	   CALL MSGCMD(MOAN,MSG_CMDNOTWITHHW)
	ENDIF
	RETURN
	END

	SUBROUTINE NOT_SUPPORTED
	IMPLICIT NONE
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	EXTERNAL	MOAN
	ENTRY	VIEW
	ENTRY	PICT
	ENTRY	PLOT
	CALL MSGCMD(MOAN,MSG_CMDNOTWITHHW)
	RETURN
	END
	SUBROUTINE LSALLV
	RETURN
	END

	SUBROUTINE LSALLI
	RETURN
	END
	SUBROUTINE LRSGWK(WKID)
	INTEGER	WKID
	RETURN
	END

	SUBROUTINE CLSWK(NUMBER)
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER*4	TABPUK	! for table monitor puck
	INTEGER*4	TABSTR	! for table monitor streaming mode
	INTEGER*4	TABERR	! for table monitor error
	INTEGER*4	TABFLG	! for wosplib table/bitpad
	INTEGER*4	TTIFLG	! for terminal input
	INTEGER*4	CLCFLG	! for control C event flag
	INTEGER*4	TBFLG	! for trackerball event flag
	INTEGER*4	FBFLG	! for trackerball button event flag
	INTEGER*4	TMOFLG	! for TEK timeout timer
	INTEGER*4	CSRFLG	! for TEK cursor timeout timer
	INTEGER*4	DTBFLG	! for direct table reading
	INTEGER*4	BUTFLG	! for reading function buttons
	INTEGER*4	AUXFLG	! for reading auxiliary inputs
	INTEGER*4	FOLFLG	! for streaming timer
	COMMON	/VAREFN/TABPUK,TABSTR,TABERR,TABFLG,TTIFLG,
     &			CLCFLG,TBFLG,FBFLG,TMOFLG,CSRFLG,DTBFLG,
     &	                BUTFLG,AUXFLG,FOLFLG
	INTEGER		NUMBER		! (in) workstation (1 or 2)
	IF (NUMBER.EQ.1) THEN		! TEK workstation
	   WOSPIN = .FALSE.		! not now using WOSPLIB input
	   TTINIT = .TRUE.		! needs initialising
	   TTREAD = .FALSE.		! need new read
	   CALL SYS$CANTIM(%VAL(TMOFLG),)	! one minute
	   CALL SYS$CANTIM(%VAL(CSRFLG),)	! 0.25 sec cursor
	   TIMOUT = .FALSE.
	   TMOTED = .FALSE.
	   CSRTMO = .FALSE.
	ENDIF
	RETURN
	END
	SUBROUTINE STDINI
	REAL		OCSXY(2)	! old cursor position
	REAL		RUBARR(2,2)	! rubber band positions
	INTEGER		RFFULL	! (preset) number to refresh
	INTEGER		RFOFF	! (preset) target within RFFULL
	INTEGER		RFCRIT	! (preset) distance of cursor to end
	INTEGER*4	RFFSEG	! segment number of refreshed found item
	INTEGER		RFFVO	! vertex offset of refreshed found item
	INTEGER		RFFOFF	! vertex offset of actual refresh bit
	INTEGER		RFFTOP	! number of refreshed vertices
	INTEGER*4	RFFCTX	! address of CTX that has cursor on it
	INTEGER*4	RFHSEG	! refreshed object in hand segment
	INTEGER		RFHOFF	! vertex offset of actual refresh bit
	INTEGER		RFHTOP	! number of refreshed vertices
	INTEGER		RFCIND	! refreshed construction index
	LOGICAL		CURS	! true if cursor required
	LOGICAL		INTCUR	! true if cursor position initialised
	LOGICAL		RFCURS	! true if cursor presently drawn
	LOGICAL		RFFLIM	! refreshed found item is in limbo
	LOGICAL		REFNG	! true while executing RFDRAW
	LOGICAL*1	RUBLIN(2)	! want rubber bands?
	LOGICAL		RUBCHG	! rubber bands changed?
	LOGICAL		RFMOD	! have a 'modification' in refresh
	LOGICAL		RFRUB	! have rubber band in refresh
	LOGICAL		RFBIG	! got big cursor
	LOGICAL		RFBNK	! got blinking cursor
	LOGICAL		RFCSEG	! true if cursor segment exists
	LOGICAL		RFLSEG	! true if F/L segment exits
	LOGICAL		RFHSEP	! true separate segment for IH
	LOGICAL		RFFSEP	! true separate segment for FO
	INTEGER		RFCTYP	! cursor type
	REAL		RFCARG(2) ! additional cursor arguments
	INTEGER		RFCOL	! bit mask (colour)
	COMMON/RFCTRL/OCSXY,RUBARR,
     &	        RFFULL,RFOFF,RFCRIT,
     &		RFFSEG,RFFVO,RFFOFF,RFFTOP,
     &		RFHSEG,RFHOFF,RFHTOP,RFCIND,RFFCTX,
     &		CURS,INTCUR,RFCURS,RFFLIM,REFNG,
     &		RUBCHG,RFMOD,RFRUB,RFBIG,RFBNK,RFCSEG,RFLSEG,
     &		RFHSEP,RFFSEP,
     &		RFCTYP,RFCARG,RUBLIN,RFCOL
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	IF (WKAC(1)) THEN
	   CALL DISMOD(0)
	   RFCURS = .FALSE.		! refresh picture taken down
	ENDIF
	RETURN
	END

	SUBROUTINE HARCOP
	IMPLICIT NONE
	INTEGER*4	LCMD_NO		! maximum command files allowed
	PARAMETER	(LCMD_NO = 10)
	INTEGER*4	FF_NO		! maximum FILE files allowed	
	PARAMETER	(FF_NO = 3)
	INTEGER*4	LMIN		! minimum for command file input
	PARAMETER	(LMIN = 1)
	INTEGER*4	LMAX		! maximum for command file input
	PARAMETER	(LMAX = LMIN + LCMD_NO -1)
	INTEGER*4	JOULUN		! for journalling
	PARAMETER	(JOULUN = LMAX + 1)
	INTEGER*4	PRTLUN		! for printing sector list
	PARAMETER	(PRTLUN = JOULUN + 1)
	INTEGER*4	EDGLUN		! for writing edgematching file
	PARAMETER	(EDGLUN = PRTLUN)	! NOTE: SAME AS ABOVE !!!!!
	INTEGER*4	FFMIN		! minimum for FILE files
	PARAMETER	(FFMIN = EDGLUN + 1)
	INTEGER*4	FFMAX		! maximum for FILE files
	PARAMETER	(FFMAX = FFMIN + FF_NO - 1)
	INTEGER	INLUN,OUTLUN	! for initial read-in of IFF files
	PARAMETER (INLUN=2,OUTLUN=1)
	INTEGER	TABEFN		! EFN for WOSPLIB table input
	PARAMETER (TABEFN=4)	! (make 4 for compatability with old IFFSHR
	INTEGER TTIEFN		! EFN for terminal input
	PARAMETER (TTIEFN=TABEFN+1)
	INTEGER TTOEFN		! EFN for terminal output
	PARAMETER (TTOEFN=TTIEFN+1)
	INTEGER WTEFN		! EFN for WAIT command
	PARAMETER (WTEFN=TTOEFN+1)
	INTEGER TBEFN		! EFN for trackerball
	PARAMETER (TBEFN=WTEFN+1)
	INTEGER FBEFN		! EFN for trackerball function buttons
	PARAMETER (FBEFN=TBEFN+1)
	INTEGER TMOEFN		! EFN for TEK timeout
	PARAMETER (TMOEFN=FBEFN+1)
	INTEGER CSREFN		! EFN for TEK cursor timeout
	PARAMETER (CSREFN=TMOEFN+1)
	INTEGER DTBEFN		! EFN for direct table read
	PARAMETER (DTBEFN=CSREFN+1)
	INTEGER BUTEFN		! EFN for function buttons
	PARAMETER (BUTEFN=DTBEFN+1)
	INTEGER AUXEFN		! EFN for auxiliary input lines
	PARAMETER (AUXEFN=BUTEFN+1)
	INTEGER FOLEFN		! EFN for streaming input
	PARAMETER (FOLEFN=AUXEFN+1)
	INTEGER		RANGE_TRANS_CORNER
	INTEGER		RANGE_TRANS_SIDE
	INTEGER		RANGE_TRANS_DATA
	PARAMETER	(RANGE_TRANS_CORNER = 1)
	PARAMETER	(RANGE_TRANS_SIDE   = 2)
	PARAMETER	(RANGE_TRANS_DATA   = 3)
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	INTEGER		INITIAL_MAXMAP	! maximium number of maps in INITIAL
					! state
	PARAMETER	(INITIAL_MAXMAP = 9)
	INTEGER		MAX_SETUP	! maximium number of maps that can
					! be setup
	PARAMETER	(MAX_SETUP = INITIAL_MAXMAP)
	INTEGER		MAXMAP
	PARAMETER	(MAXMAP=100)	! maximum number of maps
	INTEGER		MAXLUN		! number of IFFLIB LUNs
	PARAMETER	(MAXLUN=MAXMAP)
	INTEGER		CPMAXX,CPMAXY	! maximum number of boxes
	PARAMETER	(CPMAXX=10)	! in x and y direction
	PARAMETER	(CPMAXY=10)	! for OS type setup
	INTEGER		CPFULL		! total number of boxes
	PARAMETER	(CPFULL=CPMAXX*CPMAXY)
	INTEGER		MAXREP		! maximum number times to
	PARAMETER	(MAXREP=4)	! repeat observations for
					! OS type setup
	INTEGER		MAX_EDGE_POINT	! max number of points/line
	INTEGER		MAX_EDGE_SET	! max number of sets
	PARAMETER	(MAX_EDGE_POINT = 10,MAX_EDGE_SET = 5)
	INTEGER		MHLENGTH
	PARAMETER	(MHLENGTH=2502)	! length of map header
					! should be maximum of length
					! in LSL$CMNIFF:MHDEF and MHOSGB
	INTEGER		OS_MH_FLAGS
	PARAMETER	(OS_MH_FLAGS=8)	! number of flags in OS map
					! descriptor
	INTEGER		OS_MH_FL_BMAP_SIZ ! size of bitmap for flags
					  ! (in bytes)
	PARAMETER	(OS_MH_FL_BMAP_SIZ = ((OS_MH_FLAGS-1)/8+1))
	REAL		CRNPTS(4,4,0:MAXMAP-1) ! corner points of maps,
					   ! as read from IFF files
	INTEGER		NOFEAT		! total number of features
	INTEGER		NMAPS		! number we intend to read
	INTEGER		MAPTOP		! number of maps in use
	INTEGER		MAPCUR		! currently selected one
	INTEGER		LUNLST		! top LUN to use for maps
	INTEGER		IFFNAM(2,0:MAXMAP-1)	! original IFF filenames
	INTEGER		MAPNAM(2,0:MAXMAP-1)	! working IFF filenames
	LOGICAL*1	MAP_EXIST(0:MAXMAP-1)	! map in use?
	INTEGER		MAPLUN(0:MAXMAP-1) ! IFF LUN (0 if none)
	INTEGER		MAXNF(0:MAXMAP-1)  ! maximum NF number
	INTEGER		LPOSFT(0:MAXMAP-1) ! IFF address for writing
	INTEGER		LPOSF_SAV(0:MAXMAP-1) ! IFF status of LPOSF
	INTEGER		MAPOVL(0:MAXMAP-1) ! current open layer, or -1
	INTEGER		LPOSNO(0:MAXMAP-1) ! corresponding NO position
	INTEGER		MAPNO(MAXMAP)	! map on LUN n, -1 if none
	INTEGER		SELCNT		! selection counter
	INTEGER		LUNCNT(MAXMAP) ! usage count for LUN
	REAL		RANGE(4,0:MAXMAP-1)	! RA entries
	INTEGER*4	FILEID(7,0:MAXMAP-1) ! file identifications
	INTEGER*4	MAPLCK(0:MAXMAP-1) ! lock id
	LOGICAL*1	MAPRO(0:MAXMAP-1)  ! true if read-only
	LOGICAL*1	MAPINS(0:MAXMAP-1) ! true if edit in-situ
	LOGICAL*1	MAPMAP(0:MAXMAP-1) ! true if memory mapped
	LOGICAL*1	MAPWRK(0:MAXMAP-1) ! valid workspace file?
	LOGICAL*1	MAPSEL(0:MAXMAP-1) ! true if map selected
	LOGICAL*1	MAP_TABLE(0:MAXMAP-1) ! true if map to be set on table
	LOGICAL*1	SAMAPS		! .TRUE. when all maps selected
					! .FALSE. otherwise
	LOGICAL*1	MAPSLCT		! .TRUE. when in MAP select mode
					! .FALSE. otherwise
	INTEGER		MAP_SETUP(MAX_SETUP) ! maps that have been setup
	INTEGER		MAP_SETUP_TOTAL
	LOGICAL		HAD_SETUP_CANCEL
	LOGICAL*1	O_MAPSEL(0:MAXMAP-1,8) ! true if map selected
	LOGICAL*1	O_SAMAPS(8)	! .TRUE. when all maps selected
					! .FALSE. otherwise
	LOGICAL*1	O_MAPSLCT(8)	! .TRUE. when in MAP select mode
					! .FALSE. otherwise
	REAL*8		MAPORG(2,0:MAXMAP-1)
	REAL*8		MAPSCL(0:MAXMAP-1)
	REAL*8		LITES2PAR(15)		! projection parameters
	REAL*8		LITES2SCL
	REAL*8		LITES2ORG(2)
	REAL		ORGXY(2)
	INTEGER		LITES2SYS,LITES2ZONE,LITES2UNIT
	LOGICAL		USE_ORG
	LOGICAL		DO_FLY_TRANS
	LOGICAL		PROJ_TRANS_OUTPUT
	LOGICAL		RANGE_PROBLEM
	REAL*8		MAP_PARAMS(15,0:MAXMAP-1)
	INTEGER		RANGE_TRANS_TYPE
	INTEGER		RANGE_SIDE_POINTS
	LOGICAL*1	MAP_RANGE_OK(0:MAXMAP-1)
	INTEGER		MAP_SYS(0:MAXMAP-1)
	INTEGER		MAP_ZONE(0:MAXMAP-1)
	INTEGER		MAP_UNIT(0:MAXMAP-1)
	REAL*8		CURR_PARAMS(15)
	REAL*8		CURR_ORG(2)
	INTEGER		CURR_SYS
	INTEGER		CURR_ZONE
	INTEGER		CURR_UNIT
	INTEGER*4	MHLEN_FIRST
	INTEGER*4	MHARR_FIRST(MHLENGTH/2)
	BYTE		OS_MH_FL_BMAP(OS_MH_FL_BMAP_SIZ,0:MAXMAP-1)
	INTEGER		OS_MH_GRP(0:OS_MH_FLAGS-1)
	INTEGER*4	OS_MH_CAT_LIST(0:OS_MH_FLAGS-1)
	CHARACTER*1	OS_MH_CHAR(0:OS_MH_FLAGS-1)
	LOGICAL		OS_MH_EDIT
	LOGICAL		OS_MH_INITIALISED
	LOGICAL		HAD_NEW_OS_MH
	INTEGER*4	MAP_ORLEV_LEN		! number of words in bit map
	PARAMETER	(MAP_ORLEV_LEN=MAXMAP/32+1)
	INTEGER*4	MAP_ORLEV_B_MAP(MAP_ORLEV_LEN)
	LOGICAL		HAD_EXIT_RANGE
	REAL*8		EXIT_ORGXY(2)
	REAL*8		EXIT_RANGE(4)
	COMMON/MAPS/MAPORG,MAPSCL,LITES2ORG,			! R*8
     &	            LITES2PAR,LITES2SCL,
     &	            CURR_PARAMS,CURR_ORG,
     &	            EXIT_ORGXY,EXIT_RANGE,MAP_PARAMS,
     &	            CRNPTS,RANGE,ORGXY,				! R*4
     &	            NOFEAT,NMAPS,MAPTOP,MAPCUR,LUNLST,		! I*4
     &		    IFFNAM,MAPNAM,
     &		    MAPLUN,MAXNF,LPOSFT,LPOSF_SAV,MAPOVL,LPOSNO,MAPNO,
     &		    SELCNT,LUNCNT,FILEID,MAP_SETUP,MAP_SETUP_TOTAL,
     &	            MAPLCK,MAP_ORLEV_B_MAP,OS_MH_GRP,OS_MH_CAT_LIST,
     &	            MHLEN_FIRST,MHARR_FIRST,MAP_SYS,MAP_ZONE,
     &	            MAP_UNIT,
     &	            LITES2SYS,LITES2ZONE,LITES2UNIT,
     &	            CURR_SYS,CURR_ZONE,CURR_UNIT,
     &	            RANGE_TRANS_TYPE,RANGE_SIDE_POINTS,
     &	            HAD_SETUP_CANCEL,				! L*4
     &	            DO_FLY_TRANS,PROJ_TRANS_OUTPUT,
     &	            RANGE_PROBLEM,USE_ORG,
     &	            OS_MH_EDIT,HAD_EXIT_RANGE,
     &	            OS_MH_INITIALISED,HAD_NEW_OS_MH,
     &		    MAPRO,MAPINS,MAPSEL,			! L*1
     &	            SAMAPS,MAPSLCT,MAPWRK,
     &		    O_MAPSEL,O_SAMAPS,O_MAPSLCT,
     &		    MAPMAP,MAP_TABLE,OS_MH_FL_BMAP,
     &		    MAP_RANGE_OK,OS_MH_CHAR,MAP_EXIST
	REAL		OCSXY(2)	! old cursor position
	REAL		RUBARR(2,2)	! rubber band positions
	INTEGER		RFFULL	! (preset) number to refresh
	INTEGER		RFOFF	! (preset) target within RFFULL
	INTEGER		RFCRIT	! (preset) distance of cursor to end
	INTEGER*4	RFFSEG	! segment number of refreshed found item
	INTEGER		RFFVO	! vertex offset of refreshed found item
	INTEGER		RFFOFF	! vertex offset of actual refresh bit
	INTEGER		RFFTOP	! number of refreshed vertices
	INTEGER*4	RFFCTX	! address of CTX that has cursor on it
	INTEGER*4	RFHSEG	! refreshed object in hand segment
	INTEGER		RFHOFF	! vertex offset of actual refresh bit
	INTEGER		RFHTOP	! number of refreshed vertices
	INTEGER		RFCIND	! refreshed construction index
	LOGICAL		CURS	! true if cursor required
	LOGICAL		INTCUR	! true if cursor position initialised
	LOGICAL		RFCURS	! true if cursor presently drawn
	LOGICAL		RFFLIM	! refreshed found item is in limbo
	LOGICAL		REFNG	! true while executing RFDRAW
	LOGICAL*1	RUBLIN(2)	! want rubber bands?
	LOGICAL		RUBCHG	! rubber bands changed?
	LOGICAL		RFMOD	! have a 'modification' in refresh
	LOGICAL		RFRUB	! have rubber band in refresh
	LOGICAL		RFBIG	! got big cursor
	LOGICAL		RFBNK	! got blinking cursor
	LOGICAL		RFCSEG	! true if cursor segment exists
	LOGICAL		RFLSEG	! true if F/L segment exits
	LOGICAL		RFHSEP	! true separate segment for IH
	LOGICAL		RFFSEP	! true separate segment for FO
	INTEGER		RFCTYP	! cursor type
	REAL		RFCARG(2) ! additional cursor arguments
	INTEGER		RFCOL	! bit mask (colour)
	COMMON/RFCTRL/OCSXY,RUBARR,
     &	        RFFULL,RFOFF,RFCRIT,
     &		RFFSEG,RFFVO,RFFOFF,RFFTOP,
     &		RFHSEG,RFHOFF,RFHTOP,RFCIND,RFFCTX,
     &		CURS,INTCUR,RFCURS,RFFLIM,REFNG,
     &		RUBCHG,RFMOD,RFRUB,RFBIG,RFBNK,RFCSEG,RFLSEG,
     &		RFHSEP,RFFSEP,
     &		RFCTYP,RFCARG,RUBLIN,RFCOL
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	EXTERNAL	MOAN
	INTEGER		I
	IF (.NOT.WKAC(1)) GOTO 990	! Tek not available
	CALL DISMOD(0)			! cancel refresh mode
	DO 310, I=2,WSMAX
	   IF (WKAC(I)) CALL GDAWK(I)
310	CONTINUE
	CALL DRAWX   
	DO 390, I=2,WSMAX
	   IF (WKOP(I)) CALL GACWK(I)
390	CONTINUE
	CALL TKCOPY
	RFCURS = .NOT.CURS		! force refresh re-draw
	GOTO 999
990	CALL MSGCMD(MOAN,MSG_COMONPRI)
	CALL IGNCMD
999	RETURN
	END
	LOGICAL FUNCTION BALINIT(ON)
	IMPLICIT NONE

	LOGICAL FUNCTION LSCR(INDEX,R,G,B)
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER		INDEX		! colour index
	REAL		R,G,B		! red, green, blue
	INTEGER		I
	INTEGER*4	COL
	BYTE		COLB(4)
	EQUIVALENCE	(COL,COLB)
	INTEGER*4	C
	BYTE		CB
	EQUIVALENCE	(C,CB)
	LSCR = .TRUE.			! assume failed
	IF (.NOT.WKOP(2)) GOTO 999	! no ARGS
	IF (INDEX.LT.-2.OR.INDEX.GT.15) GOTO 999
	IF (R.LT.0.0.OR.R.GT.1.0) GOTO 999
	IF (G.LT.0.0.OR.G.GT.1.0) GOTO 999
	IF (B.LT.0.0.OR.B.GT.1.0) GOTO 999
	C = R*255.0
	COLB(1) = CB
	C = G*255.0
	COLB(2) = CB
	C = B*255.0
	COLB(3) = CB
	IF (INDEX.GE.0) THEN		! ordinary colour
	   COLB(4) = 0			! no blink
	   CALL VSSGSC(INDEX,COL)
	   IF (INDEX.NE.0) THEN		! don't alter background refresh
	      COLB(4) = 1		! blink for 'refresh'
	      CALL VSSGSC(INDEX+16,COL)
	   ENDIF
	ELSEIF (INDEX.EQ.-1) THEN
	   COLB(4) = 1			! set 'transient refresh' colour
	   DO 10 I=32,63
	      CALL VSSGSC(I,COL)
10	   CONTINUE
	ELSEIF (INDEX.EQ.-2) THEN	! set 'background refresh' colour
	   COLB(4) = 1
	   CALL VSSGSC(16,COL)
	ENDIF
	LSCR = .FALSE.			! success
999	RETURN
	END
	LOGICAL FUNCTION LSCRS(WKID,N,R,G,B)
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER		WKID		! workstation identifier
	INTEGER		N		! number of colours
	REAL		R(*),G(*),B(*)	! red, green, blue
	INTEGER		NN
	LSCRS = .FALSE.			! assume success
	DO 20 NN=1,N
	   CALL LSCR(NN-1,R(NN),G(NN),B(NN))
20	CONTINUE
	RETURN
	END
	SUBROUTINE	LQCR(WKID,CI,TYPE,ERRIND,RED,GREEN,BLUE)
	IMPLICIT NONE
	INTEGER	WKID			! workstation-identifier
	INTEGER	CI			! colour index
	INTEGER	TYPE			! type of values (unused)
	INTEGER	ERRIND			! error indicator
	REAL	RED,GREEN,BLUE		! colour values
	CALL GQCR(WKID,CI,TYPE,ERRIND,RED,GREEN,BLUE)
	RETURN
	END
	SUBROUTINE INTERACT(CTRLZ)
	IMPLICIT NONE
	INCLUDE 'LSL$CMNIFF:CB.STR'
	PARAMETER AUXLEN = 8	! length of auxiliary array
	PARAMETER XCENI= 1	! x coord of centre
	PARAMETER YCENI= 2	! y coord of centre
	PARAMETER RADI = 3	! radius
	PARAMETER STAI = 4	! start angle
	PARAMETER TOTI = 5	! total angle
	PARAMETER ANGI = 1	! angle
	PARAMETER COSI = 2	! cosine
	PARAMETER SINI = 3	! sine
	PARAMETER SIZI = 4	! size
	PARAMETER MINXI= 5	! minimum x
	PARAMETER MAXXI= 6	! maximum x
	PARAMETER MINYI= 7	! minimum y
	PARAMETER MAXYI= 8	! maximum y
	INTEGER*4	LCMD_NO		! maximum command files allowed
	PARAMETER	(LCMD_NO = 10)
	INTEGER*4	FF_NO		! maximum FILE files allowed	
	PARAMETER	(FF_NO = 3)
	INTEGER*4	LMIN		! minimum for command file input
	PARAMETER	(LMIN = 1)
	INTEGER*4	LMAX		! maximum for command file input
	PARAMETER	(LMAX = LMIN + LCMD_NO -1)
	INTEGER*4	JOULUN		! for journalling
	PARAMETER	(JOULUN = LMAX + 1)
	INTEGER*4	PRTLUN		! for printing sector list
	PARAMETER	(PRTLUN = JOULUN + 1)
	INTEGER*4	EDGLUN		! for writing edgematching file
	PARAMETER	(EDGLUN = PRTLUN)	! NOTE: SAME AS ABOVE !!!!!
	INTEGER*4	FFMIN		! minimum for FILE files
	PARAMETER	(FFMIN = EDGLUN + 1)
	INTEGER*4	FFMAX		! maximum for FILE files
	PARAMETER	(FFMAX = FFMIN + FF_NO - 1)
	INTEGER	INLUN,OUTLUN	! for initial read-in of IFF files
	PARAMETER (INLUN=2,OUTLUN=1)
	INTEGER	TABEFN		! EFN for WOSPLIB table input
	PARAMETER (TABEFN=4)	! (make 4 for compatability with old IFFSHR
	INTEGER TTIEFN		! EFN for terminal input
	PARAMETER (TTIEFN=TABEFN+1)
	INTEGER TTOEFN		! EFN for terminal output
	PARAMETER (TTOEFN=TTIEFN+1)
	INTEGER WTEFN		! EFN for WAIT command
	PARAMETER (WTEFN=TTOEFN+1)
	INTEGER TBEFN		! EFN for trackerball
	PARAMETER (TBEFN=WTEFN+1)
	INTEGER FBEFN		! EFN for trackerball function buttons
	PARAMETER (FBEFN=TBEFN+1)
	INTEGER TMOEFN		! EFN for TEK timeout
	PARAMETER (TMOEFN=FBEFN+1)
	INTEGER CSREFN		! EFN for TEK cursor timeout
	PARAMETER (CSREFN=TMOEFN+1)
	INTEGER DTBEFN		! EFN for direct table read
	PARAMETER (DTBEFN=CSREFN+1)
	INTEGER BUTEFN		! EFN for function buttons
	PARAMETER (BUTEFN=DTBEFN+1)
	INTEGER AUXEFN		! EFN for auxiliary input lines
	PARAMETER (AUXEFN=BUTEFN+1)
	INTEGER FOLEFN		! EFN for streaming input
	PARAMETER (FOLEFN=AUXEFN+1)
	INTEGER		RANGE_TRANS_CORNER
	INTEGER		RANGE_TRANS_SIDE
	INTEGER		RANGE_TRANS_DATA
	PARAMETER	(RANGE_TRANS_CORNER = 1)
	PARAMETER	(RANGE_TRANS_SIDE   = 2)
	PARAMETER	(RANGE_TRANS_DATA   = 3)
	INTEGER		END_EDIT	! EDIT point
	PARAMETER	(END_EDIT=3)
	INTEGER		END_INSERT	! INSERT point
	PARAMETER	(END_INSERT=4)
	INTEGER		END_JOIN	! JOIN
	PARAMETER	(END_JOIN=5)
	INTEGER		END_TIE		! TIE
	PARAMETER	(END_TIE=6)
	INTEGER		END_LOOP	! LOOP
	PARAMETER	(END_LOOP=7)
	INTEGER		END_SQUARE	! SQUARE
	PARAMETER	(END_SQUARE=8)
	INTEGER		END_ORIENT	! ORIENT
	PARAMETER	(END_ORIENT=9)
	INTEGER		END_MEND_MANUAL	! MEND MANUAL
	PARAMETER	(END_MEND_MANUAL=10)
	INTEGER		END_MEND_AUTO	! MEND AUTOMATIC
	PARAMETER	(END_MEND_AUTO=11)
	INTEGER		END_IMAGE	! IMAGE MOVE/COPY
	PARAMETER	(END_IMAGE=12)
	INTEGER		END_CONSTRUCT	! construct text or symbol
	PARAMETER	(END_CONSTRUCT=1)
	INTEGER		END_ROTATE	! rotate text or symbol
	PARAMETER	(END_ROTATE=2)	! with cursor
	INTEGER		END_ALIGN	! align scaled symbol
	PARAMETER	(END_ALIGN=3)
	INTEGER		END_STRETCH	! stretch scaled symbol
	PARAMETER	(END_STRETCH=4)
	INTEGER		END_MOVE	! move text or symbol
	PARAMETER	(END_MOVE=5)
	INTEGER		END_BEND	! bend the text
	PARAMETER	(END_BEND=6)
	INTEGER		END_PART	! PART change command
	PARAMETER	(END_PART=1)	! NB used in EDIT state also
	INTEGER		END_WHOLE	! change whole feature
	PARAMETER	(END_WHOLE=2)	! NB used in EDIT state also
	INTEGER		END_INCLUDE	! INCLUDE
	PARAMETER	(END_INCLUDE=3)
	INTEGER		END_MAP		! WINDOW MAP
	PARAMETER	(END_MAP=1)
	INTEGER		END_SCREEN	! WINDOW SCREEN
	PARAMETER	(END_SCREEN=2)
	INTEGER		END_REGION	! REGION n WINDOW
	PARAMETER	(END_REGION=3)
	INTEGER		END_START	! ordinary construction
	PARAMETER	(END_START=1)
	INTEGER		END_BRIDGE	! BRIDGE
	PARAMETER	(END_BRIDGE=2)
	INTEGER		END_BRIDGE_CLOSE ! BRIDGE with CLOSE
	PARAMETER	(END_BRIDGE_CLOSE=3)
	INTEGER		END_PAINT	! only version of IMAGE PAINT
	PARAMETER	(END_PAINT=1)
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	INTEGER*4	STATE_INITIAL	! INITIALisation
	PARAMETER	(STATE_INITIAL   =  1)
	INTEGER*4	STATE_READY	! READY for operation
	PARAMETER	(STATE_READY     =  2)
	INTEGER*4	STATE_LINE	! LINE feature found
	PARAMETER	(STATE_LINE      =  3)
	INTEGER*4	STATE_CIRCLE	! CIRCLE feature found
	PARAMETER	(STATE_CIRCLE     = 4)
	INTEGER*4	STATE_TEXT	! TEXT feature found
	PARAMETER	(STATE_TEXT      =  5)
	INTEGER*4	STATE_SYMBOL	! SYMBOL found
	PARAMETER	(STATE_SYMBOL    =  6)
	INTEGER*4	STATE_EDIT	! EDIT line
	PARAMETER	(STATE_EDIT      =  7)
	INTEGER*4	STATE_MODIFY	! MODIFY text / symbol
	PARAMETER	(STATE_MODIFY    =  8)
	INTEGER*4	STATE_ON	! constrain movement ON line
	PARAMETER	(STATE_ON        =  9)
	INTEGER*4	STATE_WINDOW	! WINDOW
	PARAMETER	(STATE_WINDOW    =  10)
	INTEGER*4	STATE_CONSTRUCT	! CONSTRUCT line
	PARAMETER	(STATE_CONSTRUCT = 11)
	INTEGER*4	STATE_AC	! AC edit
	PARAMETER	(STATE_AC        = 12)
	INTEGER*4	STATE_DEBUG	! DEBUG
	PARAMETER	(STATE_DEBUG     = 13)
	INTEGER*4	STATE_RECOVER	! RECOVER feature
	PARAMETER	(STATE_RECOVER   = 14)
	INTEGER*4	STATE_MACRO	! MACRO reading
	PARAMETER	(STATE_MACRO     = 15)
	INTEGER*4	STATE_SETUP	! SETUP of image
	PARAMETER	(STATE_SETUP     = 16)
	INTEGER*4	STATE_PAINT	! PAINTing image
	PARAMETER	(STATE_PAINT     = 17)
	INTEGER*4	MAXSTA		! number of states defined
	PARAMETER	(MAXSTA = 17)
	INTEGER*4	MASK_INITIAL	! INITIALisation
	PARAMETER	(MASK_INITIAL   =  '00040000'X)
	INTEGER*4	MASK_READY	! READY for operation
	PARAMETER	(MASK_READY     =  '08000000'X)
	INTEGER*4	MASK_LINE	! LINE feature found
	PARAMETER	(MASK_LINE      =  '00200000'X)
	INTEGER*4	MASK_CIRCLE	! CIRCLE feature found
	PARAMETER	(MASK_CIRCLE      =  '04000000'X)
	INTEGER*4	MASK_TEXT	! TEXT feature found
	PARAMETER	(MASK_TEXT      =  '20000000'X)
	INTEGER*4	MASK_SYMBOL	! SYMBOL found
	PARAMETER	(MASK_SYMBOL    =  '10000000'X)
	INTEGER*4	MASK_EDIT	! EDIT line
	PARAMETER	(MASK_EDIT      =  '00004000'X)
	INTEGER*4	MASK_MODIFY	! MODIFY text / symbol
	PARAMETER	(MASK_MODIFY    =  '00400000'X)
	INTEGER*4	MASK_ON		! constrain movement ON line
	PARAMETER	(MASK_ON        =  '01000000'X)
	INTEGER*4	MASK_WINDOW	! WINDOW
	PARAMETER	(MASK_WINDOW    =  '80000000'X)
	INTEGER*4	MASK_CONSTRUCT	! CONSTRUCT line
	PARAMETER	(MASK_CONSTRUCT =  '00001000'X)
	INTEGER*4	MASK_AC		! AC edit
	PARAMETER	(MASK_AC        =  '00000400'X)
	INTEGER*4	MASK_DEBUG	! DEBUG
	PARAMETER	(MASK_DEBUG     =  '00002000'X)
	INTEGER*4	MASK_RECOVER	! RECOVER feature
	PARAMETER	(MASK_RECOVER   =  '00010000'X)
	INTEGER*4	MASK_MACRO	! MACRO reading
	PARAMETER	(MASK_MACRO     =  '00000800'X)
	INTEGER*4	MASK_SETUP	! SETUP image
	PARAMETER	(MASK_SETUP     =  '40000000'X)
	INTEGER*4	MASK_PAINT	! PAINTing image
	PARAMETER	(MASK_PAINT     =  '02000000'X)
	INTEGER*4	DARGS		! max. no. of arguments
	PARAMETER	(DARGS = 7)
	INTEGER*4	DCM		! max. command length
	PARAMETER	(DCM = 16)
	INTEGER*4	DSM		! max. string length
	PARAMETER	(DSM = 255)
	INTEGER*4	DPRIN		! primary command number
	INTEGER*4	DSECN		! secondary command number
	INTEGER*4	DNINT		! number of integer arguments
	INTEGER*4	DNREA		! number of real arguments
	INTEGER*4	DPRIL		! primary command length
	INTEGER*4	DSECL		! secondary command length
	INTEGER*4	DSTRL		! string length
	INTEGER*4	DINTS(DARGS)	! integer arguments
	REAL*4		DREALS(DARGS)	! real arguments
	LOGICAL		DSTRIN		! string argument ?
	CHARACTER*(DCM)	DPRI		! primary command string
	CHARACTER*(DCM)	DSEC		! secondary command string
	CHARACTER*(DSM)	DSTR		! string argument
	COMMON/DOUT/DPRIN,DSECN,DNINT,DNREA,DPRIL,DSECL,DSTRL,DINTS,
     &	DREALS,DSTRIN
	COMMON/DOUTCH/DPRI,DSEC,DSTR
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
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
	LOGICAL		DONE		! finished execution ?
	LOGICAL		JOUSUP		! journalling suppressed ?
	LOGICAL		JOUFCE		! force out journal line ?
	LOGICAL		MOANED		! error ?
	LOGICAL		LAST_MOANED	! copy of above, one command behind
	INTEGER		CTRLC		! control-C has been pressed ?
	INTEGER		BREAK		! less severe control-C been pressed ?
	LOGICAL		ITERM		! SYS$INPUT is a terminal ?
	LOGICAL		IMAIL		! SYS$INPUT is a mailbox ?
	LOGICAL		OTERM		! SYS$INPUT is a terminal ?
	INTEGER		PRIV_LIST	! head of list of PRIVILEGED
					! commands
	LOGICAL		CANC_RESP	! cancel respond input
	INTEGER		CTRLC_OFF  	! no control C at all
	INTEGER		CTRLC_ABORT	! control c from ABORT command
	INTEGER		CTRLC_BREAK	! less severe control c
	INTEGER		CTRLC_AST	! control c from CTRLCAST
	PARAMETER	(CTRLC_OFF	=  0,
     &			 CTRLC_ABORT	=  1,
     &			 CTRLC_BREAK	=  3,
     &			 CTRLC_AST	= -1)
	INTEGER		BREAK_OFF  	! no break
	INTEGER		BREAK_ON	! got a break
	PARAMETER	(BREAK_OFF	=  0,
     &			 BREAK_ON	= -1)
	INTEGER		CTRLC_MAX_MESS
	PARAMETER	(CTRLC_MAX_MESS = 80)
	INTEGER		CTRLC_MESS_LEN
	CHARACTER*(CTRLC_MAX_MESS) CTRLC_MESS
	COMMON/GLOBAL/DONE,JOUSUP,MOANED,LAST_MOANED,
     &		      CTRLC,ITERM,OTERM,PRIV_LIST,CANC_RESP,IMAIL,
     &		      CTRLC_MESS_LEN,CTRLC_MESS,BREAK,JOUFCE
	REAL*8		LINWDTH_FCTR
	PARAMETER	(LINWDTH_FCTR = 5.0E-7)
	REAL*8		LINWDTH		! the "width of a line" -
					! used for comparison with zero
	REAL		CSXY(3)		! current cursor position
	INTEGER		CSZI		! Z value of cursor position (as
					! INTEGER)
	EQUIVALENCE	(CSXY(3),CSZI)	! equivalenced
	REAL		XSECTW,YSECTW	! sector widths
	REAL		XOFF,YOFF	! SW corner of sector grid
	REAL		LIMITS(4)	! extent of sector grid
	REAL*8		ABS_LIMITS(4)	! absolute range of maps
	LOGICAL		HAD_RANGE_CMD	! true when had RANGE command 
	INTEGER XRANGE,YRANGE	! number of sectors in the y- and x-axes
	INTEGER	TOPSEC		! last sector being used
	INTEGER	NDMODE		! end mode - what to do on END command
	INTEGER	LASBUT		! last button used ($BUTTON)
	REAL	WINXY(2)	! saved SW corner of window
	INTEGER	WINREG		! region number for REGION n WINDOW
	LOGICAL	SCSARC		! constrain on arc/line?
	REAL	SCSAUX(5)	! aux array if circle (should use AUXLEN,
				!  but can't face including AUXDEF
	REAL	SCSTXY(2,2)	! ends of constraint line
	INTEGER	CUST		! customer number (as in map header)
				! = 0 for unknown
				! = 1 for MCE
				! = 2 for OS 
				! etc
	INTEGER	OTHFLG		! value to be set in PAKFLG for flushed
				! features when FSHCTR is TRUE
	LOGICAL	FSHCTR		! TRUE  when OTHFLG to be used in FLUSH
				! FALSE otherwise
	LOGICAL	CHASEL		! true if selections have been changed
	LOGICAL	ROLING		! cursor is constrained
	LOGICAL	POSCMD		! .TRUE. when last command was a
				! positioning command (FIND, VERTEX
				! etc)
	LOGICAL	SETING		! setup raster registration
	LOGICAL	FINDNG		! finding (set in FINREC - used in SCNSEC)
	LOGICAL	PNTING		! doing IMAGE PAINT
	INTEGER*4 RAN_SEED	! seed value for random number generator
	INTEGER	PRIV_ATTR_LIST	! list of attributes that may not be altered
	INTEGER	PRIV_PT_LIST	! list of attibutes of privileged points
	REAL	FAR_MOVE_MM	! tolerance for FAR_MOVE (mm)
	REAL	FAR_MOVE_IFF	! tolerance for FAR_MOVE (iff units)
	REAL	FORCE_COEFFS(4)	! defining plane
	REAL	FORCE_HEIGHT	! height of original point
	LOGICAL	FORCE_C_SETUP	! OK to use plane?
	LOGICAL	FORCE_H_SETUP	! OK to use height?
	INTEGER		ASK_INT_TOT
	PARAMETER	(ASK_INT_TOT = 3)
	INTEGER		ASK_REAL_TOT
	PARAMETER	(ASK_REAL_TOT = 3)
	INTEGER		ASK_CHAR_TOT
	PARAMETER	(ASK_CHAR_TOT = 2)
	INTEGER		ASK_INT(ASK_INT_TOT)	! value for system variable $ASK_INT
	INTEGER		ASK_CHAR(2,ASK_CHAR_TOT)! value for system variable $ASK_CHAR
						! (dynamic descriptor)
	REAL		ASK_REAL(ASK_REAL_TOT)
	INTEGER		ASK_INT_NUM
	INTEGER		ASK_REAL_NUM
	INTEGER		ASK_CHAR_NUM
	COMMON /MASTER/ ABS_LIMITS,LINWDTH,
     &			CSXY,XSECTW,YSECTW,XOFF,YOFF,LIMITS,
     &			XRANGE,YRANGE,TOPSEC,NDMODE,WINXY,SCSTXY,
     &			CUST,OTHFLG,LASBUT,RAN_SEED,PRIV_ATTR_LIST,
     &	                PRIV_PT_LIST,FORCE_COEFFS,FORCE_HEIGHT,
     &			FAR_MOVE_MM,FAR_MOVE_IFF,
     &	                ASK_INT,ASK_CHAR,ASK_REAL,
     &			ASK_INT_NUM,ASK_CHAR_NUM,ASK_REAL_NUM,
     &			FSHCTR,CHASEL,ROLING,POSCMD,SETING,
     &	                FORCE_C_SETUP,FORCE_H_SETUP,
     &			FINDNG,HAD_RANGE_CMD,
     &			WINREG,PNTING,
     &			SCSARC,SCSAUX
	PARAMETER OIFULL = 201
	PARAMETER LNFAKE = 255
	INTEGER		OIH_MAX_ATTR	! maximum size of CB arrays
	PARAMETER	(OIH_MAX_ATTR = IFF_MAXCBCOL-2)
	REAL		COIXY(2,OIFULL)		! coordinates
	REAL		COPY_COIXY(2,OIFULL)  	! coordinates (for fly trans)
	REAL		COIZ(OIFULL)		! heights
	INTEGER		COIZI(OIFULL)		! (as integers)
	EQUIVALENCE	(COIZ,COIZI)
	INTEGER		COINATT			! number of attributes
	INTEGER		COIATTC(OIH_MAX_ATTR)	! attribute codes
	INTEGER		COIATTV(OIH_MAX_ATTR,OIFULL) ! attribute values
	LOGICAL		COIOVR			! attributes overflowed
	REAL		COIAUX(AUXLEN)		! auxiliary array
	REAL		COIANG			! angle
	INTEGER*4	COIPAK(PAKLEN)		! data pack
	INTEGER		COIIND			! last used in COIXY
	INTEGER		COILST			! total number of points
	REAL		COICOEFFS(4)		! plane of circle arcs
	LOGICAL		COIC_DEFINED		! set up
	INTEGER		LSTSEC			! saved sector
	INTEGER*4	LSTPST			! pointer to last ST
	INTEGER		LSTVRT			! and vertex of last ST
	INTEGER		COIFC			! fc for feature - texts
	INTEGER*2	COIFS(4)		! FS entry (for texts)
	INTEGER*4	OIPST			! pointer to ST
	INTEGER*2	OIENDS			! ST ENDS word
	LOGICAL*1	COIFST			! first bit of feature
	LOGICAL*1	HADRO			! had a rotation
	LOGICAL*1	HADTX			! had a text
	LOGICAL*1	OIDRAW			! draw the item?
	LOGICAL*1	OILOOP			! is curve a loop?
	LOGICAL*1	USEINP			! use input file only?
	LOGICAL*1	COMTXT			! composite text
	LOGICAL*1	FROM_IFFBDY		! TRUE when FLUSH 
						! called from IFFBDY
	INTEGER*2	COILEN		! descriptor  (length)
	INTEGER*2	COITYP		!     "       (undefined)
	INTEGER*4	COIADR		!     "       (buffer address)
	INTEGER*2	COIDSC(4)	!     "
	BYTE		COIBUF(LNFAKE+1)	! buffer
	EQUIVALENCE	(COIDSC(1),COILEN),(COIDSC(2),COITYP),
     &			(COIDSC(3),COIADR)
	COMMON/OIIH/COIXY,COIAUX,COINATT,COIATTC,COIATTV,COIOVR,
     &	        COICOEFFS,COIZ,COIANG,COIPAK,
     &		COIIND,COILST,LSTSEC,COIC_DEFINED,
     &		LSTPST,LSTVRT,OIPST,COIDSC,COIFC,COIFS,OIENDS,
     &		COIFST,HADRO,HADTX,OIDRAW,OILOOP,USEINP,COIBUF,COMTXT,
     &		COPY_COIXY,FROM_IFFBDY			! align
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		PROLEN		! length of prompt string
	INTEGER		PRILEN		! length of INQUIRE prompt
	LOGICAL*1	PROING		! true if prompting
	LOGICAL*1	PROSTA		! true if prompting with state
	LOGICAL*1	PROINQ		! true if want INQUIRE prompt
	COMMON/PROMPT/PROLEN,PRILEN,PROING,PROSTA,PROINQ
	CHARACTER*80	PROSTR		! prompt string
	CHARACTER*80	PINSTR		! inquire prompt string
	COMMON/PROCHR/PROSTR,PINSTR
	REAL		OCSXY(2)	! old cursor position
	REAL		RUBARR(2,2)	! rubber band positions
	INTEGER		RFFULL	! (preset) number to refresh
	INTEGER		RFOFF	! (preset) target within RFFULL
	INTEGER		RFCRIT	! (preset) distance of cursor to end
	INTEGER*4	RFFSEG	! segment number of refreshed found item
	INTEGER		RFFVO	! vertex offset of refreshed found item
	INTEGER		RFFOFF	! vertex offset of actual refresh bit
	INTEGER		RFFTOP	! number of refreshed vertices
	INTEGER*4	RFFCTX	! address of CTX that has cursor on it
	INTEGER*4	RFHSEG	! refreshed object in hand segment
	INTEGER		RFHOFF	! vertex offset of actual refresh bit
	INTEGER		RFHTOP	! number of refreshed vertices
	INTEGER		RFCIND	! refreshed construction index
	LOGICAL		CURS	! true if cursor required
	LOGICAL		INTCUR	! true if cursor position initialised
	LOGICAL		RFCURS	! true if cursor presently drawn
	LOGICAL		RFFLIM	! refreshed found item is in limbo
	LOGICAL		REFNG	! true while executing RFDRAW
	LOGICAL*1	RUBLIN(2)	! want rubber bands?
	LOGICAL		RUBCHG	! rubber bands changed?
	LOGICAL		RFMOD	! have a 'modification' in refresh
	LOGICAL		RFRUB	! have rubber band in refresh
	LOGICAL		RFBIG	! got big cursor
	LOGICAL		RFBNK	! got blinking cursor
	LOGICAL		RFCSEG	! true if cursor segment exists
	LOGICAL		RFLSEG	! true if F/L segment exits
	LOGICAL		RFHSEP	! true separate segment for IH
	LOGICAL		RFFSEP	! true separate segment for FO
	INTEGER		RFCTYP	! cursor type
	REAL		RFCARG(2) ! additional cursor arguments
	INTEGER		RFCOL	! bit mask (colour)
	COMMON/RFCTRL/OCSXY,RUBARR,
     &	        RFFULL,RFOFF,RFCRIT,
     &		RFFSEG,RFFVO,RFFOFF,RFFTOP,
     &		RFHSEG,RFHOFF,RFHTOP,RFCIND,RFFCTX,
     &		CURS,INTCUR,RFCURS,RFFLIM,REFNG,
     &		RUBCHG,RFMOD,RFRUB,RFBIG,RFBNK,RFCSEG,RFLSEG,
     &		RFHSEP,RFFSEP,
     &		RFCTYP,RFCARG,RUBLIN,RFCOL
	INTEGER*4	SSM		! max. state string length
	PARAMETER	(SSM = 16)
	INTEGER*4	STAMSK(MAXSTA)	! all state masks
	INTEGER*4	STACHS(MAXSTA)	! all state name lengths
	INTEGER*4	SMASK		! current state flag mask
	INTEGER*4	SINDEX		! current state index
	INTEGER*4	STALEN		! current state name lengths
	CHARACTER*(SSM)	STANAM(MAXSTA)	! all state names
	CHARACTER*(SSM)	STASTR		! current state name
	COMMON/STATE/STAMSK,STACHS,SMASK,SINDEX,STALEN
	COMMON/STACH/STANAM,STASTR
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
	INTEGER*4	TABPUK	! for table monitor puck
	INTEGER*4	TABSTR	! for table monitor streaming mode
	INTEGER*4	TABERR	! for table monitor error
	INTEGER*4	TABFLG	! for wosplib table/bitpad
	INTEGER*4	TTIFLG	! for terminal input
	INTEGER*4	CLCFLG	! for control C event flag
	INTEGER*4	TBFLG	! for trackerball event flag
	INTEGER*4	FBFLG	! for trackerball button event flag
	INTEGER*4	TMOFLG	! for TEK timeout timer
	INTEGER*4	CSRFLG	! for TEK cursor timeout timer
	INTEGER*4	DTBFLG	! for direct table reading
	INTEGER*4	BUTFLG	! for reading function buttons
	INTEGER*4	AUXFLG	! for reading auxiliary inputs
	INTEGER*4	FOLFLG	! for streaming timer
	COMMON	/VAREFN/TABPUK,TABSTR,TABERR,TABFLG,TTIFLG,
     &			CLCFLG,TBFLG,FBFLG,TMOFLG,CSRFLG,DTBFLG,
     &	                BUTFLG,AUXFLG,FOLFLG
	LOGICAL*1	CHFSN
	INTEGER		NEWFSN
	LOGICAL*1	CHFC
	INTEGER		NEWFC
	INTEGER		NEWGT
	LOGICAL*1	CHPC
	INTEGER		NEWPC
	LOGICAL*1	CHMAP
	INTEGER		NEWMAP
	LOGICAL*1	CHLAY
	INTEGER		NEWLAY
	LOGICAL*1	CHPOS
	REAL		CHCSXY(3)
	INTEGER		CHCZI
	EQUIVALENCE	(CHCZI,CHCSXY(3))
	LOGICAL*1	CHOFF
	REAL		OFFDIS
	LOGICAL*1	CHREV			! reverse
	LOGICAL*1	LIMBO			! put into limbo
	LOGICAL*1	RECOVR			! recover from limbo
	LOGICAL*1	CHCOPY			! change copy of object
	LOGICAL*1	REFLSH			! needs re-flushing
	LOGICAL*1	CLREDT			! clear edit flag
	LOGICAL*1	SETEDT			! set edit flag
	LOGICAL*1	CHTRAN			! transform
	LOGICAL*1	CHFILT			! filter
	COMMON/VARIAT/
     &		NEWFSN,NEWFC,NEWGT,NEWPC,NEWMAP,NEWLAY,CHCSXY,OFFDIS,
     &		CHFSN,CHFC,CHPC,CHMAP,CHLAY,CHPOS,CHOFF,CHREV,LIMBO,
     &		RECOVR,CHCOPY,REFLSH,CLREDT,SETEDT,CHTRAN,CHFILT
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INCLUDE '($DVIDEF)'
	LOGICAL*1	CTRLZ		! true when command from
					! keyboard terminated with ^Z
	INTEGER*4	SYS$DASSGN
	INTEGER*4	EXPAND
	INTEGER		LIB$GETDVI
	LOGICAL		HAD_ERROR,READ_ERROR
	LOGICAL		HAD_PUCK,READ_PUCK
	LOGICAL		HAD_STREAM,READ_STREAM
	LOGICAL		RUBISH
	LOGICAL		STRDTB
	LOGICAL		DIGTRN
	LOGICAL		GTYPAC
	LOGICAL		AUXACT		! are auxiliary inputs active
	LOGICAL		SERVAUX		! service the auxiliary inputs
	LOGICAL		AUXOFF		! has an auxiliary input gone off
	LOGICAL		SERV_FOLLOW	! service event from following
	INTEGER*4	IERR
	INTEGER*4	MASK
	INTEGER		TTLEN
	INTEGER*2	TAIOSB(4)
	INTEGER		TABLEN
	PARAMETER	(TABLEN=12)
	BYTE		TABUF(TABLEN)
	INTEGER		TALEN
	CHARACTER*20	TTDEV
	CHARACTER*20	TKDEV
	INTEGER		I,J
	INTEGER*2	TALIN,TABUT
	REAL		TABXY(2)
	INTEGER*4	DEV,BUTTON
	REAL		TEKXY(2)	! TEK cursor position
	INTEGER*2	CS1,CS2
	INTEGER		PTR
	LOGICAL*1	RMON		! .TRUE. if using table monitor
	BYTE		BU		! button number returned by
					! table monitor
	INTEGER*4	IX,IY		! coordinates returned by
					! table monitor
	LOGICAL*1	POS		! positioning command
	LOGICAL*1	POSDON		! implicit POS done?
	CHARACTER*30	STRING		! command string from TRNTIP
	INTEGER*4	STRLEN		! length of string
	INTEGER*4	COUNT		! number of chars in typeahead
	BYTE		BYTE1		! first character
	LOGICAL*1	WAIT_STREAM	! awaiting stream input?
	INTEGER		MASK4014
	LOGICAL		FROM_MENU
	INTEGER		TERMLEN
	LOGICAL		HADKB		! input from TT or AUX
	EQUIVALENCE	(TALIN,TABUF(1)),(TABUT,TABUF(3)),
     &			(TABXY(1),TABUF(5))
	RMON = TABINI.AND.MONOPT.AND..NOT.DTRON	! use table monitor?
	TXTPTR = 0			! nothing in TXTBUF
10	CTRLZ = .FALSE.			! assume not CTRL/Z
	HADKB = .FALSE.			! no keyboard input
	CALL PROMPT			! prompt if required
	IF (AUXACT()) THEN		! are any aux inputs active?
	   IF (.NOT.AUX_READ) THEN	! no read up
	      IF (AUXOFF(AUXIOSB)) GOTO 600
	   ENDIF
	ENDIF
	IF (.NOT.WKOP(1)) GOTO 100
	IF (TTINIT) THEN
	   IERR = LIB$GETDVI(DVI$_DEVNAM,,'SYS$INPUT',,TTDEV,)
	   IF (.NOT.IERR) THEN
	      CALL MOAN(MSG_FLDTOTRANS,'SYS$INPUT')
	      CALL LITES2_SIGNAL(IERR)
	      GOTO 999
	   ENDIF
	   IERR = LIB$GETDVI(DVI$_DEVNAM,,'LSL$TK',,TKDEV,)
	   IF (.NOT.IERR) THEN
	      CALL MOAN(MSG_FLDTOTRANS,'LSL$TK')
	      CALL LITES2_SIGNAL(IERR)
	      GOTO 999
	   ENDIF
	   IF (TTDEV.EQ.TKDEV) WOSPIN = .TRUE.
	   IF (WOSPIN.AND.TTASN) THEN
	      IERR = SYS$DASSGN(%VAL(TTICHN))
	      IF (.NOT.IERR) THEN
	         CALL MOAN(MSG_FLDDEASSCHN)
	         CALL LITES2_SIGNAL(IERR)
	      ENDIF
	      TTASN = .FALSE.
	   ENDIF
	   TTINIT = .FALSE.
	ENDIF
	IF ((BITINI.OR.(TABINI.AND..NOT.MONOPT)).AND..NOT.TAREAD) THEN
	   CALL TKREAD(2,TABUF,TABLEN,TALEN,TABFLG,TAIOSB)
	   TAREAD = .TRUE.			! table read going
	ENDIF
100	CONTINUE
	IF (DTRON.AND..NOT.DTBREAD) THEN
	   IF (GTYPAC(DTBCHN,COUNT,BYTE1)) THEN	! check type ahead buff
	      IF (COUNT.GT.MXTYPC) THEN
	         CALL MOAN(MSG_NOMOREBUTS,COUNT/15)
	      ENDIF
	   ENDIF
	   DTBREAD=STRDTB(DTBFLG,DTBCHN,DTBOSB,,DTBLEN,DTBBUF)
	ENDIF
	CALL STRTAUX(AUXIOSB,,TTBLEN,AUXBUF)
	IF (AUXOFF(AUXIOSB)) GOTO 600
	IF (WOSPIN) THEN		! use WOSPLIB input
	   CALL TKREAD(1,TTBUF,TTBLEN,TTLEN,TTIFLG,TTIOSB)
	   TTREAD = .TRUE.			! terminal read going
	ELSE					! go wait for something
	   IF (.NOT.TTREAD.AND..NOT.TTABORT) THEN
	      CALL QIOUP(TTASN,'SYS$INPUT',TTICHN,TTIFLG,TTIOSB,,
     &	              TTBLEN,TTBUF,TTREAD,TTABORT)
	      IF (TTABORT) GOTO 999
	   ENDIF
	ENDIF
150	CONTINUE
	MASK = 0				! clear to start with
	CALL EFWM(MASK,TTIFLG,CLCFLG)		! terminal and CTRL/C
	IF (AUX_READ) CALL EFWM(MASK,AUXFLG)
	IF (TAREAD) CALL EFWM(MASK,TABFLG)	! add WOSP table
	IF (DTBREAD) CALL EFWM(MASK,DTBFLG)	! add direct table read
	IF (RMON) THEN
	   CALL EFWM(MASK,TABPUK,TABERR)	! monitor puck and error
	   WAIT_STREAM = STREAM			! are we awaiting stream?
	   IF (STREAM) THEN
	      CALL EFWM(MASK,TABSTR)		! monitor stream
	      STREAM = .FALSE.			! assume not stream next
	   ENDIF
	ENDIF
	IF (BALINI) CALL EFWM(MASK,TBFLG,FBFLG)	! tracker ball, buttons
	IF (FOLLOWING) CALL EFWM(MASK,FOLFLG)
	IF (FOLLOWING.AND..NOT.FOLLOW_TIMING) THEN
	   CALL FOLTMR()
	   FOLLOW_TIMING = .TRUE.
	ENDIF
	IF (WTYPES(1).NE.4014) THEN
	   IF (WKOP(1).AND..NOT.TIMOUT) THEN
	      CALL EFWM(MASK,TMOFLG)		! TEK display timeout
	      CALL TMOTMR				! set timer going
	   ENDIF
	ENDIF
	IF (TIMOUT.OR..NOT.BITINI) GOTO 160	! no cursor timer
	IF (ROLING) GOTO 153
	IF ((SINDEX.EQ.STATE_MODIFY).AND.
     &	(NDMODE.EQ.END_ROTATE.OR.NDMODE.EQ.END_ALIGN
     &	.OR.NDMODE.EQ.END_STRETCH.OR.
     &	(NDMODE.EQ.END_MOVE.AND.COIPAK(PAKGT).NE.TEXTYP) ) .OR.
     &	(SINDEX.EQ.STATE_WINDOW) .OR.
     &  (SINDEX.EQ.STATE_EDIT.AND.CHPOS) ) GOTO 153
	GOTO 160
153	CALL EFWM(MASK,CSRFLG)			! cursor timer flag
155	CALL CSRTMR				! start timer
160	IF (CTRLC.NE.CTRLC_OFF) THEN
	   CALL SYS$CLREF(%VAL(CLCFLG))
	   GOTO 990
	ENDIF
	CALL SYS$WFLOR( %VAL(TTIFLG), %VAL(MASK) )
	IF (WTYPES(1).NE.4014) THEN
	   IF (TMOTED) THEN
	      CALL PING
	      CALL RFSTOP			! stop refresh cycling
	      TIMOUT = .TRUE.			! remember timed out
	      TMOTED = .FALSE.
	      GOTO 150				! wait again
	   ENDIF
	   IF (TIMOUT) THEN
	      CALL REFRSH
	      TIMOUT = .FALSE.
	   ENDIF
	ENDIF
	IF (BITINI.AND.WTYPES(1).NE.4014) THEN	! muart bitpad enabled?
	   CALL GETPCC(CS1)		! count cursor moves
	   CALL CSRD(TEKXY(1),TEKXY(2))	! read cursor
	   CALL GETPCC(CS2)		! new cursor moves
	   IF (CS2.GT.CS1) THEN		! locally tracked?
	      CALL GKSD2W(1,TEKXY(1),TEKXY(2),TEKXY(1),TEKXY(2))
	      IF (RUBISH(TEKXY)) THEN	! out of range
	         POSXY(1) = CSXY(1)	! re-position
	         POSXY(2) = CSXY(2)
	         OCSXY(1) = CSXY(1)+1.0	! force re-write
	      ELSE
	         POSXY(1) = TEKXY(1)
	         POSXY(2) = TEKXY(2)
	      ENDIF
	      POSPND = .TRUE.		! POS command pending
	      POSDON = .FALSE.		! POS not done yet
	   ENDIF
	ENDIF
	IF (BALINI) THEN
	   CALL VSTBRD(TEKXY(1),TEKXY(2))	! get displacement
	   IF (TEKXY(1).NE.0.0.OR.TEKXY(2).NE.0.0) THEN
	      CALL GD2W(2,TEKXY(1),TEKXY(2),TEKXY(1),TEKXY(2))
	      TEKXY(1) = TEKXY(1)+CSXY(1)
	      TEKXY(2) = TEKXY(2)+CSXY(2)
	      IF (.NOT.RUBISH(TEKXY)) THEN	! in range
	         POSXY(1) = TEKXY(1)
	         POSXY(2) = TEKXY(2)
	         POSPND = .TRUE.		! POS command pending
	         POSDON = .FALSE.		! POS not done yet
	      ENDIF
	      GOTO 990			! perform immediately
	   ENDIF
	   CALL VSFBRD(I)		! see which FB has been hit
	   IF (I.NE.0) THEN
	      BUTTON = I-1		! into range 0-3
	      DEV = 4			! on device 4
	      GOTO 900
	   ENDIF
	ENDIF
	IF (TTIOSB(1).NE.0) GOTO 200		! terminal input
	IF (TAREAD.AND.TAIOSB(1).NE.0) GOTO 300	! wosplib table
	IF (DTBREAD.AND.DTBOSB(1).NE.0) GOTO 400! direct table
	IF (RMON) THEN
	   IF (HAD_ERROR(IERR)) THEN
	      IF (.NOT.READ_ERROR(TXTBUF,TXTPTR,I,IERR)) THEN
	         CALL INFORM(MSG_TABMONERR,I)
	         CALL INFORM(MSG_STRING,TXTDSC)
	         TXTPTR = 0		! buffer empty again
	      ENDIF
	      GOTO 160
	   ELSEIF (HAD_PUCK(IERR)) THEN		! tab_mon puck
	      IF (.NOT.READ_PUCK(BU,IX,IY,IERR)) GOTO 500
	   ELSEIF (WAIT_STREAM) THEN		! waiting for stream
	      IF (HAD_STREAM(IERR)) THEN	! tab_mon stream
	         BU = -1			! mark as stream
	         IF (.NOT.READ_STREAM(IX,IY,IERR)) GOTO 500
	      ENDIF
	   ENDIF
	ENDIF
	IF (AUX_READ) THEN
	   IF (AUXOFF(AUXIOSB)) GOTO 600
	ENDIF	      
	IF (CSRTMO) THEN
	   CSRTMO = .FALSE.
	   IF (POSPND.AND..NOT.POSDON) GOTO 990	! perform implicit POS
	   GOTO 155				! re-time and wait
	ENDIF
	IF (FOLLOWING.AND.FOLLOWED) THEN
	   CALL FOLTMR()		! start timer again
	   IF (SERV_FOLLOW()) GOTO 990	! got valid coordinate
	   GOTO 10			! round again
	ENDIF
	IF (CTRLC.NE.CTRLC_OFF) THEN
	   CALL SYS$CLREF(%VAL(CLCFLG))
	   GOTO 990
	ENDIF
	CALL INFORM(MSG_NOINPUT)
	GOTO 10
200	TTREAD = .FALSE.	! no terminal read outstanding
	TTIDON = .TRUE.		! terminal input done (want prompt)
	IF (.NOT.TTIOSB(1)) THEN
	   CALL MOAN(MSG_ERRINTERRD)
	   CALL LITES2_SIGNAL(TTIOSB(1))
	   GOTO 10
	ENDIF
	HADKB = .TRUE.
	CTRLZ = TTIOSB(4).EQ.1.AND.TTIOSB(3).EQ.26
	J = TTIOSB(2)		! number of chars input
	TERMLEN = TTIOSB(4)	! terminator length
	IF (J.GT.0.OR.TERMLEN.GT.1) THEN	! line not empty
	   STRLEN = 0
	   IF (TERMLEN.GT.1) CALL INTTERM(TTBUF(J+1),TERMLEN,STRING,STRLEN)
	   IF (TTIOSB(3).NE.13) THEN
	      TTIDON = .FALSE.	! want newline before output
	      IF (J.NE.0) TTPROM = .TRUE.
	   ENDIF
	   PTR = 0
	   IF (POSPND.AND..NOT.PROINQ) THEN
	      PTR = EXPAND('%W%%POS %G0.8 %G0.8#',TXTBUF,
     &					POSXY(1),POSXY(2))
	      POSPND = .FALSE.
	   ENDIF
	   DO 210 I=1,J
	      TXTBUF(I+PTR) = TTBUF(I)
210	   CONTINUE
	   PTR = PTR+J
	   IF (STRLEN.GT.0.AND.(J.EQ.0.OR..NOT.PROINQ)) THEN
	      IF (J.NE.0) THEN
	         PTR = PTR + 1
	         TXTBUF(PTR) = '#'
	      ENDIF
	      PTR = PTR + EXPAND('%W%S',TXTBUF(PTR+1),STRING(1:STRLEN))
	   ENDIF
	   TXTPTR = PTR
	ELSEIF (J.EQ.0.AND.BITINI.AND.WTYPES(1).EQ.4014) THEN
220	   CALL TKGIN(.TRUE.)
	   CALL TKREAD(1,TTBUF,TTBLEN,TTLEN,TTIFLG,TTIOSB)
	   MASK4014 = 0				! clear to start with
	   CALL EFWM(MASK4014,TTIFLG,TABFLG)	! terminal
	   CALL SYS$WFLOR( %VAL(TTIFLG), %VAL(MASK4014) )
	   IF (TTIOSB(1)) GOTO 220
	   CALL TKKILL(1)	! take down keyboard read
	   TAREAD = .FALSE.	! no table read outstanding
	   IF (.NOT.TAIOSB(1)) THEN
	      CALL MOAN(MSG_ERRINTABRD)
	      CALL LITES2_SIGNAL(TAIOSB(1))
	      GOTO 10
	   ENDIF
	   CALL GKSD2W(1,TABXY(1),TABXY(2),TEKXY(1),TEKXY(2))
	   IF (RUBISH(TEKXY)) THEN	! out of range
	      POSXY(1) = CSXY(1)	! re-position
	      POSXY(2) = CSXY(2)
	      OCSXY(1) = CSXY(1)+1.0	! force re-write
	      CALL INFORM(MSG_BADPOS)
	   ELSE
	      POSXY(1) = TEKXY(1)
	      POSXY(2) = TEKXY(2)
	   ENDIF
	   POSPND = .TRUE.		! POS command pending
	   POSDON = .FALSE.		! POS not done yet
	   CALL TKREAD(2,TABUF,TABLEN,TALEN,TABFLG,TAIOSB)
	   TAREAD = .TRUE.		! table read 
	ENDIF
	IF (WOSPIN) THEN
	   CALL TKREAD(1,TTBUF,TTBLEN,TTLEN,TTIFLG,TTIOSB)
	   TTREAD = .TRUE.			! terminal read going
	ENDIF
	GOTO 990		! return with TXTBUF filled
				! ready for decoder
300	TAREAD = .FALSE.	! no table read outstanding
	IF (.NOT.TAIOSB(1)) THEN
	   CALL MOAN(MSG_ERRINTABRD)
	   CALL LITES2_SIGNAL(TAIOSB(1))
	   GOTO 10
	ENDIF
	DEV = TALIN		! convert to long
	BUTTON=TABUT		!    "    "    "
	IF (DEV.EQ.BITLIN.AND.WTYPES(1).NE.4014) THEN
	   CALL LIB$FFS(0,4,TABUT,BUTTON)
	ENDIF
	CALL TKREAD(2,TABUF,TABLEN,TALEN,TABFLG,TAIOSB)
	TAREAD = .TRUE.		! table read going
	GOTO 900		! to get this table read interpreted
400	CONTINUE
	DTBREAD=.FALSE.
	IF (.NOT.DTBOSB(1)) THEN
	   CALL MOAN(MSG_ERRINTABRD)
	   CALL LITES2_SIGNAL(DTBOSB(1))
	   GOTO 100
	ENDIF
	J=DTBOSB(2)				! I*2 -> I*4
	IF (J.EQ.0) GOTO 100
	IF (DIGTRN(DTBBUF,J,BUTTON,IX,IY,USEFUN,%VAL(FUNADR))) THEN
	   CALL INFORM(MSG_TABERRREAD,DTBBUF)   ! error in string
	   GOTO 100
	ELSE
	   DEV=DIGLIN
	   TABXY(1)=IX
	   TABXY(2)=IY
	ENDIF
	GOTO 900
500	DEV=DIGLIN		! only from table, never from bitpad
	BUTTON=BU		! byte to long conversion
	TABXY(1)=IX		! long to real conversion
	TABXY(2)=IY		!  "	   "       "
	IF (BUTTON.EQ.0) THEN		! stream button
	   STREAM = .TRUE.		! want stream next time
	   CALL READ_STREAM(IX,IY,IERR)	! clear event flag
	ELSEIF (BUTTON.LT.0) THEN	! was streamed
	   STREAM = .TRUE.		! want stream next time
	   BUTTON = 0			! stream button
	ENDIF
	GOTO 900
600	IF (SERVAUX(AUXIOSB,TTBLEN,AUXBUF)) THEN
	   HADKB = .TRUE.
	   GOTO 990
	ELSE
	   GOTO 10
	ENDIF
900	CALL TRNTIP(DEV,BUTTON,TABXY,POS,STRING,STRLEN,FROM_MENU)
	IF (DEV.EQ.4) THEN				! ARGS
	   IF (STRLEN.EQ.0) GOTO 990			! no command
	   CALL VSFBW4(ISHFT(1,BUTTON))			! light up
	ELSE
	   IF (POS) THEN		! this probe defined a position
	      IF ((BUTTON.EQ.0).OR..NOT.POSCMD) THEN	! so use it
	         POSXY(1) = TABXY(1)
	         POSXY(2) = TABXY(2)
	         POSPND = .TRUE.		! POS command pending
	         POSDON = .FALSE.		! POS not done yet
	      ENDIF
	   ENDIF
	   IF (BUTTON.EQ.0.OR.STRLEN.EQ.0) GOTO 990	! no command
	ENDIF
	IF (.NOT.QUIOPT) CALL PING		! acknowledge button
	PTR = 0
	IF (POSPND.AND..NOT.PROINQ) THEN
	   PTR = EXPAND('%W%%POS %G0.8 %G0.8#',TXTBUF,POSXY(1),POSXY(2))
	   POSPND = .FALSE.
	ENDIF
	TXTPTR = PTR + EXPAND('%W%S',TXTBUF(PTR+1),STRING(1:STRLEN))
990	IF (TXTPTR.EQ.0.OR.PROINQ) THEN		! no
	   IF (POSPND.AND..NOT.POSDON) THEN	! perform implicit POS
	      IF (ROLING.AND..NOT.PROINQ) THEN
	         TXTPTR = EXPAND(
     &			'%W%%POS %G0.8 %G0.8#',TXTBUF,POSXY(1),POSXY(2))
	         POSPND = .FALSE.
	         GOTO 999
	      ENDIF
	      DREALS(1) = POSXY(1)		! load arguments
	      DREALS(2) = POSXY(2)
	      DNREA = 2
	      CALL DOPOSI			! execute POS
	      CALL UPDATE			! update picture etc.
	      POSDON = .TRUE.			! done POS
	   ENDIF
	   IF (TXTPTR.EQ.0.AND.(.NOT.PROINQ.OR..NOT.HADKB)) THEN
	      IF (CTRLC.EQ.CTRLC_OFF) GOTO 10
	      IF (FOLLOWING) CALL ENDFOLL	! stop following on CTRLc
	   ENDIF
	ENDIF
999	CONTINUE
	IF (BITINI.AND.WTYPES(1).EQ.4014) CALL TKGIN(.FALSE.)
	MOANED = .FALSE.	! don't let command decoder ignore line
	RETURN
	END
	SUBROUTINE TMOTMR
	IMPLICIT NONE
	INTEGER*4	TABPUK	! for table monitor puck
	INTEGER*4	TABSTR	! for table monitor streaming mode
	INTEGER*4	TABERR	! for table monitor error
	INTEGER*4	TABFLG	! for wosplib table/bitpad
	INTEGER*4	TTIFLG	! for terminal input
	INTEGER*4	CLCFLG	! for control C event flag
	INTEGER*4	TBFLG	! for trackerball event flag
	INTEGER*4	FBFLG	! for trackerball button event flag
	INTEGER*4	TMOFLG	! for TEK timeout timer
	INTEGER*4	CSRFLG	! for TEK cursor timeout timer
	INTEGER*4	DTBFLG	! for direct table reading
	INTEGER*4	BUTFLG	! for reading function buttons
	INTEGER*4	AUXFLG	! for reading auxiliary inputs
	INTEGER*4	FOLFLG	! for streaming timer
	COMMON	/VAREFN/TABPUK,TABSTR,TABERR,TABFLG,TTIFLG,
     &			CLCFLG,TBFLG,FBFLG,TMOFLG,CSRFLG,DTBFLG,
     &	                BUTFLG,AUXFLG,FOLFLG
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	EXTERNAL	TMOAST			! timer AST routine
	INTEGER*4	DAYTIM(2)
	DATA		DAYTIM/-600 000 000,-1/	! 60 seconds
	CALL SYS$CANTIM(%VAL(TMOFLG),)
	TMOTED = .FALSE.
	CALL SYS$SETIMR(%VAL(TMOFLG),DAYTIM,TMOAST,%VAL(TMOFLG))
	RETURN
	END
	SUBROUTINE TMOAST
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	TMOTED = .TRUE.				! timed out
	RETURN
	END
	SUBROUTINE CSRTMR
	IMPLICIT NONE
	INTEGER*4	TABPUK	! for table monitor puck
	INTEGER*4	TABSTR	! for table monitor streaming mode
	INTEGER*4	TABERR	! for table monitor error
	INTEGER*4	TABFLG	! for wosplib table/bitpad
	INTEGER*4	TTIFLG	! for terminal input
	INTEGER*4	CLCFLG	! for control C event flag
	INTEGER*4	TBFLG	! for trackerball event flag
	INTEGER*4	FBFLG	! for trackerball button event flag
	INTEGER*4	TMOFLG	! for TEK timeout timer
	INTEGER*4	CSRFLG	! for TEK cursor timeout timer
	INTEGER*4	DTBFLG	! for direct table reading
	INTEGER*4	BUTFLG	! for reading function buttons
	INTEGER*4	AUXFLG	! for reading auxiliary inputs
	INTEGER*4	FOLFLG	! for streaming timer
	COMMON	/VAREFN/TABPUK,TABSTR,TABERR,TABFLG,TTIFLG,
     &			CLCFLG,TBFLG,FBFLG,TMOFLG,CSRFLG,DTBFLG,
     &	                BUTFLG,AUXFLG,FOLFLG
	EXTERNAL	CSRAST			! cursor AST routine
	INTEGER*4	DAYTIM(2)
	DATA		DAYTIM/-2 500 000,-1/	! quarter second
	CALL SYS$CANTIM(%VAL(CSRFLG),)
	CALL SYS$SETIMR(%VAL(CSRFLG),DAYTIM,CSRAST,%VAL(CSRFLG))
	RETURN
	END
	SUBROUTINE CSRAST
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	CSRTMO = .TRUE.				! timed out
	RETURN
	END

	SUBROUTINE RFDRAW
	IMPLICIT NONE
	INCLUDE	'LSL$CMNIFF:CB.STR'
	PARAMETER AUXLEN = 8	! length of auxiliary array
	PARAMETER XCENI= 1	! x coord of centre
	PARAMETER YCENI= 2	! y coord of centre
	PARAMETER RADI = 3	! radius
	PARAMETER STAI = 4	! start angle
	PARAMETER TOTI = 5	! total angle
	PARAMETER ANGI = 1	! angle
	PARAMETER COSI = 2	! cosine
	PARAMETER SINI = 3	! sine
	PARAMETER SIZI = 4	! size
	PARAMETER MINXI= 5	! minimum x
	PARAMETER MAXXI= 6	! maximum x
	PARAMETER MINYI= 7	! minimum y
	PARAMETER MAXYI= 8	! maximum y
	INTEGER		CTXDLEN
	PARAMETER	(CTXDLEN=5)	! longwords
	INTEGER		CTXD_NCTX
	PARAMETER	(CTXD_NCTX=1)	! numbers of text components
	INTEGER		CTXD_FSTCTX
	PARAMETER	(CTXD_FSTCTX=2)	! first text component
	INTEGER		CTXD_LSTCTX
	PARAMETER	(CTXD_LSTCTX=3)	! last text component
	INTEGER		CTXD_CUR
	PARAMETER	(CTXD_CUR=4)	! current text component
					! (for NEXT,PREV)
	INTEGER		CTXD_HOME	! component that text found by
	PARAMETER	(CTXD_HOME=5)
	INTEGER		CTXLENL
	PARAMETER	(CTXLENL=19)	! longwords
	INTEGER		CTXLENW
	PARAMETER	(CTXLENW=38)	! words
	INTEGER		CTXLENB
	PARAMETER	(CTXLENB=76)	! bytes
	INTEGER		CTX_L_NXTPTR
	PARAMETER	(CTX_L_NXTPTR=1)	! (0) forward pointer
	INTEGER		CTX_L_PREPTR
	PARAMETER	(CTX_L_PREPTR=2)	! (4) back pointer
	INTEGER		CTX_L_DESC
	PARAMETER	(CTX_L_DESC=3)		! (8) descriptor
	INTEGER		CTX_W_TXTLEN
	PARAMETER	(CTX_W_TXTLEN=5)	! (8) text length
	INTEGER		CTX_B_DTYPE
	PARAMETER	(CTX_B_DTYPE=11)	! (10) descriptor type
	INTEGER		CTX_B_DCLASS
	PARAMETER	(CTX_B_DCLASS=12)	! (11) descriptor class
	INTEGER		CTX_L_TXTADR
	PARAMETER	(CTX_L_TXTADR=4)	! (12) address of text
	INTEGER		CTX_L_TH
	PARAMETER	(CTX_L_TH=5)		! (16) TH entry
	INTEGER		CTX_L_PACK
	PARAMETER	(CTX_L_PACK=CTX_L_TH)	! (16) PACK entry
	INTEGER		CTX_L_RO
	PARAMETER	(CTX_L_RO=6)		! (20) RO value
	INTEGER		CTX_L_X
	PARAMETER	(CTX_L_X=7)		! (24) X value
	INTEGER		CTX_L_Y
	PARAMETER	(CTX_L_Y=8)		! (28) Y value
	INTEGER		CTX_L_TSA
	PARAMETER	(CTX_L_TSA=9)		! (32) TS entry 
	INTEGER		CTX_L_TSB
	PARAMETER	(CTX_L_TSB=10)		! (36) TS entry 
	INTEGER		CTX_W_TS1
	PARAMETER	(CTX_W_TS1=17)		! (32) TS word 1
	INTEGER		CTX_W_TS2
	PARAMETER	(CTX_W_TS2=18)		! (34) TS word 2
	INTEGER		CTX_W_TS3
	PARAMETER	(CTX_W_TS3=19)		! (36) TS word 3
	INTEGER		CTX_W_TS4
	PARAMETER	(CTX_W_TS4=20)		! (38) TS word 4
	INTEGER		CTX_L_AUX1		
	PARAMETER	(CTX_L_AUX1=11)		! (40) Auxiliary array
	INTEGER		CTX_L_AUX2		
	PARAMETER	(CTX_L_AUX2=12)		! (44) Auxiliary array
	INTEGER		CTX_L_AUX3		
	PARAMETER	(CTX_L_AUX3=13)		! (48) Auxiliary array
	INTEGER		CTX_L_AUX4		
	PARAMETER	(CTX_L_AUX4=14)		! (52) Auxiliary array
	INTEGER		CTX_L_AUX5		
	PARAMETER	(CTX_L_AUX5=15)		! (56) Auxiliary array
	INTEGER		CTX_L_AUX6		
	PARAMETER	(CTX_L_AUX6=16)		! (60) Auxiliary array
	INTEGER		CTX_L_AUX7		
	PARAMETER	(CTX_L_AUX7=17)		! (64) Auxiliary array
	INTEGER		CTX_L_AUX8		
	PARAMETER	(CTX_L_AUX8=18)		! (68) Auxiliary array
	INTEGER		CTX_L_EF
	PARAMETER	(CTX_L_EF=CTX_L_AUX8)	! (68) end of feature
						!      (for PACKCTXD)
	INTEGER		CTX_L_ATTR
	PARAMETER	(CTX_L_ATTR=19)		! (72) Attribute list
	INTEGER		CTX_O_NXTPTR
	PARAMETER	(CTX_O_NXTPTR = 4*(CTX_L_NXTPTR-1))
	INTEGER		CTX_O_PREPTR
	PARAMETER	(CTX_O_PREPTR = 4*(CTX_L_PREPTR-1))
	INTEGER		CTX_O_DESC
	PARAMETER	(CTX_O_DESC = 4*(CTX_L_DESC-1))
	INTEGER		CTX_O_TXTLEN
	PARAMETER	(CTX_O_TXTLEN = CTX_O_DESC)
	INTEGER		CTX_O_DTYPE
	PARAMETER	(CTX_O_DTYPE = CTX_O_TXTLEN + 2)
	INTEGER		CTX_O_DCLASS
	PARAMETER	(CTX_O_DCLASS = CTX_O_DTYPE + 1)
	INTEGER		CTX_O_TXTADDR
	PARAMETER	(CTX_O_TXTADDR = CTX_O_DESC + 4)
	INTEGER		CTX_O_TH
	PARAMETER	(CTX_O_TH   = 4*(CTX_L_TH-1))
	INTEGER		CTX_O_PACK
	PARAMETER	(CTX_O_PACK = CTX_O_TH)
	INTEGER		CTX_O_RO
	PARAMETER	(CTX_O_RO   = 4*(CTX_L_RO-1))
	INTEGER		CTX_O_X
	PARAMETER	(CTX_O_X    = 4*(CTX_L_X-1))
	INTEGER		CTX_O_Y
	PARAMETER	(CTX_O_Y    = 4*(CTX_L_Y-1))
	INTEGER		CTX_O_TS
	PARAMETER	(CTX_O_TS   = 4*(CTX_L_TSA-1))
	INTEGER		CTX_O_AUX
	PARAMETER	(CTX_O_AUX  = 4*(CTX_L_AUX1-1))
	INTEGER		CTX_O_AUXANG
	PARAMETER	(CTX_O_AUXANG  = CTX_O_AUX)
	INTEGER		CTX_O_AUXCOS
	PARAMETER	(CTX_O_AUXCOS  = 4*(CTX_L_AUX2-1))
	INTEGER		CTX_O_AUXSIN
	PARAMETER	(CTX_O_AUXSIN  = 4*(CTX_L_AUX3-1))
	INTEGER		CTX_O_AUXSIZ
	PARAMETER	(CTX_O_AUXSIZ  = 4*(CTX_L_AUX4-1))
	INTEGER		CTX_O_AUXMINX
	PARAMETER	(CTX_O_AUXMINX = 4*(CTX_L_AUX5-1))
	INTEGER		CTX_O_AUXMAXX
	PARAMETER	(CTX_O_AUXMAXX = 4*(CTX_L_AUX6-1))
	INTEGER		CTX_O_AUXMINY
	PARAMETER	(CTX_O_AUXMINY = 4*(CTX_L_AUX7-1))
	INTEGER		CTX_O_AUXMAXY
	PARAMETER	(CTX_O_AUXMAXY = 4*(CTX_L_AUX8-1))
	INTEGER		CTX_O_EF
	PARAMETER	(CTX_O_EF      = CTX_O_AUXMAXY)
	INTEGER		CTX_O_ATTR
	PARAMETER	(CTX_O_ATTR    = 4*(CTX_L_ATTR-1))
	INTEGER		CTXMAX			! max text length
	PARAMETER	(CTXMAX=255)
	INTEGER		END_EDIT	! EDIT point
	PARAMETER	(END_EDIT=3)
	INTEGER		END_INSERT	! INSERT point
	PARAMETER	(END_INSERT=4)
	INTEGER		END_JOIN	! JOIN
	PARAMETER	(END_JOIN=5)
	INTEGER		END_TIE		! TIE
	PARAMETER	(END_TIE=6)
	INTEGER		END_LOOP	! LOOP
	PARAMETER	(END_LOOP=7)
	INTEGER		END_SQUARE	! SQUARE
	PARAMETER	(END_SQUARE=8)
	INTEGER		END_ORIENT	! ORIENT
	PARAMETER	(END_ORIENT=9)
	INTEGER		END_MEND_MANUAL	! MEND MANUAL
	PARAMETER	(END_MEND_MANUAL=10)
	INTEGER		END_MEND_AUTO	! MEND AUTOMATIC
	PARAMETER	(END_MEND_AUTO=11)
	INTEGER		END_IMAGE	! IMAGE MOVE/COPY
	PARAMETER	(END_IMAGE=12)
	INTEGER		END_CONSTRUCT	! construct text or symbol
	PARAMETER	(END_CONSTRUCT=1)
	INTEGER		END_ROTATE	! rotate text or symbol
	PARAMETER	(END_ROTATE=2)	! with cursor
	INTEGER		END_ALIGN	! align scaled symbol
	PARAMETER	(END_ALIGN=3)
	INTEGER		END_STRETCH	! stretch scaled symbol
	PARAMETER	(END_STRETCH=4)
	INTEGER		END_MOVE	! move text or symbol
	PARAMETER	(END_MOVE=5)
	INTEGER		END_BEND	! bend the text
	PARAMETER	(END_BEND=6)
	INTEGER		END_PART	! PART change command
	PARAMETER	(END_PART=1)	! NB used in EDIT state also
	INTEGER		END_WHOLE	! change whole feature
	PARAMETER	(END_WHOLE=2)	! NB used in EDIT state also
	INTEGER		END_INCLUDE	! INCLUDE
	PARAMETER	(END_INCLUDE=3)
	INTEGER		END_MAP		! WINDOW MAP
	PARAMETER	(END_MAP=1)
	INTEGER		END_SCREEN	! WINDOW SCREEN
	PARAMETER	(END_SCREEN=2)
	INTEGER		END_REGION	! REGION n WINDOW
	PARAMETER	(END_REGION=3)
	INTEGER		END_START	! ordinary construction
	PARAMETER	(END_START=1)
	INTEGER		END_BRIDGE	! BRIDGE
	PARAMETER	(END_BRIDGE=2)
	INTEGER		END_BRIDGE_CLOSE ! BRIDGE with CLOSE
	PARAMETER	(END_BRIDGE_CLOSE=3)
	INTEGER		END_PAINT	! only version of IMAGE PAINT
	PARAMETER	(END_PAINT=1)
	INTEGER	GASTI,GSUPPD,GBUNDL,GINDIV,GMETRE,GSUPP,GALWAY
	INTEGER	GNONE,GOK,GNPICK,GNORML,GHILIT,GINVIS,GVISI
	INTEGER	GNCLIP,GCLIP
	INTEGER	GHOLOW,GSOLID,GPATRN,GHATCH
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
	PARAMETER (GHOLOW = 0, GSOLID = 1, GPATRN = 2, GHATCH = 3)
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	INTEGER*4	STATE_INITIAL	! INITIALisation
	PARAMETER	(STATE_INITIAL   =  1)
	INTEGER*4	STATE_READY	! READY for operation
	PARAMETER	(STATE_READY     =  2)
	INTEGER*4	STATE_LINE	! LINE feature found
	PARAMETER	(STATE_LINE      =  3)
	INTEGER*4	STATE_CIRCLE	! CIRCLE feature found
	PARAMETER	(STATE_CIRCLE     = 4)
	INTEGER*4	STATE_TEXT	! TEXT feature found
	PARAMETER	(STATE_TEXT      =  5)
	INTEGER*4	STATE_SYMBOL	! SYMBOL found
	PARAMETER	(STATE_SYMBOL    =  6)
	INTEGER*4	STATE_EDIT	! EDIT line
	PARAMETER	(STATE_EDIT      =  7)
	INTEGER*4	STATE_MODIFY	! MODIFY text / symbol
	PARAMETER	(STATE_MODIFY    =  8)
	INTEGER*4	STATE_ON	! constrain movement ON line
	PARAMETER	(STATE_ON        =  9)
	INTEGER*4	STATE_WINDOW	! WINDOW
	PARAMETER	(STATE_WINDOW    =  10)
	INTEGER*4	STATE_CONSTRUCT	! CONSTRUCT line
	PARAMETER	(STATE_CONSTRUCT = 11)
	INTEGER*4	STATE_AC	! AC edit
	PARAMETER	(STATE_AC        = 12)
	INTEGER*4	STATE_DEBUG	! DEBUG
	PARAMETER	(STATE_DEBUG     = 13)
	INTEGER*4	STATE_RECOVER	! RECOVER feature
	PARAMETER	(STATE_RECOVER   = 14)
	INTEGER*4	STATE_MACRO	! MACRO reading
	PARAMETER	(STATE_MACRO     = 15)
	INTEGER*4	STATE_SETUP	! SETUP of image
	PARAMETER	(STATE_SETUP     = 16)
	INTEGER*4	STATE_PAINT	! PAINTing image
	PARAMETER	(STATE_PAINT     = 17)
	INTEGER*4	MAXSTA		! number of states defined
	PARAMETER	(MAXSTA = 17)
	INTEGER*4	MASK_INITIAL	! INITIALisation
	PARAMETER	(MASK_INITIAL   =  '00040000'X)
	INTEGER*4	MASK_READY	! READY for operation
	PARAMETER	(MASK_READY     =  '08000000'X)
	INTEGER*4	MASK_LINE	! LINE feature found
	PARAMETER	(MASK_LINE      =  '00200000'X)
	INTEGER*4	MASK_CIRCLE	! CIRCLE feature found
	PARAMETER	(MASK_CIRCLE      =  '04000000'X)
	INTEGER*4	MASK_TEXT	! TEXT feature found
	PARAMETER	(MASK_TEXT      =  '20000000'X)
	INTEGER*4	MASK_SYMBOL	! SYMBOL found
	PARAMETER	(MASK_SYMBOL    =  '10000000'X)
	INTEGER*4	MASK_EDIT	! EDIT line
	PARAMETER	(MASK_EDIT      =  '00004000'X)
	INTEGER*4	MASK_MODIFY	! MODIFY text / symbol
	PARAMETER	(MASK_MODIFY    =  '00400000'X)
	INTEGER*4	MASK_ON		! constrain movement ON line
	PARAMETER	(MASK_ON        =  '01000000'X)
	INTEGER*4	MASK_WINDOW	! WINDOW
	PARAMETER	(MASK_WINDOW    =  '80000000'X)
	INTEGER*4	MASK_CONSTRUCT	! CONSTRUCT line
	PARAMETER	(MASK_CONSTRUCT =  '00001000'X)
	INTEGER*4	MASK_AC		! AC edit
	PARAMETER	(MASK_AC        =  '00000400'X)
	INTEGER*4	MASK_DEBUG	! DEBUG
	PARAMETER	(MASK_DEBUG     =  '00002000'X)
	INTEGER*4	MASK_RECOVER	! RECOVER feature
	PARAMETER	(MASK_RECOVER   =  '00010000'X)
	INTEGER*4	MASK_MACRO	! MACRO reading
	PARAMETER	(MASK_MACRO     =  '00000800'X)
	INTEGER*4	MASK_SETUP	! SETUP image
	PARAMETER	(MASK_SETUP     =  '40000000'X)
	INTEGER*4	MASK_PAINT	! PAINTing image
	PARAMETER	(MASK_PAINT     =  '02000000'X)
	INTEGER	CONFUL
	PARAMETER (CONFUL=1000)			! size of CONXY
	INTEGER	CONFLS
	PARAMETER (CONFLS=980)			! size to FLUSH at
	INTEGER MXATTR
	PARAMETER (MXATTR=IFF_MAXCBCOL-2+1)	! size of attribute arrys
	INTEGER	RECT_DIAG,RECT_SIDE
	PARAMETER (RECT_DIAG=1,RECT_SIDE=2)
	INTEGER		CONIND			! last used in CONXY
	REAL		CONXY(2,CONFUL)		! coordinates
	INTEGER		CONLST(CONFUL)		! list of pt attributes
	REAL		CONZ(CONFUL)		! z coordinates
	INTEGER		CONZI(CONFUL)
	EQUIVALENCE	(CONZ,CONZI)
	REAL		COTHIS(2,2)		! first two points
	REAL		COTHISZ(2)		! and their Z's
	INTEGER		CONTH			! thickness entry
						! (for texts)
	INTEGER*4	CONTC			! TC address
	INTEGER*4	CONAC			! AC address
	INTEGER*2	CONFS(4)		! FS entry
	BYTE		CONFLG(CONFUL)		! flags
	LOGICAL		CONFST			! nothing ADCORDed yet
	REAL		CONLEN			! length so far
	INTEGER*4	CONSEG		! no. of polygon segments
	LOGICAL		CONGEN		! generated feature
	LOGICAL		CONRECT		! generated rectangle?
	LOGICAL		CONCIR		! circle (true) or polygon ?
	LOGICAL		CONCLO		! closed (true) or arc ?
	LOGICAL		CONCEN		! centred (true) or circum ?
	LOGICAL		CONDIAG		! diagonal rectangle
	LOGICAL		CONSIDE		! side and point oposite
	LOGICAL		CONCUR		! current point is a curve ?
	LOGICAL		CONINT		! curve interp. not completed ?
	LOGICAL		JUSTIN
	LOGICAL		INCBRD
	LOGICAL		INSRTING
	INTEGER		FIRST_INSERT
	INTEGER		CONATT		! number of attributes
	INTEGER		COATTC(MXATTR)	! attribute codes
	INTEGER		COATTV(MXATTR)	! attribute values
	COMMON/CSTRCT/CONIND,CONXY,CONLST,CONATT,COATTC,COATTV,
     &		CONZ,COTHIS,COTHISZ,
     &	        CONTH,CONTC,CONAC,CONSEG,CONFS,FIRST_INSERT,
     &		CONFLG,CONFST,CONGEN,CONCIR,CONCLO,CONCEN,
     &	        CONCUR,CONINT,JUSTIN,INCBRD,CONRECT,CONDIAG,CONSIDE,
     &	        INSRTING,CONLEN
	INTEGER*4	CTXBUFL(CTXLENL)
	INTEGER*2	CTXBUFW(CTXLENW)
	BYTE		CTXBUFB(CTXLENB)
	REAL*4		CTXBUFR(CTXLENL)
	EQUIVALENCE	(CTXBUFL,CTXBUFW,CTXBUFB,CTXBUFR)
	BYTE		CTXTEXT(CTXMAX+1)   ! 1 byte in case of overflow
	INTEGER*4	CURCTX		! address of entry in buffer
	INTEGER*4	FTRCTXD(CTXDLEN)
	INTEGER*4	COICTXD(CTXDLEN)
	INTEGER*4	IHCTXD(CTXDLEN)
	INTEGER*4	PACKCTXD(CTXDLEN)
	INTEGER		CTX_ZONE
	COMMON/CTXS/CTXBUFL,CURCTX,CTXTEXT,
     &	            FTRCTXD,COICTXD,IHCTXD,PACKCTXD,CTX_ZONE
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
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
	REAL*8		LINWDTH_FCTR
	PARAMETER	(LINWDTH_FCTR = 5.0E-7)
	REAL*8		LINWDTH		! the "width of a line" -
					! used for comparison with zero
	REAL		CSXY(3)		! current cursor position
	INTEGER		CSZI		! Z value of cursor position (as
					! INTEGER)
	EQUIVALENCE	(CSXY(3),CSZI)	! equivalenced
	REAL		XSECTW,YSECTW	! sector widths
	REAL		XOFF,YOFF	! SW corner of sector grid
	REAL		LIMITS(4)	! extent of sector grid
	REAL*8		ABS_LIMITS(4)	! absolute range of maps
	LOGICAL		HAD_RANGE_CMD	! true when had RANGE command 
	INTEGER XRANGE,YRANGE	! number of sectors in the y- and x-axes
	INTEGER	TOPSEC		! last sector being used
	INTEGER	NDMODE		! end mode - what to do on END command
	INTEGER	LASBUT		! last button used ($BUTTON)
	REAL	WINXY(2)	! saved SW corner of window
	INTEGER	WINREG		! region number for REGION n WINDOW
	LOGICAL	SCSARC		! constrain on arc/line?
	REAL	SCSAUX(5)	! aux array if circle (should use AUXLEN,
				!  but can't face including AUXDEF
	REAL	SCSTXY(2,2)	! ends of constraint line
	INTEGER	CUST		! customer number (as in map header)
				! = 0 for unknown
				! = 1 for MCE
				! = 2 for OS 
				! etc
	INTEGER	OTHFLG		! value to be set in PAKFLG for flushed
				! features when FSHCTR is TRUE
	LOGICAL	FSHCTR		! TRUE  when OTHFLG to be used in FLUSH
				! FALSE otherwise
	LOGICAL	CHASEL		! true if selections have been changed
	LOGICAL	ROLING		! cursor is constrained
	LOGICAL	POSCMD		! .TRUE. when last command was a
				! positioning command (FIND, VERTEX
				! etc)
	LOGICAL	SETING		! setup raster registration
	LOGICAL	FINDNG		! finding (set in FINREC - used in SCNSEC)
	LOGICAL	PNTING		! doing IMAGE PAINT
	INTEGER*4 RAN_SEED	! seed value for random number generator
	INTEGER	PRIV_ATTR_LIST	! list of attributes that may not be altered
	INTEGER	PRIV_PT_LIST	! list of attibutes of privileged points
	REAL	FAR_MOVE_MM	! tolerance for FAR_MOVE (mm)
	REAL	FAR_MOVE_IFF	! tolerance for FAR_MOVE (iff units)
	REAL	FORCE_COEFFS(4)	! defining plane
	REAL	FORCE_HEIGHT	! height of original point
	LOGICAL	FORCE_C_SETUP	! OK to use plane?
	LOGICAL	FORCE_H_SETUP	! OK to use height?
	INTEGER		ASK_INT_TOT
	PARAMETER	(ASK_INT_TOT = 3)
	INTEGER		ASK_REAL_TOT
	PARAMETER	(ASK_REAL_TOT = 3)
	INTEGER		ASK_CHAR_TOT
	PARAMETER	(ASK_CHAR_TOT = 2)
	INTEGER		ASK_INT(ASK_INT_TOT)	! value for system variable $ASK_INT
	INTEGER		ASK_CHAR(2,ASK_CHAR_TOT)! value for system variable $ASK_CHAR
						! (dynamic descriptor)
	REAL		ASK_REAL(ASK_REAL_TOT)
	INTEGER		ASK_INT_NUM
	INTEGER		ASK_REAL_NUM
	INTEGER		ASK_CHAR_NUM
	COMMON /MASTER/ ABS_LIMITS,LINWDTH,
     &			CSXY,XSECTW,YSECTW,XOFF,YOFF,LIMITS,
     &			XRANGE,YRANGE,TOPSEC,NDMODE,WINXY,SCSTXY,
     &			CUST,OTHFLG,LASBUT,RAN_SEED,PRIV_ATTR_LIST,
     &	                PRIV_PT_LIST,FORCE_COEFFS,FORCE_HEIGHT,
     &			FAR_MOVE_MM,FAR_MOVE_IFF,
     &	                ASK_INT,ASK_CHAR,ASK_REAL,
     &			ASK_INT_NUM,ASK_CHAR_NUM,ASK_REAL_NUM,
     &			FSHCTR,CHASEL,ROLING,POSCMD,SETING,
     &	                FORCE_C_SETUP,FORCE_H_SETUP,
     &			FINDNG,HAD_RANGE_CMD,
     &			WINREG,PNTING,
     &			SCSARC,SCSAUX
	REAL		MODCXY(2,2)	! old cursor position at start
					! (and end) of feature
	REAL		DIST		! size of feature (if scaled
					! symbol)
	LOGICAL*1	MODMOD		! flag to say if feature has
					! been modified
	LOGICAL*1	DELOIH		! .TRUE. if object in hand is to
					! be deleted on end
	LOGICAL*1	NEWFEAT		! .TRUE. if object in COI
					! variables is a new feature
	LOGICAL*1	SUBTXT		! .TRUE. when dealing with a
					! component of a text
	LOGICAL*1	BNDSTR		! .TRUE. for BEND STRETCH
					! otherwise BEND NORMAL
	REAL		BENDXY(2)	! position to start bent texts at
	INTEGER		BENDMAP,BENDPNF	! for making sure that same 
					! found object is used at end
	LOGICAL*1	BNDFWD		! .TRUE. if bending forward along
					! linear objects
	COMMON	/MODIFY/MODCXY,DIST,BENDXY,BENDMAP,BENDPNF,
     &			MODMOD,DELOIH,NEWFEAT,SUBTXT,BNDSTR,BNDFWD
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	PARAMETER OIFULL = 201
	PARAMETER LNFAKE = 255
	INTEGER		OIH_MAX_ATTR	! maximum size of CB arrays
	PARAMETER	(OIH_MAX_ATTR = IFF_MAXCBCOL-2)
	REAL		COIXY(2,OIFULL)		! coordinates
	REAL		COPY_COIXY(2,OIFULL)  	! coordinates (for fly trans)
	REAL		COIZ(OIFULL)		! heights
	INTEGER		COIZI(OIFULL)		! (as integers)
	EQUIVALENCE	(COIZ,COIZI)
	INTEGER		COINATT			! number of attributes
	INTEGER		COIATTC(OIH_MAX_ATTR)	! attribute codes
	INTEGER		COIATTV(OIH_MAX_ATTR,OIFULL) ! attribute values
	LOGICAL		COIOVR			! attributes overflowed
	REAL		COIAUX(AUXLEN)		! auxiliary array
	REAL		COIANG			! angle
	INTEGER*4	COIPAK(PAKLEN)		! data pack
	INTEGER		COIIND			! last used in COIXY
	INTEGER		COILST			! total number of points
	REAL		COICOEFFS(4)		! plane of circle arcs
	LOGICAL		COIC_DEFINED		! set up
	INTEGER		LSTSEC			! saved sector
	INTEGER*4	LSTPST			! pointer to last ST
	INTEGER		LSTVRT			! and vertex of last ST
	INTEGER		COIFC			! fc for feature - texts
	INTEGER*2	COIFS(4)		! FS entry (for texts)
	INTEGER*4	OIPST			! pointer to ST
	INTEGER*2	OIENDS			! ST ENDS word
	LOGICAL*1	COIFST			! first bit of feature
	LOGICAL*1	HADRO			! had a rotation
	LOGICAL*1	HADTX			! had a text
	LOGICAL*1	OIDRAW			! draw the item?
	LOGICAL*1	OILOOP			! is curve a loop?
	LOGICAL*1	USEINP			! use input file only?
	LOGICAL*1	COMTXT			! composite text
	LOGICAL*1	FROM_IFFBDY		! TRUE when FLUSH 
						! called from IFFBDY
	INTEGER*2	COILEN		! descriptor  (length)
	INTEGER*2	COITYP		!     "       (undefined)
	INTEGER*4	COIADR		!     "       (buffer address)
	INTEGER*2	COIDSC(4)	!     "
	BYTE		COIBUF(LNFAKE+1)	! buffer
	EQUIVALENCE	(COIDSC(1),COILEN),(COIDSC(2),COITYP),
     &			(COIDSC(3),COIADR)
	COMMON/OIIH/COIXY,COIAUX,COINATT,COIATTC,COIATTV,COIOVR,
     &	        COICOEFFS,COIZ,COIANG,COIPAK,
     &		COIIND,COILST,LSTSEC,COIC_DEFINED,
     &		LSTPST,LSTVRT,OIPST,COIDSC,COIFC,COIFS,OIENDS,
     &		COIFST,HADRO,HADTX,OIDRAW,OILOOP,USEINP,COIBUF,COMTXT,
     &		COPY_COIXY,FROM_IFFBDY			! align
	REAL		OCSXY(2)	! old cursor position
	REAL		RUBARR(2,2)	! rubber band positions
	INTEGER		RFFULL	! (preset) number to refresh
	INTEGER		RFOFF	! (preset) target within RFFULL
	INTEGER		RFCRIT	! (preset) distance of cursor to end
	INTEGER*4	RFFSEG	! segment number of refreshed found item
	INTEGER		RFFVO	! vertex offset of refreshed found item
	INTEGER		RFFOFF	! vertex offset of actual refresh bit
	INTEGER		RFFTOP	! number of refreshed vertices
	INTEGER*4	RFFCTX	! address of CTX that has cursor on it
	INTEGER*4	RFHSEG	! refreshed object in hand segment
	INTEGER		RFHOFF	! vertex offset of actual refresh bit
	INTEGER		RFHTOP	! number of refreshed vertices
	INTEGER		RFCIND	! refreshed construction index
	LOGICAL		CURS	! true if cursor required
	LOGICAL		INTCUR	! true if cursor position initialised
	LOGICAL		RFCURS	! true if cursor presently drawn
	LOGICAL		RFFLIM	! refreshed found item is in limbo
	LOGICAL		REFNG	! true while executing RFDRAW
	LOGICAL*1	RUBLIN(2)	! want rubber bands?
	LOGICAL		RUBCHG	! rubber bands changed?
	LOGICAL		RFMOD	! have a 'modification' in refresh
	LOGICAL		RFRUB	! have rubber band in refresh
	LOGICAL		RFBIG	! got big cursor
	LOGICAL		RFBNK	! got blinking cursor
	LOGICAL		RFCSEG	! true if cursor segment exists
	LOGICAL		RFLSEG	! true if F/L segment exits
	LOGICAL		RFHSEP	! true separate segment for IH
	LOGICAL		RFFSEP	! true separate segment for FO
	INTEGER		RFCTYP	! cursor type
	REAL		RFCARG(2) ! additional cursor arguments
	INTEGER		RFCOL	! bit mask (colour)
	COMMON/RFCTRL/OCSXY,RUBARR,
     &	        RFFULL,RFOFF,RFCRIT,
     &		RFFSEG,RFFVO,RFFOFF,RFFTOP,
     &		RFHSEG,RFHOFF,RFHTOP,RFCIND,RFFCTX,
     &		CURS,INTCUR,RFCURS,RFFLIM,REFNG,
     &		RUBCHG,RFMOD,RFRUB,RFBIG,RFBNK,RFCSEG,RFLSEG,
     &		RFHSEP,RFFSEP,
     &		RFCTYP,RFCARG,RUBLIN,RFCOL
	INTEGER*4	SSM		! max. state string length
	PARAMETER	(SSM = 16)
	INTEGER*4	STAMSK(MAXSTA)	! all state masks
	INTEGER*4	STACHS(MAXSTA)	! all state name lengths
	INTEGER*4	SMASK		! current state flag mask
	INTEGER*4	SINDEX		! current state index
	INTEGER*4	STALEN		! current state name lengths
	CHARACTER*(SSM)	STANAM(MAXSTA)	! all state names
	CHARACTER*(SSM)	STASTR		! current state name
	COMMON/STATE/STAMSK,STACHS,SMASK,SINDEX,STALEN
	COMMON/STACH/STANAM,STASTR
	INTEGER	OBJDEP,FOFULL,FOVOFF,FOCRIT,IHFULL,RIFULL
	PARAMETER	(OBJDEP=4)	! max number of struck objects
	PARAMETER	(FOFULL=1000)	! size of FOXY
	PARAMETER	(FOVOFF=FOFULL/2)	! centre of FOXY
	PARAMETER	(FOCRIT=10)	! minimum distance from ends
	PARAMETER	(IHFULL=1000)	! size of IHXY
	PARAMETER 	(RIFULL=200)	! size of RIXY
	INTEGER		STR_MAX_ATTR	! maximum size of CB arrays
	PARAMETER	(STR_MAX_ATTR = IFF_MAXCBCOL-2)
	INTEGER HITITC,HITITE,HITITP,WORST,BEST
	INTEGER QUORD(OBJDEP)
	INTEGER*4	OBJPAK( PAKLEN, OBJDEP )
	REAL		OBJAUX(AUXLEN,OBJDEP)	! auxiliary array
	INTEGER		OBJPTR(OBJDEP)		! lengths of texts
	CHARACTER*255	OBJTXT(OBJDEP)		! texts themselves
	REAL 		HITRAD(OBJDEP)		! squares of hit radii
	REAL 		OBJCXY(3,OBJDEP)	! cursor positions
	LOGICAL 	OBJNVT(OBJDEP)		! true if on vertex
	LOGICAL		OBJSTRT(OBJDEP)		! true if at start of arc
	LOGICAL		OBJEND(OBJDEP)		! true if at end of arc
	INTEGER*4	FOPAK(PAKLEN)
	REAL		FOAUX(AUXLEN)
	INTEGER		FOPTR		! length of text
	CHARACTER*255	FOTXT		! text itself
	REAL		FOCXY(3)	! cursor position
	INTEGER		FOCZI		! (as an integer)
	EQUIVALENCE	(FOCZI,FOCXY(3))
	REAL 		FOXY(2,FOFULL)	! some coordinates
	REAL		FOZ(FOFULL)
	INTEGER		FOZI(FOFULL)
	EQUIVALENCE	(FOZ,FOZI)
	INTEGER		FONATT		! number of attributes
	INTEGER		FOATTC(STR_MAX_ATTR)	! attribute codes
	INTEGER		FOATTV(STR_MAX_ATTR,FOFULL)! attribute values
	BYTE		FOFLG(FOFULL)	! flags
	INTEGER		FO_Z_COL	! z column index
	INTEGER*4	FOTC		! TC address (or 0)
	INTEGER*4	FOTCND		! end of TCs
	INTEGER*4	FOAC		! AC address (or 0)
	INTEGER*4	FOACND		! end of ACs
	INTEGER*4	FOEF		! EF address
	INTEGER		FOVO		! vertex offset of FOXY
	INTEGER		FOTOP		! last used index of FOXY
	INTEGER 	FOTH		! thickness
	INTEGER*2	FOFS(4)		! FS entry
	INTEGER		FOLST		! last vertex number
	INTEGER		FOVRT		! current vertex
	INTEGER		FOFC		! feature code of FO
	REAL		FOTHIS(3)	! coordinates of first vertex
	REAL		FOTHAT(3)	! coordinates of last vertex
	LOGICAL 	FONVRT		! true if on vertex
	LOGICAL		FOSTRT		! true when on start of arc
	LOGICAL		FOEND		! true when on end of arc
	LOGICAL 	FONLIN		! true if cursor on line
	LOGICAL 	FO		! true if we have a found object
	REAL		FOARCBX(4)	! limiting box for arc
	REAL		FOCOEFFS(4)	! plane of circle arcs
	LOGICAL		FOC_DEFINED	! set up
	REAL		FMCXY(3)	! cursor position
	INTEGER		FMCZI		! (as an integer)
	EQUIVALENCE	(FMCZI,FMCXY(3))
	INTEGER		FMVRT		! marked vertex
	LOGICAL 	FMNVRT		! true if on vertex
	LOGICAL		FMSTRT		! true if on start of arc
	LOGICAL		FMEND		! true if on end of arc
	INTEGER*4	IHPAK( PAKLEN )	! a data pack
	REAL		IHAUX( AUXLEN )	! auxiliary array
	INTEGER		IHPTR		! length of text
	CHARACTER*255	IHTXT		! text itself
	REAL		IHCXY(3)	! cursor position
	INTEGER		IHCZI		! and Z as an integer
	EQUIVALENCE	(IHCXY(3),IHCZI)
	REAL		IHXY(2,IHFULL)	! coordinates
	BYTE		IHFLG(IHFULL)	! flags
	REAL		IHZ(IHFULL)	! array of Z values for clipping
	INTEGER		IHZI(IHFULL)	! integer equivalent
	EQUIVALENCE	(IHZ,IHZI)
	INTEGER*4	IHTC		! TC address (or 0)
	INTEGER*4	IHAC		! AC address (or 0)
	INTEGER*4	IHEF		! EF address
	INTEGER		IHVO		! vertex offset of IHXY
	INTEGER		IHTOP		! last used index of IHXY
	INTEGER 	IHTH		! TH value
	INTEGER*2	IHFS(4)		! FS entry
	INTEGER		IHLST		! last vertex number
	INTEGER		IHVRT		! current vertex
	INTEGER		IHFC		! feature code
	LOGICAL 	IHNVRT		! true if on vertex
	LOGICAL		IHSTRT		! true when on start of arc
	LOGICAL		IHEND		! true when on end of arc
	LOGICAL 	IH		! true if object in hand
	REAL		IHCOEFFS(4)	! plane of circle arcs
	LOGICAL		IHC_DEFINED	! set up
	REAL		IMCXY(3)	! cursor position
	INTEGER		IMCZI		! and Z as an integer
	EQUIVALENCE	(IMCXY(3),IMCZI)
	INTEGER		IMVRT		! marked vertex
	LOGICAL	 	IMNVRT		! true if on vertex
	LOGICAL		IMSTRT		! true if on start of arc
	LOGICAL		IMEND		! true if on end of arc
	REAL		RIXY(2,RIFULL+1)! coordinates
	INTEGER		RINATT		! number of attributes
	INTEGER		RIATTC(STR_MAX_ATTR+1)	! attribute codes
	INTEGER		RIATTV(STR_MAX_ATTR+1,RIFULL+1)! attribute values
	BYTE		RIFLG(RIFULL+1)	! flags
	REAL		RIZ(RIFULL+1)	! array of Z values for FIND
	INTEGER		RIZI(RIFULL+1)	! integer equivalent
	EQUIVALENCE	(RIZ,RIZI)
	INTEGER		RI_Z_COL	! z column number
	INTEGER		RIMAP		! current read-in map
	INTEGER		RIPNF		! and NF pointer
	INTEGER		RIVO		! vertex offset
	INTEGER		RITOP		! last used index
	REAL CONTXY(2)
	REAL 		DSCRIT
	REAL 		DFCRIT
	REAL 		EFCRIT
	REAL 		CRITR2
	INTEGER		FNDSEC
	INTEGER 	NFRSTN
	INTEGER		MPRSTN
	INTEGER		FTXPTR
	CHARACTER*255	FTXCHR
	LOGICAL		SEADEL
	INTEGER*4	LASPAK,SEAPAK
	INTEGER		FNDMDE
	LOGICAL 	NSCND,NVRTX
	INTEGER		ITVRT
	LOGICAL 	CSSTIL
	LOGICAL 	SPIRAL
	LOGICAL 	INSPIR
	LOGICAL 	RECVRD
	LOGICAL 	MATFC
	LOGICAL 	MATFSN
	LOGICAL 	MATLAY
	LOGICAL 	MATMAP
	LOGICAL 	MATPC
	LOGICAL		MATAC
	LOGICAL 	JOINNG
	LOGICAL 	MENDNG
	LOGICAL 	FINDND
	LOGICAL 	JOIFST
	LOGICAL		SRCHNG
	LOGICAL		SEANEA
	COMMON/STRIKE/HITITC,HITITE,HITITP,WORST,QUORD,OBJPAK,OBJAUX,
     &		OBJPTR,HITRAD,OBJCXY,
     &		FOPAK,FOAUX,FOARCBX,FOPTR,FOCXY,FOTC,FOTCND,FOAC,
     &		FOACND,FOEF,FOXY,FOVO,FO_Z_COL,
     &	        FOCOEFFS,FOZ,
     &		FONATT,FOATTC,FOATTV,
     &	        FOTOP,FOTH,FOTHIS,FOTHAT,
     &		FOLST,FOVRT,FMCXY,FMVRT,
     &	        IHPAK,IHAUX,IHPTR,IHCXY,IHCOEFFS,IHZ,IHTC,IHAC,IHEF,
     &		IHXY,IHVO,IHTOP,IHTH,IHLST,IHVRT,IMCXY,IMVRT,FOFC,IHFC,
     &	        RIXY,RIZ,RINATT,RIATTC,RIATTV,RIMAP,RIPNF,RIVO,RITOP,
     &	        RI_Z_COL,
     &		CONTXY,DSCRIT,DFCRIT,EFCRIT,CRITR2,FNDSEC,NFRSTN,FTXPTR,
     &		ITVRT,LASPAK,SEAPAK,FNDMDE,
     &		FOFS,IHFS,
     &		FOC_DEFINED,IHC_DEFINED,
     &		OBJNVT,FOFLG,FONVRT,FO,FMNVRT,IHFLG,IHNVRT,IH,IMNVRT,
     &		RIFLG,NSCND,NVRTX,CSSTIL,SPIRAL,INSPIR,RECVRD,FONLIN,
     &		MATFC,MATFSN,MATLAY,MATMAP,MATPC,MATAC,
     &		JOINNG,FINDND,JOIFST,SRCHNG,SEADEL,MENDNG,
     &		OBJSTRT,OBJEND,FOSTRT,FOEND,IHSTRT,IHEND,
     &		FMSTRT,FMEND,IMSTRT,IMEND,SEANEA,
     &		BEST,MPRSTN
	COMMON/STRCHR/OBJTXT,FOTXT,IHTXT,FTXCHR
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	LOGICAL*1	CHFSN
	INTEGER		NEWFSN
	LOGICAL*1	CHFC
	INTEGER		NEWFC
	INTEGER		NEWGT
	LOGICAL*1	CHPC
	INTEGER		NEWPC
	LOGICAL*1	CHMAP
	INTEGER		NEWMAP
	LOGICAL*1	CHLAY
	INTEGER		NEWLAY
	LOGICAL*1	CHPOS
	REAL		CHCSXY(3)
	INTEGER		CHCZI
	EQUIVALENCE	(CHCZI,CHCSXY(3))
	LOGICAL*1	CHOFF
	REAL		OFFDIS
	LOGICAL*1	CHREV			! reverse
	LOGICAL*1	LIMBO			! put into limbo
	LOGICAL*1	RECOVR			! recover from limbo
	LOGICAL*1	CHCOPY			! change copy of object
	LOGICAL*1	REFLSH			! needs re-flushing
	LOGICAL*1	CLREDT			! clear edit flag
	LOGICAL*1	SETEDT			! set edit flag
	LOGICAL*1	CHTRAN			! transform
	LOGICAL*1	CHFILT			! filter
	COMMON/VARIAT/
     &		NEWFSN,NEWFC,NEWGT,NEWPC,NEWMAP,NEWLAY,CHCSXY,OFFDIS,
     &		CHFSN,CHFC,CHPC,CHMAP,CHLAY,CHPOS,CHOFF,CHREV,LIMBO,
     &		RECOVR,CHCOPY,REFLSH,CLREDT,SETEDT,CHTRAN,CHFILT
	LOGICAL		FRTFND
	REAL	X,Y			! temporary coordinates
	INTEGER	WKID
	INTEGER	I
	CHARACTER*1 CHAR
	INTEGER*2 DUMMYE		! dummy I*2 variable
	LOGICAL*1 DUMMYL		! dummy L*1 variable
	LOGICAL*1 TEKFLS		! flush TEK (cursor moved)
	LOGICAL*1 VSFLS			! ARGS (cursor moved)
	DATA	DUMMYE,DUMMYL/0,.TRUE./
	IF (NODISP) GOTO 999
	TEKFLS = .FALSE.		! don't need to flush TEK
	VSFLS = .FALSE.			! or ARGS
	IF (CURS) THEN			! yes
	   IF (.NOT.INTCUR) THEN	! not initialised yet
	      CSXY(1) = (WINDOW(1)+WINDOW(2))/2.0
	      CSXY(2) = (WINDOW(3)+WINDOW(4))/2.0
	      INTCUR = .TRUE.
	      GOTO 10
	   ENDIF
	   IF (CSXY(1).EQ.OCSXY(1) .AND. CSXY(2).EQ.OCSXY(2)) GOTO 20
10	   IF (SINDEX.EQ.STATE_WINDOW) RUBCHG = .TRUE.
	   IF (SINDEX.EQ.STATE_EDIT.AND.CHPOS) RUBCHG = .TRUE.
	   DO 15 WKID=1,WSMAX
	      IF (.NOT.WKAC(WKID)) GOTO 15
	      CALL GKSW2D(WKID,CSXY(1),CSXY(2),X,Y)
	      GOTO (17,18),WKID
17	      IF (WTYPES(1).NE.4014) CALL CSWT(X,Y)		! TEK
	      TEKFLS = .TRUE.		! need to flush
	      GOTO 15
18	      CALL VSCSWT(X,Y)		! ARGS
	      VSFLS = .TRUE.
15	   CONTINUE
	   OCSXY(1) = CSXY(1)
	   OCSXY(2) = CSXY(2)
20	   IF (.NOT.RFCURS) THEN
	      IF (WKAC(2)) CALL VSCURS(1)
	      RFCURS = .TRUE.
	      IF (WKAC(1)) GOTO 450
	   ENDIF
	ELSE
	   IF (RFCURS) THEN
	      IF (WKAC(2)) CALL VSCURS(0)
	      RFCURS = .FALSE.
	      IF (WKAC(1)) GOTO 450
	   ENDIF
	ENDIF
	IF (RFBIG.NEQV.BIGOPT.OR.RFBNK.NEQV.BNKOPT) GOTO 450
	IF (FO) THEN			! there is a found object
	   IF (RFFSEG.EQ.0) GOTO 450	! none drawn
	   IF ( RFFSEG.NE.FOPAK(PAKSEG).OR.	! not same item or
     &		RFFVO.NE.FOVO) GOTO 450		! different vertices
	   IF (FOVRT-RFFOFF.LE.RFCRIT) THEN	! want earlier
	      IF (RFFOFF.GT.FOVO) GOTO 450	! more available
	   ELSEIF (FOVRT-RFFOFF.GT.RFFTOP-RFCRIT) THEN	! want later
	      IF (RFFOFF+RFFTOP.LT.FOVO+FOTOP) GOTO 450	! available
	   ENDIF
	   IF (FOPAK(PAKGT).EQ.TEXTYP.AND.
     &	               (RFFCTX.NE.FTRCTXD(CTXD_HOME))) GOTO 450
	ELSE				! no found object
	   IF (RFFSEG.EQ.0) GOTO 100	! and none drawn
	   IF (IH.AND.RFFSEG.EQ.IHPAK(PAKSEG)) THEN	! now in hand
	      RFHOFF = RFFOFF
	      RFHTOP = RFFTOP
	      RFFSEG = 0
	   ENDIF
	   GOTO 450
	ENDIF
100	IF (.NOT.IH) THEN		! no object in hand
	   IF (RFHSEG.NE.0) GOTO 450	! but one drawn
	ENDIF
	IF (((SINDEX.EQ.STATE_CONSTRUCT).OR.
     &	     (SINDEX.EQ.STATE_ON.AND.NDMODE.EQ.END_INCLUDE)).AND.
     &	      CONIND.NE.0) THEN
	   IF (RFCIND.EQ.0) GOTO 450		! no construction drawn
	   IF (CONIND.NE.RFCIND) GOTO 450	! construction changed
	ELSE					! not constructing
	   IF (RFCIND.NE.0) GOTO 450		! but something drawn
	ENDIF
	IF ((SINDEX.EQ.STATE_READY.OR.SINDEX.EQ.STATE_MODIFY).AND.
     &		MODMOD) THEN
	   MODMOD=.FALSE.
	   GOTO 450
	ENDIF
	IF (RUBCHG) GOTO 450		! yes
	IF (WKAC(1).AND.WTYPES(1).EQ.4014) THEN	! move alpha cursor
	   CALL GKSW2D(1,CSXY(1),CSXY(2),X,Y)
	   CALL MOVTO(X,Y)
	   CALL LDFLSH
	   CALL LDWAIT
	ELSEIF (TEKFLS) THEN
	   CALL LDWAIT		! flush TEK (cursor and RB lines)
	ENDIF
	IF (VSFLS.AND.(RUBLIN(1).OR.RUBLIN(2))) THEN
	   CALL VSDEF(2,1,5)
	   CALL VSPIC(2)
	   CALL VSCLR(2)
	   OVCOL = 1
	   FRTARE = .FALSE.		! not an area
	   FRTSYM = .FALSE.		! or a symbol
	   FRTTEX = .FALSE.		! or a text
	   FRTFC = -1			! invalidate FRTCOM
	   CALL SETCOL			! set polyline colour
	   CALL RFBAND(2)
	   OVCOL = -1
	   CALL GUWK(2,GSUPP)		! should acheive a VSGEN
	   CALL VSPIC(1)
	   CALL VSDEF(2,4,4)
	ENDIF
	GOTO 999			! nothing changed
450	REFNG = .TRUE.			! now refreshing
	IF (WKAC(1).AND.WTYPES(1).NE.4014) THEN
	   CALL DISMOD(1)		! select refresh
	   IF (RFBIG.NEQV.BIGOPT) THEN
	      IF (BIGOPT) THEN
	         CALL CURSEL(1)
	      ELSE
	         CALL CURSEL(0)
	      ENDIF
	   ENDIF
	   IF (RFCURS) THEN
	      IF (BNKOPT) THEN
	         CALL RFBLNK('5555'X)
	      ELSE
	         CALL RFBEND
	      ENDIF
	      CALL CURSOR		! add cursor
	   ENDIF
	ENDIF
	IF (WKAC(2)) THEN
	   CALL VSCLR(2)		! clear refresh
	   CALL VSPIC(2)		! select refresh picture
	ENDIF
	RFBIG = BIGOPT
	RFBNK = BNKOPT
	RFFSEG = 0
	RFHSEG = 0
	RFCIND = 0
	THKSAV = THKOPT
	AKISAV = CUROPT
	PATSAV = PATOPT
	OVCOL = 1			! overriding colour 1
	THKOPT = .FALSE.
	CUROPT = .FALSE.
	PATOPT = .FALSE.
	IF (WKAC(2)) THEN		! set overriding colour for ARGS
	   FRTARE = .FALSE.		! not an area
	   FRTSYM = .FALSE.		! or a symbol
	   FRTTEX = .FALSE.		! or a text
	   FRTFC = -1			! invalidate FRTCOM
	   CALL SETCOL			! set polyline colour
	ENDIF
	IF (FO) THEN			! there is a found item
	   IF (WKAC(1).AND.WTYPES(1).NE.4014) CALL RFBLNK('5555'X)
	   RFFOFF = MIN(FOVRT-RFOFF,	! to place FOVRT at RFOFF
     &			FOLST-RFFULL)	! to place last vertex at RFFULL
	   RFFOFF = MAX(RFFOFF,FOVO)	! force into FOXY
	   RFFTOP = MIN(RFFULL,FOTOP+FOVO-RFFOFF)
	   IF (	FOPAK(PAKGT).EQ.LINTYP .OR.
     &		FOPAK(PAKGT).EQ.CURTYP .OR.
     &		FOPAK(PAKGT).EQ.STRTYP .OR.
     &		FOPAK(PAKGT).EQ.ARETYP ) THEN
	      FRTARE = .FALSE.		! refresh area as line
	      FRTFC = -1		! invalidate FRTCOM
	      CALL STDBFF(0)		! clear buffer
	      CALL STDBFA(RFFTOP,FOXY(1,RFFOFF+1-FOVO),
     &	                  FOZI(RFFOFF+1-FOVO)) ! add points
	      CALL STDBFF(2)		! flush them out
	      DO 515 WKID=1,WSMAX
	         IF (.NOT.WKAC(WKID)) GOTO 515
	         IF (WTYPES(WKID).EQ.4014) GOTO 515
	         DO 519 I=0,1
	            IF (I.EQ.0) THEN
	               CALL GKSW2D(WKID,FOTHAT(1),FOTHAT(2),X,Y)
	               CHAR = 'L'
	            ELSE
	               CALL GKSW2D(WKID,FOTHIS(1),FOTHIS(2),X,Y)
	               CHAR = 'F'
	            ENDIF
	            GOTO (517,518),WKID
517	            CALL MOVTO(X,Y)		! TEK
	            CALL CHARS(CHAR)
	            GOTO 519
518	            CALL VSMTO(X,Y)		! ARGS
	            CALL VSCHRS(CHAR)
519	         CONTINUE
515	      CONTINUE
	   ELSE
	      IF (FRTFND(FOPAK(PAKFC))) THEN
	         CALL NASTY(MSG_BADCODE,FOPAK(PAKFC))
	         CALL COLAPS(MSG_BADCODE)
	      ENDIF
	      IF (FRTTEX) THEN				! draw text
	         CALL BOXCTX(FTRCTXD,FOPAK,.FALSE.,
     &	                  FTRCTXD(CTXD_NCTX).GT.1)
	         RFFCTX = FTRCTXD(CTXD_HOME)
	      ELSE					! draw symbols
	         CALL STDRAW(				! and circles	
     &		FOTOP,FOXY,FONATT,STR_MAX_ATTR,FOATTC,FOATTV,
     &		FOAUX,FOTXT(1:MAX(1,FOPTR)),
     &		DUMMYL,DUMMYL,DUMMYE,DUMMYL,FOPAK,FOFS)
	      ENDIF
	   ENDIF
	   RFFSEG = FOPAK(PAKSEG)	! have a found object refreshed
	   RFFVO = FOVO			! its vertex offset
	   IF (WKAC(1).AND.WTYPES(1).NE.4014) CALL RFBEND
	ENDIF
	IF (IH.AND.SINDEX.NE.STATE_MODIFY) THEN ! there is an
						!  object in hand
						!  that needs redrawing
	   IF (	IHPAK(PAKGT).EQ.LINTYP .OR.
     &		IHPAK(PAKGT).EQ.CURTYP .OR.
     &		IHPAK(PAKGT).EQ.STRTYP .OR.
     &		IHPAK(PAKGT).EQ.ARETYP ) THEN
	      FRTARE = .FALSE.		! refresh area as line
	      FRTFC = -1		! invalidate FRTCOM
	      IF (SINDEX.EQ.STATE_EDIT.AND.CHPOS) THEN
	         CALL RFMOVE		! moving
	      ELSE
	         CALL STDBFF(0)		! clear buffer
	         CALL STDBFA(RFHTOP,IHXY(1,RFHOFF+1-IHVO),
     &	                     IHZ(RFHOFF+1-IHVO)) ! add points
	         CALL STDBFF(2)		! flush them out
	      ENDIF
	   ELSE
	      IF (FRTFND(IHPAK(PAKFC))) THEN
	         CALL NASTY(MSG_BADCODE,IHPAK(PAKFC))
	         CALL COLAPS(MSG_BADCODE)
	      ENDIF
	      IF (FRTTEX) THEN				! draw texts
	         CALL BOXCTX(IHCTXD,IHPAK,.FALSE.,
     &	                     IHCTXD(CTXD_NCTX).GT.1)
	      ELSE
	         CALL STDRAW(		! draw symbols and circles
     &		IHTOP,IHXY,0,1,0,0,IHAUX,IHTXT(1:MAX(1,IHPTR)),
     &		DUMMYL,DUMMYL,DUMMYE,DUMMYL,IHPAK,IHFS)
	      ENDIF
	   ENDIF
	   RFHSEG = IHPAK(PAKSEG)	! have object in hand refreshed
	ENDIF
	IF (((SINDEX.EQ.STATE_CONSTRUCT).OR.
     &	     (SINDEX.EQ.STATE_ON.AND.NDMODE.EQ.END_INCLUDE)).AND.
     &	      CONIND.GT.0) THEN
	   IF (CONIND.GT.1) THEN	! can't refresh a single point
	      FRTARE = .FALSE.		! refresh area as line
	      FRTFC = -1		! invalidate FRTCOM
	      CALL STDBFF(0)		! clear buffer
	      RFCIND = MIN(CONIND,RFFULL) ! number to refresh
	      CALL STDBFA(RFCIND,CONXY(1,CONIND-RFCIND+1), ! add points
     &	                        CONZ(CONIND-RFCIND+1))
	      CALL STDBFF(2)		! flush them out
	   ENDIF
	   RFCIND = CONIND		! have refreshed construction
	   RUBLIN(1) = .TRUE.
	   RUBARR(1,1) = CONXY(1,CONIND)
	   RUBARR(2,1) = CONXY(2,CONIND)
	ENDIF
	IF (SINDEX.EQ.STATE_MODIFY) THEN
	   IF (FRTFND(COIPAK(PAKFC))) THEN
	      CALL NASTY(MSG_BADCODE,COIPAK(PAKFC))
	      CALL COLAPS(MSG_BADCODE)
	   ENDIF
	   IF (FRTTEX) THEN
	      CALL BOXCTX(COICTXD,COIPAK,NDMODE.EQ.END_MOVE,
     &	                  COICTXD(CTXD_NCTX).GT.1)
	   ELSE
	      IF (WKAC(1).AND.WTYPES(1).EQ.4014) CALL GDAWK(1)
	      CALL STDRAW(
     &	COIIND-1,COIXY(1,2),COINATT,OIH_MAX_ATTR,COIATTC,COIATTV(1,2),
     &		COIAUX,COIDSC,
     &		DUMMYL,DUMMYL,DUMMYE,DUMMYL,COIPAK,COIFS)
	      IF (WKOP(1).AND.WTYPES(1).EQ.4014) CALL GACWK(1)
	   ENDIF
	ENDIF
	RUBCHG = .FALSE.
	IF (RUBLIN(1).OR.RUBLIN(2)) THEN
	   IF (WKAC(1).AND.WTYPES(1).NE.4014) CALL RFBAND(1)
	   IF (WKAC(2)) THEN
	      CALL VSDEF(2,1,5)
	      CALL RFBAND(2)
	      CALL VSDEF(2,4,4)
	   ENDIF
	ENDIF
	OVCOL = -1
	THKOPT = THKSAV
	CUROPT = AKISAV
	PATOPT = PATSAV
	IF (WKAC(1)) THEN
	   IF (WTYPES(1).NE.4014) THEN
	      CALL REFRSH			! start refresh picture
	   ELSE
	      CALL GKSW2D(1,CSXY(1),CSXY(2),X,Y)
	      CALL MOVTO(X,Y)
	      CALL LDFLSH
	      CALL LDWAIT
	   ENDIF
	ENDIF
	IF (WKAC(2)) THEN
	   CALL GUWK(2,GSUPP)		! should acheive a VSGEN
	   CALL VSPIC(1)
	ENDIF
	REFNG = .FALSE.			! no longer refreshing
999	RETURN
	END
	LOGICAL*1 FUNCTION TSTWK(NUMBER,WTYPE,NAME_LEN,NAME,PLANES)
	IMPLICIT NONE
	INCLUDE 'CMN:MOANMESS.INC'  ! INCLUDE not ADC because so big
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		NUMBER		! (in) workstation (1 or 2)
	INTEGER		WTYPE		! (out) workstation type
	INTEGER		NAME_LEN	! length of program name
	CHARACTER*(*)	NAME		! program name
	INTEGER		PLANES		! number of planes
	INTEGER		DEFTEK		! default tek
	PARAMETER	(DEFTEK = 9900)
	INTEGER		DEFARGS		! default ARGS
	PARAMETER	(DEFARGS= 7000)
	INTEGER		LOCAL_LEN
	PARAMETER	(LOCAL_LEN = 8)
	CHARACTER*(LOCAL_LEN)	LOCAL
	DATA		LOCAL /'TEK_ARGS'/
	TSTWK = .FALSE.
	NAME_LEN = MIN(LOCAL_LEN,LEN(NAME))
	NAME = LOCAL(1:NAME_LEN)
	IF (NUMBER.EQ.1) THEN
	   IF (WTYPE.EQ.0.OR.WTYPE.EQ.9900) THEN
	      WTYPE = DEFTEK			! TEK
	   ELSEIF (WTYPE.NE.4014) THEN
	      CALL MOAN(MSG_INVALWTYPE,WTYPE,DEFTEK)
	      WTYPE = DEFTEK
	   ENDIF
	   PLANES = 0		! no planes for overlay on TEK
	   TSTWK = .TRUE.
	ELSEIF (NUMBER.EQ.2) THEN
	   IF (WTYPE.EQ.0.OR.WTYPE.EQ.DEFARGS) THEN
	      WTYPE = DEFARGS
	   ELSE
	      CALL MOAN(MSG_INVALWTYPE,WTYPE,DEFARGS)
	      WTYPE = DEFARGS
	   ENDIF
	   PLANES = 4		! 4 planes available on ARGS
	   IF (.NOT.CLEOPT) CALL GKSDAT(2,5,.FALSE.) ! use VSINIT(5)
	   TSTWK = .TRUE.
	ENDIF
	RETURN
	END

	LOGICAL*1 FUNCTION TSTSEG
	IMPLICIT NONE
	TSTSEG = .FALSE.
	RETURN
	END
	SUBROUTINE BOXTXT(NCOORD,COORDS,AUX,TEXT,PACK,TRACK,BOX,ZIN)
	IMPLICIT NONE
	PARAMETER AUXLEN = 8	! length of auxiliary array
	PARAMETER XCENI= 1	! x coord of centre
	PARAMETER YCENI= 2	! y coord of centre
	PARAMETER RADI = 3	! radius
	PARAMETER STAI = 4	! start angle
	PARAMETER TOTI = 5	! total angle
	PARAMETER ANGI = 1	! angle
	PARAMETER COSI = 2	! cosine
	PARAMETER SINI = 3	! sine
	PARAMETER SIZI = 4	! size
	PARAMETER MINXI= 5	! minimum x
	PARAMETER MAXXI= 6	! maximum x
	PARAMETER MINYI= 7	! minimum y
	PARAMETER MAXYI= 8	! maximum y
	INTEGER		PAKLEN
	PARAMETER	(PAKLEN = 11)	! number of longwords
	INTEGER		PAKLNK,PAKPNF,PAKPST,PAKFSN,PAKFC,PAKSEG
	INTEGER		PAKVRT,PAKOVL,PAKGT,PAKMAP,PAKFLG
	PARAMETER	(PAKLNK = 1)	! link to previous pack
	PARAMETER	(PAKPNF = 2)	! pointer to start of feature
	PARAMETER	(PAKPST = 3)	! pointer to ST
	PARAMETER	(PAKFSN = 4)	! FSN
	PARAMETER	(PAKFC  = 5)	! Feature Code
	PARAMETER	(PAKSEG = 6)	! segment number
	PARAMETER	(PAKVRT = 7)	! offset of vertex
	PARAMETER	(PAKOVL = 8)	! overlay number
	PARAMETER	(PAKGT  = 9)	! graphical type
	PARAMETER	(PAKMAP = 10)	! map
	PARAMETER	(PAKFLG = 11)	! flags
	INTEGER		DELFLG,FSTFLG,LSTFLG,DRAFLG,THIFLG,THAFLG
	INTEGER		FINFLG,LIMFLG,SEGFLG
	PARAMETER	(DELFLG = -1)
	PARAMETER	(FSTFLG = 1)
	PARAMETER	(LSTFLG = 2)
	PARAMETER	(DRAFLG = 4)
	PARAMETER	(THIFLG = 8)
	PARAMETER	(THAFLG = 16)
	PARAMETER	(FINFLG = THIFLG+THAFLG)
	PARAMETER	(LIMFLG = 64)
	PARAMETER	(SEGFLG = 32)
	CHARACTER*(*)	LOG_TEXT	! logical name of image
	PARAMETER	(LOG_TEXT='LSL$TEXT_ROUTINE')
	CHARACTER*(*)	TEXT_ENTRY	! routine name therein
	PARAMETER	(TEXT_ENTRY='DRAW_TEXT')
	CHARACTER*(*)	TEXT_ENTRY_B	! routine name therein
	PARAMETER	(TEXT_ENTRY_B='BLANK_TEXT')
	INTEGER*4	TEXTAD		! address of routine
	INTEGER*4	TEXTAD_B
	CHARACTER*(*)	LOG_SYMBOL	! logical name of image
	PARAMETER	(LOG_SYMBOL='LSL$SYMBOL_ROUTINE')
	CHARACTER*(*)	SYMBOL_ENTRY	! routine name therein
	PARAMETER	(SYMBOL_ENTRY='DRAW_SYMBOL')
	CHARACTER*(*)	SYMBOL_ENTRY_B	! routine name therein
	PARAMETER	(SYMBOL_ENTRY_B='BLANK_SYMBOL')
	INTEGER*4	SYMBAD		! address of routine
	INTEGER*4	SYMBAD_B
	CHARACTER*(*)	LOG_RELVNT	! logical name of image
	PARAMETER	(LOG_RELVNT='LSL$LITES2_RELEVANT_ROUTINE')
	CHARACTER*(*)	RELVNT_ENTRY	! routine name therein
	PARAMETER	(RELVNT_ENTRY='USER_RELEVANT')
	INTEGER*4	RELVNTAD	! address of routine
	REAL		HATWID,HATSEP
	PARAMETER	(HATWID = 0.0)	! minimum line width
	PARAMETER	(HATSEP = 5.0)	! spacing in mm
	REAL NDCX,NDCY		! initial limits in NDC
	REAL WINDOW(4)		! window in IFF units
	REAL WINSAV(4)		! save of WINDOW
	REAL WINIMG(4)		! WINDOW in image space (IMAGE SETUP)
	LOGICAL HADIMG		! got a saved WINIMG
	REAL	WFACX,WFACY	! pixel scale factors (FLVIEW)
	REAL	ZOOM_IMAGE	! image zoom factor 
	REAL SCLFRT		! conversion factor FRT->IFF
	REAL SCLDIS		! conversion factor screen mm->IFF
	REAL FULLSCLDIS		! full screen SCLDIS
	REAL NOMLW		! nominal linewidth (mm)
	REAL DFSSIZ		! default symbol size
	REAL DFTSIZ		! default text size (if all else fails)
	REAL DRADEF		! default drawn curve tolerance
	PARAMETER (DRADEF=0.25)
	REAL DRAMM(3)		! drawn curve tolerences in sheet mm
	REAL GENDEF		! default generated curve tolerance
	PARAMETER (GENDEF=0.25)
	REAL GENMM(3)		! generated curve tolerances in sheet mm
	REAL CIDDEF		! default drawn circle tolerance
	PARAMETER (CIDDEF=0.05)
	REAL CIDNUM(2)		! no. of interpolated points
				! per sheet mm for drawn circles
	REAL CIDIFF(3)		! no. of interpolated points
				! per IFF unit for drawn circles
	REAL CIGDEF		! default generated circle tolerance
	PARAMETER (CIGDEF=0.05)
	REAL CIGNUM(2)		! no. of interpolated points
				! per sheet mm for generated circles
	REAL CIGIFF(3)		! no. of interpolated points
				! per IFF unit for generated circles
	REAL BUNCHMM(3)		! filtering tolerances (in sheet mm) for
				! bunch filtering algorithm
	REAL BUNCHMIN,BUNCHLAT	! default values
	PARAMETER (BUNCHMIN = 0.5)
	PARAMETER (BUNCHLAT = 0.1)
	REAL TOLEDG		! edgematch tol in mms on sheet
	REAL PRPTOL		! distance that propogation is to
				! take place over (mms on sheet)
	REAL OFFPROP		! distance to offset texts and symbols by
				! default as a proportion of their height
	REAL JSTPROP		! proportion of characters that are space
				! (used for justifying texts)
	REAL EXPROP		! proportion to expand text region
	INTEGER	OVCOL		! overriding colour (<0 if none)
	INTEGER BLANK_COL	! colour for blanking out texts
	INTEGER UNIT		! units to use  = 0 for use default
				!		= 1 for IFF units
				!		= 2 for sheet mms
				!		= 3 for factor
	REAL	UNIT_FACTOR	! the factor for UNIT = 3
	INTEGER*4 UNIT_DESC(2)	! string descriptor for unit type
	LOGICAL	THKSAV		! save of THKOPT
	LOGICAL	AKISAV		! save of CUROPT
	LOGICAL	PATSAV		! save of PATOPT
	LOGICAL	MCCON		! type of interpolation
				! .TRUE.  for McConalogue
				! .FALSE. for Akima
	LOGICAL	NODISP		! true if no displays
	LOGICAL	VIEWNG		! true when in FLVIEW
	LOGICAL	ZOOMNG		! true when find radius is to be zoomed
	LOGICAL	OVERHANG	! true if to take account of overhang
				! when genauxing texts
	LOGICAL	KRSCLR		! KRISS cleared?
	REAL	LSTOFF(2,2)	! last offset segment
	REAL	LSTPT(2)	! last point (before it was offset)
	REAL	OFFDIST		! distance to offset
	LOGICAL	STD		! started offsetting?
	LOGICAL	OFFSETF		! .true. if offsetting feature
	LOGICAL	RENDERING	! rendering a feature
	LOGICAL	REND_SYMB_TEXT	! rendering a symbol or text
	LOGICAL	FROM_DRWFEAT	! STDRAW called from DRWFEAT
	LOGICAL	INVSEG		! invisible segment (STDRAW/STDBFF)
	LOGICAL	IGNORE_BIT_14	! ignore bit 14 in flagword in FRT (in GENAUX)
	INTEGER	PRIO_FC		! feature code to use for prioritised drawing
				! (set by DRWSAV, used by DRAFTR)
	LOGICAL	DRAW_PRIORITY	! true when drawing with priorities
	COMMON/DRAWIN/NDCX,NDCY,WINDOW,WINSAV,SCLFRT,SCLDIS,NOMLW,
     &			DFSSIZ,DFTSIZ,
     &			TOLEDG,PRPTOL,FULLSCLDIS,
     &			LSTOFF,LSTPT,OFFDIST,OFFPROP,JSTPROP,EXPROP,
     &			WINIMG,HADIMG,WFACX,WFACY,
     &			CIDNUM,CIDIFF,CIGNUM,CIGIFF,
     &			DRAMM,GENMM,BUNCHMM,
     &			TEXTAD,SYMBAD,OVCOL,
     &			UNIT,RELVNTAD,BLANK_COL,
     &			ZOOM_IMAGE,UNIT_FACTOR,UNIT_DESC,
     &			THKSAV,AKISAV,PATSAV,MCCON,NODISP,VIEWNG,
     &	                ZOOMNG,STD,OFFSETF,OVERHANG,
     &	                RENDERING,REND_SYMB_TEXT,
     &			KRSCLR,FROM_DRWFEAT,INVSEG,IGNORE_BIT_14,
     &			PRIO_FC,DRAW_PRIORITY,TEXTAD_B,SYMBAD_B
	REAL*8		LINWDTH_FCTR
	PARAMETER	(LINWDTH_FCTR = 5.0E-7)
	REAL*8		LINWDTH		! the "width of a line" -
					! used for comparison with zero
	REAL		CSXY(3)		! current cursor position
	INTEGER		CSZI		! Z value of cursor position (as
					! INTEGER)
	EQUIVALENCE	(CSXY(3),CSZI)	! equivalenced
	REAL		XSECTW,YSECTW	! sector widths
	REAL		XOFF,YOFF	! SW corner of sector grid
	REAL		LIMITS(4)	! extent of sector grid
	REAL*8		ABS_LIMITS(4)	! absolute range of maps
	LOGICAL		HAD_RANGE_CMD	! true when had RANGE command 
	INTEGER XRANGE,YRANGE	! number of sectors in the y- and x-axes
	INTEGER	TOPSEC		! last sector being used
	INTEGER	NDMODE		! end mode - what to do on END command
	INTEGER	LASBUT		! last button used ($BUTTON)
	REAL	WINXY(2)	! saved SW corner of window
	INTEGER	WINREG		! region number for REGION n WINDOW
	LOGICAL	SCSARC		! constrain on arc/line?
	REAL	SCSAUX(5)	! aux array if circle (should use AUXLEN,
				!  but can't face including AUXDEF
	REAL	SCSTXY(2,2)	! ends of constraint line
	INTEGER	CUST		! customer number (as in map header)
				! = 0 for unknown
				! = 1 for MCE
				! = 2 for OS 
				! etc
	INTEGER	OTHFLG		! value to be set in PAKFLG for flushed
				! features when FSHCTR is TRUE
	LOGICAL	FSHCTR		! TRUE  when OTHFLG to be used in FLUSH
				! FALSE otherwise
	LOGICAL	CHASEL		! true if selections have been changed
	LOGICAL	ROLING		! cursor is constrained
	LOGICAL	POSCMD		! .TRUE. when last command was a
				! positioning command (FIND, VERTEX
				! etc)
	LOGICAL	SETING		! setup raster registration
	LOGICAL	FINDNG		! finding (set in FINREC - used in SCNSEC)
	LOGICAL	PNTING		! doing IMAGE PAINT
	INTEGER*4 RAN_SEED	! seed value for random number generator
	INTEGER	PRIV_ATTR_LIST	! list of attributes that may not be altered
	INTEGER	PRIV_PT_LIST	! list of attibutes of privileged points
	REAL	FAR_MOVE_MM	! tolerance for FAR_MOVE (mm)
	REAL	FAR_MOVE_IFF	! tolerance for FAR_MOVE (iff units)
	REAL	FORCE_COEFFS(4)	! defining plane
	REAL	FORCE_HEIGHT	! height of original point
	LOGICAL	FORCE_C_SETUP	! OK to use plane?
	LOGICAL	FORCE_H_SETUP	! OK to use height?
	INTEGER		ASK_INT_TOT
	PARAMETER	(ASK_INT_TOT = 3)
	INTEGER		ASK_REAL_TOT
	PARAMETER	(ASK_REAL_TOT = 3)
	INTEGER		ASK_CHAR_TOT
	PARAMETER	(ASK_CHAR_TOT = 2)
	INTEGER		ASK_INT(ASK_INT_TOT)	! value for system variable $ASK_INT
	INTEGER		ASK_CHAR(2,ASK_CHAR_TOT)! value for system variable $ASK_CHAR
						! (dynamic descriptor)
	REAL		ASK_REAL(ASK_REAL_TOT)
	INTEGER		ASK_INT_NUM
	INTEGER		ASK_REAL_NUM
	INTEGER		ASK_CHAR_NUM
	COMMON /MASTER/ ABS_LIMITS,LINWDTH,
     &			CSXY,XSECTW,YSECTW,XOFF,YOFF,LIMITS,
     &			XRANGE,YRANGE,TOPSEC,NDMODE,WINXY,SCSTXY,
     &			CUST,OTHFLG,LASBUT,RAN_SEED,PRIV_ATTR_LIST,
     &	                PRIV_PT_LIST,FORCE_COEFFS,FORCE_HEIGHT,
     &			FAR_MOVE_MM,FAR_MOVE_IFF,
     &	                ASK_INT,ASK_CHAR,ASK_REAL,
     &			ASK_INT_NUM,ASK_CHAR_NUM,ASK_REAL_NUM,
     &			FSHCTR,CHASEL,ROLING,POSCMD,SETING,
     &	                FORCE_C_SETUP,FORCE_H_SETUP,
     &			FINDNG,HAD_RANGE_CMD,
     &			WINREG,PNTING,
     &			SCSARC,SCSAUX
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER		NCOORD		   ! number of pts in feature
	REAL		COORDS(2,NCOORD)   ! these coordinates
	REAL		AUX(AUXLEN)	   ! auxiliary array
	CHARACTER*(*)	TEXT		   ! text to refresh
	INTEGER		PACK(PAKLEN)	   ! pack of feature
	LOGICAL*1	TRACK		   ! use local tracking
	LOGICAL*1	BOX		   ! draw a box, not the text
	REAL		ZIN		   ! height of point
	INTEGER*2	DUMMYE
	LOGICAL*1	DUMMYL
	REAL		XY(2)
	REAL		LENGTH,HEIGHT		! size of box
	REAL		LC,LS,HC,HS
	INTEGER		I			! loop counter
	REAL		X(5),Y(5)		! coords of box corners
	REAL		Z(5)
	INTEGER*2	DUMMYFS(4)
	DATA	DUMMYE,DUMMYL/0,.TRUE./
	DATA		DUMMYFS/0,0,0,0/
	DUMMYFS(1) = PACK(PAKFC)
	LENGTH=AUX(MAXXI)-AUX(MINXI)
	HEIGHT=AUX(MAXYI)-AUX(MINYI)
	IF (WKAC(1).AND.WTYPES(1).NE.4014) THEN
	   DO 10, I=2,WSMAX		! disable other worksataions
	      IF (WKAC(I)) CALL GDAWK(I)
   10	   CONTINUE
	   CALL GW2D(1,LENGTH,HEIGHT,LENGTH,HEIGHT)
	   XY(1)=COORDS(1,1)+AUX(MINXI)*AUX(COSI)-AUX(MINYI)*AUX(SINI)
	   XY(2)=COORDS(2,1)+AUX(MINXI)*AUX(SINI)+AUX(MINYI)*AUX(COSI)
	   IF (TRACK) THEN
	      CALL MOVTOC
	      CALL GW2D(1,XY(1)-CSXY(1),XY(2)-CSXY(2),XY(1),XY(2))
	      CALL MOVBY(XY(1),XY(2))
	   ELSE
	      CALL GKSW2D(1,XY(1),XY(2),XY(1),XY(2))
	      CALL MOVTO(XY(1),XY(2))
	   ENDIF
	   LC = LENGTH*AUX(COSI)
	   LS = LENGTH*AUX(SINI)
	   HC = HEIGHT*AUX(COSI)
	   HS = HEIGHT*AUX(SINI)
	   CALL LINBY(LC,LS)
	   CALL LINBY(-HS,HC)
	   CALL LINBY(-LC,-LS)
	   CALL LINBY(HS,-HC)
	   DO 20, I=2,WSMAX
	      IF (WKOP(I)) CALL GACWK(I)
   20	   CONTINUE
	ENDIF
	IF (WKAC(1)) CALL GDAWK(1)		! deactivate TEK
	IF (.NOT.BOX.AND.TEXTAD.EQ.0) THEN
	   CALL STDRAW(NCOORD,COORDS,0,1,0,0,AUX,TEXT,
     &	            DUMMYL,DUMMYL,DUMMYE,DUMMYL,PACK,DUMMYFS)
	ELSE
	   X(1)=COORDS(1,1)+AUX(MINXI)*AUX(COSI)-AUX(MINYI)*AUX(SINI)
	   Y(1)=COORDS(2,1)+AUX(MINXI)*AUX(SINI)+AUX(MINYI)*AUX(COSI)
	   X(2)=X(1)+AUX(COSI)*LENGTH
	   Y(2)=Y(1)+AUX(SINI)*LENGTH
	   X(3)=X(2)-AUX(SINI)*HEIGHT
	   Y(3)=Y(2)+AUX(COSI)*HEIGHT
	   X(4)=X(1)-AUX(SINI)*HEIGHT
	   Y(4)=Y(1)+AUX(COSI)*HEIGHT
	   X(5)=X(1)
	   Y(5)=Y(1)
	CALL SRIGPL(5,X,Y,Z)
	ENDIF
	IF (WKOP(1)) CALL GACWK(1)		! reactivate TEK
	RETURN
	END

	SUBROUTINE RFBAND(WKID)
	IMPLICIT NONE
	INTEGER*4	STATE_INITIAL	! INITIALisation
	PARAMETER	(STATE_INITIAL   =  1)
	INTEGER*4	STATE_READY	! READY for operation
	PARAMETER	(STATE_READY     =  2)
	INTEGER*4	STATE_LINE	! LINE feature found
	PARAMETER	(STATE_LINE      =  3)
	INTEGER*4	STATE_CIRCLE	! CIRCLE feature found
	PARAMETER	(STATE_CIRCLE     = 4)
	INTEGER*4	STATE_TEXT	! TEXT feature found
	PARAMETER	(STATE_TEXT      =  5)
	INTEGER*4	STATE_SYMBOL	! SYMBOL found
	PARAMETER	(STATE_SYMBOL    =  6)
	INTEGER*4	STATE_EDIT	! EDIT line
	PARAMETER	(STATE_EDIT      =  7)
	INTEGER*4	STATE_MODIFY	! MODIFY text / symbol
	PARAMETER	(STATE_MODIFY    =  8)
	INTEGER*4	STATE_ON	! constrain movement ON line
	PARAMETER	(STATE_ON        =  9)
	INTEGER*4	STATE_WINDOW	! WINDOW
	PARAMETER	(STATE_WINDOW    =  10)
	INTEGER*4	STATE_CONSTRUCT	! CONSTRUCT line
	PARAMETER	(STATE_CONSTRUCT = 11)
	INTEGER*4	STATE_AC	! AC edit
	PARAMETER	(STATE_AC        = 12)
	INTEGER*4	STATE_DEBUG	! DEBUG
	PARAMETER	(STATE_DEBUG     = 13)
	INTEGER*4	STATE_RECOVER	! RECOVER feature
	PARAMETER	(STATE_RECOVER   = 14)
	INTEGER*4	STATE_MACRO	! MACRO reading
	PARAMETER	(STATE_MACRO     = 15)
	INTEGER*4	STATE_SETUP	! SETUP of image
	PARAMETER	(STATE_SETUP     = 16)
	INTEGER*4	STATE_PAINT	! PAINTing image
	PARAMETER	(STATE_PAINT     = 17)
	INTEGER*4	MAXSTA		! number of states defined
	PARAMETER	(MAXSTA = 17)
	INTEGER*4	MASK_INITIAL	! INITIALisation
	PARAMETER	(MASK_INITIAL   =  '00040000'X)
	INTEGER*4	MASK_READY	! READY for operation
	PARAMETER	(MASK_READY     =  '08000000'X)
	INTEGER*4	MASK_LINE	! LINE feature found
	PARAMETER	(MASK_LINE      =  '00200000'X)
	INTEGER*4	MASK_CIRCLE	! CIRCLE feature found
	PARAMETER	(MASK_CIRCLE      =  '04000000'X)
	INTEGER*4	MASK_TEXT	! TEXT feature found
	PARAMETER	(MASK_TEXT      =  '20000000'X)
	INTEGER*4	MASK_SYMBOL	! SYMBOL found
	PARAMETER	(MASK_SYMBOL    =  '10000000'X)
	INTEGER*4	MASK_EDIT	! EDIT line
	PARAMETER	(MASK_EDIT      =  '00004000'X)
	INTEGER*4	MASK_MODIFY	! MODIFY text / symbol
	PARAMETER	(MASK_MODIFY    =  '00400000'X)
	INTEGER*4	MASK_ON		! constrain movement ON line
	PARAMETER	(MASK_ON        =  '01000000'X)
	INTEGER*4	MASK_WINDOW	! WINDOW
	PARAMETER	(MASK_WINDOW    =  '80000000'X)
	INTEGER*4	MASK_CONSTRUCT	! CONSTRUCT line
	PARAMETER	(MASK_CONSTRUCT =  '00001000'X)
	INTEGER*4	MASK_AC		! AC edit
	PARAMETER	(MASK_AC        =  '00000400'X)
	INTEGER*4	MASK_DEBUG	! DEBUG
	PARAMETER	(MASK_DEBUG     =  '00002000'X)
	INTEGER*4	MASK_RECOVER	! RECOVER feature
	PARAMETER	(MASK_RECOVER   =  '00010000'X)
	INTEGER*4	MASK_MACRO	! MACRO reading
	PARAMETER	(MASK_MACRO     =  '00000800'X)
	INTEGER*4	MASK_SETUP	! SETUP image
	PARAMETER	(MASK_SETUP     =  '40000000'X)
	INTEGER*4	MASK_PAINT	! PAINTing image
	PARAMETER	(MASK_PAINT     =  '02000000'X)
	REAL*8		LINWDTH_FCTR
	PARAMETER	(LINWDTH_FCTR = 5.0E-7)
	REAL*8		LINWDTH		! the "width of a line" -
					! used for comparison with zero
	REAL		CSXY(3)		! current cursor position
	INTEGER		CSZI		! Z value of cursor position (as
					! INTEGER)
	EQUIVALENCE	(CSXY(3),CSZI)	! equivalenced
	REAL		XSECTW,YSECTW	! sector widths
	REAL		XOFF,YOFF	! SW corner of sector grid
	REAL		LIMITS(4)	! extent of sector grid
	REAL*8		ABS_LIMITS(4)	! absolute range of maps
	LOGICAL		HAD_RANGE_CMD	! true when had RANGE command 
	INTEGER XRANGE,YRANGE	! number of sectors in the y- and x-axes
	INTEGER	TOPSEC		! last sector being used
	INTEGER	NDMODE		! end mode - what to do on END command
	INTEGER	LASBUT		! last button used ($BUTTON)
	REAL	WINXY(2)	! saved SW corner of window
	INTEGER	WINREG		! region number for REGION n WINDOW
	LOGICAL	SCSARC		! constrain on arc/line?
	REAL	SCSAUX(5)	! aux array if circle (should use AUXLEN,
				!  but can't face including AUXDEF
	REAL	SCSTXY(2,2)	! ends of constraint line
	INTEGER	CUST		! customer number (as in map header)
				! = 0 for unknown
				! = 1 for MCE
				! = 2 for OS 
				! etc
	INTEGER	OTHFLG		! value to be set in PAKFLG for flushed
				! features when FSHCTR is TRUE
	LOGICAL	FSHCTR		! TRUE  when OTHFLG to be used in FLUSH
				! FALSE otherwise
	LOGICAL	CHASEL		! true if selections have been changed
	LOGICAL	ROLING		! cursor is constrained
	LOGICAL	POSCMD		! .TRUE. when last command was a
				! positioning command (FIND, VERTEX
				! etc)
	LOGICAL	SETING		! setup raster registration
	LOGICAL	FINDNG		! finding (set in FINREC - used in SCNSEC)
	LOGICAL	PNTING		! doing IMAGE PAINT
	INTEGER*4 RAN_SEED	! seed value for random number generator
	INTEGER	PRIV_ATTR_LIST	! list of attributes that may not be altered
	INTEGER	PRIV_PT_LIST	! list of attibutes of privileged points
	REAL	FAR_MOVE_MM	! tolerance for FAR_MOVE (mm)
	REAL	FAR_MOVE_IFF	! tolerance for FAR_MOVE (iff units)
	REAL	FORCE_COEFFS(4)	! defining plane
	REAL	FORCE_HEIGHT	! height of original point
	LOGICAL	FORCE_C_SETUP	! OK to use plane?
	LOGICAL	FORCE_H_SETUP	! OK to use height?
	INTEGER		ASK_INT_TOT
	PARAMETER	(ASK_INT_TOT = 3)
	INTEGER		ASK_REAL_TOT
	PARAMETER	(ASK_REAL_TOT = 3)
	INTEGER		ASK_CHAR_TOT
	PARAMETER	(ASK_CHAR_TOT = 2)
	INTEGER		ASK_INT(ASK_INT_TOT)	! value for system variable $ASK_INT
	INTEGER		ASK_CHAR(2,ASK_CHAR_TOT)! value for system variable $ASK_CHAR
						! (dynamic descriptor)
	REAL		ASK_REAL(ASK_REAL_TOT)
	INTEGER		ASK_INT_NUM
	INTEGER		ASK_REAL_NUM
	INTEGER		ASK_CHAR_NUM
	COMMON /MASTER/ ABS_LIMITS,LINWDTH,
     &			CSXY,XSECTW,YSECTW,XOFF,YOFF,LIMITS,
     &			XRANGE,YRANGE,TOPSEC,NDMODE,WINXY,SCSTXY,
     &			CUST,OTHFLG,LASBUT,RAN_SEED,PRIV_ATTR_LIST,
     &	                PRIV_PT_LIST,FORCE_COEFFS,FORCE_HEIGHT,
     &			FAR_MOVE_MM,FAR_MOVE_IFF,
     &	                ASK_INT,ASK_CHAR,ASK_REAL,
     &			ASK_INT_NUM,ASK_CHAR_NUM,ASK_REAL_NUM,
     &			FSHCTR,CHASEL,ROLING,POSCMD,SETING,
     &	                FORCE_C_SETUP,FORCE_H_SETUP,
     &			FINDNG,HAD_RANGE_CMD,
     &			WINREG,PNTING,
     &			SCSARC,SCSAUX
	REAL		OCSXY(2)	! old cursor position
	REAL		RUBARR(2,2)	! rubber band positions
	INTEGER		RFFULL	! (preset) number to refresh
	INTEGER		RFOFF	! (preset) target within RFFULL
	INTEGER		RFCRIT	! (preset) distance of cursor to end
	INTEGER*4	RFFSEG	! segment number of refreshed found item
	INTEGER		RFFVO	! vertex offset of refreshed found item
	INTEGER		RFFOFF	! vertex offset of actual refresh bit
	INTEGER		RFFTOP	! number of refreshed vertices
	INTEGER*4	RFFCTX	! address of CTX that has cursor on it
	INTEGER*4	RFHSEG	! refreshed object in hand segment
	INTEGER		RFHOFF	! vertex offset of actual refresh bit
	INTEGER		RFHTOP	! number of refreshed vertices
	INTEGER		RFCIND	! refreshed construction index
	LOGICAL		CURS	! true if cursor required
	LOGICAL		INTCUR	! true if cursor position initialised
	LOGICAL		RFCURS	! true if cursor presently drawn
	LOGICAL		RFFLIM	! refreshed found item is in limbo
	LOGICAL		REFNG	! true while executing RFDRAW
	LOGICAL*1	RUBLIN(2)	! want rubber bands?
	LOGICAL		RUBCHG	! rubber bands changed?
	LOGICAL		RFMOD	! have a 'modification' in refresh
	LOGICAL		RFRUB	! have rubber band in refresh
	LOGICAL		RFBIG	! got big cursor
	LOGICAL		RFBNK	! got blinking cursor
	LOGICAL		RFCSEG	! true if cursor segment exists
	LOGICAL		RFLSEG	! true if F/L segment exits
	LOGICAL		RFHSEP	! true separate segment for IH
	LOGICAL		RFFSEP	! true separate segment for FO
	INTEGER		RFCTYP	! cursor type
	REAL		RFCARG(2) ! additional cursor arguments
	INTEGER		RFCOL	! bit mask (colour)
	COMMON/RFCTRL/OCSXY,RUBARR,
     &	        RFFULL,RFOFF,RFCRIT,
     &		RFFSEG,RFFVO,RFFOFF,RFFTOP,
     &		RFHSEG,RFHOFF,RFHTOP,RFCIND,RFFCTX,
     &		CURS,INTCUR,RFCURS,RFFLIM,REFNG,
     &		RUBCHG,RFMOD,RFRUB,RFBIG,RFBNK,RFCSEG,RFLSEG,
     &		RFHSEP,RFFSEP,
     &		RFCTYP,RFCARG,RUBLIN,RFCOL
	INTEGER*4	SSM		! max. state string length
	PARAMETER	(SSM = 16)
	INTEGER*4	STAMSK(MAXSTA)	! all state masks
	INTEGER*4	STACHS(MAXSTA)	! all state name lengths
	INTEGER*4	SMASK		! current state flag mask
	INTEGER*4	SINDEX		! current state index
	INTEGER*4	STALEN		! current state name lengths
	CHARACTER*(SSM)	STANAM(MAXSTA)	! all state names
	CHARACTER*(SSM)	STASTR		! current state name
	COMMON/STATE/STAMSK,STACHS,SMASK,SINDEX,STALEN
	COMMON/STACH/STANAM,STASTR
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	INTEGER		WKID		! workstation identifier
	INTEGER		START,NUMBER
	REAL		X(5),Y(5)	! temporary coords
	IF (WKID.EQ.2) GOTO 200		! ARGS
	IF (RUBLIN(1)) THEN
	   CALL GKSW2D(1,RUBARR(1,1),RUBARR(2,1),X(1),Y(1))
	   CALL MOVTO(X(1),Y(1))
	   IF (SINDEX.EQ.STATE_WINDOW) THEN
	      CALL GKSW2D(1,CSXY(1),CSXY(2),X(2),Y(2))
	      IF (X(2).GT.X(1).AND.Y(2).GT.Y(1)) THEN
	         CALL LINTO(X(1),Y(2))
	         CALL LINTOC
	         CALL LINTO(X(2),Y(1))
	         CALL LINTO(X(1),Y(1))
	      ELSE
	         CALL LINTOC
	      ENDIF
	   ELSE
	      CALL LINTOC
	   ENDIF
	ELSE
	   CALL MOVTOC
	ENDIF
	IF (RUBLIN(2)) THEN
	   CALL GKSW2D(1,RUBARR(1,2),RUBARR(2,2),X(3),Y(3))
	   CALL LINTO(X(3),Y(3))
	ENDIF
	GOTO 900
200	X(2) = CSXY(1)
	Y(2) = CSXY(2)
	IF (RUBLIN(1)) THEN
	   X(1) = RUBARR(1,1)
	   Y(1) = RUBARR(2,1)
	   START = 1
	   IF (SINDEX.EQ.STATE_WINDOW.AND.
     &		CSXY(1).GT.X(1).AND.CSXY(2).GT.Y(1)) THEN
	      X(3) = X(2)	! NE corner (cursor)
	      Y(3) = Y(2)
	      X(2) = X(1)	! NW corner (y OK already)
	      X(4) = X(3)	! SE corner
	      Y(4) = Y(1)
	      X(5) = X(1)	! back to SW
	      Y(5) = Y(1)
	      NUMBER = 5
	   ELSE
	      NUMBER = 2
	   ENDIF
	ELSE
	   START = 2
	   NUMBER = 1
	ENDIF
	IF (RUBLIN(2)) THEN
	   X(3) = RUBARR(1,2)
	   Y(3) = RUBARR(2,2)
	   NUMBER = NUMBER+1
	ENDIF
	IF (WKAC(1)) CALL GDAWK(1)
	CALL GPL(NUMBER,X(START),Y(START))
	IF (WKOP(1)) CALL GACWK(1)
900	RETURN
	END
	SUBROUTINE INIWK(NUMBER)
	IMPLICIT NONE
	INTEGER		NUMBER		! (in) workstation (1 or 2)
	LOGICAL	QUIOPT		! Quiet mode
	LOGICAL	PMEOPT		! Performance monitor
	LOGICAL	EXTOPT		! External scale
	LOGICAL	APPOPT		! append problem files
	LOGICAL	POSOPT		! Text position codes
	LOGICAL	STAOPT		! status line
	LOGICAL	POIOPT		! text in point size (not mms)
	LOGICAL	ENDOPT		! Find by ends
	LOGICAL	MAPOPT		! Memory mapped IFF
	LOGICAL	TABOPT		! digitiser table
	LOGICAL	GRAOPT		! Interactive devices
	LOGICAL	PRIOPT		! Primary screen
	LOGICAL	SECOPT		! Second screen
	LOGICAL	BITOPT		! Bitpad
	LOGICAL	DIAOPT		! Diagnostics
	LOGICAL	LEAOPT		! Learner
	LOGICAL	CUROPT		! interpolation
	LOGICAL	THKOPT		! thick lines
	LOGICAL	PATOPT		! patterned lines
	LOGICAL	HEIOPT		! get text from IFF TH entry
	LOGICAL	ECHOPT		! echo commands
	LOGICAL	CONOPT		! continue on error
	LOGICAL	TRAOPT		! traceback on error
	LOGICAL	MONOPT		! use table monitor
	LOGICAL	NOWOPT		! output "Now in XXX state"
	LOGICAL	SRTOPT		! redraws sorted
	LOGICAL	BALOPT		! use trackerball
	LOGICAL	BIGOPT		! big cursor
	LOGICAL	BNKOPT		! blink cursor
	LOGICAL	CLEOPT		! clear screen before draw
	LOGICAL	SEGOPT		! use segments
	LOGICAL	EXIOPT		! exit program on EXIT,DUMP,QUIT
	LOGICAL	NAROPT		! narrow windows
	LOGICAL	SUBOPT		! substitute variables
	LOGICAL	BRIOPT		! brief journal file
	LOGICAL	VEROPT		! verification of features
	LOGICAL	ANDOPT		! and selected regions
	LOGICAL	SCBOPT		! scrub deleted features
	LOGICAL	INFOPT		! display inform messages
	LOGICAL	COMOPT		! allow composite text
	LOGICAL	SCROPT		! allow screen menus
	LOGICAL	EDTOPT		! flagging of edited features
	LOGICAL	HWTOPT		! hardware text to be used
	LOGICAL	DATOPT		! AC flagging of edit date
	LOGICAL	DESOPT		! use origin and sale form MD
	LOGICAL	BUTOPT		! use functio buttons
	LOGICAL	BELOPT		! suppress bells in messages
	LOGICAL	FIXOPT		! new OS squaring algorithm
	LOGICAL	ZOPT		! allow interpolation of Z in edits
	LOGICAL	DSROPT		! use KERN DSR stereoplotter
	LOGICAL	KRSOPT		! use KERN KRISS display
	LOGICAL	BOXOPT		! draw texts as boxes
	LOGICAL	VECOPT		! draw IFF data, as well as RASTER
	LOGICAL	BLAOPT		! blank out behind texts
	LOGICAL	LOKOPT		! lock IFF files
	LOGICAL	CHKOPT		! check macros/variables for existance
	LOGICAL	SAMOPT		! retain existing output revision levelas input
	LOGICAL	ENCOPT		! sector inside of areas
	LOGICAL	MESOPT		! messages when inform off
	LOGICAL	FILOPT		! area fill (else draw hollow)
	LOGICAL	CCOPT
	LOGICAL	ESCOPT
	LOGICAL	VERFEA		! verify feature
	LOGICAL	VERAC		! verify AC etc
	LOGICAL	VERTXT		! verify text
	LOGICAL	VERGRP		! verify groups
	INTEGER		SORIFF		! what to sort by
	INTEGER		SORT_BY_IFF
	INTEGER		SORT_BY_FSN
	INTEGER		SORT_BY_GT
	INTEGER		SORT_BY_PRIORITY
	PARAMETER	(SORT_BY_IFF      = 1,
     &	                 SORT_BY_FSN      = 2,
     &	                 SORT_BY_GT       = 3,
     &	                 SORT_BY_PRIORITY = 4)
	COMMON/OPTION/SORIFF,QUIOPT,PMEOPT,EXTOPT,APPOPT,POSOPT,STAOPT,
     &                EXIOPT,POIOPT,ENDOPT,MAPOPT,TABOPT,GRAOPT,PRIOPT,
     &                SECOPT,BITOPT,DIAOPT,LEAOPT,CUROPT,THKOPT,PATOPT,
     &		      HEIOPT,ECHOPT,CONOPT,TRAOPT,MONOPT,
     &		      NOWOPT,SRTOPT,BALOPT,
     &		      BIGOPT,BNKOPT,CLEOPT,SEGOPT,
     &		      NAROPT,SUBOPT,BRIOPT,
     &		      VERFEA,VERAC,VERTXT,VEROPT,VERGRP,
     &	              ANDOPT,SCBOPT,INFOPT,COMOPT,SCROPT,EDTOPT,HWTOPT,
     &		      DATOPT,DESOPT,BUTOPT,BELOPT,FIXOPT,ZOPT,DSROPT,
     &		      KRSOPT,BOXOPT,VECOPT,BLAOPT,LOKOPT,CHKOPT,SAMOPT,
     &	              ENCOPT,CCOPT,MESOPT,FILOPT,ESCOPT
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	IF (NUMBER.EQ.1.AND.WTYPES(1).EQ.4014.AND.BITOPT) THEN
	   CALL TKGINFR
	ENDIF
	IF (NUMBER.EQ.2) THEN
	   CALL LSG_PLANE_SELECT(2,15)	! define picture 1 = 4 planes
	   CALL VSCHSZ(1,0)	! change ARGS character size
	ENDIF
	RETURN
	END

	SUBROUTINE PING
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	TTOBEL = .TRUE.		! no carriage controls in TWOPUT
	CALL WRITEF('%C',7)	! just a bell
	TTOBEL = .FALSE.	! restore
	RETURN
	END
	SUBROUTINE RASP
	IMPLICIT NONE
	INTEGER		WSMAX	! max number of workstations
	PARAMETER	(WSMAX=2)
	REAL	SCRSZX(WSMAX)	! full screen size (device units = m)
	REAL	SCRSZY(WSMAX)
	REAL	SCRNSX(WSMAX)	! used screen size (modified by
	REAL	SCRNSY(WSMAX)	! WORKSTATION VIEWPORT command)
	INTEGER	RASTSX(WSMAX)	! raster sizes (pixels)
	INTEGER	RASTSY(WSMAX)
	REAL	LWIDTH(WSMAX)	! nominal line width
	REAL    WKVSWX(WSMAX)   ! user specified workstation viewport
	REAL    WKVSWY(WSMAX)   !             "
	REAL    WKVNEX(WSMAX)   !
	REAL    WKVNEY(WSMAX)	!
	INTEGER	CONIDS(WSMAX)	! connection identifiers
	INTEGER	WTYPES(WSMAX)	! workstation types
	LOGICAL*1 WKOP(WSMAX)	! open?
	LOGICAL*1 WKAC(WSMAX)	! active?
	LOGICAL*1 WKSUPP(WSMAX)	! suppressed?
	LOGICAL*1 WKACT(WSMAX)	! temporarily (in)active? (segments)
	LOGICAL*1 ACTSAV(WSMAX)	! save for DOWIND,ABAWIN
	LOGICAL*1 USESEG	! use GKS segments?
	LOGICAL*1 UPDATE_SEG	! for toggling segments
	LOGICAL*1 NEW_USESEG	!  "     "        "
	LOGICAL*1 VECSUPP	! don't draw IFF data
	LOGICAL*1 CLEASUPP	! don't clear screen (on non segmented displays)
	REAL	EFSCMP,EFSCPL	! scrub parameters (metres on screen)
	LOGICAL*1 TMOTED,TIMOUT	! timeout control
	LOGICAL*1 CSRTMO	! cursor timeout
	INTEGER*4 DIGLIN	! line from digitiser
	PARAMETER (DIGLIN=3)
	LOGICAL*1 TABINI	! digitising table initialised?
				! .TRUE. if yes
	INTEGER*4 TABSUP	! type of table set up required
				! 0 = None
				! 2 = two  point
				! 4 = four point
				! 6 = OS multiple point set up
	INTEGER*4 TRNTYP	! type of transformation required
				! 2 = orthoganal
				! 3 = 3 point
				! 4 = as in laseraid
				! 1 = projective 4 point
				! defined in TRNTYP.PAR
	CHARACTER*(13)	TR_TYPE(4)
	INTEGER		TR_TYPE_LEN(4)
	INTEGER	  TABSUP_2PT
	INTEGER   TABSUP_4PT
	INTEGER   TABSUP_OS
	INTEGER	  TABSUP_EDGE
	PARAMETER (TABSUP_2PT   =  1,
     &	           TABSUP_4PT   =  2,
     &             TABSUP_OS    =  3,
     &	           TABSUP_EDGE  =  4)
	CHARACTER*(14)	TS_TYPE(4)
	INTEGER		TS_TYPE_LEN(4)
	LOGICAL*1 STREAM	! want stream input?
	LOGICAL*1 POSPND	! POSITION command pending?
	REAL	  POSXY(2)	! position itself
	REAL	  TABLE_COUNTS	! size of 1 table count (in table mm)
	INTEGER*4 BITLIN	! line from bitpad
	PARAMETER (BITLIN=2)
	LOGICAL*1 BITINI	! bitpad initialised?
	LOGICAL*1	TTASN	! TTICHN assigned to SYS$INPUT
	INTEGER*2	TTICHN	! channel for QIOs
	INTEGER		TTBLEN
	PARAMETER	(TTBLEN=255)
	BYTE		TTBUF(TTBLEN)	! input buffer
	INTEGER*2	TTIOSB(4)	! IO status block
	LOGICAL*1	TTINIT	! .TRUE. until read occurs in
				! READY state
	LOGICAL*1	WOSPIN	! read terminal using WOSPLIB
	LOGICAL*1	TTREAD	! .TRUE. when terminal read going
	LOGICAL*1	TAREAD	! .TRUE. when table read is going
	LOGICAL*1	TTABORT	! .TRUE. if cannot read from terminal
	INTEGER*4	TTIMBK(2)	! terminator mask quadword
	INTEGER*4	TTIMSK(8)	! terminator mask
	INTEGER		TABPROMPTMAX
	PARAMETER	(TABPROMPTMAX = 10)
	BYTE		TABPROMPT(TABPROMPTMAX)
	INTEGER		TABPROMPTL
	LOGICAL		TABPROMDECOD
	INTEGER*4	FUNADR	! function address to use
	INTEGER*4	DTBCHN	! channel for direct table read
	INTEGER		DTBLEN
	PARAMETER	(DTBLEN=40)	! who knows how long strings
					! will be returned by table
	BYTE		DTBBUF(DTBLEN)	! input buffer
	INTEGER*2	DTBOSB(4)
	INTEGER*2	MXTYPC	! max no of chars in typeahead buffer
	LOGICAL*1	DTBREAD ! .TRUE. when direct table read going
	LOGICAL*1	DTRON	! .TRUE. when using direct table read
	LOGICAL*1	USEFUN	! whether to use user defined function
	LOGICAL*1 	BALINI	! trackerball initialised?
	LOGICAL*1 	SCRINI	! screen menu up?
	LOGICAL*1 	KRSMENU	! screen menu on KRISS
	LOGICAL*1 	USE_KRSMENU	! to be used next time
	LOGICAL*1 	BUTINI	! function buttons defined?
	LOGICAL*1 	DSRINI		! KERN DSR in use?
	INTEGER*2	DSROSB(4)	! IO status block
	BYTE		DSRBUF		! input buffer
	LOGICAL*1	DSRREAD		! .TRUE. when DSR read going
	LOGICAL*1 	KRSINI		! KRISS also in use
	INTEGER		TTOCUR	! position of last char written
	INTEGER*2	TTOCHN	! channel for QIO to terminal
	LOGICAL*1	TTOINI	! .TRUE. if done TTO assignment
	LOGICAL*1	TTOPRO	! .TRUE. if next write is a prompt
	LOGICAL*1	TTOBEL	! .TRUE. if next write is a bell
	LOGICAL*1	TTODON	! .TRUE. if write happened since prompt
	LOGICAL*1	TTIDON	! .TRUE. if read happened since prompt
	LOGICAL*1	TTPROM	! .TRUE. if prompt wanted
	INTEGER		AUX_LINES
	PARAMETER	(AUX_LINES = 4) 	! have 4 auxiliary inputs
	LOGICAL		AUX_SERVICED(AUX_LINES)	! QIOs been serviced?
	LOGICAL*1	AUX_ACTIVE(AUX_LINES)	! auxiliary lines on?
	INTEGER*2	AUX_CHANNEL(AUX_LINES)	! channel numbers
	LOGICAL*1	AUX_ASN(AUX_LINES)	! assigned?
	CHARACTER*80	AUX_NAME(AUX_LINES)	! logical name of devices
	INTEGER		AUX_NAME_LEN(AUX_LINES)	! and their lengths
	LOGICAL*1	AUX_READ		! are there reads up?
	INTEGER*2	AUXIOSB(4,AUX_LINES)	! IO status blocks
	BYTE		AUXBUF(TTBLEN,AUX_LINES)! input lines
	LOGICAL*1	FOLLOWING		! when had FOLLOW START
	LOGICAL*1	FOLLOWED		! timer has gone off
	LOGICAL*1	FOLLOW_TIMING		! timer is running
	LOGICAL*1	FOLLOW_START		! START command from
						! SERV_FOLLOW routine
	INTEGER		PNAM_LEN_MAX		! maximum string len
	PARAMETER	(PNAM_LEN_MAX=20)
	CHARACTER*(PNAM_LEN_MAX) PNAM		! name of program
	INTEGER		PNAM_LEN		! length of program name
	INTEGER		VNAM_LEN_MAX
	PARAMETER	(VNAM_LEN_MAX=30)
	CHARACTER*(VNAM_LEN_MAX) VNAM
	INTEGER		VNAM_LEN
	COMMON/WORKS/SCRSZX,SCRSZY,SCRNSX,SCRNSY,		! real
     &		WKVSWX,WKVSWY,WKVNEX,WKVNEY,
     &	        LWIDTH,EFSCMP,EFSCPL,POSXY,TABLE_COUNTS,
     &		RASTSX,RASTSY,					! I*4s
     &		CONIDS,WTYPES,TR_TYPE_LEN,TS_TYPE_LEN,TABSUP,
     &		FUNADR,TTOCUR,AUX_NAME_LEN,PNAM_LEN,TRNTYP,
     &	        TABPROMPTL,VNAM_LEN,
     &		AUX_SERVICED,					! L*4s
     &		MXTYPC,TTICHN,TTOCHN,DTBCHN,AUX_CHANNEL,	! I*2s
     &		TTIOSB,DTBOSB,DSROSB,AUXIOSB,
     &		TTBUF,DTBBUF,DSRBUF,AUXBUF,			! L*1s
     &		TABPROMPT,TABPROMDECOD,WKOP,WKAC,WKSUPP,
     &	        WKACT,ACTSAV,USESEG,
     &		TABINI,STREAM,POSPND,BITINI,TTASN,TTINIT,
     &		TTABORT,
     &		WOSPIN,TTREAD,TAREAD,TTPROM,BALINI,TTOINI,
     &		TTOPRO,TTODON,TMOTED,TIMOUT,CSRTMO,TTOBEL,
     &	        DTBREAD,DTRON,USEFUN,TTIDON,
     &		SCRINI,BUTINI,NEW_USESEG,UPDATE_SEG,
     &		AUX_ACTIVE,AUX_ASN,
     &		AUX_READ,DSRINI,FOLLOWED,FOLLOWING,FOLLOW_TIMING,
     &	        FOLLOW_START,DSRREAD,KRSINI,KRSMENU,USE_KRSMENU,
     &		VECSUPP,CLEASUPP,
     &		TTIMBK,TTIMSK
	COMMON/WORKSC/AUX_NAME,PNAM,VNAM,TR_TYPE,TS_TYPE
	IF (WOSPIN) THEN
	   CALL TKRASP			! TEK raspberry
	ELSE
	   TTOBEL = .TRUE.		! no carriage controls in TWOPUT
	   CALL WRITEF('%C%C',7,7)	! a pair of bells
	   TTOBEL = .FALSE.		! restore
	ENDIF
	RETURN
	END
