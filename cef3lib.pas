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

Unit cef3lib;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}Messages,{$ENDIF}
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  {$IFNDEF WINDOWS}cwstring,{$ENDIF}
  {$IFDEF LINUX}xlib, x,{$ENDIF}
  SysUtils, Classes, LCLProc, Graphics, FPimage,
  cef3api, cef3types, cef3intf, cef3ref, cef3own;

function CefInitDefault: Boolean; deprecated;

function CefGetObject(ptr: Pointer): TObject; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
function CefGetData(const i: ICefBase) : Pointer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

function CefTimeToDateTime(const dt: TCefTime): TDateTime;
function DateTimeToCefTime(dt: TDateTime): TCefTime;
{$IFDEF WINDOWS}
  function TzSpecificLocalTimeToSystemTime(
    lpTimeZoneInformation: PTimeZoneInformation;
    lpLocalTime, lpUniversalTime: PSystemTime): BOOL; stdcall; external 'kernel32.dll';
  function SystemTimeToTzSpecificLocalTime(
    lpTimeZoneInformation: PTimeZoneInformation;
    lpUniversalTime, lpLocalTime: PSystemTime): BOOL; stdcall; external 'kernel32.dll';
  function CefTimeToSystemTime(const dt: TCefTime): TSystemTime;
{$ENDIF}

function TColorToCefColor(const aColor: TColor): TCefColor;
function FPColorToCefColor(const aColor: TFPColor): TCefColor;

function CefString(const str: ustring): TCefString; overload;
function CefString(const str: PCefString): ustring; overload;
function CefStringClearAndGet(var str: TCefString): ustring;
function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
function CefStringAlloc(const str: ustring): TCefString;
procedure CefStringFree(const str: PCefString);
function CefUserFreeString(const str: ustring): PCefStringUserFree;
procedure CefStringSet(const str: PCefString; const value: ustring);


{ ***  API  *** }

function CefInitialize: Boolean;
procedure CefShutDown;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
procedure CefDoMessageLoopWork;
procedure CefRunMessageLoop;
procedure CefQuitMessageLoop;
{$ENDIF}

procedure CefSetOsmodalLoop(osModalLoop: Boolean);
procedure CefEnableHighDPISupport;

function CefBrowserHostCreateBrowser(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings; const requestContext: ICefRequestContext): Boolean;
function CefBrowserHostCreateBrowserSync(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings; const requestContext: ICefRequestContext): ICefBrowser;

function CefGetGeolocation(const callback: ICefGetGeolocationCallback): Boolean;
function CefGetGeolocationProc(const callback: TCefGetGeolocationCallbackProc): Boolean;

function CefAddCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol, TargetDomain: ustring; AllowTargetSubdomains: Boolean): Boolean;
function CefRemoveCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol, TargetDomain: ustring; AllowTargetSubdomains: Boolean): Boolean;
function CefClearCrossOriginWhitelist: Boolean;

function CefParseUrl(const url: ustring; var parts: TUrlParts): Boolean;
function CefCreateUrl(var parts: TUrlParts): ustring;

function CefFormatUrlForSecurityDisplay(const originUrl: ustring): ustring;

function CefGetMimeType(const extension: ustring): ustring;
procedure CefGetExtensionsForMimeType(const mimeType: ustring; extensions: TStrings);
function CefBase64Encode(const data: Pointer; dataSize: TSize): ustring;
function CefBase64Decode(const data: ustring): ICefBinaryValue;
function CefUriEncode(const text: ustring; usePlus: Boolean): ustring;
function CefUriDecode(const text: ustring; convertToUtf8: Boolean; unescapeRules: TCefUriUnescapeRule): ustring;
function CefParseJson(const jsonString: ustring; options: TCefJsonParserOptions): ICefValue;
function CefParseJsonAndReturnError(const jsonString: ustring; options: TCefJsonParserOptions; out errorCode: TCefJsonParserError; out errorMsg: ustring): ICefValue;
function CefWriteJson(node: ICefValue; options: TCefJsonWriterOptions): ustring;

function CefGetPath(key: TCefPathKey; out path: ustring): Boolean;

function CefLaunchProcess(commandLine: ICefCommandLine): Boolean;

function CefRegisterSchemeHandlerFactory(const SchemeName, HostName: ustring;
  SyncMainThread: Boolean; const handler: TCefResourceHandlerClass): Boolean;
function CefClearSchemeHandlerFactories: Boolean;

function CefCurrentlyOn(ThreadId: TCefThreadId): Boolean;
procedure CefPostTask(ThreadId: TCefThreadId; const task: ICefTask);
procedure CefPostDelayedTask(ThreadId: TCefThreadId; const task: ICefTask; delayMs: Int64);

function CefBeginTracing(const categories: ustring; callback: ICefCompletionCallback): Boolean;
function CefEndTracing(const tracingFile: ustring; callback: ICefEndTracingCallback): Boolean;
function CefNowFromSystemTraceTime: Int64;

function CefRegisterExtension(const name, code: ustring; const Handler: ICefv8Handler): Boolean;
function Cefv8ContextInContext: Boolean;

procedure CefVisitWebPluginInfo(const visitor: ICefWebPluginInfoVisitor);
procedure CefVisitWebPluginInfoProc(const visitor: TCefWebPluginInfoVisitorProc);
procedure CefRefreshWebPlugins;
procedure CefUnregisterInternalWebPlugin(const path: ustring);
procedure CefRegisterWebPluginCrash(const path: ustring);
procedure CefIsWebPluginUnstable(const path: ustring; const callback: ICefWebPluginUnstableCallback);
procedure CefIsWebPluginUnstableProc(const path: ustring; const callback: TCefWebPluginIsUnstableProc);

function CefGetMinLogLevel: Integer;
function CefGetVlogLevel(const fileStart: String; n: TSize): Integer;
procedure CefLog(const file_: String; line, severity: Integer; const message: String);

function CefGetCurrentPlatformThreadId: TCefPlatformThreadId;
function CefGetCurrentPlatformThreadHandle: TCefPlatformThreadHandle;

function CefTimeNow(out cefTime: TCefTime): Boolean;

procedure CefTraceEventInstant(const category, name, arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);
procedure CefTraceEventBegin(const category, name, arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);
procedure CefTraceEventEnd(const category, name, arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);
procedure CefTraceCounter(const category, name, arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);
procedure CefTraceCounterId(const category, name: String; id: UInt64; const value1_name: String; value1_val: UInt64; const value2_name: String; value2_val: UInt64; copy: Integer);
procedure CefTraceEventAsyncBegin(const category, name: String; id: UInt64; const arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);
procedure CefTraceEventAsyncStepInto(const category, name: String; id, step: UInt64; const arg1_name: String; arg1_val: UInt64; copy: Integer);
procedure CefTraceEventAsyncStepPast(const category, name: String; id, step: UInt64; const arg1_name: String; arg1_val: UInt64; copy: Integer);
procedure CefTraceEventAsyncEnd(const category, name: String; id: UInt64; const arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);

function CefVersionInfo(entry: Integer): Integer;
function CefApiHash(entry: Integer): String;

{$IFDEF LINUX}
  procedure CefXWindowResize(const ABrowser: ICefBrowser; const Top, Left, Width, Height: Integer);
  procedure CefXLooseFocus(const ABrowser: ICefBrowser);
  procedure CefXSetVisibility(const ABrowser: ICefBrowser; const Value: Boolean);

  function XErrorHandler(display: PDisplay; event: PXErrorEvent): Integer; cdecl;
  function XIOErrorHandler(display: PDisplay): Integer; cdecl;
{$ENDIF}


Var
  CefSingleProcess: Boolean = False;
  CefNoSandbox: Boolean = True;
  CefBrowserSubprocessPath: ustring = '';
  CefWindowlessRenderingEnabled: Boolean = False;
  CefCachePath: ustring = '';
  CefCommandLineArgsDisabled: Boolean = False;
  CefUserDataPath: ustring = '';
  CefPersistSessionCookies: Boolean = False;
  CefPersistUserPreferences: Boolean = False;
  CefUserAgent: ustring = '';
  CefProductVersion: ustring = '';
  CefLocale: ustring = '';
  CefLogFile: ustring = '';
  CefLogSeverity: TCefLogSeverity = LOGSEVERITY_DEFAULT;
  CefJavaScriptFlags: ustring = '';
  CefResourcesDirPath: ustring = '';
  CefLocalesDirPath: ustring = '';
  CefPackLoadingDisabled: Boolean = False;
  CefRemoteDebuggingPort: Integer = 0;
  CefUncaughtExceptionStackSize: Integer = 10;
  CefContextSafetyImplementation: Integer = 0;
  CefBackgroundColor: TFPColor = (red: 255; green: 255; blue: 255; alpha: 0);
  CefAcceptLanguageList: ustring = '';

  CefGetDataResource: TGetDataResource = nil;
  CefGetLocalizedString: TGetLocalizedString = nil;

  CefResourceBundleHandler: ICefResourceBundleHandler = nil;
  CefBrowserProcessHandler: ICefBrowserProcessHandler = nil;
  CefRenderProcessHandler: ICefRenderProcessHandler = nil;

  CefOnBeforeCommandLineProcessing: TOnBeforeCommandLineProcessing = nil;
  CefOnRegisterCustomSchemes: TOnRegisterCustomSchemes = nil;

Implementation

Type
  TC = class(TThread)
    procedure Execute; override;
  end;

(*

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

*)

Var
  CefIsMainProcess: Boolean = False;


function CefInitDefault: Boolean;
begin
  {$IFDEF DEBUG}
  Debugln('CefInitDefault');
  {$ENDIF}

  Result := CefInitialize;
end;

function CefGetObject(ptr: Pointer): TObject; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}
begin
  Dec(ptr, SizeOf(Pointer));

  Result := TObject(ptr^);
end;

function CefGetData(const i: ICefBase): Pointer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}
begin
  If i <> nil then Result := i.Wrap
  Else Result := nil;
end;

{ TODO : Time functions }
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

function CefTimeToDateTime(const dt: TCefTime): TDateTime;
Var
  st: TSystemTime;
begin
  st := CefTimeToSystemTime(dt);
  SystemTimeToTzSpecificLocalTime(nil, @st, @st);
  Result := SystemTimeToDateTime(st);
end;

function DateTimeToCefTime(dt: TDateTime): TCefTime;
Var
  st: TSystemTime;
begin
  DateTimeToSystemTime(dt, st);
  TzSpecificLocalTimeToSystemTime(nil, @st, @st);
  Result := SystemTimeToCefTime(st);
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

function TColorToCefColor(const aColor: TColor): TCefColor;
Var
  red, green, blue: Byte;
begin
  RedGreenBlue(ColorToRGB(aColor), red, green, blue);
  Result := CefColorSetARGB(255, red, green, blue);
end;

function FPColorToCefColor(const aColor: TFPColor): TCefColor;
begin
  With aColor do
    Result := CefColorSetARGB(alpha, red, green, blue);
end;

function CefString(const str: ustring): TCefString;
begin
  Result.str := PChar16(PWideChar(str));
  Result.length := Length(str);
  Result.dtor := nil;
end;

function CefString(const str: PCefString): ustring;
begin
  If str <> nil then SetString(Result, str^.str, str^.length)
  Else Result := '';
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

function CefStringAlloc(const str: ustring): TCefString;
begin
  FillChar(Result, SizeOf(Result), 0);
  If str <> '' then cef_string_from_wide(PWideChar(str), Length(str), @Result);
end;

procedure CefStringFree(const str: PCefString);
begin
  If str <> nil then cef_string_clear(str);
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

procedure CefStringSet(const str: PCefString; const value: ustring);
begin
  If str <> nil then cef_string_set(PWideChar(value), Length(value), str, 1);
end;

{ *** API *** }

function CefInitialize: Boolean;
Var
  Settings: TCefSettings;
  App: ICefApp;
  ErrCode: Integer;

  Args : TCefMainArgs;
begin
  {$IFDEF DEBUG}
  Debugln('CefInitialize');
  {$ENDIF}

  If not CefLoadLibrary then
  begin
    Result := True;
    Exit;
  end;

  FillChar(Settings, SizeOf(settings), 0);

  Settings.size := SizeOf(Settings);
  Settings.single_process := Ord(CefSingleProcess);
  Settings.no_sandbox := Ord(CefNoSandbox);
  Settings.browser_subprocess_path := CefString(CefBrowserSubprocessPath);
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  Settings.multi_threaded_message_loop := Ord(True);
{$ELSE}
  Settings.multi_threaded_message_loop := Ord(False);
{$ENDIF}
  Settings.windowless_rendering_enabled := Ord(CefWindowlessRenderingEnabled);
  Settings.cache_path := CefString(CefCachePath);
  Settings.command_line_args_disabled := Ord(CefCommandLineArgsDisabled);
  Settings.user_data_path := CefString(CefUserDataPath);
  Settings.persist_session_cookies := Ord(CefPersistSessionCookies);
  Settings.persist_user_preferences := Ord(CefPersistUserPreferences);
  Settings.user_agent := CefString(CefUserAgent);
  Settings.product_version := CefString(CefProductVersion);
  Settings.locale := CefString(CefLocale);
  Settings.log_file := CefString(CefLogFile);
  Settings.log_severity := CefLogSeverity;
  Settings.javascript_flags := CefString(CefJavaScriptFlags);
  Settings.resources_dir_path := CefString(CefResourcesDirPath);
  Settings.locales_dir_path := CefString(CefLocalesDirPath);
  Settings.pack_loading_disabled := Ord(CefPackLoadingDisabled);
  Settings.remote_debugging_port := CefRemoteDebuggingPort;
  Settings.uncaught_exception_stack_size := CefUncaughtExceptionStackSize;
  Settings.context_safety_implementation := CefContextSafetyImplementation;
  Settings.background_color := FPColorToCefColor(CefBackgroundColor);
  Settings.accept_language_list := CefString(CefAcceptLanguageList);

  app := TInternalApp.Create;

  {$IFDEF WINDOWS}
  Args.instance := HINSTANCE();

  ErrCode := cef_execute_process(@Args, CefGetData(app), nil);
  {$ELSE}
  Args.argc := argc;
  Args.argv := argv;

  ErrCode := cef_execute_process(@Args, CefGetData(app), nil);
  {$ENDIF}

  If ErrCode >= 0 then Halt(ErrCode);

  ErrCode := cef_initialize(@Args, @settings, CefGetData(app), nil);
  If ErrCode <> 1 then
  begin
    Result := False;
    Exit;
  end;

  CefIsMainProcess := True;
  Result := True;

  {$IFDEF LINUX}
    // Install xlib error handlers so that the application won't be terminated
    // on non-fatal errors.
    XSetErrorHandler(@XErrorHandler);
    XSetIOErrorHandler(@XIOErrorHandler);
  {$ENDIF}
end;

procedure CefShutDown;
begin
  {$IFDEF DEBUG}
  Debugln('CefShutDown');
  {$ENDIF}

  If CefIsMainProcess then
  begin
    cef_shutdown();

    CefIsMainProcess := False;
  end;
end;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  procedure CefDoMessageLoopWork;
  begin
    cef_do_message_loop_work();
  end;

  procedure CefRunMessageLoop;
  begin
    cef_run_message_loop();
  end;

  procedure CefQuitMessageLoop;
  begin
    cef_quit_message_loop();
  end;
{$ENDIF}

procedure CefSetOsmodalLoop(osModalLoop: Boolean);
begin
  cef_set_osmodal_loop(Ord(osModalLoop));
end;

procedure CefEnableHighDPISupport;
begin
  cef_enable_highdpi_support();
end;

function CefBrowserHostCreateBrowser(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings; const requestContext: ICefRequestContext): Boolean;
Var
  u : TCefString;
begin
  CefInitialize;
  u := CefString(url);
  Result := cef_browser_host_create_browser(windowInfo, CefGetData(client), @u, settings, CefGetData(requestContext)) <> 0;
end;

function CefBrowserHostCreateBrowserSync(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings; const requestContext: ICefRequestContext): ICefBrowser;
Var
  u: TCefString;
begin
  CefInitialize;
  u := CefString(url);
  Result := TCefBrowserRef.UnWrap(cef_browser_host_create_browser_sync(windowInfo, CefGetData(client), @u, settings, CefGetData(requestContext)));
end;

function CefGetGeolocation(const callback: ICefGetGeolocationCallback): Boolean;
begin
  Result := cef_get_geolocation(CefGetData(callback)) <> 0;
end;

function CefGetGeolocationProc(const callback: TCefGetGeolocationCallbackProc): Boolean;
begin
  Result := CefGetGeolocation(TCefFastGetGeolocationCallback.Create(callback));
end;

function CefAddCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol, TargetDomain: ustring;
  AllowTargetSubdomains: Boolean): Boolean;
Var
  so, tp, td: TCefString;
begin
  CefInitialize;
  so := CefString(SourceOrigin);
  tp := CefString(TargetProtocol);
  td := CefString(TargetDomain);

  If TargetDomain <> '' then
    Result := cef_add_cross_origin_whitelist_entry(@so, @tp, @td, Ord(AllowTargetSubdomains)) <> 0
  Else
    Result := cef_add_cross_origin_whitelist_entry(@so, @tp, nil, Ord(AllowTargetSubdomains)) <> 0;
end;

function CefRemoveCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol, TargetDomain: ustring;
  AllowTargetSubdomains: Boolean): Boolean;
Var
  so, tp, td: TCefString;
begin
  CefInitialize;
  so := CefString(SourceOrigin);
  tp := CefString(TargetProtocol);
  td := CefString(TargetDomain);
  Result := cef_remove_cross_origin_whitelist_entry(@so, @tp, @td, Ord(AllowTargetSubdomains)) <> 0;
end;

function CefClearCrossOriginWhitelist: Boolean;
begin
  CefInitialize;
  Result := cef_clear_cross_origin_whitelist() <> 0;
end;

function CefParseUrl(const url: ustring; var parts: TUrlParts): Boolean;
Var
  u: TCefString;
  p: TCefUrlParts;
begin
  FillChar(p, sizeof(p), 0);
  u := CefString(url);
  Result := cef_parse_url(@u, @p) <> 0;
  If Result then
  begin
    parts.spec := CefString(@p.spec);
    parts.scheme := CefString(@p.scheme);
    parts.username := CefString(@p.username);
    parts.password := CefString(@p.password);
    parts.host := CefString(@p.host);
    parts.port := CefString(@p.port);
    parts.origin := CefString(@p.origin);
    parts.path := CefString(@p.path);
    parts.query := CefString(@p.query);
  end;
end;

function CefCreateUrl(var parts: TUrlParts): ustring;
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
  p.origin := CefString(parts.origin);
  p.path := CefString(parts.path);
  p.query := CefString(parts.query);

  FillChar(u, SizeOf(u), 0);
  If cef_create_url(@p, @u) <> 0 then Result := CefString(@u)
  Else Result := '';
end;

function CefFormatUrlForSecurityDisplay(const originUrl: ustring): ustring;
Var
  o: TCefString;
begin
  o := CefString(originUrl);

  Result := CefStringFreeAndGet(cef_format_url_for_security_display(@o));
end;

function CefGetMimeType(const extension: ustring): ustring;
Var
  e: TCefString;
begin
  e := CefString(extension);
  Result := CefStringFreeAndGet(cef_get_mime_type(@e));
end;

procedure CefGetExtensionsForMimeType(const mimeType: ustring; extensions: TStrings);
Var
  m, str: TCefString;
  i: Integer;
  list: TCefStringList;
begin
  m := CefString(mimeType);

  list := cef_string_list_alloc();
  try
    cef_get_extensions_for_mime_type(@m, list);

    FillChar(str, SizeOf(str), 0);
    For i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      extensions.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function CefBase64Encode(const data: Pointer; dataSize: TSize): ustring;
begin
  Result := CefStringFreeAndGet(cef_base64encode(data, dataSize));
end;

function CefBase64Decode(const data: ustring): ICefBinaryValue;
Var
  u: TCefString;
begin
  u := CefString(data);
  Result := TCefBinaryValueRef.UnWrap(cef_base64decode(@u));
end;

function CefUriEncode(const text: ustring; usePlus: Boolean): ustring;
Var
  t: TCefString;
begin
  t := CefString(text);
  Result := CefStringFreeAndGet(cef_uriencode(@t, Ord(usePlus)));
end;

function CefUriDecode(const text: ustring; convertToUtf8: Boolean;
  unescapeRules: TCefUriUnescapeRule): ustring;
Var
  t: TCefString;
begin
  t := CefString(text);
  Result := CefStringFreeAndGet(cef_uridecode(@t, Ord(convertToUtf8), unescapeRules));
end;

function CefParseJson(const jsonString: ustring; options: TCefJsonParserOptions): ICefValue;
Var
  j: TCefString;
begin
  j := CefString(jsonString);
  Result := TCefValueRef.UnWrap(cef_parse_json(@j, options));
end;

function CefParseJsonAndReturnError(const jsonString: ustring; options: TCefJsonParserOptions;
  out errorCode: TCefJsonParserError; out errorMsg: ustring): ICefValue;
Var
  j: TCefString;
  e: TCefString;
begin
  j := CefString(jsonString);
  Result := TCefValueRef.UnWrap(cef_parse_jsonand_return_error(@j, options, @errorCode, @e));
  errorMsg := CefStringClearAndGet(e);
end;

function CefWriteJson(node: ICefValue; options: TCefJsonWriterOptions): ustring;
begin
  Result := CefStringFreeAndGet(cef_write_json(CefGetData(node), options));
end;

function CefGetPath(key: TCefPathKey; out path: ustring): Boolean;
Var
  p: TCefString;
begin
  p := CefString('');
  Result := cef_get_path(key, @p) <> 0;
  path := CefStringClearAndGet(p);
end;

function CefLaunchProcess(commandLine: ICefCommandLine): Boolean;
begin
  Result := cef_launch_process(CefGetData(commandLine)) <> 0;
end;

function CefRegisterSchemeHandlerFactory(const SchemeName, HostName: ustring;
  SyncMainThread: Boolean; const handler: TCefResourceHandlerClass): Boolean;
Var
  s, h: TCefString;
begin
  CefInitialize;
  s := CefString(SchemeName);
  h := CefString(HostName);
  Result := cef_register_scheme_handler_factory(
    @s, @h, CefGetData(TCefSchemeHandlerFactoryOwn.Create(handler, SyncMainThread) as ICefBase)) <> 0;
end;

function CefClearSchemeHandlerFactories: Boolean;
begin
  CefInitialize;
  Result := cef_clear_scheme_handler_factories() <> 0;
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

function CefBeginTracing(const categories: ustring; callback: ICefCompletionCallback): Boolean;
Var
  c: TCefString;
begin
  c := CefString(categories);
  Result := cef_begin_tracing(@c, CefGetData(callback)) <> 0;
end;

function CefEndTracing(const tracingFile: ustring; callback: ICefEndTracingCallback): Boolean;
Var
  t: TCefString;
begin
  t := CefString(tracingFile);
  Result := cef_end_tracing(@t, CefGetData(callback)) <> 0;
end;

function CefNowFromSystemTraceTime: Int64;
begin
  Result := cef_now_from_system_trace_time();
end;

function CefRegisterExtension(const name, code: ustring; const Handler: ICefv8Handler): Boolean;
Var
  n, c: TCefString;
begin
  n := CefString(name);
  c := CefString(code);
  Result := cef_register_extension(@n, @c, CefGetData(handler)) <> 0;
end;

function Cefv8ContextInContext: Boolean;
begin
  Result := cef_v8context_in_context() <> 0;
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

procedure CefUnregisterInternalWebPlugin(const path: ustring);
Var
  p: TCefString;
begin
  p := CefString(path);
  cef_unregister_internal_web_plugin(@p);
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

function CefGetMinLogLevel: Integer;
begin
  Result := cef_get_min_log_level();
end;

function CefGetVlogLevel(const fileStart: String; n: TSize): Integer;
begin
  Result := cef_get_vlog_level(PChar(fileStart), n);
end;

procedure CefLog(const file_: String; line, severity: Integer; const message: String);
begin
  cef_log(PChar(file_), line, severity, PChar(message));
end;

function CefGetCurrentPlatformThreadId: TCefPlatformThreadId;
begin
  Result := cef_get_current_platform_thread_id();
end;

function CefGetCurrentPlatformThreadHandle: TCefPlatformThreadHandle;
begin
  Result := cef_get_current_platform_thread_handle();
end;

function CefTimeNow(out cefTime: TCefTime): Boolean;
begin
  Result := cef_time_now(@cefTime) <> 0;
end;

procedure CefTraceEventInstant(const category, name, arg1_name: String; arg1_val: UInt64;
  const arg2_name: String; arg2_val: UInt64; copy: Integer);
begin
  cef_trace_event_instant(PChar(category), PChar(name), PChar(arg1_name), arg1_val, PChar(arg2_name),
    arg2_val, copy);
end;

procedure CefTraceEventBegin(const category, name, arg1_name: String; arg1_val: UInt64;
  const arg2_name: String; arg2_val: UInt64; copy: Integer);
begin
  cef_trace_event_begin(PChar(category), PChar(name), PChar(arg1_name), arg1_val, PChar(arg2_name),
    arg2_val, copy);
end;

procedure CefTraceEventEnd(const category, name, arg1_name: String; arg1_val: UInt64;
  const arg2_name: String; arg2_val: UInt64; copy: Integer);
begin
  cef_trace_event_end(PChar(category), PChar(name), PChar(arg1_name), arg1_val, PChar(arg2_name),
    arg2_val, copy);
end;

procedure CefTraceCounter(const category, name, arg1_name: String; arg1_val: UInt64;
  const arg2_name: String; arg2_val: UInt64; copy: Integer);
begin
  cef_trace_counter(PChar(category), PChar(name), PChar(arg1_name), arg1_val, PChar(arg2_name),
    arg2_val, copy);
end;

procedure CefTraceCounterId(const category, name: String; id: UInt64; const value1_name: String;
  value1_val: UInt64; const value2_name: String; value2_val: UInt64; copy: Integer);
begin
  cef_trace_counter_id(PChar(category), PChar(name), id, PChar(value1_name), value1_val,
    PChar(value2_name), value2_val, copy);
end;

procedure CefTraceEventAsyncBegin(const category, name: String; id: UInt64;
  const arg1_name: String; arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64;
  copy: Integer);
begin
  cef_trace_event_async_begin(PChar(category), PChar(name), id, PChar(arg1_name), arg1_val,
    PChar(arg2_name), arg2_val, copy);
end;

procedure CefTraceEventAsyncStepInto(const category, name: String; id, step: UInt64;
  const arg1_name: String; arg1_val: UInt64; copy: Integer);
begin
  cef_trace_event_async_step_into(PChar(category), PChar(name), id, step, PChar(arg1_name),
    arg1_val, copy);
end;

procedure CefTraceEventAsyncStepPast(const category, name: String; id, step: UInt64;
  const arg1_name: String; arg1_val: UInt64; copy: Integer);
begin
  cef_trace_event_async_step_past(PChar(category), PChar(name), id, step, PChar(arg1_name),
    arg1_val, copy);
end;

procedure CefTraceEventAsyncEnd(const category, name: String; id: UInt64; const arg1_name: String;
  arg1_val: UInt64; const arg2_name: String; arg2_val: UInt64; copy: Integer);
begin
  cef_trace_event_async_end(PChar(category), PChar(name), id, PChar(arg1_name), arg1_val,
    PChar(arg2_name), arg2_val, copy);
end;

function CefVersionInfo(entry: Integer): Integer;
begin
  Result := cef_version_info(entry);
end;

function CefApiHash(entry: Integer): String;
begin
  Result := cef_api_hash(entry);
end;

{$IFDEF LINUX}
  procedure CefXWindowResize(const ABrowser: ICefBrowser; const Top, Left, Width, Height: Integer);
  Var
    changes: TXWindowChanges;
    TheHost: ICefBrowserHost;
  begin
    TheHost := ABrowser.Host;

    changes.x := Left;
    changes.y := Top;
    changes.width := Width;
    changes.height := Height;

    XConfigureWindow(cef_get_xdisplay(), TheHost.WindowHandle, CWX or CWY or CWHeight or CWWidth, @changes);
  end;

  procedure CefXLooseFocus(const ABrowser: ICefBrowser);
  begin
    XSetInputFocus(cef_get_xdisplay(), X.None, RevertToParent, CurrentTime);

    ABrowser.Host.SendCaptureLostEvent;
  end;

  procedure CefXSetVisibility(const ABrowser: ICefBrowser; const Value: Boolean);
  begin
    If Value then XMapWindow(cef_get_xdisplay(), ABrowser.Host.WindowHandle)
    Else XUnmapWindow(cef_get_xdisplay(), ABrowser.Host.WindowHandle);
  end;

  function XErrorHandler(display: PDisplay; event: PXErrorEvent): Integer; cdecl;
  begin
    {$IFDEF DEBUG}
    WriteLn('X error received: ');
    WriteLn(' type:         ', event^._type);
    WriteLn(' serial:       ', event^.serial);
    WriteLn(' error code:   ', event^.error_code);
    WriteLn(' request code: ', event^.request_code);
    WriteLn(' minor code:   ', event^.minor_code);
    {$ENDIF}

    Result := 0;
  end;

  function XIOErrorHandler(display: PDisplay): Integer; cdecl;
  begin
    {$IFDEF DEBUG}
    WriteLn('XIOErrorHandler');
    {$ENDIF}

    Result := 0;
  end;
{$ENDIF}

{ TC }

procedure TC.Execute;
begin
  { empty }
end;

Initialization

  // initialize threading system
  With TC.Create(False) do
  begin
    WaitFor;
    Free;
  end;

Finalization
  CefShutDown;

end.
