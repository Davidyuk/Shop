--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.1
-- Dumped by pg_dump version 9.4.1
-- Started on 2015-06-05 20:07:32

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP DATABASE shop;
--
-- TOC entry 2078 (class 1262 OID 50621)
-- Name: shop; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE shop WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';


ALTER DATABASE shop OWNER TO postgres;

\connect shop

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2079 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 188 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2081 (class 0 OID 0)
-- Dependencies: 188
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 540 (class 1247 OID 50623)
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE role AS ENUM (
    'admin',
    'manager',
    'user'
);


ALTER TYPE role OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 172 (class 1259 OID 50629)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name text,
    location text
);


ALTER TABLE categories OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 50635)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categories_id_seq OWNER TO postgres;

--
-- TOC entry 2082 (class 0 OID 0)
-- Dependencies: 173
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- TOC entry 174 (class 1259 OID 50637)
-- Name: categories_joined; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE categories_joined (
    id integer,
    name text,
    location text,
    count bigint
);

ALTER TABLE ONLY categories_joined REPLICA IDENTITY NOTHING;


ALTER TABLE categories_joined OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 50643)
-- Name: items; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE items (
    id integer NOT NULL,
    name text,
    price integer,
    category_id integer
);


ALTER TABLE items OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 50649)
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE items_id_seq OWNER TO postgres;

--
-- TOC entry 2083 (class 0 OID 0)
-- Dependencies: 176
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- TOC entry 177 (class 1259 OID 50651)
-- Name: items_joined; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE items_joined (
    id integer,
    name text,
    price integer,
    category_id integer,
    category_name text,
    category_location text,
    stores_id text,
    stores_name text
);

ALTER TABLE ONLY items_joined REPLICA IDENTITY NOTHING;


ALTER TABLE items_joined OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 50657)
-- Name: items_stores; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE items_stores (
    item_id integer NOT NULL,
    store_id integer NOT NULL,
    count integer
);


ALTER TABLE items_stores OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 50660)
-- Name: managers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE managers (
    user_id integer NOT NULL,
    store_id integer NOT NULL
);


ALTER TABLE managers OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 50663)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    user_id integer,
    items text,
    status_id integer,
    comment text,
    createtime timestamp with time zone,
    address text,
    payment text
);


ALTER TABLE orders OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 50669)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_id_seq OWNER TO postgres;

--
-- TOC entry 2084 (class 0 OID 0)
-- Dependencies: 181
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- TOC entry 182 (class 1259 OID 50671)
-- Name: statuses; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE statuses (
    id integer NOT NULL,
    name text
);


ALTER TABLE statuses OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 50677)
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE statuses_id_seq OWNER TO postgres;

--
-- TOC entry 2085 (class 0 OID 0)
-- Dependencies: 183
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE statuses_id_seq OWNED BY statuses.id;


--
-- TOC entry 184 (class 1259 OID 50679)
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stores (
    id integer NOT NULL,
    name text
);


ALTER TABLE stores OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 50685)
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stores_id_seq OWNER TO postgres;

--
-- TOC entry 2086 (class 0 OID 0)
-- Dependencies: 185
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stores_id_seq OWNED BY stores.id;


--
-- TOC entry 186 (class 1259 OID 50687)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    role role,
    email text,
    passhash text,
    salt text,
    name text,
    sname text,
    address text,
    payment text
);


ALTER TABLE users OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 50693)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- TOC entry 2087 (class 0 OID 0)
-- Dependencies: 187
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 1936 (class 2604 OID 50695)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- TOC entry 1937 (class 2604 OID 50696)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- TOC entry 1938 (class 2604 OID 50697)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- TOC entry 1939 (class 2604 OID 50698)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY statuses ALTER COLUMN id SET DEFAULT nextval('statuses_id_seq'::regclass);


--
-- TOC entry 1940 (class 2604 OID 50699)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stores ALTER COLUMN id SET DEFAULT nextval('stores_id_seq'::regclass);


--
-- TOC entry 1941 (class 2604 OID 50700)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 1943 (class 2606 OID 50702)
-- Name: categories_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_id PRIMARY KEY (id);


--
-- TOC entry 1945 (class 2606 OID 50704)
-- Name: item_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT item_id PRIMARY KEY (id);


--
-- TOC entry 1949 (class 2606 OID 50706)
-- Name: manager_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY managers
    ADD CONSTRAINT manager_id PRIMARY KEY (user_id, store_id);


--
-- TOC entry 1951 (class 2606 OID 50708)
-- Name: order_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT order_id PRIMARY KEY (id);


--
-- TOC entry 1953 (class 2606 OID 50710)
-- Name: status_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY statuses
    ADD CONSTRAINT status_id PRIMARY KEY (id);


--
-- TOC entry 1947 (class 2606 OID 50712)
-- Name: stock_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY items_stores
    ADD CONSTRAINT stock_id PRIMARY KEY (item_id, store_id);


--
-- TOC entry 1955 (class 2606 OID 50714)
-- Name: store_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT store_id PRIMARY KEY (id);


--
-- TOC entry 1957 (class 2606 OID 50716)
-- Name: user_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT user_id PRIMARY KEY (id);


--
-- TOC entry 2072 (class 2618 OID 50717)
-- Name: _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE "_RETURN" AS
    ON SELECT TO items_joined DO INSTEAD  SELECT items.id,
    items.name,
    items.price,
    items.category_id,
    categories.name AS category_name,
    categories.location AS category_location,
    string_agg((stores.id)::text, '|'::text) AS stores_id,
    string_agg(stores.name, '|'::text) AS stores_name
   FROM (((items
     JOIN categories ON ((items.category_id = categories.id)))
     JOIN items_stores ON ((items.id = items_stores.item_id)))
     JOIN stores ON ((items_stores.store_id = stores.id)))
  GROUP BY items.id, categories.id
  ORDER BY categories.name, items.price;


--
-- TOC entry 2073 (class 2618 OID 50719)
-- Name: _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE "_RETURN" AS
    ON SELECT TO categories_joined DO INSTEAD  SELECT temp.id,
    temp.name,
    temp.location,
    count(temp.flag) AS count
   FROM ( SELECT categories.id,
            categories.name,
            categories.location,
            bool_or((items_stores.store_id > 0)) AS flag
           FROM ((categories
             LEFT JOIN items ON ((categories.id = items.category_id)))
             LEFT JOIN items_stores ON ((items.id = items_stores.item_id)))
          GROUP BY categories.id, items_stores.item_id) temp
  GROUP BY temp.id, temp.name, temp.location;


--
-- TOC entry 1958 (class 2606 OID 50720)
-- Name: category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY items
    ADD CONSTRAINT category_id FOREIGN KEY (category_id) REFERENCES categories(id);


--
-- TOC entry 1959 (class 2606 OID 50725)
-- Name: item_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY items_stores
    ADD CONSTRAINT item_id FOREIGN KEY (item_id) REFERENCES items(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1961 (class 2606 OID 50730)
-- Name: status_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT status_id FOREIGN KEY (status_id) REFERENCES statuses(id);


--
-- TOC entry 1960 (class 2606 OID 50735)
-- Name: store_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY items_stores
    ADD CONSTRAINT store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1962 (class 2606 OID 50740)
-- Name: user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2080 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-06-05 20:07:32

--
-- PostgreSQL database dump complete
--

