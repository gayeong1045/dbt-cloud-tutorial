with payments as (


select
    id as customer_id,
    orderid as order_id,
    paymentmethod,
    status,
    amount,
    created

from {{ source('stripe', 'stripe_payments') }}



)
select * from payments