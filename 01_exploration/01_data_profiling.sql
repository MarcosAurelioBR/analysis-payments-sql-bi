/* PROJETO: Análise de Ecossistema de Pagamentos
   ETAPA: Diagnóstico de Dados 
   OBJETIVO: Identificar inconsistências, tipos de dados inadequados e valores nulos.
*/

-- 1. Verificação de Tipos de Dados e Estrutura
 SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('transactions_raw', 'users_raw', 'cards_raw')
ORDER BY TABLE_NAME;

-- 2. Análise de Qualidade: Identificando valores Nulos
 SELECT 
    'transactions' as tabela,
    COUNT(*) as total_registros,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) as amount_nulos,
    SUM(CASE WHEN errors IS NULL OR errors = '' THEN 1 ELSE 0 END) as transacoes_sucesso,
    SUM(CASE WHEN errors IS NOT NULL AND errors <> '' THEN 1 ELSE 0 END) as transacoes_com_erro
FROM payments_core.dbo.transactions_raw;

-- 3. Verificação de Padrões (Formatos Sujos)
SELECT TOP 5 
    amount,
    date,
    merchant_city
FROM payments_core.dbo.transactions_raw;

-- 4. Consistência entre Tabelas  
SELECT COUNT(DISTINCT t.client_id) as clientes_com_transacao
FROM payments_core.dbo.transactions_raw t
LEFT JOIN payments_core.dbo.users_raw u ON t.client_id = u.user_id
WHERE u.user_id IS NULL;
