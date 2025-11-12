unit Distribuidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _FormEditar, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.StdCtrls, Ambiente, _Distribuidor;

type
  TFormDistribuidor = class(TFormEditar)
    lbDistribuidorId: TLabel;
    eDistribuidorId: TEdit;
    lbNome: TLabel;
    eNome: TEdit;
    lbCnpj: TLabel;
    eCnpj: TMaskEdit;
    procedure eDistribuidorIdKeyPress(Sender: TObject; var Key: Char);
    procedure eDistribuidorIdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function Excluir: Boolean; override;
    function Gravar: Boolean; override;
    procedure Modo(Editando: Boolean); override;
    procedure Pesquisar; override;
    procedure VerificarDados; override;
  end;

implementation

{$R *.dfm}

procedure TFormDistribuidor.eDistribuidorIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
  distribuidor: TDistribuidorArray;
begin
  inherited;

  if Key <> VK_RETURN then
    Exit;

  if eDistribuidorId.Text = '' then begin
    Modo(True);
    Exit;
  end;

  distribuidor := _Distribuidor.BuscarDistribuidores(
    Ambiente.conexao_banco,
    0,
    [StrToInt(eDistribuidorId.Text)]
  );

  if distribuidor = nil then begin
    ShowMessage('Distribuidor não encontrado.');
    Modo(False);
    Exit;
  end;

  Modo(True);

  eNome.Text := distribuidor[0].nome;
  eCnpj.Text := distribuidor[0].cnpj;

  if Length(distribuidor) > 0 then begin
    for i := Low(distribuidor) to High(distribuidor) do begin
      distribuidor[i].Free;
      distribuidor[i] := nil;
    end;

    SetLength(distribuidor, 0);
  end;
end;

procedure TFormDistribuidor.eDistribuidorIdKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;

  if not CharInSet(Key,[^H, ^V, ^X, #13, #27, '0'..'9', #8]) then
    Key := #0;

  TeclarEnter(Sender, Key);

end;

function TFormDistribuidor.Excluir: Boolean;
begin
  Result := False;

  try
    _Distribuidor.Excluir(Ambiente.conexao_banco, StrToInt(eDistribuidorId.Text));
    ShowMessage('Distribuidor excluído com sucesso');
    Result := True;
  except
    ShowMessage('Não foi possível excluir o distribuidor');
  end;
end;

function TFormDistribuidor.Gravar: Boolean;
var
  distribuidor_id: Integer;
begin
  Result := False;

  distribuidor_id := 0;
  if eDistribuidorId.Text <> '' then
    distribuidor_id := StrToInt(eDistribuidorId.Text);

  try
    _Distribuidor.InserirAtualizar(
      Ambiente.conexao_banco,
      distribuidor_id,
      eNome.Text,
      eCnpj.Text
    );

    ShowMessage('Distribuidor cadastrado com sucesso');

    Result := True;
  except
    ShowMessage('Não foi possível cadastrar o distribuidor');
  end;
end;

procedure TFormDistribuidor.Modo(Editando: Boolean);
begin
  inherited;

  Ambiente.Habilitar([eDistribuidorId], not editando, False);

  Ambiente.Habilitar(
    [eNome, eCnpj],
    editando,
    True
  );

  if editando then
    eNome.SetFocus
  else begin
    eDistribuidorId.Clear;
    eDistribuidorId.SetFocus;
  end;
end;

procedure TFormDistribuidor.Pesquisar;
begin
  inherited;

end;

procedure TFormDistribuidor.VerificarDados;
begin
  inherited;

end;

end.
