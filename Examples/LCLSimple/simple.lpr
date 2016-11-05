Program simple;

{$MODE objfpc}{$H+}

Uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'Simple';
  {$IFDEF WINDOWS}
  Application.MainFormOnTaskBar := True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TMainform, Mainform);
  Application.Run;
end.

