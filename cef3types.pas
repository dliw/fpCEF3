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

Unit cef3types;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  ctypes;

Type
  ustring = WideString;
  rbstring = AnsiString;

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

  PSize = ^TSize;
  TSize = csize_t;

{ ***  cef_string_types.h  *** }
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
    length: csize_t;
    dtor: procedure(str: PWideChar); cconv;
  end;

  PCefStringUtf8 = ^TCefStringUtf8;
  TCefStringUtf8 = record
    str: PAnsiChar;
    length: csize_t;
    dtor: procedure(str: PAnsiChar); cconv;
  end;

  PCefStringUtf16 = ^TCefStringUtf16;
  TCefStringUtf16 = record
    str: PChar16;
    length: csize_t;
    dtor: procedure(str: PChar16); cconv;
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

{ ***  cef_string.h  *** }
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

{ ***  cef_string_list.h  *** }
  // CEF string maps are a set of key/value string pairs.
  TCefStringList = Pointer;

{ ***  cef_string_map.h  *** }
  // CEF string maps are a set of key/value string pairs.
  TCefStringMap = Pointer;

{ ***  cef_string_multimap.h  *** }
  // CEF string multimaps are a set of key/value string pairs.
  // More than one value can be assigned to a single key.
  TCefStringMultimap = Pointer;


{ ***  platform specific types  *** }

  TCefWindowHandle = {$IFDEF WINDOWS}HWND   {$ELSE}Pointer {PGtkWidget}{$ENDIF};
  TCefCursorHandle = {$IFDEF WINDOWS}HCURSOR{$ELSE}Pointer {PGdkCursor}{$ENDIF};
  TCefEventHandle  = {$IFDEF WINDOWS}PMSG   {$ELSE}Pointer {PGdkEvent}{$ENDIF};
  TCefTextInputContext = Pointer;

  // Structure representing CefExecuteProcess arguments.
  PCefMainArgs = ^TCefMainArgs;
  TCefMainArgs = record
    {$IFDEF WINDOWS}
      instance : HINST;
    {$ELSE}
      argc : Integer;
      argv : PPChar;
    {$ENDIF}
  end;

  // Structure representing window information.
  PCefWindowInfo = ^TCefWindowInfo;
  TCefWindowInfo = record
    {$IFDEF WINDOWS}
      // Standard parameters required by CreateWindowEx()
      ex_style : DWORD;
      window_name : TCefString;
      style : DWORD;
      x, y, width, height : Integer;
      parent_window : TCefWindowHandle;
      menu : HMENU;

      // If window rendering is disabled no browser window will be created. Set
      // |parent_window| to be used for identifying monitor info
      // (MonitorFromWindow). If |parent_window| is not provided the main screen
      // monitor will be used.
      window_rendering_disabled : BOOL;

      // Set to true to enable transparent painting.
      // If window rendering is disabled and |transparent_painting| is set to true
      // WebKit rendering will draw on a transparent background (RGBA=0x00000000).
      // When this value is false the background will be white and opaque.
      transparent_painting : BOOL;

      // Handle for the new browser window.
      window : TCefWindowHandle;
    {$ENDIF}
    {$IFDEF LINUX}
      // Pointer for the parent GtkBox widget.
      parent_widget : TCefWindowHandle;

      // If window rendering is disabled no browser window will be created. Set
      // |parent_widget| to the window that will act as the parent for popup menus,
      // dialog boxes, etc.
      window_rendering_disabled : Boolean;

      // Set to true to enable transparent painting.
      transparent_painting : Boolean;

      // Pointer for the new browser widget.
      widget : TCefWindowHandle;
    {$ENDIF}
    {$IFDEF MACOS}
      window_name : TCefString;
      x, y, width, height, hidden : Integer;

      // NSView pointer for the parent view.
      parent_view : TCefWindowHandle;

      // If window rendering is disabled no browser window will be created. Set
      // |parent_view| to the window that will act as the parent for popup menus,
      // dialog boxes, etc.
      window_rendering_disabled : Boolean;

      // Set to true to enable transparent painting.
      transparent_painting : Boolean;

      // NSView pointer for the new browser view.
      view : TCefWindowHandle;
    {$ENDIF}
  end;

{ ***  cef_time.h  *** }
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

{ ***  cef_types.h  *** }
  // 32-bit ARGB color value, not premultiplied. The color components are always
  // in a known order. Equivalent to the SkColor type.
  TCefColor = UInt32;

function CefColorGetA(color: TCefColor): Byte;
function CefColorGetR(color: TCefColor): Byte;
function CefColorGetG(color: TCefColor): Byte;
function CefColorGetB(color: TCefColor): Byte;

function CefColorSetARGB(a, r, g, b: Byte): TCefColor;

Type

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
    size: csize_t;

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
    // cache will be used for some features and a temporary disk cache for others.
    // HTML5 databases such as localStorage will only persist across sessions if a
    // cache path is specified.
    cache_path: TCefString;

    // To persist session cookies (cookies without an expiry date or validity
    // interval) by default when using the global cookie manager set this value to
    // true. Session cookies are generally intended to be transient and most Web
    // browsers do not persist them. A |cache_path| value must also be specified to
    // enable this feature. Also configurable using the "persist-session-cookies"
    // command-line switch.
    persist_session_cookies: Boolean;

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

    // Set to true (1) to ignore errors related to invalid SSL certificates.
    // Enabling this setting can lead to potential security vulnerabilities like
    // "man in the middle" attacks. Applications that load content from the
    // internet should not enable this setting. Also configurable using the
    // "ignore-certificate-errors" command-line switch.
    ignore_certificate_error: Boolean;

    // Used on Mac OS X to specify the background color for hardware accelerated
    // content.
    background_color: TCefColor;
  end;

  // Browser initialization settings. Specify NULL or 0 to get the recommended
  // default values. The consequences of using custom values may not be well
  // tested. Many of these and other settings can also configured using command-
  // line switches.
  PCefBrowserSettings = ^TCefBrowserSettings;
  TCefBrowserSettings = record
    // Size of this structure.
    size: csize_t;

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

  // Cookie information.
  PCefCookie = ^TCefCookie;
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

  {$NOTE ascending order?}
  TCefErrorCode = (
    ERR_NONE = 0,
    ERR_FAILED = -2,
    ERR_ABORTED = -3,
    ERR_INVALID_ARGUMENT = -4,
    ERR_INVALID_HANDLE = -5,
    ERR_FILE_NOT_FOUND = -6,
    ERR_TIMED_OUT = -7,
    ERR_FILE_TOO_BIG = -8,
    ERR_UNEXPECTED = -9,
    ERR_ACCESS_DENIED = -10,
    ERR_NOT_IMPLEMENTED = -11,
    ERR_CONNECTION_CLOSED = -100,
    ERR_CONNECTION_RESET = -101,
    ERR_CONNECTION_REFUSED = -102,
    ERR_CONNECTION_ABORTED = -103,
    ERR_CONNECTION_FAILED = -104,
    ERR_NAME_NOT_RESOLVED = -105,
    ERR_INTERNET_DISCONNECTED = -106,
    ERR_SSL_PROTOCOL_ERROR = -107,
    ERR_ADDRESS_INVALID = -108,
    ERR_ADDRESS_UNREACHABLE = -109,
    ERR_SSL_CLIENT_AUTH_CERT_NEEDED = -110,
    ERR_TUNNEL_CONNECTION_FAILED = -111,
    ERR_NO_SSL_VERSIONS_ENABLED = -112,
    ERR_SSL_VERSION_OR_CIPHER_MISMATCH = -113,
    ERR_SSL_RENEGOTIATION_REQUESTED = -114,
    ERR_CERT_COMMON_NAME_INVALID = -200,
    ERR_CERT_DATE_INVALID = -201,
    ERR_CERT_AUTHORITY_INVALID = -202,
    ERR_CERT_CONTAINS_ERRORS = -203,
    ERR_CERT_NO_REVOCATION_MECHANISM = -204,
    ERR_CERT_UNABLE_TO_CHECK_REVOCATION = -205,
    ERR_CERT_REVOKED = -206,
    ERR_CERT_INVALID = -207,
    ERR_CERT_END = -208,
    ERR_INVALID_URL = -300,
    ERR_DISALLOWED_URL_SCHEME = -301,
    ERR_UNKNOWN_URL_SCHEME = -302,
    ERR_TOO_MANY_REDIRECTS = -310,
    ERR_UNSAFE_REDIRECT = -311,
    ERR_UNSAFE_PORT = -312,
    ERR_INVALID_RESPONSE = -320,
    ERR_INVALID_CHUNKED_ENCODING = -321,
    ERR_METHOD_NOT_SUPPORTED = -322,
    ERR_UNEXPECTED_PROXY_AUTH = -323,
    ERR_EMPTY_RESPONSE = -324,
    ERR_RESPONSE_HEADERS_TOO_BIG = -325,
    ERR_CACHE_MISS = -400,
    ERR_INSECURE_RESPONSE = -501
  );

Type
  // "Verb" of a drag-and-drop operation as negotiated between the source and
  // destination. These constants match their equivalents in WebCore's
  // DragActions.h and should not be renumbered.
  TCefDragOperationsMask = (
    DRAG_OPERATION_NONE    = 0,
    DRAG_OPERATION_COPY    = 1,
    DRAG_OPERATION_LINK    = 2,
    DRAG_OPERATION_GENERIC = 4,
    DRAG_OPERATION_PRIVATE = 8,
    DRAG_OPERATION_MOVE    = 16,
    DRAG_OPERATION_DELETE  = 32,
    DRAG_OPERATION_EVERY   = High(UInt32)
    );

  // V8 access control values.
  TCefV8AccessControl = (
    V8_ACCESS_CONTROL_DEFAULT               = 0,
    V8_ACCESS_CONTROL_ALL_CAN_READ          = 1,
    V8_ACCESS_CONTROL_ALL_CAN_WRITE         = 1 shl 1,
    V8_ACCESS_CONTROL_PROHIBITS_OVERWRITING = 1 shl 2
  );
  TCefV8AccessControls = set of TCefV8AccessControl;

  // V8 property attribute values.
  TCefV8PropertyAttribute = (
    V8_PROPERTY_ATTRIBUTE_NONE       = 0,       // Writeable, Enumerable, Configurable
    V8_PROPERTY_ATTRIBUTE_READONLY   = 1 shl 0, // Not writeable
    V8_PROPERTY_ATTRIBUTE_DONTENUM   = 1 shl 1, // Not enumerable
    V8_PROPERTY_ATTRIBUTE_DONTDELETE = 1 shl 2  // Not configurable
  );
  TCefV8PropertyAttributes = set of TCefV8PropertyAttribute;

  // Post data elements may represent either bytes or files.
  TCefPostDataElementType = (
    PDE_TYPE_EMPTY  = 0,
    PDE_TYPE_BYTES,
    PDE_TYPE_FILE
  );

  // Resource type for a request.
  TCefResourceType = (
    // Top level page.
    RT_MAIN_FRAME = 0,

    // Frame or iframe.
    RT_SUB_FRAME,

    // CSS stylesheet.
    RT_STYLESHEET,

    // External script.
    RT_SCRIPT,

    // Image (jpg/gif/png/etc).
    RT_IMAGE,

    // Font.
    RT_FONT_RESOURCE,

    // Some other subresource. This is the default type if the actual type is
    // unknown.
    RT_SUB_RESOURCE,

    // Object (or embed) tag for a plugin, or a resource that a plugin requested.
    RT_OBJECT,

    // Media resource.
    RT_MEDIA,

    // Main resource of a dedicated worker.
    RT_WORKER,

    // Main resource of a shared worker.
    RT_SHARED_WORKER,

    // Explicitly requested prefetch.
    RT_PREFETCH,

    // Favicon.
    RT_FAVICON,

    // XMLHttpRequest.
    RT_XHR
  );

  // Transition type for a request. Made up of one source value and 0 or more
  // qualifiers.
  TCefTransitionType = (
    // Source is a link click or the JavaScript window.open function. This is
    // also the default value for requests like sub-resource loads that are not
    // navigations.
    TT_LINK = 0,


    // Source is some other "explicit" navigation action such as creating a new
    // browser or using the LoadURL function. This is also the default value
    // for navigations where the actual type is unknown.
    TT_EXPLICIT = 1,

    // Source is a subframe navigation. This is any content that is automatically
    // loaded in a non-toplevel frame. For example, if a page consists of several
    // frames containing ads, those ad URLs will have this transition type.
    // The user may not even realize the content in these pages is a separate
    // frame, so may not care about the URL.
    TT_AUTO_SUBFRAME = 3,

    // Source is a subframe navigation explicitly requested by the user that will
    // generate new navigation entries in the back/forward list. These are
    // probably more important than frames that were automatically loaded in
    // the background because the user probably cares about the fact that this
    // link was loaded.
    TT_MANUAL_SUBFRAME = 4,

    // Source is a form submission by the user. NOTE: In some situations
    // submitting a form does not result in this transition type. This can happen
    // if the form uses a script to submit the contents.
    TT_FORM_SUBMIT = 7,

    // Source is a "reload" of the page via the Reload function or by re-visiting
    // the same URL. NOTE: This is distinct from the concept of whether a
    // particular load uses "reload semantics" (i.e. bypasses cached data).
    TT_RELOAD = 8,

    // General mask defining the bits used for the source values.
    TT_SOURCE_MASK = $FF,

    // Qualifiers.
    // Any of the core values above can be augmented by one or more qualifiers.
    // These qualifiers further define the transition.

    // Attempted to visit a URL but was blocked.
    TT_BLOCKED_FLAG = $00800000,

    // Used the Forward or Back function to navigate among browsing history.
    TT_FORWARD_BACK_FLAG = $01000000,

    // The beginning of a navigation chain.
    TT_CHAIN_START_FLAG = $10000000,

    // The last transition in a redirect chain.
    TT_CHAIN_END_FLAG = $20000000,

    // Redirects caused by JavaScript or a meta refresh tag on the page.
    TT_CLIENT_REDIRECT_FLAG = $40000000,

    // Redirects sent from the server by HTTP headers.
    TT_SERVER_REDIRECT_FLAG = $80000000,

    // Used to test whether a transition involves a redirect.
    TT_IS_REDIRECT_MASK = $C0000000,

    // General mask defining the bits used for the qualifiers.
    TT_QUALIFIER_MASK = $FFFFFF00
  );

  // Flags used to customize the behavior of CefURLRequest.
  TCefUrlRequestFlag = (
    // Default behavior.
    UR_FLAG_NONE                      = 0,
    // If set the cache will be skipped when handling the request.
    UR_FLAG_SKIP_CACHE                = 1 shl 0,
    // If set user name, password, and cookies may be sent with the request.
    UR_FLAG_ALLOW_CACHED_CREDENTIALS  = 1 shl 1,
    // If set cookies may be sent with the request and saved from the response.
    // UR_FLAG_ALLOW_CACHED_CREDENTIALS must also be set.
    UR_FLAG_ALLOW_COOKIES             = 1 shl 2,
    // If set upload progress events will be generated when a request has a body.
    UR_FLAG_REPORT_UPLOAD_PROGRESS    = 1 shl 3,
    // If set load timing info will be collected for the request.
    UR_FLAG_REPORT_LOAD_TIMING        = 1 shl 4,
    // If set the headers sent and received for the request will be recorded.
    UR_FLAG_REPORT_RAW_HEADERS        = 1 shl 5,
    // If set the CefURLRequestClient::OnDownloadData method will not be called.
    UR_FLAG_NO_DOWNLOAD_DATA          = 1 shl 6,
    // If set 5XX redirect errors will be propagated to the observer instead of
    // automatically re-tried. This currently only applies for requests
    // originated in the browser process.
    UR_FLAG_NO_RETRY_ON_5XX           = 1 shl 7
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

  // Screen information used when window rendering is disabled. This structure is
  // passed as a parameter to CefRenderHandler::GetScreenInfo and should be filled
  // in by the client.
  PCefScreenInfo = ^TCefScreenInfo;
  TCefScreenInfo = record
    // Device scale factor. Specifies the ratio between physical and logical
    // pixels.
    device_scale_factor: Single;

    // The screen depth in bits per pixel.
    depth: Integer;

    // The bits per color component. This assumes that the colors are balanced
    // equally.
    depth_per_component: Integer;

    // This can be true for black and white printers.
    is_monochrome: Boolean;

    // This is set from the rcMonitor member of MONITORINFOEX, to whit:
    //   "A RECT structure that specifies the display monitor rectangle,
    //   expressed in virtual-screen coordinates. Note that if the monitor
    //   is not the primary display monitor, some of the rectangle's
    //   coordinates may be negative values."
    //
    // The |rect| and |available_rect| properties are used to determine the
    // available surface for rendering popup views.
    rect: TCefRect;

    // This is set from the rcWork member of MONITORINFOEX, to whit:
    //   "A RECT structure that specifies the work area rectangle of the
    //   display monitor that can be used by applications, expressed in
    //   virtual-screen coordinates. Windows uses this rectangle to
    //   maximize an application on the monitor. The rest of the area in
    //   rcMonitor contains system windows such as the task bar and side
    //   bars. Note that if the monitor is not the primary display monitor,
    //   some of the rectangle's coordinates may be negative values".
    //
    // The |rect| and |available_rect| properties are used to determine the
    // available surface for rendering popup views.
    available_rect: TCefRect;
  end;


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
    MBT_LEFT = 0,
    MBT_MIDDLE,
    MBT_RIGHT
  );

  // Paint element types.
  TCefPaintElementType = (
    PET_VIEW = 0,
    PET_POPUP
  );

  // Supported event bit flags.
  TCefEventFlag = (
    EVENTFLAG_NONE                = 0,
    EVENTFLAG_CAPS_LOCK_ON,        //= 1 shl 0,
    EVENTFLAG_SHIFT_DOWN,          //= 1 shl 1,
    EVENTFLAG_CONTROL_DOWN,        //= 1 shl 2,
    EVENTFLAG_ALT_DOWN,            //= 1 shl 3,
    EVENTFLAG_LEFT_MOUSE_BUTTON,   //= 1 shl 4,
    EVENTFLAG_MIDDLE_MOUSE_BUTTON, //= 1 shl 5,
    EVENTFLAG_RIGHT_MOUSE_BUTTON,  //= 1 shl 6,
    // Mac OS-X command key.
    EVENTFLAG_COMMAND_DOWN,        //= 1 shl 7,
    EVENTFLAG_NUM_LOCK_ON,         //= 1 shl 8,
    EVENTFLAG_IS_KEY_PAD,          //= 1 shl 9,
    EVENTFLAG_IS_LEFT,             //= 1 shl 10,
    EVENTFLAG_IS_RIGHT             //= 1 shl 11
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
    CM_TYPEFLAG_NONE        = 0,
    // The top page is selected.
    CM_TYPEFLAG_PAGE        = 1 shl 0,
    // A subframe page is selected.
    CM_TYPEFLAG_FRAME       = 1 shl 1,
    // A link is selected.
    CM_TYPEFLAG_LINK        = 1 shl 2,
    // A media node is selected.
    CM_TYPEFLAG_MEDIA       = 1 shl 3,
    // There is a textual or mixed selection that is selected.
    CM_TYPEFLAG_SELECTION   = 1 shl 4,
    // An editable element is selected.
    CM_TYPEFLAG_EDITABLE    = 1 shl 5
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
    CM_MEDIAFLAG_NONE                  = 0,
    CM_MEDIAFLAG_ERROR,                 //= 1 shl 0,
    CM_MEDIAFLAG_PAUSED,                //= 1 shl 1,
    CM_MEDIAFLAG_MUTED,                 //= 1 shl 2,
    CM_MEDIAFLAG_LOOP,                  //= 1 shl 3,
    CM_MEDIAFLAG_CAN_SAVE,              //= 1 shl 4,
    CM_MEDIAFLAG_HAS_AUDIO,             //= 1 shl 5,
    CM_MEDIAFLAG_HAS_VIDEO,             //= 1 shl 6,
    CM_MEDIAFLAG_CONTROL_ROOT_ELEMENT,  //= 1 shl 7,
    CM_MEDIAFLAG_CAN_PRINT,             //= 1 shl 8,
    CM_MEDIAFLAG_CAN_ROTATE            //= 1 shl 9
  );
  TCefContextMenuMediaStateFlags = set of TCefContextMenuMediaStateFlag;

  // Supported context menu edit state bit flags.
  TCefContextMenuEditStateFlag = (
    CM_EDITFLAG_NONE            = 0,
    CM_EDITFLAG_CAN_UNDO        = 1 shl 0,
    CM_EDITFLAG_CAN_REDO        = 1 shl 1,
    CM_EDITFLAG_CAN_CUT         = 1 shl 2,
    CM_EDITFLAG_CAN_COPY        = 1 shl 3,
    CM_EDITFLAG_CAN_PASTE       = 1 shl 4,
    CM_EDITFLAG_CAN_DELETE      = 1 shl 5,
    CM_EDITFLAG_CAN_SELECT_ALL  = 1 shl 6,
    CM_EDITFLAG_CAN_TRANSLATE   = 1 shl 7
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
    character: Char16;

    // Same as |character| but unmodified by any concurrently-held modifiers
    // (except shift). This is useful for working out shortcut keys.
    unmodified_character: Char16;

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
    NAVIGATION_LINK_CLICKED = 0,
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

Const
  DOM_EVENT_CATEGORY_UNKNOWN                 = $0;
  DOM_EVENT_CATEGORY_UI                      = $1;
  DOM_EVENT_CATEGORY_MOUSE                   = $2;
  DOM_EVENT_CATEGORY_MUTATION                = $4;
  DOM_EVENT_CATEGORY_KEYBOARD                = $8;
  DOM_EVENT_CATEGORY_TEXT                    = $10;
  DOM_EVENT_CATEGORY_COMPOSITION             = $20;
  DOM_EVENT_CATEGORY_DRAG                    = $40;
  DOM_EVENT_CATEGORY_CLIPBOARD               = $80;
  DOM_EVENT_CATEGORY_MESSAGE                 = $100;
  DOM_EVENT_CATEGORY_WHEEL                   = $200;
  DOM_EVENT_CATEGORY_BEFORE_TEXT_INSERTED    = $400;
  DOM_EVENT_CATEGORY_OVERFLOW                = $800;
  DOM_EVENT_CATEGORY_PAGE_TRANSITION         = $1000;
  DOM_EVENT_CATEGORY_POPSTATE                = $2000;
  DOM_EVENT_CATEGORY_PROGRESS                = $4000;
  DOM_EVENT_CATEGORY_XMLHTTPREQUEST_PROGRESS = $8000;
  DOM_EVENT_CATEGORY_BEFORE_LOAD             = $10000;

Type
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
    FILE_DIALOG_OPEN = 0,

    // Like Open, but allows picking multiple files to open.
    FILE_DIALOG_OPEN_MULTIPLE,

    // Allows picking a nonexistent file, and prompts to overwrite if the file
    // already exists.
    FILE_DIALOG_SAVE
  );

  // Geoposition error codes.
  TCefGeopositionErrorCode = (
    GEOPOSITON_ERROR_NONE = 0,
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

  // Callbacks
  TGetDataResource = function(resourceId: Integer; out data: Pointer; out dataSize: TSize): Boolean;
  TGetLocalizedString = function(messageId: Integer; out stringVal: ustring): Boolean;
  TCefWebPluginIsUnstableProc = procedure(const path: ustring; unstable: Boolean);

Implementation

function CefColorGetA(color : TCefColor) : Byte;
begin
  Result := (color shr 24) and $FF;
end;

function CefColorGetR(color : TCefColor) : Byte;
begin
  Result := (color shr 16) and $FF;
end;

function CefColorGetG(color : TCefColor) : Byte;
begin
  Result := (color shr 8) and $FF;
end;

function CefColorGetB(color : TCefColor) : Byte;
begin
  Result := (color shr 0) and $FF;
end;

function CefColorSetARGB(a, r, g, b : Byte) : TCefColor;
begin
  Result := (a shl 24) or (r shl 16) or (g shl 8) or (b shl 0);
end;

end.
