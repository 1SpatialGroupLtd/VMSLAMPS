C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LVF -- GP1 LIBRARY VMS/FORTRAN
C
      SUBROUTINE MESSAG (STATUS)
C                       Messages to the user (on the terminal)
C=====================================================================

C... variables:

      CHARACTER  BELL
      INTEGER*2  STATUS
      INTEGER*2  ANSWER
      INTEGER*2  UNITO,UNITI

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... input and output units
C
      BELL  = CHAR(7)
      UNITO = 5
      UNITI = 5
C
      GOTO (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,
     +      24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
     +      44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,
     +      64,65,66,67,68,69,70,71,72), STATUS
C
1     WRITE (UNITO,9001)
      GOTO 200
2     WRITE (UNITO,9002)
      GOTO 200
3     WRITE (UNITO,9003)
      GOTO 200
4     WRITE (UNITO,9004)
      GOTO 200
5     WRITE (UNITO,9005)
      GOTO 200
6     WRITE (UNITO,9006)
      GOTO 200
7     WRITE (UNITO,9007)
      GOTO 200
8     WRITE (UNITO,9008)
      GOTO 200
9     WRITE (UNITO,9009)
      GOTO 200
10    WRITE (UNITO,9010)
      GOTO 200
11    WRITE (UNITO,9011)
      GOTO 200
12    WRITE (UNITO,9012)
      GOTO 200
13    WRITE (UNITO,9013)
      GOTO 200
14    WRITE (UNITO,9014)
      GOTO 200
15    WRITE (UNITO,9015)
      GOTO 150
16    WRITE (UNITO,9016)
      GOTO 200
17    WRITE (UNITO,9017)
      GOTO 200
18    WRITE (UNITO,9018)
      GOTO 200
19    WRITE (UNITO,9019)
      GOTO 200
20    WRITE (UNITO,9020)
      GOTO 200
21    WRITE (UNITO,9021)
      GOTO 200
22    WRITE (UNITO,9022)
      GOTO 200
23    WRITE (UNITO,9023)
      GOTO 200
24    WRITE (UNITO,9024)
      GOTO 200
25    WRITE (UNITO,9025)
      GOTO 200
26    WRITE (UNITO,9026)
      GOTO 200
27    WRITE (UNITO,9027)
      GOTO 200
28    WRITE (UNITO,9028)
      GOTO 200
29    WRITE (UNITO,9029)
      GOTO 200
30    WRITE (UNITO,9030)
      GOTO 200
31    WRITE (UNITO,9031)
      GOTO 200
32    WRITE (UNITO,9032)
      GOTO 200
33    WRITE (UNITO,9033)
      GOTO 200
34    WRITE (UNITO,9034)
      GOTO 200
35    WRITE (UNITO,9035)
      GOTO 200
36    WRITE (UNITO,9036)
      GOTO 200
37    WRITE (UNITO,9037)
      GOTO 200
38    WRITE (UNITO,9038)
      GOTO 200
39    WRITE (UNITO,9039)
      GOTO 200
40    WRITE (UNITO,9040)
      GOTO 200
41    WRITE (UNITO,9041)
      GOTO 200
42    WRITE (UNITO,9042)
      GOTO 200
43    WRITE (UNITO,9043)
      GOTO 200
44    WRITE (UNITO,9044)
      GOTO 200
45    WRITE (UNITO,9045)
      GOTO 200
46    WRITE (UNITO,9046)
      GOTO 100
47    WRITE (UNITO,9047)
      GOTO 200
48    WRITE (UNITO,9048)
      GOTO 200
49    WRITE (UNITO,9049)
      GOTO 100
50    WRITE (UNITO,9050)
      GOTO 200
51    WRITE (UNITO,9051)
      GOTO 200
52    WRITE (UNITO,9052)
      GOTO 200
53    WRITE (UNITO,9053)
      GOTO 200
54    WRITE (UNITO,9054)
      GOTO 200
55    WRITE (UNITO,9055)
      GOTO 200
56    WRITE (UNITO,9056)
      GOTO 200
57    WRITE (UNITO,9057)
      GOTO 200
58    WRITE (UNITO,9058)
      GOTO 200
59    WRITE (UNITO,9059)
      GOTO 200
60    WRITE (UNITO,9060)
      GOTO 200
61    WRITE (UNITO,9061)
      GOTO 100
62    WRITE (UNITO,9062)
      GOTO 200
63    WRITE (UNITO,9063)
      GOTO 200
64    WRITE (UNITO,9064)
      GOTO 200
65    WRITE (UNITO,9065) BELL
      GOTO 200
66    WRITE (UNITO,9066)
      GOTO 200
67    WRITE (UNITO,9067)
      GOTO 200
68    WRITE (UNITO,9068)
      GOTO 200
69    WRITE (UNITO,9069)
      GOTO 200
70    WRITE (UNITO,9070)
      GOTO 200
71    WRITE (UNITO,9071)
      GOTO 200
72    WRITE (UNITO,9072)
      GOTO 200
C
100   CONTINUE
      WRITE (UNITO,9100)
      ANSWER = '  '
      READ (UNITI,9101) ANSWER
      IF (ANSWER .EQ. 'Y ' .OR. ANSWER .EQ. 'y ') GOTO 200
150   CONTINUE
      WRITE (UNITO,9065) BELL
      CALL EXIT


200   CONTINUE
      RETURN

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... formats
C
9001  FORMAT (/1X,'GP1LVF - Characters are in buffer'/)
9002  FORMAT (/1X,'GP1LVF - Buffer empty'/)
9003  FORMAT ('+','GP1LVF - Buffer full')
9004  FORMAT (/1X,'GP1LVF - Enough place in buffer'/)
9005  FORMAT (/1X,'GP1LVF - Plotter in REMOTE'/)
9006  FORMAT ('+','GP1LVF - Plotter in LOCAL')
9007  FORMAT (/1X,'GP1LVF - Reference ok'/)
9008  FORMAT (/1X,'GP1LVF - Reference lost'/)
9009  FORMAT (/1X,'GP1LVF - Code not correct'/)
9010  FORMAT (/1X,'GP1LVF - Code ok'/)
9011  FORMAT (/1X,'GP1LVF - Checksum error'/)
9012  FORMAT (/1X,'GP1LVF - Checksum ok'/)
9013  FORMAT ('+','GP1LVF - Plotter in HALT')
9014  FORMAT (/1X,'GP1LVF - Plotter in CONTINUE'/)
9015  FORMAT (/1X,'GP1LVF - Try to start again !'/)
9016  FORMAT (/////////////////////,
     +        ' Copyright by Kern & Co. AG, CH-5001 Aarau, Switzerland',
     +        /,' GP1LVF -- GP1 Library VMS/Fortran 718.1X0.0700:-',
     +        ' January 1988', //)
9017  FORMAT (/1X,'GP1LVF - '/)
9018  FORMAT (/1X,'GP1LVF - '/)
9019  FORMAT (/1X,'GP1LVF - Illegal answer'/)
9020  FORMAT (/1X,'GP1LVF - Plotter not ready'/)
9021  FORMAT (/1X,'GP1LVF - Bad connection'/)
9022  FORMAT (/1X,'GP1LVF - Check if GP1 off, processor on HALT ',
     +        'or bad connection with GP1'/)
9023  FORMAT (//20X,'GP1LVF - END OF PLOTTING -',//)
9024  FORMAT (/1X,'GP1LVF - *VECTOR* - Parameter(s) not in range,  ',
     +        'no execution'/)
9025  FORMAT (/1X,'GP1LVF - *SCALE* - Parameter not in range, ',
     +        'no execution'/)
9026  FORMAT (/1X,'GP1LVF - *CIRCL1* - Parameter(s) not in range, ',
     +        'no execution'/)
9027  FORMAT (/1X,'GP1LVF - *SPLINE* - Parameter(s) not in range, ',
     +        'no execution'/)
9028  FORMAT (/1X,'GP1LVF - *SYSET* - Parameter not in range, ',
     +        'no execution'/)
9029  FORMAT (/1X,'GP1LVF - *SYSCAL* - Parameter not in range, ',
     +        'no execution'/)
9030  FORMAT (/1X,'GP1LVF - *SYROTA* - Parameter not in range, ',
     +        'no execution'/)
9031  FORMAT (/1X,'GP1LVF - *CHAR* - Parameter not in range, ',
     +        'no execution'/)
9032  FORMAT (/1X,'GP1LVF - *STRSET* - Parameter(s) not in range, ',
     +        'no execution'/)
9033  FORMAT (/1X,'GP1LVF - *STRSCL* - Parameter not in range, ',
     +        'no execution'/)
9034  FORMAT (/1X,'GP1LVF - *STROT* - Parameter not in range, ',
     +        'no execution'/)
9035  FORMAT (/1X,'GP1LVF - *STRSLN* - Parameter not in range, ',
     +        'no execution'/)
9036  FORMAT (/1X,'GP1LVF - *PENCHA* - Parameter not in range, ',
     +        'no execution'/)
9037  FORMAT (/1X,'GP1LVF - *LINSET* - Parameter(s) not in range, ',
     +        'no execution'/)
9038  FORMAT (/1X,'GP1LVF - *LINSCL* - Parameter not in range, ',
     +        'no execution'/)
9039  FORMAT (/1X,'GP1LVF - *LINRAT* - Parameter not in range, ',
     +        'no execution'/)
9040  FORMAT (/1X,'GP1LVF - *LINSYM* - Parameter not in range, ',
     +        'no execution'/)
9041  FORMAT (/1X,'GP1LVF - *LINSRO* - Parameter not in range, ',
     +        'no execution'/)
9042  FORMAT (/1X,'GP1LVF - *NEWORG* - Parameter(s) not in range, ',
     +        'no execution'/)
9043  FORMAT (/1X,'GP1LVF - *NEWIND* - Parameter(s) not in range, ',
     +        'no execution'/)
9044  FORMAT (/1X,'GP1LVF - *SPEED* - Parameter not in range, ',
     +        'no execution'/)
9045  FORMAT (/1X,'GP1LVF - *WHERE* - No coordinates available, ',
     +        'no execution'/)
9046  FORMAT (/1X,'GP1LVF - *WHERE* - Transmitting error in ',
     +        'recieved data, no execution'/)
9047  FORMAT (/1X,'GP1LVF - *SETPAR* - Parameter(s) not in range, ',
     +        'no execution'/)
9048  FORMAT (/1X,'GP1LVF - *MOVPLO* - Parameter not in range, ',
     +        'no execution'/)
9049  FORMAT (/1X,'GP1LVF - Please press SEEK REF key on the hand ',
     +        'controller !'/)
9050  FORMAT ('+'72(' '))
9051  FORMAT (/1X,'GP1LVF - *SYMDEF* - Invalid symbol definition, ',
     +        'no execution'/)
9052  FORMAT (/1X,'GP1LVF - *GPINIT* - "PLOTTER_LINE" not defined'/)
9053  FORMAT (/1X,'GP1LVF - *GPINIT* - "PLOTTER_LINE" is NOT a ',
     +        'terminalline'/)
9054  FORMAT (/1X,'GP1LVF - *GPINIT* - Error in SYS$GETDVIW'/)
9055  FORMAT (/1X,'GP1LVF - *TXTYP* - Parameter not in range, ',
     +        'no execution'/)
9056  FORMAT (/1X,'GP1LVF - *CHDIS* - Parameter not in range, ',
     +        'no execution'/)
9057  FORMAT (/1X,'GP1LVF - *PUTIN* - Error during write ',
     +        'to data file)'/)
9058  FORMAT (/1X,'GP1LVF - *GPINIT* - Error in SYS$ASSIGN'/)
9059  FORMAT (/1X,'GP1LVF - *GPINIT* - Error in SYS$QIOW'/)
9060  FORMAT (/1X,'GP1LVF - *GPINIT* - Parameter "mode" not in range'/)
9061  FORMAT (/1X,'GP1LVF - Please set GP1 to "CONTINUE" on the hand ',
     +        'controller !'/)
9062  FORMAT (/1X,'GP1LVF - Please set GP1 to "XON-XOFF" protocoll ',
     +        '(transmission-mode 2)'/)
9063  FORMAT (/1X,'GP1LVF - Fatal error ! Program aborted'/)
9064  FORMAT (/1X,'GP1LVF - *GPINIT* - error opening file'/)
9065  FORMAT (2A1)
9066  FORMAT (/1X,'GP1LVF - *GPSTAT* - Error in SYS$QIOW'/)
9067  FORMAT (/1X,'GP1LVF - *LOCAL* - Error in SYS$QIOW'/)
9068  FORMAT (/1X,'GP1LVF - *ORIWIN* - Error in SYS$QIOW'/)
9069  FORMAT (/1X,'GP1LVF - *PUTIN* - Error in SYS$QIOW'/)
9070  FORMAT (/1X,'GP1LVF - *SETORG* - Error in SYS$QIOW'/)
9071  FORMAT (/1X,'GP1LVF - *WHERE* - Error in SYS$QIOW'/)
9072  FORMAT (/1X,'GP1LVF - *WHERED* - Error in SYS$QIOW'/)

C
9100  FORMAT (/26X,'Continue ? (Y/N): ',$)
9101  FORMAT (A2)
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C
      E N D
