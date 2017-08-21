Program minimal;

{$MODE objfpc}{$H+}

Uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Classes, sysutils,
  Glib2, Gtk2, gdk2x, xlib, x,
  cef3types, cef3lib, cef3api, cef3ref, cef3own;

Var
  Window : PGtkWidget;
  VBox   : PGtkWidget;
  Button : PGtkWidget;

  ButtonHeight: Integer;

  MainArgs : TCefMainArgs;
  Settings : TCefSettings;
  ExitCode : Integer;

  BrowserSettings : TCefBrowserSettings;
  Info            : TCefWindowInfo;

  URL             : TCefString;

  Client          : TCefClientOwn;

  Browser         : PCefBrowser;
  Frame           : PCefFrame;
  Host            : PCefBrowserHost;

procedure Release(var base : TCefBaseRefCounted);
begin
  base.release(@base);
end;

procedure size_allocated(widget: PGtkWidget; allocation: PGtkAllocation; data: Pointer); cdecl;
begin
  ButtonHeight := allocation^.height;
end;

procedure vbox_resize(widget: PGtkWidget; allocation: PGtkAllocation; data: Pointer); cdecl;
Var
  xdisplay: PXDisplay;
  xwindow: TWindow;
  changes: TXWindowChanges;
begin
  info.x := allocation^.x;
  info.y := allocation^.y + ButtonHeight;
  info.width := allocation^.width;
  info.height := allocation^.height - ButtonHeight;

  If Assigned(Browser) then
  begin
    Host := Browser^.get_host(Browser);
    xwindow := Host^.get_window_handle(Host);

    xdisplay := cef_get_xdisplay();

    changes.x := info.x;
    changes.y := info.y;
    changes.width := info.width;
    changes.height := info.height;

    XConfigureWindow(xdisplay, xwindow, CWX or CWY or CWHeight or CWWidth, @changes);

    Release(Host^.base);
  end;
end;

function idle(widget: PGtkWidget): gboolean; cdecl;
begin
  cef_do_message_loop_work();

  Result := true;
end;

procedure destroy(widget: PGtkWidget; data: gpointer); cdecl;
begin
  gtk_main_quit;
end;

procedure bclicked(widget : PGtkWidget; data : gpointer); cdecl;
Var
  Dest : TCefString;
begin
  WriteLn('Reloading...');

  Dest := CefString('http://youtube.com');
  Frame := Browser^.get_main_frame(Browser);
  Frame^.load_url(Frame, @Dest);

  Release(Frame^.base);
end;

begin
  MainArgs.argc := argc;
  MainArgs.argv := argv;

  CefLoadLibrary;

  ExitCode := cef_execute_process(@MainArgs, nil, nil);
  If ExitCode >= 0 then Halt(ExitCode);

  gtk_init(nil, nil);

  // Install xlib error handlers so that the application won't be terminated
  // on non-fatal errors.
  XSetErrorHandler(@XErrorHandler);
  XSetIOErrorHandler(@XIOErrorHandler);

  Settings.size := SizeOf(Settings);
  Settings.single_process := Ord(False);
  Settings.no_sandbox := Ord(True);
  Settings.multi_threaded_message_loop := Ord(False);
  Settings.log_severity := LOGSEVERITY_INFO;
  Settings.uncaught_exception_stack_size := 20;
  Settings.context_safety_implementation := 0;

  cef_initialize(@MainArgs, @Settings, nil, nil);

  // Window
  Window := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), 'CEF3 Bare Bones');
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 400);

  VBox := gtk_vbox_new(False, 0);
  g_signal_connect(G_OBJECT(VBox), 'size-allocate', G_CALLBACK(@vbox_resize), nil);
  gtk_container_add(GTK_CONTAINER(window), VBox);

  Button := gtk_button_new_with_label('Go');
  g_signal_connect (G_OBJECT(Button), 'clicked', G_CALLBACK(@bclicked), PChar('go'));
  g_signal_connect(G_OBJECT(Button), 'size-allocate', G_CALLBACK(@size_allocated), nil);
  gtk_box_pack_start(GTK_BOX(VBox), Button, False, False, 0);

  gtk_widget_show_all(Window);

  info.parent_window := GDK_WINDOW_XID(VBox^.window);

  Client := TCefClientOwn.Create;
  URL := CefString('chrome://version');
  Browser := cef_browser_host_create_browser_sync(@info, Client.Wrap, @URL, @BrowserSettings, nil);

  g_signal_connect(G_OBJECT(window), 'destroy', G_CALLBACK(@Destroy), nil);
  g_idle_add_full(G_PRIORITY_HIGH_IDLE,TGSourceFunc(@idle), Window, nil);

  // main loop
  gtk_main;

  // cleanup
  Host := Browser^.get_host(Browser);
  Host^.close_browser(Host, 1);

  Release(Host^.base);
  Release(Browser^.base);

  cef_shutdown();
end.
