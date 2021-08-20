with payments as (select * from {{ ref('stg_payments') }}),

orders as (select * from {{ ref('stg_orders') }}),

successful_orders as (
    select 
        order_id,
        sum(case when payments.status = 'success' then payments.amount end) as amount
    
    from payments

    group by 1
),

final as (
    select 
        orders.customer_id,
        orders.order_id,
        coalesce(successful_orders.amount, 0) as amount

    from orders left join successful_orders using(order_id)
)

select * from final

--select sum(case when payments.status = 'success' then amount end) as amount from payments