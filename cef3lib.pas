(*
 *                       Free Pascal Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Author: d.l.i.w <dev.dliw@gmail.com>
 * Repository: http://github.com/dliw/fpCEF3
 *
 *
 * Based on 'Delphi Chromium Embedded' by: Henri Gourvest <hgourvest@gmail.com>
 * Repository : http://code.google.com/p/delphichromiumembedded/
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

Unit cef3lib;

{$MODE objfpc}{$H+}

(*
{$ALIGN ON}
{$MINENUMSIZE 4}
*)


{$I cef.inc}

Interface

Uses
  {$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}Messages,{$ENDIF}
  SysUtils, Classes,
  {$IFDEF WINDOWS}Windows,{$ENDIF}
  cef3types;

Type
  ustring = AnsiString;
  rbstring = AnsiString;
(*
{$IFDEF UNICODE}
  ustring = type String;
  rbstring = type RawByteString;
{$ELSE}
  {$IFDEF FPC}
    {$IF declared(unicodestring)}
      ustring = type UnicodeString;
    {$ELSE}
      ustring = type WideString;
    {$IFEND}
  {$ELSE}
    ustring = type WideString;
  {$ENDIF}
  rbstring = type AnsiString;
{$ENDIF}
*)

  TUrlParts = record
    spec: ustring;
    scheme: ustring;
    username: ustring;
    password: ustring;
    host: ustring;
    port: ustring;
    path: ustring;
    query: ustring;
  end;

Implementation

end.
