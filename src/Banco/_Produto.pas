unit _Produto;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, _Conexao, _Tabela, _Generator;

type
  TProduto = class(TComponent)
  public
    produto_id: Integer;
    nome: string;
    preco: Double;
  end;

  TProdutoArray = TArray<TProduto>;

  Produto = class(TTabela)
  private
    function  GetPRODUTO_ID: Integer;
    procedure SetPRODUTO_ID(x: Integer);
    function  GetNOME: string;
    procedure SetNOME(x: string);
    function  GetPRECO: Double;
    procedure SetPRECO(x: Double);
  public
    constructor Create(conexao: TConexao);
    function GetProduto: TProduto;
  end;

function GetFiltros: TFiltroArray;

function InserirAtualizar(
  conexao: TConexao;
  produto_id: Integer;
  nome: string;
  preco: Double
): TRetorno;

function Excluir(con: TConexao; produto_id: Integer): TRetorno;

function BuscarProdutos(con: TConexao; indice: Integer; filtros: array of Variant ): TProdutoArray;
function BuscarProdutosComando(con: TConexao; comando: string): TProdutoArray;



implementation

function GetFiltros: TFiltroArray;
begin
  SetLength(Result, 1);

  Result[0] := _Conexao.NovoFiltro(
    0,
    'Código',
    'where PRODUTO_ID = :P1 '
  );
end;

function InserirAtualizar(
  conexao: TConexao;
  produto_id: Integer;
  nome: string;
  preco: Double
): TRetorno;
var
  novo_registro: Boolean;

  tabela: Produto;
begin
  tabela := Produto.Create(conexao);

  novo_registro := (produto_id = 0);

  Result.houve_erro := False;

  try
    conexao.AbrirTransacao;

    if novo_registro then
      produto_id := _Generator.GetID(conexao, 'GEN_PRODUTO_ID');

    tabela.SetPRODUTO_ID(produto_id);
    tabela.SetNOME(nome);
    tabela.SetPRECO(preco);

    if novo_registro then
      tabela.Inserir
    else
      tabela.Atualizar;

    conexao.FecharTransacao;
  except on e: Exception do
    begin
      conexao.VoltarTransacao;
      Result.houve_erro := True;
      Result.mensagem := e.Message;
    end;
  end;

  FreeAndNil(tabela);
end;

function Excluir(con: TConexao; produto_id: Integer): TRetorno;
var
  t: Produto;
begin
  t := Produto.Create(con);

  try
    con.AbrirTransacao;

    t.SetPRODUTO_ID(produto_id);
    t.Excluir;

    con.FecharTransacao;
  except on e: Exception do
    begin
      con.VoltarTransacao;
      Result.houve_erro := True;
      Result.mensagem := e.Message;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarProdutos(con: TConexao; indice: Integer; filtros: array of Variant ): TProdutoArray;
var
  i: Integer;
  t: Produto;
begin
  t := Produto.Create(con);

  Result := nil;
  if t.Localizar(indice, filtros) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetProduto;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarProdutosComando(con: TConexao; comando: string): TProdutoArray;
var
  i: Integer;
  t: Produto;
begin
  t := Produto.Create(con);

  Result := nil;
  if t.Localizar(comando) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetProduto;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

{ Produto }

constructor Produto.Create(conexao: TConexao);
begin
  inherited Create('PRODUTOS', conexao);

  sql_base :=
    'select ' +
    '  PRODUTO_ID, ' +
    '  NOME, ' +
    '  PRECO ' +
    'from ' +
    '  PRODUTOS ';

  filtros := _Produto.GetFiltros;

  chaves.Add('PRODUTO_ID');
  campos.Add('NOME');
  campos.Add('PRECO');
end;

function Produto.GetPRECO: Double;
begin
  Result := campos.ValorParametroDouble('PRECO');
end;

function Produto.GetNOME: string;
begin
  Result := campos.ValorParametroStr('NOME');
end;

function Produto.GetProduto: TProduto;
begin
  Result := TProduto.Create(Application);
  Result.produto_id := GetPRODUTO_ID;
  Result.nome := GetNOME;
  Result.preco := GetPRECO;
end;

function Produto.GetPRODUTO_ID: Integer;
begin
  Result := chaves.ValorParametroInt('PRODUTO_ID');
end;

procedure Produto.SetPRECO(x: Double);
begin
  campos.SetValor('PRECO', x);
end;

procedure Produto.SetNOME(x: string);
begin
  campos.SetValor('NOME', x);
end;

procedure Produto.SetPRODUTO_ID(x: Integer);
begin
  chaves.SetValor('PRODUTO_ID', x);
end;

end.
