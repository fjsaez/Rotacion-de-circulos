unit U_RotateASquare;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math,
  StdCtrls, ExtCtrls, ComCtrls;

type

  TPts = array of TPoint;

  TDataPoint = record
    Dist: TPoint;
    Cuadrante: byte;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Shape: TShape;  {Just a triangle to rotate around}
    TBar: TTrackBar;
    LPos: TLabel;
    Label2: TLabel; {Use a trackbar to let user change the angle}
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TBarChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
      {the center of the square}
  end;

var
  Form1: TForm1;
  PtC,PtT: TPts;
  Origen1: TPoint;
  DataAzul,DataVerde: array of TDataPoint;

implementation

{$R *.lfm}

procedure GenerarPuntos(var P: TPoint; Ang: real; Orig: TPoint);
var
  T: TPoint;
begin
  T:=P;
  P.x:=Round(T.x*Cos(Ang)-T.y*Sin(Ang));
  P.y:=Round(T.x*Sin(Ang)+T.y*Cos(Ang));
  P.x:=P.x+Orig.x;
  P.y:=P.y+Orig.y;
end;

procedure Rotar(var Pt: TPts; const Origin: TPoint; const Angle: integer;
                Data: array of TDataPoint);
var
  Angulo: real;
  I: integer;
begin
  Angulo:=Angle*Pi/180.0;
  for I:=0 to Length(Pt)-1 do
  begin
    case Data[I].Cuadrante of
      1: Pt[I]:=Point(+Data[I].Dist.x,+Data[I].Dist.y); //esq inf der (cuadrante 1)
      2: Pt[I]:=Point(-Data[I].Dist.x,+Data[I].Dist.y); //esq inf izq (cuadrante 2)
      3: Pt[I]:=Point(-Data[I].Dist.x,-Data[I].Dist.y); //esq sup izq (cuadrante 3)
      4: Pt[I]:=Point(+Data[I].Dist.x,-Data[I].Dist.y); //esq sup der (cuadrante 4)
    end;
    GenerarPuntos(Pt[I],Angulo,Origin);
  end;
end;

procedure ObtenerCuadrante(var Pt: TPts; Org: TPoint; var Data: array of TDataPoint);
var
  I: integer;
begin
  for I:=0 to Length(Pt)-1 do
    if Pt[I].x>=Org.x then
      if Pt[I].y>=Org.y then Data[I].Cuadrante:=1
                        else Data[I].Cuadrante:=4
    else
      if Pt[I].y>=Org.y then Data[I].Cuadrante:=2
                        else Data[I].Cuadrante:=3;
end;

procedure TForm1.TBarChange(Sender: TObject);
begin
  LPos.Caption:=IntToStr(TBar.Position)+'°';
  Rotar(PtC,Origen1,TBar.Position,DataAzul);
  Rotar(PtT,Origen1,TBar.Position,DataVerde);
  Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: integer;
begin
  Randomize;
  //los arrays a utilizar:
  SetLength(PtC,RandomRange(3,10));
  SetLength(DataAzul,Length(PtC));
  SetLength(PtT,RandomRange(3,10));
  SetLength(DataVerde,Length(PtT));
  //al inicio, establecer origen del cuadro al centro de la imagen
  Origen1.x:=Shape.Left+Shape.Width div 2;
  Origen1.y:=Shape.Top+Shape.height div 2;
  //los puntos azules en posiciones aleatorias:
  for I:=0 to High(PtC) do
  begin
    PtC[I]:=Point(RandomRange(10,500),RandomRange(10,500));
    DataAzul[I].Dist.x:=Abs(PtC[I].x-Origen1.x);
    DataAzul[I].Dist.y:=Abs(PtC[I].y-Origen1.y);
  end;
  //los puntos verdes en posiciones aleatorias:
  for I:=0 to High(PtT) do
  begin
    PtT[I]:=Point(RandomRange(10,500),RandomRange(10,500));
    DataVerde[I].Dist.x:=Abs(PtT[I].x-Origen1.x);
    DataVerde[I].Dist.y:=Abs(PtT[I].y-Origen1.y);
  end;
  DoubleBuffered:=true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ObtenerCuadrante(PtC,Origen1,DataAzul);
  ObtenerCuadrante(PtT,Origen1,DataVerde);
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  I: integer;
begin
  Canvas.Brush.Color:=clBlue;  //los círculos azules:
  for I:=0 to High(PtC) do Canvas.EllipseC(PtC[I].x,PtC[I].y,10,10);
  Canvas.Brush.Color:=clLime;  //los círculos verdes:
  for I:=0 to High(PtT) do Canvas.EllipseC(PtT[I].x,PtT[I].y,7,7);
end;

end.  //148
