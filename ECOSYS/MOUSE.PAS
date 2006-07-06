Unit Mouse;

Interface
  Uses Crt,Dos,Graph;
  Var  Regs : Registers;
       MX, MY, Button1, Button2 : Word;
  Procedure ReadMouse (Var XPixel, YPixel, Button1, Button2 : Word);
  Procedure ReadGMouse (Var XPixel, YPixel, Button1, Button2 : Word);
  Function  MouseClicked : Boolean;
  Procedure FindMouse (Var XPixel, YPixel:Word);
  Procedure FindGMouse (Var XPixel, YPixel:Word);
  Procedure ShowMouseCursor;
  Procedure HideMouseCursor;
  Procedure PrintMousePos;
  Procedure PrintGMousePos;

Implementation
  Function FindTextX (XPixel : Word):Byte;
    Begin
      FindTextX := XPixel Div 8 + 1;
    End;

  Function FindTextY (YPixel : Word):Byte;
    Begin
      FindTextY := YPixel Div 8 + 1;
    End;

  Procedure ReadGMouse (var XPixel, YPixel, Button1, Button2 : Word);
    Begin
      Regs.ax := 3;
      intr($33,Regs);
      XPixel := Regs.cx;
      YPixel := Regs.dx;
      Button1 := (Regs.bx and 1);
      Button2 := (Regs.bx and 2);
    End;

  Procedure ReadMouse (var XPixel, YPixel, Button1, Button2 : Word);
    Begin
      Regs.ax := 3;
      intr($33,Regs);
      XPixel := Regs.cx;
      XPixel := FindTextX(XPixel);
      YPixel := Regs.dx;
      YPixel := FindTextY(YPixel);
      Button1 := (Regs.bx and 1);
      Button2 := (Regs.bx and 2);
    End;

  Function MouseClicked : Boolean;
    Begin
      ReadMouse(MX,MY,Button1,Button2);
      If (Button1=1) or (Button2=1)
        then MouseClicked := True
        else MouseClicked := False;
    End;

  Procedure FindMouse (Var XPixel,YPixel:Word);
    Begin
      Regs.ax := 3;
      intr($33,Regs);
      XPixel := Regs.cx;
      XPixel := FindTextX(XPixel);
      YPixel := Regs.dx;
      YPixel := FindTextY(YPixel);
    End;

  Procedure FindGMouse (Var XPixel,YPixel:Word);
    Begin
      Regs.ax := 3;
      intr($33,Regs);
      XPixel := Regs.cx;
      YPixel := Regs.dx;
    End;

  Procedure ShowMouseCursor;
    Assembler;
      asm
        Mov AX,1
        Int 33h
    End;

  Procedure HideMouseCursor;
    Assembler;
      asm
        Mov Ax,2
        Int 33h
    End;

  Procedure PrintMousePos;
    Var TMX,TMY : String[2]; StrngThng : String[5];
    Begin
      FindMouse(MX,MY);
      Str(MX,TMX); Str(MY,TMY); StrngThng := TMX+','+TMY;
      While Length(StrngThng)<5 do StrngThng := ' '+StrngThng;
      TextColor(12);
      GoToXY(74,25); Write (StrngThng);
    End;

  Procedure PrintGMousePos;
    Var TMX,TMY : String[3]; StrngThng : String[7];
    Begin
      FindGMouse(MX,MY);
      Str(MX,TMX); Str(MY,TMY); StrngThng := TMX+','+TMY;
      While Length(StrngThng)<5 do StrngThng := ' '+StrngThng;
      SetColor(1);
      Rectangle(GetMaxX-59,GetMaxY-11,GetMaxX,GetMaxY);
      SetFillStyle(1,0);
      FloodFill(GetMaxX-30,GetMaxY-5,1);
      SetColor(12);
      OutTextXY(GetMaxX-58,GetMaxY-10,StrngThng);
    End;
END.




