Unit Handler;

{$MODE objfpc}{$H+}

(*
 * Everything in here is called from a render process, so there is no access to GUI and all the
 * data of the main process.
 *)

Interface

Uses
  Classes, SysUtils,
  cef3types, cef3intf, cef3ref, cef3own, cef3lib;

Type
  { Custom handler for the render process }
  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    // Test Window Bindings
    procedure OnContextCreated(const browser: ICefBrowser; const frame: ICefFrame; const context: ICefv8Context); override;
    // Test Extension
    procedure OnWebKitInitialized; override;
  end;

  TMyHandler = class(TCefv8HandlerOwn)
  protected
  function Execute(const name: ustring; const obj: ICefv8Value;
    const arguments: ICefv8ValueArray; var retval: ICefv8Value;
    var exception: ustring): Boolean; override;
  end;

Implementation

Var
  mystr : String;

{ TMyHandler }

function TMyHandler.Execute(const name : ustring; const obj : ICefv8Value;
  const arguments : ICefv8ValueArray; var retval : ICefv8Value;
  var exception : ustring) : Boolean;
begin
  // return a value
  retval := TCefv8ValueRef.NewString(
    'Handler called for function ' + name + '(#args = ' + IntToStr(Length(arguments)) + ')');

  Result := True;
end;

{ TCustomRenderProcessHandler }

procedure TCustomRenderProcessHandler.OnContextCreated(const browser : ICefBrowser;
  const frame : ICefFrame; const context : ICefv8Context);
Var
  myWin : ICefv8Value;
  args  : ICefv8ValueArray;
begin
  myWin := context.GetGlobal;
  mystr := 'a test string';
  SetLength(args, 1);
  args[0] := TCefv8ValueRef.NewString(mystr);
  myWin.SetValueByKey('myval', args[0], []);
end;

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
Var
  Code: ustring;
begin
  Code :=
   'var cef;'+
   'if (!cef)'+
   '  cef = {};'+
   'if (!cef.test)'+
   '  cef.test = {};'+
   '(function() {'+
   '  cef.test.__defineGetter__(''test_param'', function() {'+
   '    native function GetTestParam();'+
   '    return GetTestParam();'+
   '  });'+
   '  cef.test.__defineSetter__(''test_param'', function(b) {'+
   '    native function SetTestParam();'+
   '    if(b) SetTestParam(b);'+
   '  });'+
   '  cef.test.test_object = function() {'+
   '    native function GetTestObject();'+
   '    return GetTestObject();'+
   '  };'+
   '})();';

  CefRegisterExtension('example/v8', Code, TMyHandler.Create as ICefv8Handler);
end;

end.

