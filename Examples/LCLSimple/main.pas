Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Dialogs, StdCtrls, LCLType,
  cef3types, cef3lib, cef3intf, cef3lcl;

Type

  { TMainform }

  TMainform = class(TForm)
    BGo: TButton;
    Chromium: TChromium;
    EUrl: TEdit;
    LUrl: TStaticText;
    procedure BGoClick(Sender: TObject);
    procedure ChromiumBeforeClose(Sender: TObject; const Browser: ICefBrowser);
    procedure ChromiumBeforeUnloadDialog(Sender: TObject; const Browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean; const callback: ICefJsDialogCallback;
      out Result: Boolean);
    procedure ChromiumLoadEnd(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
      httpStatusCode: Integer);
    procedure ChromiumTakeFocus(Sender: TObject; const Browser: ICefBrowser; next_: Boolean);
    procedure ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser; const title: ustring);
    procedure EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
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

procedure TMainform.ChromiumBeforeClose(Sender: TObject; const Browser: ICefBrowser);
begin
  Halt;
end;

procedure TMainform.ChromiumBeforeUnloadDialog(Sender: TObject; const Browser: ICefBrowser;
  const messageText: ustring; isReload: Boolean; const callback: ICefJsDialogCallback;
  out Result: Boolean);
Var
  AllowClose: Boolean;
begin
  // use custom dialog
  Result := True;

  // show dialog
  AllowClose := MessageDlg('Confirmation', messageText, mtConfirmation, [mbYes,mbNo], 0) = mrYes;

  // execute callback
  callback.Cont(AllowClose, '');
end;

procedure TMainform.ChromiumLoadEnd(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
  httpStatusCode: Integer);
begin
  EUrl.Text := UTF8Encode(Browser.MainFrame.Url);
end;

procedure TMainform.ChromiumTakeFocus(Sender: TObject; const Browser: ICefBrowser; next_: Boolean);
begin
  SelectNext(ActiveControl, next_, True);
end;

procedure TMainform.ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser; const title: ustring);
begin
  Caption := 'Browser - ' + UTF8Encode(title);
end;

procedure TMainform.EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

procedure TMainform.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := Chromium.Browser.Host.TryCloseBrowser;
end;


Initialization
  {$IFNDEF DARWIN}
    {$INFO subprocess is set here, uncomment to use a subprocess}
    //CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};
  {$ENDIF}

end.
