------------------------------------------------------------------
Рассчет метрик.

1 Вычислите общие значения ключевых показателей сервиса за весь период:
- общая выручка с заказов total_revenue;
- количество заказов total_orders;
- средняя выручка заказа avg_revenue_per_order;
- общее число уникальных клиентов total_users.

Напишите запрос для вычисления этих значений. 
Поскольку данные представлены в российских рублях и казахстанских тенге, 
то значения посчитайте в разрезе каждой валюты (поле currency_code). 
Результат отсортируйте по убыванию значения в поле total_revenue.

SELECT
currency_code,
SUM(revenue) AS total_revenue,
COUNT(order_id) AS total_orders,
AVG(revenue) AS avg_revenue_per_order,
COUNT(DISTINCT user_id) AS total_users
FROM afisha.purchases
GROUP BY currency_code
ORDER BY total_revenue DESC;

	total_revenue	total_orders	avg_revenue_per_order	total_users
rub	157130432		286961			547.570922412914		21422
kzt	25340978		5073			4995.309819793927		1362

Заказов билетов в казахстанских тенге намного меньше, 
чем в российских рублях — чуть меньше 2%. 
Однако при дальнейшем анализе их всё равно следует учитывать.

-----------------------------------

2 Изучение распределения выручки в разрезе устройств

Для заказов в рублях вычислите 
- распределение выручки 
- распределение количества заказов 

по типу устройства device_type_canonical. 

Результат должен включать поля:
- тип устройства device_type_canonical;
- общая выручка с заказов total_revenue;
- количество заказов total_orders;
- средняя стоимость заказа avg_revenue_per_order;
- доля выручки для каждого устройства от общего значения revenue_share, округлённая до трёх знаков после точки.

Результат отсортируйте по убыванию значения в поле revenue_share.

/*synchronize_seqscans — параметр конфигурации PostgreSQL, 
 * который включает синхронизацию обращений при последовательном 
 * сканировании больших таблиц. Это позволяет параллельным сканированиям 
 * читать один блок примерно в одно и то же время, что разделяет нагрузку ввода-вывода (I/O)*/

-- Настройка параметра synchronize_seqscans важна для проверки

WITH set_config_precode AS (
  SELECT set_config('synchronize_seqscans', 'off', true)
)
SELECT
device_type_canonical,
SUM(revenue) AS total_revenue,
COUNT(order_id) AS total_orders,
AVG(revenue) AS avg_revenue_per_order,
ROUND((SUM(revenue)/(SELECT SUM(revenue) FROM afisha.purchases WHERE currency_code = 'rub'))::numeric, 3) AS revenue_share
FROM afisha.purchases
WHERE currency_code = 'rub'
GROUP BY device_type_canonical
ORDER BY revenue_share DESC;

device_type_canonical	total_revenue	total_orders	avg_revenue_per_order	revenue_share
mobile					1.24634e+08		229021			544.198					0.793
desktop					3.18516e+07		56759			561.169					0.203
tablet					640989			1176			545.058					0.004
other					5133.76			2				2566.88					0
tv						1299.16			3				433.053					0

По результатам видно, что основная часть выручки приходится на мобильные устройства и стационарные компьютеры. 
Доля остальных устройств в структуре выручки минимальна и составляет меньше процента.

-------------------------------------

3 Изучение распределения выручки в разрезе типа мероприятий

Для заказов в рублях вычислите 
- распределение количества заказов 
- их выручку 

в зависимости от типа мероприятия event_type_main. 

Результат должен включать поля:
- тип мероприятия event_type_main;
- общая выручка с заказов total_revenue;
- количество заказов total_orders;
- средняя стоимость заказа avg_revenue_per_order;
- уникальное число событий total_event_name (по их коду event_name_code);
- среднее число билетов в заказе avg_tickets;
- средняя выручка с одного билета avg_ticket_revenue;
- доля выручки от общего значения revenue_share, округлённая до трёх знаков после точки.

Результат отсортируйте по убыванию значения в поле total_orders.

SELECT
e.event_type_main,
SUM(a.revenue) AS total_revenue,
COUNT(a.order_id) AS total_orders,
AVG(a.revenue) AS avg_revenue_per_order,
COUNT(DISTINCT e.event_name_code) AS total_event_name,
AVG(a.tickets_count) AS avg_tickets,
SUM(a.revenue)/SUM(tickets_count) AS avg_ticket_revenue,
ROUND((SUM(revenue)/(SELECT SUM(revenue) FROM afisha.purchases WHERE currency_code = 'rub'))::numeric, 3) AS revenue_share
FROM afisha.purchases AS a
JOIN afisha.events AS e ON a.event_id=e.event_id
WHERE currency_code = 'rub'
GROUP BY e.event_type_main
ORDER BY total_orders DESC;

event_type_main	total_revenue	total_orders	avg_revenue_per_order	total_event_name	avg_tickets	avg_ticket_revenue	revenue_share
концерты		8.87054e+07		112418			789.085					6014				2.65704		296.973				0.565
театр			3.71417e+07		67733			548.357					4352				2.76007		198.674				0.236
другое			1.55796e+07		64572			241.282					3807				2.76484		87.2658				0.099
спорт			3.46673e+06		21700			159.754					785					3.05341		52.3208				0.022
стендап			9.54725e+06		13421			711.364					420					2.99195		237.76				0.061
выставки		1.13589e+06		4873			233.1					279					2.55818		91.1187				0.007
ёлки			1.54936e+06		2006			772.36					173					3.34247		231.075				0.01
фильм			3084.81			238				12.9614					19					2.65546		4.88103				0

Среди наиболее популярных событий — концерты, театральные постановки и загадочное «другое».

----------------------------------

4 Динамика изменения значений

На дашборде понадобится показать динамику изменения ключевых метрик и параметров. 
Для заказов в рублях вычислите изменение 
- выручки, 
- количества заказов, 
- уникальных клиентов 
- средней стоимости одного заказа 

в недельной динамике. 

Результат должен включать поля:
- неделя week;
- суммарная выручка total_revenue;
- число заказов total_orders;
- уникальное число клиентов total_users;
- средняя стоимость одного заказа revenue_per_order.

Результат отсортируйте по возрастанию значения в поле week.

SELECT
DATE_TRUNC('week', a.created_dt_msk)::date AS week,
SUM(a.revenue) AS total_revenue,
COUNT(a.order_id) AS total_orders,
COUNT(DISTINCT a.user_id) AS total_users,
SUM(a.revenue)/COUNT(a.order_id) AS revenue_per_order
FROM afisha.purchases AS a
WHERE currency_code = 'rub'
GROUP BY week
ORDER BY week;

week		total_revenue	total_orders	total_users	revenue_per_order
2024-05-27	911626			2024			805			450.408
2024-06-03	3.9895e+06		7589			2238		525.695
2024-06-10	4.16055e+06		7431			2153		559.891
2024-06-17	4.61219e+06		8043			2143		573.441
2024-06-24	4.2437e+06		7362			2032		576.433
2024-07-01	5.15982e+06		8995			2296		573.632
2024-07-08	5.511e+06		8980			2310		613.697
2024-07-15	5.58084e+06		8836			2406		631.602
2024-07-22	5.4571e+06		9347			2421		583.835
2024-07-29	5.84635e+06		10536			2492		554.893
2024-08-05	6.23562e+06		9642			2546		646.714
2024-08-12	6.08158e+06		9719			2596		625.742
2024-08-19	5.82303e+06		10488			2654		555.209
2024-08-26	5.7016e+06		10157			2527		561.346
2024-09-02	6.9264e+06		15642			3075		442.808
2024-09-09	8.34924e+06		15706			3431		531.596
2024-09-16	9.0447e+06		16599			3509		544.894
2024-09-23	9.86548e+06		17554			3768		562.007
2024-09-30	1.14409e+07		23031			4071		496.759
2024-10-07	1.09782e+07		19420			4118		565.306
2024-10-14	1.2097e+07		22438			4420		539.128
2024-10-21	1.2207e+07		22810			4475		535.162
2024-10-28	6.90785e+06		14612			3019		472.752

Виден рост количества заказов и пользователей к концу временного периода.

---------------------------------------

5 Выделение топ-сегментов

Выведите топ-7 регионов по значению общей выручки, включив только заказы за рубли. 

Результат должен включать поля:
- название региона region_name;
- суммарная выручка total_revenue;
- число заказов total_orders;
- уникальное число клиентов total_users;
- количество проданных билетов total_tickets;
- средняя выручка одного билета one_ticket_cost

только заказы за рубли, топ-7.

Результат отсортируйте по убыванию значения в поле total_revenue.

SELECT
r.region_name AS region_name,
SUM(a.revenue) AS total_revenue,
COUNT(a.order_id) AS total_orders,
COUNT(DISTINCT a.user_id) AS total_users,
SUM(a.tickets_count) AS total_tickets,
SUM(a.revenue)/SUM(a.tickets_count) AS one_ticket_cost
FROM afisha.purchases AS a
JOIN afisha.events AS e ON a.event_id=e.event_id
JOIN afisha.city AS c ON e.city_id=c.city_id
JOIN afisha.regions AS r ON c.region_id=r.region_id
WHERE currency_code = 'rub'
GROUP BY r.region_name
ORDER BY total_revenue DESC
LIMIT 7;

region_name					total_revenue	total_orders	total_users	total_tickets	one_ticket_cost
Каменевский регион			6.15552e+07		91634			10646		253393			242.924
Североярская область		2.54534e+07		44282			6735		125204			203.295
Озернинский край			9.79366e+06		10502			2488		29621			330.632
Широковская область			9.54378e+06		16538			3278		46977			203.159
Малиновоярский округ		5.95593e+06		6634			1902		17465			341.021
Яблоневская область			3.6924e+06		6197			1431		16589			222.581
Светополянский округ		3.42587e+06		7632			1683		20434			167.655
