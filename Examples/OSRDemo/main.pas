Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType, ExtCtrls,
  BGRABitmap, BGRABitmapTypes,
  cef3types, cef3lib, cef3intf, cef3osr;

Type

  { TMainform }

  TMainform = class(TForm)
    BGo : TButton;
    Chromium : TChromiumOSR;
    EUrl : TEdit;
    LUrl : TStaticText;
    PaintBox : TPaintBox;
    procedure BGoClick(Sender : TObject);
    procedure ChromiumGetRootScreenRect(Sender : TObject;
      const Browser : ICefBrowser; rect : PCefRect; out Result : Boolean);
    procedure ChromiumGetViewRect(Sender : TObject;
      const Browser : ICefBrowser; rect : PCefRect; out Result : Boolean);
    procedure ChromiumPaint(Sender : TObject; const Browser : ICefBrowser; kind : TCefPaintElementType;
      dirtyRectsCount : Cardinal; const dirtyRects : PCefRectArray; const buffer : Pointer;
      awidth, aheight : Integer);
    procedure EUrlKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
    procedure FormCreate(Sender : TObject);
    procedure PaintBoxMouseDown(Sender : TObject; Button : TMouseButton;
      Shift : TShiftState; X, Y : Integer);
    procedure PaintBoxMouseMove(Sender : TObject; Shift : TShiftState;
      X, Y : Integer);
    procedure PaintBoxMouseUp(Sender : TObject; Button : TMouseButton;
      Shift : TShiftState; X, Y : Integer);
    procedure PaintBoxMouseWheel(Sender : TObject; Shift : TShiftState;
      WheelDelta : Integer; MousePos : TPoint; var Handled : Boolean);
    procedure PaintBoxResize(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

Var
  Mainform : TMainform;

Implementation

{$R *.lfm}

function getModifiers(Shift: TShiftState): TCefEventFlags;
begin
  Result := [];
  if ssShift in Shift then Include(Result, EVENTFLAG_SHIFT_DOWN);
  if ssAlt in Shift then Include(Result, EVENTFLAG_ALT_DOWN);
  if ssCtrl in Shift then Include(Result, EVENTFLAG_CONTROL_DOWN);
  if ssLeft in Shift then Include(Result, EVENTFLAG_LEFT_MOUSE_BUTTON);
  if ssRight in Shift then Include(Result, EVENTFLAG_RIGHT_MOUSE_BUTTON);
  if ssMiddle in Shift then Include(Result, EVENTFLAG_MIDDLE_MOUSE_BUTTON);
end;

function getButton(Button: TMouseButton): TCefMouseButtonType;
begin
  Case Button of
    TMouseButton.mbLeft: Result := MBT_LEFT;
    TMouseButton.mbRight: Result := MBT_RIGHT;
    TMouseButton.mbMiddle: Result := MBT_MIDDLE;
  end;
end;

{ TMainform }

procedure TMainform.BGoClick(Sender : TObject);
begin
  Chromium.Load(EUrl.Text);
end;

procedure TMainform.ChromiumGetRootScreenRect(Sender : TObject; const Browser : ICefBrowser;
  rect : PCefRect; out Result : Boolean);
begin
  rect^.x := 0;
  rect^.y := 0;
  rect^.width := PaintBox.Width;
  rect^.height := PaintBox.Height;
  Result := True;
end;

procedure TMainform.ChromiumGetViewRect(Sender : TObject; const Browser : ICefBrowser;
  rect : PCefRect; out Result : Boolean);
Var
  Point: TPoint;
begin
  Point.X := 0;
  Point.Y := 0;

  Point := PaintBox.ClientToScreen(Point);

  rect^.x := Point.X;
  rect^.y := Point.Y;
  rect^.height := PaintBox.Height;
  rect^.width := PaintBox.Width;

  Result := True;
end;

procedure TMainform.ChromiumPaint(Sender : TObject; const Browser : ICefBrowser;
  kind : TCefPaintElementType; dirtyRectsCount : Cardinal; const dirtyRects : PCefRectArray;
  const buffer : Pointer; awidth, aheight : Integer);
Var
  Rect : TRect;
begin
  // Much more intelligent implementation possible here

  {$IFDEF WINDOWS}
  Rect.Bottom := aheight;
  Rect.Top := 0;
  {$ELSE}
  Rect.Bottom := 0;
  Rect.Top := aheight;
  {$ENDIF}
  Rect.Left := 0;
  Rect.Right := awidth;

  PaintBox.Canvas.Lock;
  BGRABitmapDraw(PaintBox.Canvas, Rect, buffer, False, awidth, aheight, False);
  PaintBox.Canvas.Unlock;
end;

procedure TMainform.EUrlKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

procedure TMainform.PaintBoxMouseDown(Sender : TObject; Button : TMouseButton;
  Shift : TShiftState; X, Y : Integer);
Var
  MouseEvent: TCefMouseEvent;
begin
  MouseEvent.x := X;
  MouseEvent.y := Y;
  MouseEvent.modifiers := getModifiers(Shift);
  Chromium.Browser.Host.SendMouseClickEvent(MouseEvent, getButton(Button), False, 1);
end;

procedure TMainform.PaintBoxMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Var
  MouseEvent: TCefMouseEvent;
begin
  MouseEvent.x := X;
  MouseEvent.y := Y;
  MouseEvent.modifiers := getModifiers(Shift);

  Chromium.Browser.Host.SendMouseMoveEvent(MouseEvent, not PaintBox.MouseEntered);
end;

procedure TMainform.PaintBoxMouseUp(Sender : TObject; Button : TMouseButton;
  Shift : TShiftState; X, Y : Integer);
Var
  MouseEvent: TCefMouseEvent;
begin
  MouseEvent.x := X;
  MouseEvent.y := Y;
  MouseEvent.modifiers := getModifiers(Shift);
  Chromium.Browser.Host.SendMouseClickEvent(MouseEvent, getButton(Button), True, 1);
end;

procedure TMainform.PaintBoxMouseWheel(Sender : TObject; Shift : TShiftState; WheelDelta : Integer;
  MousePos : TPoint; var Handled : Boolean);
Var
  MouseEvent: TCefMouseEvent;
begin
  MouseEvent.x := MousePos.X;
  MouseEvent.y := MousePos.Y;
  MouseEvent.modifiers := getModifiers(Shift);

  Chromium.Browser.Host.SendMouseWheelEvent(MouseEvent, 0, WheelDelta);
  Handled := True;
end;

procedure TMainform.PaintBoxResize(Sender : TObject);
begin
  Chromium.Browser.Host.WasResized;
  Chromium.Browser.Host.SendFocusEvent(1);
  Application.ProcessMessages;
end;

procedure TMainform.FormCreate(Sender : TObject);
begin
  {$INFO subprocess is set here, uncomment to use a subprocess}
  //CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};
end;

end.
