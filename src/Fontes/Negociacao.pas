unit Negociacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _FormEditar, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Grids, Ambiente, _Negociacao, _Produto, _Produtor, _Distribuidor;

type
  TFormNegociacao = class(TFormEditar)
    Label1: TLabel;
    eNegociacaoId: TEdit;
    Label2: TLabel;
    cbProdutores: TComboBox;
    Label3: TLabel;
    cbDistribuidores: TComboBox;
    pnProdutos: TPanel;
    Label4: TLabel;
    cbProdutos: TComboBox;
    Label5: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    sgLimiteCredito: TStringGrid;
    procedure eNegociacaoIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFormNegociacao.eNegociacaoIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
  negociacao: TNegociacaoArray;
begin
  inherited;

  if Key <> VK_RETURN then
    Exit;

  if eNegociacaoId.Text = '' then begin
    Modo(True);
    Exit;
  end;

  negociacao := _Negociacao.BuscarNegociacoes(
    Ambiente.conexao_banco,
    0,
    [StrToInt(eNegociacaoId.Text)]
  );

  if produtor = nil then begin
    ShowMessage('Negociação não encontrada.');
    Modo(False);
    Exit;
  end;

  Modo(True);
end;

end.
