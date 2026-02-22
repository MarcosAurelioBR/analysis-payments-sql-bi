/* 
PROJETO: Análise de Ecossistema de Pagamentos
ETAPA 4: VALIDAÇÃO DE KPIs E INSIGHTS DE NEGÓCIO
OBJETIVO: Extrair indicadores estratégicos da Tabela Fato unificada.

*/

-- 1. PERFORMANCE POR CATEGORIA
-- Analisa o volume total transacionado (TPV) e o ticket médio por setor.
-- Útil para identificar os segmentos de mercado com maior relevância financeira.
SELECT 
    category_name,
    COUNT(*) AS qtd_transacoes,
    SUM(amount_value) AS volume_total_tpv,
    AVG(amount_value) AS ticket_medio
FROM vw_fact_payments_performance
WHERE transaction_status = 'Success'
GROUP BY category_name
ORDER BY volume_total_tpv DESC;


-- 2. ANÁLISE DE RISCO (MOTIVOS DE RECUSA)
-- Identifica os principais gargalos que impedem a aprovação das transações.
-- O cálculo percentual ajuda a priorizar ações de melhoria na taxa de aprovação.
SELECT 
    transaction_status, -- Motivo do erros
    COUNT(*) AS total_ocorrencias,
    CAST((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()) AS DECIMAL(10,2)) AS percentual_do_total
FROM vw_fact_payments_performance
WHERE transaction_status <> 'Success'
GROUP BY transaction_status
ORDER BY total_ocorrencias DESC;


-- 3. PERFIL DEMOGRÁFICO E FINANCEIRO
-- Compara o comportamento de consumo, renda e saúde financeira entre os gêneros.
-- Tratamento com CAST para evitar erro de estouro aritmético em grandes volumes.
SELECT 
    gender,
    CAST(AVG(CAST(credit_score AS FLOAT)) AS DECIMAL(10,2)) AS score_medio,
    CAST(AVG(CAST(yearly_income AS FLOAT)) AS DECIMAL(10,2)) AS renda_media,
    CAST(SUM(CAST(amount_value AS DECIMAL(38,2))) AS DECIMAL(38,2)) AS volume_total,
    CAST(AVG(CAST(debt_to_income_ratio AS FLOAT)) AS DECIMAL(10,2)) AS endividamento_medio
FROM vw_fact_payments_performance
WHERE transaction_status = 'Success'
GROUP BY gender;

-- 4. SAÚDE FINANCEIRA POR FAIXA DE SCORE
-- Classifica os clientes por qualidade de crédito e analisa o nível de alavancagem
-- (razão entre dívida total e renda anual).
-- Permite avaliar se scores mais altos estão associados a menor nível de endividamento relativo.

WITH base AS (
    SELECT
        CASE 
            WHEN credit_score < 500 THEN 'Baixo (Até 500)'
            WHEN credit_score >= 500 AND credit_score < 700 THEN 'Médio (500-700)'
            ELSE 'Alto (Acima 700)'
        END AS faixa_score,
        debt_to_income_ratio
    FROM vw_users_cleaned
    WHERE debt_to_income_ratio IS NOT NULL
)

SELECT 
    faixa_score,
    CAST(AVG(debt_to_income_ratio) AS DECIMAL(10,2)) AS indice_endividamento_medio,
    COUNT(*) AS total_clientes
FROM base
GROUP BY faixa_score
ORDER BY 
    CASE faixa_score
        WHEN 'Baixo (Até 500)' THEN 1
        WHEN 'Médio (500-700)' THEN 2
        ELSE 3
    END;
