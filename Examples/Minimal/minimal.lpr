Program minimal;

{$MODE objfpc}{$H+}

Uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}cthreads,{$ENDIF}{$ENDIF}
  Classes, Glib2, Gdk2, Gtk2,
  cef3lib, cef3api, cef3class;

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

function idle(widget: PGtkWidget): gboolean; cdecl;
begin
  cef_do_message_loop_work;

  Result := true;
end;

procedure destroy(Widget: PGtkWidget; Data: gpointer); cdecl;
begin
  Host := Browser^.get_host(Browser);
  Host^.parent_window_will_close(Host);

  Release(Host^.base);
  Release(Browser^.base);

  gtk_main_quit;
  cef_shutdown;

  Client.Free;
end;

procedure bclicked(widget : PGtkWidget; data : gpointer); cdecl;
Var
  Dest : TCefString;
begin
  WriteLn('Reloading...');

  Dest := CefString('http://www.google.de');
  Frame := Browser^.get_main_frame(Browser);
  Frame^.load_url(Frame, @Dest);

  Release(Frame^.base);
end;

begin
  MainArgs.argc := argc;
  MainArgs.argv := argv;

  CefLoadLibrary;

  ExitCode := cef_execute_process(@MainArgs, nil);
  If ExitCode >= 0 then Halt(ExitCode);

  Settings.multi_threaded_message_loop := false;
  Settings.single_process := true;
  Settings.context_safety_implementation := 0;
  Settings.log_severity := LOGSEVERITY_VERBOSE;
  Settings.uncaught_exception_stack_size := 20;
  Settings.release_dcheck_enabled := true;

  cef_initialize(@MainArgs, @Settings, nil);

  gtk_init(nil, nil);

  // Window
  Window := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), 'CEF3 Bare Bones');
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 400);

  VBox := gtk_vbox_new(False, 0);
  gtk_container_add(GTK_CONTAINER(window), VBox);

  Button := gtk_button_new_with_label('Los');
  g_signal_connect (G_OBJECT (button), 'clicked', G_CALLBACK (@bclicked), PChar('run'));
  gtk_box_pack_start(GTK_BOX(VBox), Button, TRUE, TRUE, 0);


  info.parent_widget := VBox;
  Client := TCefClientOwn.Create;

  URL := CefString('');
  Browser := cef_browser_host_create_browser_sync(@info, Client.Wrap, @URL, @BrowserSettings);

  g_signal_connect(G_OBJECT(window), 'destroy', G_CALLBACK(@Destroy), nil);
  g_idle_add_full(G_PRIORITY_HIGH_IDLE,TGSourceFunc(@idle), Window, nil);

  gtk_widget_show_all(Window);

  gtk_main;
end.







Program test;

{$mode objfpc}{$H+}

{.$DEFINE MULTI}

Uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Math,
  cwstring, Messages, Glib2, Gdk2, Gtk2,
  cef3lib, cef3api_static, cef3intf, cef3class;




function CefStringAlloc(const str: ustring): TCefString;
begin
  FillChar(Result, SizeOf(Result), 0);
  If str <> '' then
    WriteLn('Status: ',cef_string_wide_to_utf16(PWideChar(str), Length(str), @Result) <> 0);
end;

function AsciiToCefString(const Value : String) : TCefString;
begin
  FillChar(Result, SizeOf(Result), 0);

  if Value <> '' then
    cef_string_ascii_to_utf16(PChar(Value), Length(Value), @Result);
end;



procedure destroy(Widget: PGtkWidget; Data: gpointer); cdecl;
begin
  WriteLn('Exiting...');
  WriteLn('RefCount: ',Client.RefCount);

  {$IFDEF MULTI}
  cef_shutdown;
  gtk_main_quit;
  {$ELSE}
  Host := Browser^.get_host(Browser);
  Host^.parent_window_will_close(Host);

  Release(Host^.base);
  Release(Browser^.base);

  cef_shutdown;

  gtk_main_quit;

  //cef_quit_message_loop;
  {$ENDIF}
end;

procedure bclicked(widget : PGtkWidget; data : gpointer); cdecl;
Var
  Dest : TCefString;
begin
  WriteLn('Reloading...');

  //Dest := CefString('http://localhost');
  Dest := AsciiToCefString('http://localhost');
  //Dest := AsciiToCefString('http://www.google.de');
  Frame := Browser^.get_main_frame(Browser);
  Frame^.load_url(Frame, @Dest);

  Release(Frame^.base);

  cef_do_message_loop_work;
end;

begin
  MainArgs.argc := argc;
  MainArgs.argv := argv;

  WriteLn(argv[1]);

  ExitCode := cef_execute_process(@MainArgs, nil);
  If ExitCode >= 0 then Halt(ExitCode);

  {$IFDEF MULTI}
  Settings.multi_threaded_message_loop := true;
  {$ELSE}
  Settings.multi_threaded_message_loop := false;
  {$ENDIF}
  Settings.single_process := false;
  Settings.context_safety_implementation := 0;
  Settings.log_severity := LOGSEVERITY_VERBOSE;
  Settings.uncaught_exception_stack_size := 20;
  Settings.release_dcheck_enabled := false;

  cef_initialize(@MainArgs, @Settings, nil);

  gtk_init(nil, nil);

  // Fenster
  Window := gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), 'CEF3 Bare Bones');
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 400);

  VBox := gtk_vbox_new(False, 0);
  gtk_container_add(GTK_CONTAINER(window), VBox);

  Button := gtk_button_new_with_label('Los');
  g_signal_connect (G_OBJECT (button), 'clicked', G_CALLBACK (@bclicked), PChar('run'));
  gtk_box_pack_start(GTK_BOX(VBox), Button, TRUE, TRUE, 0);

  g_signal_connect(G_OBJECT(window), 'destroy', G_CALLBACK(@Destroy), nil);


  info.parent_widget := VBox;
  Client := TCefClientOwn.Create;

  //URL := CefStringAlloc('http://www.google.de');
  //URL := AsciiToCefString('http://localhost');
  //URL := CefString('about:blank');
  URL := CefString('');


  {$IFDEF MULTI}
  cef_browser_host_create_browser(@info, Client.Wrap, @URL, @BrowserSettings);
  {$ELSE}
  Browser := cef_browser_host_create_browser_sync(@info, Client.Wrap, @URL, @BrowserSettings);
  g_idle_add_full(G_PRIORITY_DEFAULT_IDLE,TGSourceFunc(@idle), Window, nil);
  {$ENDIF}

  gtk_widget_show_all(Window);

  {$IFDEF MULTI}
  gtk_main;
  {$ELSE}

  gtk_main;

  //cef_run_message_loop;
  //cef_shutdown;
  {$ENDIF}
end.

(*








// CEF3 Bare Bones
// https://github.com/aphistic/cef3barebones
//
// For some details on what this code is doing, please see
// my blog post at:
// http://blog.erikd.org/2013/01/14/chromium-embedded-framework-3-bare-bones/
//
// PLEASE READ:
// Check out the README file for information about this code.
// TLDR version: This code is not good, it's the bare minimum you need and
// it's probably not correct in many (most?) cases.  It creates a window,
// loads some pages and that's it.

#include <gtk/gtk.h>

#include "include/cef_app.h"

#include "bareboneshandler.h"

CefRefPtr<BareBonesHandler> g_handler;

void destroy(void) {
  // Tells CEF to quit its message loop so the application can exit.
  CefQuitMessageLoop();
}

int main(int argc, char* argv[]) {
  CefMainArgs main_args(argc, argv);

  int exitCode = CefExecuteProcess(main_args, NULL);
  if (exitCode >= 0) {
    return exitCode;
  }

  CefSettings settings;
  CefInitialize(main_args, settings, NULL);

  gtk_init(&argc, &argv);

  window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "CEF3 Bare Bones");
  // Set the window to 400x400
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 400);

  vbox = gtk_vbox_new(FALSE, 0);
  gtk_container_add(GTK_CONTAINER(window), vbox);

  hbox = gtk_hbox_new(FALSE, 0);
  gtk_box_pack_start(GTK_BOX(vbox), hbox, TRUE, TRUE, 0);

  g_signal_connect(window, "destroy", G_CALLBACK(destroy), NULL);

  CefBrowserSettings browserSettings;
  CefWindowInfo info;

  g_handler = new BareBonesHandler();

  info.SetAsChild(hbox);
  CefBrowserHost::CreateBrowserSync(info, g_handler.get(),
    "http://code.google.com", browserSettings);
  CefBrowserHost::CreateBrowserSync(info, g_handler.get(),
    "http://www.github.com", browserSettings);

  info.SetAsChild(vbox);
  CefBrowserHost::CreateBrowserSync(info, g_handler.get(),
    "http://www.google.com", browserSettings);

  gtk_widget_show_all(window);

  CefRunMessageLoop();

  CefShutdown();

  return 0;
}

*)


