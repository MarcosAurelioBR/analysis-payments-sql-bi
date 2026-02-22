Etapa 1: Diagnóstico dos Dados

Nesta fase inicial, analisei a base bruta e identifiquei os pontos que precisavam de correção para viabilizar as análises:

    Problemas com Números: Colunas importantes como valor da compra (amount) e renda anual (yearly_income) estavam como texto, o que impedia qualquer cálculo matemático.

    Formato de Datas: As datas também estavam como texto, impossibilitando organizar os gastos por dia, mês ou ano.

    Sujeira nos Campos: Presença de caracteres como o cifrão ($) e espaços vazios que atrapalhavam a leitura dos dados.

    Grande Volume: A base de transações tem 15 milhões de registros, o que exige queries bem estruturadas para não travar o sistema.

O que foi feito:

O script 01_exploration/01_data_profiling.sql validou as seguintes necessidades:

    Limpeza Financeira: Remover o $ e converter os valores para formato numérico para somar totais e calcular médias.

    Ajuste de Calendário: Converter as datas para o formato correto, permitindo ver a evolução das vendas no tempo.

    Padronização de Erros: As transações sem erro estavam vazias. Padronizei para 'Success' para facilitar a contagem no Dashboard.

    Uso de Views: Como a base é muito grande, decidi usar Views. Assim, mantenho os dados originais guardados e crio uma camada de leitura muito mais rápida para o BI.

Etapa 2: Limpeza e Transformação

Com os problemas mapeados, criei os scripts para limpar e organizar os dados de transações e usuários.

O que foi feito:

Utilizei Views para transformar os dados brutos em informações prontas para o uso, sem alterar a base original:

    vw_transactions_cleaned: Corrigi os valores em dinheiro, tratei os nomes dos erros e ajustei o formato da data (resolvendo conflitos de leitura do sistema).

    vw_users_cleaned: Limpei a renda dos clientes e criei um cálculo de Endividamento, que mostra o quanto da renda do cliente está comprometida.

Etapa 3: Modelagem dos Dados

Nesta etapa, o foco foi juntar as peças. Em vez de trabalhar com várias tabelas espalhadas, criei uma Tabela Mestra.

O que foi feito:

Criei a View final vw_fact_payments_performance, que é o "coração" do projeto:

    Unificação: Juntei os dados de transações, os perfis dos usuários e os nomes das categorias de lojas em um só lugar.

    Dados Prontos: Com tudo unificado, o Dashboard não precisa fazer cálculos pesados toda hora. Ele já recebe os dados prontos para mostrar os gráficos.

    Filtros Rápidos: A estrutura foi montada para permitir filtros instantâneos por categoria de gasto, gênero e pontuação de crédito (Score).

Etapa 4: Resultados e Insights de Negócio

Com a estrutura pronta, já conseguimos extrair indicadores importantes para a tomada de decisão:
1. Desempenho Financeiro

    Volume Total (TPV): Valor total de vendas aprovadas.

    Ticket Médio: Valor médio gasto por compra em cada categoria.

    Principais Setores: Identificamos que Money Transfer (Transferência de Dinheiro) é a categoria com maior volume financeiro.

2. Análise de Risco

    Taxa de Aprovação: Proporção entre compras aprovadas e negadas.

    Motivos de Recusa: O principal motivo de cancelamento foi Saldo Insuficiente, o que faz sentido, já que identificamos um alto índice de endividamento na base de usuários.

3. Perfil do Cliente

    Gastos por Gênero: Comparação de consumo entre homens e mulheres.

    Comportamento: Identificação de clientes fiéis que usam o cartão com recorrência.

### Validação dos Dados
Para extrair os indicadores acima, foram desenvolvidas queries de agregação que consolidam os 15 milhões de registros. Os scripts completos podem ser encontrados na pasta `/04_insights`.

**Exemplo de insight extraído:**
* **Risco:** 61.92% das negativas de pagamento concentram-se em "Saldo Insuficiente", permitindo uma ação direcionada para aumento de limites ou produtos de crédito para perfis específicos.
* **Perfil:** Clientes com Score Alto apresentam um índice de endividamento de 1.30, confirmando a estabilidade da base principal.
