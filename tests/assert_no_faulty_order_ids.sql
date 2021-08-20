select
    order_id,
    count(distinct customer_id) as dis_customer_id

from {{ ref('fct_orders') }}

group by order_id

having dis_customer_id > 1