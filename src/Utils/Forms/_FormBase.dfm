object FormBase: TFormBase
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'FormBase'
  ClientHeight = 441
  ClientWidth = 624
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object pnActions: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 441
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 24
    ExplicitTop = 56
    ExplicitHeight = 41
  end
end
