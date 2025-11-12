unit Produto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _FormEditar, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, Ambiente, _Produto;

type
  TFormProduto = class(TFormEditar)
    lbProdutorId: TLabel;
    eProdutoId: TEdit;
    lbNome: TLabel;
    eNome: TEdit;
    lbPreco: TLabel;
    ePreco: TEdit;
    procedure eProdutoIdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eProdutoIdKeyPress(Sender: TObject; var Key: Char);
    procedure ePrecoKeyPress(Sender: TObject; var Key: Char);
    procedure ePrecoExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function Excluir: Boolean; override;
    function Gravar: Boolean; override;
    procedure Modo(Editando: Boolean); override;
    procedure Pesquisar; override;
    procedure VerificarDados; override;
  end;

implementation

{$R *.dfm}

procedure TFormProduto.ePrecoExit(Sender: TObject);
var
  valor: Double;
begin
  inherited;

  if TryStrToFloat(StringReplace(ePreco.Text, ',', '.', []), valor) then
    ePreco.Text := FormatFloat('0.00', valor)
  else
    ePreco.Text := '0,00';
end;

procedure TFormProduto.ePrecoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not CharInSet(Key,[^H, ^V, ^X, #13, #27, '0'..'9', #8, ',']) then
    Key := #0;


  if (Key = ',') and (Pos(',', TEdit(Sender).Text) > 0) then
    Key := #0;

  TeclarEnter(Sender, Key);

end;

procedure TFormProduto.eProdutoIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
  produto: TProdutoArray;
begin
  inherited;

  if Key <> VK_RETURN then
    Exit;

  if eProdutoId.Text = '' then begin
    Modo(True);
    Exit;
  end;

  produto := _Produto.BuscarProdutos(
    Ambiente.conexao_banco,
    0,
    [StrToInt(eProdutoId.Text)]
  );

  if produto = nil then begin
    ShowMessage('Produto não encontrado.');
    Modo(False);
    Exit;
  end;

  Modo(True);

  eNome.Text := produto[0].nome;
  ePreco.Text := FormatFloat('0.00', produto[0].preco);

  if Length(produto) > 0 then begin
    for i := Low(produto) to High(produto) do begin
      produto[i].Free;
      produto[i] := nil;
    end;

    SetLength(produto, 0);
  end;
end;

procedure TFormProduto.eProdutoIdKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not CharInSet(Key,[^H, ^V, ^X, #13, #27, '0'..'9', #8]) then
    Key := #0;

  TeclarEnter(Sender, Key);
end;

function TFormProduto.Excluir: Boolean;
begin
  Result := False;

  try
    _Produto.Excluir(Ambiente.conexao_banco, StrToInt(eProdutoId.Text));
    ShowMessage('Produto excluído');
    Result := True;
  except
    ShowMessage('Não foi possível excluir o produto');
  end;
end;

function TFormProduto.Gravar: Boolean;
var
  produto_id: Integer;
begin
  Result := False;

  produto_id := 0;
  if eProdutoId.Text <> '' then
    produto_id := StrToInt(eProdutoId.Text);

  try
    _Produto.InserirAtualizar(
      Ambiente.conexao_banco,
      produto_id,
      eNome.Text,
      StrToFloat(ePreco.Text)
    );

    ShowMessage('Produto cadastrado com sucesso');
    Result := True;
  except
    ShowMessage('Não foi possível cadastrar o produto');
  end;
end;

procedure TFormProduto.Modo(Editando: Boolean);
begin
  inherited;

  Ambiente.Habilitar([eProdutoId], not editando, False);

  Ambiente.Habilitar(
    [eNome, ePreco],
    editando,
    True
  );

  if not editando then begin
    eProdutoId.Clear;
    eProdutoId.SetFocus;
  end;
end;

procedure TFormProduto.Pesquisar;
begin
  inherited;

end;

procedure TFormProduto.VerificarDados;
begin
  inherited;

end;

end.
