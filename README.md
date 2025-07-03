# 🔍 QueryAnalyzer - Validador de SQLs em projetos Delphi

Ferramenta de linha de comando que escaneia projetos Delphi em busca de comandos SQL embutidos em arquivos `.pas` e `.dfm`, identifica práticas ruins e gera relatórios organizados em JSON e HTML. Ideal para uso em esteiras CI/CD, validação automática com Jenkins ou auditoria interna.

---

## ⚙️ Funcionalidades

- ✅ Varredura recursiva de arquivos `.pas` (código fonte Delphi).
- ✅ Análise de arquivos `.dfm` (formulários visuais).
- 🧠 Identificação automática de SQLs em componentes `TFDQuery`.
- 🚨 Validação de más práticas em SQL:
  - `SELECT *` em vez de colunas explícitas.
  - `DELETE` ou `UPDATE` sem cláusula `WHERE`.
  - `JOIN` sem condição `ON`.
- 📁 Agrupamento por projeto (baseado na estrutura de pastas).
- 🧾 Geração de relatórios em:
  - `relatorio.json` → ideal para automações.
  - `relatorio.html` → leitura visual, segmentado por projeto.
- 📊 Estatísticas ao final:
  - Total de consultas analisadas.
  - Total de problemas detectados.
  - Ranking de projetos com mais alertas.

---

## 🚀 Como usar

Compile o projeto com Delphi e execute via linha de comando:

```bash
QueryAnalyzer.exe "C:\Fontes"

📂 Saída gerada
Na pasta do executável será criada a pasta Relatorios com:
- relatorio.json
- relatorio.html
O console exibirá o resumo da análise com contagens e ranking por projeto.

🧱 Estrutura interna
- TClasseScanner → varre .pas e extrai SQLs.
- TScannerDFM → varre .dfm e extrai SQLs.
- TClasseAnalyzer → aplica regras e sugestões.
- TClasseRelatorioJSON → gera relatório JSON.
- TClasseRelatorioHTML → gera relatório HTML.
- TSQLItem → representa cada SQL.
- TProjetoItem → agrupa por projeto.


