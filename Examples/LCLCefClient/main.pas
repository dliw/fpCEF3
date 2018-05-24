Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, LCLType, Menus, Dialogs,
  WebPanel;

Type
  TFMain = class(TForm)
    BGo: TButton;
    BNewTab: TButton;
    BCloseTab: TButton;
    EUrl: TEdit;
    OpenFile: TOpenDialog;
    SaveFile: TSaveDialog;
    OpenFolder: TSelectDirectoryDialog;
    TabIcons: TImageList;
    LUrl: TStaticText;
    Tabs: TPageControl;
    procedure BCloseTabClick(Sender: TObject);
    procedure BGoClick(Sender: TObject);
    procedure BNewTabClick(Sender: TObject);
    procedure EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure TabsChange(Sender: TObject);
  private
    fCloseRequested: Boolean;
    fCloseAllowed: Boolean;

    procedure AddTab(First: Boolean = False);
    procedure TabAfterClose(const Index: Integer);
    procedure TabCloseStopped(Sender: TObject);
  protected
    procedure DoFirstShow; override;
  public
    procedure NewTab(const Url: String);
  end;

Var
  FMain: TFMain;

Implementation

{$R *.lfm}

{ TFMain }

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  If fCloseAllowed then CanClose := True
  Else
  begin
    fCloseRequested := True;
    CanClose := False;

    // start closing tabs
    (Tabs.Page[Tabs.PageCount-1] as TWebPanel).RequestClose;
  end;
end;

procedure TFMain.DoFirstShow;
begin
  fCloseRequested := False;
  fCloseAllowed := False;

  AddTab(True);
end;

procedure TFMain.TabsChange(Sender: TObject);
begin
  EUrl.Text := (Tabs.ActivePage as TWebPanel).Url;
end;

procedure TFMain.BGoClick(Sender: TObject);
begin
  (Tabs.ActivePage as TWebPanel).OpenUrl(EUrl.Text);
end;

procedure TFMain.BCloseTabClick(Sender: TObject);
begin
  (Tabs.ActivePage as TWebPanel).RequestClose;
end;

procedure TFMain.BNewTabClick(Sender: TObject);
begin
  AddTab;
end;

procedure TFMain.EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;

procedure TFMain.AddTab(First: Boolean);
Var
  TabSheet: TWebPanel;
begin
  TabSheet := TWebPanel.Create(Tabs);
  TabSheet.Parent := Tabs;
  TabSheet.Caption := 'New Tab';
  TabSheet.OnClose := @TabAfterClose;
  TabSheet.OnCloseStopped := @TabCloseStopped;

  // Create a dummy tab icon (could be a loading indicator) until we get the real one
  TabIcons.AddIcon(Application.Icon);

  Tabs.ActivePageIndex := TabSheet.PageIndex;

  If First then TabSheet.InitializeChromium('fpcef://')
  Else TabSheet.InitializeChromium;

  If Tabs.PageCount > 1 then BCloseTab.Enabled := True;
end;

procedure TFMain.TabAfterClose(const Index: Integer);
Var
  i: Integer;
begin
  // delete tab icon
  TabIcons.Delete(Index);

  // adjust tab icon indices
  For i := 0 to Tabs.PageCount - 1 do
  begin
    With Tabs.Pages[i] do
      If ImageIndex <> -1 then ImageIndex := TabIndex;
  end;
  Tabs.Repaint;

  If fCloseRequested then
  begin
    If Tabs.PageCount = 0 then
    begin
      // terminate application if all tabs are closed
      Halt;
    end
    Else
    begin
      Application.ProcessMessages;

      // continue closing tabs
      (Tabs.Page[Tabs.PageCount-1] as TWebPanel).RequestClose;
    end
  end
  Else
  begin
    // last tab cannot be closed
    If Tabs.PageCount < 2 then BCloseTab.Enabled := False;
  end;
end;

procedure TFMain.TabCloseStopped(Sender: TObject);
begin
  fCloseRequested := False;
end;

procedure TFMain.NewTab(const Url: String);
begin
  AddTab;
  (Tabs.ActivePage as TWebPanel).OpenUrl(Url);
end;

end.
