                                                                              program QueryAnalyzer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
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
  ContadorSQLs, ContadorProblemas: Integer;
  Ranking: TList<TPair<string, Integer>>;
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

    Writeln('?? Preparando motores de análise...');
    Scanner := TClasseScanner.Create;
    ScannerDFM := TScannerDFM.Create;
    Analyzer := TClasseAnalyzer.Create;
    RelatorioJSON := TClasseRelatorioJSON.Create;
    RelatorioHTML := TClasseRelatorioHTML.Create;
    ContadorSQLs := 0;

    Writeln('?? Escaneando arquivos .pas...');
    Projetos := Scanner.ExecutarScan(Caminho);
    for ProjetoItem in Projetos do
      ContadorSQLs := ContadorSQLs + ProjetoItem.SQLs.Count;
    Writeln('? Arquivos .pas escaneados: ', Projetos.Count, ' projeto(s).');

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

      Inc(ContadorSQLs);
    end;

    SQLsDFM.Free;
    ScannerDFM.Free;

    Writeln('?? Validando consultas...');
    Analyzer.AnalisarProjetos(Projetos);
    Writeln('? Validação concluída.');

    RelatorioJSON.Gerar(Projetos);
    RelatorioHTML.Gerar(Projetos);

    Writeln('?? Relatórios salvos na pasta "Relatorios".');

    // Resumo estatístico
    Ranking := TList<TPair<string, Integer>>.Create;
    ContadorProblemas := 0;

    for ProjetoItem in Projetos do
    begin
      var ProblemasNoProjeto := 0;
      for Item in ProjetoItem.SQLs do
        if not Item.Problema.IsEmpty then
          Inc(ProblemasNoProjeto);

      ContadorProblemas := ContadorProblemas + ProblemasNoProjeto;
      Ranking.Add(TPair<string, Integer>.Create(ProjetoItem.NomeProjeto, ProblemasNoProjeto));
    end;

    Ranking.Sort(
      TComparer<TPair<string, Integer>>.Construct(
        function(const A, B: TPair<string, Integer>): Integer
        begin
          Result := B.Value - A.Value;
        end
      )
    );

    Writeln('');
    Writeln('?? Total de consultas SQL processadas: ', ContadorSQLs);
    Writeln('?? Total com problemas detectados: ', ContadorProblemas);
    Writeln('');
    Writeln('?? Projetos com mais alertas:');
    for var Pair in Ranking do
      if Pair.Value > 0 then
        Writeln('  • ', Pair.Key, ': ', Pair.Value, ' alerta(s)');

    Ranking.Free;

    // Cleanup
    Writeln('');
    Writeln('?? Finalizando e liberando memória...');
    Projetos.Free;
    Scanner.Free;
    Analyzer.Free;
    RelatorioJSON.Free;
    RelatorioHTML.Free;

    Writeln('?? Processo concluído com sucesso.');
  except
    on E: Exception do
      Writeln('? Erro: ', E.Message);
  end;
end.
