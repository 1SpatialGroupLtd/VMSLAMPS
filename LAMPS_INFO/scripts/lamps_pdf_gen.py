#!python3
#Filename: lamps_pdf_gen.py
#
# Python Script to create pdf of LAMPS manuals
#
# Created PGH 2019-04-17
# Modified PGH 2019-04-25 (Handle escape sequences)

from __future__ import with_statement
import os, string, re, sys, time, datetime
## sys.path.append('C:\Temp\pyfpdf-master\fpdf')
# py -3 -m pip install fpdf
import fpdf


def main():
        "Script to create pdf of LAMPS manuals"
#
        rootDir = '../../LAMPS_MANUALS'
        for dirName, subdirList, fileList in os.walk(rootDir):
                print('Found directory: %s' % dirName)
                level = dirName.count(chr(92))
#       print('Level = %d' % level)
                if level==1:
                        package = dirName.rsplit(chr(92),1)[1]
                        print("LAMPS Manuals for package " + package)
                        component="*"
                elif level==2:
                        component = dirName.rsplit(chr(92),1)[1]
                        print("LAMPS package " + package + " manual " + component)
                elif level>2:
                        subfolder = dirName.rsplit(chr(92),1)[1]
                        print("LAMPS software package " + package + " component " + component + ", subfolder " + subfolder)
                for fname in fileList:
                        fullpath=dirName+'\\'+fname
                        modified = os.path.getmtime(fullpath)
                        modtime = time.strftime("%d-%b-%Y",time.localtime(modified))
                        relpath = fullpath.replace('../../', '../')
                        if fname.endswith('.LNI'):
                                print('\t%s is a LAMPS manual file, modified %s' % (fname, modtime))
                                ansitopdf(package,component,fullpath,fname)
        return

# Convert Ansi Text to PDF
def ansitopdf(package,component,fullpath,fname):
        pdf = fpdf.FPDF('P', 'mm', 'A4')
        pdf.add_page()
        pdf.set_margins(8.0,10.0,7.0)
        pdf.set_author("Laser-Scan Ltd, converted by Paul Hardy")
        pdf.set_subject("LAMPS Automated Map Production Software - Manuals")
        pdf.set_title("LAMPS package "+package+", manual "+component+", Item "+fname.replace('.LNI',''))
        pdf.set_font('Courier','',11)
        height=4.2
        with open(fullpath) as file:
                inescape=0
                inbold=0
                initalic=0
                inunderline=0
                for line in file.readlines():
###                        print(line.replace('\n',''))
                        part=''
                        nchrs=0
                        for i in range( len(line) ):
                                c=line[i]
###                                print("/%s/ %s / %s /" % (c,str(ord(c)),hex(ord(c))))
                                if inescape>0:
                                        inescape=inescape+1
                                        if inescape==2 and c!='[':
                                                print("Unexpected open after escape - "+c)
                                        if inescape==3:
                                                if c=='0':
                                                        pdf.set_font('Courier','',11)
                                                        inbold=0
                                                        initalic=0
                                                        inunderline=0
                                                elif c=='1':
                                                        pdf.set_font('Courier','B',11)
                                                        inbold=1
                                                elif c=='2':
                                                        print(c+" found in escape")
                                                        print(c+" unexpected escape")
                                                elif c=='3':
                                                        pdf.set_font('Courier','I',11)
                                                        initalic=1
                                                elif c=='4':
                                                        pdf.set_font('Courier','U',11)
                                                        inunderline=1
                                                if inbold and initalic:
#                                                        print("Bold and Italic")
                                                        pdf.set_font('Courier','BI',11)
                                                if inbold and inunderline:
#                                                        print("Bold and Underline")
                                                        pdf.set_font('Courier','BU',11)
                                                if initalic and inunderline:
#                                                        print("Italic and Underline")
                                                        pdf.set_font('Courier','IU',11)
                                                if initalic and inunderline and inbold:
#                                                        print("Italic and Underline and Bold")
                                                        pdf.set_font('Courier','IUB',11)
                                        if inescape==4:
                                                if c!='m':
                                                         print("Unexpected close after escape - "+c)
                                                inescape=0
                                elif c=='\n':
                                        pdf.write(height, part)
                                        pdf.ln(height)
                                        part=''
                                        nchrs=0
                                elif c==chr(27):
                                        inescape=1
                                        pdf.write(height, part)
                                        part=''
                                        nchrs=0
                                elif c==chr(12):
                                        pdf.write(height, part)
                                        pdf.ln(height)
                                        part=''
                                        nchrs=0
                                        pdf.add_page()
                                else:
                                        nchrs=nchrs+1
                                        part=part+c
                pdf.output(fullpath.replace(".LNI",".PDF"), 'F')
        return

# #Start point for script

main()

# All done.

