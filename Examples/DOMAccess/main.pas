Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType, ExtCtrls,
  cef3types, cef3lib, cef3intf, cef3ref, cef3lcl,
  Handler; // custom render process handler

Type

  { TMainform }

  TMainform = class(TForm)
    BGo : TButton;
    Chromium : TChromium;
    EUrl : TEdit;
    LUrl : TStaticText;
    Log : TMemo;
    procedure BGoClick(Sender : TObject);
    procedure ChromiumKeyEvent(Sender : TObject; const Browser : ICefBrowser;
      const event : PCefKeyEvent; osEvent : TCefEventHandle; out Result : Boolean);
    procedure ChromiumLoadEnd(Sender : TObject; const Browser : ICefBrowser;
      const Frame : ICefFrame; httpStatusCode : Integer);
    procedure ChromiumProcessMessageReceived(Sender : TObject;
      const Browser : ICefBrowser; sourceProcess : TCefProcessId;
      const message : ICefProcessMessage; out Result : Boolean);
    procedure ChromiumTitleChange(Sender : TObject; const Browser : ICefBrowser;
      const title : ustring);
    procedure EUrlKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure FormCreate(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

Var
  Mainform : TMainform;

Implementation

{$R *.lfm}

{ TMainform }

procedure TMainform.BGoClick(Sender : TObject);
begin
  Chromium.Load(EUrl.Text);
end;

procedure TMainform.ChromiumKeyEvent(Sender: TObject; const Browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle; out Result: Boolean);
begin
  If event^.kind = KEYEVENT_KEYUP then
  begin
    If Browser.SendProcessMessage(PID_RENDERER,TCefProcessMessageRef.New('visitdom')) then
      Log.Append('Triggered DOM visit.')
    Else Log.Append('Failed to start DOM visit.');

    Result := True;
  end;
end;

procedure TMainform.ChromiumLoadEnd(Sender : TObject; const Browser : ICefBrowser; const Frame : ICefFrame;
  httpStatusCode : Integer);
begin
  EUrl.Text := UTF8Encode(Browser.MainFrame.Url);
end;

procedure TMainform.ChromiumProcessMessageReceived(Sender : TObject;
  const Browser : ICefBrowser; sourceProcess : TCefProcessId;
  const message : ICefProcessMessage; out Result : Boolean);
begin
  Case message.Name of
    'domdata':
         begin
           With message.ArgumentList do
           begin
             Log.Append('Title: ' + GetString(0));
             Log.Append('HasSelection: ' + BoolToStr(GetBool(1), True));
             Log.Append('Selection: ' + GetString(2));
           end;
           Result := True;
         end;
  Else
    Log.Append('Unhandled message: ' + message.Name);
    inherited;
  end;
end;

procedure TMainform.ChromiumTitleChange(Sender : TObject; const Browser : ICefBrowser; const title : ustring);
begin
  Caption := 'Browser - ' + UTF8Encode(title);
end;

procedure TMainform.EUrlKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

procedure TMainform.FormCreate(Sender : TObject);
begin
  // No subprocess here
  // If you want to use a subprocess, this CefRenderProcessHandler has to be registered in subprocess
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;

  Log.Append('Press any key to get DOM data...');
end;

end.
