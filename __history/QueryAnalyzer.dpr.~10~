program QueryAnalyzer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  uScanner in 'uScanner.pas',
  uScannerDFM in 'uScannerDFM.pas',
  uAnalyzer in 'uAnalyzer.pas',
  uRelatorioJSON in 'uRelatorioJSON.pas',
  uRelatorioHTML in 'uRelatorioHTML.pas',
  uSQLItem in 'uSQLItem.pas',
  uProjetoItem in 'uProjetoItem.pas';

procedure CriarPastaRelatorios;
begin
  if not DirectoryExists('Relatorios') then
  begin
    Writeln('?? Criando pasta de relatórios...');
    CreateDir('Relatorios');
    Writeln('? Pasta "Relatorios" criada.');
  end
  else
    Writeln('?? Pasta "Relatorios" já existe.');
end;

var
  Caminho: string;
  Scanner: TClasseScanner;
  ScannerDFM: TScannerDFM;
  Analyzer: TClasseAnalyzer;
  RelatorioJSON: TClasseRelatorioJSON;
  RelatorioHTML: TClasseRelatorioHTML;
  Projetos: TObjectList<TProjetoItem>;
  SQLsDFM: TList<TSQLItem>;
  Item: TSQLItem;
  ProjetoItem: TProjetoItem;
  ProjetoEncontrado: Boolean;
begin
  try
    Writeln('?? Iniciando análise de SQLs...');
    if ParamCount = 0 then
    begin
      Writeln('?? Uso: QueryAnalyzer.exe <caminho_dos_projetos>');
      Exit;
    end;

    Caminho := IncludeTrailingPathDelimiter(ParamStr(1));
    Writeln('?? Caminho raiz: ', Caminho);

    CriarPastaRelatorios;

    // Instanciando as classes
    Writeln('?? Preparando motores de análise...');
    Scanner := TClasseScanner.Create;
    ScannerDFM := TScannerDFM.Create;
    Analyzer := TClasseAnalyzer.Create;
    RelatorioJSON := TClasseRelatorioJSON.Create;
    RelatorioHTML := TClasseRelatorioHTML.Create;

    // Escanear arquivos .pas
    Writeln('?? Escaneando arquivos .pas...');
    Projetos := Scanner.ExecutarScan(Caminho);
    Writeln('? Arquivos .pas escaneados: ', Projetos.Count, ' projetos encontrados.');

    // Escanear arquivos .dfm
    Writeln('?? Escaneando arquivos .dfm...');
    SQLsDFM := ScannerDFM.EscanearDFMs(Caminho);
    Writeln('? Consultas encontradas em .dfm: ', SQLsDFM.Count);

    for Item in SQLsDFM do
    begin
      Item.Arquivo := ExtractRelativePath(Caminho, Item.Arquivo);
      Item.Projeto := Copy(Item.Arquivo, 1, Pos('\', Item.Arquivo) - 1);
      ProjetoEncontrado := False;

      for ProjetoItem in Projetos do
        if ProjetoItem.NomeProjeto = Item.Projeto then
        begin
          ProjetoItem.SQLs.Add(Item);
          ProjetoEncontrado := True;
          Break;
        end;

      if not ProjetoEncontrado then
      begin
        ProjetoItem := TProjetoItem.Create;
        ProjetoItem.NomeProjeto := Item.Projeto;
        ProjetoItem.SQLs := TObjectList<TSQLItem>.Create(True);
        ProjetoItem.SQLs.Add(Item);
        Projetos.Add(ProjetoItem);
      end;
    end;

    SQLsDFM.Free;
    ScannerDFM.Free;

    // Validação de SQLs
    Writeln('?? Validando consultas e aplicando sugestões...');
    Analyzer.AnalisarProjetos(Projetos);
    Writeln('? Validação concluída.');

    // Geração dos relatórios
    Writeln('?? Gerando arquivos de relatório...');
    RelatorioJSON.Gerar(Projetos);
    RelatorioHTML.Gerar(Projetos);
    Writeln('? Relatórios gerados com sucesso na pasta "Relatorios".');

    // Liberação de memória
    Writeln('?? Limpando recursos da memória...');
    Projetos.Free;
    Scanner.Free;
    Analyzer.Free;
    RelatorioJSON.Free;
    RelatorioHTML.Free;

    Writeln('?? Processo finalizado com sucesso.');
  except
    on E: Exception do
      Writeln('? Erro: ', E.Message);
  end;
end.
