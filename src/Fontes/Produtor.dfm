inherited FormProdutor: TFormProdutor
  Caption = 'Cadastro de Produtor'
  ClientHeight = 498
  ClientWidth = 868
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 884
  ExplicitHeight = 537
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
  object lbTipoPessoa: TLabel [2]
    Left = 617
    Top = 58
    Width = 63
    Height = 15
    Caption = 'Tipo Pessoa'
  end
  object lbCpfCnpj: TLabel [3]
    Left = 713
    Top = 59
    Width = 44
    Height = 15
    Caption = 'CpfCnpj'
  end
  object Label1: TLabel [4]
    Left = 200
    Top = 136
    Width = 62
    Height = 15
    Caption = 'Distribuidor'
  end
  object Label2: TLabel [5]
    Left = 617
    Top = 136
    Width = 91
    Height = 15
    Caption = 'Limite de Cr'#233'dito'
  end
  inherited pnActions: TPanel
    Height = 498
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 498
    inherited sbFechar: TSpeedButton
      Top = 458
      ExplicitTop = 191
    end
  end
  object eProdutorId: TEdit
    Left = 200
    Top = 29
    Width = 81
    Height = 21
    Alignment = taRightJustify
    TabOrder = 1
    OnKeyDown = eProdutorIdKeyDown
    OnKeyPress = eProdutorIdKeyPress
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
    OnKeyPress = TeclarEnter
  end
  object cbTipoPessoa: TComboBox
    Left = 617
    Top = 79
    Width = 90
    Height = 22
    Style = csOwnerDrawFixed
    Ctl3D = False
    Enabled = False
    ItemIndex = 0
    ParentCtl3D = False
    TabOrder = 3
    Text = 'F'#237'sica'
    OnChange = cbTipoPessoaChange
    OnKeyPress = TeclarEnter
    Items.Strings = (
      'F'#237'sica'
      'Jur'#237'dica')
  end
  object eCpfCnpj: TMaskEdit
    Left = 713
    Top = 80
    Width = 146
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = ''
    OnKeyPress = TeclarEnter
  end
  object pnTitle: TPanel
    Left = 200
    Top = 108
    Width = 660
    Height = 22
    BevelInner = bvLowered
    Caption = 'Vincular Distribuidores'
    TabOrder = 5
  end
  object cbDistribuidores: TComboBox
    Left = 200
    Top = 157
    Width = 410
    Height = 22
    Style = csOwnerDrawFixed
    Enabled = False
    TabOrder = 6
  end
  object eLimiteCredito: TEdit
    Left = 617
    Top = 157
    Width = 140
    Height = 21
    Alignment = taRightJustify
    TabOrder = 7
    OnExit = eLimiteCreditoExit
    OnKeyPress = eLimiteCreditoKeyPress
  end
  object btnAdicionar: TButton
    Left = 763
    Top = 155
    Width = 97
    Height = 25
    Caption = 'Adicionar'
    TabOrder = 8
    OnClick = btnAdicionarClick
  end
  object sgLimiteCredito: TStringGrid
    Left = 200
    Top = 192
    Width = 660
    Height = 298
    ColCount = 3
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
    TabOrder = 9
    ColWidths = (
      64
      383
      177)
  end
end
