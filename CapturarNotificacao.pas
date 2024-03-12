unit CapturarNotificacao;

interface

uses
  UICapturarNotificacao,System.Generics.Collections;

type
 TCapturarNotificacao = class(TInterfacedObject , ICapturarNotificacao)
  private
    FListErro : TList<string>;
  public
     procedure LimparErroLista();
     procedure AdicionarErro(pErro : string);
     function  ContarErros : Integer;
     function  ObterErros : TList<string>;

     constructor Create();
end;

implementation

{ TCapturarNotificacao }

constructor TCapturarNotificacao.Create;
begin
   FListErro := TList<string>.Create;
end;

procedure TCapturarNotificacao.AdicionarErro(pErro: string);
begin
   FListErro.Add(pErro);
end;

function TCapturarNotificacao.ContarErros: Integer;
begin
    Result := FListErro.Count;
end;


procedure TCapturarNotificacao.LimparErroLista;
begin
   FListErro.Clear;
end;

function TCapturarNotificacao.ObterErros: TList<string>;
begin
    Result := FListErro;
end;

end.
