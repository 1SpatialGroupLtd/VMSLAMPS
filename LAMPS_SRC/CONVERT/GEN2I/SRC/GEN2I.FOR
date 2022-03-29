	program geniff
C++++
C----	Program to translate genamap to IFF for LSL
C----	JM v1.0 17/5/91 -- derived from cgfiffc of 30/3/90
C****
	implicit none
C
	integer*4	luno,luns,luna,lunp
	common/funits/luno,luns,luna,lunp
	data luno,luns,luna,lunp/1,2,3,4/
	call geolod
	call get_proc	
	call scan_in
	call iff_hdr
	call iff_data
	call iff_eof
	call exit
	end
	subroutine get_proc
	include 'procdat.inc'
	common/funits/luno,luns,luna,lunp
10	write(6,FMT='(A,$)')' Parameter file name?'
1	format(a)
	read(5,1)par_file
	open(unit=lunp,file=par_file,status='old',err=199)
	read(lunp,1)out_file
C----	read in the maplist
20	ndat=ndat+1
	read(lunp,1,err=30,end=30)dat_file(ndat)
	go to 20
30	ndat=ndat-1
C----	close the file
	close(unit=lunp)
	return
199	continue
	write(6,1)'*** cannot open file -- Re-enter the name ***'
	go to 10
	end
	subroutine scan_in
	real*8 xy(10)
	character*40 dline
	character*55 hline
	byte filesp(80)
	include 'procdat.inc'
	common/funits/luno,luns,luna,lunp
	if(ndat.eq.0)stop
	rxmin=999999999.
	rymin=rxmin
	rxmax=-rxmin
	rymax=rxmax
	do 100 i=1,ndat
	do 201 j=1,80
201	filesp(j)=0
	decode(80,1,dat_file(i))filesp
1	format(80a1)
	iseg=0
	iann=0
	nc=80
	call compby(filesp,nc)
C----	OPEN vector file
	call moveby(4,filesp(nc+1),'.DAT')
	filesp(nc+5)=0
	open(unit=luns,file=filesp,status='old',err=3)
	iseg=1
	go to 4
3	write(6,2)(filesp(ik),ik=1,nc+4)
2	format(' File Missing -',80a1)
C----	OPEN TEXT file
4	call moveby(5,filesp(nc+1),'T.DAT')
	filesp(nc+6)=0
	open(unit=luna,file=filesp,status='old',err=5)
	iann=1
	go to 6
5	write(6,2)(filesp(ik),ik=1,nc+5)
C----	NOW SCAN THE VECTOR DATA TO ESTABLISH THE RANGE
6	if(iseg.eq.0)go to 30
10	read(luns,11,err=29,end=29)hline
11	format(a)
	nend=55
123	if(hline(nend:nend).eq.' ')then
		nend=nend-1
		go to 123
	endif
	read(unit=hline(51:nend),fmt='(i)')numpnt
	if(numpnt.eq.0)go to 10
	do 20 j =1,numpnt
	read(luns,11,err=29,end=29)dline
	call ctxy(dline,xy)
	if(rxmin.gt.xy(1))rxmin=xy(1)
	if(rxmax.lt.xy(1))rxmax=xy(1)
	if(rymin.gt.xy(2))rymin=xy(2)
	if(rymax.lt.xy(2))rymax=xy(2)
20	continue
	go to 10	
29	close(luns)
30	if(iann.eq.0)go to 100
C----	NOW SCAN THE TEXT DATA TO ESTABLISH THE RANGE
40	read(luna,41,err=59,end=59)hline,dline
41	format(/,a,/,a,/,/,/,/)
	call ctxy(dline,xy)
	if(rxmin.gt.xy(1))rxmin=xy(1)
	if(rxmax.lt.xy(1))rxmax=xy(1)
	if(rymin.gt.xy(2))rymin=xy(2)
	if(rymax.lt.xy(2))rymax=xy(2)
	go to 40
59	close(luna)
100	continue
	print *,' rxmin=',rxmin,' rxmax=',rxmax
	print *,' rymin=',rymin,' rymax=',rymax
	return
	end
	subroutine iff_hdr
c	integer*4 nfeat
	include 'procdat.inc'
	common/funits/luno,luns,luna,lunp
	open(unit=luno,file=out_file,status='new',carriagecontrol='list')
	call ra_rec
	call hi_rec
	call mh_rec
	call md_rec
	call ns_rec
	call cc_rec
	call cp_rec
	return
	end
	subroutine ra_rec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
	write(luno,1)rxmin,rxmax,rymin,rymax
1	format('RA ',4F16.5)
	return
	end
	subroutine hi_rec
	character*60 hirec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
	write(luno,1)
1	format('HI')
2	format(a)
	call date(hirec(1:9))
	hirec(10:11)=hirec(8:9)
	hirec(8:9)='19'
	hirec(12:12)=' '
	call time(hirec(13:20))
	hirec(18:60)=' DUMMY      GENIFF   GENAMAP-19+25 to IFF'
	write(luno,2)hirec
	return
	end
	subroutine mh_rec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
	write(luno,1)
1	format('MH 0 0')
	return
	end
	subroutine md_rec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
	write(luno,1)
1	format('MD -1')
	return
	end
	subroutine ns_rec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
	write(luno,1)
1	format('NS created by GENIFF')
	return
	end
	subroutine cc_rec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
	write(luno,1)
1	format('CC  .00000000E 000  .00000000E 000')
	write(luno,2)
2	format('    .10000000E 001  .00000000E 000')
	write(luno,3)
3	format('    .00000000E 000  .10000000E 001')
	do 10 i=4,10
10	write(luno,11)
11	format('    .00000000E 000  .00000000E 000')
	return
	end
	subroutine cp_rec
	include 'procdat.inc'
	common/funits/luno,luns,luna,linp
c	write(luno,1)rymax-rymin,rymax-rymin
c1	format('CP','    0.000000',1x,f10.5,1x,'  0.000000',1x,f10.5)
c	write(luno,2)
c2	format('      0.000000   0.000000   0.000000   0.000000')
c	write(luno,3)rxmax-rxmin,rxmax-rymin
c3	format('   ',f10.5,1x,'  0.000000',1x,f10.5,'   0.000000')
c	write(luno,4)rxmax-rxmin,rymax-rymin,rxmax-rxmin,rymax-rymin
c4	format(4x,f10.5,1x,f10.5,1x,f10.5,1x,f10.5)
	write(luno,1)rxmin,rymax,rxmin,rymax
1	format('CP  ',f10.1,1x,f10.1,1x,f10.1,1x,f10.1)
	write(luno,4)rxmin,rymin,rxmin,rymin
	write(luno,4)rxmax,rymin,rxmax,rymin
	write(luno,4)rxmax,rymax,rxmax,rymax
4	format(4x,f10.1,1x,f10.1,1x,f10.1,1x,f10.1)
	return
	end
	subroutine iff_data
	character*32 geocod
	real*8 xy(10)
	byte filesp(80)
	CHARACTER*55 HLINE
	CHARACTER*40 DLINE
	include 'procdat.inc'
	common/funits/luno,luns,luna,lunp
	if(ndat.eq.0)stop
	write(luno,2)
2	format('NO 1 0')
	do 100 i=1,ndat
	decode(80,1,dat_file(i))filesp
1	format(80a1)
	iseg=0
	iann=0
	nc=80
	call compby(filesp,nc)
C----	OPEN vector file
	call moveby(4,filesp(nc+1),'.DAT')
	filesp(nc+5)=0
	open(unit=luns,file=filesp,status='old',err=3)
	iseg=1
	go to 4
3	write(6,222)(filesp(ik),ik=1,nc+4)
222	format(' File Missing -',80a1)
C----	OPEN TEXT file
4	call moveby(5,filesp(nc+1),'T.DAT')
	filesp(nc+6)=0
	open(unit=luna,file=filesp,status='old',err=5)
	iann=1
	go to 6
5	write(6,222)(filesp(ik),ik=1,nc+5)
C----	NOW SCAN THE VECTOR DATA TO ESTABLISH THE RANGE
6	if(iseg.eq.0)go to 30
10	read(luns,115,err=29,end=29)hline
115	format(a)
	nend=55
123	if(hline(nend:nend).eq.' ')then
		nend=nend-1
		go to 123
	endif
	read(unit=hline(51:nend),fmt='(i)')numpnt
	kl=numpnt
	knum=numpnt
	if(kl.ge.200)knum=200
	if(numpnt.eq.0)go to 10
	nfeat=nfeat+1
	write(luno,14)nfeat,nfeat
14	format('NF ',I6,i6)
	write(luno,15)
15	format('TH 0')
	GEOCOD=HLINE(16:47)
	call geoiff(geocod,ifrt)
	write(luno,161)ifrt
161	format('FS',i4,' 2 0 0')
	write(luno,11)knum
	k=0
	do 20 j =1,numpnt
	read(luns,115,err=29,end=29)dline
	call ctxy(dline,xy)
	k=k+1
	if(k.eq.201)then
		k=1
		kl=kl-200
		knum=kl
		if(knum.gt.200)knum=200
		write(luno,111)knum
111		format('ST ',i3,' 1')
	endif
11	format('ST ',i3,' 0')
c	write(luno,13)xy(1)-rxmin,xy(2)-rymin
	write(luno,13)xy(1),xy(2)
c13	format(2(1x,f10.5))
13	format(2(1x,f10.1))
20	continue
	write(luno,21)
21	format('EF')
	go to 10	
29	CLOSE(UNIT=LUNS)
30	if(iann.eq.0)go to 100
40	read(luna,41,err=59,end=59)hline,dline
41	format(/,a,/,a,/,/,/,/)
	call ctxy(dline,xy)
	nfeat=nfeat+1
	write(luno,14)nfeat,nfeat
	GEOCOD=HLINE(1:32)
	call geojff(geocod,ifrt)
	write(luno,162)ifrt
162	format('FS',i4,' 0 -1')
	write(luno,577)
577	format('TH 12')
	write(luno,578)
578	format('ST 1 0')
c	write(luno,13)xy(1)-rxmin,xy(2)-rymin
	write(luno,13)xy(1),xy(2)
	ANGLE=0.0
	if((Abs(angle).le.3).or.(angle.ge.353))angle=0
	radang=angle/57.29578
	write(luno,579)radang
579	format('RO',f7.4)
	write(lunO,580)HLINE(1:32)
580	format('TX ',a)
	write(luno,21)
	go to 40
59	cLOSE(UNIT=LUNA)
100	continue
	write(luno,101)
101	format('EO')
	return
	end
	subroutine iff_eof
	common/funits/luno,luns,luna,lunp
	write(luno,1)'EO'
	write(luno,1)'EM'
	write(luno,1)'EJ'
1	format(a)
	close(unit=luno)
	return
	end	
	subroutine geoiff(geocod,ifrt)
	character*32 gcode,geocod
	common/geofrt/ncode,gcode(200),jfrt(200),kfrt(200)
	do 10 i =1,ncode
	if(geocod.eq.gcode(i))then
		ifrt=jfrt(i)
		return
	endif
10	continue
	ifrt=0
	write(6,11)geocod
11	format(' GENAMAP code:',A32,' not found - using code 0')
	return
	end
	subroutine geojff(geocod,ifrt)
	character*32 gcode,geocod
	common/geofrt/ncode,gcode(200),jfrt(200),kfrt(200)
	do 10 i =1,ncode
	if(geocod.eq.gcode(i))then
		ifrt=kfrt(i)
		return
	endif
10	continue
	ifrt=0
	write(6,11)geocod
11	format(' GENAMAP code:',A32,' not found - using code 0')
	return
	end
	subroutine geolod
	character*32 gcode
	common/geofrt/ncode,gcode(200),jfrt(200),kfrt(200)
	common/funits/luno,luns,luna,lunp
	open(unit=lunp,file='geNfrt.dat',status='old')
	i=0
10	i=i+1
	read(lunp,11,err=100,end=100)gcode(i),jfrt(i),kfrt(i)
11	format(a32,i4,i4)
	go to 10
100	ncode=i-1
	close(unit=lunp)	
	return
	end
	subroutine ctxy(dline,xy)
	character*40 dline
	real*8 xy(2)
	integer*2 i,j
	ik = 0
	do 10 i =1,40
	if((dline(i:i).ne.' ').and.(ik.eq.0))ik=1
	if((ik.eq.1).and.(dline(i:i).eq.' '))then
		j = i
		go to 20
	endif
10	continue
	stop 'badrec'
C20	read(unit=dline(1:j-1),fmt='(f)')xy(1)	
C	read(unit=dline(j+1:40),fmt='(f)')xy(2)
C
20	read(unit=dline(1:j-1),fmt=*)xy(1)	
	read(unit=dline(j+1:40),fmt=*)xy(2)
	return
	end

	SUBROUTINE MOVEBY(N,ARRAY1,ARRAY2)
C
C   DESCRIPTION :-  MOVES N BYTES FROM ARRAY2 TO ARRAY1 WITHOUT
C                   ALTERING ARRAY2
C
C   USAGE :-  CALL MOVEBY(NBYTES,ARRAY1,ARRAY2)
C             ARRAY1, ARRAY2  ARE ARRAYS OF ANY TYPE
C             NBYTES  IS AN INTEGER*2 VARIABLE
C
C
	BYTE ARRAY1(1),ARRAY2(1)
	IF (N.LE.0) RETURN  ! N<=0 THEN LEAVE ARRAY1 UNCHANGED
	DO 10 I=1,N
10	ARRAY1(I)=ARRAY2(I)
	RETURN
	END
	SUBROUTINE COMPBY(STR,LSTR)
C++++
C----	Srtn to compress a char string
C----	v 1.0 jm 22/9/81
C****
	BYTE STR(1),BLANK
	DATA BLANK/' '/
	IF(LSTR.EQ.0)RETURN
	LCNT = LSTR
	DO 10 I = LSTR,1,-1
	IF(STR(I).NE.BLANK)GO TO 10
	LCNT = LCNT - 1
	IF(I.EQ.LCNT+1)GO TO 10
	DO 20 J = I,LCNT
20	STR(J) = STR(J+1)
10	CONTINUE
	IF(LCNT.EQ.LSTR)RETURN
	DO 30 J = LCNT+1,LSTR
30	STR(J)=BLANK
	LSTR = LCNT
	RETURN
	END
