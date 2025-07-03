unit uScannerDFM;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, System.Generics.Collections,
  uSQLItem;

type
  TScannerDFM = class
  public
    function EscanearDFMs(const CaminhoRaiz: string): TList<TSQLItem>;
  end;

implementation

function TScannerDFM.EscanearDFMs(const CaminhoRaiz: string): TList<TSQLItem>;
var
  Arquivos: TArray<string>;
  Arquivo, LinhaAtual, Componente, SQLAcumulado: string;
  Linhas: TArray<string>;
  i: Integer;
  Capturando: Boolean;
  Item: TSQLItem;
begin
  Result := TList<TSQLItem>.Create;
  Arquivos := TDirectory.GetFiles(CaminhoRaiz, '*.dfm', TSearchOption.soAllDirectories);
  Capturando := False;

  for Arquivo in Arquivos do
  begin
    try
      Linhas := TFile.ReadAllLines(Arquivo);
      Componente := '';
      SQLAcumulado := '';

      for i := 0 to High(Linhas) do
      begin
        LinhaAtual := Linhas[i].Trim;

        if (LinhaAtual.StartsWith('object')) and (LinhaAtual.Contains(': TFDQuery')) then
          Componente := LinhaAtual.Split([':'])[0].Replace('object', '').Trim;

        if LinhaAtual = 'SQL.Strings = (' then
        begin
          Capturando := True;
          SQLAcumulado := '';
          Continue;
        end;

        if Capturando then
        begin
          if LinhaAtual = ')' then
          begin
            Capturando := False;
            Item := TSQLItem.Create;
            Item.SQL := SQLAcumulado.Trim;
            Item.Componente := Componente;
            Item.Arquivo := Arquivo;
            Item.UnitName := ''; // opcional, pode tentar vincular ao DFM equivalente
            Item.Projeto := '';  // será preenchido no scanner principal se necessário
            Item.Linha := i + 1;
            Result.Add(Item);
          end
          else
            SQLAcumulado := SQLAcumulado + ' ' + LinhaAtual.Replace('''', '').Trim;
        end;
      end;
    except
      on E: Exception do
        Writeln('Erro ao ler DFM: ', Arquivo, ' -> ', E.Message);
    end;
  end;
end;

end.
