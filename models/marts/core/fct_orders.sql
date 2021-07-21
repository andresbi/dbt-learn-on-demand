with orders as (
select      a.order_id, a.customer_id, a.order_date 
from        {{ ref("stg_orders")}} a
)

,    payments as (
SELECT      order_id,
            sum(case when status = 'success' then amount end) as amount 
FROM        {{ref("stg_payments")}}
GROUP BY    order_id
)

select      a.order_id,
            a.customer_id,
            a.order_date,
            coalesce(b.amount,0) amount
from        orders a
LEFT JOIN   payments b on a.order_id = b.order_id