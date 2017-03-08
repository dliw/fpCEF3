Unit PrintHandler;

{$MODE objfpc}{$H+}

Interface

Uses
  Classes, SysUtils,
  cef3types, cef3own;

Type
  { custom print handler }

  // only printing to PDF is implemented on Linux at the moment
  // for a complete printing support, the print handler needs to be fully implemented

  TCustomPrintHandler = class(TCefPrintHandlerOwn)
    protected
      function GetPdfPaperSize(DeviceUnitsPerInch: Integer): TCefSize; override;
  end;

Implementation

{ TCustomPrintHandler }
function TCustomPrintHandler.GetPdfPaperSize(DeviceUnitsPerInch: Integer): TCefSize;
Var
  Size: TCefSize;
begin
  // Use A4 size: width=8.267in, heigth=11.692in

  Size.width  := Round(DeviceUnitsPerInch * 8.267);
  Size.height := Round(DeviceUnitsPerInch * 11.692);

  Result := Size;
end;


end.

