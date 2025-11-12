unit Produtor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _FormEditar, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask, Ambiente, _Produtor, _Distribuidor, _ProdutorDistribuidor
  , Vcl.Grids;

type
  TFormProdutor = class(TFormEditar)
    lbProdutorId: TLabel;
    eProdutorId: TEdit;
    lbNome: TLabel;
    eNome: TEdit;
    lbTipoPessoa: TLabel;
    cbTipoPessoa: TComboBox;
    lbCpfCnpj: TLabel;
    eCpfCnpj: TMaskEdit;
    pnTitle: TPanel;
    Label1: TLabel;
    cbDistribuidores: TComboBox;
    Label2: TLabel;
    eLimiteCredito: TEdit;
    btnAdicionar: TButton;
    sgLimiteCredito: TStringGrid;
    procedure eProdutorIdKeyPress(Sender: TObject; var Key: Char);
    procedure cbTipoPessoaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eProdutorIdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eLimiteCreditoKeyPress(Sender: TObject; var Key: Char);
    procedure eLimiteCreditoExit(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
  private
    { Private declarations }
    distribuidores: TDistribuidorArray;

    procedure LimparGrid;
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

const
  cCPF  = 0;
  cCNPJ = 1;

  cCodigo         = 0;
  cDistribuidor   = 1;
  cLimite_Credito = 2;

  cMask_CPF  = '999.999.999-99';
  cMask_CNPJ = '99.999.999/9999-99';

procedure TFormProdutor.btnAdicionarClick(Sender: TObject);
var
  i: Integer;
  linha: Integer;
  adicionado: Boolean;
begin
  inherited;

  if cbDistribuidores.ItemIndex = -1 then begin
    ShowMessage('É necessário informar o distribuidor');
    Exit;
  end;

  if (eLimiteCredito.Text = '') or (eLimiteCredito.Text = '0,00') then begin
    ShowMessage('É necessário informar o limite de crédito');
    Exit;
  end;

  adicionado := False;
  for i := 1 to sgLimiteCredito.RowCount - 1 do begin
    adicionado := StrToIntDef(sgLimiteCredito.Cells[cCodigo, i], 0) = distribuidores[cbDistribuidores.ItemIndex].distribuidor_id;

    if adicionado then
      break;
  end;

  if adicionado then begin
    ShowMessage('Esse distribuidor já foi adicionado');
    Exit;
  end;

  linha := sgLimiteCredito.RowCount - 1;

  if sgLimiteCredito.Cells[cCodigo, linha] <> '' then begin
    sgLimiteCredito.RowCount := sgLimiteCredito.RowCount + 1;
    linha := sgLimiteCredito.RowCount - 1;
  end;

  // Preenche os dados
  sgLimiteCredito.Cells[cCodigo, linha] := IntToStr(distribuidores[cbDistribuidores.ItemIndex].distribuidor_id);
  sgLimiteCredito.Cells[cDistribuidor, linha] := distribuidores[cbDistribuidores.ItemIndex].nome;
  sgLimiteCredito.Cells[cLimite_Credito, linha] := eLimiteCredito.Text;

  sgLimiteCredito.Row := linha;
end;

procedure TFormProdutor.cbTipoPessoaChange(Sender: TObject);
begin
  inherited;

  if cbTipoPessoa.ItemIndex = cCNPJ then begin
    lbCpfCnpj.Caption := 'CNPJ';
    eCpfCnpj.EditMask := cMask_CNPJ
  end
  else begin
    lbCpfCnpj.Caption := 'CPF';
    eCpfCnpj.EditMask := cMask_CPF;
  end;

end;

procedure TFormProdutor.eLimiteCreditoExit(Sender: TObject);
var
  valor: Double;
begin
  inherited;
  if TryStrToFloat(StringReplace(eLimiteCredito.Text, ',', '.', []), valor) then
    eLimiteCredito.Text := FormatFloat('0.00', valor)
  else
    eLimiteCredito.Text := '0,00';
end;

procedure TFormProdutor.eLimiteCreditoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not CharInSet(Key,[^H, ^V, ^X, #13, #27, '0'..'9', #8, ',']) then
    Key := #0;


  if (Key = ',') and (Pos(',', TEdit(Sender).Text) > 0) then
    Key := #0;

  TeclarEnter(Sender, Key);
end;

procedure TFormProdutor.eProdutorIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
  produtor: TProdutorArray;
begin
  inherited;

  if Key <> VK_RETURN then
    Exit;

  if eProdutorId.Text = '' then begin
    Modo(True);
    Exit;
  end;

  produtor := _Produtor.BuscarProdutores(
    Ambiente.conexao_banco,
    0,
    [StrToInt(eProdutorId.Text)]
  );

  if produtor = nil then begin
    ShowMessage('Produtor não encontrado.');
    Modo(False);
    Exit;
  end;

  Modo(True);

  eNome.Text := produtor[0].nome;

  if produtor[0].tipo_pessoa = 'J' then
    cbTipoPessoa.ItemIndex := cCNPJ
  else
    cbTipoPessoa.ItemIndex := cCPF;

  eCpfCnpj.Text := produtor[0].cpf_cnpj;

  if Length(produtor) > 0 then begin
    for i := Low(produtor) to High(produtor) do begin
      produtor[i].Free;
      produtor[i] := nil;
    end;

    SetLength(produtor, 0);
  end;
end;

procedure TFormProdutor.eProdutorIdKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not CharInSet(Key,[^H, ^V, ^X, #13, #27, '0'..'9', #8]) then
    Key := #0;

  TeclarEnter(Sender, Key);
end;

function TFormProdutor.Excluir: Boolean;
begin
  Result := False;

  try
    _Produtor.Excluir(Ambiente.conexao_banco, StrToInt(eProdutorId.Text));
    ShowMessage('Produtor excluído com sucesso');
    Result := True;
  except
    ShowMessage('Não foi possível excluir o produtor');
  end;
end;

procedure TFormProdutor.FormCreate(Sender: TObject);
begin
  inherited;
  cbTipoPessoaChange(Sender);
  LimparGrid;
end;

function TFormProdutor.Gravar: Boolean;
var
  i: Integer;
  linhas: Integer;

  produtor_id: Integer;
  tipo_pessoa: string;

  produtorDistribuidor: TProdutorDistribuidor;
  produtoresDistribuidores: TProdutorDistribuidorArray;
begin
  Result := True;

  produtor_id := 0;

  if eProdutorId.Text <> '' then
    produtor_id := StrToInt(eProdutorId.Text);

  tipo_pessoa := 'F';
  if cbTipoPessoa.ItemIndex = cCNPJ then
    tipo_pessoa := 'J';


  if sgLimiteCredito.Cells[cCodigo, sgLimiteCredito.FixedRows] <> '' then begin
    linhas := sgLimiteCredito.RowCount - 1;
    SetLength(produtoresDistribuidores, linhas);

    for i := sgLimiteCredito.FixedRows to sgLimiteCredito.RowCount - 1 do begin

      produtorDistribuidor := TProdutorDistribuidor.Create(Application);

      produtorDistribuidor.produtor_id := StrToIntDef(eProdutorId.Text, 0); // ID do produtor
      produtorDistribuidor.distribuidor_id := StrToIntDef(sgLimiteCredito.Cells[0, i], 0);
      produtorDistribuidor.limite_credito := StrToFloatDef(StringReplace(sgLimiteCredito.Cells[2, i], ',', '.', [rfReplaceAll]), 0);
      produtoresDistribuidores[i - 1] := produtorDistribuidor;
    end;
  end;

  try
    _Produtor.InserirAtualizar(
      Ambiente.conexao_banco,
      produtor_id,
      eNome.Text,
      tipo_pessoa,
      eCpfCnpj.Text,
      produtoresDistribuidores
    );

    for i := Low(produtoresDistribuidores) to High(produtoresDistribuidores) do
      produtoresDistribuidores[i].Free;

    SetLength(produtoresDistribuidores, 0);

    ShowMessage('Produtor cadastrado com sucesso');
  except
    ShowMessage('Não foi possível cadastrar o produtor');
    Result := False;
  end;
end;

procedure TFormProdutor.LimparGrid;
var
  Col, Row: Integer;
begin
  // Define colunas fixas
  sgLimiteCredito.ColCount := 3;
  sgLimiteCredito.FixedCols := 0;

  // Define linhas
  sgLimiteCredito.RowCount := 2;

  // Limpa todas as células de dados (exceto cabeçalho)
  for Row := 1 to sgLimiteCredito.RowCount - 1 do
    for Col := 0 to sgLimiteCredito.ColCount - 1 do
      sgLimiteCredito.Cells[Col, Row] := '';

  // Define valores da primeira linha (cabeçalho)
  sgLimiteCredito.Cells[0, 0] := 'Código';
  sgLimiteCredito.Cells[1, 0] := 'Distribuidor';
  sgLimiteCredito.Cells[2, 0] := 'Limite de Crédito';
end;

procedure TFormProdutor.Modo(editando: Boolean);
var
  i: Integer;
begin
  inherited;

  Ambiente.Habilitar([eProdutorId], not editando, False);

  Ambiente.Habilitar(
    [
      cbTipoPessoa,
      eCpfCnpj,
      eNome,
      cbDistribuidores,
      eLimiteCredito,
      btnAdicionar
    ],
    editando,
    True
  );

  if editando then begin
    distribuidores := _Distribuidor.BuscarDistribuidoresComando(Ambiente.conexao_banco, 'ORDER BY NOME');

    cbDistribuidores.Items.Clear;
    if length(distribuidores) > 0 then begin
      for i := Low(distribuidores) to High(distribuidores) do
        cbDistribuidores.items.Add(distribuidores[i].nome)
    end;

    cbTipoPessoa.ItemIndex := cCPF;
  end
  else begin
    LimparGrid;
    eProdutorId.Clear;
    eProdutorId.SetFocus;
  end;
end;

procedure TFormProdutor.Pesquisar;
begin
  inherited;

end;

procedure TFormProdutor.VerificarDados;
begin
  inherited;

end;

end.
