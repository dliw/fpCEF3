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

Unit cef3osr;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils, fpTimer,
  cef3types, cef3lib, cef3intf, cef3gui;

Type
  TCustomChromiumOSR = class(TComponent, IChromiumEvents)
  private
    FHandler: ICefClient;
    FBrowser: ICefBrowser;
    FBrowserId: Integer;
    FDefaultUrl: ustring;

    { Client }
    FOnProcessMessageReceived: TOnProcessMessageReceived;

    { ContextMenuHandler }
    FOnBeforeContextMenu: TOnBeforeContextMenu;
    FOnContextMenuCommand: TOnContextMenuCommand;
    FOnContextMenuDismissed: TOnContextMenuDismissed;

    { DialogHandler }
    FOnFileDialog: TOnFileDialog;

    { DisplayHandler }
    FOnAddressChange: TOnAddressChange;
    FOnTitleChange: TOnTitleChange;
    FOnTooltip: TOnTooltip;
    FOnStatusMessage: TOnStatusMessage;
    FOnConsoleMessage: TOnConsoleMessage;

    { DownloadHandler }
    FOnBeforeDownload: TOnBeforeDownload;
    FOnDownloadUpdated: TOnDownloadUpdated;

    { DragHandler }
    FOnDragEnter: TOnDragEnter;

    { FocusHandler }
    FOnTakeFocus: TOnTakeFocus;
    FOnSetFocus: TOnSetFocus;
    FOnGotFocus: TOnGotFocus;

    { GeolocationHandler }
    FOnRequestGeolocationPermission: TOnRequestGeolocationPermission;
    FOnCancelGeolocationPermission: TOnCancelGeolocationPermission;

    { JsDialogHandler }
    FOnJsdialog: TOnJsdialog;
    FOnBeforeUnloadDialog: TOnBeforeUnloadDialog;
    FOnResetDialogState: TOnResetDialogState;

    { KeyboardHandler }
    FOnPreKeyEvent: TOnPreKeyEvent;
    FOnKeyEvent: TOnKeyEvent;

    { LiveSpanHandler }
    FOnBeforePopup: TOnBeforePopup;
    FOnAfterCreated: TOnAfterCreated;
    FOnBeforeClose: TOnBeforeClose;
    FOnRunModal: TOnRunModal;
    FOnClose: TOnClose;

    { LoadHandler }
    FOnLoadingStateChange: TOnLoadingStateChange;
    FOnLoadStart: TOnLoadStart;
    FOnLoadEnd: TOnLoadEnd;
    FOnLoadError: TOnLoadError;

    { RenderHandler }
    FOnGetRootScreenRect: TOnGetRootScreenRect;
    FOnGetViewRect: TOnGetViewRect;
    FOnGetScreenPoint: TOnGetScreenPoint;
    FOnGetScreenInfo: TOnGetScreenInfo;
    FOnPopupShow: TOnPopupShow;
    FOnPopupSize: TOnPopupSize;
    FOnPaint: TOnPaint;
    FOnCursorChange: TOnCursorChange;
    FOnScrollOffsetChanged: TOnScrollOffsetChanged;

    { RequestHandler }
    FOnBeforeBrowse: TOnBeforeBrowse;
    FOnBeforeResourceLoad: TOnBeforeResourceLoad;
    FOnGetResourceHandler: TOnGetResourceHandler;
    FOnResourceRedirect: TOnResourceRedirect;
    FOnGetAuthCredentials: TOnGetAuthCredentials;
    FOnQuotaRequest: TOnQuotaRequest;
    FOnGetCookieManager: TOnGetCookieManager;
    FOnProtocolExecution: TOnProtocolExecution;
    FOnCertificateError: TOnCertificateError;
    FOnBeforePluginLoad: TOnBeforePluginLoad;
    FOnPluginCrashed: TOnPluginCrashed;
    FOnRenderProcessTerminated: TOnRenderProcessTerminated;

    FOptions: TChromiumOptions;
    FUserStyleSheetLocation: ustring;
    FDefaultEncoding: ustring;
    FFontOptions: TChromiumFontOptions;

    procedure GetSettings(var settings: TCefBrowserSettings);
    procedure CreateBrowser;
  protected
    procedure Loaded; override;

    { Client }
    function doOnProcessMessageReceived(const Browser: ICefBrowser;
      sourceProcess: TCefProcessId; const Message: ICefProcessMessage): Boolean; virtual;

    { ContextMenuHandler }
    procedure doOnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel); virtual;
    function doOnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean; virtual;
    procedure doOnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame); virtual;

    { DialogHandler }
    function doOnFileDialog(const Browser: ICefBrowser; mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptTypes: TStrings;
      const callback: ICefFileDialogCallback): Boolean;

    { DisplayHandler }
    procedure doOnAddressChange(const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring); virtual;
    procedure doOnTitleChange(const Browser: ICefBrowser; const title: ustring); virtual;
    function doOnTooltip(const Browser: ICefBrowser; var atext: ustring): Boolean; virtual;
    procedure doOnStatusMessage(const Browser: ICefBrowser; const value: ustring); virtual;
    function doOnConsoleMessage(const Browser: ICefBrowser; const Message, Source: ustring; line: Integer): Boolean; virtual;

    { DownloadHandler }
    procedure doOnBeforeDownload(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback); virtual;
    procedure doOnDownloadUpdated(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback); virtual;

    { DragHandler }
    function doOnDragEnter(const Browser: ICefBrowser; const dragData: ICefDragData; mask: TCefDragOperationsMask): Boolean; virtual;

    { FocusHandler }
    procedure doOnTakeFocus(const Browser: ICefBrowser; next: Boolean); virtual;
    function doOnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean; virtual;
    procedure doOnGotFocus(const Browser: ICefBrowser); virtual;

    { GeolocationHandler }
    procedure doOnRequestGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback); virtual;
    procedure doOnCancelGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer); virtual;

    { JsDialogHandler }
    function doOnJsdialog(const Browser: ICefBrowser; const originUrl, acceptLang: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
    function doOnBeforeUnloadDialog(const Browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean; virtual;
    procedure doOnResetDialogState(const Browser: ICefBrowser); virtual;

    { KeyboardHander }
    function doOnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; virtual;
    function doOnKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean; virtual;

    { LiveSpanHandler }
    function doOnBeforePopup(const Browser: ICefBrowser;
      const Frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean): Boolean; virtual;
    procedure doOnAfterCreated(const Browser: ICefBrowser); virtual;
    procedure doOnBeforeClose(const Browser: ICefBrowser); virtual;
    function doOnRunModal(const Browser: ICefBrowser): Boolean; virtual;
    function doOnClose(const Browser: ICefBrowser): Boolean; virtual;

    { LoadHandler }
    procedure doOnLoadingStateChange(const Browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;
    procedure doOnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame); virtual;
    procedure doOnLoadEnd(const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer); virtual;
    procedure doOnLoadError(const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: TCefErrorCode;
      const errorText, failedUrl: ustring); virtual;

    { RenderHandler }
    function doOnGetRootScreenRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
    function doOnGetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
    function doOnGetScreenPoint(const Browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean;
    function doOnGetScreenInfo(const browser: ICefBrowser; var screenInfo: TCefScreenInfo): Boolean;
    procedure doOnPopupShow(const Browser: ICefBrowser; doshow: Boolean);
    procedure doOnPopupSize(const Browser: ICefBrowser; const rect: PCefRect);
    procedure doOnPaint(const Browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: TSize; const dirtyRects: PCefRectArray;
      const buffer: Pointer; awidth, aheight: Integer);
    procedure doOnCursorChange(const Browser: ICefBrowser; acursor: TCefCursorHandle);
    procedure doOnScrollOffsetChanged(const browser: ICefBrowser);

    { RequestHandler }
    function doOnBeforeBrowse(const Browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; isRedirect: Boolean): Boolean; virtual;
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
    function doOnCertificateError(certError: TCefErrorcode; const requestUrl: ustring;
      callback: ICefAllowCertificateErrorCallback): Boolean;
    function doOnBeforePluginLoad(const Browser: ICefBrowser; const url, policyUrl: ustring;
      const info: ICefWebPluginInfo): Boolean; virtual;
    procedure doOnPluginCrashed(const Browser: ICefBrowser; const pluginPath: ustring); virtual;
    procedure doOnRenderProcessTerminated(const Browser: ICefBrowser; Status: TCefTerminationStatus); virtual;

    { Client }
    property OnProcessMessageReceived: TOnProcessMessageReceived read FOnProcessMessageReceived write FOnProcessMessageReceived;

    { ContextMenuHandler }
    property OnBeforeContextMenu: TOnBeforeContextMenu read FOnBeforeContextMenu write FOnBeforeContextMenu;
    property OnContextMenuCommand: TOnContextMenuCommand read FOnContextMenuCommand write FOnContextMenuCommand;
    property OnContextMenuDismissed: TOnContextMenuDismissed read FOnContextMenuDismissed write FOnContextMenuDismissed;

    { DialogHandler }
    property OFileDialog: TOnFileDialog read FOnFileDialog write FOnFileDialog;

    { DisplayHandler }
    property OnAddressChange: TOnAddressChange read FOnAddressChange write FOnAddressChange;
    property OnTitleChange: TOnTitleChange read FOnTitleChange write FOnTitleChange;
    property OnTooltip: TOnTooltip read FOnTooltip write FOnTooltip;
    property OnStatusMessage: TOnStatusMessage read FOnStatusMessage write FOnStatusMessage;
    property OnConsoleMessage: TOnConsoleMessage read FOnConsoleMessage write FOnConsoleMessage;

    { DownloadHandler }
    property OnBeforeDownload: TOnBeforeDownload read FOnBeforeDownload write FOnBeforeDownload;
    property OnDownloadUpdated: TOnDownloadUpdated read FOnDownloadUpdated write FOnDownloadUpdated;

    { DragHandler }
    property OnDragEnter: TOnDragEnter read FOnDragEnter write FOnDragEnter;

    { FocusHandler }
    property OnTakeFocus: TOnTakeFocus read FOnTakeFocus write FOnTakeFocus;
    property OnSetFocus: TOnSetFocus read FOnSetFocus write FOnSetFocus;
    property OnGotFocus: TOnGotFocus read FOnGotFocus write FOnGotFocus;

    { GeolocationHandler }
    property OnRequestGeolocationPermission: TOnRequestGeolocationPermission read FOnRequestGeolocationPermission write FOnRequestGeolocationPermission;
    property OnCancelGeolocationPermission: TOnCancelGeolocationPermission read FOnCancelGeolocationPermission write FOnCancelGeolocationPermission;

    { JsDialogHandler }
    property OnJsdialog: TOnJsdialog read FOnJsdialog write FOnJsdialog;
    property OnBeforeUnloadDialog: TOnBeforeUnloadDialog read FOnBeforeUnloadDialog write FOnBeforeUnloadDialog;
    property OnResetDialogState: TOnResetDialogState read FOnResetDialogState write FOnResetDialogState;

    { KeyboardHandler }
    property OnPreKeyEvent: TOnPreKeyEvent read FOnPreKeyEvent write FOnPreKeyEvent;
    property OnKeyEvent: TOnKeyEvent read FOnKeyEvent write FOnKeyEvent;

    { LiveSpanHandler }
    property OnBeforePopup: TOnBeforePopup read FOnBeforePopup write FOnBeforePopup;
    property OnAfterCreated: TOnAfterCreated read FOnAfterCreated write FOnAfterCreated;
    property OnBeforeClose: TOnBeforeClose read FOnBeforeClose write FOnBeforeClose;
    property OnRunModal: TOnRunModal read FOnRunModal write FOnRunModal;
    property OnClose: TOnClose read FOnClose write FOnClose;

    { LoadHandler }
    property OnLoadingStateChange: TOnLoadingStateChange read FOnLoadingStateChange write FOnLoadingStateChange;
    property OnLoadStart: TOnLoadStart read FOnLoadStart write FOnLoadStart;
    property OnLoadEnd: TOnLoadEnd read FOnLoadEnd write FOnLoadEnd;
    property OnLoadError: TOnLoadError read FOnLoadError write FOnLoadError;

    { RenderHandler }
    property OnGetRootScreenRect: TOnGetRootScreenRect read FOnGetRootScreenRect write FOnGetRootScreenRect;
    property OnGetViewRect: TOnGetViewRect read FOnGetViewRect write FOnGetViewRect;
    property OnGetScreenPoint: TOnGetScreenPoint read FOnGetScreenPoint write FOnGetScreenPoint;
    property OnGetScreenInfo: TOnGetScreenInfo read FOnGetScreenInfo write FOnGetScreenInfo;
    property OnPopupShow: TOnPopupShow read FOnPopupShow write FOnPopupShow;
    property OnPopupSize: TOnPopupSize read FOnPopupSize write FOnPopupSize;
    property OnPaint: TOnPaint read FOnPaint write FOnPaint;
    property OnCursorChange: TOnCursorChange read FOnCursorChange write FOnCursorChange;
    property OnScrollOffsetChanged: TOnScrollOffsetChanged read FOnScrollOffsetChanged write FOnScrollOffsetChanged;

    { RequestHandler }
    property OnBeforeBrowse: TOnBeforeBrowse read FOnBeforeBrowse write FOnBeforeBrowse;
    property OnBeforeResourceLoad: TOnBeforeResourceLoad read FOnBeforeResourceLoad write FOnBeforeResourceLoad;
    property OnGetResourceHandler: TOnGetResourceHandler read FOnGetResourceHandler write FOnGetResourceHandler;
    property OnResourceRedirect: TOnResourceRedirect read FOnResourceRedirect write FOnResourceRedirect;
    property OnGetAuthCredentials: TOnGetAuthCredentials read FOnGetAuthCredentials write FOnGetAuthCredentials;
    property OnQuotaRequest: TOnQuotaRequest read FOnQuotaRequest write FOnQuotaRequest;
    property OnGetCookieManager: TOnGetCookieManager read FOnGetCookieManager write FOnGetCookieManager;
    property OnProtocolExecution: TOnProtocolExecution read FOnProtocolExecution write FOnProtocolExecution;
    property OnCertificateError: TOnCertificateError read FOnCertificateError write FOnCertificateError;
    property OnBeforePluginLoad: TOnBeforePluginLoad read FOnBeforePluginLoad write FOnBeforePluginLoad;
    property OnPluginCrashed: TOnPluginCrashed read FOnPluginCrashed write FOnPluginCrashed;
    property OnRenderProcessTerminated: TOnRenderProcessTerminated read FOnRenderProcessTerminated write FOnRenderProcessTerminated;

    property DefaultUrl: ustring read FDefaultUrl write FDefaultUrl;
    property Options: TChromiumOptions read FOptions write FOptions;
    property FontOptions: TChromiumFontOptions read FFontOptions;
    property DefaultEncoding: ustring read FDefaultEncoding write FDefaultEncoding;
    property UserStyleSheetLocation: ustring read FUserStyleSheetLocation write FUserStyleSheetLocation;
    property BrowserId: Integer read FBrowserId;
    property Browser: ICefBrowser read FBrowser;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(const url: ustring);
  end;

  TChromiumOSR = class(TCustomChromiumOSR)
  public
    property BrowserId;
    property Browser;
  published
    property DefaultUrl;

    property OnProcessMessageReceived;

    property OnBeforeContextMenu;
    property OnContextMenuCommand;
    property OnContextMenuDismissed;

    property OFileDialog;

    property OnAddressChange;
    property OnTitleChange;
    property OnTooltip;
    property OnStatusMessage;
    property OnConsoleMessage;

    property OnBeforeDownload;
    property OnDownloadUpdated;

    property OnDragEnter;

    property OnTakeFocus;
    property OnSetFocus;
    property OnGotFocus;

    property OnRequestGeolocationPermission;
    property OnCancelGeolocationPermission;

    property OnJsdialog;
    property OnBeforeUnloadDialog;
    property OnResetDialogState;

    property OnPreKeyEvent: TOnPreKeyEvent;
    property OnKeyEvent: TOnKeyEvent;

    property OnBeforePopup;
    property OnAfterCreated;
    property OnBeforeClose;
    property OnRunModal;
    property OnClose;

    property OnLoadingStateChange;
    property OnLoadStart;
    property OnLoadEnd;
    property OnLoadError;

    property OnGetRootScreenRect;
    property OnGetViewRect;
    property OnGetScreenPoint;
    property OnGetScreenInfo;
    property OnPopupShow;
    property OnPopupSize;
    property OnPaint;
    property OnCursorChange;
    property OnScrollOffsetChanged;

    property OnBeforeBrowse;
    property OnBeforeResourceLoad;
    property OnGetResourceHandler;
    property OnResourceRedirect;
    property OnGetAuthCredentials;
    property OnQuotaRequest;
    property OnGetCookieManager;
    property OnProtocolExecution;
    property OnCertificateError;
    property OnBeforePluginLoad;
    property OnPluginCrashed;
    property OnRenderProcessTerminated;

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
  Timer        : TFPTimer;
  Looping : Boolean = False;
{$ENDIF}

Type

  { TOSRClientHandler }

  TOSRClientHandler = class(TCustomClientHandler)
  private
    class procedure OnTimer(Sender : TObject);
  public
    constructor Create(const crm: IChromiumEvents); override;
    procedure Cleanup;
    procedure StartTimer;
  end;

procedure Register;
begin
  RegisterComponents('Chromium', [TChromiumOSR]);
end;

class procedure TOSRClientHandler.OnTimer(Sender : TObject);
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

constructor TOSRClientHandler.Create(const crm : IChromiumEvents);
begin
  inherited Create(crm);

  {$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  If not assigned(Timer) then
  begin
    Timer := TFPTimer.Create(nil);
    Timer.Interval := 15;
    Timer.Enabled := False;
    Timer.OnTimer := @OnTimer;

    {$IFDEF DEBUG}
    Debugln('Timer created.');
    {$ENDIF}
  end;

  InterLockedIncrement(CefInstances);
  {$ENDIF}

  {$IFDEF DEBUG}
  Debugln('ClientHandler instances: ', IntToStr(CefInstances));
  {$ENDIF}
end;

procedure TOSRClientHandler.Cleanup;
begin
  { TODO : Check, why Destroy; override never gets called }
  {$IFDEF DEBUG}
  Debugln('LCLClientHandler.Cleanup');
  {$ENDIF}

  {$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  InterLockedDecrement(CefInstances);

  If CefInstances = 0 then
  begin
    Timer.Enabled := False;

    FreeAndNil(Timer);

    {$IFDEF DEBUG}
    Debugln('Timer cleaned.');
    {$ENDIF}
  end;
  {$ENDIF}

  // inherited;
end;

procedure TOSRClientHandler.StartTimer;
begin
  If not Assigned(Timer) then Exit;

  Timer.Enabled := True;
end;

{ TCustomChromiumOSR }

procedure TCustomChromiumOSR.GetSettings(var settings : TCefBrowserSettings);
begin
  If not (settings.size >= SizeOf(settings)) then raise Exception.Create('settings invalid');
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
  settings.default_encoding := CefString(FDefaultEncoding);
  settings.user_style_sheet_location := CefString(FUserStyleSheetLocation);

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

procedure TCustomChromiumOSR.CreateBrowser;
Var
  info: TCefWindowInfo;
  settings: TCefBrowserSettings;
begin
  If not (csDesigning in ComponentState) then
  begin
    FillChar(info, SizeOf(info), 0);
    info.window_rendering_disabled := True;
    // info.transparent_painting := ???;

    FillChar(settings, SizeOf(TCefBrowserSettings), 0);
    settings.size := SizeOf(TCefBrowserSettings);
    GetSettings(settings);

    {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
      CefBrowserHostCreateBrowser(@info, FHandler, FDefaultUrl, @settings, nil);
    {$ELSE}
      FBrowser := CefBrowserHostCreateBrowserSync(@info, FHandler, '', @settings, nil);
      FBrowserId := FBrowser.Identifier;
    {$ENDIF}

    (FHandler as TOSRClientHandler).StartTimer;
  end;
end;


procedure TCustomChromiumOSR.Loaded;
begin
  inherited;

  CreateBrowser;
  // Load(FDefaultUrl);
end;

function TCustomChromiumOSR.doOnProcessMessageReceived(const Browser : ICefBrowser;
  sourceProcess : TCefProcessId; const Message : ICefProcessMessage) : Boolean;
begin
  Result := False;
  if Assigned(FOnProcessMessageReceived) then
    FOnProcessMessageReceived(Self, Browser, sourceProcess, message, Result);
end;

procedure TCustomChromiumOSR.doOnBeforeContextMenu(const Browser : ICefBrowser;
  const Frame : ICefFrame; const params : ICefContextMenuParams; const model : ICefMenuModel);
begin
  If Assigned(FOnBeforeContextMenu) then FOnBeforeContextMenu(Self, Browser, frame, params, model);
end;

function TCustomChromiumOSR.doOnContextMenuCommand(const Browser : ICefBrowser;
  const Frame : ICefFrame; const params : ICefContextMenuParams;
  commandId : Integer; eventFlags : TCefEventFlags) : Boolean;
begin
  Result := False;
  If Assigned(FOnContextMenuCommand) then
    FOnContextMenuCommand(Self, Browser, frame, params, commandId, eventFlags, Result);
end;

procedure TCustomChromiumOSR.doOnContextMenuDismissed(const Browser : ICefBrowser;
  const Frame : ICefFrame);
begin
  If Assigned(FOnContextMenuDismissed) then FOnContextMenuDismissed(Self, Browser, frame);
end;

function TCustomChromiumOSR.doOnFileDialog(const Browser : ICefBrowser;
  mode : TCefFileDialogMode; const title, defaultFileName : ustring;
  acceptTypes : TStrings; const callback : ICefFileDialogCallback) : Boolean;
begin
  Result := False;
  If Assigned(FOnFileDialog) then
    FOnFileDialog(Self, Browser, mode, title, defaultFileName, acceptTypes, callback, Result);
end;

procedure TCustomChromiumOSR.doOnAddressChange(const Browser : ICefBrowser;
  const Frame : ICefFrame; const url : ustring);
begin
  If Assigned(FOnAddressChange) then FOnAddressChange(Self, Browser, frame, url);
end;

procedure TCustomChromiumOSR.doOnTitleChange(const Browser : ICefBrowser; const title : ustring);
begin
  If Assigned(FOnTitleChange) then FOnTitleChange(Self, Browser, title);
end;

function TCustomChromiumOSR.doOnTooltip(const Browser : ICefBrowser; var atext : ustring) : Boolean;
begin
  Result := False;
  If Assigned(FOnTooltip) then FOnTooltip(Self, Browser, atext, Result);
end;

procedure TCustomChromiumOSR.doOnStatusMessage(const Browser : ICefBrowser; const value : ustring);
begin
  If Assigned(FOnStatusMessage) then FOnStatusMessage(Self, Browser, value);
end;

function TCustomChromiumOSR.doOnConsoleMessage(const Browser : ICefBrowser;
  const Message, Source : ustring; line : Integer) : Boolean;
begin
  Result := False;
  If Assigned(FOnConsoleMessage) then FOnConsoleMessage(Self, Browser, message, source, line, Result);
end;

procedure TCustomChromiumOSR.doOnBeforeDownload(const Browser : ICefBrowser;
  const downloadItem : ICefDownloadItem; const suggestedName : ustring;
  const callback : ICefBeforeDownloadCallback);
begin
  If Assigned(FOnBeforeDownload) then
    OnBeforeDownload(Self, Browser, downloadItem, suggestedName, callback);
end;

procedure TCustomChromiumOSR.doOnDownloadUpdated(const Browser : ICefBrowser;
  const downloadItem : ICefDownloadItem;
  const callback : ICefDownloadItemCallback);
begin
  If Assigned(FOnDownloadUpdated) then FOnDownloadUpdated(Self, Browser, downloadItem, callback);
end;

function TCustomChromiumOSR.doOnDragEnter(const Browser : ICefBrowser;
  const dragData : ICefDragData; mask : TCefDragOperationsMask) : Boolean;
begin
  Result := False;
  If Assigned(FOnDragEnter) then FOnDragEnter(Self, Browser, dragData, mask, Result);
end;

procedure TCustomChromiumOSR.doOnTakeFocus(const Browser : ICefBrowser; next : Boolean);
begin
  If Assigned(FOnTakeFocus) then FOnTakeFocus(Self, Browser, next);
end;

function TCustomChromiumOSR.doOnSetFocus(const Browser : ICefBrowser;
  Source : TCefFocusSource) : Boolean;
begin
  Result := False;
  If Assigned(FOnSetFocus) then FOnSetFocus(Self, Browser, source, Result);
end;

procedure TCustomChromiumOSR.doOnGotFocus(const Browser : ICefBrowser);
begin
  If Assigned(FOnGotFocus) then FOnGotFocus(Self, Browser);
end;

procedure TCustomChromiumOSR.doOnRequestGeolocationPermission(const Browser : ICefBrowser;
  const requestingUrl : ustring; requestId : Integer;
  const callback : ICefGeolocationCallback);
begin
  If Assigned(FOnRequestGeolocationPermission) then
    FOnRequestGeolocationPermission(Self, Browser, requestingUrl, requestId, callback);
end;

procedure TCustomChromiumOSR.doOnCancelGeolocationPermission(const Browser : ICefBrowser;
  const requestingUrl : ustring; requestId : Integer);
begin
  If Assigned(FOnCancelGeolocationPermission) then
    FOnCancelGeolocationPermission(Self, Browser, requestingUrl, requestId);
end;

function TCustomChromiumOSR.doOnJsdialog(const Browser : ICefBrowser;
  const originUrl, acceptLang : ustring; dialogType : TCefJsDialogType;
  const messageText, defaultPromptText : ustring;
  callback : ICefJsDialogCallback; out suppressMessage : Boolean) : Boolean;
begin
  Result := False;
  If Assigned(FOnJsdialog) then
    FOnJsdialog(Self, Browser, originUrl, acceptLang, dialogType,
                messageText, defaultPromptText, callback, suppressMessage, Result);
end;

function TCustomChromiumOSR.doOnBeforeUnloadDialog(const Browser : ICefBrowser;
  const messageText : ustring; isReload : Boolean;
  const callback : ICefJsDialogCallback) : Boolean;
begin
  Result := False;
  If Assigned(FOnBeforeUnloadDialog) then
    FOnBeforeUnloadDialog(Self, Browser, messageText, isReload, callback, Result);
end;

procedure TCustomChromiumOSR.doOnResetDialogState(const Browser : ICefBrowser);
begin
  If Assigned(FOnResetDialogState) then FOnResetDialogState(Self, Browser);
end;

function TCustomChromiumOSR.doOnPreKeyEvent(const Browser : ICefBrowser; const event : PCefKeyEvent;
  osEvent : TCefEventHandle; out isKeyboardShortcut : Boolean) : Boolean;
begin
  Result := False;
  If Assigned(FOnPreKeyEvent) then
    FOnPreKeyEvent(Self, Browser, event, osEvent, isKeyboardShortcut, Result);
end;

function TCustomChromiumOSR.doOnKeyEvent(const Browser : ICefBrowser;
  const event : PCefKeyEvent; osEvent : TCefEventHandle) : Boolean;
begin
  Result := False;
  If Assigned(FOnKeyEvent) then FOnKeyEvent(Self, Browser, event, osEvent, Result);
end;

function TCustomChromiumOSR.doOnBeforePopup(const Browser : ICefBrowser;
  const Frame : ICefFrame; const targetUrl, targetFrameName : ustring;
  var popupFeatures : TCefPopupFeatures; var windowInfo : TCefWindowInfo;
  var client : ICefClient; var settings : TCefBrowserSettings;
  var noJavascriptAccess : Boolean) : Boolean;
begin
  Result := False;
  If Assigned(FOnBeforePopup) then
    FOnBeforePopup(Self, Browser, frame, targetUrl, targetFrameName, popupFeatures,
                   windowInfo, client, settings, noJavascriptAccess, Result);
end;

procedure TCustomChromiumOSR.doOnAfterCreated(const Browser : ICefBrowser);
begin
  If Assigned(FOnAfterCreated) then FOnAfterCreated(Self, Browser);
end;

procedure TCustomChromiumOSR.doOnBeforeClose(const Browser : ICefBrowser);
begin
  If Assigned(FOnBeforeClose) then FOnBeforeClose(Self, Browser);
end;

function TCustomChromiumOSR.doOnRunModal(const Browser : ICefBrowser) : Boolean;
begin
  Result := False;
  If Assigned(FOnRunModal) then FOnRunModal(Self, Browser, Result);
end;

function TCustomChromiumOSR.doOnClose(const Browser : ICefBrowser) : Boolean;
begin
  Result := False;
  if Assigned(FOnClose) then FOnClose(Self, Browser, Result);
end;

procedure TCustomChromiumOSR.doOnLoadingStateChange(const Browser : ICefBrowser;
  isLoading, canGoBack, canGoForward : Boolean);
begin
  If Assigned(FOnLoadingStateChange) then
    FOnLoadingStateChange(Self, Browser, isLoading, canGoBack, canGoForward);
end;

procedure TCustomChromiumOSR.doOnLoadStart(const Browser : ICefBrowser; const Frame : ICefFrame);
begin
  If Assigned(FOnLoadStart) then FOnLoadStart(Self, Browser, frame);
end;

procedure TCustomChromiumOSR.doOnLoadEnd(const Browser : ICefBrowser;
  const Frame : ICefFrame; httpStatusCode : Integer);
begin
  If Assigned(FOnLoadEnd) then FOnLoadEnd(Self, Browser, frame, httpStatusCode);
end;

procedure TCustomChromiumOSR.doOnLoadError(const Browser : ICefBrowser;
  const Frame : ICefFrame; errorCode : TCefErrorCode; const errorText, failedUrl : ustring);
begin
  If Assigned(FOnLoadError) then
    FOnLoadError(Self, Browser, frame, errorCode, errorText, failedUrl);
end;

function TCustomChromiumOSR.doOnGetRootScreenRect(const Browser : ICefBrowser;
  rect : PCefRect) : Boolean;
begin
  Result := False;
  If Assigned(FOnGetRootScreenRect) then FOnGetRootScreenRect(Self, Browser, rect, Result);
end;

function TCustomChromiumOSR.doOnGetViewRect(const Browser : ICefBrowser; rect : PCefRect) : Boolean;
begin
  Result := False;
  If Assigned(FOnGetViewRect) then FOnGetViewRect(Self, Browser, rect, Result);
end;

function TCustomChromiumOSR.doOnGetScreenPoint(const Browser : ICefBrowser;
  viewX, viewY : Integer; screenX, screenY : PInteger) : Boolean;
begin
  Result := False;
  If Assigned(FOnGetScreenPoint) then
    FOnGetScreenPoint(Self, Browser, viewX, viewY, screenX, screenY, Result);
end;

function TCustomChromiumOSR.doOnGetScreenInfo(const browser : ICefBrowser;
  var screenInfo : TCefScreenInfo) : Boolean;
begin
  Result := False;
  If Assigned(FOnGetScreenInfo) then FOnGetScreenInfo(Self, Browser, screenInfo, Result);
end;

procedure TCustomChromiumOSR.doOnPopupShow(const Browser : ICefBrowser; doshow : Boolean);
begin
  If Assigned(FOnPopupShow) then FOnPopupShow(Self, Browser, doshow);
end;

procedure TCustomChromiumOSR.doOnPopupSize(const Browser : ICefBrowser; const rect : PCefRect);
begin
  If Assigned(FOnPopupSize) then FOnPopupSize(Self, Browser, rect);
end;

procedure TCustomChromiumOSR.doOnPaint(const Browser : ICefBrowser;
  kind : TCefPaintElementType; dirtyRectsCount : TSize; const dirtyRects : PCefRectArray;
  const buffer : Pointer; awidth, aheight : Integer);
begin
  If Assigned(FOnPaint) then
    FOnPaint(Self, Browser, kind, dirtyRectsCount, dirtyRects, buffer, awidth, aheight);
end;

procedure TCustomChromiumOSR.doOnCursorChange(const Browser : ICefBrowser;
  acursor : TCefCursorHandle);
begin
  If Assigned(FOnCursorChange) then FOnCursorChange(Self, Browser, acursor);
end;

procedure TCustomChromiumOSR.doOnScrollOffsetChanged(const browser : ICefBrowser);
begin
  If Assigned(FOnScrollOffsetChanged) then FOnScrollOffsetChanged(Self, Browser);
end;

function TCustomChromiumOSR.doOnBeforeBrowse(const Browser : ICefBrowser;
  const frame : ICefFrame; const request : ICefRequest; isRedirect : Boolean) : Boolean;
begin
  Result := False;
  If Assigned(FOnBeforeBrowse) then
    FOnBeforeBrowse(Self, Browser, frame, request, isRedirect, Result);
end;

function TCustomChromiumOSR.doOnBeforeResourceLoad(const Browser : ICefBrowser;
  const Frame : ICefFrame; const request : ICefRequest) : Boolean;
begin
  Result := False;
  If Assigned(FOnBeforeResourceLoad) then FOnBeforeResourceLoad(Self, Browser, frame, request, Result);
end;

function TCustomChromiumOSR.doOnGetResourceHandler(const Browser : ICefBrowser;
  const Frame : ICefFrame; const request : ICefRequest) : ICefResourceHandler;
begin
  If Assigned(FOnGetResourceHandler) then FOnGetResourceHandler(Self, Browser, frame, request, Result)
  Else Result := nil;
end;

procedure TCustomChromiumOSR.doOnResourceRedirect(const Browser : ICefBrowser;
  const Frame : ICefFrame; const oldUrl : ustring; var newUrl : ustring);
begin
  If Assigned(FOnResourceRedirect) then FOnResourceRedirect(Self, Browser, frame, oldUrl, newUrl);
end;

function TCustomChromiumOSR.doOnGetAuthCredentials(const Browser : ICefBrowser;
  const Frame : ICefFrame; isProxy : Boolean; const host : ustring;
  port : Integer; const realm, scheme : ustring;
  const callback : ICefAuthCallback) : Boolean;
begin
  Result := False;
  If Assigned(FOnGetAuthCredentials) then
    FOnGetAuthCredentials(Self, Browser, frame, isProxy, host, port, realm, scheme, callback, Result);
end;

function TCustomChromiumOSR.doOnQuotaRequest(const Browser : ICefBrowser;
  const originUrl : ustring; newSize : Int64; const callback : ICefQuotaCallback) : Boolean;
begin
  Result := False;
  If Assigned(FOnQuotaRequest) then
    FOnQuotaRequest(Self, Browser, originUrl, newSize, callback, Result);
end;

function TCustomChromiumOSR.doOnGetCookieManager(const Browser : ICefBrowser;
  const mainUrl : ustring) : ICefCookieManager;
begin
  If Assigned(FOnGetCookieManager) then FOnGetCookieManager(Self, Browser, mainUrl, Result)
  Else Result := nil;
end;

procedure TCustomChromiumOSR.doOnProtocolExecution(const Browser : ICefBrowser;
  const url : ustring; out allowOsExecution : Boolean);
begin
  If Assigned(FOnProtocolExecution) then
    FOnProtocolExecution(Self, Browser, url, allowOsExecution);
end;

function TCustomChromiumOSR.doOnCertificateError(certError : TCefErrorcode;
  const requestUrl : ustring; callback : ICefAllowCertificateErrorCallback) : Boolean;
begin
  Result := False;
  If Assigned(FOnCertificateError) then
    FOnCertificateError(Self, certError, requestUrl, callback, Result);
end;

function TCustomChromiumOSR.doOnBeforePluginLoad(const Browser : ICefBrowser;
  const url, policyUrl : ustring; const info : ICefWebPluginInfo) : Boolean;
begin
  Result := False;
  If Assigned(FOnBeforePluginLoad) then
    FOnBeforePluginLoad(Self, Browser, url, policyUrl, info, Result);
end;

procedure TCustomChromiumOSR.doOnPluginCrashed(const Browser : ICefBrowser;
  const pluginPath : ustring);
begin
  If Assigned(FOnPluginCrashed) then FOnPluginCrashed(Self, Browser, pluginPath);
end;

procedure TCustomChromiumOSR.doOnRenderProcessTerminated(const Browser : ICefBrowser;
  Status : TCefTerminationStatus);
begin
  If Assigned(FOnRenderProcessTerminated) then FOnRenderProcessTerminated(Self, Browser, status);
end;

constructor TCustomChromiumOSR.Create(AOwner : TComponent);
begin
  inherited;

  FDefaultUrl := 'about:blank';

  If not (csDesigning in ComponentState) then
  begin
    FHandler := TOSRClientHandler.Create(Self);

    If not Assigned(FHandler) then raise Exception.Create('FHandler is nil');
  end;

  FOptions := TChromiumOptions.Create;
  FFontOptions := TChromiumFontOptions.Create;

  FUserStyleSheetLocation := '';
  FDefaultEncoding := '';
  FBrowserId := 0;
  FBrowser := nil;
end;

destructor TCustomChromiumOSR.Destroy;
begin
  // FreeAndNil(FCanvas);

  If FBrowser <> nil then
  begin
    FBrowser.StopLoad;
    FBrowser.Host.ParentWindowWillClose;
  end;

  If FHandler <> nil then
  begin
    (FHandler as TOSRClientHandler).Cleanup;
    (FHandler as ICefClientHandler).Disconnect;
  end;

  FHandler := nil;
  FBrowser := nil;
  FFontOptions.Free;
  FOptions.Free;

  inherited;
end;

procedure TCustomChromiumOSR.Load(const url : ustring);
Var Frame : ICefFrame;
begin
  If FBrowser <> nil then
  begin
    Frame := FBrowser.MainFrame;

    If Frame <> nil then
    begin
      FBrowser.StopLoad;
      Frame.LoadUrl(url);
    end;
  end;
end;

end.

