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

Unit cef3own;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils, Math,
  {$IFDEF DEBUG}LCLProc,{$ENDIF}
  cef3api, cef3types, cef3intf, cef3scp;

Type
  TCefBaseOwn = class(TInterfacedObject, ICefBaseRefCounted)
  private
    fData: Pointer;
  public
    function Wrap: Pointer;
    constructor CreateData(size: TSize; owned: Boolean = False); virtual;
    destructor Destroy; override;
  end;

  TCefAppOwn = class(TCefBaseOwn, ICefApp)
  protected
    procedure OnBeforeCommandLineProcessing(const processType: ustring;
      const commandLine: ICefCommandLine); virtual; abstract;
    procedure OnRegisterCustomSchemes(const registrar: TCefSchemeRegistrarRef); virtual; abstract;
    function GetResourceBundleHandler: ICefResourceBundleHandler; virtual; abstract;
    function GetBrowserProcessHandler: ICefBrowserProcessHandler; virtual; abstract;
    function GetRenderProcessHandler: ICefRenderProcessHandler; virtual; abstract;
  public
    constructor Create; virtual;
  end;

  TInternalApp = class(TCefAppOwn)
  protected
    procedure OnBeforeCommandLineProcessing(const processType: ustring;
      const commandLine: ICefCommandLine); override;
    procedure OnRegisterCustomSchemes(const registrar: TCefSchemeRegistrarRef); override;
    function GetResourceBundleHandler: ICefResourceBundleHandler; override;
    function GetBrowserProcessHandler: ICefBrowserProcessHandler; override;
    function GetRenderProcessHandler: ICefRenderProcessHandler; override;
  end;

  TCefRunFileDialogCallbackOwn = class(TCefBaseOwn, ICefRunFileDialogCallback)
  protected
    procedure OnFileDialogDismissed(selectedAcceptFilter: Integer; filePaths: TStrings); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastRunFileDialogCallback = class(TCefRunFileDialogCallbackOwn)
  private
    fCallback: TCefRunFileDialogCallbackProc;
  protected
    procedure OnFileDialogDismissed(selectedAcceptFilter: Integer; filePaths: TStrings); override;
  public
    constructor Create(callback: TCefRunFileDialogCallbackProc); reintroduce; virtual;
  end;

  TCefNavigationEntryVisitorOwn = class(TCefBaseOwn, ICefNavigationEntryVisitor)
  protected
    function Visit(entry: ICefNavigationEntry; current: Boolean; index, total: Integer): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastNavigationEntryVisitor = class(TCefNavigationEntryVisitorOwn)
  private
    fVisitor: TCefNavigationEntryVisitorProc;
  protected
    function Visit(entry: ICefNavigationEntry; current: Boolean; index, total: Integer): Boolean; override;
  public
    constructor Create(Visitor: TCefNavigationEntryVisitorProc); reintroduce; virtual;
  end;

  TCefPdfPrintCallbackOwn = class(TCefBaseOwn, ICefPdfPrintCallback)
  protected
    procedure OnPdfPrintFinished(const path: ustring; ok: Boolean); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastPdfPrintCallback = class(TCefPdfPrintCallbackOwn)
  private
    fCallback: TCefPdfPrintCallbackProc;
  protected
    procedure OnPdfPrintFinished(const path: ustring; ok: Boolean); override;
  public
    constructor Create(callback: TCefPdfPrintCallbackProc); reintroduce; virtual;
  end;

  TCefDownloadImageCallbackOwn = class(TCefBaseOwn, ICefDownloadImageCallback)
  protected
    procedure OnDownloadImageFinished(const imageUrl: ustring; httpStatusCode: Integer; image: ICefImage); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastDownloadImageCallback = class(TCefDownloadImageCallbackOwn)
  private
    fCallback: TCefDownloadImageCallbackProc;
  protected
    procedure OnDownloadImageFinished(const imageUrl: ustring; httpStatusCode: Integer; image: ICefImage); override;
  public
    constructor Create(callback: TCefDownloadImageCallbackProc); reintroduce; virtual;
  end;

  TCefBrowserProcessHandlerOwn = class(TCefBaseOwn, ICefBrowserProcessHandler)
  protected
    procedure OnContextInitialized; virtual;
    procedure OnBeforeChildProcessLaunch(const commandLine: ICefCommandLine); virtual;
    procedure OnRenderProcessThreadCreated(extraInfo: ICefListValue); virtual;
    function GetPrintHandler: ICefPrintHandler; virtual;
    procedure OnScheduleMessagePumpWork(delayMs: Int64); virtual;
  public
    constructor Create; virtual;
  end;

  TCefCompletionCallbackOwn = class(TCefBaseOwn, ICefCompletionCallback)
  protected
    procedure OnComplete; virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastCompletionCallback = class(TCefCompletionCallbackOwn)
  private
    fCallback: TCefCompletionCallbackProc;
  protected
    procedure OnComplete; override;
  public
    constructor Create(callback: TCefCompletionCallbackProc); reintroduce; virtual;
  end;

  TCefClientOwn = class(TCefBaseOwn, ICefClient)
  protected
    function GetContextMenuHandler: ICefContextMenuHandler; virtual;
    function GetDialogHandler:ICefDialogHandler; virtual;
    function GetDisplayHandler: ICefDisplayHandler; virtual;
    function GetDownloadHandler: ICefDownloadHandler; virtual;
    function GetDragHandler: ICefDragHandler; virtual;
    function GetFindHandler: ICefFindHandler; virtual;
    function GetFocusHandler: ICefFocusHandler; virtual;
    function GetGeolocationHandler: ICefGeolocationHandler; virtual;
    function GetJsdialogHandler: ICefJsdialogHandler; virtual;
    function GetKeyboardHandler: ICefKeyboardHandler; virtual;
    function GetLifeSpanHandler: ICefLifeSpanHandler; virtual;
    function GetLoadHandler: ICefLoadHandler; virtual;
    function GetRenderHandler: ICefRenderHandler; virtual;
    function GetRequestHandler: ICefRequestHandler; virtual;
    function OnProcessMessageReceived(const browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefContextMenuHandlerOwn = class(TCefBaseOwn, ICefContextMenuHandler)
  protected
    procedure OnBeforeContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel); virtual;
    function RunContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel;
      const callback: ICefRunContextMenuCallback): Boolean; virtual;
    function OnContextMenuCommand(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean; virtual;
    procedure OnContextMenuDismissed(const browser: ICefBrowser; const frame: ICefFrame); virtual;
  public
    constructor Create; virtual;
  end;

  TCefCookieVisitorOwn = class(TCefBaseOwn, ICefCookieVisitor)
  protected
    function Visit(const cookie: TCefCookie; count, total: Integer; out deleteCookie: Boolean): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastCookieVisitor = class(TCefCookieVisitorOwn)
  private
    fVisitor: TCefCookieVisitorProc;
  protected
    function Visit(const cookie: TCefCookie; count, total: Integer; out deleteCookie: Boolean): Boolean; override;
  public
    constructor Create(const visitor: TCefCookieVisitorProc); reintroduce;
  end;

  TCefSetCookieCallbackOwn = class(TCefBaseOwn, ICefSetCookieCallback)
  protected
    procedure OnComplete(success: Boolean); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastSetCookieCallback = class(TCefSetCookieCallbackOwn)
  private
    fCallback: TCefSetCookieCallbackProc;
  protected
    procedure OnComplete(success: Boolean); override;
  public
    constructor Create(const callback: TCefSetCookieCallbackProc); reintroduce; virtual;
  end;

  TCefDeleteCookiesCallbackOwn = class(TCefBaseOwn, ICefDeleteCookiesCallback)
  protected
    procedure OnComplete(numDeleted: Integer); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastDeleteCookiesCallback = class(TCefDeleteCookiesCallbackOwn)
  private
    fCallback: TCefDeleteCookiesCallbackProc;
  protected
    procedure OnComplete(numDeleted: Integer); override;
  public
    constructor Create(const callback: TCefDeleteCookiesCallbackProc); reintroduce; virtual;
  end;

  TCefDialogHandlerOwn = class(TCefBaseOwn, ICefDialogHandler)
  protected
  function OnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
    const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
    const callback: ICefFileDialogCallback): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefDisplayHandlerOwn = class(TCefBaseOwn, ICefDisplayHandler)
  protected
    procedure OnAddressChange(const browser: ICefBrowser; const frame: ICefFrame; const url: ustring); virtual;
    procedure OnTitleChange(const browser: ICefBrowser; const title: ustring); virtual;
    procedure OnFaviconUrlchange(const browser: ICefBrowser; iconUrls: TStrings); virtual;
    procedure OnFullscreenModeChange(const browser: ICefBrowser; fullscreen: Boolean); virtual;
    function OnTooltip(const browser: ICefBrowser; var text: ustring): Boolean; virtual;
    procedure OnStatusMessage(const browser: ICefBrowser; const value: ustring); virtual;
    function OnConsoleMessage(const browser: ICefBrowser; const message, source: ustring; line: Integer): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefDomVisitorOwn = class(TCefBaseOwn, ICefDomVisitor)
  protected
    procedure Visit(const document: ICefDomDocument); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastDomVisitor = class(TCefDomVisitorOwn)
  private
    fProc: TCefDomVisitorProc;
  protected
    procedure Visit(const document: ICefDomDocument); override;
  public
    constructor Create(const proc: TCefDomVisitorProc); reintroduce; virtual;
  end;

  TCefDownloadHandlerOwn = class(TCefBaseOwn, ICefDownloadHandler)
  protected
    procedure OnBeforeDownload(const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback); virtual;
    procedure OnDownloadUpdated(const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
        const callback: ICefDownloadItemCallback); virtual;
  public
    constructor Create; virtual;
  end;

  TCefDragHandlerOwn = class(TCefBaseOwn, ICefDragHandler)
  protected
    function OnDragEnter(const browser: ICefBrowser; const dragData: ICefDragData; mask: TCefDragOperationsMask): Boolean; virtual;
    procedure OnDraggableRegionsChanged(browser: ICefBrowser; regionsCount: TSize; const regions: TCefDraggableRegionArray); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFindHandlerOwn = class(TCefBaseOwn, ICefFindHandler)
  protected
    procedure OnFindResult(browser: ICefBrowser; identifier, count: Integer;
      const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFocusHandlerOwn = class(TCefBaseOwn, ICefFocusHandler)
  protected
    procedure OnTakeFocus(const browser: ICefBrowser; next: Boolean); virtual;
    function OnSetFocus(const browser: ICefBrowser; source: TCefFocusSource): Boolean; virtual;
    procedure OnGotFocus(const browser: ICefBrowser); virtual;
  public
    constructor Create; virtual;
  end;

  TCefGetGeolocationCallbackOwn = class(TCefBaseOwn, ICefGetGeolocationCallback)
  protected
    procedure OnLocationUpdate(const position: TCefGeoposition); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastGetGeolocationCallback = class(TCefGetGeolocationCallbackOwn)
  private
    fCallback: TCefGetGeolocationCallbackProc;
  protected
    procedure OnLocationUpdate(const position: TCefGeoposition); override;
  public
    constructor Create(callback: TCefGetGeolocationCallbackProc); reintroduce; virtual;
  end;

  TCefGeolocationHandlerOwn = class(TCefBaseOwn, ICefGeolocationHandler)
  protected
    function OnRequestGeolocationPermission(const browser: ICefBrowser; const requestingUrl: ustring;
      requestId: Integer; const callback: ICefGeolocationCallback): Boolean; virtual;
    procedure OnCancelGeolocationPermission(const browser: ICefBrowser; requestId: Integer); virtual;
  public
    constructor Create; virtual;
  end;

  TCefJsDialogHandlerOwn = class(TCefBaseOwn, ICefJsDialogHandler)
  protected
    function OnJsDialog(const browser: ICefBrowser; const originUrl: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
    function OnBeforeUnloadDialog(const browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean; virtual;
    procedure OnResetDialogState(const browser: ICefBrowser); virtual;
    procedure OnDialogClosed(const browser: ICefBrowser); virtual;
  public
    constructor Create; virtual;
  end;

  TCefKeyboardHandlerOwn = class(TCefBaseOwn, ICefKeyboardHandler)
  protected
    function OnPreKeyEvent(const browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; virtual;
    function OnKeyEvent(const browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefLifeSpanHandlerOwn = class(TCefBaseOwn, ICefLifeSpanHandler)
  protected
    function OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean; virtual;
    procedure OnAfterCreated(const browser: ICefBrowser); virtual;
    function DoClose(const browser: ICefBrowser): Boolean; virtual;
    procedure OnBeforeClose(const browser: ICefBrowser); virtual;
  public
    constructor Create; virtual;
  end;

  TCefLoadHandlerOwn = class(TCefBaseOwn, ICefLoadHandler)
  protected
    procedure OnLoadingStateChange(const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;
    procedure OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame; transitionType: TCefTransitionType); virtual;
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer); virtual;
    procedure OnLoadError(const browser: ICefBrowser; const frame: ICefFrame; errorCode: TCefErrorCode;
      const errorText, failedUrl: ustring); virtual;
  public
    constructor Create; virtual;
  end;

  TCefMenuModelDelegateOwn = class(TCefBaseOwn, ICefMenuModelDelegate)
  protected
    procedure ExecuteCommand(menuModel: ICefMenuModel; commandId: Integer; eventFlags: TCefEventFlags); virtual;
    procedure MouseOutsideMenu(menuModel: ICefMenuModel; const screenPoint: TCefPoint); virtual;
    procedure UnhandledOpenSubmenu(menuModel: ICefMenuModel; isRTL: Boolean); virtual;
    procedure UnhandledCloseSubmenu(menuModel: ICefMenuModel; isRTL: Boolean); virtual;
    procedure MenuWillShow(menuModel: ICefMenuModel); virtual;
    procedure MenuClosed(menuModel: ICefMenuModel); virtual;
    function FormatLabel(menuModel: ICefMenuModel; var label_: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefPrintHandlerOwn = class(TCefBaseOwn, ICefPrintHandler)
  protected
    procedure OnPrintStart(const browser: ICefBrowser); virtual;
    procedure OnPrintSettings(settings: ICefPrintSettings; getDefaults: Boolean); virtual;
    function OnPrintDialog(hasSelection: Boolean; callback: ICefPrintDialogCallback): Boolean; virtual;
    function OnPrintJob(const documentName, pdfFilePath: ustring;
      callback: ICefPrintJobCallback): Boolean; virtual;
    procedure OnPrintReset; virtual;
    function GetPdfPaperSize(deviceUnitsPerInch: Integer): TCefSize; virtual;
  public
    constructor Create; virtual;
  end;

  TCefRenderHandlerOwn = class(TCefBaseOwn, ICefRenderHandler)
  protected
    function GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean; virtual;
    function GetScreenInfo(const browser: ICefBrowser; var screenInfo: TCefScreenInfo): Boolean; virtual;
    procedure OnPopupShow(const browser: ICefBrowser; show: Boolean); virtual;
    procedure OnPopupSize(const browser: ICefBrowser; const rect: PCefRect); virtual;
    procedure OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: TSize; const dirtyRects: TCefRectArray;
      const buffer: Pointer; width, height: Integer); virtual;
    procedure OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle; type_: TCefCursorType;
      const customCursorInfo: PCefCursorInfo); virtual;
    function StartDragging(const browser: ICefBrowser; const dragData: ICefDragData;
      allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean; virtual;
    procedure UpdateDragCursor(const browser: ICefBrowser; operation: TCefDragOperationsMask); virtual;
    procedure OnScrollOffsetChanged(const browser: ICefBrowser; x,y: Double); virtual;
    procedure OnImeCompositionRangeChanged(const browser: ICefBrowser;
      const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray); virtual;
  public
    constructor Create; virtual;
  end;

  TCefRenderProcessHandlerOwn = class(TCefBaseOwn, ICefRenderProcessHandler)
  protected
    procedure OnRenderThreadCreated(const ExtraInfo:ICefListValue); virtual;
    procedure OnWebKitInitialized; virtual;
    procedure OnBrowserCreated(const browser: ICefBrowser); virtual;
    procedure OnBrowserDestroyed(const browser: ICefBrowser); virtual;
    function GetLoadHandler: ICefLoadHandler; virtual;
    function OnBeforeNavigation(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const navigationType: TCefNavigationType;
      const isRedirect: Boolean): Boolean; virtual;
    procedure OnContextCreated(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefV8Context); virtual;
    procedure OnContextReleased(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefV8Context); virtual;
    procedure OnUncaughtException(const browser :ICefBrowser;
      const frame: ICefFrame; const context: ICefV8Context;
      const exception: ICefV8Exception; const stackTrace: ICefV8StackTrace); virtual;
    procedure OnFocusedNodeChanged(const browser: ICefBrowser;
      const frame: ICefFrame; const node: ICefDomNode); virtual;
    function OnProcessMessageReceived(const browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefPostDataElementOwn = class(TCefBaseOwn, ICefPostDataElement)
  private
    fDataType: TCefPostDataElementType;
    fValueByte: Pointer;
    fValueStr: TCefString;
    fSize: Cardinal;
    fReadOnly: Boolean;
    procedure Clear;
  protected
    function IsReadOnly: Boolean; virtual;
    procedure SetToEmpty; virtual;
    procedure SetToFile(const fileName: ustring); virtual;
    procedure SetToBytes(size: TSize; const bytes: Pointer); virtual;
    function GetType: TCefPostDataElementType; virtual;
    function GetFile: ustring; virtual;
    function GetBytesCount: TSize; virtual;
    function GetBytes(size: TSize; bytes: Pointer): TSize; virtual;
  public
    constructor Create(readonly: Boolean); virtual;
  end;

  TCefResolveCallbackOwn = class(TCefBaseOwn, ICefResolveCallback)
  protected
    procedure OnResolveCompleted(result: TCefErrorCode; resolvedIps: TStrings); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastResolveCallback = class(TCefResolveCallbackOwn)
  private
    fCallback: TCefResolveCallbackProc;
  protected
    procedure OnResolveCompleted(result: TCefErrorCode; resolvedIps: TStrings); override;
  public
    constructor Create(callback: TCefResolveCallbackProc); reintroduce; virtual;
  end;

  TCefRequestContextHandlerOwn = class(TCefBaseOwn, ICefRequestContextHandler)
  protected
    function GetCookieManager: ICefCookieManager; virtual;
    function OnBeforePluginLoad(const mimeType, pluginUrl: ustring; isMainFrame: Boolean;
      const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo; pluginPolicy: TCefPluginPolicy): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefRequestHandlerOwn = class(TCefBaseOwn, ICefRequestHandler)
  protected
    function OnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; isRedirect: Boolean): Boolean; virtual;
    function OnOpenUrlFromTab(browser: ICefBrowser; frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean): Boolean; virtual;
    function OnBeforeResourceLoad(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback): TCefReturnValue; virtual;
    function GetResourceHandler(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler; virtual;
    procedure OnResourceRedirect(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse; var newUrl: ustring); virtual;
    function OnResourceResponse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse): Boolean; virtual;
    function GetResourceResponseFilter(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse): ICefResponseFilter; virtual;
    procedure OnResourceLoadComplete(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse; status: TCefUrlRequestStatus;
      receivedContentLength: Int64); virtual;
    function GetAuthCredentials(const browser: ICefBrowser; const frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean; virtual;
    function OnQuotaRequest(const browser: ICefBrowser;
      const originUrl: ustring; newSize: Int64; const callback: ICefRequestCallback): Boolean; virtual;
    procedure OnProtocolExecution(const browser: ICefBrowser; const url: ustring;
      out allowOsExecution: Boolean); virtual;
    function OnCertificateError(const browser: ICefBrowser; certError: TCefErrorCode;
      const requestUrl: ustring; const sslInfo: ICefSslinfo; callback: ICefRequestCallback): Boolean; virtual;
    function OnSelectClientCertificate(const browser: ICefBrowser; isProxy: Boolean;
      const host: ustring; port: Integer; certificatesCount: TSize;
      certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback): Boolean; virtual;
    procedure OnPluginCrashed(const browser: ICefBrowser; const plugin_path: ustring); virtual;
    procedure OnRenderViewReady(browser: ICefBrowser); virtual;
    procedure OnRenderProcessTerminated(const browser: ICefBrowser; status: TCefTerminationStatus); virtual;
  public
    constructor Create; virtual;
  end;

  TCefResourceBundleHandlerOwn = class(TCefBaseOwn, ICefResourceBundleHandler)
  protected
    function GetLocalizedString(messageId: Integer;
      out stringVal: ustring): Boolean; virtual; abstract;
    function GetDataResource(resourceId: Integer; out data: Pointer;
      out dataSize: TSize): Boolean; virtual; abstract;
    function GetDataResourceForScale(resourceId: Integer; scaleFactor: TCefScaleFactor;
      out data: Pointer; out dataSize: TSize): Boolean; virtual; abstract;
  public
    constructor Create; virtual;
  end;

  TCefFastResourceBundle = class(TCefResourceBundleHandlerOwn)
  private
    fGetLocalizedString: TGetLocalizedString;
    fGetDataResource: TGetDataResource;
    fGetDataResourceForScale: TGetDataResourceForScale;
  protected
    function GetLocalizedString(messageId: Integer; out stringVal: ustring): Boolean; override;
    function GetDataResource(resourceId: Integer; out data: Pointer;
      out dataSize: TSize): Boolean; override;
    function GetDataResourceForScale(resourceId: Integer; scaleFactor: TCefScaleFactor;
      out data: Pointer; out dataSize: TSize): Boolean; override;
  public
    constructor Create(AGetLocalizedString: TGetLocalizedString; AGetDataResource: TGetDataResource;
      AGetDataResourceForScale: TGetDataResourceForScale); reintroduce;
  end;

  TCefResourceHandlerOwn = class(TCefBaseOwn, ICefResourceHandler)
  protected
    function ProcessRequest(const request: ICefRequest; const callback: ICefCallback): Boolean; virtual;
    procedure GetResponseHeaders(const response: ICefResponse;
      out responseLength: Int64; out redirectUrl: ustring); virtual;
    function ReadResponse(const dataOut: Pointer; bytesToRead: Integer;
      var bytesRead: Integer; const callback: ICefCallback): Boolean; virtual;
    function CanGetCookie(const cookie: PCefCookie): Boolean; virtual;
    function CanSetCookie(const cookie: PCefCookie): Boolean; virtual;
    procedure Cancel; virtual;
  public
    constructor Create(const browser: ICefBrowser; const frame: ICefFrame;
      const schemeName: ustring; const request: ICefRequest); virtual;
  end;

  TCefResourceHandlerClass = class of TCefResourceHandlerOwn;

  TCefResponseFilterOwn = class(TCefBaseOwn, ICefResponseFilter)
  protected
    function InitFilter: Boolean; virtual;
    function Filter(dataIn: Pointer; dataInSize: TSize; out dataInRead: TSize; dataOut: Pointer;
      dataOutSize: TSize; out dataOutWritten: TSize): TCefResponseFilterStatus; virtual; abstract;
  public
    constructor Create; virtual;
  end;

  TCefSchemeHandlerFactoryOwn = class(TCefBaseOwn, ICefSchemeHandlerFactory)
  private
    fClass: TCefResourceHandlerClass;
  protected
    function New(const browser: ICefBrowser; const frame: ICefFrame;
      const schemeName: ustring; const request: ICefRequest): ICefResourceHandler; virtual;
  public
    constructor Create(const AClass: TCefResourceHandlerClass); virtual;
  end;

  TCefReadHandlerOwn = class(TCefBaseOwn, ICefReadHandler)
  private
    fStream: TStream;
    fOwned: Boolean;
  protected
    function Read(ptr: Pointer; size, n: TSize): TSize; virtual;
    function Seek(offset: Int64; whence: Integer): Integer; virtual;
    function Tell: Int64; virtual;
    function Eof: Boolean; virtual;
    function MayBlock: Boolean; virtual;
  public
    constructor Create(Stream: TStream; Owned: Boolean); overload; virtual;
    constructor Create(const filename: String); overload; virtual;
    destructor Destroy; override;
  end;

  TCefWriteHandlerOwn = class(TCefBaseOwn, ICefWriteHandler)
  private
    fStream: TStream;
    fOwned: Boolean;
  protected
    function Write(const ptr: Pointer; size, n: TSize): TSize; virtual;
    function Seek(offset: Int64; whence: Integer): Integer; virtual;
    function Tell: Int64; virtual;
    function Flush: Boolean; virtual;
    function MayBlock: Boolean; virtual;
  public
    constructor Create(Stream: TStream; Owned: Boolean); overload; virtual;
    constructor Create(const filename: String); overload; virtual;
    destructor Destroy; override;
  end;

  TCefStringVisitorOwn = class(TCefBaseOwn, ICefStringVisitor)
  protected
    procedure Visit(const str: ustring); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastStringVisitor = class(TCefStringVisitorOwn, ICefStringVisitor)
  private
    fVisit: TCefStringVisitorProc;
  protected
    procedure Visit(const str: ustring); override;
  public
    constructor Create(const callback: TCefStringVisitorProc); reintroduce;
  end;

  TCefTaskOwn = class(TCefBaseOwn, ICefTask)
  protected
    procedure Execute; virtual;
  public
    constructor Create; virtual;
  end;

  TCefEndTracingCallbackOwn = class(TCefBaseOwn, ICefEndTracingCallback)
  protected
    procedure OnEndTracingComplete(const tracingFile: ustring); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastEndTracingCallback = class(TCefEndTracingCallbackOwn)
  private
    fCallback: TCefEndTracingCallbackProc;
  protected
    procedure OnEndTracingComplete(const tracingFile: ustring); override;
  public
    constructor Create(const callback: TCefEndTracingCallbackProc); reintroduce; virtual;
  end;

  TCefUrlrequestClientOwn = class(TCefBaseOwn, ICefUrlrequestClient)
  protected
    procedure OnRequestComplete(const request: ICefUrlRequest); virtual;
    procedure OnUploadProgress(const request: ICefUrlRequest; current, total: Int64); virtual;
    procedure OnDownloadProgress(const request: ICefUrlRequest; current, total: Int64); virtual;
    procedure OnDownloadData(const request: ICefUrlRequest; data: Pointer; dataLength: TSize); virtual;
    function GetAuthCredentials(isProxy: Boolean; const host: ustring; port: Integer;
      const realm, scheme: ustring; callback: ICefAuthCallback): Boolean; virtual;
  public
    constructor Create; virtual;
 end;

  TCefV8HandlerOwn = class(TCefBaseOwn, ICefV8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefV8Value;
      const arguments: ICefV8ValueArray; var retval: ICefV8Value;
      var exception: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefV8AccessorOwn = class(TCefBaseOwn, ICefV8Accessor)
  protected
    function Get(const name: ustring; const obj: ICefV8Value;
      out value: ICefV8Value; out exception: ustring): Boolean; virtual;
    function Put(const name: ustring; const obj, value: ICefV8Value;
      out exception: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefV8InterceptorOwn = class(TCefBaseOwn, ICefV8Interceptor)
  protected
    function GetByName(const name: ustring; const object_: ICefV8Value; var retval: ICefV8Value;
      out exception: ustring): Boolean; virtual;
    function GetByIndex(const index: Integer; const object_: ICefV8Value; var retval: ICefV8Value;
      out exception: ustring): Boolean; virtual;
    function SetByName(const name: ustring; const object_, value: ICefV8Value;
      out exception: ustring): Boolean; virtual;
    function SetByIndex(const index: Integer; const object_, value: ICefV8Value;
      out exception: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefWebPluginInfoVisitorOwn = class(TCefBaseOwn, ICefWebPluginInfoVisitor)
  protected
    function Visit(const info: ICefWebPluginInfo; count, total: Integer): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastWebPluginInfoVisitor = class(TCefWebPluginInfoVisitorOwn)
  private
    fProc: TCefWebPluginInfoVisitorProc;
  protected
    function Visit(const info: ICefWebPluginInfo; count, total: Integer): Boolean; override;
  public
    constructor Create(const proc: TCefWebPluginInfoVisitorProc); reintroduce;
  end;

  TCefWebPluginUnstableCallbackOwn = class(TCefBaseOwn, ICefWebPluginUnstableCallback)
  protected
    procedure IsUnstable(const path: ustring; unstable: Boolean); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastWebPluginUnstableCallback = class(TCefWebPluginUnstableCallbackOwn)
  private
    fCallback: TCefWebPluginIsUnstableProc;
  protected
    procedure IsUnstable(const path: ustring; unstable: Boolean); override;
  public
    constructor Create(const callback: TCefWebPluginIsUnstableProc); reintroduce;
  end;

  TCefRegisterCdmCallbackOwn = class(TCefBaseOwn, ICefRegisterCdmCallback)
  protected
    procedure OnCdmRegistration(result: TCefCdmRegistrationError; const errorMessage: ustring); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastRegisterCdmCallback = class(TCefRegisterCdmCallbackOwn)
  private
    fCallback: TCefRegisterCdmCallbackProc;
  protected
    procedure OnCdmRegistration(result: TCefCdmRegistrationError; const errorMessage: ustring); override;
  public
    constructor Create(const callback: TCefRegisterCdmCallbackProc); reintroduce; virtual;
  end;

  TCefStringMapOwn = class(TInterfacedObject, ICefStringMap)
  private
    fStringMap: TCefStringMap;
  protected
    function GetHandle: TCefStringMap; virtual;
    function GetSize: TSize; virtual;
    function Find(const key: ustring): ustring; virtual;
    function GetKey(index: TSize): ustring; virtual;
    function GetValue(index: TSize): ustring; virtual;
    procedure Append(const key, value: ustring); virtual;
    procedure Clear; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TCefStringMultimapOwn = class(TInterfacedObject, ICefStringMultimap)
  private
    fStringMap: TCefStringMultimap;
  protected
    function GetHandle: TCefStringMultimap; virtual;
    function GetSize: TSize; virtual;
    function FindCount(const Key: ustring): TSize; virtual;
    function GetEnumerate(const Key: ustring; ValueIndex: TSize): ustring; virtual;
    function GetKey(Index: TSize): ustring; virtual;
    function GetValue(Index: TSize): ustring; virtual;
    procedure Append(const Key, Value: ustring); virtual;
    procedure Clear; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;


(*
  TCefRTTIExtension = class(TCefV8HandlerOwn)
  private
    FValue: TValue;
    FCtx: TRttiContext;
    {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
    FSyncMainThread: Boolean;
    {$ENDIF}
    function GetValue(pi: PTypeInfo; const v: ICefV8Value; var ret: TValue): Boolean;
    function SetValue(const v: TValue; var ret: ICefV8Value): Boolean;
  protected
    function Execute(const name: ustring; const obj: ICefV8Value;
      const arguments: ICefV8ValueArray; var retval: ICefV8Value;
      var exception: ustring): Boolean; override;
  public
    constructor Create(const value: TValue{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}; SyncMainThread: Boolean{$ENDIF}); reintroduce;
    destructor Destroy; override;
    class procedure Register(const name: string; const value: TValue{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}; SyncMainThread: Boolean{$ENDIF});
  end;
*)

  ECefException = class(Exception)
  end;


Implementation

Uses cef3lib, cef3ref;

{ TCefBaseOwn }

procedure cef_base_add_ref(self: PCefBaseRefCounted); cconv;
begin
  TCefBaseOwn(CefGetObject(self))._AddRef;
end;

function cef_base_release(self: PCefBaseRefCounted): Integer; cconv;
begin
  Result := Ord(TCefBaseOwn(CefGetObject(self))._Release = 0);
end;

function cef_base_has_one_ref(self: PCefBaseRefCounted): Integer; cconv;
begin
  Result := Ord(TCefBaseOwn(CefGetObject(self)).RefCount = 1);
end;

procedure cef_base_add_ref_owned(self: PCefBaseRefCounted); cconv;
begin
  { empty }
end;

function cef_base_release_owned(self: PCefBaseRefCounted): Integer; cconv;
begin
  Result := 1;
end;

function cef_base_has_one_ref_owned(self: PCefBaseRefCounted): Integer; cconv;
begin
  Result := 1;
end;

function TCefBaseOwn.Wrap : Pointer;
begin
  Result := FData;
  If Assigned(PCefBaseRefCounted(FData)^.add_ref) then PCefBaseRefCounted(FData)^.add_ref(FData);
end;

constructor TCefBaseOwn.CreateData(size: TSize; owned: Boolean);
begin
  {$IFDEF DEBUG}
  DebugLn(Self.ClassName + '.CreateData; RefCount: ' + IntToStr(Self.RefCount));
  {$ENDIF}

  GetMem(fData, size + SizeOf(Pointer));
  PPointer(fData)^ := Self;
  Inc(fData, SizeOf(Pointer));
  FillChar(fData^, size, 0);
  PCefBaseRefCounted(fData)^.size := size;

  If owned then
  begin
    PCefBaseRefCounted(fData)^.add_ref := @cef_base_add_ref_owned;
    PCefBaseRefCounted(fData)^.release := @cef_base_release_owned;
    PCefBaseRefCounted(fData)^.has_one_ref := @cef_base_has_one_ref_owned;
  end
  Else
  begin
    PCefBaseRefCounted(fData)^.add_ref := @cef_base_add_ref;
    PCefBaseRefCounted(fData)^.release := @cef_base_release;
    PCefBaseRefCounted(fData)^.has_one_ref := @cef_base_has_one_ref;
  end;
end;

destructor TCefBaseOwn.Destroy;
begin
  {$IFDEF DEBUG}
  DebugLn(Self.ClassName + '.Destroy; RefCount: ' + IntToStr(Self.RefCount));
  {$ENDIF}

  Dec(fData, SizeOf(Pointer));
  FreeMem(fData);

  inherited;
end;

{ TCefAppOwn }

procedure cef_app_on_before_command_line_processing(self: PCefApp; const process_type: PCefString;
  command_line: PCefCommandLine); cconv;
begin
  With TCefAppOwn(CefGetObject(self)) do
    OnBeforeCommandLineProcessing(CefString(process_type), TCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_app_on_register_custom_schemes(self: PCefApp; registrar: PCefSchemeRegistrar); cconv;
Var
  r: TCefSchemeRegistrarRef;
begin
  try
    r := TCefSchemeRegistrarRef.Create(registrar);
    TCefAppOwn(CefGetObject(self)).OnRegisterCustomSchemes(r);
  finally
    FreeAndNil(r);
  end;
end;

function cef_app_get_resource_bundle_handler(self: PCefApp): PCefResourceBundleHandler; cconv;
begin
  Result := CefGetData(TCefAppOwn(CefGetObject(self)).GetResourceBundleHandler());
end;

function cef_app_get_browser_process_handler(self: PCefApp): PCefBrowserProcessHandler; cconv;
begin
  Result := CefGetData(TCefAppOwn(CefGetObject(self)).GetBrowserProcessHandler());
end;

function cef_app_get_render_process_handler(self: PCefApp): PCefRenderProcessHandler; cconv;
begin
  Result := CefGetData(TCefAppOwn(CefGetObject(self)).GetRenderProcessHandler());
end;

constructor TCefAppOwn.Create;
begin
  inherited CreateData(SizeOf(TCefApp));
  With PCefApp(FData)^ do
  begin
    on_before_command_line_processing := @cef_app_on_before_command_line_processing;
    on_register_custom_schemes := @cef_app_on_register_custom_schemes;
    get_resource_bundle_handler := @cef_app_get_resource_bundle_handler;
    get_browser_process_handler := @cef_app_get_browser_process_handler;
    get_render_process_handler := @cef_app_get_render_process_handler;
  end;
end;

{ TInternalApp }

procedure TInternalApp.OnBeforeCommandLineProcessing(const processType: ustring;
  const commandLine: ICefCommandLine);
begin
  If Assigned(CefOnBeforeCommandLineProcessing) then
    CefOnBeforeCommandLineProcessing(processType, commandLine);
end;

procedure TInternalApp.OnRegisterCustomSchemes(const registrar: TCefSchemeRegistrarRef);
begin
  If Assigned(CefOnRegisterCustomSchemes) then CefOnRegisterCustomSchemes(registrar);
end;

function TInternalApp.GetResourceBundleHandler: ICefResourceBundleHandler;
begin
  Result := CefResourceBundleHandler;
end;

function TInternalApp.GetBrowserProcessHandler: ICefBrowserProcessHandler;
begin
  Result := CefBrowserProcessHandler;
end;

function TInternalApp.GetRenderProcessHandler: ICefRenderProcessHandler;
begin
  Result := CefRenderProcessHandler;
end;

{ TCefRunFileDialogCallbackOwn }

procedure cef_run_file_dialog_callback_on_file_dialog_dismissed(self: PCefRunFileDialogCallback;
  selected_accept_filter: Integer; file_paths: TCefStringList); cconv;
Var
  list: TStringList;
  item : TCefString;
  i: Integer;
begin
  try
    If Assigned(file_paths) then
    begin
      list := TStringList.Create;
      For i := 0 to cef_string_list_size(file_paths) - 1 do
      begin
        FillChar(item, SizeOf(item), 0);
        cef_string_list_value(file_paths, i, @item);
        list.Add(CefStringClearAndGet(item));
      end;
    end
    Else list := nil;

    TCefRunFileDialogCallbackOwn(CefGetObject(self)).
      OnFileDialogDismissed(selected_accept_filter, list);

  finally
    list.Free;
  end;
end;

procedure TCefRunFileDialogCallbackOwn.OnFileDialogDismissed(selectedAcceptFilter: Integer;
  filePaths: TStrings);
begin
  { empty }
end;

constructor TCefRunFileDialogCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRunFileDialogCallback));
  With PCefRunFileDialogCallback(FData)^ do
  begin
    on_file_dialog_dismissed := @cef_run_file_dialog_callback_on_file_dialog_dismissed;
  end;
end;

{ TCefFastRunFileDialogCallback }

procedure TCefFastRunFileDialogCallback.OnFileDialogDismissed(selectedAcceptFilter: Integer; filePaths: TStrings);
begin
  fCallback(selectedAcceptFilter, filePaths);
end;

constructor TCefFastRunFileDialogCallback.Create(callback: TCefRunFileDialogCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefNavigationEntryVisitorOwn }

function cef_navigation_entry_visitor_visit(self: PCefNavigationEntryVisitor;
  entry: PCefNavigationEntry; current, index, total: Integer): Integer; cconv;
begin
  Result := Ord(
    TCefNavigationEntryVisitorOwn(CefGetObject(self)).Visit(TCefNavigationEntryRef.UnWrap(entry),
      current <> 0, index, total)
  );
end;

function TCefNavigationEntryVisitorOwn.Visit(entry: ICefNavigationEntry;
  current: Boolean; index, total: Integer): Boolean;
begin
  Result := False;
end;

constructor TCefNavigationEntryVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefNavigationEntryVisitor));
  With PCefNavigationEntryVisitor(fData)^ do
  begin
    visit := @cef_navigation_entry_visitor_visit;
  end;
end;

{ TCefFastNavigationEntryVisitor }

function TCefFastNavigationEntryVisitor.Visit(entry: ICefNavigationEntry; current: Boolean;
  index, total: Integer): Boolean;
begin
  Result := fVisitor(entry, current, index, total);
end;

constructor TCefFastNavigationEntryVisitor.Create(visitor: TCefNavigationEntryVisitorProc);
begin
  inherited Create;
  fVisitor := Visitor;
end;

{ TCefPdfPrintCallbackOwn }

procedure cef_pdf_print_callback_on_pdf_print_finished(self: PCefPdfPrintCallback;
  const path: PCefString; ok: Integer); cconv;
begin
  TCefPdfPrintCallbackOwn(CefGetObject(self)).OnPdfPrintFinished(CefString(path), ok <> 0);
end;

procedure TCefPdfPrintCallbackOwn.OnPdfPrintFinished(const path: ustring; ok: Boolean);
begin
  { empty }
end;

constructor TCefPdfPrintCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefPdfPrintCallback));
  With PCefPdfPrintCallback(fData)^ do
  begin
    on_pdf_print_finished := @cef_pdf_print_callback_on_pdf_print_finished;
  end;
end;

{ TCefFastPdfPrintCallback }

procedure TCefFastPdfPrintCallback.OnPdfPrintFinished(const path: ustring; ok: Boolean);
begin
  fCallback(path, ok);
end;

constructor TCefFastPdfPrintCallback.Create(callback: TCefPdfPrintCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefDownloadImageCallbackOwn }

procedure cef_download_image_callback_on_download_image_finished(self: PCefDownloadImageCallback;
  const image_url: PCefString; http_status_code: Integer; image: PCefImage); cconv;
begin
  TCefDownloadImageCallbackOwn(CefGetObject(self)).
    OnDownloadImageFinished(CefString(image_url), http_status_code, TCefImageRef.UnWrap(image));
end;

procedure TCefDownloadImageCallbackOwn.OnDownloadImageFinished(const imageUrl: ustring;
  httpStatusCode: Integer; image: ICefImage);
begin
  { empty }
end;

constructor TCefDownloadImageCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDownloadImageCallback));
  With PCefDownloadImageCallback(fData)^ do
  begin
    on_download_image_finished := @cef_download_image_callback_on_download_image_finished;
  end;
end;

{ TCefFastDownloadImageCallback }

procedure TCefFastDownloadImageCallback.OnDownloadImageFinished(const imageUrl: ustring;
  httpStatusCode: Integer; image: ICefImage);
begin
  fCallback(imageUrl, httpStatusCode, image);
end;

constructor TCefFastDownloadImageCallback.Create(callback: TCefDownloadImageCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefBrowserProcessHandlerOwn }

procedure cef_browser_process_handler_on_context_initialized(self: PCefBrowserProcessHandler); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).OnContextInitialized;
end;

procedure cef_browser_process_handler_on_before_child_process_launch(
  self: PCefBrowserProcessHandler; command_line: PCefCommandLine); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).
    OnBeforeChildProcessLaunch(TCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_browser_process_handler_on_render_process_thread_created(self: PCefBrowserProcessHandler;
  extra_info: PCefListValue); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).
    OnRenderProcessThreadCreated(TCefListValueRef.UnWrap(extra_info));
end;

function cef_browser_process_handler_get_print_handler(self: PCefBrowserProcessHandler): PCefPrintHandler; cconv;
begin
  Result := CefGetData(TCefBrowserProcessHandlerOwn(CefGetObject(self)).GetPrintHandler());
end;

procedure cef_browser_process_handler_on_schedule_message_pump_work(self: PCefBrowserProcessHandler;
  delay_ms: Int64); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).OnScheduleMessagePumpWork(delay_ms);
end;

procedure TCefBrowserProcessHandlerOwn.OnContextInitialized;
begin
  { empty }
end;

procedure TCefBrowserProcessHandlerOwn.OnBeforeChildProcessLaunch(const commandLine: ICefCommandLine);
begin
  { empty }
end;

procedure TCefBrowserProcessHandlerOwn.OnRenderProcessThreadCreated(extraInfo: ICefListValue);
begin
  { empty }
end;

function TCefBrowserProcessHandlerOwn.GetPrintHandler: ICefPrintHandler;
begin
  Result := nil;
end;

procedure TCefBrowserProcessHandlerOwn.OnScheduleMessagePumpWork(delayMs: Int64);
begin
  { empty }
end;

constructor TCefBrowserProcessHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefBrowserProcessHandler));
  With PCefBrowserProcessHandler(FData)^ do
  begin
    on_context_initialized := @cef_browser_process_handler_on_context_initialized;
    on_before_child_process_launch := @cef_browser_process_handler_on_before_child_process_launch;
    on_render_process_thread_created := @cef_browser_process_handler_on_render_process_thread_created;
    get_print_handler := @cef_browser_process_handler_get_print_handler;
    on_schedule_message_pump_work := @cef_browser_process_handler_on_schedule_message_pump_work;
  end;
end;

{ TCefCompletionCallbackOwn }

procedure cef_completion_callback_on_complete(self: PCefCompletionCallback); cconv;
begin
  TCefCompletionCallbackOwn(CefGetObject(self)).OnComplete;
end;

procedure TCefCompletionCallbackOwn.OnComplete;
begin
  { empty }
end;

constructor TCefCompletionCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefCompletionCallback));
  With PCefCompletionCallback(fData)^ do
  begin
    on_complete := @cef_completion_callback_on_complete;
  end;
end;

{ TCefFastCompletionCallback }

procedure TCefFastCompletionCallback.OnComplete;
begin
  fCallback;
end;

constructor TCefFastCompletionCallback.Create(callback: TCefCompletionCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefClientOwn }

function cef_client_get_context_menu_handler(self: PCefClient): PCefContextMenuHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetContextMenuHandler);
end;

function cef_client_get_dialog_handler(self: PCefClient): PCefDialogHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetDialogHandler);
end;

function cef_client_get_display_handler(self: PCefClient): PCefDisplayHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetDisplayHandler);
end;

function cef_client_get_download_handler(self: PCefClient): PCefDownloadHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetDownloadHandler);
end;

function cef_client_get_drag_handler(self: PCefClient): PCefDragHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetDragHandler);
end;

function cef_client_get_find_handler(self: PCefClient): PCefFindHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetFindHandler);
end;

function cef_client_get_focus_handler(self: PCefClient): PCefFocusHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetFocusHandler);
end;

function cef_client_get_geolocation_handler(self: PCefClient): PCefGeolocationHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetGeolocationHandler);
end;

function cef_client_get_jsdialog_handler(self: PCefClient): PCefJsDialogHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetJsdialogHandler);
end;

function cef_client_get_keyboard_handler(self: PCefClient): PCefKeyboardHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetKeyboardHandler);
end;

function cef_client_get_life_span_handler(self: PCefClient): PCefLifeSpanHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetLifeSpanHandler);
end;

function cef_client_get_load_handler(self: PCefClient): PCefLoadHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetLoadHandler);
end;

function cef_client_get_render_handler(self: PCefClient): PCefRenderHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetRenderHandler);
end;

function cef_client_get_request_handler(self: PCefClient): PCefRequestHandler; cconv;
begin
  Result := CefGetData(TCefClientOwn(CefGetObject(self)).GetRequestHandler);
end;

function cef_client_on_process_message_received(self: PCefClient; browser: PCefBrowser;
  source_process: TCefProcessId; message: PCefProcessMessage): Integer; cconv;
begin
  Result := Ord(TCefClientOwn(CefGetObject(self)).
    OnProcessMessageReceived(TCefBrowserRef.UnWrap(browser), source_process,
      TCefProcessMessageRef.UnWrap(message)));
end;

function TCefClientOwn.GetContextMenuHandler: ICefContextMenuHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDialogHandler: ICefDialogHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDisplayHandler: ICefDisplayHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDownloadHandler: ICefDownloadHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDragHandler: ICefDragHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetFindHandler: ICefFindHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetFocusHandler: ICefFocusHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetGeolocationHandler: ICefGeolocationHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetJsdialogHandler: ICefJsdialogHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetKeyboardHandler: ICefKeyboardHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetLifeSpanHandler: ICefLifeSpanHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetLoadHandler: ICefLoadHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetRenderHandler: ICefRenderHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetRequestHandler: ICefRequestHandler;
begin
  Result := nil;
end;

function TCefClientOwn.OnProcessMessageReceived(const browser: ICefBrowser;
  sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean;
begin
  Result := False;
end;

constructor TCefClientOwn.Create;
begin
  inherited CreateData(SizeOf(TCefClient));
  With PCefClient(FData)^ do
  begin
    get_context_menu_handler := @cef_client_get_context_menu_handler;
    get_dialog_handler := @cef_client_get_dialog_handler;
    get_display_handler := @cef_client_get_display_handler;
    get_download_handler := @cef_client_get_download_handler;
    get_drag_handler := @cef_client_get_drag_handler;
    get_find_handler := @cef_client_get_find_handler;
    get_focus_handler := @cef_client_get_focus_handler;
    get_geolocation_handler := @cef_client_get_geolocation_handler;
    get_jsdialog_handler := @cef_client_get_jsdialog_handler;
    get_keyboard_handler := @cef_client_get_keyboard_handler;
    get_life_span_handler := @cef_client_get_life_span_handler;
    get_load_handler := @cef_client_get_load_handler;
    get_render_handler := @cef_client_get_render_handler;
    get_request_handler := @cef_client_get_request_handler;
    on_process_message_received := @cef_client_on_process_message_received;
  end;
end;

{ TCefContextMenuHandlerOwn }

procedure cef_context_menu_handler_on_before_context_menu(self: PCefContextMenuHandler;
  browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams; model: PCefMenuModel); cconv;
begin
  TCefContextMenuHandlerOwn(CefGetObject(self)).
    OnBeforeContextMenu(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), TCefMenuModelRef.UnWrap(model));
end;

function cef_context_menu_handler_run_context_menu(self: PCefContextMenuHandler; browser: PCefBrowser;
  frame: PCefFrame; params: PCefContextMenuParams; model: PCefMenuModel;
  callback: PCefRunContextMenuCallback): Integer; cconv;
begin
  Result := Ord(TCefContextMenuHandlerOwn(CefGetObject(self)).
    RunContextMenu(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), TCefMenuModelRef.UnWrap(model),
      TCefRunContextMenuCallbackRef.UnWrap(callback)));
end;

function cef_context_menu_handler_on_context_menu_command(self: PCefContextMenuHandler;
  browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
  command_id: Integer; event_flags: TCefEventFlags): Integer; cconv;
begin
  Result := Ord(TCefContextMenuHandlerOwn(CefGetObject(self)).
    OnContextMenuCommand(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), command_id, TCefEventFlags(Pointer(@event_flags)^)));
end;

procedure cef_context_menu_handler_on_context_menu_dismissed(self: PCefContextMenuHandler;
  browser: PCefBrowser; frame: PCefFrame); cconv;
begin
  TCefContextMenuHandlerOwn(CefGetObject(self)).
    OnContextMenuDismissed(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame));
end;

procedure TCefContextMenuHandlerOwn.OnBeforeContextMenu(const browser: ICefBrowser;
  const frame: ICefFrame; const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  { empty }
end;

function TCefContextMenuHandlerOwn.RunContextMenu(const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel;
  const callback: ICefRunContextMenuCallback): Boolean;
begin
  Result := False;
end;

function TCefContextMenuHandlerOwn.OnContextMenuCommand(const browser: ICefBrowser;
  const frame: ICefFrame; const params: ICefContextMenuParams;
  commandId: Integer; eventFlags: TCefEventFlags): Boolean;
begin
  Result := False;
end;

procedure TCefContextMenuHandlerOwn.OnContextMenuDismissed(const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  { empty }
end;

constructor TCefContextMenuHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefContextMenuHandler));
  With PCefContextMenuHandler(fData)^ do
  begin
    on_before_context_menu := @cef_context_menu_handler_on_before_context_menu;
    run_context_menu := @cef_context_menu_handler_run_context_menu;
    on_context_menu_command := @cef_context_menu_handler_on_context_menu_command;
    on_context_menu_dismissed := @cef_context_menu_handler_on_context_menu_dismissed;
  end;
end;

{ TCefCookieVisitorOwn }

function cef_cookie_visitor_visit(self: PCefCookieVisitor; const cookie: PCefCookie;
  count, total: Integer; deleteCookie: PInteger): Integer; cconv;
Var
  delete: Boolean;
begin
  delete := False;
  Result := Ord(TCefCookieVisitorOwn(CefGetObject(self)).Visit(cookie^, count, total, delete));
  deleteCookie^ := Ord(delete);
end;

function TCefCookieVisitorOwn.Visit(const cookie: TCefCookie; count, total: Integer;
  out deleteCookie: Boolean): Boolean;
begin
  Result := True;
end;

constructor TCefCookieVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefCookieVisitor));
  With PCefCookieVisitor(fData)^ do
  begin
    visit := @cef_cookie_visitor_visit;
  end;
end;

{ TCefFastCookieVisitor }

function TCefFastCookieVisitor.Visit(const cookie: TCefCookie; count, total: Integer;
  out deleteCookie: Boolean): Boolean;
begin
  Result := fVisitor(cookie, count, total, deleteCookie);
end;

constructor TCefFastCookieVisitor.Create(const visitor : TCefCookieVisitorProc);
begin
  inherited Create;
  fVisitor := visitor;
end;

{ TCefSetCookieCallbackOwn }

procedure cef_set_cookie_callback_on_complete(self: PCefSetCookieCallback; success: Integer); cconv;
begin
  TCefSetCookieCallbackOwn(CefGetObject(self)).OnComplete(success <> 0);
end;

procedure TCefSetCookieCallbackOwn.OnComplete(success: Boolean);
begin
  { empty }
end;

constructor TCefSetCookieCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefSetCookieCallback));
  With PCefSetCookieCallback(fData)^ do
  begin
    on_complete := @cef_set_cookie_callback_on_complete;
  end;
end;

{ TCefFastSetCookieCallback }

procedure TCefFastSetCookieCallback.OnComplete(success: Boolean);
begin
  fCallback(success);
end;

constructor TCefFastSetCookieCallback.Create(const callback: TCefSetCookieCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefDeleteCookiesCallbackOwn }

procedure cef_delete_cookies_callback_on_complete(self: PCefDeleteCookiesCallback;
  num_deleted: Integer); cconv;
begin
  TCefDeleteCookiesCallbackOwn(CefGetObject(self)).OnComplete(num_deleted);
end;

procedure TCefDeleteCookiesCallbackOwn.OnComplete(numDeleted: Integer);
begin
  { empty }
end;

constructor TCefDeleteCookiesCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDeleteCookiesCallback));
  With PCefDeleteCookiesCallback(fData)^ do
  begin
    on_complete := @cef_delete_cookies_callback_on_complete;
  end;
end;

{ TCefFastDeleteCookiesCallback }

procedure TCefFastDeleteCookiesCallback.OnComplete(numDeleted: Integer);
begin
  fCallback(numDeleted);
end;

constructor TCefFastDeleteCookiesCallback.Create(const callback: TCefDeleteCookiesCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefDialogHandlerOwn }

function cef_dialog_handler_on_file_dialog(self: PCefDialogHandler; browser: PCefBrowser;
  mode: TCefFileDialogMode; const title, default_file_path: PCefString; accept_filters: TCefStringList;
  selected_accept_filter: Integer; callback: PCefFileDialogCallback): Integer; cconv;
Var
  list : TStringList;
  i    : Integer;
  item : TCefString;
begin
  list := TStringList.Create;
  try
    For i := 0 to cef_string_list_size(accept_filters) - 1 do
    begin
      FillChar(item, SizeOf(item), 0);
      cef_string_list_value(accept_filters, i, @item);
      list.Add(CefStringClearAndGet(item));
    end;

    With TCefDialogHandlerOwn(CefGetObject(self)) do
      Result := Ord(OnFileDialog(TCefBrowserRef.UnWrap(browser), mode, CefString(title),
        CefString(default_file_path), list, selected_accept_filter, TCefFileDialogCallbackRef.UnWrap(callback)));
  finally
    list.Free;
  end;
end;

function TCefDialogHandlerOwn.OnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
  const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
  const callback: ICefFileDialogCallback): Boolean;
begin
  Result := False;
end;

constructor TCefDialogHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDialogHandler));
  With PCefDialogHandler(FData)^ do
  begin
    on_file_dialog := @cef_dialog_handler_on_file_dialog;
  end;
end;

{ TCefDisplayHandlerOwn }

procedure cef_display_handler_on_address_change(self: PCefDisplayHandler; browser: PCefBrowser;
  frame: PCefFrame; const url: PCefString); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnAddressChange(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      CefString(url)
    );
end;

procedure cef_display_handler_on_title_change(self: PCefDisplayHandler; browser: PCefBrowser;
  const title: PCefString); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnTitleChange(TCefBrowserRef.UnWrap(browser), CefString(title));
end;

procedure cef_display_handler_on_favicon_urlchange(self: PCefDisplayHandler; browser: PCefBrowser;
  icon_urls: TCefStringList); cconv;
Var
  list: TStringList;
  item: TCefString;
  i: Integer;
begin
  list := TStringList.Create;
  try
    For i := 0 to cef_string_list_size(icon_urls) - 1 do
    begin
      FillChar(item, SizeOf(item), 0);
      cef_string_list_value(icon_urls, i, @item);
      list.Add(CefStringClearAndGet(item));
    end;

    With TCefDisplayHandlerOwn(CefGetObject(self)) do
      OnFaviconUrlchange(TCefBrowserRef.UnWrap(browser), list);
  finally
    list.Free;
  end;
end;

procedure cef_display_handler_on_fullscreen_mode_change(self: PCefDisplayHandler; browser: PCefBrowser;
  fullscreen: Integer); cconv;
begin
  TCefDisplayHandlerOwn(CefGetObject(self)).
    OnFullscreenModeChange(TCefBrowserRef.UnWrap(browser), fullscreen <> 0);
end;

function cef_display_handler_on_tooltip(self: PCefDisplayHandler; browser: PCefBrowser;
  text: PCefString): Integer; cconv;
Var
  t: ustring;
begin
  t := CefString(text);
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnTooltip(TCefBrowserRef.UnWrap(browser), t));
  CefStringSet(text, t);
end;

procedure cef_display_handler_on_status_message(self: PCefDisplayHandler; browser: PCefBrowser;
  const value: PCefString); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnStatusMessage(TCefBrowserRef.UnWrap(browser), CefString(value));
end;

function cef_display_handler_on_console_message(self: PCefDisplayHandler; browser: PCefBrowser;
  const message: PCefString; const source: PCefString; line: Integer): Integer; cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnConsoleMessage(TCefBrowserRef.UnWrap(browser),
    CefString(message), CefString(source), line));
end;

procedure TCefDisplayHandlerOwn.OnAddressChange(const browser: ICefBrowser; const frame: ICefFrame;
  const url: ustring);
begin
  { empty }
end;

procedure TCefDisplayHandlerOwn.OnTitleChange(const browser: ICefBrowser; const title: ustring);
begin
  { empty }
end;

procedure TCefDisplayHandlerOwn.OnFaviconUrlchange(const browser: ICefBrowser; iconUrls: TStrings);
begin
  { empty }
end;

procedure TCefDisplayHandlerOwn.OnFullscreenModeChange(const browser: ICefBrowser; fullscreen: Boolean);
begin
  { empty }
end;

function TCefDisplayHandlerOwn.OnTooltip(const browser: ICefBrowser; var text: ustring): Boolean;
begin
  Result := False
end;

procedure TCefDisplayHandlerOwn.OnStatusMessage(const browser: ICefBrowser; const value: ustring);
begin
  { empty }
end;

function TCefDisplayHandlerOwn.OnConsoleMessage(const browser: ICefBrowser;
  const message, source: ustring; line: Integer): Boolean;
begin
  Result := False
end;

constructor TCefDisplayHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDisplayHandler));
  With PCefDisplayHandler(FData)^ do
  begin
    on_address_change := @cef_display_handler_on_address_change;
    on_title_change := @cef_display_handler_on_title_change;
    on_favicon_urlchange := @cef_display_handler_on_favicon_urlchange;
    on_fullscreen_mode_change := @cef_display_handler_on_fullscreen_mode_change;
    on_tooltip := @cef_display_handler_on_tooltip;
    on_status_message := @cef_display_handler_on_status_message;
    on_console_message := @cef_display_handler_on_console_message;
  end;
end;

{ TCefDomVisitorOwn }

procedure cef_dom_visitor_visit(self: PCefDomVisitor; document: PCefDomDocument); cconv;
begin
  TCefDomVisitorOwn(CefGetObject(self)).Visit(TCefDomDocumentRef.UnWrap(document));
end;

procedure TCefDomVisitorOwn.Visit(const document: ICefDomDocument);
begin
  { empty }
end;

constructor TCefDomVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDomVisitor));
  With PCefDomVisitor(FData)^ do
  begin
    visit := @cef_dom_visitor_visit;
  end;
end;

{ TCefFastDomVisitor }

procedure TCefFastDomVisitor.Visit(const document: ICefDomDocument);
begin
  fProc(document);
end;

constructor TCefFastDomVisitor.Create(const proc: TCefDomVisitorProc);
begin
  inherited Create;
  fProc := proc;
end;

{ TCefDownloadHandlerOwn }

procedure cef_download_handler_on_before_download(self: PCefDownloadHandler; browser: PCefBrowser;
  download_item: PCefDownloadItem; const suggested_name: PCefString; callback: PCefBeforeDownloadCallback); cconv;
begin
  TCefDownloadHandlerOwn(CefGetObject(self)).
    OnBeforeDownload(TCefBrowserRef.UnWrap(browser),
    TCefDownLoadItemRef.UnWrap(download_item), CefString(suggested_name),
    TCefBeforeDownloadCallbackRef.UnWrap(callback));
end;

procedure cef_download_handler_on_download_updated(self: PCefDownloadHandler; browser: PCefBrowser;
  download_item: PCefDownloadItem; callback: PCefDownloadItemCallback); cconv;
begin
  TCefDownloadHandlerOwn(
    CefGetObject(self)).OnDownloadUpdated(TCefBrowserRef.UnWrap(browser),
    TCefDownLoadItemRef.UnWrap(download_item),
    TCefDownloadItemCallbackRef.UnWrap(callback)
  );
end;

procedure TCefDownloadHandlerOwn.OnBeforeDownload(const browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
begin
  { empty }
end;

procedure TCefDownloadHandlerOwn.OnDownloadUpdated(const browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const callback: ICefDownloadItemCallback);
begin
  { empty }
end;

constructor TCefDownloadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDownloadHandler));
  With PCefDownloadHandler(FData)^ do
  begin
    on_before_download := @cef_download_handler_on_before_download;
    on_download_updated := @cef_download_handler_on_download_updated;
  end;
end;

{ TCefDragHandlerOwn }

function cef_drag_handler_on_drag_enter(self: PCefDragHandler; browser: PCefBrowser;
  dragData: PCefDragData; mask: TCefDragOperationsMask): Integer; cconv;
begin
  Result := Ord(TCefDragHandlerOwn(CefGetObject(self)).OnDragEnter(
    TCefBrowserRef.UnWrap(browser), TCefDragDataRef.UnWrap(dragData), mask));
end;

procedure cef_drag_handler_on_draggable_regions_changed(self: PCefDragHandler; browser: PCefBrowser;
  regionsCount: TSize; regions: PCefDraggableRegionArray); cconv;
begin
  TCefDragHandlerOwn(CefGetObject(self)).OnDraggableRegionsChanged(TCefBrowserRef.UnWrap(browser),
    regionsCount, regions^);
end;

function TCefDragHandlerOwn.OnDragEnter(const browser: ICefBrowser; const dragData: ICefDragData;
  mask: TCefDragOperationsMask): Boolean;
begin
  Result := False;
end;

procedure TCefDragHandlerOwn.OnDraggableRegionsChanged(browser: ICefBrowser; regionsCount: TSize;
  const regions: TCefDraggableRegionArray);
begin
  { empty }
end;

constructor TCefDragHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDragHandler));
  With PCefDragHandler(FData)^ do
  begin
    on_drag_enter := @cef_drag_handler_on_drag_enter;
    on_draggable_regions_changed := @cef_drag_handler_on_draggable_regions_changed;
  end;
end;

{ TCefFindHandlerOwn }

procedure cef_find_handler_on_find_result(self: PCefFindHandler; browser: PCefBrowser;
  identifier, count: Integer; const selectionRect: PCefRect; activeMatchOrdinal, finalUpdate: Integer); cconv;
begin
  TCefFindHandlerOwn(CefGetObject(self)).
    OnFindResult(TCefBrowserRef.UnWrap(browser), identifier, count, selectionRect^, activeMatchOrdinal,
      finalUpdate <> 0);
end;

procedure TCefFindHandlerOwn.OnFindResult(browser: ICefBrowser; identifier, count: Integer;
  const selectionRect: TCefRect; activeMatchOridinal: Integer; finalUpdate: Boolean);
begin
  { empty }
end;

constructor TCefFindHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefFindHandler));
  With PCefFindHandler(FData)^ do
  begin
    on_find_result := @cef_find_handler_on_find_result;
  end;
end;

{ TCefFocusHandlerOwn }

procedure cef_focus_handler_on_take_focus(self: PCefFocusHandler; browser: PCefBrowser; next: Integer); cconv;
begin
  TCefFocusHandlerOwn(CefGetObject(self)).OnTakeFocus(TCefBrowserRef.UnWrap(browser), next <> 0);
end;

function cef_focus_handler_on_set_focus(self: PCefFocusHandler; browser: PCefBrowser;
  source: TCefFocusSource): Integer; cconv;
begin
  Result := Ord(TCefFocusHandlerOwn(CefGetObject(self)).
    OnSetFocus(TCefBrowserRef.UnWrap(browser), source));
end;

procedure cef_focus_handler_on_got_focus(self: PCefFocusHandler; browser: PCefBrowser); cconv;
begin
  TCefFocusHandlerOwn(CefGetObject(self)).OnGotFocus(TCefBrowserRef.UnWrap(browser));
end;

procedure TCefFocusHandlerOwn.OnTakeFocus(const browser: ICefBrowser; next: Boolean);
begin
  { empty }
end;

function TCefFocusHandlerOwn.OnSetFocus(const browser: ICefBrowser; source: TCefFocusSource): Boolean;
begin
  Result := False;
end;

procedure TCefFocusHandlerOwn.OnGotFocus(const browser: ICefBrowser);
begin
  { empty }
end;

constructor TCefFocusHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefFocusHandler));
  With PCefFocusHandler(FData)^ do
  begin
    on_take_focus := @cef_focus_handler_on_take_focus;
    on_set_focus := @cef_focus_handler_on_set_focus;
    on_got_focus := @cef_focus_handler_on_got_focus;
  end;
end;

{ TCefGetGeolocationCallbackOwn }

procedure cef_get_geolocation_callback_on_location_update(self: PCefGetGeolocationCallback;
  const position: PCefGeoposition); cconv;
begin
  TCefGetGeolocationCallbackOwn(CefGetObject(self)).OnLocationUpdate(position^);
end;

procedure TCefGetGeolocationCallbackOwn.OnLocationUpdate(const position: TCefGeoposition);
begin
  { empty }
end;

constructor TCefGetGeolocationCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefGetGeolocationCallback));
  With PCefGetGeolocationCallback(FData)^ do
  begin
    on_location_update := @cef_get_geolocation_callback_on_location_update;
  end;
end;

{ TCefFastGetGeolocationCallback }

procedure TCefFastGetGeolocationCallback.OnLocationUpdate(const position: TCefGeoposition);
begin
  fCallback(position);
end;

constructor TCefFastGetGeolocationCallback.Create(callback: TCefGetGeolocationCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefGeolocationHandlerOwn }

function cef_geolocation_handler_on_request_geolocation_permission(self: PCefGeolocationHandler;
  browser: PCefBrowser; const requesting_url: PCefString; request_id: Integer;
  callback: PCefGeolocationCallback): Integer; cconv;
begin
  Result := Ord(TCefGeolocationHandlerOwn(CefGetObject(self)).
    OnRequestGeolocationPermission(TCefBrowserRef.UnWrap(browser), CefString(requesting_url),
      request_id, TCefGeolocationCallbackRef.UnWrap(callback)));
end;

procedure cef_geolocation_handler_on_cancel_geolocation_permission(self: PCefGeolocationHandler;
  browser: PCefBrowser; request_id: Integer); cconv;
begin
  TCefGeolocationHandlerOwn(CefGetObject(self)).
    OnCancelGeolocationPermission(TCefBrowserRef.UnWrap(browser), request_id);
end;

function TCefGeolocationHandlerOwn.OnRequestGeolocationPermission(const browser: ICefBrowser;
  const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback): Boolean;
begin
  Result := False;
end;

procedure TCefGeolocationHandlerOwn.OnCancelGeolocationPermission(const browser: ICefBrowser;
  requestId: Integer);
begin
  { empty }
end;

constructor TCefGeolocationHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefGeolocationHandler));
  With PCefGeolocationHandler(FData)^ do
  begin
    on_request_geolocation_permission := @cef_geolocation_handler_on_request_geolocation_permission;
    on_cancel_geolocation_permission := @cef_geolocation_handler_on_cancel_geolocation_permission;
  end;
end;

{ TCefJsDialogHandlerOwn }

function cef_jsdialog_handler_on_jsdialog(self: PCefJsDialogHandler; browser: PCefBrowser;
  const origin_url: PCefString; dialog_type: TCefJsDialogType;
  const message_text, default_prompt_text: PCefString; callback: PCefJsDialogCallback;
  suppress_message: PInteger): Integer; cconv;
Var
  sm: Boolean;
begin
  sm := suppress_message^ <> 0;
  Result := Ord(TCefJsDialogHandlerOwn(CefGetObject(self)).
    OnJsdialog(TCefBrowserRef.UnWrap(browser), CefString(origin_url), dialog_type,
      CefString(message_text), CefString(default_prompt_text),
      TCefJsDialogCallbackRef.UnWrap(callback), sm));
  suppress_message^ := Ord(sm);
end;

function cef_jsdialog_handler_on_before_unload_dialog(self: PCefJsDialogHandler; browser: PCefBrowser;
  const message_text: PCefString; is_reload: Integer; callback: PCefJsDialogCallback): Integer; cconv;
begin
  Result := Ord(TCefJsDialogHandlerOwn(CefGetObject(self)).
    OnBeforeUnloadDialog(TCefBrowserRef.UnWrap(browser), CefString(message_text), is_reload <> 0,
                         TCefJsDialogCallbackRef.UnWrap(callback)));
end;

procedure cef_jsdialog_handler_on_reset_dialog_state(self: PCefJsDialogHandler; browser: PCefBrowser); cconv;
begin
  TCefJsDialogHandlerOwn(CefGetObject(self)).OnResetDialogState(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_jsdialog_handler_on_dialog_closed(self: PCefJsDialogHandler; browser: PCefBrowser); cconv;
begin
  TCefJsDialogHandlerOwn(CefGetObject(self)).OnDialogClosed(TCefBrowserRef.UnWrap(browser));
end;

function TCefJsDialogHandlerOwn.OnJsdialog(const browser: ICefBrowser;
  const originUrl: ustring; dialogType: TCefJsDialogType;
  const messageText, defaultPromptText: ustring;
  callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean;
begin
  Result := False;
end;

function TCefJsDialogHandlerOwn.OnBeforeUnloadDialog(const browser: ICefBrowser;
  const messageText: ustring; isReload: Boolean; const callback: ICefJsDialogCallback): Boolean;
begin
  Result := False;
end;

procedure TCefJsDialogHandlerOwn.OnResetDialogState(const browser: ICefBrowser);
begin
  { empty }
end;

procedure TCefJsDialogHandlerOwn.OnDialogClosed(const browser: ICefBrowser);
begin
  { empty }
end;

constructor TCefJsDialogHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefJsDialogHandler));
  With PCefJsDialogHandler(FData)^ do
  begin
    on_jsdialog := @cef_jsdialog_handler_on_jsdialog;
    on_before_unload_dialog := @cef_jsdialog_handler_on_before_unload_dialog;
    on_reset_dialog_state := @cef_jsdialog_handler_on_reset_dialog_state;
    on_dialog_closed := @cef_jsdialog_handler_on_dialog_closed;
  end;
end;

{ TCefKeyboardHandlerOwn }

function cef_keyboard_handler_on_pre_key_event(self: PCefKeyboardHandler; browser: PCefBrowser;
  const event: PCefKeyEvent; os_event: TCefEventHandle; is_keyboard_shortcut: PInteger): Integer; cconv;
Var
  ks: Boolean;
begin
  ks := is_keyboard_shortcut^ <> 0;
  With TCefKeyboardHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnPreKeyEvent(TCefBrowserRef.UnWrap(browser), event, os_event, ks));
  is_keyboard_shortcut^ := Ord(ks);
end;

function cef_keyboard_handler_on_key_event(self: PCefKeyboardHandler; browser: PCefBrowser;
  const event: PCefKeyEvent; os_event: TCefEventHandle): Integer; cconv;
begin
  With TCefKeyboardHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnKeyEvent(TCefBrowserRef.UnWrap(browser), event, os_event));
end;

function TCefKeyboardHandlerOwn.OnPreKeyEvent(const browser: ICefBrowser; const event: PCefKeyEvent;
  osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
begin
  Result := False;
end;

function TCefKeyboardHandlerOwn.OnKeyEvent(const browser: ICefBrowser; const event: PCefKeyEvent;
  osEvent: TCefEventHandle): Boolean;
begin
  Result := False;
end;

constructor TCefKeyboardHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefKeyboardHandler));
  With PCefKeyboardHandler(FData)^ do
  begin
    on_pre_key_event := @cef_keyboard_handler_on_pre_key_event;
    on_key_event := @cef_keyboard_handler_on_key_event;
  end;
end;

{ TCefLifeSpanHandlerOwn }

function cef_life_span_handler_on_before_popup(self: PCefLifeSpanHandler; browser: PCefBrowser;
  frame: PCefFrame; const target_url, target_frame_name: PCefString;
  target_disposition: TCefWindowOpenDisposition; user_gesture: Integer;
  const popupFeatures: PCefPopupFeatures; windowInfo: PCefWindowInfo;
  var client: PCefClient; settings: PCefBrowserSettings; no_javascript_access: PInteger): Integer; cconv;
Var
  u,f : ustring;
  nojs: Boolean;
  c: ICefClient;
begin
  u := CefString(target_url);
  f := CefString(target_frame_name);
  nojs := no_javascript_access^ <> 0;
  c := TCefClientOwn(CefGetObject(client)) as ICefClient;

  Result := Ord(TCefLifeSpanHandlerOwn(CefGetObject(self)).OnBeforePopup(TCefBrowserRef.UnWrap(browser),
    TCefFrameRef.UnWrap(frame), u, f, target_disposition, user_gesture <> 0, popupFeatures^,
    windowInfo^, c, settings^, nojs));

  client := CefGetData(c);
  c := nil;
  no_javascript_access^ := Ord(nojs);
end;

procedure cef_life_span_handler_on_after_created(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;
begin
  TCefLifeSpanHandlerOwn(CefGetObject(self)).OnAfterCreated(TCefBrowserRef.UnWrap(browser));
end;

function cef_life_span_handler_do_close(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cconv;
begin
  Result := Ord(TCefLifeSpanHandlerOwn(CefGetObject(self)).DoClose(TCefBrowserRef.UnWrap(browser)));
end;

procedure cef_life_span_handler_on_before_close(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;
begin
  TCefLifeSpanHandlerOwn(CefGetObject(self)).OnBeforeClose(TCefBrowserRef.UnWrap(browser));
end;

function TCefLifeSpanHandlerOwn.OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
  const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  Result := False;
end;

procedure TCefLifeSpanHandlerOwn.OnAfterCreated(const browser: ICefBrowser);
begin
  { empty }
end;

function TCefLifeSpanHandlerOwn.DoClose(const browser: ICefBrowser): Boolean;
begin
  Result := False;
end;

procedure TCefLifeSpanHandlerOwn.OnBeforeClose(const browser: ICefBrowser);
begin
  { empty }
end;

constructor TCefLifeSpanHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefLifeSpanHandler));
  With PCefLifeSpanHandler(FData)^ do
  begin
    on_before_popup := @cef_life_span_handler_on_before_popup;
    on_after_created := @cef_life_span_handler_on_after_created;
    do_close := @cef_life_span_handler_do_close;
    on_before_close := @cef_life_span_handler_on_before_close;
  end;
end;

{ TCefLoadHandlerOwn }

procedure cef_load_handler_on_loading_state_change(self: PCefLoadHandler; browser: PCefBrowser;
  isLoading, canGoBack, canGoForward: Integer); cconv;
begin
  TCefLoadHandlerOwn(CefGetObject(self)).
    OnLoadingStateChange(TCefBrowserRef.UnWrap(browser), isLoading <> 0, canGoBack <> 0,
      canGoForward <> 0);
end;

procedure cef_load_handler_on_load_start(self: PCefLoadHandler; browser: PCefBrowser;
  frame: PCefFrame; transition_type: TCefTransitionType); cconv;
begin
  TCefLoadHandlerOwn(CefGetObject(self)).
    OnLoadStart(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), transition_type);
end;

procedure cef_load_handler_on_load_end(self: PCefLoadHandler; browser: PCefBrowser; frame: PCefFrame;
  httpStatusCode: Integer); cconv;
begin
  TCefLoadHandlerOwn(CefGetObject(self)).
    OnLoadEnd(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), httpStatusCode);
end;

procedure cef_load_handler_on_load_error(self: PCefLoadHandler; browser: PCefBrowser; frame: PCefFrame;
  errorCode: TCefErrorCode; const errorText, failedUrl: PCefString); cconv;
begin
  TCefLoadHandlerOwn(CefGetObject(self)).
    OnLoadError(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      errorCode, CefString(errorText), CefString(failedUrl));
end;

procedure TCefLoadHandlerOwn.OnLoadingStateChange(const browser: ICefBrowser;
  isLoading, canGoBack, canGoForward: Boolean);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame; transitionType: TCefTransitionType);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame;
  httpStatusCode: Integer);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnLoadError(const browser: ICefBrowser; const frame: ICefFrame;
  errorCode: TCefErrorCode; const errorText, failedUrl: ustring);
begin
  { empty }
end;

constructor TCefLoadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefLoadHandler));
  With PCefLoadHandler(FData)^ do
  begin
    on_loading_state_change := @cef_load_handler_on_loading_state_change;
    on_load_start := @cef_load_handler_on_load_start;
    on_load_end := @cef_load_handler_on_load_end;
    on_load_error := @cef_load_handler_on_load_error;
  end;
end;

{ TCefMenuModelDelegateOwn }

procedure cef_menu_model_delegate_execute_command(self: PCefMenuModelDelegate;
  menu_model: PCefMenuModel; command_id: Integer; event_flags: TCefEventFlags); cconv;
begin
  TCefMenuModelDelegateOwn(CefGetObject(self)).
    ExecuteCommand(TCefMenuModelRef.UnWrap(menu_model), command_id, event_flags);
end;

procedure cef_menu_model_delegate_mouse_outside_menu(self: PCefMenuModelDelegate;
  menu_model: PCefMenuModel; const screen_point: PCefPoint); cconv;
begin
  TCefMenuModelDelegateOwn(CefGetObject(self)).
    MouseOutsideMenu(TCefMenuModelRef.UnWrap(menu_model), screen_point^);
end;

procedure cef_menu_model_delegate_unhandled_open_submenu(self: PCefMenuModelDelegate;
  menu_model: PCefMenuModel; is_rtl: Integer); cconv;
begin
  TCefMenuModelDelegateOwn(CefGetObject(self)).
    UnhandledOpenSubmenu(TCefMenuModelRef.UnWrap(menu_model), is_rtl <> 0);
end;

procedure cef_menu_model_delegate_unhandled_close_submenu(self: PCefMenuModelDelegate;
  menu_model: PCefMenuModel; is_rtl: Integer); cconv;
begin
  TCefMenuModelDelegateOwn(CefGetObject(self)).
    UnhandledCloseSubmenu(TCefMenuModelRef.UnWrap(menu_model), is_rtl <> 0);
end;

procedure cef_menu_model_delegate_menu_will_show(self: PCefMenuModelDelegate;
  menu_model: PCefMenuModel); cconv;
begin
  TCefMenuModelDelegateOwn(CefGetObject(self)).MenuWillShow(TCefMenuModelRef.UnWrap(menu_model));
end;

procedure cef_menu_model_delegate_menu_closed(self: PCefMenuModelDelegate; menu_model: PCefMenuModel); cconv;
begin
  TCefMenuModelDelegateOwn(CefGetObject(self)).MenuClosed(TCefMenuModelRef.UnWrap(menu_model));
end;

function cef_menu_model_delegate_format_label(self: PCefMenuModelDelegate; menu_model: PCefMenuModel;
  label_: PCefString): Integer; cconv;
Var
  l: ustring;
begin
  l := CefString(label_);
  Result := Ord(
    TCefMenuModelDelegateOwn(CefGetObject(self)).FormatLabel(TCefMenuModelRef.UnWrap(menu_model), l)
  );
  CefStringSet(label_, l);
end;

procedure TCefMenuModelDelegateOwn.ExecuteCommand(menuModel: ICefMenuModel; commandId: Integer;
  eventFlags: TCefEventFlags);
begin
  { empty }
end;

procedure TCefMenuModelDelegateOwn.MouseOutsideMenu(menuModel: ICefMenuModel;
  const screenPoint: TCefPoint);
begin
  { empty }
end;

procedure TCefMenuModelDelegateOwn.UnhandledOpenSubmenu(menuModel: ICefMenuModel; isRTL: Boolean);
begin
  { empty }
end;

procedure TCefMenuModelDelegateOwn.UnhandledCloseSubmenu(menuModel: ICefMenuModel; isRTL: Boolean);
begin
  { empty }
end;

procedure TCefMenuModelDelegateOwn.MenuWillShow(menuModel: ICefMenuModel);
begin
  { empty }
end;

procedure TCefMenuModelDelegateOwn.MenuClosed(menuModel: ICefMenuModel);
begin
  { empty }
end;

function TCefMenuModelDelegateOwn.FormatLabel(menuModel: ICefMenuModel;
  var label_: ustring): Boolean;
begin
  Result := False;
end;

constructor TCefMenuModelDelegateOwn.Create;
begin
  inherited CreateData(SizeOf(TCefMenuModelDelegate));
  With PCefMenuModelDelegate(fData)^ do
  begin
    execute_command := @cef_menu_model_delegate_execute_command;
    mouse_outside_menu := @cef_menu_model_delegate_mouse_outside_menu;
    unhandled_open_submenu := @cef_menu_model_delegate_unhandled_open_submenu;
    unhandled_close_submenu := @cef_menu_model_delegate_unhandled_close_submenu;
    menu_will_show := @cef_menu_model_delegate_menu_will_show;
    menu_closed := @cef_menu_model_delegate_menu_closed;
    format_label := @cef_menu_model_delegate_format_label;
  end;
end;

{ TCefPrintHandlerOwn }

procedure cef_print_handler_on_print_start(self: PCefPrintHandler; browser: PCefBrowser); cconv;
begin
  TCefPrintHandlerOwn(CefGetObject(self)).OnPrintStart(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_print_handler_on_print_settings(self: PCefPrintHandler; settings: PCefPrintSettings;
  get_defaults: Integer); cconv;
begin
  TCefPrintHandlerOwn(CefGetObject(self)).
    OnPrintSettings(TCefPrintSettingsRef.UnWrap(settings), get_defaults <> 0);
end;

function cef_print_handler_on_print_dialog(self: PCefPrintHandler; has_selection: Integer;
  callback: PCefPrintDialogCallback): Integer; cconv;
begin
  Result := Ord(TCefPrintHandlerOwn(CefGetObject(self)).
    OnPrintDialog(has_selection <> 0, TCefPrintDialogCallbackRef.UnWrap(callback)));
end;

function cef_print_handler_on_print_job(self: PCefPrintHandler;
  const document_name, pdf_file_path: PCefString; callback: PCefPrintJobCallback): Integer; cconv;
Var
  d, p: ustring;
begin
  d := CefString(document_name);
  p := CefString(pdf_file_path);

  Result := Ord(TCefPrintHandlerOwn(CefGetObject(self)).
    OnPrintJob(d, p, TCefPrintJobCallbackRef.UnWrap(callback)));
end;

procedure cef_print_handler_on_print_reset(self: PCefPrintHandler); cconv;
begin
  TCefPrintHandlerOwn(CefGetObject(self)).OnPrintReset;
end;

function cef_print_handler_get_pdf_paper_size(self: PCefPrintHandler;
  device_units_per_inch: Integer): TCefSize; cconv;
begin
  Result := TCefPrintHandlerOwn(CefGetObject(self)).GetPdfPaperSize(device_units_per_inch);
end;

procedure TCefPrintHandlerOwn.OnPrintStart(const browser: ICefBrowser);
begin
  { empty }
end;

procedure TCefPrintHandlerOwn.OnPrintSettings(settings: ICefPrintSettings; getDefaults: Boolean);
begin
  { empty }
end;

function TCefPrintHandlerOwn.OnPrintDialog(hasSelection: Boolean;
  callback: ICefPrintDialogCallback): Boolean;
begin
  Result := False;
end;

function TCefPrintHandlerOwn.OnPrintJob(const documentName, pdfFilePath: ustring;
  callback: ICefPrintJobCallback): Boolean;
begin
  Result := False;
end;

procedure TCefPrintHandlerOwn.OnPrintReset;
begin
  { empty }
end;

function TCefPrintHandlerOwn.GetPdfPaperSize(deviceUnitsPerInch: Integer): TCefSize;
begin
  FillByte(Result, SizeOf(Result), 0);
end;

constructor TCefPrintHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefPrintHandler));
  With PCefPrintHandler(fData)^ do
  begin
    on_print_start := @cef_print_handler_on_print_start;
    on_print_settings := @cef_print_handler_on_print_settings;
    on_print_dialog := @cef_print_handler_on_print_dialog;
    on_print_job := @cef_print_handler_on_print_job;
    on_print_reset := @cef_print_handler_on_print_reset;
    get_pdf_paper_size := @cef_print_handler_get_pdf_paper_size;
  end;
end;

{ TCefRenderHandlerOwn }

function cef_render_handler_get_root_screen_rect(self: PCefRenderHandler; browser: PCefBrowser;
  rect: PCefRect): Integer; cconv;
begin
  Result := Ord(TCefRenderHandlerOwn(CefGetObject(self)).
    GetRootScreenRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_view_rect(self: PCefRenderHandler; browser: PCefBrowser;
  rect: PCefRect): Integer; cconv;
begin
  Result := Ord(TCefRenderHandlerOwn(CefGetObject(self)).
    GetViewRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_screen_point(self: PCefRenderHandler; browser: PCefBrowser;
  viewX, viewY: Integer; screenX, screenY: PInteger): Integer; cconv;
begin
  Result := Ord(TCefRenderHandlerOwn(CefGetObject(self)).
    GetScreenPoint(TCefBrowserRef.UnWrap(browser), viewX, viewY, screenX, screenY));
end;

function cef_render_handler_get_screen_info(self: PCefRenderHandler; browser: PCefBrowser;
  screen_info: PCefScreenInfo): Integer; cconv;
begin
  Result := Ord(TCefRenderHandlerOwn(CefGetObject(self)).
    GetScreenInfo(TCefBrowserRef.UnWrap(browser), screen_info^));
end;

procedure cef_render_handler_on_popup_show(self: PCefRenderHandler; browser: PCefBrowser;
  show: Integer); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).OnPopupShow(TCefBrowserRef.UnWrap(browser), show <> 0);
end;

procedure cef_render_handler_on_popup_size(self: PCefRenderHandler; browser: PCefBrowser;
  const rect: PCefRect); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).OnPopupSize(TCefBrowserRef.UnWrap(browser), rect);
end;

procedure cef_render_handler_on_paint(self: PCefRenderHandler; browser: PCefBrowser;
  type_: TCefPaintElementType; dirtyRectsCount: TSize; dirtyRects: PCefRectArray;
  const buffer: Pointer; width, height: Integer); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).
    OnPaint(TCefBrowserRef.UnWrap(browser), type_, dirtyRectsCount, dirtyRects^, buffer, width, height);
end;

procedure cef_render_handler_on_cursor_change(self: PCefRenderHandler; browser: PCefBrowser;
  cursor: TCefCursorHandle; type_: TCefCursorType; const custom_cursor_info: PCefCursorInfo); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).
    OnCursorChange(TCefBrowserRef.UnWrap(browser), cursor, type_, custom_cursor_info);
end;

function cef_render_handler_start_dragging(self: PCefRenderHandler; browser: PCefBrowser;
  drag_data: PCefDragData; allowed_ops: TCefDragOperationsMask; x, y: Integer): Integer; cconv;
begin
  Result := Ord(TCefRenderHandlerOwn(CefGetObject(self)).
    StartDragging(TCefBrowserRef.UnWrap(self), TCefDragDataRef.UnWrap(drag_data), allowed_ops, x, y));
end;

procedure cef_render_handler_update_drag_cursor(self: PCefRenderHandler; browser: PCefBrowser;
  operation: TCefDragOperationsMask); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).
    UpdateDragCursor(TCefBrowserRef.UnWrap(browser), operation);
end;

procedure cef_render_handler_on_scroll_offset_changed(self: PCefRenderHandler; browser: PCefBrowser;
  x, y: Double); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).
    OnScrollOffsetChanged(TCefBrowserRef.UnWrap(browser), x, y);
end;

procedure cef_render_handler_on_ime_composition_range_changed(self: PCefRenderHandler;
  browser: PCefBrowser; const selected_range: PCefRange; character_boundsCount: TSize;
  character_bounds: PCefRectArray); cconv;
begin
  TCefRenderHandlerOwn(CefGetObject(self)).OnImeCompositionRangeChanged(
    TCefBrowserRef.UnWrap(browser), selected_range^, character_boundsCount, character_bounds^);
end;

function TCefRenderHandlerOwn.GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
  screenX, screenY: PInteger): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenInfo(const browser: ICefBrowser;
  var screenInfo: TCefScreenInfo): Boolean;
begin
  Result := False;
end;

procedure TCefRenderHandlerOwn.OnPopupShow(const browser: ICefBrowser; show: Boolean);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnPopupSize(const browser: ICefBrowser; const rect: PCefRect);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnPaint(const browser : ICefBrowser; kind: TCefPaintElementType;
  dirtyRectsCount: TSize; const dirtyRects: TCefRectArray; const buffer: Pointer;
  width, height: Integer);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle;
  type_: TCefCursorType; const customCursorInfo: PCefCursorInfo);
begin
  { empty }
end;

function TCefRenderHandlerOwn.StartDragging(const browser: ICefBrowser;
  const dragData: ICefDragData; allowedOps: TCefDragOperationsMask; x, y: Integer): Boolean;
begin
  Result := False;
end;

procedure TCefRenderHandlerOwn.UpdateDragCursor(const browser: ICefBrowser;
  operation: TCefDragOperationsMask);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnScrollOffsetChanged(const browser: ICefBrowser; x, y: Double);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnImeCompositionRangeChanged(const browser: ICefBrowser;
  const selectedRange: TCefRange; characterBoundsCount: TSize; characterBounds: TCefRectArray);
begin
  { empty }
end;

constructor TCefRenderHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRenderHandler));
  With PCefRenderHandler(FData)^ do
  begin
    get_root_screen_rect := @cef_render_handler_get_root_screen_rect;
    get_view_rect := @cef_render_handler_get_view_rect;
    get_screen_point := @cef_render_handler_get_screen_point;
    get_screen_info  := @cef_render_handler_get_screen_info;
    on_popup_show := @cef_render_handler_on_popup_show;
    on_popup_size := @cef_render_handler_on_popup_size;
    on_paint := @cef_render_handler_on_paint;
    on_cursor_change := @cef_render_handler_on_cursor_change;
    start_dragging := @cef_render_handler_start_dragging;
    update_drag_cursor := @cef_render_handler_update_drag_cursor;
    on_scroll_offset_changed := @cef_render_handler_on_scroll_offset_changed;
    on_ime_composition_range_changed := @cef_render_handler_on_ime_composition_range_changed;
  end;
end;

{ TCefRenderProcessHandlerOwn }

procedure cef_render_process_handler_on_render_thread_created(self: PCefRenderProcessHandler;
  ExtraInfo: PCefListValue); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnRenderThreadCreated(TCefListValueRef.UnWrap(ExtraInfo));
end;

procedure cef_render_process_handler_on_web_kit_initialized(self: PCefRenderProcessHandler); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).OnWebKitInitialized;
end;

procedure cef_render_process_handler_on_browser_created(self: PCefRenderProcessHandler;
  browser: PCefBrowser); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).OnBrowserCreated(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_render_process_handler_on_browser_destroyed(self: PCefRenderProcessHandler;
  browser: PCefBrowser); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).OnBrowserDestroyed(TCefBrowserRef.UnWrap(browser));
end;

function cef_render_process_handler_get_load_handler(self: PCefRenderProcessHandler): PCefLoadHandler; cconv;
begin
  Result := CefGetData(TCefRenderProcessHandlerOwn(CefGetObject(self)).GetLoadHandler);
end;

function cef_render_process_handler_on_before_navigation(self: PCefRenderProcessHandler; browser: PCefBrowser;
  frame: PCefFrame; request: PCefRequest; navigation_type: TCefNavigationType;
  is_redirect: Integer): Integer; cconv;
begin
  Result := Ord(TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnBeforeNavigation(TCefBrowserRef.UnWrap(browser),TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request),navigation_type,is_redirect <> 0));
end;

procedure cef_render_process_handler_on_context_created(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; context: PCefV8Context); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnContextCreated(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefV8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_context_released(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; context: PCefV8Context); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnContextReleased(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefV8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_uncaught_exception(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; context: PCefV8Context; exception: PCefV8Exception;
  stackTrace: PCefV8StackTrace); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnUncaughtException(TCefBrowserRef.UnWrap(browser),TCefFrameRef.UnWrap(frame),
      TCefV8ContextRef.UnWrap(context),TCefV8ExceptionRef.UnWrap(exception),
      TCefV8StackTraceRef.UnWrap(stackTrace));
end;

procedure cef_render_process_handler_on_focused_node_changed(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; node: PCefDomNode); cconv;
begin
  TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnFocusedNodeChanged(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefDomNodeRef.UnWrap(node));
end;

function cef_render_process_handler_on_process_message_received(self: PCefRenderProcessHandler;
  browser: PCefBrowser; source_process: TCefProcessId; message: PCefProcessMessage): Integer; cconv;
begin
  Result := Ord(TCefRenderProcessHandlerOwn(CefGetObject(Self)).
    OnProcessMessageReceived(TCefBrowserRef.UnWrap(browser), source_process,
      TCefProcessMessageRef.UnWrap(message)));
end;

procedure TCefRenderProcessHandlerOwn.OnRenderThreadCreated(const ExtraInfo: ICefListValue);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnWebKitInitialized;
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnBrowserCreated(const browser: ICefBrowser);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnBrowserDestroyed(const browser: ICefBrowser);
begin
  { empty }
end;

function TCefRenderProcessHandlerOwn.GetLoadHandler: ICefLoadHandler;
begin
  Result := nil;
end;

function TCefRenderProcessHandlerOwn.OnBeforeNavigation(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const navigationType: TCefNavigationType;
  const isRedirect: Boolean): Boolean;
begin
  Result := False;
end;

procedure TCefRenderProcessHandlerOwn.OnContextCreated(const browser: ICefBrowser;
  const frame: ICefFrame; const context: ICefV8Context);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnContextReleased(const browser: ICefBrowser;
  const frame: ICefFrame; const context: ICefV8Context);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnUncaughtException(const browser: ICefBrowser;
  const frame: ICefFrame; const context: ICefV8Context;
  const exception: ICefV8Exception; const stackTrace: ICefV8StackTrace);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnFocusedNodeChanged(const browser: ICefBrowser;
  const frame: ICefFrame; const node: ICefDomNode);
begin
  { empty }
end;

function TCefRenderProcessHandlerOwn.OnProcessMessageReceived(const browser: ICefBrowser;
  sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean;
begin
  Result := False;
end;

constructor TCefRenderProcessHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRenderProcessHandler));
  With PCefRenderProcessHandler(FData)^ do
  begin
    on_render_thread_created := @cef_render_process_handler_on_render_thread_created;
    on_web_kit_initialized := @cef_render_process_handler_on_web_kit_initialized;
    on_browser_created := @cef_render_process_handler_on_browser_created;
    on_browser_destroyed := @cef_render_process_handler_on_browser_destroyed;
    get_load_handler := @cef_render_process_handler_get_load_handler;
    on_before_navigation:= @cef_render_process_handler_on_before_navigation;
    on_context_created := @cef_render_process_handler_on_context_created;
    on_context_released := @cef_render_process_handler_on_context_released;
    on_uncaught_exception:= @cef_render_process_handler_on_uncaught_exception;
    on_focused_node_changed := @cef_render_process_handler_on_focused_node_changed;
    on_process_message_received := @cef_render_process_handler_on_process_message_received;
  end;
end;

{ TCefPostDataElementOwn }

function cef_post_data_element_is_read_only(self : PCefPostDataElement): Integer; cconv;
begin
  Result := Ord(TCefPostDataElementOwn(CefGetObject(self)).IsReadOnly)
end;

procedure cef_post_data_element_set_to_empty(self: PCefPostDataElement); cconv;
begin
  TCefPostDataElementOwn(CefGetObject(self)).SetToEmpty;
end;

procedure cef_post_data_element_set_to_file(self: PCefPostDataElement; const fileName: PCefString); cconv;
begin
  TCefPostDataElementOwn(CefGetObject(self)).SetToFile(CefString(fileName));
end;

procedure cef_post_data_element_set_to_bytes(self: PCefPostDataElement; size: TSize;
  const bytes: Pointer); cconv;
begin
  TCefPostDataElementOwn(CefGetObject(self)).SetToBytes(size, bytes);
end;

function cef_post_data_element_get_type(self: PCefPostDataElement): TCefPostDataElementType; cconv;
begin
  Result := TCefPostDataElementOwn(CefGetObject(self)).GetType;
end;

function cef_post_data_element_get_file(self: PCefPostDataElement): PCefStringUserFree; cconv;
begin
  Result := CefUserFreeString(TCefPostDataElementOwn(CefGetObject(self)).GetFile);
end;

function cef_post_data_element_get_bytes_count(self: PCefPostDataElement): TSize; cconv;
begin
  Result := TCefPostDataElementOwn(CefGetObject(self)).GetBytesCount;
end;

function cef_post_data_element_get_bytes(self: PCefPostDataElement; size: TSize; bytes: Pointer): TSize; cconv;
begin
  Result := TCefPostDataElementOwn(CefGetObject(self)).GetBytes(size, bytes)
end;

procedure TCefPostDataElementOwn.Clear;
begin
  Case fDataType of
    PDE_TYPE_BYTES:
      If (fValueByte <> nil) then
      begin
        Freemem(fValueByte);
        fValueByte := nil;
      end;
    PDE_TYPE_FILE:
      CefStringFree(@fValueStr);
  end;
  fDataType := PDE_TYPE_EMPTY;
  fSize := 0;
end;

function TCefPostDataElementOwn.IsReadOnly: Boolean;
begin
  Result := fReadOnly;
end;

procedure TCefPostDataElementOwn.SetToEmpty;
begin
  Clear;
end;

procedure TCefPostDataElementOwn.SetToFile(const fileName: ustring);
begin
  Clear;
  fSize := 0;
  fValueStr := CefStringAlloc(fileName);
  fDataType := PDE_TYPE_FILE;
end;

procedure TCefPostDataElementOwn.SetToBytes(size: TSize; const bytes: Pointer);
begin
  Clear;
  If (size > 0) and (bytes <> nil) then
  begin
    GetMem(fValueByte, size);
    Move(bytes^, fValueByte, size);
    fSize := size;
  end
  Else
  begin
    fValueByte := nil;
    fSize := 0;
  end;
  fDataType := PDE_TYPE_BYTES;
end;

function TCefPostDataElementOwn.GetType: TCefPostDataElementType;
begin
  Result := fDataType;
end;

function TCefPostDataElementOwn.GetFile: ustring;
begin
  If (fDataType = PDE_TYPE_FILE) then Result := CefString(@fValueStr)
  Else Result := '';
end;

function TCefPostDataElementOwn.GetBytesCount: TSize;
begin
  If (fDataType = PDE_TYPE_BYTES) then Result := fSize
  Else Result := 0;
end;

function TCefPostDataElementOwn.GetBytes(size: TSize; bytes: Pointer): TSize;
begin
  If (fDataType = PDE_TYPE_BYTES) and (fValueByte <> nil) then
  begin
    If size > fSize then Result := fSize
    Else Result := size;
    Move(fValueByte^, bytes^, Result);
  end
  Else Result := 0;
end;

constructor TCefPostDataElementOwn.Create(readonly: Boolean);
begin
  inherited CreateData(SizeOf(TCefPostDataElement));

  fReadOnly := readonly;
  fDataType := PDE_TYPE_EMPTY;
  fValueByte := nil;
  FillChar(fValueStr, SizeOf(fValueStr), 0);
  fSize := 0;

  With PCefPostDataElement(FData)^ do
  begin
    is_read_only := @cef_post_data_element_is_read_only;
    set_to_empty := @cef_post_data_element_set_to_empty;
    set_to_file := @cef_post_data_element_set_to_file;
    set_to_bytes := @cef_post_data_element_set_to_bytes;
    get_type := @cef_post_data_element_get_type;
    get_file := @cef_post_data_element_get_file;
    get_bytes_count := @cef_post_data_element_get_bytes_count;
    get_bytes := @cef_post_data_element_get_bytes;
  end;
end;

{ TCefResolveCallbackOwn }

procedure cef_resolve_callback_on_resolve_completed(self: PCefResolveCallback;
  result: TCefErrorCode; resolved_ips: TCefStringList); cconv;
Var
  list: TStringList;
  i: Integer;
  item: TCefString;
begin
  list := TStringList.Create;
  try
    For i := 0 to cef_string_list_size(resolved_ips) - 1 do
    begin
      FillChar(item, SizeOf(item), 0);
      cef_string_list_value(resolved_ips, i, @item);
      list.Add(CefStringClearAndGet(item));
    end;

    TCefResolveCallbackOwn(CefGetObject(self)).OnResolveCompleted(result, list);
  finally
    list.Free;
  end;
end;

procedure TCefResolveCallbackOwn.OnResolveCompleted(result: TCefErrorCode; resolvedIps: TStrings);
begin
  { empty }
end;

constructor TCefResolveCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefResolveCallback));
  With PCefResolveCallback(fData)^ do
  begin
    on_resolve_completed := @cef_resolve_callback_on_resolve_completed;
  end;
end;

{ TCefFastResolveCallback }

procedure TCefFastResolveCallback.OnResolveCompleted(result: TCefErrorCode; resolvedIps: TStrings);
begin
  fCallback(result, resolvedIps);
end;

constructor TCefFastResolveCallback.Create(callback: TCefResolveCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefRequestContextHandler }

function cef_request_context_handler_get_cookie_manager(self: PCefRequestContextHandler): PCefCookieManager; cconv;
begin
  Result := CefGetData(TCefRequestContextHandlerOwn(CefGetObject(self)).GetCookieManager);
end;

function cef_request_context_handler_on_before_plugin_load(self: PCefRequestContextHandler;
  const mime_type, plugin_url: PCefString; is_main_frame: Integer; const top_origin_url: PCefString;
  plugin_info: PCefWebPluginInfo; plugin_policy: PCefPluginPolicy): Integer; cconv;
Var
  m, p, t: ustring;
begin
  m := CefString(mime_type);
  p := CefString(plugin_url);
  t := CefString(top_origin_url);
  Result := Ord(TCefRequestContextHandlerOwn(CefGetObject(self)).
    OnBeforePluginLoad(m, p, is_main_frame <> 0, t, TCefWebPluginInfoRef.UnWrap(plugin_info),
    plugin_policy^));
end;

function TCefRequestContextHandlerOwn.GetCookieManager: ICefCookieManager;
begin
  Result := nil;
end;

function TCefRequestContextHandlerOwn.OnBeforePluginLoad(const mimeType, pluginUrl: ustring;
  isMainFrame: Boolean; const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo;
  pluginPolicy: TCefPluginPolicy): Boolean;
begin
  Result := False;
end;

constructor TCefRequestContextHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRequestContextHandler));
  With PCefRequestContextHandler(FData)^ do
  begin
    get_cookie_manager := @cef_request_context_handler_get_cookie_manager;
    on_before_plugin_load := @cef_request_context_handler_on_before_plugin_load;
  end;
end;

{ TCefRequestHandlerOwn }

function cef_request_handler_on_before_browse(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; request: PCefRequest; is_redirect: Integer): Integer; cconv;
begin
  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).
    OnBeforeBrowse(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request), is_redirect <> 0));
end;

function cef_request_handler_on_open_urlfrom_tab(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; const target_url: PCefString; target_disposition: TCefWindowOpenDisposition;
  user_gesture: Integer): Integer; cconv;
Var
  u: ustring;
begin
  u := CefString(target_url);
  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).
    OnOpenUrlFromTab(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), u,
      target_disposition, user_gesture <> 0));
end;

function cef_request_handler_on_before_resource_load(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; request: PCefRequest; callback: PCefRequestCallback): TCefReturnValue; cconv;
begin
  Result := TCefRequestHandlerOwn(CefGetObject(self)).
    OnBeforeResourceLoad(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request), TCefRequestCallbackRef.UnWrap(callback));
end;

function cef_request_handler_get_resource_handler(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; request: PCefRequest): PCefResourceHandler; cconv;
begin
  Result := CefGetData(TCefRequestHandlerOwn(CefGetObject(self)).
    GetResourceHandler(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request)));
end;


procedure cef_request_handler_on_resource_redirect(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; request: PCefRequest; response: PCefResponse; new_url: PCefString); cconv;
Var
  u: ustring;
begin
  u := CefString(new_url);
  TCefRequestHandlerOwn(CefGetObject(self)).
    OnResourceRedirect(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request), TCefResponseRef.UnWrap(response), u);
  CefStringSet(new_url, u);
end;

function cef_request_handler_on_resource_response(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; request: PCefRequest; response: PCefResponse): Integer; cconv;
begin
  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).
    OnResourceResponse(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request), TCefResponseRef.UnWrap(response)));
end;

function cef_request_handler_get_auth_credentials(self: PCefRequestHandler; browser: PCefBrowser;
  frame: PCefFrame; isProxy: Integer; const host: PCefString; port: Integer;
  const realm, scheme: PCefString; callback: PCefAuthCallback) : Integer; cconv;
begin
  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).
    GetAuthCredentials(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), isProxy <> 0,
      CefString(host), port, CefString(realm), CefString(scheme), TCefAuthCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_on_quota_request(self: PCefRequestHandler; browser: PCefBrowser;
  const origin_url: PCefString; new_size: Int64; callback: PCefRequestCallback): Integer; cconv;
begin
  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).
    OnQuotaRequest(TCefBrowserRef.UnWrap(browser), CefString(origin_url), new_size,
      TCefRequestCallbackRef.UnWrap(callback)));
end;

procedure cef_request_handler_on_protocol_execution(self: PCefRequestHandler;
  browser: PCefBrowser; const url: PCefString; allow_os_execution: PInteger); cconv;
Var
  allow: Boolean;
begin
  allow := allow_os_execution^ <> 0;
  TCefRequestHandlerOwn(CefGetObject(self)).
    OnProtocolExecution(TCefBrowserRef.UnWrap(browser), CefString(url), allow);
  allow_os_execution^ := Ord(allow);
end;

function cef_request_handler_on_certificate_error(self: PCefRequestHandler; browser: PCefBrowser;
  cert_error: TCefErrorCode; const request_url: PCefString; ssl_info: PCefSslInfo;
  callback: PCefRequestCallback): Integer; cconv;
begin
  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).OnCertificateError(
    TCefBrowserRef.UnWrap(browser), cert_error, CefString(request_url),
    TCefSslinfoRef.UnWrap(ssl_info),TCefRequestCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_on_select_client_certificate(self: PCefRequestHandler;
  browser: PCefBrowser; isProxy: Integer; const host: PCefString; port: Integer;
  certificatesCount: TSize; certificates: PCefX509CertificateArray;
  callback: PCefSelectClientCertificateCallback): Integer; cconv;
Var
  certs: ICefX509certificateArray;
  i: Integer;
begin
  SetLength(certs, certificatesCount);
  If certificatesCount > 0 then
  begin
    For i := 0 to certificatesCount - 1 do
      certs[i] := TCefX509CertificateRef.UnWrap(certificates^[i]);
  end;

  Result := Ord(TCefRequestHandlerOwn(CefGetObject(self)).OnSelectClientCertificate(
    TCefBrowserRef.UnWrap(browser), isProxy <> 0, CefString(host), port, certificatesCount, certs,
    TCefSelectClientCertificateCallbackRef.UnWrap(callback)));
end;

procedure cef_request_handler_on_plugin_crashed(self: PCefRequestHandler; browser: PCefBrowser;
  const plugin_path: PCefString); cconv;
begin
  TCefRequestHandlerOwn(CefGetObject(self)).
    OnPluginCrashed(TCefBrowserRef.UnWrap(browser), CefString(plugin_path));
end;

procedure cef_request_handler_on_render_view_ready(self: PCefRequestHandler; browser: PCefBrowser); cconv;
begin
  TCefRequestHandlerOwn(CefGetObject(self)).OnRenderViewReady(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_request_handler_on_render_process_terminated(self: PCefRequestHandler;
  browser: PCefBrowser; status: TCefTerminationStatus); cconv;
begin
  TCefRequestHandlerOwn(CefGetObject(self)).
    OnRenderProcessTerminated(TCefBrowserRef.UnWrap(browser), status);
end;

function TCefRequestHandlerOwn.OnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; isRedirect: Boolean): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnOpenUrlFromTab(browser: ICefBrowser; frame: ICefFrame;
  const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition;
  useGesture: Boolean): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnBeforeResourceLoad(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  const callback: ICefRequestCallback): TCefReturnValue;
begin
  Result := RV_CONTINUE;
end;

function TCefRequestHandlerOwn.GetResourceHandler(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest): ICefResourceHandler;
begin
  Result := nil;
end;

procedure TCefRequestHandlerOwn.OnResourceRedirect(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
  var newUrl: ustring);
begin
  { empty }
end;

function TCefRequestHandlerOwn.OnResourceResponse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.GetResourceResponseFilter(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  const response: ICefResponse): ICefResponseFilter;
begin
  Result := nil;
end;

procedure TCefRequestHandlerOwn.OnResourceLoadComplete(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; const response: ICefResponse;
  status: TCefUrlRequestStatus; receivedContentLength: Int64);
begin
  { empty }
end;

function TCefRequestHandlerOwn.GetAuthCredentials(const browser: ICefBrowser;
  const frame: ICefFrame; isProxy: Boolean; const host: ustring; port: Integer;
  const realm, scheme: ustring; const callback: ICefAuthCallback): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnQuotaRequest(const browser: ICefBrowser; const originUrl: ustring;
  newSize: Int64; const callback: ICefRequestCallback): Boolean;
begin
  Result := False;
end;

procedure TCefRequestHandlerOwn.OnProtocolExecution(const browser: ICefBrowser; const url: ustring;
  out allowOsExecution: Boolean);
begin
  { empty }
end;

function TCefRequestHandlerOwn.OnCertificateError(const browser: ICefBrowser;
  certError: TCefErrorCode; const requestUrl: ustring; const sslInfo: ICefSslinfo;
  callback: ICefRequestCallback): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnSelectClientCertificate(const browser: ICefBrowser;
  isProxy: Boolean; const host: ustring; port: Integer; certificatesCount: TSize;
  certificates: ICefX509certificateArray; callback: ICefSelectClientCertificateCallback): Boolean;
begin
  Result := False;
end;

procedure TCefRequestHandlerOwn.OnPluginCrashed(const browser: ICefBrowser;
  const plugin_path: ustring);
begin
  { empty }
end;

procedure TCefRequestHandlerOwn.OnRenderViewReady(browser: ICefBrowser);
begin
  { empty }
end;

procedure TCefRequestHandlerOwn.OnRenderProcessTerminated(const browser: ICefBrowser;
  status: TCefTerminationStatus);
begin
  { empty }
end;

constructor TCefRequestHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRequestHandler));
  With PCefRequestHandler(FData)^ do
  begin
    on_before_browse := @cef_request_handler_on_before_browse;
    on_open_urlfrom_tab := @cef_request_handler_on_open_urlfrom_tab;
    on_before_resource_load := @cef_request_handler_on_before_resource_load;
    get_resource_handler := @cef_request_handler_get_resource_handler;
    on_resource_redirect := @cef_request_handler_on_resource_redirect;
    on_resource_response := @cef_request_handler_on_resource_response;
    get_auth_credentials := @cef_request_handler_get_auth_credentials;
    on_quota_request := @cef_request_handler_on_quota_request;
    on_protocol_execution := @cef_request_handler_on_protocol_execution;
    on_certificate_error := @cef_request_handler_on_certificate_error;
    on_select_client_certificate := @cef_request_handler_on_select_client_certificate;
    on_plugin_crashed := @cef_request_handler_on_plugin_crashed;
    on_render_view_ready := @cef_request_handler_on_render_view_ready;
    on_render_process_terminated := @cef_request_handler_on_render_process_terminated;
  end;
end;

{ TCefResourceBundleHandlerOwn }

function cef_resource_bundle_handler_get_localized_string(self: PCefResourceBundleHandler;
  string_id: Integer; string_: PCefString): Integer; cconv;
Var
  s: ustring;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).GetLocalizedString(string_id, s));
  If Result <> 0 then CefStringSet(string_, s);
end;

function cef_resource_bundle_handler_get_data_resource(self: PCefResourceBundleHandler;
  resource_id: Integer; var data: Pointer; var data_size: TSize): Integer; cconv;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).
    GetDataResource(resource_id, data, data_size));
end;

function cef_resource_bundle_handler_get_data_resource_for_scale(self: PCefResourceBundleHandler;
  resource_id: Integer; scale_factor: TCefScaleFactor; data: PPointer; data_size: PSize): Integer; cconv;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).
    GetDataResourceForScale(resource_id, scale_factor, data, data_size^));
end;

constructor TCefResourceBundleHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefResourceBundleHandler));
  With PCefResourceBundleHandler(FData)^ do
  begin
    get_localized_string := @cef_resource_bundle_handler_get_localized_string;
    get_data_resource := @cef_resource_bundle_handler_get_data_resource;
    get_data_resource_for_scale := @cef_resource_bundle_handler_get_data_resource_for_scale;
  end;
end;

{ TCefFastResourceBundle }

function TCefFastResourceBundle.GetLocalizedString(messageId : Integer;
  out stringVal : ustring) : Boolean;
begin
  If Assigned(fGetLocalizedString) then Result := fGetLocalizedString(messageId, stringVal)
  Else Result := False;
end;

function TCefFastResourceBundle.GetDataResource(resourceId : Integer;
  out data : Pointer; out dataSize : TSize) : Boolean;
begin
  If Assigned(fGetDataResource) then Result := fGetDataResource(resourceId, data, dataSize)
  Else Result := False;
end;

function TCefFastResourceBundle.GetDataResourceForScale(resourceId: Integer;
  scaleFactor: TCefScaleFactor; out data: Pointer; out dataSize: TSize): Boolean;
begin
  If Assigned(fGetDataResourceForScale) then
    Result := fGetDataResourceForScale(resourceId, scaleFactor, data, dataSize)
  Else Result := False;
end;

constructor TCefFastResourceBundle.Create(AGetLocalizedString: TGetLocalizedString;
  AGetDataResource: TGetDataResource; AGetDataResourceForScale: TGetDataResourceForScale);
begin
  inherited Create;
  fGetLocalizedString := AGetLocalizedString;
  fGetDataResource := AGetDataResource;
  fGetDataResourceForScale := AGetDataResourceForScale;
end;

{ TCefResourceHandlerOwn }

function cef_resource_handler_process_request(self: PCefResourceHandler; request: PCefRequest;
  callback: PCefCallback): Integer; cconv;
begin
  Result := Ord(TCefResourceHandlerOwn(CefGetObject(self)).
    ProcessRequest(TCefRequestRef.UnWrap(request), TCefCallbackRef.UnWrap(callback)));
end;

procedure cef_resource_handler_get_response_headers(self: PCefResourceHandler; response: PCefResponse;
  response_length: PInt64; redirectUrl: PCefString); cconv;
Var
  ru: ustring;
begin
  TCefResourceHandlerOwn(CefGetObject(self)).
    GetResponseHeaders(TCefResponseRef.UnWrap(response), response_length^, ru);
  CefStringSet(redirectUrl, ru);
end;

function cef_resource_handler_read_response(self: PCefResourceHandler; data_out: Pointer;
  bytes_to_read: Integer; bytes_read: PInteger; callback: PCefCallback): Integer; cconv;
begin
  Result := Ord(TCefResourceHandlerOwn(CefGetObject(self)).
    ReadResponse(data_out, bytes_to_read, bytes_read^, TCefCallbackRef.UnWrap(callback)));
end;

function cef_resource_handler_can_get_cookie(self: PCefResourceHandler; const cookie: PCefCookie): Integer; cconv;
begin
  Result := Ord(TCefResourceHandlerOwn(CefGetObject(self)).CanGetCookie(cookie));
end;

function cef_resource_handler_can_set_cookie(self: PCefResourceHandler; const cookie: PCefCookie): Integer; cconv;
begin
  Result := Ord(TCefResourceHandlerOwn(CefGetObject(self)).CanSetCookie(cookie));
end;

procedure cef_resource_handler_cancel(self: PCefResourceHandler); cconv;
begin
  TCefResourceHandlerOwn(CefGetObject(self)).Cancel;
end;

function TCefResourceHandlerOwn.ProcessRequest(const request: ICefRequest;
  const callback: ICefCallback): Boolean;
begin
  Result := False;
end;

procedure TCefResourceHandlerOwn.GetResponseHeaders(const response: ICefResponse;
  out responseLength: Int64; out redirectUrl: ustring);
begin
  { empty }
end;

function TCefResourceHandlerOwn.ReadResponse(const dataOut : Pointer;
  bytesToRead : Integer; var bytesRead : Integer;
  const callback : ICefCallback) : Boolean;
begin
  Result := False;
end;

function TCefResourceHandlerOwn.CanGetCookie(const cookie: PCefCookie): Boolean;
begin
  Result := False;
end;

function TCefResourceHandlerOwn.CanSetCookie(const cookie: PCefCookie): Boolean;
begin
  Result := False;
end;

procedure TCefResourceHandlerOwn.Cancel;
begin
  { empty }
end;

constructor TCefResourceHandlerOwn.Create(const browser: ICefBrowser; const frame: ICefFrame;
  const schemeName: ustring; const request: ICefRequest);
begin
  inherited CreateData(SizeOf(TCefResourceHandler));
  With PCefResourceHandler(FData)^ do
  begin
    process_request := @cef_resource_handler_process_request;
    get_response_headers := @cef_resource_handler_get_response_headers;
    read_response := @cef_resource_handler_read_response;
    can_get_cookie := @cef_resource_handler_can_get_cookie;
    can_set_cookie := @cef_resource_handler_can_set_cookie;
    cancel := @cef_resource_handler_cancel;
  end;
end;

{ TCefResponseFilter }

function cef_response_filter_init_filter(self: PCefResponseFilter): Integer; cconv;
begin
  Result := Ord(TCefResponseFilterOwn(CefGetObject(self)).InitFilter);
end;

function cef_response_filter_filter(self: PCefResponseFilter; data_in: Pointer;
  data_in_size: TSize; data_in_read: PSize; data_out: Pointer; data_out_size: TSize;
  data_out_written: PSize): TCefResponseFilterStatus; cconv;
begin
  Result := TCefResponseFilterOwn(CefGetObject(self)).Filter(data_in, data_in_size, data_in_read^,
    data_out, data_out_size, data_out_written^);
end;

function TCefResponseFilterOwn.InitFilter: Boolean;
begin
  Result := False;
end;

constructor TCefResponseFilterOwn.Create;
begin
  inherited CreateData(SizeOf(TCefResponseFilter));
  With PCefResponseFilter(fData)^ do
  begin
    init_filter := @cef_response_filter_init_filter;
    filter := @cef_response_filter_filter;
  end;
end;

{ TCefSchemeHandlerFactoryOwn }

function cef_scheme_handler_factory_create(self: PCefSchemeHandlerFactory; browser: PCefBrowser;
  frame: PCefFrame; const scheme_name: PCefString; request: PCefRequest): PCefResourceHandler; cconv;
begin
  Result := CefGetData(TCefSchemeHandlerFactoryOwn(CefGetObject(self)).
    New(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), CefString(scheme_name),
      TCefRequestRef.UnWrap(request)));
end;

function TCefSchemeHandlerFactoryOwn.New(const browser: ICefBrowser; const frame: ICefFrame;
  const schemeName: ustring; const request: ICefRequest): ICefResourceHandler;
begin
  Result := fClass.Create(browser, frame, schemeName, request);
end;

constructor TCefSchemeHandlerFactoryOwn.Create(const AClass: TCefResourceHandlerClass);
begin
  inherited CreateData(SizeOf(TCefSchemeHandlerFactory));
  fClass := AClass;
  With PCefSchemeHandlerFactory(FData)^ do
  begin
    create := @cef_scheme_handler_factory_create;
  end;
end;

{ TCefReadHandlerOwn }

function cef_read_handler_read(self: PCefReadHandler; ptr: Pointer; size, n: TSize): TSize; cconv;
begin
  Result := TCefReadHandlerOwn(CefGetObject(self)).Read(ptr, size, n);
end;

function cef_read_handler_seek(self: PCefReadHandler; offset: Int64; whence: Integer): Integer; cconv;
begin
  Result := TCefReadHandlerOwn(CefGetObject(self)).Seek(offset, whence);
end;

function cef_read_handler_tell(self: PCefReadHandler): Int64; cconv;
begin
  Result := TCefReadHandlerOwn(CefGetObject(self)).Tell;
end;

function cef_read_handler_eof(self: PCefReadHandler): Integer; cconv;
begin
  Result := Ord(TCefReadHandlerOwn(CefGetObject(self)).Eof);
end;

function cef_read_handler_may_block(self: PCefReadHandler): Integer; cconv;
begin
  Result := Ord(TCefReadHandlerOwn(CefGetObject(self)).MayBlock);
end;

function TCefReadHandlerOwn.Read(ptr: Pointer; size, n: TSize): TSize;
begin
  Result := Cardinal(fStream.Read(ptr^, n * size)) div size;
end;

function TCefReadHandlerOwn.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := fStream.Seek(offset, whence);
end;

function TCefReadHandlerOwn.Tell: Int64;
begin
  Result := fStream.Position;
end;

function TCefReadHandlerOwn.Eof: Boolean;
begin
  Result := fStream.Position = FStream.Size;
end;

function TCefReadHandlerOwn.MayBlock: Boolean;
begin
  Result := True;
end;

constructor TCefReadHandlerOwn.Create(Stream: TStream; Owned: Boolean);
begin
  inherited CreateData(SizeOf(TCefReadHandler));

  fStream := Stream;
  fOwned := Owned;

  With PCefReadHandler(FData)^ do
  begin
    read := @cef_read_handler_read;
    seek := @cef_read_handler_seek;
    tell := @cef_read_handler_tell;
    eof := @cef_read_handler_eof;
    may_block := @cef_read_handler_may_block;
  end;
end;

constructor TCefReadHandlerOwn.Create(const filename: String);
begin
  Create(TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite), True);
end;

destructor TCefReadHandlerOwn.Destroy;
begin
  If fOwned then fStream.Free;

  inherited;
end;

{ TCefWriteHandlerOwn }

function cef_write_handler_write(self: PCefWriteHandler; const ptr: Pointer; size, n: TSize): TSize; cconv;
begin
  Result := TCefWriteHandlerOwn(CefGetObject(self)).Write(ptr, size, n);
end;

function cef_write_handler_seek(self: PCefWriteHandler; offset: Int64; whence: Integer): Integer; cconv;
begin
  Result := TCefWriteHandlerOwn(CefGetObject(self)).Seek(offset, whence);
end;

function cef_write_handler_tell(self: PCefWriteHandler): Int64; cconv;
begin
  Result := TCefWriteHandlerOwn(CefGetObject(self)).Tell;
end;

function cef_write_handler_flush(self: PCefWriteHandler): Integer; cconv;
begin
  Result := Ord(TCefWriteHandlerOwn(CefGetObject(self)).Flush);
end;

function cef_write_handler_may_block(self: PCefWriteHandler): Integer; cconv;
begin
  Result := Ord(TCefWriteHandlerOwn(CefGetObject(self)).MayBlock);
end;

function TCefWriteHandlerOwn.Write(const ptr: Pointer; size, n: TSize): TSize;
begin
  Result := Cardinal(fStream.Read(ptr^, n * size)) div size;
end;

function TCefWriteHandlerOwn.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := fStream.Seek(offset, whence);
end;

function TCefWriteHandlerOwn.Tell: Int64;
begin
  Result := fStream.Position;
end;

function TCefWriteHandlerOwn.Flush: Boolean;
begin
  Result := True;
end;

function TCefWriteHandlerOwn.MayBlock: Boolean;
begin
  Result := True;
end;

constructor TCefWriteHandlerOwn.Create(Stream: TStream; Owned: Boolean);
begin
  inherited CreateData(SizeOf(TCefWriteHandler));

  fStream := Stream;
  fOwned := Owned;

  With PCefWriteHandler(FData)^ do
  begin
    write := @cef_write_handler_write;
    seek := @cef_write_handler_seek;
    tell := @cef_write_handler_tell;
    flush := @cef_write_handler_flush;
    may_block := @cef_write_handler_may_block;
  end;
end;

constructor TCefWriteHandlerOwn.Create(const filename: String);
begin
  Create(TFileStream.Create(filename, fmOpenWrite), True);
end;

destructor TCefWriteHandlerOwn.Destroy;
begin
  If fOwned then fStream.Free;

  inherited;
end;

{ TCefStringVisitorOwn }

procedure cef_string_visitor_visit(self: PCefStringVisitor; const str: PCefString); cconv;
begin
  TCefStringVisitorOwn(CefGetObject(self)).Visit(CefString(str));
end;


procedure TCefStringVisitorOwn.Visit(const str: ustring);
begin
  { empty }
end;

constructor TCefStringVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefStringVisitor));

  With PCefStringVisitor(FData)^ do
  begin
    visit := @cef_string_visitor_visit;
  end;
end;

{ TCefFastStringVisitor }

procedure TCefFastStringVisitor.Visit(const str: ustring);
begin
  FVisit(str);
end;

constructor TCefFastStringVisitor.Create(const callback: TCefStringVisitorProc);
begin
  inherited Create;
  fVisit := callback;
end;

{ TCefTaskOwn }

procedure cef_task_execute(self: PCefTask); cconv;
begin
  TCefTaskOwn(CefGetObject(self)).Execute;
end;

procedure TCefTaskOwn.Execute;
begin
  { empty }
end;

constructor TCefTaskOwn.Create;
begin
  inherited CreateData(SizeOf(TCefTask));

  With PCefTask(FData)^ do
  begin
    execute := @cef_task_execute;
  end;
end;

{ TCefEndTracingCallbackOwn }

procedure cef_end_tracing_callback_on_end_tracing_complete(self: PCefEndTracingCallback;
  const tracing_file: PCefString); cconv;
begin
  TCefEndTracingCallbackOwn(CefGetObject(self)).OnEndTracingComplete(CefString(tracing_file));
end;

procedure TCefEndTracingCallbackOwn.OnEndTracingComplete(const tracingFile: ustring);
begin
  { empty }
end;

constructor TCefEndTracingCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefEndTracingCallback));
  With PCefEndTracingCallback(fData)^ do
  begin
    on_end_tracing_complete := @cef_end_tracing_callback_on_end_tracing_complete;
  end;
end;

{ TCefFastEndTracingCallback }

procedure TCefFastEndTracingCallback.OnEndTracingComplete(const tracingFile: ustring);
begin
  fCallback(tracingFile);
end;

constructor TCefFastEndTracingCallback.Create(const callback: TCefEndTracingCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefUrlrequestClientOwn }

procedure cef_url_request_client_on_request_complete(self: PCefUrlRequestClient;
    request: PCefUrlRequest); cconv;
begin
  TCefUrlrequestClientOwn(CefGetObject(self)).OnRequestComplete(TCefUrlRequestRef.UnWrap(request));
end;

procedure cef_url_request_client_on_upload_progress(self : PCefUrlRequestClient;
  request: PCefUrlRequest; current, total : Int64); cconv;
begin
  TCefUrlrequestClientOwn(CefGetObject(self)).
    OnUploadProgress(TCefUrlRequestRef.UnWrap(request), current, total);
end;

procedure cef_url_request_client_on_download_progress(self: PCefUrlRequestClient;
  request: PCefUrlRequest; current, total: Int64); cconv;
begin
  TCefUrlrequestClientOwn(CefGetObject(self)).
    OnDownloadProgress(TCefUrlRequestRef.UnWrap(request), current, total);
end;

procedure cef_url_request_client_on_download_data(self: PCefUrlRequestClient;
  request: PCefUrlRequest; const data: Pointer; data_length: TSize); cconv;
begin
  TCefUrlrequestClientOwn(CefGetObject(self)).
    OnDownloadData(TCefUrlRequestRef.UnWrap(request), data, data_length);
end;

function cef_url_request_client_get_auth_credentials(self: PCefUrlRequestClient; isProxy: Integer;
  const host: PCefString; port: Integer; const realm, scheme: PCefString;
  callback: PCefAuthCallback): Integer; cconv;
begin
  Result := Ord(TCefUrlrequestClientOwn(CefGetObject(self)).
    GetAuthCredentials(isProxy <> 0, CefString(host), port, CefString(realm), CefString(scheme),
      TCefAuthCallbackRef.UnWrap(callback)));
end;

procedure TCefUrlrequestClientOwn.OnRequestComplete(const request: ICefUrlRequest);
begin
  { empty }
end;

procedure TCefUrlrequestClientOwn.OnUploadProgress(const request: ICefUrlRequest;
  current, total: Int64);
begin
  { empty }
end;

procedure TCefUrlrequestClientOwn.OnDownloadProgress(const request: ICefUrlRequest;
  current, total: Int64);
begin
  { empty }
end;

procedure TCefUrlrequestClientOwn.OnDownloadData(const request: ICefUrlRequest;
  data: Pointer; dataLength: TSize);
begin
  { empty }
end;

function TCefUrlrequestClientOwn.GetAuthCredentials(isProxy: Boolean; const host: ustring;
  port: Integer; const realm, scheme: ustring; callback: ICefAuthCallback): Boolean;
begin
  Result := False;
end;

constructor TCefUrlrequestClientOwn.Create;
begin
  inherited CreateData(SizeOf(TCefUrlRequestClient));
  With PCefUrlRequestClient(FData)^ do
  begin
    on_request_complete := @cef_url_request_client_on_request_complete;
    on_upload_progress := @cef_url_request_client_on_upload_progress;
    on_download_progress := @cef_url_request_client_on_download_progress;
    on_download_data := @cef_url_request_client_on_download_data;
    get_auth_credentials := @cef_url_request_client_get_auth_credentials;
  end;
end;

{ TCefV8HandlerOwn }

function cef_v8_handler_execute(self: PCefV8handler; const name: PCefString; object_: PCefV8value;
  argumentsCount: TSize; arguments: PCefV8ValueArray; out retval: PCefV8value;
  exception: PCefString): Integer; cconv;
Var
  args: ICefV8ValueArray;
  i: Integer;
  r: ICefV8Value;
  e: ustring;
begin
  SetLength(args, argumentsCount);
  If (argumentsCount > 0) then
  begin
    For i := 0 to argumentsCount - 1 do args[i] := TCefV8ValueRef.UnWrap(arguments^[i]);
  end;

  Result := -Ord(TCefV8HandlerOwn(CefGetObject(self)).Execute(
    CefString(name), TCefV8ValueRef.UnWrap(object_), args, r, e));
  retval := CefGetData(r);
  CefStringSet(exception, e);
end;

function TCefV8HandlerOwn.Execute(const name: ustring; const obj: ICefV8Value;
  const arguments: ICefV8ValueArray; var retval: ICefV8Value; var exception: ustring): Boolean;
begin
  Result := False;
end;

constructor TCefV8HandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefV8Handler));

  With PCefV8Handler(fData)^ do
  begin
    execute := @cef_v8_handler_execute;
  end;
end;

{ TCefV8AccessorOwn }

function cef_v8_accessor_get(self: PCefV8accessor; const name: PCefString; object_: PCefV8value;
  out retval: PCefV8value; exception: PCefString): Integer; cconv;
Var
  r: ICefV8Value;
  e: ustring;
begin
  Result := Ord(TCefV8AccessorOwn(CefGetObject(self)).Get(CefString(name),
    TCefV8ValueRef.UnWrap(object_), r, e));
  retval := CefGetData(r);
  CefStringSet(exception, e);
end;


function cef_v8_accessor_put(self: PCefV8accessor; const name: PCefString; object_: PCefV8value;
  value: PCefV8value; exception: PCefString): Integer; cconv;
Var
  e: ustring;
begin
  Result := Ord(TCefV8AccessorOwn(CefGetObject(self)).Put(CefString(name),
    TCefV8ValueRef.UnWrap(object_), TCefV8ValueRef.UnWrap(value), e));
  CefStringSet(exception, e);
end;

function TCefV8AccessorOwn.Get(const name: ustring; const obj: ICefV8Value; out value: ICefV8Value;
  out exception: ustring): Boolean;
begin
  Result := False;
end;

function TCefV8AccessorOwn.Put(const name: ustring; const obj, value: ICefV8Value;
  out exception: ustring): Boolean;
begin
  Result := False;
end;

constructor TCefV8AccessorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefV8Accessor));
  With PCefV8Accessor(FData)^ do
  begin
    get  := @cef_v8_accessor_get;
    set_ := @cef_v8_accessor_put;
  end;
end;

{ TCefV8InterceptorOwn }

function cef_v8_interceptor_get_byname(self: PCefV8Interceptor; const name: PCefString;
  object_: PCefV8Value; out retval: PCefV8Value; exception: PCefString): Integer; cconv;
Var
  r: ICefV8Value;
  e: ustring;
begin
  Result := Ord(TCefV8InterceptorOwn(CefGetObject(self)).GetByName(CefString(name),
    TCefV8ValueRef.UnWrap(object_), r, e));
  retval := CefGetData(r);
  CefStringSet(exception, e);
end;

function cef_v8_interceptor_get_byindex(self: PCefV8Interceptor; index: Integer;
  object_: PCefV8Value; out retval: PCefV8Value; exception: PCefString): Integer; cconv;
Var
  r: ICefV8Value;
  e: ustring;
begin
  Result := Ord(TCefV8InterceptorOwn(CefGetObject(self)).GetByIndex(index,
    TCefV8ValueRef.UnWrap(object_), r, e));
  retval := CefGetData(r);
  CefStringSet(exception, e);
end;

function cef_v8_interceptor_set_byname(self: PCefV8Interceptor; const name: PCefString;
  object_: PCefV8Value; value: PCefV8Value; exception: PCefString): Integer; cconv;
Var
  e: ustring;
begin
  Result := Ord(TCefV8InterceptorOwn(CefGetObject(self)).SetByName(CefString(name),
    TCefV8ValueRef.UnWrap(object_), TCefV8ValueRef.UnWrap(value), e));
  CefStringSet(exception, e);
end;

function cef_v8_interceptor_set_byindex(self: PCefV8Interceptor; index: Integer;
  object_: PCefV8Value; value: PCefV8Value; exception: PCefString): Integer; cconv;
Var
  e: ustring;
begin
  Result := Ord(TCefV8InterceptorOwn(CefGetObject(self)).SetByIndex(index,
    TCefV8ValueRef.UnWrap(object_), TCefV8ValueRef.UnWrap(value), e));
  CefStringSet(exception, e);
end;

function TCefV8InterceptorOwn.GetByName(const name: ustring; const object_: ICefV8Value;
  var retval: ICefV8Value; out exception: ustring): Boolean;
begin
  Result := False;
end;

function TCefV8InterceptorOwn.GetByIndex(const index: Integer; const object_: ICefV8Value;
  var retval: ICefV8Value; out exception: ustring): Boolean;
begin
  Result := False;
end;

function TCefV8InterceptorOwn.SetByName(const name: ustring; const object_, value: ICefV8Value;
  out exception: ustring): Boolean;
begin
  Result := False;
end;

function TCefV8InterceptorOwn.SetByIndex(const index: Integer; const object_, value: ICefV8Value;
  out exception: ustring): Boolean;
begin
  Result := False;
end;

constructor TCefV8InterceptorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefV8Interceptor));
  With PCefV8Interceptor(fData)^ do
  begin
    get_byname := @cef_v8_interceptor_get_byname;
    get_byindex := @cef_v8_interceptor_get_byindex;
    set_byname := @cef_v8_interceptor_set_byname;
    set_byindex := @cef_v8_interceptor_set_byindex;
  end;
end;

{ TCefWebPluginInfoVisitorOwn }

function cef_web_plugin_info_visitor_visit(self: PCefWebPluginInfoVisitor; info: PCefWebPluginInfo;
  count, total: Integer): Integer; cconv;
begin
  Result := Ord(TCefWebPluginInfoVisitorOwn(CefGetObject(self)).
    Visit(TCefWebPluginInfoRef.UnWrap(info), count, total));
end;

function TCefWebPluginInfoVisitorOwn.Visit(const info: ICefWebPluginInfo;
  count, total: Integer): Boolean;
begin
  Result := False;
end;

constructor TCefWebPluginInfoVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefWebPluginInfoVisitor));
  With PCefWebPluginInfoVisitor(FData)^ do
  begin
    visit := @cef_web_plugin_info_visitor_visit;
  end;
end;

{ TCefFastWebPluginInfoVisitor }

function TCefFastWebPluginInfoVisitor.Visit(const info: ICefWebPluginInfo;
  count, total: Integer): Boolean;
begin
  Result := fProc(info, count, total);
end;

constructor TCefFastWebPluginInfoVisitor.Create(const proc: TCefWebPluginInfoVisitorProc);
begin
  inherited Create;
  fProc := proc;
end;

{ TCefWebPluginUnstableCallbackOwn }

procedure cef_web_plugin_unstable_callback_is_unstable(self: PCefWebPluginUnstableCallback;
  const path: PCefString; unstable: Integer); cconv;
begin
  TCefWebPluginUnstableCallbackOwn(CefGetObject(self)).IsUnstable(CefString(path), unstable <> 0);
end;

procedure TCefWebPluginUnstableCallbackOwn.IsUnstable(const path: ustring; unstable: Boolean);
begin
  { empty }
end;

constructor TCefWebPluginUnstableCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefWebPluginUnstableCallback));
  With PCefWebPluginUnstableCallback(FData)^ do
  begin
    is_unstable := @cef_web_plugin_unstable_callback_is_unstable;
  end;
end;

{ TCefFastWebPluginUnstableCallback }

procedure TCefFastWebPluginUnstableCallback.IsUnstable(const path: ustring; unstable: Boolean);
begin
  fCallback(path, unstable);
end;

constructor TCefFastWebPluginUnstableCallback.Create(const callback: TCefWebPluginIsUnstableProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefRegisterCdmCallbackOwn }

procedure cef_register_cdm_callback_on_cdm_registration_complete(self: PCefRegisterCdmCallback;
  result: TCefCdmRegistrationError; const error_message: PCefString); cconv;
begin
  TCefRegisterCdmCallbackOwn(CefGetObject(self)).OnCdmRegistration(result, CefString(error_message));
end;

procedure TCefRegisterCdmCallbackOwn.OnCdmRegistration(result: TCefCdmRegistrationError;
  const errorMessage: ustring);
begin
  { empty }
end;

constructor TCefRegisterCdmCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRegisterCdmCallback));
  With PCefRegisterCdmCallback(fData)^ do
  begin
    on_cdm_registration_complete := @cef_register_cdm_callback_on_cdm_registration_complete;
  end;
end;

{ TCefFastRegisterCdmCallback }

procedure TCefFastRegisterCdmCallback.OnCdmRegistration(result: TCefCdmRegistrationError;
  const errorMessage: ustring);
begin
  fCallback(result, errorMessage);
end;

constructor TCefFastRegisterCdmCallback.Create(const callback: TCefRegisterCdmCallbackProc);
begin
  inherited Create;
  fCallback := callback;
end;

{ TCefStringMapOwn }

function TCefStringMapOwn.GetHandle: TCefStringMap;
begin
  Result := fStringMap;
end;

function TCefStringMapOwn.GetSize: TSize;
begin
  Result := cef_string_map_size(fStringMap);
end;

function TCefStringMapOwn.Find(const key: ustring): ustring;
Var
  s, k : TCefString;
begin
  FillChar(s, SizeOf(s), 0);
  k := CefString(key);
  cef_string_map_find(fStringMap, @k, @s);
  Result := CefString(@s);
end;

function TCefStringMapOwn.GetKey(index: TSize): ustring;
Var
  s : TCefString;
begin
  FillChar(s, SizeOf(s), 0);
  cef_string_map_key(fStringMap, index, s);
  Result := CefString(@s);
end;

function TCefStringMapOwn.GetValue(index: TSize): ustring;
Var
  s : TCefString;
begin
  FillChar(s, SizeOf(s), 0);
  cef_string_map_value(fStringMap, index, s);
  Result := CefString(@s);
end;

procedure TCefStringMapOwn.Append(const key, value: ustring);
Var
  k, v : TCefString;
begin
  k := CefString(key);
  v := CefString(value);
  cef_string_map_append(fStringMap, @k, @v);
end;

procedure TCefStringMapOwn.Clear;
begin
  cef_string_map_clear(fStringMap);
end;

constructor TCefStringMapOwn.Create;
begin
  fStringMap := cef_string_map_alloc();
end;

destructor TCefStringMapOwn.Destroy;
begin
  cef_string_map_free(fStringMap);
end;

{ TCefStringMultimapOwn }

function TCefStringMultimapOwn.GetHandle: TCefStringMultimap;
begin
  Result := fStringMap;
end;

function TCefStringMultimapOwn.GetSize: TSize;
begin
  Result := cef_string_multimap_size(fStringMap);
end;

function TCefStringMultimapOwn.FindCount(const Key: ustring): TSize;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := cef_string_multimap_find_count(fStringMap, @k);
end;

function TCefStringMultimapOwn.GetEnumerate(const Key: ustring; ValueIndex: TSize): ustring;
Var
  k, v : TCefString;
begin
  k := CefString(Key);
  FillChar(v, SizeOf(v), 0);
  cef_string_multimap_enumerate(fStringMap, @k, ValueIndex, v);
  Result := CefString(@v);
end;

function TCefStringMultimapOwn.GetKey(Index: TSize): ustring;
Var
  s : TCefString;
begin
  FillChar(s, SizeOf(s), 0);
  cef_string_multimap_key(fStringMap, Index, s);
  Result := CefString(@s);
end;

function TCefStringMultimapOwn.GetValue(Index: TSize): ustring;
Var
  s : TCefString;
begin
  FillChar(s, SizeOf(s), 0);
  cef_string_multimap_value(fStringMap, Index, s);
  Result := CefString(@s);
end;

procedure TCefStringMultimapOwn.Append(const Key, Value: ustring);
Var
  k, v : TCefString;
begin
  k := CefString(Key);
  v := CefString(Value);
  cef_string_multimap_append(fStringMap, @k, @v);
end;

procedure TCefStringMultimapOwn.Clear;
begin
  cef_string_multimap_clear(fStringMap);
end;

constructor TCefStringMultimapOwn.Create;
begin
  fStringMap := cef_string_multimap_alloc();
end;

destructor TCefStringMultimapOwn.Destroy;
begin
  cef_string_multimap_free(fStringMap);
  inherited;
end;

{ TCefRTTIExtension }
{
function TCefRTTIExtension.GetValue(pi : PTypeInfo; const v : ICefV8Value;
  var ret : TValue) : Boolean;
begin

end;

function TCefRTTIExtension.SetValue(const v : TValue;
  var ret : ICefV8Value) : Boolean;
begin

end;

function TCefRTTIExtension.Execute(const name : ustring;
  const obj : ICefV8Value; const arguments : ICefV8ValueArray;
  var retval : ICefV8Value; var exception : ustring) : Boolean;
begin
  Result := inherited Execute(name, obj, arguments, retval, exception);
end;

constructor TCefRTTIExtension.Create(const value : TValue);
begin

end;

destructor TCefRTTIExtension.Destroy;
begin
  inherited Destroy;
end;

class procedure TCefRTTIExtension.Register(const name : string;
  const value : TValue);
begin

end;
}

end.
