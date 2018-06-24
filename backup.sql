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

DROP INDEX public.schema_version_s_idx;
DROP INDEX public.idx_entries_es;
DROP INDEX public.idx_entries_en_plural_and_en_disambiguation;
DROP INDEX public.idx_entries_en_and_en_disambiguation;
ALTER TABLE ONLY public.schema_version DROP CONSTRAINT schema_version_pk;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.entries DROP CONSTRAINT entries_pkey;
ALTER TABLE public.goals ALTER COLUMN goal_id DROP DEFAULT;
ALTER TABLE public.entries ALTER COLUMN entry_id DROP DEFAULT;
DROP TABLE public.schema_version;
DROP SEQUENCE public.goals_goal_id_seq;
DROP TABLE public.goals;
DROP SEQUENCE public.entries_entry_id_seq;
DROP TABLE public.entries;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entries (
    entry_id integer NOT NULL,
    es text NOT NULL,
    en text NOT NULL,
    en_disambiguation text NOT NULL,
    en_plural text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE entries OWNER TO postgres;

--
-- Name: entries_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE entries_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE entries_entry_id_seq OWNER TO postgres;

--
-- Name: entries_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE entries_entry_id_seq OWNED BY entries.entry_id;


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
-- Name: schema_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE schema_version OWNER TO postgres;

--
-- Name: entries entry_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entries ALTER COLUMN entry_id SET DEFAULT nextval('entries_entry_id_seq'::regclass);


--
-- Name: goals goal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals ALTER COLUMN goal_id SET DEFAULT nextval('goals_goal_id_seq'::regclass);


--
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY entries (entry_id, es, en, en_disambiguation, en_plural, created_at) FROM stdin;
62	brazo	arm		arms	2018-06-24 09:42:32.310062-06
63	pierna	leg		legs	2018-06-24 09:42:32.31134-06
64	corazón	heart		hearts	2018-06-24 09:42:32.311925-06
65	estómago	stomach		stomachs	2018-06-24 09:42:32.312547-06
66	ojo	eye		eyes	2018-06-24 09:42:32.313039-06
67	nariz	nose		noses	2018-06-24 09:42:32.313538-06
68	boca	mouth		mouths	2018-06-24 09:42:32.31404-06
69	oreja	ear		ears	2018-06-24 09:42:32.314516-06
70	cara	face		faces	2018-06-24 09:42:32.314983-06
71	cuello	neck		necks	2018-06-24 09:42:32.315436-06
72	dedo	finger		fingers	2018-06-24 09:42:32.315907-06
73	pie	foot		feet	2018-06-24 09:42:32.316363-06
74	muslo	thigh		thighs	2018-06-24 09:42:32.316797-06
75	tobillo	ankle		ankles	2018-06-24 09:42:32.317247-06
76	codo	elbow		elbows	2018-06-24 09:42:32.317698-06
77	muñeca	wrist		wrists	2018-06-24 09:42:32.318139-06
78	cuerpo	body		bodies	2018-06-24 09:42:32.318608-06
79	diente	tooth		tooths	2018-06-24 09:42:32.319075-06
80	mano	hand		hands	2018-06-24 09:42:32.319518-06
81	espalda	back		backs	2018-06-24 09:42:32.31995-06
82	cadera	hip		hips	2018-06-24 09:42:32.320412-06
83	mandíbula	jaw		jaws	2018-06-24 09:42:32.320864-06
84	hombro	shoulder		shoulders	2018-06-24 09:42:32.321315-06
85	pulgar	thumb		thumbs	2018-06-24 09:42:32.321761-06
86	lengua	tongue		tongues	2018-06-24 09:42:32.322202-06
87	garganta	throat		throats	2018-06-24 09:42:32.322985-06
88	español	Spanish		\N	2018-06-24 09:42:32.323407-06
89	inglés	English		\N	2018-06-24 09:42:32.323906-06
90	día	day		days	2018-06-24 09:42:32.324572-06
91	tarde	afternoon		afternoon	2018-06-24 09:42:32.325038-06
92	ingeniero	engineer		engineers	2018-06-24 09:42:32.325593-06
93	lista	list		lists	2018-06-24 09:42:32.326072-06
94	oración	sentence		sentences	2018-06-24 09:42:32.326465-06
95	bueno	good	masc.	good	2018-06-24 09:42:32.326926-06
96	buena	good	fem.	good	2018-06-24 09:42:32.327412-06
97	el	the	masc.	\N	2018-06-24 09:42:32.327897-06
98	la	the	fem.	\N	2018-06-24 09:42:32.32839-06
99	un	a	masc.	\N	2018-06-24 09:42:32.328869-06
100	una	a	fem.	\N	2018-06-24 09:42:32.329419-06
101	mi	my		\N	2018-06-24 09:42:32.329823-06
102	este	this	masc.	\N	2018-06-24 09:42:32.330276-06
103	esta	this	fem.	\N	2018-06-24 09:42:32.33074-06
104	cada	every		\N	2018-06-24 09:42:32.331212-06
105	cómo	how		\N	2018-06-24 09:42:32.331646-06
106	bien	well		\N	2018-06-24 09:42:32.332094-06
107	yo	I		\N	2018-06-24 09:42:32.332558-06
108	tú	you	pronoun	\N	2018-06-24 09:42:32.33304-06
109	él	he		\N	2018-06-24 09:42:32.33464-06
110	ella	she		\N	2018-06-24 09:42:32.335082-06
111	nosotros	we	masc.	\N	2018-06-24 09:42:32.335483-06
112	nosotras	we	fem.	\N	2018-06-24 09:42:32.335885-06
113	ellos	they	masc.	\N	2018-06-24 09:42:32.33628-06
114	ellas	they	fem.	\N	2018-06-24 09:42:32.336675-06
115	qué	what		\N	2018-06-24 09:42:32.337066-06
116	hola	hello		\N	2018-06-24 09:42:32.337468-06
117	de	of		\N	2018-06-24 09:42:32.337867-06
118	dónde	where	question	\N	2018-06-24 09:42:32.338256-06
119	donde	where	relative	\N	2018-06-24 09:42:32.338645-06
120	software	software		\N	2018-06-24 09:42:32.339084-06
121	con	with		\N	2018-06-24 09:42:32.339496-06
122	quién	who		\N	2018-06-24 09:42:32.339963-06
123	me	me		\N	2018-06-24 09:42:32.340438-06
124	te	you	direct/indirect object	\N	2018-06-24 09:42:32.340855-06
\.


--
-- Name: entries_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('entries_entry_id_seq', 124, true);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags, en_free_text, es, created_at, updated_at) FROM stdin;
33	language learning	Who do you want to speak Spanish with?	Con quién quieres hablar español	2018-06-23 20:41:23.295495-06	2018-06-23 20:41:23.294-06
11	greetings	Good afternoon!	buenas tardes	2018-06-23 09:01:05.641051-06	2018-06-23 21:31:32.711-06
16	get to know you, occupation	I'm a software engineer.	soy ingeniero de software	2018-06-23 09:04:59.410926-06	2018-06-23 21:32:47.192-06
24	location	Where do you live?	dónde vives	2018-06-23 20:26:55.205221-06	2018-06-23 21:36:42.851-06
29	language learning	I took a class in Spanish	Asistí una clase de español	2018-06-23 20:33:14.420905-06	2018-06-23 21:40:00.6-06
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
25	location	I live in Longmont	vivo en Longmont	2018-06-23 20:27:13.219577-06	2018-06-23 20:27:13.218-06
26	location	I moved to Longmont in January.	me mudé a Longmont en enero	2018-06-23 20:29:45.689523-06	2018-06-23 20:29:45.677-06
27	language learning	Where did you learn Spanish?	Dónde aprendiste español	2018-06-23 20:31:15.448914-06	2018-06-23 20:31:25.802-06
28	travel	I visited Cuba for a few weeks	Visité Cuba por unas semanas	2018-06-23 20:32:22.284674-06	2018-06-23 20:32:22.283-06
30	language learning	How did you learn Spanish?	Cómo aprendiste español	2018-06-23 20:34:34.78697-06	2018-06-23 20:34:34.785-06
32	language learning	I created a mobile app to study Spanish	creé una aplicación móvil para estudiar español	2018-06-23 20:38:21.147851-06	2018-06-23 20:38:21.146-06
31	language learning	I made a list of sentences to learn.	hice una lista de oraciones para aprender	2018-06-23 20:37:17.918029-06	2018-06-24 09:43:20.409-06
10	greetings	Good morning!	buenos días	2018-06-23 09:01:01.56348-06	2018-06-24 09:45:30.549-06
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 33, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create goals	SQL	V1__create_goals.sql	-337851082	postgres	2018-06-23 07:47:24.603432	45	t
2	2	create entries	SQL	V2__create_entries.sql	1207714738	postgres	2018-06-24 09:38:11.893217	22	t
\.


--
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (entry_id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (goal_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: idx_entries_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_entries_en_and_en_disambiguation ON entries USING btree (en, en_disambiguation);


--
-- Name: idx_entries_en_plural_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_entries_en_plural_and_en_disambiguation ON entries USING btree (en_plural, en_disambiguation);


--
-- Name: idx_entries_es; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_entries_es ON entries USING btree (es);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX schema_version_s_idx ON schema_version USING btree (success);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

