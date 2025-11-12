unit _Execucao;

interface

uses
  System.Variants, System.SysUtils, System.Classes, FireDAC.Stan.Param, _Conexao;

type
  Execucao = class(TComponent)
  private
    con: TConexao;
    query: TConsulta;
  public
    constructor Create(c: TConexao); reintroduce;
    destructor Destroy; override;
    procedure SetSQL(sql: string);
    procedure Executar; overload;
    procedure Executar(valores: array of Variant); overload;
  end;

implementation

constructor Execucao.Create(c: TConexao);
begin
  inherited Create(c);
  con := c;
  query := con.NovaQuery;
end;

procedure Execucao.Executar;
begin
  with query do begin
    Unprepare;
    Prepare;
    ExecSQL;
  end;
end;

destructor Execucao.Destroy;
begin
  query.Free;
  inherited Destroy;
end;

procedure Execucao.Executar(valores: array of Variant);
var
  i: Integer;
begin
  with query do begin
    Unprepare;
    Prepare;

    for i := Low(valores) to High(valores) do
      ParamByName('P' + IntToStr(i + 1)).Value := valores[i];

    ExecSql;
  end;
end;

procedure Execucao.SetSQL(sql: string);
begin
  query.SQL.Clear;
  query.SQL.Add(sql);
end;

end.
