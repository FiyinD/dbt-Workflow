{{
    config(
        materialized='incremental',
        unique_key='payment_id'
     )
}}

with source_payments as (
    select * from {{ source('stripe', 'payment') }}
    {% if is_incremental() %}
    where _batched_at > (select max(_batched_at) from {{ this }})
    {% endif %}

)

select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    {{ cents_to_dollar('amount') }} as amount,
    created as created_date,
    _batched_at as latest_load_date

from source_payments as payments


