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
16	get to know you, occupation	I'm a software engineer.	!IClause\r\nprompt: I'm a software engineer.\r\nv: soy\r\ndObj: ingeniero de software	2018-06-23 09:04:59.410926-06	2018-06-23 17:03:52.393-06
17	get to know you, occupation	I work part-time for a client in Germany.	!IClause\r\nprompt: I work.\r\nv: trabajo	2018-06-23 09:05:11.545771-06	2018-06-23 17:04:07.921-06
19	language learning	I speak Spanish.	!IClause\r\nprompt: I speak Spanish.\r\nv: hablo\r\ndObj: español	2018-06-23 11:50:32.308946-06	2018-06-23 17:04:16.298-06
23	language learning	Did you speak Spanish?	!IClause\r\nprompt: Did you speak Spanish?\r\nv: hablaste\r\ndObj: español\r\n_isQuestion: true	2018-06-23 13:13:07.340568-06	2018-06-23 17:04:23.805-06
21	language learning	I speak English.	!IClause\r\nprompt: I speak English.\r\nv: hablo\r\ndObj: inglés	2018-06-23 11:51:16.31606-06	2018-06-23 17:04:33.783-06
12	greetings	How are you?	!NClause\r\nprompt: How are you?\r\nheadEs: cómo\r\nheadEn: how\r\niClause: !IClause\r\n  prompt: you are (how)\r\n  v: estás	2018-06-23 09:01:10.381372-06	2018-06-23 17:13:45.731-06
14	get to know you, occupation	What do you do?	!NClause\r\nprompt: "What do you do?"\r\nheadEn: what\r\nheadEs: qué\r\niClause: !IClause\r\n  prompt: "you do"\r\n  v: haces	2018-06-23 09:04:11.131862-06	2018-06-23 17:38:33.356-06
15	get to know you, occupation	What have you been working on?		2018-06-23 09:04:30.829722-06	2018-06-23 10:46:28.858-06
22	language learning	Does he speak English?	!IClause\r\nprompt: Does he speak English?\r\nagent: él\r\nv: habla\r\ndObj: inglés\r\n_isQuestion: true	2018-06-23 12:48:48.844155-06	2018-06-23 17:03:01.429-06
20	language learning	Do you speak English?	!IClause\r\nprompt: Do you speak English?\r\nv: hablas\r\ndObj: inglés\r\n_isQuestion: true	2018-06-23 11:51:01.738222-06	2018-06-23 17:03:21.063-06
13	greetings	I'm doing well.	!IClause\r\nprompt: I'm doing well.\r\nv: estoy\r\nadvComp: bien	2018-06-23 09:01:25.618678-06	2018-06-23 17:03:30.08-06
18	language learning	Do you speak Spanish?	!IClause\r\nprompt: Do you speak Spanish?\r\nv: hablas\r\ndObj: español\r\n_isQuestion: true	2018-06-23 11:48:16.493354-06	2018-06-23 17:03:37.932-06
9	greetings	Hello!	!NP\r\nes: "hola"	2018-06-23 09:00:55.660665-06	2018-06-23 11:40:02.385-06
10	greetings	Good morning!	!NP\r\nes: buenas días	2018-06-23 09:01:01.56348-06	2018-06-23 11:41:33.217-06
11	greetings	Good afternoon!	!NP\r\nes: buenas tardes	2018-06-23 09:01:05.641051-06	2018-06-23 11:41:42.338-06
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

