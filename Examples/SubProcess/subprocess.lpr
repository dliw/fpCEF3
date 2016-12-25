Program subprocess;

{$mode objfpc}{$H+}

Uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  cef3types, cef3api;

Var
  Args : TCefMainArgs;

begin
  CefLoadLibrary;

  {$IFDEF WINDOWS}
  Args.instance := HINSTANCE();

  Halt(cef_execute_process(@Args, nil, nil));
  {$ELSE}
  Args.argc := argc;
  Args.argv := argv;

  Halt(cef_execute_process(@Args, nil, nil));
  {$ENDIF}
end.

