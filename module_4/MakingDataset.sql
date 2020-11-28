/*
Максимальное количество мест и тип самолета на рейсе
*/
SELECT fl.flight_id,
       ac.model,
       count(bp.seat_no) max_seats
FROM dst_project.flights fl
JOIN dst_project.seats bp ON fl.aircraft_code=bp.aircraft_code
JOIN dst_project.aircrafts ac ON fl.aircraft_code=ac.aircraft_code
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
GROUP BY fl.flight_id,
         ac.model 

/*
Количество занятых мест на рейсе
*/
SELECT fl.flight_id,
       count(bp.seat_no) seats_taken
FROM dst_project.flights fl
LEFT JOIN dst_project.boarding_passes bp ON fl.flight_id=bp.flight_id
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
GROUP BY fl.flight_id 

/* Рейсы 136511,136513,136514,136523,136540,136544,136546,136560,136567 в Новосибирск (NOZ) не имеют данных о бортовых билетах,
стоимости. Поэтому, в виду их небольшого количества, предлагается их исключить из датасета с помощью фильтрации. Однако
если бы была возможность в дальнейшем восстановить недостающую информацию, то тогда пришлось бы добавлять их в запросы.
Например, с помощью UNION и констант.
*/

/*
ID  рейса, Код рейса, Аэропорт вылета, Код аэропорта вылета, Аэропорт прилета, Код аэропорта прилета, Действительное время вылета, 
Действительное время прилета, Запланированное время вылета, Запланированное время прилета, Длительность перелета
*/
SELECT fl.flight_id,
       fl.flight_no,
       'Anapa Vityazevo Airport' departure_airport_name,
                                 fl.departure_airport,
                                 ap.airport_name arrival_airport_name,
                                 fl.arrival_airport,
                                 fl.actual_departure,
                                 fl.actual_arrival,
                                 fl.scheduled_departure,
                                 fl.scheduled_arrival,
                                 date_part('hour', (fl.actual_arrival-fl.actual_departure)) * 60 + date_part('minute', (fl.actual_arrival-fl.actual_departure)) AS duration_min
FROM dst_project.flights fl
JOIN dst_project.airports ap ON ap.airport_code=fl.arrival_airport
WHERE departure_airport = 'AAQ'
  AND (date_trunc('month', scheduled_departure) in ('2017-01-01',
                                                    '2017-02-01',
                                                    '2017-12-01'))
  AND status not in ('Cancelled')
  AND arrival_airport != 'NOZ'

/*
Задержки из-за изменения длительности полета по рпзличным причинам включая, такие как: погода, направления ветров, зона ожидания посадки, уход на второй круг.
*/
  SELECT flight_id,
         date_part('hour', actual_arrival-actual_departure - (scheduled_arrival-scheduled_departure)) * 60 + date_part('minute', actual_arrival-actual_departure - (scheduled_arrival-scheduled_departure)) AS landing_delay_mins
  FROM dst_project.flights fl WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ' 

/*
Задержки вылета
*/
  SELECT flight_id,
         date_part('hour', actual_departure - scheduled_departure) * 60 + date_part('minute', actual_departure - scheduled_departure) AS departure_delay_mins
  FROM dst_project.flights fl WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ' 

/*
Координаты Анапы - вспомогательный расчет для получения lat=45 и long=37.35
*/
SELECT latitude,
       longitude
FROM dst_project.airports
WHERE airport_code='AAQ' /*
Расстояние до аэропортов назначения
*/
  SELECT fl.flight_id,
         --ap.airport_code dest_airport,
         ROUND(2 * 6371 * asin(sqrt((sin(radians((ap.latitude - 45) / 2))) ^ 2 + cos(radians(45)) * cos(radians(ap.latitude)) * (sin(radians((ap.longitude - 37.35) / 2))) ^ 2)), 0)  AS Distance
  FROM dst_project.flights fl
  JOIN dst_project.airports ap ON fl.arrival_airport=ap.airport_code WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ' 
/*
тип, код самолета на рейсе, максимальное количество мест и максимальная дальность 
*/
SELECT fl.flight_id,
       fl.flight_no,
       ac.model,
       ac.aircraft_code,
       ac.range max_range,
       count(bp.seat_no) max_seats
FROM dst_project.flights fl
JOIN dst_project.seats bp ON fl.aircraft_code=bp.aircraft_code
JOIN dst_project.aircrafts ac ON fl.aircraft_code=ac.aircraft_code
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
GROUP BY fl.flight_id,
         ac.model,
         ac.aircraft_code


/*
Количество проданных билетов
*/ 
SELECT fl.flight_id,
       count(tf.ticket_no) tickets_registered
FROM dst_project.flights fl
JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
GROUP BY fl.flight_id

/*
Количество пассажиров прошедших на рейс
*/         
SELECT fl.flight_id,
       count(bp.seat_no) pass_on_board
FROM dst_project.flights fl
JOIN dst_project.boarding_passes bp ON fl.flight_id=bp.flight_id
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
GROUP BY fl.flight_id

/*
Количество билетов   "туда-обратно" на рейсе. При этом учитываются, как возвращающиеся из Анапы, так и вылетающие с тем чтобы вернуться потом.
Один билет "туда-обратно" может иметь разные классы обслуживания. Возможно слишком слолжный код, но по-другому, без вложенных запросов не примдумал.
*/
SELECT fl_id,
       count(t_no) two_way_tickets
FROM
  (SELECT a.ticket_no t_no,
          a.flight_id fl_id
   FROM
     (SELECT tf.ticket_no,
             fl.flight_id
      FROM dst_project.flights fl
      JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
      WHERE fl.departure_airport = 'AAQ'
        AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                             '2017-02-01',
                                                             '2017-12-01'))
        AND fl.status not in ('Cancelled')
        AND fl.arrival_airport != 'NOZ'
      GROUP BY tf.ticket_no,
               fl.flight_id) a
   JOIN
     (SELECT tf.ticket_no  -- определяем те билеты "туда-обратно" , которые дважды содержат Анапу, как arrival или destination.   

      FROM dst_project.flights fl
      JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
      WHERE ((fl.departure_airport = 'AAQ'
              AND date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                                  '2017-02-01',
                                                                  '2017-12-01'))
             OR fl.arrival_airport= 'AAQ')
        AND fl.status not in ('Cancelled')
        AND fl.arrival_airport != 'NOZ'
      GROUP BY tf.ticket_no
      HAVING count(*)>1) b ON a.ticket_no=b.ticket_no) c
GROUP BY fl_id


/*
День недели вылета
*/
  SELECT flight_id,
         date_part('dow', scheduled_departure) AS day_of_week
  FROM dst_project.flights fl WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ' 

/*
Среднее количество дней между вылетом и бронированием
*/
  SELECT fl.flight_id,
         ROUND(avg(date_part('day', fl.scheduled_departure-b.book_date)), 2)  AS avg_book_days_before_flight
  FROM dst_project.flights fl
  JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
  JOIN dst_project.tickets t ON tf.ticket_no=t.ticket_no
  JOIN dst_project.bookings b ON t.book_ref=b.book_ref WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
GROUP BY fl.flight_id /*
Среднее количество дней между вылетом и бронированием бизнесс класса
*/
SELECT fl.flight_id,
       ROUND(avg(date_part('day', fl.scheduled_departure-b.book_date)), 2) AS avg_biz_book_days_before_flight
FROM dst_project.flights fl
JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
JOIN dst_project.tickets t ON tf.ticket_no=t.ticket_no
JOIN dst_project.bookings b ON t.book_ref=b.book_ref
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
  AND tf.fare_conditions='Business'
GROUP BY fl.flight_id /*
Среднее количество дней между вылетом и бронированием эконом класса
*/
SELECT fl.flight_id,
       ROUND(avg(date_part('day', fl.scheduled_departure-b.book_date)), 2)  AS avg_book_days_before_flight
FROM dst_project.flights fl
JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
JOIN dst_project.tickets t ON tf.ticket_no=t.ticket_no
JOIN dst_project.bookings b ON t.book_ref=b.book_ref
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
  AND tf.fare_conditions='Economy'
GROUP BY fl.flight_id

/*
Количество билетов Бизнес-класса и выручка от них
*/
SELECT fl.flight_id,
       count(tf.amount) biz_tickets,
       sum(tf.amount) income_on_biz
FROM dst_project.flights fl
JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
  AND tf.fare_conditions='Business'
GROUP BY fl.flight_id 
/*
Количество бронирований бизнесс-класса, выручка от них и среднее количество билетов бизнесс-класса в бронированиях
*/
SELECT a.flight_id, count(a.book_ref) biz_books, sum(b.total_amount) income_on_biz_books, ROUND(sum(a.tickets)/count(a.book_ref), 2) avg_biz_tickets_per_book
from
(
SELECT t.book_ref, fl.flight_id,  count(t.ticket_no) tickets
from
dst_project.flights fl
join dst_project.ticket_flights tf on fl.flight_id=tf.flight_id
join dst_project.tickets t on tf.ticket_no=t.ticket_no

where fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
  AND fl.status not in ('Cancelled') AND fl.arrival_airport != 'NOZ' AND tf.fare_conditions='Business'
group by t.book_ref,fl.flight_id
) a
join dst_project.bookings b on a.book_ref=b.book_ref
group by a.flight_id
/*
Количество билетов Эконом-класса и выручка от них
*/
SELECT fl.flight_id,
       count(tf.amount) econ_tickets,
       sum(tf.amount) income_on_econ
FROM dst_project.flights fl
JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
  AND tf.fare_conditions='Economy'
GROUP BY fl.flight_id  /*
Количество бронирований Эконом-класса и выручка от них
*/
SELECT fl.flight_id,
       count(t.book_ref) econ_books,
       sum(b.total_amount) income_on_econ_books
FROM dst_project.flights fl
JOIN dst_project.ticket_flights tf ON fl.flight_id=tf.flight_id
JOIN dst_project.tickets t ON tf.ticket_no=t.ticket_no
JOIN dst_project.bookings b ON t.book_ref=b.book_ref
WHERE fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01',
                                                       '2017-02-01',
                                                       '2017-12-01'))
  AND fl.status not in ('Cancelled')
  AND fl.arrival_airport != 'NOZ'
  AND tf.fare_conditions='Economy'
GROUP BY fl.flight_id 
/*
Количество бронирований эконом-класса, выручка от них и среднее количество билетов эконом-класса в бронированиях
*/
SELECT a.flight_id, count(a.book_ref) econ_books, sum(b.total_amount) income_on_econ_books, ROUND(sum(a.tickets)/count(a.book_ref), 2) avg_econ_tickets_per_book
from
(
SELECT t.book_ref, fl.flight_id,  count(t.ticket_no) tickets
from
dst_project.flights fl
join dst_project.ticket_flights tf on fl.flight_id=tf.flight_id
join dst_project.tickets t on tf.ticket_no=t.ticket_no

where fl.departure_airport = 'AAQ'
  AND (date_trunc('month', fl.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
  AND fl.status not in ('Cancelled') AND fl.arrival_airport != 'NOZ' AND tf.fare_conditions='Economy'
group by t.book_ref,fl.flight_id
) a
join dst_project.bookings b on a.book_ref=b.book_ref
group by a.flight_id

