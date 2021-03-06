object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 262
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnLog: TButton
    Left = 8
    Top = 8
    Width = 90
    Height = 25
    Caption = 'Log Text'
    TabOrder = 0
    OnClick = btnLogClick
  end
  object btnError: TButton
    Left = 8
    Top = 39
    Width = 90
    Height = 25
    Caption = 'Log Error'
    TabOrder = 1
    OnClick = btnErrorClick
  end
  object btnDebug: TButton
    Left = 8
    Top = 101
    Width = 90
    Height = 25
    Caption = 'Log Debug'
    TabOrder = 2
    OnClick = btnDebugClick
  end
  object btnWarning: TButton
    Left = 8
    Top = 70
    Width = 90
    Height = 25
    Caption = 'Log Warning'
    TabOrder = 3
    OnClick = btnWarningClick
  end
  object gbSeverityFilter: TGroupBox
    Left = 8
    Top = 130
    Width = 90
    Height = 124
    Caption = 'Severity Filter'
    TabOrder = 4
    object chkSeverityLog: TCheckBox
      Left = 16
      Top = 22
      Width = 70
      Height = 17
      Caption = 'Debug'
      TabOrder = 0
      OnClick = OnUpdateFilterSet
    end
    object chkSeverityInfo: TCheckBox
      Left = 16
      Top = 45
      Width = 70
      Height = 17
      Caption = 'Info'
      TabOrder = 1
      OnClick = OnUpdateFilterSet
    end
    object chkSeverityWarning: TCheckBox
      Left = 16
      Top = 68
      Width = 70
      Height = 17
      Caption = 'Warning'
      TabOrder = 2
      OnClick = OnUpdateFilterSet
    end
    object chkSeverityError: TCheckBox
      Left = 16
      Top = 91
      Width = 70
      Height = 17
      Caption = 'Error'
      TabOrder = 3
      OnClick = OnUpdateFilterSet
    end
  end
  object LogMemo: TMemo
    Left = 112
    Top = 8
    Width = 481
    Height = 246
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object Timer1: TTimer
    Interval = 350
    OnTimer = Timer1Timer
    Left = 536
    Top = 216
  end
end
