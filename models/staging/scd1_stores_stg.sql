with t0 as (
    select * from {{ source('luxury_data', 'scd1_stores_t0') }}
),
t1 as (
    select * from {{ source('luxury_data', 'scd1_stores_t1') }}
),
final as (
    select
        coalesce(t1.store_id, t0.store_id) as store_id,
        coalesce(t1.store_name, t0.store_name) as store_name,
        coalesce(t1.city, t0.city) as city,
        coalesce(t1.country, t0.country) as country,
        case
            when t0.store_id is null then 'NEW'
            when t1.store_id is null then 'DELETED'
            when (t1.store_name <> t0.store_name)
              or (t1.city <> t0.city)
              or (t1.country <> t0.country)
                then 'UPDATED'
            else 'UNCHANGED'
        end as change_type
    from t0
    full outer join t1 using (store_id)
)
select * from final