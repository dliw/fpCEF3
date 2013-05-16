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

Unit cef3lib;

{$MODE objfpc}{$H+}

(*
{$ALIGN ON}
{$MINENUMSIZE 4}
*)


{$I cef.inc}

Interface

Uses
  {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}Messages,{$ENDIF}
  SysUtils, Classes, SyncObjs
  {$IFDEF MSWINDOWS}, Windows{$ENDIF}
  ;

Type
  //ustring = WideString;
  ustring = AnsiString;
  rbstring = AnsiString;
(*
{$IFDEF UNICODE}
  ustring = type String;
  rbstring = type RawByteString;
{$ELSE}
  {$IFDEF FPC}
    {$IF declared(unicodestring)}
      ustring = type UnicodeString;
    {$ELSE}
      ustring = type WideString;
    {$IFEND}
  {$ELSE}
    ustring = type WideString;
  {$ENDIF}
  rbstring = type AnsiString;
{$ENDIF}
*)

(*

{$if not defined(UInt64)}
  UInt64 = Int64;
{$ifend}

*)

  TCefWindowHandle = {$IFDEF LINUX}Pointer {PGTKWidget}{$ELSE}HWND{$ENDIF};
  TCefCursorHandle = {$IFDEF LINUX}Pointer{$ELSE}HCURSOR{$ENDIF};
  TCefEventHandle  = {$IFDEF LINUX}Pointer {PGDKEvent}{$ELSE}PMsg{$ENDIF};

  // CEF provides functions for converting between UTF-8, -16 and -32 strings.
  // CEF string types are safe for reading from multiple threads but not for
  // modification. It is the user's responsibility to provide synchronization if
  // modifying CEF strings from multiple threads.

  // CEF character type definitions. wchat_t is 2 bytes on Windows and 4 bytes on
  // most other platforms.

  Char16 = WideChar;
  PChar16 = PWideChar;


  // CEF string type definitions. Whomever allocates |str| is responsible for
  // providing an appropriate |dtor| implementation that will free the string in
  // the same memory space. When reusing an existing string structure make sure
  // to call |dtor| for the old value before assigning new |str| and |dtor|
  // values. Static strings will have a NULL |dtor| value. Using the below
  // functions if you want this managed for you.


  PCefStringWide = ^TCefStringWide;
  TCefStringWide = record
    str: PWideChar;
    length: Cardinal;
    dtor: procedure(str: PWideChar); cdecl;
  end;

  PCefStringUtf8 = ^TCefStringUtf8;
  TCefStringUtf8 = record
    str: PAnsiChar;
    length: Cardinal;
    dtor: procedure(str: PAnsiChar); cdecl;
  end;

  PCefStringUtf16 = ^TCefStringUtf16;
  TCefStringUtf16 = record
    str: PChar16;
    length: Cardinal;
    dtor: procedure(str: PChar16); cdecl;
  end;


  // It is sometimes necessary for the system to allocate string structures with
  // the expectation that the user will free them. The userfree types act as a
  // hint that the user is responsible for freeing the structure.

  PCefStringUserFreeWide = ^TCefStringUserFreeWide;
  TCefStringUserFreeWide = type TCefStringWide;

  PCefStringUserFreeUtf8 = ^TCefStringUserFreeUtf8;
  TCefStringUserFreeUtf8 = type TCefStringUtf8;

  PCefStringUserFreeUtf16 = ^TCefStringUserFreeUtf16;
  TCefStringUserFreeUtf16 = type TCefStringUtf16;

(*
{$IFDEF CEF_STRING_TYPE_UTF8}
  TCefChar = AnsiChar;
  PCefChar = PAnsiChar;
  TCefStringUserFree = TCefStringUserFreeUtf8;
  PCefStringUserFree = PCefStringUserFreeUtf8;
  TCefString = TCefStringUtf8;
  PCefString = PCefStringUtf8;
{$ENDIF}
*)

{$IFDEF CEF_STRING_TYPE_UTF16}
  TCefChar = Char16;
  PCefChar = PChar16;
  TCefStringUserFree = TCefStringUserFreeUtf16;
  PCefStringUserFree = PCefStringUserFreeUtf16;
  TCefString = TCefStringUtf16;
  PCefString = PCefStringUtf16;
{$ENDIF}

(*

{$IFDEF CEF_STRING_TYPE_WIDE}
  TCefChar = WideChar;
  PCefChar = PWideChar;
  TCefStringUserFree = TCefStringUserFreeWide;
  PCefStringUserFree = PCefStringUserFreeWide;
  TCefString = TCefStringWide;
  PCefString = PCefStringWide;
{$ENDIF}

*)

  // CEF strings are NUL-terminated wide character strings prefixed with a size
  // value, similar to the Microsoft BSTR type.  Use the below API functions for
  // allocating, managing and freeing CEF strings.

  // CEF string maps are a set of key/value string pairs.
  TCefStringMap = Pointer;

  // CEF string multimaps are a set of key/value string pairs.
  // More than one value can be assigned to a single key.
  TCefStringMultimap = Pointer;

  // CEF string maps are a set of key/value string pairs.
  TCefStringList = Pointer;

//---------------------------------------------------------------------

  // Structure representing CefExecuteProcess arguments.
  PCefMainArgs = ^TCefMainArgs;
  TCefMainArgs = record
    {$IFDEF LINUX}
      argc : Integer;
      argv : PPChar;
    {$ELSE}
      instance: HINST;
    {$ENDIF}
  end;

  // Structure representing window information.
  PCefWindowInfo = ^TCefWindowInfo;

  {$IFDEF LINUX}
  TCefWindowInfo = record

    // Pointer for the parent GtkBox widget.
    parent_widget: TCefWindowHandle;

    // Pointer for the new browser widget.
    widget: TCefWindowHandle;
  end;
  {$ENDIF}

(*

{$IFDEF MACOS}
  TCefWindowInfo = record
    m_windowName: TCefString;
    m_x: Integer;
    m_y: Integer;
    m_nWidth: Integer;
    m_nHeight: Integer;
    m_bHidden: Integer;

    // NSView pointer for the parent view.
    m_ParentView: TCefWindowHandle;

    // NSView pointer for the new browser view.
    m_View: TCefWindowHandle;
  end;
{$ENDIF}

{$IFDEF MSWINDOWS}
  TCefWindowInfo = record
    // Standard parameters required by CreateWindowEx()
    ex_style: DWORD;
    window_name: TCefString;
    style: DWORD;
    x: Integer;
    y: Integer;
    width: Integer;
    height: Integer;
    parent_window: HWND;
    menu: HMENU;
    // If window rendering is disabled no browser window will be created. Set
    // |parent_window| to be used for identifying monitor info
    // (MonitorFromWindow). If |parent_window| is not provided the main screen
    // monitor will be used.
    window_rendering_disabled: BOOL;

    // Set to true to enable transparent painting.
    // If window rendering is disabled and |transparent_painting| is set to true
    // WebKit rendering will draw on a transparent background (RGBA=0x00000000).
    // When this value is false the background will be white and opaque.
    transparent_painting: BOOL;

    // Handle for the new browser window.
    window: HWND ;
  end;
{$ENDIF}

*)

  // Log severity levels.
  TCefLogSeverity = (
    // Default logging (currently INFO logging).
    LOGSEVERITY_DEFAULT,
    // Verbose logging.
    LOGSEVERITY_VERBOSE,
    // INFO logging.
    LOGSEVERITY_INFO,
    // WARNING logging.
    LOGSEVERITY_WARNING,
    // ERROR logging.
    LOGSEVERITY_ERROR,
    // ERROR_REPORT logging.
    LOGSEVERITY_ERROR_REPORT,
    // Disables logging completely.
    LOGSEVERITY_DISABLE = 99
  );

  // Represents the state of a setting.
  TCefState = (
    // Use the default state for the setting.
    STATE_DEFAULT = 0,

    // Enable or allow the setting.
    STATE_ENABLED,

    // Disable or disallow the setting.
    STATE_DISABLED
  );

  // Initialization settings. Specify NULL or 0 to get the recommended default
  // values. Many of these and other settings can also configured using command-
  // line switches.
  PCefSettings = ^TCefSettings;
  TCefSettings = record
    // Size of this structure.
    size: Cardinal;

    // Set to true (1) to use a single process for the browser and renderer. This
    // run mode is not officially supported by Chromium and is less stable than
    // the multi-process default. Also configurable using the "single-process"
    // command-line switch.
    single_process: Boolean;

    // The path to a separate executable that will be launched for sub-processes.
    // By default the browser process executable is used. See the comments on
    // CefExecuteProcess() for details. Also configurable using the
    // "browser-subprocess-path" command-line switch.
    browser_subprocess_path: TCefString;

    // Set to true (1) to have the browser process message loop run in a separate
    // thread. If false (0) than the CefDoMessageLoopWork() function must be
    // called from your application message loop.
    multi_threaded_message_loop: Boolean;

    // Set to true (1) to disable configuration of browser process features using
    // standard CEF and Chromium command-line arguments. Configuration can still
    // be specified using CEF data structures or via the
    // CefApp::OnBeforeCommandLineProcessing() method.
    command_line_args_disabled: Boolean;

    // The location where cache data will be stored on disk. If empty an in-memory
    // cache will be used. HTML5 databases such as localStorage will only persist
    // across sessions if a cache path is specified.
    cache_path: TCefString;

    // Value that will be returned as the User-Agent HTTP header. If empty the
    // default User-Agent string will be used. Also configurable using the
    // "user-agent" command-line switch.
    user_agent: TCefString;

    // Value that will be inserted as the product portion of the default
    // User-Agent string. If empty the Chromium product version will be used. If
    // |userAgent| is specified this value will be ignored. Also configurable
    // using the "product-version" command-line switch.
    product_version: TCefString;

    // The locale string that will be passed to WebKit. If empty the default
    // locale of "en-US" will be used. This value is ignored on Linux where locale
    // is determined using environment variable parsing with the precedence order:
    // LANGUAGE, LC_ALL, LC_MESSAGES and LANG. Also configurable using the "lang"
    // command-line switch.
    locale: TCefString;

    // The directory and file name to use for the debug log. If empty, the
    // default name of "debug.log" will be used and the file will be written
    // to the application directory. Also configurable using the "log-file"
    // command-line switch.
    log_file: TCefString;

    // The log severity. Only messages of this severity level or higher will be
    // logged.
    log_severity: TCefLogSeverity;

    // Enable DCHECK in release mode to ease debugging. Also configurable using the
    // "enable-release-dcheck" command-line switch.
    release_dcheck_enabled: Boolean;

    // Custom flags that will be used when initializing the V8 JavaScript engine.
    // The consequences of using custom flags may not be well tested. Also
    // configurable using the "js-flags" command-line switch.
    javascript_flags: TCefString;

    // The fully qualified path for the resources directory. If this value is
    // empty the cef.pak and/or devtools_resources.pak files must be located in
    // the module directory on Windows/Linux or the app bundle Resources directory
    // on Mac OS X. Also configurable using the "resources-dir-path" command-line
    // switch.
    resources_dir_path: TCefString;

    // The fully qualified path for the locales directory. If this value is empty
    // the locales directory must be located in the module directory. This value
    // is ignored on Mac OS X where pack files are always loaded from the app
    // bundle Resources directory. Also configurable using the "locales-dir-path"
    // command-line switch.
    locales_dir_path: TCefString;

    // Set to true (1) to disable loading of pack files for resources and locales.
    // A resource bundle handler must be provided for the browser and render
    // processes via CefApp::GetResourceBundleHandler() if loading of pack files
    // is disabled. Also configurable using the "disable-pack-loading" command-
    // line switch.
    pack_loading_disabled: Boolean;

    // Set to a value between 1024 and 65535 to enable remote debugging on the
    // specified port. For example, if 8080 is specified the remote debugging URL
    // will be http://localhost:8080. CEF can be remotely debugged from any CEF or
    // Chrome browser window. Also configurable using the "remote-debugging-port"
    // command-line switch.
    remote_debugging_port: Integer;

    // The number of stack trace frames to capture for uncaught exceptions.
    // Specify a positive value to enable the CefV8ContextHandler::
    // OnUncaughtException() callback. Specify 0 (default value) and
    // OnUncaughtException() will not be called. Also configurable using the
    // "uncaught-exception-stack-size" command-line switch.

    uncaught_exception_stack_size: Integer;

    // By default CEF V8 references will be invalidated (the IsValid() method will
    // return false) after the owning context has been released. This reduces the
    // need for external record keeping and avoids crashes due to the use of V8
    // references after the associated context has been released.
    //
    // CEF currently offers two context safety implementations with different
    // performance characteristics. The default implementation (value of 0) uses a
    // map of hash values and should provide better performance in situations with
    // a small number contexts. The alternate implementation (value of 1) uses a
    // hidden value attached to each context and should provide better performance
    // in situations with a large number of contexts.
    //
    // If you need better performance in the creation of V8 references and you
    // plan to manually track context lifespan you can disable context safety by
    // specifying a value of -1.
    //
    // Also configurable using the "context-safety-implementation" command-line
    // switch.

    context_safety_implementation: Integer;
  end;

  // Browser initialization settings. Specify NULL or 0 to get the recommended
  // default values. The consequences of using custom values may not be well
  // tested. Many of these and other settings can also configured using command-
  // line switches.
  PCefBrowserSettings = ^TCefBrowserSettings;
  TCefBrowserSettings = record
    // Size of this structure.
    size: Cardinal;

    // The below values map to WebPreferences settings.

    // Font settings.
    standard_font_family: TCefString;
    fixed_font_family: TCefString;
    serif_font_family: TCefString;
    sans_serif_font_family: TCefString;
    cursive_font_family: TCefString;
    fantasy_font_family: TCefString;
    default_font_size: Integer;
    default_fixed_font_size: Integer;
    minimum_font_size: Integer;
    minimum_logical_font_size: Integer;

    // Default encoding for Web content. If empty "ISO-8859-1" will be used. Also
    // configurable using the "default-encoding" command-line switch.
    default_encoding: TCefString;

    // Location of the user style sheet that will be used for all pages. This must
    // be a data URL of the form "data:text/css;charset=utf-8;base64,csscontent"
    // where "csscontent" is the base64 encoded contents of the CSS file. Also
    // configurable using the "user-style-sheet-location" command-line switch.
    user_style_sheet_location: TCefString;

    // Controls the loading of fonts from remote sources. Also configurable using
    // the "disable-remote-fonts" command-line switch.
    remote_fonts: TCefState;

    // Controls whether JavaScript can be executed. Also configurable using the
    // "disable-javascript" command-line switch.
    javascript: TCefState;


    // Controls whether JavaScript can be used for opening windows. Also
    // configurable using the "disable-javascript-open-windows" command-line
    // switch.
    javascript_open_windows: TCefState;

    // Controls whether JavaScript can be used to close windows that were not
    // opened via JavaScript. JavaScript can still be used to close windows that
    // were opened via JavaScript. Also configurable using the
    // "disable-javascript-close-windows" command-line switch.
    javascript_close_windows: TCefState;

    // Controls whether JavaScript can access the clipboard. Also configurable
    // using the "disable-javascript-access-clipboard" command-line switch.
    javascript_access_clipboard: TCefState;

    // Controls whether DOM pasting is supported in the editor via
    // execCommand("paste"). The |javascript_access_clipboard| setting must also
    // be enabled. Also configurable using the "disable-javascript-dom-paste"
    // command-line switch.
    javascript_dom_paste: TCefState;

    // Controls whether the caret position will be drawn. Also configurable using
    // the "enable-caret-browsing" command-line switch.
    caret_browsing: TCefState;

    // Controls whether the Java plugin will be loaded. Also configurable using
    // the "disable-java" command-line switch.
    java: TCefState;

    // Controls whether any plugins will be loaded. Also configurable using the
    // "disable-plugins" command-line switch.
    plugins: TCefState;

    // Controls whether file URLs will have access to all URLs. Also configurable
    // using the "allow-universal-access-from-files" command-line switch.
    universal_access_from_file_urls: TCefState;

    // Controls whether file URLs will have access to other file URLs. Also
    // configurable using the "allow-access-from-files" command-line switch.
    file_access_from_file_urls: TCefState;

    // Controls whether web security restrictions (same-origin policy) will be
    // enforced. Disabling this setting is not recommend as it will allow risky
    // security behavior such as cross-site scripting (XSS). Also configurable
    // using the "disable-web-security" command-line switch.
    web_security: TCefState;

    // Controls whether image URLs will be loaded from the network. A cached image
    // will still be rendered if requested. Also configurable using the
    // "disable-image-loading" command-line switch.
    image_loading: TCefState;

    // Controls whether standalone images will be shrunk to fit the page. Also
    // configurable using the "image-shrink-standalone-to-fit" command-line
    // switch.
    image_shrink_standalone_to_fit: TCefState;

    // Controls whether text areas can be resized. Also configurable using the
    // "disable-text-area-resize" command-line switch.
    text_area_resize: TCefState;

    // Controls whether the fastback (back/forward) page cache will be used. Also
    // configurable using the "enable-fastback" command-line switch.
    page_cache: TCefState;

    // Controls whether the tab key can advance focus to links. Also configurable
    // using the "disable-tab-to-links" command-line switch.
    tab_to_links: TCefState;

    // Controls whether style sheets can be used. Also configurable using the
    // "disable-author-and-user-styles" command-line switch.
    author_and_user_styles: TCefState;

    // Controls whether local storage can be used. Also configurable using the
    // "disable-local-storage" command-line switch.
    local_storage: TCefState;

    // Controls whether databases can be used. Also configurable using the
    // "disable-databases" command-line switch.
    databases: TCefState;

    // Controls whether the application cache can be used. Also configurable using
    // the "disable-application-cache" command-line switch.
    application_cache: TCefState;

    // Controls whether WebGL can be used. Note that WebGL requires hardware
    // support and may not work on all systems even when enabled. Also
    // configurable using the "disable-webgl" command-line switch.
    webgl: TCefState;

    // Controls whether content that depends on accelerated compositing can be
    // used. Note that accelerated compositing requires hardware support and may
    // not work on all systems even when enabled. Also configurable using the
    // "disable-accelerated-compositing" command-line switch.
    accelerated_compositing: TCefState;

    // Controls whether developer tools (WebKit inspector) can be used. Also
    // configurable using the "disable-developer-tools" command-line switch.
    developer_tools: TCefState;
  end;

  // URL component parts.
  PCefUrlParts = ^TCefUrlParts;
  TCefUrlParts = record
    // The complete URL specification.
    spec: TCefString;

    // Scheme component not including the colon (e.g., "http").
    scheme: TCefString;

    // User name component.
    username: TCefString;

    // Password component.
    password: TCefString;

    // Host component. This may be a hostname, an IPv4 address or an IPv6 literal
    // surrounded by square brackets (e.g., "[2001:db8::1]").
    host: TCefString;

    // Port number component.
    port: TCefString;

    // Path component including the first slash following the host.
    path: TCefString;

    // Query string component (i.e., everything following the '?').
    query: TCefString;
  end;

  TUrlParts = record
    spec: ustring;
    scheme: ustring;
    username: ustring;
    password: ustring;
    host: ustring;
    port: ustring;
    path: ustring;
    query: ustring;
  end;

  // Time information. Values should always be in UTC.
  PCefTime = ^TCefTime;
  TCefTime = record
    year: Integer;          // Four digit year "2007"
    month: Integer;         // 1-based month (values 1 = January, etc.)
    day_of_week: Integer;   // 0-based day of week (0 = Sunday, etc.)
    day_of_month: Integer;  // 1-based day of month (1-31)
    hour: Integer;          // Hour within the current day (0-23)
    minute: Integer;        // Minute within the current hour (0-59)
    second: Integer;        // Second within the current minute (0-59 plus leap
                            //   seconds which may take it up to 60).
    millisecond: Integer;   // Milliseconds within the current second (0-999)
  end;

  // Cookie information.
  TCefCookie = record
    // The cookie name.
    name: TCefString;

    // The cookie value.
    value: TCefString;

    // If |domain| is empty a host cookie will be created instead of a domain
    // cookie. Domain cookies are stored with a leading "." and are visible to
    // sub-domains whereas host cookies are not.
    domain: TCefString;

    // If |path| is non-empty only URLs at or below the path will get the cookie
    // value.
    path: TCefString;

    // If |secure| is true the cookie will only be sent for HTTPS requests.
    secure: Boolean;

    // If |httponly| is true the cookie will only be sent for HTTP requests.
    httponly: Boolean;

    // The cookie creation date. This is automatically populated by the system on
    // cookie creation.
    creation: TCefTime;

    // The cookie last access date. This is automatically populated by the system
    // on access.
    last_access: TCefTime;

    // The cookie expiration date is only valid if |has_expires| is true.
    has_expires: Boolean;
    expires: TCefTime;
  end;

  // Process termination status values.
  TCefTerminationStatus = (
    // Non-zero exit status.
    TS_ABNORMAL_TERMINATION,
    // SIGKILL or task manager kill.
    TS_PROCESS_WAS_KILLED,
    // Segmentation fault.
    TS_PROCESS_CRASHED
  );

  // Path key values.
  TCefPathKey = (
    // Current directory.
    PK_DIR_CURRENT,
    // Directory containing PK_FILE_EXE.
    PK_DIR_EXE,
    // Directory containing PK_FILE_MODULE.
    PK_DIR_MODULE,
    // Temporary directory.
    PK_DIR_TEMP,
    // Path and filename of the current executable.
    PK_FILE_EXE,
    // Path and filename of the module containing the CEF code (usually the libcef
    // module).
    PK_FILE_MODULE
  );

  // Storage types.
  TCefStorageType = (
    ST_LOCALSTORAGE = 0,
    ST_SESSIONSTORAGE
  );

  // Supported error code values. See net\base\net_error_list.h for complete
  // descriptions of the error codes.
  TCefHandlerErrorcode = Integer;

Const
  ERR_NONE = 0;
  ERR_FAILED = -2;
  ERR_ABORTED = -3;
  ERR_INVALID_ARGUMENT = -4;
  ERR_INVALID_HANDLE = -5;
  ERR_FILE_NOT_FOUND = -6;
  ERR_TIMED_OUT = -7;
  ERR_FILE_TOO_BIG = -8;
  ERR_UNEXPECTED = -9;
  ERR_ACCESS_DENIED = -10;
  ERR_NOT_IMPLEMENTED = -11;
  ERR_CONNECTION_CLOSED = -100;
  ERR_CONNECTION_RESET = -101;
  ERR_CONNECTION_REFUSED = -102;
  ERR_CONNECTION_ABORTED = -103;
  ERR_CONNECTION_FAILED = -104;
  ERR_NAME_NOT_RESOLVED = -105;
  ERR_INTERNET_DISCONNECTED = -106;
  ERR_SSL_PROTOCOL_ERROR = -107;
  ERR_ADDRESS_INVALID = -108;
  ERR_ADDRESS_UNREACHABLE = -109;
  ERR_SSL_CLIENT_AUTH_CERT_NEEDED = -110;
  ERR_TUNNEL_CONNECTION_FAILED = -111;
  ERR_NO_SSL_VERSIONS_ENABLED = -112;
  ERR_SSL_VERSION_OR_CIPHER_MISMATCH = -113;
  ERR_SSL_RENEGOTIATION_REQUESTED = -114;
  ERR_CERT_COMMON_NAME_INVALID = -200;
  ERR_CERT_DATE_INVALID = -201;
  ERR_CERT_AUTHORITY_INVALID = -202;
  ERR_CERT_CONTAINS_ERRORS = -203;
  ERR_CERT_NO_REVOCATION_MECHANISM = -204;
  ERR_CERT_UNABLE_TO_CHECK_REVOCATION = -205;
  ERR_CERT_REVOKED = -206;
  ERR_CERT_INVALID = -207;
  ERR_CERT_END = -208;
  ERR_INVALID_URL = -300;
  ERR_DISALLOWED_URL_SCHEME = -301;
  ERR_UNKNOWN_URL_SCHEME = -302;
  ERR_TOO_MANY_REDIRECTS = -310;
  ERR_UNSAFE_REDIRECT = -311;
  ERR_UNSAFE_PORT = -312;
  ERR_INVALID_RESPONSE = -320;
  ERR_INVALID_CHUNKED_ENCODING = -321;
  ERR_METHOD_NOT_SUPPORTED = -322;
  ERR_UNEXPECTED_PROXY_AUTH = -323;
  ERR_EMPTY_RESPONSE = -324;
  ERR_RESPONSE_HEADERS_TOO_BIG = -325;
  ERR_CACHE_MISS = -400;
  ERR_INSECURE_RESPONSE = -501;

Type
  // V8 access control values.
  TCefV8AccessControl = (
    //V8_ACCESS_CONTROL_DEFAULT               = 0;
    V8_ACCESS_CONTROL_ALL_CAN_READ,
    V8_ACCESS_CONTROL_ALL_CAN_WRITE,
    V8_ACCESS_CONTROL_PROHIBITS_OVERWRITING
  );
  TCefV8AccessControls = set of TCefV8AccessControl;

  // V8 property attribute values.
  TCefV8PropertyAttribute = (
    //V8_PROPERTY_ATTRIBUTE_NONE       = 0;       // Writeable, Enumerable, Configurable
    V8_PROPERTY_ATTRIBUTE_READONLY,  // Not writeable
    V8_PROPERTY_ATTRIBUTE_DONTENUM,  // Not enumerable
    V8_PROPERTY_ATTRIBUTE_DONTDELETE // Not configurable
  );
  TCefV8PropertyAttributes = set of TCefV8PropertyAttribute;


Type
  // Post data elements may represent either bytes or files.
  TCefPostDataElementType = (
    PDE_TYPE_EMPTY  = 0,
    PDE_TYPE_BYTES,
    PDE_TYPE_FILE
  );

  // Flags used to customize the behavior of CefURLRequest.
  TCefUrlRequestFlag = (
    // Default behavior.
    //UR_FLAG_NONE                      = 0,
    // If set the cache will be skipped when handling the request.
    UR_FLAG_SKIP_CACHE,
    // If set user name, password, and cookies may be sent with the request.
    UR_FLAG_ALLOW_CACHED_CREDENTIALS,
    // If set cookies may be sent with the request and saved from the response.
    // UR_FLAG_ALLOW_CACHED_CREDENTIALS must also be set.
    UR_FLAG_ALLOW_COOKIES,
    // If set upload progress events will be generated when a request has a body.
    UR_FLAG_REPORT_UPLOAD_PROGRESS,
    // If set load timing info will be collected for the request.
    UR_FLAG_REPORT_LOAD_TIMING,
    // If set the headers sent and received for the request will be recorded.
    UR_FLAG_REPORT_RAW_HEADERS,
    // If set the CefURLRequestClient::OnDownloadData method will not be called.
    UR_FLAG_NO_DOWNLOAD_DATA,
    // If set 5XX redirect errors will be propagated to the observer instead of
    // automatically re-tried. This currently only applies for requests
    // originated in the browser process.
    UR_FLAG_NO_RETRY_ON_5XX
  );
  TCefUrlRequestFlags = set of TCefUrlRequestFlag;

  // Flags that represent CefURLRequest status.
  TCefUrlRequestStatus = (
    // Unknown status.
    UR_UNKNOWN = 0,
    // Request succeeded.
    UR_SUCCESS,
    // An IO request is pending, and the caller will be informed when it is
    // completed.
    UR_IO_PENDING,
    // Request was canceled programatically.
    UR_CANCELED,
    // Request failed for some reason.
    UR_FAILED
  );

  // Structure representing a rectangle.
  PCefRect = ^TCefRect;
  TCefRect = record
    x: Integer;
    y: Integer;
    width: Integer;
    height: Integer;
  end;

  TCefRectArray = array[0..(High(Integer) div SizeOf(TCefRect))-1] of TCefRect;
  PCefRectArray = ^TCefRectArray;

  // Existing process IDs.
  TCefProcessId = (
    // Browser process.
    PID_BROWSER,
    // Renderer process.
    PID_RENDERER
  );

  // Existing thread IDs.
  TCefThreadId = (
  // BROWSER PROCESS THREADS -- Only available in the browser process.
    // The main thread in the browser. This will be the same as the main
    // application thread if CefInitialize() is called with a
    // CefSettings.multi_threaded_message_loop value of false.
    ///
    TID_UI,

    // Used to interact with the database.
    TID_DB,

    // Used to interact with the file system.
    TID_FILE,

    // Used for file system operations that block user interactions.
    // Responsiveness of this thread affects users.
    TID_FILE_USER_BLOCKING,

    // Used to launch and terminate browser processes.
    TID_PROCESS_LAUNCHER,

    // Used to handle slow HTTP cache operations.
    TID_CACHE,

    // Used to process IPC and network messages.
    TID_IO,

    // RENDER PROCESS THREADS -- Only available in the render process.

    // The main thread in the renderer. Used for all WebKit and V8 interaction.
    TID_RENDERER
  );

  // Supported value types.
  TCefValueType = (
    VTYPE_INVALID = 0,
    VTYPE_NULL,
    VTYPE_BOOL,
    VTYPE_INT,
    VTYPE_DOUBLE,
    VTYPE_STRING,
    VTYPE_BINARY,
    VTYPE_DICTIONARY,
    VTYPE_LIST
  );

  // Supported JavaScript dialog types.
  TCefJsDialogType = (
    JSDIALOGTYPE_ALERT = 0,
    JSDIALOGTYPE_CONFIRM,
    JSDIALOGTYPE_PROMPT
  );

  // Supported menu IDs. Non-English translations can be provided for the
  // IDS_MENU_* strings in CefResourceBundleHandler::GetLocalizedString().
  TCefMenuId = (
    // Navigation.
    MENU_ID_BACK                = 100,
    MENU_ID_FORWARD             = 101,
    MENU_ID_RELOAD              = 102,
    MENU_ID_RELOAD_NOCACHE      = 103,
    MENU_ID_STOPLOAD            = 104,

    // Editing.
    MENU_ID_UNDO                = 110,
    MENU_ID_REDO                = 111,
    MENU_ID_CUT                 = 112,
    MENU_ID_COPY                = 113,
    MENU_ID_PASTE               = 114,
    MENU_ID_DELETE              = 115,
    MENU_ID_SELECT_ALL          = 116,

    // Miscellaneous.
    MENU_ID_FIND                = 130,
    MENU_ID_PRINT               = 131,
    MENU_ID_VIEW_SOURCE         = 132,

    // All user-defined menu IDs should come between MENU_ID_USER_FIRST and
    // MENU_ID_USER_LAST to avoid overlapping the Chromium and CEF ID ranges
    // defined in the tools/gritsettings/resource_ids file.
    MENU_ID_USER_FIRST          = 26500,
    MENU_ID_USER_LAST           = 28500
  );

  // Mouse button types.
  TCefMouseButtonType = (
    MBT_LEFT,
    MBT_MIDDLE,
    MBT_RIGHT
  );

  // Paint element types.
  TCefPaintElementType = (
    PET_VIEW,
    PET_POPUP
  );

  // Supported event bit flags.
  TCefEventFlag = (
    //EVENTFLAG_NONE                = 0,
    EVENTFLAG_CAPS_LOCK_ON,
    EVENTFLAG_SHIFT_DOWN,
    EVENTFLAG_CONTROL_DOWN,
    EVENTFLAG_ALT_DOWN,
    EVENTFLAG_LEFT_MOUSE_BUTTON,
    EVENTFLAG_MIDDLE_MOUSE_BUTTON,
    EVENTFLAG_RIGHT_MOUSE_BUTTON,
    // Mac OS-X command key.
    EVENTFLAG_COMMAND_DOWN,
    EVENTFLAG_NUM_LOCK_ON,
    EVENTFLAG_IS_KEY_PAD,
    EVENTFLAG_IS_LEFT,
    EVENTFLAG_IS_RIGHT
  );
  TCefEventFlags = set of TCefEventFlag;

  // Structure representing mouse event information.
  PCefMouseEvent = ^TCefMouseEvent;
  TCefMouseEvent = record
    // X coordinate relative to the left side of the view.
    x: Integer;

    // Y coordinate relative to the top side of the view.
    y: Integer;

    // Bit flags describing any pressed modifier keys. See
    // cef_event_flags_t for values.
    modifiers: TCefEventFlags;
  end;

  // Supported menu item types.
  TCefMenuItemType = (
    MENUITEMTYPE_NONE,
    MENUITEMTYPE_COMMAND,
    MENUITEMTYPE_CHECK,
    MENUITEMTYPE_RADIO,
    MENUITEMTYPE_SEPARATOR,
    MENUITEMTYPE_SUBMENU
  );

  // Supported context menu type flags.
  TCefContextMenuTypeFlag = (
    // No node is selected.
    //CM_TYPEFLAG_NONE        = 0,
    // The top page is selected.
    CM_TYPEFLAG_PAGE,
    // A subframe page is selected.
    CM_TYPEFLAG_FRAME,
    // A link is selected.
    CM_TYPEFLAG_LINK,
    // A media node is selected.
    CM_TYPEFLAG_MEDIA,
    // There is a textual or mixed selection that is selected.
    CM_TYPEFLAG_SELECTION,
    // An editable element is selected.
    CM_TYPEFLAG_EDITABLE
  );
  TCefContextMenuTypeFlags = set of TCefContextMenuTypeFlag;

  // Supported context menu media types.
  TCefContextMenuMediaType = (
    // No special node is in context.
    CM_MEDIATYPE_NONE,
    // An image node is selected.
    CM_MEDIATYPE_IMAGE,
    // A video node is selected.
    CM_MEDIATYPE_VIDEO,
    // An audio node is selected.
    CM_MEDIATYPE_AUDIO,
    // A file node is selected.
    CM_MEDIATYPE_FILE,
    // A plugin node is selected.
    CM_MEDIATYPE_PLUGIN
  );

  // Supported context menu media state bit flags.
  TCefContextMenuMediaStateFlag = (
    //CM_MEDIAFLAG_NONE                  = 0,
    CM_MEDIAFLAG_ERROR,
    CM_MEDIAFLAG_PAUSED,
    CM_MEDIAFLAG_MUTED,
    CM_MEDIAFLAG_LOOP,
    CM_MEDIAFLAG_CAN_SAVE,
    CM_MEDIAFLAG_HAS_AUDIO,
    CM_MEDIAFLAG_HAS_VIDEO,
    CM_MEDIAFLAG_CONTROL_ROOT_ELEMENT,
    CM_MEDIAFLAG_CAN_PRINT,
    CM_MEDIAFLAG_CAN_ROTATE
  );
  TCefContextMenuMediaStateFlags = set of TCefContextMenuMediaStateFlag;

  // Supported context menu edit state bit flags.
  TCefContextMenuEditStateFlag = (
    //CM_EDITFLAG_NONE            = 0,
    CM_EDITFLAG_CAN_UNDO,
    CM_EDITFLAG_CAN_REDO,
    CM_EDITFLAG_CAN_CUT,
    CM_EDITFLAG_CAN_COPY,
    CM_EDITFLAG_CAN_PASTE,
    CM_EDITFLAG_CAN_DELETE,
    CM_EDITFLAG_CAN_SELECT_ALL,
    CM_EDITFLAG_CAN_TRANSLATE
 );
 TCefContextMenuEditStateFlags = set of TCefContextMenuEditStateFlag;

  // Key event types.
  TCefKeyEventType = (
    KEYEVENT_RAWKEYDOWN = 0,
    KEYEVENT_KEYDOWN,
    KEYEVENT_KEYUP,
    KEYEVENT_CHAR
  );

  // Structure representing keyboard event information.
  PCefKeyEvent = ^TCefKeyEvent;
  TCefKeyEvent = record
    // The type of keyboard event.
    kind: TCefKeyEventType;

    // Bit flags describing any pressed modifier keys. See
    // cef_event_flags_t for values.
    modifiers: TCefEventFlags;

    // The Windows key code for the key event. This value is used by the DOM
    // specification. Sometimes it comes directly from the event (i.e. on
    // Windows) and sometimes it's determined using a mapping function. See
    // WebCore/platform/chromium/KeyboardCodes.h for the list of values.
    windows_key_code: Integer;

    // The actual key code genenerated by the platform.
    native_key_code: Integer;

    // Indicates whether the event is considered a "system key" event (see
    // http://msdn.microsoft.com/en-us/library/ms646286(VS.85).aspx for details).
    // This value will always be false on non-Windows platforms.
    is_system_key: Boolean;

    // The character generated by the keystroke.
    character: WideChar;

    // Same as |character| but unmodified by any concurrently-held modifiers
    // (except shift). This is useful for working out shortcut keys.
    unmodified_character: WideChar;

    // True if the focus is currently on an editable field on the page. This is
    // useful for determining if standard key events should be intercepted.
    focus_on_editable_field: Boolean;
  end;

  // Focus sources.
  TCefFocusSource = (
    // The source is explicit navigation via the API (LoadURL(), etc).
    FOCUS_SOURCE_NAVIGATION = 0,
    // The source is a system-generated focus event.
    FOCUS_SOURCE_SYSTEM
  );

  // Navigation types.
  TCefNavigationType = (
    NAVIGATION_LINK_CLICKED,
    NAVIGATION_FORM_SUBMITTED,
    NAVIGATION_BACK_FORWARD,
    NAVIGATION_RELOAD,
    NAVIGATION_FORM_RESUBMITTED,
    NAVIGATION_OTHER
  );

  // Supported XML encoding types. The parser supports ASCII, ISO-8859-1, and
  // UTF16 (LE and BE) by default. All other types must be translated to UTF8
  // before being passed to the parser. If a BOM is detected and the correct
  // decoder is available then that decoder will be used automatically.
  TCefXmlEncodingType = (
    XML_ENCODING_NONE = 0,
    XML_ENCODING_UTF8,
    XML_ENCODING_UTF16LE,
    XML_ENCODING_UTF16BE,
    XML_ENCODING_ASCII
  );

  // XML node types.
  TCefXmlNodeType = (
    XML_NODE_UNSUPPORTED = 0,
    XML_NODE_PROCESSING_INSTRUCTION,
    XML_NODE_DOCUMENT_TYPE,
    XML_NODE_ELEMENT_START,
    XML_NODE_ELEMENT_END,
    XML_NODE_ATTRIBUTE,
    XML_NODE_TEXT,
    XML_NODE_CDATA,
    XML_NODE_ENTITY_REFERENCE,
    XML_NODE_WHITESPACE,
    XML_NODE_COMMENT
  );

  // Popup window features.
  PCefPopupFeatures = ^TCefPopupFeatures;
  TCefPopupFeatures = record
    x: Integer;
    xSet: Boolean;
    y: Integer;
    ySet: Boolean;
    width: Integer;
    widthSet: Boolean;
    height: Integer;
    heightSet: Boolean;

    menuBarVisible: Boolean;
    statusBarVisible: Boolean;
    toolBarVisible: Boolean;
    locationBarVisible: Boolean;
    scrollbarsVisible: Boolean;
    resizable: Boolean;

    fullscreen: Boolean;
    dialog: Boolean;
    additionalFeatures: TCefStringList;
  end;

  // DOM document types.
  TCefDomDocumentType = (
    DOM_DOCUMENT_TYPE_UNKNOWN = 0,
    DOM_DOCUMENT_TYPE_HTML,
    DOM_DOCUMENT_TYPE_XHTML,
    DOM_DOCUMENT_TYPE_PLUGIN
  );

  // DOM event category flags.
  TCefDomEventCategory = Integer;
const
  DOM_EVENT_CATEGORY_UNKNOWN = $0;
  DOM_EVENT_CATEGORY_UI = $1;
  DOM_EVENT_CATEGORY_MOUSE = $2;
  DOM_EVENT_CATEGORY_MUTATION = $4;
  DOM_EVENT_CATEGORY_KEYBOARD = $8;
  DOM_EVENT_CATEGORY_TEXT = $10;
  DOM_EVENT_CATEGORY_COMPOSITION = $20;
  DOM_EVENT_CATEGORY_DRAG = $40;
  DOM_EVENT_CATEGORY_CLIPBOARD = $80;
  DOM_EVENT_CATEGORY_MESSAGE = $100;
  DOM_EVENT_CATEGORY_WHEEL = $200;
  DOM_EVENT_CATEGORY_BEFORE_TEXT_INSERTED = $400;
  DOM_EVENT_CATEGORY_OVERFLOW = $800;
  DOM_EVENT_CATEGORY_PAGE_TRANSITION = $1000;
  DOM_EVENT_CATEGORY_POPSTATE = $2000;
  DOM_EVENT_CATEGORY_PROGRESS = $4000;
  DOM_EVENT_CATEGORY_XMLHTTPREQUEST_PROGRESS = $8000;
  DOM_EVENT_CATEGORY_WEBKIT_ANIMATION = $10000;
  DOM_EVENT_CATEGORY_WEBKIT_TRANSITION = $20000;
  DOM_EVENT_CATEGORY_BEFORE_LOAD = $40000;

type
  // DOM event processing phases.
  TCefDomEventPhase = (
    DOM_EVENT_PHASE_UNKNOWN = 0,
    DOM_EVENT_PHASE_CAPTURING,
    DOM_EVENT_PHASE_AT_TARGET,
    DOM_EVENT_PHASE_BUBBLING
  );

  // DOM node types.
  TCefDomNodeType = (
    DOM_NODE_TYPE_UNSUPPORTED = 0,
    DOM_NODE_TYPE_ELEMENT,
    DOM_NODE_TYPE_ATTRIBUTE,
    DOM_NODE_TYPE_TEXT,
    DOM_NODE_TYPE_CDATA_SECTION,
    DOM_NODE_TYPE_ENTITY_REFERENCE,
    DOM_NODE_TYPE_ENTITY,
    DOM_NODE_TYPE_PROCESSING_INSTRUCTIONS,
    DOM_NODE_TYPE_COMMENT,
    DOM_NODE_TYPE_DOCUMENT,
    DOM_NODE_TYPE_DOCUMENT_TYPE,
    DOM_NODE_TYPE_DOCUMENT_FRAGMENT,
    DOM_NODE_TYPE_NOTATION,
    DOM_NODE_TYPE_XPATH_NAMESPACE
  );

  // Supported file dialog modes.
  TCefFileDialogMode = (
    // Requires that the file exists before allowing the user to pick it.
    FILE_DIALOG_OPEN,

    // Like Open, but allows picking multiple files to open.
    FILE_DIALOG_OPEN_MULTIPLE,

    // Allows picking a nonexistent file, and prompts to overwrite if the file
    // already exists.
    FILE_DIALOG_SAVE
  );

  // Geoposition error codes.
  TCefGeopositionErrorCode = (
    GEOPOSITON_ERROR_NONE,
    GEOPOSITON_ERROR_PERMISSION_DENIED,
    GEOPOSITON_ERROR_POSITION_UNAVAILABLE,
    GEOPOSITON_ERROR_TIMEOUT
  );

  // Structure representing geoposition information. The properties of this
  // structure correspond to those of the JavaScript Position object although
  // their types may differ.
  PCefGeoposition = ^TCefGeoposition;
  TCefGeoposition = record
    // Latitude in decimal degrees north (WGS84 coordinate frame).
    latitude: Double;

    // Longitude in decimal degrees west (WGS84 coordinate frame).
    longitude: Double;

    // Altitude in meters (above WGS84 datum).
    altitude: Double;

    // Accuracy of horizontal position in meters.
    accuracy: Double;

    // Accuracy of altitude in meters.
    altitude_accuracy: Double;

    // Heading in decimal degrees clockwise from true north.
    heading: Double;

    // Horizontal component of device velocity in meters per second.
    speed: Double;

    // Time of position measurement in miliseconds since Epoch in UTC time. This
    // is taken from the host computer's system clock.
    timestamp: TCefTime;

    // Error code, see enum above.
    error_code: TCefGeopositionErrorCode;

    // Human-readable error message.
    error_message: TCefString;
  end;


(*******************************************************************************
   capi
 *******************************************************************************)

Type
  PCefv8Handler = ^TCefv8Handler;
  PCefV8Accessor = ^TCefV8Accessor;
  PCefv8Value = ^TCefv8Value;
  PCefV8StackTrace = ^TCefV8StackTrace;
  PCefV8StackFrame = ^TCefV8StackFrame;
  PCefV8ValueArray = array[0..(High(Integer) div SizeOf(Integer)) - 1] of PCefV8Value;
  PPCefV8Value = ^PCefV8ValueArray;
  PCefSchemeHandlerFactory = ^TCefSchemeHandlerFactory;
  PCefSchemeRegistrar = ^TCefSchemeRegistrar;
  PCefFrame = ^TCefFrame;
  PCefRequest = ^TCefRequest;
  PCefStreamReader = ^TCefStreamReader;
  PCefPostData = ^TCefPostData;
  PCefPostDataElement = ^TCefPostDataElement;
  PPCefPostDataElement = ^PCefPostDataElement;
  PCefReadHandler = ^TCefReadHandler;
  PCefWriteHandler = ^TCefWriteHandler;
  PCefStreamWriter = ^TCefStreamWriter;
  PCefBase = ^TCefBase;
  PCefBrowser = ^TCefBrowser;
  PCefRunFileDialogCallback = ^TCefRunFileDialogCallback;
  PCefBrowserHost = ^TCefBrowserHost;
  PCefTask = ^TCefTask;
  PCefTaskRunner = ^TCefTaskRunner;
  PCefDownloadHandler = ^TCefDownloadHandler;
  PCefXmlReader = ^TCefXmlReader;
  PCefZipReader = ^TCefZipReader;
  PCefDomVisitor = ^TCefDomVisitor;
  PCefDomDocument = ^TCefDomDocument;
  PCefDomNode = ^TCefDomNode;
  PCefDomEventListener = ^TCefDomEventListener;
  PCefDomEvent = ^TCefDomEvent;
  PCefResponse = ^TCefResponse;
  PCefv8Context = ^TCefv8Context;
  PCefCookieVisitor = ^TCefCookieVisitor;
  PCefCookie = ^TCefCookie;
  PCefClient = ^TCefClient;
  PCefLifeSpanHandler = ^TCefLifeSpanHandler;
  PCefLoadHandler = ^TCefLoadHandler;
  PCefRequestHandler = ^TCefRequestHandler;
  PCefDisplayHandler = ^TCefDisplayHandler;
  PCefFocusHandler = ^TCefFocusHandler;
  PCefKeyboardHandler = ^TCefKeyboardHandler;
  PCefJsDialogHandler = ^TCefJsDialogHandler;
  PCefApp = ^TCefApp;
  PCefV8Exception = ^TCefV8Exception;
  PCefResourceBundleHandler = ^TCefResourceBundleHandler;
  PCefCookieManager = ^TCefCookieManager;
  PCefWebPluginInfo = ^TCefWebPluginInfo;
  PCefCommandLine = ^TCefCommandLine;
  PCefProcessMessage = ^TCefProcessMessage;
  PCefBinaryValue = ^TCefBinaryValue;
  PCefDictionaryValue = ^TCefDictionaryValue;
  PCefListValue = ^TCefListValue;
  PCefBrowserProcessHandler = ^TCefBrowserProcessHandler;
  PCefRenderProcessHandler = ^TCefRenderProcessHandler;
  PCefAuthCallback = ^TCefAuthCallback;
  PCefQuotaCallback = ^TCefQuotaCallback;
  PCefResourceHandler = ^TCefResourceHandler;
  PCefCallback = ^TCefCallback;
  PCefContextMenuHandler = ^TCefContextMenuHandler;
  PCefContextMenuParams = ^TCefContextMenuParams;
  PCefMenuModel = ^TCefMenuModel;
  PCefGeolocationCallback = ^TCefGeolocationCallback;
  PCefGeolocationHandler = ^TCefGeolocationHandler;
  PCefBeforeDownloadCallback = ^TCefBeforeDownloadCallback;
  PCefDownloadItemCallback = ^TCefDownloadItemCallback;
  PCefDownloadItem = ^TCefDownloadItem;
  PCefStringVisitor = ^TCefStringVisitor;
  PCefJsDialogCallback = ^TCefJsDialogCallback;
  PCefUrlRequest = ^TCefUrlRequest;
  PCefUrlRequestClient = ^TCefUrlRequestClient;
  PCefWebPluginInfoVisitor = ^TCefWebPluginInfoVisitor;
  PCefWebPluginUnstableCallback = ^TCefWebPluginUnstableCallback;
  PCefFileDialogCallback = ^TCefFileDialogCallback;
  PCefDialogHandler = ^TCefDialogHandler;
  PCefRenderHandler = ^TCefRenderHandler;
  PCefGetGeolocationCallback = ^TCefGetGeolocationCallback;
  PCefTraceClient = ^TCefTraceClient;

  // Structure defining the reference count implementation functions. All
  // framework structures must include the cef_base_t structure first.
  TCefBase = record
    // Size of the data structure.
    size: Cardinal;

    // Increment the reference count.
    add_ref: function(self: PCefBase): Integer; cdecl;
    // Decrement the reference count.  Delete this object when no references
    // remain.
    release: function(self: PCefBase): Integer; cdecl;
    // Returns the current number of references.
    get_refct: function(self: PCefBase): Integer; cdecl;
  end;

  // Structure representing a binary value. Can be used on any process and thread.
  TCefBinaryValue = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefBinaryValue): Integer; cdecl;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefBinaryValue): Integer; cdecl;

    // Returns a copy of this object. The data in this object will also be copied.
    copy: function(self: PCefBinaryValue): PCefBinaryValue; cdecl;

    // Returns the data size.
    get_size: function(self: PCefBinaryValue): Cardinal; cdecl;

    // Read up to |buffer_size| number of bytes into |buffer|. Reading begins at
    // the specified byte |data_offset|. Returns the number of bytes read.
    get_data: function(self: PCefBinaryValue; buffer: Pointer; buffer_size, data_offset: Cardinal): Cardinal; cdecl;
  end;

  // Structure representing a dictionary value. Can be used on any process and
  // thread.
  TCefDictionaryValue = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefDictionaryValue): Integer; cdecl;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefDictionaryValue): Integer; cdecl;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefDictionaryValue): Integer; cdecl;

    // Returns a writable copy of this object. If |exclude_NULL_children| is true
    // (1) any NULL dictionaries or lists will be excluded from the copy.
    copy: function(self: PCefDictionaryValue; exclude_empty_children: Integer): PCefDictionaryValue; cdecl;

    // Returns the number of values.
    get_size: function(self: PCefDictionaryValue): Cardinal; cdecl;

    // Removes all values. Returns true (1) on success.
    clear: function(self: PCefDictionaryValue): Integer; cdecl;

    // Returns true (1) if the current dictionary has a value for the given key.
    has_key: function(self: PCefDictionaryValue; const key: PCefString): Integer; cdecl;

    // Reads all keys for this dictionary into the specified vector.
    get_keys: function(self: PCefDictionaryValue; const keys: TCefStringList): Integer; cdecl;

    // Removes the value at the specified key. Returns true (1) is the value was
    // removed successfully.
    remove: function(self: PCefDictionaryValue; const key: PCefString): Integer; cdecl;

    // Returns the value type for the specified key.
    get_type: function(self: PCefDictionaryValue; const key: PCefString): TCefValueType; cdecl;

    // Returns the value at the specified key as type bool.
    get_bool: function(self: PCefDictionaryValue; const key: PCefString): Integer; cdecl;

    // Returns the value at the specified key as type int.
    get_int: function(self: PCefDictionaryValue; const key: PCefString): Integer; cdecl;

    // Returns the value at the specified key as type double.
    get_double: function(self: PCefDictionaryValue; const key: PCefString): Double; cdecl;

    // Returns the value at the specified key as type string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string: function(self: PCefDictionaryValue; const key: PCefString): PCefStringUserFree; cdecl;

    // Returns the value at the specified key as type binary.
    get_binary: function(self: PCefDictionaryValue; const key: PCefString): PCefBinaryValue; cdecl;

    // Returns the value at the specified key as type dictionary.
    get_dictionary: function(self: PCefDictionaryValue; const key: PCefString): PCefDictionaryValue; cdecl;

    // Returns the value at the specified key as type list.
    get_list: function(self: PCefDictionaryValue; const key: PCefString): PCefListValue; cdecl;

    // Sets the value at the specified key as type null. Returns true (1) if the
    // value was set successfully.
    set_null: function(self: PCefDictionaryValue; const key: PCefString): Integer; cdecl;

    // Sets the value at the specified key as type bool. Returns true (1) if the
    // value was set successfully.
    set_bool: function(self: PCefDictionaryValue; const key: PCefString; value: Integer): Integer; cdecl;

    // Sets the value at the specified key as type int. Returns true (1) if the
    // value was set successfully.
    set_int: function(self: PCefDictionaryValue; const key: PCefString; value: Integer): Integer; cdecl;

    // Sets the value at the specified key as type double. Returns true (1) if the
    // value was set successfully.
    set_double: function(self: PCefDictionaryValue; const key: PCefString; value: Double): Integer; cdecl;

    // Sets the value at the specified key as type string. Returns true (1) if the
    // value was set successfully.
    set_string: function(self: PCefDictionaryValue; const key: PCefString; value: PCefString): Integer; cdecl;

    // Sets the value at the specified key as type binary. Returns true (1) if the
    // value was set successfully. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_binary: function(self: PCefDictionaryValue; const key: PCefString; value: PCefBinaryValue): Integer; cdecl;

    // Sets the value at the specified key as type dict. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_dictionary: function(self: PCefDictionaryValue; const key: PCefString; value: PCefDictionaryValue): Integer; cdecl;

    // Sets the value at the specified key as type list. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_list: function(self: PCefDictionaryValue; const key: PCefString; value: PCefListValue): Integer; cdecl;
  end;

  // Structure representing a list value. Can be used on any process and thread.
  TCefListValue = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefListValue): Integer; cdecl;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefListValue): Integer; cdecl;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefListValue): Integer; cdecl;

    // Returns a writable copy of this object.
    copy: function(self: PCefListValue): PCefListValue; cdecl;

    // Sets the number of values. If the number of values is expanded all new
    // value slots will default to type null. Returns true (1) on success.
    set_size: function(self: PCefListValue; size: Cardinal): Integer; cdecl;

    // Returns the number of values.
    get_size: function(self: PCefListValue): Cardinal; cdecl;

    // Removes all values. Returns true (1) on success.
    clear: function(self: PCefListValue): Integer; cdecl;

    // Removes the value at the specified index.
    remove: function(self: PCefListValue; index: Integer): Integer; cdecl;

    // Returns the value type at the specified index.
    get_type: function(self: PCefListValue; index: Integer): TCefValueType; cdecl;

    // Returns the value at the specified index as type bool.
    get_bool: function(self: PCefListValue; index: Integer): Integer; cdecl;

    // Returns the value at the specified index as type int.
    get_int: function(self: PCefListValue; index: Integer): Integer; cdecl;

    // Returns the value at the specified index as type double.
    get_double: function(self: PCefListValue; index: Integer): Double; cdecl;

    // Returns the value at the specified index as type string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string: function(self: PCefListValue; index: Integer): PCefStringUserFree; cdecl;

    // Returns the value at the specified index as type binary.
    get_binary: function(self: PCefListValue; index: Integer): PCefBinaryValue; cdecl;

    // Returns the value at the specified index as type dictionary.
    get_dictionary: function(self: PCefListValue; index: Integer): PCefDictionaryValue; cdecl;

    // Returns the value at the specified index as type list.
    get_list: function(self: PCefListValue; index: Integer): PCefListValue; cdecl;

    // Sets the value at the specified index as type null. Returns true (1) if the
    // value was set successfully.
    set_null: function(self: PCefListValue; index: Integer): Integer; cdecl;

    // Sets the value at the specified index as type bool. Returns true (1) if the
    // value was set successfully.
    set_bool: function(self: PCefListValue; index, value: Integer): Integer; cdecl;

    // Sets the value at the specified index as type int. Returns true (1) if the
    // value was set successfully.
    set_int: function(self: PCefListValue; index, value: Integer): Integer; cdecl;

    // Sets the value at the specified index as type double. Returns true (1) if
    // the value was set successfully.
    set_double: function(self: PCefListValue; index: Integer; value: Double): Integer; cdecl;

    // Sets the value at the specified index as type string. Returns true (1) if
    // the value was set successfully.
    set_string: function(self: PCefListValue; index: Integer; value: PCefString): Integer; cdecl;

    // Sets the value at the specified index as type binary. Returns true (1) if
    // the value was set successfully. After calling this function the |value|
    // object will no longer be valid. If |value| is currently owned by another
    // object then the value will be copied and the |value| reference will not
    // change. Otherwise, ownership will be transferred to this object and the
    // |value| reference will be invalidated.
    set_binary: function(self: PCefListValue; index: Integer; value: PCefBinaryValue): Integer; cdecl;

    // Sets the value at the specified index as type dict. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_dictionary: function(self: PCefListValue; index: Integer; value: PCefDictionaryValue): Integer; cdecl;

    // Sets the value at the specified index as type list. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_list: function(self: PCefListValue; index: Integer; value: PCefListValue): Integer; cdecl;
  end;

  // Implement this structure for asynchronous task execution. If the task is
  // posted successfully and if the associated message loop is still running then
  // the execute() function will be called on the target thread. If the task fails
  // to post then the task object may be destroyed on the source thread instead of
  // the target thread. For this reason be cautious when performing work in the
  // task object destructor.
  TCefTask = record
    // Base structure.
    base: TCefBase;
    // Method that will be executed on the target thread.
    execute: procedure(self: PCefTask); cdecl;
  end;

  // Structure that asynchronously executes tasks on the associated thread. It is
  // safe to call the functions of this structure on any thread.
  //
  // CEF maintains multiple internal threads that are used for handling different
  // types of tasks in different processes. The cef_thread_id_t definitions in
  // cef_types.h list the common CEF threads. Task runners are also available for
  // other CEF threads as appropriate (for example, V8 WebWorker threads).
  TCefTaskRunner = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is pointing to the same task runner as
    // |that| object.
    is_same: function(self, that: PCefTaskRunner): Integer; cdecl;

    // Returns true (1) if this task runner belongs to the current thread.
    belongs_to_current_thread: function(self: PCefTaskRunner): Integer; cdecl;

    // Returns true (1) if this task runner is for the specified CEF thread.
    belongs_to_thread: function(self: PCefTaskRunner; threadId: TCefThreadId): Integer; cdecl;

    // Post a task for execution on the thread associated with this task runner.
    // Execution will occur asynchronously.
    post_task: function(self: PCefTaskRunner; task: PCefTask): Integer; cdecl;

    // Post a task for delayed execution on the thread associated with this task
    // runner. Execution will occur asynchronously. Delayed tasks are not
    // supported on V8 WebWorker threads and will be executed without the
    // specified delay.
    post_delayed_task: function(self: PCefTaskRunner; task: PCefTask; delay_ms: Int64): Integer; cdecl;
  end;

  // Structure representing a message. Can be used on any process and thread.
  TCefProcessMessage = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefProcessMessage): Integer; cdecl;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefProcessMessage): Integer; cdecl;

    // Returns a writable copy of this object.
    copy: function(self: PCefProcessMessage): PCefProcessMessage; cdecl;

    // Returns the message name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefProcessMessage): PCefStringUserFree; cdecl;

    // Returns the list of arguments.
    get_argument_list: function(self: PCefProcessMessage): PCefListValue; cdecl;
  end;

  // Class used to represent a browser window. When used in the browser process
  // the methods of this class may be called on any thread unless otherwise
  // indicated in the comments. When used in the render process the methods of
  // this class may only be called on the main thread.
  TCefBrowser = record
    // Base structure.
    base: TCefBase;

    // Returns the browser host object. This function can only be called in the
    // browser process.
    get_host: function(self: PCefBrowser): PCefBrowserHost; cdecl;

    // Returns true (1) if the browser can navigate backwards.
    can_go_back: function(self: PCefBrowser): Integer; cdecl;

    // Navigate backwards.
    go_back: procedure(self: PCefBrowser); cdecl;

    // Returns true (1) if the browser can navigate forwards.
    can_go_forward: function(self: PCefBrowser): Integer; cdecl;

    // Navigate forwards.
    go_forward: procedure(self: PCefBrowser); cdecl;

    // Returns true (1) if the browser is currently loading.
    is_loading: function(self: PCefBrowser): Integer; cdecl;

    // Reload the current page.
    reload: procedure(self: PCefBrowser); cdecl;

    // Reload the current page ignoring any cached data.
    reload_ignore_cache: procedure(self: PCefBrowser); cdecl;

    // Stop loading the page.
    stop_load: procedure(self: PCefBrowser); cdecl;

    // Returns the globally unique identifier for this browser.
    get_identifier  : function(self: PCefBrowser): Integer; cdecl;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefBrowser): Integer; cdecl;

    // Returns true (1) if the window is a popup window.
    is_popup: function(self: PCefBrowser): Integer; cdecl;

    // Returns true (1) if a document has been loaded in the browser.
    has_document: function(self: PCefBrowser): Integer; cdecl;

    // Returns the main (top-level) frame for the browser window.
    get_main_frame: function(self: PCefBrowser): PCefFrame; cdecl;

    // Returns the focused frame for the browser window.
    get_focused_frame: function(self: PCefBrowser): PCefFrame; cdecl;

    // Returns the frame with the specified identifier, or NULL if not found.
    get_frame_byident: function(self: PCefBrowser; identifier: Int64): PCefFrame; cdecl;

    // Returns the frame with the specified name, or NULL if not found.
    get_frame: function(self: PCefBrowser; const name: PCefString): PCefFrame; cdecl;

    // Returns the number of frames that currently exist.
    get_frame_count: function(self: PCefBrowser): Cardinal; cdecl;

    // Returns the identifiers of all existing frames.
    get_frame_identifiers: procedure(self: PCefBrowser; identifiersCount: PCardinal; identifiers: PInt64); cdecl;

    // Returns the names of all existing frames.
    get_frame_names: procedure(self: PCefBrowser; names: TCefStringList); cdecl;

    // Send a message to the specified |target_process|. Returns true (1) if the
    // message was sent successfully.
    send_process_message: function(self: PCefBrowser; target_process: TCefProcessId;
      message: PCefProcessMessage): Integer; cdecl;
  end;

  // Callback structure for cef_browser_host_t::RunFileDialog. The functions of
  // this structure will be called on the browser process UI thread.
  TCefRunFileDialogCallback = record
    // Base structure.
    base: TCefBase;

    // Called asynchronously after the file dialog is dismissed. If the selection
    // was successful |file_paths| will be a single value or a list of values
    // depending on the dialog mode. If the selection was cancelled |file_paths|
    // will be NULL.
    cont: procedure(self: PCefRunFileDialogCallback; browser_host: PCefBrowserHost;
      file_paths: TCefStringList); cdecl;
  end;

  // Structure used to represent the browser process aspects of a browser window.
  // The functions of this structure can only be called in the browser process.
  // They may be called on any thread in that process unless otherwise indicated
  // in the comments.
  TCefBrowserHost = record
    // Base structure.
    base: TCefBase;

    // Returns the hosted browser object.
    get_browser: function(self: PCefBrowserHost): PCefBrowser; cdecl;

    // Call this function before destroying a contained browser window. This
    // function performs any internal cleanup that may be needed before the
    // browser window is destroyed.
    parent_window_will_close: procedure(self: PCefBrowserHost); cdecl;

    // Closes this browser window.
    close_browser: procedure(self: PCefBrowserHost); cdecl;

    // Set focus for the browser window. If |enable| is true (1) focus will be set
    // to the window. Otherwise, focus will be removed.
    set_focus: procedure(self: PCefBrowserHost; enable: Integer); cdecl;

    // Retrieve the window handle for this browser.
    get_window_handle: function(self: PCefBrowserHost): TCefWindowHandle; cdecl;

    // Retrieve the window handle of the browser that opened this browser. Will
    // return NULL for non-popup windows. This function can be used in combination
    // with custom handling of modal windows.
    get_opener_window_handle: function(self: PCefBrowserHost): TCefWindowHandle; cdecl;

    // Returns the client for this browser.
    get_client: function(self: PCefBrowserHost): PCefClient; cdecl;

    // Returns the DevTools URL for this browser. If |http_scheme| is true (1) the
    // returned URL will use the http scheme instead of the chrome-devtools
    // scheme. Remote debugging can be enabled by specifying the "remote-
    // debugging-port" command-line flag or by setting the
    // CefSettings.remote_debugging_port value. If remote debugging is not enabled
    // this function will return an NULL string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_dev_tools_url: function(self: PCefBrowserHost; http_scheme: Integer): PCefStringUserFree; cdecl;

    // Get the current zoom level. The default zoom level is 0.0. This function
    // can only be called on the UI thread.
    get_zoom_level: function(self: PCefBrowserHost): Double; cdecl;

    // Change the zoom level to the specified value. Specify 0.0 to reset the zoom
    // level. If called on the UI thread the change will be applied immediately.
    // Otherwise, the change will be applied asynchronously on the UI thread.
    set_zoom_level: procedure(self: PCefBrowserHost; zoomLevel: Double); cdecl;

    // Call to run a file chooser dialog. Only a single file chooser dialog may be
    // pending at any given time. |mode| represents the type of dialog to display.
    // |title| to the title to be used for the dialog and may be NULL to show the
    // default title ("Open" or "Save" depending on the mode). |default_file_name|
    // is the default file name to select in the dialog. |accept_types| is a list
    // of valid lower-cased MIME types or file extensions specified in an input
    // element and is used to restrict selectable files to such types. |callback|
    // will be executed after the dialog is dismissed or immediately if another
    // dialog is already pending. The dialog will be initiated asynchronously on
    // the UI thread.
    run_file_dialog: procedure(self: PCefBrowserHost; mode: TCefFileDialogMode;
      const title, default_file_name: PCefString; accept_types: TCefStringList;
      callback: PCefRunFileDialogCallback); cdecl;

    // Returns true (1) if window rendering is disabled.
    is_window_rendering_disabled: function(self: PCefBrowserHost): Integer; cdecl;

    // Notify the browser that the widget has been resized. The browser will first
    // call cef_render_handler_t::GetViewRect to get the new size and then call
    // cef_render_handler_t::OnPaint asynchronously with the updated regions. This
    // function is only used when window rendering is disabled.
    was_resized: procedure(self: PCefBrowserHost); cdecl;

    ///
    // Invalidate the |dirtyRect| region of the view. The browser will call
    // cef_render_handler_t::OnPaint asynchronously with the updated regions. This
    // function is only used when window rendering is disabled.
    ///
    invalidate: procedure(self: PCefBrowserHost; const dirtyRect: PCefRect;
      kind: TCefPaintElementType); cdecl;

    // Send a key event to the browser.
    send_key_event: procedure(self: PCefBrowserHost; const event: PCefKeyEvent); cdecl;

    // Send a mouse click event to the browser. The |x| and |y| coordinates are
    // relative to the upper-left corner of the view.
    send_mouse_click_event: procedure(self: PCefBrowserHost;
      const event: PCefMouseEvent; kind: TCefMouseButtonType;
      mouseUp, clickCount: Integer); cdecl;

    // Send a mouse move event to the browser. The |x| and |y| coordinates are
    // relative to the upper-left corner of the view.
    send_mouse_move_event: procedure(self: PCefBrowserHost;
        const event: PCefMouseEvent; mouseLeave: Integer); cdecl;

    // Send a mouse wheel event to the browser. The |x| and |y| coordinates are
    // relative to the upper-left corner of the view. The |deltaX| and |deltaY|
    // values represent the movement delta in the X and Y directions respectively.
    // In order to scroll inside select popups with window rendering disabled
    // cef_render_handler_t::GetScreenPoint should be implemented properly.
    send_mouse_wheel_event: procedure(self: PCefBrowserHost;
        const event: PCefMouseEvent; deltaX, deltaY: Integer); cdecl;

    // Send a focus event to the browser.
    send_focus_event: procedure(self: PCefBrowserHost; setFocus: Integer); cdecl;

    // Send a capture lost event to the browser.
    send_capture_lost_event: procedure(self: PCefBrowserHost);
  end;

  // Implement this structure to receive string values asynchronously.
  TCefStringVisitor = record
    // Base structure.
    base: TCefBase;

    // Method that will be executed.
    visit: procedure(self: PCefStringVisitor; const str: PCefString); cdecl;
  end;

  // Structure used to represent a frame in the browser window. When used in the
  // browser process the functions of this structure may be called on any thread
  // unless otherwise indicated in the comments. When used in the render process
  // the functions of this structure may only be called on the main thread.
  TCefFrame = record
    // Base structure.
    base: TCefBase;

    // True if this object is currently attached to a valid frame.
    is_valid: function(self: PCefFrame): Integer; cdecl;

    // Execute undo in this frame.
    undo: procedure(self: PCefFrame); cdecl;

    // Execute redo in this frame.
    redo: procedure(self: PCefFrame); cdecl;

    // Execute cut in this frame.
    cut: procedure(self: PCefFrame); cdecl;

    // Execute copy in this frame.
    copy: procedure(self: PCefFrame); cdecl;

    // Execute paste in this frame.
    paste: procedure(self: PCefFrame); cdecl;

    // Execute delete in this frame.
    del: procedure(self: PCefFrame); cdecl;

    // Execute select all in this frame.
    select_all: procedure(self: PCefFrame); cdecl;

    // Save this frame's HTML source to a temporary file and open it in the
    // default text viewing application. This function can only be called from the
    // browser process.
    view_source: procedure(self: PCefFrame); cdecl;

    // Retrieve this frame's HTML source as a string sent to the specified
    // visitor.
    get_source: procedure(self: PCefFrame; visitor: PCefStringVisitor); cdecl;

    // Retrieve this frame's display text as a string sent to the specified
    // visitor.
    get_text: procedure(self: PCefFrame; visitor: PCefStringVisitor); cdecl;

    // Load the request represented by the |request| object.
    load_request: procedure(self: PCefFrame; request: PCefRequest); cdecl;

    // Load the specified |url|.
    load_url: procedure(self: PCefFrame; const url: PCefString); cdecl;

    // Load the contents of |stringVal| with the optional dummy target |url|.
    load_string: procedure(self: PCefFrame; const stringVal, url: PCefString); cdecl;

    // Execute a string of JavaScript code in this frame. The |script_url|
    // parameter is the URL where the script in question can be found, if any. The
    // renderer may request this URL to show the developer the source of the
    // error.  The |start_line| parameter is the base line number to use for error
    // reporting.
    execute_java_script: procedure(self: PCefFrame; const code,
      script_url: PCefString; start_line: Integer); cdecl;

    // Returns true (1) if this is the main (top-level) frame.
    is_main: function(self: PCefFrame): Integer; cdecl;

    // Returns true (1) if this is the focused frame.
    is_focused: function(self: PCefFrame): Integer; cdecl;

    // Returns the name for this frame. If the frame has an assigned name (for
    // example, set via the iframe "name" attribute) then that value will be
    // returned. Otherwise a unique name will be constructed based on the frame
    // parent hierarchy. The main (top-level) frame will always have an NULL name
    // value.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefFrame): PCefStringUserFree; cdecl;

    // Returns the globally unique identifier for this frame.
    get_identifier: function(self: PCefFrame): Int64; cdecl;

    // Returns the parent of this frame or NULL if this is the main (top-level)
    // frame.
    get_parent: function(self: PCefFrame): PCefFrame; cdecl;

    // Returns the URL currently loaded in this frame.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefFrame): PCefStringUserFree; cdecl;

    // Returns the browser that this frame belongs to.
    get_browser: function(self: PCefFrame): PCefBrowser; cdecl;

    // Get the V8 context associated with the frame. This function can only be
    // called from the render process.
    get_v8context: function(self: PCefFrame): PCefv8Context; cdecl;

    // Visit the DOM document. This function can only be called from the render
    // process.
    visit_dom: procedure(self: PCefFrame; visitor: PCefDomVisitor); cdecl;
  end;

  // Structure used to implement a custom resource bundle structure. The functions
  // of this structure may be called on multiple threads.
  TCefResourceBundleHandler = record
    // Base structure.
    base: TCefBase;

    // Called to retrieve a localized translation for the string specified by
    // |message_id|. To provide the translation set |string| to the translation
    // string and return true (1). To use the default translation return false
    // (0). Supported message IDs are listed in cef_pack_strings.h.
    get_localized_string: function(self: PCefResourceBundleHandler;
      message_id: Integer; string_val: PCefString): Integer; cdecl;

    // Called to retrieve data for the resource specified by |resource_id|. To
    // provide the resource data set |data| and |data_size| to the data pointer
    // and size respectively and return true (1). To use the default resource data
    // return false (0). The resource data will not be copied and must remain
    // resident in memory. Supported resource IDs are listed in
    // cef_pack_resources.h.
    get_data_resource: function(self: PCefResourceBundleHandler;
        resource_id: Integer; var data: Pointer; var data_size: Cardinal): Integer; cdecl;
  end;

  // Structure used to create and/or parse command line arguments. Arguments with
  // '--', '-' and, on Windows, '/' prefixes are considered switches. Switches
  // will always precede any arguments without switch prefixes. Switches can
  // optionally have a value specified using the '=' delimiter (e.g.
  // "-switch=value"). An argument of "--" will terminate switch parsing with all
  // subsequent tokens, regardless of prefix, being interpreted as non-switch
  // arguments. Switch names are considered case-insensitive. This structure can
  // be used before cef_initialize() is called.
  TCefCommandLine = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefCommandLine): Integer; cdecl;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefCommandLine): Integer; cdecl;

    // Returns a writable copy of this object.
    copy: function(self: PCefCommandLine): PCefCommandLine; cdecl;

    // Initialize the command line with the specified |argc| and |argv| values.
    // The first argument must be the name of the program. This function is only
    // supported on non-Windows platforms.
    init_from_argv: procedure(self: PCefCommandLine; argc: Integer; const argv: PPAnsiChar); cdecl;

    // Initialize the command line with the string returned by calling
    // GetCommandLineW(). This function is only supported on Windows.
    init_from_string: procedure(self: PCefCommandLine; command_line: PCefString); cdecl;

    // Reset the command-line switches and arguments but leave the program
    // component unchanged.
    reset: procedure(self: PCefCommandLine); cdecl;

    // Retrieve the original command line string as a vector of strings. The argv
    // array: { program, [(--|-|/)switch[=value]]*, [--], [argument]* }
    get_argv: procedure(self: PCefCommandLine; argv: TCefStringList); cdecl;

    // Constructs and returns the represented command line string. Use this
    // function cautiously because quoting behavior is unclear.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_command_line_string: function(self: PCefCommandLine): PCefStringUserFree; cdecl;

    // Get the program part of the command line string (the first item).
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_program: function(self: PCefCommandLine): PCefStringUserFree; cdecl;

    // Set the program part of the command line string (the first item).
    set_program: procedure(self: PCefCommandLine; program_: PCefString); cdecl;

    // Returns true (1) if the command line has switches.
    has_switches: function(self: PCefCommandLine): Integer; cdecl;

    // Returns true (1) if the command line contains the given switch.
    has_switch: function(self: PCefCommandLine; const name: PCefString): Integer; cdecl;

    // Returns the value associated with the given switch. If the switch has no
    // value or isn't present this function returns the NULL string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_switch_value: function(self: PCefCommandLine; const name: PCefString): PCefStringUserFree; cdecl;

    // Returns the map of switch names and values. If a switch has no value an
    // NULL string is returned.
    get_switches: procedure(self: PCefCommandLine; switches: TCefStringMap); cdecl;

    // Add a switch to the end of the command line. If the switch has no value
    // pass an NULL value string.
    append_switch: procedure(self: PCefCommandLine; const name: PCefString); cdecl;

    // Add a switch with the specified value to the end of the command line.
    append_switch_with_value: procedure(self: PCefCommandLine; const name, value: PCefString); cdecl;

    // True if there are remaining command line arguments.
    has_arguments: function(self: PCefCommandLine): Integer; cdecl;

    // Get the remaining command line arguments.
    get_arguments: procedure(self: PCefCommandLine; arguments: TCefStringList); cdecl;

    // Add an argument to the end of the command line.
    append_argument: procedure(self: PCefCommandLine; const argument: PCefString); cdecl;

    // Insert a command before the current command. Common for debuggers, like
    // "valgrind" or "gdb --args".
    prepend_wrapper: procedure(self: PCefCommandLine; const wrapper: PCefString); cdecl;
  end;

  // Structure used to implement browser process callbacks. The functions of this
  // structure will be called on the browser process main thread unless otherwise
  // indicated.
  TCefBrowserProcessHandler = record
    // Base structure.
    base: TCefBase;

    // Called on the browser process UI thread immediately after the CEF context
    // has been initialized.
    on_context_initialized: procedure(self: PCefBrowserProcessHandler); cdecl;

    // Called before a child process is launched. Will be called on the browser
    // process UI thread when launching a render process and on the browser
    // process IO thread when launching a GPU or plugin process. Provides an
    // opportunity to modify the child process command line. Do not keep a
    // reference to |command_line| outside of this function.
    on_before_child_process_launch: procedure(self: PCefBrowserProcessHandler;
      command_line: PCefCommandLine); cdecl;

    // Called on the browser process IO thread after the main thread has been
    // created for a new render process. Provides an opportunity to specify extra
    // information that will be passed to
    // cef_render_process_handler_t::on_render_thread_created() in the render
    // process. Do not keep a reference to |extra_info| outside of this function.
    on_render_process_thread_created: procedure(self: PCefBrowserProcessHandler;
        extra_info: PCefListValue); cdecl;
  end;

  // Structure used to implement render process callbacks. The functions of this
  // structure will be called on the render process main thread (TID_RENDERER)
  // unless otherwise indicated.
  TCefRenderProcessHandler = record
    // Base structure.
    base: TCefBase;

    // Called after the render process main thread has been created. |extra_info|
    // is a read-only value originating from
    // cef_browser_process_handler_t::on_render_process_thread_created(). Do not
    // keep a reference to |extra_info| outside of this function.
    on_render_thread_created: procedure(self: PCefRenderProcessHandler;
      extra_info: PCefListValue); cdecl;

    // Called after WebKit has been initialized.
    on_web_kit_initialized: procedure(self: PCefRenderProcessHandler); cdecl;

    // Called after a browser has been created. When browsing cross-origin a new
    // browser will be created before the old browser with the same identifier is
    // destroyed.
    on_browser_created: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser); cdecl;

    // Called before a browser is destroyed.
    on_browser_destroyed: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser); cdecl;

    // Called before browser navigation. Return true (1) to cancel the navigation
    // or false (0) to allow the navigation to proceed. The |request| object
    // cannot be modified in this callback.
    on_before_navigation: function(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; request: PCefRequest;
      navigation_type: TCefNavigationType; is_redirect: Integer): Integer; cdecl;

    // Called immediately after the V8 context for a frame has been created. To
    // retrieve the JavaScript 'window' object use the
    // cef_v8context_t::get_global() function. V8 handles can only be accessed
    // from the thread on which they are created. A task runner for posting tasks
    // on the associated thread can be retrieved via the
    // cef_v8context_t::get_task_runner() function.
    on_context_created: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context); cdecl;

    // Called immediately before the V8 context for a frame is released. No
    // references to the context should be kept after this function is called.
    on_context_released: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context); cdecl;

    // Called for global uncaught exceptions in a frame. Execution of this
    // callback is disabled by default. To enable set
    // CefSettings.uncaught_exception_stack_size > 0.
    on_uncaught_exception: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context;
      exception: PCefV8Exception; stackTrace: PCefV8StackTrace); cdecl;

    // Called on the WebWorker thread immediately after the V8 context for a new
    // WebWorker has been created. To retrieve the JavaScript 'self' object use
    // the cef_v8context_t::get_global() function. V8 handles can only be accessed
    // from the thread on which they are created. A task runner for posting tasks
    // on the associated thread can be retrieved via the
    // cef_v8context_t::get_task_runner() function.
    on_worker_context_created: procedure(self: PCefRenderProcessHandler;
      worker_id: Integer; const url: PCefString; context: PCefv8Context); cdecl;

    // Called on the WebWorker thread immediately before the V8 context for a
    // WebWorker is released. No references to the context should be kept after
    // this function is called. Any tasks posted or pending on the WebWorker
    // thread after this function is called may not be executed.
    on_worker_context_released: procedure(self: PCefRenderProcessHandler;
      worker_id: Integer; const url: PCefString; context: PCefv8Context); cdecl;

    // Called on the WebWorker thread for global uncaught exceptions in a
    // WebWorker. Execution of this callback is disabled by default. To enable set
    // CefSettings.uncaught_exception_stack_size > 0.
    on_worker_uncaught_exception: procedure(self: PCefRenderProcessHandler;
      worker_id: Integer; const url: PCefString; context: PCefv8Context;
        exception: PCefV8Exception; stackTrace: PCefV8StackTrace); cdecl;

    // Called when a new node in the the browser gets focus. The |node| value may
    // be NULL if no specific node has gained focus. The node object passed to
    // this function represents a snapshot of the DOM at the time this function is
    // executed. DOM objects are only valid for the scope of this function. Do not
    // keep references to or attempt to access any DOM objects outside the scope
    // of this function.
    on_focused_node_changed: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; node: PCefDomNode); cdecl;

    // Called when a new message is received from a different process. Return true
    // (1) if the message was handled or false (0) otherwise. Do not keep a
    // reference to or attempt to access the message outside of this callback.
    on_process_message_received: function(self: PCefRenderProcessHandler;
      browser: PCefBrowser; source_process: TCefProcessId;
      message: PCefProcessMessage): Integer; cdecl;
  end;

  // Implement this structure to provide handler implementations. Methods will be
  // called by the process and/or thread indicated.
  TCefApp = record
    // Base structure.
    base: TCefBase;

    // Provides an opportunity to view and/or modify command-line arguments before
    // processing by CEF and Chromium. The |process_type| value will be NULL for
    // the browser process. Do not keep a reference to the cef_command_line_t
    // object passed to this function. The CefSettings.command_line_args_disabled
    // value can be used to start with an NULL command-line object. Any values
    // specified in CefSettings that equate to command-line arguments will be set
    // before this function is called. Be cautious when using this function to
    // modify command-line arguments for non-browser processes as this may result
    // in undefined behavior including crashes.
    on_before_command_line_processing: procedure(self: PCefApp; const process_type: PCefString;
      command_line: PCefCommandLine); cdecl;

    // Provides an opportunity to register custom schemes. Do not keep a reference
    // to the |registrar| object. This function is called on the main thread for
    // each process and the registered schemes should be the same across all
    // processes.
    on_register_custom_schemes: procedure(self: PCefApp; registrar: PCefSchemeRegistrar); cdecl;

    // Return the handler for resource bundle events. If
    // CefSettings.pack_loading_disabled is true (1) a handler must be returned.
    // If no handler is returned resources will be loaded from pack files. This
    // function is called by the browser and render processes on multiple threads.
    get_resource_bundle_handler: function(self: PCefApp): PCefResourceBundleHandler; cdecl;

    // Return the handler for functionality specific to the browser process. This
    // function is called on multiple threads in the browser process.
    get_browser_process_handler: function(self: PCefApp): PCefBrowserProcessHandler; cdecl;

    // Return the handler for functionality specific to the render process. This
    // function is called on the render process main thread.
    get_render_process_handler: function(self: PCefApp): PCefRenderProcessHandler; cdecl;
  end;

  // Implement this structure to handle events related to browser life span. The
  // functions of this structure will be called on the UI thread unless otherwise
  // indicated.
  TCefLifeSpanHandler = record
    // Base structure.
    base: TCefBase;

    // Called on the IO thread before a new popup window is created. The |browser|
    // and |frame| parameters represent the source of the popup request. The
    // |target_url| and |target_frame_name| values may be NULL if none were
    // specified with the request. The |popupFeatures| structure contains
    // information about the requested popup window. To allow creation of the
    // popup window optionally modify |windowInfo|, |client|, |settings| and
    // |no_javascript_access| and return false (0). To cancel creation of the
    // popup window return true (1). The |client| and |settings| values will
    // default to the source browser's values. The |no_javascript_access| value
    // indicates whether the new browser window should be scriptable and in the
    // same process as the source browser.

    on_before_popup: function(self: PCefLifeSpanHandler;
      browser: PCefBrowser; frame: PCefFrame;
      const target_url, target_frame_name: PCefString;
      const popupFeatures: PCefPopupFeatures;
      windowInfo: PCefWindowInfo; var client: PCefClient;
      settings: PCefBrowserSettings; no_javascript_access: PInteger): Integer; cdecl;

    // Called after a new window is created.
    on_after_created: procedure(self: PCefLifeSpanHandler; browser: PCefBrowser); cdecl;

    // Called when a modal window is about to display and the modal loop should
    // begin running. Return false (0) to use the default modal loop
    // implementation or true (1) to use a custom implementation.
    run_modal: function(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cdecl;

    // Called when a window has recieved a request to close. Return false (0) to
    // proceed with the window close or true (1) to cancel the window close. If
    // this is a modal window and a custom modal loop implementation was provided
    // in run_modal() this callback should be used to restore the opener window to
    // a usable state.
    do_close: function(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cdecl;

    // Called just before a window is closed. If this is a modal window and a
    // custom modal loop implementation was provided in run_modal() this callback
    // should be used to exit the custom modal loop.
    on_before_close: procedure(self: PCefLifeSpanHandler; browser: PCefBrowser); cdecl;
  end;

  // Implement this structure to handle events related to browser load status. The
  // functions of this structure will be called on the UI thread.
  TCefLoadHandler = record
    // Base structure.
    base: TCefBase;

    // Called when the browser begins loading a frame. The |frame| value will
    // never be NULL -- call the is_main() function to check if this frame is the
    // main frame. Multiple frames may be loading at the same time. Sub-frames may
    // start or continue loading after the main frame load has ended. This
    // function may not be called for a particular frame if the load request for
    // that frame fails.
    on_load_start: procedure(self: PCefLoadHandler;
      browser: PCefBrowser; frame: PCefFrame); cdecl;

    // Called when the browser is done loading a frame. The |frame| value will
    // never be NULL -- call the is_main() function to check if this frame is the
    // main frame. Multiple frames may be loading at the same time. Sub-frames may
    // start or continue loading after the main frame load has ended. This
    // function will always be called for all frames irrespective of whether the
    // request completes successfully.
    on_load_end: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; httpStatusCode: Integer); cdecl;

    // Called when the browser fails to load a resource. |errorCode| is the error
    // code number, |errorText| is the error text and and |failedUrl| is the URL
    // that failed to load. See net\base\net_error_list.h for complete
    // descriptions of the error codes.
    on_load_error: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; errorCode: Integer; const errorText, failedUrl: PCefString); cdecl;

    // Called when the render process terminates unexpectedly. |status| indicates
    // how the process terminated.
    on_render_process_terminated: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      status: TCefTerminationStatus); cdecl;

    // Called when a plugin has crashed. |plugin_path| is the path of the plugin
    // that crashed.
    on_plugin_crashed: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      const plugin_path: PCefString); cdecl;
  end;

  // Generic callback structure used for asynchronous continuation.
  TCefCallback = record
    // Base structure.
    base: TCefBase;

    // Continue processing.
    cont: procedure(self: PCefCallback); cdecl;

    // Cancel processing.
    cancel: procedure(self: PCefCallback); cdecl;
  end;

  // Structure used to implement a custom request handler structure. The functions
  // of this structure will always be called on the IO thread.
  TCefResourceHandler = record
    // Base structure.
    base: TCefBase;

    // Begin processing the request. To handle the request return true (1) and
    // call cef_callback_t::cont() once the response header information is
    // available (cef_callback_t::cont() can also be called from inside this
    // function if header information is available immediately). To cancel the
    // request return false (0).
    process_request: function(self: PCefResourceHandler;
      request: PCefRequest; callback: PCefCallback): Integer; cdecl;

    // Retrieve response header information. If the response length is not known
    // set |response_length| to -1 and read_response() will be called until it
    // returns false (0). If the response length is known set |response_length| to
    // a positive value and read_response() will be called until it returns false
    // (0) or the specified number of bytes have been read. Use the |response|
    // object to set the mime type, http status code and other optional header
    // values. To redirect the request to a new URL set |redirectUrl| to the new
    // URL.
    get_response_headers: procedure(self: PCefResourceHandler;
      response: PCefResponse; response_length: PInt64; redirectUrl: PCefString); cdecl;

    // Read response data. If data is available immediately copy up to
    // |bytes_to_read| bytes into |data_out|, set |bytes_read| to the number of
    // bytes copied, and return true (1). To read the data at a later time set
    // |bytes_read| to 0, return true (1) and call cef_callback_t::cont() when the
    // data is available. To indicate response completion return false (0).
    read_response: function(self: PCefResourceHandler;
      data_out: Pointer; bytes_to_read: Integer; bytes_read: PInteger;
        callback: PCefCallback): Integer; cdecl;

    // Return true (1) if the specified cookie can be sent with the request or
    // false (0) otherwise. If false (0) is returned for any cookie then no
    // cookies will be sent with the request.
    can_get_cookie: function(self: PCefResourceHandler;
      const cookie: PCefCookie): Integer; cdecl;

    // Return true (1) if the specified cookie returned with the response can be
    // set or false (0) otherwise.
    can_set_cookie: function(self: PCefResourceHandler;
      const cookie: PCefCookie): Integer; cdecl;

    // Request processing has been canceled.
    cancel: procedure(self: PCefResourceHandler); cdecl;
  end;

  // Callback structure used for asynchronous continuation of authentication
  // requests.
  TCefAuthCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the authentication request.
    cont: procedure(self: PCefAuthCallback;
        const username, password: PCefString); cdecl;

    // Cancel the authentication request.
    cancel: procedure(self: PCefAuthCallback); cdecl;
  end;

  // Callback structure used for asynchronous continuation of quota requests.
  TCefQuotaCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the quota request. If |allow| is true (1) the request will be
    // allowed. Otherwise, the request will be denied.
    cont: procedure(self: PCefQuotaCallback; allow: Integer); cdecl;
    // Cancel the quota request.
    cancel: procedure(self: PCefQuotaCallback); cdecl;
  end;

  // Implement this structure to handle events related to browser requests. The
  // functions of this structure will be called on the thread indicated.
  TCefRequestHandler = record
    // Base structure.
    base: TCefBase;

    // Called on the IO thread before a resource request is loaded. The |request|
    // object may be modified. To cancel the request return true (1) otherwise
    // return false (0).
    on_before_resource_load: function(self: PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; request: PCefRequest): Integer; cdecl;

    // Called on the IO thread before a resource is loaded. To allow the resource
    // to load normally return NULL. To specify a handler for the resource return
    // a cef_resource_handler_t object. The |request| object should not be
    // modified in this callback.
    get_resource_handler: function(self: PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; request: PCefRequest): PCefResourceHandler; cdecl;

    // Called on the IO thread when a resource load is redirected. The |old_url|
    // parameter will contain the old URL. The |new_url| parameter will contain
    // the new URL and can be changed if desired.
    on_resource_redirect: procedure(self: PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; const old_url: PCefString;
      new_url: PCefString); cdecl;

    // Called on the IO thread when the browser needs credentials from the user.
    // |isProxy| indicates whether the host is a proxy server. |host| contains the
    // hostname and |port| contains the port number. Return true (1) to continue
    // the request and call cef_auth_callback_t::cont() when the authentication
    // information is available. Return false (0) to cancel the request.
    get_auth_credentials: function(self: PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; isProxy: Integer; const host: PCefString;
      port: Integer; const realm, scheme: PCefString; callback: PCefAuthCallback): Integer; cdecl;

    // Called on the IO thread when JavaScript requests a specific storage quota
    // size via the webkitStorageInfo.requestQuota function. |origin_url| is the
    // origin of the page making the request. |new_size| is the requested quota
    // size in bytes. Return true (1) and call cef_quota_callback_t::cont() either
    // in this function or at a later time to grant or deny the request. Return
    // false (0) to cancel the request.
    on_quota_request: function(self: PCefRequestHandler; browser: PCefBrowser;
      const origin_url: PCefString; new_size: Int64; callback: PCefQuotaCallback): Integer; cdecl;

    // Called on the IO thread to retrieve the cookie manager. |main_url| is the
    // URL of the top-level frame. Cookies managers can be unique per browser or
    // shared across multiple browsers. The global cookie manager will be used if
    // this function returns NULL.
    get_cookie_manager: function(self: PCefRequestHandler;
      browser: PCefBrowser; const main_url: PCefString): PCefCookieManager; cdecl;

    // Called on the UI thread to handle requests for URLs with an unknown
    // protocol component. Set |allow_os_execution| to true (1) to attempt
    // execution via the registered OS protocol handler, if any. SECURITY WARNING:
    // YOU SHOULD USE THIS METHOD TO ENFORCE RESTRICTIONS BASED ON SCHEME, HOST OR
    // OTHER URL ANALYSIS BEFORE ALLOWING OS EXECUTION.
    on_protocol_execution: procedure(self: PCefRequestHandler;
      browser: PCefBrowser; const url: PCefString; allow_os_execution: PInteger); cdecl;

    // Called on the browser process IO thread before a plugin is loaded. Return
    // true (1) to block loading of the plugin.
    on_before_plugin_load: function(self: PCefRequestHandler; browser: PCefBrowser;
      const url, policy_url: PCefString; info: PCefWebPluginInfo): Integer; cdecl;
  end;


  // Implement this structure to handle events related to browser display state.
  // The functions of this structure will be called on the UI thread.
  TCefDisplayHandler = record
    // Base structure.
    base: TCefBase;

    // Called when the loading state has changed.
    on_loading_state_change: procedure(self: PCefDisplayHandler;
      browser: PCefBrowser; isLoading, canGoBack, canGoForward: Integer); cdecl;

    // Called when a frame's address has changed.
    on_address_change: procedure(self: PCefDisplayHandler;
      browser: PCefBrowser; frame: PCefFrame; const url: PCefString); cdecl;

    // Called when the page title changes.
    on_title_change: procedure(self: PCefDisplayHandler;
        browser: PCefBrowser; const title: PCefString); cdecl;

    // Called when the browser is about to display a tooltip. |text| contains the
    // text that will be displayed in the tooltip. To handle the display of the
    // tooltip yourself return true (1). Otherwise, you can optionally modify
    // |text| and then return false (0) to allow the browser to display the
    // tooltip. When window rendering is disabled the application is responsible
    // for drawing tooltips and the return value is ignored.
    on_tooltip: function(self: PCefDisplayHandler;
        browser: PCefBrowser; text: PCefString): Integer; cdecl;

    // Called when the browser receives a status message. |text| contains the text
    // that will be displayed in the status message.
    on_status_message: procedure(self: PCefDisplayHandler;
        browser: PCefBrowser; const value: PCefString); cdecl;

    // Called to display a console message. Return true (1) to stop the message
    // from being output to the console.
    on_console_message: function(self: PCefDisplayHandler;
        browser: PCefBrowser; const message: PCefString;
        const source: PCefString; line: Integer): Integer; cdecl;
  end;

  // Implement this structure to handle events related to focus. The functions of
  // this structure will be called on the UI thread.
  TCefFocusHandler = record
    // Base structure.
    base: TCefBase;

    // Called when the browser component is about to loose focus. For instance, if
    // focus was on the last HTML element and the user pressed the TAB key. |next|
    // will be true (1) if the browser is giving focus to the next component and
    // false (0) if the browser is giving focus to the previous component.
    on_take_focus: procedure(self: PCefFocusHandler;
        browser: PCefBrowser; next: Integer); cdecl;

    // Called when the browser component is requesting focus. |source| indicates
    // where the focus request is originating from. Return false (0) to allow the
    // focus to be set or true (1) to cancel setting the focus.
    on_set_focus: function(self: PCefFocusHandler;
        browser: PCefBrowser; source: TCefFocusSource): Integer; cdecl;

    // Called when the browser component has received focus.
    on_got_focus: procedure(self: PCefFocusHandler; browser: PCefBrowser); cdecl;
  end;

  // Implement this structure to handle events related to keyboard input. The
  // functions of this structure will be called on the UI thread.
  TCefKeyboardHandler = record
    // Base structure.
    base: TCefBase;

    // Called before a keyboard event is sent to the renderer. |event| contains
    // information about the keyboard event. |os_event| is the operating system
    // event message, if any. Return true (1) if the event was handled or false
    // (0) otherwise. If the event will be handled in on_key_event() as a keyboard
    // shortcut set |is_keyboard_shortcut| to true (1) and return false (0).
    on_pre_key_event: function(self: PCefKeyboardHandler;
      browser: PCefBrowser; const event: PCefKeyEvent;
      os_event: TCefEventHandle; is_keyboard_shortcut: PInteger): Integer; cdecl;

    // Called after the renderer and JavaScript in the page has had a chance to
    // handle the event. |event| contains information about the keyboard event.
    // |os_event| is the operating system event message, if any. Return true (1)
    // if the keyboard event was handled or false (0) otherwise.
    on_key_event: function(self: PCefKeyboardHandler;
        browser: PCefBrowser; const event: PCefKeyEvent;
        os_event: TCefEventHandle): Integer; cdecl;
  end;

  // Callback structure used for asynchronous continuation of JavaScript dialog
  // requests.
  TCefJsDialogCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the JS dialog request. Set |success| to true (1) if the OK button
    // was pressed. The |user_input| value should be specified for prompt dialogs.
    cont: procedure(self: PCefJsDialogCallback; success: Integer; const user_input: PCefString); cdecl;
  end;

  // Implement this structure to handle events related to JavaScript dialogs. The
  // functions of this structure will be called on the UI thread.
  TCefJsDialogHandler = record
    // Base structure.
    base: TCefBase;

    // Called to run a JavaScript dialog. The |default_prompt_text| value will be
    // specified for prompt dialogs only. Set |suppress_message| to true (1) and
    // return false (0) to suppress the message (suppressing messages is
    // preferable to immediately executing the callback as this is used to detect
    // presumably malicious behavior like spamming alert messages in
    // onbeforeunload). Set |suppress_message| to false (0) and return false (0)
    // to use the default implementation (the default implementation will show one
    // modal dialog at a time and suppress any additional dialog requests until
    // the displayed dialog is dismissed). Return true (1) if the application will
    // use a custom dialog or if the callback has been executed immediately.
    // Custom dialogs may be either modal or modeless. If a custom dialog is used
    // the application must execute |callback| once the custom dialog is
    // dismissed.
    on_jsdialog: function(self: PCefJsDialogHandler;
      browser: PCefBrowser; const origin_url, accept_lang: PCefString;
      dialog_type: TCefJsDialogType; const message_text, default_prompt_text: PCefString;
      callback: PCefJsDialogCallback; suppress_message: PInteger): Integer; cdecl;

    // Called to run a dialog asking the user if they want to leave a page. Return
    // false (0) to use the default dialog implementation. Return true (1) if the
    // application will use a custom dialog or if the callback has been executed
    // immediately. Custom dialogs may be either modal or modeless. If a custom
    // dialog is used the application must execute |callback| once the custom
    // dialog is dismissed.
    on_before_unload_dialog: function(self: PCefJsDialogHandler;
      browser: PCefBrowser; const message_text: PCefString; is_reload: Integer;
      callback: PCefJsDialogCallback): Integer; cdecl;

    // Called to cancel any pending dialogs and reset any saved dialog state. Will
    // be called due to events like page navigation irregardless of whether any
    // dialogs are currently pending.
    on_reset_dialog_state: procedure(self: PCefJsDialogHandler; browser: PCefBrowser); cdecl;
  end;

  // Supports creation and modification of menus. See cef_menu_id_t for the
  // command ids that have default implementations. All user-defined command ids
  // should be between MENU_ID_USER_FIRST and MENU_ID_USER_LAST. The functions of
  // this structure can only be accessed on the browser process the UI thread.
  TCefMenuModel = record
    // Base structure.
    base: TCefBase;

    // Clears the menu. Returns true (1) on success.
    clear: function(self: PCefMenuModel): Integer; cdecl;

    // Returns the number of items in this menu.
    get_count: function(self: PCefMenuModel): Integer; cdecl;

    // Add a separator to the menu. Returns true (1) on success.
    add_separator: function(self: PCefMenuModel): Integer; cdecl;

    // Add an item to the menu. Returns true (1) on success.
    add_item: function(self: PCefMenuModel; command_id: Integer;
      const text: PCefString): Integer; cdecl;

    // Add a check item to the menu. Returns true (1) on success.
    add_check_item: function(self: PCefMenuModel; command_id: Integer;
      const text: PCefString): Integer; cdecl;

    // Add a radio item to the menu. Only a single item with the specified
    // |group_id| can be checked at a time. Returns true (1) on success.
    add_radio_item: function(self: PCefMenuModel; command_id: Integer;
      const text: PCefString; group_id: Integer): Integer; cdecl;

    // Add a sub-menu to the menu. The new sub-menu is returned.
    add_sub_menu: function(self: PCefMenuModel; command_id: Integer;
      const text: PCefString): PCefMenuModel; cdecl;

    // Insert a separator in the menu at the specified |index|. Returns true (1)
    // on success.
    insert_separator_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Insert an item in the menu at the specified |index|. Returns true (1) on
    // success.
    insert_item_at: function(self: PCefMenuModel; index, command_id: Integer;
      const text: PCefString): Integer; cdecl;

    // Insert a check item in the menu at the specified |index|. Returns true (1)
    // on success.
    insert_check_item_at: function(self: PCefMenuModel; index, command_id: Integer;
      const text: PCefString): Integer; cdecl;

    // Insert a radio item in the menu at the specified |index|. Only a single
    // item with the specified |group_id| can be checked at a time. Returns true
    // (1) on success.
    insert_radio_item_at: function(self: PCefMenuModel; index, command_id: Integer;
      const text: PCefString; group_id: Integer): Integer; cdecl;

    // Insert a sub-menu in the menu at the specified |index|. The new sub-menu is
    // returned.
    insert_sub_menu_at: function(self: PCefMenuModel; index, command_id: Integer;
      const text: PCefString): PCefMenuModel; cdecl;

    // Removes the item with the specified |command_id|. Returns true (1) on
    // success.
    remove: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Removes the item at the specified |index|. Returns true (1) on success.
    remove_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Returns the index associated with the specified |command_id| or -1 if not
    // found due to the command id not existing in the menu.
    get_index_of: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Returns the command id at the specified |index| or -1 if not found due to
    // invalid range or the index being a separator.
    get_command_id_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Sets the command id at the specified |index|. Returns true (1) on success.
    set_command_id_at: function(self: PCefMenuModel; index, command_id: Integer): Integer; cdecl;

    // Returns the label for the specified |command_id| or NULL if not found.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_label: function(self: PCefMenuModel; command_id: Integer): PCefStringUserFree; cdecl;

    // Returns the label at the specified |index| or NULL if not found due to
    // invalid range or the index being a separator.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_label_at: function(self: PCefMenuModel; index: Integer): PCefStringUserFree; cdecl;

    // Sets the label for the specified |command_id|. Returns true (1) on success.
    set_label: function(self: PCefMenuModel; command_id: Integer;
      const text: PCefString): Integer; cdecl;

    // Set the label at the specified |index|. Returns true (1) on success.
    set_label_at: function(self: PCefMenuModel; index: Integer;
      const text: PCefString): Integer; cdecl;

    // Returns the item type for the specified |command_id|.
    get_type: function(self: PCefMenuModel; command_id: Integer): TCefMenuItemType; cdecl;

    // Returns the item type at the specified |index|.
    get_type_at: function(self: PCefMenuModel; index: Integer): TCefMenuItemType; cdecl;

    // Returns the group id for the specified |command_id| or -1 if invalid.
    get_group_id: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Returns the group id at the specified |index| or -1 if invalid.
    get_group_id_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Sets the group id for the specified |command_id|. Returns true (1) on
    // success.
    set_group_id: function(self: PCefMenuModel; command_id, group_id: Integer): Integer; cdecl;

    // Sets the group id at the specified |index|. Returns true (1) on success.
    set_group_id_at: function(self: PCefMenuModel; index, group_id: Integer): Integer; cdecl;

    // Returns the submenu for the specified |command_id| or NULL if invalid.
    get_sub_menu: function(self: PCefMenuModel; command_id: Integer): PCefMenuModel; cdecl;

    // Returns the submenu at the specified |index| or NULL if invalid.
    get_sub_menu_at: function(self: PCefMenuModel; index: Integer): PCefMenuModel; cdecl;

    // Returns true (1) if the specified |command_id| is visible.
    is_visible: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Returns true (1) if the specified |index| is visible.
    is_visible_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Change the visibility of the specified |command_id|. Returns true (1) on
    // success.
    set_visible: function(self: PCefMenuModel; command_id, visible: Integer): Integer; cdecl;

    // Change the visibility at the specified |index|. Returns true (1) on
    // success.
    set_visible_at: function(self: PCefMenuModel; index, visible: Integer): Integer; cdecl;

    // Returns true (1) if the specified |command_id| is enabled.
    is_enabled: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Returns true (1) if the specified |index| is enabled.
    is_enabled_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Change the enabled status of the specified |command_id|. Returns true (1)
    // on success.
    set_enabled: function(self: PCefMenuModel; command_id, enabled: Integer): Integer; cdecl;

    // Change the enabled status at the specified |index|. Returns true (1) on
    // success.
    set_enabled_at: function(self: PCefMenuModel; index, enabled: Integer): Integer; cdecl;

    // Returns true (1) if the specified |command_id| is checked. Only applies to
    // check and radio items.
    is_checked: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Returns true (1) if the specified |index| is checked. Only applies to check
    // and radio items.
    is_checked_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Check the specified |command_id|. Only applies to check and radio items.
    // Returns true (1) on success.
    set_checked: function(self: PCefMenuModel; command_id, checked: Integer): Integer; cdecl;

    // Check the specified |index|. Only applies to check and radio items. Returns
    // true (1) on success.
    set_checked_at: function(self: PCefMenuModel; index, checked: Integer): Integer; cdecl;

    // Returns true (1) if the specified |command_id| has a keyboard accelerator
    // assigned.
    has_accelerator: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Returns true (1) if the specified |index| has a keyboard accelerator
    // assigned.
    has_accelerator_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Set the keyboard accelerator for the specified |command_id|. |key_code| can
    // be any virtual key or character value. Returns true (1) on success.
    set_accelerator: function(self: PCefMenuModel; command_id, key_code,
      shift_pressed, ctrl_pressed, alt_pressed: Integer): Integer; cdecl;

    // Set the keyboard accelerator at the specified |index|. |key_code| can be
    // any virtual key or character value. Returns true (1) on success.
    set_accelerator_at: function(self: PCefMenuModel; index, key_code,
      shift_pressed, ctrl_pressed, alt_pressed: Integer): Integer; cdecl;

    // Remove the keyboard accelerator for the specified |command_id|. Returns
    // true (1) on success.
    remove_accelerator: function(self: PCefMenuModel; command_id: Integer): Integer; cdecl;

    // Remove the keyboard accelerator at the specified |index|. Returns true (1)
    // on success.
    remove_accelerator_at: function(self: PCefMenuModel; index: Integer): Integer; cdecl;

    // Retrieves the keyboard accelerator for the specified |command_id|. Returns
    // true (1) on success.
    get_accelerator: function(self: PCefMenuModel; command_id: Integer; key_code,
      shift_pressed, ctrl_pressed, alt_pressed: PInteger): Integer; cdecl;

    // Retrieves the keyboard accelerator for the specified |index|. Returns true
    // (1) on success.
    get_accelerator_at: function(self: PCefMenuModel; index: Integer; key_code,
      shift_pressed, ctrl_pressed, alt_pressed: PInteger): Integer; cdecl;
  end;

  // Implement this structure to handle context menu events. The functions of this
  // structure will be called on the UI thread.
  TCefContextMenuHandler = record
    // Base structure.
    base: TCefBase;

    // Called before a context menu is displayed. |params| provides information
    // about the context menu state. |model| initially contains the default
    // context menu. The |model| can be cleared to show no context menu or
    // modified to show a custom menu. Do not keep references to |params| or
    // |model| outside of this callback.
    on_before_context_menu: procedure(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
      model: PCefMenuModel); cdecl;

    // Called to execute a command selected from the context menu. Return true (1)
    // if the command was handled or false (0) for the default implementation. See
    // cef_menu_id_t for the command ids that have default implementations. All
    // user-defined command ids should be between MENU_ID_USER_FIRST and
    // MENU_ID_USER_LAST. |params| will have the same values as what was passed to
    // on_before_context_menu(). Do not keep a reference to |params| outside of
    // this callback.
    on_context_menu_command: function(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
      command_id: Integer; event_flags: Integer): Integer; cdecl;

    // Called when the context menu is dismissed irregardless of whether the menu
    // was NULL or a command was selected.
    on_context_menu_dismissed: procedure(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame); cdecl;
  end;


  // Provides information about the context menu state. The ethods of this
  // structure can only be accessed on browser process the UI thread.
  TCefContextMenuParams = record
    // Base structure.
    base: TCefBase;

    // Returns the X coordinate of the mouse where the context menu was invoked.
    // Coords are relative to the associated RenderView's origin.
    get_xcoord: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns the Y coordinate of the mouse where the context menu was invoked.
    // Coords are relative to the associated RenderView's origin.
    get_ycoord: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns flags representing the type of node that the context menu was
    // invoked on.
    get_type_flags: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns the URL of the link, if any, that encloses the node that the
    // context menu was invoked on.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_link_url: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns the link URL, if any, to be used ONLY for "copy link address". We
    // don't validate this field in the frontend process.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_unfiltered_link_url: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns the source URL, if any, for the element that the context menu was
    // invoked on. Example of elements with source URLs are img, audio, and video.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_source_url: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns true (1) if the context menu was invoked on a blocked image.
    is_image_blocked: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns the URL of the top level page that the context menu was invoked on.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_page_url: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns the URL of the subframe that the context menu was invoked on.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_frame_url: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns the character encoding of the subframe that the context menu was
    // invoked on.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_frame_charset: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns the type of context node that the context menu was invoked on.
    get_media_type: function(self: PCefContextMenuParams): TCefContextMenuMediaType; cdecl;

    // Returns flags representing the actions supported by the media element, if
    // any, that the context menu was invoked on.
    get_media_state_flags: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns the text of the selection, if any, that the context menu was
    // invoked on.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_text: function(self: PCefContextMenuParams): PCefStringUserFree; cdecl;

    // Returns true (1) if the context menu was invoked on an editable node.
    is_editable: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns true (1) if the context menu was invoked on an editable node where
    // speech-input is enabled.
    is_speech_input_enabled: function(self: PCefContextMenuParams): Integer; cdecl;

    // Returns flags representing the actions supported by the editable node, if
    // any, that the context menu was invoked on.
    get_edit_state_flags: function(self: PCefContextMenuParams): Integer; cdecl;
  end;

  // Callback structure used for asynchronous continuation of geolocation
  // permission requests.
  TCefGeolocationCallback = record
    // Base structure.
    base: TCefBase;

    // Call to allow or deny geolocation access.
    cont: procedure(self: PCefGeolocationCallback; allow: Integer); cdecl;
  end;


  // Implement this structure to handle events related to geolocation permission
  // requests. The functions of this structure will be called on the browser
  // process IO thread.
  TCefGeolocationHandler = record
    // Base structure.
    base: TCefBase;

    // Called when a page requests permission to access geolocation information.
    // |requesting_url| is the URL requesting permission and |request_id| is the
    // unique ID for the permission request. Call
    // cef_geolocation_callback_t::Continue to allow or deny the permission
    // request.
    on_request_geolocation_permission: procedure(self: PCefGeolocationHandler;
        browser: PCefBrowser; const requesting_url: PCefString; request_id: Integer;
        callback: PCefGeolocationCallback); cdecl;

    // Called when a geolocation access request is canceled. |requesting_url| is
    // the URL that originally requested permission and |request_id| is the unique
    // ID for the permission request.
    on_cancel_geolocation_permission: procedure(self: PCefGeolocationHandler;
        browser: PCefBrowser; const requesting_url: PCefString; request_id: Integer); cdecl;
  end;

  // Implement this structure to provide handler implementations.
  TCefClient = record
    // Base structure.
    base: TCefBase;

    // Return the handler for context menus. If no handler is provided the default
    // implementation will be used.
    get_context_menu_handler: function(self: PCefClient): PCefContextMenuHandler; cdecl;

    // Return the handler for dialogs. If no handler is provided the default
    // implementation will be used.
    get_dialog_handler: function(self: PCefClient): PCefDialogHandler; cdecl;

    // Return the handler for browser display state events.
    get_display_handler: function(self: PCefClient): PCefDisplayHandler; cdecl;

    // Return the handler for download events. If no handler is returned downloads
    // will not be allowed.
    get_download_handler: function(self: PCefClient): PCefDownloadHandler; cdecl;

    // Return the handler for focus events.
    get_focus_handler: function(self: PCefClient): PCefFocusHandler; cdecl;

    // Return the handler for geolocation permissions requests. If no handler is
    // provided geolocation access will be denied by default.
    get_geolocation_handler: function(self: PCefClient): PCefGeolocationHandler; cdecl;

    // Return the handler for JavaScript dialog events.
    get_jsdialog_handler: function(self: PCefClient): PCefJsDialogHandler; cdecl;

    // Return the handler for keyboard events.
    get_keyboard_handler: function(self: PCefClient): PCefKeyboardHandler; cdecl;

    // Return the handler for browser life span events.
    get_life_span_handler: function(self: PCefClient): PCefLifeSpanHandler; cdecl;

    // Return the handler for browser load status events.
    get_load_handler: function(self: PCefClient): PCefLoadHandler; cdecl;

    // Return the handler for off-screen rendering events.
    get_render_handler: function(self: PCefClient): PCefRenderHandler; cdecl;

    // Return the handler for browser request events.
    get_request_handler: function(self: PCefClient): PCefRequestHandler; cdecl;

    // Called when a new message is received from a different process. Return true
    // (1) if the message was handled or false (0) otherwise. Do not keep a
    // reference to or attempt to access the message outside of this callback.
    on_process_message_received: function(self: PCefClient; browser: PCefBrowser;
      source_process: TCefProcessId; message: PCefProcessMessage): Integer; cdecl;
  end;

  // Structure used to represent a web request. The functions of this structure
  // may be called on any thread.
  TCefRequest = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefRequest): Integer; cdecl;

    // Get the fully qualified URL.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefRequest): PCefStringUserFree; cdecl;
    // Set the fully qualified URL.
    set_url: procedure(self: PCefRequest; const url: PCefString); cdecl;

    // Get the request function type. The value will default to POST if post data
    // is provided and GET otherwise.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_method: function(self: PCefRequest): PCefStringUserFree; cdecl;
    // Set the request function type.
    set_method: procedure(self: PCefRequest; const method: PCefString); cdecl;

    // Get the post data.
    get_post_data: function(self: PCefRequest): PCefPostData; cdecl;
    // Set the post data.
    set_post_data: procedure(self: PCefRequest; postData: PCefPostData); cdecl;

    // Get the header values.
    get_header_map: procedure(self: PCefRequest; headerMap: TCefStringMultimap); cdecl;
    // Set the header values.
    set_header_map: procedure(self: PCefRequest; headerMap: TCefStringMultimap); cdecl;

    // Set all values at one time.
    set_: procedure(self: PCefRequest; const url, method: PCefString;
      postData: PCefPostData; headerMap: TCefStringMultimap); cdecl;

    // Get the flags used in combination with cef_urlrequest_t. See
    // cef_urlrequest_flags_t for supported values.
    get_flags: function(self: PCefRequest): Integer; cdecl;
    // Set the flags used in combination with cef_urlrequest_t.  See
    // cef_urlrequest_flags_t for supported values.
    set_flags: procedure(self: PCefRequest; flags: Integer); cdecl;

    // Get the URL to the first party for cookies used in combination with
    // cef_urlrequest_t.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_first_party_for_cookies: function(self: PCefRequest): PCefStringUserFree; cdecl;
    // Set the URL to the first party for cookies used in combination with
    // cef_urlrequest_t.
    set_first_party_for_cookies: procedure(self: PCefRequest; const url: PCefString); cdecl;
  end;


  TCefPostDataElementArray = array[0..(High(Integer) div SizeOf(PCefPostDataElement)) - 1] of PCefPostDataElement;
  PCefPostDataElementArray = ^TCefPostDataElementArray;

  // Structure used to represent post data for a web request. The functions of
  // this structure may be called on any thread.
  TCefPostData = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefPostData):Integer; cdecl;

    // Returns the number of existing post data elements.
    get_element_count: function(self: PCefPostData): Cardinal; cdecl;

    // Retrieve the post data elements.
    get_elements: procedure(self: PCefPostData; elementsCount: PCardinal;
      elements: PCefPostDataElementArray); cdecl;

    // Remove the specified post data element.  Returns true (1) if the removal
    // succeeds.
    remove_element: function(self: PCefPostData;
      element: PCefPostDataElement): Integer; cdecl;

    // Add the specified post data element.  Returns true (1) if the add succeeds.
    add_element: function(self: PCefPostData;
        element: PCefPostDataElement): Integer; cdecl;

    // Remove all existing post data elements.
    remove_elements: procedure(self: PCefPostData); cdecl;

  end;

  // Structure used to represent a single element in the request post data. The
  // functions of this structure may be called on any thread.
  TCefPostDataElement = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefPostDataElement): Integer; cdecl;

    // Remove all contents from the post data element.
    set_to_empty: procedure(self: PCefPostDataElement); cdecl;

    // The post data element will represent a file.
    set_to_file: procedure(self: PCefPostDataElement;
        const fileName: PCefString); cdecl;

    // The post data element will represent bytes.  The bytes passed in will be
    // copied.
    set_to_bytes: procedure(self: PCefPostDataElement;
        size: Cardinal; const bytes: Pointer); cdecl;

    // Return the type of this post data element.
    get_type: function(self: PCefPostDataElement): TCefPostDataElementType; cdecl;

    // Return the file name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_file: function(self: PCefPostDataElement): PCefStringUserFree; cdecl;

    // Return the number of bytes.
    get_bytes_count: function(self: PCefPostDataElement): Cardinal; cdecl;

    // Read up to |size| bytes into |bytes| and return the number of bytes
    // actually read.
    get_bytes: function(self: PCefPostDataElement;
        size: Cardinal; bytes: Pointer): Cardinal; cdecl;
  end;

  // Structure used to represent a web response. The functions of this structure
  // may be called on any thread.
  TCefResponse = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefResponse): Integer; cdecl;

    // Get the response status code.
    get_status: function(self: PCefResponse): Integer; cdecl;
    // Set the response status code.
    set_status: procedure(self: PCefResponse; status: Integer); cdecl;

    // Get the response status text.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_status_text: function(self: PCefResponse): PCefStringUserFree; cdecl;
    // Set the response status text.
    set_status_text: procedure(self: PCefResponse; const statusText: PCefString); cdecl;

    // Get the response mime type.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_mime_type: function(self: PCefResponse): PCefStringUserFree; cdecl;
    // Set the response mime type.
    set_mime_type: procedure(self: PCefResponse; const mimeType: PCefString); cdecl;

    // Get the value for the specified response header field.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_header: function(self: PCefResponse; const name: PCefString): PCefStringUserFree; cdecl;

    // Get all response header fields.
    get_header_map: procedure(self: PCefResponse; headerMap: TCefStringMultimap); cdecl;
    // Set all response header fields.
    set_header_map: procedure(self: PCefResponse; headerMap: TCefStringMultimap); cdecl;
  end;

  // Structure the client can implement to provide a custom stream reader. The
  // functions of this structure may be called on any thread.
  TCefReadHandler = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefReadHandler; ptr: Pointer;
      size, n: Cardinal): Cardinal; cdecl;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Return zero on success and non-zero on failure.
    seek: function(self: PCefReadHandler; offset: Int64;
      whence: Integer): Integer; cdecl;

    // Return the current offset position.
    tell: function(self: PCefReadHandler): Int64; cdecl;

    // Return non-zero if at end of file.
    eof: function(self: PCefReadHandler): Integer; cdecl;
  end;

  // Structure used to read data from a stream. The functions of this structure
  // may be called on any thread.
  TCefStreamReader = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefStreamReader; ptr: Pointer;
        size, n: Cardinal): Cardinal; cdecl;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamReader; offset: Int64;
        whence: Integer): Integer; cdecl;

    // Return the current offset position.
    tell: function(self: PCefStreamReader): Int64; cdecl;

    // Return non-zero if at end of file.
    eof: function(self: PCefStreamReader): Integer; cdecl;
  end;

  // Structure the client can implement to provide a custom stream writer. The
  // functions of this structure may be called on any thread.
  TCefWriteHandler = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefWriteHandler;
        const ptr: Pointer; size, n: Cardinal): Cardinal; cdecl;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefWriteHandler; offset: Int64;
        whence: Integer): Integer; cdecl;

    // Return the current offset position.
    tell: function(self: PCefWriteHandler): Int64; cdecl;

    // Flush the stream.
    flush: function(self: PCefWriteHandler): Integer; cdecl;
  end;

  // Structure used to write data to a stream. The functions of this structure may
  // be called on any thread.
  TCefStreamWriter = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefStreamWriter;
        const ptr: Pointer; size, n: Cardinal): Cardinal; cdecl;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefStreamWriter; offset: Int64;
        whence: Integer): Integer; cdecl;

    // Return the current offset position.
    tell: function(self: PCefStreamWriter): Int64; cdecl;

    // Flush the stream.
    flush: function(self: PCefStreamWriter): Integer; cdecl;
  end;

  // Structure representing a V8 context handle. V8 handles can only be accessed
  // from the thread on which they are created. Valid threads for creating a V8
  // handle include the render process main thread (TID_RENDERER) and WebWorker
  // threads. A task runner for posting tasks on the associated thread can be
  // retrieved via the cef_v8context_t::get_task_runner() function.
  TCefV8Context = record
    // Base structure.
    base: TCefBase;

    // Returns the task runner associated with this context. V8 handles can only
    // be accessed from the thread on which they are created. This function can be
    // called on any render process thread.
    get_task_runner: function(self: PCefv8Context): PCefTask; cdecl;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefv8Context): Integer; cdecl;

    // Returns the browser for this context. This function will return an NULL
    // reference for WebWorker contexts.
    get_browser: function(self: PCefv8Context): PCefBrowser; cdecl;

    // Returns the frame for this context. This function will return an NULL
    // reference for WebWorker contexts.
    get_frame: function(self: PCefv8Context): PCefFrame; cdecl;

    // Returns the global object for this context. The context must be entered
    // before calling this function.
    get_global: function(self: PCefv8Context): PCefv8Value; cdecl;

    // Enter this context. A context must be explicitly entered before creating a
    // V8 Object, Array, Function or Date asynchronously. exit() must be called
    // the same number of times as enter() before releasing this context. V8
    // objects belong to the context in which they are created. Returns true (1)
    // if the scope was entered successfully.
    enter: function(self: PCefv8Context): Integer; cdecl;

    // Exit this context. Call this function only after calling enter(). Returns
    // true (1) if the scope was exited successfully.
    exit: function(self: PCefv8Context): Integer; cdecl;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefv8Context): Integer; cdecl;

    // Evaluates the specified JavaScript code using this context's global object.
    // On success |retval| will be set to the return value, if any, and the
    // function will return true (1). On failure |exception| will be set to the
    // exception, if any, and the function will return false (0).
    eval: function(self: PCefv8Context; const code: PCefString;
      var retval: PCefv8Value; var exception: PCefV8Exception): Integer; cdecl;
  end;

  // Structure that should be implemented to handle V8 function calls. The
  // functions of this structure will be called on the thread associated with the
  // V8 function.
  TCefv8Handler = record
    // Base structure.
    base: TCefBase;

    // Handle execution of the function identified by |name|. |object| is the
    // receiver ('this' object) of the function. |arguments| is the list of
    // arguments passed to the function. If execution succeeds set |retval| to the
    // function return value. If execution fails set |exception| to the exception
    // that will be thrown. Return true (1) if execution was handled.
    execute: function(self: PCefv8Handler;
        const name: PCefString; obj: PCefv8Value; argumentsCount: Cardinal;
        const arguments: PPCefV8Value; var retval: PCefV8Value;
        var exception: TCefString): Integer; cdecl;
  end;

  // Structure that should be implemented to handle V8 accessor calls. Accessor
  // identifiers are registered by calling cef_v8value_t::set_value_byaccessor().
  // The functions of this structure will be called on the thread associated with
  // the V8 accessor.
  TCefV8Accessor = record
    // Base structure.
    base: TCefBase;

    // Handle retrieval the accessor value identified by |name|. |object| is the
    // receiver ('this' object) of the accessor. If retrieval succeeds set
    // |retval| to the return value. If retrieval fails set |exception| to the
    // exception that will be thrown. Return true (1) if accessor retrieval was
    // handled.
    get: function(self: PCefV8Accessor; const name: PCefString;
      obj: PCefv8Value; out retval: PCefv8Value; exception: PCefString): Integer; cdecl;

    // Handle assignment of the accessor value identified by |name|. |object| is
    // the receiver ('this' object) of the accessor. |value| is the new value
    // being assigned to the accessor. If assignment fails set |exception| to the
    // exception that will be thrown. Return true (1) if accessor assignment was
    // handled.
    put: function(self: PCefV8Accessor; const name: PCefString;
      obj: PCefv8Value; value: PCefv8Value; exception: PCefString): Integer; cdecl;
  end;

  // Structure representing a V8 exception. The functions of this structure may be
  // called on any render process thread.
  TCefV8Exception = record
    // Base structure.
    base: TCefBase;

    // Returns the exception message.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_message: function(self: PCefV8Exception): PCefStringUserFree; cdecl;

    // Returns the line of source code that the exception occurred within.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_source_line: function(self: PCefV8Exception): PCefStringUserFree; cdecl;

    // Returns the resource name for the script from where the function causing
    // the error originates.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_script_resource_name: function(self: PCefV8Exception): PCefStringUserFree; cdecl;

    // Returns the 1-based number of the line where the error occurred or 0 if the
    // line number is unknown.
    get_line_number: function(self: PCefV8Exception): Integer; cdecl;

    // Returns the index within the script of the first character where the error
    // occurred.
    get_start_position: function(self: PCefV8Exception): Integer; cdecl;

    // Returns the index within the script of the last character where the error
    // occurred.
    get_end_position: function(self: PCefV8Exception): Integer; cdecl;

    // Returns the index within the line of the first character where the error
    // occurred.
    get_start_column: function(self: PCefV8Exception): Integer; cdecl;

    // Returns the index within the line of the last character where the error
    // occurred.
    get_end_column: function(self: PCefV8Exception): Integer; cdecl;
  end;

  // Structure representing a V8 value handle. V8 handles can only be accessed
  // from the thread on which they are created. Valid threads for creating a V8
  // handle include the render process main thread (TID_RENDERER) and WebWorker
  // threads. A task runner for posting tasks on the associated thread can be
  // retrieved via the cef_v8context_t::get_task_runner() function.
  TCefv8Value = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is undefined.
    is_undefined: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is null.
    is_null: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is bool.
    is_bool: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is int.
    is_int: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is unsigned int.
    is_uint: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is double.
    is_double: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is Date.
    is_date: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is string.
    is_string: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is object.
    is_object: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is array.
    is_array: function(self: PCefv8Value): Integer; cdecl;
    // True if the value type is function.
    is_function: function(self: PCefv8Value): Integer; cdecl;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefv8Value): Integer; cdecl;

    // Return a bool value.  The underlying data will be converted to if
    // necessary.
    get_bool_value: function(self: PCefv8Value): Integer; cdecl;
    // Return an int value.  The underlying data will be converted to if
    // necessary.
    get_int_value: function(self: PCefv8Value): Integer; cdecl;
    // Return an unisgned int value.  The underlying data will be converted to if
    // necessary.
    get_uint_value: function(self: PCefv8Value): Cardinal; cdecl;
    // Return a double value.  The underlying data will be converted to if
    // necessary.
    get_double_value: function(self: PCefv8Value): double; cdecl;
    // Return a Date value.  The underlying data will be converted to if
    // necessary.
    get_date_value: function(self: PCefv8Value): TCefTime; cdecl;
    // Return a string value.  The underlying data will be converted to if
    // necessary.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string_value: function(self: PCefv8Value): PCefStringUserFree; cdecl;


    // OBJECT METHODS - These functions are only available on objects. Arrays and
    // functions are also objects. String- and integer-based keys can be used
    // interchangably with the framework converting between them as necessary.

    // Returns true (1) if this is a user created object.
    is_user_created: function(self: PCefv8Value): Integer; cdecl;

    // Returns true (1) if the last function call resulted in an exception. This
    // attribute exists only in the scope of the current CEF value object.
    has_exception: function(self: PCefv8Value): Integer; cdecl;

    // Returns the exception resulting from the last function call. This attribute
    // exists only in the scope of the current CEF value object.
    get_exception: function(self: PCefv8Value): PCefV8Exception; cdecl;

    // Clears the last exception and returns true (1) on success.
    clear_exception: function(self: PCefv8Value): Integer; cdecl;

    // Returns true (1) if this object will re-throw future exceptions. This
    // attribute exists only in the scope of the current CEF value object.
    will_rethrow_exceptions: function(self: PCefv8Value): Integer; cdecl;

    // Set whether this object will re-throw future exceptions. By default
    // exceptions are not re-thrown. If a exception is re-thrown the current
    // context should not be accessed again until after the exception has been
    // caught and not re-thrown. Returns true (1) on success. This attribute
    // exists only in the scope of the current CEF value object.
    set_rethrow_exceptions: function(self: PCefv8Value; rethrow: Integer): Integer; cdecl;


    // Returns true (1) if the object has a value with the specified identifier.
    has_value_bykey: function(self: PCefv8Value; const key: PCefString): Integer; cdecl;
    // Returns true (1) if the object has a value with the specified identifier.
    has_value_byindex: function(self: PCefv8Value; index: Integer): Integer; cdecl;

    // Deletes the value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly or an
    // exception is thrown. For read-only and don't-delete values this function
    // will return true (1) even though deletion failed.
    delete_value_bykey: function(self: PCefv8Value; const key: PCefString): Integer; cdecl;
    // Deletes the value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly, deletion
    // fails or an exception is thrown. For read-only and don't-delete values this
    // function will return true (1) even though deletion failed.
    delete_value_byindex: function(self: PCefv8Value; index: Integer): Integer; cdecl;

    // Returns the value with the specified identifier on success. Returns NULL if
    // this function is called incorrectly or an exception is thrown.
    get_value_bykey: function(self: PCefv8Value; const key: PCefString): PCefv8Value; cdecl;
    // Returns the value with the specified identifier on success. Returns NULL if
    // this function is called incorrectly or an exception is thrown.
    get_value_byindex: function(self: PCefv8Value; index: Integer): PCefv8Value; cdecl;

    // Associates a value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly or an
    // exception is thrown. For read-only values this function will return true
    // (1) even though assignment failed.
    set_value_bykey: function(self: PCefv8Value; const key: PCefString;
      value: PCefv8Value; attribute: Integer): Integer; cdecl;
    // Associates a value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly or an
    // exception is thrown. For read-only values this function will return true
    // (1) even though assignment failed.
    set_value_byindex: function(self: PCefv8Value; index: Integer;
       value: PCefv8Value): Integer; cdecl;

    // Registers an identifier and returns true (1) on success. Access to the
    // identifier will be forwarded to the cef_v8accessor_t instance passed to
    // cef_v8value_t::cef_v8value_create_object(). Returns false (0) if this
    // function is called incorrectly or an exception is thrown. For read-only
    // values this function will return true (1) even though assignment failed.
    set_value_byaccessor: function(self: PCefv8Value; const key: PCefString;
      settings: Integer; attribute: Integer): Integer; cdecl;

    // Read the keys for the object's values into the specified vector. Integer-
    // based keys will also be returned as strings.
    get_keys: function(self: PCefv8Value; keys: TCefStringList): Integer; cdecl;

    // Sets the user data for this object and returns true (1) on success. Returns
    // false (0) if this function is called incorrectly. This function can only be
    // called on user created objects.
    set_user_data: function(self: PCefv8Value; user_data: PCefBase): Integer; cdecl;

    // Returns the user data, if any, assigned to this object.
    get_user_data: function(self: PCefv8Value): PCefBase; cdecl;

    // Returns the amount of externally allocated memory registered for the
    // object.
    get_externally_allocated_memory: function(self: PCefv8Value): Integer; cdecl;

    // Adjusts the amount of registered external memory for the object. Used to
    // give V8 an indication of the amount of externally allocated memory that is
    // kept alive by JavaScript objects. V8 uses this information to decide when
    // to perform global garbage collection. Each cef_v8value_t tracks the amount
    // of external memory associated with it and automatically decreases the
    // global total by the appropriate amount on its destruction.
    // |change_in_bytes| specifies the number of bytes to adjust by. This function
    // returns the number of bytes associated with the object after the
    // adjustment. This function can only be called on user created objects.
    adjust_externally_allocated_memory: function(self: PCefv8Value; change_in_bytes: Integer): Integer; cdecl;

    // ARRAY METHODS - These functions are only available on arrays.

    // Returns the number of elements in the array.
    get_array_length: function(self: PCefv8Value): Integer; cdecl;


    // FUNCTION METHODS - These functions are only available on functions.

    // Returns the function name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_function_name: function(self: PCefv8Value): PCefStringUserFree; cdecl;

    // Returns the function handler or NULL if not a CEF-created function.
    get_function_handler: function(
        self: PCefv8Value): PCefv8Handler; cdecl;

    // Execute the function using the current V8 context. This function should
    // only be called from within the scope of a cef_v8handler_t or
    // cef_v8accessor_t callback, or in combination with calling enter() and
    // exit() on a stored cef_v8context_t reference. |object| is the receiver
    // ('this' object) of the function. If |object| is NULL the current context's
    // global object will be used. |arguments| is the list of arguments that will
    // be passed to the function. Returns the function return value on success.
    // Returns NULL if this function is called incorrectly or an exception is
    // thrown.
    execute_function: function(self: PCefv8Value; obj: PCefv8Value;
      argumentsCount: Cardinal; const arguments: PPCefV8Value): PCefv8Value; cdecl;

    // Execute the function using the specified V8 context. |object| is the
    // receiver ('this' object) of the function. If |object| is NULL the specified
    // context's global object will be used. |arguments| is the list of arguments
    // that will be passed to the function. Returns the function return value on
    // success. Returns NULL if this function is called incorrectly or an
    // exception is thrown.
    execute_function_with_context: function(self: PCefv8Value; context: PCefv8Context;
      obj: PCefv8Value; argumentsCount: Cardinal; const arguments: PPCefV8Value): PCefv8Value; cdecl;
  end;

  // Structure representing a V8 stack trace handle. V8 handles can only be
  // accessed from the thread on which they are created. Valid threads for
  // creating a V8 handle include the render process main thread (TID_RENDERER)
  // and WebWorker threads. A task runner for posting tasks on the associated
  // thread can be retrieved via the cef_v8context_t::get_task_runner() function.
  TCefV8StackTrace = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefV8StackTrace): Integer; cdecl;

    // Returns the number of stack frames.
    get_frame_count: function(self: PCefV8StackTrace): Integer; cdecl;

    // Returns the stack frame at the specified 0-based index.
    get_frame: function(self: PCefV8StackTrace; index: Integer): PCefV8StackFrame; cdecl;
  end;

  // Structure representing a V8 stack frame handle. V8 handles can only be
  // accessed from the thread on which they are created. Valid threads for
  // creating a V8 handle include the render process main thread (TID_RENDERER)
  // and WebWorker threads. A task runner for posting tasks on the associated
  // thread can be retrieved via the cef_v8context_t::get_task_runner() function.
  TCefV8StackFrame = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefV8StackFrame): Integer; cdecl;

    // Returns the name of the resource script that contains the function.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_script_name: function(self: PCefV8StackFrame): PCefStringUserFree; cdecl;

    // Returns the name of the resource script that contains the function or the
    // sourceURL value if the script name is undefined and its source ends with a
    // "//@ sourceURL=..." string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_script_name_or_source_url: function(self: PCefV8StackFrame): PCefStringUserFree; cdecl;

    // Returns the name of the function.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_function_name: function(self: PCefV8StackFrame): PCefStringUserFree; cdecl;

    // Returns the 1-based line number for the function call or 0 if unknown.
    get_line_number: function(self: PCefV8StackFrame): Integer; cdecl;

    // Returns the 1-based column offset on the line for the function call or 0 if
    // unknown.
    get_column: function(self: PCefV8StackFrame): Integer; cdecl;

    // Returns true (1) if the function was compiled using eval().
    is_eval: function(self: PCefV8StackFrame): Integer; cdecl;

    // Returns true (1) if the function was called as a constructor via "new".
    is_constructor: function(self: PCefV8StackFrame): Integer; cdecl;
  end;

  // Structure that manages custom scheme registrations.
  TCefSchemeRegistrar = record
    // Base structure.
    base: TCefBase;

    // Register a custom scheme. This function should not be called for the built-
    // in HTTP, HTTPS, FILE, FTP, ABOUT and DATA schemes.
    //
    // If |is_standard| is true (1) the scheme will be treated as a standard
    // scheme. Standard schemes are subject to URL canonicalization and parsing
    // rules as defined in the Common Internet Scheme Syntax RFC 1738 Section 3.1
    // available at http://www.ietf.org/rfc/rfc1738.txt
    //
    // In particular, the syntax for standard scheme URLs must be of the form:
    // <pre>
    //  [scheme]://[username]:[password]@[host]:[port]/[url-path]
    // </pre> Standard scheme URLs must have a host component that is a fully
    // qualified domain name as defined in Section 3.5 of RFC 1034 [13] and
    // Section 2.1 of RFC 1123. These URLs will be canonicalized to
    // "scheme://host/path" in the simplest case and
    // "scheme://username:password@host:port/path" in the most explicit case. For
    // example, "scheme:host/path" and "scheme:///host/path" will both be
    // canonicalized to "scheme://host/path". The origin of a standard scheme URL
    // is the combination of scheme, host and port (i.e., "scheme://host:port" in
    // the most explicit case).
    //
    // For non-standard scheme URLs only the "scheme:" component is parsed and
    // canonicalized. The remainder of the URL will be passed to the handler as-
    // is. For example, "scheme:///some%20text" will remain the same. Non-standard
    // scheme URLs cannot be used as a target for form submission.
    //
    // If |is_local| is true (1) the scheme will be treated as local (i.e., with
    // the same security rules as those applied to "file" URLs). Normal pages
    // cannot link to or access local URLs. Also, by default, local URLs can only
    // perform XMLHttpRequest calls to the same URL (origin + path) that
    // originated the request. To allow XMLHttpRequest calls from a local URL to
    // other URLs with the same origin set the
    // CefSettings.file_access_from_file_urls_allowed value to true (1). To allow
    // XMLHttpRequest calls from a local URL to all origins set the
    // CefSettings.universal_access_from_file_urls_allowed value to true (1).
    //
    // If |is_display_isolated| is true (1) the scheme will be treated as display-
    // isolated. This means that pages cannot display these URLs unless they are
    // from the same scheme. For example, pages in another origin cannot create
    // iframes or hyperlinks to URLs with this scheme.
    //
    // This function may be called on any thread. It should only be called once
    // per unique |scheme_name| value. If |scheme_name| is already registered or
    // if an error occurs this function will return false (0).
    add_custom_scheme: function(self: PCefSchemeRegistrar;
      const scheme_name: PCefString; is_standard, is_local,
      is_display_isolated: Integer): Integer; cdecl;
  end;

  // Structure that creates cef_scheme_handler_t instances. The functions of this
  // structure will always be called on the IO thread.
  TCefSchemeHandlerFactory = record
    // Base structure.
    base: TCefBase;

    // Return a new resource handler instance to handle the request. |browser| and
    // |frame| will be the browser window and frame respectively that originated
    // the request or NULL if the request did not originate from a browser window
    // (for example, if the request came from cef_urlrequest_t). The |request|
    // object passed to this function will not contain cookie data.
    create: function(self: PCefSchemeHandlerFactory;
        browser: PCefBrowser; frame: PCefFrame; const scheme_name: PCefString;
        request: PCefRequest): PCefResourceHandler; cdecl;
  end;

  // Structure used to represent a download item.
  TCefDownloadItem = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefDownloadItem): Integer; cdecl;

    // Returns true (1) if the download is in progress.
    is_in_progress: function(self: PCefDownloadItem): Integer; cdecl;

    // Returns true (1) if the download is complete.
    is_complete: function(self: PCefDownloadItem): Integer; cdecl;

    // Returns true (1) if the download has been canceled or interrupted.
    is_canceled: function(self: PCefDownloadItem): Integer; cdecl;

    // Returns a simple speed estimate in bytes/s.
    get_current_speed: function(self: PCefDownloadItem): Int64; cdecl;

    // Returns the rough percent complete or -1 if the receive total size is
    // unknown.
    get_percent_complete: function(self: PCefDownloadItem): Integer; cdecl;

    // Returns the total number of bytes.
    get_total_bytes: function(self: PCefDownloadItem): Int64; cdecl;

    // Returns the number of received bytes.
    get_received_bytes: function(self: PCefDownloadItem): Int64; cdecl;

    // Returns the time that the download started.
    get_start_time: function(self: PCefDownloadItem): TCefTime; cdecl;

    // Returns the time that the download ended.
    get_end_time: function(self: PCefDownloadItem): TCefTime; cdecl;

    // Returns the full path to the downloaded or downloading file.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_full_path: function(self: PCefDownloadItem): PCefStringUserFree; cdecl;

    // Returns the unique identifier for this download.
    get_id: function(self: PCefDownloadItem): Integer; cdecl;

    // Returns the URL.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefDownloadItem): PCefStringUserFree; cdecl;

    // Returns the suggested file name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_suggested_file_name: function(self: PCefDownloadItem): PCefStringUserFree; cdecl;

    // Returns the content disposition.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_content_disposition: function(self: PCefDownloadItem): PCefStringUserFree; cdecl;

    // Returns the mime type.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_mime_type: function(self: PCefDownloadItem): PCefStringUserFree; cdecl;
  end;

  // Callback structure used to asynchronously continue a download.
  TCefBeforeDownloadCallback = record
    // Base structure.
    base: TCefBase;

    // Call to continue the download. Set |download_path| to the full file path
    // for the download including the file name or leave blank to use the
    // suggested name and the default temp directory. Set |show_dialog| to true
    // (1) if you do wish to show the default "Save As" dialog.
    cont: procedure(self: PCefBeforeDownloadCallback;
      const download_path: PCefString; show_dialog: Integer); cdecl;
  end;

  // Callback structure used to asynchronously cancel a download.
  TCefDownloadItemCallback = record
  // Base structure.
    base: TCefBase;

    // Call to cancel the download.
    cancel: procedure(self: PCefDownloadItemCallback); cdecl;
  end;

  // Structure used to handle file downloads. The functions of this structure will
  // always be called on the UI thread.
  TCefDownloadHandler = record
    // Base structure.
    base: TCefBase;

    // Called before a download begins. |suggested_name| is the suggested name for
    // the download file. By default the download will be canceled. Execute
    // |callback| either asynchronously or in this function to continue the
    // download if desired. Do not keep a reference to |download_item| outside of
    // this function.
    on_before_download: procedure(self: PCefDownloadHandler;
      browser: PCefBrowser; download_item: PCefDownloadItem;
      const suggested_name: PCefString; callback: PCefBeforeDownloadCallback); cdecl;

    // Called when a download's status or progress information has been updated.
    // Execute |callback| either asynchronously or in this function to cancel the
    // download if desired. Do not keep a reference to |download_item| outside of
    // this function.
    on_download_updated: procedure(self: PCefDownloadHandler;
        browser: PCefBrowser; download_item: PCefDownloadItem;
        callback: PCefDownloadItemCallback); cdecl;
  end;

  // Structure that supports the reading of XML data via the libxml streaming API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefXmlReader = record
    // Base structure.
    base: TcefBase;

    // Moves the cursor to the next node in the document. This function must be
    // called at least once to set the current cursor position. Returns true (1)
    // if the cursor position was set successfully.
    move_to_next_node: function(self: PCefXmlReader): Integer; cdecl;

    // Close the document. This should be called directly to ensure that cleanup
    // occurs on the correct thread.
    close: function(self: PCefXmlReader): Integer; cdecl;

    // Returns true (1) if an error has been reported by the XML parser.
    has_error: function(self: PCefXmlReader): Integer; cdecl;

    // Returns the error string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_error: function(self: PCefXmlReader): PCefStringUserFree; cdecl;


    // The below functions retrieve data for the node at the current cursor
    // position.

    // Returns the node type.
    get_type: function(self: PCefXmlReader): TCefXmlNodeType; cdecl;

    // Returns the node depth. Depth starts at 0 for the root node.
    get_depth: function(self: PCefXmlReader): Integer; cdecl;

    // Returns the local name. See http://www.w3.org/TR/REC-xml-names/#NT-
    // LocalPart for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_local_name: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns the namespace prefix. See http://www.w3.org/TR/REC-xml-names/ for
    // additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_prefix: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns the qualified name, equal to (Prefix:)LocalName. See
    // http://www.w3.org/TR/REC-xml-names/#ns-qualnames for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_qualified_name: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns the URI defining the namespace associated with the node. See
    // http://www.w3.org/TR/REC-xml-names/ for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_namespace_uri: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns the base URI of the node. See http://www.w3.org/TR/xmlbase/ for
    // additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_base_uri: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns the xml:lang scope within which the node resides. See
    // http://www.w3.org/TR/REC-xml/#sec-lang-tag for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_xml_lang: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns true (1) if the node represents an NULL element. <a/> is considered
    // NULL but <a></a> is not.
    is_empty_element: function(self: PCefXmlReader): Integer; cdecl;

    // Returns true (1) if the node has a text value.
    has_value: function(self: PCefXmlReader): Integer; cdecl;

    // Returns the text value.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_value: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns true (1) if the node has attributes.
    has_attributes: function(self: PCefXmlReader): Integer; cdecl;

    // Returns the number of attributes.
    get_attribute_count: function(self: PCefXmlReader): Cardinal; cdecl;

    // Returns the value of the attribute at the specified 0-based index.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_byindex: function(self: PCefXmlReader; index: Integer): PCefStringUserFree; cdecl;

    // Returns the value of the attribute with the specified qualified name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_byqname: function(self: PCefXmlReader; const qualifiedName: PCefString): PCefStringUserFree; cdecl;

    // Returns the value of the attribute with the specified local name and
    // namespace URI.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_bylname: function(self: PCefXmlReader; const localName, namespaceURI: PCefString): PCefStringUserFree; cdecl;

    // Returns an XML representation of the current node's children.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_inner_xml: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns an XML representation of the current node including its children.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_outer_xml: function(self: PCefXmlReader): PCefStringUserFree; cdecl;

    // Returns the line number for the current node.
    get_line_number: function(self: PCefXmlReader): Integer; cdecl;


    // Attribute nodes are not traversed by default. The below functions can be
    // used to move the cursor to an attribute node. move_to_carrying_element()
    // can be called afterwards to return the cursor to the carrying element. The
    // depth of an attribute node will be 1 + the depth of the carrying element.

    // Moves the cursor to the attribute at the specified 0-based index. Returns
    // true (1) if the cursor position was set successfully.
    move_to_attribute_byindex: function(self: PCefXmlReader; index: Integer): Integer; cdecl;

    // Moves the cursor to the attribute with the specified qualified name.
    // Returns true (1) if the cursor position was set successfully.
    move_to_attribute_byqname: function(self: PCefXmlReader; const qualifiedName: PCefString): Integer; cdecl;

    // Moves the cursor to the attribute with the specified local name and
    // namespace URI. Returns true (1) if the cursor position was set
    // successfully.
    move_to_attribute_bylname: function(self: PCefXmlReader; const localName, namespaceURI: PCefString): Integer; cdecl;

    // Moves the cursor to the first attribute in the current element. Returns
    // true (1) if the cursor position was set successfully.
    move_to_first_attribute: function(self: PCefXmlReader): Integer; cdecl;

    // Moves the cursor to the next attribute in the current element. Returns true
    // (1) if the cursor position was set successfully.
    move_to_next_attribute: function(self: PCefXmlReader): Integer; cdecl;

    // Moves the cursor back to the carrying element. Returns true (1) if the
    // cursor position was set successfully.
    move_to_carrying_element: function(self: PCefXmlReader): Integer; cdecl;
  end;

  // Structure that supports the reading of zip archives via the zlib unzip API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefZipReader = record
    // Base structure.
    base: TCefBase;

    // Moves the cursor to the first file in the archive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_first_file: function(self: PCefZipReader): Integer; cdecl;

    // Moves the cursor to the next file in the archive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_next_file: function(self: PCefZipReader): Integer; cdecl;

    // Moves the cursor to the specified file in the archive. If |caseSensitive|
    // is true (1) then the search will be case sensitive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_file: function(self: PCefZipReader; const fileName: PCefString; caseSensitive: Integer): Integer; cdecl;

    // Closes the archive. This should be called directly to ensure that cleanup
    // occurs on the correct thread.
    close: function(Self: PCefZipReader): Integer; cdecl;


    // The below functions act on the file at the current cursor position.

    // Returns the name of the file.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_file_name: function(Self: PCefZipReader): PCefStringUserFree; cdecl;

    // Returns the uncompressed size of the file.
    get_file_size: function(Self: PCefZipReader): Int64; cdecl;

    // Returns the last modified timestamp for the file.
    get_file_last_modified: function(Self: PCefZipReader): LongInt; cdecl;

    // Opens the file for reading of uncompressed data. A read password may
    // optionally be specified.
    open_file: function(Self: PCefZipReader; const password: PCefString): Integer; cdecl;

    // Closes the file.
    close_file: function(Self: PCefZipReader): Integer; cdecl;

    // Read uncompressed file contents into the specified buffer. Returns < 0 if
    // an error occurred, 0 if at the end of file, or the number of bytes read.
    read_file: function(Self: PCefZipReader; buffer: Pointer; bufferSize: Cardinal): Integer; cdecl;

    // Returns the current offset in the uncompressed file contents.
    tell: function(Self: PCefZipReader): Int64; cdecl;

    // Returns true (1) if at end of the file contents.
    eof: function(Self: PCefZipReader): Integer; cdecl;
  end;

  // Structure to implement for visiting the DOM. The functions of this structure
  // will be called on the render process main thread.
  TCefDomVisitor = record
    // Base structure.
    base: TCefBase;

    // Method executed for visiting the DOM. The document object passed to this
    // function represents a snapshot of the DOM at the time this function is
    // executed. DOM objects are only valid for the scope of this function. Do not
    // keep references to or attempt to access any DOM objects outside the scope
    // of this function.
    visit: procedure(self: PCefDomVisitor; document: PCefDomDocument); cdecl;
  end;

  // Structure used to represent a DOM document. The functions of this structure
  // should only be called on the render process main thread thread.
  TCefDomDocument = record
    // Base structure.
    base: TCefBase;

    // Returns the document type.
    get_type: function(self: PCefDomDocument): TCefDomDocumentType; cdecl;

    // Returns the root document node.
    get_document: function(self: PCefDomDocument): PCefDomNode; cdecl;

    // Returns the BODY node of an HTML document.
    get_body: function(self: PCefDomDocument): PCefDomNode; cdecl;

    // Returns the HEAD node of an HTML document.
    get_head: function(self: PCefDomDocument): PCefDomNode; cdecl;

    // Returns the title of an HTML document.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_title: function(self: PCefDomDocument): PCefStringUserFree; cdecl;

    // Returns the document element with the specified ID value.
    get_element_by_id: function(self: PCefDomDocument; const id: PCefString): PCefDomNode; cdecl;

    // Returns the node that currently has keyboard focus.
    get_focused_node: function(self: PCefDomDocument): PCefDomNode; cdecl;

    // Returns true (1) if a portion of the document is selected.
    has_selection: function(self: PCefDomDocument): Integer; cdecl;

    // Returns the selection start node.
    get_selection_start_node: function(self: PCefDomDocument): PCefDomNode; cdecl;

    // Returns the selection offset within the start node.
    get_selection_start_offset: function(self: PCefDomDocument): Integer; cdecl;

    // Returns the selection end node.
    get_selection_end_node: function(self: PCefDomDocument): PCefDomNode; cdecl;

    // Returns the selection offset within the end node.
    get_selection_end_offset: function(self: PCefDomDocument): Integer; cdecl;

    // Returns the contents of this selection as markup.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_as_markup: function(self: PCefDomDocument): PCefStringUserFree; cdecl;

    // Returns the contents of this selection as text.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_as_text: function(self: PCefDomDocument): PCefStringUserFree; cdecl;

    // Returns the base URL for the document.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_base_url: function(self: PCefDomDocument): PCefStringUserFree; cdecl;

    // Returns a complete URL based on the document base URL and the specified
    // partial URL.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_complete_url: function(self: PCefDomDocument; const partialURL: PCefString): PCefStringUserFree; cdecl;
  end;

  // Structure used to represent a DOM node. The functions of this structure
  // should only be called on the render process main thread.
  TCefDomNode = record
    // Base structure.
    base: TCefBase;

    // Returns the type for this node.
    get_type: function(self: PCefDomNode): TCefDomNodeType; cdecl;

    // Returns true (1) if this is a text node.
    is_text: function(self: PCefDomNode): Integer; cdecl;

    // Returns true (1) if this is an element node.
    is_element: function(self: PCefDomNode): Integer; cdecl;

    // Returns true (1) if this is an editable node.
    is_editable: function(self: PCefDomNode): Integer; cdecl;

    // Returns true (1) if this is a form control element node.
    is_form_control_element: function(self: PCefDomNode): Integer; cdecl;

    // Returns the type of this form control element node.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_form_control_element_type: function(self: PCefDomNode): PCefStringUserFree; cdecl;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefDomNode): Integer; cdecl;

    // Returns the name of this node.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefDomNode): PCefStringUserFree; cdecl;

    // Returns the value of this node.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_value: function(self: PCefDomNode): PCefStringUserFree; cdecl;

    // Set the value of this node. Returns true (1) on success.
    set_value: function(self: PCefDomNode; const value: PCefString): Integer; cdecl;

    // Returns the contents of this node as markup.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_as_markup: function(self: PCefDomNode): PCefStringUserFree; cdecl;

    // Returns the document associated with this node.
    get_document: function(self: PCefDomNode): PCefDomDocument; cdecl;

    // Returns the parent node.
    get_parent: function(self: PCefDomNode): PCefDomNode; cdecl;

    // Returns the previous sibling node.
    get_previous_sibling: function(self: PCefDomNode): PCefDomNode; cdecl;

    // Returns the next sibling node.
    get_next_sibling: function(self: PCefDomNode): PCefDomNode; cdecl;

    // Returns true (1) if this node has child nodes.
    has_children: function(self: PCefDomNode): Integer; cdecl;

    // Return the first child node.
    get_first_child: function(self: PCefDomNode): PCefDomNode; cdecl;

    // Returns the last child node.
    get_last_child: function(self: PCefDomNode): PCefDomNode; cdecl;

    // Add an event listener to this node for the specified event type. If
    // |useCapture| is true (1) then this listener will be considered a capturing
    // listener. Capturing listeners will recieve all events of the specified type
    // before the events are dispatched to any other event targets beneath the
    // current node in the tree. Events which are bubbling upwards through the
    // tree will not trigger a capturing listener. Separate calls to this function
    // can be used to register the same listener with and without capture. See
    // WebCore/dom/EventNames.h for the list of supported event types.
    add_event_listener: procedure(self: PCefDomNode; const eventType: PCefString;
      listener: PCefDomEventListener; useCapture: Integer); cdecl;

    // The following functions are valid only for element nodes.

    // Returns the tag name of this element.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_element_tag_name: function(self: PCefDomNode): PCefStringUserFree; cdecl;

    // Returns true (1) if this element has attributes.
    has_element_attributes: function(self: PCefDomNode): Integer; cdecl;

    // Returns true (1) if this element has an attribute named |attrName|.
    has_element_attribute: function(self: PCefDomNode; const attrName: PCefString): Integer; cdecl;

    // Returns the element attribute named |attrName|.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_element_attribute: function(self: PCefDomNode; const attrName: PCefString): PCefStringUserFree; cdecl;

    // Returns a map of all element attributes.
    get_element_attributes: procedure(self: PCefDomNode; attrMap: TCefStringMap); cdecl;

    // Set the value for the element attribute named |attrName|. Returns true (1)
    // on success.
    set_element_attribute: function(self: PCefDomNode; const attrName, value: PCefString): Integer; cdecl;

    // Returns the inner text of the element.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_element_inner_text: function(self: PCefDomNode): PCefStringUserFree; cdecl;
  end;

  // Structure used to represent a DOM event. The functions of this structure
  // should only be called on the render process main thread.
  TCefDomEvent = record
    // Base structure.
    base: TCefBase;

    // Returns the event type.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_type: function(self: PCefDomEvent): PCefStringUserFree; cdecl;

    // Returns the event category.
    get_category: function(self: PCefDomEvent): TCefDomEventCategory; cdecl;

    // Returns the event processing phase.
    get_phase: function(self: PCefDomEvent): TCefDomEventPhase; cdecl;

    // Returns true (1) if the event can bubble up the tree.
    can_bubble: function(self: PCefDomEvent): Integer; cdecl;

    // Returns true (1) if the event can be canceled.
    can_cancel: function(self: PCefDomEvent): Integer; cdecl;

    // Returns the document associated with this event.
    get_document: function(self: PCefDomEvent): PCefDomDocument; cdecl;

    // Returns the target of the event.
    get_target: function(self: PCefDomEvent): PCefDomNode; cdecl;

    // Returns the current target of the event.
    get_current_target: function(self: PCefDomEvent): PCefDomNode; cdecl;
  end;

  // Structure to implement for handling DOM events. The functions of this
  // structure will be called on the render process main thread.
  TCefDomEventListener = record
    // Base structure.
    base: TCefBase;

    // Called when an event is received. The event object passed to this function
    // contains a snapshot of the DOM at the time this function is executed. DOM
    // objects are only valid for the scope of this function. Do not keep
    // references to or attempt to access any DOM objects outside the scope of
    // this function.
    handle_event: procedure(self: PCefDomEventListener; event: PCefDomEvent); cdecl;
  end;

  // Structure to implement for visiting cookie values. The functions of this
  // structure will always be called on the IO thread.
  TCefCookieVisitor = record
    // Base structure.
    base: TCefBase;

    // Method that will be called once for each cookie. |count| is the 0-based
    // index for the current cookie. |total| is the total number of cookies. Set
    // |deleteCookie| to true (1) to delete the cookie currently being visited.
    // Return false (0) to stop visiting cookies. This function may never be
    // called if no cookies are found.

    visit: function(self: PCefCookieVisitor; const cookie: PCefCookie;
      count, total: Integer; deleteCookie: PInteger): Integer; cdecl;
  end;

  // Structure used for managing cookies. The functions of this structure may be
  // called on any thread unless otherwise indicated.
  TCefCookieManager = record
    // Base structure.
    base: TCefBase;

    // Set the schemes supported by this manager. By default only "http" and
    // "https" schemes are supported. Must be called before any cookies are
    // accessed.
    set_supported_schemes: procedure(self: PCefCookieManager; schemes: TCefStringList); cdecl;

    // Visit all cookies. The returned cookies are ordered by longest path, then
    // by earliest creation date. Returns false (0) if cookies cannot be accessed.
    visit_all_cookies: function(self: PCefCookieManager; visitor: PCefCookieVisitor): Integer; cdecl;

    // Visit a subset of cookies. The results are filtered by the given url
    // scheme, host, domain and path. If |includeHttpOnly| is true (1) HTTP-only
    // cookies will also be included in the results. The returned cookies are
    // ordered by longest path, then by earliest creation date. Returns false (0)
    // if cookies cannot be accessed.
    visit_url_cookies: function(self: PCefCookieManager; const url: PCefString;
      includeHttpOnly: Integer; visitor: PCefCookieVisitor): Integer; cdecl;

    // Sets a cookie given a valid URL and explicit user-provided cookie
    // attributes. This function expects each attribute to be well-formed. It will
    // check for disallowed characters (e.g. the ';' character is disallowed
    // within the cookie value attribute) and will return false (0) without
    // setting the cookie if such characters are found. This function must be
    // called on the IO thread.
    set_cookie: function(self: PCefCookieManager; const url: PCefString;
      const cookie: PCefCookie): Integer; cdecl;

    // Delete all cookies that match the specified parameters. If both |url| and
    // values |cookie_name| are specified all host and domain cookies matching
    // both will be deleted. If only |url| is specified all host cookies (but not
    // domain cookies) irrespective of path will be deleted. If |url| is NULL all
    // cookies for all hosts and domains will be deleted. Returns false (0) if a
    // non- NULL invalid URL is specified or if cookies cannot be accessed. This
    // function must be called on the IO thread.
    delete_cookies: function(self: PCefCookieManager;
        const url, cookie_name: PCefString): Integer; cdecl;

    // Sets the directory path that will be used for storing cookie data. If
    // |path| is NULL data will be stored in memory only. Returns false (0) if
    // cookies cannot be accessed.
    set_storage_path: function(self: PCefCookieManager;
      const path: PCefString): Integer; cdecl;
  end;

  // Information about a specific web plugin.
  TCefWebPluginInfo = record
    // Base structure.
    base: TCefBase;

    // Returns the plugin name (i.e. Flash).
    get_name: function(self: PCefWebPluginInfo): PCefStringUserFree; cdecl;

    // Returns the plugin file path (DLL/bundle/library).
    get_path: function(self: PCefWebPluginInfo): PCefStringUserFree; cdecl;

    // Returns the version of the plugin (may be OS-specific).
    get_version: function(self: PCefWebPluginInfo): PCefStringUserFree; cdecl;

    // Returns a description of the plugin from the version information.
    get_description: function(self: PCefWebPluginInfo): PCefStringUserFree; cdecl;
  end;

  // Structure to implement for visiting web plugin information. The functions of
  // this structure will be called on the browser process UI thread.
  TCefWebPluginInfoVisitor = record
    // Base structure.
    base: TCefBase;

    // Method that will be called once for each plugin. |count| is the 0-based
    // index for the current plugin. |total| is the total number of plugins.
    // Return false (0) to stop visiting plugins. This function may never be
    // called if no plugins are found.
    visit: function(self: PCefWebPluginInfoVisitor;
      info: PCefWebPluginInfo; count, total: Integer): Integer; cdecl;
  end;

  // Structure to implement for receiving unstable plugin information. The
  // functions of this structure will be called on the browser process IO thread.
  TCefWebPluginUnstableCallback = record
    // Base structure.
    base: TCefBase;

    // Method that will be called for the requested plugin. |unstable| will be
    // true (1) if the plugin has reached the crash count threshold of 3 times in
    // 120 seconds.
    is_unstable: procedure(self: PCefWebPluginUnstableCallback;
        const path: PCefString; unstable: Integer); cdecl;
  end;

  // Structure used to make a URL request. URL requests are not associated with a
  // browser instance so no cef_client_t callbacks will be executed. URL requests
  // can be created on any valid CEF thread in either the browser or render
  // process. Once created the functions of the URL request object must be
  // accessed on the same thread that created it.
  TCefUrlRequest = record
    // Base structure.
    base: TCefBase;

    // Returns the request object used to create this URL request. The returned
    // object is read-only and should not be modified.
    get_request: function(self: PCefUrlRequest): PCefRequest; cdecl;

    // Returns the client.
    get_client: function(self: PCefUrlRequest): PCefUrlRequestClient; cdecl;

    // Returns the request status.
    get_request_status: function(self: PCefUrlRequest): TCefUrlRequestStatus; cdecl;

    // Returns the request error if status is UR_CANCELED or UR_FAILED, or 0
    // otherwise.
    get_request_error: function(self: PCefUrlRequest): Integer; cdecl;

    // Returns the response, or NULL if no response information is available.
    // Response information will only be available after the upload has completed.
    // The returned object is read-only and should not be modified.
    get_response: function(self: PCefUrlRequest): PCefResponse; cdecl;

    // Cancel the request.
    cancel: procedure(self: PCefUrlRequest); cdecl;
  end;

  // Structure that should be implemented by the cef_urlrequest_t client. The
  // functions of this structure will be called on the same thread that created
  // the request.
  TCefUrlrequestClient = record
    // Base structure.
    base: TCefBase;

    // Notifies the client that the request has completed. Use the
    // cef_urlrequest_t::GetRequestStatus function to determine if the request was
    // successful or not.
    on_request_complete: procedure(self: PCefUrlRequestClient; request: PCefUrlRequest); cdecl;

    // Notifies the client of upload progress. |current| denotes the number of
    // bytes sent so far and |total| is the total size of uploading data (or -1 if
    // chunked upload is enabled). This function will only be called if the
    // UR_FLAG_REPORT_UPLOAD_PROGRESS flag is set on the request.
    on_upload_progress: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; current, total: UInt64); cdecl;

    // Notifies the client of download progress. |current| denotes the number of
    // bytes received up to the call and |total| is the expected total size of the
    // response (or -1 if not determined).
    on_download_progress: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; current, total: UInt64); cdecl;

    // Called when some part of the response is read. |data| contains the current
    // bytes received since the last call. This function will not be called if the
    // UR_FLAG_NO_DOWNLOAD_DATA flag is set on the request.
    on_download_data: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; const data: Pointer; data_length: Cardinal); cdecl;
  end;

  // Callback structure for asynchronous continuation of file dialog requests.
  TCefFileDialogCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the file selection with the specified |file_paths|. This may be a
    // single value or a list of values depending on the dialog mode. An NULL
    // value is treated the same as calling cancel().
    cont: procedure(self: PCefFileDialogCallback; file_paths: TCefStringList); cdecl;

    // Cancel the file selection.
    cancel: procedure(self: PCefFileDialogCallback); cdecl;
  end;

  // Implement this structure to handle dialog events. The functions of this
  // structure will be called on the browser process UI thread.
  TCefDialogHandler = record
    // Base structure.
    base: TCefBase;

    // Called to run a file chooser dialog. |mode| represents the type of dialog
    // to display. |title| to the title to be used for the dialog and may be NULL
    // to show the default title ("Open" or "Save" depending on the mode).
    // |default_file_name| is the default file name to select in the dialog.
    // |accept_types| is a list of valid lower-cased MIME types or file extensions
    // specified in an input element and is used to restrict selectable files to
    // such types. To display a custom dialog return true (1) and execute
    // |callback| either inline or at a later time. To display the default dialog
    // return false (0).
    on_file_dialog: function(self: PCefDialogHandler; browser: PCefBrowser;
      mode: TCefFileDialogMode; const title, default_file_name: PCefString;
      accept_types: TCefStringList; callback: PCefFileDialogCallback): Integer; cdecl;
  end;

  // Implement this structure to handle events when window rendering is disabled.
  // The functions of this structure will be called on the UI thread.
  TCefRenderHandler = record
    // Base structure.
    base: TCefBase;

    // Called to retrieve the root window rectangle in screen coordinates. Return
    // true (1) if the rectangle was provided.
    get_root_screen_rect: function(self: PCefRenderHandler; browser: PCefBrowser;
      rect: PCefRect): Integer; cdecl;

    // Called to retrieve the view rectangle which is relative to screen
    // coordinates. Return true (1) if the rectangle was provided.
    get_view_rect: function(self: PCefRenderHandler; browser: PCefBrowser;
      rect: PCefRect): Integer; cdecl;

    // Called to retrieve the translation from view coordinates to actual screen
    // coordinates. Return true (1) if the screen coordinates were provided.
    get_screen_point: function(self: PCefRenderHandler; browser: PCefBrowser;
      viewX, viewY: Integer; screenX, screenY: PInteger): Integer; cdecl;

    // Called when the browser wants to show or hide the popup widget. The popup
    // should be shown if |show| is true (1) and hidden if |show| is false (0).
    on_popup_show: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      show: Integer); cdecl;

    // Called when the browser wants to move or resize the popup widget. |rect|
    // contains the new location and size.
    on_popup_size: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      const rect: PCefRect); cdecl;

    // Called when an element should be painted. |type| indicates whether the
    // element is the view or the popup widget. |buffer| contains the pixel data
    // for the whole image. |dirtyRects| contains the set of rectangles that need
    // to be repainted. On Windows |buffer| will be |width|*|height|*4 bytes in
    // size and represents a BGRA image with an upper-left origin.
    on_paint: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      kind: TCefPaintElementType; dirtyRectsCount: Cardinal;
      const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer); cdecl;

    // Called when the browser window's cursor has changed.
    on_cursor_change: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      cursor: TCefCursorHandle); cdecl;
  end;

  // Implement this structure to receive geolocation updates. The functions of
  // this structure will be called on the browser process UI thread.
  TCefGetGeolocationCallback = record
    // Base structure.
    base: TCefBase;

    // Called with the 'best available' location information or, if the location
    // update failed, with error information.
    on_location_update: procedure(self: PCefGetGeolocationCallback;
        const position: Pcefgeoposition); cdecl;
  end;

  // Implement this structure to receive trace notifications. The functions of
  // this structure will be called on the browser process UI thread.

  TCefTraceClient = record
    // Base structure.
    base: TCefBase;

    // Called 0 or more times between CefBeginTracing and OnEndTracingComplete
    // with a UTF8 JSON |fragment| of the specified |fragment_size|. Do not keep a
    // reference to |fragment|.

    on_trace_data_collected: procedure(self: PCefTraceClient;
        const fragment: PAnsiChar; fragment_size: Cardinal); cdecl;

    // Called in response to CefGetTraceBufferPercentFullAsync.
    on_trace_buffer_percent_full_reply: procedure(self: PCefTraceClient; percent_full: Single); cdecl;

    // Called after all processes have sent their trace data.
    on_end_tracing_complete: procedure(self: PCefTraceClient); cdecl;
  end;

Implementation

end.