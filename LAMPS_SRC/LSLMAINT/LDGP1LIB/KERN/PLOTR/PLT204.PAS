[INHERIT ('Inherit_File')]
MODULE PLT204 ;

{ PLT204.PAS <> }

(****************************************************************************)
[GLOBAL] PROCEDURE DMW_Define_Manuscript_Window ;
(****************************************************************************)
CONST
     Insufficient_Data       =   '       ** INSUFFICIENT VALUES **        ';
     Max_Points_Reached      =   '  ** MAXIMUM WINDOW POINTS REACHED **   ';
     Max_Lines_Per_Page      = 10 ;
VAR
    SString,
    Message                : String_40 ;
    Line_Number,
    Number_Of_Characters   : INTEGER ;
    Add_Possible,
    Error,
    Finished,
    Return                 : BOOLEAN ;
    Arrow_Key              : CHAR ;
    Begin_Scroll_Segment,
    End_Scroll_Segment     : INTEGER ;
    Add_Mode               : BOOLEAN ;


(************************************************************************)
PROCEDURE WW_Write_Window ;
(************************************************************************)
VAR
   Line,
   I               : INTEGER ;

BEGIN (* WW_Write_Window *)

  KT_Kern_Title  (Ten_Digit_Number, Title) ;
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 6                   MANUSCRIPT WINDOW' ) ;

  WRITELN;
  WRITELN ('                       EASTING                  NORTHING ');

  Line := 8 ;
  FOR I := Begin_Scroll_Segment TO End_Scroll_Segment DO
      BEGIN
      Line := Line + 1 ;
      CURPOS_Cursor_Position ( Line, 0  ) ;
      WRITELN (' ':10, I:2 , '.  ', X_Window [I]:17:3,
                                    Y_Window [I]:26:3 ) ;
      END ;

IF (Message <> Blank_40)
     THEN BEGIN
               BELLRI_Bell_Ring ;
               DBWIDT_Double_Width ( 20 ) ;
               WRITELN ( Message ) ;
          END ;

END ; (* WW_Write_Window *)


(********************************************************************)
PROCEDURE WCL_Write_Command_Line ;
(********************************************************************)

BEGIN (* WCL_Write_Command_Line *)

CURPOS_Cursor_Position ( 22,0 ) ;
WRITELN ('        A(dd), E(dit), I(nsert), K(ill), N(ew Window), C(lose Window) ' );
WRITE   ('                            TYPE COMMAND, <RETURN>  ' ) ;

END ; (* WCL_Write_Command_Line *)


(********************************************************************)
PROCEDURE PW_Print_Window ;
(********************************************************************)
VAR
     I,
     Title_Length,
     Cursor_Position     :   INTEGER ;
     Out_Write           :   TEXT    ;

BEGIN (* PMP_Print_Menu_Page *)

   OPEN ( Out_Write,
          FILE_NAME := '$PRINTER' ) ;

   REWRITE ( Out_Write ) ;
   PKT_Print_Kern_Title ( Ten_digit_Number, Title );

   WRITELN (Out_Write, 'OFF-LINE PLOTTING                   PAGE 6                   MANUSCRIPT WINDOW' ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, '                       EASTING                  NORTHING ');
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   FOR I := 1 TO Nr_Window_Pts DO
       WRITELN (Out_Write, ' ':10, I:2 , '.  ', X_Window [I]:17:3,
                                                Y_Window [I]:26:3 ) ;
   WRITELN (Out_Write) ;

   CLOSE (Out_Write) ;

END ; (* PW_Print_Window *)



(********************************************************************)
PROCEDURE CF_Check_Finished ;
(********************************************************************)

BEGIN (* CF_Check_Finished *)

   Finished := TRUE ;
   Message  := Blank_40 ;

   IF Nr_Window_Pts < 3
      THEN BEGIN
                Finished := FALSE ;
                Message  := Insufficient_Data ;
             END ;

   IF Nr_Window_Pts >= Max_Window_Points - 1
      THEN Message := Max_Points_Reached ;

END ; (* CF_Check_Finished *)



(********************************************************************)
PROCEDURE CW_Close_Window ;
(********************************************************************)
VAR
   Easting,
   Northing   :  DOUBLE ;
   Closed     :  BOOLEAN ;
   I          :  INTEGER ;

BEGIN (* CW_Close_Window *)

     Easting  :=  X_Window [1] ;
     Northing :=  Y_Window [1] ;
     Closed := FALSE ;

     I := 1 ;
     REPEAT
       I := I + 1 ;

       IF     (Easting  =  X_Window [I])
          AND (Northing =  Y_Window [I])
         THEN BEGIN
              IF (I = Nr_Window_Pts )
               THEN Closed := TRUE
               ELSE BEGIN
                    I := I + 1 ;
                    Easting  :=  X_Window [I] ;
                    Northing :=  Y_Window [I] ;
                    END ;
                 END ;

    UNTIL (I >= Nr_Window_Pts ) ;

    IF NOT Closed
     THEN BEGIN
               Nr_Window_Pts := Nr_Window_Pts + 1 ;
               X_Window [Nr_Window_Pts] := Easting  ;
               Y_Window [Nr_Window_Pts] := Northing  ;
          END ;

END ; (* CW_Close_Window *)



(**********************************************************************)
PROCEDURE NW_New_Window ;
(**********************************************************************)
VAR
    I                    : INTEGER ;
    SString              : String_40 ;
    Number_Of_Characters : INTEGER ;
    Return               : BOOLEAN ;

BEGIN (* NW_New_Window *)

    CURPOS_Cursor_Position (21, 0) ;
    ERADIS_Erase_Display  ('D') ;
    CURPOS_Cursor_Position (23, 0) ;
    WRITE ('        KILLING EXISTING WINDOW DEFINITION :   ARE YOU SURE (Y/N) ? ');

    Read_Key_Board (SString, Number_Of_Characters, Scape,
                    Return, Arrow_Key, 1 ) ;

    IF (SString [1] IN ['Y', 'y'])
       THEN BEGIN
            FOR I := 1 TO Max_Window_Points DO
                BEGIN
                     X_Window [I] := 0.0;
                     Y_Window [I] := 0.0;
                END;
            Nr_Window_Pts := 0;
            END;

   Arrow_Key := Down_Arrow_Key ;
   End_Scroll_Segment := Nr_Window_Pts - Max_Lines_Per_Page ;
   Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                     Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key) ;

END; (* NW_New_Window *)


(********************************************************************)
PROCEDURE IC_Interpret_Command ;
(********************************************************************)

BEGIN (* IC_Interpret_Command *)

   IF (Arrow_Key <> ' ')
       THEN Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                     Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key)

       ELSE CASE SString[1] OF

             '?'   :  RADH_Read_And_Display_Help ( Help_Text_File, 7 ) ;

             'A',
             'a'   : IF Nr_Window_Pts < Max_Window_Points - 1
                       THEN BEGIN
                            Add_Mode := TRUE ;
                            Arrow_Key := Down_Arrow_Key ;
                            End_Scroll_Segment := Nr_Window_Pts
                                                     - Max_Lines_Per_Page ;
                            Determine_Scroll ( Begin_Scroll_Segment,
                                End_Scroll_Segment, Nr_Window_Pts,
                                             Max_Lines_Per_Page,  Arrow_Key) ;
                            END ;

             'I',
             'i'   : IF     ( Nr_Window_Pts > 1 )
                        AND ( Nr_Window_Pts < Max_Window_Points - 1 )
                        THEN IP_Insert_Point ( Begin_Scroll_Segment,
                                               End_Scroll_Segment    ) ;

             'N',
             'n'   : IF Nr_Window_Pts > 0
                        THEN NW_New_Window ;

             'E',
             'e'   : IF Nr_Window_Pts > 0
                      THEN EP_Edit_Point ( Begin_Scroll_Segment,
                                           End_Scroll_Segment    ) ;

             'K',
             'k'   : IF Nr_Window_Pts > 0
                      THEN BEGIN
                           KP_Kill_Point ;
                           Arrow_Key := Down_Arrow_Key ;
                           End_Scroll_Segment :=   Nr_Window_Pts
                                                 - Max_Lines_Per_Page ;
                           Determine_Scroll ( Begin_Scroll_Segment,
                                              End_Scroll_Segment,
                                              Nr_Window_Pts,
                                              Max_Lines_Per_Page, Arrow_Key) ;
                           END ;

             'P',
             'p'   : IF Nr_Window_Pts > 0
                        THEN PW_Print_Window ;

             'C',
             'c'   :  BEGIN
                      IF Finished
                       THEN BEGIN
                            CW_Close_Window ;

                             { set the right scrolling Area }
                             Arrow_Key := Down_Arrow_Key ;
                             End_Scroll_Segment := Nr_Window_Pts
                                                        - Max_Lines_Per_Page ;
                             Determine_Scroll ( Begin_Scroll_Segment,
                                 End_Scroll_Segment, Nr_Window_Pts,
                                              Max_Lines_Per_Page, Arrow_Key) ;
                             END ;
                      END ;

           OTHERWISE  IF NOT (Return OR Scape) THEN BELLRI_Bell_Ring ;

    END ; { of case }

END ; (* IC_Interpret_Command *)


{=====================================================================}

BEGIN (* DMW_Define_Manuscript_Window *)

  Message  := Blank_40  ;


  Arrow_Key := Down_Arrow_Key ;
  Begin_Scroll_Segment := 1 ;
  End_Scroll_Segment := Nr_Window_Pts - Max_Lines_Per_Page ;
  Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                     Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key) ;

  Scape    := FALSE ;
  Add_Mode := FALSE ;

  REPEAT

{      IF    (Nr_Window_Pts < (Max_Window_Points - 1) )
        AND (Add_Mode)
       THEN BEGIN
            CF_Check_Finished ;
            WW_Write_Window ;
            END ;
}
      WHILE     ( Nr_Window_Pts < (Max_Window_Points - 1) )
            AND (Add_Mode) DO
                 BEGIN
                 CF_Check_Finished ;
                 WW_Write_Window ;
                 DBWIDT_Double_Width ( 20 ) ;
                 WRITELN ( Message ) ;
                 IF (Message <> Blank_40)  THEN BELLRI_Bell_Ring ;
                 AP_Add_Point ( Add_Mode ) ;
                 Arrow_Key := Down_Arrow_Key ;
                 End_Scroll_Segment :=   Nr_Window_Pts
                                       - Max_Lines_Per_Page ;
                 Determine_Scroll ( Begin_Scroll_Segment, End_Scroll_Segment,
                    Nr_Window_Pts, Max_Lines_Per_Page, Arrow_Key) ;
                 END ;

      IF NOT Scape
      THEN BEGIN
           CF_Check_Finished ;
           WW_Write_Window ;
           WCL_Write_Command_Line ;

           Read_Key_Board (SString, Number_Of_Characters,
                           Scape, Return, Arrow_Key, 1 ) ;
           IC_Interpret_Command ;

           IF (Arrow_Key <> ' ') THEN Scape := FALSE ;
           END ;


 UNTIL Scape OR (Return AND Finished) ;

 IF (NOT Scape)  THEN CW_Close_Window ;
 Arrow_Key := ' ' ;

END ; (* DMW_Define_Manuscript_Window *)
END.
