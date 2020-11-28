--Задание 4.1

SELECT city,
       count(airport_code)
FROM DST_PROJECT.airports
GROUP BY city
HAVING count(airport_code)>1

--Задание 4.2
--вопрос 1

SELECT count(DISTINCT status)
FROM DST_PROJECT.flights

--вопрос 2

SELECT count(flight_id)
FROM DST_PROJECT.flights
WHERE status='Departed'

--вопрос 3

SELECT count(s.seat_no)
FROM DST_PROJECT.seats s
JOIN DST_PROJECT.aircrafts a ON s.aircraft_code=a.aircraft_code WHERE a.model='Boeing 777-300'

--вопрос 4

SELECT count(flight_id)
FROM DST_PROJECT.flights WHERE status='Arrived'
AND actual_arrival BETWEEN '2017-04-01 00:00:00' AND '2017-09-01 23:59:59'

--Задание 4.3
--вопрос 1

SELECT count(flight_id)
FROM DST_PROJECT.flights WHERE status='Cancelled'

--вопрос 2

SELECT count(aircraft_code)
FROM DDST_PROJECT.aircrafts WHERE a.model LIKE '%Boeing%' /*where
a.model LIKE '%Sukhoi Superjet%'
where
a.model LIKE '%Airbus%'
*/

--вопрос 3

SELECT count(a.airport_code)
FROM DST_PROJECT.airports a 
WHERE a.Timezone like '%Europe%'

--вопрос 4

SELECT flight_id,
     actual_arrival-scheduled_arrival diff
FROM DST_PROJECT.flights 
WHERE actual_arrival>scheduled_arrival
ORDER BY 2 DESC
LIMIT 1 

--Задание 4.4
--вопрос 1

SELECT min(scheduled_departure)
FROM dst_project.flights

--вопрос 2

SELECT departure_airport,
       arrival_airport,
       (actual_arrival-actual_departure) real_diff,
       (split_part((scheduled_arrival-scheduled_departure)::text, ':', 1))::int*60+split_part((scheduled_arrival-scheduled_departure)::text, ':', 2)::int diff_in_min
FROM DST_PROJECT.flights
WHERE status='Arrived'
ORDER BY 3 DESC 

--вопрос 3

SELECT departure_airport,
       arrival_airport,
       (scheduled_arrival-scheduled_departure) diff
FROM DST_PROJECT.flights
WHERE status='Scheduled'
  AND (departure_airport='DME'
       OR departure_airport='SVO')
ORDER BY 3 DESC 

--вопрос 4

SELECT avg(((split_part((actual_arrival-actual_departure)::text, ':', 1))::int*60+split_part((actual_arrival-actual_departure)::text, ':', 2)::int))::int
FROM DST_PROJECT.flights
WHERE status='Arrived' 

--Задание 4.5
--вопрос 1

SELECT s.fare_conditions,
     count(s.seat_no)
FROM DST_PROJECT.seats s
JOIN DST_PROJECT.aircrafts a ON s.aircraft_code=a.aircraft_code WHERE a.model='Sukhoi Superjet-100'
GROUP BY s.fare_conditions
ORDER BY 2 DESC
LIMIT 1 

--вопрос 2

SELECT min(total_amount)
FROM DST_PROJECT.bookings 

--вопрос 3

SELECT b.seat_no
FROM DST_PROJECT.boarding_passes b
JOIN dst_project.tickets t ON b.ticket_no=t.ticket_no
WHERE t.passenger_id = '4313 788533' 

--задание 5.1
--вопрос 1

SELECT count(flight_id)
FROM DST_PROJECT.flights WHERE arrival_airport = 'AAQ'
AND actual_arrival BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59' 

--вопрос 2

SELECT count(flight_id)
FROM DST_PROJECT.flights WHERE departure_airport = 'AAQ'
AND actual_departure BETWEEN '2017-01-01 00:00:00' AND '2017-02-28 23:59:59'
OR actual_departure BETWEEN '2017-12-01 00:00:00' AND '2017-12-31 23:59:59' 

--вопрос 3

SELECT count(flight_id)
FROM DST_PROJECT.flights WHERE departure_airport = 'AAQ'
AND status='Cancelled' 

--вопрос 4

SELECT count(flight_id)
FROM DST_PROJECT.flights WHERE departure_airport = 'AAQ'
AND arrival_airport!='DME'
AND arrival_airport!='SVO'
AND arrival_airport!='VKO' 

--вопрос 5

SELECT a.model
FROM DST_PROJECT.flights f
JOIN dst_project.aircrafts a ON f.aircraft_code=a.aircraft_code
JOIN dst_project.seats s ON a.aircraft_code=s.aircraft_code WHERE f.departure_airport = 'AAQ'
GROUP BY a.model
ORDER BY count(seat_no) DESC
LIMIT 1