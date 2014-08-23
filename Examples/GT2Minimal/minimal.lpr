Program minimal;

{$MODE objfpc}{$H+}

Uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Classes, sysutils, Glib2, Gtk2,
  cef3types, cef3lib, cef3api, cef3ref, cef3own;

Var
  Window : PGtkWidget;
  VBox   : PGtkWidget;
  Button : PGtkWidget;

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

procedure Release(var base : TCefBase);
begin
  base.release(@base);
end;

function idle(Widget: PGtkWidget): gboolean; cdecl;
begin
  cef_do_message_loop_work;

  Result := true;
end;

procedure destroy(Widget: PGtkWidget; Data: gpointer); cdecl;
begin
  gtk_main_quit;
end;

procedure bclicked(widget : PGtkWidget; data : gpointer); cdecl;
Var
  Dest : TCefString;
begin
  WriteLn('Reloading...');

  Dest := CefString('http://youtube.de');
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

  Settings.multi_threaded_message_loop := False;
  Settings.single_process := False;
  Settings.context_safety_implementation := 0;
  Settings.log_severity := LOGSEVERITY_INFO;
  Settings.uncaught_exception_stack_size := 20;
  Settings.release_dcheck_enabled := TRUE;

  cef_initialize(@MainArgs, @Settings, nil, nil);

  gtk_init(nil, nil);

  // Window
  Window := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), 'CEF3 Bare Bones');
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 400);

  VBox := gtk_vbox_new(False, 0);
  gtk_container_add(GTK_CONTAINER(window), VBox);

  Button := gtk_button_new_with_label('Go');
  g_signal_connect (G_OBJECT (button), 'clicked', G_CALLBACK (@bclicked), PChar('go'));
  gtk_box_pack_start(GTK_BOX(VBox), Button, TRUE, TRUE, 0);


  info.parent_widget := VBox;
  Client := TCefClientOwn.Create;

  URL := CefString('');
  Browser := cef_browser_host_create_browser_sync(@info, Client.Wrap, @URL, @BrowserSettings, nil);

  g_signal_connect(G_OBJECT(window), 'destroy', G_CALLBACK(@Destroy), nil);
  g_idle_add_full(G_PRIORITY_HIGH_IDLE,TGSourceFunc(@idle), Window, nil);

  gtk_widget_show_all(Window);

  // main loop
  gtk_main;

  // cleanup
  Host := Browser^.get_host(Browser);
  Host^.close_browser(Host, 1);

  Release(Host^.base);
  Release(Browser^.base);

  cef_shutdown;
end.
