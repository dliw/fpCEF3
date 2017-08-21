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
    procedure FormCreate(Sender: TObject);
    procedure TabsChange(Sender: TObject);
  private
    procedure AddTab(First: Boolean = False);
  public
    procedure NewTab(const Url: String);
  end;

Var
  FMain: TFMain;

Implementation

{$R *.lfm}

{ TFMain }

procedure TFMain.FormCreate(Sender: TObject);
begin
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
Var
  Index, i: Integer;
begin
  Index := Tabs.ActivePageIndex;
  Tabs.ActivePage.Free;

  // Delete tab icon
  TabIcons.Delete(Index);

  // Adjust tab icon indices
  For i := 0 to Tabs.PageCount - 1 do
  begin
    With Tabs.Pages[i] do
      If ImageIndex <> -1 then ImageIndex := TabIndex;
  end;
  Tabs.Repaint;

  If Tabs.PageCount < 2 then BCloseTab.Enabled := False;
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

  If First then TabSheet.InitializeChromium('fpcef://')
  Else TabSheet.InitializeChromium;

  // Create a dummy tab icon (could be a loading indicator) until we get the real one
  TabIcons.AddIcon(Application.Icon);

  Tabs.ActivePageIndex := TabSheet.PageIndex;

  If Tabs.PageCount > 1 then BCloseTab.Enabled := True;
end;

procedure TFMain.NewTab(const Url: String);
begin
  AddTab;
  (Tabs.ActivePage as TWebPanel).OpenUrl(Url);
end;

end.
