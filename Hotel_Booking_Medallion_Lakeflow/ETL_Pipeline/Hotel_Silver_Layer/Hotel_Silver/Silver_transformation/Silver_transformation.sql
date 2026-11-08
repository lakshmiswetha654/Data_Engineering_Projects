CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_clean (
  CONSTRAINT valid_stay_dates EXPECT (check_out_date > check_in_date) ON VIOLATION DROP ROW,
  CONSTRAINT valid_room_rate  EXPECT (room_rate >= 0)                 ON VIOLATION DROP ROW
) AS
SELECT DISTINCT
  booking_id, guest_id, check_in_date, check_out_date,
  COALESCE(nights, DATEDIFF(check_out_date, check_in_date))      AS nights,
  COALESCE(INITCAP(TRIM(city)), 'Unknown')                        AS city,
  INITCAP(TRIM(room_type))                                        AS room_type,
  COALESCE(total_amount,
           DATEDIFF(check_out_date, check_in_date) * room_rate)   AS total_amount,
  booking_status,
  booking_date, hotel_name, region, guests, room_rate, discount_amount,
  COALESCE(INITCAP(TRIM(booking_channel)), 'Unknown')            AS booking_channel,
  COALESCE(INITCAP(TRIM(meal_plan)), 'Unknown')                  AS meal_plan,
  payment_method, payment_status, guest_rating,
  _rescued_data, source_file, loaded_at
FROM bronze_hotel_bookings;
 
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_rejected AS
SELECT
  booking_id, guest_id, booking_date, check_in_date, check_out_date,
  nights, hotel_name, city, region, room_type, booking_channel,
  guests, room_rate, total_amount, discount_amount, meal_plan,
  payment_method, payment_status, booking_status, guest_rating,
  _rescued_data, source_file, loaded_at,
  CASE WHEN check_out_date <= check_in_date THEN 'Check-out is not after check-in'
       ELSE 'Room rate is negative' END AS reject_reason
FROM bronze_hotel_bookings
WHERE check_out_date <= check_in_date OR room_rate < 0;

