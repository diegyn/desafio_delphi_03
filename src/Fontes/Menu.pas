unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TFormMenu = class(TForm)
    mmMenu: TMainMenu;
    miCadastros: TMenuItem;
    miProdutor: TMenuItem;
    miDistribuidor: TMenuItem;
    N1: TMenuItem;
    miProduto: TMenuItem;
    procedure miProdutorClick(Sender: TObject);
    procedure miDistribuidorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miProdutoClick(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirFormulario(
      classe: TFormClass;
      verificar_se_aberto: Boolean = True
    );
  public
    { Public declarations }
  end;

var
  FormMenu: TFormMenu;

implementation

{$R *.dfm}

uses
  Ambiente, Produtor, Distribuidor, Produto;

{ TFormMenu }

procedure TFormMenu.AbrirFormulario(
  classe: TFormClass;
  verificar_se_aberto: Boolean
);
begin
  Ambiente.AbrirFormulario(classe, verificar_se_aberto);
end;

procedure TFormMenu.FormCreate(Sender: TObject);
begin
  Ambiente.Parametros.Menu := Self;
end;

procedure TFormMenu.miDistribuidorClick(Sender: TObject);
begin
  AbrirFormulario(TFormDistribuidor);
end;

procedure TFormMenu.miProdutoClick(Sender: TObject);
begin
  AbrirFormulario(TFormProduto);
end;

procedure TFormMenu.miProdutorClick(Sender: TObject);
begin
  AbrirFormulario(TFormProdutor);
end;

end.
