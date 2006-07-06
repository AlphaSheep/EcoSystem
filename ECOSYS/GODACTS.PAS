Unit GODACTS;

Interface

Uses CREATURS, CONSTNTS;

Procedure Disease;
Procedure Famine;
Procedure DestroyEggs;
Procedure HuntingGroup;
Procedure RevivalGroup;
Procedure PsycoGroup;
Procedure MatingSeason;
Procedure KillingSeason;
Procedure HuntingSeason;
Procedure LongingForHome;
Procedure Gathering;
Procedure Paranoia;
Procedure RevivePopulation;
Procedure Cull;

Implementation

Procedure Disease;
{ Kill half the population }
var s:integer;
Begin
  if currpop>initpop*2
   then for s := 1 to currpop div 2 do begin
     blobs[s*2].die('Disease');
    end;
End;

Procedure Famine;
{ Kills all the hungry blobs }
var s:integer;
Begin
  s:=1;
  while (s<currpop) and (currpop>initpop) do
   if blobs[s].hungr>strv/2
    then blobs[s].die('Starvation caused by famine')
    else inc(s);
End;

Procedure RevivalGroup;
{ Creates some fertile breeders at a random location }
var s:integer;
    loc:point;
    P1,P2:DNAStr;
Begin
  loc.x:=random(sizex)+1;
  loc.y:=random(sizey)+1;
  s:=0;
  P1:='RRRRRRRRRRRRRRRRRRRR';
  P2:='DDDDDDDDDDDDDDDDDDDD';
  While (s<2) and (currpop<popcap) do begin
    inc(s);
    blobs[currpop+1].genratn:=0;
    blobs[currpop+1].born(p1,p2,loc);
    blobs[currpop].state:=cmat;
   end;
End;

Procedure PsycoGroup;
{ Creates some psycopathic killers at a random location }
var s:integer;
    loc:point;
    P1,P2:DNAStr;
Begin
  loc.x:=random(sizex)+1;
  loc.y:=random(sizey)+1;
  s:=0;
  P1:='AAAAAAAAAAAAAAAAAAAA';
  P2:='FFFFFFFFFFFFFFFFFFFF';
  While (s<8) and (currpop<popcap) do begin
    inc(s);
    blobs[currpop+1].genratn:=0;
    blobs[currpop+1].born(p1,p2,loc);
    blobs[currpop].state:=cmat;
   end;
End;

Procedure DestroyEggs;
{ Destroys all the eggs }
var s:integer;
Begin
  s:=1;
  while s<=currpop do
   if blobs[s].state=cegg
    then blobs[s].die('birth Defect')
    else inc(s);
End;

Procedure MatingSeason;
{ Makes all blobs look for mates }
var s:integer;
Begin
  For s:= 1 to currpop do with blobs[s] do begin
    state:=cmat;
    chmind:=0;
   end;
End;

Procedure KillingSeason;
{ Makes all blobs try kill eachother }
var s:integer;
Begin
  For s:= 1 to currpop do with blobs[s] do begin
    state:=cfgt;
    chmind:=0;
   end;
End;

Procedure HuntingSeason;
{ Makes all blobs go hunting }
var s:integer;
Begin
  For s:= 1 to currpop do with blobs[s] do begin
    state:=ceat;
    chmind:=0;
   end;
End;

Procedure HuntingGroup;
{ Creates some hungry hunters at a random location }
var s:integer;
    loc:point;
    P1,P2:DNAStr;
Begin
  loc.x:=random(sizex)+1;
  loc.y:=random(sizey)+1;
  s:=0;
  P1:='EEEEEEEEEEEEEEEEEEEE';
  P2:='HHHHHHHHHHHHHHHHHHHH';
  While (s<4) and (currpop<popcap) do begin
    inc(s);
    blobs[currpop+1].genratn:=0;
    blobs[currpop+1].born(p1,p2,loc);
    blobs[currpop].state:=cmat;
   end;
End;

Procedure Paranoia;
{ Makes every blob run away from the nearest blob }
var s:integer;
Begin
  for s:=1 to currpop do with blobs[s] do
   if not state=cEgg
    then begin
      target:=nearestblob(pos);
      runfromTarget;
     end;
End;

Procedure RevivePopulation;
{ Creates 2 new revival groups and makes it a mating season }
Begin
  RevivalGroup;
  RevivalGroup;
  MatingSeason;
End;

Procedure Cull;
{ Creates 4 psycoGroups and calls a killing season }
Begin
  PsycoGroup;
  PsycoGroup;
  PsycoGroup;
  PsycoGroup;
  KillingSeason;
End;

Procedure LongingForHome;
{ All blobs feel a strange longing to go home }
var s:integer;
Begin
  For s:= 1 to currpop do with blobs[s] do begin
    state:=csch;
    chmind:=0;
   end;
End;

Procedure Gathering;
{ All blobs gather at the centre of the universe }
var s:integer;
Begin
  For s:= 1 to currpop do with blobs[s] do begin
    state:=cgth;
    chmind:=0;
   end;
End;

End.