Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType, ExtCtrls,
  cef3types, cef3lib, cef3intf, cef3lcl,
  Handler; // custom render process handler

Type

  { TMainform }

  TMainform = class(TForm)
    BGo : TButton;
    Button1 : TButton;
    Button2 : TButton;
    Button3 : TButton;
    Chromium : TChromium;
    EUrl : TEdit;
    LUrl : TStaticText;
    Log : TMemo;
    procedure BGoClick(Sender : TObject);
    procedure Button1Click(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure Button3Click(Sender : TObject);
    procedure ChromiumJsdialog(Sender: TObject; const Browser: ICefBrowser;
      const originUrl: ustring; dialogType: TCefJsDialogType;
      const messageText, defaultPromptText: ustring; callback: ICefJsDialogCallback;
      out suppressMessage: Boolean; out Result: Boolean);
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

procedure TMainform.BGoClick(Sender: TObject);
begin
  Chromium.Load(EUrl.Text);
end;

procedure TMainform.Button1Click(Sender: TObject);
begin
  Chromium.Load('about:blank');
end;

// JavaScript shows value of window.myval
procedure TMainform.Button2Click(Sender: TObject);
begin
  Chromium.Browser.MainFrame.ExecuteJavaScript('alert(window.myval);', 'about:blank', 0);
end;

// JavaScript executes TMyHandler.Execute
procedure TMainform.Button3Click(Sender: TObject);
begin
  Chromium.Browser.MainFrame.ExecuteJavaScript('alert(cef.test.test_param);', 'about:blank', 0);
end;

procedure TMainform.ChromiumJsdialog(Sender: TObject; const Browser: ICefBrowser;
  const originUrl: ustring; dialogType: TCefJsDialogType;
  const messageText, defaultPromptText: ustring; callback: ICefJsDialogCallback;
  out suppressMessage: Boolean; out Result: Boolean);
begin
  If dialogType = JSDIALOGTYPE_ALERT then
  begin
    ShowMessage('JavaScript alert:' + LineEnding + messageText);
    callback.Cont(True, '');
    Result := True;
  end
  Else
  begin
    suppressMessage := False;
    Result := False;
  end;
end;

procedure TMainform.ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser; const title: ustring);
begin
  Caption := 'Browser - ' + UTF8Encode(title);
end;

procedure TMainform.EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

procedure TMainform.FormCreate(Sender: TObject);
begin
  // No subprocess here
  // If you want to use a subprocess, this CefRenderProcessHandler has to be registered in subprocess
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;
end;

end.
