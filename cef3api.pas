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

Unit cef3api;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  {$IFDEF LINUX}xlib,{$ENDIF}
  sysutils, ctypes, dynlibs, {$IFDEF DEBUG}LCLProc,{$ENDIF}
  cef3types;

Type
  PCefBaseRefCounted = ^TCefBaseRefCounted;
  PCefBaseScoped = ^TCefBaseScoped;

  PCefApp = ^TCefApp;

  PCefAuthCallback = ^TCefAuthCallback;

  PCefBrowser = ^TCefBrowser;
  PCefRunFileDialogCallback = ^TCefRunFileDialogCallback;
  PCefNavigationEntryVisitor = ^TCefNavigationEntryVisitor;
  PCefPdfPrintCallback = ^TCefPdfPrintCallback;
  PCefDownloadImageCallback = ^TCefDownloadImageCallback;
  PCefBrowserHost = ^TCefBrowserHost;

  PCefBrowserProcessHandler = ^TCefBrowserProcessHandler;

  PCefCompletionCallback = ^TCefCompletionCallback;
  PCefCallback = ^TCefCallback;

  PCefClient = ^TCefClient;

  PCefCommandLine = ^TCefCommandLine;

  PCefRunContextMenuCallback = ^TCefRunContextMenuCallback;
  PCefContextMenuHandler = ^TCefContextMenuHandler;
  PCefContextMenuParams = ^TCefContextMenuParams;

  PCefCookieManager = ^TCefCookieManager;
  PCefCookieVisitor = ^TCefCookieVisitor;
  PCefSetCookieCallback = ^TCefSetCookieCallback;
  PCefDeleteCookiesCallback = ^TCefDeleteCookiesCallback;

  PCefFileDialogCallback = ^TCefFileDialogCallback;
  PCefDialogHandler = ^TCefDialogHandler;

  PCefDisplayHandler = ^TCefDisplayHandler;

  PCefDomVisitor = ^TCefDomVisitor;
  PCefDomDocument = ^TCefDomDocument;
  PCefDomNode = ^TCefDomNode;

  PCefBeforeDownloadCallback = ^TCefBeforeDownloadCallback;
  PCefDownloadItemCallback = ^TCefDownloadItemCallback;
  PCefDownloadHandler = ^TCefDownloadHandler;

  PCefDownloadItem = ^TCefDownloadItem;

  PCefDragData = ^TCefDragData;

  PCefDragHandler = ^TCefDragHandler;

  PCefFindHandler = ^TCefFindHandler;

  PCefFocusHandler = ^TCefFocusHandler;

  PCefFrame = ^TCefFrame;

  PCefGetGeolocationCallback = ^TCefGetGeolocationCallback;

  PCefGeolocationCallback = ^TCefGeolocationCallback;
  PCefGeolocationHandler = ^TCefGeolocationHandler;

  PCefImage = ^TCefImage;

  PCefJsDialogCallback = ^TCefJsDialogCallback;
  PCefJsDialogHandler = ^TCefJsDialogHandler;

  PCefKeyboardHandler = ^TCefKeyboardHandler;

  PCefLifeSpanHandler = ^TCefLifeSpanHandler;

  PCefLoadHandler = ^TCefLoadHandler;

  PCefMenuModel = ^TCefMenuModel;

  PCefMenuModelDelegate = ^TCefMenuModelDelegate;

  PCefNavigationEntry = ^TCefNavigationEntry;

  PCefPrintDialogCallback = ^TCefPrintDialogCallback;
  PCefPrintJobCallback = ^TCefPrintJobCallback;
  PCefPrintHandler = ^TCefPrintHandler;

  PCefPrintSettings = ^TCefPrintSettings;

  PCefProcessMessage = ^TCefProcessMessage;

  PCefRenderHandler = ^TCefRenderHandler;

  PCefRenderProcessHandler = ^TCefRenderProcessHandler;

  PCefRequest = ^TCefRequest;

  PCefPostData = ^TCefPostData;
  PCefPostDataElement = ^TCefPostDataElement;

  TCefPostDataElementArray = array[0..(High(Integer) div SizeOf(PCefPostDataElement)) - 1] of PCefPostDataElement;
  PCefPostDataElementArray = ^TCefPostDataElementArray;

  PCefResolveCallback = ^TCefResolveCallback;
  PCefRequestContext = ^TCefRequestContext;

  PCefRequestContextHandler = ^TCefRequestContextHandler;

  PCefRequestCallback = ^TCefRequestCallback;
  PCefSelectClientCertificateCallback = ^TCefSelectClientCertificateCallback;
  PCefRequestHandler = ^TCefRequestHandler;

  PCefResourceBundle = ^TCefResourceBundle;

  PCefResourceBundleHandler = ^TCefResourceBundleHandler;

  PCefResourceHandler = ^TCefResourceHandler;

  PCefResponse = ^TCefResponse;

  PCefResponseFilter = ^TCefResponseFilter;

  PCefSchemeRegistrar = ^TCefSchemeRegistrar;
  PCefSchemeHandlerFactory = ^TCefSchemeHandlerFactory;

  PCefSslinfo = ^TCefSslinfo;
  PCefSslstatus = ^TCefSslstatus;

  PCefReadHandler = ^TCefReadHandler;
  PCefStreamReader = ^TCefStreamReader;
  PCefWriteHandler = ^TCefWriteHandler;
  PCefStreamWriter = ^TCefStreamWriter;

  PCefStringVisitor = ^TCefStringVisitor;

  PCefTask = ^TCefTask;
  PCefTaskRunner = ^TCefTaskRunner;

  PCefThread = ^TCefThread;

  PCefEndTracingCallback = ^TCefEndTracingCallback;

  PCefUrlRequest = ^TCefUrlRequest;

  PCefUrlRequestClient = ^TCefUrlRequestClient;

  PCefV8Context = ^TCefV8Context;
  PCefV8Handler = ^TCefV8Handler;
  PCefV8Accessor = ^TCefV8Accessor;
  PCefV8Interceptor = ^TCefV8Interceptor;
  PCefV8Exception = ^TCefV8Exception;
  PCefV8Value = ^TCefV8Value;
  TCefV8ValueArray = array[0..(High(Integer) div SizeOf(PCefV8Value)) - 1] of PCefV8Value;
  PCefV8ValueArray = ^TCefV8ValueArray;
  PCefV8StackTrace = ^TCefV8StackTrace;
  PCefV8StackFrame = ^TCefV8StackFrame;

  PCefValue = ^TCefValue;
  PCefBinaryValue = ^TCefBinaryValue;
  TCefBinaryValueArray = array[0..(High(Integer) div SizeOf(PCefBinaryValue)) - 1] of PCefBinaryValue;
  PCefBinaryValueArray = ^TCefBinaryValueArray;
  PCefDictionaryValue = ^TCefDictionaryValue;
  PCefListValue = ^TCefListValue;

  PCefWaitableEvent = ^TCefWaitableEvent;

  PCefWebPluginInfo = ^TCefWebPluginInfo;
  PCefWebPluginInfoVisitor = ^TCefWebPluginInfoVisitor;
  PCefWebPluginUnstableCallback = ^TCefWebPluginUnstableCallback;
  PCefRegisterCdmCallback = ^TCefRegisterCdmCallback;

  PCefX509certPrincipal = ^TCefX509certPrincipal;
  PCefX509certificate = ^TCefX509certificate;
  TCefX509certificateArray = array[0..(High(Integer) div SizeOf(PCefX509certificate)) - 1] of PCefX509certificate;
  PCefX509certificateArray = ^TCefX509certificateArray;

  PCefXmlReader = ^TCefXmlReader;

  PCefZipReader = ^TCefZipReader;

{ ***  cef_base_capi.h  *** }
  // All ref-counted framework structures must include this structure first.
  TCefBaseRefCounted = record
    // Size of the data structure.
    size: csize_t;

    // Called to increment the reference count for the object. Should be called
    // for every new copy of a pointer to a given object.
    add_ref: procedure(self: PCefBaseRefCounted); cconv;

    // Called to decrement the reference count for the object. If the reference
    // count falls to 0 the object should self-delete. Returns true (1) if the
    // resulting reference count is 0.
    release: function(self: PCefBaseRefCounted): Integer; cconv;

    // Returns true (1) if the current reference count is 1.
    has_one_ref: function(self: PCefBaseRefCounted): Integer; cconv;
  end;


  // All scoped framework structures must include this structure first.
  TCefBaseScoped = record
    // Size of the data structure.
    size: csize_t;

    // Called to delete this object. May be NULL if the object is not owned.
    del: procedure(self: PCefBaseScoped); cconv;
  end;


{ *** cef_app_capi.h  *** }
  // Implement this structure to provide handler implementations. Methods will be
  // called by the process and/or thread indicated.
  TCefApp = record
    // Base structure.
    base: TCefBaseRefCounted;

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


{ *** cef_auth_callback_capi.h *** }
  // Callback structure used for asynchronous continuation of authentication
  // requests.
  TCefAuthCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Continue the authentication request.
    cont: procedure(self: PCefAuthCallback; const username, password: PCefString); cconv;

    // Cancel the authentication request.
    cancel: procedure(self: PCefAuthCallback); cconv;
  end;


{ ***  cef_browser_capi.h  *** }
  // Structure used to represent a browser window. When used in the browser
  // process the functions of this structure may be called on any thread unless
  // otherwise indicated in the comments. When used in the render process the
  // functions of this structure may only be called on the main thread.
  TCefBrowser = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    get_identifier: function(self: PCefBrowser): Integer; cconv;

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
    get_frame_count: function(self: PCefBrowser): csize_t; cconv;

    // Returns the identifiers of all existing frames.
    get_frame_identifiers: procedure(self: PCefBrowser; identifiersCount: pcsize_t; identifiers: PInt64); cconv;

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
    base: TCefBaseRefCounted;

    // Called asynchronously after the file dialog is dismissed.
    // |selected_accept_filter| is the 0-based index of the value selected from
    // the accept filters array passed to cef_browser_host_t::RunFileDialog.
    // |file_paths| will be a single value or a list of values depending on the
    // dialog mode. If the selection was cancelled |file_paths| will be NULL.
    on_file_dialog_dismissed: procedure(self: PCefRunFileDialogCallback; selected_accept_filter: Integer;
      file_paths: TCefStringList); cconv;
  end;


  // Callback structure for cef_browser_host_t::GetNavigationEntries. The
  // functions of this structure will be called on the browser process UI thread.
  TCefNavigationEntryVisitor = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be executed. Do not keep a reference to |entry| outside of
    // this callback. Return true (1) to continue visiting entries or false (0) to
    // stop. |current| is true (1) if this entry is the currently loaded
    // navigation entry. |index| is the 0-based index of this entry and |total| is
    // the total number of entries.
    visit: function(self: PCefNavigationEntryVisitor; entry: PCefNavigationEntry; current, index, total: Integer): Integer; cconv;
  end;


  // Callback structure for cef_browser_host_t::PrintToPDF. The functions of this
  // structure will be called on the browser process UI thread.
  TCefPdfPrintCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be executed when the PDF printing has completed. |path| is
    // the output path. |ok| will be true (1) if the printing completed
    // successfully or false (0) otherwise.
    on_pdf_print_finished: procedure(self: PCefPdfPrintCallback; const path: PCefString; ok: Integer); cconv;
  end;


  // Callback structure for cef_browser_host_t::DownloadImage. The functions of
  // this structure will be called on the browser process UI thread.
  TCefDownloadImageCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be executed when the image download has completed.
    // |image_url| is the URL that was downloaded and |http_status_code| is the
    // resulting HTTP status code. |image| is the resulting image, possibly at
    // multiple scale factors, or NULL if the download failed.
    on_download_image_finished: procedure(self: PCefDownloadImageCallback;
      const image_url: PCefString; http_status_code: Integer; image: PCefImage); cconv;
  end;


  // Structure used to represent the browser process aspects of a browser window.
  // The functions of this structure can only be called in the browser process.
  // They may be called on any thread in that process unless otherwise indicated
  // in the comments.
  TCefBrowserHost = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns the hosted browser object.
    get_browser: function(self: PCefBrowserHost): PCefBrowser; cconv;

    // Request that the browser close. The JavaScript 'onbeforeunload' event will
    // be fired. If |force_close| is false (0) the event handler, if any, will be
    // allowed to prompt the user and the user can optionally cancel the close. If
    // |force_close| is true (1) the prompt will not be displayed and the close
    // will proceed. Results in a call to cef_life_span_handler_t::do_close() if
    // the event handler allows the close or if |force_close| is true (1). See
    // cef_life_span_handler_t::do_close() documentation for additional usage
    // information.
    close_browser: procedure(self: PCefBrowserHost; force_close: Integer); cconv;

    // Helper for closing a browser. Call this function from the top-level window
    // close handler. Internally this calls CloseBrowser(false (0)) if the close
    // has not yet been initiated. This function returns false (0) while the close
    // is pending and true (1) after the close has completed. See close_browser()
    // and cef_life_span_handler_t::do_close() documentation for additional usage
    // information. This function must be called on the browser process UI thread.
    try_close_browser: function(self: PCefBrowserHost): Integer; cconv;

    // Set whether the browser is focused.
    set_focus: procedure(self: PCefBrowserHost; focus: Integer); cconv;

    // Retrieve the window handle for this browser. If this browser is wrapped in
    // a cef_browser_view_t this function should be called on the browser process
    // UI thread and it will return the handle for the top-level native window.
    get_window_handle: function(self: PCefBrowserHost): TCefWindowHandle; cconv;

    // Retrieve the window handle of the browser that opened this browser. Will
    // return NULL for non-popup windows or if this browser is wrapped in a
    // cef_browser_view_t. This function can be used in combination with custom
    // handling of modal windows.
    get_opener_window_handle: function(self: PCefBrowserHost): TCefWindowHandle; cconv;

    // Returns true (1) if this browser is wrapped in a cef_browser_view_t.
    has_view: function(self: PCefBrowserHost): Integer; cconv;

    // Returns the client for this browser.
    get_client: function(self: PCefBrowserHost): PCefClient; cconv;

    // Returns the request context for this browser.
    get_request_context: function(self: PCefBrowserHost): PCefRequestContext; cconv;

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
    // default title ("Open" or "Save" depending on the mode). |default_file_path|
    // is the path with optional directory and/or file name component that will be
    // initially selected in the dialog. |accept_filters| are used to restrict the
    // selectable file types and may any combination of (a) valid lower-cased MIME
    // types (e.g. "text/*" or "image/*"), (b) individual file extensions (e.g.
    // ".txt" or ".png"), or (c) combined description and file extension delimited
    // using "|" and ";" (e.g. "Image Types|.png;.gif;.jpg").
    // |selected_accept_filter| is the 0-based index of the filter that will be
    // selected by default. |callback| will be executed after the dialog is
    // dismissed or immediately if another dialog is already pending. The dialog
    // will be initiated asynchronously on the UI thread.
    run_file_dialog: procedure(self: PCefBrowserHost; mode: TCefFileDialogMode;
      const title, default_file_path: PCefString; accept_filters: TCefStringList;
      selected_accept_filter: Integer; callback: PCefRunFileDialogCallback); cconv;

    // Download the file at |url| using cef_download_handler_t.
    start_download: procedure(self: PCefBrowserHost; const url: PCefString); cconv;

    // Download |image_url| and execute |callback| on completion with the images
    // received from the renderer. If |is_favicon| is true (1) then cookies are
    // not sent and not accepted during download. Images with density independent
    // pixel (DIP) sizes larger than |max_image_size| are filtered out from the
    // image results. Versions of the image at different scale factors may be
    // downloaded up to the maximum scale factor supported by the system. If there
    // are no image results <= |max_image_size| then the smallest image is resized
    // to |max_image_size| and is the only result. A |max_image_size| of 0 means
    // unlimited. If |bypass_cache| is true (1) then |image_url| is requested from
    // the server even if it is present in the browser cache.
    download_image: procedure(self: PCefBrowserHost; const image_url: PCefString; is_favicon: Integer;
      max_image_size: cuint32; bypass_cache: Integer; callback: PCefDownloadImageCallback); cconv;

    // Print the current browser contents.
    print: procedure(self: PCefBrowserHost); cconv;

    // Print the current browser contents to the PDF file specified by |path| and
    // execute |callback| on completion. The caller is responsible for deleting
    // |path| when done. For PDF printing to work on Linux you must implement the
    // cef_print_handler_t::GetPdfPaperSize function.
    print_to_pdf: procedure(self: PCefBrowserHost; const path: PCefString; const settings: PCefPdfPrintSettings;
      callback: PCefPdfPrintCallback); cconv;

    // Search for |searchText|. |identifier| must be a unique ID and these IDs
    // must strictly increase so that newer requests always have greater IDs than
    // older requests. If |identifier| is zero or less than the previous ID value
    // then it will be automatically assigned a new valid ID. |forward| indicates
    // whether to search forward or backward within the page. |matchCase|
    // indicates whether the search should be case-sensitive. |findNext| indicates
    // whether this is the first request or a follow-up. The cef_find_handler_t
    // instance, if any, returned via cef_client_t::GetFindHandler will be called
    // to report find results.
    find: procedure(self: PCefBrowserHost; identifier: Integer; const searchText: PCefString;
      forward_, matchCase, findNext: Integer); cconv;

    // Cancel all searches that are currently going on.
    stop_finding: procedure(self: PCefBrowserHost; clearSelection: Integer); cconv;

    // Open developer tools (DevTools) in its own browser. The DevTools browser
    // will remain associated with this browser. If the DevTools browser is
    // already open then it will be focused, in which case the |windowInfo|,
    // |client| and |settings| parameters will be ignored. If |inspect_element_at|
    // is non-NULL then the element at the specified (x,y) location will be
    // inspected. The |windowInfo| parameter will be ignored if this browser is
    // wrapped in a cef_browser_view_t.
    show_dev_tools: procedure(self: PCefBrowserHost; const windowInfo: PCefWindowInfo; client: PCefClient;
      const settings: PCefBrowserSettings; const inspect_element_at: PCefPoint); cconv;

    // Explicitly close the associated DevTools browser, if any.
    close_dev_tools: procedure(self: PCefBrowserHost); cconv;

    // Returns true (1) if this browser currently has an associated DevTools
    // browser. Must be called on the browser process UI thread.
    has_dev_tools: function(self: PCefBrowserHost): Integer; cconv;

    // Retrieve a snapshot of current navigation entries as values sent to the
    // specified visitor. If |current_only| is true (1) only the current
    // navigation entry will be sent, otherwise all navigation entries will be
    // sent.
    get_navigation_entries: procedure(self: PCefBrowserHost; visitor: PCefNavigationEntryVisitor;
      current_only: Integer); cconv;

    // Set whether mouse cursor change is disabled.
    set_mouse_cursor_change_disabled: procedure(self: PCefBrowserHost; disabled: Integer); cconv;

    // Returns true (1) if mouse cursor change is disabled.
    is_mouse_cursor_change_disabled: function(self: PCefBrowserHost) : Integer; cconv;

    // If a misspelled word is currently selected in an editable node calling this
    // function will replace it with the specified |word|.
    replace_misspelling: procedure(self: PCefBrowserHost; const word: PCefString); cconv;

    // Add the specified |word| to the spelling dictionary.
    add_word_to_dictionary: procedure(self: PCefBrowserHost; const word: PCefString); cconv;

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

    // Invalidate the view. The browser will call cef_render_handler_t::OnPaint
    // asynchronously. This function is only used when window rendering is
    // disabled.
    invalidate: procedure(self: PCefBrowserHost; type_: TCefPaintElementType); cconv;

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

    // Notify the browser that the window hosting it is about to be moved or
    // resized. This function is only used on Windows and Linux.
    notify_move_or_resize_started: procedure(self: PCefBrowserHost); cconv;

    // Returns the maximum rate in frames per second (fps) that
    // cef_render_handler_t:: OnPaint will be called for a windowless browser. The
    // actual fps may be lower if the browser cannot generate frames at the
    // requested rate. The minimum value is 1 and the maximum value is 60 (default
    // 30). This function can only be called on the UI thread.
    get_windowless_frame_rate: function(self: PCefBrowserHost): Integer; cconv;

    // Set the maximum rate in frames per second (fps) that cef_render_handler_t::
    // OnPaint will be called for a windowless browser. The actual fps may be
    // lower if the browser cannot generate frames at the requested rate. The
    // minimum value is 1 and the maximum value is 60 (default 30). Can also be
    // set at browser creation via cef_browser_tSettings.windowless_frame_rate.
    set_windowless_frame_rate: procedure(self: PCefBrowserHost; frame_rate: Integer); cconv;

    // Begins a new composition or updates the existing composition. Blink has a
    // special node (a composition node) that allows the input function to change
    // text without affecting other DOM nodes. |text| is the optional text that
    // will be inserted into the composition node. |underlines| is an optional set
    // of ranges that will be underlined in the resulting text.
    // |replacement_range| is an optional range of the existing text that will be
    // replaced. |selection_range| is an optional range of the resulting text that
    // will be selected after insertion or replacement. The |replacement_range|
    // value is only used on OS X.
    //
    // This function may be called multiple times as the composition changes. When
    // the client is done making changes the composition should either be canceled
    // or completed. To cancel the composition call ImeCancelComposition. To
    // complete the composition call either ImeCommitText or
    // ImeFinishComposingText. Completion is usually signaled when:
    //   A. The client receives a WM_IME_COMPOSITION message with a GCS_RESULTSTR
    //      flag (on Windows), or;
    //   B. The client receives a "commit" signal of GtkIMContext (on Linux), or;
    //   C. insertText of NSTextInput is called (on Mac).
    //
    // This function is only used when window rendering is disabled.
    ime_set_composition: procedure(self: PCefBrowserHost; const text: PCefString;
      underlinesCount: csize_t; underlines: PCefCompositionUnderlineArray;
      const replacement_range, selection_range: PCefRange); cconv;

    // Completes the existing composition by optionally inserting the specified
    // |text| into the composition node. |replacement_range| is an optional range
    // of the existing text that will be replaced. |relative_cursor_pos| is where
    // the cursor will be positioned relative to the current cursor position. See
    // comments on ImeSetComposition for usage. The |replacement_range| and
    // |relative_cursor_pos| values are only used on OS X. This function is only
    // used when window rendering is disabled.
    ime_commit_text: procedure(self: PCefBrowserHost; const text: PCefString;
      const replacement_range: PCefRange; relative_cursor_pos: Integer); cconv;

    // Completes the existing composition by applying the current composition node
    // contents. If |keep_selection| is false (0) the current selection, if any,
    // will be discarded. See comments on ImeSetComposition for usage. This
    // function is only used when window rendering is disabled.
    ime_finish_composing_text: procedure(self: PCefBrowserHost; keep_selection: Integer); cconv;

    // Cancels the existing composition and discards the composition node contents
    // without applying them. See comments on ImeSetComposition for usage. This
    // function is only used when window rendering is disabled.
    ime_cancel_composition: procedure(self: PCefBrowserHost); cconv;

    // Call this function when the user drags the mouse into the web view (before
    // calling DragTargetDragOver/DragTargetLeave/DragTargetDrop). |drag_data|
    // should not contain file contents as this type of data is not allowed to be
    // dragged into the web view. File contents can be removed using
    // cef_drag_data_t::ResetFileContents (for example, if |drag_data| comes from
    // cef_render_handler_t::StartDragging). This function is only used when
    // window rendering is disabled.
    drag_target_drag_enter: procedure(self: PCefBrowserHost; drag_data: PCefDragData;
      const event: PCefMouseEvent; allowed_ops: TCefDragOperationsMask); cconv;

    // Call this function each time the mouse is moved across the web view during
    // a drag operation (after calling DragTargetDragEnter and before calling
    // DragTargetDragLeave/DragTargetDrop). This function is only used when window
    // rendering is disabled.
    drag_target_drag_over: procedure(self: PCefBrowserHost; const event: PCefMouseEvent;
      alllowed_ops: TCefDragOperationsMask); cconv;

    // Call this function when the user drags the mouse out of the web view (after
    // calling DragTargetDragEnter). This function is only used when window
    // rendering is disabled.
    drag_target_drag_leave: procedure(self: PCefBrowserHost); cconv;

    // Call this function when the user completes the drag operation by dropping
    // the object onto the web view (after calling DragTargetDragEnter). The
    // object being dropped is |drag_data|, given as an argument to the previous
    // DragTargetDragEnter call. This function is only used when window rendering
    // is disabled.
    drag_target_drop: procedure(self: PCefBrowserHost; const event: PCefMouseEvent); cconv;

    // Call this function when the drag operation started by a
    // cef_render_handler_t::StartDragging call has ended either in a drop or by
    // being cancelled. |x| and |y| are mouse coordinates relative to the upper-
    // left corner of the view. If the web view is both the drag source and the
    // drag target then all DragTarget* functions should be called before
    // DragSource* mthods. This function is only used when window rendering is
    // disabled.
    drag_source_ended_at: procedure(self: PCefBrowserHost; x, y: Integer; op: TCefDragOperationsMask); cconv;

    // Call this function when the drag operation started by a
    // cef_render_handler_t::StartDragging call has completed. This function may
    // be called immediately without first calling DragSourceEndedAt to cancel a
    // drag operation. If the web view is both the drag source and the drag target
    // then all DragTarget* functions should be called before DragSource* mthods.
    // This function is only used when window rendering is disabled.
    drag_source_system_drag_ended: procedure(self: PCefBrowserHost); cconv;

    // Returns the current visible navigation entry for this browser. This
    // function can only be called on the UI thread.
    get_visible_navigation_entry: function(self: PCefBrowserHost): PCefNavigationEntry; cconv;
  end;


{ *** cef_browser_process_handler.h  *** }
  // Structure used to implement browser process callbacks. The functions of this
  // structure will be called on the browser process main thread unless otherwise
  // indicated.
  TCefBrowserProcessHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

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

    // Return the handler for printing on Linux. If a print handler is not
    // provided then printing will not be supported on the Linux platform.
    get_print_handler: function(self: PCefBrowserProcessHandler): PCefPrintHandler; cconv;

    // Called from any thread when work has been scheduled for the browser process
    // main (UI) thread. This callback is used in combination with CefSettings.
    // external_message_pump and cef_do_message_loop_work() in cases where the CEF
    // message loop must be integrated into an existing application message loop
    // (see additional comments and warnings on CefDoMessageLoopWork). This
    // callback should schedule a cef_do_message_loop_work() call to happen on the
    // main (UI) thread. |delay_ms| is the requested delay in milliseconds. If
    // |delay_ms| is <= 0 then the call should happen reasonably soon. If
    // |delay_ms| is > 0 then the call should be scheduled to happen after the
    // specified delay and any currently pending scheduled call should be
    // cancelled.
    on_schedule_message_pump_work: procedure(self: PCefBrowserProcessHandler; delay_ms: Int64); cconv;
  end;


{ ***  cef_callback_capi.h  *** }
  // Generic callback structure used for asynchronous continuation.
  TCefCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Continue processing.
    cont: procedure(self: PCefCallback); cconv;

    // Cancel processing.
    cancel: procedure(self: PCefCallback); cconv;
  end;


  // Generic callback structure used for asynchronous completion.
  TCefCompletionCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be called once the task is complete.
    on_complete: procedure(self: PCefCompletionCallback); cconv;
  end;


{ ***  cef_client_capi.h  *** }
  // Implement this structure to provide handler implementations.
  TCefClient = record
    // Base structure.
    base: TCefBaseRefCounted;

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

    // Return the handler for find result events.
    get_find_handler: function(self: PCefClient): PCefFindHandler; cconv;

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
    base: TCefBaseRefCounted;

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


{ ***  cef_context_menu_handler.h  *** }
  TCefRunContextMenuCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Complete context menu display by selecting the specified |command_id| and
    // |event_flags|.
    cont: procedure(self: PCefRunContextMenuCallback; command_id: Integer; event_flags: TCefEventFlags); cconv;

    // Cancel context menu display.
    cancel: procedure(self: PCefRunContextMenuCallback); cconv;
  end;


  // Implement this structure to handle context menu events. The functions of this
  // structure will be called on the UI thread.
  TCefContextMenuHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called before a context menu is displayed. |params| provides information
    // about the context menu state. |model| initially contains the default
    // context menu. The |model| can be cleared to show no context menu or
    // modified to show a custom menu. Do not keep references to |params| or
    // |model| outside of this callback.
    on_before_context_menu: procedure(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
      model: PCefMenuModel); cconv;

    // Called to allow custom display of the context menu. |params| provides
    // information about the context menu state. |model| contains the context menu
    // model resulting from OnBeforeContextMenu. For custom display return true
    // (1) and execute |callback| either synchronously or asynchronously with the
    // selected command ID. For default display return false (0). Do not keep
    // references to |params| or |model| outside of this callback.
    run_context_menu: function(self: PCefContextMenuHandler; browser: PCefBrowser; frame: PCefFrame;
      params: PCefContextMenuParams; model: PCefMenuModel; callback: PCefRunContextMenuCallback): Integer; cconv;

    // Called to execute a command selected from the context menu. Return true (1)
    // if the command was handled or false (0) for the default implementation. See
    // cef_menu_id_t for the command ids that have default implementations. All
    // user-defined command ids should be between MENU_ID_USER_FIRST and
    // MENU_ID_USER_LAST. |params| will have the same values as what was passed to
    // on_before_context_menu(). Do not keep a reference to |params| outside of
    // this callback.
    on_context_menu_command: function(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame; params: PCefContextMenuParams;
      command_id: Integer; event_flags: TCefEventFlags): Integer; cconv;

    // Called when the context menu is dismissed irregardless of whether the menu
    // was NULL or a command was selected.
    on_context_menu_dismissed: procedure(self: PCefContextMenuHandler;
      browser: PCefBrowser; frame: PCefFrame); cconv;
  end;


  // Provides information about the context menu state. The methods of this
  // structure can only be accessed on browser process the UI thread.
  TCefContextMenuParams = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_link_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the link URL, if any, to be used ONLY for "copy link address". We
    // don't validate this field in the frontend process.
    get_unfiltered_link_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the source URL, if any, for the element that the context menu was
    // invoked on. Example of elements with source URLs are img, audio, and video.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_source_url: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns true (1) if the context menu was invoked on an image which has non-
    // NULL contents.
    has_image_contents: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns the title text or the alt text if the context menu was invoked on
    // an image.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_title_text: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

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
    get_media_state_flags: function(self: PCefContextMenuParams): TCefContextMenuMediaStateFlags; cconv;

    // Returns the text of the selection, if any, that the context menu was
    // invoked on.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_selection_text: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns the text of the misspelled word, if any, that the context menu was
    // invoked on.
    get_misspelled_word: function(self: PCefContextMenuParams): PCefStringUserFree; cconv;

    // Returns true (1) if suggestions exist, false (0) otherwise. Fills in
    // |suggestions| from the spell check service for the misspelled word if there
    // is one.
    get_dictionary_suggestions: function(self: PCefContextMenuParams; suggestions: TCefStringList): Integer; cconv;

    // Returns true (1) if the context menu was invoked on an editable node.
    is_editable: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns true (1) if the context menu was invoked on an editable node where
    // spell-check is enabled.
    is_spell_check_enabled: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns flags representing the actions supported by the editable node, if
    // any, that the context menu was invoked on.
    //get_edit_state_flags: function(self: PCefContextMenuParams): Integer; cconv;
    get_edit_state_flags: function(self: PCefContextMenuParams): TCefContextMenuEditStateFlags; cconv;

    // Returns true (1) if the context menu contains items specified by the
    // renderer process (for example, plugin placeholder or pepper plugin menu
    // items).
    is_custom_menu: function(self: PCefContextMenuParams): Integer; cconv;

    // Returns true (1) if the context menu was invoked from a pepper plugin.
    is_pepper_menu: function(self: PCefContextMenuParams): Integer; cconv;
  end;


{ ***  cef_cookie_capi.h  *** }
  // Structure used for managing cookies. The functions of this structure may be
  // called on any thread unless otherwise indicated.
  TCefCookieManager = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Set the schemes supported by this manager. The default schemes ("http",
    // "https", "ws" and "wss") will always be supported. If |callback| is non-
    // NULL it will be executed asnychronously on the IO thread after the change
    // has been applied. Must be called before any cookies are accessed.
    set_supported_schemes: procedure(self: PCefCookieManager; schemes: TCefStringList;
      callback: PCefCompletionCallback); cconv;

    // Visit all cookies on the IO thread. The returned cookies are ordered by
    // longest path, then by earliest creation date. Returns false (0) if cookies
    // cannot be accessed.
    visit_all_cookies: function(self: PCefCookieManager; visitor: PCefCookieVisitor): Integer; cconv;

    // Visit a subset of cookies on the IO thread. The results are filtered by the
    // given url scheme, host, domain and path. If |includeHttpOnly| is true (1)
    // HTTP-only cookies will also be included in the results. The returned
    // cookies are ordered by longest path, then by earliest creation date.
    // Returns false (0) if cookies cannot be accessed.
    visit_url_cookies: function(self: PCefCookieManager; const url: PCefString;
      includeHttpOnly: Integer; visitor: PCefCookieVisitor): Integer; cconv;

    // Sets a cookie given a valid URL and explicit user-provided cookie
    // attributes. This function expects each attribute to be well-formed. It will
    // check for disallowed characters (e.g. the ';' character is disallowed
    // within the cookie value attribute) and fail without setting the cookie if
    // such characters are found. If |callback| is non-NULL it will be executed
    // asnychronously on the IO thread after the cookie has been set. Returns
    // false (0) if an invalid URL is specified or if cookies cannot be accessed.
    set_cookie: function(self: PCefCookieManager; const url: PCefString; const cookie: PCefCookie;
      callback: PCefSetCookieCallback): Integer; cconv;

    // Delete all cookies that match the specified parameters. If both |url| and
    // |cookie_name| values are specified all host and domain cookies matching
    // both will be deleted. If only |url| is specified all host cookies (but not
    // domain cookies) irrespective of path will be deleted. If |url| is NULL all
    // cookies for all hosts and domains will be deleted. If |callback| is non-
    // NULL it will be executed asnychronously on the IO thread after the cookies
    // have been deleted. Returns false (0) if a non-NULL invalid URL is specified
    // or if cookies cannot be accessed. Cookies can alternately be deleted using
    // the Visit*Cookies() functions.
    delete_cookies: function(self: PCefCookieManager; const url, cookie_name: PCefString;
      callback: PCefDeleteCookiesCallback): Integer; cconv;

    // Sets the directory path that will be used for storing cookie data. If
    // |path| is NULL data will be stored in memory only. Otherwise, data will be
    // stored at the specified |path|. To persist session cookies (cookies without
    // an expiry date or validity interval) set |persist_session_cookies| to true
    // (1). Session cookies are generally intended to be transient and most Web
    // browsers do not persist them. If |callback| is non-NULL it will be executed
    // asnychronously on the IO thread after the manager's storage has been
    // initialized. Returns false (0) if cookies cannot be accessed.
    set_storage_path: function(self: PCefCookieManager; const path: PCefString;
      persist_session_cookies: Integer; callback: PCefCompletionCallback): Integer; cconv;

    // Flush the backing store (if any) to disk. If |callback| is non-NULL it will
    // be executed asnychronously on the IO thread after the flush is complete.
    // Returns false (0) if cookies cannot be accessed.
    flush_store: function(self: PCefCookieManager; handler: PCefCompletionCallback): Integer; cconv;
  end;


  // Structure to implement for visiting cookie values. The functions of this
  // structure will always be called on the IO thread.
  TCefCookieVisitor = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be called once for each cookie. |count| is the 0-based
    // index for the current cookie. |total| is the total number of cookies. Set
    // |deleteCookie| to true (1) to delete the cookie currently being visited.
    // Return false (0) to stop visiting cookies. This function may never be
    // called if no cookies are found.
    visit: function(self: PCefCookieVisitor; const cookie: PCefCookie;
      count, total: Integer; deleteCookie: PInteger): Integer; cconv;
  end;


  // Structure to implement to be notified of asynchronous completion via
  // cef_cookie_manager_t::set_cookie().
  TCefSetCookieCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be called upon completion. |success| will be true (1) if
    // the cookie was set successfully.
    on_complete: procedure(self: PCefSetCookieCallback; success: Integer); cconv;
  end;


  // Structure to implement to be notified of asynchronous completion via
  // cef_cookie_manager_t::delete_cookies().
  TCefDeleteCookiesCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be called upon completion. |num_deleted| will be the
    // number of cookies that were deleted or -1 if unknown.
    on_complete: procedure(self: PCefDeleteCookiesCallback; num_deleted: Integer); cconv;
  end;


{ ***  cef_dialog_handler_capi.h  *** }
  // Callback structure for asynchronous continuation of file dialog requests.
  TCefFileDialogCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Continue the file selection. |selected_accept_filter| should be the 0-based
    // index of the value selected from the accept filters array passed to
    // cef_dialog_handler_t::OnFileDialog. |file_paths| should be a single value
    // or a list of values depending on the dialog mode. An NULL |file_paths|
    // value is treated the same as calling cancel().
    cont: procedure(self: PCefFileDialogCallback; selected_accept_filter: Integer;
      file_paths: TCefStringList); cconv;

    // Cancel the file selection.
    cancel: procedure(self: PCefFileDialogCallback); cconv;
  end;


  // Implement this structure to handle dialog events. The functions of this
  // structure will be called on the browser process UI thread.
  TCefDialogHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called to run a file chooser dialog. |mode| represents the type of dialog
    // to display. |title| to the title to be used for the dialog and may be NULL
    // to show the default title ("Open" or "Save" depending on the mode).
    // |default_file_path| is the path with optional directory and/or file name
    // component that should be initially selected in the dialog. |accept_filters|
    // are used to restrict the selectable file types and may any combination of
    // (a) valid lower-cased MIME types (e.g. "text/*" or "image/*"), (b)
    // individual file extensions (e.g. ".txt" or ".png"), or (c) combined
    // description and file extension delimited using "|" and ";" (e.g. "Image
    // Types|.png;.gif;.jpg"). |selected_accept_filter| is the 0-based index of
    // the filter that should be selected by default. To display a custom dialog
    // return true (1) and execute |callback| either inline or at a later time. To
    // display the default dialog return false (0).
    on_file_dialog: function(self: PCefDialogHandler; browser: PCefBrowser;
      mode: TCefFileDialogMode; const title, default_file_path: PCefString;
      accept_filters: TCefStringList; selected_accept_filter: Integer;
      callback: PCefFileDialogCallback): Integer; cconv;
  end;


{ ***  cef_display_handler_capi.h  *** }
  // Implement this structure to handle events related to browser display state.
  // The functions of this structure will be called on the UI thread.
  TCefDisplayHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called when a frame's address has changed.
    on_address_change: procedure(self: PCefDisplayHandler;
      browser: PCefBrowser; frame: PCefFrame; const url: PCefString); cconv;

    // Called when the page title changes.
    on_title_change: procedure(self: PCefDisplayHandler;
        browser: PCefBrowser; const title: PCefString); cconv;

    // Called when the page icon changes.
    on_favicon_urlchange: procedure(self: PCefDisplayHandler; browser: PCefBrowser; icon_urls: TCefStringList); cconv;

    // Called when web content in the page has toggled fullscreen mode. If
    // |fullscreen| is true (1) the content will automatically be sized to fill
    // the browser content area. If |fullscreen| is false (0) the content will
    // automatically return to its original size and position. The client is
    // responsible for resizing the browser if desired.
    on_fullscreen_mode_change: procedure(self: PCefDisplayHandler; browser: PCefBrowser; fullscreen: Integer); cconv;

    // Called when the browser is about to display a tooltip. |text| contains the
    // text that will be displayed in the tooltip. To handle the display of the
    // tooltip yourself return true (1). Otherwise, you can optionally modify
    // |text| and then return false (0) to allow the browser to display the
    // tooltip. When window rendering is disabled the application is responsible
    // for drawing tooltips and the return value is ignored.
    on_tooltip: function(self: PCefDisplayHandler;
        browser: PCefBrowser; text: PCefString): Integer; cconv;

    // Called when the browser receives a status message. |value| contains the
    // text that will be displayed in the status message.
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
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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

    // Returns the selection offset within the start node.
    get_selection_start_offset: function(self: PCefDomDocument): Integer; cconv;

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
    base: TCefBaseRefCounted;

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

    // Returns the bounds of the element.
    get_element_bounds: function(self: PCefDomNode): TCefRect; cconv;
  end;


{ ***  cef_download_handler_capi.h  *** }
  // Callback structure used to asynchronously continue a download.
  TCefBeforeDownloadCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

    // Call to cancel the download.
    cancel: procedure(self: PCefDownloadItemCallback); cconv;

    // Call to pause the download.
    pause: procedure(self: PCefDownloadItemCallback); cconv;

    // Call to resume the download.
    resume: procedure(self: PCefDownloadItemCallback); cconv;
  end;


  // Structure used to handle file downloads. The functions of this structure will
  // called on the browser process UI thread.
  TCefDownloadHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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
    get_id: function(self: PCefDownloadItem): UInt32; cconv;

    // Returns the URL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefDownloadItem): PCefStringUserFree; cconv;

    // Returns the original URL before any redirections.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_original_url: function(self: PCefDownloadItem): PCefStringUserFree; cconv;

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
    base: TCefBaseRefCounted;

    // Returns a copy of the current object.
    clone: function(self: PCefDragData): PCefDragData; cconv;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefDragData): Integer; cconv;

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

    // Write the contents of the file being dragged out of the web view into
    // |writer|. Returns the number of bytes sent to |writer|. If |writer| is NULL
    // this function will return the size of the file contents in bytes. Call
    // get_file_name() to get a suggested name for the file.
    get_file_contents: function(self: PCefDragData; writer: PCefStreamWriter): csize_t; cconv;

    // Retrieve the list of file names that are being dragged into the browser
    // window.
    get_file_names: function(self: PCefDragData; names: TCefStringList): Integer; cconv;

    // Set the link URL that is being dragged.
    set_link_url: procedure(self: PCefDragData; const url: PCefString); cconv;

    // Set the title associated with the link being dragged.
    set_link_title: procedure(self: PCefDragData; const title: PCefString); cconv;

    // Set the metadata associated with the link being dragged.
    set_link_metadata: procedure(self: PCefDragData; const data: PCefString); cconv;

    // Set the plain text fragment that is being dragged.
    set_fragment_text: procedure(self: PCefDragData; const text: PCefString); cconv;

    // Set the text/html fragment that is being dragged.
    set_fragment_html: procedure(self: PCefDragData; const html: PCefString); cconv;

    // Set the base URL that the fragment came from.
    set_fragment_base_url: procedure(self: PCefDragData; const base_url: PCefString); cconv;

    // Reset the file contents. You should do this before calling
    // cef_browser_host_t::DragTargetDragEnter as the web view does not allow us
    // to drag in this kind of data.
    reset_file_contents: procedure(self: PCefDragData); cconv;

    // Add a file that is being dragged into the webview.
    add_file: procedure(self: PCefDragData; const path, display_name: PCefString); cconv;
  end;


{ ***  cef_drag_handler_capi.h  *** }
  // Implement this structure to handle events related to dragging. The functions
  // of this structure will be called on the UI thread.
  TCefDragHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called when an external drag event enters the browser window. |dragData|
    // contains the drag event data and |mask| represents the type of drag
    // operation. Return false (0) for default drag handling behavior or true (1)
    // to cancel the drag event.
    on_drag_enter: function(self: PCefDragHandler; browser: PCefBrowser; dragData: PCefDragData;
      mask: TCefDragOperationsMask): Integer; cconv;

    // Called whenever draggable regions for the browser window change. These can
    // be specified using the '-webkit-app-region: drag/no-drag' CSS-property. If
    // draggable regions are never defined in a document this function will also
    // never be called. If the last draggable region is removed from a document
    // this function will be called with an NULL vector.
    on_draggable_regions_changed: procedure(self: PCefDragHandler; browser: PCefBrowser;
      regionsCount: csize_t; regions: PCefDraggableRegionArray); cconv;
  end;


{ ***  cef_find_handler_capi.h  *** }

  // Implement this structure to handle events related to find results. The
  // functions of this structure will be called on the UI thread.
  TCefFindHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called to report find results returned by cef_browser_host_t::find().
    // |identifer| is the identifier passed to find(), |count| is the number of
    // matches currently identified, |selectionRect| is the location of where the
    // match was found (in window coordinates), |activeMatchOrdinal| is the
    // current position in the search results, and |finalUpdate| is true (1) if
    // this is the last find notification.
    on_find_result: procedure(self: PCefFindHandler; browser: PCefBrowser; identifier, count: Integer;
      const selectionRect: PCefRect; activeMatchOrdinal, finalUpdate: Integer); cconv;
  end;


{ ***  cef_focus_handler_capi.h  *** }
  // Implement this structure to handle events related to focus. The functions of
  // this structure will be called on the UI thread.
  TCefFocusHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called when the browser component is about to loose focus. For instance, if
    // focus was on the last HTML element and the user pressed the TAB key. |next|
    // will be true (1) if the browser is giving focus to the next component and
    // false (0) if the browser is giving focus to the previous component.
    on_take_focus: procedure(self: PCefFocusHandler; browser: PCefBrowser; next: Integer); cconv;

    // Called when the browser component is requesting focus. |source| indicates
    // where the focus request is originating from. Return false (0) to allow the
    // focus to be set or true (1) to cancel setting the focus.
    on_set_focus: function(self: PCefFocusHandler; browser: PCefBrowser;
      source: TCefFocusSource): Integer; cconv;

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
    base: TCefBaseRefCounted;

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

    // Returns the globally unique identifier for this frame or < 0 if the
    // underlying frame does not yet exist.
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
    base: TCefBaseRefCounted;

    // Called with the 'best available' location information or, if the location
    // update failed, with error information.
    on_location_update: procedure(self: PCefGetGeolocationCallback; const position: PCefGeoposition); cconv;
  end;


{ ***  cef_geolocation_handler_capi.h  *** }
  // Callback structure used for asynchronous continuation of geolocation
  // permission requests.
  TCefGeolocationCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Call to allow or deny geolocation access.
    cont: procedure(self: PCefGeolocationCallback; allow: Integer); cconv;
  end;


  // Implement this structure to handle events related to geolocation permission
  // requests. The functions of this structure will be called on the browser
  // process UI thread.
  TCefGeolocationHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called when a page requests permission to access geolocation information.
    // |requesting_url| is the URL requesting permission and |request_id| is the
    // unique ID for the permission request. Return true (1) and call
    // cef_geolocation_callback_t::cont() either in this function or at a later
    // time to continue or cancel the request. Return false (0) to cancel the
    // request immediately.
    on_request_geolocation_permission: function(self: PCefGeolocationHandler; browser: PCefBrowser;
      const requesting_url: PCefString; request_id: Integer; callback: PCefGeolocationCallback): Integer; cconv;

    // Called when a geolocation access request is canceled. |request_id| is the
    // unique ID for the permission request.
    on_cancel_geolocation_permission: procedure(self: PCefGeolocationHandler;
        browser: PCefBrowser; request_id: Integer); cconv;
  end;


{ ***  cef_image_capi.h  *** }
  // Container for a single image represented at different scale factors. All
  // image representations should be the same size in density independent pixel
  // (DIP) units. For example, if the image at scale factor 1.0 is 100x100 pixels
  // then the image at scale factor 2.0 should be 200x200 pixels -- both images
  // will display with a DIP size of 100x100 units. The functions of this
  // structure must be called on the browser process UI thread.
  TCefImage = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this Image is NULL.
    is_empty: function(self: PCefImage): Integer; cconv;

    // Returns true (1) if this Image and |that| Image share the same underlying
    // storage. Will also return true (1) if both images are NULL.
    is_same: function(self, that: PCefImage): Integer; cconv;

    // Add a bitmap image representation for |scale_factor|. Only 32-bit RGBA/BGRA
    // formats are supported. |pixel_width| and |pixel_height| are the bitmap
    // representation size in pixel coordinates. |pixel_data| is the array of
    // pixel data and should be |pixel_width| x |pixel_height| x 4 bytes in size.
    // |color_type| and |alpha_type| values specify the pixel format.
    add_bitmap: function(self: PCefImage; scale_factor: Single; pixel_width, pixel_height: Integer;
      color_type: TCefColorType; alpha_type: TCefAlphaType; const pixel_data: Pointer;
      pixel_data_size: csize_t): Integer; cconv;

    // Add a PNG image representation for |scale_factor|. |png_data| is the image
    // data of size |png_data_size|. Any alpha transparency in the PNG data will
    // be maintained.
    add_png: function(self: PCefImage; scale_factor: Single; const png_data: Pointer;
      png_data_size: csize_t): Integer; cconv;

    // Create a JPEG image representation for |scale_factor|. |jpeg_data| is the
    // image data of size |jpeg_data_size|. The JPEG format does not support
    // transparency so the alpha byte will be set to 0xFF for all pixels.
    add_jpeg: function(self: PCefImage; scale_factor: Single; const jpeg_data: Pointer;
      jpeg_data_size: csize_t): Integer; cconv;

    // Returns the image width in density independent pixel (DIP) units.
    get_width: function(self: PCefImage): csize_t; cconv;

    // Returns the image height in density independent pixel (DIP) units.
    get_height: function(self: PCefImage): csize_t; cconv;

    // Returns true (1) if this image contains a representation for
    // |scale_factor|.
    has_representation: function(self: PCefImage; scale_factor: Single): Integer; cconv;

    // Removes the representation for |scale_factor|. Returns true (1) on success.
    remove_representation: function(self: PCefImage; scale_factor: Single): Integer; cconv;

    // Returns information for the representation that most closely matches
    // |scale_factor|. |actual_scale_factor| is the actual scale factor for the
    // representation. |pixel_width| and |pixel_height| are the representation
    // size in pixel coordinates. Returns true (1) on success.
    get_representation_info: function(self: PCefImage; scale_factor: Single;
      actual_scale_factor: PSingle; pixel_width, pixel_height: PInteger): Integer; cconv;

    // Returns the bitmap representation that most closely matches |scale_factor|.
    // Only 32-bit RGBA/BGRA formats are supported. |color_type| and |alpha_type|
    // values specify the desired output pixel format. |pixel_width| and
    // |pixel_height| are the output representation size in pixel coordinates.
    // Returns a cef_binary_value_t containing the pixel data on success or NULL
    // on failure.
    get_as_bitmap: function(self: PCefImage; scale_factor: Single; color_type: TCefColorType;
      alpha_type: TCefAlphaType; pixel_width, pixel_height: PInteger): PCefBinaryValue; cconv;

    // Returns the PNG representation that most closely matches |scale_factor|. If
    // |with_transparency| is true (1) any alpha transparency in the image will be
    // represented in the resulting PNG data. |pixel_width| and |pixel_height| are
    // the output representation size in pixel coordinates. Returns a
    // cef_binary_value_t containing the PNG image data on success or NULL on
    // failure.
    get_as_png: function(self: PCefImage; scale_factor: Single; with_transparency: Integer;
      pixel_width, pixel_height: PInteger): PCefBinaryValue; cconv;

    // Returns the JPEG representation that most closely matches |scale_factor|.
    // |quality| determines the compression level with 0 == lowest and 100 ==
    // highest. The JPEG format does not support alpha transparency and the alpha
    // channel, if any, will be discarded. |pixel_width| and |pixel_height| are
    // the output representation size in pixel coordinates. Returns a
    // cef_binary_value_t containing the JPEG image data on success or NULL on
    // failure.
    get_as_jpeg: function(self: PCefImage; scale_factor: Single; quality: Integer;
      pixel_width, pixel_height: PInteger): PCefBinaryValue; cconv;
  end;


{ ***  cef_jsdialog_handler_capi.h  *** }
  // Callback structure used for asynchronous continuation of JavaScript dialog
  // requests.
  TCefJsDialogCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Continue the JS dialog request. Set |success| to true (1) if the OK button
    // was pressed. The |user_input| value should be specified for prompt dialogs.
    cont: procedure(self: PCefJsDialogCallback; success: Integer; const user_input: PCefString); cconv;
  end;


  // Implement this structure to handle events related to JavaScript dialogs. The
  // functions of this structure will be called on the UI thread.
  TCefJsDialogHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called to run a JavaScript dialog. If |origin_url| is non-NULL it can be
    // passed to the CefFormatUrlForSecurityDisplay function to retrieve a secure
    // and user-friendly display string. The |default_prompt_text| value will be
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
    on_jsdialog: function(self: PCefJsDialogHandler; browser: PCefBrowser;
      const origin_url: PCefString; dialog_type: TCefJsDialogType;
      const message_text, default_prompt_text: PCefString;
      callback: PCefJsDialogCallback; suppress_message: PInteger): Integer; cconv;

    // Called to run a dialog asking the user if they want to leave a page. Return
    // false (0) to use the default dialog implementation. Return true (1) if the
    // application will use a custom dialog or if the callback has been executed
    // immediately. Custom dialogs may be either modal or modeless. If a custom
    // dialog is used the application must execute |callback| once the custom
    // dialog is dismissed.
    on_before_unload_dialog: function(self: PCefJsDialogHandler; browser: PCefBrowser;
      const message_text: PCefString; is_reload: Integer; callback: PCefJsDialogCallback): Integer; cconv;


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
    base: TCefBaseRefCounted;

    // Called before a keyboard event is sent to the renderer. |event| contains
    // information about the keyboard event. |os_event| is the operating system
    // event message, if any. Return true (1) if the event was handled or false
    // (0) otherwise. If the event will be handled in on_key_event() as a keyboard
    // shortcut set |is_keyboard_shortcut| to true (1) and return false (0).
    on_pre_key_event: function(self: PCefKeyboardHandler; browser: PCefBrowser;
      const event: PCefKeyEvent; os_event: TCefEventHandle; is_keyboard_shortcut: PInteger): Integer; cconv;

    // Called after the renderer and JavaScript in the page has had a chance to
    // handle the event. |event| contains information about the keyboard event.
    // |os_event| is the operating system event message, if any. Return true (1)
    // if the keyboard event was handled or false (0) otherwise.
    on_key_event: function(self: PCefKeyboardHandler; browser: PCefBrowser;
      const event: PCefKeyEvent; os_event: TCefEventHandle): Integer; cconv;
  end;


{ ***  cef_life_span_handler_capi.h  *** }
  // Implement this structure to handle events related to browser life span. The
  // functions of this structure will be called on the UI thread unless otherwise
  // indicated.
  TCefLifeSpanHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called on the IO thread before a new popup browser is created. The
    // |browser| and |frame| values represent the source of the popup request. The
    // |target_url| and |target_frame_name| values indicate where the popup
    // browser should navigate and may be NULL if not specified with the request.
    // The |target_disposition| value indicates where the user intended to open
    // the popup (e.g. current tab, new tab, etc). The |user_gesture| value will
    // be true (1) if the popup was opened via explicit user gesture (e.g.
    // clicking a link) or false (0) if the popup opened automatically (e.g. via
    // the DomContentLoaded event). The |popupFeatures| structure contains
    // additional information about the requested popup window. To allow creation
    // of the popup browser optionally modify |windowInfo|, |client|, |settings|
    // and |no_javascript_access| and return false (0). To cancel creation of the
    // popup browser return true (1). The |client| and |settings| values will
    // default to the source browser's values. If the |no_javascript_access| value
    // is set to false (0) the new browser will not be scriptable and may not be
    // hosted in the same renderer process as the source browser. Any
    // modifications to |windowInfo| will be ignored if the parent browser is
    // wrapped in a cef_browser_view_t. Popup browser creation will be canceled if
    // the parent browser is destroyed before the popup browser creation completes
    // (indicated by a call to OnAfterCreated for the popup browser).
    on_before_popup: function(self: PCefLifeSpanHandler; browser: PCefBrowser; frame: PCefFrame;
      const target_url, target_frame_name: PCefString; target_disposition: TCefWindowOpenDisposition;
      user_gesture: Integer; const popupFeatures: PCefPopupFeatures;
      windowInfo: PCefWindowInfo; var client: PCefClient; settings: PCefBrowserSettings;
      no_javascript_access: PInteger): Integer; cconv;

    // Called after a new browser is created. This callback will be the first
    // notification that references |browser|.
    on_after_created: procedure(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;

    // Called when a browser has recieved a request to close. This may result
    // directly from a call to cef_browser_host_t::*close_browser() or indirectly
    // if the browser is parented to a top-level window created by CEF and the
    // user attempts to close that window (by clicking the 'X', for example). The
    // do_close() function will be called after the JavaScript 'onunload' event
    // has been fired.
    //
    // An application should handle top-level owner window close notifications by
    // calling cef_browser_host_t::try_close_browser() or
    // cef_browser_host_t::CloseBrowser(false (0)) instead of allowing the window
    // to close immediately (see the examples below). This gives CEF an
    // opportunity to process the 'onbeforeunload' event and optionally cancel the
    // close before do_close() is called.
    //
    // When windowed rendering is enabled CEF will internally create a window or
    // view to host the browser. In that case returning false (0) from do_close()
    // will send the standard close notification to the browser's top-level owner
    // window (e.g. WM_CLOSE on Windows, performClose: on OS X, "delete_event" on
    // Linux or cef_window_delegate_t::can_close() callback from Views). If the
    // browser's host window/view has already been destroyed (via view hierarchy
    // tear-down, for example) then do_close() will not be called for that browser
    // since is no longer possible to cancel the close.
    //
    // When windowed rendering is disabled returning false (0) from do_close()
    // will cause the browser object to be destroyed immediately.
    //
    // If the browser's top-level owner window requires a non-standard close
    // notification then send that notification from do_close() and return true
    // (1).
    //
    // The cef_life_span_handler_t::on_before_close() function will be called
    // after do_close() (if do_close() is called) and immediately before the
    // browser object is destroyed. The application should only exit after
    // on_before_close() has been called for all existing browsers.
    //
    // The below examples describe what should happen during window close when the
    // browser is parented to an application-provided top-level window.
    //
    // Example 1: Using cef_browser_host_t::try_close_browser(). This is
    // recommended for clients using standard close handling and windows created
    // on the browser process UI thread. 1.  User clicks the window close button
    // which sends a close notification to
    //     the application's top-level window.
    // 2.  Application's top-level window receives the close notification and
    //     calls TryCloseBrowser() (which internally calls CloseBrowser(false)).
    //     TryCloseBrowser() returns false so the client cancels the window close.
    // 3.  JavaScript 'onbeforeunload' handler executes and shows the close
    //     confirmation dialog (which can be overridden via
    //     CefJSDialogHandler::OnBeforeUnloadDialog()).
    // 4.  User approves the close. 5.  JavaScript 'onunload' handler executes. 6.
    // CEF sends a close notification to the application's top-level window
    //     (because DoClose() returned false by default).
    // 7.  Application's top-level window receives the close notification and
    //     calls TryCloseBrowser(). TryCloseBrowser() returns true so the client
    //     allows the window close.
    // 8.  Application's top-level window is destroyed. 9.  Application's
    // on_before_close() handler is called and the browser object
    //     is destroyed.
    // 10. Application exits by calling cef_quit_message_loop() if no other
    // browsers
    //     exist.
    //
    // Example 2: Using cef_browser_host_t::CloseBrowser(false (0)) and
    // implementing the do_close() callback. This is recommended for clients using
    // non-standard close handling or windows that were not created on the browser
    // process UI thread. 1.  User clicks the window close button which sends a
    // close notification to
    //     the application's top-level window.
    // 2.  Application's top-level window receives the close notification and:
    //     A. Calls CefBrowserHost::CloseBrowser(false).
    //     B. Cancels the window close.
    // 3.  JavaScript 'onbeforeunload' handler executes and shows the close
    //     confirmation dialog (which can be overridden via
    //     CefJSDialogHandler::OnBeforeUnloadDialog()).
    // 4.  User approves the close. 5.  JavaScript 'onunload' handler executes. 6.
    // Application's do_close() handler is called. Application will:
    //     A. Set a flag to indicate that the next close attempt will be allowed.
    //     B. Return false.
    // 7.  CEF sends an close notification to the application's top-level window.
    // 8.  Application's top-level window receives the close notification and
    //     allows the window to close based on the flag from #6B.
    // 9.  Application's top-level window is destroyed. 10. Application's
    // on_before_close() handler is called and the browser object
    //     is destroyed.
    // 11. Application exits by calling cef_quit_message_loop() if no other
    // browsers
    //     exist.
    do_close: function(self: PCefLifeSpanHandler; browser: PCefBrowser): Integer; cconv;

    // Called just before a browser is destroyed. Release all references to the
    // browser object and do not attempt to execute any functions on the browser
    // object after this callback returns. This callback will be the last
    // notification that references |browser|. See do_close() documentation for
    // additional usage information.
    on_before_close: procedure(self: PCefLifeSpanHandler; browser: PCefBrowser); cconv;
  end;


{ *** cef_load_handler_capi.h  *** }
  // Implement this structure to handle events related to browser load status. The
  // functions of this structure will be called on the browser process UI thread
  // or render process main thread (TID_RENDERER).
  TCefLoadHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called when the loading state has changed. This callback will be executed
    // twice -- once when loading is initiated either programmatically or by user
    // action, and once when loading is terminated due to completion, cancellation
    // of failure. It will be called before any calls to OnLoadStart and after all
    // calls to OnLoadError and/or OnLoadEnd.
    on_loading_state_change: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      isLoading, canGoBack, canGoForward: Integer); cconv;

    // Called after a navigation has been committed and before the browser begins
    // loading contents in the frame. The |frame| value will never be NULL -- call
    // the is_main() function to check if this frame is the main frame.
    // |transition_type| provides information about the source of the navigation
    // and an accurate value is only available in the browser process. Multiple
    // frames may be loading at the same time. Sub-frames may start or continue
    // loading after the main frame load has ended. This function will not be
    // called for same page navigations (fragments, history state, etc.) or for
    // navigations that fail or are canceled before commit. For notification of
    // overall browser load status use OnLoadingStateChange instead.
    on_load_start: procedure(self: PCefLoadHandler; browser: PCefBrowser; frame: PCefFrame;
      transition_type: TCefTransitionType); cconv;

    // Called when the browser is done loading a frame. The |frame| value will
    // never be NULL -- call the is_main() function to check if this frame is the
    // main frame. Multiple frames may be loading at the same time. Sub-frames may
    // start or continue loading after the main frame load has ended. This
    // function will not be called for same page navigations (fragments, history
    // state, etc.) or for navigations that fail or are canceled before commit.
    // For notification of overall browser load status use OnLoadingStateChange
    // instead.
    on_load_end: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; httpStatusCode: Integer); cconv;

    // Called when a navigation fails or is canceled. This function may be called
    // by itself if before commit or in combination with OnLoadStart/OnLoadEnd if
    // after commit. |errorCode| is the error code number, |errorText| is the
    // error text and |failedUrl| is the URL that failed to load. See
    // net\base\net_error_list.h for complete descriptions of the error codes.
    on_load_error: procedure(self: PCefLoadHandler; browser: PCefBrowser;
      frame: PCefFrame; errorCode: TCefErrorCode; const errorText, failedUrl: PCefString); cconv;
  end;


{ *** cef_menu_model_capi.h  *** }
  // Supports creation and modification of menus. See cef_menu_id_t for the
  // command ids that have default implementations. All user-defined command ids
  // should be between MENU_ID_USER_FIRST and MENU_ID_USER_LAST. The functions of
  // this structure can only be accessed on the browser process the UI thread.
  TCefMenuModel = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this menu is a submenu.
    is_sub_menu: function(self: PCefMenuModel): Integer; cconv;

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

    // Set the explicit color for |command_id| and |color_type| to |color|.
    // Specify a |color| value of 0 to remove the explicit color. If no explicit
    // color or default color is set for |color_type| then the system color will
    // be used. Returns true (1) on success.
    set_color: function(self: PCefMenuModel; command_id: Integer; color_type: TCefMenuColorType;
      color: TCefColor): Integer; cconv;

    // Set the explicit color for |command_id| and |index| to |color|. Specify a
    // |color| value of 0 to remove the explicit color. Specify an |index| value
    // of -1 to set the default color for items that do not have an explicit color
    // set. If no explicit color or default color is set for |color_type| then the
    // system color will be used. Returns true (1) on success.
    set_color_at: function(self: PCefMenuModel; index: Integer; color_type: TCefMenuColorType;
      color: TCefColor): Integer; cconv;

    // Returns in |color| the color that was explicitly set for |command_id| and
    // |color_type|. If a color was not set then 0 will be returned in |color|.
    // Returns true (1) on success.
    get_color: function(self: PCefMenuModel; command_id: Integer; color_type: TCefMenuColorType;
      color: PCefColor): Integer; cconv;

    // Returns in |color| the color that was explicitly set for |command_id| and
    // |color_type|. Specify an |index| value of -1 to return the default color in
    // |color|. If a color was not set then 0 will be returned in |color|. Returns
    // true (1) on success.
    get_color_at: function(self: PCefMenuModel; index: Integer; color_type: TCefMenuColorType;
      color: PCefColor): Integer; cconv;

    // Sets the font list for the specified |command_id|. If |font_list| is NULL
    // the system font will be used. Returns true (1) on success. The format is
    // "<FONT_FAMILY_LIST>,[STYLES] <SIZE>", where: - FONT_FAMILY_LIST is a comma-
    // separated list of font family names, - STYLES is an optional space-
    // separated list of style names (case-sensitive
    //   "Bold" and "Italic" are supported), and
    // - SIZE is an integer font size in pixels with the suffix "px".
    //
    // Here are examples of valid font description strings: - "Arial, Helvetica,
    // Bold Italic 14px" - "Arial, 14px"
    set_font_list: function(self: PCefMenuModel; command_id: Integer;
      const font_list: PCefString): Integer; cconv;

    // Sets the font list for the specified |index|. Specify an |index| value of
    // -1 to set the default font. If |font_list| is NULL the system font will be
    // used. Returns true (1) on success. The format is
    // "<FONT_FAMILY_LIST>,[STYLES] <SIZE>", where: - FONT_FAMILY_LIST is a comma-
    // separated list of font family names, - STYLES is an optional space-
    // separated list of style names (case-sensitive
    //   "Bold" and "Italic" are supported), and
    // - SIZE is an integer font size in pixels with the suffix "px".
    //
    // Here are examples of valid font description strings: - "Arial, Helvetica,
    // Bold Italic 14px" - "Arial, 14px"
    set_font_list_at: function(self: PCefMenuModel; index: Integer;
      const font_list: PCefString): Integer; cconv;
  end;


{ *** cef_menu_model_delegate_capi.h  *** }
  // Implement this structure to handle menu model events. The functions of this
  // structure will be called on the browser process UI thread unless otherwise
  // indicated.
  TCefMenuModelDelegate = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Perform the action associated with the specified |command_id| and optional
    // |event_flags|.
    execute_command: procedure(self: PCefMenuModelDelegate; menu_model: PCefMenuModel;
      command_id: Integer; event_flags: TCefEventFlags); cconv;

    // Called when the user moves the mouse outside the menu and over the owning
    // window.
    mouse_outside_menu: procedure(self: PCefMenuModelDelegate; menu_model: PCefMenuModel;
      const screen_point: PCefPoint); cconv;

    // Called on unhandled open submenu keyboard commands. |is_rtl| will be true
    // (1) if the menu is displaying a right-to-left language.
    unhandled_open_submenu: procedure(self: PCefMenuModelDelegate; menu_model: PCefMenuModel;
      is_rtl: Integer); cconv;

    // Called on unhandled close submenu keyboard commands. |is_rtl| will be true
    // (1) if the menu is displaying a right-to-left language.
    unhandled_close_submenu: procedure(self: PCefMenuModelDelegate; menu_model: PCefMenuModel;
      is_rtl: Integer); cconv;

    // The menu is about to show.
    menu_will_show: procedure(self: PCefMenuModelDelegate; menu_model: PCefMenuModel); cconv;

    // The menu has closed.
    menu_closed: procedure(self: PCefMenuModelDelegate; menu_model: PCefMenuModel); cconv;

    // Optionally modify a menu item label. Return true (1) if |label| was
    // modified.
    format_label: function(self: PCefMenuModelDelegate; menu_model: PCefMenuModel;
      label_: PCefString): Integer; cconv;
  end;


{ ***  cef_navigation_entry_capi.h  *** }
  // Structure used to represent an entry in navigation history.
  TCefNavigationEntry = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefNavigationEntry): Integer; cconv;

    // Returns the actual URL of the page. For some pages this may be data: URL or
    // similar. Use get_display_url() to return a display-friendly version.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefNavigationEntry): PCefStringUserFree; cconv;

    // Returns a display-friendly version of the URL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_display_url: function(self: PCefNavigationEntry): PCefStringUserFree; cconv;

    // Returns the original URL that was entered by the user before any redirects.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_original_url: function(self: PCefNavigationEntry): PCefStringUserFree; cconv;

    // Returns the title set by the page. This value may be NULL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_title: function(self: PCefNavigationEntry): PCefStringUserFree; cconv;

    // Returns the transition type which indicates what the user did to move to
    // this page from the previous page.
    get_transition_type: function(self: PCefNavigationEntry): TCefTransitionType; cconv;

    // Returns true (1) if this navigation includes post data.
    has_post_data: function(self: PCefNavigationEntry): Integer; cconv;

    // Returns the time for the last known successful navigation completion. A
    // navigation may be completed more than once if the page is reloaded. May be
    // 0 if the navigation has not yet completed.
    get_completion_time: function(self: PCefNavigationEntry): TCefTime; cconv;

    // Returns the HTTP status code for the last known successful navigation
    // response. May be 0 if the response has not yet been received or if the
    // navigation has not yet completed.
    get_http_status_code: function(self: PCefNavigationEntry): Integer; cconv;

    // Returns the SSL information for this navigation entry.
    get_sslstatus: function(self: PCefNavigationEntry): PCefSslstatus; cconv;
  end;


{ ***  cef_print_handler_capi.h  *** }
  // Callback structure for asynchronous continuation of print dialog requests.
  TCefPrintDialogCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Continue printing with the specified |settings|.
    cont: procedure(self: PCefPrintDialogCallback; settings: PCefPrintSettings); cconv;

    // Cancel the printing.
    cancel: procedure(self: PCefPrintDialogCallback); cconv;
  end;

  TCefPrintJobCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Indicate completion of the print job.
    cont: procedure(self: PCefPrintJobCallback); cconv;
  end;

  // Implement this structure to handle printing on Linux. The functions of this
  // structure will be called on the browser process UI thread.
  TCefPrintHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called when printing has started for the specified |browser|. This function
    // will be called before the other OnPrint*() functions and irrespective of
    // how printing was initiated (e.g. cef_browser_host_t::print(), JavaScript
    // window.print() or PDF extension print button).
    on_print_start: procedure(self: PCefPrintHandler; browser: PCefBrowser); cconv;

    // Synchronize |settings| with client state. If |get_defaults| is true (1)
    // then populate |settings| with the default print settings. Do not keep a
    // reference to |settings| outside of this callback.
    on_print_settings: procedure(self: PCefPrintHandler; settings: PCefPrintSettings; get_defaults: Integer); cconv;

    // Show the print dialog. Execute |callback| once the dialog is dismissed.
    // Return true (1) if the dialog will be displayed or false (0) to cancel the
    // printing immediately.
    on_print_dialog: function(self: PCefPrintHandler; has_selection: Integer;
      callback: PCefPrintDialogCallback): Integer; cconv;

    // Send the print job to the printer. Execute |callback| once the job is
    // completed. Return true (1) if the job will proceed or false (0) to cancel
    // the job immediately.
    on_print_job: function(self: PCefPrintHandler; const document_name, pdf_file_path: PCefString;
      callback: PCefPrintJobCallback): Integer; cconv;

    // Reset client state related to printing.
    on_print_reset: procedure(self: PCefPrintHandler); cconv;

    // Return the PDF paper size in device units. Used in combination with
    // cef_browser_host_t::print_to_pdf().
    get_pdf_paper_size: function(self: PCefPrintHandler; device_units_per_inch: Integer): TCefSize; cconv;
  end;


{ ***  cef_print_settings_capi.h  *** }
  TCefPrintSettings = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is valid. Do not call any other functions
    // if this function returns false (0).
    is_valid: function(self: PCefPrintSettings): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefPrintSettings): Integer; cconv;

    // Returns a writable copy of this object.
    copy: function(self: PCefPrintSettings): PCefPrintSettings; cconv;

    // Set the page orientation.
    set_orientation: procedure(self: PCefPrintSettings; landscape: Integer); cconv;

    // Returns true (1) if the orientation is landscape.
    is_landscape: function(self: PCefPrintSettings): Integer; cconv;

    // Set the printer printable area in device units. Some platforms already
    // provide flipped area. Set |landscape_needs_flip| to false (0) on those
    // platforms to avoid double flipping.
    set_printer_printable_area: procedure(self: PCefPrintSettings; const physical_size_device_units: PCefSize;
      const printable_area_device_units: PCefRect; landscape_needs_flip: Integer); cconv;

    // Set the device name.
    set_device_name: procedure(self: PCefPrintSettings; const name: PCefString); cconv;

    // Get the device name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_device_name: function(self: PCefPrintSettings): PCefStringUserFree; cconv;

    // Set the DPI (dots per inch).
    set_dpi: procedure(self: PCefPrintSettings; dpi: Integer); cconv;

    // Get the DPI (dots per inch).
    get_dpi: function(self: PCefPrintSettings): Integer; cconv;

    // Set the page ranges.
    set_page_ranges: procedure(self: PCefPrintSettings; rangesCount: csize_t; ranges: PCefRangeArray); cconv;

    // Returns the number of page ranges that currently exist.
    get_page_ranges_count: function(self: PCefPrintSettings): csize_t; cconv;

    // Retrieve the page ranges.
    get_page_ranges: procedure(self: PCefPrintSettings; rangesCount: csize_t; ranges: PCefRangeArray); cconv;

    // Set whether only the selection will be printed.
    set_selection_only: procedure(self: PCefPrintSettings; selection_only: Integer); cconv;

    // Returns true (1) if only the selection will be printed.
    is_selection_only: function(self: PCefPrintSettings): Integer; cconv;

    // Set whether pages will be collated.
    set_collate: procedure(self: PCefPrintSettings; collate: Integer); cconv;

    // Returns true (1) if pages will be collated.
    will_collate: function(self: PCefPrintSettings): Integer; cconv;

    // Set the color model.
    set_color_model: procedure(self: PCefPrintSettings; model: TCefColorModel); cconv;

    // Get the color model.
    get_color_model: function(self: PCefPrintSettings): TCefColorModel; cconv;

    // Set the number of copies.
    set_copies: procedure(self: PCefPrintSettings; copies: Integer); cconv;

    // Get the number of copies.
    get_copies: function(self: PCefPrintSettings): Integer; cconv;

    // Set the duplex mode.
    set_duplex_mode: procedure(self: PCefPrintSettings; mode: TCefDuplexMode); cconv;

    // Get the duplex mode.
    get_duplex_mode: function(self: PCefPrintSettings): TCefDuplexMode; cconv;
  end;


{ ***  cef_process_message_capi.h  *** }
  // Structure representing a message. Can be used on any process and thread.
  TCefProcessMessage = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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
    get_screen_info: function(self: PCefRenderHandler; browser: PCefBrowser;
      screen_info: PCefScreenInfo): Integer; cconv;

    // Called when the browser wants to show or hide the popup widget. The popup
    // should be shown if |show| is true (1) and hidden if |show| is false (0).
    on_popup_show: procedure(self: PCefRenderHandler; browser: PCefBrowser; show: Integer); cconv;

    // Called when the browser wants to move or resize the popup widget. |rect|
    // contains the new location and size in view coordinates.
    on_popup_size: procedure(self: PCefRenderHandler; browser: PCefBrowser; const rect: PCefRect); cconv;

    // Called when an element should be painted. Pixel values passed to this
    // function are scaled relative to view coordinates based on the value of
    // CefScreenInfo.device_scale_factor returned from GetScreenInfo. |type|
    // indicates whether the element is the view or the popup widget. |buffer|
    // contains the pixel data for the whole image. |dirtyRects| contains the set
    // of rectangles in pixel coordinates that need to be repainted. |buffer| will
    // be |width|*|height|*4 bytes in size and represents a BGRA image with an
    // upper-left origin.
    on_paint: procedure(self: PCefRenderHandler; browser: PCefBrowser; type_: TCefPaintElementType;
      dirtyRectsCount: csize_t; dirtyRects: PCefRectArray;
      const buffer: Pointer; width, height: Integer); cconv;

    // Called when the browser's cursor has changed. If |type| is CT_CUSTOM then
    // |custom_cursor_info| will be populated with the custom cursor information.
    on_cursor_change: procedure(self: PCefRenderHandler; browser: PCefBrowser; cursor: TCefCursorHandle;
      type_: TCefCursorType; const custom_cursor_info: PCefCursorInfo); cconv;

    // Called when the user starts dragging content in the web view. Contextual
    // information about the dragged content is supplied by |drag_data|. (|x|,
    // |y|) is the drag start location in screen coordinates. OS APIs that run a
    // system message loop may be used within the StartDragging call.
    //
    // Return false (0) to abort the drag operation. Don't call any of
    // cef_browser_host_t::DragSource*Ended* functions after returning false (0).
    //
    // Return true (1) to handle the drag operation. Call
    // cef_browser_host_t::DragSourceEndedAt and DragSourceSystemDragEnded either
    // synchronously or asynchronously to inform the web view that the drag
    // operation has ended.
    start_dragging: function(self: PCefRenderHandler; browser: PCefBrowser; drag_data: PCefDragData;
      allowed_ops: TCefDragOperationsMask; x, y: Integer): Integer; cconv;

    // Called when the web view wants to update the mouse cursor during a drag &
    // drop operation. |operation| describes the allowed operation (none, move,
    // copy, link).
    update_drag_cursor: procedure(self: PCefRenderHandler; browser: PCefBrowser;
      operation: TCefDragOperationsMask); cconv;

    // Called when the scroll offset has changed.
    on_scroll_offset_changed: procedure(self: PCefRenderHandler; browser: PCefBrowser;
      x, y: Double); cconv;

    // Called when the IME composition range has changed. |selected_range| is the
    // range of characters that have been selected. |character_bounds| is the
    // bounds of each character in view coordinates.
    on_ime_composition_range_changed: procedure(self: PCefRenderHandler; browser: PCefBrowser;
      const selected_range: PCefRange; character_boundsCount: csize_t;
      character_bounds: PCefRectArray); cconv;
  end;


{ *** cef_render_process_handler_capi.h  *** }
  // Structure used to implement render process callbacks. The functions of this
  // structure will be called on the render process main thread (TID_RENDERER)
  // unless otherwise indicated.
  TCefRenderProcessHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called after the render process main thread has been created. |extra_info|
    // is a read-only value originating from
    // cef_browser_process_handler_t::on_render_process_thread_created(). Do not
    // keep a reference to |extra_info| outside of this function.
    on_render_thread_created: procedure(self: PCefRenderProcessHandler; extra_info: PCefListValue); cconv;

    // Called after WebKit has been initialized.
    on_web_kit_initialized: procedure(self: PCefRenderProcessHandler); cconv;

    // Called after a browser has been created. When browsing cross-origin a new
    // browser will be created before the old browser with the same identifier is
    // destroyed.
    on_browser_created: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser); cconv;

    // Called before a browser is destroyed.
    on_browser_destroyed: procedure(self: PCefRenderProcessHandler; browser: PCefBrowser); cconv;

    // Return the handler for browser load status events.
    get_load_handler: function(self: PCefRenderProcessHandler): PCefLoadHandler; cconv;

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
    base: TCefBaseRefCounted;

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

    // Set the referrer URL and policy. If non-NULL the referrer URL must be fully
    // qualified with an HTTP or HTTPS scheme component. Any username, password or
    // ref component will be removed.
    set_referrer: procedure(self: PCefRequest; const referrer_url: PCefString; policy: TCefReferrerPolicy); cconv;

    // Get the referrer URL.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_referrer_url: function(self: PCefRequest): PCefStringUserFree; cconv;

    // Get the referrer policy.
    get_referrer_policy: function(self: PCefRequest): TCefReferrerPolicy; cconv;

    // Get the post data.
    get_post_data: function(self: PCefRequest): PCefPostData; cconv;

    // Set the post data.
    set_post_data: procedure(self: PCefRequest; postData: PCefPostData); cconv;

    // Get the header values. Will not include the Referer value if any.
    get_header_map: procedure(self: PCefRequest; headerMap: TCefStringMultimap); cconv;

    // Set the header values. If a Referer value exists in the header map it will
    // be removed and ignored.
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

    // Get the resource type for this request. Only available in the browser
    // process.
    get_resource_type: function(self: PCefRequest): TCefResourceType; cconv;

    // Get the transition type for this request. Only available in the browser
    // process and only applies to requests that represent a main frame or sub-
    // frame navigation.
    get_transition_type: function(self: PCefRequest): TCefTransitionType; cconv;

    // Returns the globally unique identifier for this request or 0 if not
    // specified. Can be used by cef_request_tHandler implementations in the
    // browser process to track a single request across multiple callbacks.
    get_identifier: function(self: PCefRequest): UInt64; cconv;
  end;


  // Structure used to represent post data for a web request. The functions of
  // this structure may be called on any thread.
  TCefPostData = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefPostData):Integer; cconv;

    // Returns true (1) if the underlying POST data includes elements that are not
    // represented by this cef_post_data_t object (for example, multi-part file
    // upload data). Modifying cef_post_data_t objects with excluded elements may
    // result in the request failing.
    has_excluded_elements: function(self: PCefPostData): Integer; cconv;

    // Returns the number of existing post data elements.
    get_element_count: function(self: PCefPostData): csize_t; cconv;

    // Retrieve the post data elements.
    get_elements: procedure(self: PCefPostData; elementsCount: Pcsize_t;
      elements: PCefPostDataElementArray); cconv;

    // Remove the specified post data element.  Returns true (1) if the removal
    // succeeds.
    remove_element: function(self: PCefPostData; element: PCefPostDataElement): Integer; cconv;

    // Add the specified post data element.  Returns true (1) if the add succeeds.
    add_element: function(self: PCefPostData; element: PCefPostDataElement): Integer; cconv;

    // Remove all existing post data elements.
    remove_elements: procedure(self: PCefPostData); cconv;
  end;

  // Structure used to represent a single element in the request post data. The
  // functions of this structure may be called on any thread.
  TCefPostDataElement = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefPostDataElement): Integer; cconv;

    // Remove all contents from the post data element.
    set_to_empty: procedure(self: PCefPostDataElement); cconv;

    // The post data element will represent a file.
    set_to_file: procedure(self: PCefPostDataElement; const fileName: PCefString); cconv;

    // The post data element will represent bytes.  The bytes passed in will be
    // copied.
    set_to_bytes: procedure(self: PCefPostDataElement; size: csize_t; const bytes: Pointer); cconv;

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
    get_bytes: function(self: PCefPostDataElement; size: csize_t; bytes: Pointer): csize_t; cconv;
  end;


{ *** cef_request_context_capi.h *** }
  // Callback structure for cef_request_tContext::ResolveHost.
  TCefResolveCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called after the ResolveHost request has completed. |result| will be the
    // result code. |resolved_ips| will be the list of resolved IP addresses or
    // NULL if the resolution failed.
    on_resolve_completed: procedure(self: PCefResolveCallback; result: TCefErrorCode;
      resolved_ips: TCefStringList); cconv;
  end;

  // A request context provides request handling for a set of related browser or
  // URL request objects. A request context can be specified when creating a new
  // browser via the cef_browser_host_t static factory functions or when creating
  // a new URL request via the cef_urlrequest_t static factory functions. Browser
  // objects with different request contexts will never be hosted in the same
  // render process. Browser objects with the same request context may or may not
  // be hosted in the same render process depending on the process model. Browser
  // objects created indirectly via the JavaScript window.open function or
  // targeted links will share the same render process and the same request
  // context as the source browser. When running in single-process mode there is
  // only a single render process (the main process) and so all browsers created
  // in single-process mode will share the same request context. This will be the
  // first request context passed into a cef_browser_host_t static factory
  // function and all other request context objects will be ignored.
  TCefRequestContext = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is pointing to the same context as |that|
    // object.
    is_same: function(self: PCefRequestContext; other: PCefRequestContext): Integer; cconv;

    // Returns true (1) if this object is sharing the same storage as |that|
    // object.
    is_sharing_with: function(self: PCefRequestContext; other: PCefRequestContext): Integer; cconv;

    // Returns true (1) if this object is the global context. The global context
    // is used by default when creating a browser or URL request with a NULL
    // context argument.
    is_global: function(self: PCefRequestContext): Integer; cconv;

    // Returns the handler for this context if any.
    get_handler: function(self: PCefRequestContext): PCefRequestContextHandler; cconv;

    // Returns the cache path for this object. If NULL an "incognito mode" in-
    // memory cache is being used.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_cache_path: function(self: PCefRequestContext): PCefStringUserFree; cconv;

    // Returns the default cookie manager for this object. This will be the global
    // cookie manager if this object is the global request context. Otherwise,
    // this will be the default cookie manager used when this request context does
    // not receive a value via cef_request_tContextHandler::get_cookie_manager().
    // If |callback| is non-NULL it will be executed asnychronously on the IO
    // thread after the manager's storage has been initialized.
    get_default_cookie_manager: function(self: PCefRequestContext; callback: PCefCompletionCallback): PCefCookieManager; cconv;

    // Register a scheme handler factory for the specified |scheme_name| and
    // optional |domain_name|. An NULL |domain_name| value for a standard scheme
    // will cause the factory to match all domain names. The |domain_name| value
    // will be ignored for non-standard schemes. If |scheme_name| is a built-in
    // scheme and no handler is returned by |factory| then the built-in scheme
    // handler factory will be called. If |scheme_name| is a custom scheme then
    // you must also implement the cef_app_t::on_register_custom_schemes()
    // function in all processes. This function may be called multiple times to
    // change or remove the factory that matches the specified |scheme_name| and
    // optional |domain_name|. Returns false (0) if an error occurs. This function
    // may be called on any thread in the browser process.
    register_scheme_handler_factory: function(self: PCefRequestContext; const scheme_name, domain_name: PCefString;
      factory: PCefSchemeHandlerFactory): Integer; cconv;

    // Clear all registered scheme handler factories. Returns false (0) on error.
    // This function may be called on any thread in the browser process.
    clear_scheme_handler_factories: function(self: PCefRequestContext): Integer; cconv;

    // Tells all renderer processes associated with this context to throw away
    // their plugin list cache. If |reload_pages| is true (1) they will also
    // reload all pages with plugins.
    // cef_request_tContextHandler::OnBeforePluginLoad may be called to rebuild
    // the plugin list cache.
    purge_plugin_list_cache: procedure(self: PCefRequestContext; reload_pages: Integer); cconv;

    // Returns true (1) if a preference with the specified |name| exists. This
    // function must be called on the browser process UI thread.
    has_preference: function(self: PCefRequestContext; const name: PCefString): Integer; cconv;

    // Returns the value for the preference with the specified |name|. Returns
    // NULL if the preference does not exist. The returned object contains a copy
    // of the underlying preference value and modifications to the returned object
    // will not modify the underlying preference value. This function must be
    // called on the browser process UI thread.
    get_preference: function(self: PCefRequestContext; const name: PCefString): PCefValue; cconv;

    // Returns all preferences as a dictionary. If |include_defaults| is true (1)
    // then preferences currently at their default value will be included. The
    // returned object contains a copy of the underlying preference values and
    // modifications to the returned object will not modify the underlying
    // preference values. This function must be called on the browser process UI
    // thread.
    get_all_preferences: function(self: PCefRequestContext; include_defaults: Integer): PCefDictionaryValue; cconv;

    // Returns true (1) if the preference with the specified |name| can be
    // modified using SetPreference. As one example preferences set via the
    // command-line usually cannot be modified. This function must be called on
    // the browser process UI thread.
    can_set_preference: function(self: PCefRequestContext; const name: PCefString): Integer; cconv;

    // Set the |value| associated with preference |name|. Returns true (1) if the
    // value is set successfully and false (0) otherwise. If |value| is NULL the
    // preference will be restored to its default value. If setting the preference
    // fails then |error| will be populated with a detailed description of the
    // problem. This function must be called on the browser process UI thread.
    set_preference: function(self: PCefRequestContext; const name: PCefString; value: PCefValue;
      error: PCefString): Integer; cconv;

    // Clears all certificate exceptions that were added as part of handling
    // cef_request_tHandler::on_certificate_error(). If you call this it is
    // recommended that you also call close_all_connections() or you risk not
    // being prompted again for server certificates if you reconnect quickly. If
    // |callback| is non-NULL it will be executed on the UI thread after
    // completion.
    clear_certificate_exceptions: procedure(self: PCefRequestContext; callback: PCefCompletionCallback); cconv;

    // Clears all active and idle connections that Chromium currently has. This is
    // only recommended if you have released all other CEF objects but don't yet
    // want to call cef_shutdown(). If |callback| is non-NULL it will be executed
    // on the UI thread after completion.
    close_all_connections: procedure(self: PCefRequestContext; callback: PCefCompletionCallback); cconv;

    // Attempts to resolve |origin| to a list of associated IP addresses.
    // |callback| will be executed on the UI thread after completion.
    resolve_host: procedure(self: PCefRequestContext; const origin: PCefString;
      callback: PCefResolveCallback); cconv;

    // Attempts to resolve |origin| to a list of associated IP addresses using
    // cached data. |resolved_ips| will be populated with the list of resolved IP
    // addresses or NULL if no cached data is available. Returns ERR_NONE on
    // success. This function must be called on the browser process IO thread.
    resolve_host_cached: function(self: PCefRequestCallback; const origin: PCefString;
      resolved_ips: TCefStringList): TCefErrorCode; cconv;
  end;


{ *** cef_request_context_handler_capi.h *** }
  // Implement this structure to provide handler implementations. The handler
  // instance will not be released until all objects related to the context have
  // been destroyed.
  TCefRequestContextHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called on the browser process IO thread to retrieve the cookie manager. If
    // this function returns NULL the default cookie manager retrievable via
    // cef_request_tContext::get_default_cookie_manager() will be used.
    get_cookie_manager: function(self: PCefRequestContextHandler): PCefCookieManager; cconv;

    // Called on multiple browser process threads before a plugin instance is
    // loaded. |mime_type| is the mime type of the plugin that will be loaded.
    // |plugin_url| is the content URL that the plugin will load and may be NULL.
    // |is_main_frame| will be true (1) if the plugin is being loaded in the main
    // (top-level) frame, |top_origin_url| is the URL for the top-level frame that
    // contains the plugin when loading a specific plugin instance or NULL when
    // building the initial list of enabled plugins for 'navigator.plugins'
    // JavaScript state. |plugin_info| includes additional information about the
    // plugin that will be loaded. |plugin_policy| is the recommended policy.
    // Modify |plugin_policy| and return true (1) to change the policy. Return
    // false (0) to use the recommended policy. The default plugin policy can be
    // set at runtime using the `--plugin-policy=[allow|detect|block]` command-
    // line flag. Decisions to mark a plugin as disabled by setting
    // |plugin_policy| to PLUGIN_POLICY_DISABLED may be cached when
    // |top_origin_url| is NULL. To purge the plugin list cache and potentially
    // trigger new calls to this function call
    // cef_request_tContext::PurgePluginListCache.
    on_before_plugin_load: function(self: PCefRequestContextHandler; const mime_type, plugin_url: PCefString;
      is_main_frame: Integer; const top_origin_url: PCefString; plugin_info: PCefWebPluginInfo;
      plugin_policy: PCefPluginPolicy): Integer; cconv;
  end;


{ ***  cef_request_handler_capi.h  *** }
  // Callback structure used for asynchronous continuation of url requests.
  TCefRequestCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Continue the url request. If |allow| is true (1) the request will be
    // continued. Otherwise, the request will be canceled.
    cont: procedure(self: PCefRequestCallback; allow: Integer); cconv;

    // Cancel the url request.
    cancel: procedure(self: PCefRequestCallback); cconv;
  end;

  // Callback structure used to select a client certificate for authentication.
  TCefSelectClientCertificateCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Chooses the specified certificate for client certificate authentication.
    // NULL value means that no client certificate should be used.
    select: procedure(self: PCefSelectClientCertificateCallback; cert: PCefX509certificate); cconv;
  end;


  // Implement this structure to handle events related to browser requests. The
  // functions of this structure will be called on the thread indicated.
  TCefRequestHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called on the UI thread before browser navigation. Return true (1) to
    // cancel the navigation or false (0) to allow the navigation to proceed. The
    // |request| object cannot be modified in this callback.
    // cef_load_handler_t::OnLoadingStateChange will be called twice in all cases.
    // If the navigation is allowed cef_load_handler_t::OnLoadStart and
    // cef_load_handler_t::OnLoadEnd will be called. If the navigation is canceled
    // cef_load_handler_t::OnLoadError will be called with an |errorCode| value of
    // ERR_ABORTED.
    on_before_browse: function(self: PCefRequestHandler; browser: PCefBrowser; frame: PCefFrame;
      request: PCefRequest; is_redirect: Integer): Integer; cconv;

    // Called on the UI thread before OnBeforeBrowse in certain limited cases
    // where navigating a new or different browser might be desirable. This
    // includes user-initiated navigation that might open in a special way (e.g.
    // links clicked via middle-click or ctrl + left-click) and certain types of
    // cross-origin navigation initiated from the renderer process (e.g.
    // navigating the top-level frame to/from a file URL). The |browser| and
    // |frame| values represent the source of the navigation. The
    // |target_disposition| value indicates where the user intended to navigate
    // the browser based on standard Chromium behaviors (e.g. current tab, new
    // tab, etc). The |user_gesture| value will be true (1) if the browser
    // navigated via explicit user gesture (e.g. clicking a link) or false (0) if
    // it navigated automatically (e.g. via the DomContentLoaded event). Return
    // true (1) to cancel the navigation or false (0) to allow the navigation to
    // proceed in the source browser's top-level frame.
    on_open_urlfrom_tab: function(self: PCefRequestHandler; browser: PCefBrowser; frame: PCefFrame;
      const target_url: PCefString; target_disposition: TCefWindowOpenDisposition; user_gesture: Integer): Integer; cconv;

    // Called on the IO thread before a resource request is loaded. The |request|
    // object may be modified. Return RV_CONTINUE to continue the request
    // immediately. Return RV_CONTINUE_ASYNC and call cef_request_tCallback::
    // cont() at a later time to continue or cancel the request asynchronously.
    // Return RV_CANCEL to cancel the request immediately.
    on_before_resource_load: function(self: PCefRequestHandler; browser: PCefBrowser;
      frame: PCefFrame; request: PCefRequest; callback: PCefRequestCallback): TCefReturnValue; cconv;

    // Called on the IO thread before a resource is loaded. To allow the resource
    // to load normally return NULL. To specify a handler for the resource return
    // a cef_resource_handler_t object. The |request| object should not be
    // modified in this callback.
    get_resource_handler: function(self:PCefRequestHandler; browser: PCefBrowser;frame: PCefFrame;
      request: PCefRequest): PCefResourceHandler; cconv;

    // Called on the IO thread when a resource load is redirected. The |request|
    // parameter will contain the old URL and other request-related information.
    // The |response| parameter will contain the response that resulted in the
    // redirect. The |new_url| parameter will contain the new URL and can be
    // changed if desired. The |request| object cannot be modified in this
    // callback.
    on_resource_redirect: procedure(self: PCefRequestHandler; browser: PCefBrowser;
      frame: PCefFrame; request: PCefRequest; response: PCefResponse; new_url: PCefString); cconv;

    // Called on the IO thread when a resource response is received. To allow the
    // resource to load normally return false (0). To redirect or retry the
    // resource modify |request| (url, headers or post body) and return true (1).
    // The |response| object cannot be modified in this callback.
    on_resource_response: function(self: PCefRequestHandler; browser: PCefBrowser; frame: PCefFrame;
      request: PCefRequest; response: PCefResponse): Integer; cconv;

    // Called on the IO thread to optionally filter resource response content.
    // |request| and |response| represent the request and response respectively
    // and cannot be modified in this callback.
    get_resource_response_filter: function(self: PCefRequestHandler; browser: PCefBrowser;
      frame: PCefFrame; request: PCefRequest; response: PCefResponse): PCefResponseFilter; cconv;

    // Called on the IO thread when a resource load has completed. |request| and
    // |response| represent the request and response respectively and cannot be
    // modified in this callback. |status| indicates the load completion status.
    // |received_content_length| is the number of response bytes actually read.
    on_resource_load_complete: procedure(self: PCefRequestHandler; browser: PCefBrowser;
      frame: PCefFrame; request: PCefRequest; response: PCefResponse; status: TCefUrlRequestStatus;
      received_content_length: cint64); cconv;

    // Called on the IO thread when the browser needs credentials from the user.
    // |isProxy| indicates whether the host is a proxy server. |host| contains the
    // hostname and |port| contains the port number. |realm| is the realm of the
    // challenge and may be NULL. |scheme| is the authentication scheme used, such
    // as "basic" or "digest", and will be NULL if the source of the request is an
    // FTP server. Return true (1) to continue the request and call
    // cef_auth_callback_t::cont() either in this function or at a later time when
    // the authentication information is available. Return false (0) to cancel the
    // request immediately.
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
      const origin_url: PCefString; new_size: Int64; callback: PCefRequestCallback): Integer; cconv;

    // Called on the UI thread to handle requests for URLs with an unknown
    // protocol component. Set |allow_os_execution| to true (1) to attempt
    // execution via the registered OS protocol handler, if any. SECURITY WARNING:
    // YOU SHOULD USE THIS METHOD TO ENFORCE RESTRICTIONS BASED ON SCHEME, HOST OR
    // OTHER URL ANALYSIS BEFORE ALLOWING OS EXECUTION.
    on_protocol_execution: procedure(self: PCefRequestHandler;
      browser: PCefBrowser; const url: PCefString; allow_os_execution: PInteger); cconv;

    // Called on the UI thread to handle requests for URLs with an invalid SSL
    // certificate. Return true (1) and call cef_request_tCallback::cont() either
    // in this function or at a later time to continue or cancel the request.
    // Return false (0) to cancel the request immediately. If
    // CefSettings.ignore_certificate_errors is set all invalid certificates will
    // be accepted without calling this function.
  	on_certificate_error: function(self: PCefRequestHandler; browser: PCefBrowser;
      cert_error: TCefErrorCode; const request_url: PCefString; ssl_info: PCefSslInfo;
      callback: PCefRequestCallback): Integer; cconv;

    // Called on the UI thread when a client certificate is being requested for
    // authentication. Return false (0) to use the default behavior and
    // automatically select the first certificate available. Return true (1) and
    // call cef_select_client_certificate_callback_t::Select either in this
    // function or at a later time to select a certificate. Do not call Select or
    // call it with NULL to continue without using any certificate. |isProxy|
    // indicates whether the host is an HTTPS proxy or the origin server. |host|
    // and |port| contains the hostname and port of the SSL server. |certificates|
    // is the list of certificates to choose from; this list has already been
    // pruned by Chromium so that it only contains certificates from issuers that
    // the server trusts.
    on_select_client_certificate: function(self: PCefRequestHandler; browser: PCefBrowser;
      isProxy: Integer; const host: PCefString; port: Integer; certificatesCount: csize_t;
      certificates: PCefX509CertificateArray; callback: PCefSelectClientCertificateCallback): Integer; cconv;

    // Called on the browser process UI thread when a plugin has crashed.
    // |plugin_path| is the path of the plugin that crashed.
    on_plugin_crashed: procedure(self: PCefRequestHandler; browser: PCefBrowser;
      const plugin_path: PCefString); cconv;

    // Called on the browser process UI thread when the render view associated
    // with |browser| is ready to receive/handle IPC messages in the render
    // process.
    on_render_view_ready: procedure(self: PCefRequestHandler; browser: PCefBrowser); cconv;

    // Called on the browser process UI thread when the render process terminates
    // unexpectedly. |status| indicates how the process terminated.
    on_render_process_terminated: procedure(self: PCefRequestHandler; browser: PCefBrowser;
      status: TCefTerminationStatus); cconv;
  end;


{ ***  cef_resource_bundle_capi.h  *** }
  // Structure used for retrieving resources from the resource bundle (*.pak)
  // files loaded by CEF during startup or via the cef_resource_bundle_tHandler
  // returned from cef_app_t::GetResourceBundleHandler. See CefSettings for
  // additional options related to resource bundle loading. The functions of this
  // structure may be called on any thread unless otherwise indicated.
  TCefResourceBundle = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns the localized string for the specified |string_id| or an NULL
    // string if the value is not found. Include cef_pack_strings.h for a listing
    // of valid string ID values.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_localized_string: function(self: PCefResourceBundle; string_id: Integer): PCefStringUserFree; cconv;

    // Retrieves the contents of the specified scale independent |resource_id|. If
    // the value is found then |data| and |data_size| will be populated and this
    // function will return true (1). If the value is not found then this function
    // will return false (0). The returned |data| pointer will remain resident in
    // memory and should not be freed. Include cef_pack_resources.h for a listing
    // of valid resource ID values.
    get_data_resource: function(self: PCefResourceBundle; resource_id: Integer; data: PPointer;
      data_size: pcsize_t): Integer; cconv;

    // Retrieves the contents of the specified |resource_id| nearest the scale
    // factor |scale_factor|. Use a |scale_factor| value of SCALE_FACTOR_NONE for
    // scale independent resources or call GetDataResource instead. If the value
    // is found then |data| and |data_size| will be populated and this function
    // will return true (1). If the value is not found then this function will
    // return false (0). The returned |data| pointer will remain resident in
    // memory and should not be freed. Include cef_pack_resources.h for a listing
    // of valid resource ID values.
    get_data_resource_for_scale: function(self: PCefResourceBundle; resource_id: Integer;
      scale_factor: TCefScaleFactor; data: PPointer; data_size: pcsize_t): Integer; cconv;
  end;


{ ***  cef_resource_bundle_handler_capi.h  *** }
  // Structure used to implement a custom resource bundle structure. See
  // CefSettings for additional options related to resource bundle loading. The
  // functions of this structure may be called on multiple threads.
  TCefResourceBundleHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called to retrieve a localized translation for the specified |string_id|.
    // To provide the translation set |string| to the translation string and
    // return true (1). To use the default translation return false (0). Include
    // cef_pack_strings.h for a listing of valid string ID values.
    get_localized_string: function(self: PCefResourceBundleHandler;
      string_id: Integer; string_: PCefString): Integer; cconv;

    // Called to retrieve data for the specified scale independent |resource_id|.
    // To provide the resource data set |data| and |data_size| to the data pointer
    // and size respectively and return true (1). To use the default resource data
    // return false (0). The resource data will not be copied and must remain
    // resident in memory. Include cef_pack_resources.h for a listing of valid
    // resource ID values.
    get_data_resource: function(self: PCefResourceBundleHandler;
      resource_id: Integer; var data: Pointer; var data_size: csize_t): Integer; cconv;

    // Called to retrieve data for the specified |resource_id| nearest the scale
    // factor |scale_factor|. To provide the resource data set |data| and
    // |data_size| to the data pointer and size respectively and return true (1).
    // To use the default resource data return false (0). The resource data will
    // not be copied and must remain resident in memory. Include
    // cef_pack_resources.h for a listing of valid resource ID values.
    get_data_resource_for_scale: function(self: PCefResourceBundleHandler; resource_id: Integer;
      scale_factor: TCefScaleFactor; data: PPointer; data_size: pcsize_t): Integer; cconv;
  end;


{ ***  cef_resource_handler_capi.h  *** }
  // Structure used to implement a custom request handler structure. The functions
  // of this structure will always be called on the IO thread.
  TCefResourceHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    // URL. If an error occured while setting up the request you can call
    // set_error() on |response| to indicate the error condition.
    get_response_headers: procedure(self: PCefResourceHandler;
      response: PCefResponse; response_length: PInt64; redirectUrl: PCefString); cconv;

    // Read response data. If data is available immediately copy up to
    // |bytes_to_read| bytes into |data_out|, set |bytes_read| to the number of
    // bytes copied, and return true (1). To read the data at a later time set
    // |bytes_read| to 0, return true (1) and call cef_callback_t::cont() when the
    // data is available. To indicate response completion return false (0).
    read_response: function(self: PCefResourceHandler; data_out: Pointer; bytes_to_read: Integer;
      bytes_read: PInteger; callback: PCefCallback): Integer; cconv;

    // Return true (1) if the specified cookie can be sent with the request or
    // false (0) otherwise. If false (0) is returned for any cookie then no
    // cookies will be sent with the request.
    can_get_cookie: function(self: PCefResourceHandler; const cookie: PCefCookie): Integer; cconv;

    // Return true (1) if the specified cookie returned with the response can be
    // set or false (0) otherwise.
    can_set_cookie: function(self: PCefResourceHandler; const cookie: PCefCookie): Integer; cconv;

    // Request processing has been canceled.
    cancel: procedure(self: PCefResourceHandler); cconv;
  end;


{ ***  cef_response_capi.h  *** }
  // Structure used to represent a web response. The functions of this structure
  // may be called on any thread.
  TCefResponse = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is read-only.
    is_read_only: function(self: PCefResponse): Integer; cconv;

    // Get the response error code. Returns ERR_NONE if there was no error.
    get_error: function(self: PCefResponse): TCefErrorCode; cconv;

    // Set the response error code. This can be used by custom scheme handlers to
    // return errors during initial request processing.
    set_error: procedure(self: PCefResponse; error: TCefErrorCode); cconv;

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


{ *** cef_response_filter_capi.h *** }
  // Implement this structure to filter resource response content. The functions
  // of this structure will be called on the browser process IO thread.
  TCefResponseFilter = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Initialize the response filter. Will only be called a single time. The
    // filter will not be installed if this function returns false (0).
    init_filter: function(self: PCefResponseFilter): Integer; cconv;

    // Called to filter a chunk of data. Expected usage is as follows:
    //
    //  A. Read input data from |data_in| and set |data_in_read| to the number of
    //     bytes that were read up to a maximum of |data_in_size|. |data_in| will
    //     be NULL if |data_in_size| is zero.
    //  B. Write filtered output data to |data_out| and set |data_out_written| to
    //     the number of bytes that were written up to a maximum of
    //     |data_out_size|. If no output data was written then all data must be
    //     read from |data_in| (user must set |data_in_read| = |data_in_size|).
    //  C. Return RESPONSE_FILTER_DONE if all output data was written or
    //     RESPONSE_FILTER_NEED_MORE_DATA if output data is still pending.
    //
    // This function will be called repeatedly until the input buffer has been
    // fully read (user sets |data_in_read| = |data_in_size|) and there is no more
    // input data to filter (the resource response is complete). This function may
    // then be called an additional time with an NULL input buffer if the user
    // filled the output buffer (set |data_out_written| = |data_out_size|) and
    // returned RESPONSE_FILTER_NEED_MORE_DATA to indicate that output data is
    // still pending.
    //
    // Calls to this function will stop when one of the following conditions is
    // met:
    //
    //  A. There is no more input data to filter (the resource response is
    //     complete) and the user sets |data_out_written| = 0 or returns
    //     RESPONSE_FILTER_DONE to indicate that all data has been written, or;
    //  B. The user returns RESPONSE_FILTER_ERROR to indicate an error.
    //
    // Do not keep a reference to the buffers passed to this function.
    filter: function(self: PCefResponseFilter;
      data_in: Pointer; data_in_size: csize_t; data_in_read: pcsize_t;
      data_out: Pointer; data_out_size: csize_t; data_out_written: pcsize_t): TCefResponseFilterStatus; cconv;
  end;


{ ***  cef_scheme_capi.h  *** }
  // Structure that manages custom scheme registrations.
  TCefSchemeRegistrar = record
    // Base structure.
    base: TCefBaseScoped;

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
    // If |is_local| is true (1) the scheme will be treated with the same security
    // rules as those applied to "file" URLs. Normal pages cannot link to or
    // access local URLs. Also, by default, local URLs can only perform
    // XMLHttpRequest calls to the same URL (origin + path) that originated the
    // request. To allow XMLHttpRequest calls from a local URL to other URLs with
    // the same origin set the CefSettings.file_access_from_file_urls_allowed
    // value to true (1). To allow XMLHttpRequest calls from a local URL to all
    // origins set the CefSettings.universal_access_from_file_urls_allowed value
    // to true (1).
    //
    // If |is_display_isolated| is true (1) the scheme can only be displayed from
    // other content hosted with the same scheme. For example, pages in other
    // origins cannot create iframes or hyperlinks to URLs with the scheme. For
    // schemes that must be accessible from other schemes set this value to false
    // (0), set |is_cors_enabled| to true (1), and use CORS "Access-Control-Allow-
    // Origin" headers to further restrict access.
    //
    // If |is_secure| is true (1) the scheme will be treated with the same
    // security rules as those applied to "https" URLs. For example, loading this
    // scheme from other secure schemes will not trigger mixed content warnings.
    //
    // If |is_cors_enabled| is true (1) the scheme can be sent CORS requests. This
    // value should be true (1) in most cases where |is_standard| is true (1).
    //
    // If |is_csp_bypassing| is true (1) the scheme can bypass Content-Security-
    // Policy (CSP) checks. This value should be false (0) in most cases where
    // |is_standard| is true (1).
    //
    // This function may be called on any thread. It should only be called once
    // per unique |scheme_name| value. If |scheme_name| is already registered or
    // if an error occurs this function will return false (0).
    add_custom_scheme: function(self: PCefSchemeRegistrar; const scheme_name: PCefString;
      is_standard, is_local, is_display_isolated, is_secure, is_cors_enabled,
      is_csp_bypassing: Integer): Integer; cconv;
  end;


  // Structure that creates cef_resource_handler_t instances for handling scheme
  // requests. The functions of this structure will always be called on the IO
  // thread.
  TCefSchemeHandlerFactory = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Return a new resource handler instance to handle the request or an NULL
    // reference to allow default handling of the request. |browser| and |frame|
    // will be the browser window and frame respectively that originated the
    // request or NULL if the request did not originate from a browser window (for
    // example, if the request came from cef_urlrequest_t). The |request| object
    // passed to this function will not contain cookie data.
    create: function(self: PCefSchemeHandlerFactory; browser: PCefBrowser; frame: PCefFrame;
      const scheme_name: PCefString; request: PCefRequest): PCefResourceHandler; cconv;
  end;


{ *** cef_ssl_info_capi.h  *** }
  // Structure representing SSL information.
  TCefSslinfo = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns a bitmask containing any and all problems verifying the server
    // certificate.
    get_cert_status: function(self: PCefSslinfo): TCefCertStatus; cconv;

    // Returns the X.509 certificate.
    get_x509certificate: function(self: PCefSslinfo): PCefX509certificate; cconv;
  end;


{ ***  cef_ssl_status_capi.h  *** }
  // Structure representing the SSL information for a navigation entry.
  TCefSslstatus = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if the status is related to a secure SSL/TLS connection.
    is_secure_connection: function(self: PCefSslStatus): Integer; cconv;

    // Returns a bitmask containing any and all problems verifying the server
    // certificate.
    get_cert_status: function(self: PCefSslStatus): TCefCertStatus; cconv;

    // Returns the SSL version used for the SSL connection.
    get_sslversion: function(self: PCefSslStatus): TCefSslVersion; cconv;

    // Returns a bitmask containing the page security content status.
    get_content_status: function(self: PCefSslStatus): TCefSslContentStatus; cconv;

    // Returns the X.509 certificate.
    get_x509certificate: function(self: PCefSslStatus): PCefX509certificate; cconv;
  end;


{ ***  cef_stream_capi.h  *** }
  // Structure the client can implement to provide a custom stream reader. The
  // functions of this structure may be called on any thread.
  TCefReadHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Read raw binary data.
    read: function(self: PCefReadHandler; ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Return zero on success and non-zero on failure.
    seek: function(self: PCefReadHandler; offset: Int64; whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefReadHandler): Int64; cconv;

    // Return non-zero if at end of file.
    eof: function(self: PCefReadHandler): Integer; cconv;

    // Return true (1) if this handler performs work like accessing the file
    // system which may block. Used as a hint for determining the thread to access
    // the handler from.
    may_block: function(self: PCefReadHandler): Integer; cconv;
  end;


  // Structure used to read data from a stream. The functions of this structure
  // may be called on any thread.
  TCefStreamReader = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Read raw binary data.
    read: function(self: PCefStreamReader; ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamReader; offset: Int64; whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefStreamReader): Int64; cconv;

    // Return non-zero if at end of file.
    eof: function(self: PCefStreamReader): Integer; cconv;

    // Returns true (1) if this reader performs work like accessing the file
    // system which may block. Used as a hint for determining the thread to access
    // the reader from.
    may_block: function(self: PCefStreamReader): Integer; cconv;
  end;


  // Structure the client can implement to provide a custom stream writer. The
  // functions of this structure may be called on any thread.
  TCefWriteHandler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Write raw binary data.
    write: function(self: PCefWriteHandler; const ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Return zero on success and non-zero on failure.
    seek: function(self: PCefWriteHandler; offset: Int64; whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefWriteHandler): Int64; cconv;

    // Flush the stream.
    flush: function(self: PCefWriteHandler): Integer; cconv;

    // Return true (1) if this handler performs work like accessing the file
    // system which may block. Used as a hint for determining the thread to access
    // the handler from.
    may_block: function(self: PCefWriteHandler): Integer; cconv;
  end;


  // Structure used to write data to a stream. The functions of this structure may
  // be called on any thread.
  TCefStreamWriter = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Write raw binary data.
    write: function(self: PCefStreamWriter; const ptr: Pointer; size, n: csize_t): csize_t; cconv;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamWriter; offset: Int64; whence: Integer): Integer; cconv;

    // Return the current offset position.
    tell: function(self: PCefStreamWriter): Int64; cconv;

    // Flush the stream.
    flush: function(self: PCefStreamWriter): Integer; cconv;

    // Returns true (1) if this writer performs work like accessing the file
    // system which may block. Used as a hint for determining the thread to access
    // the writer from.
    may_block: function(self: PCefStreamWriter): Integer; cconv;
  end;


{ ***  cef_string_visitor_capi.h  *** }
  // Implement this structure to receive string values asynchronously.
  TCefStringVisitor = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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


{ ***  cef_thread_capi.h  *** }
  // A simple thread abstraction that establishes a message loop on a new thread.
  // The consumer uses cef_task_tRunner to execute code on the thread's message
  // loop. The thread is terminated when the cef_thread_t object is destroyed or
  // stop() is called. All pending tasks queued on the thread's message loop will
  // run to completion before the thread is terminated. cef_thread_create() can be
  // called on any valid CEF thread in either the browser or render process. This
  // structure should only be used for tasks that require a dedicated thread. In
  // most cases you can post tasks to an existing CEF thread instead of creating a
  // new one; see cef_task.h for details.
  TCefThread = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns the cef_task_tRunner that will execute code on this thread's
    // message loop. This function is safe to call from any thread.
    get_task_runner: function(self: PCefThread): PCefTaskRunner; cconv;

    // Returns the platform thread ID. It will return the same value after stop()
    // is called. This function is safe to call from any thread.
    get_platform_thread_id: function(self: PCefThread): TCefPlatformThreadId; cconv;

    // Stop and join the thread. This function must be called from the same thread
    // that called cef_thread_create(). Do not call this function if
    // cef_thread_create() was called with a |stoppable| value of false (0).
    stop: procedure(self: PCefThread); cconv;

    // Returns true (1) if the thread is currently running. This function must be
    // called from the same thread that called cef_thread_create().
    is_running: function(self: PCefThread): Integer; cconv;
  end;


{ ***  cef_trace_capi.h  *** }
  // Implement this structure to receive notification when tracing has completed.
  // The functions of this structure will be called on the browser process UI
  // thread.
  TCefEndTracingCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Called after all processes have sent their trace data. |tracing_file| is
    // the path at which tracing data was written. The client is responsible for
    // deleting |tracing_file|.
    on_end_tracing_complete: procedure(self: PCefEndTracingCallback; const tracing_file: PCefString); cconv;
  end;


{ ***  cef_urlrequest_capi.h  *** }
  // Structure used to make a URL request. URL requests are not associated with a
  // browser instance so no cef_client_t callbacks will be executed. URL requests
  // can be created on any valid CEF thread in either the browser or render
  // process. Once created the functions of the URL request object must be
  // accessed on the same thread that created it.
  TCefUrlRequest = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns the request object used to create this URL request. The returned
    // object is read-only and should not be modified.
    get_request: function(self: PCefUrlRequest): PCefRequest; cconv;

    // Returns the client.
    get_client: function(self: PCefUrlRequest): PCefUrlRequestClient; cconv;

    // Returns the request status.
    get_request_status: function(self: PCefUrlRequest): TCefUrlRequestStatus; cconv;

    // Returns the request error if status is UR_CANCELED or UR_FAILED, or 0
    // otherwise.
    get_request_error: function(self: PCefUrlRequest): TCefErrorCode; cconv;

    // Returns the response, or NULL if no response information is available.
    // Response information will only be available after the upload has completed.
    // The returned object is read-only and should not be modified.
    get_response: function(self: PCefUrlRequest): PCefResponse; cconv;

    // Cancel the request.
    cancel: procedure(self: PCefUrlRequest); cconv;
  end;


  // Structure that should be implemented by the cef_urlrequest_t client. The
  // functions of this structure will be called on the same thread that created
  // the request unless otherwise documented.
  TCefUrlRequestClient = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Notifies the client that the request has completed. Use the
    // cef_urlrequest_t::GetRequestStatus function to determine if the request was
    // successful or not.
    on_request_complete: procedure(self: PCefUrlRequestClient; request: PCefUrlRequest); cconv;

    // Notifies the client of upload progress. |current| denotes the number of
    // bytes sent so far and |total| is the total size of uploading data (or -1 if
    // chunked upload is enabled). This function will only be called if the
    // UR_FLAG_REPORT_UPLOAD_PROGRESS flag is set on the request.
    on_upload_progress: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; current, total: Int64); cconv;

    // Notifies the client of download progress. |current| denotes the number of
    // bytes received up to the call and |total| is the expected total size of the
    // response (or -1 if not determined).
    on_download_progress: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; current, total: Int64); cconv;

    // Called when some part of the response is read. |data| contains the current
    // bytes received since the last call. This function will not be called if the
    // UR_FLAG_NO_DOWNLOAD_DATA flag is set on the request.
    on_download_data: procedure(self: PCefUrlRequestClient;
      request: PCefUrlRequest; const data: Pointer; data_length: csize_t); cconv;

    // Called on the IO thread when the browser needs credentials from the user.
    // |isProxy| indicates whether the host is a proxy server. |host| contains the
    // hostname and |port| contains the port number. Return true (1) to continue
    // the request and call cef_auth_callback_t::cont() when the authentication
    // information is available. Return false (0) to cancel the request. This
    // function will only be called for requests initiated from the browser
    // process.
    get_auth_credentials: function(self: PCefUrlRequestClient; isProxy: Integer;
      const host: PCefString; port: Integer; const realm, scheme: PCefString;
      callback: PCefAuthCallback): Integer; cconv;
  end;


{ ***  cef_v8_capi.h  *** }
  // Structure representing a V8 context handle. V8 handles can only be accessed
  // from the thread on which they are created. Valid threads for creating a V8
  // handle include the render process main thread (TID_RENDERER) and WebWorker
  // threads. A task runner for posting tasks on the associated thread can be
  // retrieved via the cef_v8context_t::get_task_runner() function.
  TCefV8Context = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns the task runner associated with this context. V8 handles can only
    // be accessed from the thread on which they are created. This function can be
    // called on any render process thread.
    get_task_runner: function(self: PCefV8Context): PCefTaskRunner; cconv;

    // Returns true (1) if the underlying handle is valid and it can be accessed
    // on the current thread. Do not call any other functions if this function
    // returns false (0).
    is_valid: function(self: PCefV8Context): Integer; cconv;

    // Returns the browser for this context. This function will return an NULL
    // reference for WebWorker contexts.
    get_browser: function(self: PCefV8Context): PCefBrowser; cconv;

    // Returns the frame for this context. This function will return an NULL
    // reference for WebWorker contexts.
    get_frame: function(self: PCefV8Context): PCefFrame; cconv;

    // Returns the global object for this context. The context must be entered
    // before calling this function.
    get_global: function(self: PCefV8Context): PCefv8Value; cconv;

    // Enter this context. A context must be explicitly entered before creating a
    // V8 Object, Array, Function or Date asynchronously. exit() must be called
    // the same number of times as enter() before releasing this context. V8
    // objects belong to the context in which they are created. Returns true (1)
    // if the scope was entered successfully.
    enter: function(self: PCefV8Context): Integer; cconv;

    // Exit this context. Call this function only after calling enter(). Returns
    // true (1) if the scope was exited successfully.
    exit: function(self: PCefV8Context): Integer; cconv;

    // Returns true (1) if this object is pointing to the same handle as |that|
    // object.
    is_same: function(self, that: PCefV8Context): Integer; cconv;

    // Execute a string of JavaScript code in this V8 context. The |script_url|
    // parameter is the URL where the script in question can be found, if any. The
    // |start_line| parameter is the base line number to use for error reporting.
    // On success |retval| will be set to the return value, if any, and the
    // function will return true (1). On failure |exception| will be set to the
    // exception, if any, and the function will return false (0).
    eval: function(self: PCefV8Context; const code, script_url: PCefString;
      start_line: Integer; var retval: PCefV8Value; var exception: PCefV8Exception): Integer; cconv;
  end;


  // Structure that should be implemented to handle V8 function calls. The
  // functions of this structure will be called on the thread associated with the
  // V8 function.
  TCefV8Handler = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Handle execution of the function identified by |name|. |object| is the
    // receiver ('this' object) of the function. |arguments| is the list of
    // arguments passed to the function. If execution succeeds set |retval| to the
    // function return value. If execution fails set |exception| to the exception
    // that will be thrown. Return true (1) if execution was handled.
    execute: function(self: PCefv8Handler; const name: PCefString; object_: PCefv8Value;
      argumentsCount: csize_t; arguments: PCefV8ValueArray; out retval: PCefV8Value;
      exception: PCefString): Integer; cconv;
  end;


  // Structure that should be implemented to handle V8 accessor calls. Accessor
  // identifiers are registered by calling cef_v8value_t::set_value(). The
  // functions of this structure will be called on the thread associated with the
  // V8 accessor.
  TCefV8Accessor = record
    // Base structure.
    base: TCefBaseRefCounted;

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


  // Structure that should be implemented to handle V8 interceptor calls. The
  // functions of this structure will be called on the thread associated with the
  // V8 interceptor. Interceptor's named property handlers (with first argument of
  // type CefString) are called when object is indexed by string. Indexed property
  // handlers (with first argument of type int) are called when object is indexed
  // by integer.
  TCefV8Interceptor = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Handle retrieval of the interceptor value identified by |name|. |object| is
    // the receiver ('this' object) of the interceptor. If retrieval succeeds, set
    // |retval| to the return value. If the requested value does not exist, don't
    // set either |retval| or |exception|. If retrieval fails, set |exception| to
    // the exception that will be thrown. If the property has an associated
    // accessor, it will be called only if you don't set |retval|. Return true (1)
    // if interceptor retrieval was handled, false (0) otherwise.
    get_byname: function(self: PCefV8Interceptor; const name: PCefString; object_: PCefV8Value;
      out retval: PCefV8Value; exception: PCefString): Integer; cconv;

    // Handle retrieval of the interceptor value identified by |index|. |object|
    // is the receiver ('this' object) of the interceptor. If retrieval succeeds,
    // set |retval| to the return value. If the requested value does not exist,
    // don't set either |retval| or |exception|. If retrieval fails, set
    // |exception| to the exception that will be thrown. Return true (1) if
    // interceptor retrieval was handled, false (0) otherwise.
    get_byindex: function(self: PCefV8Interceptor; index: Integer; object_: PCefV8Value;
      out retval: PCefV8Value; exception: PCefString): Integer; cconv;

    // Handle assignment of the interceptor value identified by |name|. |object|
    // is the receiver ('this' object) of the interceptor. |value| is the new
    // value being assigned to the interceptor. If assignment fails, set
    // |exception| to the exception that will be thrown. This setter will always
    // be called, even when the property has an associated accessor. Return true
    // (1) if interceptor assignment was handled, false (0) otherwise.
    set_byname: function(self: PCefV8Interceptor; const name: PCefString; object_: PCefV8Value;
      value: PCefV8Value; exception: PCefString): Integer; cconv;

    // Handle assignment of the interceptor value identified by |index|. |object|
    // is the receiver ('this' object) of the interceptor. |value| is the new
    // value being assigned to the interceptor. If assignment fails, set
    // |exception| to the exception that will be thrown. Return true (1) if
    // interceptor assignment was handled, false (0) otherwise.
    set_byindex: function(self: PCefV8Interceptor; index: Integer; object_: PCefV8Value;
      value: PCefV8Value; exception: PCefString): Integer; cconv;
  end;


  // Structure representing a V8 exception. The functions of this structure may be
  // called on any render process thread.
  TCefV8Exception = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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

    // Return a bool value.
    get_bool_value: function(self: PCefv8Value): Integer; cconv;

    // Return an int value.
    get_int_value: function(self: PCefv8Value): Integer; cconv;

    // Return an unsigned int value.
    get_uint_value: function(self: PCefv8Value): UInt32; cconv;

    // Return a double value.
    get_double_value: function(self: PCefv8Value): Double; cconv;

    // Return a Date value.
    get_date_value: function(self: PCefv8Value): TCefTime; cconv;

    // Return a string value.
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
      value: PCefv8Value; attribute: TCefV8PropertyAttributes): Integer; cconv;

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
    set_value_byaccessor: function(self: PCefv8Value; const key: PCefString;
      settings: TCefV8AccessControls; attribute: TCefV8PropertyAttributes): Integer; cconv;

    // Read the keys for the object's values into the specified vector. Integer-
    // based keys will also be returned as strings.
    get_keys: function(self: PCefv8Value; keys: TCefStringList): Integer; cconv;

    // Sets the user data for this object and returns true (1) on success. Returns
    // false (0) if this function is called incorrectly. This function can only be
    // called on user created objects.
    set_user_data: function(self: PCefv8Value; user_data: PCefBaseRefCounted): Integer; cconv;

    // Returns the user data, if any, assigned to this object.
    get_user_data: function(self: PCefv8Value): PCefBaseRefCounted; cconv;

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
      argumentsCount: csize_t; const arguments: PCefV8ValueArray): PCefv8Value; cconv;

    // Execute the function using the specified V8 context. |object| is the
    // receiver ('this' object) of the function. If |object| is NULL the specified
    // context's global object will be used. |arguments| is the list of arguments
    // that will be passed to the function. Returns the function return value on
    // success. Returns NULL if this function is called incorrectly or an
    // exception is thrown.
    execute_function_with_context: function(self: PCefv8Value; context: PCefv8Context;
      object_: PCefv8Value; argumentsCount: csize_t; const arguments: PCefV8ValueArray): PCefv8Value; cconv;
  end;


  // Structure representing a V8 stack trace handle. V8 handles can only be
  // accessed from the thread on which they are created. Valid threads for
  // creating a V8 handle include the render process main thread (TID_RENDERER)
  // and WebWorker threads. A task runner for posting tasks on the associated
  // thread can be retrieved via the cef_v8context_t::get_task_runner() function.
  TCefV8StackTrace = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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
  // Structure that wraps other data value types. Complex types (binary,
  // dictionary and list) will be referenced but not owned by this object. Can be
  // used on any process and thread.
  TCefValue = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if the underlying data is valid. This will always be true
    // (1) for simple types. For complex types (binary, dictionary and list) the
    // underlying data may become invalid if owned by another object (e.g. list or
    // dictionary) and that other object is then modified or destroyed. This value
    // object can be re-used by calling Set*() even if the underlying data is
    // invalid.
    is_valid: function(self: PCefValue): Integer; cconv;

    // Returns true (1) if the underlying data is owned by another object.
    is_owned: function(self: PCefValue): Integer; cconv;

    // Returns true (1) if the underlying data is read-only. Some APIs may expose
    // read-only objects.
    is_read_only: function(self: PCefValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have the same underlying
    // data. If true (1) modifications to this object will also affect |that|
    // object and vice-versa.
    is_same: function(self, that: PCefValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have an equivalent
    // underlying value but are not necessarily the same object.
    is_equal: function(seld, that: PCefValue): Integer; cconv;

    // Returns a copy of this object. The underlying data will also be copied.
    copy: function(self: PCefValue): PCefValue; cconv;

    // Returns the underlying value type.
    get_type: function(self: PCefValue): TCefValueType; cconv;

    // Returns the underlying value as type bool.
    get_bool: function(self: PCefValue): Integer; cconv;

    // Returns the underlying value as type int.
    get_int: function(self: PCefValue): Integer; cconv;

    // Returns the underlying value as type double.
    get_double: function(self: PCefValue): Double; cconv;

    // Returns the underlying value as type string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string: function(self: PCefValue): PCefStringUserFree; cconv;

    // Returns the underlying value as type binary. The returned reference may
    // become invalid if the value is owned by another object or if ownership is
    // transferred to another object in the future. To maintain a reference to the
    // value after assigning ownership to a dictionary or list pass this object to
    // the set_value() function instead of passing the returned reference to
    // set_binary().
    get_binary: function(self: PCefValue): PCefBinaryValue; cconv;

    // Returns the underlying value as type dictionary. The returned reference may
    // become invalid if the value is owned by another object or if ownership is
    // transferred to another object in the future. To maintain a reference to the
    // value after assigning ownership to a dictionary or list pass this object to
    // the set_value() function instead of passing the returned reference to
    // set_dictionary().
    get_dictionary: function(self: PCefValue): PCefDictionaryValue; cconv;

    // Returns the underlying value as type list. The returned reference may
    // become invalid if the value is owned by another object or if ownership is
    // transferred to another object in the future. To maintain a reference to the
    // value after assigning ownership to a dictionary or list pass this object to
    // the set_value() function instead of passing the returned reference to
    // set_list().
    get_list: function(self: PCefValue): PCefListValue; cconv;

    // Sets the underlying value as type null. Returns true (1) if the value was
    // set successfully.
    set_null: function(self: PCefValue): Integer; cconv;

    // Sets the underlying value as type bool. Returns true (1) if the value was
    // set successfully.
    set_bool: function(self: PCefValue; value: Integer): Integer; cconv;

    // Sets the underlying value as type int. Returns true (1) if the value was
    // set successfully.
    set_int: function(self: PCefValue; value: Integer): Integer; cconv;

    // Sets the underlying value as type double. Returns true (1) if the value was
    // set successfully.
    set_double: function(self: PCefValue; value: Double): Integer; cconv;

    // Sets the underlying value as type string. Returns true (1) if the value was
    // set successfully.
    set_string: function(self: PCefValue; value: PCefString): Integer; cconv;

    // Sets the underlying value as type binary. Returns true (1) if the value was
    // set successfully. This object keeps a reference to |value| and ownership of
    // the underlying data remains unchanged.
    set_binary: function(self: PCefValue; value: PCefBinaryValue): Integer; cconv;

    // Sets the underlying value as type dict. Returns true (1) if the value was
    // set successfully. This object keeps a reference to |value| and ownership of
    // the underlying data remains unchanged.
    set_dictionary: function(self: PCefValue; value: PCefDictionaryValue): Integer; cconv;

    // Sets the underlying value as type list. Returns true (1) if the value was
    // set successfully. This object keeps a reference to |value| and ownership of
    // the underlying data remains unchanged.
    set_list: function(self: PCefValue; value: PCefListValue): Integer; cconv;
  end;


  // Structure representing a binary value. Can be used on any process and thread.
  TCefBinaryValue = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is valid. This object may become invalid if
    // the underlying data is owned by another object (e.g. list or dictionary)
    // and that other object is then modified or destroyed. Do not call any other
    // functions if this function returns false (0).
    is_valid: function(self: PCefBinaryValue): Integer; cconv;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefBinaryValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have the same underlying
    // data.
    is_same: function(self, that: PCefBinaryValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have an equivalent
    // underlying value but are not necessarily the same object.
    is_equal: function(self, that: PCefBinaryValue): Integer; cconv;

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
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is valid. This object may become invalid if
    // the underlying data is owned by another object (e.g. list or dictionary)
    // and that other object is then modified or destroyed. Do not call any other
    // functions if this function returns false (0).
    is_valid: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have the same underlying
    // data. If true (1) modifications to this object will also affect |that|
    // object and vice-versa.
    is_same: function(self, that: PCefDictionaryValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have an equivalent
    // underlying value but are not necessarily the same object.
    is_equal: function(self, that: PCefDictionaryValue): Integer; cconv;

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

    // Returns the value at the specified key. For simple types the returned value
    // will copy existing data and modifications to the value will not modify this
    // object. For complex types (binary, dictionary and list) the returned value
    // will reference existing data and modifications to the value will modify
    // this object.
    get_value: function(self: PCefDictionaryValue; const key: PCefString): PCefValue; cconv;

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

    // Returns the value at the specified key as type binary. The returned value
    // will reference existing data.
    get_binary: function(self: PCefDictionaryValue; const key: PCefString): PCefBinaryValue; cconv;

    // Returns the value at the specified key as type dictionary. The returned
    // value will reference existing data and modifications to the value will
    // modify this object.
    get_dictionary: function(self: PCefDictionaryValue; const key: PCefString): PCefDictionaryValue; cconv;

    // Returns the value at the specified key as type list. The returned value
    // will reference existing data and modifications to the value will modify
    // this object.
    get_list: function(self: PCefDictionaryValue; const key: PCefString): PCefListValue; cconv;

    // Sets the value at the specified key. Returns true (1) if the value was set
    // successfully. If |value| represents simple data then the underlying data
    // will be copied and modifications to |value| will not modify this object. If
    // |value| represents complex data (binary, dictionary or list) then the
    // underlying data will be referenced and modifications to |value| will modify
    // this object.
    set_value: function(self: PCefDictionaryValue; const key: PCefString; value: PCefValue): Integer; cconv;

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
    // value was set successfully. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_dictionary: function(self: PCefDictionaryValue; const key: PCefString; value: PCefDictionaryValue): Integer; cconv;

    // Sets the value at the specified key as type list. Returns true (1) if the
    // value was set successfully. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_list: function(self: PCefDictionaryValue; const key: PCefString; value: PCefListValue): Integer; cconv;
  end;


  // Structure representing a list value. Can be used on any process and thread.
  TCefListValue = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns true (1) if this object is valid. This object may become invalid if
    // the underlying data is owned by another object (e.g. list or dictionary)
    // and that other object is then modified or destroyed. Do not call any other
    // functions if this function returns false (0).
    is_valid: function(self: PCefListValue): Integer; cconv;

    // Returns true (1) if this object is currently owned by another object.
    is_owned: function(self: PCefListValue): Integer; cconv;

    // Returns true (1) if the values of this object are read-only. Some APIs may
    // expose read-only objects.
    is_read_only: function(self: PCefListValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have the same underlying
    // data. If true (1) modifications to this object will also affect |that|
    // object and vice-versa.
    is_same: function(self, that: PCefListValue): Integer; cconv;

    // Returns true (1) if this object and |that| object have an equivalent
    // underlying value but are not necessarily the same object.
    is_equal: function(self, that: PCefListValue): Integer; cconv;

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
    remove: function(self: PCefListValue; index: csize_t): Integer; cconv;

    // Returns the value type at the specified index.
    get_type: function(self: PCefListValue; index: csize_t): TCefValueType; cconv;

    // Returns the value at the specified index. For simple types the returned
    // value will copy existing data and modifications to the value will not
    // modify this object. For complex types (binary, dictionary and list) the
    // returned value will reference existing data and modifications to the value
    // will modify this object.
    get_value: function(self: PCefListValue; index: csize_t): PCefValue; cconv;

    // Returns the value at the specified index as type bool.
    get_bool: function(self: PCefListValue; index: csize_t): Integer; cconv;

    // Returns the value at the specified index as type int.
    get_int: function(self: PCefListValue; index: csize_t): Integer; cconv;

    // Returns the value at the specified index as type double.
    get_double: function(self: PCefListValue; index: csize_t): Double; cconv;

    // Returns the value at the specified index as type string.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string: function(self: PCefListValue; index: csize_t): PCefStringUserFree; cconv;

    // Returns the value at the specified index as type binary. The returned value
    // will reference existing data.
    get_binary: function(self: PCefListValue; index: csize_t): PCefBinaryValue; cconv;

    // Returns the value at the specified index as type dictionary. The returned
    // value will reference existing data and modifications to the value will
    // modify this object.
    get_dictionary: function(self: PCefListValue; index: csize_t): PCefDictionaryValue; cconv;

    // Returns the value at the specified index as type list. The returned value
    // will reference existing data and modifications to the value will modify
    // this object.
    get_list: function(self: PCefListValue; index: csize_t): PCefListValue; cconv;

    // Sets the value at the specified index. Returns true (1) if the value was
    // set successfully. If |value| represents simple data then the underlying
    // data will be copied and modifications to |value| will not modify this
    // object. If |value| represents complex data (binary, dictionary or list)
    // then the underlying data will be referenced and modifications to |value|
    // will modify this object.
    set_value: function(self: PCefListValue; index: csize_t; value: PCefValue): Integer; cconv;

    // Sets the value at the specified index as type null. Returns true (1) if the
    // value was set successfully.
    set_null: function(self: PCefListValue; index: csize_t): Integer; cconv;

    // Sets the value at the specified index as type bool. Returns true (1) if the
    // value was set successfully.
    set_bool: function(self: PCefListValue; index, csize_t: Integer): Integer; cconv;

    // Sets the value at the specified index as type int. Returns true (1) if the
    // value was set successfully.
    set_int: function(self: PCefListValue; index, csize_t: Integer): Integer; cconv;

    // Sets the value at the specified index as type double. Returns true (1) if
    // the value was set successfully.
    set_double: function(self: PCefListValue; index: csize_t; value: Double): Integer; cconv;

    // Sets the value at the specified index as type string. Returns true (1) if
    // the value was set successfully.
    set_string: function(self: PCefListValue; index: csize_t; value: PCefString): Integer; cconv;

    // Sets the value at the specified index as type binary. Returns true (1) if
    // the value was set successfully. If |value| is currently owned by another
    // object then the value will be copied and the |value| reference will not
    // change. Otherwise, ownership will be transferred to this object and the
    // |value| reference will be invalidated.
    set_binary: function(self: PCefListValue; index: csize_t; value: PCefBinaryValue): Integer; cconv;

    // Sets the value at the specified index as type dict. Returns true (1) if the
    // value was set successfully. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_dictionary: function(self: PCefListValue; index: csize_t; value: PCefDictionaryValue): Integer; cconv;

    // Sets the value at the specified index as type list. Returns true (1) if the
    // value was set successfully. If |value| is currently owned by another object
    // then the value will be copied and the |value| reference will not change.
    // Otherwise, ownership will be transferred to this object and the |value|
    // reference will be invalidated.
    set_list: function(self: PCefListValue; index: csize_t; value: PCefListValue): Integer; cconv;
  end;


{ ***  cef_waitable_event_capi.h  *** }
  // WaitableEvent is a thread synchronization tool that allows one thread to wait
  // for another thread to finish some work. This is equivalent to using a
  // Lock+ConditionVariable to protect a simple boolean value. However, using
  // WaitableEvent in conjunction with a Lock to wait for a more complex state
  // change (e.g., for an item to be added to a queue) is not recommended. In that
  // case consider using a ConditionVariable instead of a WaitableEvent. It is
  // safe to create and/or signal a WaitableEvent from any thread. Blocking on a
  // WaitableEvent by calling the *wait() functions is not allowed on the browser
  // process UI or IO threads.
  TCefWaitableEvent = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Put the event in the un-signaled state.
    reset: procedure(self: PCefWaitableEvent); cconv;

    // Put the event in the signaled state. This causes any thread blocked on Wait
    // to be woken up.
    signal: procedure(self: PCefWaitableEvent); cconv;

    // Returns true (1) if the event is in the signaled state, else false (0). If
    // the event was created with |automatic_reset| set to true (1) then calling
    // this function will also cause a reset.
    is_signaled: function(self: PCefWaitableEvent): Integer; cconv;

    // Wait indefinitely for the event to be signaled. This function will not
    // return until after the call to signal() has completed. This function cannot
    // be called on the browser process UI or IO threads.
    wait: procedure(self: PCefWaitableEvent); cconv;

    // Wait up to |max_ms| milliseconds for the event to be signaled. Returns true
    // (1) if the event was signaled. A return value of false (0) does not
    // necessarily mean that |max_ms| was exceeded. This function will not return
    // until after the call to signal() has completed. This function cannot be
    // called on the browser process UI or IO threads.
    timed_wait: function(self: PCefWaitableEvent; max_ms: cint64): Integer; cconv;
  end;


{ ***  cef_web_plugin_capi.h  *** }
  // Information about a specific web plugin.
  TCefWebPluginInfo = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

    // Method that will be called for the requested plugin. |unstable| will be
    // true (1) if the plugin has reached the crash count threshold of 3 times in
    // 120 seconds.
    is_unstable: procedure(self: PCefWebPluginUnstableCallback;
      const path: PCefString; unstable: Integer); cconv;
  end;


  // Implement this structure to receive notification when CDM registration is
  // complete. The functions of this structure will be called on the browser
  // process UI thread.
  TCefRegisterCdmCallback = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Method that will be called when CDM registration is complete. |result| will
    // be CEF_CDM_REGISTRATION_ERROR_NONE if registration completed successfully.
    // Otherwise, |result| and |error_message| will contain additional information
    // about why registration failed.
    on_cdm_registration_complete: procedure(self: PCefRegisterCdmCallback;
      result: TCefCdmRegistrationError; const error_message: PCefString); cconv;
  end;


{ ***  cef_x509_certificate_capi.h  *** }
  // Structure representing the issuer or subject field of an X.509 certificate.
  TCefX509certPrincipal = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns a name that can be used to represent the issuer. It tries in this
    // order: Common Name (CN), Organization Name (O) and Organizational Unit Name
    // (OU) and returns the first non-NULL one found.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_display_name: function(self: PCefX509certPrincipal): PCefStringUserFree; cconv;

    // Returns the common name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_common_name: function(self: PCefX509certPrincipal): PCefStringUserFree; cconv;

    // Returns the locality name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_locality_name: function(self: PCefX509certPrincipal): PCefStringUserFree; cconv;

    // Returns the state or province name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_state_or_province_name: function(self: PCefX509certPrincipal): PCefStringUserFree; cconv;

    // Returns the country name.
    //
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_country_name: function(self: PCefX509certPrincipal): PCefStringUserFree; cconv;

    // Retrieve the list of street addresses.
    get_street_addresses: procedure(self: PCefX509certPrincipal; addresses: TCefStringList); cconv;

    // Retrieve the list of organization names.
    get_organization_names: procedure(self: PCefX509certPrincipal; names: TCefStringList); cconv;

    // Retrieve the list of organization unit names.
    get_organization_unit_names: procedure(self: PCefX509certPrincipal; names: TCefStringList) cconv;

    // Retrieve the list of domain components.
    get_domain_components: procedure(self: PCefX509certPrincipal; components: TCefStringList); cconv;
  end;


  // Structure representing a X.509 certificate.
  TCefX509Certificate = record
    // Base structure.
    base: TCefBaseRefCounted;

    // Returns the subject of the X.509 certificate. For HTTPS server certificates
    // this represents the web server.  The common name of the subject should
    // match the host name of the web server.
    get_subject: function(self: PCefX509certificate): PCefX509certPrincipal; cconv;

    // Returns the issuer of the X.509 certificate.
    get_issuer: function(self: PCefX509Certificate): PCefX509certPrincipal; cconv;

    // Returns the DER encoded serial number for the X.509 certificate. The value
    // possibly includes a leading 00 byte.
    get_serial_number: function(self: PCefX509Certificate): PCefBinaryValue; cconv;

    // Returns the date before which the X.509 certificate is invalid.
    // CefTime.GetTimeT() will return 0 if no date was specified.
    get_valid_start: function(self: PCefX509Certificate): TCefTime; cconv;

    // Returns the date after which the X.509 certificate is invalid.
    // CefTime.GetTimeT() will return 0 if no date was specified.
    get_valid_expiry: function(self: PCefX509Certificate): TCefTime; cconv;

    // Returns the DER encoded data for the X.509 certificate.
    get_derencoded: function(self: PCefX509Certificate): PCefBinaryValue; cconv;

    // Returns the PEM encoded data for the X.509 certificate.
    get_pemencoded: function(self: PCefX509Certificate): PCefBinaryValue; cconv;

    // Returns the number of certificates in the issuer chain. If 0, the
    // certificate is self-signed.
    get_issuer_chain_size: function(self: PCefX509Certificate): Integer; cconv;

    // Returns the DER encoded data for the certificate issuer chain. If we failed
    // to encode a certificate in the chain it is still present in the array but
    // is an NULL string.
    get_derencoded_issuer_chain: procedure(self: PCefX509Certificate; chainCount: pcsize_t;
      chain: PCefBinaryValueArray); cconv;

    // Returns the PEM encoded data for the certificate issuer chain. If we failed
    // to encode a certificate in the chain it is still present in the array but
    // is an NULL string.
    get_pemencoded_issuer_chain: procedure(self: PCefX509Certificate; chainCount: pcsize_t;
      chain: PCefBinaryValueArray); cconv;
  end;


{ ***  cef_xml_reader_capi.h  *** }
  // Structure that supports the reading of XML data via the libxml streaming API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefXmlReader = record
    // Base structure.
    base: TCefBaseRefCounted;

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
    base: TCefBaseRefCounted;

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
    get_file_last_modified: function(Self: PCefZipReader): TCefTime; cconv;

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
  // the process exit code. The |application| parameter may be NULL. The
  // |windows_sandbox_info| parameter is only used on Windows and may be NULL (see
  // cef_sandbox_win.h for details).
  cef_execute_process: function(const args: PCefMainArgs; application: PCefApp; windows_sandbox_info: Pointer): Integer; cdecl;

  // This function should be called on the main application thread to initialize
  // the CEF browser process. The |application| parameter may be NULL. A return
  // value of true (1) indicates that it succeeded and false (0) indicates that it
  // failed. The |windows_sandbox_info| parameter is only used on Windows and may
  // be NULL (see cef_sandbox_win.h for details).
  cef_initialize: function(const args: PCefMainArgs; const settings: PCefSettings; application: PCefApp;
      windows_sandbox_info: Pointer): Integer; cdecl;

  // This function should be called on the main application thread to shut down
  // the CEF browser process before the application exits.
  cef_shutdown: procedure(); cdecl;

  // Perform a single iteration of CEF message loop processing. This function is
  // provided for cases where the CEF message loop must be integrated into an
  // existing application message loop. Use of this function is not recommended
  // for most users; use either the cef_run_message_loop() function or
  // CefSettings.multi_threaded_message_loop if possible. When using this function
  // care must be taken to balance performance against excessive CPU usage. It is
  // recommended to enable the CefSettings.external_message_pump option when using
  // this function so that
  // cef_browser_process_handler_t::on_schedule_message_pump_work() callbacks can
  // facilitate the scheduling process. This function should only be called on the
  // main application thread and only if cef_initialize() is called with a
  // CefSettings.multi_threaded_message_loop value of false (0). This function
  // will not block.
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
  cef_set_osmodal_loop: procedure(osModalLoop: Integer); cdecl;

  // Call during process startup to enable High-DPI support on Windows 7 or newer.
  // Older versions of Windows should be left DPI-unaware because they do not
  // support DirectWrite and GDI fonts are kerned very badly.
  cef_enable_highdpi_support: procedure; cdecl;


{ ***  cef_browser_capi.h  *** }
  // Create a new browser window using the window parameters specified by
  // |windowInfo|. All values will be copied internally and the actual window will
  // be created on the UI thread. If |request_context| is NULL the global request
  // context will be used. This function can be called on any browser process
  // thread and will not block.
  cef_browser_host_create_browser: function(
      const windowInfo: PCefWindowInfo; client: PCefClient;
      const url: PCefString; const settings: PCefBrowserSettings;
      requestContext: PCefRequestContext): Integer; cdecl;

  // Create a new browser window using the window parameters specified by
  // |windowInfo|. If |request_context| is NULL the global request context will be
  // used. This function can only be called on the browser process UI thread.
  cef_browser_host_create_browser_sync: function(
      const windowInfo: PCefWindowInfo; client: PCefClient;
      const url: PCefString; const settings: PCefBrowserSettings;
      requestContext: PCefRequestContext): PCefBrowser; cdecl;


{ ***  cef_command_line_capi.h  *** }
  // Create a new cef_command_line_t instance.
  cef_command_line_create: function: PCefCommandLine; cdecl;

  // Returns the singleton global cef_command_line_t object. The returned object
  // will be read-only.
  cef_command_line_get_global: function: PCefCommandLine; cdecl;


{ ***  cef_drag_data_capi.h *** }
  // Create a new cef_drag_data_t object.
  cef_drag_data_create: function: PCefDragData; cdecl;


{ ***  cef_cookie_capi.h  *** }
  // Returns the global cookie manager. By default data will be stored at
  // CefSettings.cache_path if specified or in memory otherwise. If |callback| is
  // non-NULL it will be executed asnychronously on the IO thread after the
  // manager's storage has been initialized. Using this function is equivalent to
  // calling cef_request_tContext::cef_request_context_get_global_context()->get_d
  // efault_cookie_manager().
  cef_cookie_manager_get_global_manager: function(callback: PCefCompletionCallback): PCefCookieManager; cdecl;

  // Creates a new cookie manager. If |path| is NULL data will be stored in memory
  // only. Otherwise, data will be stored at the specified |path|. To persist
  // session cookies (cookies without an expiry date or validity interval) set
  // |persist_session_cookies| to true (1). Session cookies are generally intended
  // to be transient and most Web browsers do not persist them. If |callback| is
  // non-NULL it will be executed asnychronously on the IO thread after the
  // manager's storage has been initialized.
  cef_cookie_manager_create_manager: function(const path: PCefString; persist_session_cookies: Integer;
    callback: PCefCompletionCallback): PCefCookieManager; cdecl;


{ ***  cef_crash_util_capi.h  *** }
  // Crash reporting is configured using an INI-style config file named
  // "crash_reporter.cfg". On Windows and Linux this file must be placed next to
  // the main application executable. On macOS this file must be placed in the
  // top-level app bundle Resources directory (e.g.
  // "<appname>.app/Contents/Resources"). File contents are as follows:
  //
  //  # Comments start with a hash character and must be on their own line.
  //
  //  [Config]
  //  ProductName=<Value of the "prod" crash key; defaults to "cef">
  //  ProductVersion=<Value of the "ver" crash key; defaults to the CEF version>
  //  AppName=<Windows only; App-specific folder name component for storing crash
  //           information; default to "CEF">
  //  ExternalHandler=<Windows only; Name of the external handler exe to use
  //                   instead of re-launching the main exe; default to empty>
  //  BrowserCrashForwardingEnabled=<macOS only; True if browser process crashes
  //                                 should be forwarded to the system crash
  //                                 reporter; default to false>
  //  ServerURL=<crash server URL; default to empty>
  //  RateLimitEnabled=<True if uploads should be rate limited; default to true>
  //  MaxUploadsPerDay=<Max uploads per 24 hours, used if rate limit is enabled;
  //                    default to 5>
  //  MaxDatabaseSizeInMb=<Total crash report disk usage greater than this value
  //                       will cause older reports to be deleted; default to 20>
  //  MaxDatabaseAgeInDays=<Crash reports older than this value will be deleted;
  //                        default to 5>
  //
  //  [CrashKeys]
  //  my_key1=<small|medium|large>
  //  my_key2=<small|medium|large>
  //
  // Config section:
  //
  // If "ProductName" and/or "ProductVersion" are set then the specified values
  // will be included in the crash dump metadata. On macOS if these values are set
  // to NULL then they will be retrieved from the Info.plist file using the
  // "CFBundleName" and "CFBundleShortVersionString" keys respectively.
  //
  // If "AppName" is set on Windows then crash report information (metrics,
  // database and dumps) will be stored locally on disk under the
  // "C:\Users\[CurrentUser]\AppData\Local\[AppName]\User Data" folder. On other
  // platforms the CefSettings.user_data_path value will be used.
  //
  // If "ExternalHandler" is set on Windows then the specified exe will be
  // launched as the crashpad-handler instead of re-launching the main process
  // exe. The value can be an absolute path or a path relative to the main exe
  // directory. On Linux the CefSettings.browser_subprocess_path value will be
  // used. On macOS the existing subprocess app bundle will be used.
  //
  // If "BrowserCrashForwardingEnabled" is set to true (1) on macOS then browser
  // process crashes will be forwarded to the system crash reporter. This results
  // in the crash UI dialog being displayed to the user and crash reports being
  // logged under "~/Library/Logs/DiagnosticReports". Forwarding of crash reports
  // from non-browser processes and Debug builds is always disabled.
  //
  // If "ServerURL" is set then crashes will be uploaded as a multi-part POST
  // request to the specified URL. Otherwise, reports will only be stored locally
  // on disk.
  //
  // If "RateLimitEnabled" is set to true (1) then crash report uploads will be
  // rate limited as follows:
  //  1. If "MaxUploadsPerDay" is set to a positive value then at most the
  //     specified number of crashes will be uploaded in each 24 hour period.
  //  2. If crash upload fails due to a network or server error then an
  //     incremental backoff delay up to a maximum of 24 hours will be applied for
  //     retries.
  //  3. If a backoff delay is applied and "MaxUploadsPerDay" is > 1 then the
  //     "MaxUploadsPerDay" value will be reduced to 1 until the client is
  //     restarted. This helps to avoid an upload flood when the network or
  //     server error is resolved.
  // Rate limiting is not supported on Linux.
  //
  // If "MaxDatabaseSizeInMb" is set to a positive value then crash report storage
  // on disk will be limited to that size in megabytes. For example, on Windows
  // each dump is about 600KB so a "MaxDatabaseSizeInMb" value of 20 equates to
  // about 34 crash reports stored on disk. Not supported on Linux.
  //
  // If "MaxDatabaseAgeInDays" is set to a positive value then crash reports older
  // than the specified age in days will be deleted. Not supported on Linux.
  //
  // CrashKeys section:
  //
  // Any number of crash keys can be specified for use by the application. Crash
  // key values will be truncated based on the specified size (small = 63 bytes,
  // medium = 252 bytes, large = 1008 bytes). The value of crash keys can be set
  // from any thread or process using the CefSetCrashKeyValue function. These
  // key/value pairs will be sent to the crash server along with the crash dump
  // file. Medium and large values will be chunked for submission. For example, if
  // your key is named "mykey" then the value will be broken into ordered chunks
  // and submitted using keys named "mykey-1", "mykey-2", etc.
  cef_crash_reporting_enabled: function: Integer; cdecl;

  // Sets or clears a specific key-value pair from the crash metadata.
  cef_set_crash_key_value: procedure(const key, value: PCefString); cdecl;


{ ***  cef_file_util_capi.h  *** }
  // Creates a directory and all parent directories if they don't already exist.
  // Returns true (1) on successful creation or if the directory already exists.
  // The directory is only readable by the current user. Calling this function on
  // the browser process UI or IO threads is not allowed.
  cef_create_directory: function(const full_path: PCefString): Integer; cdecl;

  // Get the temporary directory provided by the system.
  //
  // WARNING: In general, you should use the temp directory variants below instead
  // of this function. Those variants will ensure that the proper permissions are
  // set so that other users on the system can't edit them while they're open
  // (which could lead to security issues).
  cef_get_temp_directory: function(temp_dir: PCefString): Integer; cdecl;

  // Creates a new directory. On Windows if |prefix| is provided the new directory
  // name is in the format of "prefixyyyy". Returns true (1) on success and sets
  // |new_temp_path| to the full path of the directory that was created. The
  // directory is only readable by the current user. Calling this function on the
  // browser process UI or IO threads is not allowed.
  cef_create_new_temp_directory: function(const prefix: PCefString;
    new_temp_path: PCefString): Integer; cdecl;

  // Creates a directory within another directory. Extra characters will be
  // appended to |prefix| to ensure that the new directory does not have the same
  // name as an existing directory. Returns true (1) on success and sets |new_dir|
  // to the full path of the directory that was created. The directory is only
  // readable by the current user. Calling this function on the browser process UI
  // or IO threads is not allowed.
  cef_create_temp_directory_in_directory: function(const base_dir, prefix: PCefString;
    new_dir: PCefString): Integer; cdecl;

  // Returns true (1) if the given path exists and is a directory. Calling this
  // function on the browser process UI or IO threads is not allowed.
  cef_directory_exists: function(const path: PCefString): Integer; cdecl;

  // Deletes the given path whether it's a file or a directory. If |path| is a
  // directory all contents will be deleted.  If |recursive| is true (1) any sub-
  // directories and their contents will also be deleted (equivalent to executing
  // "rm -rf", so use with caution). On POSIX environments if |path| is a symbolic
  // link then only the symlink will be deleted. Returns true (1) on successful
  // deletion or if |path| does not exist. Calling this function on the browser
  // process UI or IO threads is not allowed.
  cef_delete_file: function(const path: PCefString; recursive: Integer): Integer; cdecl;

  // Writes the contents of |src_dir| into a zip archive at |dest_file|. If
  // |include_hidden_files| is true (1) files starting with "." will be included.
  // Returns true (1) on success.  Calling this function on the browser process UI
  // or IO threads is not allowed.
  cef_zip_directory: function(const src_dir, dest_file: PCefString; include_hidden_files: Integer): Integer; cdecl;


{ ***  cef_geolocation_capi.h  *** }
  // Request a one-time geolocation update. This function bypasses any user
  // permission checks so should only be used by code that is allowed to access
  // location information.
  cef_get_geolocation: function(callback: PCefGetGeolocationCallback): Integer; cdecl;


{ ***  cef_image_capi.h  *** }
  // Create a new cef_image_t. It will initially be NULL. Use the Add*() functions
  // to add representations at different scale factors.
  cef_image_create: function: PCefImage; cdecl;


{ ***  cef_menu_model_capi.h  *** }
  // Create a new MenuModel with the specified |delegate|.
  cef_menu_model_create: function(delegate: PCefMenuModelDelegate): PCefMenuModel; cdecl;


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


{ ***  cef_parser_capi.h  *** }
  // Parse the specified |url| into its component parts. Returns false (0) if the
  // URL is NULL or invalid.
  cef_parse_url: function(const url: PCefString; parts: PCefUrlParts): Integer; cdecl;

  // Creates a URL from the specified |parts|, which must contain a non-NULL spec
  // or a non-NULL host and path (at a minimum), but not both. Returns false (0)
  // if |parts| isn't initialized as described.
  cef_create_url: function(const parts: PCefUrlParts; url: PCefString): Integer; cdecl;

  // This is a convenience function for formatting a URL in a concise and human-
  // friendly way to help users make security-related decisions (or in other
  // circumstances when people need to distinguish sites, origins, or otherwise-
  // simplified URLs from each other). Internationalized domain names (IDN) may be
  // presented in Unicode if the conversion is considered safe. The returned value
  // will (a) omit the path for standard schemes, excepting file and filesystem,
  // and (b) omit the port if it is the default for the scheme. Do not use this
  // for URLs which will be parsed or sent to other applications.
  //
  // The resulting string must be freed by calling cef_string_userfree_free().
  cef_format_url_for_security_display: function(const origin_url: PCefString): PCefStringUserFree; cdecl;

  // Returns the mime type for the specified file extension or an NULL string if
  // unknown.
  //
  // The resulting string must be freed by calling cef_string_userfree_free().
  cef_get_mime_type: function(const extension: PCefString): PCefStringUserFree; cdecl;

  // Get the extensions associated with the given mime type. This should be passed
  // in lower case. There could be multiple extensions for a given mime type, like
  // "html,htm" for "text/html", or "txt,text,html,..." for "text/*". Any existing
  // elements in the provided vector will not be erased.
  cef_get_extensions_for_mime_type: procedure(const mime_type: PCefString; extensions: TCefStringList); cdecl;

  // Encodes |data| as a base64 string.
  //
  // The resulting string must be freed by calling cef_string_userfree_free().
  cef_base64encode: function(const data: Pointer; data_size: csize_t): PCefStringUserFree; cdecl;

  // Decodes the base64 encoded string |data|. The returned value will be NULL if
  // the decoding fails.
  cef_base64decode: function(const data: PCefString): PCefBinaryValue; cdecl;

  // Escapes characters in |text| which are unsuitable for use as a query
  // parameter value. Everything except alphanumerics and -_.!~*'() will be
  // converted to "%XX". If |use_plus| is true (1) spaces will change to "+". The
  // result is basically the same as encodeURIComponent in Javacript.
  //
  // The resulting string must be freed by calling cef_string_userfree_free().
  cef_uriencode: function(const text: PCefString; use_plus: Integer): PCefStringUserFree; cdecl;

  // Unescapes |text| and returns the result. Unescaping consists of looking for
  // the exact pattern "%XX" where each X is a hex digit and converting to the
  // character with the numerical value of those digits (e.g. "i%20=%203%3b"
  // unescapes to "i = 3;"). If |convert_to_utf8| is true (1) this function will
  // attempt to interpret the initial decoded result as UTF-8. If the result is
  // convertable into UTF-8 it will be returned as converted. Otherwise the
  // initial decoded result will be returned.  The |unescape_rule| parameter
  // supports further customization the decoding process.
  //
  // The resulting string must be freed by calling cef_string_userfree_free().
  cef_uridecode: function(const text: PCefString; convert_to_utf8: Integer; unescape_rule: TCefUriUnescapeRule): PCefStringUserFree; cdecl;

  // Parses the specified |json_string| and returns a dictionary or list
  // representation. If JSON parsing fails this function returns NULL.
  cef_parse_json: function(const json_string: PCefString; options: TCefJsonParserOptions): PCefValue; cdecl;

  // Parses the specified |json_string| and returns a dictionary or list
  // representation. If JSON parsing fails this function returns NULL and
  // populates |error_code_out| and |error_msg_out| with an error code and a
  // formatted error message respectively.
  cef_parse_jsonand_return_error: function(const json_string: PCefString; options: TCefJsonParserOptions;
    error_code_out: PCefJsonParserError; error_msg_out: PCefString): PCefValue; cdecl;

  // Generates a JSON string from the specified root |node| which should be a
  // dictionary or list value. Returns an NULL string on failure. This function
  // requires exclusive access to |node| including any underlying data.
  // The resulting string must be freed by calling cef_string_userfree_free().
  cef_write_json: function(node: PCefValue; options: TCefJsonWriterOptions): PCefStringUserFree; cdecl;


{ ***  cef_path_util_capi.h  *** }
  // Retrieve the path associated with the specified |key|. Returns true (1) on
  // success. Can be called on any thread in the browser process.
  cef_get_path: function(key: TCefPathKey; path: PCefString): Integer; cdecl;


{ ***  cef_print_settings_capi.h  *** }
  // Create a new cef_print_settings_t object.
  cef_print_settings_create: function: PCefPrintSettings; cdecl;


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


{ *** cef_request_context_capi.h *** }
  // Returns the global context object.
  cef_request_context_get_global_context: function: PCefRequestContext; cdecl;

  // Creates a new context object with the specified |settings| and optional
  // |handler|.
  cef_request_context_create_context: function(const settings: PCefRequestContextSettings;
    handler: PCefRequestContextHandler): PCefRequestContextHandler; cdecl;

  // Creates a new context object that shares storage with |other| and uses an
  // optional |handler|.
  cef_create_context_shared: function(other: PCefRequestContext; handler: PCefRequestContextHandler): PCefRequestContext; cdecl;


{ ***  cef_resource_bundle_capi.h  *** }
  // Returns the global resource bundle instance.
  cef_resource_bundle_get_global: function: PCefResourceBundle; cdecl;


{ ***  cef_response_capi.h  *** }
  // Create a new TCefResponse object.
  cef_response_create: function: PCefResponse; cdecl;


{ ***  cef_scheme_capi.h  *** }
  // Register a scheme handler factory with the global request context. An NULL
  // |domain_name| value for a standard scheme will cause the factory to match all
  // domain names. The |domain_name| value will be ignored for non-standard
  // schemes. If |scheme_name| is a built-in scheme and no handler is returned by
  // |factory| then the built-in scheme handler factory will be called. If
  // |scheme_name| is a custom scheme then you must also implement the
  // cef_app_t::on_register_custom_schemes() function in all processes. This
  // function may be called multiple times to change or remove the factory that
  // matches the specified |scheme_name| and optional |domain_name|. Returns false
  // (0) if an error occurs. This function may be called on any thread in the
  // browser process. Using this function is equivalent to calling cef_request_tCo
  // ntext::cef_request_context_get_global_context()->register_scheme_handler_fact
  // ory().
  cef_register_scheme_handler_factory: function(
    const scheme_name, domain_name: PCefString;
    factory: PCefSchemeHandlerFactory): Integer; cdecl;

  // Clear all scheme handler factories registered with the global request
  // context. Returns false (0) on error. This function may be called on any
  // thread in the browser process. Using this function is equivalent to calling c
  // ef_request_tContext::cef_request_context_get_global_context()->clear_scheme_h
  // andler_factories().
  cef_clear_scheme_handler_factories: function: Integer; cdecl;


{ *** cef_ssl_info_capi.h *** }
  // Returns true (1) if the certificate status has any error, major or minor.
  cef_is_cert_status_error: function(status: TCefCertStatus): Integer; cdecl;

  // Returns true (1) if the certificate status represents only minor errors (e.g.
  // failure to verify certificate revocation).
  cef_is_cert_status_minor_error: function(status: TCefCertStatus): Integer; cdecl;


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
  // cef_task_tRunner::GetForThread(threadId)->belongs_to_current_thread().
  cef_currently_on: function(threadId: TCefThreadId): Integer; cdecl;

  // Post a task for execution on the specified thread. Equivalent to using
  // cef_task_tRunner::GetForThread(threadId)->PostTask(task).
  cef_post_task: function(threadId: TCefThreadId; task: PCefTask): Integer; cdecl;

  // Post a task for delayed execution on the specified thread. Equivalent to
  // using cef_task_tRunner::GetForThread(threadId)->PostDelayedTask(task,
  // delay_ms).
  cef_post_delayed_task: function(threadId: TCefThreadId;
      task: PCefTask; delay_ms: Int64): Integer; cdecl;

  // Returns the task runner for the current thread. Only CEF threads will have
  // task runners. An NULL reference will be returned if this function is called
  // on an invalid thread.
  cef_task_runner_get_for_current_thread: function: PCefTaskRunner; cdecl;

  // Returns the task runner for the specified CEF thread.
  cef_task_runner_get_for_thread: function(threadId: TCefThreadId): PCefTaskRunner; cdecl;


{ ***  cef_thread_capi.h  *** }
  // Create and start a new thread. This function does not block waiting for the
  // thread to run initialization. |display_name| is the name that will be used to
  // identify the thread. |priority| is the thread execution priority.
  // |message_loop_type| indicates the set of asynchronous events that the thread
  // can process. If |stoppable| is true (1) the thread will stopped and joined on
  // destruction or when stop() is called; otherwise, the the thread cannot be
  // stopped and will be leaked on shutdown. On Windows the |com_init_mode| value
  // specifies how COM will be initialized for the thread. If |com_init_mode| is
  // set to COM_INIT_MODE_STA then |message_loop_type| must be set to ML_TYPE_UI.
  cef_thread_create: function(const display_name: PCefString; priority: TCefThreadPriority;
    message_loop_type: TCefMessageLoopType; stoppable: Integer; com_init_mode: TCefComInitMode): PCefThread; cdecl;


{ ***  cef_trace_capi.h  *** }
  // Start tracing events on all processes. Tracing is initialized asynchronously
  // and |callback| will be executed on the UI thread after initialization is
  // complete.
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
  cef_begin_tracing: function(const categories: PCefString; callback: PCefCompletionCallback): Integer; cdecl;


  // Stop tracing events on all processes.
  //
  // This function will fail and return false (0) if a previous call to
  // CefEndTracingAsync is already pending or if CefBeginTracing was not called.
  //
  // |tracing_file| is the path at which tracing data will be written and
  // |callback| is the callback that will be executed once all processes have sent
  // their trace data. If |tracing_file| is NULL a new temporary file path will be
  // used. If |callback| is NULL no trace data will be written.
  //
  // This function must be called on the browser process UI thread.
  cef_end_tracing: function(const tracing_file: PCefString; callback: PCefEndTracingCallback): Integer; cdecl;


  // Returns the current system trace time or, if none is defined, the current
  // high-res time. Can be used by clients to synchronize with the time
  // information in trace events.
  cef_now_from_system_trace_time: function: Int64; cdecl;


{ ***  cef_urlrequest_capi.h  *** }
  // Create a new URL request. Only GET, POST, HEAD, DELETE and PUT request
  // functions are supported. Multiple post data elements are not supported and
  // elements of type PDE_TYPE_FILE are only supported for requests originating
  // from the browser process. Requests originating from the render process will
  // receive the same handling as requests originating from Web content -- if the
  // response contains Content-Disposition or Mime-Type header values that would
  // not normally be rendered then the response may receive special handling
  // inside the browser (for example, via the file download code path instead of
  // the URL request code path). The |request| object will be marked as read-only
  // after calling this function. In the browser process if |request_context| is
  // NULL the global request context will be used. In the render process
  // |request_context| must be NULL and the context associated with the current
  // renderer process' browser will be used.
  cef_urlrequest_create: function(request: PCefRequest; client: PCefUrlRequestClient;
    request_context: PCefRequestContext): PCefUrlRequest; cdecl;


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
  // called from within the scope of a cef_render_process_handler_t,
  // cef_v8handler_t or cef_v8accessor_t callback, or in combination with calling
  // enter() and exit() on a stored cef_v8context_t reference.
  cef_v8value_create_date: function(const value: PCefTime): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type string.
  cef_v8value_create_string: function(const value: PCefString): PCefv8Value; cdecl;

  // Create a new cef_v8value_t object of type object with optional accessor
  // and/or interceptor. This function should only be called from within the scope
  // of a cef_render_process_handler_t, cef_v8handler_t or cef_v8accessor_t
  // callback, or in combination with calling enter() and exit() on a stored
  // cef_v8context_t reference.
  cef_v8value_create_object: function(accessor: PCefV8Accessor; interceptor: PCefV8Interceptor): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type array with the specified |length|.
  // If |length| is negative the returned array will have length 0. This function
  // should only be called from within the scope of a
  // cef_render_process_handler_t, cef_v8handler_t or cef_v8accessor_t callback,
  // or in combination with calling enter() and exit() on a stored cef_v8context_t
  // reference.
  cef_v8value_create_array: function(length: Integer): PCefv8Value; cdecl;

  // Create a new TCefv8Value object of type function. This function should only
  // be called from within the scope of a cef_render_process_handler_t,
  // cef_v8handler_t or cef_v8accessor_t callback, or in combination with calling
  // enter() and exit() on a stored cef_v8context_t reference.
  cef_v8value_create_function: function(const name: PCefString; handler: PCefv8Handler): PCefv8Value; cdecl;

  // Returns the stack trace for the currently active context. |frame_limit| is
  // the maximum number of frames that will be captured.
  cef_v8stack_trace_get_current: function(frame_limit: Integer): PCefV8StackTrace; cdecl;


{ ***  cef_values_capi.h  *** }
  // Creates a new object.
  cef_value_create: function: PCefValue; cdecl;

  // Creates a new object that is not owned by any other object. The specified
  // |data| will be copied.
  cef_binary_value_create: function(const data: Pointer; data_size: csize_t): PCefBinaryValue; cdecl;

  // Creates a new object that is not owned by any other object.
  cef_dictionary_value_create: function: PCefDictionaryValue; cdecl;

  // Creates a new object that is not owned by any other object.
  cef_list_value_create: function: PCefListValue; cdecl;


{ ***  cef_waitable_event_capi.h  *** }
  // Create a new waitable event. If |automatic_reset| is true (1) then the event
  // state is automatically reset to un-signaled after a single waiting thread has
  // been released; otherwise, the state remains signaled until reset() is called
  // manually. If |initially_signaled| is true (1) then the event will start in
  // the signaled state.
  cef_waitable_event_create: function(automatic_reset, initially_signaled: Integer): PCefWaitableEvent; cdecl;


{ ***  cef_web_plugin_capi.h  *** }
  // Visit web plugin information. Can be called on any thread in the browser
  // process.
  cef_visit_web_plugin_info: procedure(visitor: PCefWebPluginInfoVisitor); cdecl;

  // Cause the plugin list to refresh the next time it is accessed regardless of
  // whether it has already been loaded. Can be called on any thread in the
  // browser process.
  cef_refresh_web_plugins: procedure; cdecl;

  // Unregister an internal plugin. This may be undone the next time
  // cef_refresh_web_plugins() is called. Can be called on any thread in the
  // browser process.
  cef_unregister_internal_web_plugin: procedure(const path: PCefString); cdecl;

  // Register a plugin crash. Can be called on any thread in the browser process
  // but will be executed on the IO thread.
  cef_register_web_plugin_crash: procedure(const path: PCefString); cdecl;

  // Query if a plugin is unstable. Can be called on any thread in the browser
  // process.
  cef_is_web_plugin_unstable: procedure(const path: PCefString; callback: PCefWebPluginUnstableCallback); cdecl;

  // Register the Widevine CDM plugin.
  //
  // The client application is responsible for downloading an appropriate
  // platform-specific CDM binary distribution from Google, extracting the
  // contents, and building the required directory structure on the local machine.
  // The cef_browser_host_t::StartDownload function and CefZipArchive structure
  // can be used to implement this functionality in CEF. Contact Google via
  // https://www.widevine.com/contact.html for details on CDM download.
  //
  // |path| is a directory that must contain the following files:
  //   1. manifest.json file from the CDM binary distribution (see below).
  //   2. widevinecdm file from the CDM binary distribution (e.g.
  //      widevinecdm.dll on on Windows, libwidevinecdm.dylib on OS X,
  //      libwidevinecdm.so on Linux).
  //   3. widevidecdmadapter file from the CEF binary distribution (e.g.
  //      widevinecdmadapter.dll on Windows, widevinecdmadapter.plugin on OS X,
  //      libwidevinecdmadapter.so on Linux).
  //
  // If any of these files are missing or if the manifest file has incorrect
  // contents the registration will fail and |callback| will receive a |result|
  // value of CEF_CDM_REGISTRATION_ERROR_INCORRECT_CONTENTS.
  //
  // The manifest.json file must contain the following keys:
  //   A. "os": Supported OS (e.g. "mac", "win" or "linux").
  //   B. "arch": Supported architecture (e.g. "ia32" or "x64").
  //   C. "x-cdm-module-versions": Module API version (e.g. "4").
  //   D. "x-cdm-interface-versions": Interface API version (e.g. "8").
  //   E. "x-cdm-host-versions": Host API version (e.g. "8").
  //   F. "version": CDM version (e.g. "1.4.8.903").
  //   G. "x-cdm-codecs": List of supported codecs (e.g. "vp8,vp9.0,avc1").
  //
  // A through E are used to verify compatibility with the current Chromium
  // version. If the CDM is not compatible the registration will fail and
  // |callback| will receive a |result| value of
  // CEF_CDM_REGISTRATION_ERROR_INCOMPATIBLE.
  //
  // |callback| will be executed asynchronously once registration is complete.
  //
  // On Linux this function must be called before cef_initialize() and the
  // registration cannot be changed during runtime. If registration is not
  // supported at the time that cef_register_widevine_cdm() is called then
  // |callback| will receive a |result| value of
  // CEF_CDM_REGISTRATION_ERROR_NOT_SUPPORTED.
  cef_register_widevine_cdm: procedure(const path: PCefString; callback: PCefRegisterCdmCallback); cdecl;


{ ***  cef_xml_reader_capi.h  *** }
  // Create a new TCefXMLReader object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_xml_reader_create: function(stream: PCefStreamReader;
    encodingType: TCefXmlEncodingType; const URI: PCefString): PCefXmlReader; cdecl;


{ ***  cef_zip_reader_capi.h  *** }
  // Create a new cef_zip_reader_t object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_zip_reader_create: function(stream: PCefStreamReader): PCefZipReader; cdecl;



{ *** cef_logging_internal.h *** }

  // Gets the current log level.
  cef_get_min_log_level: function: Integer; cdecl;

  // Gets the current vlog level for the given file (usually taken from
  // __FILE__). Note that |N| is the size *with* the null terminator.
  cef_get_vlog_level: function(const file_start: PChar; N: csize_t): Integer;

  // Add a log message. See the LogSeverity defines for supported |severity|
  // values.
  cef_log: procedure(const file_: PChar; line, severity: Integer; const message: PChar);


{ ***  cef_string_types.h  *** }

  // These functions set string values. If |copy| is true (1) the value will be
  // copied instead of referenced. It is up to the user to properly manage
  // the lifespan of references.
  cef_string_wide_set: function(const src: PWideChar; src_len: csize_t;  output: PCefStringWide; copy: Integer): Integer; cdecl;
  cef_string_utf8_set: function(const src: PAnsiChar; src_len: csize_t; output: PCefStringUtf8; copy: Integer): Integer; cdecl;
  cef_string_utf16_set: function(const src: PChar16; src_len: csize_t; output: PCefStringUtf16; copy: Integer): Integer; cdecl;

  cef_string_set: function(const src: PCefChar; src_len: csize_t; output: PCefString; copy: Integer): Integer; cdecl;

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
  cef_string_wide_to_utf8: function(const src: PWideChar; src_len: csize_t; output: PCefStringUtf8): Integer; cdecl;
  cef_string_utf8_to_wide: function(const src: PAnsiChar; src_len: csize_t; output: PCefStringWide): Integer; cdecl;

  cef_string_wide_to_utf16: function (const src: PWideChar; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_wide: function(const src: PChar16; src_len: csize_t; output: PCefStringWide): Integer; cdecl;

  cef_string_utf8_to_utf16: function(const src: PAnsiChar; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_utf8: function(const src: PChar16; src_len: csize_t; output: PCefStringUtf8): Integer; cdecl;

  { Additional }
  cef_string_to_utf8: function(const src: PCefChar; src_len: csize_t; output: PCefStringUtf8): Integer; cdecl;
  cef_string_from_utf8: function(const src: PAnsiChar; src_len: csize_t; output: PCefString): Integer; cdecl;
  cef_string_to_utf16: function(const src: PCefChar; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;
  cef_string_from_utf16: function(const src: PChar16; src_len: csize_t; output: PCefString): Integer; cdecl;
  cef_string_to_wide: function(const src: PCefChar; src_len: csize_t; output: PCefStringWide): Integer; cdecl;
  cef_string_from_wide: function(const src: PWideChar; src_len: csize_t; output: PCefString): Integer; cdecl;


  // These functions convert an ASCII string, typically a hardcoded constant, to a
  // Wide/UTF16 string. Use instead of the UTF8 conversion routines if you know
  // the string is ASCII.
  cef_string_ascii_to_wide: function(const src: PAnsiChar; src_len: csize_t; output: PCefStringWide): Integer; cdecl;
  cef_string_ascii_to_utf16: function(const src: PAnsiChar; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;

  cef_string_from_ascii: function(const src: PAnsiChar; src_len: csize_t; output: PCefString): Integer; cdecl;


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


  // These functions convert utf16 string case using the current ICU locale. This
  // may change the length of the string in some cases.
  cef_string_utf16_to_lower: function(const src: PChar16; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_upper: function(const src: PChar16; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;


{ ***  cef_string_list.h  *** }

  // Allocate a new string map.
  cef_string_list_alloc: function: TCefStringList; cdecl;

  // Return the number of elements in the string list.
  cef_string_list_size: function(list: TCefStringList): csize_t; cdecl;

  // Retrieve the value at the specified zero-based string list index. Returns
  // true (1) if the value was successfully retrieved.
  cef_string_list_value: function(list: TCefStringList; index: csize_t; value: PCefString): Integer; cdecl;

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
  cef_string_map_size: function(map: TCefStringMap): csize_t; cdecl;

  // Return the value assigned to the specified key.
  cef_string_map_find: function(map: TCefStringMap; const key: PCefString; value: PCefString): Integer; cdecl;

  // Return the key at the specified zero-based string map index.
  cef_string_map_key: function(map: TCefStringMap; index: csize_t; var key: TCefString): Integer; cdecl;

  // Return the value at the specified zero-based string map index.
  cef_string_map_value: function(map: TCefStringMap; index: csize_t; var value: TCefString): Integer; cdecl;

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
  cef_string_multimap_size: function(map: TCefStringMultimap): csize_t; cdecl;

  // Return the number of values with the specified key.
  cef_string_multimap_find_count: function(map: TCefStringMultimap; const key: PCefString): csize_t; cdecl;

  // Return the value_index-th value with the specified key.
  cef_string_multimap_enumerate: function(map: TCefStringMultimap;
    const key: PCefString; value_index: csize_t; var value: TCefString): Integer; cdecl;

  // Return the key at the specified zero-based string multimap index.
  cef_string_multimap_key: function(map: TCefStringMultimap; index: csize_t; var key: TCefString): Integer; cdecl;

  // Return the value at the specified zero-based string multimap index.
  cef_string_multimap_value: function(map: TCefStringMultimap; index: csize_t; var value: TCefString): Integer; cdecl;

  // Append a new key/value pair at the end of the string multimap.
  cef_string_multimap_append: function(map: TCefStringMultimap; const key, value: PCefString): Integer; cdecl;

  // Clear the string multimap.
  cef_string_multimap_clear: procedure(map: TCefStringMultimap); cdecl;

  // Free the string multimap.
  cef_string_multimap_free: procedure(map: TCefStringMultimap); cdecl;


{ ***  cef_thread_internal.h  *** }
  // Returns the current platform thread ID.
  cef_get_current_platform_thread_id: function: TCefPlatformThreadId; cdecl;

  // Returns the current platform thread handle.
  cef_get_current_platform_thread_handle: function: TCefPlatformThreadHandle; cdecl;


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


{ ***  cef_trace_event_internal.h  *** }
  // Functions for tracing counters and functions; called from macros.
  // - |category| string must have application lifetime (static or literal). They
  //   may not include "(quotes) chars.
  // - |argX_name|, |argX_val|, |valueX_name|, |valeX_val| are optional parameters
  //   and represent pairs of name and values of arguments
  // - |copy| is used to avoid memory scoping issues with the |name| and
  //   |arg_name| parameters by copying them
  // - |id| is used to disambiguate counters with the same name, or match async
  //   trace events
  cef_trace_event_instant: procedure(const category, name, arg1_name: PChar; arg1_val: UInt64;
                                     const arg2_name: PChar; arg2_val: UInt64; copy: Integer); cdecl;

  cef_trace_event_begin: procedure(const category, name, arg1_name: PChar; arg1_val: UInt64;
                                   const arg2_name: PChar; arg2_val: UInt64; copy: Integer); cdecl;

  cef_trace_event_end: procedure(const category, name, arg1_name: PChar; arg1_val: UInt64;
                                 const arg2_name: PChar; arg2_val: UInt64; copy: Integer); cdecl;

  cef_trace_counter: procedure(const category, name, arg1_name: PChar; arg1_val: UInt64;
                               const arg2_name: PChar; arg2_val: UInt64; copy: Integer); cdecl;

  cef_trace_counter_id: procedure(const category, name: PChar; id: UInt64; const value1_name: PChar;
                                  value1_val: UInt64; const value2_name: PChar; value2_val: UInt64; copy: Integer); cdecl;

  cef_trace_event_async_begin: procedure(const category, name: PChar; id: UInt64; const arg1_name: PChar;
                                         arg1_val: UInt64; const arg2_name: PChar; arg2_val: UInt64; copy: Integer); cdecl;

  cef_trace_event_async_step_into: procedure(const category, name: PChar; id, step: UInt64;
                                             const arg1_name: PChar; arg1_val: UInt64; copy: Integer); cdecl;

  cef_trace_event_async_step_past: procedure(const category, name: PChar; id, step: UInt64;
                                             const arg1_name: PChar; arg1_val: UInt64; copy: Integer); cdecl;

  cef_trace_event_async_end: procedure(const category, name: PChar; id: UInt64; const arg1_name: PChar;
                                       arg1_val: UInt64; const arg2_name: PChar; arg2_val: UInt64; copy: Integer); cdecl;


{ ***  cef_version.h *** }

Const
  // Returns CEF version information for the libcef library. The |entry|
  // parameter describes which version component will be returned:
  CEF_VERSION_MAJOR    = 0;
  CEF_REVISION         = 1;
  CHROME_VERSION_MAJOR = 2;
  CHROME_VERSION_MINOR = 3;
  CHROME_VERSION_BUILD = 4;
  CHROME_VERSION_PATCH = 5;

Var
  cef_version_info: function(entry: Integer): Integer; cdecl;


Const
  // Returns CEF API hashes for the libcef library. The returned string is owned
  // by the library and should not be freed. The |entry| parameter describes which
  // hash value will be returned:
  CEF_API_HASH_PLATFORM  = 0;
  CEF_API_HASH_UNIVERSAL = 1;

Var
  cef_api_hash: function(entry: Integer): PChar; cdecl;


{ ***  cef_types_linux.h  *** }
  {$IFDEF LINUX}
    // Return the singleton X11 display shared with Chromium. The display is not
    // thread-safe and must only be accessed on the browser process UI thread.
    cef_get_xdisplay: function: PXDisplay; cdecl;
  {$ENDIF}


function CefLoadLibrary: Boolean;
procedure CefCloseLibrary;

Implementation

Uses Math;

Const
  CefLibrary: String =
    {$IFDEF WINDOWS}'libcef.dll'{$ENDIF}
    {$IFDEF LINUX}'libcef.so'{$ENDIF}
    {$IFDEF DARWIN}'Chromium Embedded Framework'{$ENDIF};

Var
  LibHandle : TLibHandle = 0;


{ ***  cef_string_types.h *** }

// Convenience macros for copying values.
function cef_string_wide_copy(const src: PWideChar; src_len: csize_t;  output: PCefStringWide): Integer; cdecl;
begin
  Result := cef_string_wide_set(src, src_len, output, ord(True))
end;

function cef_string_utf8_copy(const src: PAnsiChar; src_len: csize_t; output: PCefStringUtf8): Integer; cdecl;
begin
  Result := cef_string_utf8_set(src, src_len, output, ord(True))
end;

function cef_string_utf16_copy(const src: PChar16; src_len: csize_t; output: PCefStringUtf16): Integer; cdecl;
begin
  Result := cef_string_utf16_set(src, src_len, output, ord(True))
end;

function cef_string_copy(const src: PCefChar; src_len: csize_t; output: PCefString): Integer; cdecl;
begin
  Result := cef_string_set(src, src_len, output, ord(True));
end;
{ ***                     *** }

{$IFDEF DARWIN}
  function LoadLibraryFromBundlePath(const CefLibrary: String): TLibHandle;
  Var
    ExeDir, FWName, LibPath: String;
  begin
    ExeDir := ExtractFileDir(ExpandFileName(ParamStr(0)));
    FWName := ChangeFileExt(CefLibrary, '.framework');

    // first attempt: main application
    // Contents
    //   MacOS   <- ExeDir
    //     exe
    //   Frameworks
    //     name.framework   <- FWName
    //       name           <- LibPath
    LibPath := ExtractFileDir(ExeDir) + PathDelim + 'Frameworks' + PathDelim + FWName + PathDelim + CefLibrary;

    Result := LoadLibrary(LibPath);
    If Result <> 0 then Exit;


    // second attempt: subprocess
    //   Frameworks
    //     name.framework   <- FWName
    //       name           <- LibPath
    //     subapp.app
    //       Contents
    //         MacOS   <- ExeDir
    //           exe
    LibPath := ExtractFileDir(ExeDir);  // Contents
    LibPath := ExtractFileDir(LibPath); // subapp.app
    LibPath := ExtractFileDir(LibPath); // Frameworks
    LibPath := LibPath + PathDelim + FWName + PathDelim + CefLibrary;

    Result := LoadLibrary(LibPath);
    If Result <> 0 then Exit;


    // third attempt: console application
    LibPath := ExeDir + PathDelim + FWName + PathDelim + CefLibrary;
    Result := LoadLibrary(LibPath);
  end;

{$ENDIF}

function CefLoadLibrary: Boolean;
begin
  {$IFDEF DEBUG}
  Debugln('CefLoadLibrary');
  {$ENDIF}

  If LibHandle = 0 then
  begin
    Set8087CW(Get8087CW or $3F); // deactivate FPU exception
    SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);

    LibHandle := LoadLibrary(CefLibrary);
    {$IFDEF DARWIN}
      If LibHandle = 0 then LibHandle := LoadLibraryFromBundlePath(CefLibrary);
    {$ENDIF}
    If LibHandle = 0 then RaiseLastOsError;

    Pointer(cef_string_wide_set)             := GetProcAddress(LibHandle, 'cef_string_wide_set');
    Pointer(cef_string_utf8_set)             := GetProcAddress(LibHandle, 'cef_string_utf8_set');
    Pointer(cef_string_utf16_set)            := GetProcAddress(LibHandle, 'cef_string_utf16_set');
    Pointer(cef_string_wide_clear)           := GetProcAddress(LibHandle, 'cef_string_wide_clear');
    Pointer(cef_string_utf8_clear)           := GetProcAddress(LibHandle, 'cef_string_utf8_clear');
    Pointer(cef_string_utf16_clear)          := GetProcAddress(LibHandle, 'cef_string_utf16_clear');
    Pointer(cef_string_wide_cmp)             := GetProcAddress(LibHandle, 'cef_string_wide_cmp');
    Pointer(cef_string_utf8_cmp)             := GetProcAddress(LibHandle, 'cef_string_utf8_cmp');
    Pointer(cef_string_utf16_cmp)            := GetProcAddress(LibHandle, 'cef_string_utf16_cmp');
    Pointer(cef_string_wide_to_utf8)         := GetProcAddress(LibHandle, 'cef_string_wide_to_utf8');
    Pointer(cef_string_utf8_to_wide)         := GetProcAddress(LibHandle, 'cef_string_utf8_to_wide');
    Pointer(cef_string_wide_to_utf16)        := GetProcAddress(LibHandle, 'cef_string_wide_to_utf16');
    Pointer(cef_string_utf16_to_wide)        := GetProcAddress(LibHandle, 'cef_string_utf16_to_wide');
    Pointer(cef_string_utf8_to_utf16)        := GetProcAddress(LibHandle, 'cef_string_utf8_to_utf16');
    Pointer(cef_string_utf16_to_utf8)        := GetProcAddress(LibHandle, 'cef_string_utf16_to_utf8');
    Pointer(cef_string_ascii_to_wide)        := GetProcAddress(LibHandle, 'cef_string_ascii_to_wide');
    Pointer(cef_string_ascii_to_utf16)       := GetProcAddress(LibHandle, 'cef_string_ascii_to_utf16');
    Pointer(cef_string_userfree_wide_alloc)  := GetProcAddress(LibHandle, 'cef_string_userfree_wide_alloc');
    Pointer(cef_string_userfree_utf8_alloc)  := GetProcAddress(LibHandle, 'cef_string_userfree_utf8_alloc');
    Pointer(cef_string_userfree_utf16_alloc) := GetProcAddress(LibHandle, 'cef_string_userfree_utf16_alloc');
    Pointer(cef_string_userfree_wide_free)   := GetProcAddress(LibHandle, 'cef_string_userfree_wide_free');
    Pointer(cef_string_userfree_utf8_free)   := GetProcAddress(LibHandle, 'cef_string_userfree_utf8_free');
    Pointer(cef_string_userfree_utf16_free)  := GetProcAddress(LibHandle, 'cef_string_userfree_utf16_free');
    Pointer(cef_string_utf16_to_lower)       := GetProcAddress(LibHandle, 'cef_string_utf16_to_lower');
    Pointer(cef_string_utf16_to_upper)       := GetProcAddress(LibHandle, 'cef_string_utf16_to_upper');

{$IFDEF CEF_STRING_TYPE_UTF8}
    cef_string_set            := cef_string_utf8_set;
    cef_string_clear          := cef_string_utf8_clear;
    cef_string_userfree_alloc := cef_string_userfree_utf8_alloc;
    cef_string_userfree_free  := cef_string_userfree_utf8_free;
    cef_string_from_ascii     := @cef_string_utf8_copy;
    cef_string_to_utf8        := @cef_string_utf8_copy;
    cef_string_from_utf8      := @cef_string_utf8_copy;
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
    cef_string_to_utf16       := @cef_string_utf16_copy;
    cef_string_from_utf16     := @cef_string_utf16_copy;
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
    cef_string_to_wide        := @cef_string_wide_copy;
    cef_string_from_wide      := @cef_string_wide_copy;
{$ENDIF}

    Pointer(cef_string_list_alloc)                   := GetProcAddress(LibHandle, 'cef_string_list_alloc');
    Pointer(cef_string_list_size)                    := GetProcAddress(LibHandle, 'cef_string_list_size');
    Pointer(cef_string_list_value)                   := GetProcAddress(LibHandle, 'cef_string_list_value');
    Pointer(cef_string_list_append)                  := GetProcAddress(LibHandle, 'cef_string_list_append');
    Pointer(cef_string_list_clear)                   := GetProcAddress(LibHandle, 'cef_string_list_clear');
    Pointer(cef_string_list_free)                    := GetProcAddress(LibHandle, 'cef_string_list_free');
    Pointer(cef_string_list_copy)                    := GetProcAddress(LibHandle, 'cef_string_list_copy');
    Pointer(cef_string_map_alloc)                    := GetProcAddress(LibHandle, 'cef_string_map_alloc');
    Pointer(cef_string_map_size)                     := GetProcAddress(LibHandle, 'cef_string_map_size');
    Pointer(cef_string_map_find)                     := GetProcAddress(LibHandle, 'cef_string_map_find');
    Pointer(cef_string_map_key)                      := GetProcAddress(LibHandle, 'cef_string_map_key');
    Pointer(cef_string_map_value)                    := GetProcAddress(LibHandle, 'cef_string_map_value');
    Pointer(cef_string_map_append)                   := GetProcAddress(LibHandle, 'cef_string_map_append');
    Pointer(cef_string_map_clear)                    := GetProcAddress(LibHandle, 'cef_string_map_clear');
    Pointer(cef_string_map_free)                     := GetProcAddress(LibHandle, 'cef_string_map_free');
    Pointer(cef_string_multimap_alloc)               := GetProcAddress(LibHandle, 'cef_string_multimap_alloc');
    Pointer(cef_string_multimap_size)                := GetProcAddress(LibHandle, 'cef_string_multimap_size');
    Pointer(cef_string_multimap_find_count)          := GetProcAddress(LibHandle, 'cef_string_multimap_find_count');
    Pointer(cef_string_multimap_enumerate)           := GetProcAddress(LibHandle, 'cef_string_multimap_enumerate');
    Pointer(cef_string_multimap_key)                 := GetProcAddress(LibHandle, 'cef_string_multimap_key');
    Pointer(cef_string_multimap_value)               := GetProcAddress(LibHandle, 'cef_string_multimap_value');
    Pointer(cef_string_multimap_append)              := GetProcAddress(LibHandle, 'cef_string_multimap_append');
    Pointer(cef_string_multimap_clear)               := GetProcAddress(LibHandle, 'cef_string_multimap_clear');
    Pointer(cef_string_multimap_free)                := GetProcAddress(LibHandle, 'cef_string_multimap_free');

    Pointer(cef_execute_process)                     := GetProcAddress(LibHandle, 'cef_execute_process');
    Pointer(cef_initialize)                          := GetProcAddress(LibHandle, 'cef_initialize');
    Pointer(cef_shutdown)                            := GetProcAddress(LibHandle, 'cef_shutdown');
    Pointer(cef_do_message_loop_work)                := GetProcAddress(LibHandle, 'cef_do_message_loop_work');
    Pointer(cef_run_message_loop)                    := GetProcAddress(LibHandle, 'cef_run_message_loop');
    Pointer(cef_quit_message_loop)                   := GetProcAddress(LibHandle, 'cef_quit_message_loop');
    Pointer(cef_set_osmodal_loop)                    := GetProcAddress(LibHandle, 'cef_set_osmodal_loop');
    Pointer(cef_enable_highdpi_support)              := GetProcAddress(LibHandle, 'cef_enable_highdpi_support');

    Pointer(cef_browser_host_create_browser)         := GetProcAddress(LibHandle, 'cef_browser_host_create_browser');
    Pointer(cef_browser_host_create_browser_sync)    := GetProcAddress(LibHandle, 'cef_browser_host_create_browser_sync');

    Pointer(cef_command_line_create)                 := GetProcAddress(LibHandle, 'cef_command_line_create');
    Pointer(cef_command_line_get_global)             := GetProcAddress(LibHandle, 'cef_command_line_get_global');

    Pointer(cef_drag_data_create)                    := GetProcAddress(LibHandle, 'cef_drag_data_create');

    Pointer(cef_cookie_manager_get_global_manager)   := GetProcAddress(LibHandle, 'cef_cookie_manager_get_global_manager');
    Pointer(cef_cookie_manager_create_manager)       := GetProcAddress(LibHandle, 'cef_cookie_manager_create_manager');

    Pointer(cef_crash_reporting_enabled)             := GetProcAddress(LibHandle, 'cef_crash_reporting_enabled');
    Pointer(cef_set_crash_key_value)                 := GetProcAddress(LibHandle, 'cef_set_crash_key_value');

    Pointer(cef_create_directory)                    := GetProcAddress(LibHandle, 'cef_create_directory');
    Pointer(cef_get_temp_directory)                  := GetProcAddress(LibHandle, 'cef_get_temp_directory');
    Pointer(cef_create_new_temp_directory)           := GetProcAddress(LibHandle, 'cef_create_new_temp_directory');
    Pointer(cef_create_temp_directory_in_directory)  := GetProcAddress(LibHandle, 'cef_create_temp_directory_in_directory');
    Pointer(cef_directory_exists)                    := GetProcAddress(LibHandle, 'cef_directory_exists');
    Pointer(cef_delete_file)                         := GetProcAddress(LibHandle, 'cef_delete_file');
    Pointer(cef_zip_directory)                       := GetProcAddress(LibHandle, 'cef_zip_directory');

    Pointer(cef_get_geolocation)                     := GetProcAddress(LibHandle, 'cef_get_geolocation');

    Pointer(cef_image_create)                        := GetProcAddress(LibHandle, 'cef_image_create');

    Pointer(cef_menu_model_create)                   := GetProcAddress(LibHandle, 'cef_menu_model_create');

    Pointer(cef_add_cross_origin_whitelist_entry)    := GetProcAddress(LibHandle, 'cef_add_cross_origin_whitelist_entry');
    Pointer(cef_remove_cross_origin_whitelist_entry) := GetProcAddress(LibHandle, 'cef_remove_cross_origin_whitelist_entry');
    Pointer(cef_clear_cross_origin_whitelist)        := GetProcAddress(LibHandle, 'cef_clear_cross_origin_whitelist');

    Pointer(cef_parse_url)                           := GetProcAddress(LibHandle, 'cef_parse_url');
    Pointer(cef_create_url)                          := GetProcAddress(LibHandle, 'cef_create_url');
    Pointer(cef_format_url_for_security_display)     := GetProcAddress(LibHandle, 'cef_format_url_for_security_display');
    Pointer(cef_get_mime_type)                       := GetProcAddress(LibHandle, 'cef_get_mime_type');
    Pointer(cef_get_extensions_for_mime_type)        := GetProcAddress(LibHandle, 'cef_get_extensions_for_mime_type');
    Pointer(cef_base64encode)                        := GetProcAddress(LibHandle, 'cef_base64encode');
    Pointer(cef_base64decode)                        := GetProcAddress(LibHandle, 'cef_base64decode');
    Pointer(cef_uriencode)                           := GetProcAddress(LibHandle, 'cef_uriencode');
    Pointer(cef_uridecode)                           := GetProcAddress(LibHandle, 'cef_uridecode');
    Pointer(cef_parse_json)                          := GetProcAddress(LibHandle, 'cef_parse_json');
    Pointer(cef_parse_jsonand_return_error)          := GetProcAddress(LibHandle, 'cef_parse_jsonand_return_error');
    Pointer(cef_write_json)                          := GetProcAddress(LibHandle, 'cef_write_json');

    Pointer(cef_get_path)                            := GetProcAddress(LibHandle, 'cef_get_path');

    Pointer(cef_print_settings_create)               := GetProcAddress(LibHandle, 'cef_print_settings_create');

    Pointer(cef_process_message_create)              := GetProcAddress(LibHandle, 'cef_process_message_create');

    Pointer(cef_launch_process)                      := GetProcAddress(LibHandle, 'cef_launch_process');

    Pointer(cef_request_create)                      := GetProcAddress(LibHandle, 'cef_request_create');
    Pointer(cef_post_data_create)                    := GetProcAddress(LibHandle, 'cef_post_data_create');
    Pointer(cef_post_data_element_create)            := GetProcAddress(LibHandle, 'cef_post_data_element_create');

    Pointer(cef_request_context_get_global_context)  := GetProcAddress(LibHandle, 'cef_request_context_get_global_context');
    Pointer(cef_request_context_create_context)      := GetProcAddress(LibHandle, 'cef_request_context_create_context');
    Pointer(cef_create_context_shared)               := GetProcAddress(LibHandle, 'cef_create_context_shared');

    Pointer(cef_resource_bundle_get_global)          := GetProcAddress(LibHandle, 'cef_resource_bundle_get_global');

    Pointer(cef_response_create)                     := GetProcAddress(LibHandle, 'cef_response_create');

    Pointer(cef_register_scheme_handler_factory)     := GetProcAddress(LibHandle, 'cef_register_scheme_handler_factory');
    Pointer(cef_clear_scheme_handler_factories)      := GetProcAddress(LibHandle, 'cef_clear_scheme_handler_factories');

    Pointer(cef_is_cert_status_error)                := GetProcAddress(LibHandle, 'cef_is_cert_status_error');
    Pointer(cef_is_cert_status_minor_error)          := GetProcAddress(LibHandle, 'cef_is_cert_status_minor_error');

    Pointer(cef_stream_reader_create_for_file)       := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_file');
    Pointer(cef_stream_reader_create_for_data)       := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_data');
    Pointer(cef_stream_reader_create_for_handler)    := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_handler');
    Pointer(cef_stream_writer_create_for_file)       := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_file');
    Pointer(cef_stream_writer_create_for_handler)    := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_handler');

    Pointer(cef_currently_on)                        := GetProcAddress(LibHandle, 'cef_currently_on');
    Pointer(cef_post_task)                           := GetProcAddress(LibHandle, 'cef_post_task');
    Pointer(cef_post_delayed_task)                   := GetProcAddress(LibHandle, 'cef_post_delayed_task');
    Pointer(cef_task_runner_get_for_current_thread)  := GetProcAddress(LibHandle, 'cef_task_runner_get_for_current_thread');
    Pointer(cef_task_runner_get_for_thread)          := GetProcAddress(LibHandle, 'cef_task_runner_get_for_thread');

    Pointer(cef_thread_create)                       := GetProcAddress(LibHandle, 'cef_thread_create');

    Pointer(cef_begin_tracing)                       := GetProcAddress(LibHandle, 'cef_begin_tracing');
    Pointer(cef_end_tracing)                         := GetProcAddress(LibHandle, 'cef_end_tracing');
    Pointer(cef_now_from_system_trace_time)          := GetProcAddress(LibHandle, 'cef_now_from_system_trace_time');

    Pointer(cef_urlrequest_create)                   := GetProcAddress(LibHandle, 'cef_urlrequest_create');

    Pointer(cef_register_extension)                  := GetProcAddress(LibHandle, 'cef_register_extension');
    Pointer(cef_v8context_get_current_context)       := GetProcAddress(LibHandle, 'cef_v8context_get_current_context');
    Pointer(cef_v8context_get_entered_context)       := GetProcAddress(LibHandle, 'cef_v8context_get_entered_context');
    Pointer(cef_v8context_in_context)                := GetProcAddress(LibHandle, 'cef_v8context_in_context');
    Pointer(cef_v8value_create_undefined)            := GetProcAddress(LibHandle, 'cef_v8value_create_undefined');
    Pointer(cef_v8value_create_null)                 := GetProcAddress(LibHandle, 'cef_v8value_create_null');
    Pointer(cef_v8value_create_bool)                 := GetProcAddress(LibHandle, 'cef_v8value_create_bool');
    Pointer(cef_v8value_create_int)                  := GetProcAddress(LibHandle, 'cef_v8value_create_int');
    Pointer(cef_v8value_create_uint)                 := GetProcAddress(LibHandle, 'cef_v8value_create_uint');
    Pointer(cef_v8value_create_double)               := GetProcAddress(LibHandle, 'cef_v8value_create_double');
    Pointer(cef_v8value_create_date)                 := GetProcAddress(LibHandle, 'cef_v8value_create_date');
    Pointer(cef_v8value_create_string)               := GetProcAddress(LibHandle, 'cef_v8value_create_string');
    Pointer(cef_v8value_create_object)               := GetProcAddress(LibHandle, 'cef_v8value_create_object');
    Pointer(cef_v8value_create_array)                := GetProcAddress(LibHandle, 'cef_v8value_create_array');
    Pointer(cef_v8value_create_function)             := GetProcAddress(LibHandle, 'cef_v8value_create_function');
    Pointer(cef_v8stack_trace_get_current)           := GetProcAddress(LibHandle, 'cef_v8stack_trace_get_current');

    Pointer(cef_value_create)                        := GetProcAddress(LibHandle, 'cef_value_create');
    Pointer(cef_binary_value_create)                 := GetProcAddress(LibHandle, 'cef_binary_value_create');
    Pointer(cef_dictionary_value_create)             := GetProcAddress(LibHandle, 'cef_dictionary_value_create');
    Pointer(cef_list_value_create)                   := GetProcAddress(LibHandle, 'cef_list_value_create');

    Pointer(cef_waitable_event_create)               := GetProcAddress(LibHandle, 'cef_waitable_event_create');

    Pointer(cef_visit_web_plugin_info)               := GetProcAddress(LibHandle, 'cef_visit_web_plugin_info');
    Pointer(cef_refresh_web_plugins)                 := GetProcAddress(LibHandle, 'cef_refresh_web_plugins');
    Pointer(cef_unregister_internal_web_plugin)      := GetProcAddress(LibHandle, 'cef_unregister_internal_web_plugin');
    Pointer(cef_register_web_plugin_crash)           := GetProcAddress(LibHandle, 'cef_register_web_plugin_crash');
    Pointer(cef_is_web_plugin_unstable)              := GetProcAddress(LibHandle, 'cef_is_web_plugin_unstable');
    Pointer(cef_register_widevine_cdm)               := GetProcAddress(LibHandle, 'cef_register_widevine_cdm');

    Pointer(cef_xml_reader_create)                   := GetProcAddress(LibHandle, 'cef_xml_reader_create');

    Pointer(cef_zip_reader_create)                   := GetProcAddress(LibHandle, 'cef_zip_reader_create');

    Pointer(cef_get_min_log_level)                   := GetProcAddress(LibHandle, 'cef_get_min_log_level');
    Pointer(cef_get_vlog_level)                      := GetProcAddress(LibHandle, 'cef_get_vlog_level');
    Pointer(cef_log)                                 := GetProcAddress(LibHandle, 'cef_log');

    Pointer(cef_get_current_platform_thread_id)      := GetProcAddress(LibHandle, 'cef_get_current_platform_thread_id');
    Pointer(cef_get_current_platform_thread_handle)  := GetProcAddress(LibHandle, 'cef_get_current_platform_thread_handle');

    Pointer(cef_time_now)                            := GetProcAddress(LibHandle, 'cef_time_now');

    Pointer(cef_trace_event_instant)                 := GetProcAddress(LibHandle, 'cef_trace_event_instant');
    Pointer(cef_trace_event_begin)                   := GetProcAddress(LibHandle, 'cef_trace_event_begin');
    Pointer(cef_trace_event_end)                     := GetProcAddress(LibHandle, 'cef_trace_event_end');
    Pointer(cef_trace_counter)                       := GetProcAddress(LibHandle, 'cef_trace_counter');
    Pointer(cef_trace_counter_id)                    := GetProcAddress(LibHandle, 'cef_trace_counter_id');
    Pointer(cef_trace_event_async_begin)             := GetProcAddress(LibHandle, 'cef_trace_event_async_begin');
    Pointer(cef_trace_event_async_step_into)         := GetProcAddress(LibHandle, 'cef_trace_event_async_step_into');
    Pointer(cef_trace_event_async_step_past)         := GetProcAddress(LibHandle, 'cef_trace_event_async_step_past');
    Pointer(cef_trace_event_async_end)               := GetProcAddress(LibHandle, 'cef_trace_event_async_end');

    Pointer(cef_version_info)                        := GetProcAddress(LibHandle, 'cef_version_info');
    Pointer(cef_api_hash)                            := GetProcAddress(LibHandle, 'cef_api_hash');

    {$IFDEF LINUX}
      Pointer(cef_get_xdisplay)                      := GetProcAddress(LibHandle, 'cef_get_xdisplay');
    {$ENDIF}

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
      Assigned(cef_string_utf16_to_lower) and
      Assigned(cef_string_utf16_to_upper) and

      Assigned(cef_string_list_alloc) and
      Assigned(cef_string_list_size) and
      Assigned(cef_string_list_value) and
      Assigned(cef_string_list_append) and
      Assigned(cef_string_list_clear) and
      Assigned(cef_string_list_free) and
      Assigned(cef_string_list_copy) and
      Assigned(cef_string_map_alloc) and
      Assigned(cef_string_map_size) and
      Assigned(cef_string_map_find) and
      Assigned(cef_string_map_key) and
      Assigned(cef_string_map_value) and
      Assigned(cef_string_map_append) and
      Assigned(cef_string_map_clear) and
      Assigned(cef_string_map_free) and
      Assigned(cef_string_multimap_alloc) and
      Assigned(cef_string_multimap_size) and
      Assigned(cef_string_multimap_find_count) and
      Assigned(cef_string_multimap_enumerate) and
      Assigned(cef_string_multimap_key) and
      Assigned(cef_string_multimap_value) and
      Assigned(cef_string_multimap_append) and
      Assigned(cef_string_multimap_clear) and
      Assigned(cef_string_multimap_free) and

      Assigned(cef_execute_process) and
      Assigned(cef_initialize) and
      Assigned(cef_shutdown) and
      Assigned(cef_do_message_loop_work) and
      Assigned(cef_run_message_loop) and
      Assigned(cef_quit_message_loop) and
      Assigned(cef_set_osmodal_loop) and
      Assigned(cef_enable_highdpi_support) and

      Assigned(cef_browser_host_create_browser) and
      Assigned(cef_browser_host_create_browser_sync) and

      Assigned(cef_command_line_create) and
      Assigned(cef_command_line_get_global) and

      Assigned(cef_drag_data_create) and

      Assigned(cef_cookie_manager_get_global_manager) and
      Assigned(cef_cookie_manager_create_manager) and

      Assigned(cef_crash_reporting_enabled) and
      Assigned(cef_set_crash_key_value) and

      Assigned(cef_create_directory) and
      Assigned(cef_get_temp_directory) and
      Assigned(cef_create_new_temp_directory) and
      Assigned(cef_create_temp_directory_in_directory) and
      Assigned(cef_directory_exists) and
      Assigned(cef_delete_file) and
      Assigned(cef_zip_directory) and

      Assigned(cef_get_geolocation) and

      Assigned(cef_image_create) and

      Assigned(cef_menu_model_create) and

      Assigned(cef_add_cross_origin_whitelist_entry) and
      Assigned(cef_remove_cross_origin_whitelist_entry) and
      Assigned(cef_clear_cross_origin_whitelist) and

      Assigned(cef_parse_url) and
      Assigned(cef_create_url) and
      Assigned(cef_format_url_for_security_display) and
      Assigned(cef_get_mime_type) and
      Assigned(cef_get_extensions_for_mime_type) and
      Assigned(cef_base64encode) and
      Assigned(cef_base64decode) and
      Assigned(cef_uriencode) and
      Assigned(cef_uridecode) and
      Assigned(cef_parse_json) and
      Assigned(cef_parse_jsonand_return_error) and
      Assigned(cef_write_json) and

      Assigned(cef_get_path) and

      Assigned(cef_print_settings_create) and

      Assigned(cef_process_message_create) and

      Assigned(cef_launch_process) and

      Assigned(cef_request_create) and
      Assigned(cef_post_data_create) and
      Assigned(cef_post_data_element_create) and

      Assigned(cef_request_context_get_global_context) and
      Assigned(cef_request_context_create_context) and
      Assigned(cef_create_context_shared) and

      Assigned(cef_resource_bundle_get_global) and

      Assigned(cef_response_create) and

      Assigned(cef_register_scheme_handler_factory) and
      Assigned(cef_clear_scheme_handler_factories) and

      Assigned(cef_is_cert_status_error) and
      Assigned(cef_is_cert_status_minor_error) and

      Assigned(cef_stream_reader_create_for_file) and
      Assigned(cef_stream_reader_create_for_data) and
      Assigned(cef_stream_reader_create_for_handler) and
      Assigned(cef_stream_writer_create_for_file) and
      Assigned(cef_stream_writer_create_for_handler) and

      Assigned(cef_currently_on) and
      Assigned(cef_post_task) and
      Assigned(cef_post_delayed_task) and
      Assigned(cef_task_runner_get_for_current_thread) and
      Assigned(cef_task_runner_get_for_thread) and

      Assigned(cef_thread_create) and

      Assigned(cef_begin_tracing) and
      Assigned(cef_end_tracing) and
      Assigned(cef_now_from_system_trace_time) and

      Assigned(cef_urlrequest_create) and

      Assigned(cef_register_extension) and
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

      Assigned(cef_value_create) and
      Assigned(cef_binary_value_create) and
      Assigned(cef_dictionary_value_create) and
      Assigned(cef_list_value_create) and

      Assigned(cef_waitable_event_create) and

      Assigned(cef_visit_web_plugin_info) and
      Assigned(cef_refresh_web_plugins) and
      Assigned(cef_unregister_internal_web_plugin) and
      Assigned(cef_register_web_plugin_crash) and
      Assigned(cef_is_web_plugin_unstable) and
      Assigned(cef_register_widevine_cdm) and

      Assigned(cef_xml_reader_create) and

      Assigned(cef_zip_reader_create) and

      Assigned(cef_get_min_log_level) and
      Assigned(cef_get_vlog_level) and
      Assigned(cef_log) and

      Assigned(cef_get_current_platform_thread_id) and
      Assigned(cef_get_current_platform_thread_handle) and
      Assigned(cef_time_now) and

      Assigned(cef_trace_event_instant) and
      Assigned(cef_trace_event_begin) and
      Assigned(cef_trace_event_end) and
      Assigned(cef_trace_counter) and
      Assigned(cef_trace_counter_id) and
      Assigned(cef_trace_event_async_begin) and
      Assigned(cef_trace_event_async_step_into) and
      Assigned(cef_trace_event_async_step_past) and
      Assigned(cef_trace_event_async_end) and

      Assigned(cef_version_info) and
      Assigned(cef_api_hash)

      {$IFDEF LINUX}
        and Assigned(cef_get_xdisplay)
      {$ENDIF}
    ) then raise Exception.Create('Unsupported CEF library version');

    {$IFDEF DEBUG}
    Debugln('-> loaded');
    {$ENDIF}

    Result := True;
  end
  Else
  begin
    {$IFDEF DEBUG}
    Debugln('-> already loaded');
    {$ENDIF}

    Result := False;
  end;
end;

procedure CefCloseLibrary;
begin
  {$IFDEF DEBUG}
  Debugln('CefCloseLibrary');
  {$ENDIF}
  If LibHandle <> 0 then
  begin
    {$IFDEF DEBUG}
    Debugln('-> Freed');
    {$ENDIF}

    FreeLibrary(LibHandle);
    LibHandle := 0;
  end
  {$IFDEF DEBUG}
  Else Debugln('-> not loaded.');
  {$ENDIF}
end;

Finalization
  CefCloseLibrary;

end.
