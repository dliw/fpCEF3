(*
 *                       Free Pascal Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Author: d.l.i.w <dev.dliw@gmail.com>
 * Repository: http://github.com/dliw/fpCEF3
 *
 *)

Unit cef3lcl;

{$I cef.inc}

{
 Choose the right backend depending on used LCL widgetset
 Currently supported:
   Windows
   Linux / GTK2
}

{$IFDEF LCLWin32}
  {$DEFINE TargetDefined}
{$ENDIF}
{$IFDEF LCLGTK2}
  {$IFDEF Linux}
    {$DEFINE TargetDefined}
  {$ENDIF}
{$ENDIF}

(*
{$IFDEF LCLGTK}
  {$IFDEF Linux}
    {$DEFINE TargetDefined}
  {$ENDIF}
{$ENDIF}
*)
(*
{$IFDEF LCLCarbon}
  {$DEFINE TargetDefined}
{$ENDIF}
{$IFDEF LCLQT}
  {$DEFINE TargetDefined}
{$ENDIF}
*)
{$IFNDEF TargetDefined}
  {$ERROR This LCL widgetset/OS is not yet supported}
{$ENDIF}

Interface
Uses
  Classes, SysUtils, LCLProc, Forms, Controls, LCLType, LCLIntf, LResources, InterfaceBase,
  Graphics, LMessages, WSLCLClasses, WSControls,
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF LCLGTK2}
  Gtk2Def, gdk2x, glib2, gtk2, Gtk2Int,  Gtk2Proc,
  {$ENDIF}
  cef3lib, cef3intf, cef3class, cef3gui;

type

  { TCustomChromium }

  TCustomChromium = class(TWinControl, IChromiumEvents)
    private
      FHandler: ICefClient;
      FBrowser: ICefBrowser;
      FBrowserId: Integer;
      FDefaultUrl: ustring;

      FCanvas    : TCanvas;

      FOnProcessMessageReceived: TOnProcessMessageReceived;
      FOnLoadStart: TOnLoadStart;
      FOnLoadEnd: TOnLoadEnd;
      FOnLoadError: TOnLoadError;
      FOnRenderProcessTerminated: TOnRenderProcessTerminated;
      FOnPluginCrashed: TOnPluginCrashed;

      FOnTakeFocus: TOnTakeFocus;
      FOnSetFocus: TOnSetFocus;
      FOnGotFocus: TOnGotFocus;
      FOnBeforeContextMenu: TOnBeforeContextMenu;
      FOnContextMenuCommand: TOnContextMenuCommand;
      FOnContextMenuDismissed: TOnContextMenuDismissed;
      FOnPreKeyEvent: TOnPreKeyEvent;
      FOnKeyEvent: TOnKeyEvent;
      FOnLoadingStateChange: TOnLoadingStateChange;

      FOnAddressChange: TOnAddressChange;
      FOnTitleChange: TOnTitleChange;
      FOnTooltip: TOnTooltip;
      FOnStatusMessage: TOnStatusMessage;
      FOnConsoleMessage: TOnConsoleMessage;
      FOnBeforeDownload: TOnBeforeDownload;
      FOnDownloadUpdated: TOnDownloadUpdated;
      FOnRequestGeolocationPermission: TOnRequestGeolocationPermission;
      FOnCancelGeolocationPermission: TOnCancelGeolocationPermission;
      FOnJsdialog: TOnJsdialog;

      FOnBeforeUnloadDialog: TOnBeforeUnloadDialog;
      FOnResetDialogState: TOnResetDialogState;
      FOnBeforePopup: TOnBeforePopup;
      FOnAfterCreated: TOnAfterCreated;
      FOnBeforeClose: TOnBeforeClose;
      FOnRunModal: TOnRunModal;
      FOnClose: TOnClose;
      FOnBeforeResourceLoad: TOnBeforeResourceLoad;
      FOnGetResourceHandler: TOnGetResourceHandler;
      FOnResourceRedirect: TOnResourceRedirect;
      FOnGetAuthCredentials: TOnGetAuthCredentials;
      FOnQuotaRequest: TOnQuotaRequest;
      FOnGetCookieManager: TOnGetCookieManager;
      FOnProtocolExecution: TOnProtocolExecution;

      FOnBeforePluginLoad: TOnBeforePluginLoad;

      FOnFileDialog: TOnFileDialog;

      FOptions: TChromiumOptions;
      FUserStyleSheetLocation: ustring;
      FDefaultEncoding: ustring;
      FFontOptions: TChromiumFontOptions;

      procedure GetSettings(var settings: TCefBrowserSettings);
      procedure CreateBrowser;
    protected
      procedure CreateWnd; override;
      procedure WMPaint(var Msg : TLMPaint); message LM_PAINT;
      {$IFDEF WINDOWS}
      procedure WndProc(var Message : TLMessage); override;
      procedure Resize; override;
      {$ENDIF}
    protected
      function doOnProcessMessageReceived(const Browser: ICefBrowser;
        sourceProcess: TCefProcessId; const Message: ICefProcessMessage): Boolean; virtual;

      procedure doOnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame); virtual;
      procedure doOnLoadEnd(const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer); virtual;
      procedure doOnLoadError(const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: Integer;
        const errorText, failedUrl: ustring); virtual;
      procedure doOnRenderProcessTerminated(const Browser: ICefBrowser; Status: TCefTerminationStatus); virtual;
      procedure doOnPluginCrashed(const Browser: ICefBrowser; const pluginPath: ustring); virtual;

      procedure doOnTakeFocus(const Browser: ICefBrowser; next: Boolean); virtual;
      function doOnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean; virtual;
      procedure doOnGotFocus(const Browser: ICefBrowser); virtual;

      procedure doOnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
        const params: ICefContextMenuParams; const model: ICefMenuModel); virtual;
      function doOnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
        const params: ICefContextMenuParams; commandId: Integer;
        eventFlags: TCefEventFlags): Boolean; virtual;
      procedure doOnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame); virtual;

      function doOnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
        osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; virtual;
      function doOnKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
        osEvent: TCefEventHandle): Boolean; virtual;

      procedure doOnLoadingStateChange(const Browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;
      procedure doOnAddressChange(const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring); virtual;
      procedure doOnTitleChange(const Browser: ICefBrowser; const title: ustring); virtual;
      function doOnTooltip(const Browser: ICefBrowser; var atext: ustring): Boolean; virtual;
      procedure doOnStatusMessage(const Browser: ICefBrowser; const value: ustring); virtual;
      function doOnConsoleMessage(const Browser: ICefBrowser; const Message, Source: ustring; line: Integer): Boolean; virtual;

      procedure doOnBeforeDownload(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
        const suggestedName: ustring; const callback: ICefBeforeDownloadCallback); virtual;
      procedure doOnDownloadUpdated(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
          const callback: ICefDownloadItemCallback); virtual;

      procedure doOnRequestGeolocationPermission(const Browser: ICefBrowser;
        const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback); virtual;
      procedure doOnCancelGeolocationPermission(const Browser: ICefBrowser;
        const requestingUrl: ustring; requestId: Integer); virtual;

      function doOnJsdialog(const Browser: ICefBrowser; const originUrl, acceptLang: ustring;
        dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
        callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
      function doOnBeforeUnloadDialog(const Browser: ICefBrowser;
        const messageText: ustring; isReload: Boolean;
        const callback: ICefJsDialogCallback): Boolean; virtual;
      procedure doOnResetDialogState(const Browser: ICefBrowser); virtual;

      function doOnBeforePopup(const Browser: ICefBrowser;
        const Frame: ICefFrame; const targetUrl, targetFrameName: ustring;
        var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
        var client: ICefClient; var settings: TCefBrowserSettings;
        var noJavascriptAccess: Boolean): Boolean; virtual;
      procedure doOnAfterCreated(const Browser: ICefBrowser); virtual;
      procedure doOnBeforeClose(const Browser: ICefBrowser); virtual;
      function doOnRunModal(const Browser: ICefBrowser): Boolean; virtual;
      function doOnClose(const Browser: ICefBrowser): Boolean; virtual;

      function doOnBeforeResourceLoad(const Browser: ICefBrowser; const Frame: ICefFrame;
        const request: ICefRequest): Boolean; virtual;
      function doOnGetResourceHandler(const Browser: ICefBrowser; const Frame: ICefFrame;
        const request: ICefRequest): ICefResourceHandler; virtual;
      procedure doOnResourceRedirect(const Browser: ICefBrowser; const Frame: ICefFrame;
        const oldUrl: ustring; var newUrl: ustring); virtual;
      function doOnGetAuthCredentials(const Browser: ICefBrowser; const Frame: ICefFrame;
        isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
        const callback: ICefAuthCallback): Boolean; virtual;
      function doOnQuotaRequest(const Browser: ICefBrowser; const originUrl: ustring;
        newSize: Int64; const callback: ICefQuotaCallback): Boolean; virtual;
      function doOnGetCookieManager(const Browser: ICefBrowser;
        const mainUrl: ustring): ICefCookieManager; virtual;
      procedure doOnProtocolExecution(const Browser: ICefBrowser;

        const url: ustring; out allowOsExecution: Boolean); virtual;

      function doOnBeforePluginLoad(const Browser: ICefBrowser; const url,
        policyUrl: ustring; const info: ICefWebPluginInfo): Boolean; virtual;

      function doOnFileDialog(const Browser: ICefBrowser; mode: TCefFileDialogMode;
        const title, defaultFileName: ustring; acceptTypes: TStrings;
        const callback: ICefFileDialogCallback): Boolean;

      function doOnGetRootScreenRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
      function doOnGetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
      function doOnGetScreenPoint(const Browser: ICefBrowser; viewX, viewY: Integer;
        screenX, screenY: PInteger): Boolean;
      procedure doOnPopupShow(const Browser: ICefBrowser; doshow: Boolean);
      procedure doOnPopupSize(const Browser: ICefBrowser; const rect: PCefRect);
      procedure doOnPaint(const Browser: ICefBrowser; kind: TCefPaintElementType;
        dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray;
        const buffer: Pointer; awidth, aheight: Integer);
      procedure doOnCursorChange(const Browser: ICefBrowser; acursor: TCefCursorHandle);

      property OnProcessMessageReceived: TOnProcessMessageReceived read FOnProcessMessageReceived write FOnProcessMessageReceived;
      property OnLoadStart: TOnLoadStart read FOnLoadStart write FOnLoadStart;
      property OnLoadEnd: TOnLoadEnd read FOnLoadEnd write FOnLoadEnd;
      property OnLoadError: TOnLoadError read FOnLoadError write FOnLoadError;
      property OnRenderProcessTerminated: TOnRenderProcessTerminated read FOnRenderProcessTerminated write FOnRenderProcessTerminated;
      property OnPluginCrashed: TOnPluginCrashed read FOnPluginCrashed write FOnPluginCrashed;

      property OnTakeFocus: TOnTakeFocus read FOnTakeFocus write FOnTakeFocus;
      property OnSetFocus: TOnSetFocus read FOnSetFocus write FOnSetFocus;
      property OnGotFocus: TOnGotFocus read FOnGotFocus write FOnGotFocus;
      property OnBeforeContextMenu: TOnBeforeContextMenu read FOnBeforeContextMenu write FOnBeforeContextMenu;
      property OnContextMenuCommand: TOnContextMenuCommand read FOnContextMenuCommand write FOnContextMenuCommand;
      property OnContextMenuDismissed: TOnContextMenuDismissed read FOnContextMenuDismissed write FOnContextMenuDismissed;
      property OnPreKeyEvent: TOnPreKeyEvent read FOnPreKeyEvent write FOnPreKeyEvent;
      property OnKeyEvent: TOnKeyEvent read FOnKeyEvent write FOnKeyEvent;
      property OnLoadingStateChange: TOnLoadingStateChange read FOnLoadingStateChange write FOnLoadingStateChange;

      property OnAddressChange: TOnAddressChange read FOnAddressChange write FOnAddressChange;
      property OnTitleChange: TOnTitleChange read FOnTitleChange write FOnTitleChange;
      property OnTooltip: TOnTooltip read FOnTooltip write FOnTooltip;
      property OnStatusMessage: TOnStatusMessage read FOnStatusMessage write FOnStatusMessage;
      property OnConsoleMessage: TOnConsoleMessage read FOnConsoleMessage write FOnConsoleMessage;
      property OnBeforeDownload: TOnBeforeDownload read FOnBeforeDownload write FOnBeforeDownload;
      property OnDownloadUpdated: TOnDownloadUpdated read FOnDownloadUpdated write FOnDownloadUpdated;
      property OnRequestGeolocationPermission: TOnRequestGeolocationPermission read FOnRequestGeolocationPermission write FOnRequestGeolocationPermission;
      property OnCancelGeolocationPermission: TOnCancelGeolocationPermission read FOnCancelGeolocationPermission write FOnCancelGeolocationPermission;
      property OnJsdialog: TOnJsdialog read FOnJsdialog write FOnJsdialog;

      property OnBeforeUnloadDialog: TOnBeforeUnloadDialog read FOnBeforeUnloadDialog write FOnBeforeUnloadDialog;
      property OnResetDialogState: TOnResetDialogState read FOnResetDialogState write FOnResetDialogState;
      property OnBeforePopup: TOnBeforePopup read FOnBeforePopup write FOnBeforePopup;
      property OnAfterCreated: TOnAfterCreated read FOnAfterCreated write FOnAfterCreated;
      property OnBeforeClose: TOnBeforeClose read FOnBeforeClose write FOnBeforeClose;
      property OnRunModal: TOnRunModal read FOnRunModal write FOnRunModal;
      property OnClose: TOnClose read FOnClose write FOnClose;
      property OnBeforeResourceLoad: TOnBeforeResourceLoad read FOnBeforeResourceLoad write FOnBeforeResourceLoad;
      property OnGetResourceHandler: TOnGetResourceHandler read FOnGetResourceHandler write FOnGetResourceHandler;
      property OnResourceRedirect: TOnResourceRedirect read FOnResourceRedirect write FOnResourceRedirect;
      property OnGetAuthCredentials: TOnGetAuthCredentials read FOnGetAuthCredentials write FOnGetAuthCredentials;
      property OnQuotaRequest: TOnQuotaRequest read FOnQuotaRequest write FOnQuotaRequest;
      property OnGetCookieManager: TOnGetCookieManager read FOnGetCookieManager write FOnGetCookieManager;
      property OnProtocolExecution: TOnProtocolExecution read FOnProtocolExecution write FOnProtocolExecution;

      property OnBeforePluginLoad: TOnBeforePluginLoad read FOnBeforePluginLoad write FOnBeforePluginLoad;

      property OnFileDialog: TOnFileDialog read FOnFileDialog write FOnFileDialog;

      property DefaultUrl: ustring read FDefaultUrl write FDefaultUrl;
      property Options: TChromiumOptions read FOptions write FOptions;
      property FontOptions: TChromiumFontOptions read FFontOptions;
      property DefaultEncoding: ustring read FDefaultEncoding write FDefaultEncoding;
      property UserStyleSheetLocation: ustring read FUserStyleSheetLocation write FUserStyleSheetLocation;
      property BrowserId: Integer read FBrowserId;
      property Browser: ICefBrowser read FBrowser;
    public
      constructor Create(TheOwner : TComponent); override;
      destructor Destroy; override;
      procedure Load(const url: ustring);
  end;

  TChromium = class(TCustomChromium)
    public
      property BrowserId;
      property Browser;
    published
      property Color;
      property Constraints;
      property TabStop;
      property Align;
      property Anchors;
      property DefaultUrl;
      property TabOrder;
      property Visible;

      property OnProcessMessageReceived;
      property OnLoadStart;
      property OnLoadEnd;
      property OnLoadError;
      property OnRenderProcessTerminated;
      property OnPluginCrashed;

      property OnTakeFocus;
      property OnSetFocus;
      property OnGotFocus;
      property OnBeforeContextMenu;
      property OnContextMenuCommand;
      property OnContextMenuDismissed;
      property OnPreKeyEvent;
      property OnKeyEvent;
      property OnLoadingStateChange;

      property OnAddressChange;
      property OnTitleChange;
      property OnTooltip;
      property OnStatusMessage;
      property OnConsoleMessage;
      property OnBeforeDownload;
      property OnDownloadUpdated;
      property OnRequestGeolocationPermission;
      property OnCancelGeolocationPermission;
      property OnJsdialog;

      property OnBeforeUnloadDialog;
      property OnResetDialogState;
      property OnBeforePopup;
      property OnAfterCreated;
      property OnBeforeClose;
      property OnRunModal;
      property OnClose;
      property OnBeforeResourceLoad;
      property OnGetResourceHandler;
      property OnResourceRedirect;
      property OnGetAuthCredentials;
      property OnGetCookieManager;
      property OnProtocolExecution;

      property OnFileDialog;


      property Options;
      property FontOptions;
      property DefaultEncoding;
      property UserStyleSheetLocation;
  end;

procedure Register;

Implementation
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
Uses ExtCtrls;
Var
  CefInstances : Integer = 0;
  Timer        : TTimer;
  Looping : Boolean = False;
{$ENDIF}

Type

  { TLCLClientHandler }

  TLCLClientHandler = class(TCustomClientHandler)
  private
    class procedure OnTimer(Sender : TObject);
  public
    constructor Create(const crm: IChromiumEvents); override;
    procedure Cleanup;
    procedure StartTimer;
  end;

  TWSChromiumControl = class(TWSWinControl)
  published
    class function CreateHandle(const AWinControl: TWinControl;
                                const AParams: TCreateParams): HWND; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
  end;

procedure Register;
begin
  RegisterComponents('Chromium',[TChromium]);
end;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
class procedure TLCLClientHandler.OnTimer(Sender : TObject);
begin
  If Looping then Exit;
  If CefInstances > 0 then
  begin
    Looping := True;
    try
      CefDoMessageLoopWork;
    finally
      Looping := False;
    end;
  end;
end;
{$ENDIF}

constructor TLCLClientHandler.Create(const crm : IChromiumEvents);
begin
  inherited Create(crm);

  {$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  If not assigned(Timer) then
  begin
    Timer := TTimer.Create(nil);
    Timer.Interval := 15;
    Timer.Enabled := false;
    Timer.OnTimer := @OnTimer;

    Debugln('Timer created.');
  end;

  InterLockedIncrement(CefInstances);
  {$ENDIF}

  Debugln('ClientHandler instances: ', IntToStr(CefInstances));
end;

procedure TLCLClientHandler.Cleanup;
begin
  { TODO : Check, why Destroy; override never gets called }
  Debugln('LCLClientHandler.Cleanup');

  {$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  InterLockedDecrement(CefInstances);

  If CefInstances = 0 then
  begin
    Timer.Enabled := false;

    FreeAndNil(Timer);

    Debugln('Timer cleaned.');
  end;
  {$ENDIF}

  // inherited;
end;

procedure TLCLClientHandler.StartTimer;
begin
  Assert(Assigned(Timer), 'Timer must be assigned...');

  Timer.Enabled := true;
end;

{ TCustomChromium }

procedure TCustomChromium.GetSettings(var settings : TCefBrowserSettings);
begin
  Assert(settings.size >= SizeOf(settings));
  settings.standard_font_family := CefString(FFontOptions.StandardFontFamily);
  settings.fixed_font_family := CefString(FFontOptions.FixedFontFamily);
  settings.serif_font_family := CefString(FFontOptions.SerifFontFamily);
  settings.sans_serif_font_family := CefString(FFontOptions.SansSerifFontFamily);
  settings.cursive_font_family := CefString(FFontOptions.CursiveFontFamily);
  settings.fantasy_font_family := CefString(FFontOptions.FantasyFontFamily);
  settings.default_font_size := FFontOptions.DefaultFontSize;
  settings.default_fixed_font_size := FFontOptions.DefaultFixedFontSize;
  settings.minimum_font_size := FFontOptions.MinimumFontSize;
  settings.minimum_logical_font_size := FFontOptions.MinimumLogicalFontSize;
  settings.remote_fonts := FFontOptions.RemoteFonts;
  settings.default_encoding := CefString(DefaultEncoding);
  settings.user_style_sheet_location := CefString(UserStyleSheetLocation);

  settings.javascript := FOptions.Javascript;
  settings.javascript_open_windows := FOptions.JavascriptOpenWindows;
  settings.javascript_close_windows := FOptions.JavascriptCloseWindows;
  settings.javascript_access_clipboard := FOptions.JavascriptAccessClipboard;
  settings.javascript_dom_paste := FOptions.JavascriptDomPaste;
  settings.caret_browsing := FOptions.CaretBrowsing;
  settings.java := FOptions.Java;
  settings.plugins := FOptions.Plugins;
  settings.universal_access_from_file_urls := FOptions.UniversalAccessFromFileUrls;
  settings.file_access_from_file_urls := FOptions.FileAccessFromFileUrls;
  settings.web_security := FOptions.WebSecurity;
  settings.image_loading := FOptions.ImageLoading;
  settings.image_shrink_standalone_to_fit := FOptions.ImageShrinkStandaloneToFit;
  settings.text_area_resize := FOptions.TextAreaResize;
  settings.tab_to_links := FOptions.TabToLinks;
  settings.author_and_user_styles := FOptions.AuthorAndUserStyles;
  settings.local_storage := FOptions.LocalStorage;
  settings.databases := FOptions.Databases;
  settings.application_cache := FOptions.ApplicationCache;
  settings.webgl := FOptions.Webgl;
  settings.accelerated_compositing := FOptions.AcceleratedCompositing;
end;

procedure TCustomChromium.CreateWnd;
begin
  inherited CreateWnd;

  CreateBrowser;
end;

procedure TCustomChromium.WMPaint(var Msg : TLMPaint);
begin
  Include(FControlState, csCustomPaint);
  inherited WMPaint(Msg);

  If (csDesigning in ComponentState) and (FCanvas<>nil) then
  begin
    With FCanvas do
    begin
      If Msg.DC <> 0 then Handle := Msg.DC;

      Brush.Color := clLtGray;
      Pen.Color   := clRed;
      Rectangle(0,0,Self.Width,Self.Height);
      MoveTo(0,0);
      LineTo(Self.Width,Self.Height);
      MoveTo(0,Self.Height);
      LineTo(Self.Width,0);

      If Msg.DC <> 0 then Handle := 0;
    end;
  end;

  Exclude(FControlState, csCustomPaint);
end;

{$IFDEF WINDOWS}
procedure TCustomChromium.WndProc(var Message : TLMessage);
begin
  Case Message.Msg of
    WM_SETFOCUS:
      begin
        If (FBrowser <> nil) and (FBrowser.Host.WindowHandle <> 0) then
          PostMessage(FBrowser.Host.WindowHandle, WM_SETFOCUS, Message.WParam, 0);

        inherited WndProc(Message);
      end;
    WM_ERASEBKGND:
      If (csDesigning in ComponentState) or (FBrowser = nil) then inherited WndProc(Message);
    {$IFNDEF CPU64}
    {$WARNING temporary fix}
    CM_WANTSPECIALKEY:
      If not (TWMKey(Message).CharCode in [VK_LEFT .. VK_DOWN]) then Message.Result := 1
      Else inherited WndProc(Message);
    {$ENDIF}
    WM_GETDLGCODE:
      Message.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
  Else
    inherited WndProc(Message);
  end;
end;

procedure TCustomChromium.Resize;
Var
  Brow : ICefBrowser;
  Rect : TRect;
  Hand : THandle;
begin
  inherited Resize;

  If not (csDesigning in ComponentState) then
  begin
    Brow := FBrowser;

    If (Brow <> nil) and (Brow.Host.WindowHandle <> INVALID_HANDLE_VALUE) then
    begin
      Rect := GetClientRect;
      Hand := BeginDeferWindowPos(1);
      try
        Hand := DeferWindowPos(Hand, Browser.Host.WindowHandle, 0, Rect.Left, Rect.Top,
                                 Rect.Right - Rect.Left, Rect.Bottom - Rect.Top, SWP_NOZORDER);
      finally
        EndDeferWindowPos(Hand);
      end;
    end;
  end;
end;
{$ENDIF}

procedure TCustomChromium.CreateBrowser;
Var
  info: TCefWindowInfo;
  settings: TCefBrowserSettings;

  {$IFDEF WINDOWS}
  rect : TRect;
  {$ENDIF}
begin
  If not (csDesigning in ComponentState) then
  begin
    FillChar(info, SizeOf(info), 0);

    {$IFDEF WINDOWS}
      rect := GetClientRect;

      info.style := WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TABSTOP;
      info.parent_window := Handle;
      info.x := rect.Left;
      info.y := rect.Top;
      info.width := rect.Right - rect.Left;
      info.height := rect.Bottom - rect.Top;
    {$ENDIF}
    {$IFDEF LINUX}
      info.parent_widget := Pointer(Handle);
    {$ENDIF}

    FillChar(settings, SizeOf(TCefBrowserSettings), 0);
    settings.size := SizeOf(TCefBrowserSettings);
    GetSettings(settings);

{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
    CefBrowserHostCreate(@info, FHandler, FDefaultUrl, @settings);
{$ELSE}
    FBrowser := CefBrowserHostCreateSync(@info, FHandler, '', @settings);
    FBrowserId := FBrowser.Identifier;
{$ENDIF}

    (FHandler as TLCLClientHandler).StartTimer;
    Load(FDefaultUrl);
  end;
end;

constructor TCustomChromium.Create(TheOwner : TComponent);
begin
  inherited;

  ControlStyle := ControlStyle - [csAcceptsControls];

  If not (csDesigning in ComponentState) then
  begin
    FHandler := TLCLClientHandler.Create(Self);
  end
  Else
  begin
    FCanvas := TControlCanvas.Create;
    TControlCanvas(FCanvas).Control := Self;
  end;

  FOptions := TChromiumOptions.Create;
  FFontOptions := TChromiumFontOptions.Create;

  FUserStyleSheetLocation := '';
  FDefaultEncoding := '';
  FBrowserId := 0;
  FBrowser := nil;
end;

destructor TCustomChromium.Destroy;
begin
  Debugln('CustomChromium.Destroy');

  FreeAndNil(FCanvas);

  If FBrowser <> nil then
  begin
    FBrowser.StopLoad;
    FBrowser.Host.ParentWindowWillClose;
  end;

  If FHandler <> nil then
  begin
    (FHandler as TLCLClientHandler).Cleanup;
    (FHandler as ICefClientHandler).Disconnect;
  end;

  FHandler := nil;
  FBrowser := nil;
  FFontOptions.Free;
  FOptions.Free;

  inherited;
end;

procedure TCustomChromium.Load(const url : ustring);
Var
  Frame : ICefFrame;
begin
  If FBrowser <> nil then
  begin
    Frame := FBrowser.MainFrame;
    If Frame <> nil then Frame.LoadUrl(url);
  end;
end;

function TCustomChromium.doOnClose(const Browser: ICefBrowser): Boolean;
begin
  Result := False;
  If Assigned(FOnClose) then FOnClose(Self, Browser, Result);
end;

procedure TCustomChromium.doOnAddressChange(const Browser: ICefBrowser;
  const Frame: ICefFrame; const url: ustring);
begin
  If Assigned(FOnAddressChange) then FOnAddressChange(Self, Browser, Frame, url);
end;

procedure TCustomChromium.doOnAfterCreated(const Browser: ICefBrowser);
begin
  If Assigned(FOnAfterCreated) then FOnAfterCreated(Self, Browser);
end;

procedure TCustomChromium.doOnBeforeClose(const Browser: ICefBrowser);
begin
  If Assigned(FOnBeforeClose) then FOnBeforeClose(Self, Browser);
end;

procedure TCustomChromium.doOnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  If Assigned(FOnBeforeContextMenu) then
    FOnBeforeContextMenu(Self, Browser, Frame, params, model);
end;

procedure TCustomChromium.doOnBeforeDownload(const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
begin
  if Assigned(FOnBeforeDownload) then
    FOnBeforeDownload(Self, Browser, downloadItem, suggestedName, callback);
end;

function TCustomChromium.doOnBeforePluginLoad(const Browser: ICefBrowser;
  const url, policyUrl: ustring; const info: ICefWebPluginInfo): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforePluginLoad) then
    FOnBeforePluginLoad(Self, Browser, url, policyUrl, info, Result);
end;

function TCustomChromium.doOnBeforePopup(const Browser: ICefBrowser;
  const Frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforePopup) then
    FOnBeforePopup(Self, Browser, Frame, targetUrl, targetFrameName, popupFeatures,
      windowInfo, client, settings, noJavascriptAccess, Result);
end;

function TCustomChromium.doOnBeforeResourceLoad(const Browser: ICefBrowser;
  const Frame: ICefFrame; const request: ICefRequest): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforeResourceLoad) then
    FOnBeforeResourceLoad(Self, Browser, Frame, request, Result);
end;

function TCustomChromium.doOnBeforeUnloadDialog(const Browser: ICefBrowser;
  const messageText: ustring; isReload: Boolean;
  const callback: ICefJsDialogCallback): Boolean;
begin
  Result := False;
  If Assigned(FOnBeforeUnloadDialog) then
    FOnBeforeUnloadDialog(Self, Browser, messageText, isReload, callback, Result);
end;

procedure TCustomChromium.doOnCancelGeolocationPermission(
  const Browser: ICefBrowser; const requestingUrl: ustring; requestId: Integer);
begin
  If Assigned(FOnCancelGeolocationPermission) then
    FOnCancelGeolocationPermission(Self, Browser, requestingUrl, requestId);
end;

function TCustomChromium.doOnConsoleMessage(const Browser: ICefBrowser;
  const Message, Source: ustring; line: Integer): Boolean;
begin
  Result := False;
  If Assigned(FOnConsoleMessage) then
    FOnConsoleMessage(Self, Browser, Message, Source, line, Result);
end;

function TCustomChromium.doOnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer; eventFlags: TCefEventFlags): Boolean;
begin
  Result := False;
  If Assigned(FOnContextMenuCommand) then
    FOnContextMenuCommand(Self, Browser, Frame, params, commandId, eventFlags, Result);
end;

procedure TCustomChromium.doOnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame);
begin
  If Assigned(FOnContextMenuDismissed) then FOnContextMenuDismissed(Self, Browser, Frame);
end;

procedure TCustomChromium.doOnCursorChange(const Browser: ICefBrowser; acursor: TCefCursorHandle);
begin

end;

procedure TCustomChromium.doOnDownloadUpdated(const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const callback: ICefDownloadItemCallback);
begin
  If Assigned(FOnDownloadUpdated) then FOnDownloadUpdated(Self, Browser, downloadItem, callback);
end;

function TCustomChromium.doOnFileDialog(const Browser: ICefBrowser; mode: TCefFileDialogMode;
  const title, defaultFileName: ustring; acceptTypes: TStrings;
  const callback: ICefFileDialogCallback): Boolean;
begin
  Result := False;
  If Assigned(FOnFileDialog) then
    FOnFileDialog(Self, Browser, mode, title, defaultFileName, acceptTypes, callback, Result);
end;

function TCustomChromium.doOnGetAuthCredentials(const Browser: ICefBrowser; const Frame: ICefFrame;
  isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
  const callback: ICefAuthCallback): Boolean;
begin
  Result := False;
  If Assigned(FOnGetAuthCredentials) then
    FOnGetAuthCredentials(Self, Browser, Frame, isProxy, host,
      port, realm, scheme, callback, Result);
end;

function TCustomChromium.doOnGetCookieManager(const Browser: ICefBrowser;
  const mainUrl: ustring): ICefCookieManager;
begin
  If Assigned(FOnGetCookieManager) then FOnGetCookieManager(Self, Browser, mainUrl, Result)
  Else Result := nil;
end;

function TCustomChromium.doOnGetResourceHandler(const Browser: ICefBrowser;
  const Frame: ICefFrame; const request: ICefRequest): ICefResourceHandler;
begin
  If Assigned(FOnGetResourceHandler) then
    FOnGetResourceHandler(Self, Browser, Frame, request, Result)
  Else Result := nil;
end;

function TCustomChromium.doOnGetRootScreenRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := False;
end;

function TCustomChromium.doOnGetScreenPoint(const Browser: ICefBrowser; viewX,
  viewY: Integer; screenX, screenY: PInteger): Boolean;
begin
  Result := False;
end;

function TCustomChromium.doOnGetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := False;
end;

procedure TCustomChromium.doOnGotFocus(const Browser: ICefBrowser);
begin
  If Assigned(FOnGotFocus) then FOnGotFocus(Self, Browser)
end;

function TCustomChromium.doOnJsdialog(const Browser: ICefBrowser;
  const originUrl, acceptLang: ustring; dialogType: TCefJsDialogType;
  const messageText, defaultPromptText: ustring; callback: ICefJsDialogCallback;
  out suppressMessage: Boolean): Boolean;
begin
  Result := False;
  If Assigned(FOnJsdialog) then
    FOnJsdialog(Self, Browser, originUrl, acceptLang, dialogType,
      messageText, defaultPromptText, callback, suppressMessage, Result);
end;

function TCustomChromium.doOnKeyEvent(const Browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle): Boolean;
begin
  Result := False;
  If Assigned(FOnKeyEvent) then FOnKeyEvent(Self, Browser, event, osEvent, Result);
end;

procedure TCustomChromium.doOnLoadEnd(const Browser: ICefBrowser;
  const Frame: ICefFrame; httpStatusCode: Integer);
begin
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, Browser, Frame, httpStatusCode);
end;

procedure TCustomChromium.doOnLoadError(const Browser: ICefBrowser;
  const Frame: ICefFrame; errorCode: Integer; const errorText,
  failedUrl: ustring);
begin
  If Assigned(FOnLoadError) then
    FOnLoadError(Self, Browser, Frame, errorCode, errorText, failedUrl);
end;

procedure TCustomChromium.doOnLoadingStateChange(const Browser: ICefBrowser;
  isLoading, canGoBack, canGoForward: Boolean);
begin
  If Assigned(FOnLoadingStateChange) then
    FOnLoadingStateChange(Self, Browser, isLoading, canGoBack, canGoForward);
end;

procedure TCustomChromium.doOnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame);
begin
  If Assigned(FOnLoadStart) then FOnLoadStart(Self, Browser, Frame);
end;

procedure TCustomChromium.doOnPaint(const Browser: ICefBrowser; kind: TCefPaintElementType;
  dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray; const buffer: Pointer; awidth, aheight: Integer);
begin

end;

procedure TCustomChromium.doOnPluginCrashed(const Browser: ICefBrowser;
  const pluginPath: ustring);
begin
  If Assigned(FOnPluginCrashed) then
    FOnPluginCrashed(Self, Browser, pluginPath);
end;

procedure TCustomChromium.doOnPopupShow(const Browser: ICefBrowser; doshow: Boolean);
begin

end;

procedure TCustomChromium.doOnPopupSize(const Browser: ICefBrowser; const rect: PCefRect);
begin

end;

function TCustomChromium.doOnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
  osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
begin
  Result := False;
  If Assigned(FOnPreKeyEvent) then
    FOnPreKeyEvent(Self, Browser, event, osEvent, isKeyboardShortcut, Result);
end;

function TCustomChromium.doOnProcessMessageReceived(const Browser: ICefBrowser;
  sourceProcess: TCefProcessId; const Message: ICefProcessMessage): Boolean;
begin
  Result := False;
  If Assigned(FOnProcessMessageReceived) then
    FOnProcessMessageReceived(Self, Browser, sourceProcess, Message, Result);
end;

procedure TCustomChromium.doOnProtocolExecution(const Browser: ICefBrowser;
  const url: ustring; out allowOsExecution: Boolean);
begin
  If Assigned(FOnProtocolExecution) then FOnProtocolExecution(Self, Browser, url, allowOsExecution);
end;

function TCustomChromium.doOnQuotaRequest(const Browser: ICefBrowser; const originUrl: ustring;
  newSize: Int64; const callback: ICefQuotaCallback): Boolean;
begin
  Result := False;
  If Assigned(FOnQuotaRequest) then
    FOnQuotaRequest(Self, Browser, originUrl, newSize, callback, Result);
end;

procedure TCustomChromium.doOnRenderProcessTerminated(const Browser: ICefBrowser;
  Status: TCefTerminationStatus);
begin
  If Assigned(FOnRenderProcessTerminated) then FOnRenderProcessTerminated(Self, Browser, Status);
end;

procedure TCustomChromium.doOnRequestGeolocationPermission(
  const Browser: ICefBrowser; const requestingUrl: ustring; requestId: Integer;
  const callback: ICefGeolocationCallback);
begin
  If Assigned(FOnRequestGeolocationPermission) then
    FOnRequestGeolocationPermission(Self, Browser, requestingUrl, requestId, callback);
end;

procedure TCustomChromium.doOnResetDialogState(const Browser: ICefBrowser);
begin
  If Assigned(FOnResetDialogState) then FOnResetDialogState(Self, Browser);
end;

procedure TCustomChromium.doOnResourceRedirect(const Browser: ICefBrowser;
  const Frame: ICefFrame; const oldUrl: ustring; var newUrl: ustring);
begin
  If Assigned(FOnResourceRedirect) then FOnResourceRedirect(Self, Browser, Frame, oldUrl, newUrl);
end;

function TCustomChromium.doOnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean;
begin
  Result := False;
  If Assigned(FOnSetFocus) then FOnSetFocus(Self, Browser, Source, Result);
end;

procedure TCustomChromium.doOnStatusMessage(const Browser: ICefBrowser; const value: ustring);
begin
  If Assigned(FOnStatusMessage) then FOnStatusMessage(Self, Browser, value);
end;

procedure TCustomChromium.doOnTakeFocus(const Browser: ICefBrowser; next: Boolean);
begin
  If Assigned(FOnTakeFocus) then FOnTakeFocus(Self, Browser, next);
end;

procedure TCustomChromium.doOnTitleChange(const Browser: ICefBrowser; const title: ustring);
begin
  If Assigned(FOnTitleChange) then FOnTitleChange(Self, Browser, title);
end;

function TCustomChromium.doOnTooltip(const Browser: ICefBrowser; var atext: ustring): Boolean;
begin
  Result := False;
  If Assigned(FOnTooltip) then FOnTooltip(Self, Browser, atext, Result);
end;

function TCustomChromium.doOnRunModal(const Browser: ICefBrowser): Boolean;
begin
  Result := False;
  If Assigned(FOnRunModal) then FOnRunModal(Self, Browser, Result);
end;

{ TWSChromiumControl }

class function TWSChromiumControl.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
Var
  ChromiumControl: TCustomChromium;

  {$IFDEF LCLGTK2}
  NewWidget : PGtkWidget;
  {$ENDIF}
begin
  If csDesigning in AWinControl.ComponentState then begin
    // do not use "inherited CreateHandle", because the LCL changes the hierarchy at run time
    Result := TWSWinControlClass(ClassParent).CreateHandle(AWinControl, AParams);
  end
  Else
  begin
    ChromiumControl := AWinControl as TCustomChromium;

    {$IFDEF WINDOWS}
      Result := TWSWinControlClass(ClassParent).CreateHandle(ChromiumControl, AParams);
    {$ENDIF}
    {$IFDEF LCLGTK2}
      NewWidget := gtk_vbox_new(False, 0);
      Result := HWND(PtrUInt(Pointer(NewWidget)));

      //PGtkObject(NewWidget)^.flags := PGtkObject(NewWidget)^.flags or GTK_CAN_FOCUS;

      TGtk2WidgetSet(WidgetSet).FinishCreateHandle(ChromiumControl, NewWidget, AParams);
    {$ENDIF}
  end;
end;

class procedure TWSChromiumControl.DestroyHandle(const AWinControl: TWinControl);
begin
  Debugln('DestroyHandle');

  // do not use "inherited DestroyHandle", because the LCL changes the hierarchy at run time
  TWSWinControlClass(ClassParent).DestroyHandle(AWinControl);
end;

Initialization
  RegisterWSComponent(TCustomChromium, TWSChromiumControl);
  {$I icon.lrs}

end.
