Unit CONSTNTS;
{ Holds all the universal constants that govern the blob      }
{  universe and the biological information needed to initiate }
{  thei pitiful meaningless lives.                            }
{ Also contains some variables for called in multiple units,  }
{  as well as some useful general subprograms                 }

Interface

Type DNAStr=String[20];
     Point=record
       X,Y:Integer;  { Coordinates of a point in the world }
      end;
     ID=integer;

Const

{   ---===   user editable constants   ===---   }

  {Control}
    autorevive=false       { TRUE to prevent extinction };
    speedreg=true          { TRUE to regulate the speed };
    tdelay=0               { Milliseconds in real time per blob day };
    Tupdate=1              { Update display every ? years };
  {Universe}
    SizeX=300              { Width of universe };
    SizeY=300              { Length of universe };
  {Population}
    Popcap=250             { Population limit };
    kidcap=2               { Maximum children per parent };
  {Food}
    Avlblty=50             { Availability of food };
    Nrshmnt=10             { Nourishment in food };
    Strvfact=6             { How desperate blobs are for food };
  {Life}
    Sight=40               { How far blobs can see };
    EggAge=50              { Time it takes an egg to hatch };
    DecayTime=100          { Time it takes for a body to decy completely };
    Attention=100          { Time before a blob changes it's mind };
    Initlonely=10          { How not lonely a blob is };
  {Death}
    Oldage=500             { Age at which a blob is considered old };
    dold=500               { probability of dying if old };
    Strv=500               { Hunger it takes to starve to death };
    dstrv=100              { probability of dying if starving };
{WARNING- Attention must not exceed the starvation time. If it does, }
{         or even gets to close then the blobs may not be able to find }
{         food in time to survive. }
  {Initial}
    InitPop=2                         { initial population };
    initIalblobs:array[1..initpop]of DNAStr
        = ('RRRRRRRRRRRRRDDDDDDD',    { The DNA strings of each blob }
           'RRRRRRRRRRRRRDDDDDDD');   {   in the initial population  }

{       ---=== end user constants   ===---      }

Var Currpop:Integer;                   { Current population }
    NumBodies:integer;                 { Current number of bodies }
    TL:Point;                          { Top left corner of the universe }
    StatStrv:Longint;                  { Blobs that died of starvation }
    StatOld:LongInt;                   { Blobs that died of natural causes }
    StatKild:LongInt;                  { Blobs that were murdered }
    StatBorn:Longint;                  { Blobs born }
    DatY,Datd:integer;                 { The Date in a 99.99 format }
    h,i,j,n:integer;                   { FOR  loop variables }

Const {Death Constants}
  strStrv='Starvation';
  strold='Natural Causes';
  strKild='Homocide';

Const {State Constants}
  Cnil=099;
  CEgg=100;
  CEat=101;
  CMat=102;
  CFgt=103;
  CRun=104;
  CSch=105;
  CGth=106;
  States:Array[cnil..cgth] of string
    =('Sitting around doing nothing',
      'Being an egg',
      'Hunting for food',
      'Following potential mate',
      'Stalking potential victim',
      'Running away',
      'Searching for other blobs',
      'Heading to gathering');

Const {Types}
  name :array['A'..'R'] of string
       =('Aggressive','','',
         'Fertile',
         'Hungry',
         'Violent','',
         'Hunter','','','','','',
         'Hybrid','','','',
         'Breeder');

Function Strng(Num:longint):String;
Procedure incDate;
Procedure Ignore;
Function Eqlpnt(p1,p2:point):boolean;

Implementation

Function Strng(Num:longint):String;
{ Recieves a number as an integer and returns it as a string }
Var S : String;
Begin
  Str(Num,S);
  Strng := S;
End;

Procedure IncDate;
{ Increases the date }
Begin
  inc(datd);
  if datd=100 then begin
    inc(daty);
    datd:=0;
   end;
End;

Procedure Ignore;
{ Does nothing, but makes something else look complete }
Begin
End;

Function Eqlpnt(p1,p2:point):boolean;
{ Compares two points and returns true if they are equal }
Begin
  if (p1.x=p2.x) and (p1.y=p2.y)
   then eqlpnt:=true
   else eqlpnt:=false;
End;

End.


