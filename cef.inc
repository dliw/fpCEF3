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
 * Author: dliw <dev.dliw@gmail.com>
 * Repository: http://github.com/dliw/fpCEF3
 *
 * Based on 'Delphi Chromium Embedded' by: Henri Gourvest <hgourvest@gmail.com>
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
