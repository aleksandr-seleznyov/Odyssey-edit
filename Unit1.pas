unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DXDraws, DXClass, DIB, ComCtrls, ImgList,
  ToolWin, XPMan, ExtDlgs;

type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    DXL1: TDXImageList;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ListBox1: TListBox;
    Label1: TLabel;
    DXDraw2: TDXDraw;
    SB1: TScrollBar;
    Panel1: TPanel;
    DXTimer1: TDXTimer;
    DXL2: TDXImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button9: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button12: TButton;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox4: TCheckBox;
    XPManifest1: TXPManifest;
    SavePictureDialog1: TSavePictureDialog;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBox1Click(Sender: TObject);
    procedure DXDraw2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SB1Change(Sender: TObject);
    procedure DXDraw2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type cell = record
Level:Integer;
DrLevel:Boolean;
SetLevel:Integer;
end;

var
  Form1: TForm1;
  map: array[0..14,0..14,0..2] of cell;
  tmpmap: array[0..14,0..14] of cell;
  mx1,my1,mx2,my2:Integer;
  px,py,Item,oldx,oldy:Integer;
  lvl,tileset,vofs,colcount:Integer;
  tool : (point, line, rect, fill, wall, eraser);
  md,Draw:boolean;
  
implementation

{$R *.dfm}

procedure setTile(sx,sy,it:integer);
begin
if (sx>=0) and (sy>=0) and (sx<=14) and (sy<=14) then
begin
if it>-1 then
begin
map[sx,sy,lvl].drLevel:=true;
map[sx,sy,lvl].Level:=it;
map[sx,sy,lvl].SetLevel:=tileset;
end
else
map[sx,sy,lvl].drLevel:=false;
end;
end;

procedure setLine(stX,stY,eX,eY:Integer);
begin
end;

procedure setRect(stX,stY,eX,eY:Integer; fill:Boolean);
var i,j,x1,x2,y1,y2:Integer;
begin
if (stx>=0) and (sty>=0) and (stx<=14) and (sty<=14) then
begin
if stx>=ex then begin x1:=ex; x2:=stx end else begin x1:=stx; x2:=ex; end;
if sty>=ey then begin y1:=ey; y2:=sty end else begin y1:=sty; y2:=ey; end;
if x2>14 then x2:=14;
if x1<0 then x1:=0;
if y2>14 then y2:=14;
if y1<0 then y1:=0;
for i:=x1 to x2 do
for j:=y1 to y2 do
if fill then
setTile(i,j,item) else
if ((i=x1) or (i=x2)) or ((j=y1) or (j=y2)) then setTile(i,j,item);
end;

end;

procedure setWall(stX,stY,eX,eY:Integer);
var i,j,x1,x2,y1,y2:Integer;
begin
if (stx>=0) and (sty>=0) and (stx<=14) and (sty<=14) then
begin
if stx>=ex then begin x1:=ex; x2:=stx end else begin x1:=stx; x2:=ex; end;
if sty>=ey then begin y1:=ey; y2:=sty end else begin y1:=sty; y2:=ey; end;
if x2>14 then x2:=14;
if x1<0 then x1:=0;
if y2>14 then y2:=14;
if y1<0 then y1:=0;
for i:=x1 to x2 do
for j:=y1 to y2 do
begin
if ((i=x1) or (i=x2)) then setTile(i,j,item);
if ((j=y1) or (j=y2)) then setTile(i,j,item+1);
if ((j=y1) and (i=x1)) then setTile(i,j,item+9);
if ((j=y2) and (i=x2)) then setTile(i,j,item+6);
if ((j=y1) and (i=x2)) then setTile(i,j,item+8);
if ((j=y2) and (i=x1)) then setTile(i,j,item+7);
end;

end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var i,j:Integer;
TilesList: TextFile;
TileName: string;
begin
lvl:=0;
tileset:=3;
vofs:=0;
item:=-1;
colcount:=12;
tool:=point;
draw:=false;
dxdraw1.Cursor:=crNone;

for i:=0 to 14 do
for j:=0 to 14 do
with map[i,j,0] do
begin
DrLevel:=true;
SetLevel:=3;
Level:=71;
end;


listBox1.Items.LoadFromFile('img\tiles.txt');
i:=2;
AssignFile(TilesList, 'img\tiles.txt');
Reset(TilesList);
  while not Eof(TilesList) do
  begin
    ReadLn(TilesList, TileName);
    inc(i);
    DXL1.Items.add;
    DXL1.Items.Items[i].Name:=tileName;
    DXL1.Items.Items[i].PatternHeight:=54;
    DXL1.Items.Items[i].PatternWidth:=54;
    DXL1.Items.Items[i].Transparent:=true;
    DXL1.Items.Items[i].TransparentColor:=clFuchsia;
    DXL1.Items.Items[i].Picture.LoadFromFile('img\'+TileName+'.bmp');
  end;
 
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var i,j,l :Integer;
begin
DXDraw1.Surface.Fill(0);

px:=(( ( Mx1 -395  -26) + 2*( My1  -1 ) ) div 52)-1;
py:=(( 2*( My1 -1 ) - ( Mx1 -395 -26 ) ) div 52)-1;


for l:=0 to 2  do
for i:=0 to 14  do
for j:=0 to 14 do
with map[i,j,l] do
begin
// Тайлы ///////////////////////////////////////////////////////////////////////
if DrLevel then
DXL1.Items[SetLevel].Draw(DXDRAW1.Surface,(i*26-j*26)+395,(j*13+i*13),Level);
////////////////////////////////////////////////////////////////////////////////

// Сетка ///////////////////////////////////////////////////////////////////////
if (l=0) and (CheckBox1.Checked) then
DXL1.Items[0].Draw(DXDRAW1.Surface,(i*26-j*26)+395,(j*13+i*13)+27,2+combobox1.ItemIndex);
////////////////////////////////////////////////////////////////////////////////
end;

//инструмент////////////////////////////////////////////////////////////////////
if (px>=0) and (py>=0) and (px<=14) and (py<=14) then

  if item=-1 then
  DXL1.Items[0].Draw(DXDRAW1.Surface,(px*26-py*26)+395,(py*13+px*13)+27,1)
  else begin
  DXL1.Items[tileset].Draw(DXDRAW1.Surface,(px*26-py*26)+395,(py*13+px*13),item);
  DXL1.Items[0].Draw(DXDRAW1.Surface,(px*26-py*26)+395,(py*13+px*13)+27,0);
  end;
////////////////////////////////////////////////////////////////////////////////


//Интерфейс ////////////////////////////////////////////////////////////////////
if CheckBox4.Checked then begin
DXL1.Items[1].Draw(DXDRAW1.Surface,10,20,lvl);
if item>-1 then begin
DXL1.Items[1].Draw(DXDRAW1.Surface,10,100,3);
DXL1.Items[tileset].Draw(DXDRAW1.Surface,10,100,item);
end else
DXL1.Items[1].Draw(DXDRAW1.Surface,10,100,4);


with DXDraw1.Surface.Canvas do
    begin
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
      Textout(0, 0, '    Слой:');
      Textout(0, 80, '    Тайл:');
      Textout(100, 0, 'FPS: '+inttostr(DXTimer1.FrameRate));
      if (px>-1) and (px<15) and (py>-1) and (py<15) then
      Textout(100, 20, 'Координаты: '+char(65+py)+inttostr(px))
      else
      Textout(100, 20, 'Координаты: ');
      Release;
    end;

end;
////////////////////////////////////////////////////////////////////////////////

/////////Подписи ///////////////////////////////////////////////////////////////
if CheckBox3.Checked then begin
j:=15;
for i:=0 to 14 do
  DXL1.Items[0].Draw(DXDRAW1.Surface,(i*26-j*26)+395,(j*13+i*13)+27,1);
i:=15;
for j:=0 to 14 do
  DXL1.Items[0].Draw(DXDRAW1.Surface,(i*26-j*26)+395,(j*13+i*13)+27,1);


with DXDraw1.Surface.Canvas do
begin
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
    j:=15;
    for i:=0 to 14 do
      if i<=9 then
        Textout((i*26-j*26)+417,(j*13+i*13)+30,inttostr(i))
      else
        Textout((i*26-j*26)+412,(j*13+i*13)+30,inttostr(i));
    i:=15;
    for j:=0 to 14 do 
      Textout((i*26-j*26)+417,(j*13+i*13)+30,char(65+j)) ;
Release;
end;
end;
////////////////////////////////////////////////////////////////////////////////

// Курсор ////////////////////////////////////////////////////
if CheckBox2.Checked then begin
case tool of
point: begin if draw then DXL1.Items[2].Draw(DXDRAW1.Surface,mx1,my1-17,1) else DXL1.Items[2].Draw(DXDRAW1.Surface,mx1,my1-17,0) end;
line:  begin DXL1.Items[2].Draw(DXDRAW1.Surface,mx1-3,my1-14,4) end;
rect:  begin DXL1.Items[2].Draw(DXDRAW1.Surface,mx1-3,my1-14,2) end;
fill:  begin DXL1.Items[2].Draw(DXDRAW1.Surface,mx1-3,my1-14,3) end;
wall:  begin DXL1.Items[2].Draw(DXDRAW1.Surface,mx1-3,my1-14,5) end;
eraser:  begin DXL1.Items[2].Draw(DXDRAW1.Surface,mx1-3,my1-14,6) end;
end;
end;
//////////////////////////////////////////


DXDraw1.Flip;


 //////////// Нижний Drawer
DXDraw2.Surface.Fill(4000);


for i:=0 to colcount - 1 do
for j:=vofs to vofs+4 do
DXL1.Items[tileset].Draw(DXDRAW2.Surface,i*54,(j-vofs)*54,(colcount*j)+i);

if (mx2 div 54)<=colcount-1 then
DXL2.Items[0].Draw(DXDRAW2.Surface,(mx2 div 54)*54,(my2 div 54)*54,0);

if (item>-1) and ((item div colcount)>=vofs) and  ((item div colcount)<=vofs+4) then
DXL2.Items[0].Draw(DXDRAW2.Surface,(item mod colcount)*54,((item div colcount)-vofs)*54,1);



DXDraw2.Flip;
 ////////////////////////////////////

end;

procedure TForm1.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i,j:Integer;
begin

if ((tool=fill) or (tool=rect) or (tool=line) or (tool=wall)) and (md) then
begin
for i:=0 to 14 do
for j:=0 to 14 do
map[i,j,lvl]:=tmpmap[i,j];
if (tool=fill) then setRect(oldx,oldy,px,py, true);
if (tool=rect) then setRect(oldx,oldy,px,py, false);
if (tool=wall) then setWall(oldx,oldy,px,py);
end;

mx1:=x;
my1:=y;

if ((tool=point) or (tool=eraser)) and (draw) and (md) then setTile(px,py,item);

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
tileset:=ListBox1.ItemIndex+3;
item:=-1;
if (DXL1.Items[tileset].Picture.height div 54)-5 >=0 then
sb1.Max:=(DXL1.Items[tileset].Picture.height div 54)-5 else sb1.Max:=0;
colcount:=DXL1.Items[tileset].Picture.Width div 54
end;

procedure TForm1.DXDraw2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
mx2:=x;
my2:=y;
end;

procedure TForm1.SB1Change(Sender: TObject);
begin
vofs:=sb1.Position;
DXTimer1Timer(Sender, 0);
end;

procedure TForm1.DXDraw2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

if (button=mbLeft) and ((x div 54)<=colcount-1) then
item:=(colcount*((y div 54)+vofs))+(x div 54);
if button= mbRight then item:=-1;
end;


procedure TForm1.DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
md:=false;
if (tool=point) or (tool=eraser) then setTile(px,py,item);
if (tool=fill) then setRect(oldx,oldy,px,py, true);
if (tool=rect) then setRect(oldx,oldy,px,py, false);
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
lvl:=1;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
lvl:=2;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
lvl:=0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
tool:=point;
end;

procedure TForm1.DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j:Integer;
begin
for i:=0 to 14 do
for j:=0 to 14 do
tmpmap[i,j]:=map[i,j,lvl];

md:=true;

oldx:=px;
oldy:=py;

end;

procedure TForm1.Button2Click(Sender: TObject);
var f:textfile;
i,j,l:integer;
begin
if SaveDialog1.Execute then begin
AssignFile(F, SaveDialog1.FileName);
rewrite(f);
for i:=0 to 14 do
for j:=0 to 14 do
for l:=0 to 2 do
with map[i,j,l] do
begin
writeln(f,inttostr(Level));
writeln(f,booltostr(DrLevel,true));
writeln(f,inttostr(SetLevel));
end;
closefile(f);
end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var i,j,l :Integer;
begin
for l:=0 to 2  do
for i:=0 to 14  do
for j:=0 to 14 do
with map[i,j,l] do
begin
if l=0 then begin
DrLevel:=true;
SetLevel:=3;
Level:=71;
end else begin
Level:=0;
DrLevel:=false;
SetLevel:=0;
end;
end;

end;


procedure TForm1.Button3Click(Sender: TObject);
var f:textfile;
i,j,l:integer;
s:string;
begin
if OpenDialog1.Execute then
begin
DXDraw1.Enabled:=false;
lvl:=0;
tileset:=3;
vofs:=0;
item:=-1;
colcount:=12;
tool:=point;
draw:=false;

for i:=0 to 14 do
for j:=0 to 14 do
with map[i,j,0] do
begin
DrLevel:=true;
SetLevel:=3;
Level:=71;
end;

AssignFile(F, OpenDialog1.FileName);
reset(f);
for i:=0 to 14 do
for j:=0 to 14 do
for l:=0 to 2 do
with map[i,j,l] do
begin
readln(f,s);
Level:=strtoint(s);
readln(f,s);
DrLevel:=strtobool(s);
readln(f,s);
SetLevel:=strtoint(s);
end;
closefile(f);
DXDraw1.Enabled:=true;
end;
end;

procedure TForm1.Button11Click(Sender: TObject);
var i,j:Integer;
begin
for i:=0 to 14 do
for j:=0 to 14 do
map[i,j,lvl]:=tmpmap[i,j];
end;

procedure TForm1.Button12Click(Sender: TObject);
var b:tdib;
begin
if SavePictureDialog1.Execute then begin
b:=tdib.Create;
//dxtimer1.Enabled:=not dxtimer1.Enabled;
dxdraw1.GrabImage(0,0,838,450,b);
b.SaveToFile(SavePictureDialog1.FileName);
end;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin

draw:=not draw;

end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
tool:=rect;
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin
tool:=fill;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
tool:=line;
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
tool:=wall;
end;

procedure TForm1.ToolButton11Click(Sender: TObject);
begin
///tool:=eraser;
Item:=-1;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
combobox1.Enabled:=CheckBox1.Checked
end;

procedure TForm1.ToolButton13Click(Sender: TObject);
var i,j:Integer;
begin
for i:=0 to 14 do
for j:=0 to 14 do
map[i,j,lvl]:=tmpmap[i,j];
end;

end.

