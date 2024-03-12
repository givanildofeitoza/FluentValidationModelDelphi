*Exemplo de validação de models com o FluentValidation Delphi

procedure TServicoContasPagar.AdicionarDocumentoAPagar(
  pDocumento: TContasPagar);
begin
    TFluentValidation.RegraParaCampo(pDocumento,'CodigoFilial').Tamanho(5).ApenaNumeros.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'Documento').NaoVazioOuNulo.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'Empresa').NaoVazioOuNulo.TamanhoEntre(5,200).validar;
    TFluentValidation.RegraParaCampo(pDocumento,'CodigoFornecedor').NaoVazioOuNulo.ApenaNumeros.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'Valor').NaoVazioOuNulo.ValorMaiorQueZero.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'Vencimento').NaoVazioOuNulo.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'Data').NaoVazioOuNulo.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'CodigoSet').NaoVazioOuNulo.validar;
    TFluentValidation.RegraParaCampo(pDocumento,'CodigoSubset').NaoVazioOuNulo.validar;
    FRepositorioContasPagar.Add(pDocumento);
end;
