Unit SchemeHandler;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils,
  cef3types, cef3intf, cef3own;

Type
  { custom scheme handler }

  TCustomScheme = class(TCefResourceHandlerOwn)
    private
      fData: TMemoryStream;
      fStatus: Integer;
      fStatusText: ustring;
      fMimeType: ustring;
    protected
      function ProcessRequest(const request: ICefRequest; const callback: ICefCallback): Boolean; override;
      procedure GetResponseHeaders(const response: ICefResponse; out responseLength: Int64;
        out redirectUrl: ustring); override;
      function ReadResponse(const dataOut: Pointer; bytesToRead: Integer; var bytesRead: Integer;
        const callback: ICefCallback): Boolean; override;
    public
      constructor Create(const browser: ICefBrowser; const frame: ICefFrame;
        const schemeName: ustring; const request: ICefRequest); override;
      destructor Destroy; override;
  end;

Implementation

{ TCustomScheme }
function TCustomScheme.ProcessRequest(const request: ICefRequest;
  const callback: ICefCallback): Boolean;
Var
  Output: String;
begin
  Result := True;

  fStatus     := 200;
  fStatusText := 'OK';
  fMimeType   := 'text/html';

  Output := UTF8Encode(
    '<!doctype html><html><head><meta charset="UTF-8"><title>Welcome</title></head>' +
    '<body><h1>Welcome to the LCLCefClient</h1><a href="https://github.com/dliw/fpCEF3">fpCEF @ Github</a></html>'
  );

  fData.Clear;
  fData.Write(Output[1], Length(Output));
  fData.Seek(0, soFromBeginning);

  callback.Cont;
end;

procedure TCustomScheme.GetResponseHeaders(const response: ICefResponse; out responseLength: Int64;
  out redirectUrl: ustring);
begin
  response.Status := fStatus;
  response.StatusText := fStatusText;
  response.MimeType := fMimeType;

  responseLength := fData.Size;
end;

function TCustomScheme.ReadResponse(const dataOut: Pointer; bytesToRead: Integer;
  var bytesRead: Integer; const callback: ICefCallback): Boolean;
begin
  bytesRead := fData.Read(dataOut^, bytesToRead);
  Result := True;
end;

constructor TCustomScheme.Create(const browser: ICefBrowser; const frame: ICefFrame;
  const schemeName: ustring; const request: ICefRequest);
begin
  inherited;

  fData := TMemoryStream.Create;
end;

destructor TCustomScheme.Destroy;
begin
  FreeAndNil(fData);

  inherited;
end;

end.

