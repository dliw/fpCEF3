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

Unit cef3ref;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils,
  {$IFDEF DEBUG}LCLProc,{$ENDIF}
  cef3api, cef3types, cef3intf, cef3own;

Type
  { TCefBaseRef }

  TCefBaseRef = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
  public
    constructor Create(data: Pointer); virtual;
    destructor Destroy; override;
    function Wrap: Pointer;
    class function UnWrap(data: Pointer): ICefBase;
  end;

  { TCefBrowserRef }

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
    function GetFrameCount: TSize;
    procedure GetFrameIdentifiers(count: PSize; identifiers: PInt64);
    procedure GetFrameNames(names: TStrings);
    function SendProcessMessage(targetProcess: TCefProcessId; message: ICefProcessMessage): Boolean;
  public
    class function UnWrap(data: Pointer): ICefBrowser;
  end;

  TCefBrowserHostRef = class(TCefBaseRef, ICefBrowserHost)
    function GetBrowser: ICefBrowser;
    procedure ParentWindowWillClose;
    procedure CloseBrowser(aForceClose: Boolean);
    procedure SetFocus(focus: Boolean);
    procedure SetWindowVisibility(visible: Boolean);
    function GetWindowHandle: TCefWindowHandle;
    function GetOpenerWindowHandle: TCefWindowHandle;
    function GetClient: ICefClient;
    function GetRequestContext: ICefRequestContext;
    function GetZoomLevel: Double;
    procedure SetZoomLevel(zoomLevel: Double);
    procedure StartDownload(const url: ustring);
    procedure Print;
    procedure Find(identifier: Integer; const searchText: ustring; forward_, matchCase, findNext: Boolean);
    procedure StopFinding(clearSelection: Boolean);
    procedure ShowDevTools(var windowInfo: TCefWindowInfo; client: ICefClient; var settings: TCefBrowserSettings);
    procedure CloseDevTools;
    procedure SetMouseCursorChangeDisabled(disabled: Boolean);
    function GetIsMouseCursorChangeDisabled: Boolean;
    function GetIsWindowRenderingDisabled: Boolean;
    procedure WasResized;
    procedure WasHidden(hidden: Boolean);
    procedure NotifyScreenInfoChanged;
    procedure Invalidate(const dirtyRect: PCefRect; const aType: TCefPaintElementType);
    procedure SendKeyEvent(const event:TCefKeyEvent);
    procedure SendMouseClickEvent(const event: TCefMouseEvent; aType: TCefMouseButtonType;
      mouseUp: Boolean; clickCount: Integer);
    procedure SendMouseMoveEvent(event:TCefMouseEvent; mouseLeave:boolean);
    procedure SendMouseWheelEvent(const event:TCefMouseEvent; deltaX, deltaY: Integer);
    procedure SendFocusEvent(dosetFocus: Integer);
    procedure SendCaptureLostEvent;
    procedure RunFileDialog(mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptTypes: TStrings;
      const callback: ICefRunFileDialogCallback);
    procedure RunFileDialogProc(mode: TCefFileDialogMode;
      const title, defaultFileName: ustring; acceptTypes: TStrings;
      const callback: TCefRunFileDialogCallbackProc);
    { MACOS
    function GetNstextInputContext: ICefTextInputContext;
    procedure HandleKeyEventBeforeTextInputClient(event: TCefEventHandle);
    procedure HandleKeyAfterBeforeTextInputClient(event: TCefEventHandle);
    }
  public
    class function UnWrap(data: Pointer): ICefBrowserHost;
  end;

  TCefCallbackRef = class(TCefBaseRef, ICefCallback)
  protected
    procedure Cont;
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefCallback;
  end;

  TCefCommandLineRef = class(TCefBaseRef, ICefCommandLine)
  protected
    function IsValid: Boolean;
    function IsReadOnly: Boolean;
    function Copy: ICefCommandLine;
    procedure InitFromArgv(argc: Integer; const argv: PPAnsiChar);
    procedure InitFromString(const commandLine: ustring);
    procedure Reset;
    procedure GetArgv(argv: TStrings);
    function GetCommandLineString: ustring;
    function GetProgram: ustring;
    procedure SetProgram(const program_: ustring);
    function HasSwitches: Boolean;
    function HasSwitch(const name: ustring): Boolean;
    function GetSwitchValue(const name: ustring): ustring;
    procedure GetSwitches(switches: ICefStringMap);
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

  TCefContextMenuParamsRef = class(TCefBaseRef, ICefContextMenuParams)
  protected
    function GetXCoord: Integer;
    function GetYCoord: Integer;
    function GetTypeFlags: TCefContextMenuTypeFlags;
    function GetLinkUrl: ustring;
    function GetUnfilteredLinkUrl: ustring;
    function GetSourceUrl: ustring;
    function HasImageContents: Boolean;
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
    function SetStoragePath(const path: ustring; PersistSessionCookies:boolean): Boolean;
    function FlushStore(handler:ICefCompletionHandler):boolean;
  public
    class function UnWrap(data: Pointer): ICefCookieManager;
    class function Global: ICefCookieManager;
    class function New(const path: ustring; persistSessionCookies: Boolean): ICefCookieManager;
  end;

  TCefFileDialogCallbackRef = class(TCefBaseRef, ICefFileDialogCallback)
  protected
    procedure Cont(filePaths: TStrings);
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefFileDialogCallback;
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

  TCefBeforeDownloadCallbackRef = class(TCefBaseRef, ICefBeforeDownloadCallback)
  protected
    procedure Cont(const downloadPath: ustring; showDialog: Boolean);
  public
     class function UnWrap(data: Pointer): ICefBeforeDownloadCallback;
  end;

  TCefDownloadItemCallbackRef = class(TCefBaseRef, ICefDownloadItemCallback)
  protected
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefDownloadItemCallback;
  end;

  TCefDownloadItemRef = class(TCefBaseRef, ICefDownloadItem)
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
    function GetId: UInt32;
    function GetUrl: ustring;
    function GetSuggestedFileName: ustring;
    function GetContentDisposition: ustring;
    function GetMimeType: ustring;
  public
    class function UnWrap(data: Pointer): ICefDownLoadItem;
  end;

  TCefDragDataRef = class(TCefBaseRef, ICefDragData)
  protected
    function IsLink: Boolean;
    function IsFragment: Boolean;
    function IsFile: Boolean;
    function GetLinkUrl: ustring;
    function GetLinkTitle: ustring;
    function GetLinkMetadata: ustring;
    function GetFragmentText: ustring;
    function GetFragmentHTML: ustring;
    function GetFragmentBaseURL: ustring;
    function GetFileName: ustring;
    function GetFileNames(names: TStrings): Boolean;
  public
    class function UnWrap(data: Pointer): ICefDragData;
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

  TCefGeolocationCallbackRef = class(TCefBaseRef, ICefGeolocationCallback)
  protected
    procedure Cont(allow: Boolean);
  public
    class function UnWrap(data: Pointer): ICefGeolocationCallback;
  end;

  TCefJsDialogCallbackRef = class(TCefBaseRef, ICefJsDialogCallback)
  protected
    procedure Cont(success: Boolean; const userInput: ustring);
  public
    class function UnWrap(data: Pointer): ICefJsDialogCallback;
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
    function GetResourceType: TCefResourceType;
    function GetTransitionType: TCefTransitionType;
    procedure Assign(const url, method: ustring;
      const postData: ICefPostData; const headerMap: ICefStringMultimap);
  public
    class function UnWrap(data: Pointer): ICefRequest;
    class function New: ICefRequest;
  end;

  TCefPostDataRef = class(TCefBaseRef, ICefPostData)
  protected
    function IsReadOnly: Boolean;
    function GetElementCount: TSize;
    function GetElements(Count: TSize): IInterfaceList; // ICefPostDataElement
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
    procedure SetToBytes(size: TSize; const bytes: Pointer);
    function GetType: TCefPostDataElementType;
    function GetFile: ustring;
    function GetBytesCount: TSize;
    function GetBytes(size: TSize; bytes: Pointer): TSize;
  public
    class function UnWrap(data: Pointer): ICefPostDataElement;
    class function New: ICefPostDataElement;
  end;

  TCefRequestContextRef = class(TCefBaseRef, ICefRequestContext)
  protected
    function IsSame(other: ICefRequestContext): Boolean;
    function IsGlobal: Boolean;
    function GetHandler: ICefRequestContextHandler;
  public
    class function UnWrap(data: Pointer): ICefRequestContext;
  end;

  TCefRequestContextHandlerRef = class(TCefBaseRef, ICefRequestContextHandler)
  protected
    function GetCookieManager: ICefCookieManager;
  public
    class function UnWrap(data: Pointer): ICefRequestContextHandler;
  end;

  TCefAuthCallbackRef = class(TCefBaseRef, ICefAuthCallback)
  protected
    procedure Cont(const username, password: ustring);
    procedure Cancel;
  public
     class function UnWrap(data: Pointer): ICefAuthCallback;
  end;

  TCefQuotaCallbackRef = class(TCefBaseRef, ICefQuotaCallback)
  protected
    procedure Cont(allow: Boolean);
    procedure Cancel;
  public
     class function UnWrap(data: Pointer): ICefQuotaCallback;
  end;

  TCefAllowCertificateErrorCallbackRef = class(TCefBaseRef, ICefAllowCertificateErrorCallback)
  protected
    procedure Cont(allow: Boolean);
  public
    class function UnWrap(data: Pointer): ICefAllowCertificateErrorCallback;
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

  TCefSchemeRegistrarRef = class(TCefBaseRef, ICefSchemeRegistrar)
  protected
    function AddCustomScheme(const schemeName: ustring; IsStandard, IsLocal,
      IsDisplayIsolated: Boolean): Boolean; cconv;
  public
    class function UnWrap(data: Pointer): ICefSchemeRegistrar;
  end;

  TCefStreamReaderRef = class(TCefBaseRef, ICefStreamReader)
  protected
    function Read(ptr: Pointer; size, n: TSize): TSize;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Eof: Boolean;
    function MayBlock: Boolean;
  public
    class function UnWrap(data: Pointer): ICefStreamReader;
    class function CreateForFile(const filename: ustring): ICefStreamReader;
    class function CreateForCustomStream(const stream: ICefCustomStreamReader): ICefStreamReader;
    class function CreateForStream(const stream: TSTream; owned: Boolean): ICefStreamReader;
    class function CreateForData(data: Pointer; size: Cardinal): ICefStreamReader;
  end;

  TCefTaskRef = class(TCefBaseRef, ICefTask)
  protected
    procedure Execute; virtual;
  public
    class function UnWrap(data: Pointer): ICefTask;
  end;

  TCefTaskRunnerRef = class(TCefBaseRef, ICefTaskRunner)
  protected
    function IsSame(that:ICefTaskRunner):boolean;
    function BelongsToCurrentThread:boolean;
    function BelongsToThread(ThreadID:TCefThreadID):boolean;
    function PostTask(task:ICefTask):integer;
    function PostDelayedTask(task:ICefTask; delay_ms:Int64):integer;
  public
    class function UnWrap(data: Pointer): ICefTaskRunner;
    class function GetForThread(const ThreadID:TCefThreadID): ICefTaskRunner;
    class function GetForCurrentThread: ICefTaskRunner;
  end;

  TCefUrlRequestRef = class(TCefBaseRef, ICefUrlRequest)
  protected
    function GetRequest: ICefRequest;
    function GetClient: ICefUrlRequestClient;
    function GetRequestStatus: TCefUrlRequestStatus;
    function GetRequestError: TCefErrorcode;
    function GetResponse: ICefResponse;
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefUrlRequest;
    class function New(const request: ICefRequest; const client: ICefUrlRequestClient): ICefUrlRequest;
  end;

  TCefUrlRequestClientRef = class(TCefBaseRef, ICefUrlRequestClient)
  protected
    procedure OnRequestComplete(const request: ICefUrlRequest);
    procedure OnUploadProgress(const request: ICefUrlRequest; current, total: UInt64);
    procedure OnDownloadProgress(const request: ICefUrlRequest; current, total: UInt64);
    procedure OnDownloadData(const request: ICefUrlRequest; data: Pointer; dataLength: TSize);
    function GetAuthCredentials(isProxy: Boolean; const host: ustring; port: Integer;
      const realm, scheme: ustring; callback: ICefAuthCallback): Boolean;
  public
    class function UnWrap(data: Pointer): ICefUrlRequestClient;
  end;

  TCefv8ContextRef = class(TCefBaseRef, ICefv8Context)
  protected
    function GetTaskRunner:ICefTaskRunner;
    function IsValid:boolean;
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

  TCefv8HandlerRef = class(TCefBaseRef, ICefv8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefv8Handler;
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

  TCefv8ValueRef = class(TCefBaseRef, ICefv8Value)
  protected
    function IsValid:boolean;
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
      attribute: TCefV8PropertyAttribute): Boolean;
    function SetValueByIndex(index: Integer; const value: ICefv8Value): Boolean;
    function SetValueByAccessor(const key: ustring; settings: TCefV8AccessControl;
      attribute: TCefV8PropertyAttribute): Boolean;
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

  TCefV8StackTraceRef = class(TCefBaseRef, ICefV8StackTrace)
  protected
    function IsValid:boolean;
    function GetFrameCount: Integer;
    function GetFrame(index: Integer): ICefV8StackFrame;
  public
    class function UnWrap(data: Pointer): ICefV8StackTrace;
    class function Current(frameLimit: Integer): ICefV8StackTrace;
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

  TCefBinaryValueRef = class(TCefBaseRef, ICefBinaryValue)
  protected
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function Copy: ICefBinaryValue;
    function GetSize: TSize;
    function GetData(buffer: Pointer; bufferSize, dataOffset: TSize): TSize;
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
    function GetSize: TSize;
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

  TCefListValueRef = class(TCefBaseRef, ICefListValue)
  protected
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function Copy: ICefListValue;
    function SetSize(size: TSize): Boolean;
    function GetSize: TSize;
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

  TCefWebPluginInfoRef = class(TCefBaseRef, ICefWebPluginInfo)
  protected
    function GetName: ustring;
    function GetPath: ustring;
    function GetVersion: ustring;
    function GetDescription: ustring;
  public
    class function UnWrap(data: Pointer): ICefWebPluginInfo;
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
    function GetAttributeCount: TSize;
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
    function ReadFile(buffer: Pointer; bufferSize: TSize): Integer;
    function Tell: Int64;
    function Eof: Boolean;
  public
    class function UnWrap(data: Pointer): ICefZipReader;
    class function New(const stream: ICefStreamReader): ICefZipReader;
  end;

Implementation

Uses cef3lib;

{ TCefAllowCertificateErrorCallbackRef }

procedure TCefAllowCertificateErrorCallbackRef.Cont(allow : Boolean);
begin
  PCefAllowCertificateErrorCallback(FData)^.cont(FData, Ord(allow));
end;

class function TCefAllowCertificateErrorCallbackRef.UnWrap(data : Pointer) : ICefAllowCertificateErrorCallback;
begin
  If data <> nil then Result := Create(data) as ICefAllowCertificateErrorCallback
  Else Result := nil;
end;

{ TCefBaseRef }

constructor TCefBaseRef.Create(data : Pointer);
begin
  Assert(data <> nil);
  FData := Data;
end;

destructor TCefBaseRef.Destroy;
begin
  If Assigned(PCefBase(FData)^.release) then PCefBase(FData)^.release(FData);

  inherited;
end;

function TCefBaseRef.Wrap : Pointer;
begin
  Result := FData;
  If Assigned(PCefBase(FData)^.add_ref) then PCefBase(FData)^.add_ref(FData);
end;

class function TCefBaseRef.UnWrap(data : Pointer) : ICefBase;
begin
  If data <> nil then Result := Create(data) as ICefBase
  Else Result := nil;
end;

{ TCefBrowserRef }

function TCefBrowserRef.GetHost : ICefBrowserHost;
begin
  Result := TCefBrowserHostRef.UnWrap(PCefBrowser(FData)^.get_host(FData));
end;

function TCefBrowserRef.CanGoBack : Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_back(FData) <> 0;
end;

procedure TCefBrowserRef.GoBack;
begin
  PCefBrowser(FData)^.go_back(FData);
end;

function TCefBrowserRef.CanGoForward : Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_forward(FData) <> 0;
end;

procedure TCefBrowserRef.GoForward;
begin
  PCefBrowser(FData)^.go_forward(FData);
end;

function TCefBrowserRef.IsLoading : Boolean;
begin
  Result := PCefBrowser(FData)^.is_loading(FData) <> 0;
end;

procedure TCefBrowserRef.Reload;
begin
  PCefBrowser(FData)^.reload(FData);
end;

procedure TCefBrowserRef.ReloadIgnoreCache;
begin
  PCefBrowser(FData)^.reload_ignore_cache(FData);
end;

procedure TCefBrowserRef.StopLoad;
begin
  PCefBrowser(FData)^.stop_load(FData);
end;

function TCefBrowserRef.GetIdentifier : Integer;
begin
  Result := PCefBrowser(FData)^.get_identifier(FData);
end;

function TCefBrowserRef.IsSame(const that: ICefBrowser): Boolean;
begin
  Result := PCefBrowser(FData)^.is_same(FData, CefGetData(that)) <> 0;
end;

function TCefBrowserRef.IsPopup : Boolean;
begin
  Result := PCefBrowser(FData)^.is_popup(FData) <> 0;
end;

function TCefBrowserRef.HasDocument : Boolean;
begin
  Result := PCefBrowser(FData)^.has_document(FData) <> 0;
end;

function TCefBrowserRef.GetMainFrame : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_main_frame(FData));
end;

function TCefBrowserRef.GetFocusedFrame : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_focused_frame(FData));
end;

function TCefBrowserRef.GetFrameByident(identifier : Int64) : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_frame_byident(FData, identifier));
end;

function TCefBrowserRef.GetFrame(const name : ustring) : ICefFrame;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_frame(FData, @n));
end;

function TCefBrowserRef.GetFrameCount : TSize;
begin
  Result := PCefBrowser(FData)^.get_frame_count(FData);
end;

procedure TCefBrowserRef.GetFrameIdentifiers(count : PSize; identifiers : PInt64);
begin
  PCefBrowser(FData)^.get_frame_identifiers(FData, count, identifiers);
end;

procedure TCefBrowserRef.GetFrameNames(names : TStrings);
Var
  list : TCefStringList;
  i    : Integer;
  str  : TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefBrowser(FData)^.get_frame_names(FData, list);

    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      names.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefBrowserRef.SendProcessMessage(targetProcess : TCefProcessId; message : ICefProcessMessage) : Boolean;
begin
  Result := PCefBrowser(FData)^.send_process_message(FData, targetProcess, CefGetData(message)) <> 0;
end;

class function TCefBrowserRef.UnWrap(data : Pointer) : ICefBrowser;
begin
  If data <> nil then Result := Create(data) as ICefBrowser
  Else Result := nil;
end;

{ TCefBrowserHostRef }

function TCefBrowserHostRef.GetBrowser : ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefBrowserHost(FData)^.get_browser(FData));
end;

procedure TCefBrowserHostRef.ParentWindowWillClose;
begin
  PCefBrowserHost(FData)^.parent_window_will_close(FData);
end;

procedure TCefBrowserHostRef.CloseBrowser(aForceClose : Boolean);
begin
  PCefBrowserHost(FData)^.close_browser(FData, Ord(aForceClose));
end;

procedure TCefBrowserHostRef.SetFocus(focus: Boolean);
begin
  PCefBrowserHost(FData)^.set_focus(FData, Ord(focus));
end;

procedure TCefBrowserHostRef.SetWindowVisibility(visible : Boolean);
begin
  PCefBrowserHost(FData)^.set_window_visibility(FData, Ord(visible));
end;

function TCefBrowserHostRef.GetWindowHandle : TCefWindowHandle;
begin
  Result := PCefBrowserHost(FData)^.get_window_handle(FData);
end;

function TCefBrowserHostRef.GetOpenerWindowHandle : TCefWindowHandle;
begin
  Result := PCefBrowserHost(FData)^.get_opener_window_handle(FData);
end;

function TCefBrowserHostRef.GetClient : ICefClient;
Var
  client : PCefClient;
begin
  client := PCefBrowserHost(FData)^.get_client(FData);

  If Assigned(client) then Result := TCefBaseRef.Create(client) as ICefClient
  Else Result := nil;
end;

function TCefBrowserHostRef.GetRequestContext : ICefRequestContext;
begin
  Result:=TCefRequestContextRef.UnWrap(PCefBrowserHost(FData)^.get_request_context(PCefBrowserHost(FData)));
end;

function TCefBrowserHostRef.GetZoomLevel : Double;
begin
  Result := PCefBrowserHost(FData)^.get_zoom_level(FData);
end;

procedure TCefBrowserHostRef.SetZoomLevel(zoomLevel : Double);
begin
  PCefBrowserHost(FData)^.set_zoom_level(FData, zoomLevel);
end;

procedure TCefBrowserHostRef.StartDownload(const url : ustring);
Var
  u : TCefString;
begin
  u := CefString(url);
  PCefBrowserHost(FData)^.start_download(FData, @u);
end;

procedure TCefBrowserHostRef.Print;
begin
  PCefBrowserHost(FData)^.print(PCefBrowserHost(FData));
end;

procedure TCefBrowserHostRef.Find(identifier : Integer; const searchText : ustring;
  forward_, matchCase, findNext : Boolean);
Var
  text: TCefString;
begin
  text := CefString(searchText);
  PCefBrowserHost(FData)^.find(PCefBrowserHost(FData), identifier, @text, Ord(forward_), Ord(matchCase),
                               Ord(findNext));
end;

procedure TCefBrowserHostRef.StopFinding(clearSelection : Boolean);
begin
  PCefBrowserHost(FData)^.stop_finding(PCefBrowserHost(FData),Ord(clearSelection));
end;

procedure TCefBrowserHostRef.ShowDevTools(var windowInfo : TCefWindowInfo; client : ICefClient;
  var settings : TCefBrowserSettings);
begin
  PCefBrowserHost(FData)^.show_dev_tools(FData, @windowInfo, CefGetData(client), @settings);
end;

procedure TCefBrowserHostRef.CloseDevTools;
begin
  PCefBrowserHost(FData)^.close_dev_tools(FData);
end;

procedure TCefBrowserHostRef.SetMouseCursorChangeDisabled(disabled : Boolean);
begin
  PCefBrowserHost(FData)^.set_mouse_cursor_change_disabled(FData, Ord(disabled));
end;

function TCefBrowserHostRef.GetIsMouseCursorChangeDisabled : Boolean;
begin
  Result := PCefBrowserHost(FData)^.is_mouse_cursor_change_disabled(FData) <> 0;
end;

function TCefBrowserHostRef.GetIsWindowRenderingDisabled : Boolean;
begin
  Result := PCefBrowserHost(FData)^.is_window_rendering_disabled(FData) <> 0;
end;

procedure TCefBrowserHostRef.WasResized;
begin
  PCefBrowserHost(FData)^.was_resized(FData);
end;

procedure TCefBrowserHostRef.WasHidden(hidden : Boolean);
begin
  PCefBrowserHost(FData)^.was_hidden(FData, Ord(hidden));
end;

procedure TCefBrowserHostRef.NotifyScreenInfoChanged;
begin
  PCefBrowserHost(FData)^.notify_screen_info_changed(FData);
end;

procedure TCefBrowserHostRef.Invalidate(const dirtyRect : PCefRect; const aType : TCefPaintElementType);
begin
  PCefBrowserHost(FData)^.invalidate(FData, dirtyRect, aType);
end;

procedure TCefBrowserHostRef.SendKeyEvent(const event : TCefKeyEvent);
begin
  PCefBrowserHost(FData)^.send_key_event(FData, @event);
end;

procedure TCefBrowserHostRef.SendMouseClickEvent(const event : TCefMouseEvent;
  aType : TCefMouseButtonType; mouseUp : Boolean; clickCount : Integer);
begin
  PCefBrowserHost(FData)^.send_mouse_click_event(FData, @event, aType, Ord(mouseUp), clickCount);
end;

procedure TCefBrowserHostRef.SendMouseMoveEvent(event : TCefMouseEvent;
  mouseLeave : boolean);
begin
  PCefBrowserHost(FData)^.send_mouse_move_event(FData, @event, Ord(mouseLeave));
end;

procedure TCefBrowserHostRef.SendMouseWheelEvent(const event : TCefMouseEvent;
  deltaX, deltaY : Integer);
begin
  PCefBrowserHost(FData)^.send_mouse_wheel_event(FData, @event, deltaX, deltaY);
end;

procedure TCefBrowserHostRef.SendFocusEvent(dosetFocus : Integer);
begin
  PCefBrowserHost(FData)^.send_focus_event(FData, dosetFocus);
end;

procedure TCefBrowserHostRef.SendCaptureLostEvent;
begin
  PCefBrowserHost(FData)^.send_capture_lost_event(FData);
end;

procedure TCefBrowserHostRef.RunFileDialog(mode : TCefFileDialogMode;
  const title, defaultFileName : ustring; acceptTypes : TStrings;
  const callback : ICefRunFileDialogCallback);
Var
  t, f : TCefString;
  list : TCefStringList;
  item : TCefString;
  i    : Integer;
begin
  t := CefString(title);
  f := CefString(defaultFileName);
  list := cef_string_list_alloc();

  try
    For i := 0 to acceptTypes.Count - 1 do
    begin
      item := CefString(acceptTypes[i]);
      cef_string_list_append(list, @item);
    end;
    PCefBrowserHost(FData)^.run_file_dialog(FData, mode, @t, @f, list, CefGetData(callback));
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefBrowserHostRef.RunFileDialogProc(mode : TCefFileDialogMode;
  const title, defaultFileName : ustring; acceptTypes : TStrings;
  const callback : TCefRunFileDialogCallbackProc);
begin
  RunFileDialog(mode, title, defaultFileName, acceptTypes, TCefFastRunFileDialogCallback.Create(callback));
end;

class function TCefBrowserHostRef.UnWrap(data : Pointer) : ICefBrowserHost;
begin
  If data <> nil then Result := Create(data) as ICefBrowserHost
  Else Result := nil;
end;

{ TCefCallbackRef }

procedure TCefCallbackRef.Cont;
begin
  PCefCallback(FData)^.cont(FData);
end;

procedure TCefCallbackRef.Cancel;
begin
  PCefCallback(FData)^.cancel(FData);
end;

class function TCefCallbackRef.UnWrap(data : Pointer) : ICefCallback;
begin
  If data <> nil then Result := Create(data) as ICefCallback
  Else Result := nil;
end;

{ TCefCommandLineRef }

function TCefCommandLineRef.IsValid : Boolean;
begin
  Result := PCefCommandLine(FData)^.is_valid(FData) <> 0;
end;

function TCefCommandLineRef.IsReadOnly : Boolean;
begin
  Result := PCefCommandLine(FData)^.is_read_only(FData) <> 0;
end;

function TCefCommandLineRef.Copy : ICefCommandLine;
begin
  Result := UnWrap(PCefCommandLine(FData)^.copy(FData));
end;

procedure TCefCommandLineRef.InitFromArgv(argc : Integer; const argv : PPAnsiChar);
begin
  PCefCommandLine(FData)^.init_from_argv(FData, argc, argv);
end;

procedure TCefCommandLineRef.InitFromString(const commandLine : ustring);
Var
  c : TCefString;
begin
  c := CefString(commandLine);
  PCefCommandLine(FData)^.init_from_string(FData, @c);
end;

procedure TCefCommandLineRef.Reset;
begin
  PCefCommandLine(FData)^.reset(FData);
end;

procedure TCefCommandLineRef.GetArgv(argv : TStrings);
Var
  list: TCefStringList;
  i   : Integer;
  str : TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefCommandLine(FData)^.get_argv(FData, list);
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      argv.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefCommandLineRef.GetCommandLineString : ustring;
begin
  Result := CefStringFreeAndGet(PCefCommandLine(FData)^.get_command_line_string(FData));
end;

function TCefCommandLineRef.GetProgram : ustring;
begin
  Result := CefStringFreeAndGet(PCefCommandLine(FData)^.get_program(FData));
end;

procedure TCefCommandLineRef.SetProgram(const program_ : ustring);
Var
  p: TCefString;
begin
  p := CefString(program_);
  PCefCommandLine(FData)^.set_program(FData, @p);
end;

function TCefCommandLineRef.HasSwitches : Boolean;
begin
  Result := PCefCommandLine(FData)^.has_switches(FData) <> 0;
end;

function TCefCommandLineRef.HasSwitch(const name : ustring) : Boolean;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := PCefCommandLine(FData)^.has_switch(FData, @n) <> 0;
end;

function TCefCommandLineRef.GetSwitchValue(const name : ustring) : ustring;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(PCefCommandLine(FData)^.get_switch_value(FData, @n));
end;

procedure TCefCommandLineRef.GetSwitches(switches : ICefStringMap);
begin
  PCefCommandLine(FData)^.get_switches(FData, switches.Handle);
end;

procedure TCefCommandLineRef.AppendSwitch(const name : ustring);
Var
  n: TCefString;
begin
  n := CefString(name);
  PCefCommandLine(FData)^.append_switch(FData, @n);
end;

procedure TCefCommandLineRef.AppendSwitchWithValue(const name, value : ustring);
Var
  n, v: TCefString;
begin
  n := CefString(name);
  v := CefString(value);
  PCefCommandLine(FData)^.append_switch_with_value(FData, @n, @v);
end;

function TCefCommandLineRef.HasArguments : Boolean;
begin
  Result := PCefCommandLine(FData)^.has_arguments(FData) <> 0;
end;

procedure TCefCommandLineRef.GetArguments(arguments : TStrings);
Var
  list: TCefStringList;
  i   : Integer;
  str : TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefCommandLine(FData)^.get_arguments(FData, list);
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      arguments.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefCommandLineRef.AppendArgument(const argument : ustring);
Var
  a: TCefString;
begin
  a := CefString(argument);
  PCefCommandLine(FData)^.append_argument(FData, @a);
end;

procedure TCefCommandLineRef.PrependWrapper(const wrapper : ustring);
Var
  w: TCefString;
begin
  w := CefString(wrapper);
  PCefCommandLine(FData)^.prepend_wrapper(FData, @w);
end;

class function TCefCommandLineRef.UnWrap(data : Pointer) : ICefCommandLine;
begin
  If data <> nil then Result := Create(data) as ICefCommandLine
  Else Result := nil;
end;

class function TCefCommandLineRef.New : ICefCommandLine;
begin
  Result := UnWrap(cef_command_line_create());
end;

class function TCefCommandLineRef.Global : ICefCommandLine;
begin
  Result := UnWrap(cef_command_line_get_global());
end;

{ TCefContextMenuParamsRef }

function TCefContextMenuParamsRef.GetXCoord : Integer;
begin
  Result := PCefContextMenuParams(FData)^.get_xcoord(FData);
end;

function TCefContextMenuParamsRef.GetYCoord : Integer;
begin
  Result := PCefContextMenuParams(FData)^.get_ycoord(FData);
end;

function TCefContextMenuParamsRef.GetTypeFlags : TCefContextMenuTypeFlags;
begin
  Result := PCefContextMenuParams(FData)^.get_type_flags(FData);
end;

function TCefContextMenuParamsRef.GetLinkUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_link_url(FData));
end;

function TCefContextMenuParamsRef.GetUnfilteredLinkUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_unfiltered_link_url(FData));
end;

function TCefContextMenuParamsRef.GetSourceUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_source_url(FData));
end;

function TCefContextMenuParamsRef.HasImageContents : Boolean;
begin
  Result := PCefContextMenuParams(FData)^.has_image_contents(FData) <> 0;
end;

function TCefContextMenuParamsRef.GetPageUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_page_url(FData));
end;

function TCefContextMenuParamsRef.GetFrameUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_frame_url(FData));
end;

function TCefContextMenuParamsRef.GetFrameCharset : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_frame_charset(FData));
end;

function TCefContextMenuParamsRef.GetMediaType : TCefContextMenuMediaType;
begin
  Result := PCefContextMenuParams(FData)^.get_media_type(FData);
end;

function TCefContextMenuParamsRef.GetMediaStateFlags : TCefContextMenuMediaStateFlags;
begin
  Result := PCefContextMenuParams(FData)^.get_media_state_flags(FData);
end;

function TCefContextMenuParamsRef.GetSelectionText : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(FData)^.get_selection_text(FData));
end;

function TCefContextMenuParamsRef.IsEditable : Boolean;
begin
  Result := PCefContextMenuParams(FData)^.is_editable(FData) <> 0;
end;

function TCefContextMenuParamsRef.IsSpeechInputEnabled : Boolean;
begin
  Result := PCefContextMenuParams(FData)^.is_speech_input_enabled(FData) <> 0;
end;

function TCefContextMenuParamsRef.GetEditStateFlags : TCefContextMenuEditStateFlags;
begin
  Result := PCefContextMenuParams(FData)^.get_edit_state_flags(FData);
end;

class function TCefContextMenuParamsRef.UnWrap(data : Pointer) : ICefContextMenuParams;
begin
  If data <> nil then Result := Create(data) as ICefContextMenuParams
  Else Result := nil;
end;

{ TCefCookieManagerRef }

procedure TCefCookieManagerRef.SetSupportedSchemes(schemes : TStrings);
Var
  list : TCefStringList;
  i    : Integer;
  item : TCefString;
begin
  list := cef_string_list_alloc();
  try
    If (schemes <> nil) then
      For i := 0 to schemes.Count - 1 do
      begin
        item := CefString(schemes[i]);
        cef_string_list_append(list, @item);
      end;
    PCefCookieManager(FData)^.set_supported_schemes(FData, list);
  finally
    cef_string_list_free(list);
  end;
end;

function TCefCookieManagerRef.VisitAllCookies(const visitor : ICefCookieVisitor) : Boolean;
begin
  Result := PCefCookieManager(FData)^.visit_all_cookies(FData, CefGetData(visitor)) <> 0;
end;

function TCefCookieManagerRef.VisitAllCookiesProc(const visitor : TCefCookieVisitorProc) : Boolean;
begin
  Result := VisitAllCookies(TCefFastCookieVisitor.Create(visitor) as ICefCookieVisitor);
end;

function TCefCookieManagerRef.VisitUrlCookies(const url : ustring;
  includeHttpOnly : Boolean; const visitor : ICefCookieVisitor) : Boolean;
Var
  u : TCefString;
begin
  u := CefString(url);
  Result := PCefCookieManager(FData)^.visit_url_cookies(FData, @u, Ord(includeHttpOnly), CefGetData(visitor)) <> 0;
end;

function TCefCookieManagerRef.VisitUrlCookiesProc(const url : ustring;
  includeHttpOnly : Boolean; const visitor : TCefCookieVisitorProc) : Boolean;
begin
  Result := VisitUrlCookies(url, includeHttpOnly, TCefFastCookieVisitor.Create(visitor) as ICefCookieVisitor);
end;

function TCefCookieManagerRef.SetCookie(const url : ustring;
  const name, value, domain, path : ustring;
  secure, httponly, hasExpires : Boolean;
  const creation, lastAccess, expires : TDateTime) : Boolean;
Var
  u : TCefString;
  c : TCefCookie;
begin
  u := CefString(url);
  c.name := CefString(name);
  c.value := CefString(value);
  c.domain := CefString(domain);
  c.path := CefString(path);
  c.secure := Ord(secure);
  c.httponly := Ord(httponly);
  c.creation := DateTimeToCefTime(creation);
  c.last_access := DateTimeToCefTime(lastAccess);
  c.has_expires := Ord(hasExpires);

  If hasExpires then c.expires := DateTimeToCefTime(expires)
  Else FillChar(c.expires, SizeOf(TCefTime), 0);

  Result := PCefCookieManager(FData)^.set_cookie(FData, @u, @c) <> 0;
end;

function TCefCookieManagerRef.DeleteCookies(const url, cookieName : ustring) : Boolean;
Var
  u, n : TCefString;
begin
  u := CefString(url);
  n := CefString(cookieName);
  Result := PCefCookieManager(FData)^.delete_cookies(FData, @u, @n) <> 0;
end;

function TCefCookieManagerRef.SetStoragePath(const path : ustring; PersistSessionCookies : Boolean) : Boolean;
Var
  p   : TCefString;
begin
  p := CefString(path);
  If path <> '' then Result := PCefCookieManager(FData)^.set_storage_path(FData, @p, Ord(PersistSessionCookies)) <> 0
  Else Result := PCefCookieManager(FData)^.set_storage_path(FData, nil, Ord(PersistSessionCookies)) <> 0;
end;

function TCefCookieManagerRef.FlushStore(handler : ICefCompletionHandler) : Boolean;
begin
  Result := PCefCookieManager(FData)^.flush_store(FData, CefGetData(handler)) <> 0;
end;

class function TCefCookieManagerRef.UnWrap(data : Pointer) : ICefCookieManager;
begin
  If data <> nil then Result := Create(data) as ICefCookieManager
  Else Result := nil;
end;

class function TCefCookieManagerRef.Global : ICefCookieManager;
begin
  Result := UnWrap(cef_cookie_manager_get_global_manager());
end;

class function TCefCookieManagerRef.New(const path : ustring; persistSessionCookies : Boolean) : ICefCookieManager;
Var
  p : TCefString;
begin
  p := CefString(path);
  Result := UnWrap(cef_cookie_manager_create_manager(@p, Ord(persistSessionCookies)));
end;

{ TCefFileDialogCallbackRef }

procedure TCefFileDialogCallbackRef.Cont(filePaths : TStrings);
Var
  list : TCefStringList;
  i    : Integer;
  item : TCefString;
begin
  list := cef_string_list_alloc();
  try
    For i := 0 to filePaths.Count - 1 do
    begin
      item := CefString(filePaths[i]);
      cef_string_list_append(list, @item);
    end;
    PCefFileDialogCallback(FData)^.cont(FData, list);
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefFileDialogCallbackRef.Cancel;
begin
  PCefFileDialogCallback(FData)^.cancel(FData);
end;

class function TCefFileDialogCallbackRef.UnWrap(data : Pointer) : ICefFileDialogCallback;
begin
  If data <> nil then Result := Create(data) as ICefFileDialogCallBack
  Else Result := nil;
end;

{ TCefDomDocumentRef }

function TCefDomDocumentRef.GetType : TCefDomDocumentType;
begin
  Result := PCefDomDocument(FData)^.get_type(FData);
end;

function TCefDomDocumentRef.GetDocument : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_document(FData));
end;

function TCefDomDocumentRef.GetBody : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_body(FData));
end;

function TCefDomDocumentRef.GetHead : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_head(FData));
end;

function TCefDomDocumentRef.GetTitle : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_title(FData));
end;

function TCefDomDocumentRef.GetElementById(const id : ustring) : ICefDomNode;
Var
  i : TCefString;
begin
  i := CefString(id);
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_element_by_id(FData, @i));
end;

function TCefDomDocumentRef.GetFocusedNode : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_focused_node(FData));
end;

function TCefDomDocumentRef.HasSelection : Boolean;
begin
  Result := PCefDomDocument(FData)^.has_selection(FData) <> 0;
end;

function TCefDomDocumentRef.GetSelectionStartNode : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_selection_start_node(FData));
end;

function TCefDomDocumentRef.GetSelectionStartOffset : Integer;
begin
  Result := PCefDomDocument(FData)^.get_selection_start_offset(FData);
end;

function TCefDomDocumentRef.GetSelectionEndNode : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(FData)^.get_selection_end_node(FData));
end;

function TCefDomDocumentRef.GetSelectionEndOffset : Integer;
begin
  Result := PCefDomDocument(FData)^.get_selection_end_offset(FData);
end;

function TCefDomDocumentRef.GetSelectionAsMarkup : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_selection_as_markup(FData));
end;

function TCefDomDocumentRef.GetSelectionAsText : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_selection_as_text(FData));
end;

function TCefDomDocumentRef.GetBaseUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_base_url(FData));
end;

function TCefDomDocumentRef.GetCompleteUrl(const partialURL : ustring) : ustring;
Var
  p : TCefString;
begin
  p := CefString(partialURL);
  Result := CefStringFreeAndGet(PCefDomDocument(FData)^.get_complete_url(FData, @p));
end;

class function TCefDomDocumentRef.UnWrap(data : Pointer) : ICefDomDocument;
begin
  If data <> nil then Result := Create(data) as ICefDomDocument
  Else Result := nil;
end;

{ TCefDomNodeRef }

function TCefDomNodeRef.GetType : TCefDomNodeType;
begin
  Result := PCefDomNode(FData)^.get_type(FData);
end;

function TCefDomNodeRef.IsText : Boolean;
begin
  Result := PCefDomNode(FData)^.is_text(FData) <> 0;
end;

function TCefDomNodeRef.IsElement : Boolean;
begin
  Result := PCefDomNode(FData)^.is_element(FData) <> 0;
end;

function TCefDomNodeRef.IsEditable : Boolean;
begin
  Result := PCefDomNode(FData)^.is_editable(FData) <> 0;
end;

function TCefDomNodeRef.IsFormControlElement : Boolean;
begin
  Result := PCefDomNode(FData)^.is_form_control_element(FData) <> 0;
end;

function TCefDomNodeRef.GetFormControlElementType : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_form_control_element_type(FData));
end;

function TCefDomNodeRef.IsSame(const that : ICefDomNode) : Boolean;
begin
  Result := PCefDomNode(FData)^.is_same(FData, CefGetData(that)) <> 0;
end;

function TCefDomNodeRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_name(FData));
end;

function TCefDomNodeRef.GetValue : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_value(FData));
end;

function TCefDomNodeRef.SetValue(const value : ustring) : Boolean;
Var
  v: TCefString;
begin
  v := CefString(value);
  Result := PCefDomNode(FData)^.set_value(FData, @v) <> 0;
end;

function TCefDomNodeRef.GetAsMarkup : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_as_markup(FData));
end;

function TCefDomNodeRef.GetDocument : ICefDomDocument;
begin
  Result := TCefDomDocumentRef.UnWrap(PCefDomNode(FData)^.get_document(FData));
end;

function TCefDomNodeRef.GetParent : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_parent(FData));
end;

function TCefDomNodeRef.GetPreviousSibling : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_previous_sibling(FData));
end;

function TCefDomNodeRef.GetNextSibling : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_next_sibling(FData));
end;

function TCefDomNodeRef.HasChildren : Boolean;
begin
  Result := PCefDomNode(FData)^.has_children(FData) <> 0;
end;

function TCefDomNodeRef.GetFirstChild : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_first_child(FData));
end;

function TCefDomNodeRef.GetLastChild : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(FData)^.get_last_child(FData));
end;

procedure TCefDomNodeRef.AddEventListener(const eventType : ustring;
  useCapture : Boolean; const listener : ICefDomEventListener);
Var
  e : TCefString;
begin
  e := CefString(eventType);
  PCefDomNode(FData)^.add_event_listener(FData, @e, CefGetData(listener), Ord(useCapture));
end;

procedure TCefDomNodeRef.AddEventListenerProc(const eventType : ustring;
  useCapture : Boolean; const proc : TCefDomEventListenerProc);
begin
  AddEventListener(eventType, useCapture, TCefFastDomEventListener.Create(proc) as ICefDomEventListener);
end;

function TCefDomNodeRef.GetElementTagName : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_element_tag_name(FData));
end;

function TCefDomNodeRef.HasElementAttributes : Boolean;
begin
  Result := PCefDomNode(FData)^.has_element_attributes(FData) <> 0;
end;

function TCefDomNodeRef.HasElementAttribute(const attrName : ustring) : Boolean;
Var
  a : TCefString;
begin
  a := CefString(attrName);
  Result := PCefDomNode(FData)^.has_element_attribute(FData, @a) <> 0;
end;

function TCefDomNodeRef.GetElementAttribute(const attrName : ustring) : ustring;
Var
  a : TCefString;
begin
  a := CefString(attrName);
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_element_attribute(FData, @a));
end;

procedure TCefDomNodeRef.GetElementAttributes(const attrMap : ICefStringMap);
begin
  PCefDomNode(FData)^.get_element_attributes(FData, attrMap.Handle);
end;

function TCefDomNodeRef.SetElementAttribute(const attrName, value : ustring) : Boolean;
Var
  a, v : TCefString;
begin
  a := CefString(attrName);
  v := CefString(value);
  Result := PCefDomNode(FData)^.set_element_attribute(FData, @a, @v) <> 0;
end;

function TCefDomNodeRef.GetElementInnerText : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(FData)^.get_element_inner_text(FData));
end;

class function TCefDomNodeRef.UnWrap(data : Pointer) : ICefDomNode;
begin
  If data <> nil then Result := Create(data) as ICefDomNode
  Else Result := nil;
end;

{ TCefDomEventRef }

function TCefDomEventRef.GetType : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomEvent(FData)^.get_type(FData));
end;

function TCefDomEventRef.GetCategory : TCefDomEventCategory;
begin
  Result := PCefDomEvent(FData)^.get_category(FData);
end;

function TCefDomEventRef.GetPhase : TCefDomEventPhase;
begin
  Result := PCefDomEvent(FData)^.get_phase(FData);
end;

function TCefDomEventRef.CanBubble : Boolean;
begin
  Result := PCefDomEvent(FData)^.can_bubble(FData) <> 0;
end;

function TCefDomEventRef.CanCancel : Boolean;
begin
  Result := PCefDomEvent(FData)^.can_cancel(FData) <> 0;
end;

function TCefDomEventRef.GetDocument : ICefDomDocument;
begin
  Result := TCefDomDocumentRef.UnWrap(PCefDomEvent(FData)^.get_document(FData));
end;

function TCefDomEventRef.GetTarget : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomEvent(FData)^.get_target(FData));
end;

function TCefDomEventRef.GetCurrentTarget : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomEvent(FData)^.get_current_target(FData));
end;

class function TCefDomEventRef.UnWrap(data : Pointer) : ICefDomEvent;
begin
  If data <> nil then Result := Create(data) as ICefDomEvent
  Else Result := nil;
end;

{ TCefBeforeDownloadCallbackRef }

procedure TCefBeforeDownloadCallbackRef.Cont(const downloadPath : ustring; showDialog : Boolean);
Var
  d : TCefString;
begin
  d := CefString(downloadPath);
  PCefBeforeDownloadCallback(FData)^.cont(FData, @d, Ord(showDialog));
end;

class function TCefBeforeDownloadCallbackRef.UnWrap(data : Pointer) : ICefBeforeDownloadCallback;
begin
  If data <> nil then Result := Create(data) as ICefBeforeDownloadCallback
  Else Result := nil;
end;

{ TCefDownloadItemCallbackRef }

procedure TCefDownloadItemCallbackRef.Cancel;
begin
  PCefDownloadItemCallback(FData)^.cancel(FData);
end;

class function TCefDownloadItemCallbackRef.UnWrap(data : Pointer) : ICefDownloadItemCallback;
begin
  If data <> nil then Result := Create(data) as ICefDownloadItemCallback
  Else Result := nil;
end;

{ TCefDownLoadItemRef }

function TCefDownLoadItemRef.IsValid : Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_valid(FData) <> 0;
end;

function TCefDownLoadItemRef.IsInProgress : Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_in_progress(FData) <> 0;
end;

function TCefDownLoadItemRef.IsComplete : Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_complete(FData) <> 0;
end;

function TCefDownLoadItemRef.IsCanceled : Boolean;
begin
  Result := PCefDownloadItem(FData)^.is_canceled(FData) <> 0;
end;

function TCefDownLoadItemRef.GetCurrentSpeed : Int64;
begin
  Result := PCefDownloadItem(FData)^.get_current_speed(FData);
end;

function TCefDownLoadItemRef.GetPercentComplete : Integer;
begin
  Result := PCefDownloadItem(FData)^.get_percent_complete(FData);
end;

function TCefDownLoadItemRef.GetTotalBytes : Int64;
begin
  Result := PCefDownloadItem(FData)^.get_total_bytes(FData);
end;

function TCefDownLoadItemRef.GetReceivedBytes : Int64;
begin
  Result := PCefDownloadItem(FData)^.get_received_bytes(FData);
end;

function TCefDownLoadItemRef.GetStartTime : TDateTime;
begin
  Result := CefTimeToDateTime(PCefDownloadItem(FData)^.get_start_time(FData));
end;

function TCefDownLoadItemRef.GetEndTime : TDateTime;
begin
  Result := CefTimeToDateTime(PCefDownloadItem(FData)^.get_end_time(FData));
end;

function TCefDownLoadItemRef.GetFullPath : ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_full_path(FData));
end;

function TCefDownloadItemRef.GetId : UInt32;
begin
  Result := PCefDownloadItem(FData)^.get_id(FData);
end;

function TCefDownLoadItemRef.GetUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_url(FData));
end;

function TCefDownLoadItemRef.GetSuggestedFileName : ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_suggested_file_name(FData));
end;

function TCefDownLoadItemRef.GetContentDisposition : ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_content_disposition(FData));
end;

function TCefDownLoadItemRef.GetMimeType : ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(FData)^.get_mime_type(FData));
end;

class function TCefDownLoadItemRef.UnWrap(data: Pointer): ICefDownLoadItem;
begin
  If data <> nil then Result := Create(data) as ICefDownloadItem
  Else Result := nil;
end;

{ TCefDragDataRef }

function TCefDragDataRef.IsLink: Boolean;
begin
  Result := PCefDragData(FData)^.is_link(FData) <> 0;
end;

function TCefDragDataRef.IsFragment: Boolean;
begin
  Result := PCefDragData(FData)^.is_fragment(FData) <> 0;
end;

function TCefDragDataRef.IsFile: Boolean;
begin
  Result := PCefDragData(FData)^.is_file(FData) <> 0;
end;

function TCefDragDataRef.GetLinkUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_link_url(FData));
end;

function TCefDragDataRef.GetLinkTitle: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_link_title(FData));
end;

function TCefDragDataRef.GetLinkMetadata: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_link_metadata(FData));
end;

function TCefDragDataRef.GetFragmentText: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_fragment_text(FData));
end;

function TCefDragDataRef.GetFragmentHTML: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_fragment_html(FData));
end;

function TCefDragDataRef.GetFragmentBaseURL: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_fragment_base_url(FData));
end;

function TCefDragDataRef.GetFileName: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(FData)^.get_file_name(FData));
end;

function TCefDragDataRef.GetFileNames(names: TStrings): Boolean;
Var
  list: TCefStringList;
  i   : Integer;
  str : TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefDragData(FData)^.get_file_names(FData, list) <> 0;
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      names.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

class function TCefDragDataRef.UnWrap(data: Pointer): ICefDragData;
begin
  If data <> nil then Result := Create(data) as ICefDragData
  Else Result := nil;
end;

{ TCefFrameRef }

function TCefFrameRef.IsValid : Boolean;
begin
  Result := PCefFrame(FData)^.is_valid(FData) <> 0;
end;

procedure TCefFrameRef.Undo;
begin
  PCefFrame(FData)^.undo(FData);
end;

procedure TCefFrameRef.Redo;
begin
  PCefFrame(FData)^.redo(FData);
end;

procedure TCefFrameRef.Cut;
begin
  PCefFrame(FData)^.cut(FData);
end;

procedure TCefFrameRef.Copy;
begin
  PCefFrame(FData)^.copy(FData);
end;

procedure TCefFrameRef.Paste;
begin
  PCefFrame(FData)^.paste(FData);
end;

procedure TCefFrameRef.Del;
begin
  PCefFrame(FData)^.del(FData);
end;

procedure TCefFrameRef.SelectAll;
begin
  PCefFrame(FData)^.select_all(FData);
end;

procedure TCefFrameRef.ViewSource;
begin
  PCefFrame(FData)^.view_source(FData);
end;

procedure TCefFrameRef.GetSource(const visitor : ICefStringVisitor);
begin
  PCefFrame(FData)^.get_source(FData, CefGetData(visitor));
end;

procedure TCefFrameRef.GetSourceProc(const proc : TCefStringVisitorProc);
begin
  GetSource(TCefFastStringVisitor.Create(proc));
end;

procedure TCefFrameRef.GetText(const visitor : ICefStringVisitor);
begin
  PCefFrame(FData)^.get_text(FData, CefGetData(visitor));
end;

procedure TCefFrameRef.GetTextProc(const proc : TCefStringVisitorProc);
begin
  GetText(TCefFastStringVisitor.Create(proc));
end;

procedure TCefFrameRef.LoadRequest(const request : ICefRequest);
begin
  PCefFrame(FData)^.load_request(FData, CefGetData(request));
end;

procedure TCefFrameRef.LoadUrl(const url : ustring);
Var
  u : TCefString;
begin
  u := CefString(url);
  PCefFrame(FData)^.load_url(FData, @u);
end;

procedure TCefFrameRef.LoadString(const str, url : ustring);
Var
  s, u : TCefString;
begin
  s := CefString(str);
  u := CefString(url);
  PCefFrame(FData)^.load_string(FData, @s, @u);
end;

procedure TCefFrameRef.ExecuteJavaScript(const code, scriptUrl : ustring;
  startLine : Integer);
Var
  j, s : TCefString;
begin
  j := CefString(code);
  s := CefString(scriptUrl);
  PCefFrame(FData)^.execute_java_script(FData, @j, @s, startLine);
end;

function TCefFrameRef.IsMain : Boolean;
begin
  Result := PCefFrame(FData)^.is_main(FData) <> 0;
end;

function TCefFrameRef.IsFocused : Boolean;
begin
  Result := PCefFrame(FData)^.is_focused(FData) <> 0;
end;

function TCefFrameRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_name(FData));
end;

function TCefFrameRef.GetIdentifier : Int64;
begin
  Result := PCefFrame(FData)^.get_identifier(FData);
end;

function TCefFrameRef.GetParent : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefFrame(FData)^.get_parent(FData));
end;

function TCefFrameRef.GetUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_url(FData));
end;

function TCefFrameRef.GetBrowser : ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefFrame(FData)^.get_browser(FData));
end;

function TCefFrameRef.GetV8Context : ICefv8Context;
begin
  Result := TCefv8ContextRef.UnWrap(PCefFrame(FData)^.get_v8context(FData));
end;

procedure TCefFrameRef.VisitDom(const visitor : ICefDomVisitor);
begin
  PCefFrame(FData)^.visit_dom(PCefFrame(FData), CefGetData(visitor));
end;

procedure TCefFrameRef.VisitDomProc(const proc : TCefDomVisitorProc);
begin
  VisitDom(TCefFastDomVisitor.Create(proc) as ICefDomVisitor);
end;

class function TCefFrameRef.UnWrap(data : Pointer) : ICefFrame;
begin
  If data <> nil then Result := Create(data) as ICefFrame
  Else Result := nil;
end;

{ TCefGeolocationCallbackRef }

procedure TCefGeolocationCallbackRef.Cont(allow : Boolean);
begin
  PCefGeolocationCallback(FData)^.cont(FData, Ord(allow));
end;

class function TCefGeolocationCallbackRef.UnWrap(data : Pointer) : ICefGeolocationCallback;
begin
  If data <> nil then Result := Create(data) as ICefGeolocationCallback
  Else Result := nil;
end;

{ TCefJsDialogCallbackRef }

procedure TCefJsDialogCallbackRef.Cont(success : Boolean; const userInput : ustring);
Var
  u : TCefString;
begin
  u := CefString(userInput);
  PCefJsDialogCallback(FData)^.cont(FData, Ord(success), @u);
end;

class function TCefJsDialogCallbackRef.UnWrap(data : Pointer) : ICefJsDialogCallback;
begin
  If data <> nil then Result := Create(data) as ICefJsDialogCallback
  Else Result := nil;
end;

{ TCefMenuModelRef }

function TCefMenuModelRef.Clear : Boolean;
begin
  Result := PCefMenuModel(FData)^.clear(FData) <> 0;
end;

function TCefMenuModelRef.GetCount : Integer;
begin
  Result := PCefMenuModel(FData)^.get_count(FData);
end;

function TCefMenuModelRef.AddSeparator : Boolean;
begin
  Result := PCefMenuModel(FData)^.add_separator(FData) <> 0;
end;

function TCefMenuModelRef.AddItem(commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.add_item(FData, commandId, @t) <> 0;
end;

function TCefMenuModelRef.AddCheckItem(commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.add_check_item(FData, commandId, @t) <> 0;
end;

function TCefMenuModelRef.AddRadioItem(commandId : Integer;
  const text : ustring; groupId : Integer) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.add_radio_item(FData, commandId, @t, groupId) <> 0;
end;

function TCefMenuModelRef.AddSubMenu(commandId : Integer;
  const text : ustring) : ICefMenuModel;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.add_sub_menu(FData, commandId, @t));
end;

function TCefMenuModelRef.InsertSeparatorAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.insert_separator_at(FData, index) <> 0;
end;

function TCefMenuModelRef.InsertItemAt(index, commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.insert_item_at(FData, index, commandId, @t) <> 9;
end;

function TCefMenuModelRef.InsertCheckItemAt(index, commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.insert_check_item_at(FData, index, commandId, @t) <> 9;
end;

function TCefMenuModelRef.InsertRadioItemAt(index, commandId : Integer;
  const text : ustring; groupId : Integer) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.insert_radio_item_at(FData, index, commandId, @t, groupId) <> 9;
end;

function TCefMenuModelRef.InsertSubMenuAt(index, commandId : Integer;
  const text : ustring) : ICefMenuModel;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.insert_sub_menu_at(FData, index, commandId, @t));
end;

function TCefMenuModelRef.Remove(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.remove(FData, commandId) <> 0;
end;

function TCefMenuModelRef.RemoveAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.remove_at(FData, index) <> 0;
end;

function TCefMenuModelRef.GetIndexOf(commandId : Integer) : Integer;
begin
  Result := PCefMenuModel(FData)^.get_index_of(FData, commandId);
end;

function TCefMenuModelRef.GetCommandIdAt(index : Integer) : Integer;
begin
  Result := PCefMenuModel(FData)^.get_command_id_at(FData, index);
end;

function TCefMenuModelRef.SetCommandIdAt(index, commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_command_id_at(FData, index, commandId) <> 0;
end;

function TCefMenuModelRef.GetLabel(commandId : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefMenuModel(FData)^.get_label(FData, commandId));
end;

function TCefMenuModelRef.GetLabelAt(index : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefMenuModel(FData)^.get_label_at(FData, index));
end;

function TCefMenuModelRef.SetLabel(commandId : Integer; const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.set_label(FData, commandId, @t) <> 0;
end;

function TCefMenuModelRef.SetLabelAt(index : Integer; const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(FData)^.set_label_at(FData, index, @t) <> 0;
end;

function TCefMenuModelRef.GetType(commandId : Integer) : TCefMenuItemType;
begin
  Result := PCefMenuModel(FData)^.get_type(FData, commandId);
end;

function TCefMenuModelRef.GetTypeAt(index : Integer) : TCefMenuItemType;
begin
  Result := PCefMenuModel(FData)^.get_type_at(FData, index);
end;

function TCefMenuModelRef.GetGroupId(commandId : Integer) : Integer;
begin
  Result := PCefMenuModel(FData)^.get_group_id(FData, commandId);
end;

function TCefMenuModelRef.GetGroupIdAt(index : Integer) : Integer;
begin
  Result := PCefMenuModel(FData)^.get_group_id_at(FData, index);
end;

function TCefMenuModelRef.SetGroupId(commandId, groupId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_group_id(FData, commandId, groupId) <> 0;
end;

function TCefMenuModelRef.SetGroupIdAt(index, groupId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_group_id_at(FData, index, groupId) <> 0;
end;

function TCefMenuModelRef.GetSubMenu(commandId : Integer) : ICefMenuModel;
begin
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.get_sub_menu(FData, commandId));
end;

function TCefMenuModelRef.GetSubMenuAt(index : Integer) : ICefMenuModel;
begin
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(FData)^.get_sub_menu_at(FData, index));
end;

function TCefMenuModelRef.IsVisible(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.is_visible(FData, commandId) <> 0;
end;

function TCefMenuModelRef.isVisibleAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.is_visible_at(FData, index) <> 0;
end;

function TCefMenuModelRef.SetVisible(commandId : Integer; visible : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_visible(FData, commandId, Ord(visible)) <> 0;
end;

function TCefMenuModelRef.SetVisibleAt(index : Integer; visible : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_visible_at(FData, index, Ord(visible)) <> 0;
end;

function TCefMenuModelRef.IsEnabled(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.is_enabled(FData, commandId) <> 0;
end;

function TCefMenuModelRef.IsEnabledAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.is_enabled_at(FData, index) <> 0;
end;

function TCefMenuModelRef.SetEnabled(commandId : Integer; enabled : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_enabled(FData, commandId, Ord(enabled)) <> 0;
end;

function TCefMenuModelRef.SetEnabledAt(index : Integer; enabled : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_enabled_at(FData, index, Ord(enabled)) <> 0;
end;

function TCefMenuModelRef.IsChecked(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.is_checked(FData, commandId) <> 0;
end;

function TCefMenuModelRef.IsCheckedAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.is_checked_at(FData, index) <> 0;
end;

function TCefMenuModelRef.setChecked(commandId : Integer;
  checked : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_checked(FData, commandId, Ord(checked)) <> 0;
end;

function TCefMenuModelRef.setCheckedAt(index : Integer; checked : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_checked_at(FData, index, Ord(checked)) <> 0;
end;

function TCefMenuModelRef.HasAccelerator(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.has_accelerator(FData, commandId) <> 0;
end;

function TCefMenuModelRef.HasAcceleratorAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.has_accelerator_at(FData, index) <> 0;
end;

function TCefMenuModelRef.SetAccelerator(commandId, keyCode : Integer;
  shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_accelerator(FData, commandId, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TCefMenuModelRef.SetAcceleratorAt(index, keyCode : Integer;
  shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
begin
  Result := PCefMenuModel(FData)^.set_accelerator_at(FData, index, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TCefMenuModelRef.RemoveAccelerator(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.remove_accelerator(FData, commandId) <> 0;
end;

function TCefMenuModelRef.RemoveAcceleratorAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(FData)^.remove_accelerator_at(FData, index) <> 0;
end;

function TCefMenuModelRef.GetAccelerator(commandId : Integer;
  out keyCode : Integer; out shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
Var
  sp, cp, ap : Integer;
begin
  Result := PCefMenuModel(FData)^.get_accelerator(FData, commandId, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TCefMenuModelRef.GetAcceleratorAt(index : Integer;
  out keyCode : Integer; out shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
Var
  sp, cp, ap : Integer;
begin
  Result := PCefMenuModel(FData)^.get_accelerator_at(FData, index, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

class function TCefMenuModelRef.UnWrap(data : Pointer) : ICefMenuModel;
begin
  If data <> nil then Result := Create(data) as ICefMenuModel
  Else Result := nil;
end;

{ TCefProcessMessageRef }

function TCefProcessMessageRef.IsValid : Boolean;
begin
  Result := PCefProcessMessage(FData)^.is_valid(FData) <> 0;
end;

function TCefProcessMessageRef.IsReadOnly : Boolean;
begin
  Result := PCefProcessMessage(FData)^.is_read_only(FData) <> 0;
end;

function TCefProcessMessageRef.Copy : ICefProcessMessage;
begin
  Result := UnWrap(PCefProcessMessage(FData)^.copy(FData));
end;

function TCefProcessMessageRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefProcessMessage(FData)^.get_name(FData));
end;

function TCefProcessMessageRef.GetArgumentList : ICefListValue;
begin
  Result := TCefListValueRef.UnWrap(PCefProcessMessage(FData)^.get_argument_list(FData));
end;

class function TCefProcessMessageRef.UnWrap(data : Pointer) : ICefProcessMessage;
begin
  If data <> nil then Result := Create(data) as ICefProcessMessage
  Else Result := nil;
end;

class function TCefProcessMessageRef.New(const name : ustring) : ICefProcessMessage;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := UnWrap(cef_process_message_create(@n));
end;

{ TCefRequestRef }

function TCefRequestRef.IsReadOnly : Boolean;
begin
  Result := PCefRequest(FData)^.is_read_only(FData) <> 0;
end;

function TCefRequestRef.GetUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_url(FData));
end;

function TCefRequestRef.GetMethod : ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_method(FData));
end;

function TCefRequestRef.GetPostData : ICefPostData;
begin
  Result := TCefPostDataRef.UnWrap(PCefRequest(FData)^.get_post_data(FData));
end;

procedure TCefRequestRef.GetHeaderMap(const HeaderMap : ICefStringMultimap);
begin
  PCefRequest(FData)^.get_header_map(FData, HeaderMap.Handle);
end;

procedure TCefRequestRef.SetUrl(const value : ustring);
Var
  v : TCefString;
begin
  v := CefString(value);
  PCefRequest(FData)^.set_url(FData, @v);
end;

procedure TCefRequestRef.SetMethod(const value : ustring);
Var
  v : TCefString;
begin
  v := CefString(value);
  PCefRequest(FData)^.set_method(FData, @v);
end;

procedure TCefRequestRef.SetPostData(const value : ICefPostData);
begin
  If value <> nil then
    PCefRequest(FData)^.set_post_data(FData, CefGetData(value));
end;

procedure TCefRequestRef.SetHeaderMap(const HeaderMap : ICefStringMultimap);
begin
  PCefRequest(FData)^.set_header_map(FData, HeaderMap.Handle);
end;

function TCefRequestRef.GetFlags : TCefUrlRequestFlags;
begin
  Result := PCefRequest(FData)^.get_flags(FData);
end;

procedure TCefRequestRef.SetFlags(flags : TCefUrlRequestFlags);
begin
  PCefRequest(FData)^.set_flags(FData, PByte(@flags)^);
end;

function TCefRequestRef.GetFirstPartyForCookies : ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_first_party_for_cookies(FData));
end;

procedure TCefRequestRef.SetFirstPartyForCookies(const url : ustring);
Var
  u : TCefString;
begin
  u := CefString(url);
  PCefRequest(FData)^.set_first_party_for_cookies(FData, @u);
end;

function TCefRequestRef.GetResourceType : TCefResourceType;
begin
  Result := PCefRequest(FData)^.get_resource_type(FData);
end;

function TCefRequestRef.GetTransitionType : TCefTransitionType;
begin
  Result := PCefRequest(FData)^.get_transition_type(FData);
end;

procedure TCefRequestRef.Assign(const url, method : ustring;
  const postData : ICefPostData; const headerMap : ICefStringMultimap);
Var
  u, m : TCefString;
begin
  u := CefString(url);
  m := CefString(method);
  PCefRequest(FData)^.set_(FData, @u, @m, CefGetData(postData), headerMap.Handle);
end;

class function TCefRequestRef.UnWrap(data : Pointer) : ICefRequest;
begin
  If data <> nil then Result := Create(data) as ICefRequest
  Else Result := nil;
end;

class function TCefRequestRef.New : ICefRequest;
begin
  Result := UnWrap(cef_request_create());
end;

{ TCefPostDataRef }

function TCefPostDataRef.IsReadOnly : Boolean;
begin
  Result := PCefPostData(FData)^.is_read_only(FData) <> 0;
end;

function TCefPostDataRef.GetElementCount : TSize;
begin
  Result := PCefPostData(FData)^.get_element_count(FData);
end;

function TCefPostDataRef.GetElements(Count : TSize) : IInterfaceList;
Var
  items : PCefPostDataElementArray;
  i     : Integer;
begin
  Result := TInterfaceList.Create;
  GetMem(items, SizeOf(PCefPostDataElement) * Count);
  FillChar(items^, SizeOf(PCefPostDataElement) * Count, 0);

  try
    PCefPostData(FData)^.get_elements(FData, @Count, items);
    For i := 0 to Count - 1 do
      Result.Add(TCefPostDataElementRef.UnWrap(items^[i]));
  finally
    FreeMem(items);
  end;
end;

function TCefPostDataRef.RemoveElement(const element : ICefPostDataElement) : Integer;
begin
  Result := PCefPostData(FData)^.remove_element(FData, CefGetData(element));
end;

function TCefPostDataRef.AddElement(const element : ICefPostDataElement) : Integer;
begin
  Result := PCefPostData(FData)^.add_element(FData, CefGetData(element));
end;

procedure TCefPostDataRef.RemoveElements;
begin
  PCefPostData(FData)^.remove_elements(FData);
end;

class function TCefPostDataRef.UnWrap(data : Pointer) : ICefPostData;
begin
  If data <> nil then Result := Create(data) as ICefPostData
  Else Result := nil;
end;

class function TCefPostDataRef.New : ICefPostData;
begin
  Result := UnWrap(cef_post_data_create());
end;

{ TCefPostDataElementRef }

function TCefPostDataElementRef.IsReadOnly : Boolean;
begin
  Result := PCefPostDataElement(FData)^.is_read_only(FData) <> 0;
end;

procedure TCefPostDataElementRef.SetToEmpty;
begin
  PCefPostDataElement(FData)^.set_to_empty(FData);
end;

procedure TCefPostDataElementRef.SetToFile(const fileName : ustring);
Var
  f : TCefString;
begin
  f := CefString(fileName);
  PCefPostDataElement(FData)^.set_to_file(FData, @f);
end;

procedure TCefPostDataElementRef.SetToBytes(size : TSize; const bytes : Pointer);
begin
  PCefPostDataElement(FData)^.set_to_bytes(FData, size, bytes);
end;

function TCefPostDataElementRef.GetType : TCefPostDataElementType;
begin
  Result := PCefPostDataElement(FData)^.get_type(FData);
end;

function TCefPostDataElementRef.GetFile : ustring;
begin
  Result := CefStringFreeAndGet(PCefPostDataElement(FData)^.get_file(FData));
end;

function TCefPostDataElementRef.GetBytesCount : TSize;
begin
  Result := PCefPostDataElement(FData)^.get_bytes_count(FData);
end;

function TCefPostDataElementRef.GetBytes(size : TSize; bytes : Pointer) : TSize;
begin
  Result := PCefPostDataElement(FData)^.get_bytes(FData, size, bytes);
end;

class function TCefPostDataElementRef.UnWrap(data : Pointer) : ICefPostDataElement;
begin
  If data <> nil then Result := Create(data) as ICefPostDataElement
  Else Result := nil;
end;

class function TCefPostDataElementRef.New : ICefPostDataElement;
begin
  Result := UnWrap(cef_post_data_element_create());
end;

{ TCefRequestContextRef }

function TCefRequestContextRef.IsSame(other : ICefRequestContext) : Boolean;
begin
  Result := PCefRequestContext(FData)^.is_same(PCefRequestContext(FData), CefGetData(other)) <> 0;
end;

function TCefRequestContextRef.IsGlobal : Boolean;
begin
  Result := PCefRequestContext(FData)^.is_global(PCefRequestContext(FData)) <> 0;
end;

function TCefRequestContextRef.GetHandler : ICefRequestContextHandler;
begin
  Result := TCefRequestContextHandlerRef.UnWrap(PCefRequestContext(FData)^.get_handler(PCefRequestContext(FData)));
end;

class function TCefRequestContextRef.UnWrap(data : Pointer) : ICefRequestContext;
begin
  If data <> nil then Result := Create(data) as ICefRequestContext
  Else Result := nil;
end;

{ TCefRequestContextHandlerRef }

function TCefRequestContextHandlerRef.GetCookieManager : ICefCookieManager;
begin
  Result := TCefCookieManagerRef.UnWrap(PCefRequestContextHandler(FData)^.get_cookie_manager(FData));
end;

class function TCefRequestContextHandlerRef.UnWrap(data : Pointer) : ICefRequestContextHandler;
begin
  If data <> nil then Result := Create(data) as ICefRequestContextHandler
  Else Result := nil;
end;

{ TCefAuthCallbackRef }

procedure TCefAuthCallbackRef.Cont(const username, password : ustring);
Var
  u, p : TCefString;
begin
  u := CefString(username);
  p := CefString(password);
  PCefAuthCallback(FData)^.cont(FData, @u, @p);
end;

procedure TCefAuthCallbackRef.Cancel;
begin
  PCefAuthCallback(FData)^.cancel(FData);
end;

class function TCefAuthCallbackRef.UnWrap(data : Pointer) : ICefAuthCallback;
begin
  If data <> nil then Result := Create(data) as ICefAuthCallback
  Else Result := nil;
end;

{ TCefQuotaCallbackRef }

procedure TCefQuotaCallbackRef.Cont(allow : Boolean);
begin
  PCefQuotaCallback(FData)^.cont(FData, Ord(allow));
end;

procedure TCefQuotaCallbackRef.Cancel;
begin
  PCefQuotaCallback(FData)^.cancel(FData);
end;

class function TCefQuotaCallbackRef.UnWrap(data : Pointer) : ICefQuotaCallback;
begin
  If data <> nil then Result := Create(data) as ICefQuotaCallback
  Else Result := nil;
end;

{ TCefResponseRef }

function TCefResponseRef.IsReadOnly : Boolean;
begin
  Result := PCefResponse(FData)^.is_read_only(FData) <> 0;
end;

function TCefResponseRef.GetStatus : Integer;
begin
  Result := PCefResponse(FData)^.get_status(FData);
end;

procedure TCefResponseRef.SetStatus(status : Integer);
begin
  PCefResponse(FData)^.set_status(FData, status);
end;

function TCefResponseRef.GetStatusText : ustring;
begin
  Result := CefStringFreeAndGet(PCefResponse(FData)^.get_status_text(FData));
end;

procedure TCefResponseRef.SetStatusText(const StatusText : ustring);
Var
  s : TCefString;
begin
  s := CefString(StatusText);
  PCefResponse(FData)^.set_status_text(FData, @s);
end;

function TCefResponseRef.GetMimeType : ustring;
begin
  Result := CefStringFreeAndGet(PCefResponse(FData)^.get_mime_type(FData));
end;

procedure TCefResponseRef.SetMimeType(const mimetype : ustring);
Var
  m : TCefString;
begin
  m := CefString(mimetype);
  PCefResponse(FData)^.set_mime_type(FData, @m);
end;

function TCefResponseRef.GetHeader(const name : ustring) : ustring;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(PCefResponse(FData)^.get_header(FData, @n));
end;

procedure TCefResponseRef.GetHeaderMap(const headerMap : ICefStringMultimap);
begin
  PCefResponse(FData)^.get_header_map(FData, headerMap.Handle);
end;

procedure TCefResponseRef.SetHeaderMap(const headerMap : ICefStringMultimap);
begin
  PCefResponse(FData)^.set_header_map(FData, headerMap.Handle);
end;

class function TCefResponseRef.UnWrap(data : Pointer) : ICefResponse;
begin
  If data <> nil then Result := Create(data) as ICefResponse
  Else Result := nil;
end;

class function TCefResponseRef.New : ICefResponse;
begin
  Result := UnWrap(cef_response_create());
end;

{ TCefSchemeRegistrarRef }

function TCefSchemeRegistrarRef.AddCustomScheme(const schemeName : ustring;
  IsStandard, IsLocal, IsDisplayIsolated : Boolean) : Boolean; cconv;
Var
  s : TCefString;
begin
  s := CefString(schemeName);
  Result := PCefSchemeRegistrar(FData)^.add_custom_scheme(FData, @s, Ord(IsStandard), Ord(IsLocal), Ord(IsDisplayIsolated)) <> 0;
end;

class function TCefSchemeRegistrarRef.UnWrap(data : Pointer) : ICefSchemeRegistrar;
begin
  If data <> nil then Result := Create(data) as ICefSchemeRegistrar
  Else Result := nil;
end;

{ TCefStreamReaderRef }

function TCefStreamReaderRef.Read(ptr : Pointer; size, n : TSize) : TSize;
begin
  Result := PCefStreamReader(FData)^.read(FData, ptr, size, n);
end;

function TCefStreamReaderRef.Seek(offset : Int64; whence : Integer) : Integer;
begin
  Result := PCefStreamReader(FData)^.seek(FData, offset, whence);
end;

function TCefStreamReaderRef.Tell : Int64;
begin
  Result := PCefStreamReader(FData)^.tell(FData);
end;

function TCefStreamReaderRef.Eof : Boolean;
begin
  Result := PCefStreamReader(FData)^.eof(FData) <> 0;
end;

function TCefStreamReaderRef.MayBlock : Boolean;
begin
  Result := True;
end;

class function TCefStreamReaderRef.UnWrap(data : Pointer) : ICefStreamReader;
begin
  If data <> nil then Result := Create(data) as ICefStreamReader
  Else Result := nil;
end;

class function TCefStreamReaderRef.CreateForFile(const filename : ustring) : ICefStreamReader;
Var
  f : TCefString;
begin
  f := CefString(filename);
  Result := UnWrap(cef_stream_reader_create_for_file(@f));
end;

class function TCefStreamReaderRef.CreateForCustomStream(const stream : ICefCustomStreamReader) : ICefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_handler(CefGetData(stream)));
end;

class function TCefStreamReaderRef.CreateForStream(const stream : TSTream;
  owned : Boolean) : ICefStreamReader;
begin
  Result := CreateForCustomStream(TCefCustomStreamReader.Create(stream, owned) as ICefCustomStreamReader);
end;

class function TCefStreamReaderRef.CreateForData(data : Pointer;
  size : Cardinal) : ICefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_data(data, size));
end;

{ TCefTaskRef }

procedure TCefTaskRef.Execute;
begin
  PCefTask(FData)^.execute(FData);
end;

class function TCefTaskRef.UnWrap(data : Pointer) : ICefTask;
begin
  If data <> nil then Result := Create(data) as ICefTask
  Else Result := nil;
end;

{ TCefTaskRunnerRef }

function TCefTaskRunnerRef.IsSame(that : ICefTaskRunner) : Boolean;
begin
  Result := PCefTaskRunner(FData)^.is_same(FData, CefGetData(that)) <> 0;
end;

function TCefTaskRunnerRef.BelongsToCurrentThread : Boolean;
begin
  Result := PCefTaskRunner(FData)^.belongs_to_current_thread(FData) <> 0;
end;

function TCefTaskRunnerRef.BelongsToThread(ThreadID : TCefThreadID) : Boolean;
begin
  Result := PCefTaskRunner(FData)^.belongs_to_thread(FData, ThreadID) <> 0;
end;

function TCefTaskRunnerRef.PostTask(task : ICefTask) : Integer;
begin
  Result := PCefTaskRunner(FData)^.post_task(FData, CefGetData(task));
end;

function TCefTaskRunnerRef.PostDelayedTask(task : ICefTask; delay_ms : Int64) : Integer;
begin
  Result := PCefTaskRunner(FData)^.post_delayed_task(FData, CefGetData(task), delay_ms);
end;

class function TCefTaskRunnerRef.UnWrap(data : Pointer) : ICefTaskRunner;
begin
  If data <> nil then Result := Create(data) as ICefTaskRunner
  Else Result := nil;
end;

class function TCefTaskRunnerRef.GetForThread(const ThreadID : TCefThreadID) : ICefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_thread(ThreadID));
end;

class function TCefTaskRunnerRef.GetForCurrentThread : ICefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_current_thread());
end;

{ TCefUrlRequestRef }

function TCefUrlRequestRef.GetRequest : ICefRequest;
begin
  Result := TCefRequestRef.UnWrap(PCefUrlRequest(FData)^.get_request(FData));
end;

function TCefUrlRequestRef.GetClient : ICefUrlrequestClient;
begin
  Result := TCefUrlRequestClientRef.UnWrap(PCefUrlRequest(FData)^.get_client(FData));
end;

function TCefUrlRequestRef.GetRequestStatus : TCefUrlRequestStatus;
begin
  Result := PCefUrlRequest(FData)^.get_request_status(FData);
end;

function TCefUrlRequestRef.GetRequestError : TCefErrorCode;
begin
  Result := PCefUrlRequest(FData)^.get_request_error(FData);
end;

function TCefUrlRequestRef.GetResponse : ICefResponse;
begin
  Result := TCefResponseRef.UnWrap(PCefUrlRequest(FData)^.get_response(FData));
end;

procedure TCefUrlRequestRef.Cancel;
begin
  PCefUrlRequest(FData)^.cancel(FData);
end;

class function TCefUrlRequestRef.UnWrap(data : Pointer) : ICefUrlRequest;
begin
  If data <> nil then Result := Create(data) as ICefUrlRequest
  Else Result := nil;
end;

class function TCefUrlRequestRef.New(const request : ICefRequest;
  const client : ICefUrlRequestClient) : ICefUrlRequest;
begin
  Result := UnWrap(cef_urlrequest_create(CefGetData(request), CefGetData(client)));
end;

{ TCefUrlRequestClientRef }

procedure TCefUrlRequestClientRef.OnRequestComplete(const request : ICefUrlRequest);
begin
  PCefUrlRequestClient(FData)^.on_request_complete(FData, CefGetData(request));
end;

procedure TCefUrlRequestClientRef.OnUploadProgress(const request : ICefUrlRequest;
  current, total : UInt64);
begin
  PCefUrlRequestClient(FData)^.on_upload_progress(FData, CefGetData(request), current, total);
end;

procedure TCefUrlRequestClientRef.OnDownloadProgress(const request : ICefUrlRequest;
  current, total : UInt64);
begin
  PCefUrlRequestClient(FData)^.on_download_progress(FData, CefGetData(request), current, total);
end;

procedure TCefUrlRequestClientRef.OnDownloadData(const request : ICefUrlRequest;
  data : Pointer; dataLength : TSize);
begin
  PCefUrlRequestClient(FData)^.on_download_data(FData, CefGetData(request), data, dataLength);
end;

function TCefUrlRequestClientRef.GetAuthCredentials(isProxy : Boolean;
  const host : ustring; port : Integer; const realm, scheme : ustring;
  callback : ICefAuthCallback) : Boolean;
Var
  h, r, s: TCefString;
begin
  h := CefString(host);
  r := CefString(realm);
  s := CefString(scheme);
  Result := PCefUrlRequestClient(FData)^.get_auth_credentials(FData, Ord(isProxy), @h, port, @r, @s, CefGetData(callback)) <> 0;
end;

class function TCefUrlRequestClientRef.UnWrap(data : Pointer) : ICefUrlRequestClient;
begin
  If data <> nil then Result := Create(data) as ICefUrlRequestClient
  Else Result := nil;
end;

{ TCefv8ContextRef }

function TCefv8ContextRef.GetTaskRunner : ICefTaskRunner;
begin
  Result := TCefTaskRunnerRef.UnWrap(PCefV8Context(FData)^.get_task_runner(FData));
end;

function TCefv8ContextRef.IsValid : boolean;
begin
  Result := PCefV8Context(FData)^.is_valid(FData) <> 0;
end;

function TCefv8ContextRef.GetBrowser : ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefV8Context(FData)^.get_browser(FData));
end;

function TCefv8ContextRef.GetFrame : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefV8Context(FData)^.get_frame(FData));
end;

function TCefv8ContextRef.GetGlobal : ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Context(FData)^.get_global(FData));
end;

function TCefv8ContextRef.Enter : Boolean;
begin
  Result := PCefV8Context(FData)^.enter(FData) <> 0;
end;

function TCefv8ContextRef.Exit : Boolean;
begin
  Result := PCefV8Context(FData)^.exit(FData) <> 0;
end;

function TCefv8ContextRef.IsSame(const that : ICefv8Context) : Boolean;
begin
  Result := PCefV8Context(FData)^.is_same(FData, CefGetData(that)) <> 0;
end;

function TCefv8ContextRef.Eval(const code : ustring; var retval : ICefv8Value;
  var exception : ICefV8Exception) : Boolean;
Var
  c : TCefString;
  r : PCefV8Value;
  e : PCefV8Exception;
begin
  c := CefString(code);
  r := nil;
  e := nil;
  Result := PCefV8Context(FData)^.eval(FData, @c, r, e) <> 0;
  retval := TCefv8ValueRef.UnWrap(r);
  exception := TCefV8ExceptionRef.UnWrap(e);
end;

class function TCefv8ContextRef.UnWrap(data : Pointer) : ICefv8Context;
begin
  If data <> nil then Result := Create(data) as ICefv8Context
  Else Result := nil;
end;

class function TCefv8ContextRef.Current : ICefv8Context;
begin
  Result := UnWrap(cef_v8context_get_current_context());
end;

class function TCefv8ContextRef.Entered : ICefv8Context;
begin
  Result := UnWrap(cef_v8context_get_entered_context());
end;

{ TCefv8HandlerRef }

function TCefv8HandlerRef.Execute(const name : ustring;
  const obj : ICefv8Value; const arguments : TCefv8ValueArray;
  var retval : ICefv8Value; var exception : ustring) : Boolean;
Var
  args : array of PCefV8Value;
  i    : Integer;
  ret  : PCefV8Value;
  exc  : TCefString;
  n    : TCefString;
begin
  SetLength(args, Length(arguments));
  For i := 0 to Length(arguments) - 1 do
  begin
    args[i] := CefGetData(arguments[i]);
  end;
  ret := nil;
  FillChar(exc, SizeOf(exc), 0);
  n := CefString(name);
  Result := PCefV8Handler(FData)^.execute(FData, @n, CefGetData(obj), Length(arguments), @args, ret, exc) <> 0;
  retval := TCefv8ValueRef.UnWrap(ret);
  exception := CefStringClearAndGet(exc);
end;

class function TCefv8HandlerRef.UnWrap(data : Pointer) : ICefv8Handler;
begin
  If data <> nil then Result := Create(data) as ICefv8Handler
  Else Result := nil;
end;

{ TCefFastV8Accessor }

function TCefFastV8Accessor.Get(const name : ustring; const obj : ICefv8Value;
  out value : ICefv8Value; const exception : string) : Boolean;
begin
  If Assigned(FGetter) then Result := FGetter(name, obj, value, exception)
  Else Result := False;
end;

function TCefFastV8Accessor.Put(const name : ustring;
  const obj, value : ICefv8Value; const exception : string) : Boolean;
begin
  If Assigned(FSetter) then FSetter(name, obj, value, exception)
  Else Result := False;
end;

constructor TCefFastV8Accessor.Create(const getter : TCefV8AccessorGetterProc;
  const setter : TCefV8AccessorSetterProc);
begin
  FGetter := getter;
  FSetter := setter;
end;

{ TCefV8ExceptionRef }

function TCefV8ExceptionRef.GetMessage : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(FData)^.get_message(FData));
end;

function TCefV8ExceptionRef.GetSourceLine : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(FData)^.get_source_line(FData));
end;

function TCefV8ExceptionRef.GetScriptResourceName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(FData)^.get_script_resource_name(FData));
end;

function TCefV8ExceptionRef.GetLineNumber : Integer;
begin
  Result := PCefV8Exception(FData)^.get_line_number(FData);
end;

function TCefV8ExceptionRef.GetStartPosition : Integer;
begin
  Result := PCefV8Exception(FData)^.get_start_position(FData);
end;

function TCefV8ExceptionRef.GetEndPosition : Integer;
begin
  Result := PCefV8Exception(FData)^.get_end_position(FData);
end;

function TCefV8ExceptionRef.GetStartColumn : Integer;
begin
  Result := PCefV8Exception(FData)^.get_start_column(FData);
end;

function TCefV8ExceptionRef.GetEndColumn : Integer;
begin
  Result := PCefV8Exception(FData)^.get_end_column(FData);
end;

class function TCefV8ExceptionRef.UnWrap(data : Pointer) : ICefV8Exception;
begin
  If data <> nil then Result := Create(data) as ICefV8Exception
  Else Result := nil;
end;

{ TCefv8ValueRef }

function TCefv8ValueRef.IsValid : boolean;
begin
  Result := PCefV8Value(FData)^.is_valid(FData) <> 0;
end;

function TCefv8ValueRef.IsUndefined : Boolean;
begin
  Result := PCefV8Value(FData)^.is_undefined(FData) <> 0;
end;

function TCefv8ValueRef.IsNull : Boolean;
begin
  Result := PCefV8Value(FData)^.is_null(FData) <> 0;
end;

function TCefv8ValueRef.IsBool : Boolean;
begin
  Result := PCefV8Value(FData)^.is_bool(FData) <> 0;
end;

function TCefv8ValueRef.IsInt : Boolean;
begin
  Result := PCefV8Value(FData)^.is_int(FData) <> 0;
end;

function TCefv8ValueRef.IsUInt : Boolean;
begin
  Result := PCefV8Value(FData)^.is_uint(FData) <> 0;
end;

function TCefv8ValueRef.IsDouble : Boolean;
begin
  Result := PCefV8Value(FData)^.is_double(FData) <> 0;
end;

function TCefv8ValueRef.IsDate : Boolean;
begin
  Result := PCefV8Value(FData)^.is_date(FData) <> 0;
end;

function TCefv8ValueRef.IsString : Boolean;
begin
  Result := PCefV8Value(FData)^.is_string(FData) <> 0;
end;

function TCefv8ValueRef.IsObject : Boolean;
begin
  Result := PCefV8Value(FData)^.is_object(FData) <> 0;
end;

function TCefv8ValueRef.IsArray : Boolean;
begin
  Result := PCefV8Value(FData)^.is_array(FData) <> 0;
end;

function TCefv8ValueRef.IsFunction : Boolean;
begin
  Result := PCefV8Value(FData)^.is_function(FData) <> 0;
end;

function TCefv8ValueRef.IsSame(const that : ICefv8Value) : Boolean;
begin
  Result := PCefV8Value(FData)^.is_same(FData, CefGetData(that)) <> 0;
end;

function TCefv8ValueRef.GetBoolValue : Boolean;
begin
  Result := PCefV8Value(FData)^.get_bool_value(FData) <> 0;
end;

function TCefv8ValueRef.GetIntValue : Integer;
begin
  Result := PCefV8Value(FData)^.get_int_value(FData);
end;

function TCefv8ValueRef.GetUIntValue : Cardinal;
begin
  Result := PCefV8Value(FData)^.get_uint_value(FData);
end;

function TCefv8ValueRef.GetDoubleValue : Double;
begin
  Result := PCefV8Value(FData)^.get_double_value(FData);
end;

function TCefv8ValueRef.GetDateValue : TDateTime;
begin
  Result := CefTimeToDateTime(PCefV8Value(FData)^.get_date_value(FData));
end;

function TCefv8ValueRef.GetStringValue : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(FData)^.get_string_value(FData));
end;

function TCefv8ValueRef.IsUserCreated : Boolean;
begin
  Result := PCefV8Value(FData)^.is_user_created(FData) <> 0;
end;

function TCefv8ValueRef.HasException : Boolean;
begin
  Result := PCefV8Value(FData)^.has_exception(FData) <> 0;
end;

function TCefv8ValueRef.GetException : ICefV8Exception;
begin
  Result := TCefV8ExceptionRef.UnWrap(PCefV8Value(FData)^.get_exception(FData));
end;

function TCefv8ValueRef.ClearException : Boolean;
begin
  Result := PCefV8Value(FData)^.clear_exception(FData) <> 0;
end;

function TCefv8ValueRef.WillRethrowExceptions : Boolean;
begin
  Result := PCefV8Value(FData)^.will_rethrow_exceptions(FData) <> 0;
end;

function TCefv8ValueRef.SetRethrowExceptions(rethrow : Boolean) : Boolean;
begin
  Result := PCefV8Value(FData)^.set_rethrow_exceptions(FData, Ord(rethrow)) <> 0;
end;

function TCefv8ValueRef.HasValueByKey(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(FData)^.has_value_bykey(FData, @k) <> 0;
end;

function TCefv8ValueRef.HasValueByIndex(index : Integer) : Boolean;
begin
  Result := PCefV8Value(FData)^.has_value_byindex(FData, index) <> 0;
end;

function TCefv8ValueRef.DeleteValueByKey(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(FData)^.delete_value_bykey(FData, @k) <> 0;
end;

function TCefv8ValueRef.DeleteValueByIndex(index : Integer) : Boolean;
begin
  Result := PCefV8Value(FData)^.delete_value_byindex(FData, index) <> 0;
end;

function TCefv8ValueRef.GetValueByKey(const key : ustring) : ICefv8Value;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_value_bykey(FData, @k));
end;

function TCefv8ValueRef.GetValueByIndex(index : Integer) : ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_value_byindex(FData, index));
end;

function TCefv8ValueRef.SetValueByKey(const key : ustring;
  const value : ICefv8Value; attribute : TCefV8PropertyAttribute) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(FData)^.set_value_bykey(FData, @k, CefGetData(value), attribute) <> 0;
end;

function TCefv8ValueRef.SetValueByIndex(index : Integer; const value : ICefv8Value) : Boolean;
begin
  Result := PCefV8Value(FData)^.set_value_byindex(FData, index, CefGetData(value)) <> 0;
end;

function TCefv8ValueRef.SetValueByAccessor(const key : ustring;
  settings : TCefV8AccessControl; attribute : TCefV8PropertyAttribute) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(FData)^.set_value_byaccessor(FData, @k, settings, attribute) <> 0;
end;

function TCefv8ValueRef.GetKeys(const keys : TStrings) : Integer;
Var
  list : TCefStringList;
  i    : Integer;
  item : TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefV8Value(FData)^.get_keys(FData, list);
    FillChar(item, SizeOf(item), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @item);
      keys.Add(CefStringClearAndGet(item));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefv8ValueRef.SetUserData(const data : ICefv8Value) : Boolean;
begin
  Result := PCefV8Value(FData)^.set_user_data(FData, CefGetData(data)) <> 0;
end;

function TCefv8ValueRef.GetUserData : ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_user_data(FData));
end;

function TCefv8ValueRef.GetExternallyAllocatedMemory : Integer;
begin
  Result := PCefV8Value(FData)^.get_externally_allocated_memory(FData);
end;

function TCefv8ValueRef.AdjustExternallyAllocatedMemory(changeInBytes : Integer) : Integer;
begin
  Result := PCefV8Value(FData)^.adjust_externally_allocated_memory(FData, changeInBytes);
end;

function TCefv8ValueRef.GetArrayLength : Integer;
begin
  Result := PCefV8Value(FData)^.get_array_length(FData);
end;

function TCefv8ValueRef.GetFunctionName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(FData)^.get_function_name(FData));
end;

function TCefv8ValueRef.GetFunctionHandler : ICefv8Handler;
begin
  Result := TCefv8HandlerRef.UnWrap(PCefV8Value(FData)^.get_function_handler(FData));
end;

function TCefv8ValueRef.ExecuteFunction(const obj : ICefv8Value;
  const arguments : TCefv8ValueArray) : ICefv8Value;
Var
  args : PPCefV8Value;
  i    : Integer;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  try
    For i := 0 to Length(arguments) - 1 do
    begin
      args^[i] := CefGetData(arguments[i]);
    end;
    Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.execute_function(FData, CefGetData(obj), Length(arguments), args));
  finally
    FreeMem(args);
  end;
end;

function TCefv8ValueRef.ExecuteFunctionWithContext(const context : ICefv8Context;
  const obj : ICefv8Value; const arguments : TCefv8ValueArray) : ICefv8Value;
Var
  args : PPCefV8Value;
  i    : Integer;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  try
    For i := 0 to Length(arguments) - 1 do
    begin
      args^[i] := CefGetData(arguments[i]);
    end;
    Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.execute_function_with_context(FData, CefGetData(context), CefGetData(obj), Length(arguments), args));
  finally
    FreeMem(args);
  end;
end;

class function TCefv8ValueRef.UnWrap(data : Pointer) : ICefv8Value;
begin
  If data <> nil then Result := Create(data) as ICefv8Value
  Else Result := nil;
end;

class function TCefv8ValueRef.NewUndefined : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_undefined());
end;

class function TCefv8ValueRef.NewNull : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_null());
end;

class function TCefv8ValueRef.NewBool(value : Boolean) : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_bool(Ord(value)));
end;

class function TCefv8ValueRef.NewInt(value : Integer) : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_int(value));
end;

class function TCefv8ValueRef.NewUInt(value : Cardinal) : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_uint(value));
end;

class function TCefv8ValueRef.NewDouble(value : Double) : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_double(value));
end;

class function TCefv8ValueRef.NewDate(value : TDateTime) : ICefv8Value;
Var
  dt : TCefTime;
begin
  dt := DateTimeToCefTime(value);
  Result := UnWrap(cef_v8value_create_date(@dt));
end;

class function TCefv8ValueRef.NewString(const str : ustring) : ICefv8Value;
Var
  s : TCefString;
begin
  s := CefString(str);
  Result := UnWrap(cef_v8value_create_string(@s));
end;

class function TCefv8ValueRef.NewObject(const Accessor : ICefV8Accessor) : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_object(CefGetData(Accessor)));
end;

class function TCefv8ValueRef.NewObjectProc(const getter : TCefV8AccessorGetterProc;
  const setter : TCefV8AccessorSetterProc) : ICefv8Value;
begin
  Result := NewObject(TCefFastv8Accessor.Create(getter, setter) as ICefV8Accessor);
end;

class function TCefv8ValueRef.NewArray(len : Integer) : ICefv8Value;
begin
  Result := UnWrap(cef_v8value_create_array(len));
end;

class function TCefv8ValueRef.NewFunction(const name : ustring;
  const handler : ICefv8Handler) : ICefv8Value;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := UnWrap(cef_v8value_create_function(@n, CefGetData(handler)));
end;

{ TCefV8StackTraceRef }

function TCefV8StackTraceRef.IsValid : Boolean;
begin
  Result := PCefV8StackTrace(FData)^.is_valid(FData) <> 0;
end;

function TCefV8StackTraceRef.GetFrameCount : Integer;
begin
  Result := PCefV8StackTrace(FData)^.get_frame_count(FData);
end;

function TCefV8StackTraceRef.GetFrame(index : Integer) : ICefV8StackFrame;
begin
  Result := TCefV8StackFrameRef.UnWrap(PCefV8StackTrace(FData)^.get_frame(FData, index));
end;

class function TCefV8StackTraceRef.UnWrap(data : Pointer) : ICefV8StackTrace;
begin
  If data <> nil then Result := Create(data) as ICefV8StackTrace
  Else Result := nil;
end;

class function TCefV8StackTraceRef.Current(frameLimit : Integer) : ICefV8StackTrace;
begin
  Result := UnWrap(cef_v8stack_trace_get_current(frameLimit));
end;

{ TCefV8StackFrameRef }

function TCefV8StackFrameRef.IsValid : Boolean;
begin
  Result := PCefV8StackFrame(FData)^.is_valid(FData) <> 0;
end;

function TCefV8StackFrameRef.GetScriptName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(FData)^.get_script_name(FData));
end;

function TCefV8StackFrameRef.GetScriptNameOrSourceUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(FData)^.get_script_name_or_source_url(FData));
end;

function TCefV8StackFrameRef.GetFunctionName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(FData)^.get_function_name(FData));
end;

function TCefV8StackFrameRef.GetLineNumber : Integer;
begin
  Result := PCefV8StackFrame(FData)^.get_line_number(FData);
end;

function TCefV8StackFrameRef.GetColumn : Integer;
begin
  Result := PCefV8StackFrame(FData)^.get_column(FData);
end;

function TCefV8StackFrameRef.IsEval : Boolean;
begin
  Result := PCefV8StackFrame(FData)^.is_eval(FData) <> 0;
end;

function TCefV8StackFrameRef.IsConstructor : Boolean;
begin
  Result := PCefV8StackFrame(FData)^.is_constructor(FData) <> 0;
end;

class function TCefV8StackFrameRef.UnWrap(data : Pointer) : ICefV8StackFrame;
begin
  If data <> nil then Result := Create(data) as ICefV8StackFrame
  Else Result := nil;
end;

{ TCefBinaryValueRef }

function TCefBinaryValueRef.IsValid : Boolean;
begin
  Result := PCefBinaryValue(FData)^.is_valid(FData) <> 0;
end;

function TCefBinaryValueRef.IsOwned : Boolean;
begin
  Result := PCefBinaryValue(FData)^.is_owned(FData) <> 0;
end;

function TCefBinaryValueRef.Copy : ICefBinaryValue;
begin
  Result := UnWrap(PCefBinaryValue(FData)^.copy(FData));
end;

function TCefBinaryValueRef.GetSize : TSize;
begin
  Result := PCefBinaryValue(FData)^.get_size(FData);
end;

function TCefBinaryValueRef.GetData(buffer : Pointer; bufferSize, dataOffset : TSize) : TSize;
begin
  Result := PCefBinaryValue(FData)^.get_data(FData, buffer, bufferSize, dataOffset);
end;

class function TCefBinaryValueRef.UnWrap(data : Pointer) : ICefBinaryValue;
begin
  If data <> nil then Result := Create(data) as ICefBinaryValue
  Else Result := nil;
end;

class function TCefBinaryValueRef.New(const data : Pointer; dataSize : Cardinal) : ICefBinaryValue;
begin
  Result := UnWrap(cef_binary_value_create(data, dataSize));
end;

{ TCefDictionaryValueRef }

function TCefDictionaryValueRef.IsValid : Boolean;
begin
  Result := PCefDictionaryValue(FData)^.is_valid(FData) <> 0;
end;

function TCefDictionaryValueRef.isOwned : Boolean;
begin
  Result := PCefDictionaryValue(FData)^.is_owned(FData) <> 0;
end;

function TCefDictionaryValueRef.IsReadOnly : Boolean;
begin
  Result := PCefDictionaryValue(FData)^.is_read_only(FData) <> 0;
end;

function TCefDictionaryValueRef.Copy(excludeEmptyChildren : Boolean) : ICefDictionaryValue;
begin
  Result := UnWrap(PCefDictionaryValue(FData)^.copy(FData, Ord(excludeEmptyChildren)));
end;

function TCefDictionaryValueRef.GetSize : TSize;
begin
  Result := PCefDictionaryValue(FData)^.get_size(FData);
end;

function TCefDictionaryValueRef.Clear : Boolean;
begin
  Result := PCefDictionaryValue(FData)^.clear(FData) <> 0;
end;

function TCefDictionaryValueRef.HasKey(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.has_key(FData, @k) <> 0;
end;

function TCefDictionaryValueRef.GetKeys(const keys : TStrings) : Boolean;
Var
  list : TCefStringList;
  i    : Integer;
  item : TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefDictionaryValue(FData)^.get_keys(FData, list) <> 0;
    FillChar(item, SizeOf(item), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      FillChar(item, SizeOf(item), 0);
      cef_string_list_value(list, i, @item);
      keys.Add(CefStringClearAndGet(item));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefDictionaryValueRef.Remove(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.remove(FData, @k) <> 0;
end;

function TCefDictionaryValueRef.GetType(const key : ustring) : TCefValueType;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_type(FData, @k);
end;

function TCefDictionaryValueRef.GetBool(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_bool(FData, @k) <> 0;
end;

function TCefDictionaryValueRef.GetInt(const key : ustring) : Integer;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_int(FData, @k);
end;

function TCefDictionaryValueRef.GetDouble(const key : ustring) : Double;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.get_double(FData, @k);
end;

function TCefDictionaryValueRef.GetString(const key : ustring) : ustring;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := CefStringFreeAndGet(PCefDictionaryValue(FData)^.get_string(FData, @k));
end;

function TCefDictionaryValueRef.GetBinary(const key : ustring) : ICefBinaryValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefBinaryValueRef.UnWrap(PCefDictionaryValue(FData)^.get_binary(FData, @k));
end;

function TCefDictionaryValueRef.GetDictionary(const key : ustring) : ICefDictionaryValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := UnWrap(PCefDictionaryValue(FData)^.get_dictionary(FData, @k));
end;

function TCefDictionaryValueRef.GetList(const key : ustring) : ICefListValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefListValueRef.UnWrap(PCefDictionaryValue(FData)^.get_list(FData, @k));
end;

function TCefDictionaryValueRef.SetNull(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_null(FData, @k) <> 0;
end;

function TCefDictionaryValueRef.SetBool(const key : ustring; value : Boolean) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_bool(FData, @k, Ord(value)) <> 0;
end;

function TCefDictionaryValueRef.SetInt(const key : ustring; value : Integer) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_int(FData, @k, value) <> 0;
end;

function TCefDictionaryValueRef.SetDouble(const key : ustring; value : Double) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_double(FData, @k, value) <> 0;
end;

function TCefDictionaryValueRef.SetString(const key, value : ustring) : Boolean;
Var
  k, v : TCefString;
begin
  k := CefString(key);
  v := CefString(value);
  Result := PCefDictionaryValue(FData)^.set_string(FData, @k, @v) <> 0;
end;

function TCefDictionaryValueRef.SetBinary(const key : ustring;
  const value : ICefBinaryValue) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_binary(FData, @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetDictionary(const key : ustring;
  const value : ICefDictionaryValue) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_dictionary(FData, @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetList(const key : ustring;
  const value : ICefListValue) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(FData)^.set_list(FData, @k, CefGetData(value)) <> 0;
end;

class function TCefDictionaryValueRef.UnWrap(data : Pointer) : ICefDictionaryValue;
begin
  If data <> nil then Result := Create(data) as ICefDictionaryValue
  Else Result := nil;
end;

class function TCefDictionaryValueRef.New : ICefDictionaryValue;
begin
  Result := UnWrap(cef_dictionary_value_create());
end;

{ TCefListValueRef }

function TCefListValueRef.IsValid : Boolean;
begin
  Result := PCefListValue(FData)^.is_valid(FData) <> 0;
end;

function TCefListValueRef.IsOwned : Boolean;
begin
  Result := PCefListValue(FData)^.is_owned(FData) <> 0;
end;

function TCefListValueRef.IsReadOnly : Boolean;
begin
  Result := PCefListValue(FData)^.is_read_only(FData) <> 0;
end;

function TCefListValueRef.Copy : ICefListValue;
begin
  Result := UnWrap(PCefListValue(FData)^.copy(FData));
end;

function TCefListValueRef.SetSize(size : TSize) : Boolean;
begin
  Result := PCefListValue(FData)^.set_size(FData, size) <> 0;
end;

function TCefListValueRef.GetSize : TSize;
begin
  Result := PCefListValue(FData)^.get_size(FData);
end;

function TCefListValueRef.Clear : Boolean;
begin
  Result := PCefListValue(FData)^.clear(FData) <> 0;
end;

function TCefListValueRef.Remove(index : Integer) : Boolean;
begin
  Result := PCefListValue(FData)^.remove(FData, index) <> 0;
end;

function TCefListValueRef.GetType(index : Integer) : TCefValueType;
begin
  Result := PCefListValue(FData)^.get_type(FData, index);
end;

function TCefListValueRef.GetBool(index : Integer) : Boolean;
begin
  Result := PCefListValue(FData)^.get_bool(FData, index) <> 0;
end;

function TCefListValueRef.GetInt(index : Integer) : Integer;
begin
  Result := PCefListValue(FData)^.get_int(FData, index);
end;

function TCefListValueRef.GetDouble(index : Integer) : Double;
begin
  Result := PCefListValue(FData)^.get_double(FData, index);
end;

function TCefListValueRef.GetString(index : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefListValue(FData)^.get_string(FData, index));
end;

function TCefListValueRef.GetBinary(index : Integer) : ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefListValue(FData)^.get_binary(FData, index));
end;

function TCefListValueRef.GetDictionary(index : Integer) : ICefDictionaryValue;
begin
  Result := TCefDictionaryValueRef.UnWrap(PCefListValue(FData)^.get_dictionary(FData, index));
end;

function TCefListValueRef.GetList(index : Integer) : ICefListValue;
begin
  Result := UnWrap(PCefListValue(FData)^.get_list(FData, index));
end;

function TCefListValueRef.SetNull(index : Integer) : Boolean;
begin
  Result := PCefListValue(FData)^.set_null(FData, index) <> 0;
end;

function TCefListValueRef.SetBool(index : Integer; value : Boolean) : Boolean;
begin
  Result := PCefListValue(FData)^.set_bool(FData, index, Ord(value)) <> 0;
end;

function TCefListValueRef.SetInt(index, value : Integer) : Boolean;
begin
  Result := PCefListValue(FData)^.set_int(FData, index, value) <> 0;
end;

function TCefListValueRef.SetDouble(index : Integer; value : Double) : Boolean;
begin
  Result := PCefListValue(FData)^.set_double(FData, index, value) <> 0;
end;

function TCefListValueRef.SetString(index : Integer; const value : ustring) : Boolean;
Var
  v : TCefString;
begin
  v := CefString(value);
  Result := PCefListValue(FData)^.set_string(FData, index, @v) <> 0;
end;

function TCefListValueRef.SetBinary(index : Integer; const value : ICefBinaryValue) : Boolean;
begin
  Result := PCefListValue(FData)^.set_binary(FData, index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetDictionary(index : Integer; const value : ICefDictionaryValue) : Boolean;
begin
  Result := PCefListValue(FData)^.set_dictionary(FData, index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetList(index : Integer; const value : ICefListValue) : Boolean;
begin
  Result := PCefListValue(FData)^.set_list(FData, index, CefGetData(value)) <> 0;
end;

class function TCefListValueRef.UnWrap(data : Pointer) : ICefListValue;
begin
  If Data <> nil then Result := Create(data) as ICefListValue
  Else Result := nil;
end;

class function TCefListValueRef.New : ICefListValue;
begin
  Result := UnWrap(cef_list_value_create());
end;

{ TCefWebPluginInfoRef }

function TCefWebPluginInfoRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_name(FData));
end;

function TCefWebPluginInfoRef.GetPath : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_path(FData));
end;

function TCefWebPluginInfoRef.GetVersion : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_version(FData));
end;

function TCefWebPluginInfoRef.GetDescription : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(FData)^.get_description(FData));
end;

class function TCefWebPluginInfoRef.UnWrap(data : Pointer) : ICefWebPluginInfo;
begin
  If data <> nil then Result := Create(data) as ICefWebPluginInfo
  Else Result := nil;
end;

{ TCefXmlReaderRef }

function TCefXmlReaderRef.MoveToNextNode : Boolean;
begin
  Result := PCefXMLReader(FData)^.move_to_next_node(FData) <> 0;
end;

function TCefXmlReaderRef.Close : Boolean;
begin
  Result := PCefXMLReader(FData)^.close(FData) <> 0;
end;

function TCefXmlReaderRef.HasError : Boolean;
begin
  Result := PCefXMLReader(FData)^.has_attributes(FData) <> 0;
end;

function TCefXmlReaderRef.GetError : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_error(FData));
end;

function TCefXmlReaderRef.GetType : TCefXmlNodeType;
begin
  Result := PCefXMLReader(FData)^.get_type(FData);
end;

function TCefXmlReaderRef.GetDepth : Integer;
begin
  Result := PCefXMLReader(FData)^.get_depth(FData);
end;

function TCefXmlReaderRef.GetLocalName : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_local_name(FData));
end;

function TCefXmlReaderRef.GetPrefix : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_prefix(FData));
end;

function TCefXmlReaderRef.GetQualifiedName : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_qualified_name(FData));
end;

function TCefXmlReaderRef.GetNamespaceUri : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_namespace_uri(FData));
end;

function TCefXmlReaderRef.GetBaseUri : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_base_uri(FData));
end;

function TCefXmlReaderRef.GetXmlLang : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_xml_lang(FData));
end;

function TCefXmlReaderRef.IsEmptyElement : Boolean;
begin
  Result := PCefXMLReader(FData)^.is_empty_element(FData) <> 0;
end;

function TCefXmlReaderRef.HasValue : Boolean;
begin
  Result := PCefXMLReader(FData)^.has_value(FData) <> 0;
end;

function TCefXmlReaderRef.GetValue : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_value(FData));
end;

function TCefXmlReaderRef.HasAttributes : Boolean;
begin
  Result := PCefXMLReader(FData)^.has_attributes(FData) <> 0;
end;

function TCefXmlReaderRef.GetAttributeCount : TSize;
begin
  Result := PCefXMLReader(FData)^.get_attribute_count(FData);
end;

function TCefXmlReaderRef.GetAttributeByIndex(index : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_attribute_byindex(FData, index));
end;

function TCefXmlReaderRef.GetAttributeByQName(const qualifiedName : ustring) : ustring;
Var
  q: TCefString;
begin
  q := CefString(qualifiedName);
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_attribute_byqname(FData, @q));
end;

function TCefXmlReaderRef.GetAttributeByLName(const localName, namespaceURI : ustring) : ustring;
Var
  l, n: TCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_attribute_bylname(FData, @l, @n));
end;

function TCefXmlReaderRef.GetInnerXml : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_inner_xml(FData));
end;

function TCefXmlReaderRef.GetOuterXml : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(FData)^.get_outer_xml(FData));
end;

function TCefXmlReaderRef.GetLineNumber : Integer;
begin
  Result := PCefXMLReader(FData)^.get_line_number(FData);
end;

function TCefXmlReaderRef.MoveToAttributeByIndex(index : Integer) : Boolean;
begin
  Result := PCefXMLReader(FData)^.move_to_attribute_byindex(FData, index) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByQName(const qualifiedName : ustring) : Boolean;
Var
  q: TCefString;
begin
  q := CefString(qualifiedName);
  Result := PCefXMLReader(FData)^.move_to_attribute_byqname(FData, @q) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByLName(const localName, namespaceURI : ustring) : Boolean;
Var
  l, n: TCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := PCefXMLReader(FData)^.move_to_attribute_bylname(FData, @l, @n) <> 0;
end;

function TCefXmlReaderRef.MoveToFirstAttribute : Boolean;
begin
  Result := PCefXMLReader(FData)^.move_to_first_attribute(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToNextAttribute : Boolean;
begin
  Result := PCefXMLReader(FData)^.move_to_next_attribute(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToCarryingElement : Boolean;
begin
  Result := PCefXMLReader(FData)^.move_to_carrying_element(FData) <> 0;
end;

class function TCefXmlReaderRef.UnWrap(data : Pointer) : ICefXmlReader;
begin
  If data <> nil then Result := Create(data) as ICefXmlReader
  Else Result := nil;
end;

class function TCefXmlReaderRef.New(const stream : ICefStreamReader;
  encodingType : TCefXmlEncodingType; const URI : ustring) : ICefXmlReader;
Var
  u: TCefString;
begin
  u := CefString(URI);
  Result := UnWrap(cef_xml_reader_create(CefGetData(stream), encodingType, @u));
end;

{ TCefZipReaderRef }

function TCefZipReaderRef.MoveToFirstFile : Boolean;
begin
  Result := PCefZipReader(FData)^.move_to_first_file(FData) <> 0;
end;

function TCefZipReaderRef.MoveToNextFile : Boolean;
begin
  Result := PCefZipReader(FData)^.move_to_next_file(FData) <> 0;
end;

function TCefZipReaderRef.MoveToFile(const fileName : ustring; caseSensitive : Boolean) : Boolean;
Var
  f: TCefString;
begin
  f := CefString(fileName);
  Result := PCefZipReader(FData)^.move_to_file(FData, @f, Ord(caseSensitive)) <> 0;
end;

function TCefZipReaderRef.Close : Boolean;
begin
  Result := PCefZipReader(FData)^.close(FData) <> 0;
end;

function TCefZipReaderRef.GetFileName : ustring;
begin
  Result := CefStringFreeAndGet(PCefZipReader(FData)^.get_file_name(FData));
end;

function TCefZipReaderRef.GetFileSize : Int64;
begin
  Result := PCefZipReader(FData)^.get_file_size(FData);
end;

function TCefZipReaderRef.GetFileLastModified : LongInt;
begin
  Result := PCefZipReader(FData)^.get_file_last_modified(FData);
end;

function TCefZipReaderRef.OpenFile(const password : ustring) : Boolean;
Var
  p: TCefString;
begin
  p := CefString(password);
  Result :=  PCefZipReader(FData)^.open_file(FData, @p) <> 0;
end;

function TCefZipReaderRef.CloseFile : Boolean;
begin
  Result := PCefZipReader(FData)^.close_file(FData) <> 0;
end;

function TCefZipReaderRef.ReadFile(buffer : Pointer; bufferSize : TSize) : Integer;
begin
  Result := PCefZipReader(FData)^.read_file(FData, buffer, bufferSize);
end;

function TCefZipReaderRef.Tell : Int64;
begin
  Result := PCefZipReader(FData)^.tell(FData);
end;

function TCefZipReaderRef.Eof : Boolean;
begin
  Result := PCefZipReader(FData)^.eof(FData) <> 0;
end;

class function TCefZipReaderRef.UnWrap(data : Pointer) : ICefZipReader;
begin
  If data <> nil then Result := Create(data) as ICefZipReader
  Else Result := nil;
end;

class function TCefZipReaderRef.New(const stream : ICefStreamReader) : ICefZipReader;
begin
  Result := UnWrap(cef_zip_reader_create(CefGetData(stream)));
end;

end.
