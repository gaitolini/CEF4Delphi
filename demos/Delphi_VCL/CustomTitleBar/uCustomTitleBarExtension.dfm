object CTBForm: TCTBForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'CTBForm'
  ClientHeight = 628
  ClientWidth = 994
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 609
    Width = 994
    Height = 19
    Panels = <
      item
        Width = 1000
      end>
    ExplicitTop = 570
    ExplicitWidth = 978
  end
  object CEFWindowParent1: TCEFWindowParent
    Left = 0
    Top = 0
    Width = 994
    Height = 609
    Align = alClient
    TabOrder = 1
    ExplicitTop = 30
    ExplicitWidth = 978
    ExplicitHeight = 540
  end
  object Chromium1: TChromium
    OnProcessMessageReceived = Chromium1ProcessMessageReceived
    OnLoadEnd = Chromium1LoadEnd
    OnBeforeContextMenu = Chromium1BeforeContextMenu
    OnContextMenuCommand = Chromium1ContextMenuCommand
    OnBeforePopup = Chromium1BeforePopup
    OnAfterCreated = Chromium1AfterCreated
    OnBeforeClose = Chromium1BeforeClose
    OnClose = Chromium1Close
    Left = 32
    Top = 224
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300
    OnTimer = Timer1Timer
    Left = 32
    Top = 288
  end
  object CEFSentinel1: TCEFSentinel
    OnClose = CEFSentinel1Close
    Left = 32
    Top = 352
  end
  object Timer2: TTimer
    Interval = 1
    OnTimer = Timer2Timer
    Left = 624
    Top = 336
  end
end
