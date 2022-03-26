[INHERIT ('Inherit_File')]
MODULE PLT002 ;

{ PLT002.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE IOD_Initialise_Output_Device ;
(********************************************************************)
VAR
  Error:	BOOLEAN ;

BEGIN

  { If valid device, get P4_IO, open P4 text file }
  IF NOT ( Plotter_Device IN [VWS, P_DSP, KRISS] ) THEN
    BEGIN  

      KT_Kern_Title (Ten_Digit_Number, Title) ;
      IRAWF_Indicate_Reading_And_Writing_Files
        ('  Reading Input / Output Address File   ',
         'READING KPH$WS:KERNIO.DAT               ' ) ;

      CURPOS_Cursor_Position ( 6, 17 ) ;
      DBHEIG_Double_Height ( 0 ) ;
      WRITELN ( Plotter:5 ) ;
      CURPOS_Cursor_Position ( 7, 17 ) ;
      WRITELN ( Plotter:5 ) ;

      TD_Time_Delay ( 0.5 );

      RIODF_Read_IO_Definition_File ( P4_Code, P4_IO ) ;
      GIOP_Get_IO_Port ( P4_Code, P4_Port, Error ) ;

      { Note that we should really take 'evasive action' if there was an error }
      IF Error THEN WRITELN ( 'PLT002: Error on return from GIOP' ) ;

      OPEN ( P4, P4_Port ) ;
      REWRITE ( P4 ) ;

    END ;

    IF Plotter_Device IN [KRISS,P_DSP] THEN
      SUP_Start_User_Program ;

END ;
END.
