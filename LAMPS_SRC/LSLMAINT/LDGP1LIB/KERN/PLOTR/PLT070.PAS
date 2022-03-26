[INHERIT ('Inherit_File')]
MODULE PLT070 ;

{ PLT070.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE EPP_Exit_Plot_Program ;
(**********************************************************************)

BEGIN (* PROCEDURE EPP_Exit_Plot_Program *)

    { lift the pen }
    LOCATION := START ;
    CAM_Mode := 1 ;
    Last_Foot_Pedal := Left ;
    PD_Plot_Datas ;

    { If using DSP/KRISS, register and switch on RT program }
    IF ( Plotter_Device IN [KRISS] ) THEN
      IF Device_Previously_Running THEN
        BEGIN
          IStatus := CNGRTL ( 1 ) ;
          IF IStatus <> 0 THEN
            WRITELN ( 'PLT070: Error on return from CNGRTL' ) ;
        END
      ELSE
        BEGIN
TD_Time_Delay ( 2.0 ) ;
          BStatus := Registration ;
          IF NOT BStatus THEN
            WRITELN ( 'PLT070: Error on return from registration' ) ;
        END ;

    { If using an HP plotter, return pen to carousel }
    IF Plotter_Device = HP THEN
      PPen ( P4, 0 ) ;

    { close the files }
    CLOSE (Library_Pointer) ;
    CLOSE ( Input_File ) ;
    IF NOT ( Plotter_Device IN [VWS,KRISS,P_DSP] ) THEN
      CLOSE ( P4 ) ;

    { If plotting on screen then allow metafile operations }
    IF ( Plotter_Device = VWS ) THEN
      IF Plot_Selected_Layers THEN
        Read_And_Write_Metafiles ( Ten_Digit_Number, Title, Scape )
      ELSE
        IF NOT Scape THEN
          Read_And_Write_Metafiles ( Ten_Digit_Number, Title, Scape ) ;

    IF Plotter_Device IN [KRISS,P_DSP] THEN
      Close_Plotter ( P4 ) ;

    { reset scroll }
    SETSCR_Set_Scroll (1,24) ;

    ERASCR_Erase_Screen ;

END ; (* PROCEDURE  EPP_Exit_Plot_Program *)
END.
