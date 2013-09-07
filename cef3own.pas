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
 *
 * Based on 'Delphi Chromium Embedded' by: Henri Gourvest <hgourvest@gmail.com>
 * Repository : http://code.google.com/p/delphichromiumembedded/
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
  Classes, SysUtils, Math, LCLProc,
  cef3api, cef3types, cef3intf;

Type
  TCefBaseOwn = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
  public
    function Wrap: Pointer;
    constructor CreateData(size: TSize; owned: Boolean = False); virtual;
    destructor Destroy; override;
  end;

  TCefAppOwn = class(TCefBaseOwn, ICefApp)
  protected
    procedure OnBeforeCommandLineProcessing(const processType: ustring;
      const commandLine: ICefCommandLine); virtual; abstract;
    procedure OnRegisterCustomSchemes(const registrar: ICefSchemeRegistrar); virtual; abstract;
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
    procedure OnRegisterCustomSchemes(const registrar: ICefSchemeRegistrar); override;
    function GetResourceBundleHandler: ICefResourceBundleHandler; override;
    function GetBrowserProcessHandler: ICefBrowserProcessHandler; override;
    function GetRenderProcessHandler: ICefRenderProcessHandler; override;
  end;

  TCefRunFileDialogCallbackOwn = class(TCefBaseOwn, ICefRunFileDialogCallback)
  protected
    procedure Cont(const browserHost: ICefBrowserHost; filePaths: TStrings); virtual;
  public
    constructor Create;
  end;

  TCefFastRunFileDialogCallback = class(TCefRunFileDialogCallbackOwn)
  private
    FCallback: TCefRunFileDialogCallbackProc;
  protected
    procedure Cont(const browserHost: ICefBrowserHost; filePaths: TStrings); override;
  public
    constructor Create(callback: TCefRunFileDialogCallbackProc); reintroduce; virtual;
  end;

  TCefBrowserProcessHandlerOwn = class(TCefBaseOwn, ICefBrowserProcessHandler)
  protected
    procedure OnContextInitialized; virtual;
    procedure OnBeforeChildProcessLaunch(const commandLine: ICefCommandLine); virtual;
    procedure OnRenderProcessThreadCreated(extra_info:ICefListValue); virtual;
  public
    constructor Create; virtual;
  end;

  TCefClientOwn = class(TCefBaseOwn, ICefClient)
  protected
    function GetContextMenuHandler: ICefContextMenuHandler; virtual;
    function GetDialogHandler:ICefDialogHandler; virtual;
    function GetDisplayHandler: ICefDisplayHandler; virtual;
    function GetDownloadHandler: ICefDownloadHandler; virtual;
    function GetDragHandler: ICefDragHandler; virtual;
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
    function OnContextMenuCommand(const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags): Boolean; virtual;
    procedure OnContextMenuDismissed(const browser: ICefBrowser; const frame: ICefFrame); virtual;
  public
    constructor Create; virtual;
  end;

  TCefCookieVisitorOwn = class(TCefBaseOwn, ICefCookieVisitor)
  protected
    function Visit(const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      count, total: Integer; out deleteCookie: Boolean): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastCookieVisitor = class(TCefCookieVisitorOwn)
  private
    FVisitor: TCefCookieVisitorProc;
  protected
    function Visit(const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      count, total: Integer; out deleteCookie: Boolean): Boolean; override;
  public
    constructor Create(const visitor: TCefCookieVisitorProc); reintroduce;
  end;

  TCefDialogHandlerOwn = class(TCefBaseOwn, ICefDialogHandler)
  protected
    function OnFileDialog(const browser:ICefBrowser; mode:TCefFileDialogMode;
      const title, default_file_name:ustring;
      accept_types:TStrings; callback:ICefFileDialogCallback):Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefDisplayHandlerOwn = class(TCefBaseOwn, ICefDisplayHandler)
  protected
    procedure OnLoadingStateChange(const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;
    procedure OnAddressChange(const browser: ICefBrowser; const frame: ICefFrame; const url: ustring); virtual;
    procedure OnTitleChange(const browser: ICefBrowser; const title: ustring); virtual;
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
    FProc: TCefDomVisitorProc;
  protected
    procedure Visit(const document: ICefDomDocument); override;
  public
    constructor Create(const proc: TCefDomVisitorProc); reintroduce; virtual;
  end;

  TCefDomEventListenerOwn = class(TCefBaseOwn, ICefDomEventListener)
  protected
    procedure HandleEvent(const event: ICefDomEvent); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastDomEventListener = class(TCefDomEventListenerOwn)
  private
    FProc: TCefDomEventListenerProc;
  protected
    procedure HandleEvent(const event: ICefDomEvent); override;
  public
    constructor Create(const proc: TCefDomEventListenerProc); reintroduce; virtual;
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

  TCefFocusHandlerOwn = class(TCefBaseOwn, ICefFocusHandler)
  protected
    procedure OnTakeFocus(const browser: ICefBrowser; next: Boolean); virtual;
    function OnSetFocus(const browser: ICefBrowser; source: TCefFocusSource): Boolean; virtual;
    procedure OnGotFocus(const browser: ICefBrowser); virtual;
  public
    constructor Create; virtual;
  end;

  TCefGeolocationHandlerOwn = class(TCefBaseOwn, ICefGeolocationHandler)
  protected
    procedure OnRequestGeolocationPermission(const browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer;
      const callback: ICefGeolocationCallback); virtual;
    procedure OnCancelGeolocationPermission(const browser: ICefBrowser;
      const requestingUrl: ustring; requestId: Integer); virtual;
  public
    constructor Create; virtual;
  end;

  TCefJsDialogHandlerOwn = class(TCefBaseOwn, ICefJsDialogHandler)
  protected
    function OnJsdialog(const browser: ICefBrowser; const originUrl, acceptLang: ustring;
      dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
      callback: ICefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
    function OnBeforeUnloadDialog(const browser: ICefBrowser;
      const messageText: ustring; isReload: Boolean;
      const callback: ICefJsDialogCallback): Boolean; virtual;
    procedure OnResetDialogState(const browser: ICefBrowser); virtual;
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
    function OnBeforePopup(const parentBrowser: ICefBrowser; const frame: ICefFrame;
      var target_url: ustring; const targetFrameName: ustring;
      var popupFeatures: TCefPopupFeatures; var windowInfo:TCefWindowInfo; var client: ICefClient;
      var settings: TCefBrowserSettings; var no_javascript_access: Boolean): Boolean; virtual;
    procedure OnAfterCreated(const browser: ICefBrowser); virtual;
    function RunModal(const browser: ICefBrowser): Boolean; virtual;
    function DoClose(const browser: ICefBrowser): Boolean; virtual;
    procedure OnBeforeClose(const browser: ICefBrowser); virtual;
  public
    constructor Create; virtual;
  end;

  TCefLoadHandlerOwn = class(TCefBaseOwn, ICefLoadHandler)
  protected
    procedure OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame); virtual;
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer); virtual;
    procedure OnLoadError(const browser: ICefBrowser; const frame: ICefFrame; errorCode: TCefErrorCode;
      const errorText, failedUrl: ustring); virtual;
    procedure OnRenderProcessTerminated(const browser: ICefBrowser; status: TCefTerminationStatus); virtual;
    procedure OnPluginCrashed(const browser: ICefBrowser; const pluginPath: ustring); virtual;
  public
    constructor Create; virtual;
  end;

  TCefRenderHandlerOwn = class(TCefBaseOwn, ICefRenderHandler)
  protected
    function GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean; virtual;
    function GetScreenInfo(browser: ICefBrowser; screenInfo: PCefScreenInfo): Boolean;
    procedure OnPopupShow(const browser: ICefBrowser; show: Boolean); virtual;
    procedure OnPopupSize(const browser: ICefBrowser; const rect: PCefRect); virtual;
    procedure OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray;
      const buffer: Pointer; width, height: Integer); virtual;
    procedure OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle); virtual;
    procedure OnScrollOffsetChanged(browser: ICefBrowser);
  public
    constructor Create; virtual;
  end;

  TCefRenderProcessHandlerOwn = class(TCefBaseOwn, ICefRenderProcessHandler)
  protected
    procedure OnRenderThreadCreated(const ExtraInfo:ICefListValue); virtual;
    procedure OnWebKitInitialized; virtual;
    procedure OnBrowserCreated(const browser: ICefBrowser); virtual;
    procedure OnBrowserDestroyed(const browser: ICefBrowser); virtual;
    function OnBeforeNavigation(const browser:ICefBrowser;
        const frame:ICefFrame; const request:ICefRequest;
        const navigation_type:TCefNavigationType;
        const is_redirect:integer):boolean; virtual;
    procedure OnContextCreated(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefv8Context); virtual;
    procedure OnContextReleased(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefv8Context); virtual;
    procedure OnUncaughtException(const browser:ICefBrowser;
      const frame:ICefFrame; const context:ICefV8Context;
      const exception:ICefV8Exception; const stackTrace:ICefV8StackTrace); virtual;
{
    procedure OnWorkerContextCreated(const worker_id:integer; const url:ustring;
      const context:ICefV8Context); virtual;
    procedure OnWorkerContextReleased(const worker_id:integer; const url:ustring;
      const context:ICefV8Context); virtual;
    procedure OnWorkerUncaughtException(const worker_id:integer; const url:ustring;
      const context:ICefV8Context; const exception:ICefV8Exception;
      const stackTrace:ICefV8StackTrace); virtual;
}
    procedure OnFocusedNodeChanged(const browser: ICefBrowser;
      const frame: ICefFrame; const node: ICefDomNode); virtual;
    function OnProcessMessageReceived(const browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefPostDataElementOwn = class(TCefBaseOwn, ICefPostDataElement)
  private
    FDataType: TCefPostDataElementType;
    FValueByte: Pointer;
    FValueStr: TCefString;
    FSize: Cardinal;
    FReadOnly: Boolean;
    procedure Clear;
  protected
    function IsReadOnly: Boolean; virtual;
    procedure SetToEmpty; virtual;
    procedure SetToFile(const fileName: ustring); virtual;
    procedure SetToBytes(size: Cardinal; bytes: Pointer); virtual;
    function GetType: TCefPostDataElementType; virtual;
    function GetFile: ustring; virtual;
    function GetBytesCount: Cardinal; virtual;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal; virtual;
  public
    constructor Create(readonly: Boolean); virtual;
  end;

  TCefRequestHandlerOwn = class(TCefBaseOwn, ICefRequestHandler)
  protected
    function OnBeforeResourceLoad(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest): Boolean; virtual;
    function GetResourceHandler(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest): ICefResourceHandler; virtual;
    procedure OnResourceRedirect(const browser: ICefBrowser; const frame: ICefFrame;
      const oldUrl: ustring; var newUrl: ustring); virtual;
    function GetAuthCredentials(const browser: ICefBrowser; const frame: ICefFrame;
      isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
      const callback: ICefAuthCallback): Boolean; virtual;
    function OnQuotaRequest(const browser: ICefBrowser; const originUrl: ustring;
      newSize: Int64; const callback: ICefQuotaCallback): Boolean; virtual;
    function GetCookieManager(const browser: ICefBrowser; const mainUrl: ustring): ICefCookieManager; virtual;
    procedure OnProtocolExecution(const browser: ICefBrowser; const url: ustring; out allowOsExecution: Boolean); virtual;
    function OnBeforePluginLoad(const browser: ICefBrowser; const url, policyUrl: ustring;
      const info: ICefWebPluginInfo): Boolean; virtual;
    function OnCertificateError(certError: TCefErrorcode; const requestUrl: ustring;
      callback: ICefAllowCertificateErrorCallback): Boolean; {$NOTE !}
  public
    constructor Create; virtual;
  end;

  TCefResourceBundleHandlerOwn = class(TCefBaseOwn, ICefResourceBundleHandler)
  protected
    function GetLocalizedString(messageId: Integer;
      out stringVal: ustring): Boolean; virtual; abstract;
    function GetDataResource(resourceId: Integer; out data: Pointer;
      out dataSize: TSize): Boolean; virtual; abstract;
  public
    constructor Create; virtual;
  end;

  TCefFastResourceBundle = class(TCefResourceBundleHandlerOwn)
  private
    FGetDataResource: TGetDataResource;
    FGetLocalizedString: TGetLocalizedString;
  protected
    function GetDataResource(resourceId: Integer; out data: Pointer;
      out dataSize: TSize): Boolean; override;
    function GetLocalizedString(messageId: Integer;
      out stringVal: ustring): Boolean; override;
  public
    constructor Create(AGetDataResource: TGetDataResource;
      AGetLocalizedString: TGetLocalizedString); reintroduce;
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

  TCefSchemeHandlerFactoryOwn = class(TCefBaseOwn, ICefSchemeHandlerFactory)
  private
    FClass: TCefResourceHandlerClass;
  protected
    function New(const browser: ICefBrowser; const frame: ICefFrame;
      const schemeName: ustring; const request: ICefRequest): ICefResourceHandler; virtual;
  public
    constructor Create(const AClass: TCefResourceHandlerClass; SyncMainThread: Boolean); virtual;
  end;

  TCefCustomStreamReader = class(TCefBaseOwn, ICefCustomStreamReader)
  private
    FStream: TStream;
    FOwned: Boolean;
  protected
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal; virtual;
    function Seek(offset: Int64; whence: Integer): Integer; virtual;
    function Tell: Int64; virtual;
    function Eof: Boolean; virtual;
  public
    constructor Create(Stream: TStream; Owned: Boolean); overload; virtual;
    constructor Create(const filename: string); overload; virtual;
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
    FVisit: TCefStringVisitorProc;
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

  TCefUrlrequestClientOwn = class(TCefBaseOwn, ICefUrlrequestClient)
  protected
    procedure OnRequestComplete(const request: ICefUrlRequest);
    procedure OnUploadProgress(const request: ICefUrlRequest; current, total: UInt64);
    procedure OnDownloadProgress(const request: ICefUrlRequest; current, total: UInt64);
    procedure OnDownloadData(const request: ICefUrlRequest; data: Pointer; dataLength: Cardinal);
  public
    constructor Create; virtual;
 end;

  TCefv8HandlerOwn = class(TCefBaseOwn, ICefv8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefV8AccessorOwn = class(TCefBaseOwn, ICefV8Accessor)
  protected
    function Get(const name: ustring; const obj: ICefv8Value;
      out value: ICefv8Value; const exception: string): Boolean; virtual;
    function Put(const name: ustring; const obj, value: ICefv8Value;
      const exception: string): Boolean; virtual;
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
    FProc: TCefWebPluginInfoVisitorProc;
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
    FCallback: TCefWebPluginIsUnstableProc;
  protected
    procedure IsUnstable(const path: ustring; unstable: Boolean); override;
  public
    constructor Create(const callback: TCefWebPluginIsUnstableProc); reintroduce;
  end;

  TCefStringMapOwn = class(TInterfacedObject, ICefStringMap)
  private
    FStringMap: TCefStringMap;
  protected
    function GetHandle: TCefStringMap; virtual;
    function GetSize: Integer; virtual;
    function Find(const key: ustring): ustring; virtual;
    function GetKey(index: Integer): ustring; virtual;
    function GetValue(index: Integer): ustring; virtual;
    procedure Append(const key, value: ustring); virtual;
    procedure Clear; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TCefStringMultimapOwn = class(TInterfacedObject, ICefStringMultimap)
  private
    FStringMap: TCefStringMultimap;
  protected
    function GetHandle: TCefStringMultimap; virtual;
    function GetSize: Integer; virtual;
    function FindCount(const Key: ustring): Integer; virtual;
    function GetEnumerate(const Key: ustring; ValueIndex: Integer): ustring; virtual;
    function GetKey(Index: Integer): ustring; virtual;
    function GetValue(Index: Integer): ustring; virtual;
    procedure Append(const Key, Value: ustring); virtual;
    procedure Clear; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;


{
  TCefRTTIExtension = class(TCefv8HandlerOwn)
  private
    FValue: TValue;
    FCtx: TRttiContext;
    {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
    FSyncMainThread: Boolean;
    {$ENDIF}
    function GetValue(pi: PTypeInfo; const v: ICefv8Value; var ret: TValue): Boolean;
    function SetValue(const v: TValue; var ret: ICefv8Value): Boolean;
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; override;
  public
    constructor Create(const value: TValue{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}; SyncMainThread: Boolean{$ENDIF}); reintroduce;
    destructor Destroy; override;
    class procedure Register(const name: string; const value: TValue{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}; SyncMainThread: Boolean{$ENDIF});
  end;
}

  ECefException = class(Exception)
  end;


Implementation

Uses cef3lib, cef3ref;

{ TCefBaseOwn }

function cef_base_add_ref(self : PCefBase) : Integer; cconv;
begin
  Result := TCefBaseOwn(CefGetObject(self))._AddRef;
end;

function cef_base_release(self : PCefBase) : Integer; cconv;
begin
  Result := TCefBaseOwn(CefGetObject(self))._Release;
end;

function cef_base_get_refct(self : PCefBase) : Integer; cconv;
begin
  Result := TCefBaseOwn(CefGetObject(self)).RefCount;
end;

function cef_base_add_ref_owned(self : PCefBase): Integer; cconv;
begin
  Result := 1;
end;

function cef_base_release_owned(self : PCefBase): Integer; cconv;
begin
  Result := 1;
end;

function cef_base_get_refct_owned(self : PCefBase): Integer; cconv;
begin
  Result := 1;
end;

function TCefBaseOwn.Wrap : Pointer;
begin
  Result := FData;
  If Assigned(PCefBase(FData)^.add_ref) then PCefBase(FData)^.add_ref(FData);
end;

constructor TCefBaseOwn.CreateData(size : TSize; owned : Boolean);
begin
  GetMem(FData, size + SizeOf(Pointer));
  PPointer(FData)^ := Self;
  Inc(FData, SizeOf(Pointer));
  FillChar(FData^, size, 0);
  PCefBase(FData)^.size := size;

  If owned then
  begin
    PCefBase(FData)^.add_ref := @cef_base_add_ref_owned;
    PCefBase(FData)^.release := @cef_base_release_owned;
    PCefBase(FData)^.get_refct := @cef_base_get_refct_owned;
  end
  Else
  begin
    PCefBase(FData)^.add_ref := @cef_base_add_ref;
    PCefBase(FData)^.release := @cef_base_release;
    PCefBase(FData)^.get_refct := @cef_base_get_refct;
  end;
end;

destructor TCefBaseOwn.Destroy;
begin
  Dec(FData, SizeOf(Pointer));
  FreeMem(FData);

  inherited;
end;

{ TCefAppOwn }

procedure cef_app_on_before_command_line_processing(self : PCefApp;
  const process_type : PCefString; command_line : PCefCommandLine); cconv;
begin
  With TCefAppOwn(CefGetObject(self)) do
    OnBeforeCommandLineProcessing(CefString(process_type), TCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_app_on_register_custom_schemes(self : PCefApp; registrar : PCefSchemeRegistrar); cconv;
begin
  With TCefAppOwn(CefGetObject(self)) do OnRegisterCustomSchemes(TCefSchemeRegistrarRef.UnWrap(registrar));
end;

function cef_app_get_resource_bundle_handler(self : PCefApp) : PCefResourceBundleHandler; cconv;
begin
  Result := CefGetData(TCefAppOwn(CefGetObject(self)).GetResourceBundleHandler());
end;

function cef_app_get_browser_process_handler(self : PCefApp) : PCefBrowserProcessHandler; cconv;
begin
  Result := CefGetData(TCefAppOwn(CefGetObject(self)).GetBrowserProcessHandler());
end;

function cef_app_get_render_process_handler(self : PCefApp) : PCefRenderProcessHandler; cconv;
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

procedure TInternalApp.OnBeforeCommandLineProcessing(const processType : ustring; const commandLine : ICefCommandLine);
begin
  If Assigned(CefOnBeforeCommandLineProcessing) then CefOnBeforeCommandLineProcessing(processType, commandLine);
end;

procedure TInternalApp.OnRegisterCustomSchemes(const registrar : ICefSchemeRegistrar);
begin
  If Assigned(CefOnRegisterCustomSchemes) then CefOnRegisterCustomSchemes(registrar);
end;

function TInternalApp.GetResourceBundleHandler : ICefResourceBundleHandler;
begin
  Result := CefResourceBundleHandler;
end;

function TInternalApp.GetBrowserProcessHandler : ICefBrowserProcessHandler;
begin
  Result := CefBrowserProcessHandler;
end;

function TInternalApp.GetRenderProcessHandler : ICefRenderProcessHandler;
begin
  Result := CefRenderProcessHandler;
end;

{ TCefRunFileDialogCallbackOwn }

procedure cef_run_file_dialog_callback_cont(self : PCefRunFileDialogCallback;
  browser_host : PCefBrowserHost; file_paths : TCefStringList); cconv;
var
  list : TStringList;
  i    : Integer;
  item  : TCefString;
begin
  list := TStringList.Create;
  try
    For i := 0 to cef_string_list_size(file_paths) - 1 do
    begin
      FillChar(item, SizeOf(item), 0);
      cef_string_list_value(file_paths, i, @item);
      list.Add(CefStringClearAndGet(item));
    end;
    With TCefRunFileDialogCallbackOwn(CefGetObject(self)) do
      cont(TCefBrowserHostRef.UnWrap(browser_host), list);
  finally
    list.Free;
  end;
end;

procedure TCefRunFileDialogCallbackOwn.Cont(const browserHost : ICefBrowserHost; filePaths : TStrings);
begin
  { empty }
end;

constructor TCefRunFileDialogCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRunFileDialogCallback));
  With PCefRunFileDialogCallback(FData)^ do
  begin
    cont := @cef_run_file_dialog_callback_cont;
  end;
end;

{ TCefFastRunFileDialogCallback }

procedure TCefFastRunFileDialogCallback.Cont(const browserHost : ICefBrowserHost; filePaths : TStrings);
begin
  FCallback(browserHost, filePaths);
end;

constructor TCefFastRunFileDialogCallback.Create(callback : TCefRunFileDialogCallbackProc);
begin
  inherited Create;
  FCallback := callback;
end;

{ TCefBrowserProcessHandlerOwn }

procedure cef_browser_process_handler_on_context_initialized(self : PCefBrowserProcessHandler); cconv;
begin
  With TCefBrowserProcessHandlerOwn(CefGetObject(self)) do
    OnContextInitialized;
end;

procedure cef_browser_process_handler_on_before_child_process_launch(
  self : PCefBrowserProcessHandler; command_line : PCefCommandLine); cconv;
begin
  With TCefBrowserProcessHandlerOwn(CefGetObject(self)) do
    OnBeforeChildProcessLaunch(TCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_browser_render_process_thread_created(self : PCefBrowserProcessHandler; extra_info : PCefListValue); cconv;
begin
  {$NOTE TODO}
  {With TCefBrowserProcessHandlerOwn(CefGetObject(self)) do
    OnRenderProcessThreadCreated(TCefExtraInfoRef.}
end;

procedure TCefBrowserProcessHandlerOwn.OnContextInitialized;
begin
  { empty }
end;

procedure TCefBrowserProcessHandlerOwn.OnBeforeChildProcessLaunch(const commandLine : ICefCommandLine);
begin
  { empty }
end;

procedure TCefBrowserProcessHandlerOwn.OnRenderProcessThreadCreated(extra_info : ICefListValue);
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
    on_render_process_thread_created := @cef_browser_render_process_thread_created;
  end;
end;

{ TCefClientOwn }

function cef_client_get_context_menu_handler(self : PCefClient) : PCefContextMenuHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetContextMenuHandler);
end;

function cef_client_get_dialog_handler(self : PCefClient) : PCefDialogHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetDialogHandler);
end;

function cef_client_get_display_handler(self : PCefClient) : PCefDisplayHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetDisplayHandler);
end;

function cef_client_get_download_handler(self : PCefClient) : PCefDownloadHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetDownloadHandler);
end;

function cef_client_get_focus_handler(self : PCefClient) : PCefFocusHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetFocusHandler);
end;

function cef_client_get_geolocation_handler(self : PCefClient) : PCefGeolocationHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetGeolocationHandler);
end;

function cef_client_get_jsdialog_handler(self : PCefClient) : PCefJsDialogHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetJsdialogHandler);
end;

function cef_client_get_keyboard_handler(self : PCefClient) : PCefKeyboardHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetKeyboardHandler);
end;

function cef_client_get_life_span_handler(self : PCefClient) : PCefLifeSpanHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetLifeSpanHandler);
end;

function cef_client_get_load_handler(self : PCefClient) : PCefLoadHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetLoadHandler);
end;

function cef_client_get_request_handler(self : PCefClient) : PCefRequestHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do Result := CefGetData(GetRequestHandler);
end;

function cef_client_on_process_message_received(self : PCefClient; browser : PCefBrowser;
  source_process : TCefProcessId; message : PCefProcessMessage) : Integer; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := Ord(OnProcessMessageReceived(TCefBrowserRef.UnWrap(browser), source_process, TCefProcessMessageRef.UnWrap(message)));
end;

function TCefClientOwn.GetContextMenuHandler : ICefContextMenuHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDialogHandler : ICefDialogHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDisplayHandler : ICefDisplayHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDownloadHandler : ICefDownloadHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetDragHandler : ICefDragHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetFocusHandler : ICefFocusHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetGeolocationHandler : ICefGeolocationHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetJsdialogHandler : ICefJsdialogHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetKeyboardHandler : ICefKeyboardHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetLifeSpanHandler : ICefLifeSpanHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetLoadHandler : ICefLoadHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetRenderHandler : ICefRenderHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetRequestHandler : ICefRequestHandler;
begin
  Result := nil;
end;

function TCefClientOwn.OnProcessMessageReceived(const browser : ICefBrowser;
  sourceProcess : TCefProcessId; const message : ICefProcessMessage) : Boolean;
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
    get_focus_handler := @cef_client_get_focus_handler;
    get_geolocation_handler := @cef_client_get_geolocation_handler;
    get_jsdialog_handler := @cef_client_get_jsdialog_handler;
    get_keyboard_handler := @cef_client_get_keyboard_handler;
    get_life_span_handler := @cef_client_get_life_span_handler;
    get_load_handler := @cef_client_get_load_handler;
    get_request_handler := @cef_client_get_request_handler;
    on_process_message_received := @cef_client_on_process_message_received;
  end;
end;

{ TCefContextMenuHandlerOwn }

procedure cef_context_menu_handler_on_before_context_menu(self: PCefContextMenuHandler;
  browser : PCefBrowser; frame : PCefFrame; params : PCefContextMenuParams;
  model : PCefMenuModel); cconv;
begin
  With TCefContextMenuHandlerOwn(CefGetObject(self)) do
    OnBeforeContextMenu(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), TCefMenuModelRef.UnWrap(model));
end;

function cef_context_menu_handler_on_context_menu_command(self : PCefContextMenuHandler;
  browser : PCefBrowser; frame : PCefFrame; params : PCefContextMenuParams;
  command_id : Integer; event_flags : TCefEventFlags) : Integer; cconv;
begin
  With TCefContextMenuHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnContextMenuCommand(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), command_id, TCefEventFlags(Pointer(@event_flags)^)));
end;

procedure cef_context_menu_handler_on_context_menu_dismissed(self : PCefContextMenuHandler;
  browser : PCefBrowser; frame : PCefFrame); cconv;
begin
  With TCefContextMenuHandlerOwn(CefGetObject(self)) do
    OnContextMenuDismissed(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame));
end;

procedure TCefContextMenuHandlerOwn.OnBeforeContextMenu(const browser : ICefBrowser;
  const frame : ICefFrame; const params : ICefContextMenuParams; const model : ICefMenuModel);
begin
  { empty }
end;

function TCefContextMenuHandlerOwn.OnContextMenuCommand(const browser : ICefBrowser;
  const frame : ICefFrame; const params : ICefContextMenuParams;
  commandId : Integer; eventFlags : TCefEventFlags) : Boolean;
begin
  Result := False;
end;

procedure TCefContextMenuHandlerOwn.OnContextMenuDismissed(const browser : ICefBrowser; const frame : ICefFrame);
begin
  { empty }
end;

constructor TCefContextMenuHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefContextMenuHandler));
  With PCefContextMenuHandler(FData)^ do
  begin
    on_before_context_menu := @cef_context_menu_handler_on_before_context_menu;
    on_context_menu_command := @cef_context_menu_handler_on_context_menu_command;
    on_context_menu_dismissed := @cef_context_menu_handler_on_context_menu_dismissed;
  end;
end;

{ TCefCookieVisitorOwn }

function cef_cookie_visitor_visit(self : PCefCookieVisitor; const cookie : PCefCookie;
  count, total : Integer; deleteCookie : PInteger) : Integer; cconv;
Var
  delete : Boolean;
  exp    : TDateTime;
begin
  delete := False;
  If cookie^.has_expires then exp := CefTimeToDateTime(cookie^.expires)
  Else exp := 0;
  Result := Ord(TCefCookieVisitorOwn(CefGetObject(self)).visit(CefString(@cookie^.name),
    CefString(@cookie^.value), CefString(@cookie^.domain), CefString(@cookie^.path),
    cookie^.secure, cookie^.httponly, cookie^.has_expires, CefTimeToDateTime(cookie^.creation),
    CefTimeToDateTime(cookie^.last_access), exp, count, total, delete));
  deleteCookie^ := Ord(delete);
end;

function TCefCookieVisitorOwn.Visit(const name, value, domain, path : ustring;
  secure, httponly, hasExpires : Boolean;
  const creation, lastAccess, expires : TDateTime; count, total : Integer;
  out deleteCookie : Boolean) : Boolean;
begin
  Result := True;
end;

constructor TCefCookieVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefCookieVisitor));
  With PCefCookieVisitor(FData)^ do
  begin
    visit := @cef_cookie_visitor_visit;
  end;
end;

{ TCefFastCookieVisitor }

function TCefFastCookieVisitor.Visit(const name, value, domain, path : ustring;
  secure, httponly, hasExpires : Boolean;
  const creation, lastAccess, expires : TDateTime; count, total : Integer;
  out deleteCookie : Boolean) : Boolean;
begin
  Result := FVisitor(name, value, domain, path, secure, httponly, hasExpires, creation, lastAccess, expires, count, total, deleteCookie);
end;

constructor TCefFastCookieVisitor.Create(const visitor : TCefCookieVisitorProc);
begin
  inherited Create;
  FVisitor := visitor;
end;

{ TCefDialogHandlerOwn }

function cef_dialog_handler_on_file_dialog(self : PCefDialogHandler; browser : PCefBrowser;
  mode : TCefFileDialogMode; const title, default_file_name : PCefString;
  accept_types : TCefStringList; callback : PCefFileDialogCallback) : Integer; cconv;
var
  list : TStringList;
  i    : Integer;
  item : TCefString;
begin
  list := TStringList.Create;
  try
    For i := 0 to cef_string_list_size(accept_types) - 1 do
    begin
      FillChar(item, SizeOf(item), 0);
      cef_string_list_value(accept_types, i, @item);
      list.Add(CefStringClearAndGet(item));
    end;

    With TCefDialogHandlerOwn(CefGetObject(self)) do
      Result := Ord(OnFileDialog(TCefBrowserRef.UnWrap(browser), mode, CefString(title),
        CefString(default_file_name), list, TCefFileDialogCallbackRef.UnWrap(callback)));
  finally
    list.Free;
  end;
end;

function TCefDialogHandlerOwn.OnFileDialog(const browser : ICefBrowser;
  mode : TCefFileDialogMode; const title : ustring;
  const default_file_name : ustring; accept_types : TStrings;
  callback : ICefFileDialogCallback) : Boolean;
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

procedure cef_display_handler_on_loading_state_change(self : PCefDisplayHandler;
  browser : PCefBrowser; isLoading, canGoBack, canGoForward : Integer); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnLoadingStateChange(TCefBrowserRef.UnWrap(browser), isLoading <> 0,
      canGoBack <> 0, canGoForward <> 0);
end;

procedure cef_display_handler_on_address_change(self : PCefDisplayHandler;
  browser : PCefBrowser; frame : PCefFrame; const url : PCefString); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnAddressChange(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      cefstring(url)
    );
end;

procedure cef_display_handler_on_title_change(self : PCefDisplayHandler;
  browser : PCefBrowser; const title : PCefString); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnTitleChange(TCefBrowserRef.UnWrap(browser), CefString(title));
end;

function cef_display_handler_on_tooltip(self : PCefDisplayHandler;
  browser : PCefBrowser; text : PCefString) : Integer; cconv;
Var
  t : ustring;
begin
  t := CefStringClearAndGet(text^);
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnTooltip(TCefBrowserRef.UnWrap(browser), t));
  text^ := CefStringAlloc(t);
end;

procedure cef_display_handler_on_status_message(self : PCefDisplayHandler;
  browser : PCefBrowser; const value : PCefString); cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnStatusMessage(TCefBrowserRef.UnWrap(browser), CefString(value));
end;

function cef_display_handler_on_console_message(self : PCefDisplayHandler;
    browser : PCefBrowser; const message : PCefString;
    const source : PCefString; line : Integer) : Integer; cconv;
begin
  With TCefDisplayHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnConsoleMessage(TCefBrowserRef.UnWrap(browser),
    CefString(message), CefString(source), line));
end;

procedure TCefDisplayHandlerOwn.OnLoadingStateChange(const browser : ICefBrowser;
  isLoading, canGoBack, canGoForward : Boolean);
begin
  { empty }
end;

procedure TCefDisplayHandlerOwn.OnAddressChange(const browser : ICefBrowser;
  const frame : ICefFrame; const url : ustring);
begin
  { empty }
end;

procedure TCefDisplayHandlerOwn.OnTitleChange(const browser : ICefBrowser;
  const title : ustring);
begin
  { empty }
end;

function TCefDisplayHandlerOwn.OnTooltip(const browser : ICefBrowser;
  var text : ustring) : Boolean;
begin
  Result := False
end;

procedure TCefDisplayHandlerOwn.OnStatusMessage(const browser : ICefBrowser;
  const value : ustring);
begin
  { empty }
end;

function TCefDisplayHandlerOwn.OnConsoleMessage(const browser : ICefBrowser;
  const message, source : ustring; line : Integer) : Boolean;
begin
  Result := False
end;

constructor TCefDisplayHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDisplayHandler));
  With PCefDisplayHandler(FData)^ do
  begin
    on_loading_state_change := @cef_display_handler_on_loading_state_change;
    on_address_change := @cef_display_handler_on_address_change;
    on_title_change := @cef_display_handler_on_title_change;
    on_tooltip := @cef_display_handler_on_tooltip;
    on_status_message := @cef_display_handler_on_status_message;
    on_console_message := @cef_display_handler_on_console_message;
  end;
end;

{ TCefDomVisitorOwn }

procedure cef_dom_visitor_visite(self : PCefDomVisitor; document : PCefDomDocument); cconv;
begin
  TCefDomVisitorOwn(CefGetObject(self)).visit(TCefDomDocumentRef.UnWrap(document));
end;

procedure TCefDomVisitorOwn.Visit(const document : ICefDomDocument);
begin
  { empty }
end;

constructor TCefDomVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDomVisitor));
  With PCefDomVisitor(FData)^ do
  begin
    visit := @cef_dom_visitor_visite;
  end;
end;

{ TCefFastDomVisitor }

procedure TCefFastDomVisitor.Visit(const document : ICefDomDocument);
begin
  FProc(document);
end;

constructor TCefFastDomVisitor.Create(const proc : TCefDomVisitorProc);
begin
  inherited Create;
  FProc := proc;
end;

{ TCefDomEventListenerOwn }

procedure cef_dom_event_listener_handle_event(self : PCefDomEventListener; event : PCefDomEvent); cconv;
begin
  TCefDomEventListenerOwn(CefGetObject(self)).HandleEvent(TCefDomEventRef.UnWrap(event));
end;

procedure TCefDomEventListenerOwn.HandleEvent(const event : ICefDomEvent);
begin
  { empty }
end;

constructor TCefDomEventListenerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDomEventListener));
  With PCefDomEventListener(FData)^ do
  begin
    handle_event := @cef_dom_event_listener_handle_event;
  end;
end;

{ TCefFastDomEventListener }

procedure TCefFastDomEventListener.HandleEvent(const event : ICefDomEvent);
begin
  inherited;
  FProc(event);
end;

constructor TCefFastDomEventListener.Create(const proc : TCefDomEventListenerProc);
begin
  inherited Create;
  FProc := proc;
end;

{ TCefDownloadHandlerOwn }

procedure cef_download_handler_on_before_download(self : PCefDownloadHandler;
  browser : PCefBrowser; download_item : PCefDownloadItem;
  const suggested_name : PCefString; callback : PCefBeforeDownloadCallback); cconv;
begin
  TCefDownloadHandlerOwn(CefGetObject(self)).
    OnBeforeDownload(TCefBrowserRef.UnWrap(browser),
    TCefDownLoadItemRef.UnWrap(download_item), CefString(suggested_name),
    TCefBeforeDownloadCallbackRef.UnWrap(callback));
end;

procedure cef_download_handler_on_download_updated(self : PCefDownloadHandler;
  browser : PCefBrowser; download_item : PCefDownloadItem; callback : PCefDownloadItemCallback); cconv;
begin
  TCefDownloadHandlerOwn(
    CefGetObject(self)).OnDownloadUpdated(TCefBrowserRef.UnWrap(browser),
    TCefDownLoadItemRef.UnWrap(download_item),
    TCefDownloadItemCallbackRef.UnWrap(callback)
  );
end;

procedure TCefDownloadHandlerOwn.OnBeforeDownload(const browser : ICefBrowser;
  const downloadItem : ICefDownloadItem; const suggestedName : ustring;
  const callback : ICefBeforeDownloadCallback);
begin
  { empty }
end;

procedure TCefDownloadHandlerOwn.OnDownloadUpdated(const browser : ICefBrowser;
  const downloadItem : ICefDownloadItem;
  const callback : ICefDownloadItemCallback);
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

{ TCefFocusHandlerOwn }

procedure cef_focus_handler_on_take_focus(self : PCefFocusHandler;
  browser : PCefBrowser; next : Integer); cconv;
begin
  With TCefFocusHandlerOwn(CefGetObject(self)) do
    OnTakeFocus(TCefBrowserRef.UnWrap(browser), next <> 0);
end;

function cef_focus_handler_on_set_focus(self : PCefFocusHandler;
  browser : PCefBrowser; source : TCefFocusSource) : Integer; cconv;
begin
  With TCefFocusHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnSetFocus(TCefBrowserRef.UnWrap(browser), source))
end;

procedure cef_focus_handler_on_got_focus(self : PCefFocusHandler; browser : PCefBrowser); cconv;
begin
  With TCefFocusHandlerOwn(CefGetObject(self)) do
    OnGotFocus(TCefBrowserRef.UnWrap(browser));
end;

procedure TCefFocusHandlerOwn.OnTakeFocus(const browser : ICefBrowser; next : Boolean);
begin
  { empty }
end;

function TCefFocusHandlerOwn.OnSetFocus(const browser : ICefBrowser; source : TCefFocusSource) : Boolean;
begin
  Result := False;
end;

procedure TCefFocusHandlerOwn.OnGotFocus(const browser : ICefBrowser);
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

{ TCefGeolocationHandlerOwn }

procedure cef_geolocation_handler_on_request_geolocation_permission(self : PCefGeolocationHandler;
  browser : PCefBrowser; const requesting_url : PCefString; request_id : Integer;
  callback : PCefGeolocationCallback); cconv;
begin
  With TCefGeolocationHandlerOwn(CefGetObject(self)) do
    OnRequestGeolocationPermission(
      TCefBrowserRef.UnWrap(browser),
      CefString(requesting_url),
      request_id,
      TCefGeolocationCallbackRef.UnWrap(callback)
  );
end;

procedure cef_geolocation_handler_on_cancel_geolocation_permission(self : PCefGeolocationHandler;
  browser : PCefBrowser; const requesting_url : PCefString; request_id : Integer); cconv;
begin
  With TCefGeolocationHandlerOwn(CefGetObject(self)) do
    OnCancelGeolocationPermission(TCefBrowserRef.UnWrap(browser), CefString(requesting_url), request_id);
end;

procedure TCefGeolocationHandlerOwn.OnRequestGeolocationPermission(const browser : ICefBrowser;
  const requestingUrl : ustring; requestId : Integer;
  const callback : ICefGeolocationCallback);
begin
  { empty }
end;

procedure TCefGeolocationHandlerOwn.OnCancelGeolocationPermission(const browser : ICefBrowser;
  const requestingUrl : ustring; requestId : Integer);
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

function cef_jsdialog_handler_on_jsdialog(self : PCefJsDialogHandler;
  browser : PCefBrowser; const origin_url, accept_lang : PCefString;
  dialog_type : TCefJsDialogType; const message_text, default_prompt_text : PCefString;
  callback : PCefJsDialogCallback; suppress_message : PInteger) : Integer; cconv;
Var
  sm: Boolean;
begin
  sm := suppress_message^ <> 0;
  With TCefJsDialogHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnJsdialog(TCefBrowserRef.UnWrap(browser), CefString(origin_url), CefString(accept_lang),
                             dialog_type, CefString(message_text), CefString(default_prompt_text),
                             TCefJsDialogCallbackRef.UnWrap(callback), sm));
  suppress_message^ := Ord(sm);
end;

function cef_jsdialog_handler_on_before_unload_dialog(self : PCefJsDialogHandler;
  browser : PCefBrowser; const message_text : PCefString; is_reload : Integer;
  callback : PCefJsDialogCallback) : Integer; cconv;
begin
  With TCefJsDialogHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforeUnloadDialog(TCefBrowserRef.UnWrap(browser), CefString(message_text),
      is_reload <> 0, TCefJsDialogCallbackRef.UnWrap(callback)));
end;

procedure cef_jsdialog_handler_on_reset_dialog_state(self : PCefJsDialogHandler; browser : PCefBrowser); cconv;
begin
  With TCefJsDialogHandlerOwn(CefGetObject(self)) do
    OnResetDialogState(TCefBrowserRef.UnWrap(browser));
end;

function TCefJsDialogHandlerOwn.OnJsdialog(const browser : ICefBrowser;
  const originUrl, acceptLang : ustring; dialogType : TCefJsDialogType;
  const messageText, defaultPromptText : ustring;
  callback : ICefJsDialogCallback; out suppressMessage : Boolean) : Boolean;
begin
  Result := False;
end;

function TCefJsDialogHandlerOwn.OnBeforeUnloadDialog(const browser : ICefBrowser;
  const messageText : ustring; isReload : Boolean;
  const callback : ICefJsDialogCallback) : Boolean;
begin
  Result := False;
end;

procedure TCefJsDialogHandlerOwn.OnResetDialogState(const browser : ICefBrowser);
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
  end;
end;

{ TCefKeyboardHandlerOwn }

function cef_keyboard_handler_on_pre_key_event(self : PCefKeyboardHandler;
  browser : PCefBrowser; const event : PCefKeyEvent;
  os_event : TCefEventHandle; is_keyboard_shortcut : PInteger) : Integer; cconv;
Var
  ks: Boolean;
begin
  ks := is_keyboard_shortcut^ <> 0;
  With TCefKeyboardHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnPreKeyEvent(TCefBrowserRef.UnWrap(browser), event, os_event, ks));
  is_keyboard_shortcut^ := Ord(ks);
end;

function cef_keyboard_handler_on_key_event(self : PCefKeyboardHandler; browser : PCefBrowser;
  const event : PCefKeyEvent; os_event : TCefEventHandle) : Integer; cconv;
begin
  With TCefKeyboardHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnKeyEvent(TCefBrowserRef.UnWrap(browser), event, os_event));
end;

function TCefKeyboardHandlerOwn.OnPreKeyEvent(const browser : ICefBrowser;
  const event : PCefKeyEvent; osEvent : TCefEventHandle;
  out isKeyboardShortcut : Boolean) : Boolean;
begin
  Result := False;
end;

function TCefKeyboardHandlerOwn.OnKeyEvent(const browser : ICefBrowser;
  const event : PCefKeyEvent; osEvent : TCefEventHandle) : Boolean;
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

function cef_life_span_handler_on_before_popup(self : PCefLifeSpanHandler; parentBrowser : PCefBrowser;
  frame : PCefFrame; const target_url : PCefString; const target_frame_name : PCefString;
  const popupFeatures : PCefPopupFeatures; windowInfo : PCefWindowInfo; var client : PCefClient;
  settings : PCefBrowserSettings; no_javascript_access : PInteger) : Integer; cconv;
Var
  _url,_framename : ustring;
  _nojs           : Boolean;
  _client         : ICefClient;
begin
  _url := CefString(target_url);
  _framename := CefString(target_frame_name);
  _nojs := no_javascript_access^ <> 0;
  CefGetObject(client);
  _client := TCefClientOwn(CefGetObject(client)) as ICefClient;
  With TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforePopup(
                    TCefBrowserRef.UnWrap(parentBrowser),
                    TCefFrameRef.UnWrap(frame),
                    _url,
                    _framename,
                    popupFeatures^,
                    windowInfo^,
                    _client,
                    settings^,
                    _nojs)
                 );
  CefStringSet(target_url, _url);
  client := CefGetData(_client);
  no_javascript_access^ := Ord(_nojs);
  _client := nil;
end;

procedure cef_life_span_handler_on_after_created(self : PCefLifeSpanHandler; browser : PCefBrowser); cconv;
begin
  With TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    OnAfterCreated(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_life_span_handler_on_before_close(self : PCefLifeSpanHandler; browser : PCefBrowser); cconv;
begin
  With TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    OnBeforeClose(TCefBrowserRef.UnWrap(browser));
end;

function cef_life_span_handler_run_modal(self : PCefLifeSpanHandler; browser : PCefBrowser) : Integer; cconv;
begin
  With TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    Result := Ord(RunModal(TCefBrowserRef.UnWrap(browser)));
end;

function cef_life_span_handler_do_close(self : PCefLifeSpanHandler; browser : PCefBrowser) : Integer; cconv;
begin
  With TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    Result := Ord(DoClose(TCefBrowserRef.UnWrap(browser)));
end;

function TCefLifeSpanHandlerOwn.OnBeforePopup(const parentBrowser : ICefBrowser; const frame : ICefFrame;
  var target_url : ustring; const targetFrameName : ustring; var popupFeatures : TCefPopupFeatures;
  var windowInfo : TCefWindowInfo; var client : ICefClient; var settings : TCefBrowserSettings;
  var no_javascript_access : boolean) : Boolean;
begin
  Result := False;
end;

procedure TCefLifeSpanHandlerOwn.OnAfterCreated(const browser : ICefBrowser);
begin
  { empty }
end;

function TCefLifeSpanHandlerOwn.RunModal(const browser : ICefBrowser) : Boolean;
begin
  Result := False;
end;

function TCefLifeSpanHandlerOwn.DoClose(const browser : ICefBrowser) : Boolean;
begin
  Result := False;
end;

procedure TCefLifeSpanHandlerOwn.OnBeforeClose(const browser : ICefBrowser);
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
    on_before_close := @cef_life_span_handler_on_before_close;
    run_modal := @cef_life_span_handler_run_modal;
    do_close := @cef_life_span_handler_do_close;
  end;
end;

{ TCefLoadHandlerOwn }

procedure cef_load_handler_on_load_start(self : PCefLoadHandler; browser : PCefBrowser; frame : PCefFrame); cconv;
begin
  With TCefLoadHandlerOwn(CefGetObject(self)) do
    OnLoadStart(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame));
end;

procedure cef_load_handler_on_load_end(self : PCefLoadHandler; browser : PCefBrowser; frame : PCefFrame;
  httpStatusCode : Integer); cconv;
begin
  With TCefLoadHandlerOwn(CefGetObject(self)) do
    OnLoadEnd(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), httpStatusCode);
end;

procedure cef_load_handler_on_load_error(self : PCefLoadHandler; browser : PCefBrowser; frame : PCefFrame;
  errorCode : TCefErrorCode; const errorText, failedUrl : PCefString); cconv;
begin
  With TCefLoadHandlerOwn(CefGetObject(self)) do
    OnLoadError(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      errorCode, CefString(errorText), CefString(failedUrl));
end;

procedure cef_load_handler_on_render_process_terminated(self : PCefLoadHandler; browser : PCefBrowser;
  status : TCefTerminationStatus); cconv;
begin
  With TCefLoadHandlerOwn(CefGetObject(self)) do
    OnRenderProcessTerminated(TCefBrowserRef.UnWrap(browser), status);
end;

procedure cef_load_handler_on_plugin_crashed(self : PCefLoadHandler; browser : PCefBrowser;
  const plugin_path : PCefString); cconv;
begin
  With TCefLoadHandlerOwn(CefGetObject(self)) do
    OnPluginCrashed(TCefBrowserRef.UnWrap(browser), CefString(plugin_path));
end;

procedure TCefLoadHandlerOwn.OnLoadStart(const browser : ICefBrowser; const frame : ICefFrame);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnLoadEnd(const browser : ICefBrowser;
  const frame : ICefFrame; httpStatusCode : Integer);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnLoadError(const browser : ICefBrowser;
  const frame : ICefFrame; errorCode : TCefErrorCode;
  const errorText, failedUrl : ustring);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnRenderProcessTerminated(const browser : ICefBrowser;
  status : TCefTerminationStatus);
begin
  { empty }
end;

procedure TCefLoadHandlerOwn.OnPluginCrashed(const browser : ICefBrowser;
  const pluginPath : ustring);
begin
  { empty }
end;

constructor TCefLoadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefLoadHandler));
  With PCefLoadHandler(FData)^ do
  begin
    on_load_start := @cef_load_handler_on_load_start;
    on_load_end := @cef_load_handler_on_load_end;
    on_load_error := @cef_load_handler_on_load_error;
    on_render_process_terminated := @cef_load_handler_on_render_process_terminated;
    on_plugin_crashed := @cef_load_handler_on_plugin_crashed;
  end;
end;

{ TCefRenderHandlerOwn }

function cef_render_handler_get_root_screen_rect(self : PCefRenderHandler; browser : PCefBrowser;
  rect : PCefRect) : Integer; cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetRootScreenRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_view_rect(self : PCefRenderHandler; browser : PCefBrowser;
  rect : PCefRect) : Integer; cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetViewRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_screen_point(self : PCefRenderHandler; browser : PCefBrowser;
  viewX, viewY : Integer; screenX, screenY : PInteger) : Integer; cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetScreenPoint(TCefBrowserRef.UnWrap(browser), viewX, viewY, screenX, screenY));
end;

function cef_render_handler_get_screen_info(self : PCefRenderHandler; browser : PCefBrowser;
  screen_info : PCefScreenInfo) : Integer; cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetScreenInfo(TCefBrowserRef.UnWrap(browser), screen_info));
end;

procedure cef_render_handler_on_popup_show(self : PCefRenderHandler; browser : PCefBrowser;
  show : Integer); cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPopupShow(TCefBrowserRef.UnWrap(browser), show <> 0);
end;

procedure cef_render_handler_on_popup_size(self : PCefRenderHandler; browser : PCefBrowser;
  const rect : PCefRect); cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPopupSize(TCefBrowserRef.UnWrap(browser), rect);
end;

procedure cef_render_handler_on_paint(self : PCefRenderHandler; browser: PCefBrowser;
  type_ : TCefPaintElementType; dirtyRectsCount : TSize; const dirtyRects : PCefRectArray;
  const buffer : Pointer; width, height : Integer); cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPaint(TCefBrowserRef.UnWrap(browser), type_, dirtyRectsCount, dirtyRects,
      buffer, width, height);
end;

procedure cef_render_handler_on_cursor_change(self : PCefRenderHandler; browser : PCefBrowser;
  cursor : TCefCursorHandle); cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    OnCursorChange(TCefBrowserRef.UnWrap(browser), cursor);
end;

procedure cef_render_handler_on_scroll_offset_changed(self : PCefRenderHandler; browser : PCefBrowser); cconv;
begin
  With TCefRenderHandlerOwn(CefGetObject(self)) do
    OnScrollOffsetChanged(TCefBrowserRef.UnWrap(browser));
end;

function TCefRenderHandlerOwn.GetRootScreenRect(const browser : ICefBrowser;
  rect : PCefRect) : Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetViewRect(const browser : ICefBrowser;
  rect : PCefRect) : Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenPoint(const browser : ICefBrowser;
  viewX, viewY : Integer; screenX, screenY : PInteger) : Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenInfo(browser : ICefBrowser;
  screenInfo : PCefScreenInfo) : Boolean;
begin
  Result := False;
end;

procedure TCefRenderHandlerOwn.OnPopupShow(const browser : ICefBrowser;
  show : Boolean);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnPopupSize(const browser : ICefBrowser;
  const rect : PCefRect);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnPaint(const browser : ICefBrowser;
  kind : TCefPaintElementType; dirtyRectsCount : Cardinal;
  const dirtyRects : PCefRectArray; const buffer : Pointer;
  width, height : Integer);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnCursorChange(const browser : ICefBrowser;
  cursor : TCefCursorHandle);
begin
  { empty }
end;

procedure TCefRenderHandlerOwn.OnScrollOffsetChanged(browser : ICefBrowser);
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
    on_scroll_offset_changed := @cef_render_handler_on_scroll_offset_changed;
  end;
end;

{ TCefRenderProcessHandlerOwn }

procedure cef_render_process_handler_on_render_thread_created(self : PCefRenderProcessHandler; ExtraInfo : PCefListValue); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnRenderThreadCreated(TCefListValueRef.UnWrap(ExtraInfo));
end;

procedure cef_render_process_handler_on_web_kit_initialized(self : PCefRenderProcessHandler); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnWebKitInitialized;
end;

procedure cef_render_process_handler_on_browser_created(self : PCefRenderProcessHandler;
  browser : PCefBrowser); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnBrowserCreated(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_render_process_handler_on_browser_destroyed(self : PCefRenderProcessHandler;
  browser : PCefBrowser); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnBrowserDestroyed(TCefBrowserRef.UnWrap(browser));
end;

function cef_render_process_handler_on_before_navigation(self : PCefRenderProcessHandler; browser : PCefBrowser;
  frame : PCefFrame; request : PCefRequest; navigation_type : TCefNavigationType;
  is_redirect : Integer) : Integer; cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    result:=ord(OnBeforeNavigation(TCefBrowserRef.UnWrap(browser),TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request),navigation_type,is_redirect));
end;

procedure cef_render_process_handler_on_context_created(self : PCefRenderProcessHandler;
  browser : PCefBrowser; frame : PCefFrame; context : PCefv8Context); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnContextCreated(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), TCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_context_released(self : PCefRenderProcessHandler;
  browser : PCefBrowser; frame : PCefFrame; context : PCefv8Context); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnContextReleased(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), TCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_uncaught_exception(self : PCefRenderProcessHandler;
  browser : PCefBrowser; frame : PCefFrame; context : PCefV8Context; exception : PCefV8Exception;
  stackTrace : PCefV8StackTrace); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnUncaughtException(TCefBrowserRef.UnWrap(browser),TCefFrameRef.UnWrap(frame),
      TCefV8ContextRef.UnWrap(context),TCefV8ExceptionRef.UnWrap(exception),
      TCefV8StackTraceRef.UnWrap(stackTrace));
end;

procedure cef_render_process_handler_on_focused_node_changed(self : PCefRenderProcessHandler;
  browser : PCefBrowser; frame : PCefFrame; node : PCefDomNode); cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnFocusedNodeChanged(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefDomNodeRef.UnWrap(node));
end;

function cef_render_process_handler_on_process_message_received(self : PCefRenderProcessHandler;
  browser : PCefBrowser; source_process : TCefProcessId;
  message : PCefProcessMessage) : Integer; cconv;
begin
  With TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    Result := Ord(OnProcessMessageReceived(TCefBrowserRef.UnWrap(browser), source_process,
      TCefProcessMessageRef.UnWrap(message)));
end;

procedure TCefRenderProcessHandlerOwn.OnRenderThreadCreated(const ExtraInfo : ICefListValue);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnWebKitInitialized;
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnBrowserCreated(const browser : ICefBrowser);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnBrowserDestroyed(const browser : ICefBrowser);
begin
  { empty }
end;

function TCefRenderProcessHandlerOwn.OnBeforeNavigation(const browser : ICefBrowser;
  const frame : ICefFrame; const request : ICefRequest;
  const navigation_type : TCefNavigationType;
  const is_redirect : integer) : boolean;
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnContextCreated(const browser : ICefBrowser;
  const frame : ICefFrame; const context : ICefv8Context);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnContextReleased(const browser : ICefBrowser;
  const frame : ICefFrame; const context : ICefv8Context);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnUncaughtException(const browser : ICefBrowser;
  const frame : ICefFrame; const context : ICefV8Context;
  const exception : ICefV8Exception; const stackTrace : ICefV8StackTrace);
begin
  { empty }
end;

procedure TCefRenderProcessHandlerOwn.OnFocusedNodeChanged(const browser : ICefBrowser;
  const frame : ICefFrame; const node : ICefDomNode);
begin
  { empty }
end;

function TCefRenderProcessHandlerOwn.OnProcessMessageReceived(const browser : ICefBrowser;
  sourceProcess : TCefProcessId; const message : ICefProcessMessage) : Boolean;
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
    on_before_navigation:= @cef_render_process_handler_on_before_navigation;
    on_context_created := @cef_render_process_handler_on_context_created;
    on_context_released := @cef_render_process_handler_on_context_released;
    on_uncaught_exception:= @cef_render_process_handler_on_uncaught_exception;
    on_focused_node_changed := @cef_render_process_handler_on_focused_node_changed;
    on_process_message_received := @cef_render_process_handler_on_process_message_received;
  end;
end;

{ TCefPostDataElementOwn }

function cef_post_data_element_is_read_only(self : PCefPostDataElement) : Integer; cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    Result := Ord(IsReadOnly)
end;

procedure cef_post_data_element_set_to_empty(self : PCefPostDataElement); cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    SetToEmpty;
end;

procedure cef_post_data_element_set_to_file(self : PCefPostDataElement; const fileName : PCefString); cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    SetToFile(CefString(fileName));
end;

procedure cef_post_data_element_set_to_bytes(self : PCefPostDataElement; size : TSize; const bytes : Pointer); cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    SetToBytes(size, bytes);
end;

function cef_post_data_element_get_type(self : PCefPostDataElement) : TCefPostDataElementType; cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetType;
end;

function cef_post_data_element_get_file(self : PCefPostDataElement) : PCefStringUserFree; cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    Result := CefUserFreeString(GetFile);
end;

function cef_post_data_element_get_bytes_count(self : PCefPostDataElement) : TSize; cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytesCount;
end;

function cef_post_data_element_get_bytes(self : PCefPostDataElement; size : TSize; bytes : Pointer) : TSize; cconv;
begin
  With TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytes(size, bytes)
end;

procedure TCefPostDataElementOwn.Clear;
begin
  Case FDataType of
    PDE_TYPE_BYTES:
      If (FValueByte <> nil) then
      begin
        Freemem(FValueByte);
        FValueByte := nil;
      end;
    PDE_TYPE_FILE:
      CefStringFree(@FValueStr);
  end;
  FDataType := PDE_TYPE_EMPTY;
  FSize := 0;
end;

function TCefPostDataElementOwn.IsReadOnly : Boolean;
begin
  Result := FReadOnly;
end;

procedure TCefPostDataElementOwn.SetToEmpty;
begin
  Clear;
end;

procedure TCefPostDataElementOwn.SetToFile(const fileName : ustring);
begin
  Clear;
  FSize := 0;
  FValueStr := CefStringAlloc(fileName);
  FDataType := PDE_TYPE_FILE;
end;

procedure TCefPostDataElementOwn.SetToBytes(size : Cardinal; bytes : Pointer);
begin
  Clear;
  If (size > 0) and (bytes <> nil) then
  begin
    GetMem(FValueByte, size);
    Move(bytes^, FValueByte, size);
    FSize := size;
  end
  Else
  begin
    FValueByte := nil;
    FSize := 0;
  end;
  FDataType := PDE_TYPE_BYTES;
end;

function TCefPostDataElementOwn.GetType : TCefPostDataElementType;
begin
  Result := FDataType;
end;

function TCefPostDataElementOwn.GetFile : ustring;
begin
  If (FDataType = PDE_TYPE_FILE) then Result := CefString(@FValueStr)
  Else Result := '';
end;

function TCefPostDataElementOwn.GetBytesCount : Cardinal;
begin
  If (FDataType = PDE_TYPE_BYTES) then Result := FSize
  Else Result := 0;
end;

function TCefPostDataElementOwn.GetBytes(size : Cardinal;
  bytes : Pointer) : Cardinal;
begin
  If (FDataType = PDE_TYPE_BYTES) and (FValueByte <> nil) then
  begin
    If size > FSize then Result := FSize
    Else Result := size;
    Move(FValueByte^, bytes^, Result);
  end
  Else Result := 0;
end;

constructor TCefPostDataElementOwn.Create(readonly : Boolean);
begin
  inherited CreateData(SizeOf(TCefPostDataElement));

  FReadOnly := readonly;
  FDataType := PDE_TYPE_EMPTY;
  FValueByte := nil;
  FillChar(FValueStr, SizeOf(FValueStr), 0);
  FSize := 0;

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

{ TCefRequestHandlerOwn }

function cef_request_handler_on_before_resource_load(self : PCefRequestHandler; browser : PCefBrowser;
  frame : PCefFrame; request : PCefRequest) : Integer; cconv;
begin
  {$WARNING DEBUG}
  Result := Ord(False);
  {
  With TCefRequestHandlerOwn(CefGetObject(self_)) do
    Result := Ord(OnBeforeResourceLoad(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request)));
  }
end;

function cef_request_handler_get_resource_handler(self : PCefRequestHandler; browser : PCefBrowser;
  frame : PCefFrame; request : PCefRequest) : PCefResourceHandler; cconv;
begin
  {$WARNING DEBUG}
  Result := nil;
  {
  With TCefRequestHandlerOwn(CefGetObject(self_)) do
    Result := CefGetData(GetResourceHandler(TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame), TCefRequestRef.UnWrap(request)));
  }
end;

procedure cef_request_handler_on_resource_redirect(self : PCefRequestHandler; browser : PCefBrowser;
  frame : PCefFrame; const old_url : PCefString; new_url : PCefString); cconv;
Var
  url : ustring;
begin
  url := CefString(new_url);
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    OnResourceRedirect(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      CefString(old_url), url);
  If url <> '' then CefStringSet(new_url, url);
end;

function cef_request_handler_get_auth_credentials(self : PCefRequestHandler; browser: PCefBrowser;
  frame : PCefFrame; isProxy : Integer; const host : PCefString; port : Integer;
  const realm, scheme : PCefString; callback : PCefAuthCallback) : Integer; cconv;
begin
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetAuthCredentials(
      TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), isProxy <> 0,
      CefString(host), port, CefString(realm), CefString(scheme), TCefAuthCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_on_quota_request(self : PCefRequestHandler; browser : PCefBrowser;
  const origin_url : PCefString; new_size : Int64; callback : PCefQuotaCallback) : Integer; cconv;
begin
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnQuotaRequest(TCefBrowserRef.UnWrap(browser),
      CefString(origin_url), new_size, TCefQuotaCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_get_cookie_manager(self : PCefRequestHandler; browser : PCefBrowser;
  const main_url : PCefString) : PCefCookieManager; cconv;
begin
  {$WARNING DEBUG}
  Result := nil;
  {
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := CefGetData(GetCookieManager(TCefBrowserRef.UnWrap(browser), CefString(main_url)));
  }
end;

procedure cef_request_handler_on_protocol_execution(self : PCefRequestHandler; browser : PCefBrowser;
  const url : PCefString; allow_os_execution : PInteger); cconv;
Var
  allow: Boolean;
begin
  allow := allow_os_execution^ <> 0;
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    OnProtocolExecution(TCefBrowserRef.UnWrap(browser), CefString(url), allow);
  allow_os_execution^ := Ord(allow);
end;

function cef_request_handler_on_before_plugin_load(self : PCefRequestHandler; browser : PCefBrowser;
  const url, policy_url : PCefString; info : PCefWebPluginInfo) : Integer; cconv;
begin
  {$WARNING DEBUG}
  Result := Ord(False);
  {
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforePluginLoad(TCefBrowserRef.UnWrap(browser),
      CefString(url), CefString(policy_url), TCefWebPluginInfoRef.UnWrap(info)));
  }
end;

function cef_request_handler_on_certificate_error(self : PCefRequestHandler; cert_error : TCefErrorcode;
  const request_url : PCefString; callback : PCefAllowCertificateErrorCallback) : Integer; cconv;
Var
  r : ustring;
begin
  {$WARNING TODO}
  {
  r := CefString(request_url);
  With TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnCertificateError(cert_error, r,  TCefAllowCertificateErrorCallbackRef.UnWrap(callback));
  }
end;

function TCefRequestHandlerOwn.OnBeforeResourceLoad(const browser : ICefBrowser;
  const frame : ICefFrame; const request : ICefRequest) : Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.GetResourceHandler(const browser : ICefBrowser;
  const frame : ICefFrame; const request : ICefRequest) : ICefResourceHandler;
begin
  Result := nil;
end;

procedure TCefRequestHandlerOwn.OnResourceRedirect(const browser : ICefBrowser;
  const frame : ICefFrame; const oldUrl : ustring; var newUrl : ustring);
begin
  { empty }
end;

function TCefRequestHandlerOwn.GetAuthCredentials(const browser : ICefBrowser;
  const frame : ICefFrame; isProxy : Boolean; const host : ustring;
  port : Integer; const realm, scheme : ustring;
  const callback : ICefAuthCallback) : Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnQuotaRequest(const browser : ICefBrowser;
  const originUrl : ustring; newSize : Int64;
  const callback : ICefQuotaCallback) : Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.GetCookieManager(const browser : ICefBrowser;
  const mainUrl : ustring) : ICefCookieManager;
begin
  Result := nil;
end;

procedure TCefRequestHandlerOwn.OnProtocolExecution(const browser : ICefBrowser;
  const url : ustring; out allowOsExecution : Boolean);
begin
  { empty }
end;

function TCefRequestHandlerOwn.OnBeforePluginLoad(const browser : ICefBrowser;
  const url, policyUrl : ustring; const info : ICefWebPluginInfo) : Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnCertificateError(certError : TCefErrorcode;
  const requestUrl : ustring;
  callback : ICefAllowCertificateErrorCallback) : Boolean;
begin
  Result := False;
end;

constructor TCefRequestHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRequestHandler));
  With PCefRequestHandler(FData)^ do
  begin
    on_before_resource_load := @cef_request_handler_on_before_resource_load;
    get_resource_handler := @cef_request_handler_get_resource_handler;
    on_resource_redirect := @cef_request_handler_on_resource_redirect;
    get_auth_credentials := @cef_request_handler_get_auth_credentials;
    on_quota_request := @cef_request_handler_on_quota_request;
    get_cookie_manager := @cef_request_handler_get_cookie_manager;
    on_protocol_execution := @cef_request_handler_on_protocol_execution;
    on_before_plugin_load := @cef_request_handler_on_before_plugin_load;
    on_certificate_error := @cef_request_handler_on_certificate_error;
  end;
end;

{ TCefResourceBundleHandlerOwn }

function cef_resource_bundle_handler_get_localized_string(self : PCefResourceBundleHandler;
  message_id : Integer; string_val : PCefString) : Integer; cconv;
Var
  str : ustring;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).
    GetLocalizedString(message_id, str));
  If Result <> 0 then string_val^ := CefString(str);
end;

function cef_resource_bundle_handler_get_data_resource(self : PCefResourceBundleHandler;
  resource_id : Integer; var data : Pointer; var data_size : TSize) : Integer; cconv;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).
    GetDataResource(resource_id, data, data_size));
end;

constructor TCefResourceBundleHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefResourceBundleHandler));
  With PCefResourceBundleHandler(FData)^ do
  begin
    get_localized_string := @cef_resource_bundle_handler_get_localized_string;
    get_data_resource := @cef_resource_bundle_handler_get_data_resource;
  end;
end;

{ TCefFastResourceBundle }

function TCefFastResourceBundle.GetDataResource(resourceId : Integer;
  out data : Pointer; out dataSize : TSize) : Boolean;
begin
  If Assigned(FGetDataResource) then Result := FGetDataResource(resourceId, data, dataSize)
  Else Result := False;
end;

function TCefFastResourceBundle.GetLocalizedString(messageId : Integer;
  out stringVal : ustring) : Boolean;
begin
  If Assigned(FGetLocalizedString) then FGetLocalizedString(messageId, stringVal)
  Else Result := False;
end;

constructor TCefFastResourceBundle.Create(AGetDataResource : TGetDataResource;
  AGetLocalizedString : TGetLocalizedString);
begin
  inherited Create;
  FGetDataResource := AGetDataResource;
  FGetLocalizedString := AGetLocalizedString;
end;

{ TCefResourceHandlerOwn }

function cef_resource_handler_process_request(self : PCefResourceHandler; request: PCefRequest;
  callback : PCefCallback) : Integer; cconv;
begin
  With TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(ProcessRequest(TCefRequestRef.UnWrap(request), TCefCallbackRef.UnWrap(callback)));
end;

procedure cef_resource_handler_get_response_headers(self : PCefResourceHandler; response: PCefResponse;
  response_length : PInt64; redirectUrl : PCefString); cconv;
Var
  ru: ustring;
begin
  ru := '';
  With TCefResourceHandlerOwn(CefGetObject(self)) do
    GetResponseHeaders(TCefResponseRef.UnWrap(response), response_length^, ru);
  If ru <> '' then CefStringSet(redirectUrl, ru);
end;

function cef_resource_handler_read_response(self : PCefResourceHandler; data_out : Pointer;
  bytes_to_read : Integer; bytes_read : PInteger; callback : PCefCallback) : Integer; cconv;
begin
  With TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(ReadResponse(data_out, bytes_to_read, bytes_read^, TCefCallbackRef.UnWrap(callback)));
end;

function cef_resource_handler_can_get_cookie(self : PCefResourceHandler; const cookie : PCefCookie) : Integer; cconv;
begin
  With TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(CanGetCookie(cookie));
end;

function cef_resource_handler_can_set_cookie(self : PCefResourceHandler; const cookie:  PCefCookie) : Integer; cconv;
begin
  With TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(CanSetCookie(cookie));
end;

procedure cef_resource_handler_cancel(self: PCefResourceHandler); cconv;
begin
  With TCefResourceHandlerOwn(CefGetObject(self)) do Cancel;
end;

function TCefResourceHandlerOwn.ProcessRequest(const request : ICefRequest;
  const callback : ICefCallback) : Boolean;
begin
  Result := False;
end;

procedure TCefResourceHandlerOwn.GetResponseHeaders(const response : ICefResponse;
  out responseLength : Int64; out redirectUrl : ustring);
begin
  { empty }
end;

function TCefResourceHandlerOwn.ReadResponse(const dataOut : Pointer;
  bytesToRead : Integer; var bytesRead : Integer;
  const callback : ICefCallback) : Boolean;
begin
  Result := False;
end;

function TCefResourceHandlerOwn.CanGetCookie(const cookie : PCefCookie) : Boolean;
begin
  Result := False;
end;

function TCefResourceHandlerOwn.CanSetCookie(const cookie : PCefCookie) : Boolean;
begin
  Result := False;
end;

procedure TCefResourceHandlerOwn.Cancel;
begin
  { empty }
end;

constructor TCefResourceHandlerOwn.Create(const browser : ICefBrowser;
  const frame : ICefFrame; const schemeName : ustring;
  const request : ICefRequest);
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

{ TCefSchemeHandlerFactoryOwn }

function cef_scheme_handler_factory_create(self : PCefSchemeHandlerFactory; browser: PCefBrowser;
  frame : PCefFrame; const scheme_name : PCefString; request : PCefRequest) : PCefResourceHandler; cconv;
begin
  With TCefSchemeHandlerFactoryOwn(CefGetObject(self)) do
    Result := CefGetData(New(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      CefString(scheme_name), TCefRequestRef.UnWrap(request)));
end;

function TCefSchemeHandlerFactoryOwn.New(const browser : ICefBrowser;
  const frame : ICefFrame; const schemeName : ustring;
  const request : ICefRequest) : ICefResourceHandler;
begin
  Result := FClass.Create(browser, frame, schemeName, request);
end;

constructor TCefSchemeHandlerFactoryOwn.Create(const AClass : TCefResourceHandlerClass;
  SyncMainThread : Boolean);
begin
  inherited CreateData(SizeOf(TCefSchemeHandlerFactory));
  FClass := AClass;
  With PCefSchemeHandlerFactory(FData)^ do
  begin
    create := @cef_scheme_handler_factory_create;
  end;
end;

{ TCefCustomStreamReader }

function cef_stream_reader_read(self : PCefReadHandler; ptr : Pointer; size, n : TSize) : TSize; cconv;
begin
  With TCefCustomStreamReader(CefGetObject(self)) do
    Result := Read(ptr, size, n);
end;

function cef_stream_reader_seek(self : PCefReadHandler; offset : Int64; whence : Integer) : Integer; cconv;
begin
  With TCefCustomStreamReader(CefGetObject(self)) do
    Result := Seek(offset, whence);
end;

function cef_stream_reader_tell(self : PCefReadHandler) : Int64; cconv;
begin
  With TCefCustomStreamReader(CefGetObject(self)) do
    Result := Tell;
end;

function cef_stream_reader_eof(self : PCefReadHandler) : Integer; cconv;
begin
  With TCefCustomStreamReader(CefGetObject(self)) do
    Result := Ord(eof);
end;

function TCefCustomStreamReader.Read(ptr : Pointer;
  size, n : Cardinal) : Cardinal;
begin
  Result := Cardinal(FStream.Read(ptr^, n * size)) div size;
end;

function TCefCustomStreamReader.Seek(offset : Int64;
  whence : Integer) : Integer;
begin
  Result := FStream.Seek(offset, whence);
end;

function TCefCustomStreamReader.Tell : Int64;
begin
  Result := FStream.Position;
end;

function TCefCustomStreamReader.Eof : Boolean;
begin
  Result := FStream.Position = FStream.Size;
end;

constructor TCefCustomStreamReader.Create(Stream : TStream; Owned : Boolean);
begin
  inherited CreateData(SizeOf(TCefReadHandler));

  FStream := Stream;
  FOwned := Owned;

  With PCefReadHandler(FData)^ do
  begin
    read := @cef_stream_reader_read;
    seek := @cef_stream_reader_seek;
    tell := @cef_stream_reader_tell;
    eof := @cef_stream_reader_eof;
  end;
end;

constructor TCefCustomStreamReader.Create(const filename : string);
begin
  Create(TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite), True)
end;

destructor TCefCustomStreamReader.Destroy;
begin
  If FOwned then FStream.Free;

  inherited;
end;

{ TCefStringVisitorOwn }

procedure cef_string_visitor_visit(self : PCefStringVisitor; const str : PCefString); cconv;
begin
  TCefStringVisitorOwn(CefGetObject(self)).Visit(CefString(str));
end;


procedure TCefStringVisitorOwn.Visit(const str : ustring);
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

procedure TCefFastStringVisitor.Visit(const str : ustring);
begin
  FVisit(str);
end;

constructor TCefFastStringVisitor.Create(const callback : TCefStringVisitorProc);
begin
  inherited Create;
  FVisit := callback;
end;

{ TCefTaskOwn }

procedure cef_task_execute(self : PCefTask); cconv;
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

{ TCefUrlrequestClientOwn }

procedure cef_url_request_client_on_request_complete(self : PCefUrlRequestClient; request:  PCefUrlRequest); cconv;
begin
  With TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnRequestComplete(TCefUrlRequestRef.UnWrap(request));
end;

procedure cef_url_request_client_on_upload_progress(self : PCefUrlRequestClient; request: PCefUrlRequest;
  current, total : UInt64); cconv;
begin
  With TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnUploadProgress(TCefUrlRequestRef.UnWrap(request), current, total);
end;

procedure cef_url_request_client_on_download_progress(self : PCefUrlRequestClient; request: PCefUrlRequest;
  current, total : UInt64); cconv;
begin
  With TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnDownloadProgress(TCefUrlRequestRef.UnWrap(request), current, total);
end;

procedure cef_url_request_client_on_download_data(self : PCefUrlRequestClient; request : PCefUrlRequest;
  const data : Pointer; data_length : TSize); cconv;
begin
  With TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnDownloadData(TCefUrlRequestRef.UnWrap(request), data, data_length);
end;

procedure TCefUrlrequestClientOwn.OnRequestComplete(const request : ICefUrlRequest);
begin
  { empty }
end;

procedure TCefUrlrequestClientOwn.OnUploadProgress(const request : ICefUrlRequest;
  current, total : UInt64);
begin
  { empty }
end;

procedure TCefUrlrequestClientOwn.OnDownloadProgress(const request : ICefUrlRequest;
  current, total : UInt64);
begin
  { empty }
end;

procedure TCefUrlrequestClientOwn.OnDownloadData(const request : ICefUrlRequest;
  data : Pointer; dataLength : Cardinal);
begin
  { empty }
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
  end;
end;

{ TCefv8HandlerOwn }

function cef_v8_handler_execute(self : PCefV8handler; const name : PCefString; object_ : PCefV8value;
  argumentsCount : TSize; arguments : PPCefV8value; out retval : PCefV8value; exception : TCefString) : Integer; cconv;
Var
  args: TCefv8ValueArray;
  i: Integer;
  ret: ICefv8Value;
  exc: ustring;
begin
  SetLength(args, argumentsCount);
  For i := 0 to argumentsCount - 1 do
    args[i] := TCefv8ValueRef.UnWrap(arguments^[i]);

  Result := -Ord(TCefv8HandlerOwn(CefGetObject(self)).Execute(
    CefString(name), TCefv8ValueRef.UnWrap(object_), args, ret, exc));
  retval := CefGetData(ret);
  ret := nil;
  exception := CefString(exc);
end;

function TCefv8HandlerOwn.Execute(const name : ustring;
  const obj : ICefv8Value; const arguments : TCefv8ValueArray;
  var retval : ICefv8Value; var exception : ustring) : Boolean;
begin
  Result := False;
end;

constructor TCefv8HandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefV8Handler));
  With PCefV8Handler(FData)^ do
  begin
    execute := @cef_v8_handler_execute;
  end;
end;

{ TCefV8AccessorOwn }

function cef_v8_accessor_get(self : PCefV8accessor; const name : PCefString;
  object_ : PCefV8value; out retval : PCefV8value; exception : PCefString) : Integer; cconv;
Var
  ret : ICefv8Value;
begin
  Result := Ord(TCefV8AccessorOwn(CefGetObject(self)).Get(CefString(name),
    TCefv8ValueRef.UnWrap(object_), ret, CefString(exception)));
  retval := CefGetData(ret);
end;


function cef_v8_accessor_put(self : PCefV8accessor; const name : PCefString; object_ : PCefV8value;
  value : PCefV8value; exception : PCefString) : Integer; cconv;
begin
  Result := Ord(TCefV8AccessorOwn(CefGetObject(self)).Put(CefString(name),
    TCefv8ValueRef.UnWrap(object_), TCefv8ValueRef.UnWrap(value), CefString(exception)));
end;

function TCefV8AccessorOwn.Get(const name : ustring; const obj : ICefv8Value;
  out value : ICefv8Value; const exception : string) : Boolean;
begin
  Result := False;
end;

function TCefV8AccessorOwn.Put(const name : ustring;
  const obj, value : ICefv8Value; const exception : string) : Boolean;
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

{ TCefWebPluginInfoVisitorOwn }

function cef_web_plugin_info_visitor_visit(self : PCefWebPluginInfoVisitor; info : PCefWebPluginInfo;
  count, total : Integer) : Integer; cconv;
begin
  With TCefWebPluginInfoVisitorOwn(CefGetObject(self)) do
    Result := Ord(Visit(TCefWebPluginInfoRef.UnWrap(info), count, total));
end;

function TCefWebPluginInfoVisitorOwn.Visit(const info : ICefWebPluginInfo;
  count, total : Integer) : Boolean;
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

function TCefFastWebPluginInfoVisitor.Visit(const info : ICefWebPluginInfo;
  count, total : Integer) : Boolean;
begin
  Result := FProc(info, count, total);
end;

constructor TCefFastWebPluginInfoVisitor.Create(const proc : TCefWebPluginInfoVisitorProc);
begin
  inherited Create;
  FProc := proc;
end;

{ TCefWebPluginUnstableCallbackOwn }

procedure cef_web_plugin_unstable_callback_is_unstable(self : PCefWebPluginUnstableCallback;
  const path : PCefString; unstable : Integer); cconv;
begin
  With TCefWebPluginUnstableCallbackOwn(CefGetObject(self)) do
    IsUnstable(CefString(path), unstable <> 0);
end;

procedure TCefWebPluginUnstableCallbackOwn.IsUnstable(const path : ustring;
  unstable : Boolean);
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

procedure TCefFastWebPluginUnstableCallback.IsUnstable(const path : ustring;
  unstable : Boolean);
begin
  FCallback(path, unstable);
end;

constructor TCefFastWebPluginUnstableCallback.Create(const callback : TCefWebPluginIsUnstableProc);
begin
  FCallback := callback;
end;

{ TCefStringMapOwn }

function TCefStringMapOwn.GetHandle : TCefStringMap;
begin
  Result := FStringMap;
end;

function TCefStringMapOwn.GetSize : Integer;
begin
  Result := cef_string_map_size(FStringMap);
end;

function TCefStringMapOwn.Find(const key : ustring) : ustring;
Var
  str, k : TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  k := CefString(key);
  cef_string_map_find(FStringMap, @k, @str);
  Result := CefString(@str);
end;

function TCefStringMapOwn.GetKey(index : Integer) : ustring;
Var
  str : TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_key(FStringMap, index, str);
  Result := CefString(@str);
end;

function TCefStringMapOwn.GetValue(index : Integer) : ustring;
Var
  str : TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_value(FStringMap, index, str);
  Result := CefString(@str);
end;

procedure TCefStringMapOwn.Append(const key, value : ustring);
Var
  k, v : TCefString;
begin
  k := CefString(key);
  v := CefString(value);
  cef_string_map_append(FStringMap, @k, @v);
end;

procedure TCefStringMapOwn.Clear;
begin
  cef_string_map_clear(FStringMap);
end;

constructor TCefStringMapOwn.Create;
begin
  FStringMap := cef_string_map_alloc;
end;

destructor TCefStringMapOwn.Destroy;
begin
  cef_string_map_free(FStringMap);
end;

{ TCefStringMultimapOwn }

function TCefStringMultimapOwn.GetHandle : TCefStringMultimap;
begin
  Result := FStringMap;
end;

function TCefStringMultimapOwn.GetSize : Integer;
begin
  Result := cef_string_multimap_size(FStringMap);
end;

function TCefStringMultimapOwn.FindCount(const Key : ustring) : Integer;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := cef_string_multimap_find_count(FStringMap, @k);
end;

function TCefStringMultimapOwn.GetEnumerate(const Key : ustring;
  ValueIndex : Integer) : ustring;
Var
  k, v : TCefString;
begin
  k := CefString(Key);
  FillChar(v, SizeOf(v), 0);
  cef_string_multimap_enumerate(FStringMap, @k, ValueIndex, v);
  Result := CefString(@v);
end;

function TCefStringMultimapOwn.GetKey(Index : Integer) : ustring;
Var
  str : TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_multimap_key(FStringMap, Index, str);
  Result := CefString(@str);
end;

function TCefStringMultimapOwn.GetValue(Index : Integer) : ustring;
Var
  str : TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_multimap_value(FStringMap, Index, str);
  Result := CefString(@str);
end;

procedure TCefStringMultimapOwn.Append(const Key, Value : ustring);
Var
  k, v : TCefString;
begin
  k := CefString(Key);
  v := CefString(Value);
  cef_string_multimap_append(FStringMap, @k, @v);
end;

procedure TCefStringMultimapOwn.Clear;
begin
  cef_string_multimap_clear(FStringMap);
end;

constructor TCefStringMultimapOwn.Create;
begin
  FStringMap := cef_string_multimap_alloc;
end;

destructor TCefStringMultimapOwn.Destroy;
begin
  cef_string_multimap_free(FStringMap);
  inherited;
end;

{ TCefRTTIExtension }
{
function TCefRTTIExtension.GetValue(pi : PTypeInfo; const v : ICefv8Value;
  var ret : TValue) : Boolean;
begin

end;

function TCefRTTIExtension.SetValue(const v : TValue;
  var ret : ICefv8Value) : Boolean;
begin

end;

function TCefRTTIExtension.Execute(const name : ustring;
  const obj : ICefv8Value; const arguments : TCefv8ValueArray;
  var retval : ICefv8Value; var exception : ustring) : Boolean;
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
