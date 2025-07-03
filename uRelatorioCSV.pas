                                             unit uRelatorioCSV;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  System.Generics.Collections, uProjetoItem, uSQLItem;

type
  TClasseRelatorioCSV = class
  public
    procedure Gerar(const Projetos: TObjectList<TProjetoItem>);
  end;

implementation

procedure TClasseRelatorioCSV.Gerar(const Projetos: TObjectList<TProjetoItem>);
var
  CSV: TStringList;
  Projeto: TProjetoItem;
  Item: TSQLItem;
  Linha, DataHoje: string;
begin
  CSV := TStringList.Create;
  DataHoje := FormatDateTime('yyyy-mm-dd', Now);

  // Cabeçalho com DataAnalise
  CSV.Add('DataAnalise;Projeto;Arquivo;Unit;Linha;Componente;SQL;Problema;Sugestao');

  for Projeto in Projetos do
    for Item in Projeto.SQLs do
    begin
      Linha := Format('%s;%s;%s;%s;%d;%s;"%s";%s;%s',
        [DataHoje,
         Projeto.NomeProjeto,
         Item.Arquivo,
         Item.UnitName,
         Item.Linha,
         Item.Componente,
         Item.SQL.Replace('"', '''').Replace(#13#10, ' ').Replace(#10, ' ').Replace(#13, ' '),
         Item.Problema,
         Item.Sugestao]);

      CSV.Add(Linha);
    end;

  TDirectory.CreateDirectory('Relatorios');
  CSV.SaveToFile('Relatorios\relatorio.csv', TEncoding.UTF8);
  CSV.Free;
end;

end.
