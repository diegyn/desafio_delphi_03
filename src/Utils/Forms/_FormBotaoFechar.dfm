inherited FormBotaoFechar: TFormBotaoFechar
  Caption = 'FormBotaoFechar'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited pnActions: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitHeight = 441
    object sbFechar: TSpeedButton
      Left = 0
      Top = 401
      Width = 185
      Height = 40
      Align = alBottom
      Caption = '&Fechar'
      OnClick = sbFecharClick
      ExplicitTop = 419
    end
  end
end
