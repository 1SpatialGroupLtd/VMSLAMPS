#!/usr/bin/python 
#Filename: lamps_pdf_index_html.py
#
# Python Script to create html index to LAMPS documentation pdf manuals
#
# Created PGH 2019-04-13
# Modified PGH 2019-05-02 (for pdf)

import os, string, re, sys, time, datetime

def main():
	"Script to create html index for Laser-Scan LAMPS documentation sources"
	outhtmlfilename = "../lamps_pdf_index.html"
	try:
		outhtmlfile = open(outhtmlfilename, 'w')  
	except IOError:
		print("Can\'t open output html file for writing. "+outhtmlfilename)
		sys.exit(0)
        outhtmlfile.write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 3.2 Final//EN"">\n")
	outhtmlfile.write("<HTML><HEAD><TITLE>VMS LAMPS Software Documentation PDF Manuals index</TITLE>\n")
	outhtmlfile.write("<LINK rel=""stylesheet"" type=""text/css"" href=""lamps.css""></HEAD>\n")
	outhtmlfile.write("<H1>VMS LAMPS Software Documentation PDF Manuals Index</H1>\n")
	outhtmlfile.write("This is an automatically generated index to PDF (and LNI) versions of the human-readable documentation manuals of the VMS LAMPS digital mapping software suite.\n")	
	outhtmlfile.write("The documentation sources were extracted en-mass from the original Laser-Scan VMS system by Paul Hardy aided by 1Spatial staff in 2016-2017.\n")
	outhtmlfile.write("The documentation sources were then disentangled and separated from binary and customer files by Paul Hardy during 2018-2019. ")
	outhtmlfile.write("<P>The LAMPS manuals were regenerated using VMS RUNOFF as printable LNI files, then converted to PDF using a python script in May 2019, also by Paul Hardy.\n")
	outhtmlfile.write("See also the <A HREF=""lamps_source_index.html"">index to LAMPS source code</A>, ") 
	outhtmlfile.write("the <A HREF=""lamps_doc_index.html"">index to LAMPS documentation sources</A>, ") 
	outhtmlfile.write("and the <A HREF=""index.html"">index overview</A>.\n")
# 
	rootDir = '../../LAMPS_MANUALS'
	for dirName, subdirList, fileList in os.walk(rootDir):
#		print('Found directory: %s' % dirName)
		level = dirName.count(chr(92))
#		print('Level = %d' % level)
		if level==1:
			package = dirName.rsplit(chr(92),1)[1]
			print("LAMPS software package " + package)
			outhtmlfile.write("<H2>LAMPS software package " + package + "</H2>\n")
		elif level==2:
			component = dirName.rsplit(chr(92),1)[1]
			print("LAMPS software package " + package + " component " + component)
			outhtmlfile.write("<H3>LAMPS software package " + package + " component " + component + "</H3>\n")
		elif level>2:
			subfolder = dirName.rsplit(chr(92),1)[1]
			print("LAMPS software package " + package + " component " + component + ", subfolder " + subfolder)
			outhtmlfile.write("<H4>Subfolder " + subfolder + "</H4>\n")
		for fname in fileList:
			fullpath=dirName+'\\'+fname
			modified = os.path.getmtime(fullpath)
			modtime = time.strftime("%d-%b-%Y",time.localtime(modified))
			relpath = fullpath.replace('../../', '../')
			if fname.endswith(('.PDF', '.pdf')):
#				print('\t%s is a LAMPS manual pdf file, modified %s' % (fname, modtime))
				outhtmlfile.write(fname + ' is a LAMPS manual (<A href="' + relpath + '">download</A>), converted from <A href="' + relpath.replace('.PDF','.LNI') + '">LNI</A> to PDF on ' + modtime + '<BR>\n')
	outhtmlfile.write("<p><hr><a href=""index.html"">Go up to LAMPS archive index overview</a></BODY></HTML>\n")
	outhtmlfile.write("<P><I>Generated by lamps_pdf_index.py</BR>\n")
	return

# #Start point for script
main()

# All done.


