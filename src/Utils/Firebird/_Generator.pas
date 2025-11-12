unit _Generator;

interface

uses
  System.Classes, _Conexao;

type
  TGenerator = class(TComponent)
  private
    query: TConsulta;

    nome: string;
    valor: Integer;
  public
    constructor Create(conexao: TConexao; nome_generator: string); reintroduce;
    destructor Destroy; override;

    function CurrVal: Integer;
    function GetGenerator: string;
    function NextVal: Integer;
  end;

function GetID(const conexao: TConexao; const nome_generator: string): Integer;

implementation

constructor TGenerator.Create(conexao: TConexao; nome_generator: string);
begin
  inherited Create(conexao);

  query := conexao.NovaQuery;
  query.SQL.Add('select GEN_ID(' + nome_generator + ', 1) from RDB$DATABASE');

  nome := nome_generator;
  valor := -1;
end;

function TGenerator.CurrVal: Integer;
begin
  Result := valor;
end;

destructor TGenerator.Destroy;
begin
  query.Free;
  inherited;
end;

function TGenerator.GetGenerator: string;
begin
  Result := nome;
end;

function TGenerator.NextVal: Integer;
begin
  query.Active := True;

  valor := query.Fields[0].AsInteger;

  query.Active := False;

  Result := valor;
end;

function GetID(const conexao: TConexao; const nome_generator: string): Integer;
var
  generator: TGenerator;
begin
  generator := TGenerator.Create(conexao, nome_generator);

  try
    Result := generator.NextVal;
  finally
    generator.Free;
  end;
end;


end.
