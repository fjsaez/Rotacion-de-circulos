program RotateASquare;

{$MODE Delphi}

uses
  Forms, Interfaces,
  U_RotateASquare in 'U_RotateASquare.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
