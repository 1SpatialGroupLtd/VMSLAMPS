


New DTMCONVERT package on TEST_ROOT


IIS2DTI.EXE and DTI2IIS.EXE (public_root) versions read/write 500 format
IIS files which are expected to be written in 512 byte wide stripes down
the data file, in a 512 byte fixed-format disk file.

The data sent from ENTERA (supposedly in 500 format) is nothing like this,
instead being a 5750 byte stripe covering the whole file, and written to
tape in 5750 byte blocks which was transferred to a disk file of 5750 byte
fixed-format block records.

There is a new version of the IIS2DTI program in IIS2DTI.NEW_EXE (on test_root)
which can read this new version of 500 format. It works in the same way as 
before, except that a new qualifier /WIDTH (= 5750) must be given to override
the default behaviour of reading the normal 512 byte 500 format.



NB. Both versions of IIS2DTI (and the unchanged DTI2IIS) can be given a 
/HEADER = n qualifier to specify how many header blocks to read/write,
(the default being 1, but all real data seems to have none and /HEADER=0 must
be given for each program run to convert the whole file).


	IIS6DTI

The second IIS format is 600 format, which used to be read/written by IIS6DTI
and DTI6IIS programs (which have never been supported). These 2 programs are
on test_root as IIS6DTI.NEW_EXE and DTI6IIS.NEW_EXE, run in the same way as 
DTI2IIS/IIS2DTI, but with no qualifiers to control the output. It has not been
possible to read the 600 format data sent from ENTERA with IIS6DTI.


The 2 files from ENTERA are on LSLM3B$DUA7:[LSLDATA.BARH]

	BARH.IMAGE is the 600 format which we cannot read

	FILE500.IMAGE is 500 format, read by IIS2DTI.NEW_EXE as:

		IIS2DTI/HEADER=0/WIDTH=5750  HERE:FILE500.IMAGE  HERE:OUT.DTI



A DIR/FULL command will show the format of the disk to be read, and the block
size to be given with the /WIDTH qualifier if it is not the usual 500 format
data type (512 byte blocks).


Any file on tape can be read to disk with the DCL commands:

	$MOUNT/FOR/BLOCK=<block-size>/RECORD=<block-size>  <tape-dev> 
	$CONVERT/FDL=SYS$INPUT  <tape-dev>  <disk-file>
		RECORD
		FORMAT FIX
		SIZE <block-size>

	<CTRL-Z>

The <block-size> can be obtained from SH DEV/FULL  <tape-dev>


A dump <disk-file> command will show how many header blocks there are before 
the real data.



	BLOCK_COPY

There is a new program on test_root called BLOCK_COPY which can copy one file to
another, omitting any block(s) specified in the /SKIP = n qualifier.

Eg. BLOCK_COPY  <infile>  <outfile> / SKIP=(1,4:5)

	will copy the infile to the outfile, omitting blocks 1,4 and 5.

This may enable a strange file to be massaged into something readable by
either IIS2DTI or IIS6DTI. In particular, the untranslatable header blocks 
may be stripped out.



