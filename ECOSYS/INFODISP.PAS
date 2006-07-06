Unit INFODISP;

Interface

Uses CONSTNTS, CREATURS, CRT, MOUSE, GRAPH;

var  EndKey:Char;             { Key pressed during the game }
     Userabort:boolean;       { false until the user presses esc }

Procedure GError;
Procedure Updateinfo;
Procedure Drawbodies;
Procedure DrawBlobs;
Procedure RefreshDisplay;
Procedure DrawUniverse;
Procedure OtherInfo;
Procedure clearOtherInfo;
Procedure displayblobstats(blobID:ID);
Procedure displaybodystats(bodyID:ID);
Procedure clearblobstats(blobID:ID);
Procedure clearbodystats(bodyID:ID);

Implementation

Procedure GError;
{ Prints an error message and halts the program }
Begin
  ClrScr;
  Writeln('Irrecoverable graphics error ');
  Writeln(' System halted...');
  Halt;
End;

Procedure Updateinfo;
{ Updates the runtime information at the bottom of the screen }
var Line:string;
Begin
  SetFillStyle(SolidFill,0);
  Bar(10,getmaxy-21,200,getmaxy);
  SetColor(10);
  Line:='Year : '+Strng(daty);
  OuttextXY(10,getmaxy-20,line);
  Line:='Population : '+Strng(currpop);
  OuttextXY(10,getmaxy-10,line);
  refreshdisplay;
End;

Procedure OtherInfo;
{ Prints statistics at the bottom of the screen }
var Line:string;
Begin
  SetFillStyle(SolidFill,0);
  Bar(10,getmaxy-71,200,getmaxy-21);
  SetColor(10);
  Line:='Births : '+Strng(statborn);
  OuttextXY(10,getmaxy-70,line);
  Line:='Deaths';
  OuttextXY(10,getmaxy-60,line);
  Line:='Natural : '+Strng(statold);
  OuttextXY(30,getmaxy-50,line);
  Line:='Starvation : '+Strng(statstrv);
  OuttextXY(30,getmaxy-40,line);
  Line:='Murder : '+Strng(statkild);
  OuttextXY(30,getmaxy-30,line);
End;

Procedure ClearOtherInfo;
Begin
  SetFillStyle(SolidFill,0);
  Bar(10,getmaxy-71,200,getmaxy-21);
End;

Procedure DrawBlobs;
{ Draws the blobs as pixels on the screen }
Begin
  For i:=1 to Currpop do with blobs[i] do begin
    PutPixel(Tl.X+prevpos.x,TL.Y+prevpos.y,0);
    PutPixel(Tl.X+pos.x,TL.Y+pos.y,BlobColour(IDNo));
   end;
End;

Procedure Drawbodies;
{ Draws the bodies }
var s:integer;
Begin
  For s:=1 to numbodies do with bodies[s] do
    PutPixel(Tl.X+pos.x,TL.Y+pos.y,8);
End;

Procedure DrawUniverse;
{ Draws the universe border }
Begin
  TL.X:=(getmaxx-sizex)div 2;
  TL.Y:=(getmaxy-sizey)div 2;
  SetColor(15);
  Rectangle(TL.X-1,TL.Y-1,TL.X+sizex+1,TL.Y+sizey+1);
End;

Procedure RefreshDisplay;
{ Erases mistakes, and missed blobs/ bodies etc. }
Begin
  SetFillStyle(SolidFill,0);
  Bar(tl.x,tl.y,tl.x+sizex,tl.y+sizey);
  Bar(0,0,400,60);
  drawuniverse;
  drawblobs;
  drawbodies;
End;

Procedure displayblobstats(blobID:ID);
{ Displays the stats of the blob blobs[blobID] }
var Line:string;
Begin
  if blobid>0 then with blobs[blobid] do begin
    Setcolor(BlobColour(IDNo)-8+128);
    Circle(Tl.X+pos.x,TL.Y+pos.y,2);
    OutTextXy(1,1,'Blob Stats');
    Setcolor(BlobColour(IDNo));
    Line:='Age : '+strng(Age div 100)+'.'+strng(Age mod 100);
    OutTextXy(20,10,Line);
    Line := 'Generation : '+Strng(Genratn);
    OutTextXy(20,20,Line);
    Line := 'Children : '+Strng(Children);
    OutTextXy(156,20,Line);
    Line := 'Kills : '+Strng(Kills);
    OutTextXy(268,20,Line);
    Line := 'DNA : '+DNA;
    OutTextXy(20,30,Line);
    Line := 'Type : '+Name[DominantType(DNA)];
    OutTextXy(20,40,Line);
    Line:= 'Current Task : '+States[State];
    OutTextXy(20,50,Line);
   end;
End;

Procedure displaybodystats(bodyID:ID);
{ Displays the stats of the body bodies[bodyID] }
Var Line:string;
Begin
  if bodyid>0 then with bodies[bodyid] do begin
    Setcolor(15);
    Circle(Tl.X+pos.x,TL.Y+pos.y,2);
    OutTextXy(GetMaxX-88,getmaxy-30,'Body Stats');
    Setcolor(7);
    Line := 'Decay : '+Strng(Decay);
    OutTextXy(getmaxx-(length(line)+1)*8,getmaxy-20,Line);
    Line := 'Cause of death : '+Cause;
    OutTextXy(getmaxx-(length(line)+1)*8,getmaxy-10,Line);
   end;
End;

Procedure clearblobstats(blobID:ID);
{ Blanks out the blob stat display }
Begin
  if blobid>0 then with blobs[blobid] do begin
    Setcolor(0);
    Circle(Tl.X+pos.x,TL.Y+pos.y,2);
    refreshdisplay;
    showmousecursor;
   end;
End;

Procedure clearbodystats(bodyID:ID);
{ Blanks out the body stat display }
Begin
  if bodyid>0 then with bodies[bodyid] do begin
    Setcolor(0);
    Circle(Tl.X+pos.x,TL.Y+pos.y,2);
    SetFillStyle(SolidFill,0);
    Bar(getmaxx-300,getmaxy-31,getmaxx,getmaxy);
    Bar(tl.x,tl.y,tl.x+sizex,tl.y+sizey);
    refreshdisplay;
   end;
End;

End.

