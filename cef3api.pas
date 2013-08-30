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

Unit cef3api;

{.$MODE objfpc}{$H+}
{$MODE Delphi}

{$I cef.inc}

Interface

Uses
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  {$IFDEF LINUX}Dynlibs,{$ENDIF}
  sysutils, LCLProc, ctypes,
  cef3types;

Type
  PCefBase = ^TCefBase;

  PCefApp = ^TCefApp;

  PCefBrowser = ^TCefBrowser;
  PCefRunFileDialogCallback = ^TCefRunFileDialogCallback;
  PCefBrowserHost = ^TCefBrowserHost;

  PCefBrowserProcessHandler = ^TCefBrowserProcessHandler;

  PCefCompletionHandler = ^TCefCompletionHandler;
  PCefCallback = ^TCefCallback;

  PCefClient = ^TCefClient;

  PCefCommandLine = ^TCefCommandLine;

  PCefContextMenuHandler = ^TCefContextMenuHandler;
  PCefContextMenuParams = ^TCefContextMenuParams;

  PCefCookieManager = ^TCefCookieManager;
  PCefCookieVisitor = ^TCefCookieVisitor;

  PCefFileDialogCallback = ^TCefFileDialogCallback;
  PCefDialogHandler = ^TCefDialogHandler;

  PCefDisplayHandler = ^TCefDisplayHandler;

  PCefDomVisitor = ^TCefDomVisitor;
  PCefDomDocument = ^TCefDomDocument;
  PCefDomNode = ^TCefDomNode;
  PCefDomEvent = ^TCefDomEvent;
  PCefDomEventListener = ^TCefDomEventListener;

  PCefBeforeDownloadCallback = ^TCefBeforeDownloadCallback;
  PCefDownloadItemCallback = ^TCefDownloadItemCallback;
  PCefDownloadHandler = ^TCefDownloadHandler;

  PCefDownloadItem = ^TCefDownloadItem;

  PCefDragData = ^TCefDragData;

  PCefDragHandler = ^TCefDragHandler;

  PCefFocusHandler = ^TCefFocusHandler;

  PCefFrame = ^TCefFrame;

  PCefGetGeolocationCallback = ^TCefGetGeolocationCallback;

  PCefGeolocationCallback = ^TCefGeolocationCallback;
  PCefGeolocationHandler = ^TCefGeolocationHandler;

  PCefJsDialogCallback = ^TCefJsDialogCallback;
  PCefJsDialogHandler = ^TCefJsDialogHandler;

  PCefKeyboardHandler = ^TCefKeyboardHandler;

  PCefLifeSpanHandler = ^TCefLifeSpanHandler;

  PCefLoadHandler = ^TCefLoadHandler;

  PCefMenuModel = ^TCefMenuModel;

  PCefProcessMessage = ^TCefProcessMessage;

  PCefRenderHandler = ^TCefRenderHandler;

  PCefRenderProcessHandler = ^TCefRenderProcessHandler;

  PCefRequest = ^TCefRequest;
  PCefPostData = ^TCefPostData;
  PCefPostDataElementArray = ^TCefPostDataElementArray;
  PCefPostDataElement = ^TCefPostDataElement;

  PCefAuthCallback = ^TCefAuthCallback;
  PCefQuotaCallback = ^TCefQuotaCallback;
  PCefAllowCertificateErrorCallback = ^TCefAllowCertificateErrorCallback;
  PCefRequestHandler = ^TCefRequestHandler;

  PCefResourceBundleHandler = ^TCefResourceBundleHandler;

  PCefResourceHandler = ^TCefResourceHandler;

  PCefResponse = ^TCefResponse;

  PCefSchemeRegistrar = ^TCefSchemeRegistrar;
  PCefSchemeHandlerFactory = ^TCefSchemeHandlerFactory;

  PCefReadHandler = ^TCefReadHandler;
  PCefStreamReader = ^TCefStreamReader;
  PCefWriteHandler = ^TCefWriteHandler;
  PCefStreamWriter = ^TCefStreamWriter;

  PCefStringVisitor = ^TCefStringVisitor;

  PCefTask = ^TCefTask;
  PCefTaskRunner = ^TCefTaskRunner;

  PCefTraceClient = ^TCefTraceClient;

  PCefUrlRequest = ^TCefUrlRequest;

  PCefUrlRequestClient = ^TCefUrlRequestClient;

  PCefV8Context = ^TCefV8Context;
  PCefV8Handler = ^TCefV8Handler;
  PCefV8Accessor = ^TCefV8Accessor;
  PCefV8Exception = ^TCefV8Exception;
  PPCefV8Value = ^PCefV8ValueArray;
  PCefV8Value = ^TCefV8Value;
  PCefV8StackTrace = ^TCefV8StackTrace;
  PCefV8StackFrame = ^TCefV8StackFrame;

  PCefBinaryValue = ^TCefBinaryValue;
  PCefDictionaryValue = ^TCefDictionaryValue;
  PCefListValue = ^TCefListValue;

  PCefWebPluginInfo = ^TCefWebPluginInfo;
  PCefWebPluginInfoVisitor = ^TCefWebPluginInfoVisitor;
  PCefWebPluginUnstableCallback = ^TCefWebPluginUnstableCallback;

  PCefXMLReader = ^TCefXMLReader;

  PCefZipReader = ^TCefZipReader;

{ ***  cef_base_capi.h  *** }
  // Structure defining the reference count implementation functions. All
  // framework structures must include the cef_base_t structure first.
  TCefBase = record
    // Size of the data structure.
    size: csize_t;

    // Increment the reference count.
    add_ref: function(self: PCefBase): Integer; cconv;

    // Decrement the reference count.  Delete this object when no references
    // remain.
    release: function(self: PCefBase): Integer; cconv;

    // Returns the current number of references.
    get_refct: function(self: PCefBase): Integer; cconv;
  end;


{ *** cef_app_capi.h  *** }
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
    on_before_command_line_processing: procedure(self: PCefApp; const process_type: PCefString; command_line: PCefCommandLine); cconv;

    // Provides an opportunity to register custom schemes. Do not keep a reference
    // to the |registrar| object. This function is called on the main thread for
    // each process and the registered schemes should be the same across all
    // processes.
    on_register_custom_schemes: procedure(self: PCefApp; registrar: PCefSchemeRegistrar); cconv;

    // Return the handler for resource bundle events. If
    // CefSettings.pack_loading_disabled is true (1) a handler must be returned.
    // If no handler is returned resources will be loaded from pack files. This
    // function is called by the browser and render processes on multiple threads.
    get_resource_bundle_handler: function(self: PCefApp): PCefResourceBundleHandler; cconv;

    // Return the handler for functionality specific to the browser process. This
    // function is called on multiple threads in the browser process.
    get_browser_process_handler: function(self: PCefApp): PCefBrowserProcessHandler; cconv;

    // Return the handler for functionality specific to the render process. This
    // function is called on the render process main thread.
    get_render_process_handler: function(self: PCefApp): PCefRenderProcessHandler; cconv;
  end;


{ ***  cef_browser_capi.inc  *** }
  // Structure used to represent a browser window. When used in the browser
  // process the functions of this structure may be called on any thread unless
  // otherwise indicated in the comments. When used in the render process the
  // functions of this structure may only be called on the main thread.
  TCefBrowser = record
    // Base structure.
    base: TCefBase;

    // Returns the browser host object. This function can only be called in the
    // browser process.
    get_host: function(self: PCefBrowser): PCefBrowserHost; cconv;

    // Returns true (1) if the browser can navigate backwards.
    can_go_back: function(self: PCefBrowser): Integer; cconv;

    // Navigate backwards.
    go_back: procedure(self: PCefBrowser); cconv;

    // Returns true (1) if the browser can navigate forwards.
    can_go_forward: function(self: PCefBrowser): Integer; cconv;

    // Navigate forwards.
    go_forward: procedure(self: PCefBrowser); cconv;

    // Returns true (1) if the browser is currently loading.
    is_loading: function(self: PCefBrowser): Integer; cconv;

    // Reload the current page.
    reload: procedure(self: PCefBrowser); cconv;

    // Reload the current page ignoring any cached data.
    reload_ignore_cache: procedure(self: PCefBrowser); cconv;

    // Stop loading the page.
    stop_load: procedure(self: PCefBrowser); cconv;

    // Returns the globally unique identifier for this browser.
    get_identifier  : function(self: PCefBrowser): Integer; cconv;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefBrowser): Integer; cconv;

    // Returns true (1) if the window is a popup window.
    is_popup: function(self: PCefBrowser): Integer; cconv;

    // Returns true (1) if a document has been loaded in the browser.
    has_document: function(self: PCefBrowser): Integer; cconv;

    // Returns the main (top-level) frame for the browser window.
    get_main_frame: function(self: PCefBrowser): PCefFrame; cconv;

    // Returns the focused frame for the browser window.
    get_focused_frame: function(self: PCefBrowser): PCefFrame; cconv;

    // Returns the frame with the specified identifier, or NULL if not found.
    get_frame_byident: function(self: PCefBrowser; identifier: Int64): PCefFrame; cconv;

    // Returns the frame with the specified name, or NULL if not found.
    get_frame: function(self: PCefBrowser; const name: PCefString): PCefFrame; cconv;

    // Returns the number of frames that currently exist.
    get_frame_count: function(self: PCefBrowser): Cardinal; cconv;

    // Returns the identifiers of all existing frames.
    get_frame_identifiers: procedure(self: PCefBrowser; identifiersCount: PCardinal; identifiers: PInt64); cconv;

    // Returns the names of all existing frames.
    get_frame_names: procedure(self: PCefBrowser; names: TCefStringList); cconv;

    // Send a message to the specified |target_process|. Returns true (1) if the
    // message was sent successfully.
    send_process_message: function(self: PCefBrowser; target_process: TCefProcessId;
      message: PCefProcessMessage): Integer; cconv;
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
      file_paths: TCefStringList); cconv;
  end;


  // Structure used to represent the browser process aspects of a browser window.
  // The functions of this structure can only be called in the browser process.
  // They may be called on any thread in that process unless otherwise indicated
  // in the comments.
  TCefBrowserHost = record
    // Base structure.
    base: TCefBase;

    // Returns the hosted browser object.
    get_browser: function(self : PCefBrowserHost) : PCefBrowser; cconv;

    // Call this function before destroying a contained browser window. This
    // function performs any internal cleanup that may be needed before the
    // browser window is destroyed. See cef_life_span_handler_t::do_close()
    // documentation for additional usage information.
    parent_window_will_close: procedure(self: PCefBrowserHost); cconv;

    // Request that the browser close. The JavaScript 'onbeforeunload' event will
    // be fired. If |force_close| is false (0) the event handler, if any, will be
    // allowed to prompt the user and the user can optionally cancel the close. If
    // |force_close| is true (1) the prompt will not be displayed and the close
    // will proceed. Results in a call to cef_life_span_handler_t::do_close() if
    // the event handler allows the close or if |force_close| is true (1). See
    // cef_life_span_handler_t::do_close() documentation for additional usage
    // information.
    close_browser: procedure(self: PCefBrowserHost; force_close: Integer); cconv;

    // Set focus for the browser window. If |enable| is true (1) focus will be set
    // to the window. Otherwise, focus will be removed.
    set_focus: procedure(self : PCefBrowserHost; enable : Integer); cconv;

    // Retrieve the window handle for this browser.
    get_window_handle: function(self: PCefBrowserHost): TCefWindowHandle; cconv;

    // Retrieve the window handle of the browser that opened this browser. Will
    // return NULL for non-popup windows. This function can be used in combination
    // with custom handling of modal windows.
    get_opener_window_handle: function(self: PCefBrowserHost): TCefWindowHandle; cconv;

    // Returns the client for this browser.
    get_client: function(self: PCefBrowserHost): PCefClient; cconv;

    // Returns the DevTools URL for this browser. If |http_scheme| is true (1) the
    // returned URL will use the http scheme instead of the chrome-devtools
    // scheme. Remote debugging can be enabled by specifying the "remote-
    // debugging-port" command-line flag or by setting the
    // CefSettings.remote_debugging_port value. If remote debugging is not enabled
    // this function will return an NULL string.
    ///
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_dev_tools_url: function(self: PCefBrowserHost; http_scheme: Integer): PCefStringUserFree; cconv;

    // Get the current zoom level. The default zoom level is 0.0. This function
    // can only be called on the UI thread.
    get_zoom_level: function(self: PCefBrowserHost): Double; cconv;

    // Change the zoom level to the specified value. Specify 0.0 to reset the zoom
    // level. If called on the UI thread the change will be applied immediately.
    // Otherwise, the change will be applied asynchronously on the UI thread.
    set_zoom_level: procedure(self: PCefBrowserHost; zoomLevel: Double); cconv;

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
      callback: PCefRunFileDialogCallback); cconv;

    // Download the file at |url| using cef_download_handler_t.
    start_download: procedure(self: PCefBrowserHost; const url: PCefString); cconv;

    // Set whether mouse cursor change is disabled.
    set_mouse_cursor_change_disabled: procedure(self: PCefBrowserHost; disabled: Integer); cconv;

    // Returns true (1) if mouse cursor change is disabled.
    is_mouse_cursor_change_disabled: function(self: PCefBrowserHost) : Integer; cconv;

    // Returns true (1) if window rendering is disabled.
    is_window_rendering_disabled: function(self: PCefBrowserHost): Integer; cconv;

    // Notify the browser that the widget has been resized. The browser will first
    // call cef_render_handler_t::GetViewRect to get the new size and then call
    // cef_render_handler_t::OnPaint asynchronously with the updated regions. This
    // function is only used when window rendering is disabled.
    was_resized: procedure(self: PCefBrowserHost); cconv;

    // Notify the browser that it has been hidden or shown. Layouting and
    // cef_render_handler_t::OnPaint notification will stop when the browser is
    // hidden. This function is only used when window rendering is disabled.
    was_hidden: procedure(self: PCefBrowserHost; hidden: Integer); cconv;

    // Send a notification to the browser that the screen info has changed. The
    // browser will then call cef_render_handler_t::GetScreenInfo to update the
    // screen information with the new values. This simulates moving the webview
    // window from one display to another, or changing the properties of the
    // current display. This function is only used when window rendering is
    // disabled.
    notify_screen_info_changed: procedure(self: PCefBrowserHost); cconv;

    // Invalidate the |dirtyRect| region of the view. The browser will call
    // cef_render_handler_t::OnPaint asynchronously with the updated regions. This
    // function is only used when window rendering is disabled.
    invalidate: procedure(self: PCefBrowserHost; const dirtyRect: PCefRect; type_: TCefPaintElementType); cconv;

    // Send a key event to the browser.
    send_key_event: procedure(self: PCefBrowserHost; const event: PCefKeyEvent); cconv;

    // Send a mouse click event to the browser. The |x| and |y| coordinates are
    // relative to the upper-left corner of the view.
    send_mouse_click_event: procedure(self: PCefBrowserHost; const event: PCefMouseEvent; type_: TCefMouseButtonType;
      mouseUp, clickCount: Integer); cconv;

    // Send a mouse move event to the browser. The |x| and |y| coordinates are
    // relative to the upper-left corner of the view.
    send_mouse_move_event: procedure(self: PCefBrowserHost; const event: PCefMouseEvent; mouseLeave: Integer); cconv;

    // Send a mouse wheel event to the browser. The |x| and |y| coordinates are
    // relative to the upper-left corner of the view. The |deltaX| and |deltaY|
    // values represent the movement delta in the X and Y directions respectively.
    // In order to scroll inside select popups with window rendering disabled
    // cef_render_handler_t::GetScreenPoint should be implemented properly.
    send_mouse_wheel_event: procedure(self: PCefBrowserHost; const event: PCefMouseEvent; deltaX, deltaY: Integer); cconv;

    // Send a focus event to the browser.
    send_focus_event: procedure(self: PCefBrowserHost; setFocus: Integer); cconv;

    // Send a capture lost event to the browser.
    send_capture_lost_event: procedure(self: PCefBrowserHost); cconv;

    // Get the NSTextInputContext implementation for enabling IME on Mac when
    // window rendering is disabled.
    get_nstext_input_context: function(self : PCefBrowserHost) : TCefTextInputContext; cconv;

    // Handles a keyDown event prior to passing it through the NSTextInputClient
    // machinery.
    handle_key_event_before_text_input_client: procedure(self : PCefBrowserHost; keyEvent : TCefEventHandle); cconv;

    // Performs any additional actions after NSTextInputClient handles the event.
    handle_key_event_after_text_input_client: procedure(self : PCefBrowserHost; keyEvent : TCefEventHandle); cconv;
  end;


{ *** cef_browser_process_handler.inc  *** }
  // Structure used to implement browser process callbacks. The functions of this
  // structure will be called on the browser process main thread unless otherwise
  // indicated.
  TCefBrowserProcessHandler = record
    // Base structure.
    base: TCefBase;

    // Called on the browser process UI thread immediately after the CEF context
    // has been initialized.
    on_context_initialized: procedure(self: PCefBrowserProcessHandler); cconv;

    // Called before a child process is launched. Will be called on the browser
    // process UI thread when launching a render process and on the browser
    // process IO thread when launching a GPU or plugin process. Provides an
    // opportunity to modify the child process command line. Do not keep a
    // reference to |command_line| outside of this function.
    on_before_child_process_launch: procedure(self: PCefBrowserProcessHandler; command_line: PCefCommandLine); cconv;

    // Called on the browser process IO thread after the main thread has been
    // created for a new render process. Provides an opportunity to specify extra
    // information that will be passed to
    // cef_render_process_handler_t::on_render_thread_created() in the render
    // process. Do not keep a reference to |extra_info| outside of this function.
    on_render_process_thread_created: procedure(self: PCefBrowserProcessHandler; extra_info: PCefListValue); cconv;
  end;


{ ***  cef_callback_capi.h  *** }
  // Generic callback structure used for asynchronous continuation.
  TCefCallback = record
    // Base structure.
    base: TCefBase;

    // Continue processing.
    cont: procedure(self: PCefCallback); cconv;

    // Cancel processing.
    cancel: procedure(self: PCefCallback); cconv;
  end;


  // Generic callback structure used for asynchronous completion.
  TCefCompletionHandler = record
    // Base structure.
    base: TCefBase;

    // Method that will be called once the task is complete.
    on_complete: procedure(self: PCefCompletionHandler); cconv;
  end;


{ ***  cef_client_capi.h  *** }
  // Implement this structure to provide handler implementations.
  TCefClient = record
    // Base structure.
    base: TCefBase;

    // Return the handler for context menus. If no handler is provided the default
    // implementation will be used.
    get_context_menu_handler: function(self: PCefClient): PCefContextMenuHandler; cconv;

    // Return the handler for dialogs. If no handler is provided the default
    // implementation will be used.
    get_dialog_handler: function(self: PCefClient): PCefDialogHandler; cconv;

    // Return the handler for browser display state events.
    get_display_handler: function(self: PCefClient): PCefDisplayHandler; cconv;

    // Return the handler for download events. If no handler is returned downloads
    // will not be allowed.
    get_download_handler: function(self: PCefClient): PCefDownloadHandler; cconv;

    // Return the handler for drag events.
    get_drag_handler: function(self: PCefClient): PCefDragHandler; cconv;

    // Return the handler for focus events.
    get_focus_handler: function(self: PCefClient): PCefFocusHandler; cconv;

    // Return the handler for geolocation permissions requests. If no handler is
    // provided geolocation access will be denied by default.
    get_geolocation_handler: function(self: PCefClient): PCefGeolocationHandler; cconv;

    // Return the handler for JavaScript dialogs. If no handler is provided the
    // default implementation will be used.
    get_jsdialog_handler: function(self: PCefClient): PCefJsDialogHandler; cconv;

    // Return the handler for keyboard events.
    get_keyboard_handler: function(self: PCefClient): PCefKeyboardHandler; cconv;

    // Return the handler for browser life span events.
    get_life_span_handler: function(self: PCefClient): PCefLifeSpanHandler; cconv;

    // Return the handler for browser load status events.
    get_load_handler: function(self: PCefClient): PCefLoadHandler; cconv;

    // Return the handler for off-screen rendering events.
    get_render_handler: function(self: PCefClient): PCefRenderHandler; cconv;

    // Return the handler for browser request events.
    get_request_handler: function(self: PCefClient): PCefRequestHandler; cconv;

    // Called when a new message is received from a different process. Return true
    // (1) if the message was handled or false (0) otherwise. Do not keep a
    // reference to or attempt to access the message outside of this callback.
    on_process_message_received: function(self: PCefClient; browser: PCefBrowser; source_process: TCefProcessId; message: PCefProcessMessage): Integer; cconv;
  end;


{ ***  cef_command_line_capi.h  *** }
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
    is_valid: function(self: PCefCommandLine): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefCommandLine): Integer; cconv;

    // Returns a writable copy of this object.
    copy: function(self: PCefCommandLine): PCefCommandLine; cconv;

    // Initialize the command line with the specified |argc| and |argv| values.
    // The first argument must be the name of the program. This function is only
    // supported on non-Windows platforms.
    init_from_argv: procedure(self: PCefCommandLine; argc: Integer; const argv: PPAnsiChar); cconv;

    // Initialize the command line with the string returned by calling
    // GetCommandLineW(). This function is only supported on Windows.
    init_from_string: procedure(self: PCefCommandLine; command_line: PCefString); cconv;

    // Reset the command-line switches and arguments but leave the program
    // component unchanged.
    reset: procedure(self: PCefCommandLine); cconv;

    // Retrieve the original command line string as a vector of strings. The argv
    // array: { program, [(--|-|/)switch[=value]]*, [--], [argument]* }
    get_argv: procedure(self: PCefCommandLine; argv: TCefStringList); cconv;

    // Constructs and returns the represented command line string. Use this
    // function cautiously because quoting behavior is unclear.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_command_line_string: function(self: PCefCommandLine): PCefStringUserFree; cconv;

    // Get the program part of the command line string (the first item).
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_program: function(self: PCefCommandLine): PCefStringUserFree; cconv;

    // Set the program part of the command line string (the first item).
    set_program: procedure(self: PCefCommandLine; const program_: PCefString); cconv;

    // Returns true (1) if the command line has switches.
    has_switches: function(self: PCefCommandLine): Integer; cconv;

    // Returns true (1) if the command line contains the given switch.
    has_switch: function(self: PCefCommandLine; const name: PCefString): Integer; cconv;

    // Returns the value associated with the given switch. If the switch has no
    // value or isn't present this function returns the NULL string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_switch_value: function(self: PCefCommandLine; const name: PCefString): PCefStringUserFree; cconv;

    // Returns the map of switch names and values. If a switch has no value an
    // NULL string is returned.
    get_switches: procedure(self: PCefCommandLine; switches: TCefStringMap); cconv;

    // Add a switch to the end of the command line. If the switch has no value
    // pass an NULL value string.
    append_switch: procedure(self: PCefCommandLine; const name: PCefString); cconv;

    // Add a switch with the specified value to the end of the command line.
    append_switch_with_value: procedure(self: PCefCommandLine; const name, value: PCefString); cconv;

    // True if there are remaining command line arguments.
    has_arguments: function(self: PCefCommandLine): Integer; cconv;

    // Get the remaining command line arguments.
    get_arguments: procedure(self: PCefCommandLine; arguments: TCefStringList); cconv;

    // Add an argument to the end of the command line.
    append_argument: procedure(self: PCefCommandLine; const argument: PCefString); cconv;

    // Insert a command before the current command. Common for debuggers, like
    // "valgrind" or "gdb --args".
    prepend_wrapper: procedure(self: PCefCommandLine; const wrapper: PCefString); cconv;
  end;


{ ***  cef_context_menu_handler.inc  *** }
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
      model: PCefMenuModel); cconv;

    // Called to execute a command selected from the context menu. Return true (1)
    // if the command was handled or false (0) for the default implementation. See
    // cef_menu_id_t for the command ids that have default implementations. All
    // user-defined command ids should be between MENU_ID_USER_FIRST and
    // MENU_ID_USER_LAST. |params| will have the same values as what was passed to
    // on_before_context_menu(). Do not keep a reference to |params| outside of
    // this callback.
    on_context_menu_command: function(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
      command_id: Integer; event_flags: Integer): Integer; cconv;

    // Called when the context menu is dismissed irregardless of whether the menu
    // was NULL or a command was selected.
    on_context_menu_dismissed: procedure(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame); cconv;
  end;


  // Provides information about the context menu state. The ethods of this
  // structure can only be accessed on browser process the UI thread.
  TCefContextMenuParams = record
    // Base structure.
    base: TCefBase;

    // Returns the X coordinate of the mouse where the context menu was invoked.
    // Coords are relative to the associated RenderView's origin.
    get_xcoord: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns the Y coordinate of the mouse where the context menu was invoked.
    // Coords are relative to the associated RenderView's origin.
    get_ycoord: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns flags representing the type of node that the context menu was
    // invoked on.
    //get_type_flags: function(self: PCefContextMenuParams): Integer; cconv;
    get_type_flags: function(self: PCefContextMenuParams): TCefContextMenuTypeFlags; cconv;

    // Returns the URL of the link, if any, that encloses the node that the
    // context menu was invoked on.
    get_link_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the link URL, if any, to be used ONLY for "copy link address". We
    // don't validate this field in the frontend process.
    get_unfiltered_link_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the source URL, if any, for the element that the context menu was
    // invoked on. Example of elements with source URLs are img, audio, and video.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_source_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns true (1) if the context menu was invoked on a blocked image.
    is_image_blocked: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns the URL of the top level page that the context menu was invoked on.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_page_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the URL of the subframe that the context menu was invoked on.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_frame_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the character encoding of the subframe that the context menu was
    // invoked on.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_frame_charset: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the type of context node that the context menu was invoked on.
    get_media_type: function(self: PCefContextMenuParams): TCefContextMenuMediaType; cconv;

    // Returns flags representing the actions supported by the media element, if
    // any, that the context menu was invoked on.
    get_media_state_flags: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns the text of the selection, if any, that the context menu was
    // invoked on.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_text: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns true (1) if the context menu was invoked on an editable node.
    is_editable: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns true (1) if the context menu was invoked on an editable node where
    // speech-input is enabled.
    is_speech_input_enabled: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns flags representing the actions supported by the editable node, if
    // any, that the context menu was invoked on.
    //get_edit_state_flags: function(self: PCefContextMenuParams): Integer; cconv;
    get_edit_state_flags: function(self: PCefContextMenuParams): TCefContextMenuEditStateFlags; cconv;
  end;


{ ***  cef_cookie_capi.h  *** }
  // Structure used for managing cookies. The functions of this structure may be
  // called on any thread unless otherwise indicated.
  TCefCookieManager = record
    // Base structure.
    base: TCefBase;

    // Set the schemes supported by this manager. By default only "http" and
    // "https" schemes are supported. Must be called before any cookies are
    // accessed.
    set_supported_schemes: procedure(self: PCefCookieManager; schemes: TCefStringList); cconv;

    // Visit all cookies. The returned cookies are ordered by longest path, then
    // by earliest creation date. Returns false (0) if cookies cannot be accessed.
    visit_all_cookies: function(self: PCefCookieManager; visitor: PCefCookieVisitor): Integer; cconv;

    // Visit a subset of cookies. The results are filtered by the given url
    // scheme, host, domain and path. If |includeHttpOnly| is true (1) HTTP-only
    // cookies will also be included in the results. The returned cookies are
    // ordered by longest path, then by earliest creation date. Returns false (0)
    // if cookies cannot be accessed.
    visit_url_cookies: function(self: PCefCookieManager; const url: PCefString;
      includeHttpOnly: Integer; visitor: PCefCookieVisitor): Integer; cconv;

    // Sets a cookie given a valid URL and explicit user-provided cookie
    // attributes. This function expects each attribute to be well-formed. It will
    // check for disallowed characters (e.g. the ';' character is disallowed
    // within the cookie value attribute) and will return false (0) without
    // setting the cookie if such characters are found. This function must be
    // called on the IO thread.
    set_cookie: function(self: PCefCookieManager; const url: PCefString; const cookie: PCefCookie): Integer; cconv;

    // Delete all cookies that match the specified parameters. If both |url| and
    // values |cookie_name| are specified all host and domain cookies matching
    // both will be deleted. If only |url| is specified all host cookies (but not
    // domain cookies) irrespective of path will be deleted. If |url| is NULL all
    // cookies for all hosts and domains will be deleted. Returns false (0) if a
    // non- NULL invalid URL is specified or if cookies cannot be accessed. This
    // function must be called on the IO thread.
    delete_cookies: function(self: PCefCookieManager;
        const url, cookie_name: PCefString): Integer; cconv;

    // Sets the directory path that will be used for storing cookie data. If
    // |path| is NULL data will be stored in memory only. Otherwise, data will be
    // stored at the specified |path|. To persist session cookies (cookies without
    // an expiry date or validity interval) set |persist_session_cookies| to true
    // (1). Session cookies are generally intended to be transient and most Web
    // browsers do not persist them. Returns false (0) if cookies cannot be
    // accessed.
    set_storage_path: function(self: PCefCookieManager; const path: PCefString;
        persist_session_cookies: Integer): Integer; cconv;

    // Flush the backing store (if any) to disk and execute the specified
    // |handler| on the IO thread when done. Returns false (0) if cookies cannot
    // be accessed.
    flush_store: function(self: PCefCookieManager; handler: PCefCompletionHandler): Integer; cconv;
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
      count, total: Integer; deleteCookie: PInteger): Integer; cconv;
  end;


{ *** cef_dialog_handler_capi.h  *** }
  // Callback structure for asynchronous continuation of file dialog requests.
  TCefFileDialogCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the file selection with the specified |file_paths|. This may be a
    // single value or a list of values depending on the dialog mode. An NULL
    // value is treated the same as calling cancel().
    cont: procedure(self: PCefFileDialogCallback; file_paths: TCefStringList); cconv;

    // Cancel the file selection.
    cancel: procedure(self: PCefFileDialogCallback); cconv;
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
      accept_types: TCefStringList; callback: PCefFileDialogCallback): Integer; cconv;
  end;


{ ***  cef_display_handler_capi.h  *** }
  // Implement this structure to handle events related to browser display state.
  // The functions of this structure will be called on the UI thread.
  TCefDisplayHandler = record
    // Base structure.
    base: TCefBase;

    // Called when the loading state has changed.
    on_loading_state_change: procedure(self: PCefDisplayHandler;
      browser: PCefBrowser; isLoading, canGoBack, canGoForward: Integer); cconv;

    // Called when a frame's address has changed.
    on_address_change: procedure(self: PCefDisplayHandler;
      browser: PCefBrowser; frame: PCefFrame; const url: PCefString); cconv;

    // Called when the page title changes.
    on_title_change: procedure(self: PCefDisplayHandler;
        browser: PCefBrowser; const title: PCefString); cconv;

    // Called when the browser is about to display a tooltip. |text| contains the
    // text that will be displayed in the tooltip. To handle the display of the
    // tooltip yourself return true (1). Otherwise, you can optionally modify
    // |text| and then return false (0) to allow the browser to display the
    // tooltip. When window rendering is disabled the application is responsible
    // for drawing tooltips and the return value is ignored.
    on_tooltip: function(self: PCefDisplayHandler;
        browser: PCefBrowser; text: PCefString): Integer; cconv;

    // Called when the browser receives a status message. |text| contains the text
    // that will be displayed in the status message and |type| indicates the
    // status message type.
    on_status_message: procedure(self: PCefDisplayHandler;
        browser: PCefBrowser; const value: PCefString); cconv;

    // Called to display a console message. Return true (1) to stop the message
    // from being output to the console.
    on_console_message: function(self: PCefDisplayHandler;
        browser: PCefBrowser; const message, source: PCefString; line: Integer): Integer; cconv;
  end;


{ ***  cef_dom_capi.h  *** }
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
    visit: procedure(self: PCefDomVisitor; document: PCefDomDocument); cconv;
  end;

  // Structure used to represent a DOM document. The functions of this structure
  // should only be called on the render process main thread thread.
  TCefDomDocument = record
    // Base structure.
    base: TCefBase;

    // Returns the document type.
    get_type: function(self: PCefDomDocument): TCefDomDocumentType; cconv;

    // Returns the root document node.
    get_document: function(self: PCefDomDocument): PCefDomNode; cconv;

    // Returns the BODY node of an HTML document.
    get_body: function(self: PCefDomDocument): PCefDomNode; cconv;

    // Returns the HEAD node of an HTML document.
    get_head: function(self: PCefDomDocument): PCefDomNode; cconv;

    // Returns the title of an HTML document.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_title: function(self: PCefDomDocument): PCefStringUserFree; cconv;

    // Returns the document element with the specified ID value.
    get_element_by_id: function(self: PCefDomDocument; const id: PCefString): PCefDomNode; cconv;

    // Returns the node that currently has keyboard focus.
    get_focused_node: function(self: PCefDomDocument): PCefDomNode; cconv;

    // Returns true (1) if a portion of the document is selected.
    has_selection: function(self: PCefDomDocument): Integer; cconv;

    // Returns the selection start node.
    get_selection_start_node: function(self: PCefDomDocument): PCefDomNode; cconv;

    // Returns the selection offset within the start node.
    get_selection_start_offset: function(self: PCefDomDocument): Integer; cconv;

    // Returns the selection end node.
    get_selection_end_node: function(self: PCefDomDocument): PCefDomNode; cconv;

    // Returns the selection offset within the end node.
    get_selection_end_offset: function(self: PCefDomDocument): Integer; cconv;

    // Returns the contents of this selection as markup.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_as_markup: function(self: PCefDomDocument): PCefStringUserFree; cconv;

    // Returns the contents of this selection as text.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_as_text: function(self: PCefDomDocument): PCefStringUserFree; cconv;

    // Returns the base URL for the document.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_base_url: function(self: PCefDomDocument): PCefStringUserFree; cconv;

    // Returns a complete URL based on the document base URL and the specified
    // partial URL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_complete_url: function(self: PCefDomDocument; const partialURL: PCefString): PCefStringUserFree; cconv;
  end;


  // Structure used to represent a DOM node. The functions of this structure
  // should only be called on the render process main thread.
  TCefDomNode = record
    // Base structure.
    base: TCefBase;

    // Returns the type for this node.
    get_type: function(self: PCefDomNode): TCefDomNodeType; cconv;

    // Returns true (1) if this is a text node.
    is_text: function(self: PCefDomNode): Integer; cconv;

    // Returns true (1) if this is an element node.
    is_element: function(self: PCefDomNode): Integer; cconv;

    // Returns true (1) if this is an editable node.
    is_editable: function(self: PCefDomNode): Integer; cconv;

    // Returns true (1) if this is a form control element node.
    is_form_control_element: function(self: PCefDomNode): Integer; cconv;

    // Returns the type of this form control element node.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_form_control_element_type: function(self: PCefDomNode): PCefStringUserFree; cconv;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefDomNode): Integer; cconv;

    // Returns the name of this node.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefDomNode): PCefStringUserFree; cconv;

    // Returns the value of this node.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_value: function(self: PCefDomNode): PCefStringUserFree; cconv;

    // Set the value of this node. Returns true (1) on success.
    set_value: function(self: PCefDomNode; const value: PCefString): Integer; cconv;

    // Returns the contents of this node as markup.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_as_markup: function(self: PCefDomNode): PCefStringUserFree; cconv;

    // Returns the document associated with this node.
    get_document: function(self: PCefDomNode): PCefDomDocument; cconv;

    // Returns the parent node.
    get_parent: function(self: PCefDomNode): PCefDomNode; cconv;

    // Returns the previous sibling node.
    get_previous_sibling: function(self: PCefDomNode): PCefDomNode; cconv;

    // Returns the next sibling node.
    get_next_sibling: function(self: PCefDomNode): PCefDomNode; cconv;

    // Returns true (1) if this node has child nodes.
    has_children: function(self: PCefDomNode): Integer; cconv;

    // Return the first child node.
    get_first_child: function(self: PCefDomNode): PCefDomNode; cconv;

    // Returns the last child node.
    get_last_child: function(self: PCefDomNode): PCefDomNode; cconv;

    // Add an event listener to this node for the specified event type. If
    // |useCapture| is true (1) then this listener will be considered a capturing
    // listener. Capturing listeners will recieve all events of the specified type
    // before the events are dispatched to any other event targets beneath the
    // current node in the tree. Events which are bubbling upwards through the
    // tree will not trigger a capturing listener. Separate calls to this function
    // can be used to register the same listener with and without capture. See
    // WebCore/dom/EventNames.h for the list of supported event types.
    add_event_listener: procedure(self: PCefDomNode; const eventType: PCefString;
      listener: PCefDomEventListener; useCapture: Integer); cconv;

    // The following functions are valid only for element nodes.


    // Returns the tag name of this element.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_element_tag_name: function(self: PCefDomNode): PCefStringUserFree; cconv;

    // Returns true (1) if this element has attributes.
    has_element_attributes: function(self: PCefDomNode): Integer; cconv;

    // Returns true (1) if this element has an attribute named |attrName|.
    has_element_attribute: function(self: PCefDomNode; const attrName: PCefString): Integer; cconv;

    // Returns the element attribute named |attrName|.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_element_attribute: function(self: PCefDomNode; const attrName: PCefString): PCefStringUserFree; cconv;

    // Returns a map of all element attributes.
    get_element_attributes: procedure(self: PCefDomNode; attrMap: TCefStringMap); cconv;

    // Set the value for the element attribute named |attrName|. Returns true (1)
    // on success.
    set_element_attribute: function(self: PCefDomNode; const attrName, value: PCefString): Integer; cconv;

    // Returns the inner text of the element.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_element_inner_text: function(self: PCefDomNode): PCefStringUserFree; cconv;
  end;


  // Structure used to represent a DOM event. The functions of this structure
  // should only be called on the render process main thread.
  TCefDomEvent = record
    // Base structure.
    base: TCefBase;

    // Returns the event type.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_type: function(self: PCefDomEvent): PCefStringUserFree; cconv;

    // Returns the event category.
    get_category: function(self: PCefDomEvent): TCefDomEventCategory; cconv;

    // Returns the event processing phase.
    get_phase: function(self: PCefDomEvent): TCefDomEventPhase; cconv;

    // Returns true (1) if the event can bubble up the tree.
    can_bubble: function(self: PCefDomEvent): Integer; cconv;

    // Returns true (1) if the event can be canceled.
    can_cancel: function(self: PCefDomEvent): Integer; cconv;

    // Returns the document associated with this event.
    get_document: function(self: PCefDomEvent): PCefDomDocument; cconv;

    // Returns the target of the event.
    get_target: function(self: PCefDomEvent): PCefDomNode; cconv;

    // Returns the current target of the event.
    get_current_target: function(self: PCefDomEvent): PCefDomNode; cconv;
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
    handle_event: procedure(self: PCefDomEventListener; event: PCefDomEvent); cconv;
  end;


{ ***  cef_download_handler_capi.h  *** }
  // Callback structure used to asynchronously continue a download.
  TCefBeforeDownloadCallback = record
    // Base structure.
    base: TCefBase;

    // Call to continue the download. Set |download_path| to the full file path
    // for the download including the file name or leave blank to use the
    // suggested name and the default temp directory. Set |show_dialog| to true
    // (1) if you do wish to show the default "Save As" dialog.
    cont: procedure(self: PCefBeforeDownloadCallback;
      const download_path: PCefString; show_dialog: Integer); cconv;
  end;


  // Callback structure used to asynchronously cancel a download.
  TCefDownloadItemCallback = record
    // Base structure.
    base: TCefBase;

    // Call to cancel the download.
    cancel: procedure(self: PCefDownloadItemCallback); cconv;
  end;


  // Structure used to handle file downloads. The functions of this structure will
  // called on the browser process UI thread.
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
      const suggested_name: PCefString; callback: PCefBeforeDownloadCallback); cconv;

    // Called when a download's status or progress information has been updated.
    // This may be called multiple times before and after on_before_download().
    // Execute |callback| either asynchronously or in this function to cancel the
    // download if desired. Do not keep a reference to |download_item| outside of
    // this function.
    on_download_updated: procedure(self: PCefDownloadHandler;
        browser: PCefBrowser; download_item: PCefDownloadItem;
        callback: PCefDownloadItemCallback); cconv;
  end;


{ ***  cef_download_item_capi.h  *** }
  // Structure used to represent a download item.
  TCefDownloadItem = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefDownloadItem): Integer; cconv;

    // Returns true (1) if the download is in progress.
    is_in_progress: function(self: PCefDownloadItem): Integer; cconv;

    // Returns true (1) if the download is complete.
    is_complete: function(self: PCefDownloadItem): Integer; cconv;

    // Returns true (1) if the download has been canceled or interrupted.
    is_canceled: function(self: PCefDownloadItem): Integer; cconv;

    // Returns a simple speed estimate in bytes/s.
    get_current_speed: function(self: PCefDownloadItem): Int64; cconv;

    // Returns the rough percent complete or -1 if the receive total size is
    // unknown.
    get_percent_complete: function(self: PCefDownloadItem): Integer; cconv;

    // Returns the total number of bytes.
    get_total_bytes: function(self: PCefDownloadItem): Int64; cconv;

    // Returns the number of received bytes.
    get_received_bytes: function(self: PCefDownloadItem): Int64; cconv;

    // Returns the time that the download started.
    get_start_time: function(self: PCefDownloadItem): TCefTime; cconv;

    // Returns the time that the download ended.
    get_end_time: function(self: PCefDownloadItem): TCefTime; cconv;

    // Returns the full path to the downloaded or downloading file.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_full_path: function(self: PCefDownloadItem): PCefStringUserFree; cconv;

    // Returns the unique identifier for this download.
    get_id: function(self: PCefDownloadItem): Int32; cconv;

    // Returns the URL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefDownloadItem): PCefStringUserFree; cconv;

    // Returns the suggested file name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_suggested_file_name: function(self: PCefDownloadItem): PCefStringUserFree; cconv;

    // Returns the content disposition.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_content_disposition: function(self: PCefDownloadItem): PCefStringUserFree; cconv;

    // Returns the mime type.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_mime_type: function(self: PCefDownloadItem): PCefStringUserFree; cconv;
  end;


{ *** cef_drag_data_capi.h  *** }
  // Structure used to represent drag data. The functions of this structure may be
  // called on any thread.
  TCefDragData = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the drag data is a link.
    is_link: function(self: PCefDragData): Integer; cconv;

    // Returns true (1) if the drag data is a text or html fragment.
    is_fragment: function(self: PCefDragData): Integer; cconv;

    // Returns true (1) if the drag data is a file.
    is_file: function(self: PCefDragData): Integer; cconv;

    // Return the link URL that is being dragged.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_link_url: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Return the title associated with the link being dragged.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_link_title: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Return the metadata, if any, associated with the link being dragged.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_link_metadata: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Return the plain text fragment that is being dragged.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_fragment_text: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Return the text/html fragment that is being dragged.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_fragment_html: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Return the base URL that the fragment came from. This value is used for
    // resolving relative URLs and may be NULL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_fragment_base_url: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Return the name of the file being dragged out of the browser window.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_file_name: function(self: PCefDragData): PCefStringUserFree; cconv;

    // Retrieve the list of file names that are being dragged into the browser
    // window.
    get_file_names: function(self: PCefDragData; names: TCefStringList): Integer; cconv;
  end;


{ ***  cef_drag_handler_capi.h  *** }
  // Implement this structure to handle events related to dragging. The functions
  // of this structure will be called on the UI thread.
  TCefDragHandler = record
    // Base structure.
    base: TCefBase;

    // Called when an external drag event enters the browser window. |dragData|
    // contains the drag event data and |mask| represents the type of drag
    // operation. Return false (0) for default drag handling behavior or true (1)
    // to cancel the drag event.
    on_drag_enter: function(self: PCefDragHandler; browser: PCefBrowser; dragData: PCefDragData; mask: TCefDragOperationsMask): Integer; cconv;
  end;


{ ***  cef_focus_handler_capi.h  *** }
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
        browser: PCefBrowser; next: Integer); cconv;

    // Called when the browser component is requesting focus. |source| indicates
    // where the focus request is originating from. Return false (0) to allow the
    // focus to be set or true (1) to cancel setting the focus.
    on_set_focus: function(self: PCefFocusHandler;
        browser: PCefBrowser; source: TCefFocusSource): Integer; cconv;

    // Called when the browser component has received focus.
    on_got_focus: procedure(self: PCefFocusHandler; browser: PCefBrowser); cconv;
  end;


{ ***  cef_frame_capi.h  *** }
  // Structure used to represent a frame in the browser window. When used in the
  // browser process the functions of this structure may be called on any thread
  // unless otherwise indicated in the comments. When used in the render process
  // the functions of this structure may only be called on the main thread.
  TCefFrame = record
    // Base structure.
    base: TCefBase;

    // True if this object is currently attached to a valid frame.
    is_valid: function(self: PCefFrame): Integer; cconv;

    // Execute undo in this frame.
    undo: procedure(self: PCefFrame); cconv;

    // Execute redo in this frame.
    redo: procedure(self: PCefFrame); cconv;

    // Execute cut in this frame.
    cut: procedure(self: PCefFrame); cconv;

    // Execute copy in this frame.
    copy: procedure(self: PCefFrame); cconv;

    // Execute paste in this frame.
    paste: procedure(self: PCefFrame); cconv;

    // Execute delete in this frame.
    del: procedure(self: PCefFrame); cconv;

    // Execute select all in this frame.
    select_all: procedure(self: PCefFrame); cconv;

    // Save this frame's HTML source to a temporary file and open it in the
    // default text viewing application. This function can only be called from the
    // browser process.
    view_source: procedure(self: PCefFrame); cconv;

    // Retrieve this frame's HTML source as a string sent to the specified
    // visitor.
    get_source: procedure(self: PCefFrame; visitor: PCefStringVisitor); cconv;

    // Retrieve this frame's display text as a string sent to the specified
    // visitor.
    get_text: procedure(self: PCefFrame; visitor: PCefStringVisitor); cconv;

    // Load the request represented by the |request| object.
    load_request: procedure(self: PCefFrame; request: PCefRequest); cconv;

    // Load the specified |url|.
    load_url: procedure(self: PCefFrame; const url: PCefString); cconv;

    // Load the contents of |string_val| with the specified dummy |url|. |url|
    // should have a standard scheme (for example, http scheme) or behaviors like
    // link clicks and web security restrictions may not behave as expected.
    load_string: procedure(self: PCefFrame; const stringVal, url: PCefString); cconv;

    // Execute a string of JavaScript code in this frame. The |script_url|
    // parameter is the URL where the script in question can be found, if any. The
    // renderer may request this URL to show the developer the source of the
    // error.  The |start_line| parameter is the base line number to use for error
    // reporting.
    execute_java_script: procedure(self: PCefFrame; const code,
      script_url: PCefString; start_line: Integer); cconv;

    // Returns true (1) if this is the main (top-level) frame.
    is_main: function(self: PCefFrame): Integer; cconv;

    // Returns true (1) if this is the focused frame.
    is_focused: function(self: PCefFrame): Integer; cconv;

    // Returns the name for this frame. If the frame has an assigned name (for
    // example, set via the iframe "name" attribute) then that value will be
    // returned. Otherwise a unique name will be constructed based on the frame
    // parent hierarchy. The main (top-level) frame will always have an NULL name
    // value.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefFrame): PCefStringUserFree; cconv;

    // Returns the globally unique identifier for this frame.
    get_identifier: function(self: PCefFrame): Int64; cconv;

    // Returns the parent of this frame or NULL if this is the main (top-level)
    // frame.
    get_parent: function(self: PCefFrame): PCefFrame; cconv;

    // Returns the URL currently loaded in this frame.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefFrame): PCefStringUserFree; cconv;

    // Returns the browser that this frame belongs to.
    get_browser: function(self: PCefFrame): PCefBrowser; cconv;

    // Get the V8 context associated with the frame. This function can only be
    // called from the render process.
    get_v8context: function(self: PCefFrame): PCefv8Context; cconv;

    // Visit the DOM document. This function can only be called from the render
    // process.
    visit_dom: procedure(self: PCefFrame; visitor: PCefDomVisitor); cconv;
  end;


{ ***  cef_geolocation_capi.h  *** }
  // Implement this structure to receive geolocation updates. The functions of
  // this structure will be called on the browser process UI thread.
  TCefGetGeolocationCallback = record
    // Base structure.
    base: TCefBase;

    // Called with the 'best available' location information or, if the location
    // update failed, with error information.
    on_location_update: procedure(self: PCefGetGeolocationCallback;
        const position: PCefGeoposition); cconv;
  end;


{ ***  cef_geolocation_handler_capi.h  *** }
  // Callback structure used for asynchronous continuation of geolocation
  // permission requests.
  TCefGeolocationCallback = record
    // Base structure.
    base: TCefBase;

    // Call to allow or deny geolocation access.
    cont: procedure(self: PCefGeolocationCallback; allow: Integer); cconv;
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
        callback: PCefGeolocationCallback); cconv;

    // Called when a geolocation access request is canceled. |requesting_url| is
    // the URL that originally requested permission and |request_id| is the unique
    // ID for the permission request.
    on_cancel_geolocation_permission: procedure(self: PCefGeolocationHandler;
        browser: PCefBrowser; const requesting_url: PCefString; request_id: Integer); cconv;
  end;


{ ***  cef_jsdialog_handler_capi.h  *** }
  // Callback structure used for asynchronous continuation of JavaScript dialog
  // requests.
  TCefJsDialogCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the JS dialog request. Set |success| to true (1) if the OK button
    // was pressed. The |user_input| value should be specified for prompt dialogs.
    cont: procedure(self: PCefJsDialogCallback; success: Integer; const user_input: PCefString); cconv;
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
      callback: PCefJsDialogCallback; suppress_message: PInteger): Integer; cconv;

    // Called to run a dialog asking the user if they want to leave a page. Return
    // false (0) to use the default dialog implementation. Return true (1) if the
    // application will use a custom dialog or if the callback has been executed
    // immediately. Custom dialogs may be either modal or modeless. If a custom
    // dialog is used the application must execute |callback| once the custom
    // dialog is dismissed.
    on_before_unload_dialog: function(self: PCefJsDialogHandler;
      browser: PCefBrowser; const message_text: PCefString; is_reload: Integer;
      callback: PCefJsDialogCallback): Integer; cconv;


    // Called to cancel any pending dialogs and reset any saved dialog state. Will
    // be called due to events like page navigation irregardless of whether any
    // dialogs are currently pending.
    on_reset_dialog_state: procedure(self: PCefJsDialogHandler; browser: PCefBrowser); cconv;

    // Called when the default implementation dialog is closed.
    on_dialog_closed: procedure(self: PCefJsDialogHandler; browser: PCefBrowser); cconv;
  end;


{ *** cef_keyboard_handler_capi.h  *** }
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
      os_event: TCefEventHandle; is_keyboard_shortcut: PInteger): Integer; cconv;

    // Called after the renderer and JavaScript in the page has had a chance to
    // handle the event. |event| contains information about the keyboard event.
    // |os_event| is the operating system event message, if any. Return true (1)
    // if the keyboard event was handled or false (0) otherwise.
    on_key_event: function(self: PCefKeyboardHandler;
        browser: PCefBrowser; const event: PCefKeyEvent;
        os_event: TCefEventHandle): Integer; cconv;
  end;


{ ***  cef_life_span_handler_capi.h  *** }
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
    {$NOTE check twice}
    on_before_popup: function(self: PCefLifeSpanHandler;
      browser: PCefBrowser; frame: PCefFrame;
      const target_url, target_frame_name: PCefString;
      const popupFeatures: PCefPopupFeatures;
      windowInfo: PCefWindowInfo; var client: PCefClient;
      settings: PCefBrowserSettings; no_javascript_access: PInteger): Integer; cconv;

    // Called after a new browser is created.
    on_after_created: procedure(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;

    // Called when a modal window is about to display and the modal loop should
    // begin running. Return false (0) to use the default modal loop
    // implementation or true (1) to use a custom implementation.
    run_modal: function(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cconv;

    // Called when a browser has recieved a request to close. This may result
    // directly from a call to cef_browser_host_t::close_browser() or indirectly
    // if the browser is a top-level OS window created by CEF and the user
    // attempts to close the window. This function will be called after the
    // JavaScript 'onunload' event has been fired. It will not be called for
    // browsers after the associated OS window has been destroyed (for those
    // browsers it is no longer possible to cancel the close).
    //
    // If CEF created an OS window for the browser returning false (0) will send
    // an OS close notification to the browser window's top-level owner (e.g.
    // WM_CLOSE on Windows, performClose: on OS-X and "delete_event" on Linux). If
    // no OS window exists (window rendering disabled) returning false (0) will
    // cause the browser object to be destroyed immediately. Return true (1) if
    // the browser is parented to another window and that other window needs to
    // receive close notification via some non-standard technique.
    //
    // If an application provides its own top-level window it should handle OS
    // close notifications by calling cef_browser_host_t::CloseBrowser(false (0))
    // instead of immediately closing (see the example below). This gives CEF an
    // opportunity to process the 'onbeforeunload' event and optionally cancel the
    // close before do_close() is called.
    //
    // The cef_life_span_handler_t::OnBeforeclose() function will be called
    // immediately before the browser object is destroyed. The application should
    // only exit after OnBeforeclose() has been called for all existing browsers.
    //
    // If the browser represents a modal window and a custom modal loop
    // implementation was provided in cef_life_span_handler_t::run_modal() this
    // callback should be used to restore the opener window to a usable state.
    //
    // By way of example consider what should happen during window close when the
    // browser is parented to an application-provided top-level OS window. 1.
    // User clicks the window close button which sends an OS close
    //     notification (e.g. WM_CLOSE on Windows, performClose: on OS-X and
    //     "delete_event" on Linux).
    // 2.  Application's top-level window receives the close notification and:
    //     A. Calls CefBrowserHost::CloseBrowser(false).
    //     B. Cancels the window close.
    // 3.  JavaScript 'onbeforeunload' handler executes and shows the close
    //     confirmation dialog (which can be overridden via
    //     CefJSDialogHandler::OnBeforeUnloadDialog()).
    // 4.  User approves the close. 5.  JavaScript 'onunload' handler executes. 6.
    // Application's do_close() handler is called. Application will:
    //     A. Call CefBrowserHost::ParentWindowWillClose() to notify CEF that the
    //        parent window will be closing.
    //     B. Set a flag to indicate that the next close attempt will be allowed.
    //     C. Return false.
    // 7.  CEF sends an OS close notification. 8.  Application's top-level window
    // receives the OS close notification and
    //     allows the window to close based on the flag from #6B.
    // 9.  Browser OS window is destroyed. 10. Application's
    // cef_life_span_handler_t::OnBeforeclose() handler is called and
    //     the browser object is destroyed.
    // 11. Application exits by calling cef_quit_message_loop() if no other
    // browsers
    //     exist.
    do_close: function(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cconv;

    // Called just before a browser is destroyed. Release all references to the
    // browser object and do not attempt to execute any functions on the browser
    // object after this callback returns. If this is a modal window and a custom
    // modal loop implementation was provided in run_modal() this callback should
    // be used to exit the custom modal loop. See do_close() documentation for
    // additional usage information.
    on_before_close: procedure(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;
  end;


{ *** cef_load_handler_capi.h  *** }
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
      browser: PCefBrowser; frame: PCefFrame); cconv;

    // Called when the browser is done loading a frame. The |frame| value will
    // never be NULL -- call the is_main() function to check if this frame is the
    // main frame. Multiple frames may be loading at the same time. Sub-frames may
    // start or continue loading after the main frame load has ended. This
    // function will always be called for all frames irrespective of whether the
    // request completes successfully.
    on_load_end: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; httpStatusCode: Integer); cconv;

    // Called when the browser fails to load a resource. |errorCode| is the error
    // code number, |errorText| is the error text and and |failedUrl| is the URL
    // that failed to load. See net\base\net_error_list.h for complete
    // descriptions of the error codes.
    {
    on_load_error: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; errorCode: TCefErrorCode; const errorText, failedUrl: PCefString); cconv;
    }
    on_load_error: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; errorCode: Integer; const errorText, failedUrl: PCefString); cconv;

    // Called when the render process terminates unexpectedly. |status| indicates
    // how the process terminated.
    on_render_process_terminated: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      status: TCefTerminationStatus); cconv;

    // Called when a plugin has crashed. |plugin_path| is the path of the plugin
    // that crashed.
    on_plugin_crashed: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      const plugin_path: PCefString); cconv;
  end;


{ *** cef_menu_model_capi.h  *** }
  // Supports creation and modification of menus. See cef_menu_id_t for the
  // command ids that have default implementations. All user-defined command ids
  // should be between MENU_ID_USER_FIRST and MENU_ID_USER_LAST. The functions of
  // this structure can only be accessed on the browser process the UI thread.
  TCefMenuModel = record
    // Base structure.
    base: TCefBase;

    // Clears the menu. Returns true (1) on success.
    clear: function(self: PCefMenuModel): Integer; cconv;

    // Returns the number of items in this menu.
    get_count: function(self: PCefMenuModel): Integer; cconv;

    // Add a separator to the menu. Returns true (1) on success.
    add_separator: function(self: PCefMenuModel): Integer; cconv;

    // Add an item to the menu. Returns true (1) on success.
    add_item: function(self: PCefMenuModel; command_id: Integer;
      const label_: PCefString): Integer; cconv;

    // Add a check item to the menu. Returns true (1) on success.
    add_check_item: function(self: PCefMenuModel; command_id: Integer;
      const label_: PCefString): Integer; cconv;

    // Add a radio item to the menu. Only a single item with the specified
    // |group_id| can be checked at a time. Returns true (1) on success.
    add_radio_item: function(self: PCefMenuModel; command_id: Integer;
      const label_: PCefString; group_id: Integer): Integer; cconv;

    // Add a sub-menu to the menu. The new sub-menu is returned.
    add_sub_menu: function(self: PCefMenuModel; command_id: Integer;
      const label_: PCefString): PCefMenuModel; cconv;

    // Insert a separator in the menu at the specified |index|. Returns true (1)
    // on success.
    insert_separator_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Insert an item in the menu at the specified |index|. Returns true (1) on
    // success.
    insert_item_at: function(self: PCefMenuModel; index, command_id: Integer;
      const label_: PCefString): Integer; cconv;

    // Insert a check item in the menu at the specified |index|. Returns true (1)
    // on success.
    insert_check_item_at: function(self: PCefMenuModel; index, command_id: Integer;
      const label_: PCefString): Integer; cconv;

    // Insert a radio item in the menu at the specified |index|. Only a single
    // item with the specified |group_id| can be checked at a time. Returns true
    // (1) on success.
    insert_radio_item_at: function(self: PCefMenuModel; index, command_id: Integer;
      const label_: PCefString; group_id: Integer): Integer; cconv;

    // Insert a sub-menu in the menu at the specified |index|. The new sub-menu is
    // returned.
    insert_sub_menu_at: function(self: PCefMenuModel; index, command_id: Integer;
      const label_: PCefString): PCefMenuModel; cconv;

    // Removes the item with the specified |command_id|. Returns true (1) on
    // success.
    remove: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Removes the item at the specified |index|. Returns true (1) on success.
    remove_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Returns the index associated with the specified |command_id| or -1 if not
    // found due to the command id not existing in the menu.
    get_index_of: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Returns the command id at the specified |index| or -1 if not found due to
    // invalid range or the index being a separator.
    get_command_id_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Sets the command id at the specified |index|. Returns true (1) on success.
    set_command_id_at: function(self: PCefMenuModel; index, command_id: Integer): Integer; cconv;

    // Returns the label for the specified |command_id| or NULL if not found.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_label: function(self: PCefMenuModel; command_id: Integer): PCefStringUserFree; cconv;

    // Returns the label at the specified |index| or NULL if not found due to
    // invalid range or the index being a separator.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_label_at: function(self: PCefMenuModel; index: Integer): PCefStringUserFree; cconv;

    // Sets the label for the specified |command_id|. Returns true (1) on success.
    set_label: function(self: PCefMenuModel; command_id: Integer;
      const label_: PCefString): Integer; cconv;

    // Set the label at the specified |index|. Returns true (1) on success.
    set_label_at: function(self: PCefMenuModel; index: Integer;
      const label_: PCefString): Integer; cconv;

    // Returns the item type for the specified |command_id|.
    get_type: function(self: PCefMenuModel; command_id: Integer): TCefMenuItemType; cconv;

    // Returns the item type at the specified |index|.
    get_type_at: function(self: PCefMenuModel; index: Integer): TCefMenuItemType; cconv;

    // Returns the group id for the specified |command_id| or -1 if invalid.
    get_group_id: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Returns the group id at the specified |index| or -1 if invalid.
    get_group_id_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Sets the group id for the specified |command_id|. Returns true (1) on
    // success.
    set_group_id: function(self: PCefMenuModel; command_id, group_id: Integer): Integer; cconv;

    // Sets the group id at the specified |index|. Returns true (1) on success.
    set_group_id_at: function(self: PCefMenuModel; index, group_id: Integer): Integer; cconv;

    // Returns the submenu for the specified |command_id| or NULL if invalid.
    get_sub_menu: function(self: PCefMenuModel; command_id: Integer): PCefMenuModel; cconv;

    // Returns the submenu at the specified |index| or NULL if invalid.
    get_sub_menu_at: function(self: PCefMenuModel; index: Integer): PCefMenuModel; cconv;

    // Returns true (1) if the specified |command_id| is visible.
    is_visible: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Returns true (1) if the specified |index| is visible.
    is_visible_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Change the visibility of the specified |command_id|. Returns true (1) on
    // success.
    set_visible: function(self: PCefMenuModel; command_id, visible: Integer): Integer; cconv;

    // Change the visibility at the specified |index|. Returns true (1) on
    // success.
    set_visible_at: function(self: PCefMenuModel; index, visible: Integer): Integer; cconv;

    // Returns true (1) if the specified |command_id| is enabled.
    is_enabled: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Returns true (1) if the specified |index| is enabled.
    is_enabled_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Change the enabled status of the specified |command_id|. Returns true (1)
    // on success.
    set_enabled: function(self: PCefMenuModel; command_id, enabled: Integer): Integer; cconv;

    // Change the enabled status at the specified |index|. Returns true (1) on
    // success.
    set_enabled_at: function(self: PCefMenuModel; index, enabled: Integer): Integer; cconv;

    // Returns true (1) if the specified |command_id| is checked. Only applies to
    // check and radio items.
    is_checked: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Returns true (1) if the specified |index| is checked. Only applies to check
    // and radio items.
    is_checked_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Check the specified |command_id|. Only applies to check and radio items.
    // Returns true (1) on success.
    set_checked: function(self: PCefMenuModel; command_id, checked: Integer): Integer; cconv;

    // Check the specified |index|. Only applies to check and radio items. Returns
    // true (1) on success.
    set_checked_at: function(self: PCefMenuModel; index, checked: Integer): Integer; cconv;

    // Returns true (1) if the specified |command_id| has a keyboard accelerator
    // assigned.
    has_accelerator: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Returns true (1) if the specified |index| has a keyboard accelerator
    // assigned.
    has_accelerator_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Set the keyboard accelerator for the specified |command_id|. |key_code| can
    // be any virtual key or character value. Returns true (1) on success.
    set_accelerator: function(self: PCefMenuModel; command_id, key_code,
      shift_pressed, ctrl_pressed, alt_pressed: Integer): Integer; cconv;

    // Set the keyboard accelerator at the specified |index|. |key_code| can be
    // any virtual key or character value. Returns true (1) on success.
    set_accelerator_at: function(self: PCefMenuModel; index, key_code,
      shift_pressed, ctrl_pressed, alt_pressed: Integer): Integer; cconv;

    // Remove the keyboard accelerator for the specified |command_id|. Returns
    // true (1) on success.
    remove_accelerator: function(self: PCefMenuModel; command_id: Integer): Integer; cconv;

    // Remove the keyboard accelerator at the specified |index|. Returns true (1)
    // on success.
    remove_accelerator_at: function(self: PCefMenuModel; index: Integer): Integer; cconv;

    // Retrieves the keyboard accelerator for the specified |command_id|. Returns
    // true (1) on success.
    get_accelerator: function(self: PCefMenuModel; command_id: Integer; key_code,
      shift_pressed, ctrl_pressed, alt_pressed: PInteger): Integer; cconv;

    // Retrieves the keyboard accelerator for the specified |index|. Returns true
    // (1) on success.
    get_accelerator_at: function(self: PCefMenuModel; index: Integer; key_code,
      shift_pressed, ctrl_pressed, alt_pressed: PInteger): Integer; cconv;
  end;


{ *** cef_process_message_capi.h  *** }
  // Structure representing a message. Can be used on any process and thread.
  TCefProcessMessage = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefProcessMessage): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefProcessMessage): Integer; cconv;

    // Returns a writable copy of this object.
    copy: function(self: PCefProcessMessage): PCefProcessMessage; cconv;

    // Returns the message name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefProcessMessage): PCefStringUserFree; cconv;

    // Returns the list of arguments.
    get_argument_list: function(self: PCefProcessMessage): PCefListValue; cconv;
  end;


{ ***  cef_render_handler_capi.h  *** }
  // Implement this structure to handle events when window rendering is disabled.
  // The functions of this structure will be called on the UI thread.
  TCefRenderHandler = record
    // Base structure.
    base: TCefBase;

    // Called to retrieve the root window rectangle in screen coordinates. Return
    // true (1) if the rectangle was provided.
    get_root_screen_rect: function(self: PCefRenderHandler; browser: PCefBrowser;
      rect: PCefRect): Integer; cconv;

    // Called to retrieve the view rectangle which is relative to screen
    // coordinates. Return true (1) if the rectangle was provided.
    get_view_rect: function(self: PCefRenderHandler; browser: PCefBrowser;
      rect: PCefRect): Integer; cconv;

    // Called to retrieve the translation from view coordinates to actual screen
    // coordinates. Return true (1) if the screen coordinates were provided.
    get_screen_point: function(self: PCefRenderHandler; browser: PCefBrowser;
      viewX, viewY: Integer; screenX, screenY: PInteger): Integer; cconv;

    // Called to allow the client to fill in the CefScreenInfo object with
    // appropriate values. Return true (1) if the |screen_info| structure has been
    // modified.
    //
    // If the screen info rectangle is left NULL the rectangle from GetViewRect
    // will be used. If the rectangle is still NULL or invalid popups may not be
    // drawn correctly.
    get_screen_info: function(self: PCefRenderHandler; browser: PCefBrowser; screen_info: PCefScreenInfo): Integer; cconv;

    // Called when the browser wants to show or hide the popup widget. The popup
    // should be shown if |show| is true (1) and hidden if |show| is false (0).
    on_popup_show: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      show: Integer); cconv;

    // Called when the browser wants to move or resize the popup widget. |rect|
    // contains the new location and size.
    on_popup_size: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      const rect: PCefRect); cconv;

    // Called when an element should be painted. |type| indicates whether the
    // element is the view or the popup widget. |buffer| contains the pixel data
    // for the whole image. |dirtyRects| contains the set of rectangles that need
    // to be repainted. On Windows |buffer| will be |width|*|height|*4 bytes in
    // size and represents a BGRA image with an upper-left origin.
    on_paint: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser;
      type_: TCefPaintElementType; dirtyRectsCount: csize_t;
      const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer); cconv;

    // Called when the browser window's cursor has changed.
    on_cursor_change: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser; cursor: TCefCursorHandle); cconv;

    // Called when the scroll offset has changed.
    on_scroll_offset_changed: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser); cconv;
  end;


{ *** cef_render_process_handler_capi.h  *** }
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
      extra_info: PCefListValue); cconv;

    // Called after WebKit has been initialized.
    on_web_kit_initialized: procedure(self: PCefRenderProcessHandler); cconv;

    // Called after a browser has been created. When browsing cross-origin a new
    // browser will be created before the old browser with the same identifier is
    // destroyed.
    on_browser_created: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser); cconv;

    // Called before a browser is destroyed.
    on_browser_destroyed: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser); cconv;

    // Called before browser navigation. Return true (1) to cancel the navigation
    // or false (0) to allow the navigation to proceed. The |request| object
    // cannot be modified in this callback.
    on_before_navigation: function(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; request: PCefRequest;
      navigation_type: TCefNavigationType; is_redirect: Integer): Integer; cconv;

    // Called immediately after the V8 context for a frame has been created. To
    // retrieve the JavaScript 'window' object use the
    // cef_v8context_t::get_global() function. V8 handles can only be accessed
    // from the thread on which they are created. A task runner for posting tasks
    // on the associated thread can be retrieved via the
    // cef_v8context_t::get_task_runner() function.
    on_context_created: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context); cconv;

    // Called immediately before the V8 context for a frame is released. No
    // references to the context should be kept after this function is called.
    on_context_released: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context); cconv;

    // Called for global uncaught exceptions in a frame. Execution of this
    // callback is disabled by default. To enable set
    // CefSettings.uncaught_exception_stack_size > 0.
    on_uncaught_exception: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; context: PCefv8Context;
      exception: PCefV8Exception; stackTrace: PCefV8StackTrace); cconv;

    // Called when a new node in the the browser gets focus. The |node| value may
    // be NULL if no specific node has gained focus. The node object passed to
    // this function represents a snapshot of the DOM at the time this function is
    // executed. DOM objects are only valid for the scope of this function. Do not
    // keep references to or attempt to access any DOM objects outside the scope
    // of this function.
    on_focused_node_changed: procedure(self: PCefRenderProcessHandler;
      browser: PCefBrowser; frame: PCefFrame; node: PCefDomNode); cconv;

    // Called when a new message is received from a different process. Return true
    // (1) if the message was handled or false (0) otherwise. Do not keep a
    // reference to or attempt to access the message outside of this callback.
    on_process_message_received: function(self: PCefRenderProcessHandler;
      browser: PCefBrowser; source_process: TCefProcessId;
      message: PCefProcessMessage): Integer; cconv;
  end;


{ ***  cef_request_capi.h  *** }
  // Structure used to represent a web request. The functions of this structure
  // may be called on any thread.
  TCefRequest = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefRequest): Integer; cconv;

    // Get the fully qualified URL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefRequest): PCefStringUserFree; cconv;

    // Set the fully qualified URL.
    set_url: procedure(self: PCefRequest; const url: PCefString); cconv;

    // Get the request function type. The value will default to POST if post data
    // is provided and GET otherwise.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_method: function(self: PCefRequest): PCefStringUserFree; cconv;

    // Set the request function type.
    set_method: procedure(self: PCefRequest; const method: PCefString); cconv;

    // Get the post data.
    get_post_data: function(self: PCefRequest): PCefPostData; cconv;

    // Set the post data.
    set_post_data: procedure(self: PCefRequest; postData: PCefPostData); cconv;

    // Get the header values.
    get_header_map: procedure(self: PCefRequest; headerMap: TCefStringMultimap); cconv;

    // Set the header values.
    set_header_map: procedure(self: PCefRequest; headerMap: TCefStringMultimap); cconv;

    // Set all values at one time.
    set_: procedure(self: PCefRequest; const url, method: PCefString;
      postData: PCefPostData; headerMap: TCefStringMultimap); cconv;

    // Get the flags used in combination with cef_urlrequest_t. See
    // cef_urlrequest_flags_t for supported values.
    //get_flags: function(self: PCefRequest): Integer; cconv;
    get_flags: function(self: PCefRequest): TCefUrlRequestFlags; cconv;

    // Set the flags used in combination with cef_urlrequest_t.  See
    // cef_urlrequest_flags_t for supported values.
    set_flags: procedure(self: PCefRequest; flags: Integer); cconv;

    // Set the URL to the first party for cookies used in combination with
    // cef_urlrequest_t.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_first_party_for_cookies: function(self: PCefRequest): PCefStringUserFree; cconv;

    // Get the URL to the first party for cookies used in combination with
    // cef_urlrequest_t.
    set_first_party_for_cookies: procedure(self: PCefRequest; const url: PCefString); cconv;
  end;


  // Structure used to represent post data for a web request. The functions of
  // this structure may be called on any thread.
  TCefPostData = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefPostData):Integer; cconv;

    // Returns the number of existing post data elements.
    get_element_count: function(self: PCefPostData): csize_t; cconv;

    // Retrieve the post data elements.
    get_elements: procedure(self: PCefPostData; elementsCount: Pcsize_t;
      elements: PCefPostDataElementArray); cconv;

    // Remove the specified post data element.  Returns true (1) if the removal
    // succeeds.
    remove_element: function(self: PCefPostData;
      element: PCefPostDataElement): Integer; cconv;

    // Add the specified post data element.  Returns true (1) if the add succeeds.
    add_element: function(self: PCefPostData;
        element: PCefPostDataElement): Integer; cconv;

    // Remove all existing post data elements.
    remove_elements: procedure(self: PCefPostData); cconv;
  end;

  TCefPostDataElementArray = array[0..(High(Integer) div SizeOf(PCefPostDataElement)) - 1] of PCefPostDataElement;

  // Structure used to represent a single element in the request post data. The
  // functions of this structure may be called on any thread.
  TCefPostDataElement = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefPostDataElement): Integer; cconv;

    // Remove all contents from the post data element.
    set_to_empty: procedure(self: PCefPostDataElement); cconv;

    // The post data element will represent a file.
    set_to_file: procedure(self: PCefPostDataElement;
        const fileName: PCefString); cconv;

    // The post data element will represent bytes.  The bytes passed in will be
    // copied.
    set_to_bytes: procedure(self: PCefPostDataElement;
        size: csize_t; const bytes: Pointer); cconv;

    // Return the type of this post data element.
    get_type: function(self: PCefPostDataElement): TCefPostDataElementType; cconv;

    // Return the file name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_file: function(self: PCefPostDataElement): PCefStringUserFree; cconv;

    // Return the number of bytes.
    get_bytes_count: function(self: PCefPostDataElement): csize_t; cconv;

    // Read up to |size| bytes into |bytes| and return the number of bytes
    // actually read.
    get_bytes: function(self: PCefPostDataElement;
        size: csize_t; bytes: Pointer): csize_t; cconv;
  end;


{ ***  cef_request_handler_capi.h  *** }
  // Callback structure used for asynchronous continuation of authentication
  // requests.
  TCefAuthCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the authentication request.
    cont: procedure(self: PCefAuthCallback;
        const username, password: PCefString); cconv;

    // Cancel the authentication request.
    cancel: procedure(self: PCefAuthCallback); cconv;
  end;


  // Callback structure used for asynchronous continuation of quota requests.
  TCefQuotaCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the quota request. If |allow| is true (1) the request will be
    // allowed. Otherwise, the request will be denied.
    cont: procedure(self: PCefQuotaCallback; allow: Integer); cconv;

    // Cancel the quota request.
    cancel: procedure(self: PCefQuotaCallback); cconv;
  end;


  // Callback structure used for asynchronous continuation of url requests when
  // invalid SSL certificates are encountered.
  TCefAllowCertificateErrorCallback = record
    // Base structure.
    base: TCefBase;

    // Continue the url request. If |allow| is true (1) the request will be
    // continued. Otherwise, the request will be canceled.
  		cont: procedure(self: PCefAllowCertificateErrorCallback; allow: Integer); cconv;
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
      browser: PCefBrowser; frame: PCefFrame; request: PCefRequest): Integer; cconv;

  		// Called on the IO thread before a resource is loaded. To allow the resource
  		// to load normally return NULL. To specify a handler for the resource return
  		// a cef_resource_handler_t object. The |request| object should not be
  		// modified in this callback.
  		get_resource_handler: function(self:PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; request: PCefRequest): PCefResourceHandler; cconv;

    // Called on the IO thread when a resource load is redirected. The |old_url|
    // parameter will contain the old URL. The |new_url| parameter will contain
    // the new URL and can be changed if desired.
    on_resource_redirect: procedure(self: PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; const old_url: PCefString;
      new_url: PCefString); cconv;

    // Called on the IO thread when the browser needs credentials from the user.
    // |isProxy| indicates whether the host is a proxy server. |host| contains the
    // hostname and |port| contains the port number. Return true (1) to continue
    // the request and call cef_auth_callback_t::cont() when the authentication
    // information is available. Return false (0) to cancel the request.
    get_auth_credentials: function(self: PCefRequestHandler;
      browser: PCefBrowser; frame: PCefFrame; isProxy: Integer; const host: PCefString;
      port: Integer; const realm, scheme: PCefString; callback: PCefAuthCallback): Integer; cconv;

    // Called on the IO thread when JavaScript requests a specific storage quota
    // size via the webkitStorageInfo.requestQuota function. |origin_url| is the
    // origin of the page making the request. |new_size| is the requested quota
    // size in bytes. Return true (1) and call cef_quota_callback_t::cont() either
    // in this function or at a later time to grant or deny the request. Return
    // false (0) to cancel the request.
    on_quota_request: function(self: PCefRequestHandler; browser: PCefBrowser;
      const origin_url: PCefString; new_size: Int64; callback: PCefQuotaCallback): Integer; cconv;

    // Called on the IO thread to retrieve the cookie manager. |main_url| is the
    // URL of the top-level frame. Cookies managers can be unique per browser or
    // shared across multiple browsers. The global cookie manager will be used if
    // this function returns NULL.
    get_cookie_manager: function(self: PCefRequestHandler;
      browser: PCefBrowser; const main_url: PCefString): PCefCookieManager; cconv;

    // Called on the UI thread to handle requests for URLs with an unknown
    // protocol component. Set |allow_os_execution| to true (1) to attempt
    // execution via the registered OS protocol handler, if any. SECURITY WARNING:
    // YOU SHOULD USE THIS METHOD TO ENFORCE RESTRICTIONS BASED ON SCHEME, HOST OR
    // OTHER URL ANALYSIS BEFORE ALLOWING OS EXECUTION.
    on_protocol_execution: procedure(self: PCefRequestHandler;
      browser: PCefBrowser; const url: PCefString; allow_os_execution: PInteger); cconv;

    // Called on the browser process IO thread before a plugin is loaded. Return
    // true (1) to block loading of the plugin.
    on_before_plugin_load: function(self: PCefRequestHandler; browser: PCefBrowser;
      const url, policy_url: PCefString; info: PCefWebPluginInfo): Integer; cconv;

    // Called on the UI thread to handle requests for URLs with an invalid SSL
    // certificate. Return true (1) and call
    // cef_allow_certificate_error_callback_t:: cont() either in this function or
    // at a later time to continue or cancel the request. Return false (0) to
    // cancel the request immediately. If |callback| is NULL the error cannot be
    // recovered from and the request will be canceled automatically. If
    // CefSettings.ignore_certificate_errors is set all invalid certificates will
    // be accepted without calling this function.
  		on_certificate_error: function(self: PCefRequestHandler; cert_error: TCefErrorcode;
      const request_url: PCefString; callback: PCefAllowCertificateErrorCallback): Integer; cconv;
  end;


{ ***  cef_resource_bundle_handler_capi.h  *** }
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
      message_id: Integer; string_: PCefString): Integer; cconv;

    // Called to retrieve data for the resource specified by |resource_id|. To
    // provide the resource data set |data| and |data_size| to the data pointer
    // and size respectively and return true (1). To use the default resource data
    // return false (0). The resource data will not be copied and must remain
    // resident in memory. Supported resource IDs are listed in
    // cef_pack_resources.h.
    get_data_resource: function(self: PCefResourceBundleHandler;
        resource_id: Integer; var data: Pointer; var data_size: csize_t): Integer; cconv;
  end;


{ ***  cef_resource_handler_capi.h  *** }
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
      request: PCefRequest; callback: PCefCallback): Integer; cconv;

    // Retrieve response header information. If the response length is not known
    // set |response_length| to -1 and read_response() will be called until it
    // returns false (0). If the response length is known set |response_length| to
    // a positive value and read_response() will be called until it returns false
    // (0) or the specified number of bytes have been read. Use the |response|
    // object to set the mime type, http status code and other optional header
    // values. To redirect the request to a new URL set |redirectUrl| to the new
    // URL.
    get_response_headers: procedure(self: PCefResourceHandler;
      response: PCefResponse; response_length: PInt64; redirectUrl: PCefString); cconv;

    // Read response data. If data is available immediately copy up to
    // |bytes_to_read| bytes into |data_out|, set |bytes_read| to the number of
    // bytes copied, and return true (1). To read the data at a later time set
    // |bytes_read| to 0, return true (1) and call cef_callback_t::cont() when the
    // data is available. To indicate response completion return false (0).
    read_response: function(self: PCefResourceHandler;
      data_out: Pointer; bytes_to_read: Integer; bytes_read: PInteger;
        callback: PCefCallback): Integer; cconv;

    // Return true (1) if the specified cookie can be sent with the request or
    // false (0) otherwise. If false (0) is returned for any cookie then no
    // cookies will be sent with the request.
    can_get_cookie: function(self: PCefResourceHandler;
      const cookie: PCefCookie): Integer; cconv;

    // Return true (1) if the specified cookie returned with the response can be
    // set or false (0) otherwise.
    can_set_cookie: function(self: PCefResourceHandler;
      const cookie: PCefCookie): Integer; cconv;

    // Request processing has been canceled.
    cancel: procedure(self: PCefResourceHandler); cconv;
  end;


{ ***  cef_response_capi.h  *** }
  // Structure used to represent a web response. The functions of this structure
  // may be called on any thread.
  TCefResponse = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefResponse): Integer; cconv;

    // Get the response status code.
    get_status: function(self: PCefResponse): Integer; cconv;

    // Set the response status code.
    set_status: procedure(self: PCefResponse; status: Integer); cconv;

    // Get the response status text.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_status_text: function(self: PCefResponse): PCefStringUserFree; cconv;

    // Set the response status text.
    set_status_text: procedure(self: PCefResponse; const statusText: PCefString); cconv;

    // Get the response mime type.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_mime_type: function(self: PCefResponse): PCefStringUserFree; cconv;

    // Set the response mime type.
    set_mime_type: procedure(self: PCefResponse; const mimeType: PCefString); cconv;

    // Get the value for the specified response header field.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_header: function(self: PCefResponse; const name: PCefString): PCefStringUserFree; cconv;

    // Get all response header fields.
    get_header_map: procedure(self: PCefResponse; headerMap: TCefStringMultimap); cconv;

    // Set all response header fields.
    set_header_map: procedure(self: PCefResponse; headerMap: TCefStringMultimap); cconv;
  end;


{ ***  cef_scheme_capi.h  *** }
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
      is_display_isolated: Integer): Integer; cconv;
  end;


  // Structure that creates cef_resource_handler_t instances for handling scheme
  // requests. The functions of this structure will always be called on the IO
  // thread.
  TCefSchemeHandlerFactory = record
    // Base structure.
    base: TCefBase;

    // Return a new resource handler instance to handle the request or an NULL
    // reference to allow default handling of the request. |browser| and |frame|
    // will be the browser window and frame respectively that originated the
    // request or NULL if the request did not originate from a browser window (for
    // example, if the request came from cef_urlrequest_t). The |request| object
    // passed to this function will not contain cookie data.
    create: function(self: PCefSchemeHandlerFactory;
        browser: PCefBrowser; frame: PCefFrame; const scheme_name: PCefString;
        request: PCefRequest): PCefResourceHandler; cconv;
  end;


{ ***  cef_stream_capi.h  *** }
  // Structure the client can implement to provide a custom stream reader. The
  // functions of this structure may be called on any thread.
  TCefReadHandler = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefReadHandler; ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Return zero on success and non-zero on failure.
    seek: function(self: PCefReadHandler; offset: Int64; whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefReadHandler): Int64; cconv;

    // Return non-zero if at end of file.
    eof: function(self: PCefReadHandler): Integer; cconv;
  end;


  // Structure used to read data from a stream. The functions of this structure
  // may be called on any thread.
  TCefStreamReader = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefStreamReader; ptr: Pointer;
        size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamReader; offset: Int64;
        whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefStreamReader): Int64; cconv;

    // Return non-zero if at end of file.
    eof: function(self: PCefStreamReader): Integer; cconv;
  end;


  // Structure the client can implement to provide a custom stream writer. The
  // functions of this structure may be called on any thread.
  TCefWriteHandler = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefWriteHandler;
        const ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Return zero on success and non-zero on failure.
    seek: function(self: PCefWriteHandler; offset: Int64;
        whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefWriteHandler): Int64; cconv;

    // Flush the stream.
    flush: function(self: PCefWriteHandler): Integer; cconv;
  end;


  // Structure used to write data to a stream. The functions of this structure may
  // be called on any thread.
  TCefStreamWriter = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefStreamWriter;
        const ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamWriter; offset: Int64;
        whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefStreamWriter): Int64; cconv;

    // Flush the stream.
    flush: function(self: PCefStreamWriter): Integer; cconv;
  end;


{ ***  cef_string_visitor_capi.h  *** }
  // Implement this structure to receive string values asynchronously.
  TCefStringVisitor = record
    // Base structure.
    base: TCefBase;

    // Method that will be executed.
    visit: procedure(self: PCefStringVisitor; const str: PCefString); cconv;
  end;


{ ***  cef_task_capi.h  *** }
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
    execute: procedure(self: PCefTask); cconv;
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
    is_same: function(self, that: PCefTaskRunner): Integer; cconv;

    // Returns true (1) if this task runner belongs to the current thread.
    belongs_to_current_thread: function(self: PCefTaskRunner): Integer; cconv;

    // Returns true (1) if this task runner is for the specified CEF thread.
    belongs_to_thread: function(self: PCefTaskRunner; threadId: TCefThreadId): Integer; cconv;

    // Post a task for execution on the thread associated with this task runner.
    // Execution will occur asynchronously.
    post_task: function(self: PCefTaskRunner; task: PCefTask): Integer; cconv;

    // Post a task for delayed execution on the thread associated with this task
    // runner. Execution will occur asynchronously. Delayed tasks are not
    // supported on V8 WebWorker threads and will be executed without the
    // specified delay.
    post_delayed_task: function(self: PCefTaskRunner; task: PCefTask; delay_ms: Int64): Integer; cconv;
  end;


{ ***  cef_trace_capi.h  *** }
  // Implement this structure to receive trace notifications. The functions of
  // this structure will be called on the browser process UI thread.
  TCefTraceClient = record
    // Base structure.
    base: TCefBase;

    // Called 0 or more times between CefBeginTracing and OnEndTracingComplete
    // with a UTF8 JSON |fragment| of the specified |fragment_size|. Do not keep a
    // reference to |fragment|.
    on_trace_data_collected: procedure(self: PCefTraceClient;
        const fragment: PAnsiChar; fragment_size: csize_t); cconv;

    // Called in response to CefGetTraceBufferPercentFullAsync.
    on_trace_buffer_percent_full_reply: procedure(self: PCefTraceClient; percent_full: Single); cconv;

    // Called after all processes have sent their trace data.
    on_end_tracing_complete: procedure(self: PCefTraceClient); cconv;
  end;


{ ***  cef_urlrequest_capi.h  *** }
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
    get_request: function(self: PCefUrlRequest): PCefRequest; cconv;

    // Returns the client.
    get_client: function(self: PCefUrlRequest): PCefUrlRequestClient; cconv;

    // Returns the request status.
    get_request_status: function(self: PCefUrlRequest): TCefUrlRequestStatus; cconv;

    // Returns the request error if status is UR_CANCELED or UR_FAILED, or 0
    // otherwise.
    get_request_error: function(self: PCefUrlRequest): Integer; cconv;

    // Returns the response, or NULL if no response information is available.
    // Response information will only be available after the upload has completed.
    // The returned object is read-only and should not be modified.
    get_response: function(self: PCefUrlRequest): PCefResponse; cconv;

    // Cancel the request.
    cancel: procedure(self: PCefUrlRequest); cconv;
  end;


  // Structure that should be implemented by the cef_urlrequest_t client. The
  // functions of this structure will be called on the same thread that created
  // the request.
  TCefUrlRequestClient = record
    // Base structure.
    base: TCefBase;

    // Notifies the client that the request has completed. Use the
    // cef_urlrequest_t::GetRequestStatus function to determine if the request was
    // successful or not.
    on_request_complete: procedure(self: PCefUrlRequestClient; request: PCefUrlRequest); cconv;

    // Notifies the client of upload progress. |current| denotes the number of
    // bytes sent so far and |total| is the total size of uploading data (or -1 if
    // chunked upload is enabled). This function will only be called if the
    // UR_FLAG_REPORT_UPLOAD_PROGRESS flag is set on the request.
    on_upload_progress: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; current, total: UInt64); cconv;

    // Notifies the client of download progress. |current| denotes the number of
    // bytes received up to the call and |total| is the expected total size of the
    // response (or -1 if not determined).
    on_download_progress: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; current, total: UInt64); cconv;

    // Called when some part of the response is read. |data| contains the current
    // bytes received since the last call. This function will not be called if the
    // UR_FLAG_NO_DOWNLOAD_DATA flag is set on the request.
    on_download_data: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; const data: Pointer; data_length: csize_t); cconv;
  end;


{ ***  cef_v8_capi.h  *** }
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
    get_task_runner: function(self: PCefv8Context): PCefTask; cconv;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefv8Context): Integer; cconv;

    // Returns the browser for this context. This function will return an NULL
    // reference for WebWorker contexts.
    get_browser: function(self: PCefv8Context): PCefBrowser; cconv;

    // Returns the frame for this context. This function will return an NULL
    // reference for WebWorker contexts.
    get_frame: function(self: PCefv8Context): PCefFrame; cconv;

    // Returns the global object for this context. The context must be entered
    // before calling this function.
    get_global: function(self: PCefv8Context): PCefv8Value; cconv;

    // Enter this context. A context must be explicitly entered before creating a
    // V8 Object, Array, Function or Date asynchronously. exit() must be called
    // the same number of times as enter() before releasing this context. V8
    // objects belong to the context in which they are created. Returns true (1)
    // if the scope was entered successfully.
    enter: function(self: PCefv8Context): Integer; cconv;

    // Exit this context. Call this function only after calling enter(). Returns
    // true (1) if the scope was exited successfully.
    exit: function(self: PCefv8Context): Integer; cconv;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefv8Context): Integer; cconv;

    // Evaluates the specified JavaScript code using this context's global object.
    // On success |retval| will be set to the return value, if any, and the
    // function will return true (1). On failure |exception| will be set to the
    // exception, if any, and the function will return false (0).
    eval: function(self: PCefv8Context; const code: PCefString;
      var retval: PCefv8Value; var exception: PCefV8Exception): Integer; cconv;
  end;


  // Structure that should be implemented to handle V8 function calls. The
  // functions of this structure will be called on the thread associated with the
  // V8 function.
  TCefV8Handler = record
    // Base structure.
    base: TCefBase;

    // Handle execution of the function identified by |name|. |object| is the
    // receiver ('this' object) of the function. |arguments| is the list of
    // arguments passed to the function. If execution succeeds set |retval| to the
    // function return value. If execution fails set |exception| to the exception
    // that will be thrown. Return true (1) if execution was handled.
    {$NOTE check var usage}
    execute: function(self: PCefv8Handler;
        const name: PCefString; object_: PCefv8Value; argumentsCount: Cardinal;
        const arguments: PPCefV8Value; var retval: PCefV8Value;
        var exception: TCefString): Integer; cconv;
        //exception: PCefString): Integer; cconv;
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
      object_: PCefv8Value; out retval: PCefv8Value; exception: PCefString): Integer; cconv;

    // Handle assignment of the accessor value identified by |name|. |object| is
    // the receiver ('this' object) of the accessor. |value| is the new value
    // being assigned to the accessor. If assignment fails set |exception| to the
    // exception that will be thrown. Return true (1) if accessor assignment was
    // handled.
    set_: function(self: PCefV8Accessor; const name: PCefString;
      obj: PCefv8Value; value: PCefv8Value; exception: PCefString): Integer; cconv;
  end;


  // Structure representing a V8 exception. The functions of this structure may be
  // called on any render process thread.
  TCefV8Exception = record
    // Base structure.
    base: TCefBase;

    // Returns the exception message.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_message: function(self: PCefV8Exception): PCefStringUserFree; cconv;

    // Returns the line of source code that the exception occurred within.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_source_line: function(self: PCefV8Exception): PCefStringUserFree; cconv;

    // Returns the resource name for the script from where the function causing
    // the error originates.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_script_resource_name: function(self: PCefV8Exception): PCefStringUserFree; cconv;

    // Returns the 1-based number of the line where the error occurred or 0 if the
    // line number is unknown.
    get_line_number: function(self: PCefV8Exception): Integer; cconv;

    // Returns the index within the script of the first character where the error
    // occurred.
    get_start_position: function(self: PCefV8Exception): Integer; cconv;

    // Returns the index within the script of the last character where the error
    // occurred.
    get_end_position: function(self: PCefV8Exception): Integer; cconv;

    // Returns the index within the line of the first character where the error
    // occurred.
    get_start_column: function(self: PCefV8Exception): Integer; cconv;

    // Returns the index within the line of the last character where the error
    // occurred.
    get_end_column: function(self: PCefV8Exception): Integer; cconv;
  end;


  // Structure representing a V8 value handle. V8 handles can only be accessed
  // from the thread on which they are created. Valid threads for creating a V8
  // handle include the render process main thread (TID_RENDERER) and WebWorker
  // threads. A task runner for posting tasks on the associated thread can be
  // retrieved via the cef_v8context_t::get_task_runner() function.
  TCefV8Value = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is undefined.
    is_undefined: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is null.
    is_null: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is bool.
    is_bool: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is int.
    is_int: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is unsigned int.
    is_uint: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is double.
    is_double: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is Date.
    is_date: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is string.
    is_string: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is object.
    is_object: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is array.
    is_array: function(self: PCefv8Value): Integer; cconv;

    // True if the value type is function.
    is_function: function(self: PCefv8Value): Integer; cconv;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefv8Value): Integer; cconv;

    // Return a bool value.  The underlying data will be converted to if
    // necessary.
    get_bool_value: function(self: PCefv8Value): Integer; cconv;

    // Return an int value.  The underlying data will be converted to if
    // necessary.
    get_int_value: function(self: PCefv8Value): Integer; cconv;

    // Return an unisgned int value.  The underlying data will be converted to if
    // necessary.
    get_uint_value: function(self: PCefv8Value): UInt32; cconv;

    // Return a double value.  The underlying data will be converted to if
    // necessary.
    get_double_value: function(self: PCefv8Value): Double; cconv;

    // Return a Date value.  The underlying data will be converted to if
    // necessary.
    get_date_value: function(self: PCefv8Value): TCefTime; cconv;

    // Return a string value.  The underlying data will be converted to if
    // necessary.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string_value: function(self: PCefv8Value): PCefStringUserFree; cconv;


    // OBJECT METHODS - These functions are only available on objects. Arrays and
    // functions are also objects. String- and integer-based keys can be used
    // interchangably with the framework converting between them as necessary.

    // Returns true (1) if this is a user created object.
    is_user_created: function(self: PCefv8Value): Integer; cconv;

    // Returns true (1) if the last function call resulted in an exception. This
    // attribute exists only in the scope of the current CEF value object.
    has_exception: function(self: PCefv8Value): Integer; cconv;

    // Returns the exception resulting from the last function call. This attribute
    // exists only in the scope of the current CEF value object.
    get_exception: function(self: PCefv8Value): PCefV8Exception; cconv;

    // Clears the last exception and returns true (1) on success.
    clear_exception: function(self: PCefv8Value): Integer; cconv;

    // Returns true (1) if this object will re-throw future exceptions. This
    // attribute exists only in the scope of the current CEF value object.
    will_rethrow_exceptions: function(self: PCefv8Value): Integer; cconv;

    // Set whether this object will re-throw future exceptions. By default
    // exceptions are not re-thrown. If a exception is re-thrown the current
    // context should not be accessed again until after the exception has been
    // caught and not re-thrown. Returns true (1) on success. This attribute
    // exists only in the scope of the current CEF value object.
    set_rethrow_exceptions: function(self: PCefv8Value; rethrow: Integer): Integer; cconv;

    // Returns true (1) if the object has a value with the specified identifier.
    has_value_bykey: function(self: PCefv8Value; const key: PCefString): Integer; cconv;

    // Returns true (1) if the object has a value with the specified identifier.
    has_value_byindex: function(self: PCefv8Value; index: Integer): Integer; cconv;

    // Deletes the value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly or an
    // exception is thrown. For read-only and don't-delete values this function
    // will return true (1) even though deletion failed.
    delete_value_bykey: function(self: PCefv8Value; const key: PCefString): Integer; cconv;

    // Deletes the value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly, deletion
    // fails or an exception is thrown. For read-only and don't-delete values this
    // function will return true (1) even though deletion failed.
    delete_value_byindex: function(self: PCefv8Value; index: Integer): Integer; cconv;

    // Returns the value with the specified identifier on success. Returns NULL if
    // this function is called incorrectly or an exception is thrown.
    get_value_bykey: function(self: PCefv8Value; const key: PCefString): PCefv8Value; cconv;

    // Returns the value with the specified identifier on success. Returns NULL if
    // this function is called incorrectly or an exception is thrown.
    get_value_byindex: function(self: PCefv8Value; index: Integer): PCefv8Value; cconv;

    // Associates a value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly or an
    // exception is thrown. For read-only values this function will return true
    // (1) even though assignment failed.
    set_value_bykey: function(self: PCefv8Value; const key: PCefString;
      value: PCefv8Value; attribute: Integer): Integer; cconv;

    // Associates a value with the specified identifier and returns true (1) on
    // success. Returns false (0) if this function is called incorrectly or an
    // exception is thrown. For read-only values this function will return true
    // (1) even though assignment failed.
    set_value_byindex: function(self: PCefv8Value; index: Integer;
       value: PCefv8Value): Integer; cconv;

    // Registers an identifier and returns true (1) on success. Access to the
    // identifier will be forwarded to the cef_v8accessor_t instance passed to
    // cef_v8value_t::cef_v8value_create_object(). Returns false (0) if this
    // function is called incorrectly or an exception is thrown. For read-only
    // values this function will return true (1) even though assignment failed.
    {$NOTE Integer -> TCefV8AccessControl / TCefV8PropertyAttribute}
    set_value_byaccessor: function(self: PCefv8Value; const key: PCefString;
      settings: Integer; attribute: Integer): Integer; cconv;

    // Read the keys for the object's values into the specified vector. Integer-
    // based keys will also be returned as strings.
    get_keys: function(self: PCefv8Value; keys: TCefStringList): Integer; cconv;

    // Sets the user data for this object and returns true (1) on success. Returns
    // false (0) if this function is called incorrectly. This function can only be
    // called on user created objects.
    set_user_data: function(self: PCefv8Value; user_data: PCefBase): Integer; cconv;

    // Returns the user data, if any, assigned to this object.
    get_user_data: function(self: PCefv8Value): PCefBase; cconv;

    // Returns the amount of externally allocated memory registered for the
    // object.
    get_externally_allocated_memory: function(self: PCefv8Value): Integer; cconv;

    // Adjusts the amount of registered external memory for the object. Used to
    // give V8 an indication of the amount of externally allocated memory that is
    // kept alive by JavaScript objects. V8 uses this information to decide when
    // to perform global garbage collection. Each cef_v8value_t tracks the amount
    // of external memory associated with it and automatically decreases the
    // global total by the appropriate amount on its destruction.
    // |change_in_bytes| specifies the number of bytes to adjust by. This function
    // returns the number of bytes associated with the object after the
    // adjustment. This function can only be called on user created objects.
    adjust_externally_allocated_memory: function(self: PCefv8Value; change_in_bytes: Integer): Integer; cconv;


    // ARRAY METHODS - These functions are only available on arrays.

    // Returns the number of elements in the array.
    get_array_length: function(self: PCefv8Value): Integer; cconv;


    // FUNCTION METHODS - These functions are only available on functions.

    // Returns the function name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_function_name: function(self: PCefv8Value): PCefStringUserFree; cconv;

    // Returns the function handler or NULL if not a CEF-created function.
    get_function_handler: function(self: PCefv8Value): PCefv8Handler; cconv;

    // Execute the function using the current V8 context. This function should
    // only be called from within the scope of a cef_v8handler_t or
    // cef_v8accessor_t callback, or in combination with calling enter() and
    // exit() on a stored cef_v8context_t reference. |object| is the receiver
    // ('this' object) of the function. If |object| is NULL the current context's
    // global object will be used. |arguments| is the list of arguments that will
    // be passed to the function. Returns the function return value on success.
    // Returns NULL if this function is called incorrectly or an exception is
    // thrown.
    execute_function: function(self: PCefv8Value; object_: PCefv8Value;
      argumentsCount: csize_t; const arguments: PPCefV8Value): PCefv8Value; cconv;

    // Execute the function using the specified V8 context. |object| is the
    // receiver ('this' object) of the function. If |object| is NULL the specified
    // context's global object will be used. |arguments| is the list of arguments
    // that will be passed to the function. Returns the function return value on
    // success. Returns NULL if this function is called incorrectly or an
    // exception is thrown.
    execute_function_with_context: function(self: PCefv8Value; context: PCefv8Context;
      object_: PCefv8Value; argumentsCount: csize_t; const arguments: PPCefV8Value): PCefv8Value; cconv;
  end;

  PCefV8ValueArray = array[0..(High(Integer) div SizeOf(Integer)) - 1] of PCefV8Value;


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
    is_valid: function(self: PCefV8StackTrace): Integer; cconv;

    // Returns the number of stack frames.
    get_frame_count: function(self: PCefV8StackTrace): Integer; cconv;

    // Returns the stack frame at the specified 0-based index.
    get_frame: function(self: PCefV8StackTrace; index: Integer): PCefV8StackFrame; cconv;
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
    is_valid: function(self: PCefV8StackFrame): Integer; cconv;

    // Returns the name of the resource script that contains the function.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_script_name: function(self: PCefV8StackFrame): PCefStringUserFree; cconv;

    // Returns the name of the resource script that contains the function or the
    // sourceURL value if the script name is undefined and its source ends with a
    // "//@ sourceURL=..." string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_script_name_or_source_url: function(self: PCefV8StackFrame): PCefStringUserFree; cconv;

    // Returns the name of the function.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_function_name: function(self: PCefV8StackFrame): PCefStringUserFree; cconv;

    // Returns the 1-based line number for the function call or 0 if unknown.
    get_line_number: function(self: PCefV8StackFrame): Integer; cconv;

    // Returns the 1-based column offset on the line for the function call or 0 if
    // unknown.
    get_column: function(self: PCefV8StackFrame): Integer; cconv;

    // Returns true (1) if the function was compiled using eval().
    is_eval: function(self: PCefV8StackFrame): Integer; cconv;

    // Returns true (1) if the function was called as a constructor via "new".
    is_constructor: function(self: PCefV8StackFrame): Integer; cconv;
  end;


{ ***  cef_values_capi.h  *** }
  // Structure representing a binary value. Can be used on any process and thread.
  TCefBinaryValue = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefBinaryValue): Integer; cconv;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefBinaryValue): Integer; cconv;

    // Returns a copy of this object. The data in this object will also be copied.
    copy: function(self: PCefBinaryValue): PCefBinaryValue; cconv;

    // Returns the data size.
    get_size: function(self: PCefBinaryValue): csize_t; cconv;

    // Read up to |buffer_size| number of bytes into |buffer|. Reading begins at
    // the specified byte |data_offset|. Returns the number of bytes read.
    get_data: function(self: PCefBinaryValue; buffer: Pointer; buffer_size, data_offset: csize_t): csize_t; cconv;
  end;


  // Structure representing a dictionary value. Can be used on any process and
  // thread.
  TCefDictionaryValue = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns a writable copy of this object. If |exclude_NULL_children| is true
    // (1) any NULL dictionaries or lists will be excluded from the copy.
    copy: function(self: PCefDictionaryValue; exclude_empty_children: Integer): PCefDictionaryValue; cconv;

    // Returns the number of values.
    get_size: function(self: PCefDictionaryValue): csize_t; cconv;

    // Removes all values. Returns true (1) on success.
    clear: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if the current dictionary has a value for the given key.
    has_key: function(self: PCefDictionaryValue; const key: PCefString): Integer; cconv;

    // Reads all keys for this dictionary into the specified vector.
    get_keys: function(self: PCefDictionaryValue; const keys: TCefStringList): Integer; cconv;

    // Removes the value at the specified key. Returns true (1) is the value was
    // removed successfully.
    remove: function(self: PCefDictionaryValue; const key: PCefString): Integer; cconv;

    // Returns the value type for the specified key.
    get_type: function(self: PCefDictionaryValue; const key: PCefString): TCefValueType; cconv;

    // Returns the value at the specified key as type bool.
    get_bool: function(self: PCefDictionaryValue; const key: PCefString): Integer; cconv;

    // Returns the value at the specified key as type int.
    get_int: function(self: PCefDictionaryValue; const key: PCefString): Integer; cconv;

    // Returns the value at the specified key as type double.
    get_double: function(self: PCefDictionaryValue; const key: PCefString): Double; cconv;

    // Returns the value at the specified key as type string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string: function(self: PCefDictionaryValue; const key: PCefString): PCefStringUserFree; cconv;

    // Returns the value at the specified key as type binary.
    get_binary: function(self: PCefDictionaryValue; const key: PCefString): PCefBinaryValue; cconv;

    // Returns the value at the specified key as type dictionary.
    get_dictionary: function(self: PCefDictionaryValue; const key: PCefString): PCefDictionaryValue; cconv;

    // Returns the value at the specified key as type list.
    get_list: function(self: PCefDictionaryValue; const key: PCefString): PCefListValue; cconv;

    // Sets the value at the specified key as type null. Returns true (1) if the
    // value was set successfully.
    set_null: function(self: PCefDictionaryValue; const key: PCefString): Integer; cconv;

    // Sets the value at the specified key as type bool. Returns true (1) if the
    // value was set successfully.
    set_bool: function(self: PCefDictionaryValue; const key: PCefString; value: Integer): Integer; cconv;

    // Sets the value at the specified key as type int. Returns true (1) if the
    // value was set successfully.
    set_int: function(self: PCefDictionaryValue; const key: PCefString; value: Integer): Integer; cconv;

    // Sets the value at the specified key as type double. Returns true (1) if the
    // value was set successfully.
    set_double: function(self: PCefDictionaryValue; const key: PCefString; value: Double): Integer; cconv;

    // Sets the value at the specified key as type string. Returns true (1) if the
    // value was set successfully.
    set_string: function(self: PCefDictionaryValue; const key: PCefString; value: PCefString): Integer; cconv;

    // Sets the value at the specified key as type binary. Returns true (1) if the
    // value was set successfully. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_binary: function(self: PCefDictionaryValue; const key: PCefString; value: PCefBinaryValue): Integer; cconv;

    // Sets the value at the specified key as type dict. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_dictionary: function(self: PCefDictionaryValue; const key: PCefString; value: PCefDictionaryValue): Integer; cconv;

    // Sets the value at the specified key as type list. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_list: function(self: PCefDictionaryValue; const key: PCefString; value: PCefListValue): Integer; cconv;
  end;


  // Structure representing a list value. Can be used on any process and thread.
  TCefListValue = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefListValue): Integer; cconv;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefListValue): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefListValue): Integer; cconv;

    // Returns a writable copy of this object.
    copy: function(self: PCefListValue): PCefListValue; cconv;

    // Sets the number of values. If the number of values is expanded all new
    // value slots will default to type null. Returns true (1) on success.
    set_size: function(self: PCefListValue; size: csize_t): Integer; cconv;

    // Returns the number of values.
    get_size: function(self: PCefListValue): csize_t; cconv;

    // Removes all values. Returns true (1) on success.
    clear: function(self: PCefListValue): Integer; cconv;

    // Removes the value at the specified index.
    remove: function(self: PCefListValue; index: Integer): Integer; cconv;

    // Returns the value type at the specified index.
    get_type: function(self: PCefListValue; index: Integer): TCefValueType; cconv;

    // Returns the value at the specified index as type bool.
    get_bool: function(self: PCefListValue; index: Integer): Integer; cconv;

    // Returns the value at the specified index as type int.
    get_int: function(self: PCefListValue; index: Integer): Integer; cconv;

    // Returns the value at the specified index as type double.
    get_double: function(self: PCefListValue; index: Integer): Double; cconv;

    // Returns the value at the specified index as type string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string: function(self: PCefListValue; index: Integer): PCefStringUserFree; cconv;

    // Returns the value at the specified index as type binary.
    get_binary: function(self: PCefListValue; index: Integer): PCefBinaryValue; cconv;

    // Returns the value at the specified index as type dictionary.
    get_dictionary: function(self: PCefListValue; index: Integer): PCefDictionaryValue; cconv;

    // Returns the value at the specified index as type list.
    get_list: function(self: PCefListValue; index: Integer): PCefListValue; cconv;

    // Sets the value at the specified index as type null. Returns true (1) if the
    // value was set successfully.
    set_null: function(self: PCefListValue; index: Integer): Integer; cconv;

    // Sets the value at the specified index as type bool. Returns true (1) if the
    // value was set successfully.
    set_bool: function(self: PCefListValue; index, value: Integer): Integer; cconv;

    // Sets the value at the specified index as type int. Returns true (1) if the
    // value was set successfully.
    set_int: function(self: PCefListValue; index, value: Integer): Integer; cconv;

    // Sets the value at the specified index as type double. Returns true (1) if
    // the value was set successfully.
    set_double: function(self: PCefListValue; index: Integer; value: Double): Integer; cconv;

    // Sets the value at the specified index as type string. Returns true (1) if
    // the value was set successfully.
    set_string: function(self: PCefListValue; index: Integer; value: PCefString): Integer; cconv;

    // Sets the value at the specified index as type binary. Returns true (1) if
    // the value was set successfully. After calling this function the |value|
    // object will no longer be valid. If |value| is currently owned by another
    // object then the value will be copied and the |value| reference will not
    // change. Otherwise, ownership will be transferred to this object and the
    // |value| reference will be invalidated.
    set_binary: function(self: PCefListValue; index: Integer; value: PCefBinaryValue): Integer; cconv;

    // Sets the value at the specified index as type dict. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_dictionary: function(self: PCefListValue; index: Integer; value: PCefDictionaryValue): Integer; cconv;

    // Sets the value at the specified index as type list. Returns true (1) if the
    // value was set successfully. After calling this function the |value| object
    // will no longer be valid. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_list: function(self: PCefListValue; index: Integer; value: PCefListValue): Integer; cconv;
  end;


{ ***  cef_web_plugin_capi.h  *** }
  // Information about a specific web plugin.
  TCefWebPluginInfo = record
    // Base structure.
    base: TCefBase;

    // Returns the plugin name (i.e. Flash).
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefWebPluginInfo): PCefStringUserFree; cconv;

    // Returns the plugin file path (DLL/bundle/library).
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_path: function(self: PCefWebPluginInfo): PCefStringUserFree; cconv;

    // Returns the version of the plugin (may be OS-specific).
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_version: function(self: PCefWebPluginInfo): PCefStringUserFree; cconv;

    // Returns a description of the plugin from the version information.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_description: function(self: PCefWebPluginInfo): PCefStringUserFree; cconv;
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
      info: PCefWebPluginInfo; count, total: Integer): Integer; cconv;
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
        const path: PCefString; unstable: Integer); cconv;
  end;


{ ***  cef_xml_reader_capi.h  *** }
  // Structure that supports the reading of XML data via the libxml streaming API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefXMLReader = record
    // Base structure.
    base: TCefBase;

    // Moves the cursor to the next node in the document. This function must be
    // called at least once to set the current cursor position. Returns true (1)
    // if the cursor position was set successfully.
    move_to_next_node: function(self: PCefXmlReader): Integer; cconv;

    // Close the document. This should be called directly to ensure that cleanup
    // occurs on the correct thread.
    close: function(self: PCefXmlReader): Integer; cconv;

    // Returns true (1) if an error has been reported by the XML parser.
    has_error: function(self: PCefXmlReader): Integer; cconv;

    // Returns the error string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_error: function(self: PCefXmlReader): PCefStringUserFree; cconv;


    // The below functions retrieve data for the node at the current cursor
    // position.

    // Returns the node type.
    get_type: function(self: PCefXmlReader): TCefXmlNodeType; cconv;

    // Returns the node depth. Depth starts at 0 for the root node.
    get_depth: function(self: PCefXmlReader): Integer; cconv;

    // Returns the local name. See http://www.w3.org/TR/REC-xml-names/#NT-
    // LocalPart for additional details.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_local_name: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns the namespace prefix. See http://www.w3.org/TR/REC-xml-names/ for
    // additional details.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_prefix: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns the qualified name, equal to (Prefix:)LocalName. See
    // http://www.w3.org/TR/REC-xml-names/#ns-qualnames for additional details.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_qualified_name: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns the URI defining the namespace associated with the node. See
    // http://www.w3.org/TR/REC-xml-names/ for additional details.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_namespace_uri: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns the base URI of the node. See http://www.w3.org/TR/xmlbase/ for
    // additional details.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_base_uri: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns the xml:lang scope within which the node resides. See
    // http://www.w3.org/TR/REC-xml/#sec-lang-tag for additional details.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_xml_lang: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns true (1) if the node represents an NULL element. <a/> is considered
    // NULL but <a></a> is not.
    is_empty_element: function(self: PCefXmlReader): Integer; cconv;

    // Returns true (1) if the node has a text value.
    has_value: function(self: PCefXmlReader): Integer; cconv;

    // Returns the text value.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_value: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns true (1) if the node has attributes.
    has_attributes: function(self: PCefXmlReader): Integer; cconv;

    // Returns the number of attributes.
    get_attribute_count: function(self: PCefXmlReader): csize_t; cconv;

    // Returns the value of the attribute at the specified 0-based index.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_byindex: function(self: PCefXmlReader; index: Integer): PCefStringUserFree; cconv;

    // Returns the value of the attribute with the specified qualified name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_byqname: function(self: PCefXmlReader; const qualifiedName: PCefString): PCefStringUserFree; cconv;

    // Returns the value of the attribute with the specified local name and
    // namespace URI.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_bylname: function(self: PCefXmlReader; const localName, namespaceURI: PCefString): PCefStringUserFree; cconv;

    // Returns an XML representation of the current node's children.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_inner_xml: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns an XML representation of the current node including its children.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_outer_xml: function(self: PCefXmlReader): PCefStringUserFree; cconv;

    // Returns the line number for the current node.
    get_line_number: function(self: PCefXmlReader): Integer; cconv;


    // Attribute nodes are not traversed by default. The below functions can be
    // used to move the cursor to an attribute node. move_to_carrying_element()
    // can be called afterwards to return the cursor to the carrying element. The
    // depth of an attribute node will be 1 + the depth of the carrying element.

    // Moves the cursor to the attribute at the specified 0-based index. Returns
    // true (1) if the cursor position was set successfully.
    move_to_attribute_byindex: function(self: PCefXmlReader; index: Integer): Integer; cconv;

    // Moves the cursor to the attribute with the specified qualified name.
    // Returns true (1) if the cursor position was set successfully.
    move_to_attribute_byqname: function(self: PCefXmlReader; const qualifiedName: PCefString): Integer; cconv;

    // Moves the cursor to the attribute with the specified local name and
    // namespace URI. Returns true (1) if the cursor position was set
    // successfully.
    move_to_attribute_bylname: function(self: PCefXmlReader; const localName, namespaceURI: PCefString): Integer; cconv;

    // Moves the cursor to the first attribute in the current element. Returns
    // true (1) if the cursor position was set successfully.
    move_to_first_attribute: function(self: PCefXmlReader): Integer; cconv;

    // Moves the cursor to the next attribute in the current element. Returns true
    // (1) if the cursor position was set successfully.
    move_to_next_attribute: function(self: PCefXmlReader): Integer; cconv;

    // Moves the cursor back to the carrying element. Returns true (1) if the
    // cursor position was set successfully.
    move_to_carrying_element: function(self: PCefXmlReader): Integer; cconv;
  end;


{ ***  cef_zip_reader_capi.h  *** }
  // Structure that supports the reading of zip archives via the zlib unzip API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefZipReader = record
    // Base structure.
    base: TCefBase;

    // Moves the cursor to the first file in the archive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_first_file: function(self: PCefZipReader): Integer; cconv;

    // Moves the cursor to the next file in the archive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_next_file: function(self: PCefZipReader): Integer; cconv;

    // Moves the cursor to the specified file in the archive. If |caseSensitive|
    // is true (1) then the search will be case sensitive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_file: function(self: PCefZipReader; const fileName: PCefString; caseSensitive: Integer): Integer; cconv;

    // Closes the archive. This should be called directly to ensure that cleanup
    // occurs on the correct thread.
    close: function(Self: PCefZipReader): Integer; cconv;


    // The below functions act on the file at the current cursor position.

    // Returns the name of the file.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_file_name: function(Self: PCefZipReader): PCefStringUserFree; cconv;

    // Returns the uncompressed size of the file.
    get_file_size: function(Self: PCefZipReader): Int64; cconv;

    // Returns the last modified timestamp for the file.
    {$NOTE LongInt = time_t}
    get_file_last_modified: function(Self: PCefZipReader): LongInt; cconv;

    // Opens the file for reading of uncompressed data. A read password may
    // optionally be specified.
    open_file: function(Self: PCefZipReader; const password: PCefString): Integer; cconv;

    // Closes the file.
    close_file: function(Self: PCefZipReader): Integer; cconv;

    // Read uncompressed file contents into the specified buffer. Returns < 0 if
    // an error occurred, 0 if at the end of file, or the number of bytes read.
    read_file: function(Self: PCefZipReader; buffer: Pointer; bufferSize: csize_t): Integer; cconv;

    // Returns the current offset in the uncompressed file contents.
    tell: function(Self: PCefZipReader): Int64; cconv;

    // Returns true (1) if at end of the file contents.
    eof: function(Self: PCefZipReader): Integer; cconv;
  end;



Var

{ ***  cef_app_capi.h  *** }
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

  // Set to true (1) before calling Windows APIs like TrackPopupMenu that enter a
  // modal message loop. Set to false (0) after exiting the modal message loop.
  cef_set_osmodal_loop: procedure(osModalLoop : Integer); cdecl;


{ ***  cef_browser_capi.h  *** }
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


{ ***  cef_command_line_capi.h  *** }
  // Create a new cef_command_line_t instance.
  cef_command_line_create: function: PCefCommandLine; cdecl;

  // Returns the singleton global cef_command_line_t object. The returned object
  // will be read-only.
  cef_command_line_get_global: function: PCefCommandLine; cdecl;


{ ***  cef_cookie_capi.h  *** }
  // Returns the global cookie manager. By default data will be stored at
  // CefSettings.cache_path if specified or in memory otherwise.
  cef_cookie_manager_get_global_manager: function: PCefCookieManager; cdecl;

  // Creates a new cookie manager. If |path| is NULL data will be stored in memory
  // only. Otherwise, data will be stored at the specified |path|. To persist
  // session cookies (cookies without an expiry date or validity interval) set
  // |persist_session_cookies| to true (1). Session cookies are generally intended
  // to be transient and most Web browsers do not persist them. Returns NULL if
  // creation fails.
  cef_cookie_manager_create_manager: function(const path: PCefString; persist_session_cookies: Integer): PCefCookieManager; cdecl;


{ *** cef_geolocation_capi.h  *** }
  // Request a one-time geolocation update. This function bypasses any user
  // permission checks so should only be used by code that is allowed to access
  // location information.
  cef_get_geolocation: function(callback: PCefGetGeolocationCallback): Integer; cdecl;


{ ***  cef_origin_whitelist_capi.h  *** }
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
  // only exact domain matches will be allowed. If |target_domain| contains a top-
  // level domain component (like "example.com") and |allow_target_subdomains| is
  // true (1) sub-domain matches will be allowed. If |target_domain| is NULL and
  // |allow_target_subdomains| if true (1) all domains and IP addresses will be
  // allowed.
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


{ ***  cef_path_util_capi.h  *** }
  // Retrieve the path associated with the specified |key|. Returns true (1) on
  // success. Can be called on any thread in the browser process.
  cef_get_path: function(key: TCefPathKey; path: PCefString): Integer; cdecl;


{ ***  cef_process_message_capi.h  *** }
  // Create a new cef_process_message_t object with the specified name.
  cef_process_message_create: function(const name: PCefString): PCefProcessMessage; cdecl;


{ *** cef_process_util_capi.h  *** }
  // Launches the process specified via |command_line|. Returns true (1) upon
  // success. Must be called on the browser process TID_PROCESS_LAUNCHER thread.
  //
  // Unix-specific notes: - All file descriptors open in the parent process will
  // be closed in the
  //   child process except for stdin, stdout, and stderr.
  // - If the first argument on the command line does not contain a slash,
  //   PATH will be searched. (See man execvp.)
  cef_launch_process: function(command_line: PCefCommandLine): Integer; cdecl;


{ ***  cef_request_capi.h  *** }
  // Create a new TCefRequest object.
  cef_request_create: function: PCefRequest; cdecl;

  // Create a new TCefPostData object.
  cef_post_data_create: function: PCefPostData; cdecl;

  // Create a new TCefPostDataElement object.
  cef_post_data_element_create: function: PCefPostDataElement; cdecl;


{ ***  cef_response_capi.h  *** }
  // Create a new TCefResponse object.
  cef_response_create: function: PCefResponse; cdecl;


{ ***  cef_scheme_capi.h  *** }
  // Register a scheme handler factory for the specified |scheme_name| and
  // optional |domain_name|. An NULL |domain_name| value for a standard scheme
  // will cause the factory to match all domain names. The |domain_name| value
  // will be ignored for non-standard schemes. If |scheme_name| is a built-in
  // scheme and no handler is returned by |factory| then the built-in scheme
  // handler factory will be called. If |scheme_name| is a custom scheme then also
  // implement the cef_app_t::on_register_custom_schemes() function in all
  // processes. This function may be called multiple times to change or remove the
  // factory that matches the specified |scheme_name| and optional |domain_name|.
  // Returns false (0) if an error occurs. This function may be called on any
  // thread in the browser process.
  cef_register_scheme_handler_factory: function(
    const scheme_name, domain_name: PCefString;
    factory: PCefSchemeHandlerFactory): Integer; cdecl;

  // Clear all registered scheme handler factories. Returns false (0) on error.
  // This function may be called on any thread in the browser process.
  cef_clear_scheme_handler_factories: function: Integer; cdecl;


{ ***  cef_stream_capi.h  *** }
  // Create a new cef_stream_reader_t object from a file.
  cef_stream_reader_create_for_file: function(const fileName: PCefString): PCefStreamReader; cdecl;

  // Create a new cef_stream_reader_t object from data.
  cef_stream_reader_create_for_data: function(data: Pointer; size: csize_t): PCefStreamReader; cdecl;

  // Create a new cef_stream_reader_t object from a custom handler.
  cef_stream_reader_create_for_handler: function(handler: PCefReadHandler): PCefStreamReader; cdecl;

  // Create a new cef_stream_writer_t object for a file.
  cef_stream_writer_create_for_file: function(const fileName: PCefString): PCefStreamWriter; cdecl;

  // Create a new cef_stream_writer_t object for a custom handler.
  cef_stream_writer_create_for_handler: function(handler: PCefWriteHandler): PCefStreamWriter; cdecl;


{ ***  cef_task_capi.h  *** }
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

  // Returns the task runner for the current thread. Only CEF threads will have
  // task runners. An NULL reference will be returned if this function is called
  // on an invalid thread.
  cef_task_runner_get_for_current_thread: function: PCefTaskRunner; cdecl;

  // Returns the task runner for the specified CEF thread.
  cef_task_runner_get_for_thread: function(threadId: TCefThreadId): PCefTaskRunner; cdecl;


{ ***  cef_trace_capi.h  *** }
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
  // asynchronously after the value is determined. When any child process reaches
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


  // Returns the current system trace time or, if none is defined, the current
  // high-res time. Can be used by clients to synchronize with the time
  // information in trace events.
  cef_now_from_system_trace_time: function: Int64; cdecl;


{ ***  cef_url_capi.h  *** }
  // Parse the specified |url| into its component parts. Returns false (0) if the
  // URL is NULL or invalid.
  cef_parse_url: function(const url: PCefString; var parts: TCefUrlParts): Integer; cdecl;


  // Creates a URL from the specified |parts|, which must contain a non-NULL spec
  // or a non-NULL host and path (at a minimum), but not both. Returns false (0)
  // if |parts| isn't initialized as described.
  {$NOTE const check}
  cef_create_url: function(const parts: PCefUrlParts; url: PCefString): Integer; cdecl;


{ ***  cef_urlrequest_capi.h  *** }
  // Create a new URL request. Only GET, POST, HEAD, DELETE and PUT request
  // functions are supported. The |request| object will be marked as read-only
  // after calling this function.
  cef_urlrequest_create: function(request: PCefRequest; client: PCefUrlRequestClient): PCefUrlRequest; cdecl;


{ ***  cef_v8_capi.h  *** }
  // Register a new V8 extension with the specified JavaScript extension code and
  // handler. Functions implemented by the handler are prototyped using the
  // keyword 'native'. The calling of a native function is restricted to the scope
  // in which the prototype of the native function is defined. This function may
  // only be called on the render process main thread.
  //
  // Example JavaScript extension code: <pre>
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
  // </pre> Example usage in the page: <pre>
  //   // Call the function.
  //   example.test.myfunction();
  //   // Set the parameter.
  //   example.test.myparam = value;
  //   // Get the parameter.
  //   value = example.test.myparam;
  //   // Call another function.
  //   example.test.increment();
  // </pre>
  cef_register_extension: function(const extension_name,
    javascript_code: PCefString; handler: PCefv8Handler): Integer; cdecl;

  // Returns the current (top) context object in the V8 context stack.
  cef_v8context_get_current_context: function: PCefv8Context; cdecl;

  // Returns the entered (bottom) context object in the V8 context stack.
  cef_v8context_get_entered_context: function: PCefv8Context; cdecl;

  // Returns true (1) if V8 is currently inside a context.
  cef_v8context_in_context: function: Integer;

  // Create a new TCefv8Value object of type undefined.
  cef_v8value_create_undefined: function: PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type null.
  cef_v8value_create_null: function: PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type bool.
  cef_v8value_create_bool: function(value: Integer): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type int.
  cef_v8value_create_int: function(value: Int32): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type unsigned int.
  cef_v8value_create_uint: function(value: UInt32): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type double.
  cef_v8value_create_double: function(value: Double): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type Date. This function should only be
  // called from within the scope of a cef_v8context_tHandler, cef_v8handler_t or
  // cef_v8accessor_t callback, or in combination with calling enter() and exit()
  // on a stored cef_v8context_t reference.
  cef_v8value_create_date: function(const value: PCefTime): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type string.
  cef_v8value_create_string: function(const value: PCefString): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type object with optional accessor. This
  // function should only be called from within the scope of a
  // cef_v8context_tHandler, cef_v8handler_t or cef_v8accessor_t callback, or in
  // combination with calling enter() and exit() on a stored cef_v8context_t
  // reference.
  cef_v8value_create_object: function(accessor: PCefV8Accessor): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type array with the specified |length|.
  // If |length| is negative the returned array will have length 0. This function
  // should only be called from within the scope of a cef_v8context_tHandler,
  // cef_v8handler_t or cef_v8accessor_t callback, or in combination with calling
  // enter() and exit() on a stored cef_v8context_t reference.
  cef_v8value_create_array: function(length: Integer): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type function. This function should only
  // be called from within the scope of a cef_v8context_tHandler, cef_v8handler_t
  // or cef_v8accessor_t callback, or in combination with calling enter() and
  // exit() on a stored cef_v8context_t reference.
  cef_v8value_create_function: function(const name: PCefString; handler: PCefv8Handler): PCefv8Value; cdecl;

  // Returns the stack trace for the currently active context. |frame_limit| is
  // the maximum number of frames that will be captured.
  cef_v8stack_trace_get_current: function(frame_limit: Integer): PCefV8StackTrace; cdecl;


{ ***  cef_values_capi.h  *** }
  // Creates a new object that is not owned by any other object. The specified
  // |data| will be copied.
  cef_binary_value_create: function(const data: Pointer; data_size: csize_t): PCefBinaryValue; cdecl;

  // Creates a new object that is not owned by any other object.
  cef_dictionary_value_create: function: PCefDictionaryValue; cdecl;

  // Creates a new object that is not owned by any other object.
  cef_list_value_create: function: PCefListValue; cdecl;


{ ***  cef_web_plugin_capi.h  *** }
  // Visit web plugin information. Can be called on any thread in the browser
  // process.
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
  cef_is_web_plugin_unstable: procedure(const path: PCefString; callback: PCefWebPluginUnstableCallback); cdecl;


{ ***  cef_xml_reader_capi.h  *** }
  // Create a new TCefXMLReader object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_xml_reader_create: function(stream: PCefStreamReader;
    encodingType: TCefXmlEncodingType; const URI: PCefString): PCefXmlReader; cdecl;


{ ***  cef_zip_reader_capi.h  *** }
  // Create a new cef_zip_reader_t object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_zip_reader_create: function(stream: PCefStreamReader): PCefZipReader; cdecl;



{ ***  cef_string_types.h  *** }

  // These functions set string values. If |copy| is true (1) the value will be
  // copied instead of referenced. It is up to the user to properly manage
  // the lifespan of references.
  cef_string_wide_set: function(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide; copy: Integer): Integer; cdecl;
  cef_string_utf8_set: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8; copy: Integer): Integer; cdecl;
  cef_string_utf16_set: function(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16; copy: Integer): Integer; cdecl;

  cef_string_set: function(const src: PCefChar; src_len: Cardinal; output: PCefString; copy: Integer): Integer; cdecl;

  // Makros

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

  { Additional }
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


{ ***  cef_string_list.h  *** }

  // Allocate a new string map.
  cef_string_list_alloc: function: TCefStringList; cdecl;

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


{ ***  cef_string_map.h  *** }

  // Allocate a new string map.
  cef_string_map_alloc: function: TCefStringMap; cdecl;

  // Return the number of elements in the string map.
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


{ ***  cef_string_multimap.h  *** }

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


{ ***  cef_time.h  *** }
  // Converts cef_time_t to/from time_t. Returns true (1) on success and false (0)
  // on failure.
  //cef_time_to_timet: function(const cef_time: PCefTime; time: PTimet): Integer; cdecl;
  //cef_time_from_timet: function(time: TTimet; cef_time: PCefTime): Integer; cdecl;

  // Converts cef_time_t to/from a double which is the number of seconds since
  // epoch (Jan 1, 1970). Webkit uses this format to represent time. A value of 0
  // means "not initialized". Returns true (1) on success and false (0) on
  // failure.
  //cef_time_to_doublet: function(const cef_time: PCefTime; time : PDouble): Integer; cdecl;
  //cef_time_from_doublet: function(time: Double; cef_time: PCefTime): Integer; cdecl;

  // Retrieve the current system time.
  cef_time_now: function(cef_time: PCefTime): Integer; cdecl;

  // Retrieve the delta in milliseconds between two time values.
  //cef_time_delta: function(const cef_time_1, cef_time_2: PCefTime; delta: P long long): Integer; cdecl;


{ ***  cef_version.h *** }
  // Returns the CEF build revision for the libcef library.
  cef_build_revision: function: Integer; cdecl;

  {$NOTE TODO add constants}
  // Returns CEF version information for the libcef library. The |entry|
  // parameter describes which version component will be returned:
  // 0 - CEF_VERSION_MAJOR
  // 1 - CEF_REVISION
  // 2 - CHROME_VERSION_MAJOR
  // 3 - CHROME_VERSION_MINOR
  // 4 - CHROME_VERSION_BUILD
  // 5 - CHROME_VERSION_PATCH
  cef_version_info: function(entry: Integer): Integer; cdecl;

  // Returns CEF API hashes for the libcef library. The returned string is owned
  // by the library and should not be freed. The |entry| parameter describes which
  // hash value will be returned:
  // 0 - CEF_API_HASH_PLATFORM
  // 1 - CEF_API_HASH_UNIVERSAL
  cef_api_hash: function(entry: Integer): PChar; cdecl;



procedure CefLoadLibrary;
procedure CefCloseLibrary;

Implementation

Uses Math;

Const
  CefLibrary: String = {$IFDEF WINDOWS}'libcef.dll'{$ELSE}'libcef.so'{$ENDIF};
Var
  LibHandle : THandle = 0;


{ ***  cef_string_types.h *** }

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
{ ***                     *** }

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
    cef_set_osmodal_loop                    := GetProcAddress(LibHandle, 'cef_set_osmodal_loop');
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
      Assigned(cef_set_osmodal_loop) and
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
  Else Debugln('   : already freed.');
end;

Finalization
  CefCloseLibrary;

end.
