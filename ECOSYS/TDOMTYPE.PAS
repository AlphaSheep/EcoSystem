Program testdt;
Uses Crt;

Type DNAStr=String[20];

Var n:integer;

Procedure FindSpecs(DNA:DNAStr;var A,D,E,F,H,R:integer);
Begin
  A:=1; D:=1; E:=1; F:=1; H:=1; R:=1;
  For n := 1 to length(DNA) do begin
    if DNA[n]='A' then inc(A);
    if DNA[n]='D' then inc(D);
    if DNA[n]='E' then inc(E);
    if DNA[n]='F' then inc(F);
    if DNA[n]='H' then inc(H);
    if DNA[n]='R' then inc(R);
   end;
End;

Procedure Swapchr(var A,B:Char);
var tempc:char;
Begin
  tempc:=a;
  a:=b;
  b:=tempc;
End;

Procedure Swapint(var A,B:integer);
var tempc:integer;
Begin
  tempc:=a;
  a:=b;
  b:=tempc;
End;

Function DominantType(DNA:DNAStr):Char;
{ Finds the dominant characteristic in a DNA string }
type arr1to6=array[0..6] of char;
const baseach:arr1to6=('N','A','D','E','F','H','R');
var A,D,E,F,H,R:integer;
    hgh:integer;
    hindex:integer;
    arr:array[1..6] of integer;
    ach:arr1to6;
    s:integer;
Begin
  FindSpecs(DNA,arr[1],arr[2],arr[3],arr[4],arr[5],arr[6]);
  ach:=baseach;
  hgh:=arr[1];
  hindex:=1;
  for s := 2 to 6 do
   if arr[s]>hgh
    then begin
      hgh:=arr[s];
      hindex:=s;
     end
    else if arr[s]=hgh then hindex:=0;
  DominantType:=ach[hindex];
End;

Function Blobcolour(DNA:DNAStr):Integer;
Begin
  Case DominantType(DNA) of
   'A': BlobColour:=12;
   'D': BlobColour:=11;
   'E': BlobColour:=09;
   'F': BlobColour:=14;
   'H': BlobColour:=13;
   'R': BlobColour:=10;
   else BlobColour:=07;
  end;
End;

function colourname(col:integer):string;
begin
  case col of
    0  :colourname:='Black';
    1  :colourname:='Dark Blue';
    2  :colourname:='Dark Green';
    3  :colourname:='Dark Turquoise';
    4  :colourname:='Dark Red';
    5  :colourname:='Purple';
    6  :colourname:='Orange';
    7  :colourname:='Light Gray';
    8  :colourname:='Dark Gray';
    9  :colourname:='Blue';
    10 :colourname:='Green';
    11 :colourname:='Cyan';
    12 :colourname:='Red';
    13 :colourname:='Magenta';
    14 :colourname:='Yellow';
    15 :colourname:='White';
    else colourname:='Undefined';
   end;
end;

Var DNA:DNAStr;
    A,D,E,F,H,R:integer;

Begin
  ClrScr;
  textcolor(10);
  Write ('DNA: ');
  Readln(DNA);
  FindSpecs(DNA,A,D,E,F,H,R);
  Writeln;
  Writeln('Personality count');
  Writeln('  Hunger        : ',E);
  Writeln('  Reproduction  : ',R);
  Writeln('  Aggression    : ',A);
  Writeln('Abilities count');
  Writeln('  Hunting       : ',H);
  Writeln('  Determination : ',D);
  Writeln('  Combat        : ',F);
  Writeln;
  Writeln('Dominant Type :',Dominanttype(DNA));
  TextColor(blobcolour(DNA));
  Writeln('Colour : ',colourname(blobcolour(DNA)));
  Readkey;
End.




