--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: goals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE goals (
    goal_id integer NOT NULL,
    tags text NOT NULL,
    en_free_text text NOT NULL,
    es_yaml text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE goals OWNER TO postgres;

--
-- Name: goals_goal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE goals_goal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE goals_goal_id_seq OWNER TO postgres;

--
-- Name: goals_goal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE goals_goal_id_seq OWNED BY goals.goal_id;


--
-- Name: goals goal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals ALTER COLUMN goal_id SET DEFAULT nextval('goals_goal_id_seq'::regclass);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags, en_free_text, es_yaml, created_at, updated_at) FROM stdin;
9	greetings	Hello!		2018-06-23 09:00:55.660665-06	2018-06-23 09:05:27.903-06
10	greetings	Good morning!		2018-06-23 09:01:01.56348-06	2018-06-23 09:05:32.664-06
11	greetings	Good afternoon!		2018-06-23 09:01:05.641051-06	2018-06-23 09:05:37.723-06
12	greetings	How are you?	!IClause\r\nagent: tú\r\nv: estás	2018-06-23 09:01:10.381372-06	2018-06-23 09:07:21.215-06
17	get to know you, occupation	I work part-time for a client in Germany.	!IClause\r\nagent: yo\r\nv: trabajo	2018-06-23 09:05:11.545771-06	2018-06-23 09:07:44.236-06
15	get to know you, occupation	What have you been working on?	!IClause\r\nagent: tú\r\nv: trabajas	2018-06-23 09:04:30.829722-06	2018-06-23 09:08:21.242-06
14	get to know you, occupation	What do you do?	!IClause\r\nagent: tú\r\nv: haces	2018-06-23 09:04:11.131862-06	2018-06-23 09:08:35.257-06
13	greetings	I'm doing well.	!IClause\r\nagent: yo\r\nv: estoy	2018-06-23 09:01:25.618678-06	2018-06-23 09:12:00.823-06
16	get to know you, occupation	I'm a software developer.	!IClause\r\nagent: yo\r\nv: soy	2018-06-23 09:04:59.410926-06	2018-06-23 09:12:08.085-06
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 17, true);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (goal_id);


--
-- PostgreSQL database dump complete
--

