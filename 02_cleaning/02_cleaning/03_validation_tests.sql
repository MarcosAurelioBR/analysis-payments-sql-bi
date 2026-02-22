-- 1. Validar se agora conseguimos somar os valores (O que era impossível antes)
SELECT 
    transaction_status, 
    SUM(amount_value) as volume_total,
    AVG(amount_value) as ticket_medio
FROM vw_transactions_cleaned
GROUP BY transaction_status;

-- 2. Validar a distribuição de renda por gênero (Uso da View de Usuários)
SELECT 
    gender, 
    AVG(yearly_income) as renda_media,
    AVG(debt_to_income_ratio) as endividamento_medio
FROM vw_users_cleaned
GROUP BY gender;
