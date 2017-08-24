Unit WebPanel;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Controls, ComCtrls, FileUtil, Forms, LCLProc, Graphics, Dialogs,
  LazUTF8, LazFileUtils, strutils,
  cef3types, cef3lib, cef3intf, cef3own, cef3lcl,
  FaviconGetter;

Type

  TWebPanel = class(TTabSheet)
  private
    fChromium: TChromium;
    fUrl: String;
    fIconGetter: TFaviconGetter;

    procedure ChromiumTakeFocus(Sender: TObject; const Browser: ICefBrowser; next_: Boolean);
    procedure ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser; const title: ustring);
    procedure ChromiumAddressChange(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; const url: ustring);
    procedure ChromiumFaviconUrlchange(Sender: TObject; const Browser: ICefBrowser; iconUrls: TStrings);
    procedure ChromiumOpenUrlFromTab(Sender: TObject; browser: ICefBrowser; frame: ICefFrame;
      const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean;
      out Result: Boolean);
    procedure ChromiumBeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo; var client: ICefClient;
      var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean; out Result: Boolean);

    procedure ChromiumBeforeContextMenu(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure ChromiumContextMenuCommand(Sender: TObject; const Browser: ICefBrowser;
      const Frame: ICefFrame; const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: TCefEventFlags; out Result: Boolean);

    procedure ChromiumFileDialog(Sender: TObject; const Browser: ICefBrowser;
      mode: TCefFileDialogMode; const title, defaultFileName: ustring; acceptFilters: TStrings;
      selectedAcceptFilter: Integer; const callback: ICefFileDialogCallback; out Result: Boolean);

    procedure ChromiumBeforeDownload(Sender: TObject; const Browser: ICefBrowser;
      const downloadItem: ICefDownloadItem; const suggestedName: ustring;
      const callback: ICefBeforeDownloadCallback);

    procedure PrintToPdf(const Browser: ICefBrowser);

    procedure IconReady(const Success: Boolean; const Icon: TIcon);
  protected
    procedure DoHide; override;
    procedure DoShow; override;
  public
    destructor Destroy; override;

    procedure InitializeChromium(DefaultUrl: String = '');
    procedure RequestClose;

    procedure OpenUrl(AUrl: String);
    procedure SetIcon(const Icon: TCustomIcon);

    property Url: String read fUrl write fUrl;
  end;

  { custom browser process handler }
  TCustomBrowserProcessHandler = class(TCefBrowserProcessHandlerOwn)
    private
      fPrintHandler: ICefPrintHandler;
    protected
      function GetPrintHandler: ICefPrintHandler; override;
    public
      constructor Create; override;
  end;


Implementation

Uses Main, cef3ref, cef3scp, SchemeHandler
  {$IFDEF LINUX}, PrintHandler{$ENDIF};

Const
  // client menu IDs
  CLIENT_ID_VISIT_COOKIES = MENU_ID_USER_FIRST + 0;
  CLIENT_ID_PRINT_TO_PDF  = MENU_ID_USER_FIRST + 1;
  CLIENT_ID_EXIT          = MENU_ID_USER_FIRST + 2;

Type

  TCefNewTabTask = class(TCefTaskOwn)
  protected
    fTargetUrl: ustring;
    procedure Execute; override;
  public
    constructor Create(targetURL: ustring); reintroduce;
  end;


Var Path: ustring;

function VisitCookies(const cookie: TCefCookie; count, total: Integer;
  out deleteCookie: Boolean): Boolean;
Var
  tmp: TCefString;
begin
  Write(count + 1, '/', total, ': ');

  tmp := cookie.path;
  Write(CefString(@tmp), ' ');

  tmp := cookie.name;
  Write(CefString(@tmp), ' ');

  tmp := cookie.domain;
  Write(CefString(@tmp), ' ');

  try
    WriteLn(DateTimeToStr(CefTimeToDateTime(cookie.expires)));
  except
    WriteLn('Invalid datetime.');
  end;

  deleteCookie := False;
  Result := True;
end;

{ TCefNewTabTask }

procedure TCefNewTabTask.Execute;
begin
  Assert(CefCurrentlyOn(TID_UI));

  FMain.NewTab(UTF8Encode(fTargetUrl));
end;

constructor TCefNewTabTask.Create(targetURL: ustring);
begin
  inherited Create;

  fTargetUrl := targetURL;
end;

{ TWebPanel }

procedure TWebPanel.ChromiumTitleChange(Sender: TObject; const Browser: ICefBrowser;
  const title: ustring);
Var
  NewTitle: String;
begin
  NewTitle := UTF8Encode(title);

  If UTF8Length(NewTitle) < 15 then Caption := NewTitle
  Else Caption := UTF8Copy(NewTitle, 1, 12) + '...';
end;

procedure TWebPanel.ChromiumTakeFocus(Sender: TObject; const Browser: ICefBrowser; next_: Boolean);
Var
  NextPageIndex: Integer;
begin
  If next_ then NextPageIndex := PageIndex + 1
  Else NextPageIndex := PageIndex - 1;

  If (NextPageIndex >= 0) and (NextPageIndex < PageControl.PageCount) then
  begin
    // Select next tab if available
    PageControl.ActivePageIndex := NextPageIndex;
  end
  Else
  begin
    // otherwise select next component on form
    FMain.SelectNext(FMain.ActiveControl, next_, True);
  end;
end;

procedure TWebPanel.ChromiumAddressChange(Sender: TObject; const Browser: ICefBrowser;
  const Frame: ICefFrame; const url: ustring);
begin
  Assert(CefCurrentlyOn(TID_UI));

  If frame.IsMain then
  begin
    fUrl := UTF8Encode(Browser.MainFrame.Url);

    If PageControl.ActivePage = Self then FMain.EUrl.Text := fUrl;
  end;
end;

procedure TWebPanel.ChromiumFaviconUrlchange(Sender: TObject; const Browser: ICefBrowser;
  iconUrls: TStrings);
Var
  i: Integer;
begin
  // For simplicity just use the first .ico image
  For i := 0 to iconUrls.Count - 1 do
    If AnsiEndsText('ico', iconUrls[i]) then
    begin
      // make sure there is only one
      If Assigned(fIconGetter) then fIconGetter.Cancel;

      fIconGetter := TFaviconGetter.Create(iconUrls[i], @IconReady);
      Exit;
    end;

  // No suitabe icon found
  SetIcon(nil);
end;

procedure TWebPanel.ChromiumBeforePopup(Sender: TObject; const browser: ICefBrowser;
  const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
  targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean; out Result: Boolean);
begin
  // Called on IO thread, must be executed on the UI thread
  CefPostTask(TID_UI, TCefNewTabTask.Create(targetUrl));

  Result := True;
end;

procedure TWebPanel.ChromiumOpenUrlFromTab(Sender: TObject; browser: ICefBrowser; frame: ICefFrame;
  const targetUrl: ustring; targetDisposition: TCefWindowOpenDisposition; useGesture: Boolean;
  out Result: Boolean);
begin
  Assert(CefCurrentlyOn(TID_UI));

  FMain.NewTab(UTF8Encode(targetUrl));

  Result := True;
end;


procedure TWebPanel.ChromiumBeforeContextMenu(Sender: TObject; const Browser: ICefBrowser;
  const Frame: ICefFrame; const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
  Assert(CefCurrentlyOn(TID_UI));

  If ([CM_TYPEFLAG_PAGE, CM_TYPEFLAG_FRAME] * params.GetTypeFlags) <> [] then
  begin
    // Add seperator if the menu already contains items
    If model.GetCount > 0 then model.AddSeparator;

    model.AddItem(CLIENT_ID_VISIT_COOKIES, '&Visit Cookies');
    model.AddItem(CLIENT_ID_PRINT_TO_PDF, '&Print to PDF');
    model.AddSeparator;
    model.AddItem(CLIENT_ID_EXIT, '&Exit');
  end;
end;

procedure TWebPanel.ChromiumContextMenuCommand(Sender: TObject; const Browser: ICefBrowser;
  const Frame: ICefFrame; const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: TCefEventFlags; out Result: Boolean);
begin
  Assert(CefCurrentlyOn(TID_UI));

  Result := True;

  Case commandId of
    CLIENT_ID_VISIT_COOKIES: TCefCookieManagerRef.Global(nil).VisitAllCookiesProc(@VisitCookies);
    CLIENT_ID_PRINT_TO_PDF: PrintToPdf(Browser);
    CLIENT_ID_EXIT: Application.Terminate;
  Else Result := False;
  end;
end;

procedure TWebPanel.ChromiumFileDialog(Sender: TObject; const Browser: ICefBrowser;
  mode: TCefFileDialogMode; const title, defaultFileName: ustring; acceptFilters: TStrings;
  selectedAcceptFilter: Integer; const callback: ICefFileDialogCallback; out Result: Boolean);
Var
  ModeType: TCefFileDialogMode;
  Success: Boolean = False;
  Files: TStringList;
  InitialDir: ustring;
  LCLDialog: TOpenDialog;


function GetDescriptionFromMimeType(const mimeType: String): String;
Const
  WildCardMimeTypes: array[0..3] of array[0..1] of String = (
    ('audio', 'Audio Files'),
    ('image', 'Image Files'),
    ('text', 'Text Files'),
    ('video', 'Video Files'));
Var
  i: Integer;
begin
  Result := '';

  For i := 0 to High(WildCardMimeTypes) do
  begin
    If AnsiCompareText(mimeType, WildCardMimeTypes[i][0] + '/*') = 0 then
    begin
      Result := WildCardMimeTypes[i][1];
      Break;
    end;
  end;
end;

procedure AddFilters(includeAll: Boolean);
Var
  hasFilter: Boolean = False;
  Filter, Line, Descr: String;
  Ext: TStringList;
  sepPos: SizeInt;
  i, k: Integer;
begin
  Filter := '';
  Ext := TStringList.Create;
  Ext.Delimiter := ';';

  For i := 0 to AcceptFilters.Count - 1 do
  begin
    Line := AcceptFilters[i];

    If Line = '' then Continue;

    sepPos := Pos('|', Line);
    If  sepPos <> 0 then
    begin
      // treat as a filter of the form "Filter Name|.ext1;.ext2;.ext3"

      Descr := Copy(Line, 1, sepPos - 1);
      Line := StringReplace(Copy(Line, sepPos + 1, Length(Line) - sepPos), '.', '*.', [rfReplaceAll]);
    end
    Else
    begin
      Ext.Clear;
      Descr := '';

      If AnsiStartsStr('.', Line) then
      begin
        // treat as an extension beginning with the '.' character
        Ext.Add('*' + Line);
      end
      Else
      begin
        // convert mime type to one or more extensions
        Descr := GetDescriptionFromMimeType(Line);
        CefGetExtensionsForMimeType(Line, Ext);

        For k := 0 to Ext.Count - 1 do Ext[k] := '*.' + Ext[k];
      end;

      If Ext.Count = 0 then Continue;

      // combine extensions, reuse Line
      Line := Ext.DelimitedText;
    end;

    If Descr = '' then Descr := Line
    {$IFDEF LCLGTK2}
      Else Descr := Descr + ' (' + Line + ')'
    {$ENDIF};

    If Length(Filter) > 0 then Filter := Filter + '|';
    Filter := Filter + Descr + '|' + Line;

    hasFilter := True;
  end;

  // if there are filters, add *.* filter
  If includeAll and hasFilter then
    Filter := Filter + '|All Files' + {$IFDEF LCLGTK2}' (*.*)' +{$ENDIF} '|*.*';

  LCLDialog.Filter := Filter;

  If hasFilter then LCLDialog.FilterIndex := SelectedAcceptFilter;

  FreeAndNil(Ext);
end;

begin
  // Remove modifier flags
  ModeType := TCefFileDialogMode(LongWord(Mode) and LongWord(FILE_DIALOG_TYPE_MASK));

  Case ModeType of
    FILE_DIALOG_OPEN,
    FILE_DIALOG_OPEN_MULTIPLE: LCLDialog := FMain.OpenFile;
    FILE_DIALOG_OPEN_FOLDER: LCLDialog := FMain.OpenFolder;
    FILE_DIALOG_SAVE: LCLDialog := FMain.SaveFile;
  Else
    raise Exception.Create('Unimpemented dialog type.');
  end;

  If ModeType = FILE_DIALOG_OPEN_MULTIPLE then
    LCLDialog.Options := LCLDialog.Options + [ofAllowMultiSelect];

  If ModeType = FILE_DIALOG_SAVE then
  begin
    If Boolean(LongWord(Mode) and LongWord(FILE_DIALOG_OVERWRITEPROMPT_FLAG)) then
      LCLDialog.Options := LCLDialog.Options + [ofOverwritePrompt];

    If DefaultFileName <> '' then
    begin
      InitialDir := ExtractFileDir(DefaultFileName);

      If DirectoryExists(InitialDir) then LCLDialog.InitialDir := InitialDir
      Else LCLDialog.InitialDir := GetUserDir;

      LCLDialog.FileName := ExtractFileName(DefaultFileName);
    end;
  end;

  If Boolean(LongWord(Mode) and LongWord(FILE_DIALOG_HIDEREADONLY_FLAG)) then
    LCLDialog.Options := LCLDialog.Options + [ofHideReadOnly];

  AddFilters(True);

  Success := FMain.SaveFile.Execute;

  If Success then
  begin
    Files := TStringList.Create;

    If ModeType = FILE_DIALOG_OPEN_MULTIPLE then Files.AddStrings(LCLDialog.Files)
    Else Files.Add(LCLDialog.FileName);

    Callback.Cont(FMain.SaveFile.FilterIndex, Files);

    FreeAndNil(Files);
  end
  Else Callback.Cancel;

  Result := True;
end;

procedure TWebPanel.ChromiumBeforeDownload(Sender: TObject; const Browser: ICefBrowser;
  const downloadItem: ICefDownloadItem; const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
begin
  // Show "Save As" dialog, download to default temp directory
  callback.Cont('', True);
end;

procedure PdfPrintCallback(const path: ustring; ok: Boolean);
begin
  If ok then ShowMessage('Successfully printed to pdf file.' + LineEnding + path)
  Else ShowMessage('Failed to print to file.');
end;

procedure TWebPanel.PrintToPdf(const Browser: ICefBrowser);
Var
  PdfSettings: TCefPdfPrintSettings;
begin
  With FMain.SaveFile do
  begin
    Filter := 'PDF file|*.pdf';
    FileName := 'output.pdf';
    InitialDir := GetUserDir;
  end;

  If FMain.SaveFile.Execute then
  begin
    FillByte(PdfSettings, SizeOf(PdfSettings), 0);

    With PdfSettings do
    begin
      // default page size is A4

      header_footer_enabled := Ord(True);
      backgrounds_enabled := Ord(True);
    end;

    Browser.Host.PrintToPdf(FMain.SaveFile.FileName, PdfSettings, TCefFastPdfPrintCallback.Create(@PdfPrintCallback));
  end;
end;

procedure TWebPanel.IconReady(const Success: Boolean; const Icon: TIcon);
begin
  Assert(CefCurrentlyOn(TID_UI));

  fIconGetter := nil;

  If Success then SetIcon(Icon)
  Else SetIcon(nil);
end;

procedure TWebPanel.DoHide;
begin
  inherited DoHide;

  If Assigned(fChromium) then fChromium.Hide;
end;

procedure TWebPanel.DoShow;
begin
  inherited DoShow;

  If Assigned(fChromium) then fChromium.Show;
end;

destructor TWebPanel.Destroy;
begin
  // Cancel icon request
  If Assigned(fIconGetter) then fIconGetter.Cancel;

  inherited Destroy;
end;

procedure TWebPanel.InitializeChromium(DefaultUrl: String);
begin
  If not Assigned(fChromium) then
  begin
    fChromium := TChromium.Create(Self);
    fChromium.TabStop := True;
    fChromium.Parent := Self;
    fChromium.AnchorAsAlign(alClient, 0);

    If DefaultUrl <> '' then fChromium.DefaultUrl := DefaultUrl;

    // Register callbacks
    fChromium.OnTakeFocus := @ChromiumTakeFocus;
    fChromium.OnTitleChange := @ChromiumTitleChange;
    fChromium.OnAddressChange := @ChromiumAddressChange;
    fChromium.OnFaviconUrlchange := @ChromiumFaviconUrlchange;

    fChromium.OnOpenUrlFromTab := @ChromiumOpenUrlFromTab;
    fChromium.OnBeforePopup := @ChromiumBeforePopup;

    fChromium.OnBeforeContextMenu := @ChromiumBeforeContextMenu;
    fChromium.OnContextMenuCommand := @ChromiumContextMenuCommand;

    {$IFDEF LINUX}
      fChromium.OnFileDialog := @ChromiumFileDialog;
    {$ENDIF}

    fChromium.OnBeforeDownload := @ChromiumBeforeDownload;
  end
  Else raise Exception.Create('Chromium already initialized.');
end;

procedure TWebPanel.RequestClose;
begin
  fChromium.Browser.Host.CloseBrowser(False);
end;

procedure TWebPanel.OpenUrl(AUrl: String);
begin
  fChromium.Load(AUrl);
end;

// Change the icon of the tab
procedure TWebPanel.SetIcon(const Icon: TCustomIcon);
begin
  If Assigned(Icon) then
  begin
    // Replace icon with new one
    FMain.TabIcons.Delete(TabIndex);
    FMain.TabIcons.InsertIcon(TabIndex, Icon);

    ImageIndex := TabIndex;
  end
  Else If ImageIndex <> -1 then
  begin
    // Replace icon with dummy one
    FMain.TabIcons.Delete(TabIndex);
    FMain.TabIcons.InsertIcon(TabIndex, Application.Icon);

    ImageIndex := -1;
  end;

  PageControl.Repaint;
end;


{ TCustomBrowserProcessHandler }

function TCustomBrowserProcessHandler.GetPrintHandler: ICefPrintHandler;
begin
  Result := fPrintHandler;
end;

constructor TCustomBrowserProcessHandler.Create;
begin
  inherited;

  {$IFDEF LINUX}
    fPrintHandler := TCustomPrintHandler.Create;
  {$ELSE}
    fPrintHandler := nil;
  {$ENDIF}
end;


procedure RegisterSchemes(const registrar: TCefSchemeRegistrarRef);
begin
  registrar.AddCustomScheme('fpcef', False, True, False, False, False, False);
end;


Initialization
  Path := GetCurrentDirUTF8 + DirectorySeparator;

  CefResourcesDirPath := Path + 'Resources';
  CefLocalesDirPath := Path + 'Resources' + DirectorySeparator + 'locales';
  //CefCachePath := Path + 'Cache';
  //CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};

  // register handler
  CefBrowserProcessHandler := TCustomBrowserProcessHandler.Create;

  // scheme handler
  CefOnRegisterCustomSchemes := @RegisterSchemes;
  CefRegisterSchemeHandlerFactory('fpcef', '', TCustomScheme);

  CefInitialize;

end.
