unit _NegociacaoItem;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, _Conexao, _Tabela;

type
  TNegociacaoItem = class(TComponent)
  public
    negociacao_id: Integer;
    item_id: Integer;
    produto_id: Integer;
    quantidade: Integer;
    preco: Double;
  end;

  TNegociacaoItemArray = TArray<TNegociacaoItem>;

  NegociacaoItem = class(TTabela)
  private
    function  GetNEGOCIACAO_ID: Integer;
    procedure SetNEGOCIACAO_ID(x: Integer);
    function  GetITEM_ID: Integer;
    procedure SetITEM_ID(x: Integer);
    function  GetPRODUTO_ID: Integer;
    procedure SetPRODUTO_ID(x: Integer);
    function  GetPRECO: Double;
    procedure SetPRECO(x: Double);
    function  GetQUANTIDADE: Integer;
    procedure SetQUANTIDADE(x: Integer);
  public
    constructor Create(conexao: TConexao);
    function GetNegociacaoItem: TNegociacaoItem;
  published
    property NEGOCIACAO_ID: Integer read GetNEGOCIACAO_ID write SetNEGOCIACAO_ID;
    property ITEM_ID: Integer read GetITEM_ID write SetITEM_ID;
    property PRODUTO_ID: Integer read GetPRODUTO_ID write SetPRODUTO_ID;
    property PRECO: Double read GetPRECO write SetPRECO;
    property QUANTIDADE: Integer read GetQUANTIDADE write SetQUANTIDADE;   
  end;

function GetFiltros: TFiltroArray;

function BuscarNegociacoes(con: TConexao; indice: Integer; filtros: array of Variant ): TNegociacaoItemArray;
function BuscarNegociacoesComando(con: TConexao; comando: string): TNegociacaoItemArray;

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

function BuscarNegociacoes(con: TConexao; indice: Integer; filtros: array of Variant ): TNegociacaoItemArray;
var
  i: Integer;
  t: NegociacaoItem;
begin
  t := NegociacaoItem.Create(con);

  Result := nil;
  if t.Localizar(indice, filtros) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetNegociacaoItem;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

function BuscarNegociacoesComando(con: TConexao; comando: string): TNegociacaoItemArray;
var
  i: Integer;
  t: NegociacaoItem;
begin
  t := NegociacaoItem.Create(con);

  Result := nil;
  if t.Localizar(comando) then begin
    SetLength(Result, t.QtdRegistros);
    for i := 0 to t.QtdRegistros - 1 do  begin
      Result[i] := t.GetNegociacaoItem;
      t.Next;
    end;
  end;

  FreeAndNil(t);
end;

{ NegociacaoItem }

constructor NegociacaoItem.Create(conexao: TConexao);
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

  filtros := _NegociacaoItem.GetFiltros;

  chaves.Add('NEGOCIACAO_ID');
  campos.Add('PRODUTOR_ID');
  campos.Add('DISTRIBUIDOR_ID');
  campos.Add(True, 'STATUS');
end;

function NegociacaoItem.GetQUANTIDADE: Integer;
begin
  Result := campos.ValorParametroInt('DISTRIBUIDOR_ID');
end;

function NegociacaoItem.GetITEM_ID: Integer;
begin
  Result := campos.ValorParametroInt('ITEM_ID');
end;

function NegociacaoItem.GetNegociacaoItem: TNegociacaoItem;
begin
  Result := TNegociacaoItem.Create(Application);
  Result.negociacao_id := GetNEGOCIACAO_ID;
  Result.produto_id := GetPRODUTO_ID;
  Result.quantidade := GetQUANTIDADE;
  Result.preco := GetPRECO;
end;

function NegociacaoItem.GetNEGOCIACAO_ID: Integer;
begin
  Result := chaves.ValorParametroInt('NEGOCIACAO_ID');
end;

function NegociacaoItem.GetPRECO: Double;
begin
  Result := chaves.ValorParametroDouble('PRECO');
end;

function NegociacaoItem.GetPRODUTO_ID: Integer;
begin
  Result := campos.ValorParametroInt('PRODUTO_ID');
end;

procedure NegociacaoItem.SetQUANTIDADE(x: Integer);
begin
  campos.SetValor('QUANTIDADE', x);
end;

procedure NegociacaoItem.SetITEM_ID(x: Integer);
begin
  chaves.SetValor('ITEM_ID', x);
end;

procedure NegociacaoItem.SetNEGOCIACAO_ID(x: Integer);
begin
  chaves.SetValor('NEGOCIACAO_ID', x);
end;

procedure NegociacaoItem.SetPRECO(x: Double);
begin
  campos.SetValor('PRECO', x);  
end;

procedure NegociacaoItem.SetPRODUTO_ID(x: Integer);
begin
  campos.SetValor('PRODUTO', x);
end;

end.

