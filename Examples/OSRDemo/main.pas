Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, OpenGLContext, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType,
  GL, GLext,
  cef3types, cef3lib, cef3intf, cef3osr;

Type

  { TMainform }

  TMainform = class(TForm)
    BGo : TButton;
    CBAnimate: TCheckBox;
    CBShowUpdate: TCheckBox;
    Chromium : TChromiumOSR;
    EUrl : TEdit;
    LUrl : TStaticText;
    OSRPanel: TOpenGLControl;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure BGoClick(Sender : TObject);
    procedure CBAnimateChange(Sender: TObject);
    procedure ChromiumGetScreenPoint(Sender: TObject; const Browser: ICefBrowser;
      viewX, viewY: Integer; screenX, screenY: PInteger; out Result: Boolean);
    procedure ChromiumGetViewRect(Sender : TObject;
      const Browser : ICefBrowser; rect : PCefRect; out Result : Boolean);
    procedure ChromiumPaint(Sender : TObject; const Browser : ICefBrowser; kind : TCefPaintElementType;
      dirtyRectsCount : Cardinal; const dirtyRects : TCefRectArray; const buffer : Pointer;
      awidth, aheight : Integer);
    procedure EUrlKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OSRPanelEnter(Sender: TObject);
    procedure OSRPanelExit(Sender: TObject);
    procedure OSRPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure OSRPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OSRPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure OSRPanelMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint; var Handled: Boolean);
    procedure OSRPanelPaint(Sender: TObject);
    procedure OSRPanelResize(Sender: TObject);
  private
    fGLInitialized: Boolean;
    fTextureID: GLuint;
    fTextureWidth, fTextureHeigth: Integer;
    fUpdateRect: TCefRect;

    procedure InitializeGL;
  public
    { public declarations }
  end;

Var
  Mainform : TMainform;

Implementation

{$R *.lfm}

function getModifiers(const Shift: TShiftState): TCefEventFlags;
begin
  Result := [];
  If ssShift in Shift then Include(Result, EVENTFLAG_SHIFT_DOWN);
  If ssCaps in Shift then Include(Result, EVENTFLAG_CAPS_LOCK_ON);
  If ssCtrl in Shift then Include(Result, EVENTFLAG_CONTROL_DOWN);
  If ssAlt in Shift then Include(Result, EVENTFLAG_ALT_DOWN);
  If ssLeft in Shift then Include(Result, EVENTFLAG_LEFT_MOUSE_BUTTON);
  If ssMiddle in Shift then Include(Result, EVENTFLAG_MIDDLE_MOUSE_BUTTON);
  If ssRight in Shift then Include(Result, EVENTFLAG_RIGHT_MOUSE_BUTTON);
end;

function getButton(const Button: TMouseButton): TCefMouseButtonType;
begin
  Case Button of
    TMouseButton.mbLeft: Result := MBT_LEFT;
    TMouseButton.mbRight: Result := MBT_RIGHT;
    TMouseButton.mbMiddle: Result := MBT_MIDDLE;
  end;
end;

{ TMainform }

procedure TMainform.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  OSRPanel.Invalidate;
end;

procedure TMainform.BGoClick(Sender : TObject);
begin
  Chromium.Load(EUrl.Text);
end;

procedure TMainform.CBAnimateChange(Sender: TObject);
begin
  If CBAnimate.Checked then Application.OnIdle := @AppOnIdle
  Else
  begin
    Application.OnIdle := nil;
    OSRPanel.Invalidate;
  end;
end;

procedure TMainform.ChromiumGetScreenPoint(Sender: TObject; const Browser: ICefBrowser;
  viewX, viewY: Integer; screenX, screenY: PInteger; out Result: Boolean);
Var
  Point: TPoint;
begin
  Point.X := viewX;
  Point.Y := viewY;

  Point := OSRPanel.ClientToScreen(Point);

  screenX^ := Point.X;
  screenY^ := Point.Y;

  Result := True;
end;

procedure TMainform.ChromiumGetViewRect(Sender : TObject; const Browser : ICefBrowser;
  rect : PCefRect; out Result : Boolean);
begin
  rect^.x := 0;
  rect^.y := 0;
  rect^.width := OSRPanel.Width;
  rect^.height := OSRPanel.Height;

  Result := True;
end;

procedure TMainform.ChromiumPaint(Sender: TObject; const Browser: ICefBrowser;
  kind: TCefPaintElementType; dirtyRectsCount: Cardinal; const dirtyRects: TCefRectArray;
  const buffer: Pointer; awidth, aheight: Integer);

function RectIsFullView(const Rect: TCefRect): Boolean;
begin
  Result := (Rect.x = 0) and (Rect.y = 0) and (Rect.width = awidth) and (Rect.height = aheight);
end;

Var
  i: Integer;
  ARect: TCefRect;

begin
  If not fGLInitialized then InitializeGL;

  // enable alpha blending
  glEnable(GL_BLEND);

  // enable 2D textures
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, fTextureID);

  If kind = PET_VIEW then
  begin

    If CBShowUpdate.Checked then fUpdateRect := dirtyRects[0];

    glPixelStorei(GL_UNPACK_ROW_LENGTH, awidth);

    If (fTextureWidth <> awidth) or (fTextureHeigth <> aheight) or
      ((dirtyRectsCount = 1) and RectIsFullView(dirtyRects[0])) then
    begin
      // update / resize the whole texture

      glPixelStorei(GL_UNPACK_SKIP_PIXELS, 0);
      glPixelStorei(GL_UNPACK_SKIP_ROWS, 0);
      glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, awidth, aheight, 0, GL_BGRA,
        GL_UNSIGNED_INT_8_8_8_8_REV, buffer);

      fTextureWidth := awidth;
      fTextureHeigth := aheight;
    end
    Else
    begin
      // update just the dirty rectangles
      For i := 0 to dirtyRectsCount - 1 do
      begin
        ARect := dirtyRects[i];

        Assert(ARect.x + ARect.width <= fTextureWidth);
        Assert(Arect.y + ARect.height <= fTextureHeigth);

        glPixelStorei(GL_UNPACK_SKIP_PIXELS, ARect.x);
        glPixelStorei(GL_UNPACK_SKIP_ROWS, ARect.y);
        glTexSubImage2D(GL_TEXTURE_2D, 0, ARect.x, ARect.y, ARect.width, ARect.height,
          GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, buffer);
      end;
    end;
  end;

  // disable 2D textures.
  glDisable(GL_TEXTURE_2D);

  // disable alpha blending
  glDisable(GL_BLEND);

  OSRPanel.Invalidate;
end;

procedure TMainform.EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

procedure TMainform.FormCreate(Sender : TObject);
begin
  {$IFNDEF DARWIN}
    {$INFO subprocess is set here, uncomment to use a subprocess}
    //CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};
  {$ENDIF}

  fTextureWidth := 0;
  fTextureHeigth := 0;

  CBAnimateChange(Self);
end;

procedure TMainform.FormDestroy(Sender: TObject);
begin
  If fGLInitialized then glDeleteTextures(1, @fTextureID);
end;

procedure TMainform.OSRPanelEnter(Sender: TObject);
begin
  Chromium.Browser.Host.SendFocusEvent(True);
end;

procedure TMainform.OSRPanelExit(Sender: TObject);
begin
  Chromium.Browser.Host.SendFocusEvent(False);
end;

procedure TMainform.OSRPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
Var
  MouseEvent: TCefMouseEvent;
begin
  OSRPanel.SetFocus;

  MouseEvent.x := X;
  MouseEvent.y := Y;
  MouseEvent.modifiers := getModifiers(Shift);

  Chromium.Browser.Host.SendMouseClickEvent(MouseEvent, getButton(Button), False, 1);
end;

procedure TMainform.OSRPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var
  MouseEvent: TCefMouseEvent;
begin
  MouseEvent.x := X;
  MouseEvent.y := Y;
  MouseEvent.modifiers := getModifiers(Shift);

  Chromium.Browser.Host.SendMouseMoveEvent(MouseEvent, not OSRPanel.MouseEntered);
end;

procedure TMainform.OSRPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
Var
  MouseEvent: TCefMouseEvent;
  ClickCount: Integer;
begin
  MouseEvent.x := X;
  MouseEvent.y := Y;
  MouseEvent.modifiers := getModifiers(Shift);

  ClickCount := 1;
  If ssDouble in Shift then ClickCount := 2;
  If ssTriple in Shift then ClickCount := 3;
  If ssQuad   in Shift then ClickCount := 4;

  Chromium.Browser.Host.SendMouseClickEvent(MouseEvent, getButton(Button), True, ClickCount);
end;

procedure TMainform.OSRPanelMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
Var
  MouseEvent: TCefMouseEvent;
begin
  MouseEvent.x := MousePos.X;
  MouseEvent.y := MousePos.Y;
  MouseEvent.modifiers := getModifiers(Shift);

  Chromium.Browser.Host.SendMouseWheelEvent(MouseEvent, 0, WheelDelta);
  Handled := True;
end;

procedure TMainform.OSRPanelPaint(Sender: TObject);

function RectEmpty(const ARect: TCefRect): Boolean;
begin
  Result := (ARect.x = 0) and (ARect.y = 0) and (ARect.width = 0) and (ARect.height = 0);
end;

Type
  TVertex = packed record
    tu, tv: Single;
    x, y, z: Single;
  end;
Const
  Vertices : array[0..3] of TVertex = (
    (tu: 0.0; tv: 1.0; x: -1.0; y: -1.0; z: 0.0),
    (tu: 1.0; tv: 1.0; x:  1.0; y: -1.0; z: 0.0),
    (tu: 1.0; tv: 0.0; x:  1.0; y:  1.0; z: 0.0),
    (tu: 0.0; tv: 0.0; x: -1.0; y:  1.0; z: 0.0)
   );
Var
  ULeft, URight, UTop, UBottom: Integer;
begin
  If not fGLInitialized then Exit;

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  // Match GL units to screen coordinates.
  glViewport(0, 0, OSRPanel.Width, OSRPanel.Height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  // rotate the view
  If CBAnimate.Checked then
  begin
    glRotatef(20 * sin(GetTickCount64 * 0.001), 1, 0, 0);
    glRotatef(20 * cos(GetTickCount64 * 0.001), 0, 1, 0);
  end;

  // alpha blending style: texture values have premultiplied alpha
  glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

  // enable alpha blending
  glEnable(GL_BLEND);

  // enable 2D textures.
  glEnable(GL_TEXTURE_2D);

  // draw the facets with the texture.
  glBindTexture(GL_TEXTURE_2D, fTextureID);
  glInterleavedArrays(GL_T2F_V3F, 0, @Vertices);
  glDrawArrays(GL_QUADS, 0, 4);

  // disable 2D textures.
  glDisable(GL_TEXTURE_2D);

  // disable alpha blending
  glDisable(GL_BLEND);


  If CBShowUpdate.Checked and not RectEmpty(fUpdateRect) then
  begin
    // draw a rectangle around the update region
    ULeft := fUpdateRect.x + 1;
    URight := fUpdateRect.x + fUpdateRect.width;
    UTop := fUpdateRect.y;
    UBottom := fUpdateRect.y + fUpdateRect.height - 1;

    glPushAttrib(GL_ALL_ATTRIB_BITS);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrtho(0, OSRPanel.Width, OSRPanel.Height, 0, 0, 1);

    glLineWidth(1);
    glColor3f(1, 0, 0);

    glBegin(GL_LINE_STRIP);
      glVertex2i(ULeft, UTop);
      glVertex2i(URight, UTop);
      glVertex2i(URight, UBottom);
      glVertex2i(ULeft, UBottom);
      glVertex2i(ULeft, UTop);
    glEnd();

    glPopMatrix();
    glPopAttrib();
  end;

  OSRPanel.SwapBuffers;
end;

procedure TMainform.OSRPanelResize(Sender: TObject);
begin
  Chromium.Browser.Host.WasResized;
end;

procedure TMainform.InitializeGL;
Var
  BC: TColor;
begin
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

  BC := Chromium.BackgroundColor;
  glClearColor(Red(BC) / 255, Green(BC) / 255, Blue(BC) / 255, 1);

  // necessary for non-power-of-2 textures to render correctly
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

  // create the texture
  glGenTextures(1, @fTextureID);

  glBindTexture(GL_TEXTURE_2D, fTextureID);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  fGLInitialized := True;
end;

Initialization
  {$IFDEF DARWIN}
    CefBrowserSubprocessPath := ExtractFileDir(ExtractFileDir(ExpandFileName(Paramstr(0)))) +
      PathDelim + 'Frameworks/subprocess.app/Contents/MacOS/subprocess';
  {$ENDIF}

end.
