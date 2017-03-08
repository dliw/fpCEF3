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
 *)

Unit cef3context;

{$MODE objfpc}{$H+}

{$I cef.inc}

Interface

Uses
  Classes, SysUtils,
  cef3types, cef3lib, cef3intf, cef3ref, cef3gui;

Type

  TCustomChromiumContext = class(TComponent, IChromiumContextEvents)
    private
      fRequestContextHandler: ICefRequestContextHandler;
      fRequestContext: ICefRequestContext;

      fSharedContext: TCustomChromiumContext;

      fOnGetCookieManager: TOnGetCookieManager;
      fOnBeforePluginLoad: TOnBeforePluginLoad;

      fCachePath: String;
      fPersistSessionCookies: Boolean;
      fPersistUserPreferences: Boolean;
      fIgnoreCertificateErrors: Boolean;
      fAcceptLanguageList: String;
    protected
      function NewRequestContext: ICefRequestContext;

      function doOnGetCookieManager: ICefCookieManager;
      function doOnBeforePluginLoad(const mimeType, pluginUrl, topOriginUrl: ustring;
        pluginInfo: ICefWebPluginInfo; pluginPolicy: TCefPluginPolicy): Boolean;

      property SharedContext: TCustomChromiumContext read fSharedContext write fSharedContext default nil;

      property OnGetCookieManager: TOnGetCookieManager read fOnGetCookieManager write fOnGetCookieManager;
      property OnBeforePluginLoad: TOnBeforePluginLoad read fOnBeforePluginLoad write fOnBeforePluginLoad;

      property CachePath: String read fCachePath write fCachePath;
      property PersistSessionCookies: Boolean read fPersistSessionCookies write fPersistSessionCookies;
      property PersistUserPreferences: Boolean read fPersistUserPreferences write fPersistUserPreferences;
      property IgnoreCertificateErrors: Boolean read fIgnoreCertificateErrors write fIgnoreCertificateErrors;
      property AcceptLanguageList: String read fAcceptLanguageList write fAcceptLanguageList;
    public
      constructor Create(AOwner: TComponent); override;

      function GetRequestContext: ICefRequestContext;
  end;

  TChromiumContext = class(TCustomChromiumContext)
    published
      property SharedContext;

      property OnGetCookieManager;
      property OnBeforePluginLoad;

      property CachePath;
      property PersistSessionCookies;
      property PersistUserPreferences;
      property IgnoreCertificateErrors;
      property AcceptLanguageList;
  end;

procedure Register;

Implementation

procedure Register;
begin
  RegisterComponents('Chromium', [TChromiumContext]);
end;


{ TCustomChromiumContext }

function TCustomChromiumContext.NewRequestContext: ICefRequestContext;
Var
  settings: TCefRequestContextSettings;
begin
  CefInitialize;

  If Assigned(fSharedContext) then
  begin
    Result := TCefRequestContextRef.Shared(fSharedContext.GetRequestContext, fRequestContextHandler)
  end
  Else
  begin
    FillChar(settings, SizeOf(TCefRequestContextSettings), 0);
    settings.size := SizeOf(TCefRequestContextSettings);

    settings.cache_path := CefString(fCachePath);
    settings.persist_session_cookies := Ord(fPersistSessionCookies);
    settings.persist_user_preferences := Ord(fPersistUserPreferences);
    settings.ignore_certificate_errors := Ord(fIgnoreCertificateErrors);
    settings.accept_language_list := CefString(fAcceptLanguageList);

    Result := TCefRequestContextRef.New(settings, fRequestContextHandler);
  end;
end;

function TCustomChromiumContext.doOnGetCookieManager: ICefCookieManager;
begin
  If Assigned(fOnGetCookieManager) then fOnGetCookieManager(Self, Result)
  Else Result := nil;
end;

function TCustomChromiumContext.doOnBeforePluginLoad(const mimeType, pluginUrl, topOriginUrl: ustring;
  pluginInfo: ICefWebPluginInfo; pluginPolicy: TCefPluginPolicy): Boolean;
begin
  If Assigned(fOnBeforePluginLoad) then
    fOnBeforePluginLoad(Self, mimeType, pluginUrl, topOriginUrl, pluginInfo, pluginPolicy, Result)
  Else Result := False;
end;

constructor TCustomChromiumContext.Create(AOwner: TComponent);
begin
  inherited;

  If not (csDesigning in ComponentState) then
  begin
    fRequestContextHandler := TCustomRequestContextHandler.Create(Self);
  end;
end;

function TCustomChromiumContext.GetRequestContext: ICefRequestContext;
begin
  If not Assigned(fRequestContext) then fRequestContext := NewRequestContext;

  Result := fRequestContext;
end;

end.

