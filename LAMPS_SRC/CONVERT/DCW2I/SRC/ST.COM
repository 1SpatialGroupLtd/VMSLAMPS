!DEVICE LSL$DATA_ROOT:
!TARGET LSL$DATA_ROOT:[DCW.IFF]
DEVICE LSLV4D$DKA200:
!TARGET LSLV4D$DKA100:[LSLDATA.DCW]
TARGET LSL$SOURCE_ROOT:[CONVERT.DCW2I]
!DESEL CLASS ALL
!SEL CLASS LINE
SEL LIB SASAUS
!SEL COV AE,CL,DQ,DS,HS,LC,OF,PH,PO,RD,RR,TS,UT
SEL COV DN
SEL GEO TJ,UJ,VJ,TH,UH,VH,TG,UG,VG
ACFILE DCW.ACT
FCFILE DCW.FCT
GO