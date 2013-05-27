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

Unit cef3api;

{.$MODE objfpc}{$H+}
{$MODE Delphi}

{$I cef.inc}

Interface

Uses
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  {$IFDEF LINUX}Dynlibs,{$ENDIF}
  sysutils, LCLProc,
  cef3lib;

Var
  // These functions set string values. If |copy| is true (1) the value will be
  // copied instead of referenced. It is up to the user to properly manage
  // the lifespan of references.

  cef_string_wide_set: function(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide; copy: Integer): Integer; cdecl;
  cef_string_utf8_set: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8; copy: Integer): Integer; cdecl;
  cef_string_utf16_set: function(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16; copy: Integer): Integer; cdecl;
  cef_string_set: function(const src: PCefChar; src_len: Cardinal; output: PCefString; copy: Integer): Integer; cdecl;

  // These functions clear string values. The structure itself is not freed.

  cef_string_wide_clear: procedure(str: PCefStringWide); cdecl;
  cef_string_utf8_clear: procedure(str: PCefStringUtf8); cdecl;
  cef_string_utf16_clear: procedure(str: PCefStringUtf16); cdecl;
  cef_string_clear: procedure(str: PCefString); cdecl;

  // These functions compare two string values with the same results as strcmp().

  cef_string_wide_cmp: function(const str1, str2: PCefStringWide): Integer; cdecl;
  cef_string_utf8_cmp: function(const str1, str2: PCefStringUtf8): Integer; cdecl;
  cef_string_utf16_cmp: function(const str1, str2: PCefStringUtf16): Integer; cdecl;

  // These functions convert between UTF-8, -16, and -32 strings. They are
  // potentially slow so unnecessary conversions should be avoided. The best
  // possible result will always be written to |output| with the boolean return
  // value indicating whether the conversion is 100% valid.

  cef_string_wide_to_utf8: function(const src: PWideChar; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl;
  cef_string_utf8_to_wide: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;

  cef_string_wide_to_utf16: function (const src: PWideChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_wide: function(const src: PChar16; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;

  cef_string_utf8_to_utf16: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_utf8: function(const src: PChar16; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl;

  cef_string_to_utf8: function(const src: PCefChar; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl;
  cef_string_from_utf8: function(const src: PAnsiChar; src_len: Cardinal; output: PCefString): Integer; cdecl;
  cef_string_to_utf16: function(const src: PCefChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_from_utf16: function(const src: PChar16; src_len: Cardinal; output: PCefString): Integer; cdecl;
  cef_string_to_wide: function(const src: PCefChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;
  cef_string_from_wide: function(const src: PWideChar; src_len: Cardinal; output: PCefString): Integer; cdecl;

  // These functions convert an ASCII string, typically a hardcoded constant, to a
  // Wide/UTF16 string. Use instead of the UTF8 conversion routines if you know
  // the string is ASCII.

  cef_string_ascii_to_wide: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;
  cef_string_ascii_to_utf16: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_from_ascii: function(const src: PAnsiChar; src_len: Cardinal; output: PCefString): Integer; cdecl;

  // These functions allocate a new string structure. They must be freed by
  // calling the associated free function.

  cef_string_userfree_wide_alloc: function(): PCefStringUserFreeWide; cdecl;
  cef_string_userfree_utf8_alloc: function(): PCefStringUserFreeUtf8; cdecl;
  cef_string_userfree_utf16_alloc: function(): PCefStringUserFreeUtf16; cdecl;
  cef_string_userfree_alloc: function(): PCefStringUserFree; cdecl;

  // These functions free the string structure allocated by the associated
  // alloc function. Any string contents will first be cleared.

  cef_string_userfree_wide_free: procedure(str: PCefStringUserFreeWide); cdecl;
  cef_string_userfree_utf8_free: procedure(str: PCefStringUserFreeUtf8); cdecl;
  cef_string_userfree_utf16_free: procedure(str: PCefStringUserFreeUtf16); cdecl;
  cef_string_userfree_free: procedure(str: PCefStringUserFree); cdecl;

Var
  // Create a new browser window using the window parameters specified by
  // |windowInfo|. All values will be copied internally and the actual window will
  // be created on the UI thread. This function can be called on any browser
  // process thread and will not block.
  cef_browser_host_create_browser: function(
      const windowInfo: PCefWindowInfo; client: PCefClient;
      const url: PCefString; const settings: PCefBrowserSettings): Integer; cdecl;

  // Create a new browser window using the window parameters specified by
  // |windowInfo|. This function can only be called on the browser process UI
  // thread.
  cef_browser_host_create_browser_sync: function(
      const windowInfo: PCefWindowInfo; client: PCefClient;
      const url: PCefString; const settings: PCefBrowserSettings): PCefBrowser; cdecl;

  // Perform a single iteration of CEF message loop processing. This function is
  // used to integrate the CEF message loop into an existing application message
  // loop. Care must be taken to balance performance against excessive CPU usage.
  // This function should only be called on the main application thread and only
  // if cef_initialize() is called with a CefSettings.multi_threaded_message_loop
  // value of false (0). This function will not block.
  cef_do_message_loop_work: procedure(); cdecl;

  // Run the CEF message loop. Use this function instead of an application-
  // provided message loop to get the best balance between performance and CPU
  // usage. This function should only be called on the main application thread and
  // only if cef_initialize() is called with a
  // CefSettings.multi_threaded_message_loop value of false (0). This function
  // will block until a quit message is received by the system.
  cef_run_message_loop: procedure; cdecl;

  // Quit the CEF message loop that was started by calling cef_run_message_loop().
  // This function should only be called on the main application thread and only
  // if cef_run_message_loop() was used.
  cef_quit_message_loop: procedure; cdecl;

  // This function should be called from the application entry point function to
  // execute a secondary process. It can be used to run secondary processes from
  // the browser client executable (default behavior) or from a separate
  // executable specified by the CefSettings.browser_subprocess_path value. If
  // called for the browser process (identified by no "type" command-line value)
  // it will return immediately with a value of -1. If called for a recognized
  // secondary process it will block until the process should exit and then return
  // the process exit code. The |application| parameter may be NULL.
  cef_execute_process: function(const args: PCefMainArgs; application: PCefApp): Integer; cdecl;

  // This function should be called on the main application thread to initialize
  // the CEF browser process. The |application| parameter may be NULL. A return
  // value of true (1) indicates that it succeeded and false (0) indicates that it
  // failed.
  cef_initialize: function(const args: PCefMainArgs; const settings: PCefSettings; application: PCefApp): Integer; cdecl;

  // This function should be called on the main application thread to shut down
  // the CEF browser process before the application exits.
  cef_shutdown: procedure(); cdecl;

  // Allocate a new string map.
  cef_string_map_alloc: function(): TCefStringMap; cdecl;
  //function cef_string_map_size(map: TCefStringMap): Integer; cdecl;
  cef_string_map_size: function(map: TCefStringMap): Integer; cdecl;
  // Return the value assigned to the specified key.
  cef_string_map_find: function(map: TCefStringMap; const key: PCefString; var value: TCefString): Integer; cdecl;
  // Return the key at the specified zero-based string map index.
  cef_string_map_key: function(map: TCefStringMap; index: Integer; var key: TCefString): Integer; cdecl;
  // Return the value at the specified zero-based string map index.
  cef_string_map_value: function(map: TCefStringMap; index: Integer; var value: TCefString): Integer; cdecl;
  // Append a new key/value pair at the end of the string map.
  cef_string_map_append: function(map: TCefStringMap; const key, value: PCefString): Integer; cdecl;
  // Clear the string map.
  cef_string_map_clear: procedure(map: TCefStringMap); cdecl;
  // Free the string map.
  cef_string_map_free: procedure(map: TCefStringMap); cdecl;

  // Allocate a new string map.
  cef_string_list_alloc: function(): TCefStringList; cdecl;
  // Return the number of elements in the string list.
  cef_string_list_size: function(list: TCefStringList): Integer; cdecl;
  // Retrieve the value at the specified zero-based string list index. Returns
  // true (1) if the value was successfully retrieved.
  cef_string_list_value: function(list: TCefStringList; index: Integer; value: PCefString): Integer; cdecl;
  // Append a new value at the end of the string list.
  cef_string_list_append: procedure(list: TCefStringList; const value: PCefString); cdecl;
  // Clear the string list.
  cef_string_list_clear: procedure(list: TCefStringList); cdecl;
  // Free the string list.
  cef_string_list_free: procedure(list: TCefStringList); cdecl;
  // Creates a copy of an existing string list.
  cef_string_list_copy: function(list: TCefStringList): TCefStringList;


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
  cef_register_extension: function(const extension_name,
    javascript_code: PCefString; handler: PCefv8Handler): Integer; cdecl;

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
  cef_register_scheme_handler_factory: function(
      const scheme_name, domain_name: PCefString;
      factory: PCefSchemeHandlerFactory): Integer; cdecl;

  // Clear all registered scheme handler factories. Returns false (0) on error.
  // This function may be called on any thread.
  cef_clear_scheme_handler_factories: function: Integer; cdecl;

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

  cef_add_cross_origin_whitelist_entry: function(const source_origin, target_protocol,
    target_domain: PCefString; allow_target_subdomains: Integer): Integer; cdecl;

  // Remove an entry from the cross-origin access whitelist. Returns false (0) if
  // |source_origin| is invalid or the whitelist cannot be accessed.
  cef_remove_cross_origin_whitelist_entry: function(
      const source_origin, target_protocol, target_domain: PCefString;
      allow_target_subdomains: Integer): Integer; cdecl;

  // Remove all entries from the cross-origin access whitelist. Returns false (0)
  // if the whitelist cannot be accessed.
  cef_clear_cross_origin_whitelist: function: Integer; cdecl;

  // Returns true (1) if called on the specified thread. Equivalent to using
  // cef_task_runner_t::GetForThread(threadId)->belongs_to_current_thread().
  cef_currently_on: function(threadId: TCefThreadId): Integer; cdecl;

  // Post a task for execution on the specified thread. Equivalent to using
  // cef_task_runner_t::GetForThread(threadId)->PostTask(task).
  cef_post_task: function(threadId: TCefThreadId; task: PCefTask): Integer; cdecl;

  // Post a task for delayed execution on the specified thread. Equivalent to
  // using cef_task_runner_t::GetForThread(threadId)->PostDelayedTask(task,
  // delay_ms).
  cef_post_delayed_task: function(threadId: TCefThreadId;
      task: PCefTask; delay_ms: Int64): Integer; cdecl;

  // Parse the specified |url| into its component parts. Returns false (0) if the
  // URL is NULL or invalid.
  cef_parse_url: function(const url: PCefString; var parts: TCefUrlParts): Integer; cdecl;

  // Creates a URL from the specified |parts|, which must contain a non-NULL spec
  // or a non-NULL host and path (at a minimum), but not both. Returns false (0)
  // if |parts| isn't initialized as described.
  cef_create_url: function(parts: PCefUrlParts; url: PCefString): Integer; cdecl;

  // Create a new TCefRequest object.
  cef_request_create: function(): PCefRequest; cdecl;

  // Create a new TCefPostData object.
  cef_post_data_create: function(): PCefPostData; cdecl;

  // Create a new cef_post_data_Element object.
  cef_post_data_element_create: function(): PCefPostDataElement; cdecl;

  // Create a new cef_stream_reader_t object from a file.
  cef_stream_reader_create_for_file: function(const fileName: PCefString): PCefStreamReader; cdecl;
  // Create a new cef_stream_reader_t object from data.
  cef_stream_reader_create_for_data: function(data: Pointer; size: Cardinal): PCefStreamReader; cdecl;
  // Create a new cef_stream_reader_t object from a custom handler.
  cef_stream_reader_create_for_handler: function(handler: PCefReadHandler): PCefStreamReader; cdecl;

  // Create a new cef_stream_writer_t object for a file.
  cef_stream_writer_create_for_file: function(const fileName: PCefString): PCefStreamWriter; cdecl;
  // Create a new cef_stream_writer_t object for a custom handler.
  cef_stream_writer_create_for_handler: function(handler: PCefWriteHandler): PCefStreamWriter; cdecl;

  // Returns the current (top) context object in the V8 context stack.
  cef_v8context_get_current_context: function(): PCefv8Context; cdecl;

  // Returns the entered (bottom) context object in the V8 context stack.
  cef_v8context_get_entered_context: function(): PCefv8Context; cdecl;

  // Returns true (1) if V8 is currently inside a context.
  cef_v8context_in_context: function(): Integer;

  // Create a new cef_v8value_t object of type undefined.
  cef_v8value_create_undefined: function(): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type null.
  cef_v8value_create_null: function(): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type bool.
  cef_v8value_create_bool: function(value: Integer): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type int.
  cef_v8value_create_int: function(value: Integer): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type unsigned int.
  cef_v8value_create_uint: function(value: Cardinal): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type double.
  cef_v8value_create_double: function(value: Double): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type Date. This function should only be
  // called from within the scope of a cef_v8context_tHandler, cef_v8handler_t or
  // cef_v8accessor_t callback, or in combination with calling enter() and exit()
  // on a stored cef_v8context_t reference.
  cef_v8value_create_date: function(const value: PCefTime): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type string.
  cef_v8value_create_string: function(const value: PCefString): PCefv8Value; cdecl;

  // Create a new cef_v8value_t object of type object with optional accessor. This
  // function should only be called from within the scope of a
  // cef_v8context_tHandler, cef_v8handler_t or cef_v8accessor_t callback, or in
  // combination with calling enter() and exit() on a stored cef_v8context_t
  // reference.
  cef_v8value_create_object: function(accessor: PCefV8Accessor): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type array with the specified |length|.
  // If |length| is negative the returned array will have length 0. This function
  // should only be called from within the scope of a cef_v8context_tHandler,
  // cef_v8handler_t or cef_v8accessor_t callback, or in combination with calling
  // enter() and exit() on a stored cef_v8context_t reference.
  cef_v8value_create_array: function(length: Integer): PCefv8Value; cdecl;
  // Create a new cef_v8value_t object of type function.
  cef_v8value_create_function: function(const name: PCefString; handler: PCefv8Handler): PCefv8Value; cdecl;

  // Returns the stack trace for the currently active context. |frame_limit| is
  // the maximum number of frames that will be captured.
  cef_v8stack_trace_get_current: function(frame_limit: Integer): PCefV8StackTrace; cdecl;

  // Create a new cef_xml_reader_t object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_xml_reader_create: function(stream: PCefStreamReader;
    encodingType: TCefXmlEncodingType; const URI: PCefString): PCefXmlReader; cdecl;

  // Create a new cef_zip_reader_t object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_zip_reader_create: function(stream: PCefStreamReader): PCefZipReader; cdecl;

  // Allocate a new string multimap.
  cef_string_multimap_alloc: function: TCefStringMultimap; cdecl;

  // Return the number of elements in the string multimap.
  cef_string_multimap_size: function(map: TCefStringMultimap): Integer; cdecl;

  // Return the number of values with the specified key.
  cef_string_multimap_find_count: function(map: TCefStringMultimap; const key: PCefString): Integer; cdecl;

  // Return the value_index-th value with the specified key.
  cef_string_multimap_enumerate: function(map: TCefStringMultimap;
    const key: PCefString; value_index: Integer; var value: TCefString): Integer; cdecl;

  // Return the key at the specified zero-based string multimap index.
  cef_string_multimap_key: function(map: TCefStringMultimap; index: Integer; var key: TCefString): Integer; cdecl;

  // Return the value at the specified zero-based string multimap index.
  cef_string_multimap_value: function(map: TCefStringMultimap; index: Integer; var value: TCefString): Integer; cdecl;

  // Append a new key/value pair at the end of the string multimap.
  cef_string_multimap_append: function(map: TCefStringMultimap; const key, value: PCefString): Integer; cdecl;

  // Clear the string multimap.
  cef_string_multimap_clear: procedure(map: TCefStringMultimap); cdecl;

  // Free the string multimap.
  cef_string_multimap_free: procedure(map: TCefStringMultimap); cdecl;

  cef_build_revision: function: Integer; cdecl;

  // Returns the global cookie manager. By default data will be stored at
  // CefSettings.cache_path if specified or in memory otherwise.
  cef_cookie_manager_get_global_manager: function(): PCefCookieManager; cdecl;

  // Creates a new cookie manager. If |path| is NULL data will be stored in memory
  // only. Returns NULL if creation fails.
  cef_cookie_manager_create_manager: function(const path: PCefString): PCefCookieManager; cdecl;

  // Create a new cef_command_line_t instance.
  cef_command_line_create: function(): PCefCommandLine; cdecl;

  // Returns the singleton global cef_command_line_t object. The returned object
  // will be read-only.
  cef_command_line_get_global: function(): PCefCommandLine; cdecl;


  // Create a new cef_process_message_t object with the specified name.
  cef_process_message_create: function(const name: PCefString): PCefProcessMessage; cdecl;

  // Creates a new object that is not owned by any other object. The specified
  // |data| will be copied.
  cef_binary_value_create: function(const data: Pointer; data_size: Cardinal): PCefBinaryValue; cdecl;

  // Creates a new object that is not owned by any other object.
  cef_dictionary_value_create: function: PCefDictionaryValue; cdecl;

  // Creates a new object that is not owned by any other object.
  cef_list_value_create: function: PCefListValue; cdecl;

  // Retrieve the path associated with the specified |key|. Returns true (1) on
  // success. Can be called on any thread in the browser process.
  cef_get_path: function(key: TCefPathKey; path: PCefString): Integer; cdecl;

  // Launches the process specified via |command_line|. Returns true (1) upon
  // success. Must be called on the browser process TID_PROCESS_LAUNCHER thread.
  //
  // Unix-specific notes: - All file descriptors open in the parent process will
  // be closed in the
  //   child process except for stdin, stdout, and stderr.
  // - If the first argument on the command line does not contain a slash,
  //   PATH will be searched. (See man execvp.)
  cef_launch_process: function(command_line: PCefCommandLine): Integer; cdecl;

  // Create a new cef_response_t object.
  cef_response_create: function: PCefResponse; cdecl;

  // Create a new URL request. Only GET, POST, HEAD, DELETE and PUT request
  // functions are supported. The |request| object will be marked as read-only
  // after calling this function.
  cef_urlrequest_create: function(request: PCefRequest; client: PCefUrlRequestClient): PCefUrlRequest; cdecl;

  // Visit web plugin information.
  cef_visit_web_plugin_info: procedure(visitor: PCefWebPluginInfoVisitor); cdecl;

  // Cause the plugin list to refresh the next time it is accessed regardless of
  // whether it has already been loaded. Can be called on any thread in the
  // browser process.
  cef_refresh_web_plugins: procedure; cdecl;

  // Add a plugin path (directory + file). This change may not take affect until
  // after cef_refresh_web_plugins() is called. Can be called on any thread in the
  // browser process.
  cef_add_web_plugin_path: procedure(const path: PCefString); cdecl;

  // Add a plugin directory. This change may not take affect until after
  // cef_refresh_web_plugins() is called. Can be called on any thread in the
  // browser process.
  cef_add_web_plugin_directory: procedure(const dir: PCefString); cdecl;

  // Remove a plugin path (directory + file). This change may not take affect
  // until after cef_refresh_web_plugins() is called. Can be called on any thread
  // in the browser process.
  cef_remove_web_plugin_path: procedure(const path: PCefString); cdecl;

  // Unregister an internal plugin. This may be undone the next time
  // cef_refresh_web_plugins() is called. Can be called on any thread in the
  // browser process.
  cef_unregister_internal_web_plugin: procedure(const path: PCefString); cdecl;

  // Force a plugin to shutdown. Can be called on any thread in the browser
  // process but will be executed on the IO thread.
  cef_force_web_plugin_shutdown: procedure(const path: PCefString); cdecl;

  // Register a plugin crash. Can be called on any thread in the browser process
  // but will be executed on the IO thread.
  cef_register_web_plugin_crash: procedure(const path: PCefString); cdecl;

  // Query if a plugin is unstable. Can be called on any thread in the browser
  // process.
  cef_is_web_plugin_unstable: procedure(const path: PCefString;
    callback: PCefWebPluginUnstableCallback); cdecl;

  // Request a one-time geolocation update. This function bypasses any user
  // permission checks so should only be used by code that is allowed to access
  // location information.
  cef_get_geolocation: function(callback: PCefGetGeolocationCallback): Integer; cdecl;

  // Returns the task runner for the current thread. Only CEF threads will have
  // task runners. An NULL reference will be returned if this function is called
  // on an invalid thread.
  cef_task_runner_get_for_current_thread: function: PCefTaskRunner; cdecl;

  // Returns the task runner for the specified CEF thread.
  cef_task_runner_get_for_thread: function(threadId: TCefThreadId): PCefTaskRunner; cdecl;



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

  cef_begin_tracing: function(client: PCefTraceClient; const categories: PCefString): Integer; cdecl;

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

  cef_get_trace_buffer_percent_full_async: function: Integer; cdecl;

  // Stop tracing events on all processes.
  //
  // This function will fail and return false (0) if a previous call to
  // CefEndTracingAsync is already pending or if CefBeginTracing was not called.
  //
  // This function must be called on the browser process UI thread.

  cef_end_tracing_async: function: Integer; cdecl;


procedure CefLoadLibrary;
procedure CefCloseLibrary;

Implementation

Uses Math;

Const
  CefLibrary: String = {$IFDEF WINDOWS}'libcef.dll'{$ELSE}'libcef.so'{$ENDIF};
Var
  LibHandle : THandle = 0;

// Convenience macros for copying values.
function cef_string_wide_copy(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide): Integer;
begin
  Result := cef_string_wide_set(src, src_len, output, ord(True))
end;

function cef_string_utf8_copy(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8): Integer;
begin
  Result := cef_string_utf8_set(src, src_len, output, ord(True))
end;

function cef_string_utf16_copy(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
begin
  Result := cef_string_utf16_set(src, src_len, output, ord(True))
end;

function cef_string_copy(const src: PCefChar; src_len: Cardinal; output: PCefString): Integer; cdecl;
begin
  Result := cef_string_set(src, src_len, output, ord(True));
end;

procedure CefLoadLibrary;
begin
  Debugln('CefLoadLibrary');

  If LibHandle = 0 then
  begin
    Set8087CW(Get8087CW or $3F); // deactivate FPU exception
    SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

    LibHandle := LoadLibrary(PChar(CefLibrary));
    If LibHandle = 0 then RaiseLastOsError;

    cef_string_wide_set             := GetProcAddress(LibHandle, 'cef_string_wide_set');
    cef_string_utf8_set             := GetProcAddress(LibHandle, 'cef_string_utf8_set');
    cef_string_utf16_set            := GetProcAddress(LibHandle, 'cef_string_utf16_set');
    cef_string_wide_clear           := GetProcAddress(LibHandle, 'cef_string_wide_clear');
    cef_string_utf8_clear           := GetProcAddress(LibHandle, 'cef_string_utf8_clear');
    cef_string_utf16_clear          := GetProcAddress(LibHandle, 'cef_string_utf16_clear');
    cef_string_wide_cmp             := GetProcAddress(LibHandle, 'cef_string_wide_cmp');
    cef_string_utf8_cmp             := GetProcAddress(LibHandle, 'cef_string_utf8_cmp');
    cef_string_utf16_cmp            := GetProcAddress(LibHandle, 'cef_string_utf16_cmp');
    cef_string_wide_to_utf8         := GetProcAddress(LibHandle, 'cef_string_wide_to_utf8');
    cef_string_utf8_to_wide         := GetProcAddress(LibHandle, 'cef_string_utf8_to_wide');
    cef_string_wide_to_utf16        := GetProcAddress(LibHandle, 'cef_string_wide_to_utf16');
    cef_string_utf16_to_wide        := GetProcAddress(LibHandle, 'cef_string_utf16_to_wide');
    cef_string_utf8_to_utf16        := GetProcAddress(LibHandle, 'cef_string_utf8_to_utf16');
    cef_string_utf16_to_utf8        := GetProcAddress(LibHandle, 'cef_string_utf16_to_utf8');
    cef_string_ascii_to_wide        := GetProcAddress(LibHandle, 'cef_string_ascii_to_wide');
    cef_string_ascii_to_utf16       := GetProcAddress(LibHandle, 'cef_string_ascii_to_utf16');
    cef_string_userfree_wide_alloc  := GetProcAddress(LibHandle, 'cef_string_userfree_wide_alloc');
    cef_string_userfree_utf8_alloc  := GetProcAddress(LibHandle, 'cef_string_userfree_utf8_alloc');
    cef_string_userfree_utf16_alloc := GetProcAddress(LibHandle, 'cef_string_userfree_utf16_alloc');
    cef_string_userfree_wide_free   := GetProcAddress(LibHandle, 'cef_string_userfree_wide_free');
    cef_string_userfree_utf8_free   := GetProcAddress(LibHandle, 'cef_string_userfree_utf8_free');
    cef_string_userfree_utf16_free  := GetProcAddress(LibHandle, 'cef_string_userfree_utf16_free');

{$IFDEF CEF_STRING_TYPE_UTF8}
    cef_string_set            := cef_string_utf8_set;
    cef_string_clear          := cef_string_utf8_clear;
    cef_string_userfree_alloc := cef_string_userfree_utf8_alloc;
    cef_string_userfree_free  := cef_string_userfree_utf8_free;
    cef_string_from_ascii     := cef_string_utf8_copy;
    cef_string_to_utf8        := cef_string_utf8_copy;
    cef_string_from_utf8      := cef_string_utf8_copy;
    cef_string_to_utf16       := cef_string_utf8_to_utf16;
    cef_string_from_utf16     := cef_string_utf16_to_utf8;
    cef_string_to_wide        := cef_string_utf8_to_wide;
    cef_string_from_wide      := cef_string_wide_to_utf8;
{$ENDIF}
{$IFDEF CEF_STRING_TYPE_UTF16}
    cef_string_set            := cef_string_utf16_set;
    cef_string_clear          := cef_string_utf16_clear;
    cef_string_userfree_alloc := cef_string_userfree_utf16_alloc;
    cef_string_userfree_free  := cef_string_userfree_utf16_free;
    cef_string_from_ascii     := cef_string_ascii_to_utf16;
    cef_string_to_utf8        := cef_string_utf16_to_utf8;
    cef_string_from_utf8      := cef_string_utf8_to_utf16;
    cef_string_to_utf16       := cef_string_utf16_copy;
    cef_string_from_utf16     := cef_string_utf16_copy;
    cef_string_to_wide        := cef_string_utf16_to_wide;
    cef_string_from_wide      := cef_string_wide_to_utf16;
{$ENDIF}

{$IFDEF CEF_STRING_TYPE_WIDE}
    cef_string_set            := cef_string_wide_set;
    cef_string_clear          := cef_string_wide_clear;
    cef_string_userfree_alloc := cef_string_userfree_wide_alloc;
    cef_string_userfree_free  := cef_string_userfree_wide_free;
    cef_string_from_ascii     := cef_string_ascii_to_wide;
    cef_string_to_utf8        := cef_string_wide_to_utf8;
    cef_string_from_utf8      := cef_string_utf8_to_wide;
    cef_string_to_utf16       := cef_string_wide_to_utf16;
    cef_string_from_utf16     := cef_string_utf16_to_wide;
    cef_string_to_wide        := cef_string_wide_copy;
    cef_string_from_wide      := cef_string_wide_copy;
{$ENDIF}

    cef_string_map_alloc                    := GetProcAddress(LibHandle, 'cef_string_map_alloc');
    cef_string_map_size                     := GetProcAddress(LibHandle, 'cef_string_map_size');
    cef_string_map_find                     := GetProcAddress(LibHandle, 'cef_string_map_find');
    cef_string_map_key                      := GetProcAddress(LibHandle, 'cef_string_map_key');
    cef_string_map_value                    := GetProcAddress(LibHandle, 'cef_string_map_value');
    cef_string_map_append                   := GetProcAddress(LibHandle, 'cef_string_map_append');
    cef_string_map_clear                    := GetProcAddress(LibHandle, 'cef_string_map_clear');
    cef_string_map_free                     := GetProcAddress(LibHandle, 'cef_string_map_free');
    cef_string_list_alloc                   := GetProcAddress(LibHandle, 'cef_string_list_alloc');
    cef_string_list_size                    := GetProcAddress(LibHandle, 'cef_string_list_size');
    cef_string_list_value                   := GetProcAddress(LibHandle, 'cef_string_list_value');
    cef_string_list_append                  := GetProcAddress(LibHandle, 'cef_string_list_append');
    cef_string_list_clear                   := GetProcAddress(LibHandle, 'cef_string_list_clear');
    cef_string_list_free                    := GetProcAddress(LibHandle, 'cef_string_list_free');
    cef_string_list_copy                    := GetProcAddress(LibHandle, 'cef_string_list_copy');
    cef_initialize                          := GetProcAddress(LibHandle, 'cef_initialize');
    cef_execute_process                     := GetProcAddress(LibHandle, 'cef_execute_process');
    cef_shutdown                            := GetProcAddress(LibHandle, 'cef_shutdown');
    cef_do_message_loop_work                := GetProcAddress(LibHandle, 'cef_do_message_loop_work');
    cef_run_message_loop                    := GetProcAddress(LibHandle, 'cef_run_message_loop');
    cef_quit_message_loop                   := GetProcAddress(LibHandle, 'cef_quit_message_loop');
    cef_register_extension                  := GetProcAddress(LibHandle, 'cef_register_extension');
    cef_register_scheme_handler_factory     := GetProcAddress(LibHandle, 'cef_register_scheme_handler_factory');
    cef_clear_scheme_handler_factories      := GetProcAddress(LibHandle, 'cef_clear_scheme_handler_factories');
    cef_add_cross_origin_whitelist_entry    := GetProcAddress(LibHandle, 'cef_add_cross_origin_whitelist_entry');
    cef_remove_cross_origin_whitelist_entry := GetProcAddress(LibHandle, 'cef_remove_cross_origin_whitelist_entry');
    cef_clear_cross_origin_whitelist        := GetProcAddress(LibHandle, 'cef_clear_cross_origin_whitelist');
    cef_currently_on                        := GetProcAddress(LibHandle, 'cef_currently_on');
    cef_post_task                           := GetProcAddress(LibHandle, 'cef_post_task');
    cef_post_delayed_task                   := GetProcAddress(LibHandle, 'cef_post_delayed_task');
    cef_parse_url                           := GetProcAddress(LibHandle, 'cef_parse_url');
    cef_create_url                          := GetProcAddress(LibHandle, 'cef_create_url');
    cef_browser_host_create_browser         := GetProcAddress(LibHandle, 'cef_browser_host_create_browser');
    cef_browser_host_create_browser_sync    := GetProcAddress(LibHandle, 'cef_browser_host_create_browser_sync');
    cef_request_create                      := GetProcAddress(LibHandle, 'cef_request_create');
    cef_post_data_create                    := GetProcAddress(LibHandle, 'cef_post_data_create');
    cef_post_data_element_create            := GetProcAddress(LibHandle, 'cef_post_data_element_create');
    cef_stream_reader_create_for_file       := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_file');
    cef_stream_reader_create_for_data       := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_data');
    cef_stream_reader_create_for_handler    := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_handler');
    cef_stream_writer_create_for_file       := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_file');
    cef_stream_writer_create_for_handler    := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_handler');
    cef_v8context_get_current_context       := GetProcAddress(LibHandle, 'cef_v8context_get_current_context');
    cef_v8context_get_entered_context       := GetProcAddress(LibHandle, 'cef_v8context_get_entered_context');
    cef_v8context_in_context                := GetProcAddress(LibHandle, 'cef_v8context_in_context');
    cef_v8value_create_undefined            := GetProcAddress(LibHandle, 'cef_v8value_create_undefined');
    cef_v8value_create_null                 := GetProcAddress(LibHandle, 'cef_v8value_create_null');
    cef_v8value_create_bool                 := GetProcAddress(LibHandle, 'cef_v8value_create_bool');
    cef_v8value_create_int                  := GetProcAddress(LibHandle, 'cef_v8value_create_int');
    cef_v8value_create_uint                 := GetProcAddress(LibHandle, 'cef_v8value_create_uint');
    cef_v8value_create_double               := GetProcAddress(LibHandle, 'cef_v8value_create_double');
    cef_v8value_create_date                 := GetProcAddress(LibHandle, 'cef_v8value_create_date');
    cef_v8value_create_string               := GetProcAddress(LibHandle, 'cef_v8value_create_string');
    cef_v8value_create_object               := GetProcAddress(LibHandle, 'cef_v8value_create_object');
    cef_v8value_create_array                := GetProcAddress(LibHandle, 'cef_v8value_create_array');
    cef_v8value_create_function             := GetProcAddress(LibHandle, 'cef_v8value_create_function');
    cef_v8stack_trace_get_current           := GetProcAddress(LibHandle, 'cef_v8stack_trace_get_current');
    cef_xml_reader_create                   := GetProcAddress(LibHandle, 'cef_xml_reader_create');
    cef_zip_reader_create                   := GetProcAddress(LibHandle, 'cef_zip_reader_create');

    cef_string_multimap_alloc               := GetProcAddress(LibHandle, 'cef_string_multimap_alloc');
    cef_string_multimap_size                := GetProcAddress(LibHandle, 'cef_string_multimap_size');
    cef_string_multimap_find_count          := GetProcAddress(LibHandle, 'cef_string_multimap_find_count');
    cef_string_multimap_enumerate           := GetProcAddress(LibHandle, 'cef_string_multimap_enumerate');
    cef_string_multimap_key                 := GetProcAddress(LibHandle, 'cef_string_multimap_key');
    cef_string_multimap_value               := GetProcAddress(LibHandle, 'cef_string_multimap_value');
    cef_string_multimap_append              := GetProcAddress(LibHandle, 'cef_string_multimap_append');
    cef_string_multimap_clear               := GetProcAddress(LibHandle, 'cef_string_multimap_clear');
    cef_string_multimap_free                := GetProcAddress(LibHandle, 'cef_string_multimap_free');
    cef_build_revision                      := GetProcAddress(LibHandle, 'cef_build_revision');

    cef_cookie_manager_get_global_manager   := GetProcAddress(LibHandle, 'cef_cookie_manager_get_global_manager');
    cef_cookie_manager_create_manager       := GetProcAddress(LibHandle, 'cef_cookie_manager_create_manager');

    cef_command_line_create                 := GetProcAddress(LibHandle, 'cef_command_line_create');
    cef_command_line_get_global             := GetProcAddress(LibHandle, 'cef_command_line_get_global');

    cef_process_message_create              := GetProcAddress(LibHandle, 'cef_process_message_create');

    cef_binary_value_create                 := GetProcAddress(LibHandle, 'cef_binary_value_create');

    cef_dictionary_value_create             := GetProcAddress(LibHandle, 'cef_dictionary_value_create');

    cef_list_value_create                   := GetProcAddress(LibHandle, 'cef_list_value_create');

    cef_get_path                            := GetProcAddress(LibHandle, 'cef_get_path');

    cef_launch_process                      := GetProcAddress(LibHandle, 'cef_launch_process');

    cef_response_create                     := GetProcAddress(LibHandle, 'cef_response_create');

    cef_urlrequest_create                   := GetProcAddress(LibHandle, 'cef_urlrequest_create');

    cef_visit_web_plugin_info               := GetProcAddress(LibHandle, 'cef_visit_web_plugin_info');
    cef_refresh_web_plugins                 := GetProcAddress(LibHandle, 'cef_refresh_web_plugins');
    cef_add_web_plugin_path                 := GetProcAddress(LibHandle, 'cef_add_web_plugin_path');
    cef_add_web_plugin_directory            := GetProcAddress(LibHandle, 'cef_add_web_plugin_directory');
    cef_remove_web_plugin_path              := GetProcAddress(LibHandle, 'cef_remove_web_plugin_path');
    cef_unregister_internal_web_plugin      := GetProcAddress(LibHandle, 'cef_unregister_internal_web_plugin');
    cef_force_web_plugin_shutdown           := GetProcAddress(LibHandle, 'cef_force_web_plugin_shutdown');
    cef_register_web_plugin_crash           := GetProcAddress(LibHandle, 'cef_register_web_plugin_crash');
    cef_is_web_plugin_unstable              := GetProcAddress(LibHandle, 'cef_is_web_plugin_unstable');

    cef_get_geolocation                     := GetProcAddress(LibHandle, 'cef_get_geolocation');

    cef_task_runner_get_for_current_thread  := GetProcAddress(LibHandle, 'cef_task_runner_get_for_current_thread');
    cef_task_runner_get_for_thread          := GetProcAddress(LibHandle, 'cef_task_runner_get_for_thread');

    cef_begin_tracing                       := GetProcAddress(LibHandle, 'cef_begin_tracing');
    cef_get_trace_buffer_percent_full_async := GetProcAddress(LibHandle, 'cef_get_trace_buffer_percent_full_async');
    cef_end_tracing_async                   := GetProcAddress(LibHandle, 'cef_end_tracing_async');

    If not (
      Assigned(cef_string_wide_set) and
      Assigned(cef_string_utf8_set) and
      Assigned(cef_string_utf16_set) and
      Assigned(cef_string_wide_clear) and
      Assigned(cef_string_utf8_clear) and
      Assigned(cef_string_utf16_clear) and
      Assigned(cef_string_wide_cmp) and
      Assigned(cef_string_utf8_cmp) and
      Assigned(cef_string_utf16_cmp) and
      Assigned(cef_string_wide_to_utf8) and
      Assigned(cef_string_utf8_to_wide) and
      Assigned(cef_string_wide_to_utf16) and
      Assigned(cef_string_utf16_to_wide) and
      Assigned(cef_string_utf8_to_utf16) and
      Assigned(cef_string_utf16_to_utf8) and
      Assigned(cef_string_ascii_to_wide) and
      Assigned(cef_string_ascii_to_utf16) and
      Assigned(cef_string_userfree_wide_alloc) and
      Assigned(cef_string_userfree_utf8_alloc) and
      Assigned(cef_string_userfree_utf16_alloc) and
      Assigned(cef_string_userfree_wide_free) and
      Assigned(cef_string_userfree_utf8_free) and
      Assigned(cef_string_userfree_utf16_free) and
      Assigned(cef_string_map_alloc) and
      Assigned(cef_string_map_size) and
      Assigned(cef_string_map_find) and
      Assigned(cef_string_map_key) and
      Assigned(cef_string_map_value) and
      Assigned(cef_string_map_append) and
      Assigned(cef_string_map_clear) and
      Assigned(cef_string_map_free) and
      Assigned(cef_string_list_alloc) and
      Assigned(cef_string_list_size) and
      Assigned(cef_string_list_value) and
      Assigned(cef_string_list_append) and
      Assigned(cef_string_list_clear) and
      Assigned(cef_string_list_free) and
      Assigned(cef_string_list_copy) and
      Assigned(cef_initialize) and
      Assigned(cef_execute_process) and
      Assigned(cef_shutdown) and
      Assigned(cef_do_message_loop_work) and
      Assigned(cef_run_message_loop) and
      Assigned(cef_quit_message_loop) and
      Assigned(cef_register_extension) and
      Assigned(cef_register_scheme_handler_factory) and
      Assigned(cef_clear_scheme_handler_factories) and
      Assigned(cef_add_cross_origin_whitelist_entry) and
      Assigned(cef_remove_cross_origin_whitelist_entry) and
      Assigned(cef_clear_cross_origin_whitelist) and
      Assigned(cef_currently_on) and
      Assigned(cef_post_task) and
      Assigned(cef_post_delayed_task) and
      Assigned(cef_parse_url) and
      Assigned(cef_create_url) and
      Assigned(cef_browser_host_create_browser) and
      Assigned(cef_browser_host_create_browser_sync) and
      Assigned(cef_request_create) and
      Assigned(cef_post_data_create) and
      Assigned(cef_post_data_element_create) and
      Assigned(cef_stream_reader_create_for_file) and
      Assigned(cef_stream_reader_create_for_data) and
      Assigned(cef_stream_reader_create_for_handler) and
      Assigned(cef_stream_writer_create_for_file) and
      Assigned(cef_stream_writer_create_for_handler) and
      Assigned(cef_v8context_get_current_context) and
      Assigned(cef_v8context_get_entered_context) and
      Assigned(cef_v8context_in_context) and
      Assigned(cef_v8value_create_undefined) and
      Assigned(cef_v8value_create_null) and
      Assigned(cef_v8value_create_bool) and
      Assigned(cef_v8value_create_int) and
      Assigned(cef_v8value_create_uint) and
      Assigned(cef_v8value_create_double) and
      Assigned(cef_v8value_create_date) and
      Assigned(cef_v8value_create_string) and
      Assigned(cef_v8value_create_object) and
      Assigned(cef_v8value_create_array) and
      Assigned(cef_v8value_create_function) and
      Assigned(cef_v8stack_trace_get_current) and
      Assigned(cef_xml_reader_create) and
      Assigned(cef_zip_reader_create) and
      Assigned(cef_string_multimap_alloc) and
      Assigned(cef_string_multimap_size) and
      Assigned(cef_string_multimap_find_count) and
      Assigned(cef_string_multimap_enumerate) and
      Assigned(cef_string_multimap_key) and
      Assigned(cef_string_multimap_value) and
      Assigned(cef_string_multimap_append) and
      Assigned(cef_string_multimap_clear) and
      Assigned(cef_string_multimap_free) and
      Assigned(cef_build_revision) and
      Assigned(cef_cookie_manager_get_global_manager) and
      Assigned(cef_cookie_manager_create_manager) and
      Assigned(cef_command_line_create) and
      Assigned(cef_command_line_get_global) and
      Assigned(cef_process_message_create) and
      Assigned(cef_binary_value_create) and
      Assigned(cef_dictionary_value_create) and
      Assigned(cef_list_value_create) and
      Assigned(cef_get_path) and
      Assigned(cef_launch_process) and
      Assigned(cef_response_create) and
      Assigned(cef_urlrequest_create) and
      Assigned(cef_visit_web_plugin_info) and
      Assigned(cef_refresh_web_plugins) and
      Assigned(cef_add_web_plugin_path) and
      Assigned(cef_add_web_plugin_directory) and
      Assigned(cef_remove_web_plugin_path) and
      Assigned(cef_unregister_internal_web_plugin) and
      Assigned(cef_force_web_plugin_shutdown) and
      Assigned(cef_register_web_plugin_crash) and
      Assigned(cef_is_web_plugin_unstable) and
      Assigned(cef_get_geolocation) and
      Assigned(cef_task_runner_get_for_current_thread) and
      Assigned(cef_task_runner_get_for_thread) and
      Assigned(cef_begin_tracing) and
      Assigned(cef_get_trace_buffer_percent_full_async) and
      Assigned(cef_end_tracing_async)
    ) then raise Exception.Create('Invalid CEF Library version');
    //) then raise ECefException.Create('Invalid CEF Library version');

    Debugln('   : Loaded');
  end
  Else Debugln('   : already loaded');
end;

procedure CefCloseLibrary;
begin
  Debugln('CefCloseLibrary');
  If LibHandle <> 0 then
  begin
    Debugln('   : Freed');

    FreeLibrary(LibHandle);
    LibHandle := 0;
  end
  Else Debugln('   already freed.');
end;

Finalization
  CefCloseLibrary;

end.
