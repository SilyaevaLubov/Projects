------------------------------------------------------------------
1. Знакомство со схемой, таблицами и их связями.

1.1 Проверяем в правильной ли схеме работаем.

SELECT schema_name
FROM information_schema.schemata;

1.2 Проверяем, какие таблицы есть в схеме.

SELECT table_name
FROM information_schema.tables
WHERE table_schema='afisha';

1.3 Проверим первичные и вторичные ключи таблиц и сравним их с диаграммой.

SELECT 
table_name, 
column_name,
constraint_name
FROM information_schema.key_column_usage
WHERE table_schema='afisha'
ORDER BY table_name, column_name;

Вывод:
	В таблице purchases столбец event_id дважды указан как внешний ключ. 
Это видно как на диаграмме, так и при выводе данных при обработке запроса.
Возможно, эта ошибка могла возникнуть в процессе обновления данных.
	В схеме таблицы purchases и events, events и city, events и venues
связаны по типу "один ко многим". Таблицы city и regions связаны по типу "один к одному".
Связь "многие ко многим" отсутсвует.

----------------------------------------------------------------

2. Работа с каждой таблицей.
Проверяем:
- соответствие описанию, 
- размер таблицы, 
- наличие пропусков и дубликатов, 
- проверяем распределение по категориям,
- проверяем аномальные значения,
- смотрим период времени, за который представлены данные.

--------------------------------
2.1 Проверим таблицу purchases.

2.1.1 Проверим содержимое таблицы, соответсвует ли оно описанию. 
Выведем названия таблиц, названия их столбцов и типы.

SELECT 
table_name,
column_name,
udt_name
FROM information_schema.columns
WHERE table_schema = 'afisha'
AND table_name   = 'purchases';

Все названия и типы столбцов в таблице соответсвуют описанию.

2.1.2 Проверим в каком объеме представлены данные в таблице.

SELECT COUNT(*),
COUNT(DISTINCT user_id)
FROM afisha.purchases;

Таблица purchases содержит 292034 строк. То есть 22000 заказов и 22000 уникальных пользователей.

2.1.3 Проверим наличие дубликатов и пропусков в таблице.

SELECT COUNT(*)
FROM afisha.purchases
WHERE purchases.order_id IS NULL OR
	purchases.user_id IS NULL OR 
	purchases.created_dt_msk IS NULL OR 
	purchases.created_ts_msk IS NULL OR 
	purchases.event_id IS NULL OR 
	purchases.cinema_circuit IS NULL OR 
	purchases.age_limit IS NULL OR 
	purchases.currency_code IS NULL OR 
	purchases.device_type_canonical IS NULL OR 
	purchases.revenue IS NULL OR
	purchases.service_name IS NULL OR 
	purchases.tickets_count IS NULL OR
	purchases.total IS NULL;

Таблица не содержит пропусков.

SELECT *
FROM afisha.purchases
GROUP BY order_id, 
	user_id, 
	created_dt_msk, 
	created_ts_msk, 
	event_id, 
	cinema_circuit, 
	age_limit, 
	currency_code, 
	device_type_canonical, 
	revenue, 
	service_name,
	tickets_count,
	total
HAVING COUNT(*)>1;

Таблица не содержит явных дубликатов.

SELECT *
FROM afisha.purchases
GROUP BY order_id
HAVING COUNT(order_id)>1;

Идентификаторы заказов уникальны.

2.1.4 Распределение по категориям.

- По сети кинотеатров:

SELECT cinema_circuit,
COUNT(*) AS cnt
FROM afisha.purchases
GROUP BY cinema_circuit;

Другое	1263
КиноСити	124
Киномакс	7
Москино	7
ЦентрФильм	1
нет	290632

Большинство мероприятий проходит не в кинотеатрах.

- По возрастному ограничению:

SELECT age_limit,
COUNT(*) AS cnt
FROM afisha.purchases
GROUP BY age_limit;

0	61731
6	52403
12	62861
16	78864
18	36175

Наибольшее количество мероприятий имело рейтинг 16+, наименьшее 18+.

- По валюте:

SELECT currency_code,
COUNT(*) AS cnt
FROM afisha.purchases
GROUP BY currency_code;

kzt	5073
rub	286961

Большая часть билетов покупается в рублях.

- По типу устройства, с которого делается заказ:

SELECT device_type_canonical,
COUNT(*) AS cnt
FROM afisha.purchases
GROUP BY device_type_canonical;

desktop	58170
mobile	232679
other	2
tablet	1180
tv	3

Большая часть заказов делается с мобильного, наименьшее количество с тв.

- По билетному оператору:

SELECT service_name,
COUNT(*) AS cnt
FROM afisha.purchases
GROUP BY service_name
ORDER BY service_name;

Crazy ticket!	796
Show_ticket	2208
Билет по телефону	85
Билеты без проблем	63932
Билеты в интернете	4
Билеты в руки	40500
Быстробилет	2010
Быстрый кассир	381
Весь в билетах	16910
Восьмёрка	1126
Вперёд!	81
Выступления.ру	1621
Городской дом культуры	2747
Дом культуры	4514
Дырокол	74
За билетом!	2877
Зе Бест!	5
КарандашРУ	133
Кино билет	67
Край билетов	6238
Лимоны	8
Лови билет!	41338
Лучшие билеты	17872
Мир касс	2171
Мой билет	34965
Облачко	26730
Прачечная	10385
Радио ticket	380
Реестр	130
Росбилет	544
Тебе билет!	5242
Телебилет	321
Тех билет	22
Цвет и билет	61
Шоу начинается!	499
Яблоко	5057
-------------------------------------

Чаще пользуются сервисов "билеты без проблем", меньше всего используют сервис "росбилет".

2.1.5 Проверяем аномальные значения.

- Выручка от заказа:

SELECT
MIN(revenue) AS min,
MAX(revenue) AS max,
(MAX(revenue)-MIN(revenue)) AS R,
AVG(revenue) AS avg,
PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY revenue) AS Q1,
PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY revenue) AS median,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY revenue) AS Q3,
PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY revenue) AS proc99
FROM afisha.purchases;

min		-90.76
max		81174.54	
R		81265.3	
AVG		624.8337734042846	
Q1		116.79	
median	355.34	
Q3		809.46
proc99	3998.27

В зачениях выручки есть аномалии. Есть отрицательные значения выручки. А также выбросы (макс).
Также судя по описательным статистикам можно сказать, что распределение правосторонее нессиметричное.

- Выручка в разрезе валют:

SELECT
currency_code,
MIN(revenue) AS min,
MAX(revenue) AS max,
(MAX(revenue)-MIN(revenue)) AS R,
AVG(revenue) AS avg,
PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY revenue) AS Q1,
PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY revenue) AS median,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY revenue) AS Q3,
PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY revenue) AS proc99,
STDDEV(revenue)
FROM afisha.purchases
GROUP BY currency_code;

		kzt					rub
min		0.0					-90.76
max		26425.86			81174.54
R		26425.86			81265.3
AVG		4995.309819793927	547.5709224129142
Q1		518.1				113.95
median	3698.83				346.18
Q3		7397.66				791.38
proc99	17617.24			2570.8
std		4916.643159299363	870.6202370550681

У теньге нет аномалий, но есть выбросы (макс). Распределение несимметричное правостороннее.
Для рубля наблюдаются аномалии. Есть отрицательные значения выручки. А также выбросы (макс).
Распределение несимметричное правостороннее.

- Количество купленных билетов:

SELECT
MIN(tickets_count) AS min,
MAX(tickets_count) AS max,
(MAX(tickets_count)-MIN(tickets_count)) AS R,
AVG(tickets_count) AS avg,
PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY tickets_count) AS Q1,
PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tickets_count) AS median,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tickets_count) AS Q3,
PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY tickets_count) AS proc99
FROM afisha.purchases;

min		1
max		57	
R		56
AVG		2.7545080367354486	
Q1		2
median	3	
Q3		4
proc99	6

По количеству купленных билетов аномалий нет, но есть выбросы (макс).
Распределение симметричное.

- Общая сумма заказа:

SELECT
MIN(total) AS min,
MAX(total) AS max,
(MAX(total)-MIN(total)) AS R,
AVG(total) AS avg,
PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY total) AS Q1,
PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY total) AS median,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY total) AS Q3,
PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total) AS proc99
FROM afisha.purchases;

min		-358.85	
max		811745.4	
R		812104.25	
AVG		7524.00004975828	
Q1		2157.32	
median	4771.39	
Q3		8955.95	
proc99	61647.16

Присутствуют аномальные значения (скорее всего в тех же строках, где указана выручка < 0).
Есть выбросы (макс). Распределение несимметричное правостороннее.

2.1.6 Проверяем временные рамки данных.

SELECT
MIN(created_dt_msk) AS minD,
MAX(created_dt_msk) AS maxD,
MIN(created_ts_msk) AS minDT,
MAX(created_ts_msk) AS maxDT
FROM afisha.purchases;

Временные рамки данных: с 01.06.2024 по 31.10.2024. 

2.2 Проверим таблицу events.

2.2.1 Проверим содержимое таблицы, соответсвует ли оно описанию. Выведем названия таблиц, названия их столбцов и типы.

SELECT 
table_name,
column_name,
udt_name
FROM information_schema.columns
WHERE table_schema = 'afisha'
AND table_name   = 'events';

Все названия и типы столбцов в таблице соответсвуют описанию.

2.2.2 Проверим в каком объеме представлены данные в таблице.

SELECT COUNT(*)
FROM afisha.events;

Таблица events содержит 22484 строк.

2.2.3 Проверим наличие дубликатов и пропусков в таблице.

SELECT COUNT(*)
FROM afisha.events
WHERE event_id IS NULL OR
	event_name_code IS NULL OR 
	event_type_description IS NULL OR 
	event_type_main IS NULL OR 
	organizers IS NULL OR 
	city_id IS NULL OR 
	venue_id IS NULL;

Таблица не содержит пропусков.

SELECT *
FROM afisha.events
GROUP BY event_id, 
	event_name_code, 
	event_type_description, 
	event_type_main, 
	organizers, 
	city_id, 
	venue_id
HAVING COUNT(*)>1;

Таблица не содержит явных дубликатов.

SELECT *
FROM afisha.events
GROUP BY event_id
HAVING COUNT(event_id)>1;

Идентификаторы мероприятий уникальны.

2.2.4 Распределение по категориям.

- По типу мероприятия:

SELECT event_type_main,
COUNT(*) AS cnt
FROM afisha.events
GROUP BY event_type_main
ORDER BY cnt;

фильм	19
ёлки	215
выставки	291
стендап	636
спорт	872
другое	4662
театр	7090
концерты	8699

Больше всего мероприятий относятся к концертам, меньше всего представлено фильмов.


--для объединенных таблиц

/*SELECT e.event_type_main,
COUNT(*) AS cnt
FROM afisha.events AS e
JOIN afisha.purchases AS p ON p.event_id=e.event_id
GROUP BY e.event_type_main
ORDER BY cnt;

фильм	238
ёлки	2006
выставки	4873
стендап	13424
спорт	22006
другое	66109
театр	67744
концерты	115634 */

-----------------------------------

2.3 Проверим таблицу venues.

2.3.1 Проверим содержимое таблицы, соответсвует ли оно описанию. Выведем названия таблиц, названия их столбцов и типы.

SELECT 
table_name,
column_name,
udt_name
FROM information_schema.columns
WHERE table_schema = 'afisha'
AND table_name   = 'venues';

Все названия и типы столбцов в таблице соответсвуют описанию.

2.3.2 Проверим в каком объеме представлены данные в таблице.

SELECT COUNT(*)
FROM afisha.venues;

Таблица venues содержит 3228 строк.

2.3.3 Проверим наличие дубликатов и пропусков в таблице.

SELECT COUNT(*)
FROM afisha.venues
WHERE venue_id IS NULL OR
	venue_name IS NULL OR 
	address IS NULL;

Таблица не содержит пропусков.

SELECT *
FROM afisha.venues
GROUP BY venue_id, 
	venue_name, 
	address
HAVING COUNT(*)>1;

Таблица не содержит явных дубликатов.

SELECT *
FROM afisha.venues
GROUP BY venue_id
HAVING COUNT(venue_id)>1;

Идентификаторы площадок уникальны.

---------------------------------

2.4 Проверим таблицу city.

2.4.1 Проверим содержимое таблицы, соответсвует ли оно описанию. Выведем названия таблиц, названия их столбцов и типы.

SELECT 
table_name,
column_name,
udt_name
FROM information_schema.columns
WHERE table_schema = 'afisha'
AND table_name   = 'city';

Все названия и типы столбцов в таблице соответсвуют описанию.

2.4.2 Проверим в каком объеме представлены данные в таблице.

SELECT COUNT(*)
FROM afisha.city;

Таблица city содержит 353 строки.

2.4.3 Проверим наличие дубликатов и пропусков в таблице.

SELECT COUNT(*)
FROM afisha.city
WHERE city_id IS NULL OR
	city_name IS NULL OR 
	region_id IS NULL;

Таблица не содержит пропусков.

SELECT *
FROM afisha.city
GROUP BY city_id, 
	city_name, 
	region_id
HAVING COUNT(*)>1;

Таблица не содержит явных дубликатов.

SELECT *
FROM afisha.city
GROUP BY city_id
HAVING COUNT(city_id)>1;

Идентификаторы городов уникальны.

---------------------------------

2.5 Проверим таблицу regions.

2.5.1 Проверим содержимое таблицы, соответсвует ли оно описанию. Выведем названия таблиц, названия их столбцов и типы.

SELECT 
table_name,
column_name,
udt_name
FROM information_schema.columns
WHERE table_schema = 'afisha'
AND table_name   = 'regions';

Все названия и типы столбцов во всех таблицах рабочей схемы соответсвуют описанию.

2.5.2 Проверим в каком объеме представлены данные в таблице.

SELECT COUNT(*)
FROM afisha.regions;

Таблица regions содержит 81 строку.

2.5.3 Проверим наличие дубликатов и пропусков в таблице.

SELECT COUNT(*)
FROM afisha.regions
WHERE region_id IS NULL OR
	region_name IS NULL;

Таблица не содержит пропусков.

SELECT *
FROM afisha.regions
GROUP BY region_id, 
	region_name
HAVING COUNT(*)>1;

Таблица не содержит явных дубликатов.

SELECT *
FROM afisha.regions
GROUP BY region_id
HAVING COUNT(region_id)>1;

Идентификаторы регионов уникальны.


