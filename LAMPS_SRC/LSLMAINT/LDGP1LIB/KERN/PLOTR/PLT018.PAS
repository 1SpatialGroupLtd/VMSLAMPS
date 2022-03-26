[INHERIT ('Inherit_File')]
MODULE PLT018 ;

{ PLT018.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE CW_Compute_Window ;
(**********************************************************************)
CONST
   Max_Real = 1.0E+38 ;

VAR
   I       :  INTEGER ;
   X_Table,
   Y_TAble : DOUBLE ;

BEGIN
     IF NOT Input_Sheet_Window
        THEN BEGIN
                  Nr_Window_Pts := 5 ;

                  X_Window[1] := 0 ;
                  Y_Window[1] := 0 ;

                  X_Window[2] := 0 ;

                  { If we're using a workstation, we want to plot everything }
                  { This window SHOULD be kept in world coords, which means
                    that we SHOULD define the plot_hor/ver size as world
                    values. World to device transformation should come in
                    at device-dependant stage }
                  IF Plotter_Device IN [VWS,KRISS,P_DSP] THEN
                    Y_Window[2] := Max_Real
                  ELSE
                    Y_Window[2] := Plot_Vertical_Size * Plot_Y_Scale + 
                                   Plot_Y_Index ;

                  IF Plotter_Device IN [VWS,KRISS,P_DSP] THEN
                    X_Window[3] := Max_Real
                  ELSE
                    X_Window[3] := Plot_Horizontal_Size * Plot_X_Scale + 
                                   Plot_X_Index ;

                  Y_Window[3] := Y_Window[2] ;

                  X_Window[4] := X_Window[3] ;
                  Y_Window[4] := 0 ;

                  X_Window[5] := X_Window[1] ;
                  Y_Window[5] := Y_Window[1] ;

               END ;

     IF Input_Sheet_Window
        THEN BEGIN
                  { transform to table }
                  FOR I := 1 TO Nr_Window_Pts DO
                      BEGIN
                          { table coordinates }
{ Keep this stuff in world values -- recorded coordinate to window boundary
  comparison is in world system. }
{*****
                          X_Table := E1*X_Window [I] + E2*Y_Window [I] + E0 ;
                          Y_Table := F1*X_Window [I] + F2*Y_Window [I] + F0 ;
                          X_Window [I] := X_Table ;
                          Y_Window [I] := Y_Table ;
****}
                       END ;
               END ;

    { determine if last window point is same as first :: if not then  }
    { define another window point to be the same as the first window point }
    IF    (Nr_Window_Pts > 0 )
      AND (Nr_Window_Pts < Max_Window_Points)
      THEN BEGIN
           IF   (Y_Window[1] <> Y_Window[Nr_Window_Pts])
             OR (X_Window[1] <> X_Window[Nr_Window_Pts])
             THEN BEGIN
                       Nr_Window_Pts := Nr_Window_Pts + 1;
                       Y_Window[Nr_Window_Pts] := Y_Window[1] ;
                       X_Window[Nr_Window_Pts] := X_Window[1] ;
                   END ;
           END ;


    { plotting of mirror reverse }
    IF Plot_Horizontal [1] = '-'
       THEN
           FOR I := 1 TO Nr_Window_Pts DO
               X_Window [I] := - X_Window [I] ;

    { plotting of upside down }
    IF Plot_Vertical [1] = '-'
       THEN
           FOR I := 1 TO Nr_Window_Pts DO
               Y_Window [I] := - Y_Window [I] ;

     { find max and min }
     Max_X_Window := -1.0E+38 ;
     Max_Y_Window := -1.0E+38 ;
     Min_X_Window := +1.0E+38 ;
     Min_Y_Window := +1.0E+38 ;

     FOR I := 1 TO Nr_Window_Pts DO
         BEGIN
              IF X_Window [I] > Max_X_Window
                 THEN Max_X_Window := X_Window [I] ;
              IF Y_Window [I] > Max_Y_Window
                 THEN Max_Y_Window := Y_Window [I] ;
              IF X_Window [I] < Min_X_Window
                 THEN Min_X_Window := X_Window [I] ;
              IF Y_Window [I] < Min_Y_Window
                 THEN Min_Y_Window := Y_Window [I] ;
           END ;


END ;  (* PROCEDURE CW_Compute_Window *)
END.
