object FormMenu: TFormMenu
  Left = 0
  Top = 0
  Caption = 'Controle de Negocia'#231#227'o'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mmMenu
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 15
  object mmMenu: TMainMenu
    Left = 8
    Top = 408
    object miCadastros: TMenuItem
      Caption = 'Cadastros'
      object miProdutor: TMenuItem
        Caption = 'Produtor'
        OnClick = miProdutorClick
      end
      object miDistribuidor: TMenuItem
        Caption = 'Distribuidor'
        OnClick = miDistribuidorClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miProduto: TMenuItem
        Caption = 'Produto'
        OnClick = miProdutoClick
      end
    end
  end
end
