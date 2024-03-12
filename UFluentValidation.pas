unit UFluentValidation;

interface

uses
  UICapturarNotificacao, UModel, System.Rtti,
  UIoc, System.SysUtils, System.Types, System.StrUtils;

type

TValidation = class
   private
     FNotificacao : ICapturarNotificacao;
     FCampoValor  : string;
     FProp : string;
     FModel : TModel;
     TypeObject  : TRttiType;
     FCtx        : TRttiContext;
     FClassName  : String;
     FArrayFields : TArray<TRttiField>;
     FStrErro : string;

     function  ObterValorDoCampo(pProp : string) : string;
   public
     function  NaoVazioOuNulo : TValidation;
     function  TamanhoEntre(pMenor,pMaior : Integer) : TValidation;
     function  EmailTipoCampo : TValidation;
     function  Tamanho(pTamanho : Integer) : TValidation;
     function  ApenaNumeros : TValidation;
     function  TipoSenha : TValidation;
     function  ValorMaiorQueZero : TValidation;
     procedure validar;

     constructor Create(pModel : TModel);
end;

TFluentValidation = class
   private
     FModel : TObject;
   public
     class function   RegraParaCampo(pModel : TModel; pPropriedade : string) : TValidation;
 end;

implementation


{ TFluentValidation<T> }

function TValidation.ApenaNumeros: TValidation;
var
  I : Integer;
  numeros : string;
begin
    numeros := '0123456789';
    for  I := 1 to  ObterValorDoCampo(FProp).Length do
    begin
        if not(numeros.Contains(Copy(ObterValorDoCampo(FProp),I,1)))then
         begin
            FNotificacao.AdicionarErro('Campo '+FProp+' Só deve conter números !');
            Break;
         end;
    end;

    Result := Self;
end;

constructor TValidation.Create(pModel: TModel);
begin
    FModel := pModel;
    FNotificacao :=  TIoc.CapturarNotificacao;
    FNotificacao.LimparErroLista;

    TypeObject   := FCtx.GetType(FModel.ClassType);
    FArrayFields := TypeObject.GetFields;
    FStrErro     :=  'Falha de validação model: '+TypeObject.Name;
end;

function TValidation.EmailTipoCampo: TValidation;
begin
    if not(ObterValorDoCampo(FProp).Contains('@'))then
       FNotificacao.AdicionarErro('Campo '+FProp+' Pode não ser um e-mail!');

    Result := Self;
end;

function  TValidation.Tamanho(pTamanho : Integer) : TValidation;
begin
    if not(ObterValorDoCampo(FProp).Length = pTamanho)then
        FNotificacao.AdicionarErro('Campo '+FProp+' deve ter '+pTamanho.ToString()
        +' Caracteres !');

    Result := Self;
end;

function TValidation.NaoVazioOuNulo: TValidation;
begin
    if(string.IsNullOrEmpty(ObterValorDoCampo(FProp)))then
       FNotificacao.AdicionarErro('Campo '+FProp+' Não pode ser nulo ou vazio!');

    Result := Self;
end;

function TValidation.ObterValorDoCampo(pProp : string): string;
var
  I : Integer;
  valor : string;
begin
   valor := string.empty;
   for I := 0 to length(FArrayFields)-1 do
   begin
       if UpperCase(FArrayFields[I].Name) = UpperCase('F'+pProp) then
       begin
           valor := FArrayFields[I].GetValue(Pointer(FModel)).ToString;
           Break;
       end;
   end;
   Result := valor;
end;

function TValidation.TamanhoEntre(pMenor,
  pMaior: Integer): TValidation;
begin
    if (ObterValorDoCampo(FProp).Length < pMenor) or (ObterValorDoCampo(FProp).Length > pMaior)then
        FNotificacao.AdicionarErro('Campo '+FProp+' Não pode ser maior que '
        +pMaior.ToString+' nem menor que '+pMenor.ToString);

    Result := Self;
end;

function TValidation.TipoSenha: TValidation;
var
  caracteres : string;
  numeros : string;
  car : Boolean;
  num : Boolean;
  I : Integer;
begin
    numeros    := '0123456789';
    caracteres := 'º°*/\|_=§ª¹²³£¢¬-+.,!@#$%&:;[{]}"^~';

    for  I := 1 to  ObterValorDoCampo(FProp).Length do
    begin
        if(numeros.Contains(Copy(ObterValorDoCampo(FProp),I,1)))then
         begin
            num := True;
            Break;
         end;
    end;

    for  I := 1 to  ObterValorDoCampo(FProp).Length do
    begin
        if(caracteres.Contains(Copy(ObterValorDoCampo(FProp),I,1)))then
         begin
            car := True;
            Break;
         end;
    end;

    if not car then
       FNotificacao.AdicionarErro('Campo '+FProp+' de tipo senha deve ter ao menos 1 caractere especial !');

    if not num then
       FNotificacao.AdicionarErro('Campo '+FProp+' de tipo senha deve ter ao menos 1 caractere numérico !');

    if ObterValorDoCampo(FProp).Length < 6 then
       FNotificacao.AdicionarErro('Campo '+FProp+' de tipo senha deve ter ao menos 6 caracteres ');

    Result := Self;

end;

procedure TValidation.validar;
var
  e : string;
  EmitirErros : string;
begin
    if FNotificacao.ContarErros > 0 then
    begin
        EmitirErros := string.empty;
        for e in FNotificacao.ObterErros do
           EmitirErros := EmitirErros+e+#13;

        raise Exception.Create(FStrErro+#13+#13+EmitirErros);
    end;

end;


function TValidation.ValorMaiorQueZero: TValidation;
begin
   if not(ObterValorDoCampo(FProp).ToInteger > 0 )then
       FNotificacao.AdicionarErro('Campo '+FProp+' deve ser maior que Zero!');

    Result := Self;
end;

class function TFluentValidation.RegraParaCampo(pModel : TModel; pPropriedade: string): TValidation;
var
  f : TValidation;
begin
    f := TValidation.Create(pModel);
    f.FProp := pPropriedade;
    Result :=  f;
end;

end.
