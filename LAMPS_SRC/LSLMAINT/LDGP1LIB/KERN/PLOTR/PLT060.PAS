[INHERIT ('Inherit_File')]
MODULE PLT060 ;

{ PLT060.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE PXYC_Plot_XY_Coordinates ;
(**********************************************************************)
VAR
   D,
   dX, dY,
   Size   : DOUBLE ;

   Value    : DOUBLE ;
   Field,
   Decimals : INTEGER ;
   SString   : String_40 ;

BEGIN (* PXYC_Plot_XY_Coordinates *)

     IF Last_Foot_Pedal = Left
        THEN Pen := UP
        ELSE Pen := DOWN ;

     { finish a spline }
     IF ( CAM_Mode = 2 ) OR ( CAM_Mode = 4 ) THEN
     ELSE
       IF Location = CONTINUE THEN
         BEGIN
           Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                        Height, Plotter_Device ) ;
           Location := TERMINATE ;
           Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                        Height, Plotter_Device ) ;
           Location := START ;
         END ;

CASE CAM_Mode OF
1,3 : Plot_Line ( P4, Pen, X_Table, Y_Table,
                  Height, Plotter_Device ) ; { STRAIGHT }

2,4 : { CURVE }
      CASE Location OF
      START : IF Last_Foot_Pedal = Right THEN
                BEGIN
                  Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                               Height, Plotter_Device ) ;
                  Location := CONTINUE ;
                END
              ELSE Plot_Line ( P4, Pen, X_Table, Y_Table,
                               Height, Plotter_Device ) ;

   CONTINUE : IF Last_Foot_Pedal = Left THEN
                BEGIN
                  Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                               Height, Plotter_Device ) ;
                  Location := TERMINATE ;
                  Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                               Height, Plotter_Device ) ;
                  Plot_Line ( P4, Pen, X_Table, Y_Table,
                              Height, Plotter_Device ) ;
                  Location := START ;
                END
              ELSE
                Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                             Height, Plotter_Device ) ;


  TERMINATE : BEGIN
                   Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                                Height, Plotter_Device ) ;
                   Plot_Line ( P4, Pen, X_Table, Y_Table,
                               Height, Plotter_Device ) ;
                   Location := START ;
                END ;

            END ; (*CASE*)

 5,9,10 : BEGIN
               Plot_Line ( P4, Up, X_Table, Y_Table,
                           Height, Plotter_Device ) ; { OBJECT }
               PSymb ( P4,
                       Hardware_Symbol_Number,
                       Standard_Symbol_Size * Display_Scale_Factor / 2 ) ;
            END ;

      6 : BEGIN
               Plot_Line ( P4, Up, X_Table, Y_Table,
                           Height, Plotter_Device ) ; { SPOT HEIGHT }
               PSymb ( P4,
                       Hardware_Symbol_Number,
                       Standard_Symbol_Size * Display_Scale_Factor / 2 ) ;

               Value := Height ;
               Field := 1 ;
               Decimals := Z_Format_Decimals ;
               CRTS_Convert_Real_To_String
                    ( Value, Field, Decimals, SString  ) ;

               { leave one empty character }
               Field := Field + 1 ;
               CRTS_Convert_Real_To_String
                    ( Value, Field, Decimals, SString  ) ;

               PStr ( P4, SString ) ;

            END ;

      7 : BEGIN { NETWORK } ;
            IF Pen = UP THEN
              Plot_Line ( P4, Pen, X_Table, Y_Table,
                          Height, Plotter_Device )
            ELSE
              BEGIN
                Plot_Line ( P4, UP, Last_X_Table, Last_Y_Table,
                            Height, Plotter_Device ) ;

                IF Line_Pen_Selection <> Symbol_Pen_Selection
                  THEN PPen ( P4, Symbol_Pen_Selection ) ;

                PSymb ( P4, Hardware_Symbol_Number,
                        Standard_Symbol_Size * Display_Scale_Factor / 2 ) ;

                IF Line_Pen_Selection <> Symbol_Pen_Selection
                  THEN PPen ( P4, Line_Pen_Selection ) ;

                dX := X_Table - Last_X_Table ;
                dY := Y_Table - Last_Y_Table ;
                D  := SQRT ( dX*dX + dY*dY ) ;

                Size := Standard_Symbol_Size * Display_Scale_Factor / 2 ;

                IF D > Size THEN
                  BEGIN
                    dX := dX/D*Size ;
                    dY := dY/D*Size ;
                    Plot_Line ( P4, UP, Last_X_Table + dX, Last_Y_Table + dY,
                                Height, Plotter_Device ) ;
                    Plot_Line ( P4, DOWN, X_Table - dX, Y_Table - dY,
                                Height, Plotter_Device ) ;
                  END ;
              END ;
          END ;

      8 : { ARC } ;

     11 : PStr ( P4, Maps300_Annotation ) ;

     OTHERWISE ;
     END ; (* CASE *)

    Last_X_Table := X_Table ;
    Last_Y_Table := Y_Table ;

END ; (* PROCEDURE PXYC_Plot_XY_Coordinates *)



(**********************************************************************)
PROCEDURE Plot_Through_Window ;
(**********************************************************************)
VAR
   Found_Piece,
   More_Pieces  : BOOLEAN ;

   X_Start_Point,
   Y_Start_Point,
   X_End_Point,
   Y_End_Point  : DOUBLE ;

BEGIN
     More_Pieces := TRUE ;
     WHILE More_Pieces DO
           BEGIN
                CPLIW_Compute_Part_Line_In_Window
                      (  X_Start, Y_Start, X_End, Y_End,
                         X_Start_Point, Y_Start_Point,
                         X_End_Point, Y_End_Point,
                         Found_Piece, More_Pieces ) ;

                IF Found_Piece
                   THEN BEGIN
                             IF   ( X_Start_Point <> X_Table )
                               OR ( Y_Start_Point <> Y_Table )
                               THEN BEGIN
                                         Last_Foot_Pedal := Left ;
                                         X_Table := X_Start_Point ;
                                         Y_Table := Y_Start_Point ;
                                         PXYC_Plot_XY_Coordinates ;
                                         Last_Foot_Pedal := Right ;
                                      END ;

                             X_Table := X_End_Point ;
                             Y_Table := Y_End_Point ;

                             PXYC_Plot_XY_Coordinates ;
                          END ;
             END ;

END ; (* PROCEDURE Plot_Through_Window *)


(**********************************************************************)
[GLOBAL] PROCEDURE PD_Plot_Datas ;
(**********************************************************************)
VAR
   I            : INTEGER ;

   X,Y          : DOUBLE ;

BEGIN (* PD Plot Datas *)

     { find what to plot in X axis }
     X := East ;
     CASE Plot_Horizontal [2] OF
          'X' : X := East ;
          'Y' : X := North ;
          'Z' : X := Height ;
          'P' : X := P_Distance ;
          OTHERWISE ;
     END ; (* CASE *)

     { find what to plot in Y axis }
     Y := North ;
     CASE Plot_Vertical [2] OF
          'X' : Y := East ;
          'Y' : Y := North ;
          'Z' : Y := Height ;
          'P' : Y := P_Distance ;
          OTHERWISE ;
     END ; (* CASE *)

     { table coordinates }
     X_End := X ;
     Y_End := Y ;
{*********
     X_End := E1*X + E2*Y + E0 ;
     Y_End := F1*X + F2*Y + F0 ;
**********}
     IF   ( X_End > Max_X_Window )
       OR ( Y_End > Max_Y_Window )
       OR ( X_End < Min_X_Window )
       OR ( Y_End < Min_Y_Window )
       THEN Point_In := FALSE
       ELSE Point_In := TRUE ;

     IF     ( CAM_Mode IN [ 5,6,9,10,11 ] )
        AND Point_In
        THEN BEGIN
                  IF Input_Sheet_Window
                     THEN FPIW_Find_Point_Inside_Window
                               ( Point_In, X_End, Y_End ) ;
                  IF Point_In
                     THEN BEGIN
                               X_Table := X_End ;
                               Y_Table := Y_End ;
                               PXYC_Plot_XY_Coordinates ;
                           END ;
               END ;


     IF    ( CAM_Mode IN [ 1..4, 7,8 ] )
       AND ( Last_Foot_Pedal = Left )
       AND Point_In
       THEN BEGIN
                 IF Input_Sheet_Window
                    THEN FPIW_Find_Point_Inside_Window
                              ( Point_In, X_End, Y_End ) ;
                 IF Point_In
                    THEN BEGIN
                              X_Table := X_End ;
                              Y_Table := Y_End ;
                              PXYC_Plot_XY_Coordinates ;
                          END ;
               END ;

     IF    ( CAM_Mode IN [ 1..4, 7,8 ] )
       AND ( Last_Foot_Pedal = Right )
       THEN BEGIN
                 IF     Point_In
                    AND Last_Point_In
                    AND NOT Input_Sheet_Window
                    THEN BEGIN
                              X_Table := X_End ;
                              Y_Table := Y_End ;
                              PXYC_Plot_XY_Coordinates ;
                           END
                    ELSE Plot_Through_Window ;

              END ;


     IF Last_Foot_Pedal = Left
        THEN BEGIN
                  Last_Penup_East   := East ;
                  Last_Penup_North  := North ;
                  Last_Penup_Height := Height ;
                  Last_Penup_P_Dist := P_Distance ;
              END ;

     X_Start := X_End ;
     Y_Start := Y_End ;

     IF    ( X_Table = X_End )
       AND ( Y_Table = Y_End )
       THEN Last_Point_In := TRUE
       ELSE Last_Point_In := FALSE ;

END ; (* PD Plot Datas *)
END.
