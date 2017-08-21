{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CEF3;

interface

uses
  cef3types, cef3api, cef3lib, cef3intf, cef3ref, cef3own, cef3gui, cef3lcl, cef3osr, cef3context,
  cef3scp, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('cef3lcl', @cef3lcl.Register);
  RegisterUnit('cef3osr', @cef3osr.Register);
  RegisterUnit('cef3context', @cef3context.Register);
end;

initialization
  RegisterPackage('CEF3', @Register);
end.
