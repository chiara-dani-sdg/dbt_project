with t0 as (
    select * from {{ source('luxury_data', 'scd3_products_t0') }}
),
t1 as (
    select * from {{ source('luxury_data', 'scd3_products_t1') }}
),
joined as (
    select
        coalesce(t1.product_id, t0.product_id) as product_id,
        coalesce(t1.product_name, t0.product_name) as product_name,
        coalesce(t1.category, t0.category) as category,
        coalesce(t1.country, t0.country) as country,
        case
            when t0.product_id is null then t1.price
            when t1.product_id is null then t0.price
            else coalesce(t1.price, t0.price)
        end as price_current,
        case
            when t1.product_id is not null
             and t0.product_id is not null
             and t1.price <> t0.price
                then t0.price
            else null
        end as price_previous,
        case
            when t0.product_id is null then 'NEW'
            when t1.product_id is null then 'DELETED'
            when t1.price <> t0.price then 'UPDATED'
            else 'UNCHANGED'
        end as change_type,
        current_timestamp() as change_date
    from t0
    full outer join t1 using (product_id)
)
select * from joined