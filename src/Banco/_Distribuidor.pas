unit _Distribuidor;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, _Conexao, _Tabela, _Generator;

type
  TDistribuidor = class(TComponent)
  public
    distribuidor_id: Integer;
    nome: string;
    cnpj: string;
  end;

  TDistribuidorArray = TArray<TDistribuidor>;

  Distribuidor = class(TTabela)
  private
    function  GetDISTRIBUIDOR_ID: Integer;
    procedure SetDISTRIBUIDOR_ID(x: Integer);
    function  GetNOME: string;
    procedure SetNOME(x: string);
    function  GetCNPJ: string;
    procedure SetCNPJ(x: string);
  public
    constructor Create(conexao: TConexao);
    function GetDistribuidor: TDistribuidor;
  end;

function GetFiltros: TFiltroArray;

function InserirAtualizar(
  conexao: TConexao;
  distribuidor_id: Integer;
  nome: string;
  cnpj: string
): TRetorno;

function Excluir(con: TConexao; distribuidor_id: Integer): TRetorno;

function BuscarDistribuidores(con: TConexao; indice: Integer; filtros: array of Variant ): TDistribuidorArray;
function BuscarDistribuidoresComando(con: TConexao; comando: string): TDistribuidorArray;

implementation

function GetFiltros: TFiltroArray;
begin
  SetLength(Result, 1);

  Result[0] := _Conexao.NovoFiltro(
    0,
    'Código',
    'where DISTRIBUIDOR_ID = :P1 '
  );
end;

function InserirAtualizar(
  conexao: TConexao;
  distribuidor_id: Integer;
  nome: string;
  cnpj: string
): TRetorno;
var
  novo_registro: Boolean;

  tabela: Distribuidor;
begin
  tabela := Distribuidor.Create(conexao);

  novo_registro := (distribuidor_id = 0);

  Result.houve_erro := False;

  try
    conexao.AbrirTransacao;

    if novo_registro then
      distribuidor_id := _Generator.GetID(conexao, 'GEN_DISTRIBUIDOR_ID');

    tabela.SetDISTRIBUIDOR_ID(distribuidor_id);
    tabela.SetNOME(nome);
    tabela.SetCNPJ(cnpj);

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

function Excluir(con: TConexao; distribuidor_id: Integer): TRetorno;
var
  t: Distribuidor;
begin
  t := Distribuidor.Create(con);

  try
    con.AbrirTransacao;

    t.SetDISTRIBUIDOR_ID(distribuidor_id);
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


function BuscarDistribuidores(con: TConexao; indice: Integer; filtros: array of Variant ): TDistribuidorArray;
var
  i: Integer;
  t: Distribuidor;
begin
  t := Distribuidor.Create(con);

  Result := nil;
  if t.Localizar(indice, filtros) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetDistribuidor;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarDistribuidoresComando(con: TConexao; comando: string): TDistribuidorArray;
var
  i: Integer;
  t: Distribuidor;
begin
  t := Distribuidor.Create(con);

  Result := nil;
  if t.Localizar(comando) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetDistribuidor;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

{ Distribuidor }

constructor Distribuidor.Create(conexao: TConexao);
begin
  inherited Create('DISTRIBUIDORES', conexao);

  sql_base :=
    'select ' +
    '  DISTRIBUIDOR_ID, ' +
    '  NOME, ' +
    '  CNPJ ' +
    'from ' +
    '  DISTRIBUIDORES ';

  filtros := _Distribuidor.GetFiltros;

  chaves.Add('DISTRIBUIDOR_ID');
  campos.Add('NOME');
  campos.Add('CNPJ');
end;

function Distribuidor.GetCNPJ: string;
begin
  Result := campos.ValorParametroStr('CNPJ');
end;

function Distribuidor.GetNOME: string;
begin
  Result := campos.ValorParametroStr('NOME');
end;

function Distribuidor.GetDistribuidor: TDistribuidor;
begin
  Result := TDistribuidor.Create(Application);
  Result.distribuidor_id := GetDISTRIBUIDOR_ID;
  Result.nome := GetNOME;
  Result.cnpj := GetCNPJ;
end;

function Distribuidor.GetDISTRIBUIDOR_ID: Integer;
begin
  Result := chaves.ValorParametroInt('DISTRIBUIDOR_ID');
end;

procedure Distribuidor.SetCNPJ(x: string);
begin
  campos.SetValor('CNPJ', x);
end;

procedure Distribuidor.SetNOME(x: string);
begin
  campos.SetValor('NOME', x);
end;

procedure Distribuidor.SetDISTRIBUIDOR_ID(x: Integer);
begin
  chaves.SetValor('DISTRIBUIDOR_ID', x);
end;

end.
