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
DROP INDEX public.idx_unique_conjugations_es_mixed;
DROP INDEX public.idx_stem_changes_stem_lower;
DROP INDEX public.idx_nonverbs_es_lower;
DROP INDEX public.idx_nonverbs_en_plural_and_en_disambiguation;
DROP INDEX public.idx_nonverbs_en_and_en_disambiguation;
DROP INDEX public.idx_infinitives_es_mixed;
DROP INDEX public.idx_infinitives_es_lower;
DROP INDEX public.idx_infinitives_en_past_and_en_disambiguation;
DROP INDEX public.idx_infinitives_en_and_en_disambiguation;
DROP INDEX public.idx_cards_leaf_ids_csv;
ALTER TABLE ONLY public.unique_conjugations DROP CONSTRAINT unique_conjugations_pkey;
ALTER TABLE ONLY public.stem_changes DROP CONSTRAINT stem_changes_pkey;
ALTER TABLE ONLY public.schema_version DROP CONSTRAINT schema_version_pk;
ALTER TABLE ONLY public.nonverbs DROP CONSTRAINT nonverbs_pkey;
ALTER TABLE ONLY public.infinitives DROP CONSTRAINT infinitives_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_pkey;
ALTER TABLE public.goals ALTER COLUMN goal_id DROP DEFAULT;
ALTER TABLE public.cards ALTER COLUMN card_id DROP DEFAULT;
DROP TABLE public.unique_conjugations;
DROP TABLE public.stem_changes;
DROP TABLE public.schema_version;
DROP TABLE public.nonverbs;
DROP SEQUENCE public.leaf_ids;
DROP TABLE public.infinitives;
DROP SEQUENCE public.goals_goal_id_seq;
DROP TABLE public.goals;
DROP SEQUENCE public.cards_card_id_seq;
DROP TABLE public.cards;
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
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cards (
    card_id integer NOT NULL,
    gloss_rows_json text NOT NULL,
    last_seen_at timestamp with time zone,
    leaf_ids_csv text NOT NULL,
    prompt text NOT NULL,
    stage integer NOT NULL,
    mnemonic text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE cards OWNER TO postgres;

--
-- Name: cards_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cards_card_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cards_card_id_seq OWNER TO postgres;

--
-- Name: cards_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cards_card_id_seq OWNED BY cards.card_id;


--
-- Name: goals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE goals (
    goal_id integer NOT NULL,
    tags_csv text NOT NULL,
    en text NOT NULL,
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
    leaf_id integer NOT NULL,
    es_mixed text NOT NULL,
    en text NOT NULL,
    en_past text NOT NULL,
    en_disambiguation text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE infinitives OWNER TO postgres;

--
-- Name: leaf_ids; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE leaf_ids
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE leaf_ids OWNER TO postgres;

--
-- Name: nonverbs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nonverbs (
    leaf_id integer NOT NULL,
    es_mixed text NOT NULL,
    en text NOT NULL,
    en_disambiguation text NOT NULL,
    en_plural text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE nonverbs OWNER TO postgres;

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
    leaf_id integer NOT NULL,
    infinitive_es_mixed text NOT NULL,
    stem_mixed text NOT NULL,
    tense text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE stem_changes OWNER TO postgres;

--
-- Name: unique_conjugations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE unique_conjugations (
    leaf_id integer NOT NULL,
    es_mixed text NOT NULL,
    en text NOT NULL,
    infinitive_es_mixed text NOT NULL,
    number integer NOT NULL,
    person integer NOT NULL,
    tense text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE unique_conjugations OWNER TO postgres;

--
-- Name: cards card_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cards ALTER COLUMN card_id SET DEFAULT nextval('cards_card_id_seq'::regclass);


--
-- Name: goals goal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals ALTER COLUMN goal_id SET DEFAULT nextval('goals_goal_id_seq'::regclass);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cards (card_id, gloss_rows_json, last_seen_at, leaf_ids_csv, prompt, stage, mnemonic, created_at, updated_at) FROM stdin;
6	[{"leafId":382,"en":"days","es":"días"}]	\N	382	days	1		2018-06-26 19:18:16.741739-06	2018-06-26 19:18:16.737-06
1	[{"leafId":388,"en":"good","es":"buenas"},{"leafId":383,"en":"afternoons","es":"tardes"}]	2018-06-26 17:45:10-06	388,383	Good afternoon!	3		2018-06-26 17:26:04.984444-06	2018-06-26 19:50:58.893-06
2	[{"leafId":388,"en":"good","es":"buenas"}]	2018-06-26 17:45:05-06	388	good (fem.)	3		2018-06-26 17:26:04.984444-06	2018-06-26 19:50:59.019-06
3	[{"leafId":383,"en":"afternoons","es":"tardes"}]	2018-06-26 17:44:51-06	383	afternoons	3		2018-06-26 17:26:04.984444-06	2018-06-26 19:50:59.02-06
7	[{"leafId":387,"en":"good","es":"buenos"},{"leafId":382,"en":"days","es":"días"}]	\N	387,382	Good morning!	0		2018-06-26 19:56:45.429788-06	2018-06-26 19:56:45.426-06
8	[{"leafId":387,"en":"good","es":"buenos"}]	\N	387	good (masc.)	1		2018-06-26 19:56:45.429788-06	2018-06-26 19:56:45.426-06
10	[{"leafId":453,"en":"am","es":"soy"},{"leafId":384,"en":"engineer","es":"ingeniero"},{"leafId":409,"en":"of","es":"de"},{"leafId":412,"en":"software","es":"software"}]	\N	453,384,409,412	I'm a software engineer.	0		2018-06-26 20:39:35.595353-06	2018-06-26 20:39:35.59-06
11	[{"leafId":453,"en":"am","es":"soy"}]	\N	453	(I) to be (be (what))	1		2018-06-26 20:39:35.595353-06	2018-06-26 20:39:35.59-06
12	[{"leafId":384,"en":"engineer","es":"ingeniero"}]	\N	384	engineer	1		2018-06-26 20:39:35.595353-06	2018-06-26 20:39:35.59-06
13	[{"leafId":409,"en":"of","es":"de"}]	\N	409	of	1		2018-06-26 20:39:35.595353-06	2018-06-26 20:39:35.59-06
14	[{"leafId":412,"en":"software","es":"software"}]	\N	412	software	1		2018-06-26 20:39:35.595353-06	2018-06-26 20:39:35.59-06
15	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	\N	410,349,-12	Where do you live?	0		2018-06-26 20:39:55.002017-06	2018-06-26 20:39:54.999-06
16	[{"leafId":410,"en":"where","es":"dónde"}]	\N	410	where (question)	1		2018-06-26 20:39:55.002017-06	2018-06-26 20:39:54.999-06
17	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	\N	349,-12	(you) live	0		2018-06-26 20:39:55.002017-06	2018-06-26 20:39:55-06
18	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	327,-1,380	I speak Spanish.	0		2018-06-26 20:40:06.327063-06	2018-06-26 20:40:06.325-06
19	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"}]	\N	327,-1	(I) speak	0		2018-06-26 20:40:06.327063-06	2018-06-26 20:40:06.325-06
20	[{"leafId":380,"en":"Spanish","es":"español"}]	\N	380	Spanish	1		2018-06-26 20:40:06.327063-06	2018-06-26 20:40:06.325-06
21	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":381,"en":"English","es":"inglés"}]	\N	327,-1,381	I speak English.	0		2018-06-26 20:40:18.47619-06	2018-06-26 20:40:18.474-06
23	[{"leafId":381,"en":"English","es":"inglés"}]	\N	381	English	1		2018-06-26 20:40:18.47619-06	2018-06-26 20:40:18.474-06
24	[{"leafId":317,"en":"eat","es":"com-"},{"leafId":-11,"en":"(I)","es":"-o"},{"leafId":464,"en":"are","es":"estás"}]	\N	317,-11,464	How are you?	0		2018-06-26 20:40:26.286113-06	2018-06-26 20:40:26.283-06
25	[{"leafId":317,"en":"eat","es":"com-"},{"leafId":-11,"en":"(I)","es":"-o"}]	\N	317,-11	(I) eat	0		2018-06-26 20:40:26.286113-06	2018-06-26 20:40:26.283-06
26	[{"leafId":464,"en":"are","es":"estás"}]	\N	464	(you) to be (be (how))	1		2018-06-26 20:40:26.286113-06	2018-06-26 20:40:26.284-06
27	[{"leafId":407,"en":"what","es":"qué"},{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	\N	407,328,-12	What do you do?	0		2018-06-26 20:40:35.609432-06	2018-06-26 20:40:35.607-06
28	[{"leafId":407,"en":"what","es":"qué"}]	\N	407	what	1		2018-06-26 20:40:35.609432-06	2018-06-26 20:40:35.607-06
29	[{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	\N	328,-12	(you) do	0		2018-06-26 20:40:35.609432-06	2018-06-26 20:40:35.607-06
30	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":398,"en":"well","es":"bien"}]	\N	463,398	I'm doing well.	0		2018-06-26 20:40:50.275643-06	2018-06-26 20:40:50.273-06
31	[{"leafId":463,"en":"am","es":"estoy"}]	\N	463	(I) to be (be (how))	1		2018-06-26 20:40:50.275643-06	2018-06-26 20:40:50.273-06
32	[{"leafId":398,"en":"well","es":"bien"}]	\N	398	well	1		2018-06-26 20:40:50.275643-06	2018-06-26 20:40:50.274-06
33	[{"leafId":408,"en":"hello","es":"hola"}]	\N	408	Hello!	1		2018-06-26 20:41:09.50277-06	2018-06-26 20:41:09.501-06
35	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"},{"leafId":329,"en":"go","es":"-"},{"leafId":-14,"en":"(they)","es":"-en"},{"leafId":417,"en":"Longmont","es":"Longmont"}]	\N	349,-11,329,-14,417	I live here in Longmont.	0		2018-06-26 20:41:20.074141-06	2018-06-26 20:41:20.07-06
36	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"}]	\N	349,-11	(I) live	0		2018-06-26 20:41:20.074141-06	2018-06-26 20:41:20.071-06
37	[{"leafId":329,"en":"go","es":"-"},{"leafId":-14,"en":"(they)","es":"-en"}]	\N	329,-14	(they) go	0		2018-06-26 20:41:20.074141-06	2018-06-26 20:41:20.071-06
38	[{"leafId":417,"en":"Longmont","es":"Longmont"}]	\N	417	Longmont	1		2018-06-26 20:41:20.074141-06	2018-06-26 20:41:20.071-06
39	[{"leafId":415,"en":"me","es":"me"},{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":419,"en":"to","es":"a"},{"leafId":417,"en":"Longmont","es":"Longmont"},{"leafId":329,"en":"go","es":"-"},{"leafId":-14,"en":"(they)","es":"-en"},{"leafId":423,"en":"January","es":"enero"}]	\N	415,351,-6,419,417,329,-14,423	I moved to Longmont in January.	0		2018-06-26 20:41:35.706712-06	2018-06-26 20:41:35.702-06
40	[{"leafId":415,"en":"me","es":"me"}]	\N	415	me	1		2018-06-26 20:41:35.706712-06	2018-06-26 20:41:35.702-06
41	[{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"}]	\N	351,-6	(I) moved	0		2018-06-26 20:41:35.706712-06	2018-06-26 20:41:35.703-06
42	[{"leafId":419,"en":"to","es":"a"}]	\N	419	to	1		2018-06-26 20:41:35.706712-06	2018-06-26 20:41:35.703-06
45	[{"leafId":423,"en":"January","es":"enero"}]	\N	423	January	1		2018-06-26 20:41:35.706712-06	2018-06-26 20:41:35.703-06
46	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"},{"leafId":392,"en":"a","es":"una"},{"leafId":385,"en":"list","es":"lista"},{"leafId":409,"en":"of","es":"de"},{"leafId":386,"en":"sentences","es":"oraciones"},{"leafId":421,"en":"for","es":"para"},{"leafId":316,"en":"learn","es":"aprender"}]	\N	451,-22,392,385,409,386,421,316	I made a list of sentences to learn.	0		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.894-06
47	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"}]	\N	451,-22	(I) did	0		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.894-06
48	[{"leafId":392,"en":"a","es":"una"}]	\N	392	a (fem.)	1		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.895-06
49	[{"leafId":385,"en":"list","es":"lista"}]	\N	385	list	1		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.895-06
51	[{"leafId":386,"en":"sentences","es":"oraciones"}]	\N	386	sentences	1		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.895-06
52	[{"leafId":421,"en":"for","es":"para"}]	\N	421	for (in order to)	1		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.895-06
53	[{"leafId":316,"en":"learn","es":"aprender"}]	\N	316	to learn	1		2018-06-26 20:41:50.898792-06	2018-06-26 20:41:50.895-06
54	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	410,316,-16,380	Where did you learn Spanish?	0		2018-06-26 20:42:03.499529-06	2018-06-26 20:42:03.497-06
56	[{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	316,-16	(you) learned	0		2018-06-26 20:42:03.499529-06	2018-06-26 20:42:03.497-06
58	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":418,"en":"Cuba","es":"Cuba"},{"leafId":420,"en":"for","es":"por"},{"leafId":426,"en":"some","es":"unas"},{"leafId":428,"en":"weeks","es":"semanas"}]	\N	347,-6,418,420,426,428	I visited Cuba for a few weeks.	0		2018-06-26 20:42:15.719557-06	2018-06-26 20:42:15.713-06
59	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"}]	\N	347,-6	(I) visited	0		2018-06-26 20:42:15.719557-06	2018-06-26 20:42:15.713-06
60	[{"leafId":418,"en":"Cuba","es":"Cuba"}]	\N	418	Cuba	1		2018-06-26 20:42:15.719557-06	2018-06-26 20:42:15.713-06
61	[{"leafId":420,"en":"for","es":"por"}]	\N	420	for (on behalf of)	1		2018-06-26 20:42:15.719557-06	2018-06-26 20:42:15.713-06
62	[{"leafId":426,"en":"some","es":"unas"}]	\N	426	some (fem.)	1		2018-06-26 20:42:15.719557-06	2018-06-26 20:42:15.713-06
63	[{"leafId":428,"en":"weeks","es":"semanas"}]	\N	428	weeks	1		2018-06-26 20:42:15.719557-06	2018-06-26 20:42:15.713-06
64	[{"leafId":413,"en":"with","es":"con"},{"leafId":414,"en":"who","es":"quién"},{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"},{"leafId":327,"en":"speak","es":"hablar"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	413,414,431,-12,327,380	Who do you want to speak Spanish with?	0		2018-06-26 20:42:32.223154-06	2018-06-26 20:42:32.221-06
65	[{"leafId":413,"en":"with","es":"con"}]	\N	413	with	1		2018-06-26 20:42:32.223154-06	2018-06-26 20:42:32.221-06
66	[{"leafId":414,"en":"who","es":"quién"}]	\N	414	who	1		2018-06-26 20:42:32.223154-06	2018-06-26 20:42:32.221-06
67	[{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"}]	\N	431,-12	(you) want	0		2018-06-26 20:42:32.223154-06	2018-06-26 20:42:32.221-06
68	[{"leafId":327,"en":"speak","es":"hablar"}]	\N	327	to speak	1		2018-06-26 20:42:32.223154-06	2018-06-26 20:42:32.221-06
70	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":392,"en":"a","es":"una"},{"leafId":422,"en":"class","es":"clase"},{"leafId":409,"en":"of","es":"de"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	350,-15,392,422,409,380	 took a class in Spanish.	0		2018-06-26 20:42:44.869959-06	2018-06-26 20:42:44.859-06
71	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"}]	\N	350,-15	(I) attended	0		2018-06-26 20:42:44.869959-06	2018-06-26 20:42:44.859-06
73	[{"leafId":422,"en":"class","es":"clase"}]	\N	422	class	1		2018-06-26 20:42:44.869959-06	2018-06-26 20:42:44.859-06
76	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":392,"en":"a","es":"una"},{"leafId":424,"en":"application","es":"aplicación"},{"leafId":427,"en":"mobile phone","es":"móvil"},{"leafId":421,"en":"for","es":"para"},{"leafId":353,"en":"study","es":"estudiar"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	352,-6,392,424,427,421,353,380	I created a mobile app to study Spanish.	0		2018-06-26 20:43:00.606534-06	2018-06-26 20:43:00.601-06
77	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"}]	\N	352,-6	(I) created	0		2018-06-26 20:43:00.606534-06	2018-06-26 20:43:00.601-06
79	[{"leafId":424,"en":"application","es":"aplicación"}]	\N	424	application	1		2018-06-26 20:43:00.606534-06	2018-06-26 20:43:00.601-06
80	[{"leafId":427,"en":"mobile phone","es":"móvil"}]	\N	427	mobile phone	1		2018-06-26 20:43:00.606534-06	2018-06-26 20:43:00.601-06
82	[{"leafId":353,"en":"study","es":"estudiar"}]	\N	353	to study	1		2018-06-26 20:43:00.606534-06	2018-06-26 20:43:00.601-06
\.


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_card_id_seq', 83, true);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags_csv, en, es, created_at, updated_at) FROM stdin;
1		Good afternoon!	buenas tardes	2018-06-26 17:26:04.873884-06	2018-06-26 17:26:04.866-06
3		Good morning!	buenos días	2018-06-26 19:56:02.500663-06	2018-06-26 19:56:02.491-06
4		Good morning!	buenos días	2018-06-26 19:56:44.921752-06	2018-06-26 19:56:44.877-06
5		I'm a software engineer.	soy ingeniero de software	2018-06-26 20:39:35.338216-06	2018-06-26 20:39:35.331-06
6		Where do you live?	dónde vives	2018-06-26 20:39:54.9681-06	2018-06-26 20:39:54.966-06
7		I speak Spanish.	hablo español	2018-06-26 20:40:06.301163-06	2018-06-26 20:40:06.299-06
8		I speak English.	hablo inglés	2018-06-26 20:40:18.450858-06	2018-06-26 20:40:18.449-06
9		How are you?	como estás	2018-06-26 20:40:26.261565-06	2018-06-26 20:40:26.26-06
10		What do you do?	qué haces	2018-06-26 20:40:35.575903-06	2018-06-26 20:40:35.574-06
11		I'm doing well.	estoy bien	2018-06-26 20:40:50.251059-06	2018-06-26 20:40:50.249-06
12		Hello!	hola	2018-06-26 20:41:09.481319-06	2018-06-26 20:41:09.479-06
13		I live here in Longmont.	vivo en Longmont	2018-06-26 20:41:20.048749-06	2018-06-26 20:41:20.047-06
14		I moved to Longmont in January.	me mudé a Longmont en enero	2018-06-26 20:41:35.689042-06	2018-06-26 20:41:35.687-06
15		I made a list of sentences to learn.	hice una lista de oraciones para aprender	2018-06-26 20:41:50.877562-06	2018-06-26 20:41:50.876-06
16		Where did you learn Spanish?	dónde aprendiste español	2018-06-26 20:42:03.479536-06	2018-06-26 20:42:03.478-06
17		I visited Cuba for a few weeks.	visité Cuba por unas semanas	2018-06-26 20:42:15.690644-06	2018-06-26 20:42:15.689-06
18		Who do you want to speak Spanish with?	con quién quieres hablar español	2018-06-26 20:42:32.202747-06	2018-06-26 20:42:32.2-06
19		 took a class in Spanish.	asistí una clase de español	2018-06-26 20:42:44.831389-06	2018-06-26 20:42:44.828-06
20		I created a mobile app to study Spanish.	creé una aplicación móvil para estudiar español	2018-06-26 20:43:00.582786-06	2018-06-26 20:43:00.581-06
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 20, true);


--
-- Data for Name: infinitives; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY infinitives (leaf_id, es_mixed, en, en_past, en_disambiguation, created_at) FROM stdin;
315	andar	walk	walked		2018-06-24 09:57:33.983446-06
316	aprender	learn	learned		2018-06-24 09:57:33.984734-06
317	comer	eat	ate		2018-06-24 09:57:33.985347-06
318	conocer	know	knew	be able to	2018-06-24 09:57:33.986019-06
319	contar	tell	told		2018-06-24 09:57:33.98678-06
320	dar	give	gave		2018-06-24 09:57:33.987309-06
321	decir	say	said		2018-06-24 09:57:33.987899-06
322	empezar	start	started		2018-06-24 09:57:33.988574-06
323	encontrar	find	found		2018-06-24 09:57:33.994568-06
324	entender	understand	understood		2018-06-24 09:57:34.000548-06
325	enviar	send	sent		2018-06-24 09:57:34.006513-06
326	estar	be	was	be (how)	2018-06-24 09:57:34.012434-06
327	hablar	speak	spoke		2018-06-24 09:57:34.017548-06
328	hacer	do	did		2018-06-24 09:57:34.018056-06
329	ir	go	went		2018-06-24 09:57:34.018688-06
330	parecer	seem	seemed		2018-06-24 09:57:34.019227-06
331	pedir	request	requested		2018-06-24 09:57:34.019677-06
332	pensar	think	thought		2018-06-24 09:57:34.020182-06
333	poder	can	could		2018-06-24 09:57:34.020785-06
334	poner	put	put		2018-06-24 09:57:34.021223-06
335	preguntar	ask	asked		2018-06-24 09:57:34.021846-06
336	querer	want	wanted		2018-06-24 09:57:34.022716-06
337	recordar	remember	remembered		2018-06-24 09:57:34.023446-06
338	saber	know	knew	know (thing)	2018-06-24 09:57:34.024181-06
339	salir	go out	went out		2018-06-24 09:57:34.02479-06
340	seguir	follow	followed		2018-06-24 09:57:34.025256-06
341	sentir	feel	felt		2018-06-24 09:57:34.026079-06
342	ser	be	was	be (what)	2018-06-24 09:57:34.026682-06
343	tener	have	had		2018-06-24 09:57:34.027222-06
344	trabajar	work	worked		2018-06-24 09:57:34.027967-06
345	ver	see	saw		2018-06-24 09:57:34.028806-06
346	venir	come	came		2018-06-24 09:57:34.029696-06
347	visitar	visit	visited		2018-06-24 09:57:34.030334-06
348	volver	return	returned		2018-06-24 09:57:34.031357-06
349	vivir	live	lived		2018-06-24 10:12:18.679112-06
350	asistir	attend	attended		2018-06-24 10:15:03.427516-06
351	mudar	move	moved		2018-06-24 10:16:29.743042-06
352	crear	create	created		2018-06-24 10:17:19.293622-06
353	estudiar	study	studied		2018-06-24 10:21:48.839702-06
\.


--
-- Name: leaf_ids; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('leaf_ids', 497, true);


--
-- Data for Name: nonverbs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nonverbs (leaf_id, es_mixed, en, en_disambiguation, en_plural, created_at) FROM stdin;
383	tarde	afternoon		afternoons	2018-06-24 09:42:32.325038-06
354	brazo	arm		arms	2018-06-24 09:42:32.310062-06
355	pierna	leg		legs	2018-06-24 09:42:32.31134-06
356	corazón	heart		hearts	2018-06-24 09:42:32.311925-06
357	estómago	stomach		stomachs	2018-06-24 09:42:32.312547-06
358	ojo	eye		eyes	2018-06-24 09:42:32.313039-06
359	nariz	nose		noses	2018-06-24 09:42:32.313538-06
360	boca	mouth		mouths	2018-06-24 09:42:32.31404-06
361	oreja	ear		ears	2018-06-24 09:42:32.314516-06
362	cara	face		faces	2018-06-24 09:42:32.314983-06
363	cuello	neck		necks	2018-06-24 09:42:32.315436-06
364	dedo	finger		fingers	2018-06-24 09:42:32.315907-06
365	pie	foot		feet	2018-06-24 09:42:32.316363-06
366	muslo	thigh		thighs	2018-06-24 09:42:32.316797-06
367	tobillo	ankle		ankles	2018-06-24 09:42:32.317247-06
368	codo	elbow		elbows	2018-06-24 09:42:32.317698-06
369	muñeca	wrist		wrists	2018-06-24 09:42:32.318139-06
370	cuerpo	body		bodies	2018-06-24 09:42:32.318608-06
371	diente	tooth		tooths	2018-06-24 09:42:32.319075-06
372	mano	hand		hands	2018-06-24 09:42:32.319518-06
373	espalda	back		backs	2018-06-24 09:42:32.31995-06
374	cadera	hip		hips	2018-06-24 09:42:32.320412-06
375	mandíbula	jaw		jaws	2018-06-24 09:42:32.320864-06
376	hombro	shoulder		shoulders	2018-06-24 09:42:32.321315-06
377	pulgar	thumb		thumbs	2018-06-24 09:42:32.321761-06
378	lengua	tongue		tongues	2018-06-24 09:42:32.322202-06
379	garganta	throat		throats	2018-06-24 09:42:32.322985-06
380	español	Spanish		\N	2018-06-24 09:42:32.323407-06
381	inglés	English		\N	2018-06-24 09:42:32.323906-06
382	día	day		days	2018-06-24 09:42:32.324572-06
384	ingeniero	engineer		engineers	2018-06-24 09:42:32.325593-06
385	lista	list		lists	2018-06-24 09:42:32.326072-06
386	oración	sentence		sentences	2018-06-24 09:42:32.326465-06
387	bueno	good	masc.	good	2018-06-24 09:42:32.326926-06
388	buena	good	fem.	good	2018-06-24 09:42:32.327412-06
389	el	the	masc.	\N	2018-06-24 09:42:32.327897-06
390	la	the	fem.	\N	2018-06-24 09:42:32.32839-06
391	un	a	masc.	\N	2018-06-24 09:42:32.328869-06
392	una	a	fem.	\N	2018-06-24 09:42:32.329419-06
393	mi	my		\N	2018-06-24 09:42:32.329823-06
394	este	this	masc.	\N	2018-06-24 09:42:32.330276-06
395	esta	this	fem.	\N	2018-06-24 09:42:32.33074-06
396	cada	every		\N	2018-06-24 09:42:32.331212-06
397	cómo	how		\N	2018-06-24 09:42:32.331646-06
398	bien	well		\N	2018-06-24 09:42:32.332094-06
399	yo	I		\N	2018-06-24 09:42:32.332558-06
400	tú	you	pronoun	\N	2018-06-24 09:42:32.33304-06
401	él	he		\N	2018-06-24 09:42:32.33464-06
402	ella	she		\N	2018-06-24 09:42:32.335082-06
403	nosotros	we	masc.	\N	2018-06-24 09:42:32.335483-06
404	nosotras	we	fem.	\N	2018-06-24 09:42:32.335885-06
405	ellos	they	masc.	\N	2018-06-24 09:42:32.33628-06
406	ellas	they	fem.	\N	2018-06-24 09:42:32.336675-06
407	qué	what		\N	2018-06-24 09:42:32.337066-06
408	hola	hello		\N	2018-06-24 09:42:32.337468-06
409	de	of		\N	2018-06-24 09:42:32.337867-06
410	dónde	where	question	\N	2018-06-24 09:42:32.338256-06
411	donde	where	relative	\N	2018-06-24 09:42:32.338645-06
412	software	software		\N	2018-06-24 09:42:32.339084-06
413	con	with		\N	2018-06-24 09:42:32.339496-06
414	quién	who		\N	2018-06-24 09:42:32.339963-06
415	me	me		\N	2018-06-24 09:42:32.340438-06
416	te	you	direct/indirect object	\N	2018-06-24 09:42:32.340855-06
417	Longmont	Longmont		\N	2018-06-24 10:12:57.81832-06
418	Cuba	Cuba		\N	2018-06-24 10:14:14.159249-06
419	a	to		\N	2018-06-24 10:16:56.797247-06
420	por	for	on behalf of	\N	2018-06-24 10:18:21.748271-06
421	para	for	in order to	\N	2018-06-24 10:18:37.720114-06
422	clase	class		classes	2018-06-24 10:18:54.790579-06
423	enero	January		\N	2018-06-24 10:19:36.45117-06
424	aplicación	application		applications	2018-06-24 10:19:47.157449-06
425	unos	some	masc.	\N	2018-06-24 10:20:00.535063-06
426	unas	some	fem.	\N	2018-06-24 10:20:07.365061-06
427	móvil	mobile phone		mobile phones	2018-06-24 10:20:48.975803-06
428	semana	week		weeks	2018-06-24 10:21:05.140751-06
497	piel	skin		\N	2018-06-26 20:37:34.949585-06
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create goals and cards	SQL	V1__create_goals_and_cards.sql	-1940653025	postgres	2018-06-26 13:37:25.271006	29	t
2	2	create leaf tables	SQL	V2__create_leaf_tables.sql	988272324	postgres	2018-06-26 13:37:25.326783	51	t
\.


--
-- Data for Name: stem_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stem_changes (leaf_id, infinitive_es_mixed, stem_mixed, tense, created_at) FROM stdin;
429	poder	pued-	PRES	2018-06-24 11:26:43.651439-06
430	tener	tien-	PRES	2018-06-24 11:26:43.803834-06
431	querer	quier-	PRES	2018-06-24 11:26:43.804733-06
432	seguir	sig-	PRES	2018-06-24 11:26:43.805456-06
433	encontrar	encuentr-	PRES	2018-06-24 11:26:43.806086-06
434	venir	vien-	PRES	2018-06-24 11:26:43.806698-06
435	pensar	piens-	PRES	2018-06-24 11:26:43.807283-06
436	volver	vuelv-	PRES	2018-06-24 11:26:43.807795-06
437	sentir	sient-	PRES	2018-06-24 11:26:43.808329-06
438	contar	cuent-	PRES	2018-06-24 11:26:43.808861-06
439	empezar	empiez-	PRES	2018-06-24 11:26:43.809358-06
440	decir	dic-	PRES	2018-06-24 11:26:43.809844-06
441	recordar	recuerd-	PRES	2018-06-24 11:26:43.810424-06
442	pedir	pid-	PRES	2018-06-24 11:26:43.81091-06
443	entender	entiend-	PRES	2018-06-24 11:26:43.811642-06
444	andar	anduv-	PRET	2018-06-24 11:26:43.812328-06
445	saber	sup-	PRET	2018-06-24 11:26:43.812976-06
446	querer	quis-	PRET	2018-06-24 11:26:43.81373-06
447	poner	pus-	PRET	2018-06-24 11:26:43.814224-06
448	venir	vin-	PRET	2018-06-24 11:26:43.814936-06
449	decir	dij-	PRET	2018-06-24 11:26:43.815792-06
450	tener	tuv-	PRET	2018-06-24 11:26:43.816356-06
451	hacer	hic-	PRET	2018-06-24 11:26:43.816942-06
452	poder	pud-	PRET	2018-06-24 11:26:43.817449-06
\.


--
-- Data for Name: unique_conjugations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unique_conjugations (leaf_id, es_mixed, en, infinitive_es_mixed, number, person, tense, created_at) FROM stdin;
453	soy	am	ser	1	1	PRES	2018-06-24 10:53:11.331513-06
454	eres	are	ser	1	2	PRES	2018-06-24 10:53:11.334102-06
455	es	is	ser	1	3	PRES	2018-06-24 10:53:11.334799-06
456	somos	are	ser	2	1	PRES	2018-06-24 10:53:11.335596-06
457	son	are	ser	2	3	PRES	2018-06-24 10:53:11.336235-06
458	fui	was	ser	1	1	PRET	2018-06-24 10:53:11.336833-06
459	fuiste	were	ser	1	2	PRET	2018-06-24 10:53:11.337566-06
460	fue	was	ser	1	3	PRET	2018-06-24 10:53:11.338114-06
461	fuimos	were	ser	2	1	PRET	2018-06-24 10:53:11.338658-06
462	fueron	were	ser	2	3	PRET	2018-06-24 10:53:11.339177-06
463	estoy	am	estar	1	1	PRES	2018-06-24 10:53:11.339723-06
464	estás	are	estar	1	2	PRES	2018-06-24 10:53:11.340233-06
465	está	is	estar	1	3	PRES	2018-06-24 10:53:11.340796-06
466	están	are	estar	2	3	PRES	2018-06-24 10:53:11.341339-06
467	tengo	have	tener	1	1	PRES	2018-06-24 10:53:11.341841-06
468	hago	do	hacer	1	1	PRES	2018-06-24 10:53:11.342385-06
469	digo	say	decir	1	1	PRES	2018-06-24 10:53:11.34283-06
470	dijeron	said	decir	2	3	PRET	2018-06-24 10:53:11.343357-06
471	voy	go	ir	1	1	PRES	2018-06-24 10:53:11.343851-06
472	vas	go	ir	1	2	PRES	2018-06-24 10:53:11.344385-06
473	va	goes	ir	1	3	PRES	2018-06-24 10:53:11.34485-06
474	vamos	go	ir	2	1	PRES	2018-06-24 10:53:11.345309-06
475	van	go	ir	2	3	PRES	2018-06-24 10:53:11.345931-06
476	veo	see	ver	1	1	PRES	2018-06-24 10:53:11.346443-06
477	vi	saw	ver	1	1	PRET	2018-06-24 10:53:11.346938-06
478	vio	saw	ver	1	3	PRET	2018-06-24 10:53:11.347455-06
479	vimos	saw	ver	2	1	PRET	2018-06-24 10:53:11.347861-06
480	doy	give	dar	1	1	PRES	2018-06-24 10:53:11.348332-06
481	di	gave	dar	1	1	PRET	2018-06-24 10:53:11.348782-06
482	diste	gave	dar	1	2	PRET	2018-06-24 10:53:11.349211-06
483	dio	gave	dar	1	3	PRET	2018-06-24 10:53:11.349614-06
484	dimos	gave	dar	2	1	PRET	2018-06-24 10:53:11.349999-06
485	dieron	gave	dar	2	3	PRET	2018-06-24 10:53:11.350387-06
486	sé	know	saber	1	1	PRES	2018-06-24 10:53:11.350775-06
487	pongo	put	poner	1	1	PRES	2018-06-24 10:53:11.351199-06
488	vengo	come	venir	1	1	PRES	2018-06-24 10:53:11.351597-06
489	salgo	go out	salir	1	1	PRES	2018-06-24 10:53:11.351985-06
490	parezco	look like	parecer	1	1	PRES	2018-06-24 10:53:11.352406-06
491	conozco	know	conocer	1	1	PRES	2018-06-24 10:53:11.352811-06
492	empecé	started	empezar	1	1	PRET	2018-06-24 10:53:11.353348-06
493	envío	sent	enviar	1	1	PRES	2018-06-24 10:53:11.354736-06
494	envías	sent	enviar	1	2	PRES	2018-06-24 10:53:11.355389-06
495	envía	sent	enviar	1	3	PRES	2018-06-24 10:53:11.355845-06
496	envían	sent	enviar	2	1	PRES	2018-06-24 10:53:11.356343-06
\.


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (card_id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (goal_id);


--
-- Name: infinitives infinitives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY infinitives
    ADD CONSTRAINT infinitives_pkey PRIMARY KEY (leaf_id);


--
-- Name: nonverbs nonverbs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nonverbs
    ADD CONSTRAINT nonverbs_pkey PRIMARY KEY (leaf_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: stem_changes stem_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stem_changes
    ADD CONSTRAINT stem_changes_pkey PRIMARY KEY (leaf_id);


--
-- Name: unique_conjugations unique_conjugations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unique_conjugations
    ADD CONSTRAINT unique_conjugations_pkey PRIMARY KEY (leaf_id);


--
-- Name: idx_cards_leaf_ids_csv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cards_leaf_ids_csv ON cards USING btree (leaf_ids_csv);


--
-- Name: idx_infinitives_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_en_and_en_disambiguation ON infinitives USING btree (en, en_disambiguation);


--
-- Name: idx_infinitives_en_past_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_en_past_and_en_disambiguation ON infinitives USING btree (en_past, en_disambiguation);


--
-- Name: idx_infinitives_es_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_es_lower ON infinitives USING btree (lower(es_mixed));


--
-- Name: idx_infinitives_es_mixed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_infinitives_es_mixed ON infinitives USING btree (es_mixed);


--
-- Name: idx_nonverbs_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_nonverbs_en_and_en_disambiguation ON nonverbs USING btree (en, en_disambiguation);


--
-- Name: idx_nonverbs_en_plural_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_nonverbs_en_plural_and_en_disambiguation ON nonverbs USING btree (en_plural, en_disambiguation);


--
-- Name: idx_nonverbs_es_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_nonverbs_es_lower ON nonverbs USING btree (lower(es_mixed));


--
-- Name: idx_stem_changes_stem_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_stem_changes_stem_lower ON stem_changes USING btree (lower(stem_mixed));


--
-- Name: idx_unique_conjugations_es_mixed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_conjugations_es_mixed ON unique_conjugations USING btree (lower(es_mixed));


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX schema_version_s_idx ON schema_version USING btree (success);


--
-- Name: stem_changes stem_changes_infinitive_es_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stem_changes
    ADD CONSTRAINT stem_changes_infinitive_es_fkey FOREIGN KEY (infinitive_es_mixed) REFERENCES infinitives(es_mixed);


--
-- Name: unique_conjugations unique_conjugations_infinitive_es_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unique_conjugations
    ADD CONSTRAINT unique_conjugations_infinitive_es_fkey FOREIGN KEY (infinitive_es_mixed) REFERENCES infinitives(es_mixed);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

