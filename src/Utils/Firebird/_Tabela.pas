unit _Tabela;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Data.DB, FireDAC.Stan.Param,
  _Conexao, _Execucao;

type
  TRetorno = record
    houve_erro: Boolean;
    mensagem: string;
    retorno_int: Integer;
    retorno_str: string;
  end;

  TColuna = class(TComponent)
  public
    nome: string;
    somente_leitura: Boolean;
    valor: Variant;
  end;

  TColunas = class(TComponent)
  private
    par: TList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  Add(nome: string): Integer; overload;
    function  Add(somenteleitura: Boolean; nome: string): Integer; overload;
    function  Add(nome: string; valor: Variant): Integer; overload;
    function  Add(somenteleitura: Boolean; nome: string; valor: Variant): Integer; overload;
    procedure Clear;
    function  Count: Integer;
    function  GetSomenteLeitura(indice: Integer): Boolean;
    function  Ind(nome_coluna: string): Integer;
    function  NomeParametro(indice: Integer): string;
    procedure ParametrosNulos;
    procedure Remove(indice: Integer); overload;
    procedure Remove(nome_coluna: string); overload;
    procedure SetSomenteLeitura(indice: Integer; somente_leitura: Boolean);
    procedure SetValor(indice: Integer; valor: Variant); overload;
    procedure SetValor(nome_coluna: string; valor: Variant); overload;

    function  ValorParametro(indice: Integer): Variant; overload;
    function  ValorParametro(nome_coluna: string): Variant; overload;
    function  ValorParametroData(indice: Integer): TDateTime; overload;
    function  ValorParametroData(nome_coluna: string): TDateTime; overload;
    function  ValorParametroHora(indice: Integer): TDateTime; overload;
    function  ValorParametroHora(nome_coluna: string): TDateTime; overload;
    function  ValorParametroDouble(indice: Integer): Double; overload;
    function  ValorParametroDouble(nome_coluna: string): Double; overload;
    function  ValorParametroInt(indice: Integer): Integer; overload;
    function  ValorParametroInt(nome_coluna: string): Integer; overload;
    function  ValorParametroStr(indice: Integer): string; overload;
    function  ValorParametroStr(nome_coluna: string): string; overload;
  end;

type
  TTabela = class(TComponent)
  private
    con: TConexao;
    query: TConsulta;
    tabela: string;
    qtd_reg: Integer;
    function QtdParametrosAtualizaveis(ch: Boolean; ca: Boolean): Integer;
  public
    filtros: TFiltroArray;
    campos: TColunas;
    chaves: TColunas;
    constructor Create(_tabela: string; c: TConexao); reintroduce;
    destructor Destroy; override;
    procedure Atualizar;
    function  Eof: Boolean;
    procedure Excluir;
    procedure First;
    function  GetConexao: TConexao;
    procedure Inserir;
    procedure Last;
    procedure LimparParametros;
    function  Localizar(indice: Integer; valores: array of Variant): Boolean; overload;
    function  Localizar(indice: Integer): Boolean; overload;
    function  Localizar(final_comando: string; valores: array of Variant): Boolean; overload;
    function  Localizar(final_comando: string): Boolean; overload;
    procedure Next;
    procedure PreencherCampos;
    procedure Prior;
    function  QtdRegistros: Integer;
  protected
    sql_base: string;
  end;

implementation

{ TColunas }

function TColunas.Add(somenteleitura: Boolean; nome: string): Integer;
begin
  Result := Add(somenteleitura, nome, null);
end;

function TColunas.Add(nome: string; valor: Variant): Integer;
begin
  Result := Add(False, nome, valor);
end;

function TColunas.Add(somenteleitura: Boolean; nome: string;
  valor: Variant): Integer;
var
  x: TColuna;
begin
  nome := UpperCase(nome);
  Result := Ind(nome);

  if Result = -1 then begin
    x := TColuna.Create(Self);
    x.nome := nome;
    x.somente_leitura := somenteleitura;
    x.valor := valor;
    Result := par.Add(x)
  end
  else
    TColuna(par[Result]).valor := valor;
end;

function TColunas.Count: Integer;
begin
  Result := par.Count;
end;

constructor TColunas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  par := TList.Create;
end;

destructor TColunas.Destroy;
begin
  Clear;
  FreeAndNil(par);
  inherited;
end;

function TColunas.Ind(nome_coluna: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to par.Count - 1 do begin
    if TColuna(par[i]).nome = nome_coluna then begin
      Result := i;
      Exit;
    end;
  end;
end;

function TColunas.NomeParametro(indice: Integer): string;
begin
  Result := TColuna(par[indice]).nome;
end;

function TColunas.ValorParametro(indice: Integer): Variant;
begin
  Result := TColuna(par[indice]).valor;
end;

function TColunas.ValorParametro(nome_coluna: string): Variant;
begin
  Result := ValorParametro( Ind(nome_coluna) );
end;

function TColunas.ValorParametroData(indice: Integer): TDateTime;
var
  x: Variant;
begin
  x := ValorParametro(indice);
  if x = null then
    Result := 0
  else
    Result := x;
end;

function TColunas.ValorParametroData(nome_coluna: string): TDateTime;
var
  x: Variant;
begin
  x := ValorParametro(nome_coluna);
  if x = null then
    Result := 0
  else
    Result := x;
end;

function TColunas.ValorParametroInt(indice: Integer): Integer;
var
  x: Variant;
begin
  x := ValorParametro(indice);
  if x = null then
    Result := 0
  else
    Result := x;
end;

function TColunas.ValorParametroInt(nome_coluna: string): Integer;
var
  x: Variant;
begin
  x := ValorParametro(nome_coluna);
  if x = null then
    Result := 0
  else
    Result := x;
end;

function TColunas.ValorParametroDouble(indice: Integer): Double;
var
  x: Variant;
begin
  x := ValorParametro(indice);
  if x = null then
    Result := 0
  else
    Result := x;
end;

function TColunas.ValorParametroDouble(nome_coluna: string): Double;
var
  x: Variant;
begin
  x := ValorParametro(nome_coluna);
  if x = null then
    Result := 0
  else
    Result := x;
end;


function TColunas.ValorParametroHora(indice: Integer): TDateTime;
var
  x: Variant;
begin
  x := ValorParametro(indice);
  if x = null then
    Result := -1
  else
    Result := x;
end;

function TColunas.ValorParametroHora(nome_coluna: string): TDateTime;
var
  x: Variant;
begin
  x := ValorParametro(nome_coluna);
  if x = null then
    Result := -1
  else
    Result := x;
end;

function TColunas.ValorParametroStr(indice: Integer): string;
var
  x: Variant;
begin
  x := ValorParametro(indice);
  if x = null then
    Result := ''
  else
    Result := x;
end;

function TColunas.ValorParametroStr(nome_coluna: string): string;
var
  x: Variant;
begin
  x := ValorParametro(nome_coluna);
  if x = null then
    Result := ''
  else
    Result := x;
end;

function TColunas.GetSomenteLeitura(indice: Integer): Boolean;
begin
  Result := TColuna(par[indice]).somente_leitura;
end;

procedure TColunas.SetSomenteLeitura(indice: Integer;
  somente_leitura: Boolean);
begin
  TColuna(par[indice]).somente_leitura := somente_leitura;
end;

procedure TColunas.Remove(indice: Integer);
begin
  TColuna(par[indice]).Free;
  par.Delete(indice);
end;

procedure TColunas.Remove(nome_coluna: string);
begin
  Remove( Ind(nome_coluna) );
end;

procedure TColunas.Clear;
var
  i: Integer;
begin
  for i := 0 to par.Count - 1 do
    TColuna(par[i]).Free;
  par.Clear;
end;

procedure TColunas.ParametrosNulos;
var
  i: Integer;
begin
  for i := 0 to par.Count - 1 do
    TColuna(par[i]).valor := null;
end;

procedure TColunas.SetValor(indice: Integer; valor: Variant);
begin
  TColuna(par[indice]).valor := valor;
end;

procedure TColunas.SetValor(nome_coluna: string; valor: Variant);
begin
  SetValor( Ind(nome_coluna), valor );
end;

function TColunas.Add(nome: string): Integer;
begin
  Result := Add(False, nome);
end;

{ TTabela }

procedure TTabela.Atualizar;
var
  comando: string;
  i: Integer;
  c: Integer;
  tevecoluna: Boolean;
  exec: Execucao;
  valores: array of Variant;
begin
  c := 0;
  tevecoluna := False;

  comando := 'update ' + tabela + ' set ';

  SetLength(valores, QtdParametrosAtualizaveis(True, True));

  for i := 0 to campos.Count - 1 do begin

		if not campos.GetSomenteLeitura(i) then begin
			if tevecoluna then
				comando := comando + ',';

	    comando := comando + campos.NomeParametro(i) + ' = :P' + IntToStr(c + 1);

			tevecoluna := True;

			valores[c] := campos.ValorParametro(i);

			Inc(c);
		end;
  end;

  tevecoluna := False;

	for i := 0 to chaves.Count - 1 do begin
		if not chaves.GetSomenteLeitura(i) then begin
      if tevecoluna then
        comando := comando + ' and ' + chaves.NomeParametro(i) + ' = :P' + IntToStr(c + 1)
      else
        comando := comando + ' where ' + chaves.NomeParametro(i) + ' = :P' + IntToStr(c + 1);

      tevecoluna := True;

      valores[c] := chaves.ValorParametro(i);

      Inc(c)
    end;
  end;

	exec := Execucao.Create(con);
  try
    exec.SetSQL(comando);
    exec.Executar(valores);
  finally
    FreeAndNil(exec);
  end;
end;

constructor TTabela.Create(_tabela: string; c: TConexao);
begin
  inherited Create(c);
  tabela := _tabela;
  con := c;
  query := con.NovaQuery;
  filtros := nil;
  campos := TColunas.Create(Self);
  chaves := TColunas.Create(Self);
  qtd_reg := -1;
end;

destructor TTabela.Destroy;
begin
  FreeAndNil(campos);
  FreeAndNil(chaves);
  FreeAndNil(query);
  inherited Destroy;
end;

function TTabela.Eof: Boolean;
begin
  Result := query.Eof;
end;

procedure TTabela.Excluir;
var
  comando: string;
  i: Integer;
  c: Integer;
  tevecoluna: Boolean;
  exec: Execucao;
  valores: array of Variant;
begin
	c := 0;
  tevecoluna := False;

  comando := 'delete from ' + tabela;

  if QtdParametrosAtualizaveis(True, False) > 0 then begin
    SetLength(valores, QtdParametrosAtualizaveis(True, False));
    for i := 0 to chaves.Count - 1 do begin
      if not chaves.GetSomenteLeitura(i) then begin
        if not tevecoluna then
          comando := comando + ' where ' + chaves.NomeParametro(i) + ' = :P' + IntToStr(c + 1)
        else
          comando := comando + ' and ' + chaves.NomeParametro(i) + ' = :P' + IntToStr(c + 1);

        tevecoluna := True;

        valores[c] := chaves.ValorParametro(i);
        Inc(c);
      end;
    end;

    exec := Execucao.Create(con);
    try
      exec.SetSQL(comando);
      exec.Executar(valores);
    finally
      FreeAndNil(exec);
    end;
  end;
end;

procedure TTabela.First;
begin
  query.First;
  PreencherCampos;
end;

function TTabela.GetConexao: TConexao;
begin
  Result := Self.con;
end;

procedure TTabela.Inserir;
var
  i: Integer;
  c: Integer;
  tevecoluna: Boolean;
  exec: Execucao;
  comando: string;
  valores: array of Variant;
begin

  SetLength(valores, QtdParametrosAtualizaveis(True, True));
  tevecoluna := False;
  c := 0;

  comando := 'insert into ' + tabela + '(';

  for i := 0 to chaves.Count - 1 do begin
    if not chaves.GetSomenteLeitura(i) then begin
      if tevecoluna then
        comando := comando + ',';

      comando := comando + chaves.NomeParametro(i);

      tevecoluna := True;

      valores[c] := chaves.ValorParametro(i);

      Inc(c);
    end;
  end;

  for i := 0 to campos.Count - 1 do begin
    if not campos.GetSomenteLeitura(i) then begin
      if tevecoluna then
        comando := comando + ',';

      comando := comando + campos.NomeParametro(i);

      tevecoluna := True;

      valores[c] := campos.ValorParametro(i);

      Inc(c);
    end;
  end;

  tevecoluna := False;
  comando := comando + ') values (';
  c := 1;

  for i := 0 to chaves.Count - 1 do begin
    if not chaves.GetSomenteLeitura(i) then begin
      if tevecoluna then
        comando := comando + ',';

      comando := comando + ':P' + IntToStr(c);

      tevecoluna := True;

      Inc(c);
    end;
  end;

  for i := 0 to campos.Count - 1 do begin
    if not campos.GetSomenteLeitura(i) then begin
      if tevecoluna then
        comando := comando + ',';

      comando := comando + ':P' + IntToStr(c);

      tevecoluna := True;

      Inc(c);
    end;
  end;

  comando := comando + ')';

  exec := Execucao.Create(con);
  try
    exec.SetSQL(comando);
    exec.Executar(valores);
  finally
    FreeAndNil(exec);
  end;
end;

procedure TTabela.Last;
begin
  query.Last;
  PreencherCampos;
end;

procedure TTabela.LimparParametros;
begin
  campos.ParametrosNulos;
  chaves.ParametrosNulos;
end;

function TTabela.Localizar(indice: Integer): Boolean;
begin
  Result := Localizar( filtros[indice].sql );
end;

function TTabela.Localizar(
  indice: Integer;
  valores: array of Variant): Boolean;
begin
  Result := Localizar( filtros[indice].sql, valores );
end;

function TTabela.Localizar(final_comando: string): Boolean;
begin
  LimparParametros;
  qtd_reg := -1;

  query.Active := False;
  query.SQL.Text := sql_base + ' ' + final_comando;
  query.Active := True;

  Result := not query.IsEmpty;

  if Result then
    PreencherCampos;
end;

function TTabela.Localizar(
  final_comando: string;
  valores: array of Variant
): Boolean;
var
  i: Integer;
begin
  LimparParametros;
  qtd_reg := -1;

  query.Active := False;
  query.SQL.Text := sql_base + ' ' + final_comando;

  // Preenche os parâmetros dinamicamente
  for i := Low(valores) to High(valores) do
    query.Params[i].Value := valores[i];

  query.Active := True;

  Result := not query.IsEmpty;

  if Result then
    PreencherCampos;
end;

procedure TTabela.Next;
begin
  query.Next;
  PreencherCampos;
end;

procedure TTabela.PreencherCampos;
var
  i: Integer;
begin
	for i := 0 to campos.Count - 1 do
    campos.SetValor(i, query.FieldByName( campos.NomeParametro(i) ).Value);

	for i := 0 to chaves.Count - 1 do
    chaves.SetValor(i, query.FieldByName( chaves.NomeParametro(i) ).Value);
end;

procedure TTabela.Prior;
begin
  query.Prior;
  PreencherCampos;
end;

function TTabela.QtdParametrosAtualizaveis(ch, ca: Boolean): Integer;
var
  i: Integer;
begin
  Result := 0;

  if ch then begin
    for i := 0 to chaves.Count - 1 do begin
      if not chaves.GetSomenteLeitura(i) then
        Inc(Result);
    end;
  end;

  if ca then begin
    for i := 0 to campos.Count - 1 do begin
      if not campos.GetSomenteLeitura(i) then
        Inc(Result);
    end;
  end;
end;

function TTabela.QtdRegistros: Integer;
begin
  if qtd_reg = -1 then begin
    qtd_reg := 0;
    if not query.IsEmpty then begin
      query.First;
      while not query.Eof do begin
        inc(qtd_reg);
        query.Next;
      end;
      First;
    end;
  end;

  Result := qtd_reg;
end;

end.

