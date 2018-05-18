(*
 *                       Free Pascal Chromium Embedded 3
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Author:     dev.dliw@gmail.com
 * Repository: https://github.com/dliw/fpCEF3
 *)

Unit cef3scp;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils,
  cef3api, cef3types;

Type
  TCefBaseScopedRef = class
  private
    fData: Pointer;
  public
    constructor Create(data: Pointer); virtual;
    function Wrap: Pointer;
  end;

  TCefSchemeRegistrarRef = class(TCefBaseScopedRef)
  public
    function AddCustomScheme(const schemeName: ustring;
      isStandard, isLocal, isDisplayIsolated, isSecure, isCorsEnabled, isCspBypassing: Boolean): Boolean;
  end;

implementation

Uses cef3lib;

{ TCefBaseScopedRef }

constructor TCefBaseScopedRef.Create(data: Pointer);
begin
  Assert(data <> nil);
  fData := data;
end;

function TCefBaseScopedRef.Wrap: Pointer;
begin
  Result := fData;
end;

{ TCefSchemeRegistrarRef }

function TCefSchemeRegistrarRef.AddCustomScheme(const schemeName: ustring;
  isStandard, isLocal, isDisplayIsolated, isSecure, isCorsEnabled, isCspBypassing: Boolean): Boolean;
Var
  s : TCefString;
begin
  s := CefString(schemeName);
  Result := PCefSchemeRegistrar(fData)^.add_custom_scheme(fData, @s, Ord(isStandard), Ord(isLocal),
    Ord(isDisplayIsolated), Ord(isSecure), Ord(isCorsEnabled), Ord(isCspBypassing)) <> 0;
end;

end.

