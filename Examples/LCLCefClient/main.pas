Unit Main;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, LCLType, Menus,
  WebPanel;

Type
  TFMain = class(TForm)
    BGo: TButton;
    BNewTab: TButton;
    BCloseTab: TButton;
    EUrl: TEdit;
    LUrl: TStaticText;
    Tabs: TPageControl;
    procedure BCloseTabClick(Sender: TObject);
    procedure BGoClick(Sender: TObject);
    procedure BNewTabClick(Sender: TObject);
    procedure EUrlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure TabsChange(Sender: TObject);
  private
    procedure AddTab;
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
  AddTab;
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
  Tabs.ActivePage.Free;

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

procedure TFMain.AddTab;
Var
  TabSheet: TWebPanel;
begin
  TabSheet := TWebPanel.Create(Tabs);
  TabSheet.Parent := Tabs;
  TabSheet.Caption := 'New Tab';

  TabSheet.InitializeChromium;

  Tabs.ActivePageIndex := TabSheet.PageIndex;

  If Tabs.PageCount > 1 then BCloseTab.Enabled := True;
end;

procedure TFMain.NewTab(const Url: String);
begin
  AddTab;
  (Tabs.ActivePage as TWebPanel).OpenUrl(Url);
end;

end.
