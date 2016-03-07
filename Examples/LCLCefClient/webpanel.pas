Unit WebPanel;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Controls, ComCtrls, FileUtil, Forms, LCLProc,
  cef3types, cef3lib, cef3intf, cef3own, cef3lcl;

Type

  TWebPanel = class(TTabSheet)
  private
    fChromium: TChromium;
    fUrl: String;

    procedure ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser; const title: ustring);
    procedure ChromiumAddressChange(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; const url: ustring);
    procedure ChromiumOpenUrlFromTab(Sender: TObject; browser: ICefBrowser; frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean;
      out Result: Boolean);
    procedure ChromiumBeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo; var client: ICefClient;
      var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean; out Result: Boolean);

    procedure ChromiumBeforeContextMenu(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure ChromiumContextMenuCommand(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags; out Result: Boolean);
  protected
    procedure DoHide; override;
    procedure DoShow; override;
  public
    procedure InitializeChromium;
    procedure RequestClose;

    procedure OpenUrl(AUrl: String);

    property Url: String read fUrl write fUrl;
  end;


Implementation

Uses Main, cef3ref;

Type
  TClientMenuIDs = (
    CLIENT_ID_VISIT_COOKIES = Ord(MENU_ID_USER_FIRST),
    CLIENT_ID_EXIT
  );

  TCefNewTabTask = class(TCefTaskOwn)
  protected
    fTargetUrl: ustring;
    procedure Execute; override;
  public
    constructor Create(targetURL: ustring);
  end;


Var Path: ustring;

function VisitCookies(const cookie: TCefCookie; count, total: Integer;
  out deleteCookie: Boolean): Boolean;
Var
  tmp: TCefString;
begin
  Write(count, '/', total, ': ');

  tmp := cookie.path;
  Write(CefString(@tmp), ' ');

  tmp := cookie.name;
  Write(CefString(@tmp), ' ');

  tmp := cookie.domain;
  Write(CefString(@tmp), ' ');

  WriteLn(DateTimeToStr(CefTimeToDateTime(cookie.expires)));

  deleteCookie := False;
  Result := True;
end;

{ TCefNewTabTask }

procedure TCefNewTabTask.Execute;
begin
  Assert(CefCurrentlyOn(TID_UI));

  FMain.NewTab(UTF8Encode(fTargetUrl));
end;

constructor TCefNewTabTask.Create(targetURL: ustring);
begin
  inherited Create;

  fTargetUrl := targetURL;
end;

{ TWebPanel }

procedure TWebPanel.ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser;
  const title: ustring);
Var
  NewTitle: String;
begin
  NewTitle := UTF8Encode(title);

  If UTF8Length(NewTitle) < 15 then Caption := NewTitle
  Else Caption := UTF8Copy(NewTitle, 1, 12) + '...';
end;

procedure TWebPanel.ChromiumAddressChange(Sender: TObject; const Browser: ICefBrowser;
  const Frame: ICefFrame; const url: ustring);
begin
  fUrl := UTF8Encode(Browser.MainFrame.Url);
  FMain.EUrl.Text := fUrl;
end;

procedure TWebPanel.ChromiumBeforePopup(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean; out Result: Boolean);
begin
  // Called on IO thread, must be executed on the UI thread
  CefPostTask(TID_UI, TCefNewTabTask.Create(targetUrl));

  Result := True;
end;

procedure TWebPanel.ChromiumOpenUrlFromTab(Sender: TObject; browser: ICefBrowser; frame: ICefFrame;
  const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean;
  out Result: Boolean);
begin
  Assert(CefCurrentlyOn(TID_UI));

  FMain.NewTab(UTF8Encode(targetUrl));

  Result := True;
end;


procedure TWebPanel.ChromiumBeforeContextMenu(Sender: TObject; const Browser: ICefBrowser;
  const Frame: ICefFrame; const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  Assert(CefCurrentlyOn(TID_UI));

  If (params.GetTypeFlags in [CM_TYPEFLAG_PAGE, CM_TYPEFLAG_FRAME]) then
  begin
    // Add seperator if the menu already contains items
    If model.GetCount > 0 then model.AddSeparator;

    model.AddItem(Ord(CLIENT_ID_VISIT_COOKIES), '&Visit Cookies');
    model.AddSeparator;
    model.AddItem(Ord(CLIENT_ID_EXIT), 'Exit');
  end;
end;


procedure TWebPanel.ChromiumContextMenuCommand(Sender: TObject; const Browser: ICefBrowser;
  const Frame: ICefFrame; const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags; out Result: Boolean);
begin
  Assert(CefCurrentlyOn(TID_UI));

  Result := True;

  Case commandId of
    Ord(CLIENT_ID_VISIT_COOKIES): TCefCookieManagerRef.Global(nil).VisitAllCookiesProc(@VisitCookies);
    Ord(CLIENT_ID_EXIT): Application.Terminate;
  Else Result := False;
  end;
end;

procedure TWebPanel.DoHide;
begin
  inherited DoHide;

  If Assigned(fChromium) then fChromium.Hide;
end;

procedure TWebPanel.DoShow;
begin
  inherited DoShow;

  If Assigned(fChromium) then fChromium.Show;
end;

procedure TWebPanel.InitializeChromium;
begin
  If not Assigned(fChromium) then
  begin
    fChromium := TChromium.Create(Self);
    fChromium.Parent := Self;
    fChromium.AnchorAsAlign(alClient, 0);

    // Register callbacks
    fChromium.OnTitleChange := @ChromiumTitleChange;
    fChromium.OnAddressChange := @ChromiumAddressChange;

    fChromium.OnOpenUrlFromTab := @ChromiumOpenUrlFromTab;
    fChromium.OnBeforePopup := @ChromiumBeforePopup;

    fChromium.OnBeforeContextMenu := @ChromiumBeforeContextMenu;
    fChromium.OnContextMenuCommand := @ChromiumContextMenuCommand;
  end
  Else raise Exception.Create('Chromium already initialized.');
end;

procedure TWebPanel.RequestClose;
begin
  fChromium.Browser.Host.CloseBrowser(False);
end;

procedure TWebPanel.OpenUrl(AUrl: String);
begin
  fChromium.Load(AUrl);
end;


Initialization
  Path := GetCurrentDirUTF8 + DirectorySeparator;

  CefResourcesDirPath := Path + 'Resources';
  CefLocalesDirPath := Path + 'Resources' + DirectorySeparator + 'locales';
  //CefCachePath := Path + 'Cache';
  //CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};

  CefInitialize;

end.
