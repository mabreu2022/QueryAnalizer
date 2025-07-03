unit uRelatorioHTML;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  System.Generics.Collections, uProjetoItem, uSQLItem;

type
  TClasseRelatorioHTML = class
  public
    procedure Gerar(const Projetos: TObjectList<TProjetoItem>);
  end;

implementation

procedure TClasseRelatorioHTML.Gerar(const Projetos: TObjectList<TProjetoItem>);
var
  HTML: TStringList;
  Projeto: TProjetoItem;
  Item: TSQLItem;
begin
  HTML := TStringList.Create;

  HTML.Add('<html><head><title>Relatório de SQLs</title>');
  HTML.Add('<style>body{font-family:Arial;}table{border-collapse:collapse;width:100%;}th,td{border:1px solid #ccc;padding:8px;}th{background:#eee;}tr:hover{background:#eef;}</style>');
  HTML.Add('</head><body>');
  HTML.Add('<h1>Relatório de SQLs Encontrados</h1>');

  for Projeto in Projetos do
  begin
    HTML.Add('<h2>Projeto: ' + Projeto.NomeProjeto + '</h2>');
    HTML.Add('<table>');
    HTML.Add('<tr><th>Arquivo</th><th>Unit</th><th>Linha</th><th>Componente</th><th>SQL</th><th>Problema</th><th>Sugestão</th></tr>');

    for Item in Projeto.SQLs do
    begin
      HTML.Add('<tr>');
      HTML.Add('<td>' + Item.Arquivo + '</td>');
      HTML.Add('<td>' + Item.UnitName + '</td>');
      HTML.Add('<td>' + Item.Linha.ToString + '</td>');
      HTML.Add('<td>' + Item.Componente + '</td>');
      HTML.Add('<td>' + Item.SQL + '</td>');
      HTML.Add('<td>' + Item.Problema + '</td>');
      HTML.Add('<td>' + Item.Sugestao + '</td>');
      HTML.Add('</tr>');
    end;

    HTML.Add('</table>');
  end;

  HTML.Add('</body></html>');
  HTML.SaveToFile('Relatorios\relatorio.html');
  HTML.Free;
end;

end.
