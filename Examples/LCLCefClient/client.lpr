program client;

{$mode objfpc}{$H+}

Uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
