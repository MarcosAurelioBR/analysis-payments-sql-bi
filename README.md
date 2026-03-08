# 💳 Projeto: Ecossistema de Análise de Pagamentos (Big Data)

Este projeto simula um ambiente real de Fintech, processando mais de **15 milhões de transações** para gerar insights sobre comportamento de consumo, saúde financeira e performance de vendas utilizando SQL Server.

## Fonte de Dados
Os dados utilizados foram extraídos do Kaggle: [Transactions Fraud Datasets](https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets/data).
> **Nota:** Devido ao volume massivo (15M+ registros), o projeto utiliza **Views** e **CTEs** para otimizar o processamento e garantir a performance das consultas, evitando o consumo excessivo de memória física.

---

##  Ciclo de Desenvolvimento

### Etapa 1: Diagnóstico dos Dados 
Nesta fase inicial, analisei a base bruta e identifiquei os "gargalos" técnicos que inviabilizariam análises diretas:
* **Inconsistência de Tipos:** Colunas críticas como `amount` e `yearly_income` estavam formatadas como texto (varchar).
* **Formatos de Data:** Datas armazenadas como string, impossibilitando a ordenação cronológica e cálculos de recorrência.
* **Sujeira nos Campos:** Presença de caracteres especiais como `$` e espaços vazios.
* **Desafio de Escala:** A necessidade de processar 15 milhões de linhas sem comprometer a estabilidade do sistema.

**Script de Referência:** `01_exploration/01_data_profiling.sql`

---

### Etapa 2: Limpeza e Transformação (Data Cleaning)
Utilizei a estratégia de **Camadas de Visualização (Views)** para transformar os dados brutos em informação útil sem alterar a base original (preservando o Data Lake):
* **`vw_transactions_cleaned`**: Implementação de `TRY_CONVERT` para blindagem contra erros de data (Erro 242) e limpeza de símbolos monetários via `REPLACE`.
* **`vw_users_cleaned`**: Padronização da renda anual e criação da métrica de **Índice de Endividamento**, que mede o comprometimento financeiro do cliente.

**Script de Referência:** `02_cleaning/01_vw_transactions_cleaned.sql`

---

### Etapa 3: Modelagem de Dados (Star Schema)
Criação de uma **Tabela Mestra (Fact View)** unificada para servir de "coração" às análises de BI:
* **Unificação:** Integração de transações, perfis demográficos de usuários e categorias de mercadores (MCC) via `INNER JOIN`.
* **Performance:** A estrutura foi projetada para que ferramentas como Power BI ou Tableau realizem filtros instantâneos (por gênero, estado ou categoria) sem a necessidade de processamento pesado em tempo de execução.

**Script de Referência:** `03_modeling/01_fact_payments_performance.sql`

---

### Etapa 4: Resultados e Insights de Negócio
Com a estrutura modelada, extraímos indicadores estratégicos para tomada de decisão:

#### 1. Performance Financeira
* **TPV (Total Payment Volume):** Consolidação do faturamento bruto aprovado.
* **Ticket Médio:** Identificação de categorias líderes de faturamento, com destaque para *Money Transfer*.

#### 2. Análise de Risco e Crédito
* **Motivos de Recusa:** Identificamos que **61.92%** das negativas ocorrem por "Saldo Insuficiente", correlacionando-se diretamente com o alto índice de endividamento mapeado na Etapa 2.
* **Perfil de Crédito:** Clientes com Score Alto apresentam estabilidade, mas com um índice de endividamento médio de **1.30**, sugerindo oportunidade para produtos de refinanciamento.

#### 3. Deep Analytics 
Implementação de queries avançadas para extrair inteligência de dados:
* **Análise de Recorrência:** Cálculo do tempo médio (em minutos) entre compras utilizando a função de janela `LAG`.
* **Detecção de Anomalias:** Aplicação de **Z-Score** para identificar transações suspeitas ou fora do padrão de gasto por categoria.
* **Crescimento Mensal (MoM):** Monitoramento de faturamento mensal com cálculo de variação percentual e Médias Móveis.

**Scripts de Referência:** `04_insights/01_business_queries.sql` e `04_insights/02_advanced_analytics.sql`

#### Etapa 5: Dashboard e Business Intelligence

Nesta fase final, conectei o Power BI às Views do SQL Server para criar uma camada de visualização estratégica voltada para o mercado brasileiro. Realizei a localização dos dados, traduzindo termos técnicos e adaptando a moeda para facilitar o consumo por gestores locais.
Tratamento e Modelagem (Power Query)

Conforme evidenciado nas capturas de tela do projeto:

    Limpeza Adicional: Realizei a renomeação de colunas e ajuste de tipos de dados (Data/Hora separadas) para otimizar o modelo de dados.

    Relacionamentos: Implementei um modelo Star Schema, utilizando uma tabela Calendário para permitir análises temporais precisas e relacionando as dimensões de usuários, transações e categorias.

Inteligência de Dados (DAX)

Desenvolvi medidas avançadas para extrair indicadores de crescimento e tendência.

Insights Visuais

O dashboard final apresenta uma interface de alto impacto (Dark Mode) com:

    Cartões de KPI Dinâmicos: Exibição de valores absolutos com indicadores de tendência (Sparklines) e variação percentual.

    Visão por Segmento: Gráfico de barras horizontais identificando os setores com maior volume transacional (ex: Money Transfer e Grocery Stores).

    Sazonalidade: Monitoramento mensal do volume de vendas para suporte à estratégia de marketing e estoque.
---

## Conclusão
Este projeto demonstra maturidade técnica para lidar com **Big Data**, percorrendo todo o fluxo de dados: desde a limpeza e tratamento de erros complexos de conversão até a modelagem analítica e extração de insights estatísticos de alto nível.
