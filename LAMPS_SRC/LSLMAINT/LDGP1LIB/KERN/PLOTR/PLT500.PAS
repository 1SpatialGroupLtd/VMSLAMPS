[ENVIRONMENT ('PLOTFI.PEN')] PROGRAM PLOTFI ( INPUT, OUTPUT ) ;

%INCLUDE 'Plotr.glo/list'

{ PLT500.PAS <> }

{=====================================================================}
{                          PLOT PROGRAM                               }
{=====================================================================}

(**********************************************************************)
PROCEDURE Plot ;
(**********************************************************************)
VAR
   Finished : BOOLEAN ;
   Error    : BOOLEAN ;
   SString              : String_40 ;
   Number_Of_Characters : INTEGER   ;
   Return               : BOOLEAN   ;
   Max_Length           : INTEGER   ;

PROCEDURE Go_to_Plot ;
BEGIN

     { defined symbol }
     IF    ( Cam_Mode IN [5,9] )
       AND ( Symbol_File_Name <> Blank_40 )
       THEN PUDS_Plot_Users_Defined_Symbol
       ELSE PD_Plot_Datas ;

     { symbol annotation }
     IF    ( Cam_Mode IN [5,9] )
       AND ( Symbol_Annotation <> Blank_4 )
       AND Point_In
       THEN
           IF Annotation <> Blank_40 THEN
             PStr ( P4, Annotation )
           ELSE
             Plot_Annotation
               ( P4, Annotation, Plotter_Device, Symbol_Annotation,
                 Symbol_Annotation_Size, Symbol_Fixed_Text,
                 Symbol_Text_Rotation, Standard_Symbol_Size,
                 Display_Scale_Factor, X_Table, Y_Table,
                 Event_Counter, Event_Counter_Format, Computed_Area,
                 East, North, Height, P_Distance,
                 X_Format_Field, Y_Format_Field, Z_Format_Field, P_Format_Field,
                 X_Format_Decimals, Y_Format_Decimals,
                 Z_Format_Decimals, P_Format_Decimals,
                 Computed_Area_Format_Field, Computed_Area_Format_Decimals ) ;

     { arc }
     IF CAM_Mode = 8 THEN
       Plot_Arc ( P4, X_Table, Y_Table, Height, Last_Foot_Pedal,
                  X_Arc, Y_Arc, Z_Arc, N_Arc_Points, Plotter_Device ) ;

END ; (* PROCEDURE Go_to_Plot *)


BEGIN

     IDS_Init_Display_Screen ;

     Finished := FALSE ;

     REPEAT

           REPEAT
             READLN ( Input_File, Input_Record ) ;
             Record_Length := LS_Length_String ( Input_Record ) ;
           UNTIL Record_Length <> 0 ;

           IF NOT Quiet_Display
              THEN BEGIN
                        CURPOS_Cursor_Position ( 24, 0 ) ;
                        WRITELN ( Input_Record : Record_Length ) ;
                     END ;

           IF Input_Record [1] = ' '
              THEN BEGIN
                        IF    ( Cam_Mode IN [5,6,9] )
                          AND ( Last_Foot_Pedal = Left )
                          THEN Something_to_Plot := FALSE
                          ELSE Something_to_Plot := TRUE ;

                        IF Something_To_Plot
                           AND New_Selection
                           THEN BEGIN
                                     IF CAM_Mode IN [1..4, 7, 8]
                                        THEN Get_Line_Definition ;
                                     IF CAM_Mode = 7
                                        THEN Symbol_Code_Number :=
                                     Line_Node_Symbol_Number ;
                                     IF CAM_Mode IN [5,6,7,9]
                                        THEN Get_Symbol_Definition ;
				     ILS_Initialize_Line_and_Symbols
				       ( P4, CAM_Mode, Plotter_Status, Hardware_Line_Type_Number,
				         Standard_Line_Size, Line_Pen_Selection,
				         Line_Symbol_Rotation, Line_Symbol_Number,
				         Line_Ratio, Hardware_Symbol_Number,
				         Standard_Symbol_Size, Display_Scale_Factor,
				         Symbol_Pen_Selection, Symbol_Rotation,
				         Symbol_Annotation_Size, Symbol_Annotation_Text_Slant,
				         Symbol_Text_Rotation ) ;

                                     New_Selection := FALSE ;
                                  END ;

                        IF Something_To_Plot
                           AND Plot_Selected_Layers
                          THEN STP_Something_to_Plot ;

                        IF Something_To_Plot
                           THEN BEGIN
                                     GGC_Get_ground_Coordinates
                                        ( East,North, Height, Annotation,
                                          Error ) ;

                                     IF NOT Error
                                        THEN Go_to_Plot ;
                                  END ;
                      END
               ELSE BEGIN
                         IS_Interpret_String ;
                         IF     ( Input_Record [1] = 'Q' )
                            OR  ( Input_Record [1] = 'q' )
                            THEN Finished := TRUE ;
                      END ;

           IRKB_Interrupt_Read_Key_Board
               ( SString, Number_Of_Characters, Scape, Return, Arrow_Key, 1 ) ;

           IF Scape
              AND ( Arrow_Key = ' ' )
              THEN Finished := TRUE
              ELSE Scape := FALSE ;

           IF     ( SString [1] = 'Q' )
              OR  ( SString [1] = 'q' )
              THEN Quiet_Display := NOT Quiet_Display ;

           IF EOF ( Input_File )
              THEN Finished := TRUE ;

           { clear annotation }
           Annotation := Blank_40 ;

     UNTIL Finished ;

     IF    Something_to_Plot
       AND ( CAM_Mode IN [2,4] )
       THEN BEGIN
                 LOCATION := TERMINATE ;
                 PD_Plot_Datas ;
             END ;
END ;


{======================================================================}

BEGIN  (* PLOT PROGRAM *)

    { initialise system values }
    ISV_Initialise_System_Values ;

    IOD_Initialise_Output_Device ;

    { initialise plot parameters }
    IPP_Initialise_Plot_Parameters ;

    { read plot parameters }
    RPP_Read_Plot_Parameters_File ;

    { transformation parameters }
    CGTT_Compute_Ground_To_Table_Transformation ;

    { compute window points }
    CW_Compute_Window ;

    { compute input formats }
    COF_Compute_Input_Formats ;

   { initialize main values }
    IMV_Initialise_Main_Values ;

    { open the library file }
    OLF_Open_Library_File ;

    { open plot file }
     OPF_Open_Plot_File ;

    { create selected layers file }
    Plot_Selected_Layers := ( Selected_Layers = 'YES' ) ;
    IF Plot_Selected_Layers THEN
      CSLF_Create_Selected_Layers_File ;

    { find start of file }
    FSPF_Find_Start_of_Plot_File ;



{============================ PLOT PROGRAM ============================}

  CASE Plot_Selected_Layers OF

    TRUE:  REPEAT
             LASS_Line_And_Symbol_Selection ;
             IF NOT Scape THEN
               BEGIN
                 Plot ;
                 FSPF_Find_Start_of_Plot_File ;
               END ;
           UNTIL Scape ;

    FALSE: Plot ;

  END ;

{========================== END PLOT PROGRAM ============================}


     EPP_Exit_Plot_Program ;

END. (* PLOT PROGRAM *)
