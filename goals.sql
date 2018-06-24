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
    es text NOT NULL,
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

COPY goals (goal_id, tags, en_free_text, es, created_at, updated_at) FROM stdin;
16	get to know you, occupation	I'm a software engineer.	soy ingeniero-de-software	2018-06-23 09:04:59.410926-06	2018-06-23 18:20:27.871-06
17	get to know you, occupation	I work part-time for a client in Germany.	trabajo	2018-06-23 09:05:11.545771-06	2018-06-23 18:25:23.358-06
19	language learning	I speak Spanish.	hablo español	2018-06-23 11:50:32.308946-06	2018-06-23 18:25:29.936-06
23	language learning	Did you speak Spanish?	hablaste español	2018-06-23 13:13:07.340568-06	2018-06-23 18:25:38.9-06
21	language learning	I speak English.	hablo inglés	2018-06-23 11:51:16.31606-06	2018-06-23 18:25:45.73-06
12	greetings	How are you?	como estás	2018-06-23 09:01:10.381372-06	2018-06-23 18:25:51.526-06
14	get to know you, occupation	What do you do?	qué haces	2018-06-23 09:04:11.131862-06	2018-06-23 18:25:57.398-06
22	language learning	Does he speak English?	habla él inglés	2018-06-23 12:48:48.844155-06	2018-06-23 18:26:09.253-06
20	language learning	Do you speak English?	hablas inglés	2018-06-23 11:51:01.738222-06	2018-06-23 18:26:15.736-06
13	greetings	I'm doing well.	estoy bien	2018-06-23 09:01:25.618678-06	2018-06-23 18:26:20.552-06
15	get to know you, occupation	What have you been working on?		2018-06-23 09:04:30.829722-06	2018-06-23 10:46:28.858-06
18	language learning	Do you speak Spanish?	hablas español	2018-06-23 11:48:16.493354-06	2018-06-23 18:27:02.5-06
9	greetings	Hello!	hola	2018-06-23 09:00:55.660665-06	2018-06-23 18:27:06.936-06
10	greetings	Good morning!	buenas-días	2018-06-23 09:01:01.56348-06	2018-06-23 18:27:13.328-06
11	greetings	Good afternoon!	buenas-tardes	2018-06-23 09:01:05.641051-06	2018-06-23 18:27:18.507-06
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 23, true);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (goal_id);


--
-- PostgreSQL database dump complete
--

