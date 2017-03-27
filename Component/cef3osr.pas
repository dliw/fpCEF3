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
 * Author: dliw <dev.dliw@gmail.com>
 * Repository: http://github.com/dliw/fpCEF3
 *
 *)

Unit cef3osr;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils, Graphics, fpTimer, FPimage,
  {$IFDEF DEBUG}LCLProc,{$ENDIF}
  cef3types, cef3lib, cef3intf, cef3gui, cef3context;

Type

  { TCustomChromiumOSR }

  TCustomChromiumOSR = class(TComponent, IChromiumEvents)
  private
    fHandler: ICefClient;
    fBrowser: ICefBrowser;
    fBrowserId: Integer;
    fDefaultUrl: String;

    { Client }
    fOnProcessMessageReceived: TOnProcessMessageReceived;

    { ContextMenuHandler }
    fOnBeforeContextMenu: TOnBeforeContextMenu;
    fOnRunContextMenu: TOnRunContextMenu;
    fOnContextMenuCommand: TOnContextMenuCommand;
    fOnContextMenuDismissed: TOnContextMenuDismissed;

    { DialogHandler }
    fOnFileDialog: TOnFileDialog;

    { DisplayHandler }
    fOnAddressChange: TOnAddressChange;
    fOnTitleChange: TOnTitleChange;
    fOnFaviconUrlchange: TOnFaviconUrlchange;
    fOnFullscreenModeChange: TOnFullscreenModeChange;
    fOnTooltip: TOnTooltip;
    fOnStatusMessage: TOnStatusMessage;
    fOnConsoleMessage: TOnConsoleMessage;

    { DownloadHandler }
    fOnBeforeDownload: TOnBeforeDownload;
    fOnDownloadUpdated: TOnDownloadUpdated;

    { DragHandler }
    fOnDragEnter: TOnDragEnter;
    fOnDraggableRegionsChanged: TOnDraggableRegionsChanged;

    { FindHandler }
    fOnFindResult: TOnFindResult;

    { FocusHandler }
    fOnTakeFocus: TOnTakeFocus;
    fOnSetFocus: TOnSetFocus;
    fOnGotFocus: TOnGotFocus;

    { GeolocationHandler }
    fOnRequestGeolocationPermission: TOnRequestGeolocationPermission;
    fOnCancelGeolocationPermission: TOnCancelGeolocationPermission;

    { JsDialogHandler }
    fOnJsdialog: TOnJsdialog;
    fOnBeforeUnloadDialog: TOnBeforeUnloadDialog;
    fOnResetDialogState: TOnResetDialogState;
    fOnDialogClosed: TOnDialogClosed;

    { KeyboardHandler }
    fOnPreKeyEvent: TOnPreKeyEvent;
    fOnKeyEvent: TOnKeyEvent;

    { LiveSpanHandler }
    fOnBeforePopup: TOnBeforePopup;
    fOnAfterCreated: TOnAfterCreated;
    fOnBeforeClose: TOnBeforeClose;
    fOnClose: TOnClose;

    { LoadHandler }
    fOnLoadingStateChange: TOnLoadingStateChange;
    fOnLoadStart: TOnLoadStart;
    fOnLoadEnd: TOnLoadEnd;
    fOnLoadError: TOnLoadError;

    { RenderHandler }
    fOnGetRootScreenRect: TOnGetRootScreenRect;
    fOnGetViewRect: TOnGetViewRect;
    fOnGetScreenPoint: TOnGetScreenPoint;
    fOnGetScreenInfo: TOnGetScreenInfo;
    fOnPopupShow: TOnPopupShow;
    fOnPopupSize: TOnPopupSize;
    fOnPaint: TOnPaint;
    fOnCursorChange: TOnCursorChange;
    fOnStartDragging: TOnStartDragging;
    fOnUpdateDragCursor: TOnUpdateDragCursor;
    fOnScrollOffsetChanged: TOnScrollOffsetChanged;
    fOnImeCompositionRangeChanged: TOnImeCompositionRangeChanged;

    { RequestHandler }
    fOnBeforeBrowse: TOnBeforeBrowse;
    fOnOpenUrlFromTab: TOnOpenUrlFromTab;
    fOnBeforeResourceLoad: TOnBeforeResourceLoad;
    fOnGetResourceHandler: TOnGetResourceHandler;
    fOnResourceRedirect: TOnResourceRedirect;
    fOnResourceResponse: TOnResourceResponse;
    fOnGetResourceResponseFilter: TOnGetResourceResponseFilter;
    fOnResourceLoadComplete: TOnResourceLoadComplete;
    fOnGetAuthCredentials: TOnGetAuthCredentials;
    fOnQuotaRequest: TOnQuotaRequest;
    fOnProtocolExecution: TOnProtocolExecution;
    fOnCertificateError: TOnCertificateError;
    fOnSelectClientCertificate: TOnSelectClientCertificate;
    fOnPluginCrashed: TOnPluginCrashed;
    fOnRenderViewReady: TOnRenderViewReady;
    fOnRenderProcessTerminated: TOnRenderProcessTerminated;

    { RequestContext }
    fChromiumContext: TCustomChromiumContext;
    fRequestContext: ICefRequestContext;

    fOptions: TChromiumOptions;
    fFontOptions: TChromiumFontOptions;

    fWindowlessFramerate: Integer;
    fDefaultEncoding: String;
    fBackgroundColor: TFPColor;
    fAcceptLanguageList: String;

    procedure GetSettings(var settings: TCefBrowserSettings);
    procedure CreateBrowser;

    function GetBackgroundColor: TColor;
    procedure SetBackgroundColor(AValue: TColor);
    procedure SetWindowlessFrameRate(AValue: Integer);
  protected
    procedure Loaded; override;

    { Client }
    function doOnProcessMessageReceived(const Browser: ICefBrowser;
      sourceProcess: TCefProcessId; const Message: ICefProcessMessage): Boolean; virtual;

    { ContextMenuHandler }
    procedure doOnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel); virtual;
    function doRunContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel;
      const callback: ICefRunContextMenuCallback): Boolean; virtual;
    function doOnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean; virtual;
    procedure doOnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame); virtual;

    { DialogHandler }
    function doOnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
      const callback: ICefFileDialogCallback): Boolean; virtual;

    { DisplayHandler }
    procedure doOnAddressChange(const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring); virtual;
    procedure doOnTitleChange(const Browser: ICefBrowser; const title: ustring); virtual;
    procedure doOnFaviconUrlchange(const browser: ICefBrowser; iconUrls: TStrings); virtual;
    procedure doOnFullscreenModeChange(const browser: ICefBrowser; fullscreen: Boolean); virtual;
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
    procedure doOnDraggableRegionsChanged(const browser: ICefBrowser; regionsCount: TSize; const regions: TCefDraggableRegionArray); virtual;

    { FindHandler }
    procedure doOnFindResult(const browser: ICefBrowser; identifier, count: Integer; const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean); virtual;

    { FocusHandler }
    procedure doOnTakeFocus(const Browser: ICefBrowser; next: Boolean); virtual;
    function doOnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean; virtual;
    procedure doOnGotFocus(const Browser: ICefBrowser); virtual;

    { GeolocationHandler }
    function doOnRequestGeolocationPermission(const browser: ICefBrowser; const requestingUrl: ustring;
      requestId: Integer; const callback: ICefGeolocationCallback): Boolean; virtual;
    procedure doOnCancelGeolocationPermission(const Browser: ICefBrowser; requestId: Integer); virtual;

    { JsDialogHandler }
    function doOnJsdialog(const Browser: ICefBrowser; const originUrl: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
    function doOnBeforeUnloadDialog(const Browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean; virtual;
    procedure doOnResetDialogState(const Browser: ICefBrowser); virtual;
    procedure doOnDialogClosed(const browser: ICefBrowser); virtual;

    { KeyboardHander }
    function doOnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; virtual;
    function doOnKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean; virtual;

    { LiveSpanHandler }
    function doOnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean; virtual;
    procedure doOnAfterCreated(const Browser: ICefBrowser); virtual;
    procedure doOnBeforeClose(const Browser: ICefBrowser); virtual;
    function doOnClose(const Browser: ICefBrowser): Boolean; virtual;

    { LoadHandler }
    procedure doOnLoadingStateChange(const Browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;
    procedure doOnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame; transitionType: TCefTransitionType); virtual;
    procedure doOnLoadEnd(const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer); virtual;
    procedure doOnLoadError(const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: TCefErrorCode;
      const errorText, failedUrl: ustring); virtual;

    { RenderHandler }
    function doOnGetRootScreenRect(const Browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function doOnGetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function doOnGetScreenPoint(const Browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean; virtual;
    function doOnGetScreenInfo(const browser: ICefBrowser; var screenInfo: TCefScreenInfo): Boolean; virtual;
    procedure doOnPopupShow(const Browser: ICefBrowser; doshow: Boolean); virtual;
    procedure doOnPopupSize(const Browser: ICefBrowser; const rect: PCefRect); virtual;
    procedure doOnPaint(const Browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: TSize; const dirtyRects: TCefRectArray;
      const buffer: Pointer; awidth, aheight: Integer); virtual;
    procedure doOnCursorChange(const browser: ICefBrowser; aCursor: TCefCursorHandle; type_: TCefCursorType;
      const customCursorInfo: PCefCursorInfo); virtual;
    function doOnStartDragging(const browser: ICefBrowser; const dragData: ICefDragData;
      allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean; virtual;
    procedure doOnUpdateDragCursor(const browser: ICefBrowser; operation: TCefDragOperationsMask); virtual;
    procedure doOnScrollOffsetChanged(const browser: ICefBrowser; x,y: Double); virtual;
    procedure doOnImeCompositionRangeChanged(const browser: ICefBrowser; const selectedRange: TCefRange;
      characterBoundsCount: TSize; characterBounds: TCefRectArray); virtual;

    { RequestHandler }
    function doOnBeforeBrowse(const Browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; isRedirect: Boolean): Boolean; virtual;
    function doOnOpenUrlFromTab(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
      useGesture: Boolean): Boolean; virtual;
    function doOnBeforeResourceLoad(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback): TCefReturnValue; virtual;
    function doOnGetResourceHandler(const Browser: ICefBrowser; const Frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler; virtual;
    procedure doOnResourceRedirect(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse; var newUrl: ustring); virtual;
    function doOnResourceResponse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse): Boolean; virtual;
    function doOnGetResourceResponseFilter(const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest;
      const response: ICefResponse): ICefResponseFilter; virtual;
    procedure doOnResourceLoadComplete(const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
      status: TCefUrlRequestStatus; receivedContentLength: Int64); virtual;
    function doOnGetAuthCredentials(const Browser: ICefBrowser; const Frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean; virtual;
    function doOnQuotaRequest(const Browser: ICefBrowser; const originUrl: ustring;
      newSize: Int64; const callback: ICefRequestCallback): Boolean; virtual;
    procedure doOnProtocolExecution(const Browser: ICefBrowser;
      const url: ustring; out allowOsExecution: Boolean); virtual;
    function doOnCertificateError(const browser: ICefBrowser; certError: TCefErrorCode;
      const requestUrl: ustring; const sslInfo: ICefSslinfo; callback: ICefRequestCallback): Boolean;
    function doOnSelectClientCertificate(const browser: ICefBrowser; isProxy: Boolean;
      const host: ustring; port: Integer; certificatesCount: TSize;
      certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback): Boolean;
    procedure doOnPluginCrashed(const Browser: ICefBrowser; const pluginPath: ustring); virtual;
    procedure doOnRenderViewReady(const browser: ICefBrowser); virtual;
    procedure doOnRenderProcessTerminated(const Browser: ICefBrowser; Status: TCefTerminationStatus); virtual;

    { Client }
    property OnProcessMessageReceived: TOnProcessMessageReceived read fOnProcessMessageReceived write fOnProcessMessageReceived;

    { ContextMenuHandler }
    property OnBeforeContextMenu: TOnBeforeContextMenu read fOnBeforeContextMenu write fOnBeforeContextMenu;
    property OnRunContextMenu: TOnRunContextMenu read fOnRunContextMenu write fOnRunContextMenu;
    property OnContextMenuCommand: TOnContextMenuCommand read fOnContextMenuCommand write fOnContextMenuCommand;
    property OnContextMenuDismissed: TOnContextMenuDismissed read fOnContextMenuDismissed write fOnContextMenuDismissed;

    { DialogHandler }
    property OnFileDialog: TOnFileDialog read fOnFileDialog write fOnFileDialog;

    { DisplayHandler }
    property OnAddressChange: TOnAddressChange read fOnAddressChange write fOnAddressChange;
    property OnTitleChange: TOnTitleChange read fOnTitleChange write fOnTitleChange;
    property OnFaviconUrlchange: TOnFaviconUrlchange read fOnFaviconUrlchange write fOnFaviconUrlchange;
    property OnFullscreenModeChange: TOnFullscreenModeChange read fOnFullscreenModeChange write fOnFullscreenModeChange;
    property OnTooltip: TOnTooltip read fOnTooltip write fOnTooltip;
    property OnStatusMessage: TOnStatusMessage read fOnStatusMessage write fOnStatusMessage;
    property OnConsoleMessage: TOnConsoleMessage read fOnConsoleMessage write fOnConsoleMessage;

    { DownloadHandler }
    property OnBeforeDownload: TOnBeforeDownload read fOnBeforeDownload write fOnBeforeDownload;
    property OnDownloadUpdated: TOnDownloadUpdated read fOnDownloadUpdated write fOnDownloadUpdated;

    { DragHandler }
    property OnDragEnter: TOnDragEnter read fOnDragEnter write fOnDragEnter;
    property OnDraggableRegionsChanged: TOnDraggableRegionsChanged read fOnDraggableRegionsChanged write fOnDraggableRegionsChanged;

    { FindHandler }
    property OnFindResult: TOnFindResult read fOnFindResult write fOnFindResult;

    { FocusHandler }
    property OnTakeFocus: TOnTakeFocus read fOnTakeFocus write fOnTakeFocus;
    property OnSetFocus: TOnSetFocus read fOnSetFocus write fOnSetFocus;
    property OnGotFocus: TOnGotFocus read fOnGotFocus write fOnGotFocus;

    { GeolocationHandler }
    property OnRequestGeolocationPermission: TOnRequestGeolocationPermission read fOnRequestGeolocationPermission write fOnRequestGeolocationPermission;
    property OnCancelGeolocationPermission: TOnCancelGeolocationPermission read fOnCancelGeolocationPermission write fOnCancelGeolocationPermission;

    { JsDialogHandler }
    property OnJsdialog: TOnJsdialog read fOnJsdialog write fOnJsdialog;
    property OnBeforeUnloadDialog: TOnBeforeUnloadDialog read fOnBeforeUnloadDialog write fOnBeforeUnloadDialog;
    property OnResetDialogState: TOnResetDialogState read fOnResetDialogState write fOnResetDialogState;
    property OnDialogClosed: TOnDialogClosed read fOnDialogClosed write fOnDialogClosed;

    { KeyboardHandler }
    property OnPreKeyEvent: TOnPreKeyEvent read fOnPreKeyEvent write fOnPreKeyEvent;
    property OnKeyEvent: TOnKeyEvent read fOnKeyEvent write fOnKeyEvent;

    { LifeSpanHandler }
    property OnBeforePopup: TOnBeforePopup read fOnBeforePopup write fOnBeforePopup;
    property OnAfterCreated: TOnAfterCreated read fOnAfterCreated write fOnAfterCreated;
    property OnClose: TOnClose read fOnClose write fOnClose;
    property OnBeforeClose: TOnBeforeClose read fOnBeforeClose write fOnBeforeClose;

    { LoadHandler }
    property OnLoadingStateChange: TOnLoadingStateChange read fOnLoadingStateChange write fOnLoadingStateChange;
    property OnLoadStart: TOnLoadStart read fOnLoadStart write fOnLoadStart;
    property OnLoadEnd: TOnLoadEnd read fOnLoadEnd write fOnLoadEnd;
    property OnLoadError: TOnLoadError read fOnLoadError write fOnLoadError;

    { RenderHandler }
    property OnGetRootScreenRect: TOnGetRootScreenRect read fOnGetRootScreenRect write fOnGetRootScreenRect;
    property OnGetViewRect: TOnGetViewRect read fOnGetViewRect write fOnGetViewRect;
    property OnGetScreenPoint: TOnGetScreenPoint read fOnGetScreenPoint write fOnGetScreenPoint;
    property OnGetScreenInfo: TOnGetScreenInfo read fOnGetScreenInfo write fOnGetScreenInfo;
    property OnPopupShow: TOnPopupShow read fOnPopupShow write fOnPopupShow;
    property OnPopupSize: TOnPopupSize read fOnPopupSize write fOnPopupSize;
    property OnPaint: TOnPaint read fOnPaint write fOnPaint;
    property OnCursorChange: TOnCursorChange read fOnCursorChange write fOnCursorChange;
    property OnStartDragging: TOnStartDragging read fOnStartDragging write fOnStartDragging;
    property OnUpdateDragCursor: TOnUpdateDragCursor read fOnUpdateDragCursor write fOnUpdateDragCursor;
    property OnScrollOffsetChanged: TOnScrollOffsetChanged read fOnScrollOffsetChanged write fOnScrollOffsetChanged;
    property OnImeCompositionRangeChanged: TOnImeCompositionRangeChanged read fOnImeCompositionRangeChanged write fOnImeCompositionRangeChanged;

    { RequestHandler }
    property OnBeforeBrowse: TOnBeforeBrowse read fOnBeforeBrowse write fOnBeforeBrowse;
    property OnOpenUrlFromTab: TOnOpenUrlFromTab read fOnOpenUrlFromTab write fOnOpenUrlFromTab;
    property OnBeforeResourceLoad: TOnBeforeResourceLoad read fOnBeforeResourceLoad write fOnBeforeResourceLoad;
    property OnGetResourceHandler: TOnGetResourceHandler read fOnGetResourceHandler write fOnGetResourceHandler;
    property OnResourceRedirect: TOnResourceRedirect read fOnResourceRedirect write fOnResourceRedirect;
    property OnResourceResponse: TOnResourceResponse read fOnResourceResponse write fOnResourceResponse;
    property OnGetResourceResponseFilter: TOnGetResourceResponseFilter read fOnGetResourceResponseFilter write fOnGetResourceResponseFilter;
    property OnResourceLoadComplete: TOnResourceLoadComplete read fOnResourceLoadComplete write fOnResourceLoadComplete;
    property OnGetAuthCredentials: TOnGetAuthCredentials read fOnGetAuthCredentials write fOnGetAuthCredentials;
    property OnQuotaRequest: TOnQuotaRequest read fOnQuotaRequest write fOnQuotaRequest;
    property OnProtocolExecution: TOnProtocolExecution read fOnProtocolExecution write fOnProtocolExecution;
    property OnCertificateError: TOnCertificateError read fOnCertificateError write fOnCertificateError;
    property OnSelectClientCertificate: TOnSelectClientCertificate read fOnSelectClientCertificate write fOnSelectClientCertificate;
    property OnPluginCrashed: TOnPluginCrashed read fOnPluginCrashed write fOnPluginCrashed;
    property OnRenderViewReady: TOnRenderViewReady read fOnRenderViewReady write fOnRenderViewReady;
    property OnRenderProcessTerminated: TOnRenderProcessTerminated read fOnRenderProcessTerminated write fOnRenderProcessTerminated;

    { RequestContext }
    property ChromiumContext: TCustomChromiumContext read fChromiumContext write fChromiumContext;
    property RequestContext: ICefRequestContext read fRequestContext write fRequestContext;

    property BrowserId: Integer read fBrowserId;
    property Browser: ICefBrowser read fBrowser;
    property Handler: ICefClient read fHandler;

    property DefaultUrl: String read fDefaultUrl write fDefaultUrl;

    property Options: TChromiumOptions read fOptions write fOptions;
    property FontOptions: TChromiumFontOptions read fFontOptions write fFontOptions;
    property WindowlessFrameRate: Integer read fWindowlessFramerate write SetWindowlessFrameRate;
    property DefaultEncoding: String read fDefaultEncoding write fDefaultEncoding;
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
    property AcceptLanguageList: String read fAcceptLanguageList write fAcceptLanguageList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(const url: String);
  end;

  TChromiumOSR = class(TCustomChromiumOSR)
  public
    property BrowserId;
    property Browser;

    property RequestContext;
  published
    property OnProcessMessageReceived;

    property OnBeforeContextMenu;
    property OnRunContextMenu;
    property OnContextMenuCommand;
    property OnContextMenuDismissed;

    property OnFileDialog;

    property OnAddressChange;
    property OnTitleChange;
    property OnFaviconUrlchange;
    property OnFullscreenModeChange;
    property OnTooltip;
    property OnStatusMessage;
    property OnConsoleMessage;

    property OnBeforeDownload;
    property OnDownloadUpdated;

    property OnDragEnter;
    property OnDraggableRegionsChanged;

    property OnFindResult;

    property OnTakeFocus;
    property OnSetFocus;
    property OnGotFocus;

    property OnRequestGeolocationPermission;
    property OnCancelGeolocationPermission;

    property OnJsdialog;
    property OnBeforeUnloadDialog;
    property OnResetDialogState;
    property OnDialogClosed;

    property OnPreKeyEvent;
    property OnKeyEvent;

    property OnBeforePopup;
    property OnAfterCreated;
    property OnClose;
    property OnBeforeClose;

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
    property OnStartDragging;
    property OnUpdateDragCursor;
    property OnScrollOffsetChanged;
    property OnImeCompositionRangeChanged;

    property OnBeforeBrowse;
    property OnOpenUrlFromTab;
    property OnBeforeResourceLoad;
    property OnGetResourceHandler;
    property OnResourceRedirect;
    property OnResourceResponse;
    property OnGetResourceResponseFilter;
    property OnResourceLoadComplete;
    property OnGetAuthCredentials;
    property OnQuotaRequest;
    property OnProtocolExecution;
    property OnCertificateError;
    property OnSelectClientCertificate;
    property OnPluginCrashed;
    property OnRenderViewReady;
    property OnRenderProcessTerminated;

    property ChromiumContext;

    property DefaultUrl;

    property Options;
    property FontOptions;
    property WindowlessFrameRate;
    property DefaultEncoding;
    property BackgroundColor;
    property AcceptLanguageList;
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
    destructor Destroy; override;
    procedure StartTimer;
  end;

procedure Register;
begin
  RegisterComponents('Chromium', [TChromiumOSR]);
end;

class procedure TOSRClientHandler.OnTimer(Sender : TObject);
begin
  {$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
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
  {$ENDIF}
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

destructor TOSRClientHandler.Destroy;
begin
  {$IFDEF DEBUG}
  Debugln('OSRClientHandler.Cleanup');
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

  inherited;
end;

procedure TOSRClientHandler.StartTimer;
begin
  {$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  If not Assigned(Timer) then Exit;

  Timer.Enabled := True;
  {$ENDIF}
end;

{ TCustomChromiumOSR }

procedure TCustomChromiumOSR.GetSettings(var settings : TCefBrowserSettings);
begin
  If not (settings.size >= SizeOf(settings)) then raise Exception.Create('settings invalid');
  settings.standard_font_family := CefString(fFontOptions.StandardFontFamily);
  settings.fixed_font_family := CefString(fFontOptions.FixedFontFamily);
  settings.serif_font_family := CefString(fFontOptions.SerifFontFamily);
  settings.sans_serif_font_family := CefString(fFontOptions.SansSerifFontFamily);
  settings.cursive_font_family := CefString(fFontOptions.CursiveFontFamily);
  settings.fantasy_font_family := CefString(fFontOptions.FantasyFontFamily);
  settings.default_font_size := fFontOptions.DefaultFontSize;
  settings.default_fixed_font_size := fFontOptions.DefaultFixedFontSize;
  settings.minimum_font_size := fFontOptions.MinimumFontSize;
  settings.minimum_logical_font_size := fFontOptions.MinimumLogicalFontSize;

  settings.remote_fonts := fOptions.RemoteFonts;
  settings.javascript := fOptions.Javascript;
  settings.javascript_open_windows := fOptions.JavascriptOpenWindows;
  settings.javascript_close_windows := fOptions.JavascriptCloseWindows;
  settings.javascript_access_clipboard := fOptions.JavascriptAccessClipboard;
  settings.javascript_dom_paste := fOptions.JavascriptDomPaste;
  settings.plugins := fOptions.Plugins;
  settings.universal_access_from_file_urls := fOptions.UniversalAccessFromFileUrls;
  settings.file_access_from_file_urls := fOptions.FileAccessFromFileUrls;
  settings.web_security := fOptions.WebSecurity;
  settings.image_loading := fOptions.ImageLoading;
  settings.image_shrink_standalone_to_fit := fOptions.ImageShrinkStandaloneToFit;
  settings.text_area_resize := fOptions.TextAreaResize;
  settings.tab_to_links := fOptions.TabToLinks;
  settings.local_storage := fOptions.LocalStorage;
  settings.databases := fOptions.Databases;
  settings.application_cache := fOptions.ApplicationCache;
  settings.webgl := fOptions.Webgl;

  settings.windowless_frame_rate := fWindowlessFrameRate;
  settings.default_encoding := CefString(fDefaultEncoding);
  settings.background_color := FPColorToCefColor(fBackgroundColor);
  settings.accept_language_list := CefString(fAcceptLanguageList);
end;

procedure TCustomChromiumOSR.CreateBrowser;
Var
  info: TCefWindowInfo;
  settings: TCefBrowserSettings;
begin
  If not (csDesigning in ComponentState) then
  begin
    FillChar(info, SizeOf(info), 0);

    info.windowless_rendering_enabled := Ord(True);
    info.transparent_painting_enabled := Ord(True);

    FillChar(settings, SizeOf(TCefBrowserSettings), 0);
    settings.size := SizeOf(TCefBrowserSettings);
    GetSettings(settings);

    // request context priority: ChromiumContext (component) > RequestContext (manually set) > nil
    If Assigned(fChromiumContext) then fRequestContext := fChromiumContext.GetRequestContext;

    {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
      CefBrowserHostCreateBrowser(@info, fHandler, UTF8Decode(fDefaultUrl), @settings, fRequestContext);
    {$ELSE}
      fBrowser := CefBrowserHostCreateBrowserSync(@info, fHandler, UTF8Decode(fDefaultUrl), @settings, fRequestContext);
      FBrowserId := FBrowser.Identifier;
    {$ENDIF}

    (fHandler as TOSRClientHandler).StartTimer;
  end;
end;

function TCustomChromiumOSR.GetBackgroundColor: TColor;
begin
  Result := FPColorToTColor(fBackgroundColor);
end;

procedure TCustomChromiumOSR.SetBackgroundColor(AValue: TColor);
begin
  fBackgroundColor := TColorToFPColor(AValue);
end;

procedure TCustomChromiumOSR.SetWindowlessFrameRate(AValue: Integer);
begin
  If (AValue < 1) or (AValue > 60) then Exit;

  fWindowlessFramerate := AValue;
end;


procedure TCustomChromiumOSR.Loaded;
begin
  inherited;

  CreateBrowser;
  Load(FDefaultUrl);
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

function TCustomChromiumOSR.doRunContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel;
  const callback: ICefRunContextMenuCallback): Boolean;
begin
  If Assigned(fOnRunContextMenu) then fOnRunContextMenu(Self, browser, frame, params, model,
    callback, Result)
  Else Result := False;
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

function TCustomChromiumOSR.doOnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
  const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
  const callback: ICefFileDialogCallback): Boolean;
begin
  If Assigned(fOnFileDialog) then
    fOnFileDialog(Self, browser, mode, title, defaultFileName, acceptFilters, selectedAcceptFilter,
      callback, Result)
  Else Result := False;
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

procedure TCustomChromiumOSR.doOnFaviconUrlchange(const browser: ICefBrowser; iconUrls: TStrings);
begin
  If Assigned(fOnFaviconUrlchange) then fOnFaviconUrlchange(Self, browser, iconUrls);
end;

procedure TCustomChromiumOSR.doOnFullscreenModeChange(const browser: ICefBrowser;
  fullscreen: Boolean);
begin
  If Assigned(fOnFullscreenModeChange) then fOnFullscreenModeChange(Self, browser, fullscreen);
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

procedure TCustomChromiumOSR.doOnDraggableRegionsChanged(const browser: ICefBrowser;
  regionsCount: TSize; const regions: TCefDraggableRegionArray);
begin
  If Assigned(fOnDraggableRegionsChanged) then
    fOnDraggableRegionsChanged(Self, browser, regionsCount, regions);
end;

procedure TCustomChromiumOSR.doOnFindResult(const browser: ICefBrowser; identifier, count: Integer;
  const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean);
begin
  If Assigned(fOnFindResult) then fOnFindResult(Self, browser, identifier, count, selectionRect,
    activeMatchOridinal, finalUpdate);
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

function TCustomChromiumOSR.doOnRequestGeolocationPermission(const browser: ICefBrowser;
  const requestingUrl: ustring; requestId: Integer;
  const callback: ICefGeolocationCallback): Boolean;
begin
  If Assigned(fOnRequestGeolocationPermission) then
    fOnRequestGeolocationPermission(Self, Browser, requestingUrl, requestId, callback, Result)
  Else Result := False;
end;

procedure TCustomChromiumOSR.doOnCancelGeolocationPermission(const Browser : ICefBrowser;
  requestId : Integer);
begin
  If Assigned(FOnCancelGeolocationPermission) then
    FOnCancelGeolocationPermission(Self, Browser, requestId);
end;

function TCustomChromiumOSR.doOnJsdialog(const Browser: ICefBrowser; const originUrl: ustring;
  dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
  callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean;
begin
  Result := False;
  If Assigned(FOnJsdialog) then
    FOnJsdialog(Self, Browser, originUrl, dialogType, messageText, defaultPromptText, callback,
      suppressMessage, Result);
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

procedure TCustomChromiumOSR.doOnDialogClosed(const browser: ICefBrowser);
begin
  If Assigned(fOnDialogClosed) then fOnDialogClosed(Self, browser);
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

function TCustomChromiumOSR.doOnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
  const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  If Assigned(fOnBeforePopup) then
    fOnBeforePopup(Self, browser, frame, targetUrl, targetFrameName, targetDisposition, userGesture,
      popupFeatures, windowInfo, client, settings, noJavascriptAccess, Result)
  Else Result := False;
end;

procedure TCustomChromiumOSR.doOnAfterCreated(const Browser : ICefBrowser);
begin
  If Assigned(FOnAfterCreated) then FOnAfterCreated(Self, Browser);
end;

procedure TCustomChromiumOSR.doOnBeforeClose(const Browser : ICefBrowser);
begin
  If Assigned(FOnBeforeClose) then FOnBeforeClose(Self, Browser);
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

procedure TCustomChromiumOSR.doOnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame;
  transitionType: TCefTransitionType);
begin
  If Assigned(FOnLoadStart) then FOnLoadStart(Self, Browser, Frame, transitionType);
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

function TCustomChromiumOSR.doOnGetRootScreenRect(const Browser: ICefBrowser;
  rect: PCefRect): Boolean;
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
  kind : TCefPaintElementType; dirtyRectsCount : TSize; const dirtyRects : TCefRectArray;
  const buffer : Pointer; awidth, aheight : Integer);
begin
  If Assigned(FOnPaint) then
    FOnPaint(Self, Browser, kind, dirtyRectsCount, dirtyRects, buffer, awidth, aheight);
end;

procedure TCustomChromiumOSR.doOnCursorChange(const browser: ICefBrowser;
  aCursor: TCefCursorHandle; type_: TCefCursorType; const customCursorInfo: PCefCursorInfo);
begin
  If Assigned(fOnCursorChange) then fOnCursorChange(Self, browser, aCursor, type_, customCursorInfo);
end;

function TCustomChromiumOSR.doOnStartDragging(const browser: ICefBrowser;
  const dragData: ICefDragData; allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean;
begin
  If Assigned(fOnStartDragging) then fOnStartDragging(Self, browser, dragData, allowedOps, x, y, Result)
  Else Result := False;
end;

procedure TCustomChromiumOSR.doOnUpdateDragCursor(const browser: ICefBrowser;
  operation: TCefDragOperationsMask);
begin
  If Assigned(fOnUpdateDragCursor) then fOnUpdateDragCursor(Self, browser, operation);
end;

procedure TCustomChromiumOSR.doOnScrollOffsetChanged(const browser: ICefBrowser; x, y: Double);
begin
  If Assigned(fOnScrollOffsetChanged) then fOnScrollOffsetChanged(Self, browser, x, y);
end;

procedure TCustomChromiumOSR.doOnImeCompositionRangeChanged(const browser: ICefBrowser;
  const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray);
begin
  If Assigned(fOnImeCompositionRangeChanged) then
    fOnImeCompositionRangeChanged(Self, browser, selectedRange, characterBoundsCount, characterBounds);
end;

function TCustomChromiumOSR.doOnBeforeBrowse(const Browser : ICefBrowser;
  const frame : ICefFrame; const request : ICefRequest; isRedirect : Boolean) : Boolean;
begin
  Result := False;
  If Assigned(FOnBeforeBrowse) then
    FOnBeforeBrowse(Self, Browser, frame, request, isRedirect, Result);
end;

function TCustomChromiumOSR.doOnOpenUrlFromTab(const browser: ICefBrowser; const frame: ICefFrame;
  const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
  useGesture: Boolean): Boolean;
begin
  If Assigned(fOnOpenUrlFromTab) then fOnOpenUrlFromTab(Self, browser, frame, targetUrl,
    targetDisposition, useGesture, Result)
  Else Result := False;
end;

function TCustomChromiumOSR.doOnBeforeResourceLoad(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  const callback: ICefRequestCallback): TCefReturnValue;
begin
  If Assigned(fOnBeforeResourceLoad) then
    fOnBeforeResourceLoad(Self, browser, frame, request, callback, Result)
  Else Result := RV_CONTINUE;
end;

function TCustomChromiumOSR.doOnGetResourceHandler(const Browser : ICefBrowser;
  const Frame : ICefFrame; const request : ICefRequest) : ICefResourceHandler;
begin
  If Assigned(FOnGetResourceHandler) then FOnGetResourceHandler(Self, Browser, frame, request, Result)
  Else Result := nil;
end;

procedure TCustomChromiumOSR.doOnResourceRedirect(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
  var newUrl: ustring);
begin
  If Assigned(fOnResourceRedirect) then
    fOnResourceRedirect(Self, browser, frame, request, response, newUrl);
end;

function TCustomChromiumOSR.doOnResourceResponse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse): Boolean;
begin
  If Assigned(fOnResourceResponse) then
    fOnResourceResponse(Self, browser, frame, request, response, Result)
  Else Result := False;
end;

function TCustomChromiumOSR.doOnGetResourceResponseFilter(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  const response: ICefResponse): ICefResponseFilter;
begin
  If Assigned(fOnGetResourceResponseFilter) then
    fOnGetResourceResponseFilter(Self, browser, frame, request, response, Result)
  Else Result := nil;
end;

procedure TCustomChromiumOSR.doOnResourceLoadComplete(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
  status: TCefUrlRequestStatus; receivedContentLength: Int64);
begin
  If Assigned(fOnResourceLoadComplete) then
    fOnResourceLoadComplete(Self, browser, frame, request, response, status, receivedContentLength);
end;

function TCustomChromiumOSR.doOnGetAuthCredentials(const Browser: ICefBrowser;
  const Frame: ICefFrame; isProxy: Boolean; const host: ustring; port: Integer;
  const realm, scheme: ustring; const callback: ICefAuthCallback): Boolean;
begin
  Result := False;
  If Assigned(FOnGetAuthCredentials) then
    fOnGetAuthCredentials(Self, Browser, frame, isProxy, host, port, realm, scheme, callback, Result);
end;

function TCustomChromiumOSR.doOnQuotaRequest(const Browser: ICefBrowser;
  const originUrl: ustring; newSize: Int64; const callback: ICefRequestCallback): Boolean;
begin
  Result := False;
  If Assigned(FOnQuotaRequest) then
    FOnQuotaRequest(Self, Browser, originUrl, newSize, callback, Result);
end;

procedure TCustomChromiumOSR.doOnProtocolExecution(const Browser: ICefBrowser;
  const url: ustring; out allowOsExecution: Boolean);
begin
  If Assigned(fOnProtocolExecution) then
    fOnProtocolExecution(Self, Browser, url, allowOsExecution)
  Else allowOsExecution := True;
end;

function TCustomChromiumOSR.doOnCertificateError(const browser: ICefBrowser;
  certError: TCefErrorCode; const requestUrl: ustring; const sslInfo: ICefSslinfo;
  callback: ICefRequestCallback): Boolean;
begin
  If Assigned(FOnCertificateError) then
    fOnCertificateError(Self, browser, certError, requestUrl, sslInfo, callback, Result)
  Else Result := False;
end;

function TCustomChromiumOSR.doOnSelectClientCertificate(const browser: ICefBrowser;
  isProxy: Boolean; const host: ustring; port: Integer; certificatesCount: TSize;
  certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback): Boolean;
begin
  If Assigned(fOnSelectClientCertificate) then
    fOnSelectClientCertificate(Self, browser, isProxy, host, port, certificatesCount, certificates,
      callback, Result)
  Else Result := False;
end;

procedure TCustomChromiumOSR.doOnPluginCrashed(const Browser: ICefBrowser;
  const pluginPath: ustring);
begin
  If Assigned(FOnPluginCrashed) then FOnPluginCrashed(Self, Browser, pluginPath);
end;

procedure TCustomChromiumOSR.doOnRenderViewReady(const browser: ICefBrowser);
begin
  If Assigned(fOnRenderViewReady) then fOnRenderViewReady(Self, browser);
end;

procedure TCustomChromiumOSR.doOnRenderProcessTerminated(const Browser: ICefBrowser;
  Status: TCefTerminationStatus);
begin
  If Assigned(FOnRenderProcessTerminated) then FOnRenderProcessTerminated(Self, Browser, status);
end;

constructor TCustomChromiumOSR.Create(AOwner : TComponent);
begin
  inherited;

  If not (csDesigning in ComponentState) then
  begin
    fHandler := TOSRClientHandler.Create(Self);

    If not Assigned(fHandler) then raise Exception.Create('FHandler is nil');
  end;

  fOptions := TChromiumOptions.Create;
  fFontOptions := TChromiumFontOptions.Create;

  fWindowlessFramerate := 30;
  fDefaultUrl := 'about:blank';
  fBackgroundColor := CefBackgroundColor;
  fDefaultEncoding := '';

  fBrowserId := 0;
  fBrowser := nil;
end;

destructor TCustomChromiumOSR.Destroy;
begin
  If fBrowser <> nil then
  begin
    fBrowser.StopLoad;
    fBrowser.Host.CloseBrowser(True);
    fBrowser := nil;
  end;

  If fHandler <> nil then
  begin
    (fHandler as ICefClientHandler).Disconnect;
    fHandler := nil;
  end;

  fFontOptions.Free;
  fOptions.Free;

  inherited;
end;

procedure TCustomChromiumOSR.Load(const url: String);
Var
  Frame : ICefFrame;
begin
  If fBrowser <> nil then
  begin
    frame := fBrowser.MainFrame;

    If frame <> nil then
    begin
      fBrowser.StopLoad;
      frame.LoadUrl(UTF8Decode(url));
    end;
  end;
end;

end.

