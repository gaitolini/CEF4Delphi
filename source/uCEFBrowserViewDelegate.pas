unit uCEFBrowserViewDelegate;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I cef.inc}

{$IFNDEF TARGET_64BITS}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SysUtils,
  {$ELSE}
  Classes, SysUtils,
  {$ENDIF}
  uCEFBaseRefCounted, uCEFInterfaces, uCEFTypes, uCEFViewDelegate;

type
  TCefBrowserViewDelegateRef = class(TCefViewDelegateRef, ICefBrowserViewDelegate)
    protected
      procedure OnBrowserCreated(const browser_view: ICefBrowserView; const browser: ICefBrowser);
      procedure OnBrowserDestroyed(const browser_view: ICefBrowserView; const browser: ICefBrowser);
      procedure OnGetDelegateForPopupBrowserView(const browser_view: ICefBrowserView; const settings: TCefBrowserSettings; const client: ICefClient; is_devtools: boolean; var aResult : ICefBrowserViewDelegate);
      procedure OnPopupBrowserViewCreated(const browser_view, popup_browser_view: ICefBrowserView; is_devtools: boolean; var aResult : boolean);
      procedure OnGetChromeToolbarType(var aResult: TCefChromeToolbarType);
      procedure OnUseFramelessWindowForPictureInPicture(const browser_view: ICefBrowserView; var aResult: boolean);
      procedure OnGestureCommand(const browser_view: ICefBrowserView; gesture_command: TCefGestureCommand; var aResult : boolean);

    public
      class function UnWrap(data: Pointer): ICefBrowserViewDelegate;
  end;

  TCefBrowserViewDelegateOwn = class(TCefViewDelegateOwn, ICefBrowserViewDelegate)
    protected
      procedure OnBrowserCreated(const browser_view: ICefBrowserView; const browser: ICefBrowser); virtual;
      procedure OnBrowserDestroyed(const browser_view: ICefBrowserView; const browser: ICefBrowser); virtual;
      procedure OnGetDelegateForPopupBrowserView(const browser_view: ICefBrowserView; const settings: TCefBrowserSettings; const client: ICefClient; is_devtools: boolean; var aResult : ICefBrowserViewDelegate); virtual;
      procedure OnPopupBrowserViewCreated(const browser_view, popup_browser_view: ICefBrowserView; is_devtools: boolean; var aResult : boolean); virtual;
      procedure OnGetChromeToolbarType(var aResult: TCefChromeToolbarType); virtual;
      procedure OnUseFramelessWindowForPictureInPicture(const browser_view: ICefBrowserView; var aResult: boolean); virtual;
      procedure OnGestureCommand(const browser_view: ICefBrowserView; gesture_command: TCefGestureCommand; var aResult : boolean); virtual;

      procedure InitializeCEFMethods; override;

    public
      constructor Create; override;
  end;

  TCustomBrowserViewDelegate = class(TCefBrowserViewDelegateOwn)
    protected
      FEvents : Pointer;

      // ICefViewDelegate
      procedure OnGetPreferredSize(const view: ICefView; var aResult : TCefSize); override;
      procedure OnGetMinimumSize(const view: ICefView; var aResult : TCefSize); override;
      procedure OnGetMaximumSize(const view: ICefView; var aResult : TCefSize); override;
      procedure OnGetHeightForWidth(const view: ICefView; width: Integer; var aResult: Integer); override;
      procedure OnParentViewChanged(const view: ICefView; added: boolean; const parent: ICefView); override;
      procedure OnChildViewChanged(const view: ICefView; added: boolean; const child: ICefView); override;
      procedure OnWindowChanged(const view: ICefView; added: boolean); override;
      procedure OnLayoutChanged(const view: ICefView; new_bounds: TCefRect); override;
      procedure OnFocus(const view: ICefView); override;
      procedure OnBlur(const view: ICefView); override;

      // ICefBrowserViewDelegate
      procedure OnBrowserCreated(const browser_view: ICefBrowserView; const browser: ICefBrowser); override;
      procedure OnBrowserDestroyed(const browser_view: ICefBrowserView; const browser: ICefBrowser); override;
      procedure OnGetDelegateForPopupBrowserView(const browser_view: ICefBrowserView; const settings: TCefBrowserSettings; const client: ICefClient; is_devtools: boolean; var aResult : ICefBrowserViewDelegate); override;
      procedure OnPopupBrowserViewCreated(const browser_view, popup_browser_view: ICefBrowserView; is_devtools: boolean; var aResult : boolean); override;
      procedure OnGetChromeToolbarType(var aResult: TCefChromeToolbarType); override;
      procedure OnUseFramelessWindowForPictureInPicture(const browser_view: ICefBrowserView; var aResult: boolean); override;
      procedure OnGestureCommand(const browser_view: ICefBrowserView; gesture_command: TCefGestureCommand; var aResult : boolean); override;

    public
      constructor Create(const events: ICefBrowserViewDelegateEvents); reintroduce;
  end;

implementation

uses
  uCEFLibFunctions, uCEFMiscFunctions, uCEFBrowserView, uCEFBrowser, uCEFClient, uCEFConstants;


// **************************************************************
// **************** TCefBrowserViewDelegateRef ******************
// **************************************************************

procedure TCefBrowserViewDelegateRef.OnBrowserCreated(const browser_view : ICefBrowserView;
                                                      const browser      : ICefBrowser);
begin
  PCefBrowserViewDelegate(FData)^.on_browser_created(PCefBrowserViewDelegate(FData),
                                                     CefGetData(browser_view),
                                                     CefGetData(browser));
end;

procedure TCefBrowserViewDelegateRef.OnBrowserDestroyed(const browser_view : ICefBrowserView;
                                                        const browser      : ICefBrowser);
begin
  PCefBrowserViewDelegate(FData)^.on_browser_destroyed(PCefBrowserViewDelegate(FData),
                                                       CefGetData(browser_view),
                                                       CefGetData(browser));
end;

procedure TCefBrowserViewDelegateRef.OnGetDelegateForPopupBrowserView(const browser_view : ICefBrowserView;
                                                                      const settings     : TCefBrowserSettings;
                                                                      const client       : ICefClient;
                                                                            is_devtools  : boolean;
                                                                      var   aResult      : ICefBrowserViewDelegate);
begin
  aResult := UnWrap((PCefBrowserViewDelegate(FData)^.get_delegate_for_popup_browser_view(PCefBrowserViewDelegate(FData),
                                                                                         CefGetData(browser_view),
                                                                                         @settings,
                                                                                         CefGetData(client),
                                                                                         ord(is_devtools))));
end;

procedure TCefBrowserViewDelegateRef.OnPopupBrowserViewCreated(const browser_view       : ICefBrowserView;
                                                               const popup_browser_view : ICefBrowserView;
                                                                     is_devtools        : boolean;
                                                               var   aResult            : boolean);
begin
  aResult := (PCefBrowserViewDelegate(FData)^.on_popup_browser_view_created(PCefBrowserViewDelegate(FData),
                                                                            CefGetData(browser_view),
                                                                            CefGetData(popup_browser_view),
                                                                            ord(is_devtools)) <> 0);
end;

procedure TCefBrowserViewDelegateRef.OnGetChromeToolbarType(var aResult : TCefChromeToolbarType);
begin
  aResult := PCefBrowserViewDelegate(FData)^.get_chrome_toolbar_type(PCefBrowserViewDelegate(FData));
end;

procedure TCefBrowserViewDelegateRef.OnUseFramelessWindowForPictureInPicture(const browser_view: ICefBrowserView; var aResult: boolean);
begin
  aResult := (PCefBrowserViewDelegate(FData)^.use_frameless_window_for_picture_in_picture(PCefBrowserViewDelegate(FData),
                                                                                          CefGetData(browser_view)) <> 0);
end;

procedure TCefBrowserViewDelegateRef.OnGestureCommand(const browser_view    : ICefBrowserView;
                                                            gesture_command : TCefGestureCommand;
                                                      var   aResult         : boolean);
begin
  aResult := (PCefBrowserViewDelegate(FData)^.on_gesture_command(PCefBrowserViewDelegate(FData),
                                                                 CefGetData(browser_view),
                                                                 gesture_command) <> 0);
end;

class function TCefBrowserViewDelegateRef.UnWrap(data: Pointer): ICefBrowserViewDelegate;
begin
  if (data <> nil) then
    Result := Create(data) as ICefBrowserViewDelegate
   else
    Result := nil;
end;


// **************************************************************
// **************** TCefBrowserViewDelegateOwn ******************
// **************************************************************

procedure cef_browserview_delegate_on_browser_created(self         : PCefBrowserViewDelegate;
                                                      browser_view : PCefBrowserView;
                                                      browser      : PCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnBrowserCreated(TCefBrowserViewRef.UnWrap(browser_view),
                                                            TCefBrowserRef.UnWrap(browser));
end;

procedure cef_browserview_delegate_on_browser_destroyed(self         : PCefBrowserViewDelegate;
                                                        browser_view : PCefBrowserView;
                                                        browser      : PCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnBrowserDestroyed(TCefBrowserViewRef.UnWrap(browser_view),
                                                              TCefBrowserRef.UnWrap(browser));
end;

function cef_browserview_delegate_get_delegate_for_popup_browser_view(      self         : PCefBrowserViewDelegate;
                                                                            browser_view : PCefBrowserView;
                                                                      const settings     : PCefBrowserSettings;
                                                                            client       : PCefClient;
                                                                            is_devtools  : Integer): PCefBrowserViewDelegate; stdcall;
var
  TempObject   : TObject;
  TempDelegate : ICefBrowserViewDelegate;
begin
  TempObject   := CefGetObject(self);
  TempDelegate := nil;

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnGetDelegateForPopupBrowserView(TCefBrowserViewRef.UnWrap(browser_view),
                                                                            settings^,
                                                                            TCefClientRef.UnWrap(client),
                                                                            is_devtools <> 0,
                                                                            TempDelegate);

  Result := CefGetData(TempDelegate);
end;

function cef_browserview_delegate_on_popup_browser_view_created(self               : PCefBrowserViewDelegate;
                                                                browser_view       : PCefBrowserView;
                                                                popup_browser_view : PCefBrowserView;
                                                                is_devtools        : Integer): Integer; stdcall;
var
  TempObject : TObject;
  TempResult : boolean;
begin
  TempObject := CefGetObject(self);
  TempResult := False;

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnPopupBrowserViewCreated(TCefBrowserViewRef.UnWrap(browser_view),
                                                                     TCefBrowserViewRef.UnWrap(popup_browser_view),
                                                                     is_devtools <> 0,
                                                                     TempResult);

  Result := ord(TempResult);
end;

function cef_browserview_delegate_get_chrome_toolbar_type(self : PCefBrowserViewDelegate): TCefChromeToolbarType; stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);
  Result     := CEF_CTT_NONE;

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnGetChromeToolbarType(Result);
end;

function cef_browserview_delegate_use_frameless_window_for_picture_in_picture(self         : PCefBrowserViewDelegate;
                                                                              browser_view : PCefBrowserView): integer; stdcall;
var
  TempObject : TObject;
  TempResult : boolean;
begin
  TempObject := CefGetObject(self);
  TempResult := False;

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnUseFramelessWindowForPictureInPicture(TCefBrowserViewRef.UnWrap(browser_view),
                                                                                   TempResult);

  Result := ord(TempResult);
end;

function cef_browserview_delegate_on_gesture_command(self               : PCefBrowserViewDelegate;
                                                     browser_view       : PCefBrowserView;
                                                     gesture_command    : TCefGestureCommand): Integer; stdcall;
var
  TempObject : TObject;
  TempResult : boolean;
begin
  TempObject := CefGetObject(self);
  TempResult := False;

  if (TempObject <> nil) and (TempObject is TCefBrowserViewDelegateOwn) then
    TCefBrowserViewDelegateOwn(TempObject).OnGestureCommand(TCefBrowserViewRef.UnWrap(browser_view),
                                                           gesture_command,
                                                           TempResult);

  Result := ord(TempResult);
end;

constructor TCefBrowserViewDelegateOwn.Create;
begin
  inherited CreateData(SizeOf(TCefBrowserViewDelegate));

  InitializeCEFMethods;
end;

procedure TCefBrowserViewDelegateOwn.InitializeCEFMethods;
begin
  inherited InitializeCEFMethods;

  with PCefBrowserViewDelegate(FData)^ do
    begin
      on_browser_created                          := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_on_browser_created;
      on_browser_destroyed                        := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_on_browser_destroyed;
      get_delegate_for_popup_browser_view         := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_get_delegate_for_popup_browser_view;
      on_popup_browser_view_created               := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_on_popup_browser_view_created;
      get_chrome_toolbar_type                     := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_get_chrome_toolbar_type;
      use_frameless_window_for_picture_in_picture := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_use_frameless_window_for_picture_in_picture;
      on_gesture_command                          := {$IFDEF FPC}@{$ENDIF}cef_browserview_delegate_on_gesture_command;
    end;
end;

procedure TCefBrowserViewDelegateOwn.OnBrowserCreated(const browser_view: ICefBrowserView; const browser: ICefBrowser);
begin
  //
end;

procedure TCefBrowserViewDelegateOwn.OnBrowserDestroyed(const browser_view: ICefBrowserView; const browser: ICefBrowser);
begin
  //
end;

procedure TCefBrowserViewDelegateOwn.OnGetDelegateForPopupBrowserView(const browser_view: ICefBrowserView; const settings: TCefBrowserSettings; const client: ICefClient; is_devtools: boolean; var aResult : ICefBrowserViewDelegate);
begin
  aResult := nil;
end;

procedure TCefBrowserViewDelegateOwn.OnPopupBrowserViewCreated(const browser_view, popup_browser_view: ICefBrowserView; is_devtools: boolean; var aResult : boolean);
begin
  aResult := False;
end;

procedure TCefBrowserViewDelegateOwn.OnGetChromeToolbarType(var aResult: TCefChromeToolbarType);
begin
  aResult := CEF_CTT_NONE;
end;

procedure TCefBrowserViewDelegateOwn.OnUseFramelessWindowForPictureInPicture(const browser_view: ICefBrowserView; var aResult: boolean);
begin
  aResult := False;
end;

procedure TCefBrowserViewDelegateOwn.OnGestureCommand(const browser_view: ICefBrowserView; gesture_command: TCefGestureCommand; var aResult : boolean);
begin
  aResult := False;
end;


// **************************************************************
// **************** TCustomBrowserViewDelegate ******************
// **************************************************************

constructor TCustomBrowserViewDelegate.Create(const events: ICefBrowserViewDelegateEvents);
begin
  inherited Create;

  FEvents := Pointer(events);
end;

procedure TCustomBrowserViewDelegate.OnGetPreferredSize(const view: ICefView; var aResult : TCefSize);
begin
  inherited OnGetPreferredSize(view, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGetPreferredSize(view, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGetPreferredSize', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnGetMinimumSize(const view: ICefView; var aResult : TCefSize);
begin
  inherited OnGetMinimumSize(view, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGetMinimumSize(view, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGetMinimumSize', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnGetMaximumSize(const view: ICefView; var aResult : TCefSize);
begin
  inherited OnGetMaximumSize(view, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGetMaximumSize(view, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGetMaximumSize', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnGetHeightForWidth(const view: ICefView; width: Integer; var aResult: Integer);
begin
  inherited OnGetHeightForWidth(view, width, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGetHeightForWidth(view, width, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGetHeightForWidth', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnParentViewChanged(const view: ICefView; added: boolean; const parent: ICefView);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnParentViewChanged(view, added, parent);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnParentViewChanged', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnChildViewChanged(const view: ICefView; added: boolean; const child: ICefView);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnChildViewChanged(view, added, child);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnChildViewChanged', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnWindowChanged(const view: ICefView; added: boolean);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnWindowChanged(view, added);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnWindowChanged', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnLayoutChanged(const view: ICefView; new_bounds: TCefRect);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnLayoutChanged(view, new_bounds);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnLayoutChanged', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnFocus(const view: ICefView);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnFocus(view);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnFocus', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnBlur(const view: ICefView);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnBlur(view);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnBlur', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnBrowserCreated(const browser_view: ICefBrowserView; const browser: ICefBrowser);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnBrowserCreated(browser_view, browser);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnBrowserCreated', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnBrowserDestroyed(const browser_view: ICefBrowserView; const browser: ICefBrowser);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnBrowserDestroyed(browser_view, browser);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnBrowserDestroyed', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnGetDelegateForPopupBrowserView(const browser_view: ICefBrowserView; const settings: TCefBrowserSettings; const client: ICefClient; is_devtools: boolean; var aResult : ICefBrowserViewDelegate);
begin
  inherited OnGetDelegateForPopupBrowserView(browser_view, settings, client, is_devtools, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGetDelegateForPopupBrowserView(browser_view, settings, client, is_devtools, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGetDelegateForPopupBrowserView', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnPopupBrowserViewCreated(const browser_view, popup_browser_view: ICefBrowserView; is_devtools: boolean; var aResult : boolean);
begin
  inherited OnPopupBrowserViewCreated(browser_view, popup_browser_view, is_devtools, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnPopupBrowserViewCreated(browser_view, popup_browser_view, is_devtools, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnPopupBrowserViewCreated', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnGetChromeToolbarType(var aResult: TCefChromeToolbarType);
begin
  inherited OnGetChromeToolbarType(aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGetChromeToolbarType(aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGetChromeToolbarType', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnUseFramelessWindowForPictureInPicture(const browser_view: ICefBrowserView; var aResult: boolean);
begin
  inherited OnUseFramelessWindowForPictureInPicture(browser_view, aResult);

  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnUseFramelessWindowForPictureInPicture(browser_view, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnUseFramelessWindowForPictureInPicture', e) then raise;
  end;
end;

procedure TCustomBrowserViewDelegate.OnGestureCommand(const browser_view    : ICefBrowserView;
                                                            gesture_command : TCefGestureCommand;
                                                      var   aResult         : boolean);
begin
  try
    if (FEvents <> nil) then
      ICefBrowserViewDelegateEvents(FEvents).doOnGestureCommand(browser_view, gesture_command, aResult);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomBrowserViewDelegate.OnGestureCommand', e) then raise;
  end;
end;

end.

