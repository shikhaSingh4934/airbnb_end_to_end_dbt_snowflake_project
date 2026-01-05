{{ config 
(materialized='incremental',
unique_key='booking_id') 
}}

select  
    booking_id,
    listing_id,
    booking_date,
    SERVICE_FEE,
    CLEANING_FEE,
    nights_booked, 
    booking_amount,
    ({{multiply('nights_booked', 'booking_amount', 2) }} + CLEANING_FEE + SERVICE_FEE) as total_booking_amount,
    booking_status,
    created_at
    from {{ ref( 'bronze_bookings') }}