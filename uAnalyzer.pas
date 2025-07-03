unit uAnalyzer;

interface

uses
  System.Classes, System.SysUtils, System.RegularExpressions, System.Generics.Collections,
  uProjetoItem, uSQLItem;

type
  TClasseAnalyzer = class
  public
    procedure AnalisarProjetos(const Projetos: TObjectList<TProjetoItem>);
  end;

implementation

procedure TClasseAnalyzer.AnalisarProjetos(const Projetos: TObjectList<TProjetoItem>);
var
  Projeto: TProjetoItem;
  Item: TSQLItem;
begin
  for Projeto in Projetos do
  begin
    for Item in Projeto.SQLs do
    begin
      // Regras de valida��o e sugest�es
      if TRegEx.IsMatch(Item.SQL, '(?i)\bselect\s+\*') then
      begin
        Item.Problema := 'Uso de SELECT *';
        Item.Sugestao := 'Evite SELECT *. Prefira especificar as colunas necess�rias, como: SELECT ID, Nome';
      end
      else if TRegEx.IsMatch(Item.SQL, '(?i)\bdelete\b(?!.*\bwhere\b)') then
      begin
        Item.Problema := 'DELETE sem cl�usula WHERE';
        Item.Sugestao := 'Use cl�usula WHERE para evitar exclus�o total de registros.';
      end
      else if TRegEx.IsMatch(Item.SQL, '(?i)\bupdate\b(?!.*\bwhere\b)') then
      begin
        Item.Problema := 'UPDATE sem cl�usula WHERE';
        Item.Sugestao := 'Use cl�usula WHERE para evitar modifica��o em massa indesejada.';
      end
      else if TRegEx.IsMatch(Item.SQL, '(?i)\bjoin\b(?!.*\bon\b)') then
      begin
        Item.Problema := 'JOIN sem condi��o ON';
        Item.Sugestao := 'Certifique-se de definir ON para relacionar corretamente as tabelas.';
      end
      else
      begin
        Item.Problema := '';
        Item.Sugestao := '';
      end;
    end;
  end;
end;

end.
