Program subprocess;

{$mode objfpc}{$H+}

Uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  cef3types, cef3api;

Var
  Args : TCefMainArgs;

begin
  CefLoadLibrary;

  {$IFDEF WINDOWS}
  Args.instance := HINSTANCE();

  Halt(cef_execute_process(@Args, nil));
  {$ELSE}
  Args.argc := argc;
  Args.argv := argv;

  Halt(cef_execute_process(@Args, nil));
  {$ENDIF}
end.

