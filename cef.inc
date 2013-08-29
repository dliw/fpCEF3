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
 * Ported to Free Pascal and Linux by d.l.i.w <dev.dliw@gmail.com>
 * based on 'Delphi Chromium Embedded'
 *
 * Repository: http://github.com/dliw/fpCEF3
 *
 *
 * Originally created for Delphi by: Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

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
