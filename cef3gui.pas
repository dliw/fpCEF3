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
 * Ported to Free Pascal and Linux by d.l.i.w <dev.dliw@gmail.com>
 * based on 'Delphi Chromium Embedded'
 *
 * Repository: http://github.com/dliw/fpCEF3
 *
 *
 * Originally created for Delphi by: Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)


Unit cef3gui;

{$I cef.inc}

Interface

Uses
  Classes,
  cef3lib, cef3intf, cef3class;

Type
  TOnProcessMessageReceived = procedure(Sender: TObject; const Browser: ICefBrowser;
    sourceProcess: TCefProcessId; const message: ICefProcessMessage; out Result: Boolean) of object;

  TOnLoadStart = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame) of object;
  TOnLoadEnd = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer) of object;
  TOnLoadError = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: Integer;
    const errorText, failedUrl: ustring) of object;
  TOnRenderProcessTerminated = procedure(Sender: TObject; const Browser: ICefBrowser; status: TCefTerminationStatus) of object;
  TOnPluginCrashed = procedure(Sender: TObject; const Browser: ICefBrowser; const pluginPath: ustring) of object;

  TOnTakeFocus = procedure(Sender: TObject; const Browser: ICefBrowser; next: Boolean) of object;
  TOnSetFocus = procedure(Sender: TObject; const Browser: ICefBrowser; Source: TCefFocusSource; out Result: Boolean) of object;
  TOnGotFocus = procedure(Sender: TObject; const Browser: ICefBrowser) of object;

  TOnBeforeContextMenu = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const params: ICefContextMenuParams; const model: ICefMenuModel) of object;
  TOnContextMenuCommand = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const params: ICefContextMenuParams; commandId: Integer;
    eventFlags: TCefEventFlags; out Result: Boolean) of object;
  TOnContextMenuDismissed = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame) of object;

  TOnPreKeyEvent = procedure(Sender: TObject; const Browser: ICefBrowser; const event: PCefKeyEvent;
    osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean; out Result: Boolean) of object;
  TOnKeyEvent = procedure(Sender: TObject; const Browser: ICefBrowser; const event: PCefKeyEvent;
    osEvent: TCefEventHandle; out Result: Boolean) of object;

  TOnLoadingStateChange = procedure(Sender: TObject; const Browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean) of object;
  TOnAddressChange = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring) of object;
  TOnTitleChange = procedure(Sender: TObject; const Browser: ICefBrowser; const title: ustring) of object;
  TOnTooltip = procedure(Sender: TObject; const Browser: ICefBrowser; var text: ustring; out Result: Boolean) of object;
  TOnStatusMessage = procedure(Sender: TObject; const Browser: ICefBrowser; const value: ustring) of object;
  TOnConsoleMessage = procedure(Sender: TObject; const Browser: ICefBrowser; const message, Source: ustring; line: Integer; out Result: Boolean) of object;

  TOnBeforeDownload = procedure(Sender: TObject; const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
    const suggestedName: ustring; const callback: ICefBeforeDownloadCallback) of object;
  TOnDownloadUpdated = procedure(Sender: TObject; const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback) of object;

  TOnRequestGeolocationPermission = procedure(Sender: TObject; const Browser: ICefBrowser;
    const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback) of object;
  TOnCancelGeolocationPermission = procedure(Sender: TObject; const Browser: ICefBrowser;
    const requestingUrl: ustring; requestId: Integer) of object;

  TOnJsdialog = procedure(Sender: TObject; const Browser: ICefBrowser; const originUrl, acceptLang: ustring;
    dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
    callback: ICefJsDialogCallback; out suppressMessage: Boolean; out Result: Boolean) of object;
  TOnBeforeUnloadDialog = procedure(Sender: TObject; const Browser: ICefBrowser;
    const messageText: ustring; isReload: Boolean;
    const callback: ICefJsDialogCallback; out Result: Boolean) of object;
  TOnResetDialogState = procedure(Sender: TObject; const Browser: ICefBrowser) of object;

  TOnBeforePopup = procedure(Sender: TObject; const Browser: ICefBrowser;
    const Frame: ICefFrame; const targetUrl, targetFrameName: ustring;
    var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
    var client: ICefClient; var settings: TCefBrowserSettings;
    var noJavascriptAccess: Boolean; out Result: Boolean) of object;

  TOnAfterCreated = procedure(Sender: TObject; const Browser: ICefBrowser) of object;
  TOnBeforeClose = procedure(Sender: TObject; const Browser: ICefBrowser) of object;
  TOnRunModal = procedure(Sender: TObject; const Browser: ICefBrowser; out Result: Boolean) of object;
  TOnClose = procedure(Sender: TObject; const Browser: ICefBrowser; out Result: Boolean) of object;

  TOnBeforeResourceLoad = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const request: ICefRequest; out Result: Boolean) of object;
  TOnGetResourceHandler = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const request: ICefRequest; out Result: ICefResourceHandler) of object;
  TOnResourceRedirect = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    const oldUrl: ustring; var newUrl: ustring) of object;
  TOnGetAuthCredentials = procedure(Sender: TObject; const Browser: ICefBrowser; const Frame: ICefFrame;
    isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
    const callback: ICefAuthCallback; out Result: Boolean) of object;
  TOnQuotaRequest = procedure(Sender: TObject; const Browser: ICefBrowser;
    const originUrl: ustring; newSize: Int64; const callback: ICefQuotaCallback;
    out Result: Boolean) of object;
  TOnGetCookieManager = procedure(Sender: TObject; const Browser: ICefBrowser;
    const mainUrl: ustring; out Result: ICefCookieManager) of object;
  TOnProtocolExecution = procedure(Sender: TObject; const Browser: ICefBrowser;
    const url: ustring; out allowOsExecution: Boolean) of object;

  TOnBeforePluginLoad = procedure(Sender: TObject; const Browser: ICefBrowser;
    const url, policyUrl: ustring; const info: ICefWebPluginInfo; out Result: Boolean) of Object;

  TOnFileDialog = procedure(Sender: TObject; const Browser: ICefBrowser;
    mode: TCefFileDialogMode; const title, defaultFileName: ustring;
    acceptTypes: TStrings; const callback: ICefFileDialogCallback;
    out Result: Boolean) of Object;

  TOnGetRootScreenRect = procedure(Sender: TObject; const Browser: ICefBrowser;
    rect: PCefRect; out Result: Boolean) of Object;
  TOnGetViewRect = procedure(Sender: TObject; const Browser: ICefBrowser;
    rect: PCefRect; out Result: Boolean) of Object;
  TOnGetScreenPoint = procedure(Sender: TObject; const Browser: ICefBrowser;
    viewX, viewY: Integer; screenX, screenY: PInteger; out Result: Boolean) of Object;
  TOnPopupShow = procedure(Sender: TObject; const Browser: ICefBrowser;
    show: Boolean) of Object;
  TOnPopupSize = procedure(Sender: TObject; const Browser: ICefBrowser;
    const rect: PCefRect) of Object;
  TOnPaint = procedure(Sender: TObject; const Browser: ICefBrowser;
    kind: TCefPaintElementType; dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray;
    const buffer: Pointer; width, height: Integer) of Object;
  TOnCursorChange = procedure(Sender: TObject; const Browser: ICefBrowser;
    cursor: TCefCursorHandle) of Object;

  TChromiumOptions = class(TPersistent)
  private
    FJavascript: TCefState;
    FJavascriptOpenWindows: TCefState;
    FJavascriptCloseWindows: TCefState;
    FJavascriptAccessClipboard: TCefState;
    FJavascriptDomPaste: TCefState;
    FCaretBrowsing: TCefState;
    FJava: TCefState;
    FPlugins: TCefState;
    FUniversalAccessFromFileUrls: TCefState;
    FFileAccessFromFileUrls: TCefState;
    FWebSecurity: TCefState;
    FImageLoading: TCefState;
    FImageShrinkStandaloneToFit: TCefState;
    FTextAreaResize: TCefState;
    FPageCache: TCefState;
    FTabToLinks: TCefState;
    FAuthorAndUserStyles: TCefState;
    FLocalStorage: TCefState;
    FDatabases: TCefState;
    FApplicationCache: TCefState;
    FWebgl: TCefState;
    FAcceleratedCompositing: TCefState;
    FDeveloperTools: TCefState;
  published
    property Javascript: TCefState read FJavascript write FJavascript default STATE_DEFAULT;
    property JavascriptOpenWindows: TCefState read FJavascriptOpenWindows write FJavascriptOpenWindows default STATE_DEFAULT;
    property JavascriptCloseWindows: TCefState read FJavascriptCloseWindows write FJavascriptCloseWindows default STATE_DEFAULT;
    property JavascriptAccessClipboard: TCefState read FJavascriptAccessClipboard write FJavascriptAccessClipboard default STATE_DEFAULT;
    property JavascriptDomPaste: TCefState read FJavascriptDomPaste write FJavascriptDomPaste default STATE_DEFAULT;
    property CaretBrowsing: TCefState read FCaretBrowsing write FCaretBrowsing default STATE_DEFAULT;
    property Java: TCefState read FJava write FJava default STATE_DEFAULT;
    property Plugins: TCefState read FPlugins write FPlugins default STATE_DEFAULT;
    property UniversalAccessFromFileUrls: TCefState read FUniversalAccessFromFileUrls write FUniversalAccessFromFileUrls default STATE_DEFAULT;
    property FileAccessFromFileUrls: TCefState read FFileAccessFromFileUrls write FFileAccessFromFileUrls default STATE_DEFAULT;
    property WebSecurity: TCefState read FWebSecurity write FWebSecurity default STATE_DEFAULT;
    property ImageLoading: TCefState read FImageLoading write FImageLoading default STATE_DEFAULT;
    property ImageShrinkStandaloneToFit: TCefState read FImageShrinkStandaloneToFit write FImageShrinkStandaloneToFit default STATE_DEFAULT;
    property TextAreaResize: TCefState read FTextAreaResize write FTextAreaResize default STATE_DEFAULT;
    property PageCache: TCefState read FPageCache write FPageCache default STATE_DEFAULT;
    property TabToLinks: TCefState read FTabToLinks write FTabToLinks default STATE_DEFAULT;
    property AuthorAndUserStyles: TCefState read FAuthorAndUserStyles write FAuthorAndUserStyles default STATE_DEFAULT;
    property LocalStorage: TCefState read FLocalStorage write FLocalStorage default STATE_DEFAULT;
    property Databases: TCefState read FDatabases write FDatabases default STATE_DEFAULT;
    property ApplicationCache: TCefState read FApplicationCache write FApplicationCache default STATE_DEFAULT;
    property Webgl: TCefState read FWebgl write FWebgl default STATE_DEFAULT;
    property AcceleratedCompositing: TCefState read FAcceleratedCompositing write FAcceleratedCompositing default STATE_DEFAULT;
    property DeveloperTools: TCefState read FDeveloperTools write FDeveloperTools default STATE_DEFAULT;
  end;

  TChromiumFontOptions = class(TPersistent)
  private
    FStandardFontFamily: ustring;
    FCursiveFontFamily: ustring;
    FSansSerifFontFamily: ustring;
    FMinimumLogicalFontSize: Integer;
    FFantasyFontFamily: ustring;
    FSerifFontFamily: ustring;
    FDefaultFixedFontSize: Integer;
    FDefaultFontSize: Integer;
    FRemoteFontsDisabled: TCefState;
    FFixedFontFamily: ustring;
    FMinimumFontSize: Integer;
  public
    constructor Create; virtual;
  published
    property StandardFontFamily: ustring read FStandardFontFamily;
    property FixedFontFamily: ustring read FFixedFontFamily write FFixedFontFamily;
    property SerifFontFamily: ustring read FSerifFontFamily write FSerifFontFamily;
    property SansSerifFontFamily: ustring read FSansSerifFontFamily write FSansSerifFontFamily;
    property CursiveFontFamily: ustring read FCursiveFontFamily write FCursiveFontFamily;
    property FantasyFontFamily: ustring read FFantasyFontFamily write FFantasyFontFamily;
    property DefaultFontSize: Integer read FDefaultFontSize write FDefaultFontSize default 0;
    property DefaultFixedFontSize: Integer read FDefaultFixedFontSize write FDefaultFixedFontSize default 0;
    property MinimumFontSize: Integer read FMinimumFontSize write FMinimumFontSize default 0;
    property MinimumLogicalFontSize: Integer read FMinimumLogicalFontSize write FMinimumLogicalFontSize default 0;
    property RemoteFonts: TCefState read FRemoteFontsDisabled write FRemoteFontsDisabled default STATE_DEFAULT;
  end;

  IChromiumEvents = interface
  //['{0C139DB1-0349-4D7F-8155-76FEA6A0126D}']
    procedure GetSettings(var settings: TCefBrowserSettings);
    function doOnProcessMessageReceived(const Browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean;

    procedure doOnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame);
    procedure doOnLoadEnd(const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer);
    procedure doOnLoadError(const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: Integer;
      const errorText, failedUrl: ustring);
    procedure doOnRenderProcessTerminated(const Browser: ICefBrowser; status: TCefTerminationStatus);
    procedure doOnPluginCrashed(const Browser: ICefBrowser; const pluginPath: ustring);

    procedure doOnTakeFocus(const Browser: ICefBrowser; next: Boolean);
    function doOnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean;
    procedure doOnGotFocus(const Browser: ICefBrowser);

    procedure doOnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    function doOnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean;
    procedure doOnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame);

    function doOnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
    function doOnKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean;

    procedure doOnLoadingStateChange(const Browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean);
    procedure doOnAddressChange(const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring);
    procedure doOnTitleChange(const Browser: ICefBrowser; const title: ustring);
    function doOnTooltip(const Browser: ICefBrowser; var text: ustring): Boolean;
    procedure doOnStatusMessage(const Browser: ICefBrowser; const value: ustring);
    function doOnConsoleMessage(const Browser: ICefBrowser; const message, Source: ustring; line: Integer): Boolean;

    procedure doOnRequestGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback);
    procedure doOnCancelGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer);

    procedure doOnBeforeDownload(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
    procedure doOnDownloadUpdated(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
        const callback: ICefDownloadItemCallback);

    function doOnJsdialog(const Browser: ICefBrowser; const originUrl, acceptLang: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean;
    function doOnBeforeUnloadDialog(const Browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean;
    procedure doOnResetDialogState(const Browser: ICefBrowser);

    function doOnBeforePopup(const Browser: ICefBrowser;
      const Frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean): Boolean;
    procedure doOnAfterCreated(const Browser: ICefBrowser);
    procedure doOnBeforeClose(const Browser: ICefBrowser);
    function doOnRunModal(const Browser: ICefBrowser): Boolean;
    function doOnClose(const Browser: ICefBrowser): Boolean;

    function doOnBeforeResourceLoad(const Browser: ICefBrowser; const Frame: ICefFrame;
      const request: ICefRequest): Boolean;
    function doOnGetResourceHandler(const Browser: ICefBrowser; const Frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler;
    procedure doOnResourceRedirect(const Browser: ICefBrowser; const Frame: ICefFrame;
      const oldUrl: ustring; var newUrl: ustring);
    function doOnGetAuthCredentials(const Browser: ICefBrowser; const Frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean;
    function doOnQuotaRequest(const Browser: ICefBrowser; const originUrl: ustring;
      newSize: Int64; const callback: ICefQuotaCallback): Boolean;
    function doOnGetCookieManager(const Browser: ICefBrowser; const mainUrl: ustring): ICefCookieManager;
    procedure doOnProtocolExecution(const Browser: ICefBrowser; const url: ustring; out allowOsExecution: Boolean);
    function doOnBeforePluginLoad(const Browser: ICefBrowser; const url, policyUrl: ustring;
      const info: ICefWebPluginInfo): Boolean;

    function doOnFileDialog(const Browser: ICefBrowser; mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptTypes: TStrings;
      const callback: ICefFileDialogCallback): Boolean;

    function doOnGetRootScreenRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
    function doOnGetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
    function doOnGetScreenPoint(const Browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean;
    procedure doOnPopupShow(const Browser: ICefBrowser; show: Boolean);
    procedure doOnPopupSize(const Browser: ICefBrowser; const rect: PCefRect);
    procedure doOnPaint(const Browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray;
      const buffer: Pointer; width, height: Integer);
    procedure doOnCursorChange(const Browser: ICefBrowser; cursor: TCefCursorHandle);
  end;

  ICefClientHandler = interface ['{E76F6888-D9C3-4FCE-9C23-E89659820A36}']
    procedure Disconnect;
  end;

  TCustomClientHandler = class(TCefClientOwn, ICefClientHandler)
  private
    FEvents: IChromiumEvents;
    FLoadHandler: ICefLoadHandler;
    FFocusHandler: ICefFocusHandler;
    FContextMenuHandler: ICefContextMenuHandler;
    FDialogHandler: ICefDialogHandler;
    FKeyboardHandler: ICefKeyboardHandler;
    FDisplayHandler: ICefDisplayHandler;
    FDownloadHandler: ICefDownloadHandler;
    FGeolocationHandler: ICefGeolocationHandler;
    FJsDialogHandler: ICefJsDialogHandler;
    FLifeSpanHandler: ICefLifeSpanHandler;
    FRenderHandler: ICefRenderHandler;
    FRequestHandler: ICefRequestHandler;
  protected
    function GetContextMenuHandler: ICefContextMenuHandler; override;
    function GetDialogHandler: ICefDialogHandler; override;
    function GetDisplayHandler: ICefDisplayHandler; override;
    function GetDownloadHandler: ICefDownloadHandler; override;
    function GetFocusHandler: ICefFocusHandler; override;
    function GetGeolocationHandler: ICefGeolocationHandler; override;
    function GetJsdialogHandler: ICefJsdialogHandler; override;
    function GetKeyboardHandler: ICefKeyboardHandler; override;
    function GetLifeSpanHandler: ICefLifeSpanHandler; override;
    function GetRenderHandler: ICefRenderHandler; override;
    function GetLoadHandler: ICefLoadHandler; override;
    function GetRequestHandler: ICefRequestHandler; override;
    function OnProcessMessageReceived(const Browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; override;
    procedure Disconnect;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomClientHandlerClass = class of TCustomClientHandler;

  TCustomLoadHandler = class(TCefLoadHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    procedure OnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame); override;
    procedure OnLoadEnd(const Browser: ICefBrowser; const Frame: ICefFrame; httpStatusCode: Integer); override;
    procedure OnLoadError(const Browser: ICefBrowser; const Frame: ICefFrame; errorCode: Integer;
      const errorText, failedUrl: ustring); override;
    procedure OnRenderProcessTerminated(const Browser: ICefBrowser; status: TCefTerminationStatus); override;
    procedure OnPluginCrashed(const Browser: ICefBrowser; const pluginPath: ustring); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomFocusHandler = class(TCefFocusHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    procedure OnTakeFocus(const Browser: ICefBrowser; next: Boolean); override;
    function OnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean; override;
    procedure OnGotFocus(const Browser: ICefBrowser); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomContextMenuHandler = class(TCefContextMenuHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    procedure OnBeforeContextMenu(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel); override;
    function OnContextMenuCommand(const Browser: ICefBrowser; const Frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean; override;
    procedure OnContextMenuDismissed(const Browser: ICefBrowser; const Frame: ICefFrame); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDialogHandler = class(TCefDialogHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    function OnFileDialog(const Browser: ICefBrowser; mode: TCefFileDialogMode;
      const title: ustring; const defaultFileName: ustring;
      acceptTypes: TStrings; const callback: ICefFileDialogCallback): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomKeyboardHandler = class(TCefKeyboardHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    function OnPreKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; override;
    function OnKeyEvent(const Browser: ICefBrowser; const event: PCefKeyEvent;
      osEvent: TCefEventHandle): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDisplayHandler = class(TCefDisplayHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    procedure OnLoadingStateChange(const Browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); override;
    procedure OnAddressChange(const Browser: ICefBrowser; const Frame: ICefFrame; const url: ustring); override;
    procedure OnTitleChange(const Browser: ICefBrowser; const title: ustring); override;
    function OnTooltip(const Browser: ICefBrowser; var text: ustring): Boolean; override;
    procedure OnStatusMessage(const Browser: ICefBrowser; const value: ustring); override;
    function OnConsoleMessage(const Browser: ICefBrowser; const message, Source: ustring; line: Integer): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomDownloadHandler = class(TCefDownloadHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    procedure OnBeforeDownload(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback); override;
    procedure OnDownloadUpdated(const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
        const callback: ICefDownloadItemCallback); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomGeolocationHandler = class(TCefGeolocationHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    procedure OnRequestGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer; const callback: ICefGeolocationCallback); override;
    procedure OnCancelGeolocationPermission(const Browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomJsDialogHandler = class(TCefJsDialogHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    function OnJsdialog(const Browser: ICefBrowser; const originUrl, acceptLang: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; override;
    function OnBeforeUnloadDialog(const Browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean; override;
    procedure OnResetDialogState(const Browser: ICefBrowser); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomLifeSpanHandler = class(TCefLifeSpanHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    function OnBeforePopup(const Browser: ICefBrowser; const Frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; var popupFeatures: TCefPopupFeatures;
      var windowInfo: TCefWindowInfo; var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean): Boolean; override;
    procedure OnAfterCreated(const Browser: ICefBrowser); override;
    procedure OnBeforeClose(const Browser: ICefBrowser); override;
    function RunModal(const Browser: ICefBrowser): Boolean; override;
    function DoClose(const Browser: ICefBrowser): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomRequestHandler = class(TCefRequestHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    function OnBeforeResourceLoad(const Browser: ICefBrowser; const Frame: ICefFrame;
      const request: ICefRequest): Boolean; override;
    function GetResourceHandler(const Browser: ICefBrowser; const Frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler; override;
    procedure OnResourceRedirect(const Browser: ICefBrowser; const Frame: ICefFrame;
      const oldUrl: ustring; var newUrl: ustring); override;
    function GetAuthCredentials(const Browser: ICefBrowser; const Frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean; override;
    function OnQuotaRequest(const Browser: ICefBrowser; const originUrl: ustring;
      newSize: Int64; const callback: ICefQuotaCallback): Boolean; override;
    function GetCookieManager(const Browser: ICefBrowser; const mainUrl: ustring): ICefCookieManager; override;
    procedure OnProtocolExecution(const Browser: ICefBrowser; const url: ustring; out allowOsExecution: Boolean); override;
    function OnBeforePluginLoad(const Browser: ICefBrowser; const url: ustring;
      const policyUrl: ustring; const info: ICefWebPluginInfo): Boolean; override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

  TCustomRenderHandler = class(TCefRenderHandlerOwn)
  private
    FEvent: IChromiumEvents;
  protected
    function GetRootScreenRect(const Browser: ICefBrowser; rect: PCefRect): Boolean; override;
    function GetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean; override;
    function GetScreenPoint(const Browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean; override;
    procedure OnPopupShow(const Browser: ICefBrowser; show: Boolean); override;
    procedure OnPopupSize(const Browser: ICefBrowser; const rect: PCefRect); override;
    procedure OnPaint(const Browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray;
      const buffer: Pointer; width, height: Integer); override;
    procedure OnCursorChange(const Browser: ICefBrowser; cursor: TCefCursorHandle); override;
  public
    constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

Implementation

{ TChromiumFontOptions }

constructor TChromiumFontOptions.Create;
begin
  FStandardFontFamily := '';
  FCursiveFontFamily := '';
  FSansSerifFontFamily := '';
  FMinimumLogicalFontSize := 0;
  FFantasyFontFamily := '';
  FSerifFontFamily := '';
  FDefaultFixedFontSize := 0;
  FDefaultFontSize := 0;
  FRemoteFontsDisabled := STATE_DEFAULT;
  FFixedFontFamily := '';
  FMinimumFontSize := 0;
end;

{ TCefCustomHandler }

constructor TCustomClientHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvents := events;
  FLoadHandler := TCustomLoadHandler.Create(events);
  FFocusHandler := TCustomFocusHandler.Create(events);
  FContextMenuHandler := TCustomContextMenuHandler.Create(events);
  FDialogHandler := TCustomDialogHandler.Create(events);
  FKeyboardHandler := TCustomKeyboardHandler.Create(events);
  FDisplayHandler := TCustomDisplayHandler.Create(events);
  FDownloadHandler := TCustomDownloadHandler.Create(events);
  FGeolocationHandler := TCustomGeolocationHandler.Create(events);
  FJsDialogHandler := TCustomJsDialogHandler.Create(events);
  FLifeSpanHandler := TCustomLifeSpanHandler.Create(events);
  FRequestHandler := TCustomRequestHandler.Create(events);
  FRenderHandler := TCustomRenderHandler.Create(events);
end;

procedure TCustomClientHandler.Disconnect;
begin
  FEvents := nil;
  FLoadHandler := nil;
  FFocusHandler := nil;
  FContextMenuHandler := nil;
  FDialogHandler := nil;
  FKeyboardHandler := nil;
  FDisplayHandler := nil;
  FDownloadHandler := nil;
  FGeolocationHandler := nil;
  FJsDialogHandler := nil;
  FLifeSpanHandler := nil;
  FRequestHandler := nil;
  FRenderHandler := nil;
end;

function TCustomClientHandler.GetContextMenuHandler: ICefContextMenuHandler;
begin
  Result := FContextMenuHandler;
end;

function TCustomClientHandler.GetDialogHandler: ICefDialogHandler;
begin
  Result := FDialogHandler;
end;

function TCustomClientHandler.GetDisplayHandler: ICefDisplayHandler;
begin
  Result := FDisplayHandler;
end;

function TCustomClientHandler.GetDownloadHandler: ICefDownloadHandler;
begin
  Result := FDownloadHandler;
end;

function TCustomClientHandler.GetFocusHandler: ICefFocusHandler;
begin
  Result := FFocusHandler;
end;

function TCustomClientHandler.GetGeolocationHandler: ICefGeolocationHandler;
begin
  Result := FGeolocationHandler;
end;

function TCustomClientHandler.GetJsdialogHandler: ICefJsDialogHandler;
begin
  Result := FJsDialogHandler;
end;

function TCustomClientHandler.GetKeyboardHandler: ICefKeyboardHandler;
begin
  Result := FKeyboardHandler;
end;

function TCustomClientHandler.GetLifeSpanHandler: ICefLifeSpanHandler;
begin
  Result := FLifeSpanHandler;
end;

function TCustomClientHandler.GetLoadHandler: ICefLoadHandler;
begin
  Result := FLoadHandler;
end;

function TCustomClientHandler.GetRenderHandler: ICefRenderHandler;
begin
  Result := FRenderHandler;
end;

function TCustomClientHandler.GetRequestHandler: ICefRequestHandler;
begin
  Result := FRequestHandler;
end;

function TCustomClientHandler.OnProcessMessageReceived(
  const Browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
begin
  Result := FEvents.doOnProcessMessageReceived(Browser, sourceProcess, message);
end;

{ TCustomLoadHandler }

constructor TCustomLoadHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

procedure TCustomLoadHandler.OnLoadEnd(const Browser: ICefBrowser;
  const Frame: ICefFrame; httpStatusCode: Integer);
begin
  FEvent.doOnLoadEnd(Browser, Frame, httpStatusCode);
end;

procedure TCustomLoadHandler.OnLoadError(const Browser: ICefBrowser;
  const Frame: ICefFrame; errorCode: Integer; const errorText,
  failedUrl: ustring);
begin
  FEvent.doOnLoadError(Browser, Frame, errorCode, errorText, failedUrl);
end;

procedure TCustomLoadHandler.OnLoadStart(const Browser: ICefBrowser; const Frame: ICefFrame);
begin
  FEvent.doOnLoadStart(Browser, Frame);
end;

procedure TCustomLoadHandler.OnPluginCrashed(const Browser: ICefBrowser; const pluginPath: ustring);
begin
  FEvent.doOnPluginCrashed(Browser, pluginPath);
end;

procedure TCustomLoadHandler.OnRenderProcessTerminated(
const Browser: ICefBrowser; status: TCefTerminationStatus);
begin
  FEvent.doOnRenderProcessTerminated(Browser, status);
end;

{ TCustomFocusHandler }

constructor TCustomFocusHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

procedure TCustomFocusHandler.OnGotFocus(const Browser: ICefBrowser);
begin
  FEvent.doOnGotFocus(Browser);
end;

function TCustomFocusHandler.OnSetFocus(const Browser: ICefBrowser; Source: TCefFocusSource): Boolean;
begin
  Result := FEvent.doOnSetFocus(Browser, Source);
end;

procedure TCustomFocusHandler.OnTakeFocus(const Browser: ICefBrowser;
  next: Boolean);
begin
  FEvent.doOnTakeFocus(Browser, next);
end;

{ TCustomContextMenuHandler }

constructor TCustomContextMenuHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

procedure TCustomContextMenuHandler.OnBeforeContextMenu(
  const Browser: ICefBrowser; const Frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  FEvent.doOnBeforeContextMenu(Browser, Frame, params, model);
end;

function TCustomContextMenuHandler.OnContextMenuCommand(
  const Browser: ICefBrowser; const Frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags): Boolean;
begin
  Result := FEvent.doOnContextMenuCommand(Browser, Frame, params, commandId,
    eventFlags);
end;

procedure TCustomContextMenuHandler.OnContextMenuDismissed(
  const Browser: ICefBrowser; const Frame: ICefFrame);
begin
  FEvent.doOnContextMenuDismissed(Browser, Frame);
end;

{ TCustomKeyboardHandler }

constructor TCustomKeyboardHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomKeyboardHandler.OnKeyEvent(const Browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle): Boolean;
begin
  Result := FEvent.doOnKeyEvent(Browser, event, osEvent);
end;

function TCustomKeyboardHandler.OnPreKeyEvent(const Browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle;
  out isKeyboardShortcut: Boolean): Boolean;
begin
  Result := FEvent.doOnPreKeyEvent(Browser, event, osEvent, isKeyboardShortcut);
end;

{ TCustomDisplayHandler }

constructor TCustomDisplayHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

procedure TCustomDisplayHandler.OnAddressChange(const Browser: ICefBrowser;
  const Frame: ICefFrame; const url: ustring);
begin
  FEvent.doOnAddressChange(Browser, Frame, url);
end;

function TCustomDisplayHandler.OnConsoleMessage(const Browser: ICefBrowser;
  const message, Source: ustring; line: Integer): Boolean;
begin
  Result := FEvent.doOnConsoleMessage(Browser, message, Source, line);
end;

procedure TCustomDisplayHandler.OnLoadingStateChange(const Browser: ICefBrowser;
  isLoading, canGoBack, canGoForward: Boolean);
begin
  FEvent.doOnLoadingStateChange(Browser, isLoading, canGoBack, canGoForward);
end;

procedure TCustomDisplayHandler.OnStatusMessage(const Browser: ICefBrowser;
  const value: ustring);
begin
  FEvent.doOnStatusMessage(Browser, value);
end;

procedure TCustomDisplayHandler.OnTitleChange(const Browser: ICefBrowser; const title: ustring);
begin
  FEvent.doOnTitleChange(Browser, title);
end;

function TCustomDisplayHandler.OnTooltip(const Browser: ICefBrowser; var text: ustring): Boolean;
begin
  Result := FEvent.doOnTooltip(Browser, text);
end;

{ TCustomDownloadHandler }

constructor TCustomDownloadHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

procedure TCustomDownloadHandler.OnBeforeDownload(const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
begin
  FEvent.doOnBeforeDownload(Browser, downloadItem, suggestedName, callback);
end;

procedure TCustomDownloadHandler.OnDownloadUpdated(const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin
  FEvent.doOnDownloadUpdated(Browser, downloadItem, callback);
end;

{ TCustomGeolocationHandler }

constructor TCustomGeolocationHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

procedure TCustomGeolocationHandler.OnCancelGeolocationPermission(
  const Browser: ICefBrowser; const requestingUrl: ustring; requestId: Integer);
begin
  FEvent.doOnCancelGeolocationPermission(Browser, requestingUrl, requestId);
end;

procedure TCustomGeolocationHandler.OnRequestGeolocationPermission(
  const Browser: ICefBrowser; const requestingUrl: ustring; requestId: Integer;
  const callback: ICefGeolocationCallback);
begin
  FEvent.doOnRequestGeolocationPermission(Browser, requestingUrl, requestId, callback);
end;

{ TCustomJsDialogHandler }

constructor TCustomJsDialogHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomJsDialogHandler.OnBeforeUnloadDialog(const Browser: ICefBrowser;
  const messageText: ustring; isReload: Boolean;
  const callback: ICefJsDialogCallback): Boolean;
begin
  Result := FEvent.doOnBeforeUnloadDialog(Browser, messageText, isReload, callback);
end;

function TCustomJsDialogHandler.OnJsdialog(const Browser: ICefBrowser;
  const originUrl, acceptLang: ustring; dialogType: TCefJsDialogType;
  const messageText, defaultPromptText: ustring; callback: ICefJsDialogCallback;
  out suppressMessage: Boolean): Boolean;
begin
  Result := FEvent.doOnJsdialog(Browser, originUrl, acceptLang, dialogType,
    messageText, defaultPromptText, callback, suppressMessage);
end;

procedure TCustomJsDialogHandler.OnResetDialogState(const Browser: ICefBrowser);
begin
  FEvent.doOnResetDialogState(Browser);
end;

{ TCustomLifeSpanHandler }

constructor TCustomLifeSpanHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomLifeSpanHandler.DoClose(const Browser: ICefBrowser): Boolean;
begin
  Result := FEvent.doOnClose(Browser);
end;

procedure TCustomLifeSpanHandler.OnAfterCreated(const Browser: ICefBrowser);
begin
  FEvent.doOnAfterCreated(Browser);
end;

procedure TCustomLifeSpanHandler.OnBeforeClose(const Browser: ICefBrowser);
begin
  FEvent.doOnBeforeClose(Browser);
end;


function TCustomLifeSpanHandler.OnBeforePopup(const Browser: ICefBrowser;
  const Frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  Result := FEvent.doOnBeforePopup(Browser, Frame, targetUrl, targetFrameName,
    popupFeatures, windowInfo, client, settings, noJavascriptAccess);
end;

function TCustomLifeSpanHandler.RunModal(const Browser: ICefBrowser): Boolean;
begin
  Result := FEvent.doOnRunModal(Browser);
end;

{ TCustomRequestHandler }

constructor TCustomRequestHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomRequestHandler.GetAuthCredentials(const Browser: ICefBrowser;
  const Frame: ICefFrame; isProxy: Boolean; const host: ustring; port: Integer;
  const realm, scheme: ustring; const callback: ICefAuthCallback): Boolean;
begin
  Result := FEvent.doOnGetAuthCredentials(Browser, Frame, isProxy, host, port,
    realm, scheme, callback);
end;

function TCustomRequestHandler.GetCookieManager(const Browser: ICefBrowser;
  const mainUrl: ustring): ICefCookieManager;
begin
  Result := FEvent.doOnGetCookieManager(Browser, mainUrl);
end;

function TCustomRequestHandler.GetResourceHandler(const Browser: ICefBrowser;
  const Frame: ICefFrame; const request: ICefRequest): ICefResourceHandler;
begin
  Result := FEvent.doOnGetResourceHandler(Browser, Frame, request);
end;

function TCustomRequestHandler.OnBeforePluginLoad(const Browser: ICefBrowser;
  const url, policyUrl: ustring; const info: ICefWebPluginInfo): Boolean;
begin
  Result := FEvent.doOnBeforePluginLoad(Browser, url, policyUrl, info);
end;

function TCustomRequestHandler.OnBeforeResourceLoad(const Browser: ICefBrowser;
  const Frame: ICefFrame; const request: ICefRequest): Boolean;
begin
  Result := FEvent.doOnBeforeResourceLoad(Browser, Frame, request);
end;

procedure TCustomRequestHandler.OnProtocolExecution(const Browser: ICefBrowser;
  const url: ustring; out allowOsExecution: Boolean);
begin
  FEvent.doOnProtocolExecution(Browser, url, allowOsExecution);
end;

function TCustomRequestHandler.OnQuotaRequest(const Browser: ICefBrowser;
  const originUrl: ustring; newSize: Int64;
  const callback: ICefQuotaCallback): Boolean;
begin
  Result := FEvent.doOnQuotaRequest(Browser, originUrl, newSize, callback);
end;

procedure TCustomRequestHandler.OnResourceRedirect(const Browser: ICefBrowser;
  const Frame: ICefFrame; const oldUrl: ustring; var newUrl: ustring);
begin
  FEvent.doOnResourceRedirect(Browser, Frame, oldUrl, newUrl);
end;

{ TCustomDialogHandler }

constructor TCustomDialogHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomDialogHandler.OnFileDialog(const Browser: ICefBrowser;
  mode: TCefFileDialogMode; const title, defaultFileName: ustring;
  acceptTypes: TStrings; const callback: ICefFileDialogCallback): Boolean;
begin
  Result := FEvent.doOnFileDialog(Browser, mode, title,
    defaultFileName, acceptTypes, callback)
end;

{ TCustomRenderHandler }

constructor TCustomRenderHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomRenderHandler.GetRootScreenRect(const Browser: ICefBrowser;
  rect: PCefRect): Boolean;
begin
  Result := FEvent.doOnGetRootScreenRect(Browser, rect);
end;

function TCustomRenderHandler.GetScreenPoint(const Browser: ICefBrowser; viewX,
  viewY: Integer; screenX, screenY: PInteger): Boolean;
begin
  Result := FEvent.doOnGetScreenPoint(Browser, viewX, viewY, screenX, screenY);
end;

function TCustomRenderHandler.GetViewRect(const Browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := FEvent.doOnGetViewRect(Browser, rect);
end;

procedure TCustomRenderHandler.OnCursorChange(const Browser: ICefBrowser; cursor: TCefCursorHandle);
begin
  FEvent.doOnCursorChange(Browser, cursor);
end;

procedure TCustomRenderHandler.OnPaint(const Browser: ICefBrowser;
  kind: TCefPaintElementType; dirtyRectsCount: Cardinal;
  const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer);
begin
  FEvent.doOnPaint(Browser, kind, dirtyRectsCount, dirtyRects, buffer, width, height);
end;

procedure TCustomRenderHandler.OnPopupShow(const Browser: ICefBrowser; show: Boolean);
begin
  FEvent.doOnPopupShow(Browser, show);
end;

procedure TCustomRenderHandler.OnPopupSize(const Browser: ICefBrowser; const rect: PCefRect);
begin
  FEvent.doOnPopupSize(Browser, rect);
end;

end.