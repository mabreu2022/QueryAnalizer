unit uRelatorioJSON;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils,
  System.Generics.Collections, uProjetoItem, uSQLItem;

type
  TClasseRelatorioJSON = class
  public
    procedure Gerar(const Projetos: TObjectList<TProjetoItem>);
  end;

implementation

procedure TClasseRelatorioJSON.Gerar(const Projetos: TObjectList<TProjetoItem>);
var
  RootArray: TJSONArray;
  ProjetoObj, ConsultaObj: TJSONObject;
  Projeto: TProjetoItem;
  Item: TSQLItem;
begin
  RootArray := TJSONArray.Create;

  for Projeto in Projetos do
  begin
    ProjetoObj := TJSONObject.Create;
    ProjetoObj.AddPair('projeto', Projeto.NomeProjeto);

    var ConsultasArray := TJSONArray.Create;
    for Item in Projeto.SQLs do
    begin
      ConsultaObj := TJSONObject.Create;
      ConsultaObj.AddPair('arquivo', Item.Arquivo);
      ConsultaObj.AddPair('unit', Item.UnitName);
      ConsultaObj.AddPair('linha', TJSONNumber.Create(Item.Linha));
      ConsultaObj.AddPair('componente', Item.Componente);
      ConsultaObj.AddPair('sql', Item.SQL);
      ConsultaObj.AddPair('problema', Item.Problema);
      ConsultaObj.AddPair('sugestao', Item.Sugestao);
      ConsultasArray.Add(ConsultaObj);
    end;

    ProjetoObj.AddPair('consultas', ConsultasArray);
    RootArray.Add(ProjetoObj);
  end;

  TFile.WriteAllText('Relatorios\relatorio.json', RootArray.ToJSON);
  RootArray.Free;
end;

end.
