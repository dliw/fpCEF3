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
    procedure ChromiumLoadEnd(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
      httpStatusCode: Integer);
    procedure ChromiumTakeFocus(Sender: TObject; const Browser: ICefBrowser; next_: Boolean);
    procedure ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser; const title: ustring);
    procedure EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
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

procedure TMainform.FormCreate(Sender: TObject);
begin
  {$IFDEF DARWIN}
    // Uncomment for a single process application
    //CefSingleProcess := True;
  {$ELSE}
    {$INFO subprocess is set here, comment out to use the main program as subprocess}
    CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};
  {$ENDIF}
end;

end.
