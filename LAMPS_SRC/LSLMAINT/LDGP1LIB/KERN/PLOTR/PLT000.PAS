[ENVIRONMENT ('PLOTR.PEN')]  PROGRAM PLOTR ( INPUT, OUTPUT ) ;

%INCLUDE 'Plotr.glo/list'

{ PLT000.PAS <> }

{=====================================================================}
{                          PLOT PROGRAM                               }
{=====================================================================}

VAR
    SString                 : String_40 ;
    Page_Number,
    Delta_Last_Page,
    Delta_Next_Page,
    Number_Of_Pages,
    Number_Of_Characters   : INTEGER ;
    Value                  : DOUBLE ;
    Error,
    Finished               : BOOLEAN ;

    Message_4              : String_40 ;
    I, Len                 : INTEGER;



(**********************************************************************)
PROCEDURE WMPCRT_Write_Menu_Page_CRT ;
(**********************************************************************)

BEGIN (* WMPCRT_Write_Menu_Page_CRT *)

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;
  WRITELN ('OFF-LINE PLOTTING                   INDEX                    MENU PAGE SUMMARY') ;
  WRITELN ;
  WRITELN ;
  WRITELN ;
  WRITELN (' 1.          OVERALL PARAMETERS       :   Unit System, File Names') ;
  WRITELN ;
  WRITELN (' 2.          SINGLE POINT FORMAT      :   Formats, Recording Order') ;
  WRITELN ;
  WRITELN (' 3.          MULTIPLE POINT FORMAT    :   Formats, Recording Order') ;
  WRITELN ;
  WRITELN (' 4.          MANUSCRIPT PARAMETERS    :   Axis, Scale, Rotation') ;
  WRITELN ;
  WRITELN (' 5.          MANUSCRIPT SIZE          :   Side Lengths' ) ;
  WRITELN ;
  WRITELN (' 6.          MANUSCRIPT WINDOW        :   Window Coordinates' ) ;
  WRITELN ;

END ;  (* WMPCRT_Write_Menu_Page_CRT *)


(**********************************************************************)
PROCEDURE WAC_Write_Any_Changes ;
(**********************************************************************)

BEGIN (* WAC_Write_Any_Changes *)

  CURPOS_Cursor_Position (23,0) ;
  WRITELN ( ' ':10, '     ANY CHANGES? IF SO,  TYPE PAGE NUMBER, <RETURN>     ' ) ;
  WRITE   ( ' ':10, '                  IF NOT, PRESS <RETURN>     ' ) ;
  CURPOS_Cursor_Position (24,52) ;

END ;  (* WAC_Write_Any_Changes *)


(**********************************************************************)
 PROCEDURE CPN_Compute_Page_Number (Delta_Last_Page,
                                    Delta_Next_Page,
                                    Delta_Next_Return_Page :  INTEGER ) ;
(**********************************************************************)

VAR
    Next_Page : BOOLEAN ;

BEGIN  (* Procedure CPN Compute Page Number *)

       Next_Page := TRUE;

       IF Arrow_Key <> ' '
          THEN BEGIN
                    Scape     := FALSE ;
                    Next_Page := FALSE ;
                 END;

       { going up }
       IF Arrow_Key = Up_Arrow_Key
          THEN Page_Number := Page_Number - Delta_Last_Page ;

       { going down }
       IF Arrow_Key = Down_Arrow_Key
          THEN Page_Number := Page_Number + Delta_Next_Page ;

       IF Next_Page
          THEN Page_Number := Page_Number + Delta_Next_Return_Page ;


END ;  (* Procedure CPN Compute Page Number *)


{=======================================================================}

BEGIN  (* PLOT PROGRAM *)

    { initialise system values }
    ISV_Initialise_System_Values ;
    IOD_Initialise_Output_Device ;

    { initialise plot parameters }
    IPP_Initialise_Plot_Parameters ;

    { read plot parameters }
    RPP_Read_Plot_Parameters_File ;

    { is the library present ? }
    CLF_Check_Library_File ;

    { is the plot file in a wrong unit ? }
    Message_4 := 'OPENING                                 ' ;
    FOR I := 1 TO File_Name_Length-8 DO Message_4[I+8] := Input_File_Name[I] ;

    IRAWF_Indicate_Reading_And_Writing_Files
     ('           Opening Plot File            ',  Message_4) ;
    OPEN ( Input_File,
           FILE_NAME := Input_File_Name,
           ACCESS_METHOD := SEQUENTIAL,
           HISTORY := OLD,
           ERROR := CONTINUE ) ;
    RESET ( Input_File, ERROR := CONTINUE ) ;
    IF EOF ( Input_File ) THEN Len := -1
    ELSE
      BEGIN
        Len := 1 ;
        CLOSE ( Input_File ) ;
      END ;

{======================================================================}


  Arrow_Key       := ' ' ;
  Scape           := FALSE ;
  SString          := Blank_40 ;
  Return          := FALSE ;
  Finished        := FALSE ;
  Number_Of_Pages := 6 ;
  Number_Of_Characters := 0 ;

  REPEAT

    WMPCRT_Write_Menu_Page_CRT ;

    REPEAT

      WAC_Write_Any_Changes ;

      Read_Key_Board
             (SString, Number_Of_Characters, Scape, Return, Arrow_Key, 1) ;

      Convert_To_Numeric ( SString, Number_Of_Characters, Value, Error ) ;
      Page_Number := TRUNC ( Value ) ;

      IF Arrow_Key <> ' '
        THEN Scape     := FALSE ;

      IF ( SString [1] = '?' )
       THEN BEGIN
                RADH_Read_And_Display_Help ( Help_Text_File, 1 ) ;
                WMPCRT_Write_Menu_Page_CRT ;
              END ;

    UNTIL   Scape OR Return
         OR ( (Page_Number > 0) AND (Page_Number <= Number_Of_Pages) ) ;

    Finished := FALSE ;

    REPEAT
        CASE Page_Number OF

                 1 : BEGIN
                        DOP_Define_Overall_Parameters ;
                        Delta_Last_Page := -4 ;
                        IF Input_Sheet_Window THEN Delta_Last_Page := -5 ;
                        Delta_Next_Page := 3 ;
                        IF File_Format [1] = 'S' THEN Delta_Next_Page := 1 ;
                        IF File_Format [1] = 'M' THEN Delta_Next_Page := 2 ;
                        CPN_Compute_Page_Number ( Delta_Last_Page,
                                                  Delta_Next_Page, 6 ) ;
                     END ;

                 2 : BEGIN
                        SPF_Single_Point_Format ;
                        CPN_Compute_Page_Number (1, 2, 6) ;
                     END ;

                 3 : BEGIN
                        MPF_Multiple_Point_Format ;
                        CPN_Compute_Page_Number (2, 1, 6) ;
                     END ;

                 4 : BEGIN
                        DMP_Define_Manuscript_Parameters ;
                        Delta_Next_Page := 1 ;
                        IF Input_Sheet_Window THEN Delta_Next_Page := 2 ;
                        Delta_Last_Page := 3 ;
                        IF File_Format [1] = 'S' THEN Delta_Last_Page := 2 ;
                        IF File_Format [1] = 'M' THEN Delta_Last_Page := 1 ;
                        CPN_Compute_Page_Number (Delta_Last_Page,
                                                 Delta_Next_Page, 6) ;
                     END ;

                 5 : BEGIN
                        DMS_Define_Manuscript_Size ;
                        CPN_Compute_Page_Number (1, -4, 6) ;
                     END ;

                 6 : BEGIN
                        Arrow_Key := ' ' ;
                        DMW_Define_Manuscript_Window ;
                        CPN_Compute_Page_Number (2, -5, 6) ;
                     END ;


              OTHERWISE Finished := TRUE ;

        END ; { OF CASE }

     UNTIL Finished ;

  UNTIL Scape OR Return ;

    { update plot parameter file }
   IF NOT Scape
      THEN BEGIN
                WPP_Write_Plot_Parameters_File ;

                CASE Plotter_Device OF
                     GP1    : CAP_Chain_a_Program
		            ( 'Kph$Plotr:PLOTFI.EXE_GP       ' ) ;
                     DMP    : CAP_Chain_a_Program
			    ( 'Kph$Plotr:PLOTFI.EXE_HU       ' ) ;
                     HP     : CAP_Chain_a_Program
		            ( 'Kph$Plotr:PLOTFI.EXE_HP       ' ) ;
                     TA2    : CAP_Chain_a_Program
		            ( 'Kph$Plotr:PLOTFI.EXE_TA       ' ) ;
		     VWS    : CAP_Chain_a_Program
			    ( 'Kph$Plotr:PLOTFI.EXE_VW       ' ) ;
		     KRISS  : CAP_Chain_a_Program
			    ( 'Kph$Plotr:PLOTFI.EXE_KR       ' ) ;
                     P_DSP  : CAP_Chain_a_Program
			    ( 'Kph$Plotr:PLOTFI.EXE_DS       ' ) ;
                     OTHERWISE ; { do nothing }
                 END ; { of case }

             END ;

  ERASCR_Erase_Screen ;

END. (* PLOT PROGRAM *)
