select
    order_id,
    sum(amount) as amount
from
    {{ ref('stg_payments') }}

group by order_id

having not (amount >= 0)