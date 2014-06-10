Program dom;

{$MODE objfpc}{$H+}

Uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main, handler;

{$R *.res}

begin
  Application.Title := 'DOMAccess';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainform, Mainform);
  Application.Run;
end.

