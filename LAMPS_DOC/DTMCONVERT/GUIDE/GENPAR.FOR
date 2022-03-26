	PROGRAM GENPAR
C
***	MODULE	GENPAR
***	IDENT	05AU88
C
C declare a string to hold messages, so they are output
C with a standard width (ie just to look prettier)
C
        CHARACTER*31  MESNAME
C
C declare all our messages as EXTERNAL
C
        INTEGER        DTI2IIS__Normal         
        EXTERNAL       DTI2IIS__Normal         
        INTEGER        DTI2IIS__HEIGHT         
        EXTERNAL       DTI2IIS__HEIGHT         
        INTEGER        DTI2IIS__EXTENT         
        EXTERNAL       DTI2IIS__EXTENT         
        INTEGER        DTI2IIS__NUMCOLSWA      
        EXTERNAL       DTI2IIS__NUMCOLSWA      
        INTEGER        DTI2IIS__ERRREAHEA      
        EXTERNAL       DTI2IIS__ERRREAHEA      
        INTEGER        DTI2IIS__UNACLODTI      
        EXTERNAL       DTI2IIS__UNACLODTI      
        INTEGER        DTI2IIS__UNACLOIIS      
        EXTERNAL       DTI2IIS__UNACLOIIS      
        INTEGER        DTI2IIS__UNAOPNDTI      
        EXTERNAL       DTI2IIS__UNAOPNDTI      
        INTEGER        DTI2IIS__UNAOPNIIS      
        EXTERNAL       DTI2IIS__UNAOPNIIS      
        INTEGER        DTI2IIS__UNAWRIIIS      
        EXTERNAL       DTI2IIS__UNAWRIIIS      
        INTEGER        DTI2IIS__UNAREADTI      
        EXTERNAL       DTI2IIS__UNAREADTI      
C
C open our output files
C
        OPEN(UNIT=6,FILE='LSL$DOC_ROOT:[DTMCONVERT.GUIDE]DTI2IISMSG.PAR',STATUS='NEW',
     &		CARRIAGECONTROL='LIST')
C
C
C define the formats we will use to output the data
C
600     FORMAT('        INTEGER    ',A)
601     FORMAT('        PARAMETER (',A,'=',I,')')
C
C and we can thus output a definition of each message
C to the output files
C
        MESNAME='DTI2IIS__Normal         '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__Normal         )
        MESNAME='DTI2IIS__HEIGHT         '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__HEIGHT         )
        MESNAME='DTI2IIS__EXTENT         '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__EXTENT         )
        MESNAME='DTI2IIS__NUMCOLSWA      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__NUMCOLSWA      )
        MESNAME='DTI2IIS__ERRREAHEA      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__ERRREAHEA      )
        MESNAME='DTI2IIS__UNACLODTI      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__UNACLODTI      )
        MESNAME='DTI2IIS__UNACLOIIS      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__UNACLOIIS      )
        MESNAME='DTI2IIS__UNAOPNDTI      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__UNAOPNDTI      )
        MESNAME='DTI2IIS__UNAOPNIIS      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__UNAOPNIIS      )
        MESNAME='DTI2IIS__UNAWRIIIS      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__UNAWRIIIS      )
        MESNAME='DTI2IIS__UNAREADTI      '
        WRITE (6,600) MESNAME
        WRITE (6,601) MESNAME,%LOC(DTI2IIS__UNAREADTI      )
        CLOSE (UNIT=6,DISPOSE='KEEP')
        CALL EXIT
        END
