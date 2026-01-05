{{ config (materalized='incremental',
unique_key='listing_id')}}

select
    listing_id,
    Host_id,
    PROPERTY_TYPE,
    ROOM_TYPE,
    CITY,
    COUNTRY,
    ACCOMMODATES,
    BEDROOMS,
    BATHROOMS,  
    PRICE_PER_NIGHT,
    {{ tag('price_per_night') }}  as price_category,
    CREATED_AT
    from {{ ref( 'bronze_listings') }}


   