--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users (id, role, email, passhash, salt, name, sname, address, payment) VALUES (2, 'user', 'asd@asd', 'asd', 'my salt', '', '', '', '');
INSERT INTO users (id, role, email, passhash, salt, name, sname, address, payment) VALUES (1, 'admin', 'denis@denis', 'Пароль', 'my salt', 'Денис', 'Давидюк', '690016, край. Приморский, г. Владивосток, ул. Героев Хасана, д. 11', 'Предпочитаемый оплаты');


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (1, 1, '7209:1:550;10928:3:550;5849:1:2490', 1, 'Привееет', '2015-01-05 20:30:32.207+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (3, 1, '7713:1:1390;7728:1:1590;7725:2:1990;7723:2:2250', 1, '<i>Не продадим <b>вам</b> это</i>', '2015-06-05 23:46:47.503+10', 'Адрес доставкиsdfasdgf', 'Предпочитаемый оплатыdfgsdfgsdf', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (4, 1, '7714:1:210;7715:2:470;7719:3:590;7716:4:610;7717:5:670;7721:6:730;7726:7:810;7724:8:1190;7713:9:1390;7728:10:1590;7725:11:1990;7723:12:2250;13081:13:1850;13082:14:2150;13075:15:2450', 1, '', '2015-06-05 23:55:39.292+10', 'Аддреееее', 'Мой спомоб', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (5, 1, '7719:0:590;7716:0:610;7717:0:670', 1, '', '2015-06-06 01:12:56.83+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (6, 1, '7716:0:610;7717:0:670;7721:0:730', 1, '', '2015-06-06 01:21:50.171+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (7, 1, '7721:0:730;7726:1:810', 1, '', '2015-06-06 01:29:13.041+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (8, 1, '13081:4:1850', 1, '', '2015-06-06 01:29:30.031+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (9, 1, '7714:1:210;7715:0:470', 1, '', '2015-06-06 01:33:33.186+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (11, 1, '7715:1:470', 1, '', '2015-06-06 01:42:02.987+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (10, 1, '7719:1:590;7716:0:610', 1, '', '2015-06-06 01:34:27.046+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (12, 1, '7719:1:590;7717:2:670', 1, '', '2015-06-06 01:44:09.607+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (13, NULL, '7716:1:610;7717:1:670;7721:1:730', 1, '', '2015-06-06 23:15:03.119+10', 'qwe', 'qweqwe', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (14, 1, '7715:1:470;7719:1:590;7716:1:610', 1, '', '2015-06-14 16:05:15.993+10', '', '', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (15, 1, '7716:1:610;7717:1:670;7726:1:810', 1, '', '2015-06-14 16:07:04.503+10', '', '', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (19, 1, '7721:1:730;7726:5:810;7724:0:1190', 1, '', '2015-06-14 16:13:02.946+10', 'qwe', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (17, 1, '9940:0:330;9941:5:450;9951:1:550', 1, '', '2015-06-14 16:10:49.456+10', 'asd', '', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (21, 1, '7721:1:730', 1, '', '2015-06-14 16:59:19.165+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (22, 1, '7716:4:610;7721:3:730', 1, '', '2015-06-14 16:59:48.294+10', 'qwe', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (23, NULL, '7717:1:670;7721:4:730;7726:1:810', 1, '', '2015-06-17 23:35:21.567+10', 'Адрес', 'Способ', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (24, 1, '10008:1:650', 1, '', '2015-06-17 23:37:31.217+10', '690016, край. Приморский, г. Владивосток, ул. Героев Хасана, д. 11', 'Предпочитаемый оплаты', false);
INSERT INTO orders (id, user_id, items, status_id, comment, createtime, address, payment, hidden) VALUES (2, 1, '10005:4:650', 2, 'на Луговой', '2015-06-05 21:26:19.012+10', 'Адрес доставки', 'Предпочитаемый оплаты', false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('orders_id_seq', 24, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

