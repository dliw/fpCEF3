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
 * Ported to Free Pascal by d.l.i.w <dev.dliw@gmail.com>
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

Unit cef3class;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils, Math,
  cef3lib, cef3api, cef3intf,
  LCLProc;

Type

  TCefBaseOwn = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
  public
    function Wrap: Pointer;
    constructor CreateData(size: Cardinal; owned: Boolean = False); virtual;
    destructor Destroy; override;
  end;

  TCefBaseRef = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
  public
    constructor Create(data: Pointer); virtual;
    destructor Destroy; override;
    function Wrap: Pointer;
    class function UnWrap(data: Pointer): ICefBase;
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

  TCefBrowserHostRef = class(TCefBaseRef, ICefBrowserHost)
  protected
    function GetBrowser: ICefBrowser;
    procedure ParentWindowWillClose;
    procedure CloseBrowser;
    procedure SetFocus(enable: Boolean);
    function GetWindowHandle: TCefWindowHandle;
    function GetOpenerWindowHandle: TCefWindowHandle;
    function GetDevToolsUrl(httpScheme: Boolean): ustring;
    function GetZoomLevel: Double;
    procedure SetZoomLevel(zoomLevel: Double);
    procedure RunFileDialog(mode: TCefFileDialogMode; const title, defaultFileName: string;
      acceptTypes: TStrings; const callback: ICefRunFileDialogCallback);
    procedure RunFileDialogProc(mode: TCefFileDialogMode; const title, defaultFileName: string;
      acceptTypes: TStrings; const callback: TCefRunFileDialogCallbackProc);
    function IsWindowRenderingDisabled: Boolean;
    procedure WasResized;
    procedure Invalidate(const dirtyRect: PCefRect; kind: TCefPaintElementType);
    procedure SendKeyEvent(const event: PCefKeyEvent);
    procedure SendMouseClickEvent(const event: PCefMouseEvent;
      kind: TCefMouseButtonType; mouseUp: Boolean; clickCount: Integer);
    procedure SendMouseMoveEvent(const event: PCefMouseEvent; mouseLeave: Boolean);
    procedure SendMouseWheelEvent(const event: PCefMouseEvent; deltaX, deltaY: Integer);
    procedure SendFocusEvent(Focus: Boolean);
    procedure SendCaptureLostEvent;
  public
    class function UnWrap(data: Pointer): ICefBrowserHost;
  end;

  TCefBrowserRef = class(TCefBaseRef, ICefBrowser)
  protected
    function GetHost: ICefBrowserHost;
    function CanGoBack: Boolean;
    procedure GoBack;
    function CanGoForward: Boolean;
    procedure GoForward;
    function IsLoading: Boolean;
    procedure Reload;
    procedure ReloadIgnoreCache;
    procedure StopLoad;
    function GetIdentifier: Integer;
    function IsSame(const that: ICefBrowser): Boolean;
    function IsPopup: Boolean;
    function HasDocument: Boolean;
    function GetMainFrame: ICefFrame;
    function GetFocusedFrame: ICefFrame;
    function GetFrameByident(identifier: Int64): ICefFrame;
    function GetFrame(const name: ustring): ICefFrame;
    function GetFrameCount: Cardinal;
    procedure GetFrameIdentifiers(count: PCardinal; identifiers: PInt64);
    procedure GetFrameNames(names: TStrings);
    function SendProcessMessage(targetProcess: TCefProcessId;
      message: ICefProcessMessage): Boolean;
  public
    class function UnWrap(data: Pointer): ICefBrowser;
  end;

  TCefFrameRef = class(TCefBaseRef, ICefFrame)
  protected
    function IsValid: Boolean;
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Del;
    procedure SelectAll;
    procedure ViewSource;
    procedure GetSource(const visitor: ICefStringVisitor);
    procedure GetSourceProc(const proc: TCefStringVisitorProc);
    procedure GetText(const visitor: ICefStringVisitor);
    procedure GetTextProc(const proc: TCefStringVisitorProc);
    procedure LoadRequest(const request: ICefRequest);
    procedure LoadUrl(const url: ustring);
    procedure LoadString(const str, url: ustring);
    procedure ExecuteJavaScript(const code, scriptUrl: ustring; startLine: Integer);
    function IsMain: Boolean;
    function IsFocused: Boolean;
    function GetName: ustring;
    function GetIdentifier: Int64;
    function GetParent: ICefFrame;
    function GetUrl: ustring;
    function GetBrowser: ICefBrowser;
    function GetV8Context: ICefv8Context;
    procedure VisitDom(const visitor: ICefDomVisitor);
    procedure VisitDomProc(const proc: TCefDomVisitorProc);
  public
    class function UnWrap(data: Pointer): ICefFrame;
  end;

  TCefPostDataRef = class(TCefBaseRef, ICefPostData)
  protected
    function IsReadOnly: Boolean;
    function GetCount: Cardinal;
    function GetElements(Count: Cardinal): IInterfaceList; // ICefPostDataElement
    function RemoveElement(const element: ICefPostDataElement): Integer;
    function AddElement(const element: ICefPostDataElement): Integer;
    procedure RemoveElements;
  public
    class function UnWrap(data: Pointer): ICefPostData;
    class function New: ICefPostData;
  end;

  TCefPostDataElementRef = class(TCefBaseRef, ICefPostDataElement)
  protected
    function IsReadOnly: Boolean;
    procedure SetToEmpty;
    procedure SetToFile(const fileName: ustring);
    procedure SetToBytes(size: Cardinal; bytes: Pointer);
    function GetType: TCefPostDataElementType;
    function GetFile: ustring;
    function GetBytesCount: Cardinal;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal;
  public
    class function UnWrap(data: Pointer): ICefPostDataElement;
    class function New: ICefPostDataElement;
  end;

  TCefRequestRef = class(TCefBaseRef, ICefRequest)
  protected
    function IsReadOnly: Boolean;
    function GetUrl: ustring;
    function GetMethod: ustring;
    function GetPostData: ICefPostData;
    procedure GetHeaderMap(const HeaderMap: ICefStringMultimap);
    procedure SetUrl(const value: ustring);
    procedure SetMethod(const value: ustring);
    procedure SetPostData(const value: ICefPostData);
    procedure SetHeaderMap(const HeaderMap: ICefStringMultimap);
    function GetFlags: TCefUrlRequestFlags;
    procedure SetFlags(flags: TCefUrlRequestFlags);
    function GetFirstPartyForCookies: ustring;
    procedure SetFirstPartyForCookies(const url: ustring);
    procedure Assign(const url, method: ustring;
      const postData: ICefPostData; const headerMap: ICefStringMultimap);
  public
    class function UnWrap(data: Pointer): ICefRequest;
    class function New: ICefRequest;
  end;

  TCefStreamReaderRef = class(TCefBaseRef, ICefStreamReader)
  protected
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Eof: Boolean;
  public
    class function UnWrap(data: Pointer): ICefStreamReader;
    class function CreateForFile(const filename: ustring): ICefStreamReader;
    class function CreateForCustomStream(const stream: ICefCustomStreamReader): ICefStreamReader;
    class function CreateForStream(const stream: TSTream; owned: Boolean): ICefStreamReader;
    class function CreateForData(data: Pointer; size: Cardinal): ICefStreamReader;
  end;

  TCefV8AccessorGetterProc = function(const name: ustring; const obj: ICefv8Value; out value: ICefv8Value; const exception: string): Boolean;
  TCefV8AccessorSetterProc = function(const name: ustring; const obj, value: ICefv8Value; const exception: string): Boolean;

  { TCefv8ValueRef }

  TCefv8ValueRef = class(TCefBaseRef, ICefv8Value)
  protected
    function IsValid: Boolean;
    function IsUndefined: Boolean;
    function IsNull: Boolean;
    function IsBool: Boolean;
    function IsInt: Boolean;
    function IsUInt: Boolean;
    function IsDouble: Boolean;
    function IsDate: Boolean;
    function IsString: Boolean;
    function IsObject: Boolean;
    function IsArray: Boolean;
    function IsFunction: Boolean;
    function IsSame(const that: ICefv8Value): Boolean;
    function GetBoolValue: Boolean;
    function GetIntValue: Integer;
    function GetUIntValue: Cardinal;
    function GetDoubleValue: Double;
    function GetDateValue: TDateTime;
    function GetStringValue: ustring;
    function IsUserCreated: Boolean;
    function HasException: Boolean;
    function GetException: ICefV8Exception;
    function ClearException: Boolean;
    function WillRethrowExceptions: Boolean;
    function SetRethrowExceptions(rethrow: Boolean): Boolean;
    function HasValueByKey(const key: ustring): Boolean;
    function HasValueByIndex(index: Integer): Boolean;
    function DeleteValueByKey(const key: ustring): Boolean;
    function DeleteValueByIndex(index: Integer): Boolean;
    function GetValueByKey(const key: ustring): ICefv8Value;
    function GetValueByIndex(index: Integer): ICefv8Value;
    function SetValueByKey(const key: ustring; const value: ICefv8Value;
      attribute: TCefV8PropertyAttributes): Boolean;
    function SetValueByIndex(index: Integer; const value: ICefv8Value): Boolean;
    function SetValueByAccessor(const key: ustring; settings: TCefV8AccessControls;
      attribute: TCefV8PropertyAttributes): Boolean;
    function GetKeys(const keys: TStrings): Integer;
    function SetUserData(const data: ICefv8Value): Boolean;
    function GetUserData: ICefv8Value;
    function GetExternallyAllocatedMemory: Integer;
    function AdjustExternallyAllocatedMemory(changeInBytes: Integer): Integer;
    function GetArrayLength: Integer;
    function GetFunctionName: ustring;
    function GetFunctionHandler: ICefv8Handler;
    function ExecuteFunction(const obj: ICefv8Value;
      const arguments: TCefv8ValueArray): ICefv8Value;
    function ExecuteFunctionWithContext(const context: ICefv8Context;
      const obj: ICefv8Value; const arguments: TCefv8ValueArray): ICefv8Value;
  public
    class function UnWrap(data: Pointer): ICefv8Value;
    class function NewUndefined: ICefv8Value;
    class function NewNull: ICefv8Value;
    class function NewBool(value: Boolean): ICefv8Value;
    class function NewInt(value: Integer): ICefv8Value;
    class function NewUInt(value: Cardinal): ICefv8Value;
    class function NewDouble(value: Double): ICefv8Value;
    class function NewDate(value: TDateTime): ICefv8Value;
    class function NewString(const str: ustring): ICefv8Value;
    class function NewObject(const Accessor: ICefV8Accessor): ICefv8Value;
    class function NewObjectProc(const getter: TCefV8AccessorGetterProc;
      const setter: TCefV8AccessorSetterProc): ICefv8Value;
    class function NewArray(len: Integer): ICefv8Value;
    class function NewFunction(const name: ustring; const handler: ICefv8Handler): ICefv8Value;
  end;

  TCefv8ContextRef = class(TCefBaseRef, ICefv8Context)
  protected
    function GetTaskRunner: ICefTaskRunner;
    function IsValid: Boolean;
    function GetBrowser: ICefBrowser;
    function GetFrame: ICefFrame;
    function GetGlobal: ICefv8Value;
    function Enter: Boolean;
    function Exit: Boolean;
    function IsSame(const that: ICefv8Context): Boolean;
    function Eval(const code: ustring; var retval: ICefv8Value; var exception: ICefV8Exception): Boolean;
  public
    class function UnWrap(data: Pointer): ICefv8Context;
    class function Current: ICefv8Context;
    class function Entered: ICefv8Context;
  end;

  TCefV8StackFrameRef = class(TCefBaseRef, ICefV8StackFrame)
  protected
    function IsValid: Boolean;
    function GetScriptName: ustring;
    function GetScriptNameOrSourceUrl: ustring;
    function GetFunctionName: ustring;
    function GetLineNumber: Integer;
    function GetColumn: Integer;
    function IsEval: Boolean;
    function IsConstructor: Boolean;
  public
    class function UnWrap(data: Pointer): ICefV8StackFrame;
  end;

  TCefV8StackTraceRef = class(TCefBaseRef, ICefV8StackTrace)
  protected
    function IsValid: Boolean;
    function GetFrameCount: Integer;
    function GetFrame(index: Integer): ICefV8StackFrame;
  public
    class function UnWrap(data: Pointer): ICefV8StackTrace;
    class function Current(frameLimit: Integer): ICefV8StackTrace;
  end;

  TCefv8HandlerRef = class(TCefBaseRef, ICefv8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefv8Handler;
  end;

  TCefClientOwn = class(TCefBaseOwn, ICefClient)
  protected
    function GetContextMenuHandler: ICefContextMenuHandler; virtual;
    function GetDialogHandler: ICefDialogHandler; virtual;
    function GetDisplayHandler: ICefDisplayHandler; virtual;
    function GetDownloadHandler: ICefDownloadHandler; virtual;
    function GetFocusHandler: ICefFocusHandler; virtual;
    function GetGeolocationHandler: ICefGeolocationHandler; virtual;
    function GetJsdialogHandler: ICefJsdialogHandler; virtual;
    function GetKeyboardHandler: ICefKeyboardHandler; virtual;
    function GetLifeSpanHandler: ICefLifeSpanHandler; virtual;
    function GetRenderHandler: ICefRenderHandler; virtual;
    function GetLoadHandler: ICefLoadHandler; virtual;
    function GetRequestHandler: ICefRequestHandler; virtual;
    function OnProcessMessageReceived(const browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; virtual;
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

  TCefLifeSpanHandlerOwn = class(TCefBaseOwn, ICefLifeSpanHandler)
  protected
    function OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; var popupFeatures: TCefPopupFeatures;
      var windowInfo: TCefWindowInfo; var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean): Boolean; virtual;
    procedure OnAfterCreated(const browser: ICefBrowser); virtual;
    procedure OnBeforeClose(const browser: ICefBrowser); virtual;
    function RunModal(const browser: ICefBrowser): Boolean; virtual;
    function DoClose(const browser: ICefBrowser): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefLoadHandlerOwn = class(TCefBaseOwn, ICefLoadHandler)
  protected
    procedure OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame); virtual;
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer); virtual;
    procedure OnLoadError(const browser: ICefBrowser; const frame: ICefFrame; errorCode: Integer;
      const errorText, failedUrl: ustring); virtual;
    procedure OnRenderProcessTerminated(const browser: ICefBrowser; status: TCefTerminationStatus); virtual;
    procedure OnPluginCrashed(const browser: ICefBrowser; const pluginPath: ustring); virtual;
  public
    constructor Create; virtual;
  end;

  TCefQuotaCallbackRef = class(TCefBaseRef, ICefQuotaCallback)
  protected
    procedure Cont(allow: Boolean);
    procedure Cancel;
  public
     class function UnWrap(data: Pointer): ICefQuotaCallback;
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

  TCefFocusHandlerOwn = class(TCefBaseOwn, ICefFocusHandler)
  protected
    procedure OnTakeFocus(const browser: ICefBrowser; next: Boolean); virtual;
    function OnSetFocus(const browser: ICefBrowser; source: TCefFocusSource): Boolean; virtual;
    procedure OnGotFocus(const browser: ICefBrowser); virtual;
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

  TCefDialogHandlerOwn = class(TCefBaseOwn, ICefDialogHandler)
  protected
    function OnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptTypes: TStrings;
      const callback: ICefFileDialogCallback): Boolean; virtual;
  public
    constructor Create; virtual;
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

  TCefCallbackRef = class(TCefBaseRef, ICefCallback)
  protected
    procedure Cont;
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefCallback;
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

  TCefv8HandlerOwn = class(TCefBaseOwn, ICefv8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefTaskOwn = class(TCefBaseOwn, ICefTask)
  protected
    procedure Execute; virtual;
  public
    constructor Create; virtual;
  end;

  TCefTaskRef = class(TCefBaseRef, ICefTask)
  protected
    procedure Execute; virtual;
  public
    class function UnWrap(data: Pointer): ICefTask;
  end;

  TCefTaskRunnerRef = class(TCefBaseRef, ICefTaskRunner)
  protected
    function IsSame(const that: ICefTaskRunner): Boolean;
    function BelongsToCurrentThread: Boolean;
    function BelongsToThread(threadId: TCefThreadId): Boolean;
    function PostTask(const task: ICefTask): Boolean; cconv;
    function PostDelayedTask(const task: ICefTask; delayMs: Int64): Boolean;
  public
    class function UnWrap(data: Pointer): ICefTaskRunner;
    class function GetForCurrentThread: ICefTaskRunner;
    class function GetForThread(threadId: TCefThreadId): ICefTaskRunner;
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

  TCefXmlReaderRef = class(TCefBaseRef, ICefXmlReader)
  protected
    function MoveToNextNode: Boolean;
    function Close: Boolean;
    function HasError: Boolean;
    function GetError: ustring;
    function GetType: TCefXmlNodeType;
    function GetDepth: Integer;
    function GetLocalName: ustring;
    function GetPrefix: ustring;
    function GetQualifiedName: ustring;
    function GetNamespaceUri: ustring;
    function GetBaseUri: ustring;
    function GetXmlLang: ustring;
    function IsEmptyElement: Boolean;
    function HasValue: Boolean;
    function GetValue: ustring;
    function HasAttributes: Boolean;
    function GetAttributeCount: Cardinal;
    function GetAttributeByIndex(index: Integer): ustring;
    function GetAttributeByQName(const qualifiedName: ustring): ustring;
    function GetAttributeByLName(const localName, namespaceURI: ustring): ustring;
    function GetInnerXml: ustring;
    function GetOuterXml: ustring;
    function GetLineNumber: Integer;
    function MoveToAttributeByIndex(index: Integer): Boolean;
    function MoveToAttributeByQName(const qualifiedName: ustring): Boolean;
    function MoveToAttributeByLName(const localName, namespaceURI: ustring): Boolean;
    function MoveToFirstAttribute: Boolean;
    function MoveToNextAttribute: Boolean;
    function MoveToCarryingElement: Boolean;
  public
    class function UnWrap(data: Pointer): ICefXmlReader;
    class function New(const stream: ICefStreamReader;
      encodingType: TCefXmlEncodingType; const URI: ustring): ICefXmlReader;
  end;

  TCefZipReaderRef = class(TCefBaseRef, ICefZipReader)
  protected
    function MoveToFirstFile: Boolean;
    function MoveToNextFile: Boolean;
    function MoveToFile(const fileName: ustring; caseSensitive: Boolean): Boolean;
    function Close: Boolean;
    function GetFileName: ustring;
    function GetFileSize: Int64;
    function GetFileLastModified: LongInt;
    function OpenFile(const password: ustring): Boolean;
    function CloseFile: Boolean;
    function ReadFile(buffer: Pointer; bufferSize: Cardinal): Integer;
    function Tell: Int64;
    function Eof: Boolean;
  public
    class function UnWrap(data: Pointer): ICefZipReader;
    class function New(const stream: ICefStreamReader): ICefZipReader;
  end;

  TCefDomVisitorOwn = class(TCefBaseOwn, ICefDomVisitor)
  protected
    procedure visit(const document: ICefDomDocument); virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastDomVisitor = class(TCefDomVisitorOwn)
  private
    FProc: TCefDomVisitorProc;
  protected
    procedure visit(const document: ICefDomDocument); override;
  public
    constructor Create(const proc: TCefDomVisitorProc); reintroduce; virtual;
  end;

  TCefDomDocumentRef = class(TCefBaseRef, ICefDomDocument)
  protected
    function GetType: TCefDomDocumentType;
    function GetDocument: ICefDomNode;
    function GetBody: ICefDomNode;
    function GetHead: ICefDomNode;
    function GetTitle: ustring;
    function GetElementById(const id: ustring): ICefDomNode;
    function GetFocusedNode: ICefDomNode;
    function HasSelection: Boolean;
    function GetSelectionStartNode: ICefDomNode;
    function GetSelectionStartOffset: Integer;
    function GetSelectionEndNode: ICefDomNode;
    function GetSelectionEndOffset: Integer;
    function GetSelectionAsMarkup: ustring;
    function GetSelectionAsText: ustring;
    function GetBaseUrl: ustring;
    function GetCompleteUrl(const partialURL: ustring): ustring;
  public
    class function UnWrap(data: Pointer): ICefDomDocument;
  end;

  TCefDomNodeRef = class(TCefBaseRef, ICefDomNode)
  protected
    function GetType: TCefDomNodeType;
    function IsText: Boolean;
    function IsElement: Boolean;
    function IsEditable: Boolean;
    function IsFormControlElement: Boolean;
    function GetFormControlElementType: ustring;
    function IsSame(const that: ICefDomNode): Boolean;
    function GetName: ustring;
    function GetValue: ustring;
    function SetValue(const value: ustring): Boolean;
    function GetAsMarkup: ustring;
    function GetDocument: ICefDomDocument;
    function GetParent: ICefDomNode;
    function GetPreviousSibling: ICefDomNode;
    function GetNextSibling: ICefDomNode;
    function HasChildren: Boolean;
    function GetFirstChild: ICefDomNode;
    function GetLastChild: ICefDomNode;
    procedure AddEventListener(const eventType: ustring;
      useCapture: Boolean; const listener: ICefDomEventListener);
    procedure AddEventListenerProc(const eventType: ustring; useCapture: Boolean;
      const proc: TCefDomEventListenerProc);
    function GetElementTagName: ustring;
    function HasElementAttributes: Boolean;
    function HasElementAttribute(const attrName: ustring): Boolean;
    function GetElementAttribute(const attrName: ustring): ustring;
    procedure GetElementAttributes(const attrMap: ICefStringMap);
    function SetElementAttribute(const attrName, value: ustring): Boolean;
    function GetElementInnerText: ustring;
  public
    class function UnWrap(data: Pointer): ICefDomNode;
  end;

  TCefDomEventRef = class(TCefBaseRef, ICefDomEvent)
  protected
    function GetType: ustring;
    function GetCategory: TCefDomEventCategory;
    function GetPhase: TCefDomEventPhase;
    function CanBubble: Boolean;
    function CanCancel: Boolean;
    function GetDocument: ICefDomDocument;
    function GetTarget: ICefDomNode;
    function GetCurrentTarget: ICefDomNode;
  public
    class function UnWrap(data: Pointer): ICefDomEvent;
  end;

  TCefDomEventListenerOwn = class(TCefBaseOwn, ICefDomEventListener)
  protected
    procedure HandleEvent(const event: ICefDomEvent); virtual;
  public
    constructor Create; virtual;
  end;

  TCefResponseRef = class(TCefBaseRef, ICefResponse)
  protected
    function IsReadOnly: Boolean;
    function GetStatus: Integer;
    procedure SetStatus(status: Integer);
    function GetStatusText: ustring;
    procedure SetStatusText(const StatusText: ustring);
    function GetMimeType: ustring;
    procedure SetMimeType(const mimetype: ustring);
    function GetHeader(const name: ustring): ustring;
    procedure GetHeaderMap(const headerMap: ICefStringMultimap);
    procedure SetHeaderMap(const headerMap: ICefStringMultimap);
  public
    class function UnWrap(data: Pointer): ICefResponse;
    class function New: ICefResponse;
  end;

  TCefFastDomEventListener = class(TCefDomEventListenerOwn)
  private
    FProc: TCefDomEventListenerProc;
  protected
    procedure HandleEvent(const event: ICefDomEvent); override;
  public
    constructor Create(const proc: TCefDomEventListenerProc); reintroduce; virtual;
  end;

  TCefFastTaskProc = procedure;

  TCefFastTask = class(TCefTaskOwn)
  private
    FMethod: TCefFastTaskProc;
  protected
    procedure Execute; override;
  public
    class procedure New(threadId: TCefThreadId; const method: TCefFastTaskProc);
    class procedure NewDelayed(threadId: TCefThreadId; Delay: Int64; const method: TCefFastTaskProc);
    constructor Create(const method: TCefFastTaskProc); reintroduce;
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

  TCefFastV8Accessor = class(TCefV8AccessorOwn)
  private
    FGetter: TCefV8AccessorGetterProc;
    FSetter: TCefV8AccessorSetterProc;
  protected
    function Get(const name: ustring; const obj: ICefv8Value;
      out value: ICefv8Value; const exception: string): Boolean; override;
    function Put(const name: ustring; const obj, value: ICefv8Value;
      const exception: string): Boolean; override;
  public
    constructor Create(const getter: TCefV8AccessorGetterProc;
      const setter: TCefV8AccessorSetterProc); reintroduce;
  end;

  TCefCookieVisitorOwn = class(TCefBaseOwn, ICefCookieVisitor)
  protected
    function visit(const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      count, total: Integer; out deleteCookie: Boolean): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefFastCookieVisitor = class(TCefCookieVisitorOwn)
  private
    FVisitor: TCefCookieVisitorProc;
  protected
    function visit(const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      count, total: Integer; out deleteCookie: Boolean): Boolean; override;
  public
    constructor Create(const visitor: TCefCookieVisitorProc); reintroduce;
  end;

  TCefV8ExceptionRef = class(TCefBaseRef, ICefV8Exception)
  protected
    function GetMessage: ustring;
    function GetSourceLine: ustring;
    function GetScriptResourceName: ustring;
    function GetLineNumber: Integer;
    function GetStartPosition: Integer;
    function GetEndPosition: Integer;
    function GetStartColumn: Integer;
    function GetEndColumn: Integer;
  public
    class function UnWrap(data: Pointer): ICefV8Exception;
  end;

  TCefResourceBundleHandlerOwn = class(TCefBaseOwn, ICefResourceBundleHandler)
  protected
    function GetDataResource(resourceId: Integer; out data: Pointer;
      out dataSize: Cardinal): Boolean; virtual; abstract;
    function GetLocalizedString(messageId: Integer;
      out stringVal: ustring): Boolean; virtual; abstract;
  public
    constructor Create; virtual;
  end;


 TGetDataResource = function(resourceId: Integer; out data: Pointer; out dataSize: Cardinal): Boolean;
 TGetLocalizedString = function(messageId: Integer; out stringVal: ustring): Boolean;

  TCefFastResourceBundle = class(TCefResourceBundleHandlerOwn)
  private
    FGetDataResource: TGetDataResource;
    FGetLocalizedString: TGetLocalizedString;
  protected
    function GetDataResource(resourceId: Integer; out data: Pointer;
      out dataSize: Cardinal): Boolean; override;
    function GetLocalizedString(messageId: Integer;
      out stringVal: ustring): Boolean; override;
  public
    constructor Create(AGetDataResource: TGetDataResource;
      AGetLocalizedString: TGetLocalizedString); reintroduce;
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

  TCefCookieManagerRef = class(TCefBaseRef, ICefCookieManager)
  protected
    procedure SetSupportedSchemes(schemes: TStrings);
    function VisitAllCookies(const visitor: ICefCookieVisitor): Boolean;
    function VisitAllCookiesProc(const visitor: TCefCookieVisitorProc): Boolean;
    function VisitUrlCookies(const url: ustring;
      includeHttpOnly: Boolean; const visitor: ICefCookieVisitor): Boolean;
    function VisitUrlCookiesProc(const url: ustring;
      includeHttpOnly: Boolean; const visitor: TCefCookieVisitorProc): Boolean;
    function SetCookie(const url: ustring; const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime): Boolean;
    function DeleteCookies(const url, cookieName: ustring): Boolean;
    function SetStoragePath(const path: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefCookieManager;
    class function Global: ICefCookieManager;
    class function New(const path: ustring): ICefCookieManager;
  end;

  TCefWebPluginInfoRef = class(TCefBaseRef, ICefWebPluginInfo)
  protected
    function GetName: ustring;
    function GetPath: ustring;
    function GetVersion: ustring;
    function GetDescription: ustring;
  public
    class function UnWrap(data: Pointer): ICefWebPluginInfo;
  end;

  TCefProcessMessageRef = class(TCefBaseRef, ICefProcessMessage)
  protected
    function IsValid: Boolean;
    function IsReadOnly: Boolean;
    function Copy: ICefProcessMessage;
    function GetName: ustring;
    function GetArgumentList: ICefListValue;
  public
    class function UnWrap(data: Pointer): ICefProcessMessage;
    class function New(const name: ustring): ICefProcessMessage;
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

  TCefDownLoadItemRef = class(TCefBaseRef, ICefDownLoadItem)
  protected
    function IsValid: Boolean;
    function IsInProgress: Boolean;
    function IsComplete: Boolean;
    function IsCanceled: Boolean;
    function GetCurrentSpeed: Int64;
    function GetPercentComplete: Integer;
    function GetTotalBytes: Int64;
    function GetReceivedBytes: Int64;
    function GetStartTime: TDateTime;
    function GetEndTime: TDateTime;
    function GetFullPath: ustring;
    function GetId: Integer;
    function GetUrl: ustring;
    function GetSuggestedFileName: ustring;
    function GetContentDisposition: ustring;
    function GetMimeType: ustring;
  public
    class function UnWrap(data: Pointer): ICefDownLoadItem;
  end;

  TCefBeforeDownloadCallbackRef = class(TCefBaseRef, ICefBeforeDownloadCallback)
  protected
    procedure Cont(const downloadPath: ustring; showDialog: Boolean);
  public
     class function UnWrap(data: Pointer): ICefBeforeDownloadCallback;
  end;

  TCefDownloadItemCallbackRef = class(TCefBaseRef, ICefDownloadItemCallback)
  protected
    procedure cancel;
  public
    class function UnWrap(data: Pointer): ICefDownloadItemCallback;
  end;

  TCefAuthCallbackRef = class(TCefBaseRef, ICefAuthCallback)
  protected
    procedure Cont(const username, password: ustring);
    procedure Cancel;
  public
     class function UnWrap(data: Pointer): ICefAuthCallback;
  end;

  TCefJsDialogCallbackRef = class(TCefBaseRef, ICefJsDialogCallback)
  protected
    procedure Cont(success: Boolean; const userInput: ustring);
  public
    class function UnWrap(data: Pointer): ICefJsDialogCallback;
  end;

  TCefCommandLineRef = class(TCefBaseRef, ICefCommandLine)
  protected
    function IsValid: Boolean;
    function IsReadOnly: Boolean;
    function Copy: ICefCommandLine;
    procedure InitFromArgv(argc: Integer; const argv: PPAnsiChar);
    procedure InitFromString(const commandLine: ustring);
    procedure Reset;
    function GetCommandLineString: ustring;
    procedure GetArgv(args: TStrings);
    function GetProgram: ustring;
    procedure SetProgram(const prog: ustring);
    function HasSwitches: Boolean;
    function HasSwitch(const name: ustring): Boolean;
    function GetSwitchValue(const name: ustring): ustring;
    procedure GetSwitches(switches: TStrings);
    procedure AppendSwitch(const name: ustring);
    procedure AppendSwitchWithValue(const name, value: ustring);
    function HasArguments: Boolean;
    procedure GetArguments(arguments: TStrings);
    procedure AppendArgument(const argument: ustring);
    procedure PrependWrapper(const wrapper: ustring);
  public
    class function UnWrap(data: Pointer): ICefCommandLine;
    class function New: ICefCommandLine;
    class function Global: ICefCommandLine;
  end;

  TCefSchemeRegistrarRef = class(TCefBaseRef, ICefSchemeRegistrar)
  protected
    function AddCustomScheme(const schemeName: ustring; IsStandard, IsLocal,
      IsDisplayIsolated: Boolean): Boolean; cconv;
  public
    class function UnWrap(data: Pointer): ICefSchemeRegistrar;
  end;

  TCefGeolocationCallbackRef = class(TCefBaseRef, ICefGeolocationCallback)
  protected
    procedure Cont(allow: Boolean);
  public
    class function UnWrap(data: Pointer): ICefGeolocationCallback;
  end;

  TCefContextMenuParamsRef = class(TCefBaseRef, ICefContextMenuParams)
  protected
    function GetXCoord: Integer;
    function GetYCoord: Integer;
    function GetTypeFlags: TCefContextMenuTypeFlags;
    function GetLinkUrl: ustring;
    function GetUnfilteredLinkUrl: ustring;
    function GetSourceUrl: ustring;
    function IsImageBlocked: Boolean;
    function GetPageUrl: ustring;
    function GetFrameUrl: ustring;
    function GetFrameCharset: ustring;
    function GetMediaType: TCefContextMenuMediaType;
    function GetMediaStateFlags: TCefContextMenuMediaStateFlags;
    function GetSelectionText: ustring;
    function IsEditable: Boolean;
    function IsSpeechInputEnabled: Boolean;
    function GetEditStateFlags: TCefContextMenuEditStateFlags;
  public
    class function UnWrap(data: Pointer): ICefContextMenuParams;
  end;

  TCefMenuModelRef = class(TCefBaseRef, ICefMenuModel)
  protected
    function Clear: Boolean;
    function GetCount: Integer;
    function AddSeparator: Boolean;
    function AddItem(commandId: Integer; const text: ustring): Boolean;
    function AddCheckItem(commandId: Integer; const text: ustring): Boolean;
    function AddRadioItem(commandId: Integer; const text: ustring; groupId: Integer): Boolean;
    function AddSubMenu(commandId: Integer; const text: ustring): ICefMenuModel;
    function InsertSeparatorAt(index: Integer): Boolean;
    function InsertItemAt(index, commandId: Integer; const text: ustring): Boolean;
    function InsertCheckItemAt(index, commandId: Integer; const text: ustring): Boolean;
    function InsertRadioItemAt(index, commandId: Integer; const text: ustring; groupId: Integer): Boolean;
    function InsertSubMenuAt(index, commandId: Integer; const text: ustring): ICefMenuModel;
    function Remove(commandId: Integer): Boolean;
    function RemoveAt(index: Integer): Boolean;
    function GetIndexOf(commandId: Integer): Integer;
    function GetCommandIdAt(index: Integer): Integer;
    function SetCommandIdAt(index, commandId: Integer): Boolean;
    function GetLabel(commandId: Integer): ustring;
    function GetLabelAt(index: Integer): ustring;
    function SetLabel(commandId: Integer; const text: ustring): Boolean;
    function SetLabelAt(index: Integer; const text: ustring): Boolean;
    function GetType(commandId: Integer): TCefMenuItemType;
    function GetTypeAt(index: Integer): TCefMenuItemType;
    function GetGroupId(commandId: Integer): Integer;
    function GetGroupIdAt(index: Integer): Integer;
    function SetGroupId(commandId, groupId: Integer): Boolean;
    function SetGroupIdAt(index, groupId: Integer): Boolean;
    function GetSubMenu(commandId: Integer): ICefMenuModel;
    function GetSubMenuAt(index: Integer): ICefMenuModel;
    function IsVisible(commandId: Integer): Boolean;
    function isVisibleAt(index: Integer): Boolean;
    function SetVisible(commandId: Integer; visible: Boolean): Boolean;
    function SetVisibleAt(index: Integer; visible: Boolean): Boolean;
    function IsEnabled(commandId: Integer): Boolean;
    function IsEnabledAt(index: Integer): Boolean;
    function SetEnabled(commandId: Integer; enabled: Boolean): Boolean;
    function SetEnabledAt(index: Integer; enabled: Boolean): Boolean;
    function IsChecked(commandId: Integer): Boolean;
    function IsCheckedAt(index: Integer): Boolean;
    function setChecked(commandId: Integer; checked: Boolean): Boolean;
    function setCheckedAt(index: Integer; checked: Boolean): Boolean;
    function HasAccelerator(commandId: Integer): Boolean;
    function HasAcceleratorAt(index: Integer): Boolean;
    function SetAccelerator(commandId, keyCode: Integer; shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function SetAcceleratorAt(index, keyCode: Integer; shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function RemoveAccelerator(commandId: Integer): Boolean;
    function RemoveAcceleratorAt(index: Integer): Boolean;
    function GetAccelerator(commandId: Integer; out keyCode: Integer; out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function GetAcceleratorAt(index: Integer; out keyCode: Integer; out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
  public
    class function UnWrap(data: Pointer): ICefMenuModel;
  end;

  TCefListValueRef = class(TCefBaseRef, ICefListValue)
  protected
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function Copy: ICefListValue;
    function SetSize(size: Cardinal): Boolean;
    function GetSize: Cardinal;
    function Clear: Boolean;
    function Remove(index: Integer): Boolean;
    function GetType(index: Integer): TCefValueType;
    function GetBool(index: Integer): Boolean;
    function GetInt(index: Integer): Integer;
    function GetDouble(index: Integer): Double;
    function GetString(index: Integer): ustring;
    function GetBinary(index: Integer): ICefBinaryValue;
    function GetDictionary(index: Integer): ICefDictionaryValue;
    function GetList(index: Integer): ICefListValue;
    function SetNull(index: Integer): Boolean;
    function SetBool(index: Integer; value: Boolean): Boolean;
    function SetInt(index, value: Integer): Boolean;
    function SetDouble(index: Integer; value: Double): Boolean;
    function SetString(index: Integer; const value: ustring): Boolean;
    function SetBinary(index: Integer; const value: ICefBinaryValue): Boolean;
    function SetDictionary(index: Integer; const value: ICefDictionaryValue): Boolean;
    function SetList(index: Integer; const value: ICefListValue): Boolean;
  public
    class function UnWrap(data: Pointer): ICefListValue;
    class function New: ICefListValue;
  end;

  TCefBinaryValueRef = class(TCefBaseRef, ICefBinaryValue)
  protected
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function Copy: ICefBinaryValue;
    function GetSize: Cardinal;
    function GetData(buffer: Pointer; bufferSize, dataOffset: Cardinal): Cardinal;
  public
    class function UnWrap(data: Pointer): ICefBinaryValue;
    class function New(const data: Pointer; dataSize: Cardinal): ICefBinaryValue;
  end;

  TCefDictionaryValueRef = class(TCefBaseRef, ICefDictionaryValue)
  protected
    function IsValid: Boolean;
    function isOwned: Boolean;
    function IsReadOnly: Boolean;
    function Copy(excludeEmptyChildren: Boolean): ICefDictionaryValue;
    function GetSize: Cardinal;
    function Clear: Boolean;
    function HasKey(const key: ustring): Boolean;
    function GetKeys(const keys: TStrings): Boolean;
    function Remove(const key: ustring): Boolean;
    function GetType(const key: ustring): TCefValueType;
    function GetBool(const key: ustring): Boolean;
    function GetInt(const key: ustring): Integer;
    function GetDouble(const key: ustring): Double;
    function GetString(const key: ustring): ustring;
    function GetBinary(const key: ustring): ICefBinaryValue;
    function GetDictionary(const key: ustring): ICefDictionaryValue;
    function GetList(const key: ustring): ICefListValue;
    function SetNull(const key: ustring): Boolean;
    function SetBool(const key: ustring; value: Boolean): Boolean;
    function SetInt(const key: ustring; value: Integer): Boolean;
    function SetDouble(const key: ustring; value: Double): Boolean;
    function SetString(const key, value: ustring): Boolean;
    function SetBinary(const key: ustring; const value: ICefBinaryValue): Boolean;
    function SetDictionary(const key: ustring; const value: ICefDictionaryValue): Boolean;
    function SetList(const key: ustring; const value: ICefListValue): Boolean;
  public
    class function UnWrap(data: Pointer): ICefDictionaryValue;
    class function New: ICefDictionaryValue;
  end;

  TCefBrowserProcessHandlerOwn = class(TCefBaseOwn, ICefBrowserProcessHandler)
  protected
    //function GetProxyHandler: ICefProxyHandler; virtual;
    procedure OnContextInitialized; virtual;
    procedure OnBeforeChildProcessLaunch(const commandLine: ICefCommandLine); virtual;
    procedure OnRenderProcessThreadCreated(const extraInfo: ICefListValue); virtual;
  public
    constructor Create; virtual;
  end;

  TCefRenderProcessHandlerOwn = class(TCefBaseOwn, ICefRenderProcessHandler)
  protected
    procedure OnRenderThreadCreated(const extraInfo: ICefListValue); virtual;
    procedure OnWebKitInitialized; virtual;
    procedure OnBrowserCreated(const browser: ICefBrowser); virtual;
    procedure OnBrowserDestroyed(const browser: ICefBrowser); virtual;
    function OnBeforeNavigation(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navigationType: TCefNavigationType;
      isRedirect: Boolean): Boolean; virtual;
    procedure OnContextCreated(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefv8Context); virtual;
    procedure OnContextReleased(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefv8Context); virtual;
    procedure OnUncaughtException(const browser: ICefBrowser; const frame: ICefFrame;
      const context: ICefv8Context; const exception: ICefV8Exception;
      const stackTrace: ICefV8StackTrace); virtual;
    procedure OnWorkerContextCreated(workerId: Integer; const url: ustring;
      const context: ICefv8Context); virtual;
    procedure OnWorkerContextReleased(workerId: Integer; const url: ustring;
      const context: ICefv8Context); virtual;
    procedure OnWorkerUncaughtException(workerId: Integer; const url: ustring;
      const context: ICefv8Context; const exception: ICefV8Exception;
      const stackTrace: ICefV8StackTrace); virtual;
    procedure OnFocusedNodeChanged(const browser: ICefBrowser;
      const frame: ICefFrame; const node: ICefDomNode); virtual;
    function OnProcessMessageReceived(const browser: ICefBrowser;
      sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; virtual;
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

  TCefUrlRequestRef = class(TCefBaseRef, ICefUrlRequest)
  protected
    function GetRequest: ICefRequest;
    function GetRequestStatus: TCefUrlRequestStatus;
    function GetRequestError: Integer;
    function GetResponse: ICefResponse;
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefUrlRequest;
    class function New(const request: ICefRequest; const client: ICefUrlRequestClient): ICefUrlRequest;
  end;

  TCefWebPluginInfoVisitorOwn = class(TCefBaseOwn, ICefWebPluginInfoVisitor)
  protected
    function Visit(const info: ICefWebPluginInfo; count, total: Integer): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefWebPluginInfoVisitorProc = function(const info: ICefWebPluginInfo; count, total: Integer): Boolean;
  TCefWebPluginIsUnstableProc = procedure(const path: ustring; unstable: Boolean);

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

  TCefTraceClientOwn = class(TCefBaseOwn, ICefTraceClient)
  protected
    procedure OnTraceDataCollected(const fragment: PAnsiChar; fragmentSize: Cardinal); virtual;
    procedure OnTraceBufferPercentFullReply(percentFull: Single); virtual;
    procedure OnEndTracingComplete; virtual;
  public
    constructor Create; virtual;
  end;

  TCefGetGeolocationCallbackOwn = class(TCefBaseOwn, ICefGetGeolocationCallback)
  protected
    procedure OnLocationUpdate(const position: PCefGeoposition); virtual;
  public
    constructor Create; virtual;
  end;

  TOnLocationUpdate = procedure(const position: PCefGeoposition);

  TCefFastGetGeolocationCallback = class(TCefGetGeolocationCallbackOwn)
  private
    FCallback: TOnLocationUpdate;
  protected
    procedure OnLocationUpdate(const position: PCefGeoposition); override;
  public
    constructor Create(const callback: TOnLocationUpdate); reintroduce;
  end;

  TCefFileDialogCallbackRef = class(TCefBaseRef, ICefFileDialogCallback)
  protected
    procedure Cont(filePaths: TStrings);
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefFileDialogCallback;
  end;

  TCefRenderHandlerOwn = class(TCefBaseOwn, ICefRenderHandler)
  protected
    function GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
    function GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer;
      screenX, screenY: PInteger): Boolean; virtual;
    procedure OnPopupShow(const browser: ICefBrowser; show: Boolean); virtual;
    procedure OnPopupSize(const browser: ICefBrowser; const rect: PCefRect); virtual;
    procedure OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType;
      dirtyRectsCount: Cardinal; const dirtyRects: PCefRectArray;
      const buffer: Pointer; width, height: Integer); virtual;
    procedure OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle); virtual;
  public
    constructor Create; virtual;
  end;

  ECefException = class(Exception)
  end;

function CefInitDefault: Boolean;

function CefInitialize(const Cache: ustring = ''; const UserAgent: ustring = '';
  const ProductVersion: ustring = ''; const Locale: ustring = ''; const LogFile: ustring = '';
  const BrowserSubprocessPath: ustring = '';
  LogSeverity: TCefLogSeverity = LOGSEVERITY_DISABLE;
  JavaScriptFlags: ustring = ''; ResourcesDirPath: ustring = ''; LocalesDirPath: ustring = '';
  SingleProcess: Boolean = False; CommandLineArgsDisabled: Boolean = False; PackLoadingDisabled: Boolean = False;
  RemoteDebuggingPort: Integer = 0; ReleaseDCheck: Boolean = False;
  UncaughtExceptionStackSize: Integer = 0; ContextSafetyImplementation: Integer = 0): Boolean;

function CefGetObject(ptr: Pointer): TObject;
function CefStringAlloc(const str: ustring): TCefString;

function CefString(const str: String) : TCefString; overload;
//function CefString(const str: ustring) : TCefString; overload;
function CefString(const str: PCefString) : ustring; overload;
function CefUserFreeString(const str: ustring): PCefStringUserFree;

function CefStringClearAndGet(var str: TCefString): ustring;
procedure CefStringFree(const str: PCefString);
function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
procedure CefStringSet(const str: PCefString; const value: ustring);
function CefBrowserHostCreate(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): Boolean;
function CefBrowserHostCreateSync(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): ICefBrowser;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
procedure CefDoMessageLoopWork;
procedure CefRunMessageLoop;
procedure CefQuitMessageLoop;
{$ENDIF}

procedure CefShutDown;

function CefRegisterSchemeHandlerFactory(const SchemeName, HostName: ustring;
  SyncMainThread: Boolean; const handler: TCefResourceHandlerClass): Boolean;
function CefClearSchemeHandlerFactories: Boolean;

function CefAddCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol,
  TargetDomain: ustring; AllowTargetSubdomains: Boolean): Boolean;
function CefRemoveCrossOriginWhitelistEntry(
  const SourceOrigin, TargetProtocol, TargetDomain: ustring;
  AllowTargetSubdomains: Boolean): Boolean;
function CefClearCrossOriginWhitelist: Boolean;

function CefRegisterExtension(const name, code: ustring; const Handler: ICefv8Handler): Boolean;
function CefCurrentlyOn(ThreadId: TCefThreadId): Boolean;
procedure CefPostTask(ThreadId: TCefThreadId; const task: ICefTask);
procedure CefPostDelayedTask(ThreadId: TCefThreadId; const task: ICefTask; delayMs: Int64);
function CefGetData(const i: ICefBase): Pointer;
function CefParseUrl(const url: ustring; var parts: TUrlParts): Boolean;
function CefCreateUrl(var parts: TUrlParts): string;

procedure CefVisitWebPluginInfo(const visitor: ICefWebPluginInfoVisitor);
procedure CefVisitWebPluginInfoProc(const visitor: TCefWebPluginInfoVisitorProc);
procedure CefRefreshWebPlugins;
procedure CefAddWebPluginPath(const path: ustring);
procedure CefAddWebPluginDirectory(const dir: ustring);
procedure CefRemoveWebPluginPath(const path: ustring);
procedure CefUnregisterInternalWebPlugin(const path: ustring);
procedure CefForceWebPluginShutdown(const path: ustring);
procedure CefRegisterWebPluginCrash(const path: ustring);
procedure CefIsWebPluginUnstable(const path: ustring; const callback: ICefWebPluginUnstableCallback);
procedure CefIsWebPluginUnstableProc(const path: ustring; const callback: TCefWebPluginIsUnstableProc);

function CefGetPath(key: TCefPathKey; out path: ustring): Boolean;

function CefBeginTracing(const client: ICefTraceClient; const categories: ustring): Boolean;
function CefGetTraceBufferPercentFullAsync: Integer;
function CefEndTracingAsync: Boolean;

function CefGetGeolocation(const callback: ICefGetGeolocationCallback): Boolean;

Var
  CefCache: ustring = '';
  CefUserAgent: ustring = '';
  CefProductVersion: ustring = '';
  CefLocale: ustring = '';
  CefLogFile: ustring = '';
  CefLogSeverity: TCefLogSeverity = LOGSEVERITY_VERBOSE;
  CefLocalStorageQuota: Cardinal = 0;
  CefSessionStorageQuota: Cardinal = 0;
  CefJavaScriptFlags: ustring = '';
  CefResourcesDirPath: ustring = '';
  CefLocalesDirPath: ustring = '';
  CefPackLoadingDisabled: Boolean = False;
  CefSingleProcess: Boolean = True;
  CefBrowserSubprocessPath: ustring = '';
  CefCommandLineArgsDisabled: Boolean = False;
  CefRemoteDebuggingPort: Integer = 0;
  CefGetDataResource: TGetDataResource = nil;
  CefGetLocalizedString: TGetLocalizedString = nil;
  CefReleaseDCheck: Boolean = False;
  CefUncaughtExceptionStackSize: Integer = 10;
  CefContextSafetyImplementation: Integer = 0;

  CefResourceBundleHandler: ICefResourceBundleHandler = nil;
  CefBrowserProcessHandler: ICefBrowserProcessHandler = nil;
  CefRenderProcessHandler: ICefRenderProcessHandler = nil;
  CefOnBeforeCommandLineProcessing: TOnBeforeCommandLineProcessing = nil;
  CefOnRegisterCustomSchemes: TOnRegisterCustomSchemes = nil;

Implementation

Type
  TInternalApp = class(TCefAppOwn)
  protected
    procedure OnBeforeCommandLineProcessing(const processType: ustring;
      const commandLine: ICefCommandLine); override;
    procedure OnRegisterCustomSchemes(const registrar: ICefSchemeRegistrar); override;
    function GetResourceBundleHandler: ICefResourceBundleHandler; override;
    function GetBrowserProcessHandler: ICefBrowserProcessHandler; override;
    function GetRenderProcessHandler: ICefRenderProcessHandler; override;
  end;


procedure TInternalApp.OnBeforeCommandLineProcessing(const processType: ustring;
    const commandLine: ICefCommandLine);
begin
  If Assigned(CefOnBeforeCommandLineProcessing) then CefOnBeforeCommandLineProcessing(processType, commandLine);
end;

procedure TInternalApp.OnRegisterCustomSchemes(const registrar: ICefSchemeRegistrar);
begin
  If Assigned(CefOnRegisterCustomSchemes) then CefOnRegisterCustomSchemes(registrar);
end;

function TInternalApp.GetResourceBundleHandler: ICefResourceBundleHandler;
begin
  Result := CefResourceBundleHandler;
end;

function TInternalApp.GetBrowserProcessHandler: ICefBrowserProcessHandler;
begin
  result := CefBrowserProcessHandler;
end;

function TInternalApp.GetRenderProcessHandler: ICefRenderProcessHandler;
begin
  Result := CefRenderProcessHandler;
end;


{$IFDEF WINDOWS}
{ TODO : Where are these types defined? }
{
function TzSpecificLocalTimeToSystemTime(
  lpTimeZoneInformation: PTimeZoneInformation;
  lpLocalTime, lpUniversalTime: PSystemTime): BOOL; cdecl; external 'kernel32.dll';

function SystemTimeToTzSpecificLocalTime(
  lpTimeZoneInformation: PTimeZoneInformation;
  lpUniversalTime, lpLocalTime: PSystemTime): BOOL; cdecl; external 'kernel32.dll';
}
{$ENDIF}

Var
  CefIsMainProcess: Boolean = False;

function CefInitDefault: Boolean;
begin
  Debugln('CefInitDefault');

  Result := CefInitialize(CefCache, CefUserAgent, CefProductVersion, CefLocale, CefLogFile,
    CefBrowserSubprocessPath, CefLogSeverity,
    CefJavaScriptFlags, CefResourcesDirPath, CefLocalesDirPath, CefSingleProcess,
    CefCommandLineArgsDisabled, CefPackLoadingDisabled, CefRemoteDebuggingPort,
    CefReleaseDCheck, CefUncaughtExceptionStackSize, CefContextSafetyImplementation);
end;

function CefInitialize(const Cache, UserAgent, ProductVersion, Locale, LogFile, BrowserSubprocessPath: ustring;
  LogSeverity: TCefLogSeverity; JavaScriptFlags, ResourcesDirPath, LocalesDirPath: ustring;
  SingleProcess, CommandLineArgsDisabled, PackLoadingDisabled: Boolean; RemoteDebuggingPort: Integer;
  ReleaseDCheck: Boolean; UncaughtExceptionStackSize: Integer; ContextSafetyImplementation: Integer): Boolean;
Var
  Settings: TCefSettings;
  App: ICefApp;
  ErrCode: Integer;

  Args : TCefMainArgs;
begin
  Debugln('CefInitialize');

  If CefIsMainProcess then
  begin
    Debugln('Already loaded.');
    Exit;
  end;
  CefLoadLibrary;

  FillChar(settings, SizeOf(settings), 0);

  settings.size           := SizeOf(settings);
  settings.single_process := SingleProcess;
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  settings.multi_threaded_message_loop := True;
{$ELSE}
  settings.multi_threaded_message_loop := False;
{$ENDIF}
  settings.cache_path := CefString(Cache);
  settings.browser_subprocess_path := CefString(BrowserSubprocessPath);
  settings.command_line_args_disabled := CommandLineArgsDisabled;
  settings.user_agent := cefstring(UserAgent);
  settings.product_version := CefString(ProductVersion);
  settings.locale := CefString(Locale);
  settings.log_file := CefString(LogFile);
  settings.log_severity := LogSeverity;
  settings.release_dcheck_enabled := ReleaseDCheck;
  settings.javascript_flags := CefString(JavaScriptFlags);
  settings.resources_dir_path := CefString(ResourcesDirPath);
  settings.locales_dir_path := CefString(LocalesDirPath);
  settings.pack_loading_disabled := PackLoadingDisabled;
  settings.remote_debugging_port := RemoteDebuggingPort;
  settings.uncaught_exception_stack_size := UncaughtExceptionStackSize;
  settings.context_safety_implementation := ContextSafetyImplementation;

  app := TInternalApp.Create;

  {$IFDEF WINDOWS}
  Args.instance := HINSTANCE();

  ErrCode := cef_execute_process(@Args, CefGetData(app));
  {$ELSE}
  Args.argc := argc;
  Args.argv := argv;

  ErrCode := cef_execute_process(@Args, CefGetData(app));
  {$ENDIF}
  If ErrCode >= 0 then
  begin
    Assert(False, 'cef_execute_process went wrong');

    Result := False;
    Exit;
  end;

  ErrCode := cef_initialize(@Args, @settings, CefGetData(app));
  If ErrCode <> 1 then
  begin
    Assert(False, 'cef_initialize went wrong');

    Result := False;
    Exit;
  end;

  CefIsMainProcess := True;
  Result := True;
end;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
procedure CefDoMessageLoopWork;
begin
  //If LibHandle > 0 then
  cef_do_message_loop_work;
end;

procedure CefRunMessageLoop;
begin
  //If LibHandle > 0 then
    cef_run_message_loop;
end;

procedure CefQuitMessageLoop;
begin
  cef_quit_message_loop;
end;
{$ENDIF}

procedure CefShutDown;
begin
  If CefIsMainProcess then
  begin
    cef_shutdown;

    CefIsMainProcess := False;
  end;
end;

function CefString(const str : String) : TCefString;
begin
  FillChar(Result, SizeOf(Result), 0);

  If str <> '' then
    cef_string_ascii_to_utf16(PChar(str), Length(str), @Result);
end;

{
function CefString(const str : ustring): TCefString;
begin
  Result.str := PChar16(PWideChar(str));
  Result.length := Length(str);
  Result.dtor := nil;
end;
}

function CefString(const str: PCefString): ustring;
begin
  If str <> nil then SetString(Result, str^.str, str^.length)
  Else Result := '';
end;

procedure _free_string(str: PChar16); cconv;
begin
  If str <> nil then FreeMem(str);
end;

function CefUserFreeString(const str: ustring): PCefStringUserFree;
begin
  Result := cef_string_userfree_alloc();
  Result^.length := Length(str);
  Result^.dtor := @_free_string;

  GetMem(Result^.str, Result^.length * SizeOf(TCefChar));
  Move(PCefChar(str)^, Result^.str^, Result^.length * SizeOf(TCefChar));
end;

function CefStringAlloc(const str: ustring): TCefString;
begin
  FillChar(Result, SizeOf(Result), 0);
  If str <> '' then cef_string_from_wide(PWideChar(str), Length(str), @Result);
end;

procedure CefStringSet(const str: PCefString; const value: ustring);
begin
  If str <> nil then cef_string_set(PWideChar(value), Length(value), str, 1);
end;

function CefStringClearAndGet(var str: TCefString): ustring;
begin
  Result := CefString(@str);
  cef_string_clear(@str);
end;

function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
begin
  If str <> nil then
  begin
    Result := CefString(PCefString(str));
    cef_string_userfree_free(str);
  end
  Else Result := '';
end;

procedure CefStringFree(const str: PCefString);
begin
  If str <> nil then cef_string_clear(str);
end;

function CefRegisterSchemeHandlerFactory(const SchemeName, HostName: ustring;
  SyncMainThread: Boolean; const handler: TCefResourceHandlerClass): Boolean;
Var
  s, h: TCefString;
begin
  CefInitDefault;
  s := CefString(SchemeName);
  h := CefString(HostName);
  Result := cef_register_scheme_handler_factory(
    @s,
    @h,
    //CefGetData(TCefSchemeHandlerFactoryOwn.Create(handler, SyncMainThread) as ICefBase)) <> 0;
    CefGetData(TCefSchemeHandlerFactoryOwn.Create(handler, SyncMainThread))) <> 0;
end;

function CefClearSchemeHandlerFactories: Boolean;
begin
  CefInitDefault;
  Result := cef_clear_scheme_handler_factories() <> 0;
end;

function CefAddCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol,
  TargetDomain: ustring; AllowTargetSubdomains: Boolean): Boolean;
Var
  so, tp, td: TCefString;
begin
  CefInitDefault;
  so := CefString(SourceOrigin);
  tp := CefString(TargetProtocol);
  td := CefString(TargetDomain);
  Result := cef_add_cross_origin_whitelist_entry(@so, @tp, @td, Ord(AllowTargetSubdomains)) <> 0;
end;

function CefRemoveCrossOriginWhitelistEntry(
  const SourceOrigin, TargetProtocol, TargetDomain: ustring;
  AllowTargetSubdomains: Boolean): Boolean;
Var
  so, tp, td: TCefString;
begin
  CefInitDefault;
  so := CefString(SourceOrigin);
  tp := CefString(TargetProtocol);
  td := CefString(TargetDomain);
  Result := cef_remove_cross_origin_whitelist_entry(@so, @tp, @td, Ord(AllowTargetSubdomains)) <> 0;
end;

function CefClearCrossOriginWhitelist: Boolean;
begin
  CefInitDefault;
  Result := cef_clear_cross_origin_whitelist() <> 0;
end;

function CefRegisterExtension(const name, code: ustring;
  const Handler: ICefv8Handler): Boolean;
Var
  n, c: TCefString;
begin
  CefInitDefault;
  n := CefString(name);
  c := CefString(code);
  Result := cef_register_extension(@n, @c, CefGetData(handler)) <> 0;
end;

function CefCurrentlyOn(ThreadId: TCefThreadId): Boolean;
begin
  Result := cef_currently_on(ThreadId) <> 0;
end;

procedure CefPostTask(ThreadId: TCefThreadId; const task: ICefTask);
begin
  cef_post_task(ThreadId, CefGetData(task));
end;

procedure CefPostDelayedTask(ThreadId: TCefThreadId; const task: ICefTask; delayMs: Int64);
begin
  cef_post_delayed_task(ThreadId, CefGetData(task), delayMs);
end;

function CefGetData(const i: ICefBase): Pointer; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
begin
  If i <> nil then Result := i.Wrap
  Else Result := nil;
end;

function CefGetObject(ptr: Pointer): TObject; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
begin
  Dec(ptr, SizeOf(Pointer));
  //Dec(PByte(ptr), SizeOf(Pointer));

  Result := TObject(PPointer(ptr)^);
end;

function CefParseUrl(const url: ustring; var parts: TUrlParts): Boolean;
Var
  u: TCefString;
  p: TCefUrlParts;
begin
  FillChar(p, sizeof(p), 0);
  u := CefString(url);
  Result := cef_parse_url(@u, p) <> 0;
  if Result then
  begin
    //parts.spec := CefString(@p.spec);
    parts.scheme := CefString(@p.scheme);
    parts.username := CefString(@p.username);
    parts.password := CefString(@p.password);
    parts.host := CefString(@p.host);
    parts.port := CefString(@p.port);
    parts.path := CefString(@p.path);
    parts.query := CefString(@p.query);
  end;
end;

function CefCreateUrl(var parts: TUrlParts): string;
Var
  p: TCefUrlParts;
  u: TCefString;
begin
  FillChar(p, sizeof(p), 0);
  p.spec := CefString(parts.spec);
  p.scheme := CefString(parts.scheme);
  p.username := CefString(parts.username);
  p.password := CefString(parts.password);
  p.host := CefString(parts.host);
  p.port := CefString(parts.port);
  p.path := CefString(parts.path);
  p.query := CefString(parts.query);
  FillChar(u, SizeOf(u), 0);
  If cef_create_url(@p, @u) <> 0 then Result := CefString(@u)
  Else Result := '';
end;

function CefBrowserHostCreate(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): Boolean;
Var
  u: TCefString;
begin
  CefInitDefault;
  u := CefString(url);
  Result := cef_browser_host_create_browser(windowInfo, CefGetData(client), @u, settings) <> 0;
end;

function CefBrowserHostCreateSync(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): ICefBrowser;
Var
  u: TCefString;
begin
  CefInitDefault;
  u := CefString(url);
  Result := TCefBrowserRef.UnWrap(cef_browser_host_create_browser_sync(windowInfo, CefGetData(client), @u, settings));
end;

procedure CefVisitWebPluginInfo(const visitor: ICefWebPluginInfoVisitor);
begin
  cef_visit_web_plugin_info(CefGetData(visitor));
end;

procedure CefVisitWebPluginInfoProc(const visitor: TCefWebPluginInfoVisitorProc);
begin
  CefVisitWebPluginInfo(TCefFastWebPluginInfoVisitor.Create(visitor));
end;

procedure CefRefreshWebPlugins;
begin
  cef_refresh_web_plugins();
end;

procedure CefAddWebPluginPath(const path: ustring);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_add_web_plugin_path(@p);
end;

procedure CefAddWebPluginDirectory(const dir: ustring);
Var
  d: TCefString;
begin
  d := CefString(dir);
  cef_add_web_plugin_directory(@d);
end;

procedure CefRemoveWebPluginPath(const path: ustring);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_remove_web_plugin_path(@p);
end;

procedure CefUnregisterInternalWebPlugin(const path: ustring);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_unregister_internal_web_plugin(@p);
end;

procedure CefForceWebPluginShutdown(const path: ustring);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_force_web_plugin_shutdown(@p);
end;

procedure CefRegisterWebPluginCrash(const path: ustring);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_register_web_plugin_crash(@p);
end;

procedure CefIsWebPluginUnstable(const path: ustring; const callback: ICefWebPluginUnstableCallback);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_is_web_plugin_unstable(@p, CefGetData(callback));
end;

procedure CefIsWebPluginUnstableProc(const path: ustring; const callback: TCefWebPluginIsUnstableProc);
begin
  CefIsWebPluginUnstable(path, TCefFastWebPluginUnstableCallback.Create(callback));
end;

function CefGetPath(key: TCefPathKey; out path: ustring): Boolean;
Var
  p: TCefString;
begin
  p := CefString('');
  Result := cef_get_path(key, @p) <> 0;
  path := CefStringClearAndGet(p);
end;

function CefBeginTracing(const client: ICefTraceClient; const categories: ustring): Boolean;
Var
  c: TCefString;
begin
  c := CefString(categories);
  Result := cef_begin_tracing(CefGetData(client), @c) <> 0;
end;

function CefGetTraceBufferPercentFullAsync: Integer;
begin
  Result := cef_get_trace_buffer_percent_full_async();
end;

function CefEndTracingAsync: Boolean;
begin
  Result := cef_end_tracing_async() <> 0;
end;

function CefGetGeolocation(const callback: ICefGetGeolocationCallback): Boolean;
begin
  Result := cef_get_geolocation(CefGetData(callback)) <> 0;
end;

{$IFDEF WINDOWS}
function CefTimeToSystemTime(const dt: TCefTime): TSystemTime;
begin
  With Result do
  begin
    wYear := dt.year;
    wMonth := dt.month;
    wDayOfWeek := dt.day_of_week;
    wDay := dt.day_of_month;
    wHour := dt.hour;
    wMinute := dt.minute;
    wSecond := dt.second;
    wMilliseconds := dt.millisecond;
  end;
end;

function SystemTimeToCefTime(const dt: TSystemTime): TCefTime;
begin
  With Result do
  begin
    year := dt.wYear;
    month := dt.wMonth;
    day_of_week := dt.wDayOfWeek;
    day_of_month := dt.wDay;
    hour := dt.wHour;
    minute := dt.wMinute;
    second := dt.wSecond;
    millisecond := dt.wMilliseconds;
  end;
end;

{ TODO : Time functions }
function CefTimeToDateTime(const dt: TCefTime): TDateTime;
Var
  st: TSystemTime;
begin
  {
  st := CefTimeToSystemTime(dt);
  SystemTimeToTzSpecificLocalTime(nil, @st, @st);
  Result := SystemTimeToDateTime(st);
  }
end;

function DateTimeToCefTime(dt: TDateTime): TCefTime;
Var
  st: TSystemTime;
begin
  {
  DateTimeToSystemTime(dt, st);
  TzSpecificLocalTimeToSystemTime(nil, @st, @st);
  Result := SystemTimeToCefTime(st);
  }
end;

{$ELSE}

function CefTimeToDateTime(const dt: TCefTime): TDateTime;
begin
  Result := EncodeDate(dt.year, dt.month, dt.day_of_month) + EncodeTime(dt.hour, dt.minute, dt.second, dt.millisecond);
end;

function DateTimeToCefTime(dt: TDateTime): TCefTime;
Var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(dt, Year, Month, Day);
  DecodeTime(dt, Hour, Min, Sec, MSec);

  With Result do
  begin
    year := Year;
    month := Month;
    day_of_week := DayOfWeek(dt);
    day_of_month := Month;
    hour := Hour;
    minute := Min;
    second := Sec;
    millisecond := MSec;
  end;
end;

{$ENDIF}


{ cef_base }

function cef_base_add_ref(self: PCefBase): Integer; cconv;
begin
  //Debugln('AddRef');
  Result := TCefBaseOwn(CefGetObject(self))._AddRef;
end;

function cef_base_release(self: PCefBase): Integer; cconv;
begin
  //Debugln('Release');
  Result := TCefBaseOwn(CefGetObject(self))._Release;
end;

function cef_base_get_refct(self: PCefBase): Integer; cconv;
begin
  Result := TCefBaseOwn(CefGetObject(self)).FRefCount;
end;

function cef_base_add_ref_owned(self: PCefBase): Integer; cconv;
begin
  Result := 1;
end;

function cef_base_release_owned(self: PCefBase): Integer; cconv;
begin
  Result := 1;
end;

function cef_base_get_refct_owned(self: PCefBase): Integer; cconv;
begin
  Result := 1;
end;

{ cef_client }

function cef_client_get_context_menu_handler(self: PCefClient): PCefContextMenuHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetContextMenuHandler);
end;

function cef_client_get_dialog_handler(self: PCefClient): PCefDialogHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetDialogHandler);
end;

function cef_client_get_display_handler(self: PCefClient): PCefDisplayHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetDisplayHandler);
end;

function cef_client_get_download_handler(self: PCefClient): PCefDownloadHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetDownloadHandler);
end;

function cef_client_get_focus_handler(self: PCefClient): PCefFocusHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetFocusHandler);
end;

function cef_client_get_geolocation_handler(self: PCefClient): PCefGeolocationHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetGeolocationHandler);
end;

function cef_client_get_jsdialog_handler(self: PCefClient): PCefJsDialogHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetJsdialogHandler);
end;

function cef_client_get_keyboard_handler(self: PCefClient): PCefKeyboardHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetKeyboardHandler);
end;

function cef_client_get_life_span_handler(self: PCefClient): PCefLifeSpanHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetLifeSpanHandler);
end;

function cef_client_get_load_handler(self: PCefClient): PCefLoadHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetLoadHandler);
end;

function cef_client_get_get_render_handler(self: PCefClient): PCefRenderHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetRenderHandler);
end;

function cef_client_get_request_handler(self: PCefClient): PCefRequestHandler; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := CefGetData(GetRequestHandler);
end;

function cef_client_on_process_message_received(self: PCefClient; browser: PCefBrowser;
  source_process: TCefProcessId; message: PCefProcessMessage): Integer; cconv;
begin
  With TCefClientOwn(CefGetObject(self)) do
    Result := Ord(OnProcessMessageReceived(TCefBrowserRef.UnWrap(browser), source_process,
      TCefProcessMessageRef.UnWrap(message)));
end;

{ cef_geolocation_handler }

procedure cef_geolocation_handler_on_request_geolocation_permission(self: PCefGeolocationHandler;
  browser: PCefBrowser; const requesting_url: PCefString; request_id: Integer;
  callback: PCefGeolocationCallback); cconv;
begin
  With TCefGeolocationHandlerOwn(CefGetObject(self)) do
    OnRequestGeolocationPermission(TCefBrowserRef.UnWrap(browser), CefString(requesting_url),
      request_id, TCefGeolocationCallbackRef.UnWrap(callback));
end;

procedure cef_geolocation_handler_on_cancel_geolocation_permission(self: PCefGeolocationHandler;
  browser: PCefBrowser; const requesting_url: PCefString; request_id: Integer); cconv;
begin
  With TCefGeolocationHandlerOwn(CefGetObject(self)) do
    OnCancelGeolocationPermission(TCefBrowserRef.UnWrap(browser), CefString(requesting_url), request_id);
end;

{ cef_life_span_handler }

//function cef_life_span_handler_on_before_popup(self: PCefLifeSpanHandler; parentBrowser: PCefBrowser;
//   const popupFeatures: PCefPopupFeatures; windowInfo: PCefWindowInfo; const url: PCefString;
//   var client: PCefClient; settings: PCefBrowserSettings): Integer; cconv;
function cef_life_span_handler_on_before_popup(self: PCefLifeSpanHandler;
  browser: PCefBrowser; frame: PCefFrame; const target_url, target_frame_name: PCefString;
  const popupFeatures: PCefPopupFeatures; windowInfo: PCefWindowInfo; var client: PCefClient;
  settings: PCefBrowserSettings; no_javascript_access: PInteger): Integer; cconv;
Var
  _url, _frame: ustring;
  _client: ICefClient;
  _nojs: Boolean;
begin
  _url := CefString(target_url);
  _frame := CefString(target_frame_name);
  _client := TCefClientOwn(CefGetObject(client));// as ICefClient;
  _nojs := no_javascript_access^ <> 0;
  With TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforePopup(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      _url,
      _frame,
      popupFeatures^,
      windowInfo^,
      _client,
      settings^,
      _nojs
    ));
  CefStringSet(target_url, _url);
  CefStringSet(target_frame_name, _frame);
  client := CefGetData(_client);
  no_javascript_access^ := Ord(_nojs);
  _client := nil;
end;

procedure cef_life_span_handler_on_after_created(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;
begin
  TCefLifeSpanHandlerOwn(CefGetObject(self)).OnAfterCreated(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_life_span_handler_on_before_close(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;
begin
  with TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    OnBeforeClose(TCefBrowserRef.UnWrap(browser));
end;

function cef_life_span_handler_run_modal(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cconv;
begin
  with TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    Result := Ord(RunModal(TCefBrowserRef.UnWrap(browser)));
end;

function cef_life_span_handler_do_close(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cconv;
begin

  with TCefLifeSpanHandlerOwn(CefGetObject(self)) do
    Result := Ord(DoClose(TCefBrowserRef.UnWrap(browser)));
end;


{ cef_load_handler }

procedure cef_load_handler_on_load_start(self: PCefLoadHandler;
  browser: PCefBrowser; frame: PCefFrame); cconv;
begin
  with TCefLoadHandlerOwn(CefGetObject(self)) do
    OnLoadStart(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame));
end;

procedure cef_load_handler_on_load_end(self: PCefLoadHandler;
  browser: PCefBrowser; frame: PCefFrame; httpStatusCode: Integer); cconv;
begin
  with TCefLoadHandlerOwn(CefGetObject(self)) do
    OnLoadEnd(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), httpStatusCode);
end;

procedure cef_load_handler_on_load_error(self: PCefLoadHandler; browser: PCefBrowser;
  frame: PCefFrame; errorCode: Integer; const errorText, failedUrl: PCefString); cconv;
begin
  with TCefLoadHandlerOwn(CefGetObject(self)) do
    OnLoadError(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      errorCode, CefString(errorText), CefString(failedUrl));
end;

procedure cef_load_handler_on_render_process_terminated(self: PCefLoadHandler;
  browser: PCefBrowser; status: TCefTerminationStatus); cconv;
begin
  with TCefLoadHandlerOwn(CefGetObject(self)) do
    OnRenderProcessTerminated(TCefBrowserRef.UnWrap(browser), status);
end;

procedure cef_load_handler_on_plugin_crashed(self: PCefLoadHandler;
  browser: PCefBrowser; const plugin_path: PCefString); cconv;
begin
  with TCefLoadHandlerOwn(CefGetObject(self)) do
    OnPluginCrashed(TCefBrowserRef.UnWrap(browser), CefString(plugin_path));
end;

{ cef_request_handler }

function cef_request_handler_on_before_resource_load(self: PCefRequestHandler;
   browser: PCefBrowser; frame: PCefFrame; request: PCefRequest): Integer; cconv;
begin
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforeResourceLoad(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request)));
end;

function cef_request_handler_get_resource_handler(self: PCefRequestHandler;
  browser: PCefBrowser; frame: PCefFrame; request: PCefRequest): PCefResourceHandler; cconv;
begin
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := CefGetData(GetResourceHandler(TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame), TCefRequestRef.UnWrap(request)));
end;

procedure cef_request_handler_on_resource_redirect(self: PCefRequestHandler;
  browser: PCefBrowser; frame: PCefFrame; const old_url: PCefString; new_url: PCefString); cconv;
var
  url: ustring;
begin
  url := CefString(new_url);
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    OnResourceRedirect(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      CefString(old_url), url);
  if url <> '' then
    CefStringSet(new_url, url);
end;

function cef_request_handler_get_auth_credentials(self: PCefRequestHandler;
  browser: PCefBrowser; frame: PCefFrame; isProxy: Integer; const host: PCefString;
  port: Integer; const realm, scheme: PCefString; callback: PCefAuthCallback): Integer; cconv;
begin
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetAuthCredentials(
      TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), isProxy <> 0,
      CefString(host), port, CefString(realm), CefString(scheme), TCefAuthCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_on_quota_request(self: PCefRequestHandler; browser: PCefBrowser;
  const origin_url: PCefString; new_size: Int64; callback: PCefQuotaCallback): Integer; cconv;
begin
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnQuotaRequest(TCefBrowserRef.UnWrap(browser),
      CefString(origin_url), new_size, TCefQuotaCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_get_cookie_manager(self: PCefRequestHandler;
  browser: PCefBrowser; const main_url: PCefString): PCefCookieManager; cconv;
begin
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := CefGetData(GetCookieManager(TCefBrowserRef.UnWrap(browser), CefString(main_url)));
end;

procedure cef_request_handler_on_protocol_execution(self: PCefRequestHandler;
  browser: PCefBrowser; const url: PCefString; allow_os_execution: PInteger); cconv;
var
  allow: Boolean;
begin
  allow := allow_os_execution^ <> 0;
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    OnProtocolExecution(
      TCefBrowserRef.UnWrap(browser),
      CefString(url), allow);
  allow_os_execution^ := Ord(allow);
end;

function cef_request_handler_on_before_plugin_load(self: PCefRequestHandler; browser: PCefBrowser;
  const url, policy_url: PCefString; info: PCefWebPluginInfo): Integer; cconv;
begin
  with TCefRequestHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforePluginLoad(TCefBrowserRef.UnWrap(browser),
      CefString(url), CefString(policy_url), TCefWebPluginInfoRef.UnWrap(info)));
end;

{ cef_display_handler }

procedure cef_display_handler_on_loading_state_change(self: PCefDisplayHandler;
  browser: PCefBrowser; isLoading, canGoBack, canGoForward: Integer); cconv;
begin
  with TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnLoadingStateChange(TCefBrowserRef.UnWrap(browser), isLoading <> 0,
      canGoBack <> 0, canGoForward <> 0);
end;

procedure cef_display_handler_on_address_change(self: PCefDisplayHandler;
  browser: PCefBrowser; frame: PCefFrame; const url: PCefString); cconv;
begin
  with TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnAddressChange(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      cefstring(url))
end;

procedure cef_display_handler_on_title_change(self: PCefDisplayHandler;
  browser: PCefBrowser; const title: PCefString); cconv;
begin
  with TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnTitleChange(TCefBrowserRef.UnWrap(browser), CefString(title));
end;

function cef_display_handler_on_tooltip(self: PCefDisplayHandler;
  browser: PCefBrowser; text: PCefString): Integer; cconv;
var
  t: ustring;
begin
  t := CefStringClearAndGet(text^);
  with TCefDisplayHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnTooltip(
      TCefBrowserRef.UnWrap(browser), t));
  text^ := CefStringAlloc(t);
end;

procedure cef_display_handler_on_status_message(self: PCefDisplayHandler;
  browser: PCefBrowser; const value: PCefString); cconv;
begin
  with TCefDisplayHandlerOwn(CefGetObject(self)) do
    OnStatusMessage(TCefBrowserRef.UnWrap(browser), CefString(value));
end;

function cef_display_handler_on_console_message(self: PCefDisplayHandler;
    browser: PCefBrowser; const message: PCefString;
    const source: PCefString; line: Integer): Integer; cconv;
begin
  with TCefDisplayHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnConsoleMessage(TCefBrowserRef.UnWrap(browser),
    CefString(message), CefString(source), line));
end;

{ cef_focus_handler }

procedure cef_focus_handler_on_take_focus(self: PCefFocusHandler;
  browser: PCefBrowser; next: Integer); cconv;
begin
  with TCefFocusHandlerOwn(CefGetObject(self)) do
    OnTakeFocus(TCefBrowserRef.UnWrap(browser), next <> 0);
end;

function cef_focus_handler_on_set_focus(self: PCefFocusHandler;
  browser: PCefBrowser; source: TCefFocusSource): Integer; cconv;
begin
  with TCefFocusHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnSetFocus(TCefBrowserRef.UnWrap(browser), source))
end;

procedure cef_focus_handler_on_got_focus(self: PCefFocusHandler; browser: PCefBrowser); cconv;
begin
  with TCefFocusHandlerOwn(CefGetObject(self)) do
    OnGotFocus(TCefBrowserRef.UnWrap(browser));
end;

{ cef_keyboard_handler }

function cef_keyboard_handler_on_pre_key_event(self: PCefKeyboardHandler;
  browser: PCefBrowser; const event: PCefKeyEvent;
  os_event: TCefEventHandle; is_keyboard_shortcut: PInteger): Integer; cconv;
var
  ks: Boolean;
begin
  ks := is_keyboard_shortcut^ <> 0;
  with TCefKeyboardHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnPreKeyEvent(TCefBrowserRef.UnWrap(browser), event, os_event, ks));
  is_keyboard_shortcut^ := Ord(ks);
end;

function cef_keyboard_handler_on_key_event(self: PCefKeyboardHandler;
    browser: PCefBrowser; const event: PCefKeyEvent; os_event: TCefEventHandle): Integer; cconv;
begin
  with TCefKeyboardHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnKeyEvent(TCefBrowserRef.UnWrap(browser), event, os_event));
end;

{ cef_jsdialog_handler }

function cef_jsdialog_handler_on_jsdialog(self: PCefJsDialogHandler;
  browser: PCefBrowser; const origin_url, accept_lang: PCefString;
  dialog_type: TCefJsDialogType; const message_text, default_prompt_text: PCefString;
  callback: PCefJsDialogCallback; suppress_message: PInteger): Integer; cconv;
var
  sm: Boolean;
begin
  sm := suppress_message^ <> 0;
  with TCefJsDialogHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnJsdialog(TCefBrowserRef.UnWrap(browser), CefString(origin_url),
      CefString(accept_lang), dialog_type, CefString(message_text),
      CefString(default_prompt_text), TCefJsDialogCallbackRef.UnWrap(callback), sm));
  suppress_message^ := Ord(sm);
end;

function cef_jsdialog_handler_on_before_unload_dialog(self: PCefJsDialogHandler;
  browser: PCefBrowser; const message_text: PCefString; is_reload: Integer;
  callback: PCefJsDialogCallback): Integer; cconv;
begin
  with TCefJsDialogHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnBeforeUnloadDialog(TCefBrowserRef.UnWrap(browser), CefString(message_text),
      is_reload <> 0, TCefJsDialogCallbackRef.UnWrap(callback)));
end;

procedure cef_jsdialog_handler_on_reset_dialog_state(self: PCefJsDialogHandler;
  browser: PCefBrowser); cconv;
begin
  with TCefJsDialogHandlerOwn(CefGetObject(self)) do
    OnResetDialogState(TCefBrowserRef.UnWrap(browser));
end;

{ cef_context_menu_handler }

procedure cef_context_menu_handler_on_before_context_menu(self: PCefContextMenuHandler;
  browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
  model: PCefMenuModel); cconv;
begin
  with TCefContextMenuHandlerOwn(CefGetObject(self)) do
    OnBeforeContextMenu(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), TCefMenuModelRef.UnWrap(model));
end;

function cef_context_menu_handler_on_context_menu_command(self: PCefContextMenuHandler;
  browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
  command_id: Integer; event_flags: Integer): Integer; cconv;
begin
  with TCefContextMenuHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnContextMenuCommand(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefContextMenuParamsRef.UnWrap(params), command_id, TCefEventFlags(Pointer(@event_flags)^)));
end;

procedure cef_context_menu_handler_on_context_menu_dismissed(self: PCefContextMenuHandler;
  browser: PCefBrowser; frame: PCefFrame); cconv;
begin
  with TCefContextMenuHandlerOwn(CefGetObject(self)) do
    OnContextMenuDismissed(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame));
end;

{  cef_stream_reader }

function cef_stream_reader_read(self: PCefReadHandler; ptr: Pointer; size, n: Cardinal): Cardinal; cconv;
begin
  with TCefCustomStreamReader(CefGetObject(self)) do
    Result := Read(ptr, size, n);
end;

function cef_stream_reader_seek(self: PCefReadHandler; offset: Int64; whence: Integer): Integer; cconv;
begin
  with TCefCustomStreamReader(CefGetObject(self)) do
    Result := Seek(offset, whence);
end;

function cef_stream_reader_tell(self: PCefReadHandler): Int64; cconv;
begin
  with TCefCustomStreamReader(CefGetObject(self)) do
    Result := Tell;
end;

function cef_stream_reader_eof(self: PCefReadHandler): Integer; cconv;
begin
  with TCefCustomStreamReader(CefGetObject(self)) do
    Result := Ord(eof);
end;

{ cef_post_data_element }

function cef_post_data_element_is_read_only(self: PCefPostDataElement): Integer; cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := Ord(IsReadOnly)
end;

procedure cef_post_data_element_set_to_empty(self: PCefPostDataElement); cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToEmpty;
end;

procedure cef_post_data_element_set_to_file(self: PCefPostDataElement; const fileName: PCefString); cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToFile(CefString(fileName));
end;

procedure cef_post_data_element_set_to_bytes(self: PCefPostDataElement; size: Cardinal; const bytes: Pointer); cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToBytes(size, bytes);
end;

function cef_post_data_element_get_type(self: PCefPostDataElement): TCefPostDataElementType; cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetType;
end;

function cef_post_data_element_get_file(self: PCefPostDataElement): PCefStringUserFree; cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := CefUserFreeString(GetFile);
end;

function cef_post_data_element_get_bytes_count(self: PCefPostDataElement): Cardinal; cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytesCount;
end;

function cef_post_data_element_get_bytes(self: PCefPostDataElement; size: Cardinal; bytes: Pointer): Cardinal; cconv;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytes(size, bytes)
end;

{ cef_v8_handler }

function cef_v8_handler_execute(self: PCefv8Handler;
  const name: PCefString; obj: PCefv8Value; argumentsCount: Cardinal;
  const arguments: PPCefV8Value; var retval: PCefV8Value;
  var exception: TCefString): Integer; cconv;
var
  args: TCefv8ValueArray;
  i: Integer;
  ret: ICefv8Value;
  exc: ustring;
begin
  SetLength(args, argumentsCount);
  For i := 0 to argumentsCount - 1 do
    args[i] := TCefv8ValueRef.UnWrap(arguments^[i]);

  Result := -Ord(TCefv8HandlerOwn(CefGetObject(self)).Execute(
    CefString(name), TCefv8ValueRef.UnWrap(obj), args, ret, exc));
  retval := CefGetData(ret);
  ret := nil;
  exception := CefString(exc);
end;

{ cef_task }

procedure cef_task_execute(self: PCefTask); cconv;
begin
  TCefTaskOwn(CefGetObject(self)).Execute();
end;

{ cef_download_handler }

procedure cef_download_handler_on_before_download(self: PCefDownloadHandler;
  browser: PCefBrowser; download_item: PCefDownloadItem;
  const suggested_name: PCefString; callback: PCefBeforeDownloadCallback); cconv;
begin
  TCefDownloadHandlerOwn(CefGetObject(self)).
    OnBeforeDownload(TCefBrowserRef.UnWrap(browser),
    TCefDownLoadItemRef.UnWrap(download_item), CefString(suggested_name),
    TCefBeforeDownloadCallbackRef.UnWrap(callback));
end;

procedure cef_download_handler_on_download_updated(self: PCefDownloadHandler;
  browser: PCefBrowser; download_item: PCefDownloadItem; callback: PCefDownloadItemCallback); cconv;
begin
  TCefDownloadHandlerOwn(CefGetObject(self)).
    OnDownloadUpdated(TCefBrowserRef.UnWrap(browser),
    TCefDownLoadItemRef.UnWrap(download_item),
    TCefDownloadItemCallbackRef.UnWrap(callback));
end;

{ cef_dom_visitor }

procedure cef_dom_visitor_visite(self: PCefDomVisitor; document: PCefDomDocument); cconv;
begin
  TCefDomVisitorOwn(CefGetObject(self)).visit(TCefDomDocumentRef.UnWrap(document));
end;

{ cef_dom_event_listener }

procedure cef_dom_event_listener_handle_event(self: PCefDomEventListener; event: PCefDomEvent); cconv;
begin
  TCefDomEventListenerOwn(CefGetObject(self)).HandleEvent(TCefDomEventRef.UnWrap(event));
end;

{ cef_v8_accessor }

function cef_v8_accessor_get(self: PCefV8Accessor; const name: PCefString;
      obj: PCefv8Value; out retval: PCefv8Value; exception: PCefString): Integer; cconv;
var
  ret: ICefv8Value;
begin
  Result := Ord(TCefV8AccessorOwn(CefGetObject(self)).Get(CefString(name),
    TCefv8ValueRef.UnWrap(obj), ret, CefString(exception)));
  retval := CefGetData(ret);
end;


function cef_v8_accessor_put(self: PCefV8Accessor; const name: PCefString;
      obj: PCefv8Value; value: PCefv8Value; exception: PCefString): Integer; cconv;
begin
  Result := Ord(TCefV8AccessorOwn(CefGetObject(self)).Put(CefString(name),
    TCefv8ValueRef.UnWrap(obj), TCefv8ValueRef.UnWrap(value), CefString(exception)));
end;

{ cef_cookie_visitor }

function cef_cookie_visitor_visit(self: PCefCookieVisitor; const cookie: PCefCookie;
  count, total: Integer; deleteCookie: PInteger): Integer; cconv;
var
  delete: Boolean;
  exp: TDateTime;
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

{ cef_resource_bundle_handler }

function cef_resource_bundle_handler_get_localized_string(self: PCefResourceBundleHandler;
  message_id: Integer; string_val: PCefString): Integer; cconv;
var
  str: ustring;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).
    GetLocalizedString(message_id, str));
  if Result <> 0 then
    string_val^ := CefString(str);
end;

function cef_resource_bundle_handler_get_data_resource(self: PCefResourceBundleHandler;
  resource_id: Integer; var data: Pointer; var data_size: Cardinal): Integer; cconv;
begin
  Result := Ord(TCefResourceBundleHandlerOwn(CefGetObject(self)).
    GetDataResource(resource_id, data, data_size));
end;

{ cef_app }

procedure cef_app_on_before_command_line_processing(self: PCefApp;
  const process_type: PCefString; command_line: PCefCommandLine); cconv;
begin
  With TCefAppOwn(CefGetObject(self)) do
    OnBeforeCommandLineProcessing(CefString(process_type), TCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_app_on_register_custom_schemes(self: PCefApp; registrar: PCefSchemeRegistrar); cconv;
begin
  With TCefAppOwn(CefGetObject(self)) do
    OnRegisterCustomSchemes(TCefSchemeRegistrarRef.UnWrap(registrar));
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

{ cef_string_visitor_visit }

procedure cef_string_visitor_visit(self: PCefStringVisitor; const str: PCefString); cconv;
begin
  TCefStringVisitorOwn(CefGetObject(self)).Visit(CefString(str));
end;

{ cef_browser_process_handler }

procedure cef_browser_process_handler_on_context_initialized(self: PCefBrowserProcessHandler); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).OnContextInitialized;
end;

procedure cef_browser_process_handler_on_before_child_process_launch(
  self: PCefBrowserProcessHandler; command_line: PCefCommandLine); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).OnBeforeChildProcessLaunch(TCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_browser_process_handler_on_render_process_thread_created(
  self: PCefBrowserProcessHandler; extra_info: PCefListValue); cconv;
begin
  TCefBrowserProcessHandlerOwn(CefGetObject(self)).OnRenderProcessThreadCreated(TCefListValueRef.UnWrap(extra_info));
end;

{ cef_render_process_handler }

procedure cef_render_process_handler_on_render_thread_created(
  self: PCefRenderProcessHandler; extra_info: PCefListValue); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnRenderThreadCreated(TCefListValueRef.UnWrap(extra_info));
end;

procedure cef_render_process_handler_on_web_kit_initialized(self: PCefRenderProcessHandler); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnWebKitInitialized;
end;

procedure cef_render_process_handler_on_browser_created(self: PCefRenderProcessHandler;
  browser: PCefBrowser); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnBrowserCreated(TCefBrowserRef.UnWrap(browser));
end;

procedure cef_render_process_handler_on_browser_destroyed(self: PCefRenderProcessHandler;
  browser: PCefBrowser); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnBrowserDestroyed(TCefBrowserRef.UnWrap(browser));
end;

function cef_render_process_handler_on_before_navigation(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; request: PCefRequest;
  navigation_type: TCefNavigationType; is_redirect: Integer): Integer; cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    Result := Ord(OnBeforeNavigation(TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame), TCefRequestRef.UnWrap(request),
      navigation_type, is_redirect <> 0));
end;

procedure cef_render_process_handler_on_context_created(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnContextCreated(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), TCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_context_released(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnContextReleased(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame), TCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_uncaught_exception(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context;
  exception: PCefV8Exception; stackTrace: PCefV8StackTrace); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnUncaughtException(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefv8ContextRef.UnWrap(context), TCefV8ExceptionRef.UnWrap(exception),
      TCefV8StackTraceRef.UnWrap(stackTrace));
end;

procedure cef_render_process_handler_on_worker_context_created(self: PCefRenderProcessHandler;
  worker_id: Integer; const url: PCefString; context: PCefv8Context); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnWorkerContextCreated(worker_id, CefString(url), TCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_worker_context_released(self: PCefRenderProcessHandler;
  worker_id: Integer; const url: PCefString; context: PCefv8Context); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnWorkerContextReleased(worker_id, CefString(url), TCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_worker_uncaught_exception(self: PCefRenderProcessHandler;
  worker_id: Integer; const url: PCefString; context: PCefv8Context;
  exception: PCefV8Exception; stackTrace: PCefV8StackTrace); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnWorkerUncaughtException(worker_id, CefString(url), TCefv8ContextRef.UnWrap(context),
      TCefV8ExceptionRef.UnWrap(exception), TCefV8StackTraceRef.UnWrap(stackTrace));
end;

procedure cef_render_process_handler_on_focused_node_changed(self: PCefRenderProcessHandler;
  browser: PCefBrowser; frame: PCefFrame; node: PCefDomNode); cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    OnFocusedNodeChanged(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      TCefDomNodeRef.UnWrap(node));
end;

function cef_render_process_handler_on_process_message_received(self: PCefRenderProcessHandler;
  browser: PCefBrowser; source_process: TCefProcessId;
  message: PCefProcessMessage): Integer; cconv;
begin
  with TCefRenderProcessHandlerOwn(CefGetObject(Self)) do
    Result := Ord(OnProcessMessageReceived(TCefBrowserRef.UnWrap(browser), source_process,
      TCefProcessMessageRef.UnWrap(message)));
end;

{ cef_url_request_client }

procedure cef_url_request_client_on_request_complete(self: PCefUrlRequestClient; request: PCefUrlRequest); cconv;
begin
  with TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnRequestComplete(TCefUrlRequestRef.UnWrap(request));
end;

procedure cef_url_request_client_on_upload_progress(self: PCefUrlRequestClient;
  request: PCefUrlRequest; current, total: UInt64); cconv;
begin
  with TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnUploadProgress(TCefUrlRequestRef.UnWrap(request), current, total);
end;

procedure cef_url_request_client_on_download_progress(self: PCefUrlRequestClient;
  request: PCefUrlRequest; current, total: UInt64); cconv;
begin
  with TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnDownloadProgress(TCefUrlRequestRef.UnWrap(request), current, total);
end;

procedure cef_url_request_client_on_download_data(self: PCefUrlRequestClient;
  request: PCefUrlRequest; const data: Pointer; data_length: Cardinal); cconv;
begin
  with TCefUrlrequestClientOwn(CefGetObject(self)) do
    OnDownloadData(TCefUrlRequestRef.UnWrap(request), data, data_length);
end;

{ cef_scheme_handler_factory }

function cef_scheme_handler_factory_create(self: PCefSchemeHandlerFactory;
  browser: PCefBrowser; frame: PCefFrame; const scheme_name: PCefString;
  request: PCefRequest): PCefResourceHandler; cconv;
begin
  with TCefSchemeHandlerFactoryOwn(CefGetObject(self)) do
    Result := CefGetData(New(TCefBrowserRef.UnWrap(browser), TCefFrameRef.UnWrap(frame),
      CefString(scheme_name), TCefRequestRef.UnWrap(request)));
end;

{ cef_resource_handler }

function cef_resource_handler_process_request(self: PCefResourceHandler;
  request: PCefRequest; callback: PCefCallback): Integer; cconv;
begin
  with TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(ProcessRequest(TCefRequestRef.UnWrap(request), TCefCallbackRef.UnWrap(callback)));
end;

procedure cef_resource_handler_get_response_headers(self: PCefResourceHandler;
  response: PCefResponse; response_length: PInt64; redirectUrl: PCefString); cconv;
var
  ru: ustring;
begin
  ru := '';
  with TCefResourceHandlerOwn(CefGetObject(self)) do
    GetResponseHeaders(TCefResponseRef.UnWrap(response), response_length^, ru);
  if ru <> '' then
    CefStringSet(redirectUrl, ru);
end;

function cef_resource_handler_read_response(self: PCefResourceHandler;
  data_out: Pointer; bytes_to_read: Integer; bytes_read: PInteger;
    callback: PCefCallback): Integer; cconv;
begin
  with TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(ReadResponse(data_out, bytes_to_read, bytes_read^, TCefCallbackRef.UnWrap(callback)));
end;

function cef_resource_handler_can_get_cookie(self: PCefResourceHandler;
  const cookie: PCefCookie): Integer; cconv;
begin
  with TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(CanGetCookie(cookie));
end;

function cef_resource_handler_can_set_cookie(self: PCefResourceHandler;
  const cookie: PCefCookie): Integer; cconv;
begin
  with TCefResourceHandlerOwn(CefGetObject(self)) do
    Result := Ord(CanSetCookie(cookie));
end;

procedure cef_resource_handler_cancel(self: PCefResourceHandler); cconv;
begin
  with TCefResourceHandlerOwn(CefGetObject(self)) do
    Cancel;
end;

{ cef_web_plugin_info_visitor }

function cef_web_plugin_info_visitor_visit(self: PCefWebPluginInfoVisitor;
      info: PCefWebPluginInfo; count, total: Integer): Integer; cconv;
begin
  with TCefWebPluginInfoVisitorOwn(CefGetObject(self)) do
    Result := Ord(Visit(TCefWebPluginInfoRef.UnWrap(info), count, total));
end;

{ cef_web_plugin_unstable_callback }

procedure cef_web_plugin_unstable_callback_is_unstable(
  self: PCefWebPluginUnstableCallback; const path: PCefString; unstable: Integer); cconv;
begin
  with TCefWebPluginUnstableCallbackOwn(CefGetObject(self)) do
    IsUnstable(CefString(path), unstable <> 0);
end;

{ cef_run_file_dialog_callback }

procedure cef_run_file_dialog_callback_cont(self: PCefRunFileDialogCallback;
  browser_host: PCefBrowserHost; file_paths: TCefStringList); cconv;
var
  list: TStringList;
  i: Integer;
  str: TCefString;
begin
  list := TStringList.Create;
  try
    For i := 0 to cef_string_list_size(file_paths) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(file_paths, i, @str);
      list.Add(CefStringClearAndGet(str));
    end;
    With TCefRunFileDialogCallbackOwn(CefGetObject(self)) do
      cont(TCefBrowserHostRef.UnWrap(browser_host), list);
  finally
    list.Free;
  end;
end;


{ cef_trace_client }

procedure cef_trace_client_on_trace_data_collected(self: PCefTraceClient;
  const fragment: PAnsiChar; fragment_size: Cardinal); cconv;
begin
  TCefTraceClientOwn(CefGetObject(self)).OnTraceDataCollected(fragment, fragment_size);
end;

procedure cef_trace_client_on_trace_buffer_percent_full_reply(
  self: PCefTraceClient; percent_full: Single); cconv;
begin
  with TCefTraceClientOwn(CefGetObject(self)) do
    OnTraceBufferPercentFullReply(percent_full);
end;

procedure cef_trace_client_on_end_tracing_complete(self: PCefTraceClient); cconv;
begin
  with TCefTraceClientOwn(CefGetObject(self)) do
    OnEndTracingComplete;
end;

{ cef_get_geolocation_callback }

procedure cef_get_geolocation_callback_on_location_update(
  self: PCefGetGeolocationCallback; const position: PCefGeoposition); cconv;
begin
  with TCefGetGeolocationCallbackOwn(CefGetObject(self)) do
    OnLocationUpdate(position);
end;

{ cef_dialog_handler }

function cef_dialog_handler_on_file_dialog(self: PCefDialogHandler; browser: PCefBrowser;
  mode: TCefFileDialogMode; const title, default_file_name: PCefString;
  accept_types: TCefStringList; callback: PCefFileDialogCallback): Integer; cconv;
var
  list: TStringList;
  i: Integer;
  str: TCefString;
begin
  list := TStringList.Create;
  try
    for i := 0 to cef_string_list_size(accept_types) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(accept_types, i, @str);
      list.Add(CefStringClearAndGet(str));
    end;

    with TCefDialogHandlerOwn(CefGetObject(self)) do
      Result := Ord(OnFileDialog(TCefBrowserRef.UnWrap(browser), mode, CefString(title),
        CefString(default_file_name), list, TCefFileDialogCallbackRef.UnWrap(callback)));
  finally
    list.Free;
  end;
end;

{ cef_render_handler }

function cef_render_handler_get_root_screen_rect(self: PCefRenderHandler;
  browser: PCefBrowser; rect: PCefRect): Integer; cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetRootScreenRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_view_rect(self: PCefRenderHandler;
  browser: PCefBrowser; rect: PCefRect): Integer; cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetViewRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_screen_point(self: PCefRenderHandler;
  browser: PCefBrowser; viewX, viewY: Integer; screenX, screenY: PInteger): Integer; cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetScreenPoint(TCefBrowserRef.UnWrap(browser), viewX, viewY, screenX, screenY));
end;

procedure cef_render_handler_on_popup_show(self: PCefRenderProcessHandler;
  browser: PCefBrowser; show: Integer); cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPopupShow(TCefBrowserRef.UnWrap(browser), show <> 0);
end;

procedure cef_render_handler_on_popup_size(self: PCefRenderProcessHandler;
  browser: PCefBrowser; const rect: PCefRect); cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPopupSize(TCefBrowserRef.UnWrap(browser), rect);
end;

procedure cef_render_handler_on_paint(self: PCefRenderProcessHandler;
  browser: PCefBrowser; kind: TCefPaintElementType; dirtyRectsCount: Cardinal;
  const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer); cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPaint(TCefBrowserRef.UnWrap(browser), kind, dirtyRectsCount, dirtyRects,
      buffer, width, height);
end;

procedure cef_render_handler_on_cursor_change(self: PCefRenderProcessHandler;
  browser: PCefBrowser; cursor: TCefCursorHandle); cconv;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnCursorChange(TCefBrowserRef.UnWrap(browser), cursor);
end;

{ TCefBaseOwn }

constructor TCefBaseOwn.CreateData(size: Cardinal; owned: Boolean);
begin
  GetMem(FData, size + SizeOf(Pointer));
  PPointer(FData)^ := Self;
  //Inc(PByte(FData), SizeOf(Pointer));
  Inc(FData, SizeOf(Pointer));
  FillChar(FData^, size, 0);
  PCefBase(FData)^.size := size;

  If owned then
  begin
    With PCefBaSE(FData)^ do
    begin
      add_ref := @cef_base_add_ref_owned;
      release := @cef_base_release_owned;
      get_refct := @cef_base_get_refct_owned;
    end;
  end
  Else
  begin
    With PCefBase(FData)^ do
    begin
      add_ref := @cef_base_add_ref;
      release := @cef_base_release;
      get_refct := @cef_base_get_refct;
    end;
  end;
end;

destructor TCefBaseOwn.Destroy;
begin
  //Dec(PByte(FData), SizeOf(Pointer));
  Dec(FData, SizeOf(Pointer));
  FreeMem(FData);
  inherited;
end;

function TCefBaseOwn.Wrap: Pointer;
begin
  Result := FData;
  If Assigned(PCefBase(FData)^.add_ref) then PCefBase(FData)^.add_ref(PCefBase(FData));
end;

{ TCefBaseRef }

constructor TCefBaseRef.Create(data: Pointer);
begin
  Assert(data <> nil);
  FData := data;
end;

destructor TCefBaseRef.Destroy;
begin
  If Assigned(PCefBase(FData)^.release) then
    PCefBase(FData)^.release(PCefBase(FData));
  inherited;
end;

class function TCefBaseRef.UnWrap(data: Pointer): ICefBase;
begin
  //If data <> nil then Result := Create(data) as ICefBase
  If data <> nil then Result := ICefBase(Create(data))
  Else Result := nil;
end;

function TCefBaseRef.Wrap: Pointer;
begin
  Result := FData;
  If Assigned(PCefBase(FData)^.add_ref) then PCefBase(FData)^.add_ref(PCefBase(FData));
end;

{ TCefBrowserRef }

function TCefBrowserRef.GetHost: ICefBrowserHost;
begin
  Result := TCefBrowserHostRef.UnWrap(PCefBrowser(FData)^.get_host(PCefBrowser(FData)));
end;

function TCefBrowserRef.CanGoBack: Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_back(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.CanGoForward: Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_forward(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.GetFocusedFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_focused_frame(PCefBrowser(FData)))
end;

function TCefBrowserRef.GetFrameByident(identifier: Int64): ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_frame_byident(PCefBrowser(FData), identifier));
end;

function TCefBrowserRef.GetFrame(const name: ustring): ICefFrame;
var
  n: TCefString;
begin
  n := CefString(name);
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_frame(PCefBrowser(FData), @n));
end;

function TCefBrowserRef.GetFrameCount: Cardinal;
begin
  Result := PCefBrowser(FData)^.get_frame_count(PCefBrowser(FData));
end;

procedure TCefBrowserRef.GetFrameIdentifiers(count: PCardinal; identifiers: PInt64);
begin
  PCefBrowser(FData)^.get_frame_identifiers(PCefBrowser(FData), count, identifiers);
end;

procedure TCefBrowserRef.GetFrameNames(names: TStrings);
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    PCefBrowser(FData)^.get_frame_names(PCefBrowser(FData), list);
    FillChar(str, SizeOf(str), 0);
    for i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(list, i, @str);
      names.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefBrowserRef.SendProcessMessage(targetProcess: TCefProcessId; message: ICefProcessMessage): Boolean;
begin
  Result := PCefBrowser(FData)^.send_process_message(PCefBrowser(FData), targetProcess, CefGetData(message)) <> 0;
end;

function TCefBrowserRef.GetMainFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_main_frame(PCefBrowser(FData)))
end;

procedure TCefBrowserRef.GoBack;
begin
  PCefBrowser(FData)^.go_back(PCefBrowser(FData));
end;

procedure TCefBrowserRef.GoForward;
begin
  PCefBrowser(FData)^.go_forward(PCefBrowser(FData));
end;

function TCefBrowserRef.IsLoading: Boolean;
begin
  Result := PCefBrowser(FData)^.is_loading(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.HasDocument: Boolean;
begin
  Result := PCefBrowser(FData)^.has_document(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.IsPopup: Boolean;
begin
  Result := PCefBrowser(FData)^.is_popup(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.IsSame(const that: ICefBrowser): Boolean;
begin
  Result := PCefBrowser(FData)^.is_same(PCefBrowser(FData), CefGetData(that)) <> 0;
end;

procedure TCefBrowserRef.Reload;
begin
  PCefBrowser(FData)^.reload(PCefBrowser(FData));
end;

procedure TCefBrowserRef.ReloadIgnoreCache;
begin
  PCefBrowser(FData)^.reload_ignore_cache(PCefBrowser(FData));
end;

procedure TCefBrowserRef.StopLoad;
begin
  PCefBrowser(FData)^.stop_load(PCefBrowser(FData));
end;

function TCefBrowserRef.GetIdentifier: Integer;
begin
  Result := PCefBrowser(FData)^.get_identifier(PCefBrowser(FData));
end;

class function TCefBrowserRef.UnWrap(data: Pointer): ICefBrowser;
begin
  //If data <> nil then Result := Create(data) as ICefBrowser
  If data <> nil then Result := ICefBrowser(Create(data))
  Else Result := nil;
end;

{ TCefFrameRef }

function TCefFrameRef.IsValid: Boolean;
begin
  Result := PCefFrame(FData)^.is_valid(PCefFrame(FData)) <> 0;
end;

procedure TCefFrameRef.Copy;
begin
  PCefFrame(FData)^.copy(PCefFrame(FData));
end;

procedure TCefFrameRef.Cut;
begin
  PCefFrame(FData)^.cut(PCefFrame(FData));
end;

procedure TCefFrameRef.Del;
begin
  PCefFrame(FData)^.del(PCefFrame(FData));
end;

procedure TCefFrameRef.ExecuteJavaScript(const code, scriptUrl: ustring; startLine: Integer);
var
  j, s: TCefString;
begin
  j := CefString(code);
  s := CefString(scriptUrl);
  PCefFrame(FData)^.execute_java_script(PCefFrame(FData), @j, @s, startline);
end;

function TCefFrameRef.GetBrowser: ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefFrame(FData)^.get_browser(PCefFrame(FData)));
end;

function TCefFrameRef.GetIdentifier: Int64;
begin
  Result := PCefFrame(FData)^.get_identifier(PCefFrame(FData));
end;

function TCefFrameRef.GetName: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_name(PCefFrame(FData)));
end;

function TCefFrameRef.GetParent: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefFrame(FData)^.get_parent(PCefFrame(FData)));
end;

procedure TCefFrameRef.GetSource(const visitor: ICefStringVisitor);
begin
  PCefFrame(FData)^.get_source(PCefFrame(FData), CefGetData(visitor));
end;

procedure TCefFrameRef.GetSourceProc(const proc: TCefStringVisitorProc);
begin
  GetSource(TCefFastStringVisitor.Create(proc));
end;

procedure TCefFrameRef.getText(const visitor: ICefStringVisitor);
begin
  PCefFrame(FData)^.get_text(PCefFrame(FData), CefGetData(visitor));
end;

procedure TCefFrameRef.GetTextProc(const proc: TCefStringVisitorProc);
begin
  GetText(TCefFastStringVisitor.Create(proc));
end;

function TCefFrameRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_url(PCefFrame(FData)));
end;

function TCefFrameRef.GetV8Context: ICefv8Context;
begin
  Result := TCefv8ContextRef.UnWrap(PCefFrame(FData)^.get_v8context(PCefFrame(FData)));
end;

function TCefFrameRef.IsFocused: Boolean;
begin
  Result := PCefFrame(FData)^.is_focused(PCefFrame(FData)) <> 0;
end;

function TCefFrameRef.IsMain: Boolean;
begin
  Result := PCefFrame(FData)^.is_main(PCefFrame(FData)) <> 0;
end;

procedure TCefFrameRef.LoadRequest(const request: ICefRequest);
begin
  PCefFrame(FData)^.load_request(PCefFrame(FData), CefGetData(request));
end;

procedure TCefFrameRef.LoadString(const str, url: ustring);
var
  s, u: TCefString;
begin
  s := CefString(str);
  u := CefString(url);
  PCefFrame(FData)^.load_string(PCefFrame(FData), @s, @u);
end;

procedure TCefFrameRef.LoadUrl(const url: ustring);
var
  u: TCefString;
begin
  u := CefString(url);
  PCefFrame(FData)^.load_url(PCefFrame(FData), @u);
end;

procedure TCefFrameRef.Paste;
begin
  PCefFrame(FData)^.paste(PCefFrame(FData));
end;

procedure TCefFrameRef.Redo;
begin
  PCefFrame(FData)^.redo(PCefFrame(FData));
end;

procedure TCefFrameRef.SelectAll;
begin
  PCefFrame(FData)^.select_all(PCefFrame(FData));
end;

procedure TCefFrameRef.Undo;
begin
  PCefFrame(FData)^.undo(PCefFrame(FData));
end;

procedure TCefFrameRef.ViewSource;
begin
  PCefFrame(FData)^.view_source(PCefFrame(FData));
end;

procedure TCefFrameRef.VisitDom(const visitor: ICefDomVisitor);
begin
  PCefFrame(FData)^.visit_dom(PCefFrame(FData), CefGetData(visitor));
end;

procedure TCefFrameRef.VisitDomProc(const proc: TCefDomVisitorProc);
begin
  //VisitDom(TCefFastDomVisitor.Create(proc) as ICefDomVisitor);
  VisitDom(TCefFastDomVisitor.Create(proc));
end;

class function TCefFrameRef.UnWrap(data: Pointer): ICefFrame;
begin
  //If data <> nil then Result := Create(data) as ICefFrame
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

{ TCefCustomStreamReader }

constructor TCefCustomStreamReader.Create(Stream: TStream; Owned: Boolean);
begin
  inherited CreateData(SizeOf(TCefReadHandler));
  FStream := stream;
  FOwned := Owned;
  With PCefReadHandler(FData)^ do
  begin
    read := @cef_stream_reader_read;
    seek := @cef_stream_reader_seek;
    tell := @cef_stream_reader_tell;
    eof := @cef_stream_reader_eof;
  end;
end;

constructor TCefCustomStreamReader.Create(const filename: string);
begin
  Create(TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite), True);
end;

destructor TCefCustomStreamReader.Destroy;
begin
  If FOwned then FStream.Free;
  inherited;
end;

function TCefCustomStreamReader.Eof: Boolean;
begin
  Result := FStream.Position = FStream.size;
end;

function TCefCustomStreamReader.Read(ptr: Pointer; size, n: Cardinal): Cardinal;
begin
  result := Cardinal(FStream.Read(ptr^, n * size)) div size;
end;

function TCefCustomStreamReader.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := FStream.Seek(offset, whence);
end;

function TCefCustomStreamReader.Tell: Int64;
begin
  Result := FStream.Position;
end;

{ TCefPostDataRef }

function TCefPostDataRef.IsReadOnly: Boolean;
begin
  Result := PCefPostData(FData)^.is_read_only(PCefPostData(FData)) <> 0;
end;

function TCefPostDataRef.AddElement(
  const element: ICefPostDataElement): Integer;
begin
  Result := PCefPostData(FData)^.add_element(PCefPostData(FData), CefGetData(element));
end;

function TCefPostDataRef.GetCount: Cardinal;
begin
  Result := PCefPostData(FData)^.get_element_count(PCefPostData(FData))
end;

function TCefPostDataRef.GetElements(Count: Cardinal): IInterfaceList;
var
  items: PCefPostDataElementArray;
  i: Integer;
begin
  Result := TInterfaceList.Create;
  GetMem(items, SizeOf(PCefPostDataElement) * Count);
  FillChar(items^, SizeOf(PCefPostDataElement) * Count, 0);
  try
    PCefPostData(FData)^.get_elements(PCefPostData(FData), @Count, items);
    For i := 0 to Count - 1 do
      Result.Add(TCefPostDataElementRef.UnWrap(items^[i]));
  finally
    FreeMem(items);
  end;
end;

class function TCefPostDataRef.New: ICefPostData;
begin
  Result := UnWrap(cef_post_data_create);
end;

function TCefPostDataRef.RemoveElement(
  const element: ICefPostDataElement): Integer;
begin
  Result := PCefPostData(FData)^.remove_element(PCefPostData(FData), CefGetData(element));
end;

procedure TCefPostDataRef.RemoveElements;
begin
  PCefPostData(FData)^.remove_elements(PCefPostData(FData));
end;

class function TCefPostDataRef.UnWrap(data: Pointer): ICefPostData;
begin
  //If data <> nil then Result := Create(data) as ICefPostData
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

{ TCefPostDataElementRef }

function TCefPostDataElementRef.IsReadOnly: Boolean;
begin
  Result := PCefPostDataElement(FData)^.is_read_only(PCefPostDataElement(FData)) <> 0;
end;

function TCefPostDataElementRef.GetBytes(size: Cardinal;
  bytes: Pointer): Cardinal;
begin
  Result := PCefPostDataElement(FData)^.get_bytes(PCefPostDataElement(FData), size, bytes);
end;

function TCefPostDataElementRef.GetBytesCount: Cardinal;
begin
  Result := PCefPostDataElement(FData)^.get_bytes_count(PCefPostDataElement(FData));
end;

function TCefPostDataElementRef.GetFile: ustring;
begin
  Result := CefStringFreeAndGet(PCefPostDataElement(FData)^.get_file(PCefPostDataElement(FData)));
end;

function TCefPostDataElementRef.GetType: TCefPostDataElementType;
begin
  Result := PCefPostDataElement(FData)^.get_type(PCefPostDataElement(FData));
end;

class function TCefPostDataElementRef.New: ICefPostDataElement;
begin
  Result := UnWrap(cef_post_data_element_create);
end;

procedure TCefPostDataElementRef.SetToBytes(size: Cardinal; bytes: Pointer);
begin
  PCefPostDataElement(FData)^.set_to_bytes(PCefPostDataElement(FData), size, bytes);
end;

procedure TCefPostDataElementRef.SetToEmpty;
begin
  PCefPostDataElement(FData)^.set_to_empty(PCefPostDataElement(FData));
end;

procedure TCefPostDataElementRef.SetToFile(const fileName: ustring);
var
  f: TCefString;
begin
  f := CefString(fileName);
  PCefPostDataElement(FData)^.set_to_file(PCefPostDataElement(FData), @f);
end;

class function TCefPostDataElementRef.UnWrap(data: Pointer): ICefPostDataElement;
begin
  If data <> nil then Result := Create(data) //as ICefPostDataElement
  Else Result := nil;
end;

{ TCefPostDataElementOwn }

procedure TCefPostDataElementOwn.Clear;
begin
  case FDataType of
    PDE_TYPE_BYTES:
      if (FValueByte <> nil) then
      begin
        FreeMem(FValueByte);
        FValueByte := nil;
      end;
    PDE_TYPE_FILE:
      CefStringFree(@FValueStr)
  end;
  FDataType := PDE_TYPE_EMPTY;
  FSize := 0;
end;

constructor TCefPostDataElementOwn.Create(readonly: Boolean);
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

function TCefPostDataElementOwn.GetBytes(size: Cardinal;
  bytes: Pointer): Cardinal;
begin
  if (FDataType = PDE_TYPE_BYTES) and (FValueByte <> nil) then
  begin
    if size > FSize then
      Result := FSize else
      Result := size;
    Move(FValueByte^, bytes^, Result);
  end else
    Result := 0;
end;

function TCefPostDataElementOwn.GetBytesCount: Cardinal;
begin
  if (FDataType = PDE_TYPE_BYTES) then
    Result := FSize else
    Result := 0;
end;

function TCefPostDataElementOwn.GetFile: ustring;
begin
  if (FDataType = PDE_TYPE_FILE) then
    Result := CefString(@FValueStr) else
    Result := '';
end;

function TCefPostDataElementOwn.GetType: TCefPostDataElementType;
begin
  Result := FDataType;
end;

function TCefPostDataElementOwn.IsReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TCefPostDataElementOwn.SetToBytes(size: Cardinal; bytes: Pointer);
begin
  Clear;
  if (size > 0) and (bytes <> nil) then
  begin
    GetMem(FValueByte, size);
    Move(bytes^, FValueByte, size);
    FSize := size;
  end else
  begin
    FValueByte := nil;
    FSize := 0;
  end;
  FDataType := PDE_TYPE_BYTES;
end;

procedure TCefPostDataElementOwn.SetToEmpty;
begin
  Clear;
end;

procedure TCefPostDataElementOwn.SetToFile(const fileName: ustring);
begin
  Clear;
  FSize := 0;
  FValueStr := CefStringAlloc(fileName);
  FDataType := PDE_TYPE_FILE;
end;

{ TCefRequestRef }

function TCefRequestRef.IsReadOnly: Boolean;
begin
  Result := PCefRequest(FData)^.is_read_only(PCefRequest(FData)) <> 0;
end;

procedure TCefRequestRef.Assign(const url, method: ustring;
  const postData: ICefPostData; const headerMap: ICefStringMultimap);
var
  u, m: TCefString;
begin
  u := cefstring(url);
  m := cefstring(method);
  PCefRequest(FData)^.set_(PCefRequest(FData), @u, @m, CefGetData(postData), headerMap.Handle);
end;

function TCefRequestRef.GetFirstPartyForCookies: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_first_party_for_cookies(PCefRequest(FData)));
end;

function TCefRequestRef.GetFlags: TCefUrlRequestFlags;
begin
  Result := TCefUrlRequestFlags(PCefRequest(FData)^.get_flags(PCefRequest(FData)));
end;

procedure TCefRequestRef.GetHeaderMap(const HeaderMap: ICefStringMultimap);
begin
  PCefRequest(FData)^.get_header_map(PCefRequest(FData), HeaderMap.Handle);
end;

function TCefRequestRef.GetMethod: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_method(PCefRequest(FData)))
end;

function TCefRequestRef.GetPostData: ICefPostData;
begin
  Result := TCefPostDataRef.UnWrap(PCefRequest(FData)^.get_post_data(PCefRequest(FData)));
end;

function TCefRequestRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_url(PCefRequest(FData)))
end;

class function TCefRequestRef.New: ICefRequest;
begin
  Result := UnWrap(cef_request_create);
end;

procedure TCefRequestRef.SetFirstPartyForCookies(const url: ustring);
Var
  str: TCefString;
begin
  str := CefString(url);
  PCefRequest(FData)^.set_first_party_for_cookies(PCefRequest(FData), @str);
end;

procedure TCefRequestRef.SetFlags(flags: TCefUrlRequestFlags);
begin
  PCefRequest(FData)^.set_flags(PCefRequest(FData), PByte(@flags)^);
end;

procedure TCefRequestRef.SetHeaderMap(const HeaderMap: ICefStringMultimap);
begin
  PCefRequest(FData)^.set_header_map(PCefRequest(FData), HeaderMap.Handle);
end;

procedure TCefRequestRef.SetMethod(const value: ustring);
var
  v: TCefString;
begin
  v := CefString(value);
  PCefRequest(FData)^.set_method(PCefRequest(FData), @v);
end;

procedure TCefRequestRef.SetPostData(const value: ICefPostData);
begin
  if value <> nil then
    PCefRequest(FData)^.set_post_data(PCefRequest(FData), CefGetData(value));
end;

procedure TCefRequestRef.SetUrl(const value: ustring);
var
  v: TCefString;
begin
  v := CefString(value);
  PCefRequest(FData)^.set_url(PCefRequest(FData), @v);
end;

class function TCefRequestRef.UnWrap(data: Pointer): ICefRequest;
begin
  If data <> nil then Result := Create(data) //as ICefRequest
  Else Result := nil;
end;

{ TCefStreamReaderRef }

class function TCefStreamReaderRef.CreateForCustomStream(
  const stream: ICefCustomStreamReader): ICefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_handler(CefGetData(stream)))
end;

class function TCefStreamReaderRef.CreateForData(data: Pointer; size: Cardinal): ICefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_data(data, size))
end;

class function TCefStreamReaderRef.CreateForFile(const filename: ustring): ICefStreamReader;
var
  f: TCefString;
begin
  f := CefString(filename);
  Result := UnWrap(cef_stream_reader_create_for_file(@f))
end;

class function TCefStreamReaderRef.CreateForStream(const stream: TSTream;
  owned: Boolean): ICefStreamReader;
begin
  //Result := CreateForCustomStream(TCefCustomStreamReader.Create(stream, owned) as ICefCustomStreamReader);
  Result := CreateForCustomStream(TCefCustomStreamReader.Create(stream, owned));
end;

function TCefStreamReaderRef.Eof: Boolean;
begin
  Result := PCefStreamReader(FData)^.eof(PCefStreamReader(FData)) <> 0;
end;

function TCefStreamReaderRef.Read(ptr: Pointer; size, n: Cardinal): Cardinal;
begin
  Result := PCefStreamReader(FData)^.read(PCefStreamReader(FData), ptr, size, n);
end;

function TCefStreamReaderRef.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := PCefStreamReader(FData)^.seek(PCefStreamReader(FData), offset, whence);
end;

function TCefStreamReaderRef.Tell: Int64;
begin
  Result := PCefStreamReader(FData)^.tell(PCefStreamReader(FData));
end;

class function TCefStreamReaderRef.UnWrap(data: Pointer): ICefStreamReader;
begin
  If data <> nil then Result := Create(data) //as ICefStreamReader
  Else Result := nil;
end;

{ TCefv8ValueRef }

function TCefv8ValueRef.AdjustExternallyAllocatedMemory(changeInBytes: Integer): Integer;
begin
  Result := PCefV8Value(FData)^.adjust_externally_allocated_memory(PCefV8Value(FData), changeInBytes);
end;

class function TCefv8ValueRef.NewArray(len: Integer): ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_array(len));
end;

class function TCefv8ValueRef.NewBool(value: Boolean): ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_bool(Ord(value)));
end;

class function TCefv8ValueRef.NewDate(value: TDateTime): ICefv8Value;
Var
  dt: TCefTime;
begin
  dt := DateTimeToCefTime(value);
  Result := UnWrap(cef_v8value_create_date(@dt));
end;

class function TCefv8ValueRef.NewDouble(value: Double): ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_double(value));
end;

class function TCefv8ValueRef.NewFunction(const name: ustring; const handler: ICefv8Handler): ICefv8Value;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := UnWrap(cef_v8value_create_function(@n, CefGetData(handler)));
end;

class function TCefv8ValueRef.NewInt(value: Integer): ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_int(value));
end;

class function TCefv8ValueRef.NewUInt(value: Cardinal): ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_uint(value));
end;

class function TCefv8ValueRef.NewNull: ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_null);
end;

class function TCefv8ValueRef.NewObject(const Accessor: ICefV8Accessor): ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_object(CefGetData(Accessor)));
end;

class function TCefv8ValueRef.NewObjectProc(const getter: TCefV8AccessorGetterProc;
  const setter: TCefV8AccessorSetterProc): ICefv8Value;
begin
  //Result := NewObject(TCefFastV8Accessor.Create(getter, setter) as ICefV8Accessor);
  Result := NewObject(TCefFastV8Accessor.Create(getter, setter));
end;

class function TCefv8ValueRef.NewString(const str: ustring): ICefv8Value;
Var
  s: TCefString;
begin
  s := CefString(str);
  Result := UnWrap(cef_v8value_create_string(@s));
end;

class function TCefv8ValueRef.NewUndefined: ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_undefined);
end;

function TCefv8ValueRef.DeleteValueByIndex(index: Integer): Boolean;
begin
  Result := PCefV8Value(FData)^.delete_value_byindex(PCefV8Value(FData), index) <> 0;
end;

function TCefv8ValueRef.DeleteValueByKey(const key: ustring): Boolean;
Var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(FData)^.delete_value_bykey(PCefV8Value(FData), @k) <> 0;
end;

function TCefv8ValueRef.ExecuteFunction(const obj: ICefv8Value; const arguments: TCefv8ValueArray): ICefv8Value;
Var
  args: PPCefV8Value;
  i: Integer;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  try
    For i := 0 to Length(arguments) - 1 do args^[i] := CefGetData(arguments[i]);

    Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.execute_function(PCefV8Value(FData),
      CefGetData(obj), Length(arguments), args));
  finally
    FreeMem(args);
  end;
end;

function TCefv8ValueRef.ExecuteFunctionWithContext(const context: ICefv8Context;
  const obj: ICefv8Value; const arguments: TCefv8ValueArray): ICefv8Value;
Var
  args: PPCefV8Value;
  i: Integer;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  try
    For i := 0 to Length(arguments) - 1 do args^[i] := CefGetData(arguments[i]);

    Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.execute_function_with_context(PCefV8Value(FData),
      CefGetData(context), CefGetData(obj), Length(arguments), args));
  finally
    FreeMem(args);
  end;
end;

function TCefv8ValueRef.GetArrayLength: Integer;
begin
  Result := PCefV8Value(FData)^.get_array_length(PCefV8Value(FData));
end;

function TCefv8ValueRef.GetBoolValue: Boolean;
begin
  Result := PCefV8Value(FData)^.get_bool_value(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.GetDateValue: TDateTime;
begin
  Result := CefTimeToDateTime(PCefV8Value(FData)^.get_date_value(PCefV8Value(FData)));
end;

function TCefv8ValueRef.GetDoubleValue: Double;
begin
  Result := PCefV8Value(FData)^.get_double_value(PCefV8Value(FData));
end;

function TCefv8ValueRef.GetExternallyAllocatedMemory: Integer;
begin
  Result := PCefV8Value(FData)^.get_externally_allocated_memory(PCefV8Value(FData));
end;

function TCefv8ValueRef.GetFunctionHandler: ICefv8Handler;
begin
  Result := TCefv8HandlerRef.UnWrap(PCefV8Value(FData)^.get_function_handler(PCefV8Value(FData)));
end;

function TCefv8ValueRef.GetFunctionName: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(FData)^.get_function_name(PCefV8Value(FData)))
end;

function TCefv8ValueRef.GetIntValue: Integer;
begin
  Result := PCefV8Value(FData)^.get_int_value(PCefV8Value(FData))
end;

function TCefv8ValueRef.GetUIntValue: Cardinal;
begin
  Result := PCefV8Value(FData)^.get_uint_value(PCefV8Value(FData))
end;

function TCefv8ValueRef.GetKeys(const keys: TStrings): Integer;
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    Result := PCefV8Value(FData)^.get_keys(PCefV8Value(FData), list);
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(list, i, @str);
      keys.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefv8ValueRef.SetUserData(const data: ICefv8Value): Boolean;
begin
  Result := PCefV8Value(FData)^.set_user_data(PCefV8Value(FData), CefGetData(data)) <> 0;
end;

function TCefv8ValueRef.GetStringValue: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(FData)^.get_string_value(PCefV8Value(FData)));
end;

function TCefv8ValueRef.IsUserCreated: Boolean;
begin
  Result := PCefV8Value(FData)^.is_user_created(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsValid: Boolean;
begin
  Result := PCefV8Value(FData)^.is_valid(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.HasException: Boolean;
begin
  Result := PCefV8Value(FData)^.has_exception(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.GetException: ICefV8Exception;
begin
   Result := TCefV8ExceptionRef.UnWrap(PCefV8Value(FData)^.get_exception(PCefV8Value(FData)));
end;

function TCefv8ValueRef.ClearException: Boolean;
begin
  Result := PCefV8Value(FData)^.clear_exception(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.WillRethrowExceptions: Boolean;
begin
  Result := PCefV8Value(FData)^.will_rethrow_exceptions(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.SetRethrowExceptions(rethrow: Boolean): Boolean;
begin
  Result := PCefV8Value(FData)^.set_rethrow_exceptions(PCefV8Value(FData), Ord(rethrow)) <> 0;
end;

function TCefv8ValueRef.GetUserData: ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_user_data(PCefV8Value(FData)));
end;

function TCefv8ValueRef.GetValueByIndex(index: Integer): ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_value_byindex(PCefV8Value(FData), index))
end;

function TCefv8ValueRef.GetValueByKey(const key: ustring): ICefv8Value;
Var
  k: TCefString;
begin
  k := CefString(key);
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_value_bykey(PCefV8Value(FData), @k))
end;

function TCefv8ValueRef.HasValueByIndex(index: Integer): Boolean;
begin
  Result := PCefV8Value(FData)^.has_value_byindex(PCefV8Value(FData), index) <> 0;
end;

function TCefv8ValueRef.HasValueByKey(const key: ustring): Boolean;
Var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(FData)^.has_value_bykey(PCefV8Value(FData), @k) <> 0;
end;

function TCefv8ValueRef.IsArray: Boolean;
begin
  Result := PCefV8Value(FData)^.is_array(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsBool: Boolean;
begin
  Result := PCefV8Value(FData)^.is_bool(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsDate: Boolean;
begin
  Result := PCefV8Value(FData)^.is_date(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsDouble: Boolean;
begin
  Result := PCefV8Value(FData)^.is_double(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsFunction: Boolean;
begin
  Result := PCefV8Value(FData)^.is_function(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsInt: Boolean;
begin
  Result := PCefV8Value(FData)^.is_int(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsUInt: Boolean;
begin
  Result := PCefV8Value(FData)^.is_uint(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsNull: Boolean;
begin
  Result := PCefV8Value(FData)^.is_null(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsObject: Boolean;
begin
  Result := PCefV8Value(FData)^.is_object(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsSame(const that: ICefv8Value): Boolean;
begin
  Result := PCefV8Value(FData)^.is_same(PCefV8Value(FData), CefGetData(that)) <> 0;
end;

function TCefv8ValueRef.IsString: Boolean;
begin
  Result := PCefV8Value(FData)^.is_string(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsUndefined: Boolean;
begin
  Result := PCefV8Value(FData)^.is_undefined(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.SetValueByAccessor(const key: ustring;
  settings: TCefV8AccessControls; attribute: TCefV8PropertyAttributes): Boolean;
Var
  k: TCefString;
begin
  k := CefString(key);
  Result:= PCefV8Value(FData)^.set_value_byaccessor(PCefV8Value(FData), @k,
    PByte(@settings)^, PByte(@attribute)^) <> 0;
end;

function TCefv8ValueRef.SetValueByIndex(index: Integer;
  const value: ICefv8Value): Boolean;
begin
  Result:= PCefV8Value(FData)^.set_value_byindex(PCefV8Value(FData), index, CefGetData(value)) <> 0;
end;

function TCefv8ValueRef.SetValueByKey(const key: ustring;
  const value: ICefv8Value; attribute: TCefV8PropertyAttributes): Boolean;
Var
  k: TCefString;
begin
  k := CefString(key);
  Result:= PCefV8Value(FData)^.set_value_bykey(PCefV8Value(FData), @k,
    CefGetData(value), PByte(@attribute)^) <> 0;
end;

class function TCefv8ValueRef.UnWrap(data: Pointer): ICefv8Value;
begin
  //If data <> nil then Result := Create(data) as ICefv8Value
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;


{ TCefv8HandlerRef }

function TCefv8HandlerRef.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
Var
  args: array of PCefV8Value;
  i: Integer;
  ret: PCefV8Value;
  exc: TCefString;
  n: TCefString;
begin
  SetLength(args, Length(arguments));
  For i := 0 to Length(arguments) - 1 do args[i] := CefGetData(arguments[i]);
  ret := nil;
  FillChar(exc, SizeOf(exc), 0);
  n := CefString(name);
  Result := PCefv8Handler(FData)^.execute(PCefv8Handler(FData), @n,
    CefGetData(obj), Length(arguments), @args, ret, exc) <> 0;
  retval := TCefv8ValueRef.UnWrap(ret);
  exception := CefStringClearAndGet(exc);
end;

class function TCefv8HandlerRef.UnWrap(data: Pointer): ICefv8Handler;
begin
  //If data <> nil then Result := Create(data) as ICefv8Handler
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

{ TCefv8HandlerOwn }

constructor TCefv8HandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefv8Handler));
  PCefv8Handler(FData)^.execute := @cef_v8_handler_execute;
end;

function TCefv8HandlerOwn.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
begin
  Result := False;
end;

{ TCefTaskOwn }

constructor TCefTaskOwn.Create;
begin
  inherited CreateData(SizeOf(TCefTask));
  PCefTask(FData)^.execute := @cef_task_execute;
end;

procedure TCefTaskOwn.Execute;
begin

end;

{ TCefStringMapOwn }

procedure TCefStringMapOwn.Append(const key, value: ustring);
var
  k, v: TCefString;
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

function TCefStringMapOwn.Find(const key: ustring): ustring;
var
  str, k: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  k := CefString(key);
  cef_string_map_find(FStringMap, @k, str);
  Result := CefString(@str);
end;

function TCefStringMapOwn.GetHandle: TCefStringMap;
begin
  Result := FStringMap;
end;

function TCefStringMapOwn.GetKey(index: Integer): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_key(FStringMap, index, str);
  Result := CefString(@str);
end;

function TCefStringMapOwn.GetSize: Integer;
begin
  Result := cef_string_map_size(FStringMap);
end;

function TCefStringMapOwn.GetValue(index: Integer): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_value(FStringMap, index, str);
  Result := CefString(@str);
end;

{ TCefStringMultimapOwn }

procedure TCefStringMultimapOwn.Append(const Key, Value: ustring);
var
  k, v: TCefString;
begin
  k := CefString(key);
  v := CefString(value);
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

function TCefStringMultimapOwn.FindCount(const Key: ustring): Integer;
var
  k: TCefString;
begin
  k := CefString(Key);
  Result := cef_string_multimap_find_count(FStringMap, @k);
end;

function TCefStringMultimapOwn.GetEnumerate(const Key: ustring;
  ValueIndex: Integer): ustring;
var
  k, v: TCefString;
begin
  k := CefString(Key);
  FillChar(v, SizeOf(v), 0);
  cef_string_multimap_enumerate(FStringMap, @k, ValueIndex, v);
  Result := CefString(@v);
end;

function TCefStringMultimapOwn.GetHandle: TCefStringMultimap;
begin
  Result := FStringMap;
end;

function TCefStringMultimapOwn.GetKey(Index: Integer): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_multimap_key(FStringMap, index, str);
  Result := CefString(@str);
end;

function TCefStringMultimapOwn.GetSize: Integer;
begin
  Result := cef_string_multimap_size(FStringMap);
end;

function TCefStringMultimapOwn.GetValue(Index: Integer): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_multimap_value(FStringMap, index, str);
  Result := CefString(@str);
end;

{ TCefDownloadHandlerOwn }

constructor TCefDownloadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDownloadHandler));
  With PCefDownloadHandler(FData)^ do
  begin
    on_before_download := @cef_download_handler_on_before_download;
    on_download_updated := @cef_download_handler_on_download_updated;
  end;
end;

procedure TCefDownloadHandlerOwn.OnBeforeDownload(const browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
begin

end;

procedure TCefDownloadHandlerOwn.OnDownloadUpdated(const browser: ICefBrowser;
  const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
begin

end;

{ TCefXmlReaderRef }

function TCefXmlReaderRef.Close: Boolean;
begin
  Result := PCefXmlReader(FData)^.close(FData) <> 0;
end;

class function TCefXmlReaderRef.New(const stream: ICefStreamReader;
  encodingType: TCefXmlEncodingType; const URI: ustring): ICefXmlReader;
var
  u: TCefString;
begin
  u := CefString(URI);
  Result := UnWrap(cef_xml_reader_create(CefGetData(stream), encodingType, @u));
end;

function TCefXmlReaderRef.GetAttributeByIndex(index: Integer): ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_attribute_byindex(FData, index));
end;

function TCefXmlReaderRef.GetAttributeByLName(const localName,
  namespaceURI: ustring): ustring;
var
  l, n: TCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_attribute_bylname(FData, @l, @n));
end;

function TCefXmlReaderRef.GetAttributeByQName(
  const qualifiedName: ustring): ustring;
var
  q: TCefString;
begin
  q := CefString(qualifiedName);
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_attribute_byqname(FData, @q));
end;

function TCefXmlReaderRef.GetAttributeCount: Cardinal;
begin
  Result := PCefXmlReader(FData)^.get_attribute_count(FData);
end;

function TCefXmlReaderRef.GetBaseUri: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_base_uri(FData));
end;

function TCefXmlReaderRef.GetDepth: Integer;
begin
  Result := PCefXmlReader(FData)^.get_depth(FData);
end;

function TCefXmlReaderRef.GetError: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_error(FData));
end;

function TCefXmlReaderRef.GetInnerXml: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_inner_xml(FData));
end;

function TCefXmlReaderRef.GetLineNumber: Integer;
begin
  Result := PCefXmlReader(FData)^.get_line_number(FData);
end;

function TCefXmlReaderRef.GetLocalName: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_local_name(FData));
end;

function TCefXmlReaderRef.GetNamespaceUri: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_namespace_uri(FData));
end;

function TCefXmlReaderRef.GetOuterXml: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_outer_xml(FData));
end;

function TCefXmlReaderRef.GetPrefix: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_prefix(FData));
end;

function TCefXmlReaderRef.GetQualifiedName: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_qualified_name(FData));
end;

function TCefXmlReaderRef.GetType: TCefXmlNodeType;
begin
  Result := PCefXmlReader(FData)^.get_type(FData);
end;

function TCefXmlReaderRef.GetValue: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_value(FData));
end;

function TCefXmlReaderRef.GetXmlLang: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData)^.get_xml_lang(FData));
end;

function TCefXmlReaderRef.HasAttributes: Boolean;
begin
  Result := PCefXmlReader(FData)^.has_attributes(FData) <> 0;
end;

function TCefXmlReaderRef.HasError: Boolean;
begin
  Result := PCefXmlReader(FData)^.has_error(FData) <> 0;
end;

function TCefXmlReaderRef.HasValue: Boolean;
begin
  Result := PCefXmlReader(FData)^.has_value(FData) <> 0;
end;

function TCefXmlReaderRef.IsEmptyElement: Boolean;
begin
  Result := PCefXmlReader(FData)^.is_empty_element(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByIndex(index: Integer): Boolean;
begin
  Result := PCefXmlReader(FData)^.move_to_attribute_byindex(FData, index) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByLName(const localName, namespaceURI: ustring): Boolean;
Var
  l, n: TCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := PCefXmlReader(FData)^.move_to_attribute_bylname(FData, @l, @n) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByQName(const qualifiedName: ustring): Boolean;
Var
  q: TCefString;
begin
  q := CefString(qualifiedName);
  Result := PCefXmlReader(FData)^.move_to_attribute_byqname(FData, @q) <> 0;
end;

function TCefXmlReaderRef.MoveToCarryingElement: Boolean;
begin
  Result := PCefXmlReader(FData)^.move_to_carrying_element(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToFirstAttribute: Boolean;
begin
  Result := PCefXmlReader(FData)^.move_to_first_attribute(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToNextAttribute: Boolean;
begin
  Result := PCefXmlReader(FData)^.move_to_next_attribute(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToNextNode: Boolean;
begin
  Result := PCefXmlReader(FData)^.move_to_next_node(FData) <> 0;
end;

class function TCefXmlReaderRef.UnWrap(data: Pointer): ICefXmlReader;
begin
  If data <> nil then Result := Create(data) //as ICefXmlReader
  Else Result := nil;
end;

{ TCefZipReaderRef }

function TCefZipReaderRef.Close: Boolean;
begin
  Result := PCefZipReader(FData)^.close(FData) <> 0;
end;

function TCefZipReaderRef.CloseFile: Boolean;
begin
  Result := PCefZipReader(FData)^.close_file(FData) <> 0;
end;

class function TCefZipReaderRef.New(const stream: ICefStreamReader): ICefZipReader;
begin
  Result := UnWrap(cef_zip_reader_create(CefGetData(stream)));
end;

function TCefZipReaderRef.Eof: Boolean;
begin
  Result := PCefZipReader(FData)^.eof(FData) <> 0;
end;

function TCefZipReaderRef.GetFileLastModified: LongInt;
begin
  Result := PCefZipReader(FData)^.get_file_last_modified(FData);
end;

function TCefZipReaderRef.GetFileName: ustring;
begin
  Result := CefStringFreeAndGet(PCefZipReader(FData)^.get_file_name(FData));
end;

function TCefZipReaderRef.GetFileSize: Int64;
begin
  Result := PCefZipReader(FData)^.get_file_size(FData);
end;

function TCefZipReaderRef.MoveToFile(const fileName: ustring; caseSensitive: Boolean): Boolean;
Var
  f: TCefString;
begin
  f := CefString(fileName);
  Result := PCefZipReader(FData)^.move_to_file(FData, @f, Ord(caseSensitive)) <> 0;
end;

function TCefZipReaderRef.MoveToFirstFile: Boolean;
begin
  Result := PCefZipReader(FData)^.move_to_first_file(FData) <> 0;
end;

function TCefZipReaderRef.MoveToNextFile: Boolean;
begin
  Result := PCefZipReader(FData)^.move_to_next_file(FData) <> 0;
end;

function TCefZipReaderRef.OpenFile(const password: ustring): Boolean;
var
  p: TCefString;
begin
  p := CefString(password);
  Result := PCefZipReader(FData)^.open_file(FData, @p) <> 0;
end;

function TCefZipReaderRef.ReadFile(buffer: Pointer; bufferSize: Cardinal): Integer;
begin
  Result := PCefZipReader(FData)^.read_file(FData, buffer, buffersize);
end;

function TCefZipReaderRef.Tell: Int64;
begin
  Result := PCefZipReader(FData)^.tell(FData);
end;

class function TCefZipReaderRef.UnWrap(data: Pointer): ICefZipReader;
begin
  If data <> nil then Result := Create(data) //as ICefZipReader
  Else Result := nil;
end;

{ TCefFastTask }

constructor TCefFastTask.Create(const method: TCefFastTaskProc);
begin
  inherited Create;
  FMethod := method;
end;

procedure TCefFastTask.Execute;
begin
  FMethod();
end;

class procedure TCefFastTask.New(threadId: TCefThreadId; const method: TCefFastTaskProc);
begin
  CefPostTask(threadId, Create(method));
end;

class procedure TCefFastTask.NewDelayed(threadId: TCefThreadId;
  Delay: Int64; const method: TCefFastTaskProc);
begin
  CefPostDelayedTask(threadId, Create(method), Delay);
end;

{ TCefv8ContextRef }

class function TCefv8ContextRef.Current: ICefv8Context;
begin
  Result := UnWrap(cef_v8context_get_current_context)
end;

function TCefv8ContextRef.Enter: Boolean;
begin
  Result := PCefv8Context(FData)^.enter(PCefv8Context(FData)) <> 0;
end;

class function TCefv8ContextRef.Entered: ICefv8Context;
begin
  Result := UnWrap(cef_v8context_get_entered_context)
end;

function TCefv8ContextRef.Exit: Boolean;
begin
  Result := PCefv8Context(FData)^.exit(PCefv8Context(FData)) <> 0;
end;

function TCefv8ContextRef.GetBrowser: ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefv8Context(FData)^.get_browser(PCefv8Context(FData)));
end;

function TCefv8ContextRef.GetFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefv8Context(FData)^.get_frame(PCefv8Context(FData)))
end;

function TCefv8ContextRef.GetGlobal: ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefv8Context(FData)^.get_global(PCefv8Context(FData)));
end;

function TCefv8ContextRef.GetTaskRunner: ICefTaskRunner;
begin
  Result := TCefTaskRunnerRef.UnWrap(PCefv8Context(FData)^.get_task_runner(FData));
end;

function TCefv8ContextRef.IsSame(const that: ICefv8Context): Boolean;
begin
  Result := PCefv8Context(FData)^.is_same(PCefv8Context(FData), CefGetData(that)) <> 0;
end;

function TCefv8ContextRef.IsValid: Boolean;
begin
  Result := PCefv8Context(FData)^.is_valid(FData) <> 0;
end;

function TCefv8ContextRef.Eval(const code: ustring; var retval: ICefv8Value; var exception: ICefV8Exception): Boolean;
var
  c: TCefString;
  r: PCefv8Value;
  e: PCefV8Exception;
begin
  c := CefString(code);
  r := nil;
  e := nil;
  Result := PCefv8Context(FData)^.eval(PCefv8Context(FData), @c, r, e) <> 0;
  retval := TCefv8ValueRef.UnWrap(r);
  exception := TCefV8ExceptionRef.UnWrap(e);
end;

class function TCefv8ContextRef.UnWrap(data: Pointer): ICefv8Context;
begin
  //If data <> nil then Result := Create(data) as ICefv8Context
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

{ TCefDomVisitorOwn }

constructor TCefDomVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDomVisitor));
  PCefDomVisitor(FData)^.visit := @cef_dom_visitor_visite;
end;

procedure TCefDomVisitorOwn.visit(const document: ICefDomDocument);
begin

end;

{ TCefFastDomVisitor }

constructor TCefFastDomVisitor.Create(const proc: TCefDomVisitorProc);
begin
  inherited Create;
  FProc := proc;
end;

procedure TCefFastDomVisitor.visit(const document: ICefDomDocument);
begin
  FProc(document);
end;

{ TCefDomDocumentRef }

function TCefDomDocumentRef.GetBaseUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_base_url(PCefDomDocument(FData)))
end;

function TCefDomDocumentRef.GetBody: ICefDomNode;
begin
  Result :=  TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_body(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetCompleteUrl(const partialURL: ustring): ustring;
var
  p: TCefString;
begin
  p := CefString(partialURL);
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_complete_url(PCefDomDocument(FData), @p));
end;

function TCefDomDocumentRef.GetDocument: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_document(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetElementById(const id: ustring): ICefDomNode;
var
  i: TCefString;
begin
  i := CefString(id);
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_element_by_id(PCefDomDocument(FData), @i));
end;

function TCefDomDocumentRef.GetFocusedNode: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_focused_node(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetHead: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_head(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetSelectionAsMarkup: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_selection_as_markup(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetSelectionAsText: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_selection_as_text(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetSelectionEndNode: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_selection_end_node(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetSelectionEndOffset: Integer;
begin
  Result := PCefDomDocument(FData)^.get_selection_end_offset(PCefDomDocument(FData));
end;

function TCefDomDocumentRef.GetSelectionStartNode: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_selection_start_node(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetSelectionStartOffset: Integer;
begin
  Result := PCefDomDocument(FData)^.get_selection_start_offset(PCefDomDocument(FData));
end;

function TCefDomDocumentRef.GetTitle: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_title(PCefDomDocument(FData)));
end;

function TCefDomDocumentRef.GetType: TCefDomDocumentType;
begin
  Result := PCefDomDocument(FData)^.get_type(PCefDomDocument(FData));
end;

function TCefDomDocumentRef.HasSelection: Boolean;
begin
  Result := PCefDomDocument(FData)^.has_selection(PCefDomDocument(FData)) <> 0;
end;

class function TCefDomDocumentRef.UnWrap(data: Pointer): ICefDomDocument;
begin
  If data <> nil then Result := Create(data) //as ICefDomDocument
  Else Result := nil;
end;

{ TCefDomNodeRef }

procedure TCefDomNodeRef.AddEventListener(const eventType: ustring;
  useCapture: Boolean; const listener: ICefDomEventListener);
Var
  et: TCefString;
begin
  et := CefString(eventType);
  PCefDomNode(FData)^.add_event_listener(PCefDomNode(FData), @et, CefGetData(listener), Ord(useCapture));
end;

procedure TCefDomNodeRef.AddEventListenerProc(const eventType: ustring; useCapture: Boolean;
  const proc: TCefDomEventListenerProc);
begin
  //AddEventListener(eventType, useCapture, TCefFastDomEventListener.Create(proc) as ICefDomEventListener);
  AddEventListener(eventType, useCapture, TCefFastDomEventListener.Create(proc));
end;

function TCefDomNodeRef.GetAsMarkup: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_as_markup(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetDocument: ICefDomDocument;
begin
  Result := TCefDomDocumentRef.UnWrap(PCefDomNode(FData)^.get_document(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetElementAttribute(const attrName: ustring): ustring;
var
  p: TCefString;
begin
  p := CefString(attrName);
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_element_attribute(PCefDomNode(FData), @p));
end;

procedure TCefDomNodeRef.GetElementAttributes(const attrMap: ICefStringMap);
begin
  PCefDomNode(FData)^.get_element_attributes(PCefDomNode(FData), attrMap.Handle);
end;

function TCefDomNodeRef.GetElementInnerText: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_element_inner_text(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetElementTagName: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_element_tag_name(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetFirstChild: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_first_child(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetFormControlElementType: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_form_control_element_type(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetLastChild: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_last_child(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetName: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_name(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetNextSibling: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_next_sibling(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetParent: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_parent(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetPreviousSibling: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_previous_sibling(PCefDomNode(FData)));
end;

function TCefDomNodeRef.GetType: TCefDomNodeType;
begin
  Result := PCefDomNode(FData)^.get_type(PCefDomNode(FData));
end;

function TCefDomNodeRef.GetValue: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_value(PCefDomNode(FData)));
end;

function TCefDomNodeRef.HasChildren: Boolean;
begin
  Result := PCefDomNode(FData)^.has_children(PCefDomNode(FData)) <> 0;
end;

function TCefDomNodeRef.HasElementAttribute(const attrName: ustring): Boolean;
var
  p: TCefString;
begin
  p := CefString(attrName);
  Result := PCefDomNode(FData)^.has_element_attribute(PCefDomNode(FData), @p) <> 0;
end;

function TCefDomNodeRef.HasElementAttributes: Boolean;
begin
  Result := PCefDomNode(FData)^.has_element_attributes(PCefDomNode(FData)) <> 0;
end;

function TCefDomNodeRef.IsEditable: Boolean;
begin
  Result := PCefDomNode(FData)^.is_editable(PCefDomNode(FData)) <> 0;
end;

function TCefDomNodeRef.IsElement: Boolean;
begin
  Result := PCefDomNode(FData)^.is_element(PCefDomNode(FData)) <> 0;
end;

function TCefDomNodeRef.IsFormControlElement: Boolean;
begin
  Result := PCefDomNode(FData)^.is_form_control_element(PCefDomNode(FData)) <> 0;
end;

function TCefDomNodeRef.IsSame(const that: ICefDomNode): Boolean;
begin
  Result := PCefDomNode(FData)^.is_same(PCefDomNode(FData), CefGetData(that)) <> 0;
end;

function TCefDomNodeRef.IsText: Boolean;
begin
  Result := PCefDomNode(FData)^.is_text(PCefDomNode(FData)) <> 0;
end;

function TCefDomNodeRef.SetElementAttribute(const attrName,
  value: ustring): Boolean;
var
  p1, p2: TCefString;
begin
  p1 := CefString(attrName);
  p2 := CefString(value);
  Result := PCefDomNode(FData)^.set_element_attribute(PCefDomNode(FData), @p1, @p2) <> 0;
end;

function TCefDomNodeRef.SetValue(const value: ustring): Boolean;
var
  p: TCefString;
begin
  p := CefString(value);
  Result := PCefDomNode(FData)^.set_value(PCefDomNode(FData), @p) <> 0;
end;

class function TCefDomNodeRef.UnWrap(data: Pointer): ICefDomNode;
begin
  If data <> nil then Result := Create(data) //as ICefDomNode
  Else Result := nil;
end;

{ TCefDomEventListenerOwn }

constructor TCefDomEventListenerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDomEventListener));
  PCefDomEventListener(FData)^.handle_event := @cef_dom_event_listener_handle_event;
end;

procedure TCefDomEventListenerOwn.HandleEvent(const event: ICefDomEvent);
begin

end;

{ TCefDomEventRef }

function TCefDomEventRef.CanBubble: Boolean;
begin
  Result := PCefDomEvent(FData)^.can_bubble(PCefDomEvent(FData)) <> 0;
end;

function TCefDomEventRef.CanCancel: Boolean;
begin
  Result := PCefDomEvent(FData)^.can_cancel(PCefDomEvent(FData)) <> 0;
end;

function TCefDomEventRef.GetCategory: TCefDomEventCategory;
begin
  Result := PCefDomEvent(FData)^.get_category(PCefDomEvent(FData));
end;

function TCefDomEventRef.GetCurrentTarget: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomEvent(FData)^.get_current_target(PCefDomEvent(FData)));
end;

function TCefDomEventRef.GetDocument: ICefDomDocument;
begin
  Result := TCefDomDocumentRef.UnWrap(PCefDomEvent(FData)^.get_document(PCefDomEvent(FData)));
end;

function TCefDomEventRef.GetPhase: TCefDomEventPhase;
begin
  Result := PCefDomEvent(FData)^.get_phase(PCefDomEvent(FData));
end;

function TCefDomEventRef.GetTarget: ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomEvent(FData)^.get_target(PCefDomEvent(FData)));
end;

function TCefDomEventRef.GetType: ustring;
begin
  Result := CefStringFreeAndGet(PCefDomEvent(FData)^.get_type(PCefDomEvent(FData)));
end;

class function TCefDomEventRef.UnWrap(data: Pointer): ICefDomEvent;
begin
  If data <> nil then Result := Create(data) //as ICefDomEvent
  Else Result := nil;
end;

{ TCefFastDomEventListener }

constructor TCefFastDomEventListener.Create(
  const proc: TCefDomEventListenerProc);
begin
  inherited Create;
  FProc := proc;
end;

procedure TCefFastDomEventListener.HandleEvent(const event: ICefDomEvent);
begin
  inherited;
  FProc(event);
end;

{ TCefResponseRef }

class function TCefResponseRef.New: ICefResponse;
begin
  Result := UnWrap(cef_response_create);
end;

function TCefResponseRef.GetHeader(const name: ustring): ustring;
var
  n: TCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(PCefResponse(FData)^.get_header(PCefResponse(FData), @n));
end;

procedure TCefResponseRef.GetHeaderMap(const headerMap: ICefStringMultimap);
begin
  PCefResponse(FData)^.get_header_map(PCefResponse(FData), headermap.Handle);
end;

function TCefResponseRef.GetMimeType: ustring;
begin
  Result := CefStringFreeAndGet(PCefResponse(FData)^.get_mime_type(PCefResponse(FData)));
end;

function TCefResponseRef.GetStatus: Integer;
begin
  Result := PCefResponse(FData)^.get_status(PCefResponse(FData));
end;

function TCefResponseRef.GetStatusText: ustring;
begin
  Result := CefStringFreeAndGet(PCefResponse(FData)^.get_status_text(PCefResponse(FData)));
end;

function TCefResponseRef.IsReadOnly: Boolean;
begin
  Result := PCefResponse(FData)^.is_read_only(PCefResponse(FData)) <> 0;
end;

procedure TCefResponseRef.SetHeaderMap(const headerMap: ICefStringMultimap);
begin
  PCefResponse(FData)^.set_header_map(PCefResponse(FData), headerMap.Handle);
end;

procedure TCefResponseRef.SetMimeType(const mimetype: ustring);
var
  txt: TCefString;
begin
  txt := CefString(mimetype);
  PCefResponse(FData)^.set_mime_type(PCefResponse(FData), @txt);
end;

procedure TCefResponseRef.SetStatus(status: Integer);
begin
  PCefResponse(FData)^.set_status(PCefResponse(FData), status);
end;

procedure TCefResponseRef.SetStatusText(const StatusText: ustring);
var
  txt: TCefString;
begin
  txt := CefString(StatusText);
  PCefResponse(FData)^.set_status_text(PCefResponse(FData), @txt);
end;

class function TCefResponseRef.UnWrap(data: Pointer): ICefResponse;
begin
  If data <> nil then Result := Create(data) //as ICefResponse
  Else Result := nil;
end;

{ TCefV8AccessorOwn }

constructor TCefV8AccessorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefV8Accessor));
  PCefV8Accessor(FData)^.get  := @cef_v8_accessor_get;
  PCefV8Accessor(FData)^.put := @cef_v8_accessor_put;
end;

function TCefV8AccessorOwn.Get(const name: ustring; const obj: ICefv8Value;
  out value: ICefv8Value; const exception: string): Boolean;
begin
  Result := False;
end;

function TCefV8AccessorOwn.Put(const name: ustring; const obj,
  value: ICefv8Value; const exception: string): Boolean;
begin
  Result := False;
end;

{ TCefFastV8Accessor }

constructor TCefFastV8Accessor.Create(
  const getter: TCefV8AccessorGetterProc;
  const setter: TCefV8AccessorSetterProc);
begin
  FGetter := getter;
  FSetter := setter;
end;

function TCefFastV8Accessor.Get(const name: ustring; const obj: ICefv8Value;
  out value: ICefv8Value; const exception: string): Boolean;
begin
  if Assigned(FGetter)  then
    Result := FGetter(name, obj, value, exception) else
    Result := False;
end;

function TCefFastV8Accessor.Put(const name: ustring; const obj,
  value: ICefv8Value; const exception: string): Boolean;
begin
  if Assigned(FSetter)  then
    Result := FSetter(name, obj, value, exception) else
    Result := False;
end;

{ TCefCookieVisitorOwn }

constructor TCefCookieVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefCookieVisitor));
  PCefCookieVisitor(FData)^.visit := @cef_cookie_visitor_visit;
end;

function TCefCookieVisitorOwn.visit(const name, value, domain, path: ustring;
  secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
  count, total: Integer; out deleteCookie: Boolean): Boolean;
begin
  Result := True;
end;

{ TCefFastCookieVisitor }

constructor TCefFastCookieVisitor.Create(const visitor: TCefCookieVisitorProc);
begin
  inherited Create;
  FVisitor := visitor;
end;

function TCefFastCookieVisitor.visit(const name, value, domain, path: ustring;
  secure, httponly, hasExpires: Boolean; const creation, lastAccess,
  expires: TDateTime; count, total: Integer; out deleteCookie: Boolean): Boolean;
begin
  Result := FVisitor(name, value, domain, path, secure, httponly, hasExpires,
    creation, lastAccess, expires, count, total, deleteCookie);
end;

{ TCefClientOwn }

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
    get_render_handler := @cef_client_get_get_render_handler;
    get_request_handler := @cef_client_get_request_handler;
    on_process_message_received := @cef_client_on_process_message_received;
  end;
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

function TCefClientOwn.GetFocusHandler: ICefFocusHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetGeolocationHandler: ICefGeolocationHandler;
begin
  Result := nil;
end;

function TCefClientOwn.GetJsdialogHandler: ICefJsDialogHandler;
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

{ TCefGeolocationHandlerOwn }

constructor TCefGeolocationHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefGeolocationHandler));
  With PCefGeolocationHandler(FData)^ do
  begin
    on_request_geolocation_permission := @cef_geolocation_handler_on_request_geolocation_permission;
    on_cancel_geolocation_permission :=  @cef_geolocation_handler_on_cancel_geolocation_permission;
  end;
end;

procedure TCefGeolocationHandlerOwn.OnRequestGeolocationPermission(
  const browser: ICefBrowser; const requestingUrl: ustring; requestId: Integer;
  const callback: ICefGeolocationCallback);
begin

end;

procedure TCefGeolocationHandlerOwn.OnCancelGeolocationPermission(
  const browser: ICefBrowser; const requestingUrl: ustring; requestId: Integer);
begin

end;

{ TCefLifeSpanHandlerOwn }

constructor TCefLifeSpanHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefLifeSpanHandler));
  with PCefLifeSpanHandler(FData)^ do
  begin
    on_before_popup := @cef_life_span_handler_on_before_popup;
    on_after_created := @cef_life_span_handler_on_after_created;
    on_before_close := @cef_life_span_handler_on_before_close;
    run_modal := @cef_life_span_handler_run_modal;
    do_close := @cef_life_span_handler_do_close;
  end;
end;

procedure TCefLifeSpanHandlerOwn.OnAfterCreated(const browser: ICefBrowser);
begin

end;

procedure TCefLifeSpanHandlerOwn.OnBeforeClose(const browser: ICefBrowser);
begin

end;

function TCefLifeSpanHandlerOwn.OnBeforePopup(const browser: ICefBrowser;
  const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  Result := False;
end;

function TCefLifeSpanHandlerOwn.DoClose(const browser: ICefBrowser): Boolean;
begin
  Result := False;
end;

function TCefLifeSpanHandlerOwn.RunModal(const browser: ICefBrowser): Boolean;
begin
  Result := False;
end;


{ TCefLoadHandlerOwn }

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

procedure TCefLoadHandlerOwn.OnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin

end;

procedure TCefLoadHandlerOwn.OnRenderProcessTerminated(const browser: ICefBrowser;
  status: TCefTerminationStatus);
begin

end;

procedure TCefLoadHandlerOwn.OnPluginCrashed(const browser: ICefBrowser;
  const pluginPath: ustring);
begin

end;

procedure TCefLoadHandlerOwn.OnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: Integer; const errorText, failedUrl: ustring);
begin

end;

procedure TCefLoadHandlerOwn.OnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame);
begin

end;

{ TCefRequestHandlerOwn }

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
  end;
end;

function TCefRequestHandlerOwn.GetAuthCredentials(const browser: ICefBrowser; const frame: ICefFrame;
  isProxy: Boolean; const host: ustring; port: Integer; const realm, scheme: ustring;
  const callback: ICefAuthCallback): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.GetCookieManager(const browser: ICefBrowser;
  const mainUrl: ustring): ICefCookieManager;
begin
  Result := nil;
end;

function TCefRequestHandlerOwn.OnBeforePluginLoad(const browser: ICefBrowser;
  const url, policyUrl: ustring; const info: ICefWebPluginInfo): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.OnBeforeResourceLoad(const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest): Boolean;
begin
  Result := False;
end;

function TCefRequestHandlerOwn.GetResourceHandler(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest): ICefResourceHandler;
begin
  Result := nil;
end;

procedure TCefRequestHandlerOwn.OnProtocolExecution(const browser: ICefBrowser;
  const url: ustring; out allowOsExecution: Boolean);
begin

end;

function TCefRequestHandlerOwn.OnQuotaRequest(const browser: ICefBrowser;
  const originUrl: ustring; newSize: Int64;
  const callback: ICefQuotaCallback): Boolean;
begin
  Result := False;
end;

procedure TCefRequestHandlerOwn.OnResourceRedirect(const browser: ICefBrowser;
  const frame: ICefFrame; const oldUrl: ustring; var newUrl: ustring);
begin

end;

{ TCefDisplayHandlerOwn }

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

procedure TCefDisplayHandlerOwn.OnLoadingStateChange(const browser: ICefBrowser;
  isLoading, canGoBack, canGoForward: Boolean);
begin

end;

procedure TCefDisplayHandlerOwn.OnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring);
begin

end;

function TCefDisplayHandlerOwn.OnConsoleMessage(const browser: ICefBrowser;
  const message, source: ustring; line: Integer): Boolean;
begin
  Result := False;
end;

procedure TCefDisplayHandlerOwn.OnStatusMessage(const browser: ICefBrowser;
  const value: ustring);
begin

end;

procedure TCefDisplayHandlerOwn.OnTitleChange(const browser: ICefBrowser;
  const title: ustring);
begin

end;

function TCefDisplayHandlerOwn.OnTooltip(const browser: ICefBrowser;
  var text: ustring): Boolean;
begin
  Result := False;
end;

{ TCefFocusHandlerOwn }

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

function TCefFocusHandlerOwn.OnSetFocus(const browser: ICefBrowser;
  source: TCefFocusSource): Boolean;
begin
  Result := False;
end;

procedure TCefFocusHandlerOwn.OnGotFocus(const browser: ICefBrowser);
begin

end;

procedure TCefFocusHandlerOwn.OnTakeFocus(const browser: ICefBrowser;
  next: Boolean);
begin

end;

{ TCefKeyboardHandlerOwn }

constructor TCefKeyboardHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefKeyboardHandler));
  With PCefKeyboardHandler(FData)^ do
  begin
    on_pre_key_event := @cef_keyboard_handler_on_pre_key_event;
    on_key_event := @cef_keyboard_handler_on_key_event;
  end;
end;

function TCefKeyboardHandlerOwn.OnPreKeyEvent(const browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle;
  out isKeyboardShortcut: Boolean): Boolean;
begin
  Result := False;
end;

function TCefKeyboardHandlerOwn.OnKeyEvent(const browser: ICefBrowser;
  const event: PCefKeyEvent; osEvent: TCefEventHandle): Boolean;
begin
  Result := False;
end;

{ TCefJsDialogHandlerOwn }

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

function TCefJsDialogHandlerOwn.OnJsdialog(const browser: ICefBrowser;
  const originUrl, acceptLang: ustring; dialogType: TCefJsDialogType;
  const messageText, defaultPromptText: ustring; callback: ICefJsDialogCallback;
  out suppressMessage: Boolean): Boolean;
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

end;

{ TCefContextMenuHandlerOwn }

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

procedure TCefContextMenuHandlerOwn.OnBeforeContextMenu(
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin

end;

function TCefContextMenuHandlerOwn.OnContextMenuCommand(
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags): Boolean;
begin
  Result := False;
end;

procedure TCefContextMenuHandlerOwn.OnContextMenuDismissed(
  const browser: ICefBrowser; const frame: ICefFrame);
begin

end;

{ TCefV8ExceptionRef }

function TCefV8ExceptionRef.GetEndColumn: Integer;
begin
  Result := PCefV8Exception(FData)^.get_end_column(FData);
end;

function TCefV8ExceptionRef.GetEndPosition: Integer;
begin
  Result := PCefV8Exception(FData)^.get_end_position(FData);
end;

function TCefV8ExceptionRef.GetLineNumber: Integer;
begin
  Result := PCefV8Exception(FData)^.get_line_number(FData);
end;

function TCefV8ExceptionRef.GetMessage: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(FData)^.get_message(FData));
end;

function TCefV8ExceptionRef.GetScriptResourceName: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(FData)^.get_script_resource_name(FData));
end;

function TCefV8ExceptionRef.GetSourceLine: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(FData)^.get_source_line(FData));
end;

function TCefV8ExceptionRef.GetStartColumn: Integer;
begin
  Result := PCefV8Exception(FData)^.get_start_column(FData);
end;

function TCefV8ExceptionRef.GetStartPosition: Integer;
begin
  Result := PCefV8Exception(FData)^.get_start_position(FData);
end;

class function TCefV8ExceptionRef.UnWrap(data: Pointer): ICefV8Exception;
begin
  If data <> nil then Result := Create(data) //as ICefV8Exception
  Else Result := nil;
end;

{ TCefResourceBundleHandlerOwn }

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

constructor TCefFastResourceBundle.Create(AGetDataResource: TGetDataResource;
  AGetLocalizedString: TGetLocalizedString);
begin
  inherited Create;
  FGetDataResource := AGetDataResource;
  FGetLocalizedString := AGetLocalizedString;
end;

function TCefFastResourceBundle.GetDataResource(resourceId: Integer;
  out data: Pointer; out dataSize: Cardinal): Boolean;
begin
  if Assigned(FGetDataResource) then
    Result := FGetDataResource(resourceId, data, dataSize) else
    Result := False;
end;

function TCefFastResourceBundle.GetLocalizedString(messageId: Integer;
  out stringVal: ustring): Boolean;
begin
  If Assigned(FGetLocalizedString) then Result := FGetLocalizedString(messageId, stringVal)
  Else Result := False;
end;

{ TCefAppOwn }

constructor TCefAppOwn.Create;
begin
  inherited CreateData(SizeOf(TCefApp));
  with PCefApp(FData)^ do
  begin
    on_before_command_line_processing := @cef_app_on_before_command_line_processing;
    on_register_custom_schemes := @cef_app_on_register_custom_schemes;
    get_resource_bundle_handler := @cef_app_get_resource_bundle_handler;
    get_browser_process_handler := @cef_app_get_browser_process_handler;
    get_render_process_handler := @cef_app_get_render_process_handler;
  end;
end;

{ TCefCookieManagerRef }

class function TCefCookieManagerRef.New(const path: ustring): ICefCookieManager;
var
  pth: TCefString;
begin
  pth := CefString(path);
  Result := UnWrap(cef_cookie_manager_create_manager(@pth));
end;

function TCefCookieManagerRef.DeleteCookies(const url,
  cookieName: ustring): Boolean;
var
  u, n: TCefString;
begin
  u := CefString(url);
  n := CefString(cookieName);
  Result := PCefCookieManager(FData)^.delete_cookies(
    PCefCookieManager(FData), @u, @n) <> 0;
end;

class function TCefCookieManagerRef.Global: ICefCookieManager;
begin
  Result := UnWrap(cef_cookie_manager_get_global_manager());
end;

function TCefCookieManagerRef.SetCookie(const url, name, value, domain,
  path: ustring; secure, httponly, hasExpires: Boolean; const creation,
  lastAccess, expires: TDateTime): Boolean;
var
  str: TCefString;
  cook: TCefCookie;
begin
  str := CefString(url);
  cook.name := CefString(name);
  cook.value := CefString(value);
  cook.domain := CefString(domain);
  cook.path := CefString(path);
  cook.secure := secure;
  cook.httponly := httponly;
  cook.creation := DateTimeToCefTime(creation);
  cook.last_access := DateTimeToCefTime(lastAccess);
  cook.has_expires := hasExpires;
  If hasExpires then cook.expires := DateTimeToCefTime(expires)
  Else FillChar(cook.expires, SizeOf(TCefTime), 0);
  Result := PCefCookieManager(FData)^.set_cookie(
    PCefCookieManager(FData), @str, @cook) <> 0;
end;

function TCefCookieManagerRef.SetStoragePath(const path: ustring): Boolean;
var
  p: TCefString;
begin
  p := CefString(path);
  Result := PCefCookieManager(FData)^.set_storage_path(
    PCefCookieManager(FData), @p) <> 0;
end;

procedure TCefCookieManagerRef.SetSupportedSchemes(schemes: TStrings);
var
  list: TCefStringList;
  i: Integer;
  item: TCefString;
begin
  list := cef_string_list_alloc();
  try
    if (schemes <> nil) then
      For i := 0 to schemes.Count - 1 do
      begin
        item := CefString(schemes[i]);
        cef_string_list_append(list, @item);
      end;
    PCefCookieManager(FData)^.set_supported_schemes(PCefCookieManager(FData), list);
  finally
    cef_string_list_free(list);
  end;
end;

class function TCefCookieManagerRef.UnWrap(data: Pointer): ICefCookieManager;
begin
  If data <> nil then Result := Create(data) //as ICefCookieManager
  Else Result := nil;
end;

function TCefCookieManagerRef.VisitAllCookies(
  const visitor: ICefCookieVisitor): Boolean;
begin
  Result := PCefCookieManager(FData)^.visit_all_cookies(PCefCookieManager(FData), CefGetData(visitor)) <> 0;
end;

function TCefCookieManagerRef.VisitAllCookiesProc(
  const visitor: TCefCookieVisitorProc): Boolean;
begin
  //Result := VisitAllCookies(TCefFastCookieVisitor.Create(visitor) as ICefCookieVisitor);
  Result := VisitAllCookies(TCefFastCookieVisitor.Create(visitor));
end;

function TCefCookieManagerRef.VisitUrlCookies(const url: ustring;
  includeHttpOnly: Boolean; const visitor: ICefCookieVisitor): Boolean;
var
  str: TCefString;
begin
  str := CefString(url);
  Result := PCefCookieManager(FData)^.visit_url_cookies(PCefCookieManager(FData), @str, Ord(includeHttpOnly), CefGetData(visitor)) <> 0;
end;

function TCefCookieManagerRef.VisitUrlCookiesProc(const url: ustring;
  includeHttpOnly: Boolean; const visitor: TCefCookieVisitorProc): Boolean;
begin
  //Result := VisitUrlCookies(url, includeHttpOnly,TCefFastCookieVisitor.Create(visitor) as ICefCookieVisitor);
  Result := VisitUrlCookies(url, includeHttpOnly,TCefFastCookieVisitor.Create(visitor));
end;

{ TCefWebPluginInfoRef }

function TCefWebPluginInfoRef.GetDescription: ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_description(PCefWebPluginInfo(FData)));
end;

function TCefWebPluginInfoRef.GetName: ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_name(PCefWebPluginInfo(FData)));
end;

function TCefWebPluginInfoRef.GetPath: ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_path(PCefWebPluginInfo(FData)));
end;

function TCefWebPluginInfoRef.GetVersion: ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_version(PCefWebPluginInfo(FData)));
end;

class function TCefWebPluginInfoRef.UnWrap(data: Pointer): ICefWebPluginInfo;
begin
  If data <> nil then Result := Create(data) //as ICefWebPluginInfo
  Else Result := nil;
end;

{ TCefBrowserHostRef }

function TCefBrowserHostRef.GetBrowser: ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefBrowserHost(FData)^.get_browser(PCefBrowserHost(FData)));
end;

procedure TCefBrowserHostRef.ParentWindowWillClose;
begin
  PCefBrowserHost(FData)^.parent_window_will_close(PCefBrowserHost(FData));
end;

procedure TCefBrowserHostRef.RunFileDialog(mode: TCefFileDialogMode;
  const title, defaultFileName: string; acceptTypes: TStrings;
  const callback: ICefRunFileDialogCallback);
var
  t, f: TCefString;
  list: TCefStringList;
  item: TCefString;
  i: Integer;
begin
  t := CefString(title);
  f := CefString(defaultFileName);
  list := cef_string_list_alloc();
  try
    for i := 0 to acceptTypes.Count - 1 do
    begin
      item := CefString(acceptTypes[i]);
      cef_string_list_append(list, @item);
    end;
    PCefBrowserHost(FData)^.run_file_dialog(PCefBrowserHost(FData), mode, @t, @f,
      list, CefGetData(callback));
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefBrowserHostRef.RunFileDialogProc(mode: TCefFileDialogMode;
  const title, defaultFileName: string; acceptTypes: TStrings;
  const callback: TCefRunFileDialogCallbackProc);
begin
  RunFileDialog(mode, title, defaultFileName, acceptTypes, TCefFastRunFileDialogCallback.Create(callback));
end;

procedure TCefBrowserHostRef.CloseBrowser;
begin
  PCefBrowserHost(FData)^.close_browser(PCefBrowserHost(FData));
end;

procedure TCefBrowserHostRef.SendCaptureLostEvent;
begin
  PCefBrowserHost(FData)^.send_capture_lost_event(FData);
end;

procedure TCefBrowserHostRef.SendFocusEvent(Focus: Boolean);
begin
  PCefBrowserHost(FData)^.send_focus_event(FData, Ord(Focus));
end;

procedure TCefBrowserHostRef.SendKeyEvent(const event: PCefKeyEvent);
begin
  PCefBrowserHost(FData)^.send_key_event(FData, event);
end;

procedure TCefBrowserHostRef.SendMouseClickEvent(const event: PCefMouseEvent;
  kind: TCefMouseButtonType; mouseUp: Boolean; clickCount: Integer);
begin
  PCefBrowserHost(FData)^.send_mouse_click_event(FData, event, kind, Ord(mouseUp), clickCount);
end;

procedure TCefBrowserHostRef.SendMouseMoveEvent(const event: PCefMouseEvent; mouseLeave: Boolean);
begin
  PCefBrowserHost(FData)^.send_mouse_move_event(FData, event, Ord(mouseLeave));
end;

procedure TCefBrowserHostRef.SendMouseWheelEvent(const event: PCefMouseEvent; deltaX, deltaY: Integer);
begin
  PCefBrowserHost(FData)^.send_mouse_wheel_event(FData, event, deltaX, deltaY);
end;

procedure TCefBrowserHostRef.SetFocus(enable: Boolean);
begin
  PCefBrowserHost(FData)^.set_focus(PCefBrowserHost(FData), Ord(enable));
end;

function TCefBrowserHostRef.GetWindowHandle: TCefWindowHandle;
begin
  Result := PCefBrowserHost(FData)^.get_window_handle(PCefBrowserHost(FData))
end;

function TCefBrowserHostRef.GetOpenerWindowHandle: TCefWindowHandle;
begin
  Result := PCefBrowserHost(FData)^.get_opener_window_handle(PCefBrowserHost(FData));
end;

function TCefBrowserHostRef.GetDevToolsUrl(httpScheme: Boolean): ustring;
begin
  Result := CefStringFreeAndGet(PCefBrowserHost(FData)^.get_dev_tools_url(PCefBrowserHost(FData), Ord(httpScheme)));
end;

function TCefBrowserHostRef.GetZoomLevel: Double;
begin
  Result := PCefBrowserHost(FData)^.get_zoom_level(PCefBrowserHost(FData));
end;

procedure TCefBrowserHostRef.Invalidate(const dirtyRect: PCefRect; kind: TCefPaintElementType);
begin
  PCefBrowserHost(FData)^.invalidate(FData, dirtyRect, kind);
end;

function TCefBrowserHostRef.IsWindowRenderingDisabled: Boolean;
begin
  Result := PCefBrowserHost(FData)^.is_window_rendering_disabled(FData) <> 0
end;

procedure TCefBrowserHostRef.SetZoomLevel(zoomLevel: Double);
begin
  PCefBrowserHost(FData)^.set_zoom_level(PCefBrowserHost(FData), zoomLevel);
end;

class function TCefBrowserHostRef.UnWrap(data: Pointer): ICefBrowserHost;
begin
  //If data <> nil then Result := Create(data) as ICefBrowserHost
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

procedure TCefBrowserHostRef.WasResized;
begin
  PCefBrowserHost(FData)^.was_resized(FData);
end;

{ TCefProcessMessageRef }

function TCefProcessMessageRef.Copy: ICefProcessMessage;
begin
  Result := UnWrap(PCefProcessMessage(FData)^.copy(PCefProcessMessage(FData)));
end;

function TCefProcessMessageRef.GetArgumentList: ICefListValue;
begin
  Result := TCefListValueRef.UnWrap(PCefProcessMessage(FData)^.get_argument_list(PCefProcessMessage(FData)));
end;

function TCefProcessMessageRef.GetName: ustring;
begin
  Result := CefStringFreeAndGet(PCefProcessMessage(FData)^.get_name(PCefProcessMessage(FData)));
end;

function TCefProcessMessageRef.IsReadOnly: Boolean;
begin
  Result := PCefProcessMessage(FData)^.is_read_only(PCefProcessMessage(FData)) <> 0;
end;

function TCefProcessMessageRef.IsValid: Boolean;
begin
  Result := PCefProcessMessage(FData)^.is_valid(PCefProcessMessage(FData)) <> 0;
end;

class function TCefProcessMessageRef.New(const name: ustring): ICefProcessMessage;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := UnWrap(cef_process_message_create(@n));
end;

class function TCefProcessMessageRef.UnWrap(data: Pointer): ICefProcessMessage;
begin
  If data <> nil then Result := Create(data) //as ICefProcessMessage
  Else Result := nil;
end;

{ TCefStringVisitorOwn }

constructor TCefStringVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefStringVisitor));
  PCefStringVisitor(FData)^.visit := @cef_string_visitor_visit;
end;

procedure TCefStringVisitorOwn.Visit(const str: ustring);
begin

end;

{ TCefFastStringVisitor }

constructor TCefFastStringVisitor.Create(
  const callback: TCefStringVisitorProc);
begin
  inherited Create;
  FVisit := callback;
end;

procedure TCefFastStringVisitor.Visit(const str: ustring);
begin
  FVisit(str);
end;

{ TCefDownLoadItemRef }

function TCefDownLoadItemRef.GetContentDisposition: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_content_disposition(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.GetCurrentSpeed: Int64;
begin
  Result := PCefDownloadItem(FData)^.get_current_speed(PCefDownloadItem(FData));
end;

function TCefDownLoadItemRef.GetEndTime: TDateTime;
begin
  Result := CefTimeToDateTime(PCefDownloadItem(FData)^.get_end_time(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.GetFullPath: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_full_path(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.GetId: Integer;
begin
  Result := PCefDownloadItem(FData)^.get_id(PCefDownloadItem(FData));
end;

function TCefDownLoadItemRef.GetMimeType: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_mime_type(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.GetPercentComplete: Integer;
begin
  Result := PCefDownloadItem(FData)^.get_percent_complete(PCefDownloadItem(FData));
end;

function TCefDownLoadItemRef.GetReceivedBytes: Int64;
begin
  Result := PCefDownloadItem(FData)^.get_received_bytes(PCefDownloadItem(FData));
end;

function TCefDownLoadItemRef.GetStartTime: TDateTime;
begin
  Result := CefTimeToDateTime(PCefDownloadItem(FData)^.get_start_time(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.GetSuggestedFileName: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_suggested_file_name(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.GetTotalBytes: Int64;
begin
  Result := PCefDownloadItem(FData)^.get_total_bytes(PCefDownloadItem(FData));
end;

function TCefDownLoadItemRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_url(PCefDownloadItem(FData)));
end;

function TCefDownLoadItemRef.IsCanceled: Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_canceled(PCefDownloadItem(FData)) <> 0;
end;

function TCefDownLoadItemRef.IsComplete: Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_complete(PCefDownloadItem(FData)) <> 0;
end;

function TCefDownLoadItemRef.IsInProgress: Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_in_progress(PCefDownloadItem(FData)) <> 0;
end;

function TCefDownLoadItemRef.IsValid: Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_valid(PCefDownloadItem(FData)) <> 0;
end;

class function TCefDownLoadItemRef.UnWrap(data: Pointer): ICefDownLoadItem;
begin
  If data <> nil then Result := Create(data) //as ICefDownLoadItem
  Else Result := nil;
end;

{ TCefBeforeDownloadCallbackRef }

procedure TCefBeforeDownloadCallbackRef.Cont(const downloadPath: ustring;
  showDialog: Boolean);
var
  dp: TCefString;
begin
  dp := CefString(downloadPath);
  PCefBeforeDownloadCallback(FData)^.cont(PCefBeforeDownloadCallback(FData), @dp, Ord(showDialog));
end;

class function TCefBeforeDownloadCallbackRef.UnWrap(data: Pointer): ICefBeforeDownloadCallback;
begin
  If data <> nil then Result := Create(data) //as ICefBeforeDownloadCallback
  Else Result := nil;
end;

{ TCefDownloadItemCallbackRef }

procedure TCefDownloadItemCallbackRef.cancel;
begin
  PCefDownloadItemCallback(FData)^.cancel(PCefDownloadItemCallback(FData));
end;

class function TCefDownloadItemCallbackRef.UnWrap(data: Pointer): ICefDownloadItemCallback;
begin
  If data <> nil then Result := Create(data) //as ICefDownloadItemCallback
  Else Result := nil;
end;

{ TCefAuthCallbackRef }

procedure TCefAuthCallbackRef.Cancel;
begin
  PCefAuthCallback(FData)^.cancel(PCefAuthCallback(FData));
end;

procedure TCefAuthCallbackRef.Cont(const username, password: ustring);
var
  u, p: TCefString;
begin
  u := CefString(username);
  p := CefString(password);
  PCefAuthCallback(FData)^.cont(PCefAuthCallback(FData), @u, @p);
end;

class function TCefAuthCallbackRef.UnWrap(data: Pointer): ICefAuthCallback;
begin
  If data <> nil then Result := Create(data) //as ICefAuthCallback
  Else Result := nil;
end;

{ TCefJsDialogCallbackRef }

procedure TCefJsDialogCallbackRef.Cont(success: Boolean;
  const userInput: ustring);
var
  ui: TCefString;
begin
  ui := CefString(userInput);
  PCefJsDialogCallback(FData)^.cont(PCefJsDialogCallback(FData), Ord(success), @ui);
end;

class function TCefJsDialogCallbackRef.UnWrap(data: Pointer): ICefJsDialogCallback;
begin
  If data <> nil then Result := Create(data) //as ICefJsDialogCallback
  Else Result := nil;
end;

{ TCefCommandLineRef }

procedure TCefCommandLineRef.AppendArgument(const argument: ustring);
var
  a: TCefString;
begin
  a := CefString(argument);
  PCefCommandLine(FData)^.append_argument(PCefCommandLine(FData), @a);
end;

procedure TCefCommandLineRef.AppendSwitch(const name: ustring);
var
  n: TCefString;
begin
  n := CefString(name);
  PCefCommandLine(FData)^.append_switch(PCefCommandLine(FData), @n);
end;

procedure TCefCommandLineRef.AppendSwitchWithValue(const name, value: ustring);
var
  n, v: TCefString;
begin
  n := CefString(name);
  v := CefString(value);
  PCefCommandLine(FData)^.append_switch_with_value(PCefCommandLine(FData), @n, @v);
end;

function TCefCommandLineRef.Copy: ICefCommandLine;
begin
  Result := UnWrap(PCefCommandLine(FData)^.copy(PCefCommandLine(FData)));
end;

procedure TCefCommandLineRef.GetArguments(arguments: TStrings);
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    PCefCommandLine(FData)^.get_arguments(PCefCommandLine(FData), list);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(list, i, @str);
      arguments.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefCommandLineRef.GetArgv(args: TStrings);
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    PCefCommandLine(FData)^.get_argv(FData, list);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(list, i, @str);
      args.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefCommandLineRef.GetCommandLineString: ustring;
begin
  Result := CefStringFreeAndGet(PCefCommandLine(FData)^.get_command_line_string(PCefCommandLine(FData)));
end;

function TCefCommandLineRef.GetProgram: ustring;
begin
  Result := CefStringFreeAndGet(PCefCommandLine(FData)^.get_program(PCefCommandLine(FData)));
end;

procedure TCefCommandLineRef.GetSwitches(switches: TStrings);
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    PCefCommandLine(FData)^.get_switches(PCefCommandLine(FData), list);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(list, i, @str);
      switches.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefCommandLineRef.GetSwitchValue(const name: ustring): ustring;
var
  n: TCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(PCefCommandLine(FData)^.get_switch_value(PCefCommandLine(FData), @n));
end;

class function TCefCommandLineRef.Global: ICefCommandLine;
begin
  Result := UnWrap(cef_command_line_get_global);
end;

function TCefCommandLineRef.HasArguments: Boolean;
begin
  Result := PCefCommandLine(FData)^.has_arguments(PCefCommandLine(FData)) <> 0;
end;

function TCefCommandLineRef.HasSwitch(const name: ustring): Boolean;
var
  n: TCefString;
begin
  n := CefString(name);
  Result := PCefCommandLine(FData)^.has_switch(PCefCommandLine(FData), @n) <> 0;
end;

function TCefCommandLineRef.HasSwitches: Boolean;
begin
  Result := PCefCommandLine(FData)^.has_switches(PCefCommandLine(FData)) <> 0;
end;

procedure TCefCommandLineRef.InitFromArgv(argc: Integer;
  const argv: PPAnsiChar);
begin
  PCefCommandLine(FData)^.init_from_argv(PCefCommandLine(FData), argc, argv);
end;

procedure TCefCommandLineRef.InitFromString(const commandLine: ustring);
var
  cl: TCefString;
begin
  cl := CefString(commandLine);
  PCefCommandLine(FData)^.init_from_string(PCefCommandLine(FData), @cl);
end;

function TCefCommandLineRef.IsReadOnly: Boolean;
begin
  Result := PCefCommandLine(FData)^.is_read_only(PCefCommandLine(FData)) <> 0;
end;

function TCefCommandLineRef.IsValid: Boolean;
begin
  Result := PCefCommandLine(FData)^.is_valid(PCefCommandLine(FData)) <> 0;
end;

class function TCefCommandLineRef.New: ICefCommandLine;
begin
  Result := UnWrap(cef_command_line_create);
end;

procedure TCefCommandLineRef.PrependWrapper(const wrapper: ustring);
var
  w: TCefString;
begin
  w := CefString(wrapper);
  PCefCommandLine(FData)^.prepend_wrapper(PCefCommandLine(FData), @w);
end;

procedure TCefCommandLineRef.Reset;
begin
  PCefCommandLine(FData)^.reset(PCefCommandLine(FData));
end;

procedure TCefCommandLineRef.SetProgram(const prog: ustring);
var
  p: TCefString;
begin
  p := CefString(prog);
  PCefCommandLine(FData)^.set_program(PCefCommandLine(FData), @p);
end;

class function TCefCommandLineRef.UnWrap(data: Pointer): ICefCommandLine;
begin
  If data <> nil then Result := Create(data) //as ICefCommandLine
  Else Result := nil;
end;

{ TCefSchemeRegistrarRef }

function TCefSchemeRegistrarRef.AddCustomScheme(const schemeName: ustring;
  IsStandard, IsLocal, IsDisplayIsolated: Boolean): Boolean; cconv;
var
  sn: TCefString;
begin
  sn := CefString(schemeName);
  Result := PCefSchemeRegistrar(FData)^.add_custom_scheme(PCefSchemeRegistrar(FData),
    @sn, Ord(IsStandard), Ord(IsLocal), Ord(IsDisplayIsolated)) <> 0;
end;

class function TCefSchemeRegistrarRef.UnWrap(
  data: Pointer): ICefSchemeRegistrar;
begin
  If data <> nil then Result := Create(data) //as ICefSchemeRegistrar
  Else Result := nil;
end;

{ TCefGeolocationCallbackRef }

procedure TCefGeolocationCallbackRef.Cont(allow: Boolean);
begin
  PCefGeolocationCallback(FData)^.cont(PCefGeolocationCallback(FData), Ord(allow));
end;

class function TCefGeolocationCallbackRef.UnWrap(data: Pointer): ICefGeolocationCallback;
begin
  If data <> nil then Result := Create(data) //as ICefGeolocationCallback
  Else Result := nil;
end;

{ TCefContextMenuParamsRef }

function TCefContextMenuParamsRef.GetEditStateFlags: TCefContextMenuEditStateFlags;
begin
  //Byte(Result) := PCefContextMenuParams(FData)^.get_edit_state_flags(PCefContextMenuParams(FData));
  Result := TCefContextMenuEditStateFlags(PCefContextMenuParams(FData)^.get_edit_state_flags(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetFrameCharset: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_frame_charset(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetFrameUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_frame_url(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetLinkUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_link_url(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetMediaStateFlags: TCefContextMenuMediaStateFlags;
begin
  //Word(Result) := PCefContextMenuParams(FData)^.get_media_state_flags(PCefContextMenuParams(FData));
  Result := TCefContextMenuMediaStateFlags(PCefContextMenuParams(FData)^.get_media_state_flags(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetMediaType: TCefContextMenuMediaType;
begin
  Result := PCefContextMenuParams(FData)^.get_media_type(PCefContextMenuParams(FData));
end;

function TCefContextMenuParamsRef.GetPageUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_page_url(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetSelectionText: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_selection_text(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetSourceUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_source_url(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetTypeFlags: TCefContextMenuTypeFlags;
begin
  //Byte(Result) := PCefContextMenuParams(FData)^.get_type_flags(PCefContextMenuParams(FData));
  Result := TCefContextMenuTypeFlags(PCefContextMenuParams(FData)^.get_type_flags(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetUnfilteredLinkUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_unfiltered_link_url(PCefContextMenuParams(FData)));
end;

function TCefContextMenuParamsRef.GetXCoord: Integer;
begin
  Result := PCefContextMenuParams(FData)^.get_xcoord(PCefContextMenuParams(FData));
end;

function TCefContextMenuParamsRef.GetYCoord: Integer;
begin
  Result := PCefContextMenuParams(FData)^.get_ycoord(PCefContextMenuParams(FData));
end;

function TCefContextMenuParamsRef.IsEditable: Boolean;
begin
  Result := PCefContextMenuParams(FData)^.is_editable(PCefContextMenuParams(FData)) <> 0;
end;

function TCefContextMenuParamsRef.IsImageBlocked: Boolean;
begin
  Result := PCefContextMenuParams(FData)^.is_image_blocked(PCefContextMenuParams(FData)) <> 0;
end;

function TCefContextMenuParamsRef.IsSpeechInputEnabled: Boolean;
begin
  Result := PCefContextMenuParams(FData)^.is_speech_input_enabled(PCefContextMenuParams(FData)) <> 0;
end;

class function TCefContextMenuParamsRef.UnWrap(data: Pointer): ICefContextMenuParams;
begin
  If data <> nil then Result := Create(data) //as ICefContextMenuParams
  Else Result := nil;
end;

{ TCefMenuModelRef }

function TCefMenuModelRef.AddCheckItem(commandId: Integer; const text: ustring): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.add_check_item(PCefMenuModel(FData), commandId, @t) <> 0;
end;

function TCefMenuModelRef.AddItem(commandId: Integer; const text: ustring): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.add_item(PCefMenuModel(FData), commandId, @t) <> 0;
end;

function TCefMenuModelRef.AddRadioItem(commandId: Integer; const text: ustring;
  groupId: Integer): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.add_radio_item(PCefMenuModel(FData), commandId, @t, groupId) <> 0;
end;

function TCefMenuModelRef.AddSeparator: Boolean;
begin
  Result := PCefMenuModel(FData)^.add_separator(PCefMenuModel(FData)) <> 0;
end;

function TCefMenuModelRef.AddSubMenu(commandId: Integer; const text: ustring): ICefMenuModel;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.add_sub_menu(PCefMenuModel(FData), commandId, @t));
end;

function TCefMenuModelRef.Clear: Boolean;
begin
  Result := PCefMenuModel(FData)^.clear(PCefMenuModel(FData)) <> 0;
end;

function TCefMenuModelRef.GetAccelerator(commandId: Integer;
  out keyCode: Integer; out shiftPressed, ctrlPressed,
  altPressed: Boolean): Boolean;
var
  sp, cp, ap: Integer;
begin
  Result := PCefMenuModel(FData)^.get_accelerator(PCefMenuModel(FData),
    commandId, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TCefMenuModelRef.GetAcceleratorAt(index: Integer; out keyCode: Integer;
  out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
var
  sp, cp, ap: Integer;
begin
  Result := PCefMenuModel(FData)^.get_accelerator_at(PCefMenuModel(FData),
    index, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TCefMenuModelRef.GetCommandIdAt(index: Integer): Integer;
begin
  Result := PCefMenuModel(FData)^.get_command_id_at(PCefMenuModel(FData), index);
end;

function TCefMenuModelRef.GetCount: Integer;
begin
  Result := PCefMenuModel(FData)^.get_count(PCefMenuModel(FData));
end;

function TCefMenuModelRef.GetGroupId(commandId: Integer): Integer;
begin
  Result := PCefMenuModel(FData)^.get_group_id(PCefMenuModel(FData), commandId);
end;

function TCefMenuModelRef.GetGroupIdAt(index: Integer): Integer;
begin
  Result := PCefMenuModel(FData)^.get_group_id(PCefMenuModel(FData), index);
end;

function TCefMenuModelRef.GetIndexOf(commandId: Integer): Integer;
begin
  Result := PCefMenuModel(FData)^.get_index_of(PCefMenuModel(FData), commandId);
end;

function TCefMenuModelRef.GetLabel(commandId: Integer): ustring;
begin
  Result := CefStringFreeAndGet(PCefMenuModel(FData)^.get_label(PCefMenuModel(FData), commandId));
end;

function TCefMenuModelRef.GetLabelAt(index: Integer): ustring;
begin
  Result := CefStringFreeAndGet(PCefMenuModel(FData)^.get_label_at(PCefMenuModel(FData), index));
end;

function TCefMenuModelRef.GetSubMenu(commandId: Integer): ICefMenuModel;
begin
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.get_sub_menu(PCefMenuModel(FData), commandId));
end;

function TCefMenuModelRef.GetSubMenuAt(index: Integer): ICefMenuModel;
begin
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.get_sub_menu_at(PCefMenuModel(FData), index));
end;

function TCefMenuModelRef.GetType(commandId: Integer): TCefMenuItemType;
begin
  Result := PCefMenuModel(FData)^.get_type(PCefMenuModel(FData), commandId);
end;

function TCefMenuModelRef.GetTypeAt(index: Integer): TCefMenuItemType;
begin
  Result := PCefMenuModel(FData)^.get_type_at(PCefMenuModel(FData), index);
end;

function TCefMenuModelRef.HasAccelerator(commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.has_accelerator(PCefMenuModel(FData), commandId) <> 0;
end;

function TCefMenuModelRef.HasAcceleratorAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.has_accelerator_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.InsertCheckItemAt(index, commandId: Integer; const text: ustring): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.insert_check_item_at(PCefMenuModel(FData), index, commandId, @t) <> 0;
end;

function TCefMenuModelRef.InsertItemAt(index, commandId: Integer; const text: ustring): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.insert_item_at(PCefMenuModel(FData), index, commandId, @t) <> 0;
end;

function TCefMenuModelRef.InsertRadioItemAt(index, commandId: Integer; const text: ustring; groupId: Integer): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.insert_radio_item_at(PCefMenuModel(FData),
    index, commandId, @t, groupId) <> 0;
end;

function TCefMenuModelRef.InsertSeparatorAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.insert_separator_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.InsertSubMenuAt(index, commandId: Integer; const text: ustring): ICefMenuModel;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.insert_sub_menu_at(
    PCefMenuModel(FData), index, commandId, @t));
end;

function TCefMenuModelRef.IsChecked(commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.is_checked(PCefMenuModel(FData), commandId) <> 0;
end;

function TCefMenuModelRef.IsCheckedAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.is_checked_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.IsEnabled(commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.is_enabled(PCefMenuModel(FData), commandId) <> 0;
end;

function TCefMenuModelRef.IsEnabledAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.is_enabled_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.IsVisible(commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.is_visible(PCefMenuModel(FData), commandId) <> 0;
end;

function TCefMenuModelRef.isVisibleAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.is_visible_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.Remove(commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.remove(PCefMenuModel(FData), commandId) <> 0;
end;

function TCefMenuModelRef.RemoveAccelerator(commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.remove_accelerator(PCefMenuModel(FData), commandId) <> 0;
end;

function TCefMenuModelRef.RemoveAcceleratorAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.remove_accelerator_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.RemoveAt(index: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.remove_at(PCefMenuModel(FData), index) <> 0;
end;

function TCefMenuModelRef.SetAccelerator(commandId, keyCode: Integer;
  shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_accelerator(PCefMenuModel(FData),
    commandId, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TCefMenuModelRef.SetAcceleratorAt(index, keyCode: Integer;
  shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_accelerator_at(PCefMenuModel(FData),
    index, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TCefMenuModelRef.setChecked(commandId: Integer; checked: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_checked(PCefMenuModel(FData),
    commandId, Ord(checked)) <> 0;
end;

function TCefMenuModelRef.setCheckedAt(index: Integer; checked: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_checked_at(PCefMenuModel(FData), index, Ord(checked)) <> 0;
end;

function TCefMenuModelRef.SetCommandIdAt(index, commandId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_command_id_at(PCefMenuModel(FData), index, commandId) <> 0;
end;

function TCefMenuModelRef.SetEnabled(commandId: Integer; enabled: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_enabled(PCefMenuModel(FData), commandId, Ord(enabled)) <> 0;
end;

function TCefMenuModelRef.SetEnabledAt(index: Integer; enabled: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_enabled_at(PCefMenuModel(FData), index, Ord(enabled)) <> 0;
end;

function TCefMenuModelRef.SetGroupId(commandId, groupId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_group_id(PCefMenuModel(FData), commandId, groupId) <> 0;
end;

function TCefMenuModelRef.SetGroupIdAt(index, groupId: Integer): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_group_id_at(PCefMenuModel(FData), index, groupId) <> 0;
end;

function TCefMenuModelRef.SetLabel(commandId: Integer; const text: ustring): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.set_label(PCefMenuModel(FData), commandId, @t) <> 0;
end;

function TCefMenuModelRef.SetLabelAt(index: Integer; const text: ustring): Boolean;
var
  t: TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.set_label_at(PCefMenuModel(FData), index, @t) <> 0;
end;

function TCefMenuModelRef.SetVisible(commandId: Integer; visible: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_visible(PCefMenuModel(FData), commandId, Ord(visible)) <> 0;
end;

function TCefMenuModelRef.SetVisibleAt(index: Integer; visible: Boolean): Boolean;
begin
  Result := PCefMenuModel(FData)^.set_visible_at(PCefMenuModel(FData), index, Ord(visible)) <> 0;
end;

class function TCefMenuModelRef.UnWrap(data: Pointer): ICefMenuModel;
begin
  If data <> nil then Result := Create(data) //as ICefMenuModel
  Else Result := nil;
end;

{ TCefListValueRef }

function TCefListValueRef.Clear: Boolean;
begin
  Result := PCefListValue(FData)^.clear(PCefListValue(FData)) <> 0;
end;

function TCefListValueRef.Copy: ICefListValue;
begin
  Result := UnWrap(PCefListValue(FData)^.copy(PCefListValue(FData)));
end;

class function TCefListValueRef.New: ICefListValue;
begin
  UnWrap(cef_list_value_create);
end;

function TCefListValueRef.GetBinary(index: Integer): ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefListValue(FData)^.get_binary(PCefListValue(FData), index));
end;

function TCefListValueRef.GetBool(index: Integer): Boolean;
begin
  Result := PCefListValue(FData)^.get_bool(PCefListValue(FData), index) <> 0;
end;

function TCefListValueRef.GetDictionary(index: Integer): ICefDictionaryValue;
begin
  Result := TCefDictionaryValueRef.UnWrap(PCefListValue(FData)^.get_dictionary(PCefListValue(FData), index));
end;

function TCefListValueRef.GetDouble(index: Integer): Double;
begin
  Result := PCefListValue(FData)^.get_double(PCefListValue(FData), index);
end;

function TCefListValueRef.GetInt(index: Integer): Integer;
begin
  Result := PCefListValue(FData)^.get_int(PCefListValue(FData), index);
end;

function TCefListValueRef.GetList(index: Integer): ICefListValue;
begin
  Result := UnWrap(PCefListValue(FData)^.get_list(PCefListValue(FData), index));
end;

function TCefListValueRef.GetSize: Cardinal;
begin
  Result := PCefListValue(FData)^.get_size(PCefListValue(FData));
end;

function TCefListValueRef.GetString(index: Integer): ustring;
begin
  Result := CefStringFreeAndGet(PCefListValue(FData)^.get_string(PCefListValue(FData), index));
end;

function TCefListValueRef.GetType(index: Integer): TCefValueType;
begin
  Result := PCefListValue(FData)^.get_type(PCefListValue(FData), index);
end;

function TCefListValueRef.IsOwned: Boolean;
begin
  Result := PCefListValue(FData)^.is_owned(PCefListValue(FData)) <> 0;
end;

function TCefListValueRef.IsReadOnly: Boolean;
begin
  Result := PCefListValue(FData)^.is_read_only(PCefListValue(FData)) <> 0;
end;

function TCefListValueRef.IsValid: Boolean;
begin
  Result := PCefListValue(FData)^.is_valid(PCefListValue(FData)) <> 0;
end;

function TCefListValueRef.Remove(index: Integer): Boolean;
begin
  Result := PCefListValue(FData)^.remove(PCefListValue(FData), index) <> 0;
end;

function TCefListValueRef.SetBinary(index: Integer; const value: ICefBinaryValue): Boolean;
begin
  Result := PCefListValue(FData)^.set_binary(PCefListValue(FData), index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetBool(index: Integer; value: Boolean): Boolean;
begin
  Result := PCefListValue(FData)^.set_bool(PCefListValue(FData), index, Ord(value)) <> 0;
end;

function TCefListValueRef.SetDictionary(index: Integer; const value: ICefDictionaryValue): Boolean;
begin
  Result := PCefListValue(FData)^.set_dictionary(PCefListValue(FData), index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetDouble(index: Integer; value: Double): Boolean;
begin
  Result := PCefListValue(FData)^.set_double(PCefListValue(FData), index, value) <> 0;
end;

function TCefListValueRef.SetInt(index, value: Integer): Boolean;
begin
  Result := PCefListValue(FData)^.set_int(PCefListValue(FData), index, value) <> 0;
end;

function TCefListValueRef.SetList(index: Integer; const value: ICefListValue): Boolean;
begin
  Result := PCefListValue(FData)^.set_list(PCefListValue(FData), index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetNull(index: Integer): Boolean;
begin
  Result := PCefListValue(FData)^.set_null(PCefListValue(FData), index) <> 0;
end;

function TCefListValueRef.SetSize(size: Cardinal): Boolean;
begin
  Result := PCefListValue(FData)^.set_size(PCefListValue(FData), size) <> 0;
end;

function TCefListValueRef.SetString(index: Integer; const value: ustring): Boolean;
var
  v: TCefString;
begin
  v := CefString(value);
  Result := PCefListValue(FData)^.set_string(PCefListValue(FData), index, @v) <> 0;
end;

class function TCefListValueRef.UnWrap(data: Pointer): ICefListValue;
begin
  If data <> nil then Result := Create(data) //as ICefListValue
  Else Result := nil;
end;

{ TCefBinaryValueRef }

function TCefBinaryValueRef.Copy: ICefBinaryValue;
begin
  Result := UnWrap(PCefBinaryValue(FData)^.copy(PCefBinaryValue(FData)));
end;

function TCefBinaryValueRef.GetData(buffer: Pointer; bufferSize,
  dataOffset: Cardinal): Cardinal;
begin
  Result := PCefBinaryValue(FData)^.get_data(PCefBinaryValue(FData), buffer, bufferSize, dataOffset);
end;

function TCefBinaryValueRef.GetSize: Cardinal;
begin
  Result := PCefBinaryValue(FData)^.get_size(PCefBinaryValue(FData));
end;

function TCefBinaryValueRef.IsOwned: Boolean;
begin
  Result := PCefBinaryValue(FData)^.is_owned(PCefBinaryValue(FData)) <> 0;
end;

function TCefBinaryValueRef.IsValid: Boolean;
begin
  Result := PCefBinaryValue(FData)^.is_valid(PCefBinaryValue(FData)) <> 0;
end;

class function TCefBinaryValueRef.New(const data: Pointer; dataSize: Cardinal): ICefBinaryValue;
begin
  Result := UnWrap(cef_binary_value_create(data, dataSize));
end;

class function TCefBinaryValueRef.UnWrap(data: Pointer): ICefBinaryValue;
begin
  If data <> nil then Result := Create(data) //as ICefBinaryValue
  Else Result := nil;
end;

{ TCefDictionaryValueRef }

function TCefDictionaryValueRef.Clear: Boolean;
begin
  Result := PCefDictionaryValue(FData)^.clear(PCefDictionaryValue(FData)) <> 0;
end;

function TCefDictionaryValueRef.Copy(
  excludeEmptyChildren: Boolean): ICefDictionaryValue;
begin
  Result := UnWrap(PCefDictionaryValue(FData)^.copy(PCefDictionaryValue(FData), Ord(excludeEmptyChildren)));
end;

function TCefDictionaryValueRef.GetBinary(const key: ustring): ICefBinaryValue;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := TCefBinaryValueRef.UnWrap(PCefDictionaryValue(FData)^.get_binary(PCefDictionaryValue(FData), @k));
end;

function TCefDictionaryValueRef.GetBool(const key: ustring): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_bool(PCefDictionaryValue(FData), @k) <> 0;
end;

function TCefDictionaryValueRef.GetDictionary(
  const key: ustring): ICefDictionaryValue;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := UnWrap(PCefDictionaryValue(FData)^.get_dictionary(PCefDictionaryValue(FData), @k));
end;

function TCefDictionaryValueRef.GetDouble(const key: ustring): Double;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_double(PCefDictionaryValue(FData), @k);
end;

function TCefDictionaryValueRef.GetInt(const key: ustring): Integer;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_int(PCefDictionaryValue(FData), @k);
end;

function TCefDictionaryValueRef.GetKeys(const keys: TStrings): Boolean;
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    Result := PCefDictionaryValue(FData)^.get_keys(PCefDictionaryValue(FData), list) <> 0;
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(str, SizeOf(str), 0);
      cef_string_list_value(list, i, @str);
      keys.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefDictionaryValueRef.GetList(const key: ustring): ICefListValue;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := TCefListValueRef.UnWrap(PCefDictionaryValue(FData)^.get_list(PCefDictionaryValue(FData), @k));
end;

function TCefDictionaryValueRef.GetSize: Cardinal;
begin
  Result := PCefDictionaryValue(FData)^.get_size(PCefDictionaryValue(FData));
end;

function TCefDictionaryValueRef.GetString(const key: ustring): ustring;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := CefStringFreeAndGet(PCefDictionaryValue(FData)^.get_string(PCefDictionaryValue(FData), @k));
end;

function TCefDictionaryValueRef.GetType(const key: ustring): TCefValueType;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_type(PCefDictionaryValue(FData), @k);
end;

function TCefDictionaryValueRef.HasKey(const key: ustring): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.has_key(PCefDictionaryValue(FData), @k) <> 0;
end;

function TCefDictionaryValueRef.isOwned: Boolean;
begin
  Result := PCefDictionaryValue(FData)^.is_owned(PCefDictionaryValue(FData)) <> 0;
end;

function TCefDictionaryValueRef.IsReadOnly: Boolean;
begin
  Result := PCefDictionaryValue(FData)^.is_read_only(PCefDictionaryValue(FData)) <> 0;
end;

function TCefDictionaryValueRef.IsValid: Boolean;
begin
  Result := PCefDictionaryValue(FData)^.is_valid(PCefDictionaryValue(FData)) <> 0;
end;

class function TCefDictionaryValueRef.New: ICefDictionaryValue;
begin
  Result := UnWrap(cef_dictionary_value_create);
end;

function TCefDictionaryValueRef.Remove(const key: ustring): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.remove(PCefDictionaryValue(FData), @k) <> 0;
end;

function TCefDictionaryValueRef.SetBinary(const key: ustring; const value: ICefBinaryValue): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_binary(PCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetBool(const key: ustring; value: Boolean): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_bool(PCefDictionaryValue(FData), @k, Ord(value)) <> 0;
end;

function TCefDictionaryValueRef.SetDictionary(const key: ustring; const value: ICefDictionaryValue): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_dictionary(PCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetDouble(const key: ustring; value: Double): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_double(PCefDictionaryValue(FData), @k, value) <> 0;
end;

function TCefDictionaryValueRef.SetInt(const key: ustring; value: Integer): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_int(PCefDictionaryValue(FData), @k, value) <> 0;
end;

function TCefDictionaryValueRef.SetList(const key: ustring; const value: ICefListValue): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_list(PCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetNull(const key: ustring): Boolean;
var
  k: TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_null(PCefDictionaryValue(FData), @k) <> 0;
end;

function TCefDictionaryValueRef.SetString(const key, value: ustring): Boolean;
var
  k, v: TCefString;
begin
  k := CefString(key);
  v := CefString(value);
  Result := PCefDictionaryValue(FData)^.set_string(PCefDictionaryValue(FData), @k, @v) <> 0;
end;

class function TCefDictionaryValueRef.UnWrap(data: Pointer): ICefDictionaryValue;
begin
  If data <> nil then Result := Create(data) //as ICefDictionaryValue
  Else Result := nil;
end;

{ TCefBrowserProcessHandlerOwn }

constructor TCefBrowserProcessHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefBrowserProcessHandler));
  With PCefBrowserProcessHandler(FData)^ do
  begin
    on_context_initialized := @cef_browser_process_handler_on_context_initialized;
    on_before_child_process_launch := @cef_browser_process_handler_on_before_child_process_launch;
    on_render_process_thread_created := @cef_browser_process_handler_on_render_process_thread_created;
  end;
end;

procedure TCefBrowserProcessHandlerOwn.OnBeforeChildProcessLaunch(
  const commandLine: ICefCommandLine);
begin

end;

procedure TCefBrowserProcessHandlerOwn.OnContextInitialized;
begin

end;

procedure TCefBrowserProcessHandlerOwn.OnRenderProcessThreadCreated(const extraInfo: ICefListValue);
begin

end;

{ TCefRenderProcessHandlerOwn }

constructor TCefRenderProcessHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRenderProcessHandler));
  With PCefRenderProcessHandler(FData)^ do
  begin
    on_render_thread_created := @cef_render_process_handler_on_render_thread_created;
    on_web_kit_initialized := @cef_render_process_handler_on_web_kit_initialized;
    on_browser_created := @cef_render_process_handler_on_browser_created;
    on_browser_destroyed := @cef_render_process_handler_on_browser_destroyed;
    on_before_navigation := @cef_render_process_handler_on_before_navigation;
    on_context_created := @cef_render_process_handler_on_context_created;
    on_context_released := @cef_render_process_handler_on_context_released;
    on_uncaught_exception := @cef_render_process_handler_on_uncaught_exception;
    on_worker_context_created := @cef_render_process_handler_on_worker_context_created;
    on_worker_context_released := @cef_render_process_handler_on_worker_context_released;
    on_worker_uncaught_exception := @cef_render_process_handler_on_worker_uncaught_exception;
    on_focused_node_changed := @cef_render_process_handler_on_focused_node_changed;
    on_process_message_received := @cef_render_process_handler_on_process_message_received;
  end;
end;

function TCefRenderProcessHandlerOwn.OnBeforeNavigation(
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; navigationType: TCefNavigationType;
  isRedirect: Boolean): Boolean;
begin
  Result := False;
end;

procedure TCefRenderProcessHandlerOwn.OnBrowserCreated( const browser: ICefBrowser);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnBrowserDestroyed(const browser: ICefBrowser);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnContextCreated(
  const browser: ICefBrowser; const frame: ICefFrame;
  const context: ICefv8Context);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnContextReleased(
  const browser: ICefBrowser; const frame: ICefFrame;
  const context: ICefv8Context);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnFocusedNodeChanged(
  const browser: ICefBrowser; const frame: ICefFrame; const node: ICefDomNode);
begin

end;

function TCefRenderProcessHandlerOwn.OnProcessMessageReceived(
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
begin
  Result := False;
end;

procedure TCefRenderProcessHandlerOwn.OnRenderThreadCreated(const extraInfo: ICefListValue);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnUncaughtException(
  const browser: ICefBrowser; const frame: ICefFrame;
  const context: ICefv8Context; const exception: ICefV8Exception;
  const stackTrace: ICefV8StackTrace);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnWebKitInitialized;
begin

end;

procedure TCefRenderProcessHandlerOwn.OnWorkerContextCreated(workerId: Integer;
  const url: ustring; const context: ICefv8Context);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnWorkerContextReleased(workerId: Integer;
  const url: ustring; const context: ICefv8Context);
begin

end;

procedure TCefRenderProcessHandlerOwn.OnWorkerUncaughtException(
  workerId: Integer; const url: ustring; const context: ICefv8Context;
  const exception: ICefV8Exception; const stackTrace: ICefV8StackTrace);
begin

end;

{ TCefResourceHandlerOwn }

procedure TCefResourceHandlerOwn.Cancel;
begin

end;

function TCefResourceHandlerOwn.CanGetCookie(const cookie: PCefCookie): Boolean;
begin
  Result := False;
end;

function TCefResourceHandlerOwn.CanSetCookie(const cookie: PCefCookie): Boolean;
begin
  Result := False;
end;

constructor TCefResourceHandlerOwn.Create(const browser: ICefBrowser;
  const frame: ICefFrame; const schemeName: ustring;
  const request: ICefRequest);
begin
  inherited CreateData(SizeOf(TCefResourceHandler));
  With PCefResourceHandler(FData)^ do
  begin
    process_request := @cef_resource_handler_process_request;
    get_response_headers := @cef_resource_handler_get_response_headers;
    read_response := @cef_resource_handler_read_response;
    can_get_cookie := @cef_resource_handler_can_get_cookie;
    can_set_cookie := @cef_resource_handler_can_set_cookie;
    cancel:= @cef_resource_handler_cancel;
  end;
end;

procedure TCefResourceHandlerOwn.GetResponseHeaders(
  const response: ICefResponse; out responseLength: Int64;
  out redirectUrl: ustring);
begin

end;

function TCefResourceHandlerOwn.ProcessRequest(const request: ICefRequest;
  const callback: ICefCallback): Boolean;
begin
  Result := False;
end;

function TCefResourceHandlerOwn.ReadResponse(const dataOut: Pointer;
  bytesToRead: Integer; var bytesRead: Integer;
  const callback: ICefCallback): Boolean;
begin
  Result := False;
end;

{ TCefSchemeHandlerFactoryOwn }

constructor TCefSchemeHandlerFactoryOwn.Create(
  const AClass: TCefResourceHandlerClass; SyncMainThread: Boolean);
begin
  inherited CreateData(SizeOf(TCefSchemeHandlerFactory));
  FClass := AClass;
  PCefSchemeHandlerFactory(FData)^.create := @cef_scheme_handler_factory_create;
end;

function TCefSchemeHandlerFactoryOwn.New(const browser: ICefBrowser;
  const frame: ICefFrame; const schemeName: ustring;
  const request: ICefRequest): ICefResourceHandler;
begin
  Result := FClass.Create(browser, frame, schemeName, request);
end;

{ TCefCallbackRef }

procedure TCefCallbackRef.Cancel;
begin
  PCefCallback(FData)^.cancel(PCefCallback(FData));
end;

procedure TCefCallbackRef.Cont;
begin
  PCefCallback(FData)^.cont(PCefCallback(FData));
end;

class function TCefCallbackRef.UnWrap(data: Pointer): ICefCallback;
begin
  If data <> nil then Result := Create(data) //as ICefCallback
  Else Result := nil;
end;


{ TCefUrlrequestClientOwn }

constructor TCefUrlrequestClientOwn.Create;
begin
  inherited CreateData(SizeOf(TCefUrlrequestClient));
  With PCefUrlrequestClient(FData)^ do
  begin
    on_request_complete := @cef_url_request_client_on_request_complete;
    on_upload_progress := @cef_url_request_client_on_upload_progress;
    on_download_progress := @cef_url_request_client_on_download_progress;
    on_download_data := @cef_url_request_client_on_download_data;
  end;
end;

procedure TCefUrlrequestClientOwn.OnDownloadData(const request: ICefUrlRequest;
  data: Pointer; dataLength: Cardinal);
begin

end;

procedure TCefUrlrequestClientOwn.OnDownloadProgress(
  const request: ICefUrlRequest; current, total: UInt64);
begin

end;

procedure TCefUrlrequestClientOwn.OnRequestComplete(
  const request: ICefUrlRequest);
begin

end;

procedure TCefUrlrequestClientOwn.OnUploadProgress(
  const request: ICefUrlRequest; current, total: UInt64);
begin

end;

{ TCefUrlRequestRef }

procedure TCefUrlRequestRef.Cancel;
begin
  PCefUrlRequest(FData)^.cancel(PCefUrlRequest(FData));
end;

class function TCefUrlRequestRef.New(const request: ICefRequest;
  const client: ICefUrlRequestClient): ICefUrlRequest;
begin
  Result := UnWrap(cef_urlrequest_create(CefGetData(request), CefGetData(client)));
end;

function TCefUrlRequestRef.GetRequest: ICefRequest;
begin
  Result := TCefRequestRef.UnWrap(PCefUrlRequest(FData)^.get_request(PCefUrlRequest(FData)));
end;

function TCefUrlRequestRef.GetRequestError: Integer;
begin
  Result := PCefUrlRequest(FData)^.get_request_error(PCefUrlRequest(FData));
end;

function TCefUrlRequestRef.GetRequestStatus: TCefUrlRequestStatus;
begin
  Result := PCefUrlRequest(FData)^.get_request_status(PCefUrlRequest(FData));
end;

function TCefUrlRequestRef.GetResponse: ICefResponse;
begin
  Result := TCefResponseRef.UnWrap(PCefUrlRequest(FData)^.get_response(PCefUrlRequest(FData)));
end;

class function TCefUrlRequestRef.UnWrap(data: Pointer): ICefUrlRequest;
begin
  If data <> nil then Result := Create(data) //as ICefUrlRequest
  Else Result := nil;
end;


{ TCefWebPluginInfoVisitorOwn }

constructor TCefWebPluginInfoVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TCefWebPluginInfoVisitor));
  PCefWebPluginInfoVisitor(FData)^.visit := @cef_web_plugin_info_visitor_visit;
end;

function TCefWebPluginInfoVisitorOwn.Visit(const info: ICefWebPluginInfo; count, total: Integer): Boolean;
begin
  Result := False;
end;

{ TCefFastWebPluginInfoVisitor }

constructor TCefFastWebPluginInfoVisitor.Create(const proc: TCefWebPluginInfoVisitorProc);
begin
  inherited Create;
  FProc := proc;
end;

function TCefFastWebPluginInfoVisitor.Visit(const info: ICefWebPluginInfo;
  count, total: Integer): Boolean;
begin
  Result := FProc(info, count, total);
end;

{ TCefQuotaCallbackRef }

procedure TCefQuotaCallbackRef.Cancel;
begin
  PCefQuotaCallback(FData)^.cancel(FData);
end;

procedure TCefQuotaCallbackRef.Cont(allow: Boolean);
begin
  PCefQuotaCallback(FData)^.cont(FData, Ord(allow));
end;

class function TCefQuotaCallbackRef.UnWrap(data: Pointer): ICefQuotaCallback;
begin
  If data <> nil then Result := Create(data) //as ICefQuotaCallback
  Else Result := nil;
end;

{ TCefV8StackFrameRef }

function TCefV8StackFrameRef.GetColumn: Integer;
begin
  Result := PCefV8StackFrame(FData)^.get_column(FData);
end;

function TCefV8StackFrameRef.GetFunctionName: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(FData)^.get_function_name(FData));
end;

function TCefV8StackFrameRef.GetLineNumber: Integer;
begin
  Result := PCefV8StackFrame(FData)^.get_line_number(FData);
end;

function TCefV8StackFrameRef.GetScriptName: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(FData)^.get_script_name(FData));
end;

function TCefV8StackFrameRef.GetScriptNameOrSourceUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(FData)^.get_script_name_or_source_url(FData));
end;

function TCefV8StackFrameRef.IsConstructor: Boolean;
begin
  Result := PCefV8StackFrame(FData)^.is_constructor(FData) <> 0;
end;

function TCefV8StackFrameRef.IsEval: Boolean;
begin
  Result := PCefV8StackFrame(FData)^.is_eval(FData) <> 0;
end;

function TCefV8StackFrameRef.IsValid: Boolean;
begin
  Result := PCefV8StackFrame(FData)^.is_valid(FData) <> 0;
end;

class function TCefV8StackFrameRef.UnWrap(data: Pointer): ICefV8StackFrame;
begin
  If data <> nil then Result := Create(data) //as ICefV8StackFrame
  Else Result := nil;
end;

{ TCefV8StackTraceRef }

class function TCefV8StackTraceRef.Current(frameLimit: Integer): ICefV8StackTrace;
begin
  Result := UnWrap(cef_v8stack_trace_get_current(frameLimit));
end;

function TCefV8StackTraceRef.GetFrame(index: Integer): ICefV8StackFrame;
begin
  Result := TCefV8StackFrameRef.UnWrap(PCefV8StackTrace(FData)^.get_frame(FData, index));
end;

function TCefV8StackTraceRef.GetFrameCount: Integer;
begin
  Result := PCefV8StackTrace(FData)^.get_frame_count(FData);
end;

function TCefV8StackTraceRef.IsValid: Boolean;
begin
  Result := PCefV8StackTrace(FData)^.is_valid(FData) <> 0;
end;

class function TCefV8StackTraceRef.UnWrap(data: Pointer): ICefV8StackTrace;
begin
  If data <> nil then Result := Create(data) //as ICefV8StackTrace
  Else Result := nil;
end;

{ TCefWebPluginUnstableCallbackOwn }

constructor TCefWebPluginUnstableCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefWebPluginUnstableCallback));
  PCefWebPluginUnstableCallback(FData)^.is_unstable := @cef_web_plugin_unstable_callback_is_unstable;
end;

procedure TCefWebPluginUnstableCallbackOwn.IsUnstable(const path: ustring;
  unstable: Boolean);
begin

end;

{ TCefFastWebPluginUnstableCallback }

constructor TCefFastWebPluginUnstableCallback.Create(
  const callback: TCefWebPluginIsUnstableProc);
begin
  FCallback := callback;
end;

procedure TCefFastWebPluginUnstableCallback.IsUnstable(const path: ustring; unstable: Boolean);
begin
  FCallback(path, unstable);
end;

{ TCefRunFileDialogCallbackOwn }

procedure TCefRunFileDialogCallbackOwn.Cont(const browserHost: ICefBrowserHost; filePaths: TStrings);
begin

end;

constructor TCefRunFileDialogCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefRunFileDialogCallback));

  PCefRunFileDialogCallback(FData)^.cont := @cef_run_file_dialog_callback_cont;
end;

{ TCefFastRunFileDialogCallback }

procedure TCefFastRunFileDialogCallback.Cont(const browserHost: ICefBrowserHost; filePaths: TStrings);
begin
  FCallback(browserHost, filePaths);
end;

constructor TCefFastRunFileDialogCallback.Create( callback: TCefRunFileDialogCallbackProc);
begin
  inherited Create;
  FCallback := callback;
end;

{ TCefTaskRef }

procedure TCefTaskRef.Execute;
begin
  PCefTask(FData)^.execute(FData);
end;

class function TCefTaskRef.UnWrap(data: Pointer): ICefTask;
begin
  If data <> nil then Result := Create(data) //as ICefTask
  Else Result := nil;
end;

{ TCefTaskRunnerRef }

function TCefTaskRunnerRef.BelongsToCurrentThread: Boolean;
begin
  Result := PCefTaskRunner(FData)^.belongs_to_current_thread(FData) <> 0;
end;

function TCefTaskRunnerRef.BelongsToThread(threadId: TCefThreadId): Boolean;
begin
  Result := PCefTaskRunner(FData)^.belongs_to_thread(FData, threadId) <> 0;
end;

class function TCefTaskRunnerRef.GetForCurrentThread: ICefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_current_thread());
end;

class function TCefTaskRunnerRef.GetForThread(threadId: TCefThreadId): ICefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_thread(threadId));
end;

function TCefTaskRunnerRef.IsSame(const that: ICefTaskRunner): Boolean;
begin
  Result := PCefTaskRunner(FData)^.is_same(FData, CefGetData(that)) <> 0;
end;

function TCefTaskRunnerRef.PostDelayedTask(const task: ICefTask; delayMs: Int64): Boolean;
begin
  Result := PCefTaskRunner(FData)^.post_delayed_task(FData, CefGetData(task), delayMs) <> 0;
end;

function TCefTaskRunnerRef.PostTask(const task: ICefTask): Boolean; cconv;
begin
  Result := PCefTaskRunner(FData)^.post_task(FData, CefGetData(task)) <> 0;
end;

class function TCefTaskRunnerRef.UnWrap(data: Pointer): ICefTaskRunner;
begin
  //If data <> nil then Result := Create(data) as ICefTaskRunner
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

{ TCefTraceClientOwn }

constructor TCefTraceClientOwn.Create;
begin
  inherited CreateData(SizeOf(TCefTraceClient));
  With PCefTraceClient(FData)^ do
  begin
    on_trace_data_collected := @cef_trace_client_on_trace_data_collected;
    on_trace_buffer_percent_full_reply := @cef_trace_client_on_trace_buffer_percent_full_reply;
    on_end_tracing_complete := @cef_trace_client_on_end_tracing_complete;
  end;
end;

procedure TCefTraceClientOwn.OnEndTracingComplete;
begin

end;

procedure TCefTraceClientOwn.OnTraceBufferPercentFullReply(percentFull: Single);
begin

end;

procedure TCefTraceClientOwn.OnTraceDataCollected(const fragment: PAnsiChar; fragmentSize: Cardinal);
begin

end;

{ TCefGetGeolocationCallbackOwn }

constructor TCefGetGeolocationCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TCefGetGeolocationCallback));
  PCefGetGeolocationCallback(FData)^.on_location_update := @cef_get_geolocation_callback_on_location_update;
end;

procedure TCefGetGeolocationCallbackOwn.OnLocationUpdate(const position: PCefGeoposition);
begin

end;

{ TCefFastGetGeolocationCallback }

constructor TCefFastGetGeolocationCallback.Create(const callback: TOnLocationUpdate);
begin
  inherited Create;
  FCallback := callback;
end;

procedure TCefFastGetGeolocationCallback.OnLocationUpdate(const position: PCefGeoposition);
begin
  FCallback(position);
end;

{ TCefFileDialogCallbackRef }

procedure TCefFileDialogCallbackRef.Cancel;
begin
  PCefFileDialogCallback(FData)^.cancel(FData);
end;

procedure TCefFileDialogCallbackRef.Cont(filePaths: TStrings);
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    For i := 0 to filePaths.Count - 1 do
    begin
      str := CefString(filePaths[i]);
      cef_string_list_append(list, @str);
    end;
    PCefFileDialogCallback(FData)^.cont(FData, list);
  finally
    cef_string_list_free(list);
  end;
end;

class function TCefFileDialogCallbackRef.UnWrap(data: Pointer): ICefFileDialogCallback;
begin
  //If data <> nil then Result := Create(data) as ICefFileDialogCallback
  If data <> nil then Result := Create(data)
  Else Result := nil;
end;

{ TCefDialogHandlerOwn }

constructor TCefDialogHandlerOwn.Create;
begin
  CreateData(SizeOf(TCefDialogHandler));
  PCefDialogHandler(FData)^.on_file_dialog := @cef_dialog_handler_on_file_dialog;
end;

function TCefDialogHandlerOwn.OnFileDialog(const browser: ICefBrowser;
  mode: TCefFileDialogMode; const title, defaultFileName: ustring;
  acceptTypes: TStrings; const callback: ICefFileDialogCallback): Boolean;
begin
  Result := False;
end;

{ TCefRenderHandlerOwn }

constructor TCefRenderHandlerOwn.Create;
begin
  CreateData(SizeOf(TCefRenderHandler), False);
  With PCefRenderHandler(FData)^ do
  begin
    get_root_screen_rect := @cef_render_handler_get_root_screen_rect;
    get_view_rect := @cef_render_handler_get_view_rect;
    get_screen_point := @cef_render_handler_get_screen_point;
    on_popup_show := @cef_render_handler_on_popup_show;
    on_popup_size := @cef_render_handler_on_popup_size;
    on_paint := @cef_render_handler_on_paint;
    on_cursor_change := @cef_render_handler_on_cursor_change;
  end;
end;

function TCefRenderHandlerOwn.GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer; screenX, screenY: PInteger): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean;
begin
  Result := False;
end;

procedure TCefRenderHandlerOwn.OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle);
begin

end;

procedure TCefRenderHandlerOwn.OnPaint(const browser: ICefBrowser;
  kind: TCefPaintElementType; dirtyRectsCount: Cardinal;
  const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer);
begin

end;

procedure TCefRenderHandlerOwn.OnPopupShow(const browser: ICefBrowser; show: Boolean);
begin

end;

procedure TCefRenderHandlerOwn.OnPopupSize(const browser: ICefBrowser; const rect: PCefRect);
begin

end;

Finalization
  CefShutDown;

end.
