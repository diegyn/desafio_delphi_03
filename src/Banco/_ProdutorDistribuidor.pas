unit _ProdutorDistribuidor;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, _Conexao, _Tabela;

type
  TProdutorDistribuidor = class(TComponent)
  public
    produtor_id: Integer;
    distribuidor_id: Integer;
    limite_credito: Double;
  end;

  TProdutorDistribuidorArray = TArray<TProdutorDistribuidor>;

  ProdutorDistribuidor = class(TTabela)
  private
    function  GetPRODUTOR_ID: Integer;
    procedure SetPRODUTOR_ID(x: Integer);
    function  GetDISTRIBUIDOR_ID: Integer;
    procedure SetDISTRIBUIDOR_ID(x: Integer);
    function  GetLIMITE_CREDITO: Double;
    procedure SetLIMITE_CREDITO(x: Double);
  public
    constructor Create(conexao: TConexao);
    function GetProdutorDistribuidor: TProdutorDistribuidor;
  published
    property PRODUTOR_ID: Integer read GetPRODUTOR_ID write SetPRODUTOR_ID;
    property DISTRIBUIDOR_ID: Integer read GetDISTRIBUIDOR_ID write SetDISTRIBUIDOR_ID;
    property LIMITE_CREDITO: Double read GetLIMITE_CREDITO write SetLIMITE_CREDITO;
  end;

function GetFiltros: TFiltroArray;

function BuscarProdutoresDistribuidores(con: TConexao; indice: Integer; filtros: array of Variant ): TProdutorDistribuidorArray;
function BuscarProdutoresDistribuidoresComando(con: TConexao; comando: string): TProdutorDistribuidorArray;

implementation

function GetFiltros: TFiltroArray;
begin
  SetLength(Result, 1);

  Result[0] := _Conexao.NovoFiltro(
    0,
    'Código',
    'where PRODUTOR_ID = :P1 '
  );
end;

function BuscarProdutoresDistribuidores(con: TConexao; indice: Integer; filtros: array of Variant ): TProdutorDistribuidorArray;
var
  i: Integer;
  t: ProdutorDistribuidor;
begin
  t := ProdutorDistribuidor.Create(con);

  Result := nil;
  if t.Localizar(indice, filtros) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetProdutorDistribuidor;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarProdutoresDistribuidoresComando(con: TConexao; comando: string): TProdutorDistribuidorArray;
var
  i: Integer;
  t: ProdutorDistribuidor;
begin
  t := ProdutorDistribuidor.Create(con);

  Result := nil;
  if t.Localizar(comando) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetProdutorDistribuidor;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

{ ProdutorDistribuidor }

constructor ProdutorDistribuidor.Create(conexao: TConexao);
begin
  inherited Create('PRODUTORES_DISTRIBUIDORES', conexao);

  sql_base :=
    'select ' +
    '  PRODUTOR_ID, ' +
    '  DISTRIBUIDOR_ID, ' +
    '  LIMITE_CREDITO ' +
    'from ' +
    '  PRODUTORES_DISTRIBUIDORES ';

  filtros := _ProdutorDistribuidor.GetFiltros;

  chaves.Add('PRODUTOR_ID');
  chaves.Add('DISTRIBUIDOR_ID');
  campos.Add('LIMITE_CREDITO');
end;

function ProdutorDistribuidor.GetDISTRIBUIDOR_ID: Integer;
begin
  Result := chaves.ValorParametroInt('DISTRIBUIDORP_ID');
end;

function ProdutorDistribuidor.GetProdutorDistribuidor: TProdutorDistribuidor;
begin
  Result := TProdutorDistribuidor.Create(Application);
  Result.produtor_id := GetPRODUTOR_ID;
  Result.distribuidor_id := GetDISTRIBUIDOR_ID;
  Result.limite_credito := GetLIMITE_CREDITO;
end;

function ProdutorDistribuidor.GetPRODUTOR_ID: Integer;
begin
  Result := chaves.ValorParametroInt('PRODUTOR_ID');
end;

function ProdutorDistribuidor.GetLIMITE_CREDITO: Double;
begin
  Result := campos.ValorParametroDouble('LIMITE_CREDITO');
end;

procedure ProdutorDistribuidor.SetDISTRIBUIDOR_ID(x: Integer);
begin
  chaves.SetValor('DISTRIBUIDOR_ID', x);
end;

procedure ProdutorDistribuidor.SetPRODUTOR_ID(x: Integer);
begin
  chaves.SetValor('PRODUTOR_ID', x);
end;

procedure ProdutorDistribuidor.SetLIMITE_CREDITO(x: Double);
begin
  campos.SetValor('LIMITE_CREDITO', x);
end;

end.

