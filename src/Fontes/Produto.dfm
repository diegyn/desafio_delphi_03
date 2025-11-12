inherited FormProduto: TFormProduto
  Caption = 'Cadastro de Produtos'
  ClientHeight = 216
  ClientWidth = 755
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 771
  ExplicitHeight = 255
  TextHeight = 15
  object lbProdutorId: TLabel [0]
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
  object lbPreco: TLabel [2]
    Left = 616
    Top = 59
    Width = 30
    Height = 15
    Caption = 'Pre'#231'o'
  end
  inherited pnActions: TPanel
    Height = 216
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 216
    inherited sbFechar: TSpeedButton
      Top = 176
      ExplicitTop = 176
    end
  end
  object eProdutoId: TEdit
    Left = 200
    Top = 29
    Width = 81
    Height = 21
    Alignment = taRightJustify
    TabOrder = 1
    OnKeyDown = eProdutoIdKeyDown
    OnKeyPress = eProdutoIdKeyPress
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
  object ePreco: TEdit
    Left = 616
    Top = 80
    Width = 131
    Height = 21
    Alignment = taRightJustify
    TabOrder = 3
    OnExit = ePrecoExit
    OnKeyPress = ePrecoKeyPress
  end
end
