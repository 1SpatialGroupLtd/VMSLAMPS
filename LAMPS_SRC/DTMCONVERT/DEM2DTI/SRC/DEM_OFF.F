	BLOCK DATA DEM_OFF
C
CDEC$	IDENT	'30OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	06-Oct-1989
C
C Description:
C
C	Block data definition for DEM A & B record byte offsets
C	and field lengths
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'LSL$DEM2DTI:COMMANDS.CMN'	! Command switches
	INCLUDE 'LSL$DEM2DTI:DEMA.CMN'		! DEM A record
	INCLUDE 'LSL$DEM2DTI:DEMB.CMN'		! DEM B record
C
C Command parameters
C
	DATA	BLKSIZ	/ 4096 /		! Default tape blocksize
C
C DEM type A record (header)
C
C				offset		element   name
C
	DATA	DEMAOFF(1),DEMABYT(1)	/ 1,144 /	! (1)	DEMNAM
	DATA	DEMAOFF(2),DEMABYT(2)	/ 145,6 /	! (2)	DEMLEVEL
	DATA	DEMAOFF(3),DEMABYT(3)	/ 151,6 /	! (3)	DEMPATT 
	DATA	DEMAOFF(4),DEMABYT(4)	/ 157,6 /	! (4)	DEMREF  
	DATA	DEMAOFF(5),DEMABYT(5)	/ 163,6 /	! (5)	DEMZONE 
	DATA	DEMAOFF(6),DEMABYT(6)	/ 169,24 /	! (6)	DEMPROJ 
	DATA	DEMAOFF(7),DEMABYT(7)	/ 529,6 /	! (7)	DEMXYUN 
	DATA	DEMAOFF(8),DEMABYT(8)	/ 535,6 /	! (8)	DEMZUN  
	DATA	DEMAOFF(9),DEMABYT(9)	/ 541,6 /	! (9)	DEMPOL
	DATA	DEMAOFF(10),DEMABYT(10)	/ 547,24 /	! (10)	DEMCORN 
	DATA	DEMAOFF(11),DEMABYT(11)	/ 739,24 /	! (11)	DEMZRNG 
	DATA	DEMAOFF(12),DEMABYT(12)	/ 787,24 /	! (12)	DEMDIR  
	DATA	DEMAOFF(13),DEMABYT(13)	/ 811,6 /	! (13)	DEMACC  
	DATA	DEMAOFF(14),DEMABYT(14)	/ 817,12 /	! (14)	DEMRES  
	DATA	DEMAOFF(15),DEMABYT(15)	/ 853,6 /	! (15)	DEMNCOL 
C
C
C DEM type B record 
C
C				offset		element   name
C
	DATA	DEMBOFF(1),DEMBBYT(1)	/ 1,6 /		! (1)	DEMID
	DATA	DEMBOFF(2),DEMBBYT(2)	/ 13,6 /	! (2)	DEMNROW 
	DATA	DEMBOFF(3),DEMBBYT(3)	/ 25,24 /	! (3)	DEMFIRST
	DATA	DEMBOFF(4),DEMBBYT(4)	/ 73,24 /	! (4)	DEMDATUM
	DATA	DEMBOFF(5),DEMBBYT(5)	/ 97,24 /	! (5)	DEMPRNG 
	DATA	DEMBOFF(6),DEMBBYT(6)	/ 145,6  /	! (6)	DEMELEV 
C	
	END
C
