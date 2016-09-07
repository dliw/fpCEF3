Unit FaviconGetter;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Graphics,
  cef3types, cef3intf, cef3ref, cef3own, cef3lib;

Type
  TIconReady = procedure(const Success: Boolean; const Icon: TIcon) of object;

  TFaviconGetter = class(TCefUrlrequestClientOwn)
  private
    fCallback: TIconReady;
    fStream: TMemoryStream;
    fExt: String;
    fUrlRequest: ICefUrlRequest;
  protected
    procedure OnDownloadData(const request: ICefUrlRequest; data: Pointer; dataLength: TSize); override;
    procedure OnRequestComplete(const request: ICefUrlRequest); override;
  public
    constructor Create(Url: String; Callback: TIconReady); reintroduce;

    procedure Cancel;
  end;

Implementation

{ TFaviconGetter }

procedure TFaviconGetter.OnDownloadData(const request: ICefUrlRequest; data: Pointer;
  dataLength: TSize);
begin
  If Assigned(fCallback) then fStream.WriteBuffer(data^, dataLength);
end;

// In a real world application this would be the place to handle different file formats
// and to resize the image appropriately
procedure TFaviconGetter.OnRequestComplete(const request: ICefUrlRequest);
Var
  Picture: TPicture;
begin
  fUrlRequest := nil;

  If Assigned(fCallback) then
  begin
    If request.GetRequestStatus = UR_SUCCESS then
    begin
      fStream.Position := 0;

      try
        // Load the icon ...
        Picture := TPicture.Create;
        Picture.LoadFromStreamWithFileExt(fStream, fExt);

        // ... and add it to the TabIcons image list
        fCallback(True, Picture.Icon);
      except
        // Catch any exception
        // Broken things are easy to encounter on the internet, therefore robustness is very important
        On E: Exception do fCallback(False, nil);
      end;

      Picture.Free;
    end
    Else fCallback(False, nil);
  end;

  fStream.Free;
end;

constructor TFaviconGetter.Create(Url: String; Callback: TIconReady);
Var
  Request: ICefRequest;
begin
  inherited Create;

  fCallback := Callback;
  fStream := TMemoryStream.Create;

  // remember the file type for later
  fExt := ExtractFileExt(Url);

  // Set the data for the request ...
  Request := TCefRequestRef.New;
  Request.Url := Url;

  // ... and start the url request. The request client is FaviconGetter itself.
  fUrlRequest := TCefUrlRequestRef.New(Request, Self, nil);
end;

procedure TFaviconGetter.Cancel;
begin
  // disable callback and cancel request
  fCallback := nil;
  If Assigned(fUrlRequest) then fUrlRequest.Cancel;
end;

end.

