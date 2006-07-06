Program BlobEcoSystem;
{   Simulates an artificial population of blobs that eat, mate and  }
{ attack each other, and then die leaving children that do the same }
{ things that their parents did, except better because of evolution }
Uses CREATURS, CONSTNTS, INFODISP, GODACTS,
     CRT, GRAPH, MOUSE;

Procedure Pause;
{ Pauses and allows the user to look at individual blobs }
var endit,found,body:boolean;
    mx,my,b1,b2:word;
    s,t:integer;
    mp1,mp:point;
Begin
  refreshdisplay;
  Otherinfo;
  UpdateInfo;
  endit:=false;
  findgmouse(word(mp.x),word(mp.y));
  mp.x:=mp.x-tl.x;
  mp.y:=mp.y-tl.y;
  t:=nearestbody(mp);
  s:=nearestblob(mp);
  repeat
    Showmousecursor;
    mp1:=mp;
    findgmouse(word(mp.x),word(mp.y));
    mp.x:=mp.x-tl.x;
    mp.y:=mp.y-tl.y;
    if not eqlpnt(mp1,mp) then begin
      clearbodystats(t);
      clearblobstats(s);
      t:=nearestbody(mp);
      s:=nearestblob(mp);
      displaybodystats(t);
      displayblobstats(s);
      delay(300);
     end;
    if keypressed then endit:=true;
   until endit;
  hidemousecursor;
  clearbodystats(t);
  clearblobstats(s);
  clearotherinfo;
  hidemousecursor;
  delay(250);
  if keypressed then readkey;
End;

Procedure HandleKey;
{ Reads a key and then makes a decision and calls the }
{  appropriate response }
Begin
  Endkey:=upcase(Readkey);
  case endkey of
    'P': Pause;
    'Z': HuntingSeason;
    'X': MatingSeason;
    'C': KillingSeason;
    'A': HuntingGroup;
    'S': RevivalGroup;
    'D': PsycoGroup;
    'Q': Famine;
    'W': Destroyeggs;
    'E': Disease;
    'T': Paranoia;
    'G': RevivePopulation;
    'B': Cull;
    'Y': LongingForHome;
    'H': Gathering;
    #27: userabort:=true;
    else ignore;
   end;
  refreshdisplay;
  delay(500);
  If keyPressed then repeat readkey until not keypressed;
End;

Procedure InitBlobs;
{ Sets the specs of the initial population and draws the universe }
{ Also initializes variables }
Begin
  DrawUniverse;
  Daty:=0;Datd:=0;
  For j := 1 to initpop do with blobs[j] do begin
    idno:=j;
    DNA:=initialblobs[j];
    Pos.X:=sizex div 2;
    Pos.Y:=sizeY div 2;
    birthplace:=pos;
    loneliness:=initlonely;
    Age:=0;
    Hungr:=0;
    State:=Choosestate(IDNo);
    Target:=0;
    Genratn:=0;
    Children:=0;
    chmind:=0;
   end;
  For j := 1 to initpop do with blobs[j] do DoBirthCert(j);
  Currpop:=InitPop;
  Statborn:=initpop;
  StatKild:=0;
  statold:=0;
  statstrv:=0;
  userabort:=false;
End;

Function Extinct:boolean;
{ Returns true if all the blobs are dead }
begin
  if currpop<1 then extinct:=true
  else extinct := false;
end;

procedure HandleBodies;
Begin
  Drawbodies;
  For h:=1 to numbodies do with bodies[h] do begin
    inc(decay);
    if decay>decaytime then begin
      PutPixel(Tl.X+pos.x,TL.Y+pos.y,0);
      rotaway;
     end;
   end;
End;

Procedure Cycle;
Begin
  For h:=1 to currpop do with blobs[h] do begin
    prevpos:=pos;
    inc(age);
    inc(chmind);
    if loneliness>2 then dec(loneliness);
    if age>0 then inc(hungr);
    if (chmind>attention) and (age>0) then begin
      target:=0;
      state:=choosestate(IDno);
     end;
    case state of
      cegg :BeAnEgg;
      ceat :findfood;
      cmat :findmate;
      cfgt :findvictim;
      cnil :ignore;
      crun :runfromtarget;
      csch :SearchForOthers;
      cgth :GoToCentre;
     end;
    if age>oldage then if random(dold)=0 then begin
      PutPixel(Tl.X+prevpos.x,TL.Y+prevpos.y,0);
      PutPixel(Tl.X+pos.x,TL.Y+pos.y,0);
      die(strold);
     end;
    if hungr>strv then if random(dstrv)=0 then begin
      PutPixel(Tl.X+prevpos.x,TL.Y+prevpos.y,0);
      PutPixel(Tl.X+pos.x,TL.Y+pos.y,0);
      die(strstrv);
     end;
   end;
End;

Procedure InitCerts;
Var Death:Text;
    Birth:Text;
Begin
  Assign(Death,'DEATHS.TXT');
  Assign(Birth,'BIRTHS.TXT');
  Rewrite(Death);
  Rewrite(Birth);
  Close(Death);
  Close(Birth);
End;

Procedure SignOffDeath(const rsn:byte);
{ Ends the Death Records files with a message stating the }
{  reason why it ended }
Var Death:Text;
    Stats:Text;
    Line:String;
    DateStr:string[2];
Begin
  Assign(Death,'DEATHS.TXT');
  Append(Death);
  case rsn of
    0: begin
      Writeln(Death,'==================================================');
      Writeln(Death,'                 Species Extinct                  ');
      Writeln(Death,'==================================================');
     end;
    1: begin
      Writeln(Death,'==================================================');
      Writeln(Death,'   Universe aborted by GOD... Blobs terminated.   ');
      Writeln(Death,'      No records of final genocide available      ');
      Writeln(Death,'==================================================');
     end;
   end;
  Datestr:=Strng(Datd);
  If length(datestr)=1 then datestr:='0'+datestr;
  Line:='Final date : '+Strng(daty)+'.'+Datestr;
  Writeln(Death,line);
  Close(Death);
  Assign(Stats,'STATS.TXT');
  Rewrite(Stats);
  Line:='Total blobs born : '+strng(statborn);
  Writeln(stats,line);
  Line:='Total blobs that died : '+strng(statkild+statstrv+statold);
  Writeln(stats,line);
  Line:='   Natural deaths : '+strng(statold);
  Writeln(stats,line);
  Line:='   Starved : '+strng(statstrv);
  Writeln(stats,line);
  Line:='   Murdered : '+strng(statkild);
  Writeln(stats,line);
  Close(Stats);
End;

{   ---=== MAIN PROGRAM : BlobEcoSystem ===---   }

Const GraphPath='C:\BGI';         { Path to the graphics drivers }

Var GraphDriver,GraphMode:Integer;   { Driver and mode for graphics }

Begin
  Randomize;
  GraphDriver:=Detect;
  GraphMode:=Detect;
  InitGraph(GraphDriver,GraphMode,GraphPath);
  If GraphResult <> GROK then GError;
  SetGraphMode(GetmaxMode);
  InitCerts;
  InitBlobs;
  endkey:=#0;
  Repeat
    incdate;
    if (datd=0)and (daty mod tupdate=0) then updateinfo;
    Cycle;
    if currpop<4 then if autorevive
     then revivepopulation
     else delay(100);
    DrawBlobs;
    HandleBodies;
    If Keypressed then handlekey;
    if speedreg then delay(tdelay);
   until userabort or extinct;
  If extinct then signoffdeath(0) else signoffdeath(1);
  CloseGraph;
  If extinct then begin
    TextColor(10);
    ClrScr;
    Gotoxy(15,11);
    Writeln('==================================================');
    Gotoxy(15,12);
    Writeln('                 Species Extinct                  ');
    Gotoxy(15,13);
    Writeln('==================================================');
    readkey;
   end;
End.



