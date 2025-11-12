inherited FormDistribuidor: TFormDistribuidor
  Caption = 'Cadastro de Distribuidor'
  ClientHeight = 231
  ClientWidth = 767
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 783
  ExplicitHeight = 270
  TextHeight = 15
  object lbDistribuidorId: TLabel [0]
    Left = 200
    Top = 8
    Width = 39
    Height = 15
    Caption = 'C'#243'digo'
  end
  object lbNome: TLabel [1]
    Left = 200
    Top = 59
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object lbCnpj: TLabel [2]
    Left = 616
    Top = 59
    Width = 27
    Height = 15
    Caption = 'CNPJ'
  end
  inherited pnActions: TPanel
    Height = 231
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 231
    inherited sbFechar: TSpeedButton
      Top = 191
      ExplicitTop = 191
    end
  end
  object eDistribuidorId: TEdit
    Left = 200
    Top = 29
    Width = 81
    Height = 21
    Alignment = taRightJustify
    TabOrder = 1
    OnKeyDown = eDistribuidorIdKeyDown
    OnKeyPress = eDistribuidorIdKeyPress
  end
  object eNome: TEdit
    Left = 200
    Top = 80
    Width = 410
    Height = 21
    CharCase = ecUpperCase
    Enabled = False
    MaxLength = 150
    TabOrder = 2
  end
  object eCnpj: TMaskEdit
    Left = 616
    Top = 80
    Width = 145
    Height = 21
    Enabled = False
    EditMask = '99.999.999/9999-99'
    MaxLength = 18
    TabOrder = 3
    Text = '  .   .   /    -  '
  end
end
