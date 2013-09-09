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

Unit cef3lib;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}Messages,{$ENDIF}
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  {$IFNDEF WINDOWS}cwstring, {$ENDIF}
  SysUtils, Classes, LCLProc, strutils,
  cef3api, cef3types, cef3intf, cef3ref, cef3own;

function CefInitDefault: Boolean;
function CefInitialize(const Cache: ustring = ''; const UserAgent: ustring = '';
  const ProductVersion: ustring = ''; const Locale: ustring = ''; const LogFile: ustring = '';
  const BrowserSubprocessPath: ustring = '';
  LogSeverity: TCefLogSeverity = LOGSEVERITY_DISABLE;
  JavaScriptFlags: ustring = ''; ResourcesDirPath: ustring = ''; LocalesDirPath: ustring = '';
  SingleProcess: Boolean = False; CommandLineArgsDisabled: Boolean = False; PackLoadingDisabled: Boolean = False;
  RemoteDebuggingPort: Integer = 0; ReleaseDCheck: Boolean = False;
  UncaughtExceptionStackSize: Integer = 0; ContextSafetyImplementation: Integer = 0): Boolean;
procedure CefShutDown;

function CefGetObject(ptr: Pointer): TObject; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
function CefGetData(const i: ICefBase) : Pointer; {$IFDEF SUPPORTS_INLINE}inline; {$ENDIF}

{$IFDEF WINDOWS}
function TzSpecificLocalTimeToSystemTime(
  lpTimeZoneInformation: PTimeZoneInformation;
  lpLocalTime, lpUniversalTime: PSystemTime): BOOL; stdcall; external 'kernel32.dll';
function SystemTimeToTzSpecificLocalTime(
  lpTimeZoneInformation: PTimeZoneInformation;
  lpUniversalTime, lpLocalTime: PSystemTime): BOOL; stdcall; external 'kernel32.dll';
function CefTimeToSystemTime(const dt: TCefTime): TSystemTime;
{$ENDIF}

function CefTimeToDateTime(const dt: TCefTime): TDateTime;
function DateTimeToCefTime(dt: TDateTime): TCefTime;

function CefRegisterSchemeHandlerFactory(const SchemeName, HostName: ustring;
  SyncMainThread: Boolean; const handler: TCefResourceHandlerClass): Boolean;
function CefClearSchemeHandlerFactories: Boolean;

function CefAddCrossOriginWhitelistEntry(const SourceOrigin, TargetProtocol,
  TargetDomain: ustring; AllowTargetSubdomains: Boolean): Boolean;
function CefRemoveCrossOriginWhitelistEntry(
  const SourceOrigin, TargetProtocol, TargetDomain: ustring;
  AllowTargetSubdomains: Boolean): Boolean;
function CefClearCrossOriginWhitelist: Boolean;

function CefRegisterExtension(const name, code: ustring;
  const Handler: ICefv8Handler): Boolean;
function CefCurrentlyOn(ThreadId: TCefThreadId): Boolean;
procedure CefPostTask(ThreadId: TCefThreadId; const task: ICefTask);
procedure CefPostDelayedTask(ThreadId: TCefThreadId; const task: ICefTask; delayMs: Int64);
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
procedure CefIsWebPluginUnstable(const path: ustring;
  const callback: ICefWebPluginUnstableCallback);
procedure CefIsWebPluginUnstableProc(const path: ustring;
  const callback: TCefWebPluginIsUnstableProc);

function CefGetPath(key: TCefPathKey; out path: ustring): Boolean;

{ ***  API  *** }

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
procedure CefDoMessageLoopWork;
procedure CefRunMessageLoop;
procedure CefQuitMessageLoop;
{$ENDIF}

function CefBrowserHostCreateSync(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): ICefBrowser;
function CefBrowserHostCreateBrowser(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): boolean;

function CefRequestCreate:ICefRequest;
function CefPostDataCreate:ICefPostData;
function CefPostDataElementCreate:ICefPostDataElement;

function CefBeginTracing(const client: ICefTraceClient; const categories: ustring): Boolean;
function CefGetTraceBufferPercentFullAsync: Integer;
function CefEndTracingAsync: Boolean;

function CefGetGeolocation(const callback: ICefGetGeolocationCallback): Boolean;

function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
function CefString(const str: ustring): TCefString; overload;
function CefString(const str: PCefString): ustring; overload;
function CefStringClearAndGet(var str: TCefString): ustring;
function CefStringAlloc(const str: ustring): TCefString;
procedure CefStringFree(const str: PCefString);
function CefUserFreeString(const str: ustring): PCefStringUserFree;
procedure CefStringSet(const str: PCefString; const value: ustring);

Var
  CefCache: ustring = '';
  CefUserAgent: ustring = '';
  CefProductVersion: ustring = '';
  CefLocale: ustring = '';
  CefLogFile: ustring = '';
  CefLogSeverity: TCefLogSeverity = LOGSEVERITY_DEFAULT;
  CefLocalStorageQuota: Cardinal = 0;
  CefSessionStorageQuota: Cardinal = 0;
  CefJavaScriptFlags: ustring = '';
  CefResourcesDirPath: ustring = '';
  CefLocalesDirPath: ustring = '';
  CefPackLoadingDisabled: Boolean = False;
  CefSingleProcess: Boolean = False;
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
  i    : Integer;
begin
  {$IFDEF DEBUG}
  Debugln('CefInitialize');
  {$ENDIF}

  If CefIsMainProcess then
  begin
    {$IFDEF DEBUG}
    Debugln('Already loaded.');
    {$ENDIF}

    Result := true;
    Exit;
  end;
  CefLoadLibrary;

  FillChar(settings, SizeOf(settings), 0);

  settings.size           := SizeOf(settings);
  settings.single_process := SingleProcess;
  settings.browser_subprocess_path := CefString(BrowserSubprocessPath);
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  settings.multi_threaded_message_loop := True;
{$ELSE}
  settings.multi_threaded_message_loop := False;
{$ENDIF}
  settings.command_line_args_disabled := CommandLineArgsDisabled;
  settings.cache_path := CefString(Cache);
  //settings.persist_session_cookies := ;
  settings.user_agent := CefString(UserAgent);
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
  //settings.ignore_certificate_error := ;

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
    Result := False;
    Exit;
  end;


  ErrCode := cef_initialize(@Args, @settings, CefGetData(app));
  If ErrCode <> 1 then
  begin
    Result := False;
    Exit;
  end;

  CefIsMainProcess := True;
  Result := True;
end;

procedure CefShutDown;
begin
  If CefIsMainProcess then
  begin
    cef_shutdown;

    CefIsMainProcess := False;
  end;
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
    CefGetData(TCefSchemeHandlerFactoryOwn.Create(handler, SyncMainThread) as ICefBase)
    ) <> 0;
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

  If TargetDomain <> '' then
    Result := cef_add_cross_origin_whitelist_entry(@so, @tp, @td, Ord(AllowTargetSubdomains)) <> 0
  Else
    Result := cef_add_cross_origin_whitelist_entry(@so, @tp, nil, Ord(AllowTargetSubdomains)) <> 0;
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

{$NOTE duplicate? }
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

function CefBrowserHostCreateBrowser(windowInfo: PCefWindowInfo; const client: ICefClient;
  const url: ustring; const settings: PCefBrowserSettings): Boolean;
Var
  u : TCefString;
begin
  CefInitDefault;
  u := CefString(url);
  Result := cef_browser_host_create_browser(windowInfo, CefGetData(client), @u, settings) <> 0;
end;

function CefRequestCreate: ICefRequest;
begin
  CefInitDefault;
  Result := TCefRequestRef.UnWrap(cef_request_create());
end;

function CefPostDataCreate: ICefPostData;
begin
  CefInitDefault;
  Result := TCefPostDataRef.UnWrap(cef_post_data_create());
end;

function CefPostDataElementCreate: ICefPostDataElement;
begin
  CefInitDefault;
  Result := TCefPostDataElementRef.UnWrap(cef_post_data_element_create());
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

function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
begin
  If str <> nil then
  begin
    Result := CefString(PCefString(str));
    cef_string_userfree_free(str);
  end
  Else Result := '';
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

Finalization
  CefShutDown;

end.
