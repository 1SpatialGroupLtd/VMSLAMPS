[INHERIT ('Inherit_File')]
MODULE PLT010 ;

{ PLT010.PAS <> }

(********************************************************************)
 [GLOBAL] PROCEDURE IMV_Initialise_Main_Values ;
(********************************************************************)
CONST
   Big_Real = 1.0E+30 ;

VAR
   Plotter_Connected : BOOLEAN ;

   SString:			String_40 ;
   Number_Of_Characters:	INTEGER ;
   Return:			BOOLEAN ;
   Arrow_Key:			CHAR ;
   Program_Title:		String_40 ;
   Message:			ARRAY [1..1] OF PACKED ARRAY [1..40] OF CHAR ;
   Message_Lines:		INTEGER ;
   R_on_E:			BOOLEAN ;
   Program_Name:		String_14 ;
   Buffered:			BOOLEAN ;
   IStatus:			INTEGER ;
   P2_Loaded:			BOOLEAN ;

BEGIN (*  PROCEDURE IMV_Initialise_Main_Values *)

     Quiet_Display         := FALSE ;
     IF Plotter_Device IN [VWS,P_DSP,KRISS] THEN
       Quiet_Display := TRUE ;

     { actual cam mode }
     CAM_Mode              := 1 ;
     Line_Type_Code_Number := 1 ;
     Symbol_Code_Number    := 1 ;
     Display_Scale_Factor  := 1.0 ;

     New_Selection     := TRUE ;
     Last_Foot_Pedal   := Left ;

     { pen and spline }
     Pen      := UP ;
     Location := START ;

     Annotation := Blank_40 ;


     { define the plotter }
     Plotter_Connected := FALSE ;

     CASE Plotter_Device OF
       P_DSP: BEGIN
                P2CL_Check_If_P2_Loaded ( P2_Loaded ) ;
                Plotter_Connected := P2_Loaded ;
                IF Plotter_Connected THEN
                  BEGIN
                    IP_Initialize_Plotter ( P4 ) ;
                    Enable_Pline_Buffer ;
                  END ;
              END ;

      OTHERWISE  PS_Plotter_Status ( P4, Plotter_Connected ) ;

    END ;

     IF Plotter_Connected AND ( Plotter_Device IN [HP,VWS] ) THEN
       BEGIN
         IF Plotter_Device = VWS THEN
           BEGIN
             Program_Name := 'PLOTR' ;
             Buffered := TRUE ;

             { Bug workaround 29/6/88 }
             IF Plot_Horizontal_Size > 400.0 THEN
               Plot_Horizontal_Size := 400.0 ;
             IF Plot_Vertical_Size > 400.0 THEN
               Plot_Vertical_Size := 400.0 ;

             DP_Download_Parameters ( P4, Plot_Horizontal_Size,
					  Plot_Vertical_Size,
					  Program_Name,
					  Ten_Digit_Number,
                                          Buffered, Plot_X_Scale ) ;
             { Now 'trick' the system: because the program only 
               plots whats inside the limits defined by plot_h/v_size,
               we increase these values to big numbers }
             Plot_Horizontal_Size := Big_Real ;
             Plot_Vertical_Size   := Big_Real ;
           END ;
         IP_Initialize_Plotter ( P4 ) ;
       END ;

     { KRISS: initialize and/or store flag }
     IF Plotter_Device IN [KRISS] THEN
       BEGIN
         { Plotter_Connected => initialisation already done If already
           have the RT loop running, stop it: helps performance }
         Device_Previously_Running := Plotter_Connected ;

         IF NOT Device_Previously_Running THEN
           BEGIN
             IP_Initialize_Plotter ( P4 ) ;
             PS_Plotter_Status ( P4, Plotter_Connected ) ;
           END
         ELSE
           BEGIN
             IStatus := CNGRTL ( 0 ) ;
             IF ( IStatus <> 0 ) THEN
               WRITELN ( 'PLT010: Error on return from CNGRTL ' ) ;
           END ;
         Enable_Pline_Buffer ;
       END ;

     Plotter_Status := 'OFF  ' ;
     IF Plotter_Connected
        THEN Plotter_Status := 'ON   ' ;

     IF Plotter_Status <> 'ON   ' THEN 
       BEGIN
         Message [1] := 'Plotter not active' ;
         Message_Lines := 1 ;
         Program_Title := Title ;
         R_On_E := FALSE ;

         MAC_Message_And_Continue
 	   ( Ten_Digit_Number,
 	     Program_Title,
 	     Message,
	     Message_Lines,
	     R_On_E ) ;
         EP_Exit_Program ;
       END ;

END ; (*  PROCEDURE IMV_Initialise_Main_Values *)
END.
