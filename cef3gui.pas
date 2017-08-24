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
 * Based on 'Delphi Chromium Embedded' by: Henri Gourvest <hgourvest@gmail.com>
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

Unit cef3gui;

{$I cef.inc}

Interface

Uses
  Classes, Graphics,
  cef3types, cef3lib, cef3intf, cef3own;

Type
  { Client }
  TOnProcessMessageReceived = procedure(Sender: TObject; const Browser: ICefBrowser;
    sourceProcess: TCefProcessId; const message: ICefProcessMessage; out Result: Boolean) of object;

  { ContextMenuHandler }
  TOnBeforeContextMenu = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const params: ICefContextMenuParams; const model: ICefMenuModel) of object;
  TOnRunContextMenu = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const Params: ICefContextMenuParams; const Model: ICefMenuModel;
    const Callback: ICefRunContextMenuCallback; out Result: Boolean) of object;
  TOnContextMenuCommand = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const params: ICefContextMenuParams; commandId: Integer;
    eventFlags: TCefEventFlags; out Result: Boolean) of object;
  TOnContextMenuDismissed = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame) of object;

  { DialogHandler }
  TOnFileDialog = procedure(Sender: TObject; const Browser: ICefBrowser;
    mode: TCefFileDialogMode; const title, defaultFileName: ustring;
    acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: ICefFileDialogCallback;
    out Result: Boolean) of object;

  { DisplayHandler }
  TOnAddressChange = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring) of object;
  TOnTitleChange = procedure(Sender: TObject; const Browser: ICefBrowser; const title: ustring) of object;
  TOnFaviconUrlchange = procedure(Sender: TObject; const Browser: ICefBrowser; iconUrls: TStrings) of object;
  TOnFullscreenModeChange = procedure(Sender: TObject; const Browser: ICefBrowser; fullscreen: Boolean) of object;
  TOnTooltip = procedure(Sender: TObject; const Browser: ICefBrowser; var text: ustring; out Result: Boolean) of object;
  TOnStatusMessage = procedure(Sender: TObject; const Browser: ICefBrowser; const value: ustring) of object;
  TOnConsoleMessage = procedure(Sender: TObject; const Browser: ICefBrowser; const message, Source: ustring; line: Integer; out Result: Boolean) of object;

  { DownloadHandler }
  TOnBeforeDownload = procedure(Sender: TObject; const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
    const suggestedName: ustring; const callback: ICefBeforeDownloadCallback) of object;
  TOnDownloadUpdated = procedure(Sender: TObject; const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
    const callback: ICefDownloadItemCallback) of object;

  { DragHandler }
  TOnDragEnter = procedure(Sender: TObject; const Browser: ICefBrowser; const dragData: ICefDragData; mask: TCefDragOperationsMask; out Result: Boolean) of object;
  TOnDraggableRegionsChanged = procedure(Sender: TObject; browser: ICefBrowser; regionsCount: TSize; const regions: TCefDraggableRegionArray) of object;

  { FindHandler }
  TOnFindResult = procedure(Sender: TObject; browser: ICefBrowser; identifier, count: Integer; const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean) of object;

  { FocusHandler }
  TOnTakeFocus = procedure(Sender: TObject; const Browser: ICefBrowser; next_: Boolean) of object;
  TOnSetFocus = procedure(Sender: TObject; const Browser: ICefBrowser; Source: TCefFocusSource; out Result: Boolean) of object;
  TOnGotFocus = procedure(Sender: TObject; const Browser: ICefBrowser) of object;

  { GeolocationHandler }
  TOnRequestGeolocationPermission = procedure(Sender: TObject; const Browser: ICefBrowser;
    const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback; out Result: Boolean) of object;
  TOnCancelGeolocationPermission = procedure(Sender: TObject; const Browser: ICefBrowser;
    requestId: Integer) of object;

  { JsDialogHandler }
  TOnJsdialog = procedure(Sender: TObject; const Browser: ICefBrowser; const originUrl: ustring;
    dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
    callback: ICefJsDialogCallback; out suppressMessage: Boolean; out Result: Boolean) of object;
  TOnBeforeUnloadDialog = procedure(Sender: TObject; const Browser: ICefBrowser;
    const messageText: ustring; isReload: Boolean;
    const callback: ICefJsDialogCallback; out Result: Boolean) of object;
  TOnResetDialogState = procedure(Sender: TObject; const Browser: ICefBrowser) of object;
  TOnDialogClosed = procedure(Sender: TObject; const browser: ICefBrowser) of object;

  { KeyboardHandler }
  TOnPreKeyEvent = procedure(Sender: TObject; const Browser: ICefBrowser; const event: PCefKeyEvent;
    osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean; out Result: Boolean) of object;
  TOnKeyEvent = procedure(Sender: TObject; const Browser: ICefBrowser; const event: PCefKeyEvent;
    osEvent: TCefEventHandle; out Result: Boolean) of object;

  { LifespanHandler }
  TOnBeforePopup = procedure(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame;
    const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
    userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
    var client: ICefClient; var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean; out Result: Boolean) of object;
  TOnAfterCreated = procedure(Sender: TObject; const Browser: ICefBrowser) of object;
  TOnBeforeClose = procedure(Sender: TObject; const Browser: ICefBrowser) of object;
  TOnClose = procedure(Sender: TObject; const Browser: ICefBrowser; out Result: Boolean) of object;

  { LoadHandler }
  TOnLoadingStateChange = procedure(Sender: TObject; const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean) of object;
  TOnLoadStart = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; transitionType: TCefTransitionType) of object;
  TOnLoadEnd = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer) of object;
  TOnLoadError = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: TCefErrorCode;
    const errorText, failedUrl: ustring) of object;

  { RenderHandler }
  TOnGetRootScreenRect = procedure(Sender: TObject; const Browser: ICefBrowser;
    rect: PCefRect; out Result: Boolean) of object;
  TOnGetViewRect = procedure(Sender: TObject; const Browser: ICefBrowser;
    rect: PCefRect; out Result: Boolean) of object;
  TOnGetScreenPoint = procedure(Sender: TObject; const Browser: ICefBrowser;
    viewX, viewY: Integer; screenX, screenY: PInteger; out Result: Boolean) of object;
  TOnGetScreenInfo = procedure(Sender: TObject; const browser : ICefBrowser;
    var screenInfo : TCefScreenInfo; out Result: Boolean) of object;
  TOnPopupShow = procedure(Sender: TObject; const Browser: ICefBrowser;
    show_: Boolean) of object;
  TOnPopupSize = procedure(Sender: TObject; const Browser: ICefBrowser;
    const rect: PCefRect) of object;
  TOnPaint = procedure(Sender: TObject; const Browser: ICefBrowser;
    kind: TCefPaintElementType; dirtyRectsCount: Cardinal; const dirtyRects: TCefRectArray;
    const buffer: Pointer; awidth, aheight: Integer) of object;
  TOnCursorChange = procedure(Sender: TObject; const browser: ICefBrowser; cursor: TCefCursorHandle;
    type_: TCefCursorType; const customCursorInfo: PCefCursorInfo) of object;
  TOnStartDragging = procedure(Sender: TObject; const browser: ICefBrowser; const dragData: ICefDragData;
    allowedOps: TCefDragOperationsMask; x, y: Integer; out Result: Boolean) of object;
  TOnUpdateDragCursor = procedure(Self: TObject; const browser: ICefBrowser; operation: TCefDragOperationsMask) of object;
  TOnScrollOffsetChanged = procedure(Sender: TObject; const browser: ICefBrowser; x,y: Double) of object;

  { RequestHandler }
  TOnBeforeBrowse = procedure(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; isRedirect: Boolean; out Result: Boolean) of object;
  TOnOpenUrlFromTab = procedure(Sender: TObject; browser: ICefBrowser; frame: ICefFrame;
    const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean;
    out Result: Boolean) of object;
  TOnBeforeResourceLoad = procedure(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; const callback: ICefRequestCallback; out Result: TCefReturnValue) of object;
  TOnGetResourceHandler = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const request: ICefRequest; out Result: ICefResourceHandler) of object;
  TOnResourceRedirect = procedure(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; const response: ICefResponse; var newUrl: ustring) of object;
  TOnResourceResponse = procedure(Sender: TObject; browser: ICefBrowser; frame: ICefFrame; request: ICefRequest;
    response: ICefResponse; out Result: Boolean) of object;
  TOnGetResourceResponseFilter = procedure(Sender: TObject; const browser: ICefBrowser;
    const frame: ICefFrame; const request: ICefRequest;
    const response: ICefResponse; out Result: ICefResponseFilter) of object;
  TOnResourceLoadComplete = procedure(Sender: TObject; const browser: ICefBrowser;
    const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
    status: TCefUrlRequestStatus; receivedContentLength: Int64) of object;
  TOnGetAuthCredentials = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
    const callback: ICefAuthCallback; out Result: Boolean) of object;
  TOnQuotaRequest = procedure(Sender: TObject; const Browser: ICefBrowser;
    const originUrl: ustring; newSize: Int64; const callback: ICefRequestCallback;
    out Result: Boolean) of object;
  TOnProtocolExecution = procedure(Sender: TObject; const Browser: ICefBrowser;
    const url: ustring; out allowOsExecution: Boolean) of object;
  TOnCertificateError = procedure(Sender: TObject; const Browser: ICefBrowser;
      certError: TCefErrorCode; const requestUrl: ustring; const sslInfo: ICefSslinfo;
      callback: ICefRequestCallback; out Result: Boolean) of object;
  TOnSelectClientCertificate = procedure(Sender: TObject; const browser: ICefBrowser; isProxy: Boolean;
      const host: ustring; port: Integer; certificatesCount: TSize;
      certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback;
      out Result: Boolean) of object;
  TOnPluginCrashed = procedure(Sender: TObject; const browser: ICefBrowser; const plugin_path: ustring) of object;
  TOnRenderViewReady = procedure(Sender: TObject; const browser: ICefBrowser) of object;
  TOnRenderProcessTerminated = procedure(Sender: TObject; const browser: ICefBrowser; status: TCefTerminationStatus) of object;
  TOnImeCompositionRangeChanged = procedure(Sender: TObject; const browser: ICefBrowser;
      const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray) of object;

  { RequestContextHandler }
  TOnGetCookieManager = procedure(Sender: TObject; out Result: ICefCookieManager) of object;
  TOnBeforePluginLoad = procedure(Sender: TObject; const mimeType, pluginUrl: ustring;
    isMainFrame: Boolean; const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo;
    pluginPolicy: TCefPluginPolicy; out Result: Boolean) of object;

  TChromiumOptions = class(TPersistent)
  private
    fRemoteFonts: TCefState;
    fJavascript: TCefState;
    fJavascriptOpenWindows: TCefState;
    fJavascriptCloseWindows: TCefState;
    fJavascriptAccessClipboard: TCefState;
    fJavascriptDomPaste: TCefState;
    fPlugins: TCefState;
    fUniversalAccessFromFileUrls: TCefState;
    fFileAccessFromFileUrls: TCefState;
    fWebSecurity: TCefState;
    fImageLoading: TCefState;
    fImageShrinkStandaloneToFit: TCefState;
    fTextAreaResize: TCefState;
    fTabToLinks: TCefState;
    fLocalStorage: TCefState;
    fDatabases: TCefState;
    fApplicationCache: TCefState;
    fWebgl: TCefState;
  published
    property RemoteFonts: TCefState read fRemoteFonts write fRemoteFonts default STATE_DEFAULT;
    property Javascript: TCefState read fJavascript write fJavascript default STATE_DEFAULT;
    property JavascriptOpenWindows: TCefState read fJavascriptOpenWindows write fJavascriptOpenWindows default STATE_DEFAULT;
    property JavascriptCloseWindows: TCefState read fJavascriptCloseWindows write fJavascriptCloseWindows default STATE_DEFAULT;
    property JavascriptAccessClipboard: TCefState read fJavascriptAccessClipboard write fJavascriptAccessClipboard default STATE_DEFAULT;
    property JavascriptDomPaste: TCefState read fJavascriptDomPaste write fJavascriptDomPaste default STATE_DEFAULT;
    property Plugins: TCefState read fPlugins write fPlugins default STATE_DEFAULT;
    property UniversalAccessFromFileUrls: TCefState read fUniversalAccessFromFileUrls write fUniversalAccessFromFileUrls default STATE_DEFAULT;
    property FileAccessFromFileUrls: TCefState read fFileAccessFromFileUrls write fFileAccessFromFileUrls default STATE_DEFAULT;
    property WebSecurity: TCefState read fWebSecurity write fWebSecurity default STATE_DEFAULT;
    property ImageLoading: TCefState read fImageLoading write fImageLoading default STATE_DEFAULT;
    property ImageShrinkStandaloneToFit: TCefState read fImageShrinkStandaloneToFit write fImageShrinkStandaloneToFit default STATE_DEFAULT;
    property TextAreaResize: TCefState read fTextAreaResize write fTextAreaResize default STATE_DEFAULT;
    property TabToLinks: TCefState read fTabToLinks write fTabToLinks default STATE_DEFAULT;
    property LocalStorage: TCefState read fLocalStorage write fLocalStorage default STATE_DEFAULT;
    property Databases: TCefState read fDatabases write fDatabases default STATE_DEFAULT;
    property ApplicationCache: TCefState read fApplicationCache write fApplicationCache default STATE_DEFAULT;
    property Webgl: TCefState read fWebgl write fWebgl default STATE_DEFAULT;
  end;

  TChromiumFontOptions = class(TPersistent)
  private
    fStandardFontFamily: String;
    fFixedFontFamily: String;
    fSerifFontFamily: String;
    fSansSerifFontFamily: String;
    fCursiveFontFamily: String;
    fFantasyFontFamily: String;
    fDefaultFontSize: Integer;
    fDefaultFixedFontSize: Integer;
    fMinimumFontSize: Integer;
    fMinimumLogicalFontSize: Integer;

    function GetFontFamily(AIndex: Integer): String;
    procedure SetFontFamily(AIndex: Integer; AValue: String);
  public
    constructor Create; virtual;
  published
    property StandardFontFamily: String index 1 read GetFontFamily write SetFontFamily;
    property FixedFontFamily: String index 2 read GetFontFamily write SetFontFamily;
    property SerifFontFamily: String index 3 read GetFontFamily write SetFontFamily;
    property SansSerifFontFamily: String index 4 read GetFontFamily write SetFontFamily;
    property CursiveFontFamily: String index 5 read GetFontFamily write SetFontFamily;
    property FantasyFontFamily: String index 6 read GetFontFamily write SetFontFamily;
    property DefaultFontSize: Integer read fDefaultFontSize write fDefaultFontSize default 0;
    property DefaultFixedFontSize: Integer read fDefaultFixedFontSize write fDefaultFixedFontSize default 0;
    property MinimumFontSize: Integer read fMinimumFontSize write fMinimumFontSize default 0;
    property MinimumLogicalFontSize: Integer read fMinimumLogicalFontSize write fMinimumLogicalFontSize default 0;
  end;

  IChromiumEvents = interface ['{0C139DB1-0349-4D7F-8155-76FEA6A0126D}']
    procedure GetSettings(var settings: TCefBrowserSettings);

    { CefClient }
    function doOnProcessMessageReceived(const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage): Boolean;

    { CefContextMenuHandler }
    procedure doOnBeforeContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    function doRunContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel;
      const callback: ICefRunContextMenuCallback): Boolean;
    function doOnContextMenuCommand(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean;
    procedure doOnContextMenuDismissed(const browser: ICefBrowser; const frame: ICefFrame);

    { CefDialogHandler }
    function doOnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
      const callback: ICefFileDialogCallback): Boolean;

    { CefDisplayHandler }
    procedure doOnAddressChange(const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
    procedure doOnTitleChange(const browser: ICefBrowser; const title: ustring);
    procedure doOnFaviconUrlchange(const browser: ICefBrowser; iconUrls: TStrings);
    procedure doOnFullscreenModeChange(const browser: ICefBrowser; fullscreen: Boolean);
    function doOnTooltip(const browser: ICefBrowser; var text: ustring): Boolean;
    procedure doOnStatusMessage(const browser: ICefBrowser; const value: ustring);
    function doOnConsoleMessage(const browser: ICefBrowser; const message, source: ustring; line: Integer): Boolean;

    { CefDownloadHandler }
    procedure doOnBeforeDownload(const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
    procedure doOnDownloadUpdated(const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);

    { CefDragHandler }
    function doOnDragEnter(const browser: ICefBrowser; const dragData: ICefDragData; mask: TCefDragOperationsMask): Boolean;
    procedure doOnDraggableRegionsChanged(const browser: ICefBrowser; regionsCount: TSize; const regions: TCefDraggableRegionArray);

    { CefFindHandler }
    procedure doOnFindResult(const browser: ICefBrowser; identifier, count: Integer;
      const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean);

    { CefFocusHandler }
    procedure doOnTakeFocus(const Browser: ICefBrowser; next_: Boolean);
    function doOnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean;
    procedure doOnGotFocus(const Browser: ICefBrowser);

    { CefGeolocationHandler }
    function doOnRequestGeolocationPermission(const browser: ICefBrowser; const requestingUrl: ustring;
      requestId: Integer; const callback: ICefGeolocationCallback): Boolean;
    procedure doOnCancelGeolocationPermission(const browser: ICefBrowser; requestId: Integer);

    { CefJsDialogHandler }
    function doOnJsdialog(const browser: ICefBrowser; const originUrl: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean;
    function doOnBeforeUnloadDialog(const browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean;
    procedure doOnResetDialogState(const browser: ICefBrowser);
    procedure doOnDialogClosed(const browser: ICefBrowser);

    { CefKeyboardHandler }
    function doOnPreKeyEvent(const browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
    function doOnKeyEvent(const browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean;

    { CefLifeSpanHandler }
    function doOnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean;
    procedure doOnAfterCreated(const browser: ICefBrowser);
    function doOnClose(const browser: ICefBrowser): Boolean;
    procedure doOnBeforeClose(const browser: ICefBrowser);

    { CefLoadHandler }
    procedure doOnLoadingStateChange(const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean);
    procedure doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame; transitionType: TCefTransitionType);
    procedure doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
    procedure doOnLoadError(const browser: ICefBrowser; const frame: ICefFrame; errorCode: TCefErrorCode;
      const errorText, failedUrl: ustring);

    { CefRenderHandler }
    function doOnGetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
    function doOnGetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
    function doOnGetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean;
    function doOnGetScreenInfo(const browser: ICefBrowser; var screenInfo: TCefScreenInfo): Boolean;
    procedure doOnPopupShow(const browser: ICefBrowser; show: Boolean);
    procedure doOnPopupSize(const browser: ICefBrowser; const rect: PCefRect);
    procedure doOnPaint(const browser: ICefBrowser; aType: TCefPaintElementType;
      dirtyRectsCount: TSize; const dirtyRects: TCefRectArray; const buffer: Pointer;
      width, height: Integer);
    procedure doOnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle; type_: TCefCursorType;
      const customCursorInfo: PCefCursorInfo);
    function doOnStartDragging(const browser: ICefBrowser; const dragData: ICefDragData;
      allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean;
    procedure doOnUpdateDragCursor(const browser: ICefBrowser; operation: TCefDragOperationsMask);
    procedure doOnScrollOffsetChanged(const browser: ICefBrowser; x,y: Double);
    procedure doOnImeCompositionRangeChanged(const browser: ICefBrowser;
      const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray);

    { CefRequestHandler }
    function doOnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; isRedirect: Boolean): Boolean;
    function doOnOpenUrlFromTab(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean): Boolean;
    function doOnBeforeResourceLoad(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback): TCefReturnValue;
    function doOnGetResourceHandler(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler;
    procedure doOnResourceRedirect(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse; var newUrl: ustring);
    function doOnResourceResponse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse): Boolean;
    function doOnGetResourceResponseFilter(const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest;
      const response: ICefResponse): ICefResponseFilter;
    procedure doOnResourceLoadComplete(const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
      status: TCefUrlRequestStatus; receivedContentLength: Int64);
    function doOnGetAuthCredentials(const browser: ICefBrowser; const frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean;
    function doOnQuotaRequest(const browser: ICefBrowser;
      const originUrl: ustring; newSize: Int64; const callback: ICefRequestCallback): Boolean;
    procedure doOnProtocolExecution(const browser: ICefBrowser; const url: ustring;
      out allowOsExecution: Boolean);
    function doOnCertificateError(const browser: ICefBrowser; certError: TCefErrorCode;
      const requestUrl: ustring; const sslInfo: ICefSslinfo; callback: ICefRequestCallback): Boolean;
    function doOnSelectClientCertificate(const browser: ICefBrowser; isProxy: Boolean;
      const host: ustring; port: Integer; certificatesCount: TSize;
      certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback): Boolean;
    procedure doOnPluginCrashed(const browser: ICefBrowser; const plugin_path: ustring);
    procedure doOnRenderViewReady(const browser: ICefBrowser);
    procedure doOnRenderProcessTerminated(const browser: ICefBrowser; status: TCefTerminationStatus);
  end;

  IChromiumContextEvents = interface ['{1CEDEEB4-AEEF-473B-99FA-F8D0D2576A36}']
    function doOnGetCookieManager: ICefCookieManager;
    function doOnBeforePluginLoad(const mimeType, pluginUrl: ustring; isMainFrame: Boolean;
      const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo; pluginPolicy: TCefPluginPolicy): Boolean;
  end;

  ICefClientHandler = interface ['{E76F6888-D9C3-4FCE-9C23-E89659820A36}']
    procedure Disconnect;
  end;

  TCustomClientHandler = class(TCefClientOwn, ICefClientHandler)
  private
    fEvents: IChromiumEvents;
    fContextMenuHandler: ICefContextMenuHandler;
    fDialogHandler: ICefDialogHandler;
    fDisplayHandler: ICefDisplayHandler;
    fDownloadHandler: ICefDownloadHandler;
    fDragHandler: ICefDragHandler;
    fFindHandler: ICefFindHandler;
    fFocusHandler: ICefFocusHandler;
    fGeolocationHandler: ICefGeolocationHandler;
    fJsDialogHandler: ICefJsDialogHandler;
    fKeyboardHandler: ICefKeyboardHandler;
    fLifeSpanHandler: ICefLifeSpanHandler;
    fLoadHandler: ICefLoadHandler;
    fRenderHandler: ICefRenderHandler;
    fRequestHandler: ICefRequestHandler;
  protected
    procedure Disconnect;
    function GetContextMenuHandler: ICefContextMenuHandler; override;
    function GetDialogHandler: ICefDialogHandler; override;
    function GetDisplayHandler: ICefDisplayHandler; override;
    function GetDownloadHandler: ICefDownloadHandler; override;
    function GetDragHandler : ICefDragHandler; override;
    function GetFindHandler: ICefFindHandler; override;
    function GetFocusHandler: ICefFocusHandler; override;
    function GetGeolocationHandler: ICefGeolocationHandler; override;
    function GetJsdialogHandler: ICefJsdialogHandler; override;
    function GetKeyboardHandler: ICefKeyboardHandler; override;
    function GetLifeSpanHandler: ICefLifeSpanHandler; override;
    function GetLoadHandler: ICefLoadHandler; override;
    function GetRenderHandler: ICefRenderHandler; override;
    function GetRequestHandler: ICefRequestHandler; override;
    function OnProcessMessageReceived(const Browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomClientHandlerClass = class of TCustomClientHandler;

  TCustomContextMenuHandler = class(TCefContextMenuHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    procedure OnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel); override;
    function RunContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel;
      const callback: ICefRunContextMenuCallback): Boolean; override;
    function OnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean; override;
    procedure OnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDialogHandler = class(TCefDialogHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
      const callback: ICefFileDialogCallback): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDisplayHandler = class(TCefDisplayHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    procedure OnAddressChange(const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring); override;
    procedure OnTitleChange(const Browser: ICefBrowser; const title: ustring); override;
    procedure OnFaviconUrlchange(const Browser: ICefBrowser; iconUrls: TStrings); override;
    procedure OnFullscreenModeChange(const Browser: ICefBrowser; fullscreen: Boolean); override;
    function OnTooltip(const Browser: ICefBrowser; var text: ustring): Boolean; override;
    procedure OnStatusMessage(const Browser: ICefBrowser; const value: ustring); override;
    function OnConsoleMessage(const Browser: ICefBrowser; const message, Source: ustring; line: Integer): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDownloadHandler = class(TCefDownloadHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    procedure OnBeforeDownload(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback); override;
    procedure OnDownloadUpdated(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDragHandler = class(TCefDragHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnDragEnter(const browser: ICefBrowser; const dragData: ICefDragData; mask: TCefDragOperationsMask): Boolean; override;
    procedure OnDraggableRegionsChanged(browser: ICefBrowser; regionsCount: TSize; const regions: TCefDraggableRegionArray); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomFindHandler = class(TCefFindHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
      procedure OnFindResult(browser: ICefBrowser; identifier, count: Integer;
      const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomFocusHandler = class(TCefFocusHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    procedure OnTakeFocus(const Browser: ICefBrowser; next: Boolean); override;
    function OnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean; override;
    procedure OnGotFocus(const Browser: ICefBrowser); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomGeolocationHandler = class(TCefGeolocationHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnRequestGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback): Boolean; override;
    procedure OnCancelGeolocationPermission(const Browser: ICefBrowser; requestId: Integer); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomJsDialogHandler = class(TCefJsDialogHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnJsdialog(const Browser: ICefBrowser; const originUrl: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; override;
    function OnBeforeUnloadDialog(const Browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean; override;
    procedure OnResetDialogState(const Browser: ICefBrowser); override;
    procedure OnDialogClosed(const browser: ICefBrowser); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomKeyboardHandler = class(TCefKeyboardHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; override;
    function OnKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomLifeSpanHandler = class(TCefLifeSpanHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean; override;
    procedure OnAfterCreated(const Browser: ICefBrowser); override;
    function DoClose(const Browser: ICefBrowser): Boolean; override;
    procedure OnBeforeClose(const Browser: ICefBrowser); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomLoadHandler = class(TCefLoadHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    procedure OnLoadingStateChange(const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); override;
    procedure OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame; transitionType: TCefTransitionType); override;
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer); override;
    procedure OnLoadError(const browser: ICefBrowser; const frame: ICefFrame; errorCode: TCefErrorCode;
      const errorText, failedUrl: ustring); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomRenderHandler = class(TCefRenderHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean; override;
    function GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean; override;
    function GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean; override;
    function GetScreenInfo(const browser: ICefBrowser; var screenInfo: TCefScreenInfo): Boolean; override;
    procedure OnPopupShow(const browser: ICefBrowser; show: Boolean); override;
    procedure OnPopupSize(const browser: ICefBrowser; const rect: PCefRect); override;
    procedure OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: TSize; const dirtyRects: TCefRectArray;
      const buffer: Pointer; width, height: Integer); override;
    procedure OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle; type_: TCefCursorType;
      const customCursorInfo: PCefCursorInfo); override;
    function StartDragging(const browser: ICefBrowser; const dragData: ICefDragData;
      allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean; override;
    procedure UpdateDragCursor(const browser: ICefBrowser; operation: TCefDragOperationsMask); override;
    procedure OnScrollOffsetChanged(const browser: ICefBrowser; x,y: Double); override;
    procedure OnImeCompositionRangeChanged(const browser: ICefBrowser;
      const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomRequestHandler = class(TCefRequestHandlerOwn)
  private
    fEvent: IChromiumEvents;
  protected
    function OnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; isRedirect: Boolean): Boolean; override;
    function OnOpenUrlFromTab(browser: ICefBrowser; frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean): Boolean; override;
    function OnBeforeResourceLoad(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback): TCefReturnValue; override;
    function GetResourceHandler(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler; override;
    procedure OnResourceRedirect(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse; var newUrl: ustring); override;
    function OnResourceResponse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse): Boolean; override;
    function GetResourceResponseFilter(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse): ICefResponseFilter; override;
    procedure OnResourceLoadComplete(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse; status: TCefUrlRequestStatus;
      receivedContentLength: Int64); override;
    function GetAuthCredentials(const browser: ICefBrowser; const frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean; override;
    function OnQuotaRequest(const browser: ICefBrowser;
      const originUrl: ustring; newSize: Int64; const callback: ICefRequestCallback): Boolean; override;
    procedure OnProtocolExecution(const browser: ICefBrowser; const url: ustring;
      out allowOsExecution: Boolean); override;
    function OnCertificateError(const browser: ICefBrowser; certError: TCefErrorCode;
      const requestUrl: ustring; const sslInfo: ICefSslinfo; callback: ICefRequestCallback): Boolean; override;
    function OnSelectClientCertificate(const browser: ICefBrowser; isProxy: Boolean; const host: ustring;
      port: Integer; certificatesCount: TSize; certificates: ICefX509certificateArray;
      callback: ICefSelectClientCertificateCallback): Boolean; override;
    procedure OnPluginCrashed(const browser: ICefBrowser; const plugin_path: ustring); override;
    procedure OnRenderViewReady(browser: ICefBrowser); override;
    procedure OnRenderProcessTerminated(const browser: ICefBrowser; status: TCefTerminationStatus); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomRequestContextHandler = class(TCefRequestContextHandlerOwn)
  private
    fEvent: IChromiumContextEvents;
  protected
    function GetCookieManager: ICefCookieManager; override;
    function OnBeforePluginLoad(const mimeType, pluginUrl: ustring; isMainFrame: Boolean;
      const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo;
      pluginPolicy: TCefPluginPolicy): Boolean; override;
  public
    constructor Create(const events: IChromiumContextEvents); reintroduce; virtual;
  end;


Implementation

{ TChromiumFontOptions }

function TChromiumFontOptions.GetFontFamily(AIndex: Integer): String;
begin
  Case AIndex of
    1: Result := fStandardFontFamily;
    2: Result := fFixedFontFamily;
    3: Result := fSerifFontFamily;
    4: Result := fSansSerifFontFamily;
    5: Result := fCursiveFontFamily;
    6: Result := fFantasyFontFamily;
  Else Result := fStandardFontFamily;
  end;
end;

procedure TChromiumFontOptions.SetFontFamily(AIndex: Integer; AValue: String);
begin
  Case AIndex of
    1: fStandardFontFamily := AValue;
    2: fFixedFontFamily := AValue;
    3: fSerifFontFamily := AValue;
    4: fSansSerifFontFamily := AValue;
    5: fCursiveFontFamily := AValue;
    6: fFantasyFontFamily := AValue;
  end;
end;

constructor TChromiumFontOptions.Create;
begin
  fStandardFontFamily := '';
  fFixedFontFamily := '';
  fSerifFontFamily := '';
  fSansSerifFontFamily := '';
  fCursiveFontFamily := '';
  fFantasyFontFamily := '';
  fDefaultFontSize := 0;
  fDefaultFixedFontSize := 0;
  fMinimumFontSize := 0;
  fMinimumLogicalFontSize := 0;
end;

{ TCefCustomClientHandler }

procedure TCustomClientHandler.Disconnect;
begin
  fEvents := nil;
  fContextMenuHandler := nil;
  fDialogHandler := nil;
  fDisplayHandler := nil;
  fDownloadHandler := nil;
  fDragHandler := nil;
  fFindHandler := nil;
  fFocusHandler := nil;
  fGeolocationHandler := nil;
  fJsDialogHandler := nil;
  fKeyboardHandler := nil;
  fLifeSpanHandler := nil;
  fLoadHandler := nil;
  fRenderHandler := nil;
  fRequestHandler := nil;
end;

function TCustomClientHandler.GetContextMenuHandler: ICefContextMenuHandler;
begin
  Result := fContextMenuHandler;
end;

function TCustomClientHandler.GetDialogHandler: ICefDialogHandler;
begin
  Result := fDialogHandler;
end;

function TCustomClientHandler.GetDisplayHandler: ICefDisplayHandler;
begin
  Result := fDisplayHandler;
end;

function TCustomClientHandler.GetDownloadHandler: ICefDownloadHandler;
begin
  Result := fDownloadHandler;
end;

function TCustomClientHandler.GetDragHandler : ICefDragHandler;
begin
  Result := fDragHandler;
end;

function TCustomClientHandler.GetFindHandler: ICefFindHandler;
begin
  Result := fFindHandler;
end;

function TCustomClientHandler.GetFocusHandler: ICefFocusHandler;
begin
  Result := fFocusHandler;
end;

function TCustomClientHandler.GetGeolocationHandler: ICefGeolocationHandler;
begin
  Result := fGeolocationHandler;
end;

function TCustomClientHandler.GetJsdialogHandler : ICefJsdialogHandler;
begin
  Result := fJsDialogHandler;
end;

function TCustomClientHandler.GetKeyboardHandler: ICefKeyboardHandler;
begin
  Result := fKeyboardHandler;
end;

function TCustomClientHandler.GetLifeSpanHandler: ICefLifeSpanHandler;
begin
  Result := fLifeSpanHandler;
end;

function TCustomClientHandler.GetLoadHandler: ICefLoadHandler;
begin
  Result := fLoadHandler;
end;

function TCustomClientHandler.GetRenderHandler: ICefRenderHandler;
begin
  Result := fRenderHandler;
end;

function TCustomClientHandler.GetRequestHandler: ICefRequestHandler;
begin
  Result := fRequestHandler;
end;

function TCustomClientHandler.OnProcessMessageReceived(
  const Browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
begin
  Result := fEvents.doOnProcessMessageReceived(Browser, sourceProcess, message);
end;

constructor TCustomClientHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvents := events;
  fContextMenuHandler := TCustomContextMenuHandler.Create(events);
  fDialogHandler := TCustomDialogHandler.Create(events);
  fDisplayHandler := TCustomDisplayHandler.Create(events);
  fDownloadHandler := TCustomDownloadHandler.Create(events);
  fDragHandler := TCustomDragHandler.Create(events);
  fFindHandler := TCustomFindHandler.Create(events);
  fFocusHandler := TCustomFocusHandler.Create(events);
  fGeolocationHandler := TCustomGeolocationHandler.Create(events);
  fJsDialogHandler := TCustomJsDialogHandler.Create(events);
  fKeyboardHandler := TCustomKeyboardHandler.Create(events);
  fLifeSpanHandler := TCustomLifeSpanHandler.Create(events);
  fLoadHandler := TCustomLoadHandler.Create(events);
  fRenderHandler := TCustomRenderHandler.Create(events);
  fRequestHandler := TCustomRequestHandler.Create(events);
end;

{ TCustomContextMenuHandler }

constructor TCustomContextMenuHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

procedure TCustomContextMenuHandler.OnBeforeContextMenu(
  const Browser: ICefBrowser; const Frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  fEvent.doOnBeforeContextMenu(Browser, Frame, params, model);
end;

function TCustomContextMenuHandler.RunContextMenu(const browser: ICefBrowser;
  const frame: ICefFrame; const params: ICefContextMenuParams; const model: ICefMenuModel;
  const callback: ICefRunContextMenuCallback): Boolean;
begin
  Result := fEvent.doRunContextMenu(browser, frame, params, model, callback);
end;

function TCustomContextMenuHandler.OnContextMenuCommand(
  const Browser: ICefBrowser; const Frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags): Boolean;
begin
  Result := fEvent.doOnContextMenuCommand(Browser, Frame, params, commandId, eventFlags);
end;

procedure TCustomContextMenuHandler.OnContextMenuDismissed(
  const Browser: ICefBrowser; const Frame: ICefFrame);
begin
  fEvent.doOnContextMenuDismissed(Browser, Frame);
end;

{ TCustomDialogHandler }

constructor TCustomDialogHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomDialogHandler.OnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
  const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
  const callback: ICefFileDialogCallback): Boolean;
begin
  Result := fEvent.doOnFileDialog(browser, mode, title, defaultFileName, acceptFilters,
    selectedAcceptFilter, callback);
end;

{ TCustomDisplayHandler }

constructor TCustomDisplayHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

procedure TCustomDisplayHandler.OnAddressChange(const Browser: ICefBrowser;
  const Frame: ICefFrame; const url: ustring);
begin
  fEvent.doOnAddressChange(Browser, Frame, url);
end;

function TCustomDisplayHandler.OnConsoleMessage(const Browser: ICefBrowser;
  const message, Source: ustring; line: Integer): Boolean;
begin
  Result := fEvent.doOnConsoleMessage(Browser, message, Source, line);
end;

procedure TCustomDisplayHandler.OnStatusMessage(const Browser: ICefBrowser; const value: ustring);
begin
  fEvent.doOnStatusMessage(Browser, value);
end;

procedure TCustomDisplayHandler.OnTitleChange(const Browser: ICefBrowser; const title: ustring);
begin
  fEvent.doOnTitleChange(Browser, title);
end;

procedure TCustomDisplayHandler.OnFaviconUrlchange(const Browser: ICefBrowser; iconUrls: TStrings);
begin
  fEvent.doOnFaviconUrlchange(Browser, iconUrls);
end;

procedure TCustomDisplayHandler.OnFullscreenModeChange(const Browser: ICefBrowser;
  fullscreen: Boolean);
begin
  fEvent.doOnFullscreenModeChange(Browser, fullscreen);
end;

function TCustomDisplayHandler.OnTooltip(const Browser: ICefBrowser; var text: ustring): Boolean;
begin
  Result := fEvent.doOnTooltip(Browser, text);
end;

{ TCustomDownloadHandler }

constructor TCustomDownloadHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

procedure TCustomDownloadHandler.OnBeforeDownload(const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
begin
  fEvent.doOnBeforeDownload(Browser, downloadItem, suggestedName, callback);
end;

procedure TCustomDownloadHandler.OnDownloadUpdated(const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin
  fEvent.doOnDownloadUpdated(Browser, downloadItem, callback);
end;

{ TCustomDragHandler }

function TCustomDragHandler.OnDragEnter(const browser: ICefBrowser; const dragData: ICefDragData;
  mask: TCefDragOperationsMask): Boolean;
begin
  Result := fEvent.doOnDragEnter(browser, dragData, mask);
end;

procedure TCustomDragHandler.OnDraggableRegionsChanged(browser: ICefBrowser; regionsCount: TSize;
  const regions: TCefDraggableRegionArray);
begin
  fEvent.doOnDraggableRegionsChanged(browser, regionsCount, regions);
end;

constructor TCustomDragHandler.Create(const events : IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

{ TCustomFindHandler }

procedure TCustomFindHandler.OnFindResult(browser: ICefBrowser; identifier, count: Integer;
  const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean);
begin
  fEvent.doOnFindResult(browser, identifier, count, selectionRect, activeMatchOridinal, finalUpdate);
end;

constructor TCustomFindHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

{ TCustomFocusHandler }

constructor TCustomFocusHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

procedure TCustomFocusHandler.OnGotFocus(const Browser: ICefBrowser);
begin
  fEvent.doOnGotFocus(Browser);
end;

function TCustomFocusHandler.OnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean;
begin
  Result := fEvent.doOnSetFocus(Browser, Source);
end;

procedure TCustomFocusHandler.OnTakeFocus(const Browser: ICefBrowser; next: Boolean);
begin
  fEvent.doOnTakeFocus(Browser, next);
end;

{ TCustomGeolocationHandler }

constructor TCustomGeolocationHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomGeolocationHandler.OnRequestGeolocationPermission(const Browser: ICefBrowser;
  const requestingUrl: ustring; requestId: Integer;
  const callback: ICefGeolocationCallback): Boolean;
begin
  Result := fEvent.doOnRequestGeolocationPermission(Browser, requestingUrl, requestId, callback);
end;

procedure TCustomGeolocationHandler.OnCancelGeolocationPermission(
  const Browser: ICefBrowser; requestId: Integer);
begin
  fEvent.doOnCancelGeolocationPermission(Browser, requestId);
end;

{ TCustomJsDialogHandler }

constructor TCustomJsDialogHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomJsDialogHandler.OnBeforeUnloadDialog(const Browser: ICefBrowser;
  const messageText: ustring; isReload: Boolean;
  const callback: ICefJsDialogCallback): Boolean;
begin
  Result := fEvent.doOnBeforeUnloadDialog(Browser, messageText, isReload, callback);
end;

function TCustomJsDialogHandler.OnJsdialog(const Browser: ICefBrowser;
  const originUrl: ustring; dialogType: TCefJsDialogType;
  const messageText, defaultPromptText: ustring; callback: ICefJsDialogCallback;
  out suppressMessage: Boolean): Boolean;
begin
  Result := fEvent.doOnJsdialog(Browser, originUrl, dialogType,
    messageText, defaultPromptText, callback, suppressMessage);
end;

procedure TCustomJsDialogHandler.OnResetDialogState(const Browser: ICefBrowser);
begin
  fEvent.doOnResetDialogState(Browser);
end;

procedure TCustomJsDialogHandler.OnDialogClosed(const browser: ICefBrowser);
begin
  fEvent.doOnDialogClosed(browser);
end;

{ TCustomKeyboardHandler }

constructor TCustomKeyboardHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomKeyboardHandler.OnKeyEvent(const Browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle): Boolean;
begin
  Result := fEvent.doOnKeyEvent(Browser, event, osEvent);
end;

function TCustomKeyboardHandler.OnPreKeyEvent(const Browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle;
  out isKeyboardShortcut: Boolean): Boolean;
begin
  Result := fEvent.doOnPreKeyEvent(Browser, event, osEvent, isKeyboardShortcut);
end;

{ TCustomLifeSpanHandler }

constructor TCustomLifeSpanHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomLifeSpanHandler.OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
  const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  Result := fEvent.doOnBeforePopup(browser, frame, targetUrl, targetFrameName, targetDisposition,
    userGesture, popupFeatures, windowInfo, client, settings, noJavascriptAccess);
end;

procedure TCustomLifeSpanHandler.OnAfterCreated(const Browser: ICefBrowser);
begin
  fEvent.doOnAfterCreated(Browser);
end;

function TCustomLifeSpanHandler.DoClose(const Browser: ICefBrowser): Boolean;
begin
  Result := fEvent.doOnClose(Browser);
end;

procedure TCustomLifeSpanHandler.OnBeforeClose(const Browser: ICefBrowser);
begin
  fEvent.doOnBeforeClose(Browser);
end;

{ TCustomLoadHandler }

constructor TCustomLoadHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

procedure TCustomLoadHandler.OnLoadEnd(const browser : ICefBrowser;
  const frame : ICefFrame; httpStatusCode : Integer);
begin
  fEvent.doOnLoadEnd(Browser, Frame, httpStatusCode);
end;

procedure TCustomLoadHandler.OnLoadError(const browser : ICefBrowser;
  const frame : ICefFrame; errorCode : TCefErrorCode;
  const errorText, failedUrl : ustring);
begin
  fEvent.doOnLoadError(Browser, Frame, errorCode, errorText, failedUrl);
end;

procedure TCustomLoadHandler.OnLoadingStateChange(const browser : ICefBrowser;
  isLoading, canGoBack, canGoForward : Boolean);
begin
  fEvent.doOnLoadingStateChange(browser, isLoading, canGoBack, canGoForward);
end;

procedure TCustomLoadHandler.OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame;
  transitionType: TCefTransitionType);
begin
  fEvent.doOnLoadStart(Browser, Frame, transitionType);
end;

{ TCustomRenderHandler }

constructor TCustomRenderHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomRenderHandler.GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := fEvent.doOnGetRootScreenRect(Browser, rect);
end;

function TCustomRenderHandler.GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := fEvent.doOnGetViewRect(Browser, rect);
end;

function TCustomRenderHandler.GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
  screenX, screenY: PInteger): Boolean;
begin
  Result := fEvent.doOnGetScreenPoint(Browser, viewX, viewY, screenX, screenY);
end;

function TCustomRenderHandler.GetScreenInfo(const browser: ICefBrowser;
  var screenInfo: TCefScreenInfo): Boolean;
begin
  Result := fEvent.doOnGetScreenInfo(Browser, screenInfo);
end;

procedure TCustomRenderHandler.OnPopupShow(const browser: ICefBrowser; show: Boolean);
begin
  fEvent.doOnPopupShow(Browser, show);
end;

procedure TCustomRenderHandler.OnPopupSize(const browser: ICefBrowser; const rect: PCefRect);
begin
  fEvent.doOnPopupSize(Browser, rect);
end;

procedure TCustomRenderHandler.OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType;
  dirtyRectsCount: TSize; const dirtyRects: TCefRectArray; const buffer: Pointer;
  width, height: Integer);
begin
  fEvent.doOnPaint(Browser, kind, dirtyRectsCount, dirtyRects, buffer, width, height);
end;

procedure TCustomRenderHandler.OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle;
  type_: TCefCursorType; const customCursorInfo: PCefCursorInfo);
begin
  fEvent.doOnCursorChange(browser, cursor, type_, customCursorInfo);
end;

function TCustomRenderHandler.StartDragging(const browser: ICefBrowser;
  const dragData: ICefDragData; allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean;
begin
  Result := fEvent.doOnStartDragging(browser, dragData, allowedOps, x, y);
end;

procedure TCustomRenderHandler.UpdateDragCursor(const browser: ICefBrowser;
  operation: TCefDragOperationsMask);
begin
  inherited UpdateDragCursor(browser, operation);
end;

procedure TCustomRenderHandler.OnScrollOffsetChanged(const browser: ICefBrowser; x, y: Double);
begin
  fEvent.doOnScrollOffsetChanged(browser, x, y);
end;

procedure TCustomRenderHandler.OnImeCompositionRangeChanged(const browser: ICefBrowser;
  const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray);
begin
  fEvent.doOnImeCompositionRangeChanged(browser, selectedRange, characterBoundsCount, characterBounds);
end;

{ TCustomRequestHandler }

constructor TCustomRequestHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomRequestHandler.OnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; isRedirect: Boolean): Boolean;
begin
  Result := fEvent.doOnBeforeBrowse(browser, frame, request, isRedirect);
end;

function TCustomRequestHandler.OnOpenUrlFromTab(browser: ICefBrowser; frame: ICefFrame;
  const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
  useGesture: Boolean): Boolean;
begin
  Result := fEvent.doOnOpenUrlFromTab(browser, frame, targetUrl, targetDisposition, useGesture);
end;

function TCustomRequestHandler.OnBeforeResourceLoad(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  const callback: ICefRequestCallback): TCefReturnValue;
begin
  Result := fEvent.doOnBeforeResourceLoad(browser, frame, request, callback);
end;

function TCustomRequestHandler.GetResourceHandler(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest): ICefResourceHandler;
begin
  Result := fEvent.doOnGetResourceHandler(Browser, Frame, request);
end;

procedure TCustomRequestHandler.OnResourceRedirect(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
  var newUrl: ustring);
begin
  fEvent.doOnResourceRedirect(browser, frame, request, response, newUrl);
end;

function TCustomRequestHandler.OnResourceResponse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse): Boolean;
begin
  Result := fEvent.doOnResourceResponse(browser, frame, request, response);
end;

function TCustomRequestHandler.GetResourceResponseFilter(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  const response: ICefResponse): ICefResponseFilter;
begin
  Result := fEvent.doOnGetResourceResponseFilter(browser, frame, request, response);
end;

procedure TCustomRequestHandler.OnResourceLoadComplete(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
  status: TCefUrlRequestStatus; receivedContentLength: Int64);
begin
  fEvent.doOnResourceLoadComplete(browser, frame, request, response, status, receivedContentLength);
end;

function TCustomRequestHandler.GetAuthCredentials(const browser: ICefBrowser;
  const frame: ICefFrame; isProxy: Boolean; const host: ustring; port: Integer;
  const realm, scheme: ustring; const callback: ICefAuthCallback): Boolean;
begin
  Result := fEvent.doOnGetAuthCredentials(Browser, Frame, isProxy, host, port, realm, scheme,
    callback);
end;

function TCustomRequestHandler.OnQuotaRequest(const browser: ICefBrowser; const originUrl: ustring;
  newSize: Int64; const callback: ICefRequestCallback): Boolean;
begin
  Result := fEvent.doOnQuotaRequest(Browser, originUrl, newSize, callback);
end;

procedure TCustomRequestHandler.OnProtocolExecution(const browser: ICefBrowser; const url: ustring;
  out allowOsExecution: Boolean);
begin
  fEvent.doOnProtocolExecution(Browser, url, allowOsExecution);
end;

function TCustomRequestHandler.OnCertificateError(const browser: ICefBrowser;
  certError: TCefErrorCode; const requestUrl: ustring; const sslInfo: ICefSslinfo;
  callback: ICefRequestCallback): Boolean;
begin
  Result := fEvent.doOnCertificateError(browser, certError, requestUrl, sslInfo, callback);
end;

function TCustomRequestHandler.OnSelectClientCertificate(const browser: ICefBrowser;
  isProxy: Boolean; const host: ustring; port: Integer; certificatesCount: TSize;
  certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback): Boolean;
begin
  Result := fEvent.doOnSelectClientCertificate(browser, isProxy, host, port, certificatesCount,
    certificates, callback);
end;

procedure TCustomRequestHandler.OnPluginCrashed(const browser: ICefBrowser;
  const plugin_path: ustring);
begin
  fEvent.doOnPluginCrashed(browser, plugin_path);
end;

procedure TCustomRequestHandler.OnRenderViewReady(browser: ICefBrowser);
begin
  fEvent.doOnRenderViewReady(browser);
end;

procedure TCustomRequestHandler.OnRenderProcessTerminated(const browser: ICefBrowser;
  status: TCefTerminationStatus);
begin
  fEvent.doOnRenderProcessTerminated(browser, status);
end;

{ TCustomRequestContextHandler }

constructor TCustomRequestContextHandler.Create(const events: IChromiumContextEvents);
begin
  inherited Create;
  fEvent := events;
end;

function TCustomRequestContextHandler.GetCookieManager: ICefCookieManager;
begin
  Result := fEvent.doOnGetCookieManager;
end;

function TCustomRequestContextHandler.OnBeforePluginLoad(const mimeType, pluginUrl: ustring;
  isMainFrame: Boolean; const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo;
  pluginPolicy: TCefPluginPolicy): Boolean;
begin
  Result := fEvent.doOnBeforePluginLoad(mimeType, pluginUrl, isMainFrame, topOriginUrl, pluginInfo,
    pluginPolicy);
end;

end.
