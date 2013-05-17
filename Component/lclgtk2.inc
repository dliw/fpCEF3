function size_allocateCB(Widget: PGtkWidget; Size: pGtkAllocation; Data: gPointer): GBoolean; cdecl;
Const
  CallBackDefaultReturn = {$IFDEF GTK2}false{$ELSE}true{$ENDIF};
Var
  SizeMsg: TLMSize;
  GtkWidth, GtkHeight: integer;
  LCLControl: TWinControl;
begin
  Result := CallBackDefaultReturn;

  If not GTK_WIDGET_REALIZED(Widget) then Exit;

  If Size = nil then ;
  LCLControl := TWinControl(Data);
  If LCLControl = nil then Exit;

  gtk_widget_get_size_request(Widget, @GtkWidth, @GtkHeight);

  SizeMsg.Msg:=0;
  FillChar(SizeMsg,SizeOf(SizeMsg),0);
  With SizeMsg do
  begin
    Result := 0;
    Msg := LM_SIZE;
    SizeType := Size_SourceIsInterface;
    Width := SmallInt(GtkWidth);
    Height := SmallInt(GtkHeight);
  end;

  LCLControl.WindowProc(TLMessage(SizeMsg));
end;

function LCreateContext(AWinControl: TWinControl; const AParams: TCreateParams): HWND;
Var NewWidget: PGtkWidget;
begin
  NewWidget := gtk_vbox_new(False, 0);
  Result := HWND(PtrUInt(Pointer(NewWidget)));

  //PGtkObject(NewWidget)^.flags := PGtkObject(NewWidget)^.flags or GTK_CAN_FOCUS;

  TGtk2WidgetSet(WidgetSet).FinishCreateHandle(AWinControl, NewWidget, AParams);

  //g_signal_connect_after(PGtkObject(NewWidget), 'size-allocate', TGTKSignalFunc(@size_allocateCB), AWinControl);
end;

procedure LDestroyContext(AWinControl: TWinControl);
begin
  If not AWinControl.HandleAllocated then Exit;
  // nothing to do
end;  
