C
	INTEGER*4 	ndat,iproj,iseg,iann,nfeat
	REAL*8		rxmin,rymin,rxmax,rymax
	CHARACTER*80	par_file,out_file,dat_file(300)
C
	COMMON/proc_dat/ ndat,iproj,iseg,iann,nfeat,rxmin,rymin,rxmax,rymax,
     &			 par_file,out_file,dat_file
C
