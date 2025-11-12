inherited FormNegociacao: TFormNegociacao
  Caption = 'Cadastro do Negocia'#231#245'es'
  ClientHeight = 536
  ClientWidth = 865
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 881
  ExplicitHeight = 575
  TextHeight = 15
  object Label1: TLabel [0]
    Left = 200
    Top = 8
    Width = 39
    Height = 15
    Caption = 'C'#243'digo'
  end
  object Label2: TLabel [1]
    Left = 200
    Top = 56
    Width = 47
    Height = 15
    Caption = 'Produtor'
  end
  object Label3: TLabel [2]
    Left = 200
    Top = 106
    Width = 62
    Height = 15
    Caption = 'Distribuidor'
  end
  object Label4: TLabel [3]
    Left = 200
    Top = 183
    Width = 43
    Height = 15
    Caption = 'Produto'
  end
  object Label5: TLabel [4]
    Left = 675
    Top = 185
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  inherited pnActions: TPanel
    Height = 536
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 536
    inherited sbFechar: TSpeedButton
      Top = 496
      ExplicitTop = 496
    end
  end
  object eNegociacaoId: TEdit
    Left = 200
    Top = 29
    Width = 121
    Height = 21
    TabOrder = 1
    OnKeyDown = eNegociacaoIdKeyDown
  end
  object cbProdutores: TComboBox
    Left = 200
    Top = 77
    Width = 662
    Height = 22
    Style = csOwnerDrawFixed
    Enabled = False
    TabOrder = 2
  end
  object cbDistribuidores: TComboBox
    Left = 200
    Top = 127
    Width = 662
    Height = 22
    Style = csOwnerDrawFixed
    Enabled = False
    TabOrder = 3
  end
  object pnProdutos: TPanel
    Left = 198
    Top = 156
    Width = 664
    Height = 18
    BevelInner = bvLowered
    Caption = 'Produtos em negocia'#231#227'o'
    TabOrder = 4
  end
  object cbProdutos: TComboBox
    Left = 200
    Top = 204
    Width = 469
    Height = 23
    Style = csDropDownList
    Enabled = False
    TabOrder = 5
  end
  object Edit2: TEdit
    Left = 675
    Top = 206
    Width = 106
    Height = 21
    Enabled = False
    TabOrder = 6
  end
  object Button1: TButton
    Left = 787
    Top = 202
    Width = 75
    Height = 25
    Caption = 'Button1'
    Enabled = False
    TabOrder = 7
  end
  object sgLimiteCredito: TStringGrid
    Left = 200
    Top = 233
    Width = 660
    Height = 298
    ColCount = 3
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
    TabOrder = 8
    ColWidths = (
      64
      383
      177)
  end
end
