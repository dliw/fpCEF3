Unit Handler;

{$MODE objfpc}{$H+}

(*
 * Everything in here is called from a render process, so there is no access to GUI and all the
 * data of the main process.
 *)

Interface

Uses
  Classes, SysUtils,
  cef3types, cef3intf, cef3ref, cef3own;

Type
  { Custom handler for the render process }
  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
    protected
      function OnProcessMessageReceived(const browser: ICefBrowser; sourceProcess: TCefProcessId;
        const message: ICefProcessMessage): Boolean; override;
  end;

Implementation

Var
  // Don't access outside of callbacks
  // Enables access to browser in callbacks, necessary unless nestedprocvars is used
  ActiveBrowser: ICefBrowser;

procedure visitDOM(const document: ICefDomDocument);
Var
  message: ICefProcessMessage;
begin
  message := TCefProcessMessageRef.New('domdata');
  With message.ArgumentList do
  begin
    SetString(0, document.GetTitle);
    SetString(1, document.GetSelectionAsText);
  end;

  ActiveBrowser.SendProcessMessage(PID_BROWSER, message);
end;

procedure clickListener(const event: ICefDomEvent);
Var
  message: ICefProcessMessage;
begin
  message := TCefProcessMessageRef.New('click');
  With message.ArgumentList do
  begin
    SetString(0, event.Target.Name);
  end;

  ActiveBrowser.SendProcessMessage(PID_BROWSER, message);
end;

procedure registerListener(const document: ICefDomDocument);
begin
  document.Body.AddEventListenerProc('click', False, @clickListener);
end;

{ TCustomRenderProcessHandler }

function TCustomRenderProcessHandler.OnProcessMessageReceived(const browser : ICefBrowser;
  sourceProcess : TCefProcessId; const message : ICefProcessMessage) : Boolean;
begin
  ActiveBrowser := browser;
  Case message.Name of
   'visitdom':
       begin
         browser.MainFrame.VisitDomProc(@visitDOM);
         Result := True;
       end;
   'addListener':
       begin
         browser.MainFrame.VisitDomProc(@registerListener);
         Result := True;
       end;
  Else
     Result := inherited;
  end;
end;

end.

