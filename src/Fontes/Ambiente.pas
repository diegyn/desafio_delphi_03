unit Ambiente;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask, System.Classes,
  System.SysUtils, _Conexao;

type
  TParametros = record
    Menu: TForm;
  end;

  function AbrirFormulario(classe: TFormClass; verificar_se_aberto: Boolean = True): TForm;

  procedure Iniciar;
  procedure Habilitar(objetos: array of TControl; ativar: Boolean; limpar: Boolean);
  procedure LimparObjetos(objetos: array of TControl);

var
  conexao_banco: TConexao;
  parametros: TParametros;

implementation

const
  cUsuario = 'sysdba';
  cSenha   = 'masterkey';
  cCaminho = 'C:\\Projetos\\Aliare\\desafio_delphi_03\\data\\ALIARE.FDB';

function  AbrirFormulario(classe: TFormClass; verificar_se_aberto: Boolean = True): TForm;
var
  i: Integer;
  form: TForm;
begin
  form := nil;

  if verificar_se_aberto and Assigned(parametros.Menu) then begin
    for i := 0 to parametros.Menu.MDIChildCount - 1 do begin
      if parametros.Menu.MDIChildren[i].ClassType = classe then begin
        form := parametros.Menu.MDIChildren[i];
        Break;
      end;
    end;
  end;

  if not Assigned(form) then
    form := classe.Create(Application)
  else if form.WindowState = wsMinimized then
    form.WindowState := wsNormal;

  form.Show;
  form.BringToFront;

  Result := form;
end;

procedure Iniciar;
begin

  conexao_banco := TConexao.Create(Application);

  if not conexao_banco.Conectar(cUsuario, cSenha, cCaminho) then
    Halt;

end;

procedure Habilitar(objetos: array of TControl; ativar: Boolean; limpar: Boolean);
var
  i: Integer;
begin

  for i := Low(objetos) to High(objetos) do
    TControl(objetos[i]).Enabled := ativar;

  if limpar then
    LimparObjetos(objetos);

end;

procedure LimparObjetos(objetos: array of TControl);
var
  i: Integer;
begin
  for i := Low(objetos) to High(objetos) do begin
    if objetos[i] is TEdit then
      TEdit(objetos[i]).Clear
    else if objetos[i] is TMemo then
      TMemo(objetos[i]).Lines.Clear
    else if objetos[i] is TCheckBox then
      TCheckBox(objetos[i]).State := cbUnchecked
    else if objetos[i] is TCustomMaskEdit then
      TCustomMaskEdit(objetos[i]).Clear
    else if objetos[i] is TListBox then
      TListBox(objetos[i]).Items.Clear
    else if objetos[i] is TPageControl then
      TPageControl(objetos[i]).ActivePageIndex := 0
    else if objetos[i] is TComboBox then
      TComboBox(objetos[i]).ItemIndex := -1
    else if objetos[i] is TStaticText then
      TStaticText(objetos[i]).Caption := ''
    else if objetos[i] is TLabel then
      TLabel(objetos[i]).Caption := ''
  end;
end;

end.
