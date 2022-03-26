	BLOCK DATA MNT_OFF
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	24-Jul-1990
C
C Description:
C
C	Block data definition for MNT header and data record byte offsets
C	and field lengths
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'LSL$MNT2DTI:COMMANDS.CMN'	! Command switches
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header record
	INCLUDE 'LSL$MNT2DTI:MNT_DATA.CMN'	! MNT data record
C
C Command parameters
C
	DATA	BLKSIZ	/ 4096 /		! Default tape blocksize
C
C MNT header record
C
C				offset		element   name
C
	DATA	MNTHOFF(1),MNTHBYT(1)	/ 57,100 /	! (1)	MNTNAM
	DATA	MNTHOFF(2),MNTHBYT(2)	/ 157,4 /	! (2)	MNTSYS
	DATA	MNTHOFF(3),MNTHBYT(3)	/ 161,15 /	! (3)	MNTCORN 
	DATA	MNTHOFF(4),MNTHBYT(4)	/ 281,10 /	! (4)	MNTPTSEP
	DATA	MNTHOFF(5),MNTHBYT(5)	/ 291,10 /	! (5)	MNTPRSEP
	DATA	MNTHOFF(6),MNTHBYT(6)	/ 301,20 /	! (6)	MNTXYUN
	DATA	MNTHOFF(7),MNTHBYT(7)	/ 321,10 /	! (7)	MNTPOINTS
	DATA	MNTHOFF(8),MNTHBYT(8)	/ 331,10 /	! (8)	MNTPROFS
	DATA	MNTHOFF(9),MNTHBYT(9)	/ 351,10 /	! (9)	MNTSIN
	DATA	MNTHOFF(10),MNTHBYT(10)	/ 361,10 /	! (10)	MNTCOS
	DATA	MNTHOFF(11),MNTHBYT(11)	/ 381,10 /	! (11)	MNTZRNG
	DATA	MNTHOFF(12),MNTHBYT(12)	/ 401,10 /	! (12)	MNTZUN
	DATA	MNTHOFF(13),MNTHBYT(13)	/ 411,5 /	! (13)	MNTDSIZE
C
	END
