Unit FaviconGetter;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Graphics,
  cef3types, cef3intf, cef3ref, cef3own,
  WebPanel;

Type
  TFaviconGetter = class(TCefUrlrequestClientOwn)
  private
    fTarget: TWebPanel;
    fStream: TMemoryStream;
    fExt: String;
  protected
    procedure OnDownloadData(const request: ICefUrlRequest; data: Pointer; dataLength: TSize); override;
    procedure OnRequestComplete(const request: ICefUrlRequest); override;
  public
    constructor Create(Target: TWebPanel; Url: String);
  end;

Implementation

{ TFaviconGetter }

procedure TFaviconGetter.OnDownloadData(const request: ICefUrlRequest; data: Pointer;
  dataLength: TSize);
begin
  fStream.WriteBuffer(data^, dataLength);
end;

// Icon is ready
// In a real world application this would be the place to handle different file formats
// and to resize the image appropriately
// After OnRequestComplete has been executed, this instance of TGetFaviCon is freed automatically.
procedure TFaviconGetter.OnRequestComplete(const request: ICefUrlRequest);
Var
  Picture: TPicture;
begin
  fStream.Position := 0;

  try
    try
      // Load the icon ...
      Picture := TPicture.Create;
      Picture.LoadFromStreamWithFileExt(fStream, fExt);

      // ... and add it to the TabIcons image list
      fTarget.SetIcon(Picture.Icon);
    finally
      Picture.Free;
      fStream.Free;
    end;
  except
    // Catch any exception
    // Broken things are easy to encounter on the internet, therefore robustness is very important

    On E: Exception do
    begin
      {$IFDEF DEBUG}
      WriteLn(E.Message);
      {$ENDIF}

      fTarget.SetIcon(nil);
    end;
  end;
end;

constructor TFaviconGetter.Create(Target: TWebPanel; Url: String);
Var
  Request: ICefRequest;
begin
  inherited Create;

  fTarget := Target;
  fStream := TMemoryStream.Create;

  // remember the file type for later
  fExt := ExtractFileExt(Url);

  // Set the data for the request ...
  Request := TCefRequestRef.New;
  Request.Url := Url;

  // ... and start the url request. The request client is the FaciconGetter itself
  TCefUrlRequestRef.New(Request, Self, nil);
end;

end.

