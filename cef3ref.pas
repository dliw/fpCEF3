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

Unit cef3ref;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils,
  {$IFDEF DEBUG}LCLProc,{$ENDIF}
  cef3api, cef3types, cef3intf, cef3own;

Type
  TCefBaseRef = class(TInterfacedObject, ICefBaseRefCounted)
  private
    fData: Pointer;
  public
    constructor Create(data: Pointer); virtual;
    destructor Destroy; override;
    function Wrap: Pointer;
    class function UnWrap(data: Pointer): ICefBaseRefCounted;
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
    function GetFrameCount: TSize;
    procedure GetFrameIdentifiers(count: PSize; identifiers: PInt64);
    procedure GetFrameNames(names: TStrings);
    function SendProcessMessage(targetProcess: TCefProcessId; message: ICefProcessMessage): Boolean;
  public
    class function UnWrap(data: Pointer): ICefBrowser;
  end;

  TCefBrowserHostRef = class(TCefBaseRef, ICefBrowserHost)
    function GetBrowser: ICefBrowser;
    procedure CloseBrowser(aForceClose: Boolean);
    function TryCloseBrowser: Boolean;
    procedure SetFocus(focus: Boolean);
    function GetWindowHandle: TCefWindowHandle;
    function GetOpenerWindowHandle: TCefWindowHandle;
    function HasView: Boolean;
    function GetClient: ICefClient;
    function GetRequestContext: ICefRequestContext;
    function GetZoomLevel: Double;
    procedure SetZoomLevel(zoomLevel: Double);
    procedure RunFileDialog(mode: TCefFileDialogMode; const title, defaultFileName: ustring;
      acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: ICefRunFileDialogCallback);
    procedure RunFileDialogProc(mode: TCefFileDialogMode; const title, defaultFileName: ustring;
      acceptFilters: TStrings; selectedAcceptFilter: Integer; const proc: TCefRunFileDialogCallbackProc);
    procedure StartDownload(const url: ustring);
    procedure DownloadImage(const imageUrl: ustring; isFavicon: Boolean; maxImageSize: UInt32;
      bypassCache: Boolean; const callback: ICefDownloadImageCallback);
    procedure Print;
    procedure PrintToPdf(const path: ustring; const settings: TCefPdfPrintSettings; callback: ICefPdfPrintCallback);
    procedure Find(identifier: Integer; const searchText: ustring; forward_, matchCase, findNext: Boolean);
    procedure StopFinding(clearSelection: Boolean);
    procedure ShowDevTools(var windowInfo: TCefWindowInfo; client: ICefClient;
      var settings: TCefBrowserSettings; const inspectElementAt: PCefPoint);
    procedure CloseDevTools;
    function HasDevTools: Boolean;
    procedure GetNavigationEntries(const visitor: ICefNavigationEntryVisitor; currentOnly: Boolean);
    procedure GetNavigationEntriesProc(const proc: TCefNavigationEntryVisitorProc; currentOnly: Boolean);
    procedure SetMouseCursorChangeDisabled(disabled: Boolean);
    function GetIsMouseCursorChangeDisabled: Boolean;
    procedure ReplaceMisspelling(const word: ustring);
    procedure AddWordToDictionary(const word: ustring);
    function GetIsWindowRenderingDisabled: Boolean;
    procedure WasResized;
    procedure WasHidden(hidden: Boolean);
    procedure NotifyScreenInfoChanged;
    procedure Invalidate(const aType: TCefPaintElementType);
    procedure SendKeyEvent(const event: TCefKeyEvent);
    procedure SendMouseClickEvent(const event: TCefMouseEvent; aType: TCefMouseButtonType;
      mouseUp: Boolean; clickCount: Integer);
    procedure SendMouseMoveEvent(event:TCefMouseEvent; mouseLeave: Boolean);
    procedure SendMouseWheelEvent(const event: TCefMouseEvent; deltaX, deltaY: Integer);
    procedure SendFocusEvent(dosetFocus: Boolean);
    procedure SendCaptureLostEvent;
    procedure NotifyMoveOrResizeStarted;
    function GetWindowlessFrameRate: Integer;
    procedure SetWindowlessFrameRate(frameRate: Integer);
    procedure ImeSetComposition(const text: ustring; underlinesCount: TSize;
      underlines: TCefCompositionUnderlineArray; const replacementRange, selectionRange: TCefRange);
    procedure ImeCommitText(const text: ustring; const replacementRange: TCefRange;
      relativeCursorPos: Integer);
    procedure ImeFinishComposingText(keepSelection: Boolean);
    procedure ImeCancelComposition;
    procedure DragTargetDragEnter(dragData: ICefDragData; const event: TCefMouseEvent; allowedOps: TCefDragOperationsMask);
    procedure DragTargetDragOver(const event: TCefMouseEvent; allowedOps: TCefDragOperationsMask);
    procedure DragTargetDragLeave;
    procedure DragTargetDrop(const event: TCefMouseEvent);
    procedure DragSourceEndedAt(x,y: Integer; op: TCefDragOperationsMask);
    procedure DragSourceSystemDragEnded;
    function GetVisibleNavigationEntry: ICefNavigationEntry;
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

  TCefRunContextMenuCallbackRef = class(TCefBaseRef, ICefRunContextMenuCallback)
  protected
    procedure Cont(commandId: Integer; eventFlags: TCefEventFlags);
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefRunContextMenuCallback;
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
    function GetTitleText: ustring;
    function GetPageUrl: ustring;
    function GetFrameUrl: ustring;
    function GetFrameCharset: ustring;
    function GetMediaType: TCefContextMenuMediaType;
    function GetMediaStateFlags: TCefContextMenuMediaStateFlags;
    function GetSelectionText: ustring;
    function GetMisspelledWord: ustring;
    function GetDictionarySuggestions(suggenstions: TStrings): Boolean;
    function IsEditable: Boolean;
    function IsSpellCheckEnabled: Boolean;
    function GetEditStateFlags: TCefContextMenuEditStateFlags;
    function IsCustomMenu: Boolean;
    function IsPepperMenu: Boolean;
  public
    class function UnWrap(data: Pointer): ICefContextMenuParams;
  end;

  TCefCookieManagerRef = class(TCefBaseRef, ICefCookieManager)
  protected
    procedure SetSupportedSchemes(schemes: TStrings; const callback: ICefCompletionCallback);
    procedure SetSupportedSchemesProc(schemes: TStrings; const proc: TCefCompletionCallbackProc);
    function VisitAllCookies(const visitor: ICefCookieVisitor): Boolean;
    function VisitAllCookiesProc(const visitor: TCefCookieVisitorProc): Boolean;
    function VisitUrlCookies(const url: ustring;
      includeHttpOnly: Boolean; const visitor: ICefCookieVisitor): Boolean;
    function VisitUrlCookiesProc(const url: ustring;
      includeHttpOnly: Boolean; const visitor: TCefCookieVisitorProc): Boolean;
    function SetCookie(const url: ustring; const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      const callback: ICefSetCookieCallback): Boolean;
    function SetCookieProc(const url: ustring; const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      const proc: TCefSetCookieCallbackProc): Boolean;
    function DeleteCookies(const url, cookieName: ustring;
      const callback: ICefDeleteCookiesCallback): Boolean;
    function DeleteCookiesProc(const url, cookieName: ustring;
      const proc: TCefDeleteCookiesCallbackProc): Boolean;
    function SetStoragePath(const path: ustring; PersistSessionCookies: Boolean;
      callback: ICefCompletionCallback): Boolean;
    function FlushStore(handler: ICefCompletionCallback): Boolean;
  public
    class function UnWrap(data: Pointer): ICefCookieManager;
    class function Global(callback: ICefCompletionCallback): ICefCookieManager;
    class function New(const path: ustring; persistSessionCookies: Boolean;
      callback: ICefCompletionCallback): ICefCookieManager;
  end;

  TCefFileDialogCallbackRef = class(TCefBaseRef, ICefFileDialogCallback)
  protected
    procedure Cont(selectedAcceptFilter: Integer; filePaths: TStrings);
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
    function GetSelectionStartOffset: Integer;
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
    function GetElementTagName: ustring;
    function HasElementAttributes: Boolean;
    function HasElementAttribute(const attrName: ustring): Boolean;
    function GetElementAttribute(const attrName: ustring): ustring;
    procedure GetElementAttributes(const attrMap: ICefStringMap);
    function SetElementAttribute(const attrName, value: ustring): Boolean;
    function GetElementInnerText: ustring;
    function GetElementBounds: TCefRect;
  public
    class function UnWrap(data: Pointer): ICefDomNode;
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
    procedure Pause;
    procedure Resume;
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
    function GetOriginalUrl: ustring;
    function GetSuggestedFileName: ustring;
    function GetContentDisposition: ustring;
    function GetMimeType: ustring;
  public
    class function UnWrap(data: Pointer): ICefDownLoadItem;
  end;

  TCefDragDataRef = class(TCefBaseRef, ICefDragData)
  protected
    function Clone: ICefDragData;
    function IsReadOnly: Boolean;
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
    function GetFileContents(writer: ICefStreamWriter): TSize;
    function GetFileNames(names: TStrings): Boolean;
    procedure SetLinkUrl(const url: ustring);
    procedure SetLinkTitle(const title: ustring);
    procedure SetLinkMetadata(const data: ustring);
    procedure SetFragmentText(const text: ustring);
    procedure SetFragmentHtml(const html: ustring);
    procedure SetFragmentBaseUrl(const baseUrl: ustring);
    procedure ResetFileContents;
    procedure AddFile(const path, displayName: ustring);
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
    function GetV8Context: ICefV8Context;
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

  TCefImageRef = class(TCefBaseRef, ICefImage)
  protected
    function IsEmpty: Boolean;
    function IsSame(const that: ICefImage): Boolean;
    function AddBitmap(scaleFactor: Single; pixelWidth, pixelHeight: Integer; colorType: TCefColorType;
      alphaType: TCefAlphaType; const pixelData: Pointer; pixelDataSize: TSize): Boolean;
    function AddPng(scaleFactor: Single; const pngData: Pointer; pngDataSize: TSize): Boolean;
    function AddJpeg(scaleFactor: Single; const jpegData: Pointer; jpegDataSize: TSize): Boolean;
    function GetWidth: TSize;
    function GetHeight: TSize;
    function HasRepresentation(scaleFactor: Single): Boolean;
    function RemoveRepresentation(scaleFactor: Single): Boolean;
    function GetRepresentationInfo(scaleFactor: Single; actualScaleFactor: PSingle;
      pixelWidth, pixelHeight: PInteger): Boolean;
    function GetAsBitmap(scaleFactor: Single; colorType: TCefColorType; alphaType: TCefAlphaType;
      pixelWidth, pixelHeight: PInteger): ICefBinaryValue;
    function GetAsPng(scaleFactor: Single; withTransparency: Boolean;
      pixelWidth, pixelHeight: PInteger): ICefBinaryValue;
    function GetAsJpeg(scaleFactor: Single; quality: Integer; pixelWidth, pixelHeight: PInteger): ICefBinaryValue;
  public
    class function UnWrap(data: Pointer): ICefImage;
  end;

  TCefMenuModelRef = class(TCefBaseRef, ICefMenuModel)
  protected
    function IsSubMenu: Boolean;
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
    function SetColor(commandId: Integer; colorType: TCefMenuColorType; color: TCefColor): Boolean;
    function SetColorAt(index: Integer; colorType: TCefMenuColorType; color: TCefColor): Boolean;
    function GetColor(commandId: Integer; colorType: TCefMenuColorType; out color: TCefColor): Boolean;
    function GetColorAt(index: Integer; colorType: TCefMenuColorType; out color: TCefColor): Boolean;
    function SetFontList(commandId: Integer; const fontList: ustring): Boolean;
    function SetFontListAt(index: Integer; const fontList: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefMenuModel;
  end;

  TCefNavigationEntryRef = class(TCefBaseRef, ICefNavigationEntry)
  protected
    function IsValid: Boolean;
    function GetUrl: ustring;
    function GetDisplayUrl: ustring;
    function GetOriginalUrl: ustring;
    function GetTitle: ustring;
    function GetTransitionType: TCefTransitionType;
    function HasPostData: Boolean;
    function GetCompletionTime: TDateTime;
    function GetHttpStatusCode: Integer;
    function GetSslStatus: ICefSslStatus;
  public
    class function UnWrap(data: Pointer): ICefNavigationEntry;
  end;

  TCefPrintDialogCallbackRef = class(TCefBaseRef, ICefPrintDialogCallback)
  protected
    procedure Cont(settings: ICefPrintSettings);
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): ICefPrintDialogCallback;
  end;

  TCefPrintJobCallbackRef = class(TCefBaseRef, ICefPrintJobCallback)
  protected
    procedure Cont;
  public
    class function UnWrap(data: Pointer): ICefPrintJobCallback;
  end;

  TCefPrintSettingsRef = class(TCefBaseRef, ICefPrintSettings)
  protected
    function IsValid: Boolean;
    function IsReadOnly: Boolean;
    function Copy: ICefPrintSettings;
    procedure SetOrientation(landscape: Boolean);
    function IsLandscape: Boolean;
    procedure SetPrinterPrintableArea(const physicalSizeDeviceUnits: TCefSize;
      const printableAreaDeviceUnits: TCefRect; landscapeNeedsFlip: Boolean);
    procedure SetDeviceName(const name: ustring);
    function GetDeviceName: ustring;
    procedure SetDpi(dpi: Integer);
    function GetDpi: Integer;
    procedure SetPageRanges(rangesCount: TSize; const ranges: TCefRangeArray);
    function GetPageRangesCount: TSize;
    procedure GetPageRanges(rangesCount: TSize; out ranges: TCefRangeArray);
    procedure SetSelectionOnly(selectionOnly: Boolean);
    function IsSelectionOnly: Boolean;
    procedure SetCollate(collate: Boolean);
    function WillCollate: Boolean;
    procedure SetColorModel(model: TCefColorModel);
    function GetColorModel: TCefColorModel;
    procedure SetCopies(copies: Integer);
    function GetCopies: Integer;
    procedure SetDuplexMode(mode: TCefDuplexMode);
    function GetDuplexMode: TCefDuplexMode;
  public
    class function UnWrap(data: Pointer): ICefPrintSettings;
    class function New: ICefPrintSettings;
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
    procedure SetReferrer(const referrerUrl: ustring; policy: TCefReferrerPolicy);
    function GetReferrerUrl: ustring;
    function GetReferrerPolicy: TCefReferrerPolicy;
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
    function HasExcludedElements: Boolean;
    function GetElementCount: TSize;
    procedure GetElements(Count: TSize; out elements: ICefPostDataElementArray);
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
    function IsSharingWith(other: ICefRequestContext): Boolean;
    function IsGlobal: Boolean;
    function GetHandler: ICefRequestContextHandler;
    function GetCachePath: ustring;
    function GetDefaultCookieManager(callback: ICefCompletionCallback): ICefCookieManager;
    function RegisterSchemeHandlerFactory(const schemeName, domainName: ustring; factory: ICefSchemeHandlerFactory): Boolean;
    function ClearSchemeHandlerFactories: Boolean;
    procedure PurgePluginListCache(reloadPages: Boolean);
    function HasPreference(const name: ustring): Boolean;
    function GetPreference(const name: ustring): ICefValue;
    function GetAllPreferences(includeDefaults: Boolean): ICefDictionaryValue;
    function CanSetPreference(const name: ustring): Boolean;
    function SetPreference(const name: ustring; value: ICefValue; out error: ustring): Boolean;
    procedure ClearCertificateExceptions(callback: ICefCompletionCallback);
    procedure CloseAllConnections(callback: ICefCompletionCallback);
    procedure ResolveHost(const origin: ustring; const callback: ICefResolveCallback);
    procedure ResolveHostProc(const origin: ustring; const proc: TCefResolveCallbackProc);
    function ResolveHostCached(const origin: ustring; resolvedIps: TStrings): TCefErrorCode;
  public
    class function UnWrap(data: Pointer): ICefRequestContext;
    class function New(settings: TCefRequestContextSettings; handler: ICefRequestContextHandler): ICefRequestContext;
    class function Shared(other: ICefRequestContext; handler: ICefRequestContextHandler): ICefRequestContext;
    class function Global: ICefRequestContext;
  end;

  TCefRequestContextHandlerRef = class(TCefBaseRef, ICefRequestContextHandler)
  protected
    function GetCookieManager: ICefCookieManager;
    function OnBeforePluginLoad(const mimeType, pluginUrl: ustring; isMainFrame: Boolean;
      const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo; pluginPolicy: TCefPluginPolicy): Boolean;
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

  TCefRequestCallbackRef = class(TCefBaseRef, ICefRequestCallback)
  protected
    procedure Cont(allow: Boolean);
    procedure Cancel;
  public
     class function UnWrap(data: Pointer): ICefRequestCallback;
  end;

  TCefSelectClientCertificateCallbackRef = class(TCefBaseRef, ICefSelectClientCertificateCallback)
  protected
    procedure Select(cert: ICefX509certificate);
  public
    class function UnWrap(data: Pointer): ICefSelectClientCertificateCallback;
  end;

  TCefResourceBundleRef = class(TCefBaseRef, ICefResourceBundle)
  protected
    function GetLokalizedString(stringId: Integer): ustring;
    function GetDataResource(resourceId: Integer; data: PPointer; dataSize: PSize): Boolean;
    function GetDataResourceForScale(resourceId: Integer; scaleFactor: TCefScaleFactor;
      data: PPointer; dataSize: PSize): Boolean;
  public
    class function UnWrap(data: Pointer): ICefResourceBundle;
    class function Global: ICefResourceBundle;
  end;

  TCefResponseRef = class(TCefBaseRef, ICefResponse)
  protected
    function IsReadOnly: Boolean;
    function GetError: TCefErrorCode;
    procedure SetError(error: TCefErrorCode);
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

  TCefSslinfoRef = class(TCefBaseRef, ICefSslinfo)
  protected
    function GetCertStatus: TCefCertStatus;
    function GetX509Certificate: ICefx509Certificate;
  public
    class function UnWrap(data: Pointer): ICefSslinfo;
  end;

  TCefSslstatusRef = class(TCefBaseRef, ICefSslstatus)
  protected
    function IsSecureConnection: Boolean;
    function GetCertStatus: TCefCertStatus;
    function GetSslVersion: TCefSslVersion;
    function GetContentStatus: TCefSslContentStatus;
    function Getx509Certificate: ICefx509Certificate;
  public
    class function UnWrap(data: Pointer): ICefSslstatus;
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
    class function CreateForData(data: Pointer; size: Cardinal): ICefStreamReader;
    class function CreateForHandler(const handler: ICefStreamReader): ICefStreamReader;
    class function CreateForStream(const stream: TSTream; owned: Boolean): ICefStreamReader;
  end;

  TCefStreamWriterRef = class(TCefBaseRef, ICefStreamWriter)
  protected
    function Write(const ptr: Pointer; size, n: TSize): TSize;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Flush: Boolean;
    function MayBlock: Boolean;
  public
    class function UnWrap(data: Pointer): ICefStreamWriter;
    class function CreateForFile(const filename: ustring): ICefStreamWriter;
    class function CreateForHandler(const handler: ICefStreamWriter): ICefStreamWriter;
    class function CreateForStream(const stream: TStream; owned: Boolean): ICefStreamWriter;
  end;

  TCefTaskRef = class(TCefBaseRef, ICefTask)
  protected
    procedure Execute; virtual;
  public
    class function UnWrap(data: Pointer): ICefTask;
  end;

  TCefTaskRunnerRef = class(TCefBaseRef, ICefTaskRunner)
  protected
    function IsSame(that: ICefTaskRunner):boolean;
    function BelongsToCurrentThread: Boolean;
    function BelongsToThread(ThreadID: TCefThreadID): Boolean;
    function PostTask(task: ICefTask): Integer;
    function PostDelayedTask(task: ICefTask; delay_ms: Int64): Integer;
  public
    class function UnWrap(data: Pointer): ICefTaskRunner;
    class function GetForCurrentThread: ICefTaskRunner;
    class function GetForThread(const ThreadID: TCefThreadID): ICefTaskRunner;
  end;

  TCefThreadRef = class(TCefBaseRef, ICefThread)
  protected
    function GetTaskRunner: ICefTaskRunner;
    function GetPlatformThreadId: TCefPlatformThreadId;
    procedure Stop;
    function IsRunning: Boolean;
  public
    class function UnWrap(data: Pointer): ICefThread;
    class function New(const displayName: ustring; priority: TCefThreadPriority;
      messageLoopType: TCefMessageLoopType; stoppable: Boolean; comInitMode: TCefComInitMode): ICefThread;
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
    class function New(const request: ICefRequest; const client: ICefUrlRequestClient;
      const requestContext: ICefRequestContext): ICefUrlRequest;
  end;

  TCefUrlRequestClientRef = class(TCefBaseRef, ICefUrlRequestClient)
  protected
    procedure OnRequestComplete(const request: ICefUrlRequest);
    procedure OnUploadProgress(const request: ICefUrlRequest; current, total: Int64);
    procedure OnDownloadProgress(const request: ICefUrlRequest; current, total: Int64);
    procedure OnDownloadData(const request: ICefUrlRequest; data: Pointer; dataLength: TSize);
    function GetAuthCredentials(isProxy: Boolean; const host: ustring; port: Integer;
      const realm, scheme: ustring; callback: ICefAuthCallback): Boolean;
  public
    class function UnWrap(data: Pointer): ICefUrlRequestClient;
  end;

  TCefV8ContextRef = class(TCefBaseRef, ICefV8Context)
  protected
    function GetTaskRunner:ICefTaskRunner;
    function IsValid: Boolean;
    function GetBrowser: ICefBrowser;
    function GetFrame: ICefFrame;
    function GetGlobal: ICefV8Value;
    function Enter: Boolean;
    function Exit: Boolean;
    function IsSame(const that: ICefV8Context): Boolean;
    function Eval(const code, scriptUrl: ustring; startLine: Integer; var retval: ICefV8Value;
      var exception: ICefV8Exception): Boolean;
  public
    class function UnWrap(data: Pointer): ICefV8Context;
    class function Current: ICefV8Context;
    class function Entered: ICefV8Context;
  end;

  TCefV8HandlerRef = class(TCefBaseRef, ICefV8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefV8Value;
      const arguments: ICefV8ValueArray; var retval: ICefV8Value;
      var exception: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefV8Handler;
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

  TCefV8ValueRef = class(TCefBaseRef, ICefV8Value)
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
    function IsSame(const that: ICefV8Value): Boolean;
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
    function GetValueByKey(const key: ustring): ICefV8Value;
    function GetValueByIndex(index: Integer): ICefV8Value;
    function SetValueByKey(const key: ustring; const value: ICefV8Value;
      attribute: TCefV8PropertyAttributes): Boolean;
    function SetValueByIndex(index: Integer; const value: ICefV8Value): Boolean;
    function SetValueByAccessor(const key: ustring; settings: TCefV8AccessControls;
      attribute: TCefV8PropertyAttributes): Boolean;
    function GetKeys(const keys: TStrings): Integer;
    function SetUserData(const data: ICefV8Value): Boolean;
    function GetUserData: ICefV8Value;
    function GetExternallyAllocatedMemory: Integer;
    function AdjustExternallyAllocatedMemory(changeInBytes: Integer): Integer;
    function GetArrayLength: Integer;
    function GetFunctionName: ustring;
    function GetFunctionHandler: ICefV8Handler;
    function ExecuteFunction(const obj: ICefV8Value;
      const arguments: ICefV8ValueArray): ICefV8Value;
    function ExecuteFunctionWithContext(const context: ICefV8Context;
      const obj: ICefV8Value; const arguments: ICefV8ValueArray): ICefV8Value;
  public
    class function UnWrap(data: Pointer): ICefV8Value;
    class function NewUndefined: ICefV8Value;
    class function NewNull: ICefV8Value;
    class function NewBool(value: Boolean): ICefV8Value;
    class function NewInt(value: Integer): ICefV8Value;
    class function NewUInt(value: Cardinal): ICefV8Value;
    class function NewDouble(value: Double): ICefV8Value;
    class function NewDate(value: TDateTime): ICefV8Value;
    class function NewString(const str: ustring): ICefV8Value;
    class function NewObject(const Accessor: ICefV8Accessor;
        const Interceptor: ICefV8Interceptor): ICefV8Value;
    class function NewArray(len: Integer): ICefV8Value;
    class function NewFunction(const name: ustring; const handler: ICefV8Handler): ICefV8Value;
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

  TCefValueRef = class(TCefBaseRef, ICefValue)
  protected
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function IsSame(that: ICefValue): Boolean;
    function IsEqual(that: ICefValue): Boolean;
    function Copy: ICefValue;
    function GetType: TCefValueType;
    function GetBool: Boolean;
    function GetInt: Integer;
    function GetDouble: Double;
    function GetString: ustring;
    function GetBinary: ICefBinaryValue;
    function GetDictionary: ICefDictionaryValue;
    function GetList: ICefListValue;
    function SetNull: Boolean;
    function SetBool(value: Boolean): Boolean;
    function SetInt(value: Integer): Boolean;
    function SetDouble(value: Double): Boolean;
    function SetString(value: ustring): Boolean;
    function SetBinary(value: ICefBinaryValue): Boolean;
    function SetDictionary(value: ICefDictionaryValue): Boolean;
    function SetList(value: ICefListValue): Boolean;
  public
    class function UnWrap(data: Pointer): ICefValue;
    class function New: ICefValue;
  end;

  TCefBinaryValueRef = class(TCefBaseRef, ICefBinaryValue)
  protected
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsSame(that: ICefBinaryValue): Boolean;
    function IsEqual(that: ICefBinaryValue): Boolean;
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
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function IsSame(that: ICefDictionaryValue): Boolean;
    function IsEqual(that: ICefDictionaryValue): Boolean;
    function Copy(excludeEmptyChildren: Boolean): ICefDictionaryValue;
    function GetSize: TSize;
    function Clear: Boolean;
    function HasKey(const key: ustring): Boolean;
    function GetKeys(const keys: TStrings): Boolean;
    function Remove(const key: ustring): Boolean;
    function GetType(const key: ustring): TCefValueType;
    function GetValue(const key: ustring): ICefValue;
    function GetBool(const key: ustring): Boolean;
    function GetInt(const key: ustring): Integer;
    function GetDouble(const key: ustring): Double;
    function GetString(const key: ustring): ustring;
    function GetBinary(const key: ustring): ICefBinaryValue;
    function GetDictionary(const key: ustring): ICefDictionaryValue;
    function GetList(const key: ustring): ICefListValue;
    function SetValue(const key: ustring; value: ICefValue): Boolean;
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
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function IsSame(that: ICefListValue): Boolean;
    function IsEqual(that: ICefListValue): Boolean;
    function Copy: ICefListValue;
    function SetSize(size: TSize): Boolean;
    function GetSize: TSize;
    function Clear: Boolean;
    function Remove(index: TSize): Boolean;
    function GetType(index: TSize): TCefValueType;
    function GetValue(index: TSize): ICefValue;
    function GetBool(index: TSize): Boolean;
    function GetInt(index: TSize): Integer;
    function GetDouble(index: TSize): Double;
    function GetString(index: TSize): ustring;
    function GetBinary(index: TSize): ICefBinaryValue;
    function GetDictionary(index: TSize): ICefDictionaryValue;
    function GetList(index: TSize): ICefListValue;
    function SetValue(index: TSize; value: ICefValue): Boolean;
    function SetNull(index: TSize): Boolean;
    function SetBool(index: TSize; value: Boolean): Boolean;
    function SetInt(index: TSize; value: Integer): Boolean;
    function SetDouble(index: TSize; value: Double): Boolean;
    function SetString(index: TSize; const value: ustring): Boolean;
    function SetBinary(index: TSize; const value: ICefBinaryValue): Boolean;
    function SetDictionary(index: TSize; const value: ICefDictionaryValue): Boolean;
    function SetList(index: TSize; const value: ICefListValue): Boolean;
  public
    class function UnWrap(data: Pointer): ICefListValue;
    class function New: ICefListValue;
  end;

  TCefWaitableEventRef = class(TCefBaseRef, ICefWaitableEvent)
  protected
    procedure Reset;
    procedure Signal;
    function IsSignaled: Boolean;
    procedure Wait;
    function TimedWait(maxMs: Int64): Boolean;
  public
    class function UnWrap(data: Pointer): ICefWaitableEvent;
    class function New(automaticReset, initiallySignaled: Boolean): ICefWaitableEvent;
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

  TCefX509certPrincipalRef = class(TCefBaseRef, ICefX509certPrincipal)
  protected
    function GetDisplayName: ustring;
    function GetCommonName: ustring;
    function GetLocalityName: ustring;
    function GetStateOrProvinceName: ustring;
    function GetCountryName: ustring;
    procedure GetStreetAddresses(addresses: TStrings);
    procedure GetOrganizationNames(names: TStrings);
    procedure GetOrganizationUnitNames(names: TStrings);
    procedure GetDomainComponents(components: TStrings);
  public
    class function UnWrap(data: Pointer): ICefX509certPrincipal;
  end;

  TCefX509certificateRef = class(TCefBaseRef, ICefX509certificate)
  protected
    function GetSubject: ICefX509certPrincipal;
    function GetIssuer: ICefX509certPrincipal;
    function GetSerialNumber: ICefBinaryValue;
    function GetValidStart: TDateTime;
    function GetValidExpiry: TDateTime;
    function GetDerencoded: ICefBinaryValue;
    function GetPemencoded: ICefBinaryValue;
    function GetIssuerChainSize: Integer;
    procedure GetDerencodedIssuerChain(chainCount: TSize; out chain: ICefBinaryValueArray);
    procedure GetPemencodedIssuerChain(chainCount: TSize; out chain: ICefBinaryValueArray);
  public
    class function UnWrap(data: Pointer): ICefX509certificate;
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
    function GetFileLastModified: TDateTime;
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

{ TCefBaseRef }

constructor TCefBaseRef.Create(data: Pointer);
begin
  Assert(data <> nil);
  fData := data;
end;

destructor TCefBaseRef.Destroy;
begin
  If Assigned(PCefBaseRefCounted(fData)^.release) then PCefBaseRefCounted(fData)^.release(fData);

  inherited;
end;

function TCefBaseRef.Wrap: Pointer;
begin
  Result := fData;
  If Assigned(PCefBaseRefCounted(fData)^.add_ref) then PCefBaseRefCounted(fData)^.add_ref(fData);
end;

class function TCefBaseRef.UnWrap(data: Pointer): ICefBaseRefCounted;
begin
  If data <> nil then Result := Create(data) as ICefBaseRefCounted
  Else Result := nil;
end;

{ TCefBrowserRef }

function TCefBrowserRef.GetHost: ICefBrowserHost;
begin
  Result := TCefBrowserHostRef.UnWrap(PCefBrowser(fData)^.get_host(fData));
end;

function TCefBrowserRef.CanGoBack : Boolean;
begin
  Result := PCefBrowser(fData)^.can_go_back(fData) <> 0;
end;

procedure TCefBrowserRef.GoBack;
begin
  PCefBrowser(fData)^.go_back(fData);
end;

function TCefBrowserRef.CanGoForward : Boolean;
begin
  Result := PCefBrowser(fData)^.can_go_forward(fData) <> 0;
end;

procedure TCefBrowserRef.GoForward;
begin
  PCefBrowser(fData)^.go_forward(fData);
end;

function TCefBrowserRef.IsLoading : Boolean;
begin
  Result := PCefBrowser(fData)^.is_loading(fData) <> 0;
end;

procedure TCefBrowserRef.Reload;
begin
  PCefBrowser(fData)^.reload(fData);
end;

procedure TCefBrowserRef.ReloadIgnoreCache;
begin
  PCefBrowser(fData)^.reload_ignore_cache(fData);
end;

procedure TCefBrowserRef.StopLoad;
begin
  PCefBrowser(fData)^.stop_load(fData);
end;

function TCefBrowserRef.GetIdentifier : Integer;
begin
  Result := PCefBrowser(fData)^.get_identifier(fData);
end;

function TCefBrowserRef.IsSame(const that: ICefBrowser): Boolean;
begin
  Result := PCefBrowser(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefBrowserRef.IsPopup : Boolean;
begin
  Result := PCefBrowser(fData)^.is_popup(fData) <> 0;
end;

function TCefBrowserRef.HasDocument : Boolean;
begin
  Result := PCefBrowser(fData)^.has_document(fData) <> 0;
end;

function TCefBrowserRef.GetMainFrame : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(fData)^.get_main_frame(fData));
end;

function TCefBrowserRef.GetFocusedFrame : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(fData)^.get_focused_frame(fData));
end;

function TCefBrowserRef.GetFrameByident(identifier : Int64) : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(fData)^.get_frame_byident(fData, identifier));
end;

function TCefBrowserRef.GetFrame(const name : ustring) : ICefFrame;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := TCefFrameRef.UnWrap(PCefBrowser(fData)^.get_frame(fData, @n));
end;

function TCefBrowserRef.GetFrameCount : TSize;
begin
  Result := PCefBrowser(fData)^.get_frame_count(fData);
end;

procedure TCefBrowserRef.GetFrameIdentifiers(count : PSize; identifiers : PInt64);
begin
  PCefBrowser(fData)^.get_frame_identifiers(fData, count, identifiers);
end;

procedure TCefBrowserRef.GetFrameNames(names : TStrings);
Var
  list : TCefStringList;
  i    : Integer;
  str  : TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefBrowser(fData)^.get_frame_names(fData, list);

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
  Result := PCefBrowser(fData)^.send_process_message(fData, targetProcess, CefGetData(message)) <> 0;
end;

class function TCefBrowserRef.UnWrap(data : Pointer) : ICefBrowser;
begin
  If data <> nil then Result := Create(data) as ICefBrowser
  Else Result := nil;
end;

{ TCefBrowserHostRef }

function TCefBrowserHostRef.GetBrowser : ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefBrowserHost(fData)^.get_browser(fData));
end;

procedure TCefBrowserHostRef.CloseBrowser(aForceClose : Boolean);
begin
  PCefBrowserHost(fData)^.close_browser(fData, Ord(aForceClose));
end;

function TCefBrowserHostRef.TryCloseBrowser: Boolean;
begin
  Result := PCefBrowserHost(fData)^.try_close_browser(fData) <> 0;
end;

procedure TCefBrowserHostRef.SetFocus(focus: Boolean);
begin
  PCefBrowserHost(fData)^.set_focus(fData, Ord(focus));
end;

function TCefBrowserHostRef.GetWindowHandle : TCefWindowHandle;
begin
  Result := PCefBrowserHost(fData)^.get_window_handle(fData);
end;

function TCefBrowserHostRef.GetOpenerWindowHandle : TCefWindowHandle;
begin
  Result := PCefBrowserHost(fData)^.get_opener_window_handle(fData);
end;

function TCefBrowserHostRef.HasView: Boolean;
begin
  Result := PCefBrowserHost(fData)^.has_view(fData) <> 0;
end;

function TCefBrowserHostRef.GetClient : ICefClient;
Var
  client : PCefClient;
begin
  client := PCefBrowserHost(fData)^.get_client(fData);

  If Assigned(client) then Result := TCefBaseRef.Create(client) as ICefClient
  Else Result := nil;
end;

function TCefBrowserHostRef.GetRequestContext : ICefRequestContext;
begin
  Result:=TCefRequestContextRef.UnWrap(PCefBrowserHost(fData)^.get_request_context(PCefBrowserHost(fData)));
end;

function TCefBrowserHostRef.GetZoomLevel : Double;
begin
  Result := PCefBrowserHost(fData)^.get_zoom_level(fData);
end;

procedure TCefBrowserHostRef.SetZoomLevel(zoomLevel : Double);
begin
  PCefBrowserHost(fData)^.set_zoom_level(fData, zoomLevel);
end;

procedure TCefBrowserHostRef.StartDownload(const url : ustring);
Var
  u : TCefString;
begin
  u := CefString(url);
  PCefBrowserHost(fData)^.start_download(fData, @u);
end;

procedure TCefBrowserHostRef.DownloadImage(const imageUrl: ustring; isFavicon: Boolean;
  maxImageSize: UInt32; bypassCache: Boolean; const callback: ICefDownloadImageCallback);
Var
  i: TCefString;
begin
  i := CefString(imageUrl);
  PCefBrowserHost(fData)^.download_image(fData, @i, Ord(isFavicon), maxImageSize,
    Ord(bypassCache), CefGetData(callback));
end;

procedure TCefBrowserHostRef.Print;
begin
  PCefBrowserHost(fData)^.print(fData);
end;

procedure TCefBrowserHostRef.PrintToPdf(const path: ustring; const settings: TCefPdfPrintSettings;
  callback: ICefPdfPrintCallback);
Var
  p: TCefString;
begin
  p := CefString(path);
  PCefBrowserHost(fData)^.print_to_pdf(fData, @p, @settings, CefGetData(callback));
end;

procedure TCefBrowserHostRef.Find(identifier : Integer; const searchText : ustring;
  forward_, matchCase, findNext : Boolean);
Var
  text: TCefString;
begin
  text := CefString(searchText);
  PCefBrowserHost(fData)^.find(fData, identifier, @text, Ord(forward_), Ord(matchCase), Ord(findNext));
end;

procedure TCefBrowserHostRef.StopFinding(clearSelection : Boolean);
begin
  PCefBrowserHost(fData)^.stop_finding(PCefBrowserHost(fData),Ord(clearSelection));
end;

procedure TCefBrowserHostRef.ShowDevTools(var windowInfo: TCefWindowInfo; client: ICefClient;
  var settings: TCefBrowserSettings; const inspectElementAt: PCefPoint);
begin
  PCefBrowserHost(fData)^.show_dev_tools(fData, @windowInfo, CefGetData(client), @settings,
    inspectElementAt);
end;

procedure TCefBrowserHostRef.CloseDevTools;
begin
  PCefBrowserHost(fData)^.close_dev_tools(fData);
end;

function TCefBrowserHostRef.HasDevTools: Boolean;
begin
  Result := PCefBrowserHost(fData)^.has_dev_tools(fData) <> 0;
end;

procedure TCefBrowserHostRef.GetNavigationEntries(const visitor: ICefNavigationEntryVisitor;
  currentOnly: Boolean);
begin
  PCefBrowserHost(fData)^.get_navigation_entries(fData, CefGetData(visitor), ord(currentOnly));
end;

procedure TCefBrowserHostRef.GetNavigationEntriesProc(const proc: TCefNavigationEntryVisitorProc;
  currentOnly: Boolean);
begin
  GetNavigationEntries(TCefFastNavigationEntryVisitor.Create(proc), currentOnly);
end;

procedure TCefBrowserHostRef.SetMouseCursorChangeDisabled(disabled : Boolean);
begin
  PCefBrowserHost(fData)^.set_mouse_cursor_change_disabled(fData, Ord(disabled));
end;

function TCefBrowserHostRef.GetIsMouseCursorChangeDisabled : Boolean;
begin
  Result := PCefBrowserHost(fData)^.is_mouse_cursor_change_disabled(fData) <> 0;
end;

procedure TCefBrowserHostRef.ReplaceMisspelling(const word: ustring);
Var
  w: TCefString;
begin
  w := CefString(word);
  PCefBrowserHost(fData)^.replace_misspelling(fData, @w);
end;

procedure TCefBrowserHostRef.AddWordToDictionary(const word: ustring);
Var
  w: TCefString;
begin
  w := CefString(word);
  PCefBrowserHost(fData)^.add_word_to_dictionary(fData, @w);
end;

function TCefBrowserHostRef.GetIsWindowRenderingDisabled : Boolean;
begin
  Result := PCefBrowserHost(fData)^.is_window_rendering_disabled(fData) <> 0;
end;

procedure TCefBrowserHostRef.WasResized;
begin
  PCefBrowserHost(fData)^.was_resized(fData);
end;

procedure TCefBrowserHostRef.WasHidden(hidden : Boolean);
begin
  PCefBrowserHost(fData)^.was_hidden(fData, Ord(hidden));
end;

procedure TCefBrowserHostRef.NotifyScreenInfoChanged;
begin
  PCefBrowserHost(fData)^.notify_screen_info_changed(fData);
end;

procedure TCefBrowserHostRef.Invalidate(const aType: TCefPaintElementType);
begin
  PCefBrowserHost(fData)^.invalidate(fData, aType);
end;

procedure TCefBrowserHostRef.SendKeyEvent(const event : TCefKeyEvent);
begin
  PCefBrowserHost(fData)^.send_key_event(fData, @event);
end;

procedure TCefBrowserHostRef.SendMouseClickEvent(const event : TCefMouseEvent;
  aType : TCefMouseButtonType; mouseUp : Boolean; clickCount : Integer);
begin
  PCefBrowserHost(fData)^.send_mouse_click_event(fData, @event, aType, Ord(mouseUp), clickCount);
end;

procedure TCefBrowserHostRef.SendMouseMoveEvent(event: TCefMouseEvent; mouseLeave: Boolean);
begin
  PCefBrowserHost(fData)^.send_mouse_move_event(fData, @event, Ord(mouseLeave));
end;

procedure TCefBrowserHostRef.SendMouseWheelEvent(const event : TCefMouseEvent;
  deltaX, deltaY : Integer);
begin
  PCefBrowserHost(fData)^.send_mouse_wheel_event(fData, @event, deltaX, deltaY);
end;

procedure TCefBrowserHostRef.SendFocusEvent(dosetFocus: Boolean);
begin
  PCefBrowserHost(fData)^.send_focus_event(fData, Ord(dosetFocus));
end;

procedure TCefBrowserHostRef.SendCaptureLostEvent;
begin
  PCefBrowserHost(fData)^.send_capture_lost_event(fData);
end;

procedure TCefBrowserHostRef.NotifyMoveOrResizeStarted;
begin
  PCefBrowserHost(fData)^.notify_move_or_resize_started(fData);
end;

function TCefBrowserHostRef.GetWindowlessFrameRate: Integer;
begin
  Result := PCefBrowserHost(fData)^.get_windowless_frame_rate(fData);
end;

procedure TCefBrowserHostRef.SetWindowlessFrameRate(frameRate: Integer);
begin
  PCefBrowserHost(fData)^.set_windowless_frame_rate(fData, frameRate);
end;

procedure TCefBrowserHostRef.ImeSetComposition(const text: ustring; underlinesCount: TSize;
  underlines: TCefCompositionUnderlineArray; const replacementRange, selectionRange: TCefRange);
Var
  t: TCefString;
begin
  t := CefString(text);
  PCefBrowserHost(fData)^.ime_set_composition(fData, @t, underlinesCount, @underlines,
    @replacementRange, @selectionRange);
end;

procedure TCefBrowserHostRef.ImeCommitText(const text: ustring; const replacementRange: TCefRange;
  relativeCursorPos: Integer);
Var
  t: TCefString;
begin
  t := CefString(text);
  PCefBrowserHost(fData)^.ime_commit_text(fData, @t, @replacementRange, relativeCursorPos);
end;

procedure TCefBrowserHostRef.ImeFinishComposingText(keepSelection: Boolean);
begin
  PCefBrowserHost(fData)^.ime_finish_composing_text(fData, Ord(keepSelection));
end;

procedure TCefBrowserHostRef.ImeCancelComposition;
begin
  PCefBrowserHost(fData)^.ime_cancel_composition(fData);
end;

procedure TCefBrowserHostRef.DragTargetDragEnter(dragData: ICefDragData;
  const event: TCefMouseEvent; allowedOps: TCefDragOperationsMask);
begin
  PCefBrowserHost(fData)^.drag_target_drag_enter(fData, CefGetData(dragData), @event, allowedOps);
end;

procedure TCefBrowserHostRef.DragTargetDragOver(const event: TCefMouseEvent;
  allowedOps: TCefDragOperationsMask);
begin
  PCefBrowserHost(fData)^.drag_target_drag_over(fData, @event, allowedOps);
end;

procedure TCefBrowserHostRef.DragTargetDragLeave;
begin
  PCefBrowserHost(fData)^.drag_target_drag_leave(fData);
end;

procedure TCefBrowserHostRef.DragTargetDrop(const event: TCefMouseEvent);
begin
  PCefBrowserHost(fData)^.drag_target_drop(fData, @event);
end;

procedure TCefBrowserHostRef.DragSourceEndedAt(x, y: Integer; op: TCefDragOperationsMask);
begin
  PCefBrowserHost(fData)^.drag_source_ended_at(fData, x, y, op);
end;

procedure TCefBrowserHostRef.DragSourceSystemDragEnded;
begin
  PCefBrowserHost(fData)^.drag_source_system_drag_ended(fData);
end;

function TCefBrowserHostRef.GetVisibleNavigationEntry: ICefNavigationEntry;
begin
  Result := TCefNavigationEntryRef.UnWrap(PCefBrowserHost(fData)^.get_visible_navigation_entry(fData));
end;

procedure TCefBrowserHostRef.RunFileDialog(mode: TCefFileDialogMode;
  const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
  const callback: ICefRunFileDialogCallback);
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
    For i := 0 to acceptFilters.Count - 1 do
    begin
      item := CefString(acceptFilters[i]);
      cef_string_list_append(list, @item);
    end;

    PCefBrowserHost(fData)^.run_file_dialog(fData, mode, @t, @f, list, selectedAcceptFilter,
      CefGetData(callback));
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefBrowserHostRef.RunFileDialogProc(mode: TCefFileDialogMode;
  const title, defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
  const proc: TCefRunFileDialogCallbackProc);
begin
  RunFileDialog(mode, title, defaultFileName, acceptFilters, selectedAcceptFilter,
    TCefFastRunFileDialogCallback.Create(proc));
end;

class function TCefBrowserHostRef.UnWrap(data : Pointer) : ICefBrowserHost;
begin
  If data <> nil then Result := Create(data) as ICefBrowserHost
  Else Result := nil;
end;

{ TCefCallbackRef }

procedure TCefCallbackRef.Cont;
begin
  PCefCallback(fData)^.cont(fData);
end;

procedure TCefCallbackRef.Cancel;
begin
  PCefCallback(fData)^.cancel(fData);
end;

class function TCefCallbackRef.UnWrap(data : Pointer) : ICefCallback;
begin
  If data <> nil then Result := Create(data) as ICefCallback
  Else Result := nil;
end;

{ TCefCommandLineRef }

function TCefCommandLineRef.IsValid : Boolean;
begin
  Result := PCefCommandLine(fData)^.is_valid(fData) <> 0;
end;

function TCefCommandLineRef.IsReadOnly : Boolean;
begin
  Result := PCefCommandLine(fData)^.is_read_only(fData) <> 0;
end;

function TCefCommandLineRef.Copy : ICefCommandLine;
begin
  Result := UnWrap(PCefCommandLine(fData)^.copy(fData));
end;

procedure TCefCommandLineRef.InitFromArgv(argc : Integer; const argv : PPAnsiChar);
begin
  PCefCommandLine(fData)^.init_from_argv(fData, argc, argv);
end;

procedure TCefCommandLineRef.InitFromString(const commandLine : ustring);
Var
  c : TCefString;
begin
  c := CefString(commandLine);
  PCefCommandLine(fData)^.init_from_string(fData, @c);
end;

procedure TCefCommandLineRef.Reset;
begin
  PCefCommandLine(fData)^.reset(fData);
end;

procedure TCefCommandLineRef.GetArgv(argv : TStrings);
Var
  list: TCefStringList;
  i   : Integer;
  str : TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefCommandLine(fData)^.get_argv(fData, list);
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
  Result := CefStringFreeAndGet(PCefCommandLine(fData)^.get_command_line_string(fData));
end;

function TCefCommandLineRef.GetProgram : ustring;
begin
  Result := CefStringFreeAndGet(PCefCommandLine(fData)^.get_program(fData));
end;

procedure TCefCommandLineRef.SetProgram(const program_ : ustring);
Var
  p: TCefString;
begin
  p := CefString(program_);
  PCefCommandLine(fData)^.set_program(fData, @p);
end;

function TCefCommandLineRef.HasSwitches : Boolean;
begin
  Result := PCefCommandLine(fData)^.has_switches(fData) <> 0;
end;

function TCefCommandLineRef.HasSwitch(const name : ustring) : Boolean;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := PCefCommandLine(fData)^.has_switch(fData, @n) <> 0;
end;

function TCefCommandLineRef.GetSwitchValue(const name : ustring) : ustring;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(PCefCommandLine(fData)^.get_switch_value(fData, @n));
end;

procedure TCefCommandLineRef.GetSwitches(switches : ICefStringMap);
begin
  PCefCommandLine(fData)^.get_switches(fData, switches.Handle);
end;

procedure TCefCommandLineRef.AppendSwitch(const name : ustring);
Var
  n: TCefString;
begin
  n := CefString(name);
  PCefCommandLine(fData)^.append_switch(fData, @n);
end;

procedure TCefCommandLineRef.AppendSwitchWithValue(const name, value : ustring);
Var
  n, v: TCefString;
begin
  n := CefString(name);
  v := CefString(value);
  PCefCommandLine(fData)^.append_switch_with_value(fData, @n, @v);
end;

function TCefCommandLineRef.HasArguments : Boolean;
begin
  Result := PCefCommandLine(fData)^.has_arguments(fData) <> 0;
end;

procedure TCefCommandLineRef.GetArguments(arguments : TStrings);
Var
  list: TCefStringList;
  i   : Integer;
  str : TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefCommandLine(fData)^.get_arguments(fData, list);
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
  PCefCommandLine(fData)^.append_argument(fData, @a);
end;

procedure TCefCommandLineRef.PrependWrapper(const wrapper : ustring);
Var
  w: TCefString;
begin
  w := CefString(wrapper);
  PCefCommandLine(fData)^.prepend_wrapper(fData, @w);
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

{ TCefRunContextMenuCallbackRef }

procedure TCefRunContextMenuCallbackRef.Cont(commandId: Integer; eventFlags: TCefEventFlags);
begin
  PCefRunContextMenuCallback(fData)^.cont(fData, commandId, eventFlags);
end;

procedure TCefRunContextMenuCallbackRef.Cancel;
begin
  PCefRunContextMenuCallback(fData)^.cancel(fData);
end;

class function TCefRunContextMenuCallbackRef.UnWrap(data: Pointer): ICefRunContextMenuCallback;
begin
  If data <> nil then Result := Create(data) as ICefRunContextMenuCallback
  Else Result := nil;
end;

{ TCefContextMenuParamsRef }

function TCefContextMenuParamsRef.GetXCoord : Integer;
begin
  Result := PCefContextMenuParams(fData)^.get_xcoord(fData);
end;

function TCefContextMenuParamsRef.GetYCoord : Integer;
begin
  Result := PCefContextMenuParams(fData)^.get_ycoord(fData);
end;

function TCefContextMenuParamsRef.GetTypeFlags : TCefContextMenuTypeFlags;
begin
  Result := PCefContextMenuParams(fData)^.get_type_flags(fData);
end;

function TCefContextMenuParamsRef.GetLinkUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_link_url(fData));
end;

function TCefContextMenuParamsRef.GetUnfilteredLinkUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_unfiltered_link_url(fData));
end;

function TCefContextMenuParamsRef.GetSourceUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_source_url(fData));
end;

function TCefContextMenuParamsRef.HasImageContents : Boolean;
begin
  Result := PCefContextMenuParams(fData)^.has_image_contents(fData) <> 0;
end;

function TCefContextMenuParamsRef.GetTitleText: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_title_text(fData));
end;

function TCefContextMenuParamsRef.GetPageUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_page_url(fData));
end;

function TCefContextMenuParamsRef.GetFrameUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_frame_url(fData));
end;

function TCefContextMenuParamsRef.GetFrameCharset : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_frame_charset(fData));
end;

function TCefContextMenuParamsRef.GetMediaType : TCefContextMenuMediaType;
begin
  Result := PCefContextMenuParams(fData)^.get_media_type(fData);
end;

function TCefContextMenuParamsRef.GetMediaStateFlags : TCefContextMenuMediaStateFlags;
begin
  Result := PCefContextMenuParams(fData)^.get_media_state_flags(fData);
end;

function TCefContextMenuParamsRef.GetSelectionText : ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_selection_text(fData));
end;

function TCefContextMenuParamsRef.GetMisspelledWord: ustring;
begin
  Result := CefStringFreeAndGet(PCefContextMenuParams(fData)^.get_misspelled_word(fData));
end;

function TCefContextMenuParamsRef.GetDictionarySuggestions(suggenstions: TStrings): Boolean;
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefContextMenuParams(fData)^.get_dictionary_suggestions(fData, list) <> 0;

    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      suggenstions.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefContextMenuParamsRef.IsEditable : Boolean;
begin
  Result := PCefContextMenuParams(fData)^.is_editable(fData) <> 0;
end;

function TCefContextMenuParamsRef.IsSpellCheckEnabled : Boolean;
begin
  Result := PCefContextMenuParams(fData)^.is_spell_check_enabled(fData) <> 0;
end;

function TCefContextMenuParamsRef.GetEditStateFlags : TCefContextMenuEditStateFlags;
begin
  Result := PCefContextMenuParams(fData)^.get_edit_state_flags(fData);
end;

function TCefContextMenuParamsRef.IsCustomMenu: Boolean;
begin
  Result := PCefContextMenuParams(fData)^.is_custom_menu(fData) <> 0;
end;

function TCefContextMenuParamsRef.IsPepperMenu: Boolean;
begin
  Result := PCefContextMenuParams(fData)^.is_pepper_menu(fData) <> 0;
end;

class function TCefContextMenuParamsRef.UnWrap(data : Pointer) : ICefContextMenuParams;
begin
  If data <> nil then Result := Create(data) as ICefContextMenuParams
  Else Result := nil;
end;

{ TCefCookieManagerRef }

procedure TCefCookieManagerRef.SetSupportedSchemes(schemes: TStrings;
  const callback: ICefCompletionCallback);
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

      PCefCookieManager(fData)^.set_supported_schemes(fData, list, CefGetData(callback));
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefCookieManagerRef.SetSupportedSchemesProc(schemes: TStrings;
  const proc: TCefCompletionCallbackProc);
begin
  SetSupportedSchemes(schemes, TCefFastCompletionCallback.Create(proc));
end;

function TCefCookieManagerRef.VisitAllCookies(const visitor : ICefCookieVisitor) : Boolean;
begin
  Result := PCefCookieManager(fData)^.visit_all_cookies(fData, CefGetData(visitor)) <> 0;
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
  Result := PCefCookieManager(fData)^.visit_url_cookies(fData, @u, Ord(includeHttpOnly), CefGetData(visitor)) <> 0;
end;

function TCefCookieManagerRef.VisitUrlCookiesProc(const url : ustring;
  includeHttpOnly : Boolean; const visitor : TCefCookieVisitorProc) : Boolean;
begin
  Result := VisitUrlCookies(url, includeHttpOnly, TCefFastCookieVisitor.Create(visitor) as ICefCookieVisitor);
end;

function TCefCookieManagerRef.SetCookie(const url: ustring;
  const name, value, domain, path: ustring; secure, httponly, hasExpires: Boolean;
  const creation, lastAccess, expires: TDateTime; const callback: ICefSetCookieCallback): Boolean;
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

  Result := PCefCookieManager(fData)^.set_cookie(fData, @u, @c, CefGetData(callback)) <> 0;
end;

function TCefCookieManagerRef.SetCookieProc(const url: ustring;
  const name, value, domain, path: ustring; secure, httponly, hasExpires: Boolean;
  const creation, lastAccess, expires: TDateTime; const proc: TCefSetCookieCallbackProc): Boolean;
begin
  Result := SetCookie(url, name, value, domain, path, secure, httponly, hasExpires, creation,
    lastAccess, expires, TCefFastSetCookieCallback.Create(proc));
end;

function TCefCookieManagerRef.DeleteCookies(const url, cookieName: ustring;
  const callback: ICefDeleteCookiesCallback): Boolean;
Var
  u, n : TCefString;
begin
  u := CefString(url);
  n := CefString(cookieName);
  Result := PCefCookieManager(fData)^.delete_cookies(fData, @u, @n, CefGetData(callback)) <> 0;
end;

function TCefCookieManagerRef.DeleteCookiesProc(const url, cookieName: ustring;
  const proc: TCefDeleteCookiesCallbackProc): Boolean;
begin
  Result := DeleteCookies(url, cookieName, TCefFastDeleteCookiesCallback.Create(proc));
end;

function TCefCookieManagerRef.SetStoragePath(const path: ustring; PersistSessionCookies: Boolean;
    callback: ICefCompletionCallback): Boolean;
Var
  p: TCefString;
begin
  p := CefString(path);

  Result := PCefCookieManager(fData)^.set_storage_path(fData, @p, Ord(PersistSessionCookies),
    CefGetData(callback)) <> 0;
end;

function TCefCookieManagerRef.FlushStore(handler: ICefCompletionCallback): Boolean;
begin
  Result := PCefCookieManager(fData)^.flush_store(fData, CefGetData(handler)) <> 0;
end;

class function TCefCookieManagerRef.UnWrap(data: Pointer): ICefCookieManager;
begin
  If data <> nil then Result := Create(data) as ICefCookieManager
  Else Result := nil;
end;

class function TCefCookieManagerRef.Global(callback: ICefCompletionCallback): ICefCookieManager;
begin
  Result := UnWrap(cef_cookie_manager_get_global_manager(CefGetData(callback)));
end;

class function TCefCookieManagerRef.New(const path: ustring; persistSessionCookies: Boolean;
  callback: ICefCompletionCallback): ICefCookieManager;
Var
  p : TCefString;
begin
  p := CefString(path);
  Result := UnWrap(cef_cookie_manager_create_manager(@p, Ord(persistSessionCookies), CefGetData(callback)));
end;

{ TCefFileDialogCallbackRef }

procedure TCefFileDialogCallbackRef.Cont(selectedAcceptFilter: Integer; filePaths: TStrings);
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

    PCefFileDialogCallback(fData)^.cont(fData, selectedAcceptFilter, list);
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefFileDialogCallbackRef.Cancel;
begin
  PCefFileDialogCallback(fData)^.cancel(fData);
end;

class function TCefFileDialogCallbackRef.UnWrap(data : Pointer) : ICefFileDialogCallback;
begin
  If data <> nil then Result := Create(data) as ICefFileDialogCallBack
  Else Result := nil;
end;

{ TCefDomDocumentRef }

function TCefDomDocumentRef.GetType : TCefDomDocumentType;
begin
  Result := PCefDomDocument(fData)^.get_type(fData);
end;

function TCefDomDocumentRef.GetDocument : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(fData)^.get_document(fData));
end;

function TCefDomDocumentRef.GetBody : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(fData)^.get_body(fData));
end;

function TCefDomDocumentRef.GetHead : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(fData)^.get_head(fData));
end;

function TCefDomDocumentRef.GetTitle : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(fData)^.get_title(fData));
end;

function TCefDomDocumentRef.GetElementById(const id : ustring) : ICefDomNode;
Var
  i : TCefString;
begin
  i := CefString(id);
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(fData)^.get_element_by_id(fData, @i));
end;

function TCefDomDocumentRef.GetFocusedNode : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomDocument(fData)^.get_focused_node(fData));
end;

function TCefDomDocumentRef.HasSelection : Boolean;
begin
  Result := PCefDomDocument(fData)^.has_selection(fData) <> 0;
end;

function TCefDomDocumentRef.GetSelectionStartOffset : Integer;
begin
  Result := PCefDomDocument(fData)^.get_selection_start_offset(fData);
end;

function TCefDomDocumentRef.GetSelectionEndOffset : Integer;
begin
  Result := PCefDomDocument(fData)^.get_selection_end_offset(fData);
end;

function TCefDomDocumentRef.GetSelectionAsMarkup : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(fData)^.get_selection_as_markup(fData));
end;

function TCefDomDocumentRef.GetSelectionAsText : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(fData)^.get_selection_as_text(fData));
end;

function TCefDomDocumentRef.GetBaseUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomDocument(fData)^.get_base_url(fData));
end;

function TCefDomDocumentRef.GetCompleteUrl(const partialURL : ustring) : ustring;
Var
  p : TCefString;
begin
  p := CefString(partialURL);
  Result := CefStringFreeAndGet(PCefDomDocument(fData)^.get_complete_url(fData, @p));
end;

class function TCefDomDocumentRef.UnWrap(data : Pointer) : ICefDomDocument;
begin
  If data <> nil then Result := Create(data) as ICefDomDocument
  Else Result := nil;
end;

{ TCefDomNodeRef }

function TCefDomNodeRef.GetType : TCefDomNodeType;
begin
  Result := PCefDomNode(fData)^.get_type(fData);
end;

function TCefDomNodeRef.IsText : Boolean;
begin
  Result := PCefDomNode(fData)^.is_text(fData) <> 0;
end;

function TCefDomNodeRef.IsElement : Boolean;
begin
  Result := PCefDomNode(fData)^.is_element(fData) <> 0;
end;

function TCefDomNodeRef.IsEditable : Boolean;
begin
  Result := PCefDomNode(fData)^.is_editable(fData) <> 0;
end;

function TCefDomNodeRef.IsFormControlElement : Boolean;
begin
  Result := PCefDomNode(fData)^.is_form_control_element(fData) <> 0;
end;

function TCefDomNodeRef.GetFormControlElementType : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_form_control_element_type(fData));
end;

function TCefDomNodeRef.IsSame(const that : ICefDomNode) : Boolean;
begin
  Result := PCefDomNode(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefDomNodeRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_name(fData));
end;

function TCefDomNodeRef.GetValue : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_value(fData));
end;

function TCefDomNodeRef.SetValue(const value : ustring) : Boolean;
Var
  v: TCefString;
begin
  v := CefString(value);
  Result := PCefDomNode(fData)^.set_value(fData, @v) <> 0;
end;

function TCefDomNodeRef.GetAsMarkup : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_as_markup(fData));
end;

function TCefDomNodeRef.GetDocument : ICefDomDocument;
begin
  Result := TCefDomDocumentRef.UnWrap(PCefDomNode(fData)^.get_document(fData));
end;

function TCefDomNodeRef.GetParent : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(fData)^.get_parent(fData));
end;

function TCefDomNodeRef.GetPreviousSibling : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(fData)^.get_previous_sibling(fData));
end;

function TCefDomNodeRef.GetNextSibling : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(fData)^.get_next_sibling(fData));
end;

function TCefDomNodeRef.HasChildren : Boolean;
begin
  Result := PCefDomNode(fData)^.has_children(fData) <> 0;
end;

function TCefDomNodeRef.GetFirstChild : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(fData)^.get_first_child(fData));
end;

function TCefDomNodeRef.GetLastChild : ICefDomNode;
begin
  Result := TCefDomNodeRef.UnWrap(PCefDomNode(fData)^.get_last_child(fData));
end;

function TCefDomNodeRef.GetElementTagName : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_element_tag_name(fData));
end;

function TCefDomNodeRef.HasElementAttributes : Boolean;
begin
  Result := PCefDomNode(fData)^.has_element_attributes(fData) <> 0;
end;

function TCefDomNodeRef.HasElementAttribute(const attrName : ustring) : Boolean;
Var
  a : TCefString;
begin
  a := CefString(attrName);
  Result := PCefDomNode(fData)^.has_element_attribute(fData, @a) <> 0;
end;

function TCefDomNodeRef.GetElementAttribute(const attrName : ustring) : ustring;
Var
  a : TCefString;
begin
  a := CefString(attrName);
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_element_attribute(fData, @a));
end;

procedure TCefDomNodeRef.GetElementAttributes(const attrMap : ICefStringMap);
begin
  PCefDomNode(fData)^.get_element_attributes(fData, attrMap.Handle);
end;

function TCefDomNodeRef.SetElementAttribute(const attrName, value : ustring) : Boolean;
Var
  a, v : TCefString;
begin
  a := CefString(attrName);
  v := CefString(value);
  Result := PCefDomNode(fData)^.set_element_attribute(fData, @a, @v) <> 0;
end;

function TCefDomNodeRef.GetElementInnerText : ustring;
begin
  Result := CefStringFreeAndGet(PCefDomNode(fData)^.get_element_inner_text(fData));
end;

function TCefDomNodeRef.GetElementBounds: TCefRect;
begin
  Result := PCefDomNode(fData)^.get_element_bounds(fData);
end;

class function TCefDomNodeRef.UnWrap(data : Pointer) : ICefDomNode;
begin
  If data <> nil then Result := Create(data) as ICefDomNode
  Else Result := nil;
end;

{ TCefBeforeDownloadCallbackRef }

procedure TCefBeforeDownloadCallbackRef.Cont(const downloadPath : ustring; showDialog : Boolean);
Var
  d : TCefString;
begin
  d := CefString(downloadPath);
  PCefBeforeDownloadCallback(fData)^.cont(fData, @d, Ord(showDialog));
end;

class function TCefBeforeDownloadCallbackRef.UnWrap(data : Pointer) : ICefBeforeDownloadCallback;
begin
  If data <> nil then Result := Create(data) as ICefBeforeDownloadCallback
  Else Result := nil;
end;

{ TCefDownloadItemCallbackRef }

procedure TCefDownloadItemCallbackRef.Cancel;
begin
  PCefDownloadItemCallback(fData)^.cancel(fData);
end;

procedure TCefDownloadItemCallbackRef.Pause;
begin
  PCefDownloadItemCallback(fData)^.pause(fData);
end;

procedure TCefDownloadItemCallbackRef.Resume;
begin
  PCefDownloadItemCallback(fData)^.resume(fData);
end;

class function TCefDownloadItemCallbackRef.UnWrap(data : Pointer) : ICefDownloadItemCallback;
begin
  If data <> nil then Result := Create(data) as ICefDownloadItemCallback
  Else Result := nil;
end;

{ TCefDownLoadItemRef }

function TCefDownloadItemRef.IsValid: Boolean;
begin
  Result := PCefDownloadItem(fData)^.is_valid(fData) <> 0;
end;

function TCefDownloadItemRef.IsInProgress: Boolean;
begin
  Result := PCefDownloadItem(fData)^.is_in_progress(fData) <> 0;
end;

function TCefDownloadItemRef.IsComplete: Boolean;
begin
  Result := PCefDownloadItem(fData)^.is_complete(fData) <> 0;
end;

function TCefDownloadItemRef.IsCanceled: Boolean;
begin
  Result := PCefDownloadItem(fData)^.is_canceled(fData) <> 0;
end;

function TCefDownloadItemRef.GetCurrentSpeed: Int64;
begin
  Result := PCefDownloadItem(fData)^.get_current_speed(fData);
end;

function TCefDownloadItemRef.GetPercentComplete: Integer;
begin
  Result := PCefDownloadItem(fData)^.get_percent_complete(fData);
end;

function TCefDownloadItemRef.GetTotalBytes: Int64;
begin
  Result := PCefDownloadItem(fData)^.get_total_bytes(fData);
end;

function TCefDownloadItemRef.GetReceivedBytes: Int64;
begin
  Result := PCefDownloadItem(fData)^.get_received_bytes(fData);
end;

function TCefDownloadItemRef.GetStartTime: TDateTime;
begin
  Result := CefTimeToDateTime(PCefDownloadItem(fData)^.get_start_time(fData));
end;

function TCefDownloadItemRef.GetEndTime: TDateTime;
begin
  Result := CefTimeToDateTime(PCefDownloadItem(fData)^.get_end_time(fData));
end;

function TCefDownloadItemRef.GetFullPath: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(fData)^.get_full_path(fData));
end;

function TCefDownloadItemRef.GetId : UInt32;
begin
  Result := PCefDownloadItem(fData)^.get_id(fData);
end;

function TCefDownloadItemRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(fData)^.get_url(fData));
end;

function TCefDownloadItemRef.GetOriginalUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(fData)^.get_original_url(fData));
end;

function TCefDownloadItemRef.GetSuggestedFileName: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(fData)^.get_suggested_file_name(fData));
end;

function TCefDownloadItemRef.GetContentDisposition: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(fData)^.get_content_disposition(fData));
end;

function TCefDownloadItemRef.GetMimeType: ustring;
begin
  Result := CefStringFreeAndGet(PCefDownloadItem(fData)^.get_mime_type(fData));
end;

class function TCefDownloadItemRef.UnWrap(data: Pointer): ICefDownLoadItem;
begin
  If data <> nil then Result := Create(data) as ICefDownloadItem
  Else Result := nil;
end;

{ TCefDragDataRef }

function TCefDragDataRef.Clone: ICefDragData;
begin
  Result := UnWrap(PCefDragData(fData)^.clone(fData));
end;

function TCefDragDataRef.IsReadOnly: Boolean;
begin
  Result := PCefDragData(fData)^.is_read_only(fData) <> 0;
end;

function TCefDragDataRef.IsLink: Boolean;
begin
  Result := PCefDragData(fData)^.is_link(fData) <> 0;
end;

function TCefDragDataRef.IsFragment: Boolean;
begin
  Result := PCefDragData(fData)^.is_fragment(fData) <> 0;
end;

function TCefDragDataRef.IsFile: Boolean;
begin
  Result := PCefDragData(fData)^.is_file(fData) <> 0;
end;

function TCefDragDataRef.GetLinkUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_link_url(fData));
end;

function TCefDragDataRef.GetLinkTitle: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_link_title(fData));
end;

function TCefDragDataRef.GetLinkMetadata: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_link_metadata(fData));
end;

function TCefDragDataRef.GetFragmentText: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_fragment_text(fData));
end;

function TCefDragDataRef.GetFragmentHTML: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_fragment_html(fData));
end;

function TCefDragDataRef.GetFragmentBaseURL: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_fragment_base_url(fData));
end;

function TCefDragDataRef.GetFileName: ustring;
begin
  Result := CefStringFreeAndGet(PCefDragData(fData)^.get_file_name(fData));
end;

function TCefDragDataRef.GetFileContents(writer: ICefStreamWriter): TSize;
begin
  Result := PCefDragData(fData)^.get_file_contents(fData, CefGetData(writer));
end;

function TCefDragDataRef.GetFileNames(names: TStrings): Boolean;
Var
  list: TCefStringList;
  i   : Integer;
  str : TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefDragData(fData)^.get_file_names(fData, list) <> 0;
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

procedure TCefDragDataRef.SetLinkUrl(const url: ustring);
Var
  u: TCefString;
begin
  u := CefString(url);
  PCefDragData(fData)^.set_link_url(fData, @u);
end;

procedure TCefDragDataRef.SetLinkTitle(const title: ustring);
Var
  t: TCefString;
begin
  t := CefString(title);
  PCefDragData(fData)^.set_link_title(fData, @t);
end;

procedure TCefDragDataRef.SetLinkMetadata(const data: ustring);
Var
  d: TCefString;
begin
  d := CefString(data);
  PCefDragData(fData)^.set_link_metadata(fData, @d);
end;

procedure TCefDragDataRef.SetFragmentText(const text: ustring);
Var
  t: TCefString;
begin
  t := CefString(text);
  PCefDragData(fData)^.set_fragment_text(fData, @t);
end;

procedure TCefDragDataRef.SetFragmentHtml(const html: ustring);
Var
  h: TCefString;
begin
  h := CefString(html);
  PCefDragData(fData)^.set_fragment_html(fData, @h);
end;

procedure TCefDragDataRef.SetFragmentBaseUrl(const baseUrl: ustring);
Var
  b: TCefString;
begin
  b := CefString(baseUrl);
  PCefDragData(fData)^.set_fragment_base_url(fData, @b);
end;

procedure TCefDragDataRef.ResetFileContents;
begin
  PCefDragData(fData)^.reset_file_contents(fData);
end;

procedure TCefDragDataRef.AddFile(const path, displayName: ustring);
begin

end;

class function TCefDragDataRef.UnWrap(data: Pointer): ICefDragData;
begin
  If data <> nil then Result := Create(data) as ICefDragData
  Else Result := nil;
end;

{ TCefFrameRef }

function TCefFrameRef.IsValid : Boolean;
begin
  Result := PCefFrame(fData)^.is_valid(fData) <> 0;
end;

procedure TCefFrameRef.Undo;
begin
  PCefFrame(fData)^.undo(fData);
end;

procedure TCefFrameRef.Redo;
begin
  PCefFrame(fData)^.redo(fData);
end;

procedure TCefFrameRef.Cut;
begin
  PCefFrame(fData)^.cut(fData);
end;

procedure TCefFrameRef.Copy;
begin
  PCefFrame(fData)^.copy(fData);
end;

procedure TCefFrameRef.Paste;
begin
  PCefFrame(fData)^.paste(fData);
end;

procedure TCefFrameRef.Del;
begin
  PCefFrame(fData)^.del(fData);
end;

procedure TCefFrameRef.SelectAll;
begin
  PCefFrame(fData)^.select_all(fData);
end;

procedure TCefFrameRef.ViewSource;
begin
  PCefFrame(fData)^.view_source(fData);
end;

procedure TCefFrameRef.GetSource(const visitor : ICefStringVisitor);
begin
  PCefFrame(fData)^.get_source(fData, CefGetData(visitor));
end;

procedure TCefFrameRef.GetSourceProc(const proc : TCefStringVisitorProc);
begin
  GetSource(TCefFastStringVisitor.Create(proc));
end;

procedure TCefFrameRef.GetText(const visitor : ICefStringVisitor);
begin
  PCefFrame(fData)^.get_text(fData, CefGetData(visitor));
end;

procedure TCefFrameRef.GetTextProc(const proc : TCefStringVisitorProc);
begin
  GetText(TCefFastStringVisitor.Create(proc));
end;

procedure TCefFrameRef.LoadRequest(const request : ICefRequest);
begin
  PCefFrame(fData)^.load_request(fData, CefGetData(request));
end;

procedure TCefFrameRef.LoadUrl(const url : ustring);
Var
  u : TCefString;
begin
  u := CefString(url);
  PCefFrame(fData)^.load_url(fData, @u);
end;

procedure TCefFrameRef.LoadString(const str, url : ustring);
Var
  s, u : TCefString;
begin
  s := CefString(str);
  u := CefString(url);
  PCefFrame(fData)^.load_string(fData, @s, @u);
end;

procedure TCefFrameRef.ExecuteJavaScript(const code, scriptUrl : ustring;
  startLine : Integer);
Var
  j, s : TCefString;
begin
  j := CefString(code);
  s := CefString(scriptUrl);
  PCefFrame(fData)^.execute_java_script(fData, @j, @s, startLine);
end;

function TCefFrameRef.IsMain : Boolean;
begin
  Result := PCefFrame(fData)^.is_main(fData) <> 0;
end;

function TCefFrameRef.IsFocused : Boolean;
begin
  Result := PCefFrame(fData)^.is_focused(fData) <> 0;
end;

function TCefFrameRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(fData)^.get_name(fData));
end;

function TCefFrameRef.GetIdentifier : Int64;
begin
  Result := PCefFrame(fData)^.get_identifier(fData);
end;

function TCefFrameRef.GetParent : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefFrame(fData)^.get_parent(fData));
end;

function TCefFrameRef.GetUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(fData)^.get_url(fData));
end;

function TCefFrameRef.GetBrowser : ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefFrame(fData)^.get_browser(fData));
end;

function TCefFrameRef.GetV8Context : ICefV8Context;
begin
  Result := TCefV8ContextRef.UnWrap(PCefFrame(fData)^.get_v8context(fData));
end;

procedure TCefFrameRef.VisitDom(const visitor : ICefDomVisitor);
begin
  PCefFrame(fData)^.visit_dom(PCefFrame(fData), CefGetData(visitor));
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
  PCefGeolocationCallback(fData)^.cont(fData, Ord(allow));
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
  PCefJsDialogCallback(fData)^.cont(fData, Ord(success), @u);
end;

class function TCefJsDialogCallbackRef.UnWrap(data : Pointer) : ICefJsDialogCallback;
begin
  If data <> nil then Result := Create(data) as ICefJsDialogCallback
  Else Result := nil;
end;

{ TCefImageRef }

function TCefImageRef.IsEmpty: Boolean;
begin
  Result := PCefImage(fData)^.is_empty(fData) <> 0;
end;

function TCefImageRef.IsSame(const that: ICefImage): Boolean;
begin
  Result := PCefImage(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefImageRef.AddBitmap(scaleFactor: Single; pixelWidth, pixelHeight: Integer;
  colorType: TCefColorType; alphaType: TCefAlphaType; const pixelData: Pointer;
  pixelDataSize: TSize): Boolean;
begin
  Result := PCefImage(fData)^.add_bitmap(fData, scaleFactor, pixelWidth, pixelHeight, colorType,
    alphaType, pixelData, pixelDataSize) <> 0;
end;

function TCefImageRef.AddPng(scaleFactor: Single; const pngData: Pointer;
  pngDataSize: TSize): Boolean;
begin
  Result := PCefImage(fData)^.add_png(fData, scaleFactor, pngData, pngDataSize) <> 0;
end;

function TCefImageRef.AddJpeg(scaleFactor: Single; const jpegData: Pointer;
  jpegDataSize: TSize): Boolean;
begin
  Result := PCefImage(fData)^.add_jpeg(fData, scaleFactor, jpegData, jpegDataSize) <> 0;
end;

function TCefImageRef.GetWidth: TSize;
begin
  Result := PCefImage(fData)^.get_width(fData);
end;

function TCefImageRef.GetHeight: TSize;
begin
  Result := PCefImage(fData)^.get_height(fData);
end;

function TCefImageRef.HasRepresentation(scaleFactor: Single): Boolean;
begin
  Result := PCefImage(fData)^.has_representation(fData, scaleFactor) <> 0;
end;

function TCefImageRef.RemoveRepresentation(scaleFactor: Single): Boolean;
begin
  Result := PCefImage(fData)^.remove_representation(fData, scaleFactor) <> 0;
end;

function TCefImageRef.GetRepresentationInfo(scaleFactor: Single; actualScaleFactor: PSingle;
  pixelWidth, pixelHeight: PInteger): Boolean;
begin
  Result := PCefImage(fData)^.get_representation_info(fData, scaleFactor, actualScaleFactor,
    pixelWidth, pixelHeight) <> 0;
end;

function TCefImageRef.GetAsBitmap(scaleFactor: Single; colorType: TCefColorType;
  alphaType: TCefAlphaType; pixelWidth, pixelHeight: PInteger): ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(
    PCefImage(fData)^.get_as_bitmap(fData, scaleFactor, colorType, alphaType, pixelWidth, pixelHeight)
  );
end;

function TCefImageRef.GetAsPng(scaleFactor: Single; withTransparency: Boolean;
  pixelWidth, pixelHeight: PInteger): ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(
    PCefImage(fData)^.get_as_png(fData, scaleFactor, Ord(withTransparency), pixelWidth, pixelHeight)
  );
end;

function TCefImageRef.GetAsJpeg(scaleFactor: Single; quality: Integer;
  pixelWidth, pixelHeight: PInteger): ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(
    PCefImage(fData)^.get_as_jpeg(fData, scaleFactor, quality, pixelWidth, pixelHeight)
  );
end;

class function TCefImageRef.UnWrap(data: Pointer): ICefImage;
begin
  If data <> nil then Result := Create(data) as ICefImage
  Else Result := nil;
end;

{ TCefMenuModelRef }

function TCefMenuModelRef.IsSubMenu: Boolean;
begin
  Result := PCefMenuModel(fData)^.is_sub_menu(fData) <> 0;
end;

function TCefMenuModelRef.Clear : Boolean;
begin
  Result := PCefMenuModel(fData)^.clear(fData) <> 0;
end;

function TCefMenuModelRef.GetCount : Integer;
begin
  Result := PCefMenuModel(fData)^.get_count(fData);
end;

function TCefMenuModelRef.AddSeparator : Boolean;
begin
  Result := PCefMenuModel(fData)^.add_separator(fData) <> 0;
end;

function TCefMenuModelRef.AddItem(commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.add_item(fData, commandId, @t) <> 0;
end;

function TCefMenuModelRef.AddCheckItem(commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.add_check_item(fData, commandId, @t) <> 0;
end;

function TCefMenuModelRef.AddRadioItem(commandId : Integer;
  const text : ustring; groupId : Integer) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.add_radio_item(fData, commandId, @t, groupId) <> 0;
end;

function TCefMenuModelRef.AddSubMenu(commandId : Integer;
  const text : ustring) : ICefMenuModel;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(fData)^.add_sub_menu(fData, commandId, @t));
end;

function TCefMenuModelRef.InsertSeparatorAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.insert_separator_at(fData, index) <> 0;
end;

function TCefMenuModelRef.InsertItemAt(index, commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.insert_item_at(fData, index, commandId, @t) <> 9;
end;

function TCefMenuModelRef.InsertCheckItemAt(index, commandId : Integer;
  const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.insert_check_item_at(fData, index, commandId, @t) <> 9;
end;

function TCefMenuModelRef.InsertRadioItemAt(index, commandId : Integer;
  const text : ustring; groupId : Integer) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.insert_radio_item_at(fData, index, commandId, @t, groupId) <> 9;
end;

function TCefMenuModelRef.InsertSubMenuAt(index, commandId : Integer;
  const text : ustring) : ICefMenuModel;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(fData)^.insert_sub_menu_at(fData, index, commandId, @t));
end;

function TCefMenuModelRef.Remove(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.remove(fData, commandId) <> 0;
end;

function TCefMenuModelRef.RemoveAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.remove_at(fData, index) <> 0;
end;

function TCefMenuModelRef.GetIndexOf(commandId : Integer) : Integer;
begin
  Result := PCefMenuModel(fData)^.get_index_of(fData, commandId);
end;

function TCefMenuModelRef.GetCommandIdAt(index : Integer) : Integer;
begin
  Result := PCefMenuModel(fData)^.get_command_id_at(fData, index);
end;

function TCefMenuModelRef.SetCommandIdAt(index, commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_command_id_at(fData, index, commandId) <> 0;
end;

function TCefMenuModelRef.GetLabel(commandId : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefMenuModel(fData)^.get_label(fData, commandId));
end;

function TCefMenuModelRef.GetLabelAt(index : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefMenuModel(fData)^.get_label_at(fData, index));
end;

function TCefMenuModelRef.SetLabel(commandId : Integer; const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.set_label(fData, commandId, @t) <> 0;
end;

function TCefMenuModelRef.SetLabelAt(index : Integer; const text : ustring) : Boolean;
Var
  t : TCefString;
begin
  t := CefString(text);
  Result := PCefMenuModel(fData)^.set_label_at(fData, index, @t) <> 0;
end;

function TCefMenuModelRef.GetType(commandId : Integer) : TCefMenuItemType;
begin
  Result := PCefMenuModel(fData)^.get_type(fData, commandId);
end;

function TCefMenuModelRef.GetTypeAt(index : Integer) : TCefMenuItemType;
begin
  Result := PCefMenuModel(fData)^.get_type_at(fData, index);
end;

function TCefMenuModelRef.GetGroupId(commandId : Integer) : Integer;
begin
  Result := PCefMenuModel(fData)^.get_group_id(fData, commandId);
end;

function TCefMenuModelRef.GetGroupIdAt(index : Integer) : Integer;
begin
  Result := PCefMenuModel(fData)^.get_group_id_at(fData, index);
end;

function TCefMenuModelRef.SetGroupId(commandId, groupId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_group_id(fData, commandId, groupId) <> 0;
end;

function TCefMenuModelRef.SetGroupIdAt(index, groupId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_group_id_at(fData, index, groupId) <> 0;
end;

function TCefMenuModelRef.GetSubMenu(commandId : Integer) : ICefMenuModel;
begin
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(fData)^.get_sub_menu(fData, commandId));
end;

function TCefMenuModelRef.GetSubMenuAt(index : Integer) : ICefMenuModel;
begin
  Result := TCefMenuModelRef.UnWrap(PCefMenuModel(fData)^.get_sub_menu_at(fData, index));
end;

function TCefMenuModelRef.IsVisible(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.is_visible(fData, commandId) <> 0;
end;

function TCefMenuModelRef.isVisibleAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.is_visible_at(fData, index) <> 0;
end;

function TCefMenuModelRef.SetVisible(commandId : Integer; visible : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_visible(fData, commandId, Ord(visible)) <> 0;
end;

function TCefMenuModelRef.SetVisibleAt(index : Integer; visible : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_visible_at(fData, index, Ord(visible)) <> 0;
end;

function TCefMenuModelRef.IsEnabled(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.is_enabled(fData, commandId) <> 0;
end;

function TCefMenuModelRef.IsEnabledAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.is_enabled_at(fData, index) <> 0;
end;

function TCefMenuModelRef.SetEnabled(commandId : Integer; enabled : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_enabled(fData, commandId, Ord(enabled)) <> 0;
end;

function TCefMenuModelRef.SetEnabledAt(index : Integer; enabled : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_enabled_at(fData, index, Ord(enabled)) <> 0;
end;

function TCefMenuModelRef.IsChecked(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.is_checked(fData, commandId) <> 0;
end;

function TCefMenuModelRef.IsCheckedAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.is_checked_at(fData, index) <> 0;
end;

function TCefMenuModelRef.setChecked(commandId : Integer;
  checked : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_checked(fData, commandId, Ord(checked)) <> 0;
end;

function TCefMenuModelRef.setCheckedAt(index : Integer; checked : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_checked_at(fData, index, Ord(checked)) <> 0;
end;

function TCefMenuModelRef.HasAccelerator(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.has_accelerator(fData, commandId) <> 0;
end;

function TCefMenuModelRef.HasAcceleratorAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.has_accelerator_at(fData, index) <> 0;
end;

function TCefMenuModelRef.SetAccelerator(commandId, keyCode : Integer;
  shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_accelerator(fData, commandId, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TCefMenuModelRef.SetAcceleratorAt(index, keyCode : Integer;
  shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
begin
  Result := PCefMenuModel(fData)^.set_accelerator_at(fData, index, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TCefMenuModelRef.RemoveAccelerator(commandId : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.remove_accelerator(fData, commandId) <> 0;
end;

function TCefMenuModelRef.RemoveAcceleratorAt(index : Integer) : Boolean;
begin
  Result := PCefMenuModel(fData)^.remove_accelerator_at(fData, index) <> 0;
end;

function TCefMenuModelRef.GetAccelerator(commandId : Integer;
  out keyCode : Integer; out shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
Var
  sp, cp, ap : Integer;
begin
  Result := PCefMenuModel(fData)^.get_accelerator(fData, commandId, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TCefMenuModelRef.GetAcceleratorAt(index : Integer;
  out keyCode : Integer; out shiftPressed, ctrlPressed, altPressed : Boolean) : Boolean;
Var
  sp, cp, ap : Integer;
begin
  Result := PCefMenuModel(fData)^.get_accelerator_at(fData, index, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TCefMenuModelRef.SetColor(commandId: Integer; colorType: TCefMenuColorType;
  color: TCefColor): Boolean;
begin
  Result := PCefMenuModel(fData)^.set_color(fData, commandId, colorType, color) <> 0;
end;

function TCefMenuModelRef.SetColorAt(index: Integer; colorType: TCefMenuColorType;
  color: TCefColor): Boolean;
begin
  Result := PCefMenuModel(fData)^.set_color_at(fData, index, colorType, color) <> 0;
end;

function TCefMenuModelRef.GetColor(commandId: Integer; colorType: TCefMenuColorType;
  out color: TCefColor): Boolean;
begin
  Result := PCefMenuModel(fData)^.get_color(fData, commandId, colorType, @color) <> 0;
end;

function TCefMenuModelRef.GetColorAt(index: Integer; colorType: TCefMenuColorType;
  out color: TCefColor): Boolean;
begin
  Result := PCefMenuModel(fData)^.get_color_at(fData, index, colorType, @color) <> 0;
end;

function TCefMenuModelRef.SetFontList(commandId: Integer; const fontList: ustring): Boolean;
Var
  f: TCefString;
begin
  f := CefString(fontList);
  Result := PCefMenuModel(fData)^.set_font_list(fData, commandId, @f) <> 0;
end;

function TCefMenuModelRef.SetFontListAt(index: Integer; const fontList: ustring): Boolean;
Var
  f: TCefString;
begin
  f := CefString(fontList);
  Result := PCefMenuModel(fData)^.set_font_list_at(fData, index, @f) <> 0;
end;

class function TCefMenuModelRef.UnWrap(data : Pointer) : ICefMenuModel;
begin
  If data <> nil then Result := Create(data) as ICefMenuModel
  Else Result := nil;
end;

{ TCefNavigationEntryRef }

function TCefNavigationEntryRef.IsValid: Boolean;
begin
  Result := PCefNavigationEntry(fData)^.is_valid(fData) <> 0;
end;

function TCefNavigationEntryRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefNavigationEntry(fData)^.get_url(fData));
end;

function TCefNavigationEntryRef.GetDisplayUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefNavigationEntry(fData)^.get_display_url(fData));
end;

function TCefNavigationEntryRef.GetOriginalUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefNavigationEntry(fData)^.get_original_url(fData));
end;

function TCefNavigationEntryRef.GetTitle: ustring;
begin
  Result := CefStringFreeAndGet(PCefNavigationEntry(fData)^.get_title(fData));
end;

function TCefNavigationEntryRef.GetTransitionType: TCefTransitionType;
begin
  Result := PCefNavigationEntry(fData)^.get_transition_type(fData);
end;

function TCefNavigationEntryRef.HasPostData: Boolean;
begin
  Result := PCefNavigationEntry(fData)^.has_post_data(fData) <> 0;
end;

function TCefNavigationEntryRef.GetCompletionTime: TDateTime;
begin
  Result := CefTimeToDateTime(PCefNavigationEntry(fData)^.get_completion_time(fData));
end;

function TCefNavigationEntryRef.GetHttpStatusCode: Integer;
begin
  Result := PCefNavigationEntry(fData)^.get_http_status_code(fData);
end;

function TCefNavigationEntryRef.GetSslStatus: ICefSslStatus;
begin
  Result := TCefSslStatusRef.UnWrap(PCefNavigationEntry(fData)^.get_sslstatus(fData));
end;

class function TCefNavigationEntryRef.UnWrap(data: Pointer): ICefNavigationEntry;
begin
  If data <> nil then Result := Create(data) as ICefNavigationEntry
  Else Result := nil;
end;

{ TCefPrintDialogCallbackRef }

procedure TCefPrintDialogCallbackRef.Cont(settings: ICefPrintSettings);
begin
  PCefPrintDialogCallback(fData)^.cont(fData, CefGetData(settings));
end;

procedure TCefPrintDialogCallbackRef.Cancel;
begin
  PCefPrintDialogCallback(fData)^.cancel(fData);
end;

class function TCefPrintDialogCallbackRef.UnWrap(data: Pointer): ICefPrintDialogCallback;
begin
  If data <> nil then Result := Create(data) as ICefPrintDialogCallback
  Else Result := nil;
end;

{ TCefPrintJobCallbackRef }

procedure TCefPrintJobCallbackRef.Cont;
begin
  PCefPrintJobCallback(fData)^.cont(fData);
end;

class function TCefPrintJobCallbackRef.UnWrap(data: Pointer): ICefPrintJobCallback;
begin
  If data <> nil then Result := Create(data) as ICefPrintJobCallback
  Else Result := nil;
end;

{ TCefPrintSettingsRef }

function TCefPrintSettingsRef.IsValid: Boolean;
begin
  Result := PCefPrintSettings(fData)^.is_valid(fData) <> 0;
end;

function TCefPrintSettingsRef.IsReadOnly: Boolean;
begin
  Result := PCefPrintSettings(fData)^.is_read_only(fData) <> 0;
end;

function TCefPrintSettingsRef.Copy: ICefPrintSettings;
begin
  Result := UnWrap(PCefPrintSettings(fData)^.copy(fData));
end;

procedure TCefPrintSettingsRef.SetOrientation(landscape: Boolean);
begin
  PCefPrintSettings(fData)^.set_orientation(fData, Ord(landscape));
end;

function TCefPrintSettingsRef.IsLandscape: Boolean;
begin
  Result := PCefPrintSettings(fData)^.is_landscape(fData) <> 0;
end;

procedure TCefPrintSettingsRef.SetPrinterPrintableArea(const physicalSizeDeviceUnits: TCefSize;
  const printableAreaDeviceUnits: TCefRect; landscapeNeedsFlip: Boolean);
begin
  PCefPrintSettings(fData)^.set_printer_printable_area(fData, @physicalSizeDeviceUnits,
    @printableAreaDeviceUnits, Ord(landscapeNeedsFlip));
end;

procedure TCefPrintSettingsRef.SetDeviceName(const name: ustring);
Var
  n: TCefString;
begin
  n := CefString(name);
  PCefPrintSettings(fData)^.set_device_name(fData, @n);
end;

function TCefPrintSettingsRef.GetDeviceName: ustring;
begin
  Result := CefStringFreeAndGet(PCefPrintSettings(fData)^.get_device_name(fData));
end;

procedure TCefPrintSettingsRef.SetDpi(dpi: Integer);
begin
  PCefPrintSettings(fData)^.set_dpi(fData, dpi);
end;

function TCefPrintSettingsRef.GetDpi: Integer;
begin
  Result := PCefPrintSettings(fData)^.get_dpi(fData);
end;

procedure TCefPrintSettingsRef.SetPageRanges(rangesCount: TSize; const ranges: TCefRangeArray);
begin
  PCefPrintSettings(fData)^.set_page_ranges(fData, rangesCount, @ranges);
end;

function TCefPrintSettingsRef.GetPageRangesCount: TSize;
begin
  Result := PCefPrintSettings(fData)^.get_page_ranges_count(fData);
end;

procedure TCefPrintSettingsRef.GetPageRanges(rangesCount: TSize; out ranges: TCefRangeArray);
begin
  PCefPrintSettings(fData)^.get_page_ranges(fData, rangesCount, @ranges);
end;

procedure TCefPrintSettingsRef.SetSelectionOnly(selectionOnly: Boolean);
begin
  PCefPrintSettings(fData)^.set_selection_only(fData, Ord(selectionOnly));
end;

function TCefPrintSettingsRef.IsSelectionOnly: Boolean;
begin
  Result := PCefPrintSettings(fData)^.is_selection_only(fData) <> 0;
end;

procedure TCefPrintSettingsRef.SetCollate(collate: Boolean);
begin
  PCefPrintSettings(fData)^.set_collate(fData, Ord(collate));
end;

function TCefPrintSettingsRef.WillCollate: Boolean;
begin
  Result := PCefPrintSettings(fData)^.will_collate(fData) <> 0;
end;

procedure TCefPrintSettingsRef.SetColorModel(model: TCefColorModel);
begin
  PCefPrintSettings(fData)^.set_color_model(fData, model);
end;

function TCefPrintSettingsRef.GetColorModel: TCefColorModel;
begin
  Result := PCefPrintSettings(fData)^.get_color_model(fData);
end;

procedure TCefPrintSettingsRef.SetCopies(copies: Integer);
begin
  PCefPrintSettings(fData)^.set_copies(fData, copies);
end;

function TCefPrintSettingsRef.GetCopies: Integer;
begin
  Result := PCefPrintSettings(fData)^.get_copies(fData);
end;

procedure TCefPrintSettingsRef.SetDuplexMode(mode: TCefDuplexMode);
begin
  PCefPrintSettings(fData)^.set_duplex_mode(fData, mode);
end;

function TCefPrintSettingsRef.GetDuplexMode: TCefDuplexMode;
begin
  Result := PCefPrintSettings(fData)^.get_duplex_mode(fData);
end;

class function TCefPrintSettingsRef.UnWrap(data: Pointer): ICefPrintSettings;
begin
  If data <> nil then Result := Create(data) as ICefPrintSettings
  Else Result := nil;
end;

class function TCefPrintSettingsRef.New: ICefPrintSettings;
begin
  Result := UnWrap(cef_print_settings_create());
end;

{ TCefProcessMessageRef }

function TCefProcessMessageRef.IsValid : Boolean;
begin
  Result := PCefProcessMessage(fData)^.is_valid(fData) <> 0;
end;

function TCefProcessMessageRef.IsReadOnly : Boolean;
begin
  Result := PCefProcessMessage(fData)^.is_read_only(fData) <> 0;
end;

function TCefProcessMessageRef.Copy : ICefProcessMessage;
begin
  Result := UnWrap(PCefProcessMessage(fData)^.copy(fData));
end;

function TCefProcessMessageRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefProcessMessage(fData)^.get_name(fData));
end;

function TCefProcessMessageRef.GetArgumentList : ICefListValue;
begin
  Result := TCefListValueRef.UnWrap(PCefProcessMessage(fData)^.get_argument_list(fData));
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
  Result := PCefRequest(fData)^.is_read_only(fData) <> 0;
end;

function TCefRequestRef.GetUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(fData)^.get_url(fData));
end;

function TCefRequestRef.GetMethod : ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(fData)^.get_method(fData));
end;

function TCefRequestRef.GetPostData : ICefPostData;
begin
  Result := TCefPostDataRef.UnWrap(PCefRequest(fData)^.get_post_data(fData));
end;

procedure TCefRequestRef.GetHeaderMap(const HeaderMap : ICefStringMultimap);
begin
  PCefRequest(fData)^.get_header_map(fData, HeaderMap.Handle);
end;

procedure TCefRequestRef.SetUrl(const value : ustring);
Var
  v: TCefString;
begin
  v := CefString(value);
  PCefRequest(fData)^.set_url(fData, @v);
end;

procedure TCefRequestRef.SetMethod(const value : ustring);
Var
  v: TCefString;
begin
  v := CefString(value);
  PCefRequest(fData)^.set_method(fData, @v);
end;

procedure TCefRequestRef.SetReferrer(const referrerUrl: ustring; policy: TCefReferrerPolicy);
Var
  r: TCefString;
begin
  r := CefString(referrerUrl);
  PCefRequest(fData)^.set_referrer(fData, @r, policy);
end;

function TCefRequestRef.GetReferrerUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(fData)^.get_referrer_url(fData));
end;

function TCefRequestRef.GetReferrerPolicy: TCefReferrerPolicy;
begin
  Result := PCefRequest(fData)^.get_referrer_policy(fData);
end;

procedure TCefRequestRef.SetPostData(const value : ICefPostData);
begin
  If value <> nil then
    PCefRequest(fData)^.set_post_data(fData, CefGetData(value));
end;

procedure TCefRequestRef.SetHeaderMap(const HeaderMap : ICefStringMultimap);
begin
  PCefRequest(fData)^.set_header_map(fData, HeaderMap.Handle);
end;

function TCefRequestRef.GetFlags : TCefUrlRequestFlags;
begin
  Result := PCefRequest(fData)^.get_flags(fData);
end;

procedure TCefRequestRef.SetFlags(flags : TCefUrlRequestFlags);
begin
  PCefRequest(fData)^.set_flags(fData, PByte(@flags)^);
end;

function TCefRequestRef.GetFirstPartyForCookies : ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(fData)^.get_first_party_for_cookies(fData));
end;

procedure TCefRequestRef.SetFirstPartyForCookies(const url : ustring);
Var
  u : TCefString;
begin
  u := CefString(url);
  PCefRequest(fData)^.set_first_party_for_cookies(fData, @u);
end;

function TCefRequestRef.GetResourceType : TCefResourceType;
begin
  Result := PCefRequest(fData)^.get_resource_type(fData);
end;

function TCefRequestRef.GetTransitionType : TCefTransitionType;
begin
  Result := PCefRequest(fData)^.get_transition_type(fData);
end;

procedure TCefRequestRef.Assign(const url, method : ustring;
  const postData : ICefPostData; const headerMap : ICefStringMultimap);
Var
  u, m : TCefString;
begin
  u := CefString(url);
  m := CefString(method);
  PCefRequest(fData)^.set_(fData, @u, @m, CefGetData(postData), headerMap.Handle);
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
  Result := PCefPostData(fData)^.is_read_only(fData) <> 0;
end;

function TCefPostDataRef.HasExcludedElements: Boolean;
begin
  Result := PCefPostData(fData)^.has_excluded_elements(fData) <> 0;
end;

function TCefPostDataRef.GetElementCount : TSize;
begin
  Result := PCefPostData(fData)^.get_element_count(fData);
end;

procedure TCefPostDataRef.GetElements(Count: TSize; out elements: ICefPostDataElementArray);
Var
  items: PCefPostDataElementArray;
  i: Integer;
begin
  GetMem(items, SizeOf(PCefPostDataElement) * Count);
  try
    PCefPostData(fData)^.get_elements(fData, @Count, items);

    SetLength(elements, Count);
    For i := 0 to Count - 1 do elements[i] := TCefPostDataElementRef.UnWrap(items^[i]);
  finally
    FreeMem(items);
  end;
end;

function TCefPostDataRef.RemoveElement(const element : ICefPostDataElement) : Integer;
begin
  Result := PCefPostData(fData)^.remove_element(fData, CefGetData(element));
end;

function TCefPostDataRef.AddElement(const element : ICefPostDataElement) : Integer;
begin
  Result := PCefPostData(fData)^.add_element(fData, CefGetData(element));
end;

procedure TCefPostDataRef.RemoveElements;
begin
  PCefPostData(fData)^.remove_elements(fData);
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
  Result := PCefPostDataElement(fData)^.is_read_only(fData) <> 0;
end;

procedure TCefPostDataElementRef.SetToEmpty;
begin
  PCefPostDataElement(fData)^.set_to_empty(fData);
end;

procedure TCefPostDataElementRef.SetToFile(const fileName : ustring);
Var
  f : TCefString;
begin
  f := CefString(fileName);
  PCefPostDataElement(fData)^.set_to_file(fData, @f);
end;

procedure TCefPostDataElementRef.SetToBytes(size : TSize; const bytes : Pointer);
begin
  PCefPostDataElement(fData)^.set_to_bytes(fData, size, bytes);
end;

function TCefPostDataElementRef.GetType : TCefPostDataElementType;
begin
  Result := PCefPostDataElement(fData)^.get_type(fData);
end;

function TCefPostDataElementRef.GetFile : ustring;
begin
  Result := CefStringFreeAndGet(PCefPostDataElement(fData)^.get_file(fData));
end;

function TCefPostDataElementRef.GetBytesCount : TSize;
begin
  Result := PCefPostDataElement(fData)^.get_bytes_count(fData);
end;

function TCefPostDataElementRef.GetBytes(size : TSize; bytes : Pointer) : TSize;
begin
  Result := PCefPostDataElement(fData)^.get_bytes(fData, size, bytes);
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

function TCefRequestContextRef.IsSame(other : ICefRequestContext): Boolean;
begin
  Result := PCefRequestContext(fData)^.is_same(PCefRequestContext(fData), CefGetData(other)) <> 0;
end;

function TCefRequestContextRef.IsSharingWith(other: ICefRequestContext): Boolean;
begin
  Result := PCefRequestContext(fData)^.is_sharing_with(fData, CefGetData(other)) <> 0;
end;

function TCefRequestContextRef.IsGlobal: Boolean;
begin
  Result := PCefRequestContext(fData)^.is_global(PCefRequestContext(fData)) <> 0;
end;

function TCefRequestContextRef.GetHandler: ICefRequestContextHandler;
begin
  Result := TCefRequestContextHandlerRef.UnWrap(PCefRequestContext(fData)^.get_handler(PCefRequestContext(fData)));
end;

function TCefRequestContextRef.GetCachePath: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequestContext(fData)^.get_cache_path(fData));
end;

function TCefRequestContextRef.GetDefaultCookieManager(callback: ICefCompletionCallback): ICefCookieManager;
begin
  Result := TCefCookieManagerRef.UnWrap(PCefRequestContext(fData)^.get_default_cookie_manager(fData, CefGetData(callback)));
end;

function TCefRequestContextRef.RegisterSchemeHandlerFactory(const schemeName, domainName: ustring;
  factory: ICefSchemeHandlerFactory): Boolean;
Var
  s, d: TCefString;
begin
  s := CefString(schemeName);
  d := CefString(domainName);
  Result := PCefRequestContext(fData)^.register_scheme_handler_factory(fData, @s, @d, CefGetData(factory)) <> 0;
end;

function TCefRequestContextRef.ClearSchemeHandlerFactories: Boolean;
begin
  Result := PCefRequestContext(fData)^.clear_scheme_handler_factories(fData) <> 0;
end;

procedure TCefRequestContextRef.PurgePluginListCache(reloadPages: Boolean);
begin
  PCefRequestContext(fData)^.purge_plugin_list_cache(fData, Ord(reloadPages));
end;

function TCefRequestContextRef.HasPreference(const name: ustring): Boolean;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := PCefRequestContext(fData)^.has_preference(fData, @n) <> 0;
end;

function TCefRequestContextRef.GetPreference(const name: ustring): ICefValue;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := TCefValueRef.UnWrap(PCefRequestContext(fData)^.get_preference(fData, @n));
end;

function TCefRequestContextRef.GetAllPreferences(includeDefaults: Boolean): ICefDictionaryValue;
begin
  Result := TCefDictionaryValueRef.UnWrap(PCefRequestContext(fData)^.get_all_preferences(fData, Ord(includeDefaults)));
end;

function TCefRequestContextRef.CanSetPreference(const name: ustring): Boolean;
Var
  n: TCefString;
begin
  n := CefString(name);
  Result := PCefRequestContext(fData)^.can_set_preference(fData, @n) <> 0;
end;

function TCefRequestContextRef.SetPreference(const name: ustring; value: ICefValue;
  out error: ustring): Boolean;
Var
  n, e: TCefString;
begin
  n := CefString(name);
  e := CefString('');
  Result := PCefRequestContext(fData)^.set_preference(fData, @n, CefGetData(value), @e) <> 0;
  error := CefStringClearAndGet(e);
end;

procedure TCefRequestContextRef.ClearCertificateExceptions(callback: ICefCompletionCallback);
begin
  PCefRequestContext(fData)^.clear_certificate_exceptions(fData, CefGetData(callback));
end;

procedure TCefRequestContextRef.CloseAllConnections(callback: ICefCompletionCallback);
begin
  PCefRequestContext(fData)^.close_all_connections(fData, CefGetData(callback));
end;

procedure TCefRequestContextRef.ResolveHost(const origin: ustring;
  const callback: ICefResolveCallback);
Var
  o: TCefString;
begin
  o := CefString(origin);
  PCefRequestContext(fData)^.resolve_host(fData, @o, CefGetData(callback));
end;

procedure TCefRequestContextRef.ResolveHostProc(const origin: ustring;
  const proc: TCefResolveCallbackProc);
begin
  ResolveHost(origin, TCefFastResolveCallback.Create(proc));
end;

function TCefRequestContextRef.ResolveHostCached(const origin: ustring;
  resolvedIps: TStrings): TCefErrorCode;
Var
  o, str: TCefString;
  list: TCefStringList;
  i: Integer;
begin
  list := cef_string_list_alloc();
  try
    o := CefString(origin);
    PCefRequestContext(fData)^.resolve_host_cached(fData, @o, resolvedIps);

    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      resolvedIps.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

class function TCefRequestContextRef.UnWrap(data: Pointer): ICefRequestContext;
begin
  If data <> nil then Result := Create(data) as ICefRequestContext
  Else Result := nil;
end;

class function TCefRequestContextRef.New(settings: TCefRequestContextSettings;
  handler: ICefRequestContextHandler): ICefRequestContext;
begin
  Result := UnWrap(cef_request_context_create_context(@settings, CefGetData(handler)));
end;

class function TCefRequestContextRef.Shared(other: ICefRequestContext;
  handler: ICefRequestContextHandler): ICefRequestContext;
begin
  Result := UnWrap(cef_create_context_shared(CefGetData(other), CefGetData(handler)));
end;

class function TCefRequestContextRef.Global: ICefRequestContext;
begin
  Result := UnWrap(cef_request_context_get_global_context());
end;

{ TCefRequestContextHandlerRef }

function TCefRequestContextHandlerRef.GetCookieManager : ICefCookieManager;
begin
  Result := TCefCookieManagerRef.UnWrap(PCefRequestContextHandler(fData)^.get_cookie_manager(fData));
end;

function TCefRequestContextHandlerRef.OnBeforePluginLoad(const mimeType, pluginUrl: ustring;
  isMainFrame: Boolean; const topOriginUrl: ustring; pluginInfo: ICefWebPluginInfo;
  pluginPolicy: TCefPluginPolicy): Boolean;
Var
  m, p, t: TCefString;
begin
  m := CefString(mimeType);
  p := CefString(pluginUrl);
  t := CefString(topOriginUrl);
  Result := PCefRequestContextHandler(fData)^.on_before_plugin_load(fData, @m, @p, Ord(isMainFrame),
    @t, CefGetData(pluginInfo), @pluginPolicy) <> 0;
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
  PCefAuthCallback(fData)^.cont(fData, @u, @p);
end;

procedure TCefAuthCallbackRef.Cancel;
begin
  PCefAuthCallback(fData)^.cancel(fData);
end;

class function TCefAuthCallbackRef.UnWrap(data : Pointer) : ICefAuthCallback;
begin
  If data <> nil then Result := Create(data) as ICefAuthCallback
  Else Result := nil;
end;

{ TCefRequestCallbackRef }

procedure TCefRequestCallbackRef.Cont(allow : Boolean);
begin
  PCefRequestCallback(fData)^.cont(fData, Ord(allow));
end;

procedure TCefRequestCallbackRef.Cancel;
begin
  PCefRequestCallback(fData)^.cancel(fData);
end;

class function TCefRequestCallbackRef.UnWrap(data : Pointer) : ICefRequestCallback;
begin
  If data <> nil then Result := Create(data) as ICefRequestCallback
  Else Result := nil;
end;

{ TCefSelectClientCertificateCallbackRef }

procedure TCefSelectClientCertificateCallbackRef.Select(cert: ICefX509certificate);
begin
  PCefSelectClientCertificateCallback(fData)^.select(fData, CefGetData(cert));
end;

class function TCefSelectClientCertificateCallbackRef.UnWrap(data: Pointer): ICefSelectClientCertificateCallback;
begin
  If data <> nil then Result := Create(data) as ICefSelectClientCertificateCallback
  Else Result := nil;
end;

{ TCefResourceBundleRef }

function TCefResourceBundleRef.GetLokalizedString(stringId: Integer): ustring;
begin
  Result := CefStringFreeAndGet(PCefResourceBundle(fData)^.get_localized_string(fData, stringId));
end;

function TCefResourceBundleRef.GetDataResource(resourceId: Integer; data: PPointer;
  dataSize: PSize): Boolean;
begin
  Result := PCefResourceBundle(fData)^.get_data_resource(fData, resourceId, data, dataSize) <> 0;
end;

function TCefResourceBundleRef.GetDataResourceForScale(resourceId: Integer;
  scaleFactor: TCefScaleFactor; data: PPointer; dataSize: PSize): Boolean;
begin
  Result := PCefResourceBundle(fData)^.get_data_resource_for_scale(fData, resourceId, scaleFactor,
    data, dataSize) <> 0;
end;

class function TCefResourceBundleRef.UnWrap(data: Pointer): ICefResourceBundle;
begin
  If data <> nil then Result := Create(data) as ICefResourceBundle
  Else Result := nil;
end;

class function TCefResourceBundleRef.Global: ICefResourceBundle;
begin
  Result := UnWrap(cef_resource_bundle_get_global());
end;

{ TCefResponseRef }

function TCefResponseRef.IsReadOnly : Boolean;
begin
  Result := PCefResponse(fData)^.is_read_only(fData) <> 0;
end;

function TCefResponseRef.GetError: TCefErrorCode;
begin
  Result := PCefResponse(fData)^.get_error(fData);
end;

procedure TCefResponseRef.SetError(error: TCefErrorCode);
begin
  PCefResponse(fData)^.set_error(fData, error);
end;

function TCefResponseRef.GetStatus : Integer;
begin
  Result := PCefResponse(fData)^.get_status(fData);
end;

procedure TCefResponseRef.SetStatus(status : Integer);
begin
  PCefResponse(fData)^.set_status(fData, status);
end;

function TCefResponseRef.GetStatusText : ustring;
begin
  Result := CefStringFreeAndGet(PCefResponse(fData)^.get_status_text(fData));
end;

procedure TCefResponseRef.SetStatusText(const StatusText : ustring);
Var
  s : TCefString;
begin
  s := CefString(StatusText);
  PCefResponse(fData)^.set_status_text(fData, @s);
end;

function TCefResponseRef.GetMimeType : ustring;
begin
  Result := CefStringFreeAndGet(PCefResponse(fData)^.get_mime_type(fData));
end;

procedure TCefResponseRef.SetMimeType(const mimetype : ustring);
Var
  m : TCefString;
begin
  m := CefString(mimetype);
  PCefResponse(fData)^.set_mime_type(fData, @m);
end;

function TCefResponseRef.GetHeader(const name : ustring) : ustring;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(PCefResponse(fData)^.get_header(fData, @n));
end;

procedure TCefResponseRef.GetHeaderMap(const headerMap : ICefStringMultimap);
begin
  PCefResponse(fData)^.get_header_map(fData, headerMap.Handle);
end;

procedure TCefResponseRef.SetHeaderMap(const headerMap : ICefStringMultimap);
begin
  PCefResponse(fData)^.set_header_map(fData, headerMap.Handle);
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

{ TCefSslinfoRef }

function TCefSslinfoRef.GetCertStatus: TCefCertStatus;
begin
  Result := PCefSslinfo(fData)^.get_cert_status(fData);
end;

function TCefSslinfoRef.GetX509Certificate: ICefx509Certificate;
begin
  Result := TCefX509certificateRef.UnWrap(PCefSslinfo(fData)^.get_x509certificate(fData));
end;

class function TCefSslinfoRef.UnWrap(data: Pointer): ICefSslinfo;
begin
  If data <> nil then Result := Create(data) as ICefSslinfo
  Else Result := nil;
end;

{ TCefSslstatusRef }

function TCefSslstatusRef.IsSecureConnection: Boolean;
begin
  Result := PCefSslstatus(fData)^.is_secure_connection(fData) <> 0;
end;

function TCefSslstatusRef.GetCertStatus: TCefCertStatus;
begin
  Result := PCefSslstatus(fData)^.get_cert_status(fData);
end;

function TCefSslstatusRef.GetSslVersion: TCefSslVersion;
begin
  Result := PCefSslstatus(fData)^.get_sslversion(fData);
end;

function TCefSslstatusRef.GetContentStatus: TCefSslContentStatus;
begin
  Result := PCefSslstatus(fData)^.get_content_status(fData);
end;

function TCefSslstatusRef.Getx509Certificate: ICefx509Certificate;
begin
  Result := TCefX509certificateRef.UnWrap(PCefSslstatus(fData)^.get_x509certificate(fData));
end;

class function TCefSslstatusRef.UnWrap(data: Pointer): ICefSslstatus;
begin
  If data <> nil then Result := Create(data) as ICefSslstatus
  Else Result := nil;
end;

{ TCefStreamReaderRef }

function TCefStreamReaderRef.Read(ptr : Pointer; size, n : TSize) : TSize;
begin
  Result := PCefStreamReader(fData)^.read(fData, ptr, size, n);
end;

function TCefStreamReaderRef.Seek(offset : Int64; whence : Integer) : Integer;
begin
  Result := PCefStreamReader(fData)^.seek(fData, offset, whence);
end;

function TCefStreamReaderRef.Tell : Int64;
begin
  Result := PCefStreamReader(fData)^.tell(fData);
end;

function TCefStreamReaderRef.Eof : Boolean;
begin
  Result := PCefStreamReader(fData)^.eof(fData) <> 0;
end;

function TCefStreamReaderRef.MayBlock : Boolean;
begin
  Result := PCefStreamReader(fData)^.may_block(fData) <> 0;
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

class function TCefStreamReaderRef.CreateForData(data : Pointer;
  size : Cardinal) : ICefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_data(data, size));
end;

class function TCefStreamReaderRef.CreateForHandler(const handler: ICefStreamReader): ICefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_handler(CefGetData(handler)));
end;

class function TCefStreamReaderRef.CreateForStream(const stream: TSTream; owned: Boolean): ICefStreamReader;
begin
  Result := CreateForHandler(TCefReadHandlerOwn.Create(stream, owned) as ICefStreamReader);
end;

{ TCefStreamWriterRef }

function TCefStreamWriterRef.Write(const ptr: Pointer; size, n: TSize): TSize;
begin
  Result := PCefStreamWriter(fData)^.write(fData, ptr, size, n);
end;

function TCefStreamWriterRef.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := PCefStreamWriter(fData)^.seek(fData, offset, whence);
end;

function TCefStreamWriterRef.Tell: Int64;
begin
  Result := PCefStreamWriter(fData)^.tell(fData);
end;

function TCefStreamWriterRef.Flush: Boolean;
begin
  Result := PCefStreamWriter(fData)^.flush(fData) <> 0;
end;

function TCefStreamWriterRef.MayBlock: Boolean;
begin
  Result := PCefStreamWriter(fData)^.may_block(fData) <> 0;
end;

class function TCefStreamWriterRef.UnWrap(data: Pointer): ICefStreamWriter;
begin
  If data <> nil then Result := Create(data) as ICefStreamWriter
  Else Result := nil;
end;

class function TCefStreamWriterRef.CreateForFile(const filename: ustring): ICefStreamWriter;
Var
  f: TCefString;
begin
  f := CefString(filename);
  Result := UnWrap(cef_stream_writer_create_for_file(@f));
end;

class function TCefStreamWriterRef.CreateForHandler(const handler: ICefStreamWriter): ICefStreamWriter;
begin
  Result := UnWrap(cef_stream_writer_create_for_handler(CefGetData(handler)));
end;

class function TCefStreamWriterRef.CreateForStream(const stream: TStream; owned: Boolean): ICefStreamWriter;
begin
  Result := CreateForHandler(TCefWriteHandlerOwn.Create(stream, owned) as ICefStreamWriter);
end;

{ TCefTaskRef }

procedure TCefTaskRef.Execute;
begin
  PCefTask(fData)^.execute(fData);
end;

class function TCefTaskRef.UnWrap(data: Pointer): ICefTask;
begin
  If data <> nil then Result := Create(data) as ICefTask
  Else Result := nil;
end;

{ TCefTaskRunnerRef }

function TCefTaskRunnerRef.IsSame(that: ICefTaskRunner): Boolean;
begin
  Result := PCefTaskRunner(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefTaskRunnerRef.BelongsToCurrentThread: Boolean;
begin
  Result := PCefTaskRunner(fData)^.belongs_to_current_thread(fData) <> 0;
end;

function TCefTaskRunnerRef.BelongsToThread(ThreadID: TCefThreadID): Boolean;
begin
  Result := PCefTaskRunner(fData)^.belongs_to_thread(fData, ThreadID) <> 0;
end;

function TCefTaskRunnerRef.PostTask(task: ICefTask): Integer;
begin
  Result := PCefTaskRunner(fData)^.post_task(fData, CefGetData(task));
end;

function TCefTaskRunnerRef.PostDelayedTask(task: ICefTask; delay_ms: Int64): Integer;
begin
  Result := PCefTaskRunner(fData)^.post_delayed_task(fData, CefGetData(task), delay_ms);
end;

class function TCefTaskRunnerRef.UnWrap(data: Pointer): ICefTaskRunner;
begin
  If data <> nil then Result := Create(data) as ICefTaskRunner
  Else Result := nil;
end;

class function TCefTaskRunnerRef.GetForCurrentThread: ICefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_current_thread());
end;

class function TCefTaskRunnerRef.GetForThread(const ThreadID: TCefThreadID): ICefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_thread(ThreadID));
end;

{ TCefThreadRef }

function TCefThreadRef.GetTaskRunner: ICefTaskRunner;
begin
  Result := TCefTaskRunnerRef.UnWrap(PCefThread(fData)^.get_task_runner(fData));
end;

function TCefThreadRef.GetPlatformThreadId: TCefPlatformThreadId;
begin
  Result := PCefThread(fData)^.get_platform_thread_id(fData);
end;

procedure TCefThreadRef.Stop;
begin
  PCefThread(fData)^.stop(fData);
end;

function TCefThreadRef.IsRunning: Boolean;
begin
  Result := PCefThread(fData)^.is_running(fData) <> 0;
end;

class function TCefThreadRef.UnWrap(data: Pointer): ICefThread;
begin
  If data <> nil then Result := Create(data) as ICefThread
  Else Result := nil;
end;

class function TCefThreadRef.New(const displayName: ustring; priority: TCefThreadPriority;
  messageLoopType: TCefMessageLoopType; stoppable: Boolean;
  comInitMode: TCefComInitMode): ICefThread;
Var
  d: TCefString;
begin
  d := CefString(displayName);
  Result := UnWrap(cef_thread_create(@d, priority, messageLoopType, Ord(stoppable), comInitMode));
end;

{ TCefUrlRequestRef }

function TCefUrlRequestRef.GetRequest : ICefRequest;
begin
  Result := TCefRequestRef.UnWrap(PCefUrlRequest(fData)^.get_request(fData));
end;

function TCefUrlRequestRef.GetClient: ICefUrlRequestClient;
begin
  Result := TCefUrlRequestClientRef.UnWrap(PCefUrlRequest(fData)^.get_client(fData));
end;

function TCefUrlRequestRef.GetRequestStatus : TCefUrlRequestStatus;
begin
  Result := PCefUrlRequest(fData)^.get_request_status(fData);
end;

function TCefUrlRequestRef.GetRequestError: TCefErrorcode;
begin
  Result := PCefUrlRequest(fData)^.get_request_error(fData);
end;

function TCefUrlRequestRef.GetResponse : ICefResponse;
begin
  Result := TCefResponseRef.UnWrap(PCefUrlRequest(fData)^.get_response(fData));
end;

procedure TCefUrlRequestRef.Cancel;
begin
  PCefUrlRequest(fData)^.cancel(fData);
end;

class function TCefUrlRequestRef.UnWrap(data: Pointer): ICefUrlRequest;
begin
  If data <> nil then Result := Create(data) as ICefUrlRequest
  Else Result := nil;
end;

class function TCefUrlRequestRef.New(const request: ICefRequest;
    const client: ICefUrlRequestClient; const requestContext: ICefRequestContext): ICefUrlRequest;
begin
  Result := UnWrap(cef_urlrequest_create(CefGetData(request), CefGetData(client),
    CefGetData(requestContext)));
end;

{ TCefUrlRequestClientRef }

procedure TCefUrlRequestClientRef.OnRequestComplete(const request: ICefUrlRequest);
begin
  PCefUrlRequestClient(fData)^.on_request_complete(fData, CefGetData(request));
end;

procedure TCefUrlRequestClientRef.OnUploadProgress(const request: ICefUrlRequest;
  current, total: Int64);
begin
  PCefUrlRequestClient(fData)^.on_upload_progress(fData, CefGetData(request), current, total);
end;

procedure TCefUrlRequestClientRef.OnDownloadProgress(const request: ICefUrlRequest;
  current, total: Int64);
begin
  PCefUrlRequestClient(fData)^.on_download_progress(fData, CefGetData(request), current, total);
end;

procedure TCefUrlRequestClientRef.OnDownloadData(const request: ICefUrlRequest; data: Pointer;
  dataLength: TSize);
begin
  PCefUrlRequestClient(fData)^.on_download_data(fData, CefGetData(request), data, dataLength);
end;

function TCefUrlRequestClientRef.GetAuthCredentials(isProxy: Boolean; const host: ustring;
  port: Integer; const realm, scheme: ustring; callback: ICefAuthCallback): Boolean;
Var
  h, r, s: TCefString;
begin
  h := CefString(host);
  r := CefString(realm);
  s := CefString(scheme);
  Result := PCefUrlRequestClient(fData)^.get_auth_credentials(fData, Ord(isProxy), @h, port, @r, @s, CefGetData(callback)) <> 0;
end;

class function TCefUrlRequestClientRef.UnWrap(data: Pointer): ICefUrlRequestClient;
begin
  If data <> nil then Result := Create(data) as ICefUrlRequestClient
  Else Result := nil;
end;

{ TCefV8ContextRef }

function TCefV8ContextRef.GetTaskRunner : ICefTaskRunner;
begin
  Result := TCefTaskRunnerRef.UnWrap(PCefV8Context(fData)^.get_task_runner(fData));
end;

function TCefV8ContextRef.IsValid : boolean;
begin
  Result := PCefV8Context(fData)^.is_valid(fData) <> 0;
end;

function TCefV8ContextRef.GetBrowser : ICefBrowser;
begin
  Result := TCefBrowserRef.UnWrap(PCefV8Context(fData)^.get_browser(fData));
end;

function TCefV8ContextRef.GetFrame : ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefV8Context(fData)^.get_frame(fData));
end;

function TCefV8ContextRef.GetGlobal : ICefV8Value;
begin
  Result := TCefV8ValueRef.UnWrap(PCefV8Context(fData)^.get_global(fData));
end;

function TCefV8ContextRef.Enter : Boolean;
begin
  Result := PCefV8Context(fData)^.enter(fData) <> 0;
end;

function TCefV8ContextRef.Exit : Boolean;
begin
  Result := PCefV8Context(fData)^.exit(fData) <> 0;
end;

function TCefV8ContextRef.IsSame(const that : ICefV8Context) : Boolean;
begin
  Result := PCefV8Context(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefV8ContextRef.Eval(const code, scriptUrl: ustring; startLine: Integer;
  var retval : ICefV8Value; var exception : ICefV8Exception) : Boolean;
Var
  c, u: TCefString;
  r: PCefV8Value;
  e: PCefV8Exception;
begin
  c := CefString(code);
  u := CefString(scriptUrl);
  r := nil;
  e := nil;
  Result := PCefV8Context(fData)^.eval(fData, @c, @u, startLine, r, e) <> 0;
  retval := TCefV8ValueRef.UnWrap(r);
  exception := TCefV8ExceptionRef.UnWrap(e);
end;

class function TCefV8ContextRef.UnWrap(data : Pointer) : ICefV8Context;
begin
  If data <> nil then Result := Create(data) as ICefV8Context
  Else Result := nil;
end;

class function TCefV8ContextRef.Current : ICefV8Context;
begin
  Result := UnWrap(cef_v8context_get_current_context());
end;

class function TCefV8ContextRef.Entered : ICefV8Context;
begin
  Result := UnWrap(cef_v8context_get_entered_context());
end;

{ TCefV8HandlerRef }

function TCefV8HandlerRef.Execute(const name: ustring; const obj: ICefV8Value;
  const arguments: ICefV8ValueArray; var retval: ICefV8Value; var exception: ustring) : Boolean;
Var
  args: PCefV8ValueArray;
  i: Integer;
  r: PCefV8Value;
  e: TCefString;
  n: TCefString;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  For i := 0 to Length(arguments) - 1 do
  begin
    args^[i] := CefGetData(arguments[i]);
  end;
  r := nil;
  FillChar(e, SizeOf(e), 0);
  n := CefString(name);
  Result := PCefV8Handler(fData)^.execute(fData, @n, CefGetData(obj), Length(arguments), args, r,
    @e) <> 0;
  FreeMem(args);
  retval := TCefV8ValueRef.UnWrap(r);
  exception := CefStringClearAndGet(e);
end;

class function TCefV8HandlerRef.UnWrap(data : Pointer) : ICefV8Handler;
begin
  If data <> nil then Result := Create(data) as ICefV8Handler
  Else Result := nil;
end;

{ TCefV8ExceptionRef }

function TCefV8ExceptionRef.GetMessage : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(fData)^.get_message(fData));
end;

function TCefV8ExceptionRef.GetSourceLine : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(fData)^.get_source_line(fData));
end;

function TCefV8ExceptionRef.GetScriptResourceName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Exception(fData)^.get_script_resource_name(fData));
end;

function TCefV8ExceptionRef.GetLineNumber : Integer;
begin
  Result := PCefV8Exception(fData)^.get_line_number(fData);
end;

function TCefV8ExceptionRef.GetStartPosition : Integer;
begin
  Result := PCefV8Exception(fData)^.get_start_position(fData);
end;

function TCefV8ExceptionRef.GetEndPosition : Integer;
begin
  Result := PCefV8Exception(fData)^.get_end_position(fData);
end;

function TCefV8ExceptionRef.GetStartColumn : Integer;
begin
  Result := PCefV8Exception(fData)^.get_start_column(fData);
end;

function TCefV8ExceptionRef.GetEndColumn : Integer;
begin
  Result := PCefV8Exception(fData)^.get_end_column(fData);
end;

class function TCefV8ExceptionRef.UnWrap(data : Pointer) : ICefV8Exception;
begin
  If data <> nil then Result := Create(data) as ICefV8Exception
  Else Result := nil;
end;

{ TCefV8ValueRef }

function TCefV8ValueRef.IsValid : boolean;
begin
  Result := PCefV8Value(fData)^.is_valid(fData) <> 0;
end;

function TCefV8ValueRef.IsUndefined : Boolean;
begin
  Result := PCefV8Value(fData)^.is_undefined(fData) <> 0;
end;

function TCefV8ValueRef.IsNull : Boolean;
begin
  Result := PCefV8Value(fData)^.is_null(fData) <> 0;
end;

function TCefV8ValueRef.IsBool : Boolean;
begin
  Result := PCefV8Value(fData)^.is_bool(fData) <> 0;
end;

function TCefV8ValueRef.IsInt : Boolean;
begin
  Result := PCefV8Value(fData)^.is_int(fData) <> 0;
end;

function TCefV8ValueRef.IsUInt : Boolean;
begin
  Result := PCefV8Value(fData)^.is_uint(fData) <> 0;
end;

function TCefV8ValueRef.IsDouble : Boolean;
begin
  Result := PCefV8Value(fData)^.is_double(fData) <> 0;
end;

function TCefV8ValueRef.IsDate : Boolean;
begin
  Result := PCefV8Value(fData)^.is_date(fData) <> 0;
end;

function TCefV8ValueRef.IsString : Boolean;
begin
  Result := PCefV8Value(fData)^.is_string(fData) <> 0;
end;

function TCefV8ValueRef.IsObject : Boolean;
begin
  Result := PCefV8Value(fData)^.is_object(fData) <> 0;
end;

function TCefV8ValueRef.IsArray : Boolean;
begin
  Result := PCefV8Value(fData)^.is_array(fData) <> 0;
end;

function TCefV8ValueRef.IsFunction : Boolean;
begin
  Result := PCefV8Value(fData)^.is_function(fData) <> 0;
end;

function TCefV8ValueRef.IsSame(const that : ICefV8Value) : Boolean;
begin
  Result := PCefV8Value(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefV8ValueRef.GetBoolValue : Boolean;
begin
  Result := PCefV8Value(fData)^.get_bool_value(fData) <> 0;
end;

function TCefV8ValueRef.GetIntValue : Integer;
begin
  Result := PCefV8Value(fData)^.get_int_value(fData);
end;

function TCefV8ValueRef.GetUIntValue : Cardinal;
begin
  Result := PCefV8Value(fData)^.get_uint_value(fData);
end;

function TCefV8ValueRef.GetDoubleValue : Double;
begin
  Result := PCefV8Value(fData)^.get_double_value(fData);
end;

function TCefV8ValueRef.GetDateValue : TDateTime;
begin
  Result := CefTimeToDateTime(PCefV8Value(fData)^.get_date_value(fData));
end;

function TCefV8ValueRef.GetStringValue : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(fData)^.get_string_value(fData));
end;

function TCefV8ValueRef.IsUserCreated : Boolean;
begin
  Result := PCefV8Value(fData)^.is_user_created(fData) <> 0;
end;

function TCefV8ValueRef.HasException : Boolean;
begin
  Result := PCefV8Value(fData)^.has_exception(fData) <> 0;
end;

function TCefV8ValueRef.GetException : ICefV8Exception;
begin
  Result := TCefV8ExceptionRef.UnWrap(PCefV8Value(fData)^.get_exception(fData));
end;

function TCefV8ValueRef.ClearException : Boolean;
begin
  Result := PCefV8Value(fData)^.clear_exception(fData) <> 0;
end;

function TCefV8ValueRef.WillRethrowExceptions : Boolean;
begin
  Result := PCefV8Value(fData)^.will_rethrow_exceptions(fData) <> 0;
end;

function TCefV8ValueRef.SetRethrowExceptions(rethrow : Boolean) : Boolean;
begin
  Result := PCefV8Value(fData)^.set_rethrow_exceptions(fData, Ord(rethrow)) <> 0;
end;

function TCefV8ValueRef.HasValueByKey(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(fData)^.has_value_bykey(fData, @k) <> 0;
end;

function TCefV8ValueRef.HasValueByIndex(index : Integer) : Boolean;
begin
  Result := PCefV8Value(fData)^.has_value_byindex(fData, index) <> 0;
end;

function TCefV8ValueRef.DeleteValueByKey(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(fData)^.delete_value_bykey(fData, @k) <> 0;
end;

function TCefV8ValueRef.DeleteValueByIndex(index : Integer) : Boolean;
begin
  Result := PCefV8Value(fData)^.delete_value_byindex(fData, index) <> 0;
end;

function TCefV8ValueRef.GetValueByKey(const key : ustring) : ICefV8Value;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefV8ValueRef.UnWrap(PCefV8Value(fData)^.get_value_bykey(fData, @k));
end;

function TCefV8ValueRef.GetValueByIndex(index : Integer) : ICefV8Value;
begin
  Result := TCefV8ValueRef.UnWrap(PCefV8Value(fData)^.get_value_byindex(fData, index));
end;

function TCefV8ValueRef.SetValueByKey(const key : ustring;
  const value : ICefV8Value; attribute : TCefV8PropertyAttributes) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(fData)^.set_value_bykey(fData, @k, CefGetData(value), attribute) <> 0;
end;

function TCefV8ValueRef.SetValueByIndex(index : Integer; const value : ICefV8Value) : Boolean;
begin
  Result := PCefV8Value(fData)^.set_value_byindex(fData, index, CefGetData(value)) <> 0;
end;

function TCefV8ValueRef.SetValueByAccessor(const key : ustring;
  settings : TCefV8AccessControls; attribute : TCefV8PropertyAttributes) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefV8Value(fData)^.set_value_byaccessor(fData, @k, settings, attribute) <> 0;
end;

function TCefV8ValueRef.GetKeys(const keys : TStrings) : Integer;
Var
  list : TCefStringList;
  i    : Integer;
  item : TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefV8Value(fData)^.get_keys(fData, list);
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

function TCefV8ValueRef.SetUserData(const data : ICefV8Value) : Boolean;
begin
  Result := PCefV8Value(fData)^.set_user_data(fData, CefGetData(data)) <> 0;
end;

function TCefV8ValueRef.GetUserData : ICefV8Value;
begin
  Result := TCefV8ValueRef.UnWrap(PCefV8Value(fData)^.get_user_data(fData));
end;

function TCefV8ValueRef.GetExternallyAllocatedMemory : Integer;
begin
  Result := PCefV8Value(fData)^.get_externally_allocated_memory(fData);
end;

function TCefV8ValueRef.AdjustExternallyAllocatedMemory(changeInBytes : Integer) : Integer;
begin
  Result := PCefV8Value(fData)^.adjust_externally_allocated_memory(fData, changeInBytes);
end;

function TCefV8ValueRef.GetArrayLength : Integer;
begin
  Result := PCefV8Value(fData)^.get_array_length(fData);
end;

function TCefV8ValueRef.GetFunctionName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(fData)^.get_function_name(fData));
end;

function TCefV8ValueRef.GetFunctionHandler : ICefV8Handler;
begin
  Result := TCefV8HandlerRef.UnWrap(PCefV8Value(fData)^.get_function_handler(fData));
end;

function TCefV8ValueRef.ExecuteFunction(const obj: ICefV8Value; const arguments: ICefV8ValueArray): ICefV8Value;
Var
  args: PCefV8ValueArray;
  i: Integer;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  try
    For i := 0 to High(arguments) do args^[i] := CefGetData(arguments[i]);

    Result := TCefV8ValueRef.UnWrap(PCefV8Value(fData)^.execute_function(fData, CefGetData(obj),
      Length(arguments), args));
  finally
    FreeMem(args);
  end;
end;

function TCefV8ValueRef.ExecuteFunctionWithContext(const context: ICefV8Context;
  const obj: ICefV8Value; const arguments: ICefV8ValueArray): ICefV8Value;
Var
  args: PCefV8ValueArray;
  i: Integer;
begin
  GetMem(args, SizeOf(PCefV8Value) * Length(arguments));
  try
    For i := 0 to High(arguments) do args^[i] := CefGetData(arguments[i]);

    Result := TCefV8ValueRef.UnWrap(PCefV8Value(fData)^.execute_function_with_context(fData,
      CefGetData(context), CefGetData(obj), Length(arguments), args));
  finally
    FreeMem(args);
  end;
end;

class function TCefV8ValueRef.UnWrap(data : Pointer) : ICefV8Value;
begin
  If data <> nil then Result := Create(data) as ICefV8Value
  Else Result := nil;
end;

class function TCefV8ValueRef.NewUndefined : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_undefined());
end;

class function TCefV8ValueRef.NewNull : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_null());
end;

class function TCefV8ValueRef.NewBool(value : Boolean) : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_bool(Ord(value)));
end;

class function TCefV8ValueRef.NewInt(value : Integer) : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_int(value));
end;

class function TCefV8ValueRef.NewUInt(value : Cardinal) : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_uint(value));
end;

class function TCefV8ValueRef.NewDouble(value : Double) : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_double(value));
end;

class function TCefV8ValueRef.NewDate(value : TDateTime) : ICefV8Value;
Var
  dt : TCefTime;
begin
  dt := DateTimeToCefTime(value);
  Result := UnWrap(cef_v8value_create_date(@dt));
end;

class function TCefV8ValueRef.NewString(const str : ustring) : ICefV8Value;
Var
  s : TCefString;
begin
  s := CefString(str);
  Result := UnWrap(cef_v8value_create_string(@s));
end;

class function TCefV8ValueRef.NewObject(const Accessor: ICefV8Accessor;
  const Interceptor: ICefV8Interceptor): ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_object(CefGetData(Accessor), CefGetData(Interceptor)));
end;

class function TCefV8ValueRef.NewArray(len : Integer) : ICefV8Value;
begin
  Result := UnWrap(cef_v8value_create_array(len));
end;

class function TCefV8ValueRef.NewFunction(const name : ustring;
  const handler : ICefV8Handler) : ICefV8Value;
Var
  n : TCefString;
begin
  n := CefString(name);
  Result := UnWrap(cef_v8value_create_function(@n, CefGetData(handler)));
end;

{ TCefV8StackTraceRef }

function TCefV8StackTraceRef.IsValid : Boolean;
begin
  Result := PCefV8StackTrace(fData)^.is_valid(fData) <> 0;
end;

function TCefV8StackTraceRef.GetFrameCount : Integer;
begin
  Result := PCefV8StackTrace(fData)^.get_frame_count(fData);
end;

function TCefV8StackTraceRef.GetFrame(index : Integer) : ICefV8StackFrame;
begin
  Result := TCefV8StackFrameRef.UnWrap(PCefV8StackTrace(fData)^.get_frame(fData, index));
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
  Result := PCefV8StackFrame(fData)^.is_valid(fData) <> 0;
end;

function TCefV8StackFrameRef.GetScriptName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(fData)^.get_script_name(fData));
end;

function TCefV8StackFrameRef.GetScriptNameOrSourceUrl : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(fData)^.get_script_name_or_source_url(fData));
end;

function TCefV8StackFrameRef.GetFunctionName : ustring;
begin
  Result := CefStringFreeAndGet(PCefV8StackFrame(fData)^.get_function_name(fData));
end;

function TCefV8StackFrameRef.GetLineNumber : Integer;
begin
  Result := PCefV8StackFrame(fData)^.get_line_number(fData);
end;

function TCefV8StackFrameRef.GetColumn : Integer;
begin
  Result := PCefV8StackFrame(fData)^.get_column(fData);
end;

function TCefV8StackFrameRef.IsEval : Boolean;
begin
  Result := PCefV8StackFrame(fData)^.is_eval(fData) <> 0;
end;

function TCefV8StackFrameRef.IsConstructor : Boolean;
begin
  Result := PCefV8StackFrame(fData)^.is_constructor(fData) <> 0;
end;

class function TCefV8StackFrameRef.UnWrap(data : Pointer) : ICefV8StackFrame;
begin
  If data <> nil then Result := Create(data) as ICefV8StackFrame
  Else Result := nil;
end;

{ TCefValueRef }

function TCefValueRef.IsValid: Boolean;
begin
  Result := PCefValue(fData)^.is_valid(fData) <> 0;
end;

function TCefValueRef.IsOwned: Boolean;
begin
  Result := PCefValue(fData)^.is_owned(fData) <> 0;
end;

function TCefValueRef.IsReadOnly: Boolean;
begin
  Result := PCefValue(fData)^.is_read_only(fData) <> 0;
end;

function TCefValueRef.IsSame(that: ICefValue): Boolean;
begin
  Result := PCefValue(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefValueRef.IsEqual(that: ICefValue): Boolean;
begin
  Result := PCefValue(fData)^.is_equal(fData, CefGetData(that)) <> 0;
end;

function TCefValueRef.Copy: ICefValue;
begin
  Result := UnWrap(PCefValue(fData)^.copy(fData));
end;

function TCefValueRef.GetType: TCefValueType;
begin
  Result := PCefValue(fData)^.get_type(fData);
end;

function TCefValueRef.GetBool: Boolean;
begin
  Result := PCefValue(fData)^.get_bool(fData) <> 0;
end;

function TCefValueRef.GetInt: Integer;
begin
  Result := PCefValue(fData)^.get_int(fData);
end;

function TCefValueRef.GetDouble: Double;
begin
  Result := PCefValue(fData)^.get_double(fData);
end;

function TCefValueRef.GetString: ustring;
begin
  Result := CefStringFreeAndGet(PCefValue(fData)^.get_string(fData));
end;

function TCefValueRef.GetBinary: ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefValue(fData)^.get_binary(fData));
end;

function TCefValueRef.GetDictionary: ICefDictionaryValue;
begin
  Result := TCefDictionaryValueRef.UnWrap(PCefValue(fData)^.get_dictionary(fData));
end;

function TCefValueRef.GetList: ICefListValue;
begin
  Result := TCefListValueRef.UnWrap(PCefValue(fData)^.get_list(fData));
end;

function TCefValueRef.SetNull: Boolean;
begin
  Result := PCefValue(fData)^.set_null(fData) <> 0;
end;

function TCefValueRef.SetBool(value: Boolean): Boolean;
begin
  Result := PCefValue(fData)^.set_bool(fData, Ord(value)) <> 0;
end;

function TCefValueRef.SetInt(value: Integer): Boolean;
begin
  Result := PCefValue(fData)^.set_int(fData, value) <> 0;
end;

function TCefValueRef.SetDouble(value: Double): Boolean;
begin
  Result := PCefValue(fData)^.set_double(fData, value) <> 0;
end;

function TCefValueRef.SetString(value: ustring): Boolean;
Var
  v: TCefString;
begin
  v := CefString(value);
  Result := PCefValue(fData)^.set_string(fData, @v) <> 0;
end;

function TCefValueRef.SetBinary(value: ICefBinaryValue): Boolean;
begin
  Result := PCefValue(fData)^.set_binary(fData, CefGetData(value)) <> 0;
end;

function TCefValueRef.SetDictionary(value: ICefDictionaryValue): Boolean;
begin
  Result := PCefValue(fData)^.set_dictionary(fData, CefGetData(value)) <> 0;
end;

function TCefValueRef.SetList(value: ICefListValue): Boolean;
begin
  Result := PCefValue(fData)^.set_list(fData, CefGetData(value)) <> 0;
end;

class function TCefValueRef.UnWrap(data: Pointer): ICefValue;
begin
  If data <> nil then Result := Create(data) as ICefValue
  Else Result := nil;
end;

class function TCefValueRef.New: ICefValue;
begin
  Result := UnWrap(cef_value_create());
end;

{ TCefBinaryValueRef }

function TCefBinaryValueRef.IsValid: Boolean;
begin
  Result := PCefBinaryValue(fData)^.is_valid(fData) <> 0;
end;

function TCefBinaryValueRef.IsOwned: Boolean;
begin
  Result := PCefBinaryValue(fData)^.is_owned(fData) <> 0;
end;

function TCefBinaryValueRef.IsSame(that: ICefBinaryValue): Boolean;
begin
  Result := PCefBinaryValue(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefBinaryValueRef.IsEqual(that: ICefBinaryValue): Boolean;
begin
  Result := PCefBinaryValue(fData)^.is_equal(fData, CefGetData(that)) <> 0;
end;

function TCefBinaryValueRef.Copy: ICefBinaryValue;
begin
  Result := UnWrap(PCefBinaryValue(fData)^.copy(fData));
end;

function TCefBinaryValueRef.GetSize: TSize;
begin
  Result := PCefBinaryValue(fData)^.get_size(fData);
end;

function TCefBinaryValueRef.GetData(buffer: Pointer; bufferSize, dataOffset: TSize): TSize;
begin
  Result := PCefBinaryValue(fData)^.get_data(fData, buffer, bufferSize, dataOffset);
end;

class function TCefBinaryValueRef.UnWrap(data: Pointer): ICefBinaryValue;
begin
  If data <> nil then Result := Create(data) as ICefBinaryValue
  Else Result := nil;
end;

class function TCefBinaryValueRef.New(const data: Pointer; dataSize: Cardinal): ICefBinaryValue;
begin
  Result := UnWrap(cef_binary_value_create(data, dataSize));
end;

{ TCefDictionaryValueRef }

function TCefDictionaryValueRef.IsValid: Boolean;
begin
  Result := PCefDictionaryValue(fData)^.is_valid(fData) <> 0;
end;

function TCefDictionaryValueRef.IsOwned: Boolean;
begin
  Result := PCefDictionaryValue(fData)^.is_owned(fData) <> 0;
end;

function TCefDictionaryValueRef.IsReadOnly: Boolean;
begin
  Result := PCefDictionaryValue(fData)^.is_read_only(fData) <> 0;
end;

function TCefDictionaryValueRef.IsSame(that: ICefDictionaryValue): Boolean;
begin
  Result := PCefDictionaryValue(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefDictionaryValueRef.IsEqual(that: ICefDictionaryValue): Boolean;
begin
  Result := PCefDictionaryValue(fData)^.is_equal(fData, CefGetData(that)) <> 0;
end;

function TCefDictionaryValueRef.Copy(excludeEmptyChildren: Boolean): ICefDictionaryValue;
begin
  Result := UnWrap(PCefDictionaryValue(fData)^.copy(fData, Ord(excludeEmptyChildren)));
end;

function TCefDictionaryValueRef.GetSize: TSize;
begin
  Result := PCefDictionaryValue(fData)^.get_size(fData);
end;

function TCefDictionaryValueRef.Clear: Boolean;
begin
  Result := PCefDictionaryValue(fData)^.clear(fData) <> 0;
end;

function TCefDictionaryValueRef.HasKey(const key: ustring): Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.has_key(fData, @k) <> 0;
end;

function TCefDictionaryValueRef.GetKeys(const keys : TStrings) : Boolean;
Var
  list : TCefStringList;
  i    : Integer;
  item : TCefString;
begin
  list := cef_string_list_alloc();
  try
    Result := PCefDictionaryValue(fData)^.get_keys(fData, list) <> 0;
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

function TCefDictionaryValueRef.Remove(const key: ustring): Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.remove(fData, @k) <> 0;
end;

function TCefDictionaryValueRef.GetType(const key: ustring): TCefValueType;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.get_type(fData, @k);
end;

function TCefDictionaryValueRef.GetValue(const key: ustring): ICefValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefValueRef.UnWrap(PCefDictionaryValue(fData)^.get_value(fData, @k));
end;

function TCefDictionaryValueRef.GetBool(const key: ustring): Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.get_bool(fData, @k) <> 0;
end;

function TCefDictionaryValueRef.GetInt(const key : ustring) : Integer;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.get_int(fData, @k);
end;

function TCefDictionaryValueRef.GetDouble(const key : ustring) : Double;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.get_double(fData, @k);
end;

function TCefDictionaryValueRef.GetString(const key : ustring) : ustring;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := CefStringFreeAndGet(PCefDictionaryValue(fData)^.get_string(fData, @k));
end;

function TCefDictionaryValueRef.GetBinary(const key : ustring) : ICefBinaryValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefBinaryValueRef.UnWrap(PCefDictionaryValue(fData)^.get_binary(fData, @k));
end;

function TCefDictionaryValueRef.GetDictionary(const key : ustring) : ICefDictionaryValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := UnWrap(PCefDictionaryValue(fData)^.get_dictionary(fData, @k));
end;

function TCefDictionaryValueRef.GetList(const key : ustring) : ICefListValue;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := TCefListValueRef.UnWrap(PCefDictionaryValue(fData)^.get_list(fData, @k));
end;

function TCefDictionaryValueRef.SetValue(const key: ustring; value: ICefValue): Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_value(fData, @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetNull(const key : ustring) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_null(fData, @k) <> 0;
end;

function TCefDictionaryValueRef.SetBool(const key : ustring; value : Boolean) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_bool(fData, @k, Ord(value)) <> 0;
end;

function TCefDictionaryValueRef.SetInt(const key : ustring; value : Integer) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_int(fData, @k, value) <> 0;
end;

function TCefDictionaryValueRef.SetDouble(const key : ustring; value : Double) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_double(fData, @k, value) <> 0;
end;

function TCefDictionaryValueRef.SetString(const key, value : ustring) : Boolean;
Var
  k, v : TCefString;
begin
  k := CefString(key);
  v := CefString(value);
  Result := PCefDictionaryValue(fData)^.set_string(fData, @k, @v) <> 0;
end;

function TCefDictionaryValueRef.SetBinary(const key : ustring;
  const value : ICefBinaryValue) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_binary(fData, @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetDictionary(const key : ustring;
  const value : ICefDictionaryValue) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_dictionary(fData, @k, CefGetData(value)) <> 0;
end;

function TCefDictionaryValueRef.SetList(const key : ustring;
  const value : ICefListValue) : Boolean;
Var
  k : TCefString;
begin
  k := CefString(key);
  Result := PCefDictionaryValue(fData)^.set_list(fData, @k, CefGetData(value)) <> 0;
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

function TCefListValueRef.IsValid: Boolean;
begin
  Result := PCefListValue(fData)^.is_valid(fData) <> 0;
end;

function TCefListValueRef.IsOwned: Boolean;
begin
  Result := PCefListValue(fData)^.is_owned(fData) <> 0;
end;

function TCefListValueRef.IsReadOnly: Boolean;
begin
  Result := PCefListValue(fData)^.is_read_only(fData) <> 0;
end;

function TCefListValueRef.IsSame(that: ICefListValue): Boolean;
begin
  Result := PCefListValue(fData)^.is_same(fData, CefGetData(that)) <> 0;
end;

function TCefListValueRef.IsEqual(that: ICefListValue): Boolean;
begin
  Result := PCefListValue(fData)^.is_equal(fData, CefGetData(that)) <> 0;
end;

function TCefListValueRef.Copy: ICefListValue;
begin
  Result := UnWrap(PCefListValue(fData)^.copy(fData));
end;

function TCefListValueRef.SetSize(size: TSize): Boolean;
begin
  Result := PCefListValue(fData)^.set_size(fData, size) <> 0;
end;

function TCefListValueRef.GetSize: TSize;
begin
  Result := PCefListValue(fData)^.get_size(fData);
end;

function TCefListValueRef.Clear: Boolean;
begin
  Result := PCefListValue(fData)^.clear(fData) <> 0;
end;

function TCefListValueRef.Remove(index: TSize): Boolean;
begin
  Result := PCefListValue(fData)^.remove(fData, index) <> 0;
end;

function TCefListValueRef.GetType(index: TSize): TCefValueType;
begin
  Result := PCefListValue(fData)^.get_type(fData, index);
end;

function TCefListValueRef.GetValue(index: TSize): ICefValue;
begin
  Result := TCefValueRef.UnWrap(PCefListValue(fData)^.get_value(fData, index));
end;

function TCefListValueRef.GetBool(index: TSize): Boolean;
begin
  Result := PCefListValue(fData)^.get_bool(fData, index) <> 0;
end;

function TCefListValueRef.GetInt(index: TSize): Integer;
begin
  Result := PCefListValue(fData)^.get_int(fData, index);
end;

function TCefListValueRef.GetDouble(index: TSize): Double;
begin
  Result := PCefListValue(fData)^.get_double(fData, index);
end;

function TCefListValueRef.GetString(index: TSize): ustring;
begin
  Result := CefStringFreeAndGet(PCefListValue(fData)^.get_string(fData, index));
end;

function TCefListValueRef.GetBinary(index: TSize): ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefListValue(fData)^.get_binary(fData, index));
end;

function TCefListValueRef.GetDictionary(index: TSize): ICefDictionaryValue;
begin
  Result := TCefDictionaryValueRef.UnWrap(PCefListValue(fData)^.get_dictionary(fData, index));
end;

function TCefListValueRef.GetList(index: TSize): ICefListValue;
begin
  Result := UnWrap(PCefListValue(fData)^.get_list(fData, index));
end;

function TCefListValueRef.SetValue(index: TSize; value: ICefValue): Boolean;
begin
  Result := PCefListValue(fData)^.set_value(fData, index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetNull(index: TSize): Boolean;
begin
  Result := PCefListValue(fData)^.set_null(fData, index) <> 0;
end;

function TCefListValueRef.SetBool(index: TSize; value: Boolean): Boolean;
begin
  Result := PCefListValue(fData)^.set_bool(fData, index, Ord(value)) <> 0;
end;

function TCefListValueRef.SetInt(index: TSize; value: Integer): Boolean;
begin
  Result := PCefListValue(fData)^.set_int(fData, index, value) <> 0;
end;

function TCefListValueRef.SetDouble(index: TSize; value: Double): Boolean;
begin
  Result := PCefListValue(fData)^.set_double(fData, index, value) <> 0;
end;

function TCefListValueRef.SetString(index: TSize; const value: ustring): Boolean;
Var
  v : TCefString;
begin
  v := CefString(value);
  Result := PCefListValue(fData)^.set_string(fData, index, @v) <> 0;
end;

function TCefListValueRef.SetBinary(index: TSize; const value: ICefBinaryValue): Boolean;
begin
  Result := PCefListValue(fData)^.set_binary(fData, index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetDictionary(index: TSize; const value: ICefDictionaryValue): Boolean;
begin
  Result := PCefListValue(fData)^.set_dictionary(fData, index, CefGetData(value)) <> 0;
end;

function TCefListValueRef.SetList(index: TSize; const value: ICefListValue): Boolean;
begin
  Result := PCefListValue(fData)^.set_list(fData, index, CefGetData(value)) <> 0;
end;

class function TCefListValueRef.UnWrap(data: Pointer): ICefListValue;
begin
  If data <> nil then Result := Create(data) as ICefListValue
  Else Result := nil;
end;

class function TCefListValueRef.New : ICefListValue;
begin
  Result := UnWrap(cef_list_value_create());
end;

{ TCefWaitableEventRef }

procedure TCefWaitableEventRef.Reset;
begin
  PCefWaitableEvent(fData)^.reset(fData);
end;

procedure TCefWaitableEventRef.Signal;
begin
  PCefWaitableEvent(fData)^.signal(fData);
end;

function TCefWaitableEventRef.IsSignaled: Boolean;
begin
  Result := PCefWaitableEvent(fData)^.is_signaled(fData) <> 0;
end;

procedure TCefWaitableEventRef.Wait;
begin
  PCefWaitableEvent(fData)^.wait(fData);
end;

function TCefWaitableEventRef.TimedWait(maxMs: Int64): Boolean;
begin
  Result := PCefWaitableEvent(fData)^.timed_wait(fData, maxMs) <> 0;
end;

class function TCefWaitableEventRef.UnWrap(data: Pointer): ICefWaitableEvent;
begin
  If data <> nil then Result := Create(data) as ICefWaitableEvent
  Else Result := nil;
end;

class function TCefWaitableEventRef.New(automaticReset, initiallySignaled: Boolean): ICefWaitableEvent;
begin
  Result := UnWrap(cef_waitable_event_create(Ord(automaticReset), Ord(initiallySignaled)));
end;

{ TCefWebPluginInfoRef }

function TCefWebPluginInfoRef.GetName : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(fData)^.get_name(fData));
end;

function TCefWebPluginInfoRef.GetPath : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(fData)^.get_path(fData));
end;

function TCefWebPluginInfoRef.GetVersion : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(fData)^.get_version(fData));
end;

function TCefWebPluginInfoRef.GetDescription : ustring;
begin
  Result := CefStringFreeAndGet(PCefWebPluginInfo(fData)^.get_description(fData));
end;

class function TCefWebPluginInfoRef.UnWrap(data : Pointer) : ICefWebPluginInfo;
begin
  If data <> nil then Result := Create(data) as ICefWebPluginInfo
  Else Result := nil;
end;

{ TCefX509certPrincipalRef }

function TCefX509certPrincipalRef.GetDisplayName: ustring;
begin
  Result := CefStringFreeAndGet(PCefX509certPrincipal(fData)^.get_display_name(fData));
end;

function TCefX509certPrincipalRef.GetCommonName: ustring;
begin
  Result := CefStringFreeAndGet(PCefX509certPrincipal(fData)^.get_common_name(fData));
end;

function TCefX509certPrincipalRef.GetLocalityName: ustring;
begin
  Result := CefStringFreeAndGet(PCefX509certPrincipal(fData)^.get_locality_name(fData));
end;

function TCefX509certPrincipalRef.GetStateOrProvinceName: ustring;
begin
  Result := CefStringFreeAndGet(PCefX509certPrincipal(fData)^.get_state_or_province_name(fData));
end;

function TCefX509certPrincipalRef.GetCountryName: ustring;
begin
  Result := CefStringFreeAndGet(PCefX509certPrincipal(fData)^.get_country_name(fData));
end;

procedure TCefX509certPrincipalRef.GetStreetAddresses(addresses: TStrings);
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefX509certPrincipal(fData)^.get_street_addresses(fData, list);
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      addresses.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

procedure TCefX509certPrincipalRef.GetOrganizationNames(names: TStrings);
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefX509certPrincipal(fData)^.get_organization_names(fData, list);
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

procedure TCefX509certPrincipalRef.GetOrganizationUnitNames(names: TStrings);
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefX509certPrincipal(fData)^.get_organization_unit_names(fData, list);
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

procedure TCefX509certPrincipalRef.GetDomainComponents(components: TStrings);
Var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc();
  try
    PCefX509certPrincipal(fData)^.get_domain_components(fData, list);
    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      components.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

class function TCefX509certPrincipalRef.UnWrap(data: Pointer): ICefX509certPrincipal;
begin
  If data <> nil then Result := Create(data) as ICefX509certPrincipal
  Else Result := nil;
end;

{ TCefX509certificateRef }

function TCefX509certificateRef.GetSubject: ICefX509certPrincipal;
begin
  Result := TCefX509certPrincipalRef.UnWrap(PCefX509Certificate(fData)^.get_subject(fData));
end;

function TCefX509certificateRef.GetIssuer: ICefX509certPrincipal;
begin
  Result := TCefX509certPrincipalRef.UnWrap(PCefX509Certificate(fData)^.get_issuer(fData));
end;

function TCefX509certificateRef.GetSerialNumber: ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefX509Certificate(fData)^.get_serial_number(fData));
end;

function TCefX509certificateRef.GetValidStart: TDateTime;
begin
  Result := CefTimeToDateTime(PCefX509Certificate(fData)^.get_valid_start(fData));
end;

function TCefX509certificateRef.GetValidExpiry: TDateTime;
begin
  Result := CefTimeToDateTime(PCefX509Certificate(fData)^.get_valid_expiry(fData));
end;

function TCefX509certificateRef.GetDerencoded: ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefX509Certificate(fData)^.get_derencoded(fData));
end;

function TCefX509certificateRef.GetPemencoded: ICefBinaryValue;
begin
  Result := TCefBinaryValueRef.UnWrap(PCefX509Certificate(fData)^.get_pemencoded(fData));
end;

function TCefX509certificateRef.GetIssuerChainSize: Integer;
begin
  Result := PCefX509Certificate(fData)^.get_issuer_chain_size(fData);
end;

procedure TCefX509certificateRef.GetDerencodedIssuerChain(chainCount: TSize;
  out chain: ICefBinaryValueArray);
Var
  pchain: PCefBinaryValueArray;
  i: Integer;
begin
  GetMem(pchain, SizeOf(PCefBinaryValue) * chainCount);
  try
    PCefX509Certificate(fData)^.get_derencoded_issuer_chain(fData, @chainCount, pchain);

    SetLength(chain, chainCount);
    For i := 0 to chainCount - 1 do chain[i] := TCefBinaryValueRef.UnWrap(pchain^[i]);
  finally
    FreeMem(pchain);
  end;
end;

procedure TCefX509certificateRef.GetPemencodedIssuerChain(chainCount: TSize;
  out chain: ICefBinaryValueArray);
Var
  pchain: PCefBinaryValueArray;
  i: Integer;
begin
  GetMem(pchain, SizeOf(PCefBinaryValue) * chainCount);
  try
    PCefX509Certificate(fData)^.get_pemencoded_issuer_chain(fData, @chainCount, pchain);

    SetLength(chain, chainCount);
    For i := 0 to chainCount - 1 do chain[i] := TCefBinaryValueRef.UnWrap(pchain^[i]);
  finally
    FreeMem(pchain);
  end;
end;

class function TCefX509certificateRef.UnWrap(data: Pointer): ICefX509certificate;
begin
  If data <> nil then Result := Create(data) as ICefX509certificate
  Else Result := nil;
end;

{ TCefXmlReaderRef }

function TCefXmlReaderRef.MoveToNextNode : Boolean;
begin
  Result := PCefXMLReader(fData)^.move_to_next_node(fData) <> 0;
end;

function TCefXmlReaderRef.Close : Boolean;
begin
  Result := PCefXMLReader(fData)^.close(fData) <> 0;
end;

function TCefXmlReaderRef.HasError : Boolean;
begin
  Result := PCefXMLReader(fData)^.has_attributes(fData) <> 0;
end;

function TCefXmlReaderRef.GetError : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_error(fData));
end;

function TCefXmlReaderRef.GetType : TCefXmlNodeType;
begin
  Result := PCefXMLReader(fData)^.get_type(fData);
end;

function TCefXmlReaderRef.GetDepth : Integer;
begin
  Result := PCefXMLReader(fData)^.get_depth(fData);
end;

function TCefXmlReaderRef.GetLocalName : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_local_name(fData));
end;

function TCefXmlReaderRef.GetPrefix : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_prefix(fData));
end;

function TCefXmlReaderRef.GetQualifiedName : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_qualified_name(fData));
end;

function TCefXmlReaderRef.GetNamespaceUri : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_namespace_uri(fData));
end;

function TCefXmlReaderRef.GetBaseUri : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_base_uri(fData));
end;

function TCefXmlReaderRef.GetXmlLang : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_xml_lang(fData));
end;

function TCefXmlReaderRef.IsEmptyElement : Boolean;
begin
  Result := PCefXMLReader(fData)^.is_empty_element(fData) <> 0;
end;

function TCefXmlReaderRef.HasValue : Boolean;
begin
  Result := PCefXMLReader(fData)^.has_value(fData) <> 0;
end;

function TCefXmlReaderRef.GetValue : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_value(fData));
end;

function TCefXmlReaderRef.HasAttributes : Boolean;
begin
  Result := PCefXMLReader(fData)^.has_attributes(fData) <> 0;
end;

function TCefXmlReaderRef.GetAttributeCount : TSize;
begin
  Result := PCefXMLReader(fData)^.get_attribute_count(fData);
end;

function TCefXmlReaderRef.GetAttributeByIndex(index : Integer) : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_attribute_byindex(fData, index));
end;

function TCefXmlReaderRef.GetAttributeByQName(const qualifiedName : ustring) : ustring;
Var
  q: TCefString;
begin
  q := CefString(qualifiedName);
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_attribute_byqname(fData, @q));
end;

function TCefXmlReaderRef.GetAttributeByLName(const localName, namespaceURI : ustring) : ustring;
Var
  l, n: TCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_attribute_bylname(fData, @l, @n));
end;

function TCefXmlReaderRef.GetInnerXml : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_inner_xml(fData));
end;

function TCefXmlReaderRef.GetOuterXml : ustring;
begin
  Result := CefStringFreeAndGet(PCefXMLReader(fData)^.get_outer_xml(fData));
end;

function TCefXmlReaderRef.GetLineNumber : Integer;
begin
  Result := PCefXMLReader(fData)^.get_line_number(fData);
end;

function TCefXmlReaderRef.MoveToAttributeByIndex(index : Integer) : Boolean;
begin
  Result := PCefXMLReader(fData)^.move_to_attribute_byindex(fData, index) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByQName(const qualifiedName : ustring) : Boolean;
Var
  q: TCefString;
begin
  q := CefString(qualifiedName);
  Result := PCefXMLReader(fData)^.move_to_attribute_byqname(fData, @q) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByLName(const localName, namespaceURI : ustring) : Boolean;
Var
  l, n: TCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := PCefXMLReader(fData)^.move_to_attribute_bylname(fData, @l, @n) <> 0;
end;

function TCefXmlReaderRef.MoveToFirstAttribute : Boolean;
begin
  Result := PCefXMLReader(fData)^.move_to_first_attribute(fData) <> 0;
end;

function TCefXmlReaderRef.MoveToNextAttribute : Boolean;
begin
  Result := PCefXMLReader(fData)^.move_to_next_attribute(fData) <> 0;
end;

function TCefXmlReaderRef.MoveToCarryingElement : Boolean;
begin
  Result := PCefXMLReader(fData)^.move_to_carrying_element(fData) <> 0;
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
  Result := PCefZipReader(fData)^.move_to_first_file(fData) <> 0;
end;

function TCefZipReaderRef.MoveToNextFile : Boolean;
begin
  Result := PCefZipReader(fData)^.move_to_next_file(fData) <> 0;
end;

function TCefZipReaderRef.MoveToFile(const fileName : ustring; caseSensitive : Boolean) : Boolean;
Var
  f: TCefString;
begin
  f := CefString(fileName);
  Result := PCefZipReader(fData)^.move_to_file(fData, @f, Ord(caseSensitive)) <> 0;
end;

function TCefZipReaderRef.Close : Boolean;
begin
  Result := PCefZipReader(fData)^.close(fData) <> 0;
end;

function TCefZipReaderRef.GetFileName : ustring;
begin
  Result := CefStringFreeAndGet(PCefZipReader(fData)^.get_file_name(fData));
end;

function TCefZipReaderRef.GetFileSize : Int64;
begin
  Result := PCefZipReader(fData)^.get_file_size(fData);
end;

function TCefZipReaderRef.GetFileLastModified: TDateTime;
begin
  Result := CefTimeToDateTime(PCefZipReader(fData)^.get_file_last_modified(fData));
end;

function TCefZipReaderRef.OpenFile(const password : ustring) : Boolean;
Var
  p: TCefString;
begin
  p := CefString(password);
  Result :=  PCefZipReader(fData)^.open_file(fData, @p) <> 0;
end;

function TCefZipReaderRef.CloseFile : Boolean;
begin
  Result := PCefZipReader(fData)^.close_file(fData) <> 0;
end;

function TCefZipReaderRef.ReadFile(buffer : Pointer; bufferSize : TSize) : Integer;
begin
  Result := PCefZipReader(fData)^.read_file(fData, buffer, bufferSize);
end;

function TCefZipReaderRef.Tell : Int64;
begin
  Result := PCefZipReader(fData)^.tell(fData);
end;

function TCefZipReaderRef.Eof : Boolean;
begin
  Result := PCefZipReader(fData)^.eof(fData) <> 0;
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
