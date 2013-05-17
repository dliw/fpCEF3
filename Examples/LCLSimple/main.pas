Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType,
  ExtCtrls, cef3lcl, cef3lib, cef3intf;

Type

  { TMainform }

  TMainform = class(TForm)
    BGo : TButton;
    Chromium : TChromium;
    EUrl : TEdit;
    LUrl : TStaticText;
    procedure BGoClick(Sender : TObject);
    procedure ChromiumLoadEnd(Sender : TObject; const Browser : ICefBrowser;
      const Frame : ICefFrame; httpStatusCode : Integer);
    procedure ChromiumTitleChange(Sender : TObject;
      const Browser : ICefBrowser; const title : ustring);
    procedure EUrlKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
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

procedure TMainform.ChromiumLoadEnd(Sender : TObject; const Browser : ICefBrowser; const Frame : ICefFrame;
  httpStatusCode : Integer);
begin
  //EUrl.Text := Browser.MainFrame.Url;
end;

procedure TMainform.ChromiumTitleChange(Sender : TObject; const Browser : ICefBrowser; const title : ustring);
begin
  Caption := 'Browser - ' + title;
end;

procedure TMainform.EUrlKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

end.
