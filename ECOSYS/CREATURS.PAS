Unit CREATURS;
{ Creature unit for the ecosystem program }
Interface

Uses CONSTNTS;

Type Blob=Object
       {properties}
         IdNo:ID;             { ID Number for reference }
         DNA:DNAStr;          { The blob's DNA }
         Pos:point;           { Position of the blob in the world }
         Birthplace:point;    { Place where the blob was born }
         prevPos:point;       { Previos position of the blob }
         Age:Longint;         { The blob's age }
         Hungr:Integer;       { How hungry the blob is }
         State:byte;          { What state the blob is in }
         Target:ID;           { The blob that a blob is looking for }
         Genratn:Integer;     { The generation of the current blob }
         Children:Integer;    { Number of children it has produced }
         Kills:Integer;       { How many fellow blobs it has killed }
         ChMind:Integer;      { Countdown timer until mind changes }
         loneliness:Integer;  { Countdown timer for feeling lonely }
       {methods}
         Procedure BeAnEgg;
         Procedure Born(Parent1,Parent2:DNAStr;Location:Point);
         Procedure FindFood;
         Procedure Eat;
         Procedure EatBody(bodyID:ID);
         Procedure FindMate;
         Procedure Mate(MateID:ID);
         Procedure FindVictim;
         Procedure Attack(VictimID:ID);
         Procedure RunFromTarget;
         Procedure Die(const cause:string);
         Procedure SearchForOthers;
         Procedure GoToCentre;
         Function Cansee(blobID:ID):Boolean;
         Function Cansense(blobID:ID):Boolean;
      end;
     Body=Object
       {properties}
         idno:ID;               { ID number of the body }
         Decay:Integer;         { How long it has been decaying }
         Pos:point;             { position of the body }
         Cause:string;          { What caused the blob to die }
       {methods}
         Procedure new(location:point;cs:string);
         Procedure Rotaway;
      end;

Var  Blobs: Array[1..Popcap] of blob;   { Data on all blobs }
     Bodies: Array[1..100] of body;     { Data on all bodies }

Procedure DoBirthCert(blobid:ID);
Procedure DoDeathCert(blobid:ID;const cause:string);
Procedure FindSpecs(DNA:DNAStr;var A,D,E,F,H,R:integer);
Function DominantType(DNA:DNAStr):Char;
Function Blobcolour(bID:ID):Integer;
Function ChooseState(bID:ID):Byte;
Function Nearestblob(bp:point):ID;
Function Nearestbody(bp:point):ID;

Implementation

var n:integer; { for loop variable }

Procedure FindSpecs(DNA:DNAStr;var A,D,E,F,H,R:integer);
{ Receives the DNA and returns numerical values for the six }
{  different characteristics of a blob }
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

Procedure blob.BeAnEgg;
{ The blob is an egg- ie. it does nothing }
Begin
End;

Function Blobcolour(bid:ID):Integer;
{ Recieves the DNA and returns the colour of the blob }
Begin
  Case DominantType(blobs[bid].DNA) of
    'A': BlobColour:=12;
    'D': BlobColour:=11;
    'E': BlobColour:=09;
    'F': BlobColour:=14;
    'H': BlobColour:=13;
    'R': BlobColour:=10;
    else BlobColour:=07;
   end;
  if blobs[bID].state=cegg then BlobColour:=15;
End;

Function ChooseState(bID:ID):Byte;
{ Makes decisions about what the blob's attention is  going }
{  to be focussed on until it next changes it mind }
Var A,D,E,F,H,R:integer;
    res:byte;
Begin with blobs[bID] do begin
  FindSpecs(DNA,A,D,E,F,H,R);
  res:=cnil;
  If random(round(sqrt(sqrt(25/(F+1)))))=0 then res:=cfgt;
  If random(round(sqrt(25/(R+1))))=0 then res:=cmat;
  If random(round(sqrt(25/(E+1))))=0 then res:=ceat;
  if (res=cmat) and (currpop=popcap) then res:=cfgt;
  if (res=cfgt) and (currpop<=initpop) then res:=cmat;
  if res=cmat then if random(loneliness)=0
   then if nearestblob(pos)=-1 then res:=csch;
  if hungr>(strv/strvfact) then res:=ceat;
  if age<0 then res:=cegg;
  chmind:=0;
  choosestate:=res;
End;End;

Function BodyatPos(p:point):ID;
{ Returns the Id of the body at pos or 0 if there is none }
var S:ID;
Begin
  bodyatpos:=0;
  For s:=1 to numbodies do with bodies[s] do
   if (p.x=pos.x)and(p.y=pos.y) then bodyatpos:=s;
End;

Procedure Blob.FindFood;
{ The blob looks for food }
var A,D,E,F,H,R:integer;
Begin
  if random(2)=0 then if pos.x>2
   then if pos.x<sizex-2
    then pos.x :=pos.x+random(5)-2
    else pos.x :=pos.x+random(3)-2
   else pos.x :=pos.x+random(3);
  if random(2)=0 then if pos.y>2
   then if pos.y<sizey-2
    then pos.y :=pos.y+random(5)-2
    else pos.y :=pos.y+random(3)-2
   else pos.y :=pos.y+random(3);
  FindSpecs(DNA,A,D,E,F,H,R);
  If random(Avlblty)+H > 0.8*Avlblty then eat;
  if bodyatpos(pos)>0 then eatbody(bodyatpos(pos));
End;

Procedure Blob.Eat;
{ The blob eats food and is nourished }
Begin
  Hungr:=Hungr-Nrshmnt;
  if hungr<0 then hungr := hungr div 2;
  state:=choosestate(IDNo);
End;

Procedure Blob.EatBody(bodyID:ID);
{ The blob eats a body and is nourished }
Begin
  bodies[bodyid].rotaway;
  Hungr:=Hungr-3*Nrshmnt;
  if hungr<0 then hungr := hungr div 2;
  state:=choosestate(IDNo);
End;

Procedure DoBirthCert(blobid:ID);
{ Saves a birth entry in the birth records file }
var Birth:Text;
    Line:String;
    Datestr:String[2];
Begin With blobs[blobid] do begin
  Assign(Birth,'BIRTHS.TXT');
  Append(Birth);
  Datestr:=Strng(Datd);
  If length(datestr)=1 then datestr:='0'+datestr;
  Line:='Date : '+Strng(daty)+'.'+Datestr;
  Writeln(Birth,line);
  Line:='ID No. : '+Strng(IDNo);
  Writeln(Birth,line);
  Line := 'Type : '+Name[DominantType(DNA)];
  Writeln(Birth,line);
  Writeln(Birth,'');
  Line:='Generation : '+Strng(Genratn);
  Writeln(Birth,line);
  Line:='Child DNA : '+DNA;
  Writeln(Birth,line);
  Line:='==================================================';
  Writeln(Birth,line);
  Close(Birth);
End;End;

Function HalfDNA(DNA:DNAstr):DNAstr;
{ Finds 10 random characters from a DNA string by  }
{  deleting a single character and then passing the }
{  result back to itself }
var temp:DNAstr;
Begin
  if length(DNA)=10
   then HalfDNA:=DNA
   else begin
     temp:=DNA;
     delete(temp,random(length(temp)),1);
     HalfDNA:=HalfDNA(temp);
    end;
End;

Procedure Blob.Born(Parent1,Parent2:DNAStr;Location:Point);
{ Creates an egg and sets the countdown timer for it to hatch }
{ Sets the DNA of the blob to be born out of the egg }
{ Updates the birth report }
var DNAs:String[6];
    mutate:integer;
Begin
  inc(currpop);
  IdNo:=currpop;
  DNA:=HalfDNA(Parent1)+HalfDNA(Parent2);
  DNAs:='ADEFHR';
  mutate:=Random(20)+1;
  loneliness:=initlonely;
  DNA[mutate]:=DNAs[Random(6)+1];
  Pos:=location;
  Birthplace:=pos;
  Age:=-eggage;
  Hungr:=0;
  State:=cegg;
  Target:=0;
  Children:=0;
  chmind:=0;
  kills:=0;
  dobirthcert(IDno);
  inc(statborn);
End;

Procedure DoDeathCert(blobid:ID;const cause:string);
{ Saves a death entry in the death records file }
var Death:Text;
    Line:String;
    Datestr:String[2];
Begin With blobs[blobid] do begin
  Assign(Death,'DEATHS.TXT');
  Append(Death);
  Datestr:=Strng(Datd);
  If length(datestr)=1 then datestr:='0'+datestr;
  Line:='Date : '+Strng(daty)+'.'+Datestr;
  Writeln(Death,line);
  Line:='ID No. : '+Strng(IDNo);
  Writeln(Death,line);
  Line := 'Type : '+Name[DominantType(DNA)];
  Writeln(Death,line);
  Line:='DNA : '+DNA;
  Writeln(Death,line);
  Line:='';
  Writeln(Death,line);
  Line:='Age : '+strng(Age div 100)+'.'+strng(Age mod 100);
  Writeln(Death,line);
  Line:='Generation : '+strng(Genratn);
  Writeln(Death,line);
  Line:='Children : '+strng(Children);
  Writeln(Death,line);
  Line:='Kills : '+strng(kills);
  Writeln(Death,line);
  Writeln(Death,'');
  Line:='Hunger : '+strng(hungr);
  Writeln(Death,line);
  Line:='Cause of Death : '+Cause;
  Writeln(Death,line);
  Line:='==================================================';
  Writeln(Death,line);
  Close(Death);
  if cause=strStrv then inc(statstrv);
  if cause=strold then inc(statold);
  if cause=strkild then inc(statkild);
End;End;

Procedure Blob.Die(const cause:string);
{ Kills a blob, rearranges the universe matrix and creates a body }
Var S:integer;
Begin
  dec(Currpop);
  dodeathcert(idno,cause);
  bodies[numbodies+1].new(pos,cause);
  For s:=idno to currpop do begin
    blobs[s]:=blobs[s+1];
    blobs[s].idno:=s;
   end;
End;

Function Nearestblob(bp:point):ID;
{ Finds the closest blob to a position }
var s:integer;
    dx,dy:real;
    dist:real;
    nearest:real;
    nearid:ID;
Begin
  dx:=sizex+1;
  dy:=sizex+1;
  nearest:=sqrt(sqr(dx)+sqr(dy));
  For s:=1 to currpop do if s<>n then begin
    dx:=bp.x-blobs[s].pos.x;
    dy:=bp.y-blobs[s].pos.y;
    dist:=sqrt(dx*dx+dy*dy);
    if dist < nearest then begin
      nearest:=dist;
      nearid:=s;
     end;
   end;
  if nearest>sight then nearid:=-1;
  nearestblob:=nearid
End;

Procedure Body.Rotaway;
{ Removes a body and rearranges the death matrix }
var s:integer;
Begin
  dec(numbodies);
  For s:=idno to numbodies do begin
    bodies[s]:=bodies[s+1];
    bodies[s].idno:=s;
   end;
End;

Procedure blob.FindMate;
{ Finds the nearest blob and then sets that as a mating }
{  target. If a target has already been found, then the }
{  blob moves towards the target                        }
Begin
  If Target=0 then target:=nearestblob(pos)
   else if target=-1
    then state:=ceat
    else if cansee(target)
     then begin
       if pos.x<blobs[target].pos.x then pos.x:=pos.x+1;
       if pos.x>blobs[target].pos.x then pos.x:=pos.x-1;
       if pos.y<blobs[target].pos.y then pos.y:=pos.y+1;
       if pos.y>blobs[target].pos.y then pos.y:=pos.y-1;
       if eqlpnt(pos,blobs[target].pos)
        then Mate(target);
      end
     else state:=choosestate(IDno);
End;

Procedure blob.Mate(MateID:ID);
{ Mates with another blob and tries to lay an egg }
var A,D,E,F,H,R:integer;
Begin
  FindSpecs(DNA,A,D,E,F,H,R);
  if (currpop<popcap)
      and (children<sqrt(sqrt(21/1))/sqrt(sqrt(21/D))*kidcap)
      and (blobs[mateid].children<kidcap)
   then begin
     Blobs[currpop+1].Genratn:=Genratn+1;
     Blobs[currpop+1].Born(DNA,blobs[target].DNA,Pos);
     inc(children);
     inc(blobs[mateid].children);
    end;
  state:=ceat;
End;

Procedure Body.New(location:point;cs:string);
{ creats a new body at location }
Begin
  inc(numbodies);
  pos:=location;
  decay:=0;
  cause:=cs;
  idno:=numbodies;
End;

Function Nearestbody(bp:point):ID;
{ Finds the closest body to a position }
var s:integer;
    dx,dy:real;
    dist:real;
    nearest:real;
    nearid:ID;
Begin
  dx:=sizex+1;
  dy:=sizex+1;
  nearest:=sqrt(sqr(dx)+sqr(dy));
  For s:=1 to numbodies do if s<>n then begin
    dx:=bp.x-bodies[s].pos.x;
    dy:=bp.y-bodies[s].pos.y;
    dist:=sqrt(dx*dx+dy*dy);
    if dist < nearest then begin
      nearest:=dist;
      nearid:=s;
     end;
   end;
  if nearest>sight then nearid:=-1;
  nearestbody:=nearid
End;

Procedure blob.FindVictim;
{ Finds the nearest blob and then sets that as the victim }
{  target. If a target has already been found, then the   }
{  blob moves towards the target.                         }
Begin
  If Target=0 then target:=nearestblob(pos)
   else if target=-1
    then state:=ceat
    else if cansee(target)
     then begin
       if pos.x<blobs[target].pos.x then pos.x:=pos.x+1;
       if pos.x>blobs[target].pos.x then pos.x:=pos.x-1;
       if pos.y<blobs[target].pos.y then pos.y:=pos.y+1;
       if pos.y>blobs[target].pos.y then pos.y:=pos.y-1;
       if eqlpnt(pos,blobs[target].pos)
        then Attack(target);
      end
     else state:=choosestate(IDno);
End;

function blob.cansee(blobID:ID):boolean;
{ returns true if blobID is within sight }
var dx,dy:real;
    dist:real;
Begin
  dx:=pos.x-blobs[blobID].pos.x;
  dy:=pos.y-blobs[blobID].pos.y;
  dist:=sqrt(dx*dx+dy*dy);
  if dist>sight
   then cansee:=false
   else cansee:=true;
End;

function blob.cansense(blobID:ID):boolean;
{ returns true if blobID is close }
var dx,dy:real;
    dist:real;
Begin
  dx:=pos.x-blobs[blobID].pos.x;
  dy:=pos.y-blobs[blobID].pos.y;
  dist:=sqrt(dx*dx+dy*dy);
  if dist>sight*2
   then cansense:=false
   else cansense:=true;
End;

Procedure Blob.Attack(VictimID:ID);
{ Fights with the victim, and kills it if it can, or gets killed }
{  trying, or just gives up.                                     }
var bA,bD,bE,bF,bH,bR:integer;
    vA,vD,vE,vF,vH,vR:integer;
    win:boolean;
Begin
  FindSpecs(DNA,bA,bD,bE,bF,bH,bR);
  FindSpecs(blobs[victimID].DNA,vA,vD,vE,vF,vH,vR);
  if currpop>initpop
   then if (random(21+vF-bF)=0) and (bf>5)
    then begin
      blobs[victimID].die(strKild);
      inc(kills);
      state:=ceat;
     end
    else if (random(21+bF-vF)=0) and (vf>5)
     then begin
       die(strKild);
       inc(blobs[victimID].kills);
      end
     else blobs[victimID].runfromtarget
   else state:=ceat;
End;

Procedure blob.RunFromTarget;
{ Runs away from another blob }
Begin
  state:=crun;
  chmind:=0;
  If Cansense(target)
   then begin
     if pos.x=blobs[target].pos.x
      then if pos.x>sizex div 2
       then if pos.x>2       then pos.x := pos.x-2 else
       else if pos.x<sizex-2 then pos.x := pos.x+2;
     if pos.x>blobs[target].pos.x
      then if pos.x<sizex-2 then pos.x := pos.x+2 else
      else if pos.x>2       then pos.x := pos.x-2;
     if pos.y=blobs[target].pos.y
      then if pos.y>sizey div 2
       then if pos.y>2       then pos.y := pos.y-2 else
       else if pos.y<sizey-2 then pos.y := pos.y+2;
     if pos.y>blobs[target].pos.y
      then if pos.y<sizey-2 then pos.y := pos.y+2 else
      else if pos.y>2       then pos.y := pos.y-2;
    end
   else state:=ceat;
  if hungr>(strv/strvfact) then state:=ceat;
End;

Procedure blob.SearchForOthers;
{ The blob heads towards its birthplace in the hopes of }
{  finding other blobs }
Begin
  loneliness:=initlonely;
  if pos.x>birthplace.x
   then dec(pos.x)
   else inc(pos.x);
  if pos.y>birthplace.y
   then dec(pos.y)
   else inc(pos.y);
  if not(nearestblob(pos)=-1) then state:=choosestate(IDno);
End;

Procedure blob.GoToCentre;
{ All blobs head to the centre }
Begin
  loneliness:=initlonely;
  if pos.x>sizex div 2
   then dec(pos.x)
   else inc(pos.x);
  if pos.y>sizey div 2
   then dec(pos.y)
   else inc(pos.y);
End;

End.

