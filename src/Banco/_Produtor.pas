unit _Produtor;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, _Conexao, _Tabela, _Execucao,
  _Generator, _ProdutorDistribuidor;

type
  TProdutor = class(TComponent)
  public
    produtor_id: Integer;
    nome: string;
    tipo_pessoa: string;
    cpf_cnpj: string;
  end;

  TProdutorArray = TArray<TProdutor>;

  Produtor = class(TTabela)
  private
    function  GetPRODUTOR_ID: Integer;
    procedure SetPRODUTOR_ID(x: Integer);
    function  GetNOME: string;
    procedure SetNOME(x: string);
    function  GetTIPO_PESSOA: string;
    procedure SetTIPO_PESSOA(x: string);
    function  GetCPF_CNPJ: string;
    procedure SetCPF_CNPJ(x: string);
  public
    constructor Create(conexao: TConexao);
    function GetProdutor: TProdutor;
  end;

function GetFiltros: TFiltroArray;

function InserirAtualizar(
  conexao: TConexao;
  produtor_id: Integer;
  nome: string;
  tipo_pessoa: string;
  cpf_cnpj: string;
  distribuidores: TProdutorDistribuidorArray
): TRetorno;

function Excluir(con: TConexao; produtor_id: Integer): TRetorno;

function BuscarProdutores(con: TConexao; indice: Integer; filtros: array of Variant ): TProdutorArray;
function BuscarProdutoresComando(con: TConexao; comando: string): TProdutorArray;

implementation

function GetFiltros: TFiltroArray;
begin
  SetLength(Result, 1);

  Result[0] := _Conexao.NovoFiltro(
    0,
    'Código do Produtor',
    'where PRODUTOR_ID = :P1 '
  );
end;

function InserirAtualizar(
  conexao: TConexao;
  produtor_id: Integer;
  nome: string;
  tipo_pessoa: string;
  cpf_cnpj: string;
  distribuidores: TProdutorDistribuidorArray
): TRetorno;
var
  i: Integer;
  novo_registro: Boolean;

  tabela: Produtor;
  tabelaProdutorDistribuidor: ProdutorDistribuidor;

  ex: Execucao;
begin
  tabela := Produtor.Create(conexao);
  tabelaProdutorDistribuidor := ProdutorDistribuidor.Create(conexao);

  ex := Execucao.Create(conexao);

  novo_registro := (produtor_id = 0);

  Result.houve_erro := False;

  try
    conexao.AbrirTransacao;

    if novo_registro then
      produtor_id := _Generator.GetID(conexao, 'GEN_PRODUTOR_ID');

    tabela.SetPRODUTOR_ID(produtor_id);
    tabela.SetNOME(nome);
    tabela.SetTIPO_PESSOA(tipo_pessoa);
    tabela.SetCPF_CNPJ(cpf_cnpj);

    if novo_registro then
      tabela.Inserir
    else
      tabela.Atualizar;

    ex.SetSQL('delete from PRODUTORES_DISTRIBUIDORES where PRODUTOR_ID = :P1');
    ex.Executar([produtor_id]);

    if distribuidores <> nil then begin
      tabelaProdutorDistribuidor := ProdutorDistribuidor.Create(conexao);

      for i := Low(distribuidores) to High(distribuidores) do begin
        tabelaProdutorDistribuidor.PRODUTOR_ID := produtor_id;
        tabelaProdutorDistribuidor.DISTRIBUIDOR_ID := distribuidores[i].distribuidor_id;
        tabelaProdutorDistribuidor.LIMITE_CREDITO := distribuidores[i].limite_credito;
        tabelaProdutorDistribuidor.Inserir;
      end;

      FreeAndNil(tabelaProdutorDistribuidor);
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

function Excluir(con: TConexao; produtor_id: Integer): TRetorno;
var
  t: Produtor;
begin
  t := Produtor.Create(con);

  try
    con.AbrirTransacao;

    t.SetPRODUTOR_ID(produtor_id);
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

function BuscarProdutores(con: TConexao; indice: Integer; filtros: array of Variant ): TProdutorArray;
var
  i: Integer;
  t: Produtor;
begin
  t := Produtor.Create(con);

  Result := nil;
  if t.Localizar(indice, filtros) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetProdutor;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarProdutoresComando(con: TConexao; comando: string): TProdutorArray;
var
  i: Integer;
  t: Produtor;
begin
  t := Produtor.Create(con);

  Result := nil;
  if t.Localizar(comando) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetProdutor;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

{ Produtor }

constructor Produtor.Create(conexao: TConexao);
begin
  inherited Create('PRODUTORES', conexao);

  sql_base :=
    'select ' +
    '  PRODUTOR_ID, ' +
    '  NOME, ' +
    '  TIPO_PESSOA, ' +
    '  CPF_CNPJ ' +
    'from ' +
    '  PRODUTORES ';

  filtros := _Produtor.GetFiltros;

  chaves.Add('PRODUTOR_ID');
  campos.Add('NOME');
  campos.Add('TIPO_PESSOA');
  campos.Add('CPF_CNPJ');
end;

function Produtor.GetCPF_CNPJ: string;
begin
  Result := campos.ValorParametroStr('CPF_CNPJ');
end;

function Produtor.GetNOME: string;
begin
  Result := campos.ValorParametroStr('NOME');
end;

function Produtor.GetProdutor: TProdutor;
begin
  Result := TProdutor.Create(Application);
  Result.produtor_id := GetPRODUTOR_ID;
  Result.nome := GetNOME;
  Result.tipo_pessoa := GetTIPO_PESSOA;
  Result.cpf_cnpj := GetCPF_CNPJ;
end;

function Produtor.GetPRODUTOR_ID: Integer;
begin
  Result := chaves.ValorParametroInt('PRODUTOR_ID');
end;

function Produtor.GetTIPO_PESSOA: string;
begin
  Result := campos.ValorParametroStr('TIPO_PESSOA');
end;

procedure Produtor.SetCPF_CNPJ(x: string);
begin
  campos.SetValor('CPF_CNPJ', x);
end;

procedure Produtor.SetNOME(x: string);
begin
  campos.SetValor('NOME', x);
end;

procedure Produtor.SetPRODUTOR_ID(x: Integer);
begin
  chaves.SetValor('PRODUTOR_ID', x);
end;

procedure Produtor.SetTIPO_PESSOA(x: string);
begin
  campos.SetValor('TIPO_PESSOA', x);
end;

end.
