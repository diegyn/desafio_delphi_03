inherited FormEditar: TFormEditar
  Caption = 'FormEditar'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited pnActions: TPanel
    StyleElements = [seFont, seClient, seBorder]
    object sbGravar: TSpeedButton
      Left = 0
      Top = 0
      Width = 185
      Height = 40
      Align = alTop
      Caption = '&Gravar'
      Enabled = False
      OnClick = sbGravarClick
    end
    object sbCancelar: TSpeedButton
      Left = 0
      Top = 40
      Width = 185
      Height = 40
      Align = alTop
      Caption = '&Cancelar'
      Enabled = False
      OnClick = sbCancelarClick
    end
    object sbExcluir: TSpeedButton
      Left = 0
      Top = 80
      Width = 185
      Height = 40
      Align = alTop
      Caption = '&Excluir'
      Enabled = False
      OnClick = sbExcluirClick
    end
    object sbPesquisar: TSpeedButton
      Left = 0
      Top = 120
      Width = 185
      Height = 40
      Align = alTop
      Caption = '&Pesquisar'
      OnClick = sbPesquisarClick
    end
  end
end
