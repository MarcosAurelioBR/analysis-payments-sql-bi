
/* ETAPA 3: MODELAGEM (STAR SCHEMA)
   OBJETIVO: Tabela Fato unificada para alimentação do BI.
*/

CREATE OR ALTER VIEW vw_fact_payments_performance AS
SELECT 
    t.transaction_id,
    t.user_id, -- Coluna essencial para cálculos de recorrência
    t.transaction_timestamp,
    t.amount_value,
    t.transaction_status,
    u.gender,
    u.current_age,
    u.credit_score,
    u.yearly_income,
    u.debt_to_income_ratio,
    t.merchant_city,
    t.merchant_state,
    m.mcc_description AS category_name
FROM vw_transactions_cleaned t
INNER JOIN vw_users_cleaned u ON t.user_id = u.user_id
LEFT JOIN payments_core.dbo.mcc_codes m ON t.mcc = m.mcc;
GO
