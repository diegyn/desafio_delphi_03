unit _Conexao;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util,
  FireDAC.Comp.Script;

type
  TFiltro = record
    indice: Integer;
    descricao: string;
    sql: string;
  end;

  TFiltroArray = TArray<TFiltro>;

  TConsulta = class(TFDQuery)
  private
    reg: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    function AsInt(coluna: string): Integer; overload;
    function AsInt(ind: Integer): Integer; overload;
    function AsString(coluna: string): string; overload;
    function AsString(ind: Integer): string; overload;
    function AsDouble(coluna: string): Double; overload;
    function AsDouble(ind: Integer): Double; overload;
    function AsDateTime(coluna: string): TDateTime; overload;
    function AsDateTime(ind: Integer): TDateTime; overload;
    procedure SetPos(posicao: Integer);
    function Pesquisar: Boolean; overload;
    function Pesquisar(valores: array of variant): Boolean; overload;
    function IsNull(ind: Integer): Boolean; overload;
    function IsNull(coluna: string): Boolean; overload;
    function QtdRegistros: Integer;
  end;

  TConexao = class(TComponent)
  private
    senha: string;
  public
    banco_dados: string;
    usuario: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AbrirTransacao;
    function Conectado: Boolean;
    function Conectar: Boolean; overload;
    function Conectar(_usuario: string; _senha: string; _banco_dados: string): Boolean; overload;
    function DataBaseName: string;
    procedure Desconectar;
    procedure FecharTransacao;
    function NovaQuery: TConsulta;
    procedure SetSenha(_senha: string);
    procedure VoltarTransacao;
  protected
    TConexao: TFDConnection;
  end;

function NovoFiltro(indice: Integer; descricao: string; sql: string): TFiltro;

implementation

function NovoFiltro(indice: Integer; descricao: string; sql: string): TFiltro;
begin
  Result.indice := indice;
  Result.descricao := descricao;
  Result.sql := sql;
end;

function TConexao.Conectar: Boolean;
begin
  Result := True;
  Desconectar;

  try
    with TConexao do begin
      Params.DriverID := 'FB';
      Params.Add('CharacterSet=WIN1252');
      Params.Database := banco_dados;
      Params.UserName := usuario;
      Params.Password := senha;

      LoginPrompt := False;

      Connected := True;
    end;
  except
    Result := False;
  end;
end;

function TConexao.Conectado: Boolean;
begin
  Result := TConexao.Connected;
end;

function TConexao.Conectar(_usuario: string; _senha: string; _banco_dados: string): Boolean;
begin
  banco_dados := _banco_dados;
  usuario := _usuario;
  senha := _senha;

  Result := Conectar;
end;

constructor TConexao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TConexao := TFDConnection.Create(Self);
  TConexao.LoginPrompt := False;
end;

destructor TConexao.Destroy;
begin
  Desconectar;
  TConexao.Free;
  inherited Destroy;
end;

procedure TConexao.SetSenha(_senha: string);
begin
  senha := _senha;
end;

procedure TConexao.Desconectar;
begin
  if TConexao.Connected then
    TConexao.Close;
end;

procedure TConexao.AbrirTransacao;
begin
  if not TConexao.InTransaction then
    TConexao.StartTransaction;
end;

procedure TConexao.FecharTransacao;
begin
  TConexao.Commit;
end;

procedure TConexao.VoltarTransacao;
begin
  TConexao.Rollback;
end;

function TConexao.DataBaseName: string;
begin
  Result := TConexao.Params.Database;
end;

function TConexao.NovaQuery: TConsulta;
begin
  Result := TConsulta.Create(Self);
  Result.Connection := TConexao;
  Result.DisableControls;
end;

{ TConsulta }

function TConsulta.AsDateTime(coluna: string): TDateTime;
begin
  Result := FieldByName(coluna).AsDateTime;
end;

function TConsulta.AsDouble(coluna: string): Double;
begin
  Result := FieldByName(coluna).AsFloat;
end;

function TConsulta.AsInt(coluna: string): Integer;
begin
  Result := FieldByName(coluna).AsInteger;
end;

function TConsulta.AsString(coluna: string): string;
begin
  Result := FieldByName(coluna).AsString;
end;

function TConsulta.AsDateTime(ind: Integer): TDateTime;
begin
  Result := Fields[ind].AsDateTime;
end;

function TConsulta.AsDouble(ind: Integer): Double;
begin
  Result := Fields[ind].AsFloat;
end;

function TConsulta.AsInt(ind: Integer): Integer;
begin
  Result := Fields[ind].AsInteger;
end;

function TConsulta.AsString(ind: Integer): string;
begin
  Result := Fields[ind].AsString;
end;

procedure TConsulta.SetPos(posicao: Integer);
var
  i: Integer;
begin
  First;
  for i := 1 to posicao do
    Next;
end;

function TConsulta.Pesquisar: Boolean;
begin
  reg := -1;
  Active := False;
  Unprepare;
  Prepare;
  Active := True;
  Result := not IsEmpty;
end;

function TConsulta.Pesquisar(valores: array of variant): Boolean;
var
  i: Integer;
begin
  reg := -1;
  Active := False;
  Unprepare;
  Prepare;
  for i := Low(valores) to High(valores) do
    ParamByName('P' + IntToStr(i - Low(valores) + 1)).Value := valores[i];
  Active := True;
  Result := not IsEmpty;
end;

function TConsulta.IsNull(ind: Integer): Boolean;
begin
  Result := Fields[ind].IsNull;
end;

function TConsulta.IsNull(coluna: string): Boolean;
begin
  Result := FieldByName(coluna).IsNull;
end;

constructor TConsulta.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  reg := -1;
end;

function TConsulta.QtdRegistros: Integer;
begin
  if not Active then
    reg := -1
  else if reg = -1 then begin
    reg := 0;
    if not IsEmpty then begin
      First;
      while not Eof do begin
        Inc(reg);
        Next;
      end;

      First;
    end;
  end;

  Result := reg;
end;

end.
