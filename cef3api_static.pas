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
 *)

Unit cef3api_static;

{$mode objfpc}{$H+}

Interface

Uses
  cef3lib;

{$IFDEF WINDOWS}
  {$DEFINE DYNLINK}
{$ENDIF}

{$IF Defined(DYNLINK)}
Const
{$IF Defined(WINDOWS)}
  ceflib = 'libcef.dll';
{$ELSEIF Defined(UNIX)}
  ceflib = 'libcef.so';
{$ELSE}
  {$MESSAGE ERROR 'DYNLINK not supported'}
{$IFEND}
{$ELSEIF Defined(Darwin)}
  {$linkframework cef}
{$ELSE}
  {$LINKLIB cef}
{$ENDIF}

// These functions set string values. If |copy| is true (1) the value will be
// copied instead of referenced. It is up to the user to properly manage
// the lifespan of references.
//function cef_string_wide_set(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide; copy: Integer): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_utf8_set(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8; copy: Integer): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_utf16_set(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16; copy: Integer): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_set(const src: PCefChar; src_len: Cardinal; output: PCefString; copy: Integer): Integer;


// These functions clear string values. The structure itself is not freed.
//procedure cef_string_wide_clear(str: PCefStringWide); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//procedure cef_string_utf8_clear(str: PCefStringUtf8); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
procedure cef_string_utf16_clear(str: PCefStringUtf16); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
procedure cef_string_clear(str: PCefString);


// These functions compare two string values with the same results as strcmp().
//function cef_string_wide_cmp(const str1, str2: PCefStringWide): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_utf8_cmp(const str1, str2: PCefStringUtf8): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_utf16_cmp(const str1, str2: PCefStringUtf16): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};


// These functions convert between UTF-8, -16, and -32 strings. They are
// potentially slow so unnecessary conversions should be avoided. The best
// possible result will always be written to |output| with the boolean return
// value indicating whether the conversion is 100% valid.
//function cef_string_wide_to_utf8(const src: PWideChar; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_utf8_to_wide(const src: PAnsiChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

function cef_string_wide_to_utf16(const src: PWideChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_utf16_to_wide(const src: PChar16; src_len: Cardinal; output: PCefStringWide): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

function cef_string_utf8_to_utf16(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_utf16_to_utf8(const src: PChar16; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

function cef_string_from_utf8(const src: PAnsiChar; src_len: Cardinal; output: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_from_utf16(const src: PChar16; src_len: Cardinal; output: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_from_wide(const src: PWideChar; src_len: Cardinal; output: PCefString): Integer;
//function cef_string_to_utf8(const src: PCefChar; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_to_utf16(const src: PCefChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_to_wide(const src: PCefChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};


// These functions convert an ASCII string, typically a hardcoded constant, to a
// Wide/UTF16 string. Use instead of the UTF8 conversion routines if you know
// the string is ASCII.
//function cef_string_ascii_to_wide(const src: PAnsiChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_ascii_to_utf16(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_from_ascii(const src: PAnsiChar; src_len: Cardinal; output: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};


// These functions allocate a new string structure. They must be freed by
// calling the associated free function.
//function cef_string_userfree_wide_alloc(): PCefStringUserFreeWide; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_userfree_utf8_alloc(): PCefStringUserFreeUtf8; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_userfree_utf16_alloc(): PCefStringUserFreeUtf16; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_userfree_alloc(): PCefStringUserFree;


// These functions free the string structure allocated by the associated
// alloc function. Any string contents will first be cleared.
//procedure cef_string_userfree_wide_free(str: PCefStringUserFreeWide); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//procedure cef_string_userfree_utf8_free(str: PCefStringUserFreeUtf8); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
procedure cef_string_userfree_utf16_free(str: PCefStringUserFreeUtf16); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
procedure cef_string_userfree_free(str: PCefStringUserFree);

{

// Convenience macros for copying values.
function cef_string_wide_copy(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide): Integer;
begin
  Result := cef_string_wide_set(src, src_len, output, ord(True))
end;

function cef_string_utf8_copy(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8): Integer;
begin
  Result := cef_string_utf8_set(src, src_len, output, ord(True))
end;

function cef_string_utf16_copy(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16): Integer;
begin
  Result := cef_string_utf16_set(src, src_len, output, ord(True))
end;

function cef_string_copy(const src: PCefChar; src_len: Cardinal; output: PCefString): Integer;
begin
  Result := cef_string_set(src, src_len, output, ord(True));
end;

}

// Create a new browser window using the window parameters specified by
// |windowInfo|. All values will be copied internally and the actual window will
// be created on the UI thread. This function can be called on any browser
// process thread and will not block.
function cef_browser_host_create_browser(
    const windowInfo: PCefWindowInfo; client: PCefClient;
    const url: PCefString; const settings: PCefBrowserSettings): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new browser window using the window parameters specified by
// |windowInfo|. This function can only be called on the browser process UI
// thread.
function cef_browser_host_create_browser_sync(
    const windowInfo: PCefWindowInfo; client: PCefClient;
    const url: PCefString; const settings: PCefBrowserSettings): PCefBrowser; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Perform a single iteration of CEF message loop processing. This function is
// used to integrate the CEF message loop into an existing application message
// loop. Care must be taken to balance performance against excessive CPU usage.
// This function should only be called on the main application thread and only
// if cef_initialize() is called with a CefSettings.multi_threaded_message_loop
// value of false (0). This function will not block.
procedure cef_do_message_loop_work(); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Run the CEF message loop. Use this function instead of an application-
// provided message loop to get the best balance between performance and CPU
// usage. This function should only be called on the main application thread and
// only if cef_initialize() is called with a
// CefSettings.multi_threaded_message_loop value of false (0). This function
// will block until a quit message is received by the system.
procedure cef_run_message_loop; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Quit the CEF message loop that was started by calling cef_run_message_loop().
// This function should only be called on the main application thread and only
// if cef_run_message_loop() was used.
procedure cef_quit_message_loop; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// This function should be called from the application entry point function to
// execute a secondary process. It can be used to run secondary processes from
// the browser client executable (default behavior) or from a separate
// executable specified by the CefSettings.browser_subprocess_path value. If
// called for the browser process (identified by no "type" command-line value)
// it will return immediately with a value of -1. If called for a recognized
// secondary process it will block until the process should exit and then return
// the process exit code. The |application| parameter may be NULL.
function cef_execute_process(const args: PCefMainArgs; application: PCefApp): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// This function should be called on the main application thread to initialize
// the CEF browser process. The |application| parameter may be NULL. A return
// value of true (1) indicates that it succeeded and false (0) indicates that it
// failed.
function cef_initialize(const args: PCefMainArgs; const settings: PCefSettings; application: PCefApp): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// This function should be called on the main application thread to shut down
// the CEF browser process before the application exits.
procedure cef_shutdown(); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Allocate a new string map.
function cef_string_map_alloc(): TCefStringMap; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
//function cef_string_map_size(map: TCefStringMap): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
function cef_string_map_size(map: TCefStringMap): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Return the value assigned to the specified key.
function cef_string_map_find(map: TCefStringMap; const key: PCefString; var value: TCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Return the key at the specified zero-based string map index.
function cef_string_map_key(map: TCefStringMap; index: Integer; var key: TCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Return the value at the specified zero-based string map index.
function cef_string_map_value(map: TCefStringMap; index: Integer; var value: TCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Append a new key/value pair at the end of the string map.
function cef_string_map_append(map: TCefStringMap; const key, value: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Clear the string map.
procedure cef_string_map_clear(map: TCefStringMap); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Free the string map.
procedure cef_string_map_free(map: TCefStringMap); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Allocate a new string map.
function cef_string_list_alloc(): TCefStringList; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Return the number of elements in the string list.
function cef_string_list_size(list: TCefStringList): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Retrieve the value at the specified zero-based string list index. Returns
// true (1) if the value was successfully retrieved.
function cef_string_list_value(list: TCefStringList; index: Integer; value: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Append a new value at the end of the string list.
procedure cef_string_list_append(list: TCefStringList; const value: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Clear the string list.
procedure cef_string_list_clear(list: TCefStringList); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Free the string list.
procedure cef_string_list_free(list: TCefStringList); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Creates a copy of an existing string list.
function cef_string_list_copy(list: TCefStringList): TCefStringList; external {$IFDEF DYNLINK}ceflib{$ENDIF};


// Register a new V8 extension with the specified JavaScript extension code and
// handler. Functions implemented by the handler are prototyped using the
// keyword 'native'. The calling of a native function is restricted to the scope
// in which the prototype of the native function is defined. This function may
// only be called on the render process main thread.
//
// Example JavaScript extension code:
//
//   // create the 'example' global object if it doesn't already exist.
//   if (!example)
//     example = {};
//   // create the 'example.test' global object if it doesn't already exist.
//   if (!example.test)
//     example.test = {};
//   (function() {
//     // Define the function 'example.test.myfunction'.
//     example.test.myfunction = function() {
//       // Call CefV8Handler::Execute() with the function name 'MyFunction'
//       // and no arguments.
//       native function MyFunction();
//       return MyFunction();
//     };
//     // Define the getter function for parameter 'example.test.myparam'.
//     example.test.__defineGetter__('myparam', function() {
//       // Call CefV8Handler::Execute() with the function name 'GetMyParam'
//       // and no arguments.
//       native function GetMyParam();
//       return GetMyParam();
//     });
//     // Define the setter function for parameter 'example.test.myparam'.
//     example.test.__defineSetter__('myparam', function(b) {
//       // Call CefV8Handler::Execute() with the function name 'SetMyParam'
//       // and a single argument.
//       native function SetMyParam();
//       if(b) SetMyParam(b);
//     });
//
//     // Extension definitions can also contain normal JavaScript variables
//     // and functions.
//     var myint = 0;
//     example.test.increment = function() {
//       myint += 1;
//       return myint;
//     };
//   })();
//
// Example usage in the page:
//
//   // Call the function.
//   example.test.myfunction();
//   // Set the parameter.
//   example.test.myparam = value;
//   // Get the parameter.
//   value = example.test.myparam;
//   // Call another function.
//   example.test.increment();
//
function cef_register_extension(const extension_name,
  javascript_code: PCefString; handler: PCefv8Handler): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Register a scheme handler factory for the specified |scheme_name| and
// optional |domain_name|. An NULL |domain_name| value for a standard scheme
// will cause the factory to match all domain names. The |domain_name| value
// will be ignored for non-standard schemes. If |scheme_name| is a built-in
// scheme and no handler is returned by |factory| then the built-in scheme
// handler factory will be called. If |scheme_name| is a custom scheme the
// CefRegisterCustomScheme() function should be called for that scheme. This
// function may be called multiple times to change or remove the factory that
// matches the specified |scheme_name| and optional |domain_name|. Returns false
// (0) if an error occurs. This function may be called on any thread.
function cef_register_scheme_handler_factory(
    const scheme_name, domain_name: PCefString;
    factory: PCefSchemeHandlerFactory): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Clear all registered scheme handler factories. Returns false (0) on error.
// This function may be called on any thread.
function cef_clear_scheme_handler_factories: Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Add an entry to the cross-origin access whitelist.
//
// The same-origin policy restricts how scripts hosted from different origins
// (scheme + domain + port) can communicate. By default, scripts can only access
// resources with the same origin. Scripts hosted on the HTTP and HTTPS schemes
// (but no other schemes) can use the "Access-Control-Allow-Origin" header to
// allow cross-origin requests. For example, https://source.example.com can make
// XMLHttpRequest requests on http://target.example.com if the
// http://target.example.com request returns an "Access-Control-Allow-Origin:
// https://source.example.com" response header.
//
// Scripts in separate frames or iframes and hosted from the same protocol and
// domain suffix can execute cross-origin JavaScript if both pages set the
// document.domain value to the same domain suffix. For example,
// scheme://foo.example.com and scheme://bar.example.com can communicate using
// JavaScript if both domains set document.domain="example.com".
//
// This function is used to allow access to origins that would otherwise violate
// the same-origin policy. Scripts hosted underneath the fully qualified
// |source_origin| URL (like http://www.example.com) will be allowed access to
// all resources hosted on the specified |target_protocol| and |target_domain|.
// If |target_domain| is non-NULL and |allow_target_subdomains| if false (0)
// only exact domain matches will be allowed. If |target_domain| is non-NULL and
// |allow_target_subdomains| is true (1) sub-domain matches will be allowed. If
// |target_domain| is NULL and |allow_target_subdomains| if true (1) all domains
// and IP addresses will be allowed.
//
// This function cannot be used to bypass the restrictions on local or display
// isolated schemes. See the comments on CefRegisterCustomScheme for more
// information.
//
// This function may be called on any thread. Returns false (0) if
// |source_origin| is invalid or the whitelist cannot be accessed.
function cef_add_cross_origin_whitelist_entry(const source_origin, target_protocol,
  target_domain: PCefString; allow_target_subdomains: Integer): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Remove an entry from the cross-origin access whitelist. Returns false (0) if
// |source_origin| is invalid or the whitelist cannot be accessed.
function cef_remove_cross_origin_whitelist_entry(
    const source_origin, target_protocol, target_domain: PCefString;
    allow_target_subdomains: Integer): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Remove all entries from the cross-origin access whitelist. Returns false (0)
// if the whitelist cannot be accessed.
function cef_clear_cross_origin_whitelist: Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns true (1) if called on the specified thread. Equivalent to using
// cef_task_runner_t::GetForThread(threadId)->belongs_to_current_thread().
function cef_currently_on(threadId: TCefThreadId): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Post a task for execution on the specified thread. Equivalent to using
// cef_task_runner_t::GetForThread(threadId)->PostTask(task).
function cef_post_task(threadId: TCefThreadId; task: PCefTask): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Post a task for delayed execution on the specified thread. Equivalent to
// using cef_task_runner_t::GetForThread(threadId)->PostDelayedTask(task,
// delay_ms).
function cef_post_delayed_task(threadId: TCefThreadId;
    task: PCefTask; delay_ms: Int64): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Parse the specified |url| into its component parts. Returns false (0) if the
// URL is NULL or invalid.
function cef_parse_url(const url: PCefString; var parts: TCefUrlParts): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Creates a URL from the specified |parts|, which must contain a non-NULL spec
// or a non-NULL host and path (at a minimum), but not both. Returns false (0)
// if |parts| isn't initialized as described.
function cef_create_url(parts: PCefUrlParts; url: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new TCefRequest object.
function cef_request_create(): PCefRequest; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new TCefPostData object.
function cef_post_data_create(): PCefPostData; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_post_data_Element object.
function cef_post_data_element_create(): PCefPostDataElement; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_stream_reader_t object from a file.
function cef_stream_reader_create_for_file(const fileName: PCefString): PCefStreamReader; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_stream_reader_t object from data.
function cef_stream_reader_create_for_data(data: Pointer; size: Cardinal): PCefStreamReader; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_stream_reader_t object from a custom handler.
function cef_stream_reader_create_for_handler(handler: PCefReadHandler): PCefStreamReader; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_stream_writer_t object for a file.
function cef_stream_writer_create_for_file(const fileName: PCefString): PCefStreamWriter; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_stream_writer_t object for a custom handler.
function cef_stream_writer_create_for_handler(handler: PCefWriteHandler): PCefStreamWriter; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the current (top) context object in the V8 context stack.
function cef_v8context_get_current_context(): PCefv8Context; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the entered (bottom) context object in the V8 context stack.
function cef_v8context_get_entered_context(): PCefv8Context; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns true (1) if V8 is currently inside a context.
function cef_v8context_in_context(): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_v8value_t object of type undefined.
function cef_v8value_create_undefined(): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type null.
function cef_v8value_create_null(): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type bool.
function cef_v8value_create_bool(value: Integer): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type int.
function cef_v8value_create_int(value: Integer): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type unsigned int.
function cef_v8value_create_uint(value: Cardinal): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type double.
function cef_v8value_create_double(value: Double): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type Date. This function should only be
// called from within the scope of a cef_v8context_tHandler, cef_v8handler_t or
// cef_v8accessor_t callback, or in combination with calling enter() and exit()
// on a stored cef_v8context_t reference.
function cef_v8value_create_date(const value: PCefTime): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type string.
function cef_v8value_create_string(const value: PCefString): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_v8value_t object of type object with optional accessor. This
// function should only be called from within the scope of a
// cef_v8context_tHandler, cef_v8handler_t or cef_v8accessor_t callback, or in
// combination with calling enter() and exit() on a stored cef_v8context_t
// reference.
function cef_v8value_create_object(accessor: PCefV8Accessor): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type array with the specified |length|.
// If |length| is negative the returned array will have length 0. This function
// should only be called from within the scope of a cef_v8context_tHandler,
// cef_v8handler_t or cef_v8accessor_t callback, or in combination with calling
// enter() and exit() on a stored cef_v8context_t reference.
function cef_v8value_create_array(length: Integer): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};
// Create a new cef_v8value_t object of type function.
function cef_v8value_create_function(const name: PCefString; handler: PCefv8Handler): PCefv8Value; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the stack trace for the currently active context. |frame_limit| is
// the maximum number of frames that will be captured.
function cef_v8stack_trace_get_current(frame_limit: Integer): PCefV8StackTrace; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_xml_reader_t object. The returned object's functions can
// only be called from the thread that created the object.
function cef_xml_reader_create(stream: PCefStreamReader;
  encodingType: TCefXmlEncodingType; const URI: PCefString): PCefXmlReader; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_zip_reader_t object. The returned object's functions can
// only be called from the thread that created the object.
function cef_zip_reader_create(stream: PCefStreamReader): PCefZipReader; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Allocate a new string multimap.
function cef_string_multimap_alloc: TCefStringMultimap; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Return the number of elements in the string multimap.
function cef_string_multimap_size(map: TCefStringMultimap): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Return the number of values with the specified key.
function cef_string_multimap_find_count(map: TCefStringMultimap; const key: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Return the value_index-th value with the specified key.
function cef_string_multimap_enumerate(map: TCefStringMultimap;
  const key: PCefString; value_index: Integer; var value: TCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Return the key at the specified zero-based string multimap index.
function cef_string_multimap_key(map: TCefStringMultimap; index: Integer; var key: TCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Return the value at the specified zero-based string multimap index.
function cef_string_multimap_value(map: TCefStringMultimap; index: Integer; var value: TCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Append a new key/value pair at the end of the string multimap.
function cef_string_multimap_append(map: TCefStringMultimap; const key, value: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Clear the string multimap.
procedure cef_string_multimap_clear(map: TCefStringMultimap); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Free the string multimap.
procedure cef_string_multimap_free(map: TCefStringMultimap); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

function cef_build_revision: Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the global cookie manager. By default data will be stored at
// CefSettings.cache_path if specified or in memory otherwise.
function cef_cookie_manager_get_global_manager(): PCefCookieManager; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Creates a new cookie manager. If |path| is NULL data will be stored in memory
// only. Returns NULL if creation fails.
function cef_cookie_manager_create_manager(const path: PCefString): PCefCookieManager; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_command_line_t instance.
function cef_command_line_create(): PCefCommandLine; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the singleton global cef_command_line_t object. The returned object
// will be read-only.
function cef_command_line_get_global(): PCefCommandLine; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};


// Create a new cef_process_message_t object with the specified name.
function cef_process_message_create(const name: PCefString): PCefProcessMessage; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Creates a new object that is not owned by any other object. The specified
// |data| will be copied.
function cef_binary_value_create(const data: Pointer; data_size: Cardinal): PCefBinaryValue; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Creates a new object that is not owned by any other object.
function cef_dictionary_value_create: PCefDictionaryValue; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Creates a new object that is not owned by any other object.
function cef_list_value_create: PCefListValue; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Retrieve the path associated with the specified |key|. Returns true (1) on
// success. Can be called on any thread in the browser process.
function cef_get_path(key: TCefPathKey; path: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Launches the process specified via |command_line|. Returns true (1) upon
// success. Must be called on the browser process TID_PROCESS_LAUNCHER thread.
//
// Unix-specific notes: - All file descriptors open in the parent process will
// be closed in the
//   child process except for stdin, stdout, and stderr.
// - If the first argument on the command line does not contain a slash,
//   PATH will be searched. (See man execvp.)
function cef_launch_process(command_line: PCefCommandLine): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new cef_response_t object.
function cef_response_create: PCefResponse; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Create a new URL request. Only GET, POST, HEAD, DELETE and PUT request
// functions are supported. The |request| object will be marked as read-only
// after calling this function.
function cef_urlrequest_create(request: PCefRequest; client: PCefUrlRequestClient): PCefUrlRequest; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Visit web plugin information.
procedure cef_visit_web_plugin_info(visitor: PCefWebPluginInfoVisitor); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Cause the plugin list to refresh the next time it is accessed regardless of
// whether it has already been loaded. Can be called on any thread in the
// browser process.
procedure cef_refresh_web_plugins; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Add a plugin path (directory + file). This change may not take affect until
// after cef_refresh_web_plugins() is called. Can be called on any thread in the
// browser process.
procedure cef_add_web_plugin_path(const path: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Add a plugin directory. This change may not take affect until after
// cef_refresh_web_plugins() is called. Can be called on any thread in the
// browser process.
procedure cef_add_web_plugin_directory(const dir: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Remove a plugin path (directory + file). This change may not take affect
// until after cef_refresh_web_plugins() is called. Can be called on any thread
// in the browser process.
procedure cef_remove_web_plugin_path(const path: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Unregister an internal plugin. This may be undone the next time
// cef_refresh_web_plugins() is called. Can be called on any thread in the
// browser process.
procedure cef_unregister_internal_web_plugin(const path: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Force a plugin to shutdown. Can be called on any thread in the browser
// process but will be executed on the IO thread.
procedure cef_force_web_plugin_shutdown(const path: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Register a plugin crash. Can be called on any thread in the browser process
// but will be executed on the IO thread.
procedure cef_register_web_plugin_crash(const path: PCefString); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Query if a plugin is unstable. Can be called on any thread in the browser
// process.
procedure cef_is_web_plugin_unstable(const path: PCefString;
  callback: PCefWebPluginUnstableCallback); cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Request a one-time geolocation update. This function bypasses any user
// permission checks so should only be used by code that is allowed to access
// location information.
function cef_get_geolocation(callback: PCefGetGeolocationCallback): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the task runner for the current thread. Only CEF threads will have
// task runners. An NULL reference will be returned if this function is called
// on an invalid thread.
function cef_task_runner_get_for_current_thread: PCefTaskRunner; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Returns the task runner for the specified CEF thread.
function cef_task_runner_get_for_thread(threadId: TCefThreadId): PCefTaskRunner; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};



// Start tracing events on all processes. Tracing begins immediately locally,
// and asynchronously on child processes as soon as they receive the
// BeginTracing request.
//
// If CefBeginTracing was called previously, or if a CefEndTracingAsync call is
// pending, CefBeginTracing will fail and return false (0).
//
// |categories| is a comma-delimited list of category wildcards. A category can
// have an optional '-' prefix to make it an excluded category. Having both
// included and excluded categories in the same list is not supported.
//
// Example: "test_MyTest*" Example: "test_MyTest*,test_OtherStuff" Example:
// "-excluded_category1,-excluded_category2"
//
// This function must be called on the browser process UI thread.
function cef_begin_tracing(client: PCefTraceClient; const categories: PCefString): Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Get the maximum trace buffer percent full state across all processes.
//
// cef_trace_client_t::OnTraceBufferPercentFullReply will be called
// asynchronously after the value is determibed. When any child process reaches
// 100% full tracing will end automatically and
// cef_trace_client_t::OnEndTracingComplete will be called. This function fails
// and returns false (0) if trace is ending or disabled, no cef_trace_client_t
// was passed to CefBeginTracing, or if a previous call to
// CefGetTraceBufferPercentFullAsync is pending.
//
// This function must be called on the browser process UI thread.
function cef_get_trace_buffer_percent_full_async: Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

// Stop tracing events on all processes.
//
// This function will fail and return false (0) if a previous call to
// CefEndTracingAsync is already pending or if CefBeginTracing was not called.
//
// This function must be called on the browser process UI thread.
function cef_end_tracing_async: Integer; cdecl; external {$IFDEF DYNLINK}ceflib{$ENDIF};

{external {$IFDEF DYNLINK}ceflib{$ENDIF};}

Implementation

Uses Math;

function cef_string_set(const src : PCefChar; src_len : Cardinal; output : PCefString; copy : Integer) : Integer;
begin
  {$IFDEF CEF_STRING_TYPE_UTF16}
  Result := cef_string_set(src, src_len, output, copy);
  {$ENDIF}
end;

procedure cef_string_clear(str : PCefString);
begin
  {$IFDEF CEF_STRING_TYPE_UTF16}
  cef_string_utf16_clear(str);
  {$ENDIF}
end;

function cef_string_from_wide(const src : PWideChar; src_len : Cardinal; output : PCefString) : Integer;
begin
  {$IFDEF CEF_STRING_TYPE_UTF16}
  Result := cef_string_wide_to_utf16(src, src_len, output);
  {$ENDIF}
end;

function cef_string_userfree_alloc : PCefStringUserFree;
begin
  {$IFDEF CEF_STRING_TYPE_UTF16}
  Result := cef_string_userfree_utf16_alloc;
  {$ENDIF}
end;

procedure cef_string_userfree_free(str : PCefStringUserFree);
begin
  {$IFDEF CEF_STRING_TYPE_UTF16}
  cef_string_userfree_utf16_free(str);
  {$ENDIF}
end;

Initialization
  // Set exception masks
  Set8087CW(Get8087CW or $3F);
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

end.

