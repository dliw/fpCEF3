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
 * Original author: Dmitry Boyarintsev <skalogryz.lists@gmail.com>
 * Integrated from: http://github.com/skalogryz/fpCEF3
 * Repository: http://github.com/dliw/fpCEF3
 *
 *)

Unit cef3cocoa;

{$MODE objfpc}{$H+}
{$MODESWITCH objectivec1}

Interface

Uses
  CocoaAll;

Type

  { ***  cef_application_mac.h *** }

  // Copy of definition from base/message_loop/message_pump_mac.h.
  CrAppProtocol = objcprotocol
    function isHandlingSendEvent: Boolean; message 'isHandlingSendEvent';
  end;

  // Copy of definition from base/mac/scoped_sending_event.h.
  CrAppControlProtocol = objcprotocol(CrAppProtocol)
    procedure setHandlingSendEvent(handlingSendEvent: Boolean); message 'setHandlingSendEvent:';
  end;

  // All CEF client applications must subclass NSApplication and implement this
  // protocol.
  CefAppProtocol = objcprotocol(CrAppControlProtocol)
  end;


  { *** cefclient_mac.mm *** }

  ClientApplication = objcclass(NSApplication, CefAppProtocol)
    private
      handlingSendEvent_: Boolean;
      isHandling: Boolean;
    public
      function isHandlingSendEvent: Boolean;
      procedure setHandlingSendEvent(AHandling: Boolean);
      procedure sendEvent(aevent: NSEvent); override;
      procedure terminate(sender: id); override;
  end;

procedure InitCRApplication;

Implementation

procedure InitCRApplication;
begin
  ClientApplication.sharedApplication;
end;

{ ClientApplication }

function ClientApplication.isHandlingSendEvent: Boolean;
begin
  Result := handlingSendEvent_;
end;

procedure ClientApplication.setHandlingSendEvent(AHandling: Boolean);
begin
  handlingSendEvent_ := True;
end;

procedure ClientApplication.sendEvent(aevent: NSEvent);
var
  ishse: Boolean;
  app_: ClientApplication;
begin
  // CEF samples implement this via a C++ class
  app_ := ClientApplication(NSApplication.sharedApplication);
  ishse := app_.isHandlingSendEvent;
  app_.setHandlingSendEvent(true);

  inherited sendEvent(aevent);

  app_.setHandlingSendEvent(ishse);
end;

// |-terminate:| is the entry point for orderly "quit" operations in Cocoa. This
// includes the application menu's quit menu item and keyboard equivalent, the
// application's dock icon menu's quit menu item, "quit" (not "force quit") in
// the Activity Monitor, and quits triggered by user logout and system restart
// and shutdown.
//
// The default |-terminate:| implementation ends the process by calling exit(),
// and thus never leaves the main run loop. This is unsuitable for Chromium
// since Chromium depends on leaving the main run loop to perform an orderly
// shutdown. We support the normal |-terminate:| interface by overriding the
// default implementation. Our implementation, which is very specific to the
// needs of Chromium, works by asking the application delegate to terminate
// using its |-tryToTerminateApplication:| method.
//
// |-tryToTerminateApplication:| differs from the standard
// |-applicationShouldTerminate:| in that no special event loop is run in the
// case that immediate termination is not possible (e.g., if dialog boxes
// allowing the user to cancel have to be shown). Instead, this method tries to
// close all browsers by calling CloseBrowser(false) via
// ClientHandler::CloseAllBrowsers. Calling CloseBrowser will result in a call
// to ClientHandler::DoClose and execution of |-performClose:| on the NSWindow.
// DoClose sets a flag that is used to differentiate between new close events
// (e.g., user clicked the window close button) and in-progress close events
// (e.g., user approved the close window dialog). The NSWindowDelegate
// |-windowShouldClose:| method checks this flag and either calls
// CloseBrowser(false) in the case of a new close event or destructs the
// NSWindow in the case of an in-progress close event.
// ClientHandler::OnBeforeClose will be called after the CEF NSView hosted in
// the NSWindow is dealloc'ed.
//
// After the final browser window has closed ClientHandler::OnBeforeClose will
// begin actual tear-down of the application by calling CefQuitMessageLoop.
// This ends the NSApplication event loop and execution then returns to the
// main() function for cleanup before application termination.
//
// The standard |-applicationShouldTerminate:| is not supported, and code paths
// leading to it must be redirected.
procedure ClientApplication.terminate(sender: id);
begin
  // TODO: see what LCL does
  inherited terminate(sender);

  // don't exit and return. The application is responsible for exiting on its own.
end;

end.

