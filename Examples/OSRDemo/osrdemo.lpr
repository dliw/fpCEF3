Program osrdemo;

{$MODE objfpc}{$H+}

Uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main, bgrabitmappack;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainform, Mainform);
  Application.Run;
end.

