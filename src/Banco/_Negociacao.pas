unit _Negociacao;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, _Conexao, _Tabela, _Execucao, _Generator,
  _NegociacaoItem;

type
  TNegociacao = class(TComponent)
  public
    negociacao_id: Integer;
    produtor_id: Integer;
    distribuidor_id: Integer;
    status: string;
  end;

  TNegociacaoArray = TArray<TNegociacao>;

  Negociacao = class(TTabela)
  private
    function  GetNEGOCIACAO_ID: Integer;
    procedure SetNEGOCIACAO_ID(x: Integer);
    function  GetPRODUTOR_ID: Integer;
    procedure SetPRODUTOR_ID(x: Integer);
    function  GetDISTRIBUIDOR_ID: Integer;
    procedure SetDISTRIBUIDOR_ID(x: Integer);
    function  GetSTATUS: string;
  public
    constructor Create(conexao: TConexao);
    function GetNegociacao: TNegociacao;
  end;

function GetFiltros: TFiltroArray;

function InserirAtualizar(
  conexao: TConexao;
  negociacao_id: Integer;
  produtor_id: Integer;
  distribuidor_id: Integer;
  itens: TNegociacaoItemArray
): TRetorno;

function Excluir(con: TConexao; negociacao_id: Integer): TRetorno;

function BuscarNegociacoes(con: TConexao; indice: Integer; filtros: array of Variant ): TNegociacaoArray;
function BuscarNegociacoesComando(con: TConexao; comando: string): TNegociacaoArray;

implementation

function GetFiltros: TFiltroArray;
begin
  SetLength(Result, 1);

  Result[0] := _Conexao.NovoFiltro(
    0,
    'Código',
    'where NEGOCIACAO_ID = :P1 '
  );
end;

function InserirAtualizar(
  conexao: TConexao;
  negociacao_id: Integer;
  produtor_id: Integer;
  distribuidor_id: Integer;
  itens: TNegociacaoItemArray
): TRetorno;
var
  i: Integer;
  novo_registro: Boolean;

  tabela: Negociacao;
  tabelaItem: NegociacaoItem;

  ex: Execucao;
begin
  tabela := Negociacao.Create(conexao);
  ex := Execucao.Create(conexao);

  novo_registro := (negociacao_id = 0);

  Result.houve_erro := False;

  try
    conexao.AbrirTransacao;

    if novo_registro then
      negociacao_id := _Generator.GetID(conexao, 'GEN_NEGOCIACAO_ID');

    tabela.SetNEGOCIACAO_ID(negociacao_id);
    tabela.SetPRODUTOR_ID(produtor_id);
    tabela.SetDISTRIBUIDOR_ID(distribuidor_id);

    if novo_registro then
      tabela.Inserir
    else
      tabela.Atualizar;

    ex.SetSQL('delete from NEGOCIACOES_ITENS where NEGOCIACAO_ID = :P1');
    ex.Executar([negociacao_id]);

    if itens <> nil then begin
      tabelaItem := NegociacaoItem.Create(conexao);

      for i := Low(itens) to High(itens) do begin
        tabelaItem.NEGOCIACAO_ID := negociacao_id;
        tabelaItem.ITEM_ID := i;
        tabelaItem.PRODUTO_ID := itens[i].produto_id;
        tabelaItem.QUANTIDADE := itens[i].quantidade;
        tabelaItem.PRECO := itens[i].preco;
        tabelaItem.Inserir;
      end;

      FreeAndNil(tabelaItem);
    end;

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

function Excluir(con: TConexao; negociacao_id: Integer): TRetorno;
var
  t: Negociacao;
begin
  t := Negociacao.Create(con);

  try
    con.AbrirTransacao;

    t.SetNEGOCIACAO_ID(negociacao_id);
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


function BuscarNegociacoes(con: TConexao; indice: Integer; filtros: array of Variant ): TNegociacaoArray;
var
  i: Integer;
  t: Negociacao;
begin
  t := Negociacao.Create(con);

  Result := nil;
  if t.Localizar(indice, filtros) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetNegociacao;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarNegociacoesComando(con: TConexao; comando: string): TNegociacaoArray;
var
  i: Integer;
  t: Negociacao;
begin
  t := Negociacao.Create(con);

  Result := nil;
  if t.Localizar(comando) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetNegociacao;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

{ Negociacao }

constructor Negociacao.Create(conexao: TConexao);
begin
  inherited Create('NEGOCIACOES', conexao);

  sql_base :=
    'select ' +
    '  NEGOCIACAO_ID, ' +
    '  PRODUTOR_ID, ' +
    '  DISTRIBUIDOR_ID, ' +
    '  STATUS ' +
    'from ' +
    '  NEGOCIACOES ';

  filtros := _Negociacao.GetFiltros;

  chaves.Add('NEGOCIACAO_ID');
  campos.Add('PRODUTOR_ID');
  campos.Add('DISTRIBUIDOR_ID');
  campos.Add(True, 'STATUS');
end;

function Negociacao.GetDISTRIBUIDOR_ID: Integer;
begin
  Result := campos.ValorParametroInt('DISTRIBUIDOR_ID');
end;

function Negociacao.GetNegociacao: TNegociacao;
begin
  Result := TNegociacao.Create(Application);
  Result.negociacao_id := GetNEGOCIACAO_ID;
  Result.produtor_id := GetPRODUTOR_ID;
  Result.distribuidor_id := GetDISTRIBUIDOR_ID;
  Result.status := GetStatus;
end;

function Negociacao.GetNEGOCIACAO_ID: Integer;
begin
  Result := chaves.ValorParametroInt('NEGOCIACAO_ID');
end;

function Negociacao.GetPRODUTOR_ID: Integer;
begin
  Result := campos.ValorParametroInt('PRODUTOR_ID');
end;

function Negociacao.GetSTATUS: string;
begin
  Result := campos.ValorParametroStr('STATUS');
end;

procedure Negociacao.SetDISTRIBUIDOR_ID(x: Integer);
begin
  campos.SetValor('DISTRIBUIDOR', x);
end;

procedure Negociacao.SetNEGOCIACAO_ID(x: Integer);
begin
  chaves.SetValor('NEGOCIACAO_ID', x);
end;

procedure Negociacao.SetPRODUTOR_ID(x: Integer);
begin
  campos.SetValor('PRODUTOR', x);
end;

end.

