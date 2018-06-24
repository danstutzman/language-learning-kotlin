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

ALTER TABLE ONLY public.unique_conjugations DROP CONSTRAINT unique_conjugations_infinitive_es_fkey;
ALTER TABLE ONLY public.stem_changes DROP CONSTRAINT stem_changes_infinitive_es_fkey;
DROP INDEX public.schema_version_s_idx;
DROP INDEX public.idx_unique_conjugations_es;
DROP INDEX public.idx_stem_changes_stem;
DROP INDEX public.idx_infinitives_es;
DROP INDEX public.idx_infinitives_en_past_and_en_disambiguation;
DROP INDEX public.idx_infinitives_en_and_en_disambiguation;
DROP INDEX public.idx_entries_es;
DROP INDEX public.idx_entries_en_plural_and_en_disambiguation;
DROP INDEX public.idx_entries_en_and_en_disambiguation;
ALTER TABLE ONLY public.unique_conjugations DROP CONSTRAINT unique_conjugations_pkey;
ALTER TABLE ONLY public.stem_changes DROP CONSTRAINT stem_changes_pkey;
ALTER TABLE ONLY public.schema_version DROP CONSTRAINT schema_version_pk;
ALTER TABLE ONLY public.infinitives DROP CONSTRAINT infinitives_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.nonverbs DROP CONSTRAINT entries_pkey;
ALTER TABLE public.unique_conjugations ALTER COLUMN unique_conjugation_id DROP DEFAULT;
ALTER TABLE public.stem_changes ALTER COLUMN stem_change_id DROP DEFAULT;
ALTER TABLE public.nonverbs ALTER COLUMN nonverb_id DROP DEFAULT;
ALTER TABLE public.infinitives ALTER COLUMN infinitive_id DROP DEFAULT;
ALTER TABLE public.goals ALTER COLUMN goal_id DROP DEFAULT;
DROP SEQUENCE public.unique_conjugations_unique_conjugation_id_seq;
DROP TABLE public.unique_conjugations;
DROP SEQUENCE public.stem_changes_stem_change_id_seq;
DROP TABLE public.stem_changes;
DROP TABLE public.schema_version;
DROP SEQUENCE public.nonverbs_nonverb_id_seq;
DROP TABLE public.nonverbs;
DROP SEQUENCE public.infinitives_infinitive_id_seq;
DROP TABLE public.infinitives;
DROP SEQUENCE public.goals_goal_id_seq;
DROP TABLE public.goals;
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
-- Name: infinitives; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE infinitives (
    infinitive_id integer NOT NULL,
    es text NOT NULL,
    en text NOT NULL,
    en_past text NOT NULL,
    en_disambiguation text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE infinitives OWNER TO postgres;

--
-- Name: infinitives_infinitive_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE infinitives_infinitive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE infinitives_infinitive_id_seq OWNER TO postgres;

--
-- Name: infinitives_infinitive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE infinitives_infinitive_id_seq OWNED BY infinitives.infinitive_id;


--
-- Name: nonverbs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nonverbs (
    nonverb_id integer NOT NULL,
    es text NOT NULL,
    en text NOT NULL,
    en_disambiguation text NOT NULL,
    en_plural text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE nonverbs OWNER TO postgres;

--
-- Name: nonverbs_nonverb_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nonverbs_nonverb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nonverbs_nonverb_id_seq OWNER TO postgres;

--
-- Name: nonverbs_nonverb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nonverbs_nonverb_id_seq OWNED BY nonverbs.nonverb_id;


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
-- Name: stem_changes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stem_changes (
    stem_change_id integer NOT NULL,
    infinitive_es text NOT NULL,
    stem text NOT NULL,
    tense text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE stem_changes OWNER TO postgres;

--
-- Name: stem_changes_stem_change_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE stem_changes_stem_change_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stem_changes_stem_change_id_seq OWNER TO postgres;

--
-- Name: stem_changes_stem_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stem_changes_stem_change_id_seq OWNED BY stem_changes.stem_change_id;


--
-- Name: unique_conjugations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE unique_conjugations (
    unique_conjugation_id integer NOT NULL,
    es text NOT NULL,
    en text NOT NULL,
    infinitive_es text NOT NULL,
    number integer NOT NULL,
    person integer NOT NULL,
    tense text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE unique_conjugations OWNER TO postgres;

--
-- Name: unique_conjugations_unique_conjugation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unique_conjugations_unique_conjugation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unique_conjugations_unique_conjugation_id_seq OWNER TO postgres;

--
-- Name: unique_conjugations_unique_conjugation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE unique_conjugations_unique_conjugation_id_seq OWNED BY unique_conjugations.unique_conjugation_id;


--
-- Name: goals goal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals ALTER COLUMN goal_id SET DEFAULT nextval('goals_goal_id_seq'::regclass);


--
-- Name: infinitives infinitive_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY infinitives ALTER COLUMN infinitive_id SET DEFAULT nextval('infinitives_infinitive_id_seq'::regclass);


--
-- Name: nonverbs nonverb_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nonverbs ALTER COLUMN nonverb_id SET DEFAULT nextval('nonverbs_nonverb_id_seq'::regclass);


--
-- Name: stem_changes stem_change_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stem_changes ALTER COLUMN stem_change_id SET DEFAULT nextval('stem_changes_stem_change_id_seq'::regclass);


--
-- Name: unique_conjugations unique_conjugation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unique_conjugations ALTER COLUMN unique_conjugation_id SET DEFAULT nextval('unique_conjugations_unique_conjugation_id_seq'::regclass);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags, en_free_text, es, created_at, updated_at) FROM stdin;
11	greetings	Good afternoon!	buenas tardes	2018-06-23 09:01:05.641051-06	2018-06-23 21:31:32.711-06
16	get to know you, occupation	I'm a software engineer.	soy ingeniero de software	2018-06-23 09:04:59.410926-06	2018-06-23 21:32:47.192-06
24	location	Where do you live?	dónde vives	2018-06-23 20:26:55.205221-06	2018-06-23 21:36:42.851-06
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
32	language learning	I created a mobile app to study Spanish	creé una aplicación móvil para estudiar español	2018-06-23 20:38:21.147851-06	2018-06-23 20:38:21.146-06
31	language learning	I made a list of sentences to learn.	hice una lista de oraciones para aprender	2018-06-23 20:37:17.918029-06	2018-06-24 09:43:20.409-06
10	greetings	Good morning!	buenos días	2018-06-23 09:01:01.56348-06	2018-06-24 09:45:30.549-06
27	language learning	Where did you learn Spanish?	dónde aprendiste español	2018-06-23 20:31:15.448914-06	2018-06-24 10:13:46.881-06
28	travel	I visited Cuba for a few weeks	visité Cuba por unas semanas	2018-06-23 20:32:22.284674-06	2018-06-24 10:13:52.16-06
30	language learning	How did you learn Spanish?	cómo aprendiste español	2018-06-23 20:34:34.78697-06	2018-06-24 10:13:55.896-06
33	language learning	Who do you want to speak Spanish with?	con quién quieres hablar español	2018-06-23 20:41:23.295495-06	2018-06-24 10:14:35.013-06
29	language learning	I took a class in Spanish	asistí una clase de español	2018-06-23 20:33:14.420905-06	2018-06-24 10:15:14.949-06
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 33, true);


--
-- Data for Name: infinitives; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY infinitives (infinitive_id, es, en, en_past, en_disambiguation, created_at) FROM stdin;
31	andar	walk	walked		2018-06-24 09:57:33.983446-06
32	aprender	learn	learned		2018-06-24 09:57:33.984734-06
33	comer	eat	ate		2018-06-24 09:57:33.985347-06
34	conocer	know	knew	be able to	2018-06-24 09:57:33.986019-06
35	contar	tell	told		2018-06-24 09:57:33.98678-06
36	dar	give	gave		2018-06-24 09:57:33.987309-06
37	decir	say	said		2018-06-24 09:57:33.987899-06
38	empezar	start	started		2018-06-24 09:57:33.988574-06
39	encontrar	find	found		2018-06-24 09:57:33.994568-06
40	entender	understand	understood		2018-06-24 09:57:34.000548-06
41	enviar	send	sent		2018-06-24 09:57:34.006513-06
42	estar	be	was	be (how)	2018-06-24 09:57:34.012434-06
43	hablar	speak	spoke		2018-06-24 09:57:34.017548-06
44	hacer	do	did		2018-06-24 09:57:34.018056-06
45	ir	go	went		2018-06-24 09:57:34.018688-06
46	parecer	seem	seemed		2018-06-24 09:57:34.019227-06
47	pedir	request	requested		2018-06-24 09:57:34.019677-06
48	pensar	think	thought		2018-06-24 09:57:34.020182-06
49	poder	can	could		2018-06-24 09:57:34.020785-06
50	poner	put	put		2018-06-24 09:57:34.021223-06
51	preguntar	ask	asked		2018-06-24 09:57:34.021846-06
52	querer	want	wanted		2018-06-24 09:57:34.022716-06
53	recordar	remember	remembered		2018-06-24 09:57:34.023446-06
54	saber	know	knew	know (thing)	2018-06-24 09:57:34.024181-06
55	salir	go out	went out		2018-06-24 09:57:34.02479-06
56	seguir	follow	followed		2018-06-24 09:57:34.025256-06
57	sentir	feel	felt		2018-06-24 09:57:34.026079-06
58	ser	be	was	be (what)	2018-06-24 09:57:34.026682-06
59	tener	have	had		2018-06-24 09:57:34.027222-06
60	trabajar	work	worked		2018-06-24 09:57:34.027967-06
61	ver	see	saw		2018-06-24 09:57:34.028806-06
62	venir	come	came		2018-06-24 09:57:34.029696-06
63	visitar	visit	visited		2018-06-24 09:57:34.030334-06
64	volver	return	returned		2018-06-24 09:57:34.031357-06
65	vivir	live	lived		2018-06-24 10:12:18.679112-06
66	asistir	attend	attended		2018-06-24 10:15:03.427516-06
67	mudar	move	moved		2018-06-24 10:16:29.743042-06
68	crear	create	created		2018-06-24 10:17:19.293622-06
69	estudiar	study	studied		2018-06-24 10:21:48.839702-06
\.


--
-- Name: infinitives_infinitive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('infinitives_infinitive_id_seq', 69, true);


--
-- Data for Name: nonverbs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nonverbs (nonverb_id, es, en, en_disambiguation, en_plural, created_at) FROM stdin;
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
125	Longmont	Longmont		\N	2018-06-24 10:12:57.81832-06
126	Cuba	Cuba		\N	2018-06-24 10:14:14.159249-06
127	a	to		\N	2018-06-24 10:16:56.797247-06
128	por	for	on behalf of	\N	2018-06-24 10:18:21.748271-06
129	para	for	in order to	\N	2018-06-24 10:18:37.720114-06
130	clase	class		classes	2018-06-24 10:18:54.790579-06
131	enero	January		\N	2018-06-24 10:19:36.45117-06
132	aplicación	application		applications	2018-06-24 10:19:47.157449-06
133	unos	some	masc.	\N	2018-06-24 10:20:00.535063-06
134	unas	some	fem.	\N	2018-06-24 10:20:07.365061-06
135	móvil	mobile phone		mobile phones	2018-06-24 10:20:48.975803-06
136	semana	week		weeks	2018-06-24 10:21:05.140751-06
\.


--
-- Name: nonverbs_nonverb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nonverbs_nonverb_id_seq', 137, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create goals	SQL	V1__create_goals.sql	-337851082	postgres	2018-06-23 07:47:24.603432	45	t
3	3	create infinitives	SQL	V3__create_infinitives.sql	461677107	postgres	2018-06-24 09:55:40.838131	40	t
4	4	create unique conjugations	SQL	V4__create_unique_conjugations.sql	-1531439812	postgres	2018-06-24 10:52:47.393522	27	t
5	5	create stem changes	SQL	V5__create_stem_changes.sql	-498185464	postgres	2018-06-24 11:15:26.014979	46	t
2	2	create nonverbs	SQL	V2__create_nonverbs.sql	1917168459	postgres	2018-06-24 09:38:11.893217	22	t
\.


--
-- Data for Name: stem_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stem_changes (stem_change_id, infinitive_es, stem, tense, created_at) FROM stdin;
1	poder	pued-	PRES	2018-06-24 11:26:43.651439-06
2	tener	tien-	PRES	2018-06-24 11:26:43.803834-06
3	querer	quier-	PRES	2018-06-24 11:26:43.804733-06
4	seguir	sig-	PRES	2018-06-24 11:26:43.805456-06
5	encontrar	encuentr-	PRES	2018-06-24 11:26:43.806086-06
6	venir	vien-	PRES	2018-06-24 11:26:43.806698-06
7	pensar	piens-	PRES	2018-06-24 11:26:43.807283-06
8	volver	vuelv-	PRES	2018-06-24 11:26:43.807795-06
9	sentir	sient-	PRES	2018-06-24 11:26:43.808329-06
10	contar	cuent-	PRES	2018-06-24 11:26:43.808861-06
11	empezar	empiez-	PRES	2018-06-24 11:26:43.809358-06
12	decir	dic-	PRES	2018-06-24 11:26:43.809844-06
13	recordar	recuerd-	PRES	2018-06-24 11:26:43.810424-06
14	pedir	pid-	PRES	2018-06-24 11:26:43.81091-06
15	entender	entiend-	PRES	2018-06-24 11:26:43.811642-06
16	andar	anduv-	PRET	2018-06-24 11:26:43.812328-06
17	saber	sup-	PRET	2018-06-24 11:26:43.812976-06
18	querer	quis-	PRET	2018-06-24 11:26:43.81373-06
19	poner	pus-	PRET	2018-06-24 11:26:43.814224-06
20	venir	vin-	PRET	2018-06-24 11:26:43.814936-06
21	decir	dij-	PRET	2018-06-24 11:26:43.815792-06
22	tener	tuv-	PRET	2018-06-24 11:26:43.816356-06
23	hacer	hic-	PRET	2018-06-24 11:26:43.816942-06
24	poder	pud-	PRET	2018-06-24 11:26:43.817449-06
\.


--
-- Name: stem_changes_stem_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('stem_changes_stem_change_id_seq', 26, true);


--
-- Data for Name: unique_conjugations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unique_conjugations (unique_conjugation_id, es, en, infinitive_es, number, person, tense, created_at) FROM stdin;
50	soy	am	ser	1	1	PRES	2018-06-24 10:53:11.331513-06
51	eres	are	ser	1	2	PRES	2018-06-24 10:53:11.334102-06
52	es	is	ser	1	3	PRES	2018-06-24 10:53:11.334799-06
53	somos	are	ser	2	1	PRES	2018-06-24 10:53:11.335596-06
54	son	are	ser	2	3	PRES	2018-06-24 10:53:11.336235-06
55	fui	was	ser	1	1	PRET	2018-06-24 10:53:11.336833-06
56	fuiste	were	ser	1	2	PRET	2018-06-24 10:53:11.337566-06
57	fue	was	ser	1	3	PRET	2018-06-24 10:53:11.338114-06
58	fuimos	were	ser	2	1	PRET	2018-06-24 10:53:11.338658-06
59	fueron	were	ser	2	3	PRET	2018-06-24 10:53:11.339177-06
60	estoy	am	estar	1	1	PRES	2018-06-24 10:53:11.339723-06
61	estás	are	estar	1	2	PRES	2018-06-24 10:53:11.340233-06
62	está	is	estar	1	3	PRES	2018-06-24 10:53:11.340796-06
63	están	are	estar	2	3	PRES	2018-06-24 10:53:11.341339-06
64	tengo	have	tener	1	1	PRES	2018-06-24 10:53:11.341841-06
65	hago	do	hacer	1	1	PRES	2018-06-24 10:53:11.342385-06
66	digo	say	decir	1	1	PRES	2018-06-24 10:53:11.34283-06
67	dijeron	said	decir	2	3	PRET	2018-06-24 10:53:11.343357-06
68	voy	go	ir	1	1	PRES	2018-06-24 10:53:11.343851-06
69	vas	go	ir	1	2	PRES	2018-06-24 10:53:11.344385-06
70	va	goes	ir	1	3	PRES	2018-06-24 10:53:11.34485-06
71	vamos	go	ir	2	1	PRES	2018-06-24 10:53:11.345309-06
72	van	go	ir	2	3	PRES	2018-06-24 10:53:11.345931-06
73	veo	see	ver	1	1	PRES	2018-06-24 10:53:11.346443-06
74	vi	saw	ver	1	1	PRET	2018-06-24 10:53:11.346938-06
75	vio	saw	ver	1	3	PRET	2018-06-24 10:53:11.347455-06
76	vimos	saw	ver	2	1	PRET	2018-06-24 10:53:11.347861-06
77	doy	give	dar	1	1	PRES	2018-06-24 10:53:11.348332-06
78	di	gave	dar	1	1	PRET	2018-06-24 10:53:11.348782-06
79	diste	gave	dar	1	2	PRET	2018-06-24 10:53:11.349211-06
80	dio	gave	dar	1	3	PRET	2018-06-24 10:53:11.349614-06
81	dimos	gave	dar	2	1	PRET	2018-06-24 10:53:11.349999-06
82	dieron	gave	dar	2	3	PRET	2018-06-24 10:53:11.350387-06
83	sé	know	saber	1	1	PRES	2018-06-24 10:53:11.350775-06
84	pongo	put	poner	1	1	PRES	2018-06-24 10:53:11.351199-06
85	vengo	come	venir	1	1	PRES	2018-06-24 10:53:11.351597-06
86	salgo	go out	salir	1	1	PRES	2018-06-24 10:53:11.351985-06
87	parezco	look like	parecer	1	1	PRES	2018-06-24 10:53:11.352406-06
88	conozco	know	conocer	1	1	PRES	2018-06-24 10:53:11.352811-06
89	empecé	started	empezar	1	1	PRET	2018-06-24 10:53:11.353348-06
90	envío	sent	enviar	1	1	PRES	2018-06-24 10:53:11.354736-06
91	envías	sent	enviar	1	2	PRES	2018-06-24 10:53:11.355389-06
92	envía	sent	enviar	1	3	PRES	2018-06-24 10:53:11.355845-06
93	envían	sent	enviar	2	1	PRES	2018-06-24 10:53:11.356343-06
\.


--
-- Name: unique_conjugations_unique_conjugation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unique_conjugations_unique_conjugation_id_seq', 95, true);


--
-- Name: nonverbs entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nonverbs
    ADD CONSTRAINT entries_pkey PRIMARY KEY (nonverb_id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (goal_id);


--
-- Name: infinitives infinitives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY infinitives
    ADD CONSTRAINT infinitives_pkey PRIMARY KEY (infinitive_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: stem_changes stem_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stem_changes
    ADD CONSTRAINT stem_changes_pkey PRIMARY KEY (stem_change_id);


--
-- Name: unique_conjugations unique_conjugations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unique_conjugations
    ADD CONSTRAINT unique_conjugations_pkey PRIMARY KEY (unique_conjugation_id);


--
-- Name: idx_entries_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_entries_en_and_en_disambiguation ON nonverbs USING btree (en, en_disambiguation);


--
-- Name: idx_entries_en_plural_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_entries_en_plural_and_en_disambiguation ON nonverbs USING btree (en_plural, en_disambiguation);


--
-- Name: idx_entries_es; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_entries_es ON nonverbs USING btree (es);


--
-- Name: idx_infinitives_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_en_and_en_disambiguation ON infinitives USING btree (en, en_disambiguation);


--
-- Name: idx_infinitives_en_past_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_en_past_and_en_disambiguation ON infinitives USING btree (en_past, en_disambiguation);


--
-- Name: idx_infinitives_es; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_es ON infinitives USING btree (es);


--
-- Name: idx_stem_changes_stem; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_stem_changes_stem ON stem_changes USING btree (stem);


--
-- Name: idx_unique_conjugations_es; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_conjugations_es ON unique_conjugations USING btree (es);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX schema_version_s_idx ON schema_version USING btree (success);


--
-- Name: stem_changes stem_changes_infinitive_es_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stem_changes
    ADD CONSTRAINT stem_changes_infinitive_es_fkey FOREIGN KEY (infinitive_es) REFERENCES infinitives(es);


--
-- Name: unique_conjugations unique_conjugations_infinitive_es_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unique_conjugations
    ADD CONSTRAINT unique_conjugations_infinitive_es_fkey FOREIGN KEY (infinitive_es) REFERENCES infinitives(es);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

