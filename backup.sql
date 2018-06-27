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
    updated_at timestamp with time zone NOT NULL,
    leaf_ids_csv text NOT NULL
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
126	[{"leafId":388,"en":"good","es":"buenas"}]	\N	388	good (fem.)	1		2018-06-26 21:22:50.209001-06	2018-06-26 21:30:22.234-06
127	[{"leafId":383,"en":"afternoons","es":"tardes"}]	\N	383	afternoons	1		2018-06-26 21:22:50.209001-06	2018-06-26 21:30:22.234-06
129	[{"leafId":453,"en":"am","es":"soy"}]	\N	453	(I) to be (be (what))	1		2018-06-26 21:22:57.352948-06	2018-06-26 21:30:22.236-06
130	[{"leafId":384,"en":"engineer","es":"ingeniero"}]	\N	384	engineer	1		2018-06-26 21:22:57.352948-06	2018-06-26 21:30:22.237-06
131	[{"leafId":409,"en":"of","es":"de"}]	2018-06-26 21:29:45-06	409	of	3		2018-06-26 21:22:57.352948-06	2018-06-26 21:30:22.238-06
132	[{"leafId":412,"en":"software","es":"software"}]	2018-06-26 21:29:42-06	412	software	3		2018-06-26 21:22:57.352948-06	2018-06-26 21:30:22.238-06
133	[{"leafId":342,"en":"be","es":"ser"}]	2018-06-26 21:29:34-06	342	to be (be (what))	2		2018-06-26 21:22:57.352948-06	2018-06-26 21:30:22.239-06
134	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:32-06	410,349,-12	Where do you live?	3		2018-06-26 21:23:03.228956-06	2018-06-26 21:30:22.239-06
135	[{"leafId":410,"en":"where","es":"dónde"}]	2018-06-26 21:29:30-06	410	where (question)	3		2018-06-26 21:23:03.228956-06	2018-06-26 21:30:22.24-06
136	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:28-06	349,-12	(you) live	3		2018-06-26 21:23:03.228956-06	2018-06-26 21:30:22.241-06
137	[{"leafId":349,"en":"live","es":"vivir"}]	2018-06-26 21:29:20-06	349	to live	3		2018-06-26 21:23:03.228956-06	2018-06-26 21:30:22.241-06
138	[{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:12-06	-12	(you) eat (comer)	3		2018-06-26 21:23:03.228956-06	2018-06-26 21:30:22.242-06
139	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:10-06	327,-1,380	I speak Spanish.	3		2018-06-26 21:23:11.364754-06	2018-06-26 21:30:22.243-06
140	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-26 21:29:05-06	327,-1	(I) speak	3		2018-06-26 21:23:11.364754-06	2018-06-26 21:30:22.244-06
141	[{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:03-06	380	Spanish	3		2018-06-26 21:23:11.364754-06	2018-06-26 21:30:22.244-06
142	[{"leafId":327,"en":"speak","es":"hablar"}]	2018-06-26 21:29:01-06	327	to speak	3		2018-06-26 21:23:11.364754-06	2018-06-26 21:30:22.245-06
143	[{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-26 21:28:24-06	-1	(I) talk (hablar)	3		2018-06-26 21:23:11.364754-06	2018-06-26 21:30:22.245-06
144	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":381,"en":"English","es":"inglés"}]	2018-06-26 21:29:07-06	327,-1,381	I speak English.	3		2018-06-26 21:23:18.524111-06	2018-06-26 21:30:22.246-06
146	[{"leafId":381,"en":"English","es":"inglés"}]	2018-06-26 21:28:22-06	381	English	3		2018-06-26 21:23:18.524111-06	2018-06-26 21:30:22.247-06
151	[{"leafId":464,"en":"are","es":"estás"}]	2018-06-26 21:28:18-06	464	(you) to be (be (how))	3		2018-06-26 21:23:25.706003-06	2018-06-26 21:30:22.248-06
152	[{"leafId":317,"en":"eat","es":"comer"}]	2018-06-26 21:28:16-06	317	to eat	3		2018-06-26 21:23:25.706003-06	2018-06-26 21:30:22.249-06
153	[{"leafId":-11,"en":"(I)","es":"-o"}]	2018-06-26 21:28:11-06	-11	(I) eat (comer)	3		2018-06-26 21:23:25.706003-06	2018-06-26 21:30:22.25-06
154	[{"leafId":326,"en":"be","es":"estar"}]	2018-06-26 21:28:04-06	326	to be (be (how))	3		2018-06-26 21:23:25.706003-06	2018-06-26 21:30:22.25-06
155	[{"leafId":407,"en":"what","es":"qué"},{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:18-06	407,328,-12	What are you doing?	3		2018-06-26 21:23:38.542987-06	2018-06-26 21:30:22.251-06
156	[{"leafId":407,"en":"what","es":"qué"}]	2018-06-26 21:28:01-06	407	what	3		2018-06-26 21:23:38.542987-06	2018-06-26 21:30:22.252-06
157	[{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:15-06	328,-12	(you) do	3		2018-06-26 21:23:38.542987-06	2018-06-26 21:30:22.252-06
158	[{"leafId":328,"en":"do","es":"hacer"}]	2018-06-26 21:27:57-06	328	to do	3		2018-06-26 21:23:38.542987-06	2018-06-26 21:30:22.253-06
160	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":398,"en":"well","es":"bien"}]	2018-06-26 21:27:55-06	463,398	I'm doing well.	3		2018-06-26 21:23:47.71726-06	2018-06-26 21:30:22.253-06
161	[{"leafId":463,"en":"am","es":"estoy"}]	2018-06-26 21:27:50-06	463	(I) to be (be (how))	3		2018-06-26 21:23:47.71726-06	2018-06-26 21:30:22.254-06
162	[{"leafId":398,"en":"well","es":"bien"}]	2018-06-26 21:27:45-06	398	well	3		2018-06-26 21:23:47.71726-06	2018-06-26 21:30:22.255-06
164	[{"leafId":408,"en":"hello","es":"hola"}]	2018-06-26 21:27:43-06	408	Hello!	3		2018-06-26 21:23:53.914204-06	2018-06-26 21:30:22.256-06
166	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"},{"leafId":329,"en":"go","es":"-"},{"leafId":-14,"en":"(they)","es":"-en"},{"leafId":417,"en":"Longmont","es":"Longmont"}]	\N	349,-11,329,-14,417	I live in Longmont.	0		2018-06-26 21:24:01.746243-06	2018-06-26 21:30:22.256-06
167	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"}]	2018-06-26 21:29:25-06	349,-11	(I) live	3		2018-06-26 21:24:01.746243-06	2018-06-26 21:30:22.257-06
168	[{"leafId":329,"en":"go","es":"-"},{"leafId":-14,"en":"(they)","es":"-en"}]	\N	329,-14	(they) go	0		2018-06-26 21:24:01.746243-06	2018-06-26 21:30:22.258-06
169	[{"leafId":417,"en":"Longmont","es":"Longmont"}]	2018-06-26 21:27:41-06	417	Longmont	3		2018-06-26 21:24:01.746243-06	2018-06-26 21:30:22.258-06
172	[{"leafId":329,"en":"go","es":"ir"}]	2018-06-26 21:28:40-06	329	to go	2		2018-06-26 21:24:01.746243-06	2018-06-26 21:30:22.259-06
173	[{"leafId":-14,"en":"(they)","es":"-en"}]	2018-06-26 21:27:33-06	-14	(they) eat (comer)	3		2018-06-26 21:24:01.746243-06	2018-06-26 21:30:22.26-06
175	[{"leafId":415,"en":"me","es":"me"}]	2018-06-26 21:27:31-06	415	me (to me)	3		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.261-06
176	[{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-26 21:27:27-06	351,-6	(I) moved	3		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.262-06
177	[{"leafId":419,"en":"to","es":"a"}]	2018-06-26 21:27:24-06	419	to (toward)	3		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.262-06
180	[{"leafId":423,"en":"January","es":"enero"}]	2018-06-26 21:27:22-06	423	January	3		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.263-06
181	[{"leafId":351,"en":"move","es":"mudar"}]	2018-06-26 21:27:20-06	351	to move	3		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.263-06
182	[{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-26 21:27:03-06	-6	(I) talked (hablar)	3		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.264-06
185	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"},{"leafId":392,"en":"a","es":"una"},{"leafId":385,"en":"list","es":"lista"},{"leafId":409,"en":"of","es":"de"},{"leafId":386,"en":"sentences","es":"oraciones"},{"leafId":421,"en":"for","es":"para"},{"leafId":316,"en":"learn","es":"aprender"}]	\N	451,-22,392,385,409,386,421,316	I made a list of sentences to learn.	1		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.265-06
122	[{"leafId":387,"en":"good","es":"buenos"},{"leafId":382,"en":"days","es":"días"}]	\N	387,382	Good morning!	0		2018-06-26 21:22:40.532507-06	2018-06-26 21:30:22.228-06
123	[{"leafId":387,"en":"good","es":"buenos"}]	\N	387	good (masc.)	1		2018-06-26 21:22:40.532507-06	2018-06-26 21:30:22.231-06
124	[{"leafId":382,"en":"days","es":"días"}]	\N	382	days	1		2018-06-26 21:22:40.532507-06	2018-06-26 21:30:22.232-06
125	[{"leafId":388,"en":"good","es":"buenas"},{"leafId":383,"en":"afternoons","es":"tardes"}]	\N	388,383	Good afternoon!	0		2018-06-26 21:22:50.209001-06	2018-06-26 21:30:22.233-06
128	[{"leafId":453,"en":"am","es":"soy"},{"leafId":384,"en":"engineer","es":"ingeniero"},{"leafId":409,"en":"of","es":"de"},{"leafId":412,"en":"software","es":"software"}]	\N	453,384,409,412	I'm a software engineer.	0		2018-06-26 21:22:57.352948-06	2018-06-26 21:30:22.235-06
174	[{"leafId":415,"en":"me","es":"me"},{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":419,"en":"to","es":"a"},{"leafId":417,"en":"Longmont","es":"Longmont"},{"leafId":329,"en":"go","es":"-"},{"leafId":-14,"en":"(they)","es":"-en"},{"leafId":423,"en":"January","es":"enero"}]	\N	415,351,-6,419,417,329,-14,423	I moved to Longmont in January.	0		2018-06-26 21:24:09.613753-06	2018-06-26 21:30:22.26-06
186	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"}]	2018-06-26 21:27:01-06	451,-22	(I) did	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.265-06
187	[{"leafId":392,"en":"a","es":"una"}]	2018-06-26 21:26:59-06	392	a (fem.)	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.266-06
188	[{"leafId":385,"en":"list","es":"lista"}]	2018-06-26 21:26:57-06	385	list	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.267-06
190	[{"leafId":386,"en":"sentences","es":"oraciones"}]	2018-06-26 21:26:55-06	386	sentences	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.268-06
191	[{"leafId":421,"en":"for","es":"para"}]	2018-06-26 21:26:52-06	421	for (in order to)	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.269-06
192	[{"leafId":316,"en":"learn","es":"aprender"}]	2018-06-26 21:26:44-06	316	to learn	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.269-06
193	[{"leafId":451,"en":"did","es":"hic-"}]	2018-06-26 21:26:40-06	451	Stem change for hacer in PRET	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.27-06
194	[{"leafId":-22,"en":"(I)","es":"-e"}]	2018-06-26 21:26:36-06	-22	(I) had (tener)	3		2018-06-26 21:24:23.139561-06	2018-06-26 21:30:22.27-06
196	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":418,"en":"Cuba","es":"Cuba"},{"leafId":420,"en":"for","es":"por"},{"leafId":426,"en":"some","es":"unas"},{"leafId":428,"en":"weeks","es":"semanas"}]	2018-06-26 21:27:10-06	347,-6,418,420,426,428	I visited Cuba for a few weeks.	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.271-06
197	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-26 21:27:07-06	347,-6	(I) visited	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.272-06
198	[{"leafId":418,"en":"Cuba","es":"Cuba"}]	2018-06-26 21:26:34-06	418	Cuba	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.272-06
199	[{"leafId":420,"en":"for","es":"por"}]	2018-06-26 21:26:31-06	420	for (on behalf of)	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.273-06
200	[{"leafId":426,"en":"some","es":"unas"}]	2018-06-26 21:26:28-06	426	some (fem.)	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.274-06
201	[{"leafId":428,"en":"weeks","es":"semanas"}]	2018-06-26 21:26:26-06	428	weeks	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.275-06
202	[{"leafId":347,"en":"visit","es":"visitar"}]	2018-06-26 21:26:24-06	347	to visit	3		2018-06-26 21:24:31.970408-06	2018-06-26 21:30:22.276-06
204	[{"leafId":413,"en":"with","es":"con"},{"leafId":414,"en":"who","es":"quién"},{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"},{"leafId":327,"en":"speak","es":"hablar"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	413,414,431,-12,327,380	Who do you want to speak Spanish with?	0		2018-06-26 21:24:42.777343-06	2018-06-26 21:30:22.277-06
205	[{"leafId":413,"en":"with","es":"con"}]	2018-06-26 21:26:22-06	413	with	3		2018-06-26 21:24:42.777343-06	2018-06-26 21:30:22.277-06
206	[{"leafId":414,"en":"who","es":"quién"}]	2018-06-26 21:26:20-06	414	who	3		2018-06-26 21:24:42.777343-06	2018-06-26 21:30:22.278-06
207	[{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"}]	\N	431,-12	(you) want	0		2018-06-26 21:24:42.777343-06	2018-06-26 21:30:22.279-06
210	[{"leafId":431,"en":"want","es":"quier-"}]	2018-06-26 21:26:14-06	431	Stem change for querer in PRES	2		2018-06-26 21:24:42.777343-06	2018-06-26 21:30:22.279-06
212	[{"leafId":336,"en":"want","es":"querer"}]	2018-06-26 21:26:11-06	336	to want	3		2018-06-26 21:24:42.777343-06	2018-06-26 21:30:22.28-06
213	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	410,316,-16,380	Where did you learn Spanish?	0		2018-06-26 21:24:51.438947-06	2018-06-26 21:30:22.28-06
215	[{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	316,-16	(you) learned	0		2018-06-26 21:24:51.438947-06	2018-06-26 21:30:22.281-06
218	[{"leafId":-16,"en":"(you)","es":"-iste"}]	2018-06-26 21:28:31-06	-16	(you) ate (comer)	2		2018-06-26 21:24:51.438947-06	2018-06-26 21:30:22.282-06
219	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":392,"en":"a","es":"una"},{"leafId":424,"en":"application","es":"aplicación"},{"leafId":427,"en":"mobile phone","es":"móvil"},{"leafId":421,"en":"for","es":"para"},{"leafId":353,"en":"study","es":"estudiar"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	352,-6,392,424,427,421,353,380	I created a mobile app to study Spanish.	0		2018-06-26 21:25:00.173425-06	2018-06-26 21:30:22.282-06
220	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"}]	\N	352,-6	(I) created	0		2018-06-26 21:25:00.173425-06	2018-06-26 21:30:22.283-06
222	[{"leafId":424,"en":"application","es":"aplicación"}]	2018-06-26 21:26:05-06	424	application	3		2018-06-26 21:25:00.173425-06	2018-06-26 21:30:22.283-06
223	[{"leafId":427,"en":"mobile phone","es":"móvil"}]	2018-06-26 21:26:00-06	427	mobile phone	3		2018-06-26 21:25:00.173425-06	2018-06-26 21:30:22.284-06
225	[{"leafId":353,"en":"study","es":"estudiar"}]	2018-06-26 21:25:58-06	353	to study	3		2018-06-26 21:25:00.173425-06	2018-06-26 21:30:22.285-06
227	[{"leafId":352,"en":"create","es":"crear"}]	2018-06-26 21:25:55-06	352	to create	2		2018-06-26 21:25:00.173425-06	2018-06-26 21:30:22.286-06
229	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":392,"en":"a","es":"una"},{"leafId":422,"en":"class","es":"clase"},{"leafId":409,"en":"of","es":"de"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:47-06	350,-15,392,422,409,380	I took a class in Spanish.	3		2018-06-26 21:25:14.87594-06	2018-06-26 21:30:22.287-06
230	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"}]	2018-06-26 21:28:28-06	350,-15	(I) attended	3		2018-06-26 21:25:14.87594-06	2018-06-26 21:30:22.288-06
232	[{"leafId":422,"en":"class","es":"clase"}]	2018-06-26 21:25:51-06	422	class	3		2018-06-26 21:25:14.87594-06	2018-06-26 21:30:22.289-06
235	[{"leafId":350,"en":"attend","es":"asistir"}]	2018-06-26 21:25:48-06	350	to attend	3		2018-06-26 21:25:14.87594-06	2018-06-26 21:30:22.29-06
236	[{"leafId":-15,"en":"(I)","es":"-í"}]	2018-06-26 21:25:29-06	-15	(I) ate (comer)	3		2018-06-26 21:25:14.87594-06	2018-06-26 21:30:22.29-06
237	[{"leafId":353,"en":"study","es":"estudi-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	\N	353,-1,380	I study Spanish.	0		2018-06-27 08:50:29.172548-06	2018-06-27 08:50:29.181-06
238	[{"leafId":353,"en":"study","es":"estudi-"},{"leafId":-1,"en":"(I)","es":"-o"}]	\N	353,-1	(I) study	0		2018-06-27 08:50:29.172548-06	2018-06-27 08:50:29.182-06
\.


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_card_id_seq', 241, true);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags_csv, en, es, created_at, updated_at, leaf_ids_csv) FROM stdin;
27		Good morning!	buenos días	2018-06-26 21:22:40.515651-06	2018-06-26 21:22:40.514-06	387,382
28		Good afternoon!	buenas tardes	2018-06-26 21:22:50.192679-06	2018-06-26 21:22:50.192-06	388,383
29		I'm a software engineer.	soy ingeniero de software	2018-06-26 21:22:57.329518-06	2018-06-26 21:22:57.328-06	453,384,409,412
30		Where do you live?	dónde vives	2018-06-26 21:23:03.214123-06	2018-06-26 21:23:03.213-06	410,349,-12
31		I speak Spanish.	hablo español	2018-06-26 21:23:11.350261-06	2018-06-26 21:23:11.349-06	327,-1,380
32		I speak English.	hablo inglés	2018-06-26 21:23:18.507478-06	2018-06-26 21:23:18.506-06	327,-1,381
34		What are you doing?	qué haces	2018-06-26 21:23:38.528733-06	2018-06-26 21:23:38.527-06	407,328,-12
35		I'm doing well.	estoy bien	2018-06-26 21:23:47.703565-06	2018-06-26 21:23:47.702-06	463,398
36		Hello!	hola	2018-06-26 21:23:53.901388-06	2018-06-26 21:23:53.9-06	408
37		I live in Longmont.	vivo en Longmont	2018-06-26 21:24:01.726953-06	2018-06-26 21:24:01.726-06	349,-11,329,-14,417
38		I moved to Longmont in January.	me mudé a Longmont en enero	2018-06-26 21:24:09.59708-06	2018-06-26 21:24:09.596-06	415,351,-6,419,417,329,-14,423
39		I made a list of sentences to learn.	hice una lista de oraciones para aprender	2018-06-26 21:24:23.11975-06	2018-06-26 21:24:23.119-06	451,-22,392,385,409,386,421,316
40		I visited Cuba for a few weeks.	visité Cuba por unas semanas	2018-06-26 21:24:31.951121-06	2018-06-26 21:24:31.95-06	347,-6,418,420,426,428
41		Who do you want to speak Spanish with?	con quién quieres hablar español	2018-06-26 21:24:42.761378-06	2018-06-26 21:24:42.76-06	413,414,431,-12,327,380
42		Where did you learn Spanish?	dónde aprendiste español	2018-06-26 21:24:51.422015-06	2018-06-26 21:24:51.421-06	410,316,-16,380
43		I created a mobile app to study Spanish.	creé una aplicación móvil para estudiar español	2018-06-26 21:25:00.156027-06	2018-06-26 21:25:00.155-06	352,-6,392,424,427,421,353,380
44		I took a class in Spanish.	asistí una clase de español	2018-06-26 21:25:14.854279-06	2018-06-26 21:25:14.851-06	350,-15,392,422,409,380
45		I study Spanish.	estudio español	2018-06-27 08:50:29.172548-06	2018-06-27 08:50:29.163-06	353,-1,380
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 45, true);


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
416	te	you	direct/indirect object	\N	2018-06-24 09:42:32.340855-06
417	Longmont	Longmont		\N	2018-06-24 10:12:57.81832-06
418	Cuba	Cuba		\N	2018-06-24 10:14:14.159249-06
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
419	a	to	toward	\N	2018-06-24 10:16:56.797247-06
415	me	me	to me	\N	2018-06-24 09:42:32.340438-06
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
2	2	create leaf tables	SQL	V2__create_leaf_tables.sql	988272324	postgres	2018-06-26 13:37:25.326783	51	t
1	1	create goals and cards	SQL	V1__create_goals_and_cards.sql	-13256656	postgres	2018-06-26 13:37:25.271006	29	t
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

