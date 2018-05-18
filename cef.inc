(*
 *                       Free Pascal Chromium Embedded 3
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Author:     dev.dliw@gmail.com
 * Repository: https://github.com/dliw/fpCEF3
 *
 *
 * Originally based on 'Delphi Chromium Embedded 3' by Henri Gourvest
 * <hgourvest@gmail.com>
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

{.$DEFINE DEBUG}

// Don't change this, unless you know, what you are doing
{$DEFINE CEF_STRING_TYPE_UTF16}

 {.$DEFINE CEF_STRING_TYPE_UTF8}
 {.$DEFINE CEF_STRING_TYPE_WIDE}

{.$DEFINE CEF_MULTI_THREADED_MESSAGE_LOOP}
{$DEFINE SUPPORTS_INLINE}

// calling convention
{$MACRO ON}
{$IFDEF WINDOWS}
  {$DEFINE cconv:=stdcall}
{$ELSE}
  {$DEFINE cconv:=cdecl}
{$ENDIF}


// Sanity check
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  {$IFNDEF WINDOWS}
    {$ERROR CEF doesn't support the mulithreaded message loop on systems other than Windows}
  {$ENDIF}
{$ENDIF}
