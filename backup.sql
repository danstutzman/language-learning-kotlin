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

ALTER TABLE ONLY public.leafs DROP CONSTRAINT fk_leafs_leafs_es_mixed;
DROP INDEX public.schema_version_s_idx;
DROP INDEX public.idx_leafs_nonverbs_en_plural_and_en_disambiguation;
DROP INDEX public.idx_leafs_nonverbs_en_and_en_disambiguation;
DROP INDEX public.idx_leafs_infinitives_en_past_and_en_disambiguation;
DROP INDEX public.idx_leafs_infinitives_en_and_en_disambiguation;
DROP INDEX public.idx_leafs_es_mixed;
DROP INDEX public.idx_leafs_es_lower;
DROP INDEX public.idx_cards_leaf_ids_csv;
ALTER TABLE ONLY public.schema_version DROP CONSTRAINT schema_version_pk;
ALTER TABLE ONLY public.leafs DROP CONSTRAINT leafs_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_pkey;
ALTER TABLE public.leafs ALTER COLUMN leaf_id DROP DEFAULT;
ALTER TABLE public.goals ALTER COLUMN goal_id DROP DEFAULT;
ALTER TABLE public.cards ALTER COLUMN card_id DROP DEFAULT;
DROP TABLE public.schema_version;
DROP SEQUENCE public.leafs_leaf_id_seq;
DROP TABLE public.leafs;
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
    leaf_ids_csv text NOT NULL,
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
-- Name: leafs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE leafs (
    leaf_id integer NOT NULL,
    leaf_type text NOT NULL,
    es_mixed text NOT NULL,
    en text NOT NULL,
    en_disambiguation text NOT NULL,
    en_plural text,
    en_past text,
    infinitive_es_mixed text,
    number integer,
    person integer,
    tense text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT leafs_check CHECK ((NOT ((leaf_type = 'Inf'::text) AND (en_past IS NULL)))),
    CONSTRAINT leafs_check1 CHECK ((NOT ((leaf_type = ANY (ARRAY['StemChange'::text, 'UniqV'::text])) AND (infinitive_es_mixed IS NULL)))),
    CONSTRAINT leafs_check2 CHECK ((NOT ((leaf_type = 'UniqV'::text) AND (number IS NULL)))),
    CONSTRAINT leafs_check3 CHECK ((NOT ((leaf_type = 'UniqV'::text) AND (person IS NULL)))),
    CONSTRAINT leafs_check4 CHECK ((NOT ((leaf_type = ANY (ARRAY['StemChange'::text, 'UniqV'::text])) AND (tense <> ALL (ARRAY['PRES'::text, 'PRET'::text]))))),
    CONSTRAINT leafs_leaf_type_check CHECK ((leaf_type = ANY (ARRAY['Inf'::text, 'Nonverb'::text, 'StemChange'::text, 'UniqV'::text])))
);


ALTER TABLE leafs OWNER TO postgres;

--
-- Name: leafs_leaf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE leafs_leaf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE leafs_leaf_id_seq OWNER TO postgres;

--
-- Name: leafs_leaf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE leafs_leaf_id_seq OWNED BY leafs.leaf_id;


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
-- Name: cards card_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cards ALTER COLUMN card_id SET DEFAULT nextval('cards_card_id_seq'::regclass);


--
-- Name: goals goal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY goals ALTER COLUMN goal_id SET DEFAULT nextval('goals_goal_id_seq'::regclass);


--
-- Name: leafs leaf_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY leafs ALTER COLUMN leaf_id SET DEFAULT nextval('leafs_leaf_id_seq'::regclass);


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

COPY goals (goal_id, tags_csv, en, es, leaf_ids_csv, created_at, updated_at) FROM stdin;
27		Good morning!	buenos días	387,382	2018-06-26 21:22:40.515651-06	2018-06-26 21:22:40.514-06
28		Good afternoon!	buenas tardes	388,383	2018-06-26 21:22:50.192679-06	2018-06-26 21:22:50.192-06
29		I'm a software engineer.	soy ingeniero de software	453,384,409,412	2018-06-26 21:22:57.329518-06	2018-06-26 21:22:57.328-06
30		Where do you live?	dónde vives	410,349,-12	2018-06-26 21:23:03.214123-06	2018-06-26 21:23:03.213-06
31		I speak Spanish.	hablo español	327,-1,380	2018-06-26 21:23:11.350261-06	2018-06-26 21:23:11.349-06
32		I speak English.	hablo inglés	327,-1,381	2018-06-26 21:23:18.507478-06	2018-06-26 21:23:18.506-06
34		What are you doing?	qué haces	407,328,-12	2018-06-26 21:23:38.528733-06	2018-06-26 21:23:38.527-06
35		I'm doing well.	estoy bien	463,398	2018-06-26 21:23:47.703565-06	2018-06-26 21:23:47.702-06
36		Hello!	hola	408	2018-06-26 21:23:53.901388-06	2018-06-26 21:23:53.9-06
37		I live in Longmont.	vivo en Longmont	349,-11,329,-14,417	2018-06-26 21:24:01.726953-06	2018-06-26 21:24:01.726-06
38		I moved to Longmont in January.	me mudé a Longmont en enero	415,351,-6,419,417,329,-14,423	2018-06-26 21:24:09.59708-06	2018-06-26 21:24:09.596-06
39		I made a list of sentences to learn.	hice una lista de oraciones para aprender	451,-22,392,385,409,386,421,316	2018-06-26 21:24:23.11975-06	2018-06-26 21:24:23.119-06
40		I visited Cuba for a few weeks.	visité Cuba por unas semanas	347,-6,418,420,426,428	2018-06-26 21:24:31.951121-06	2018-06-26 21:24:31.95-06
41		Who do you want to speak Spanish with?	con quién quieres hablar español	413,414,431,-12,327,380	2018-06-26 21:24:42.761378-06	2018-06-26 21:24:42.76-06
42		Where did you learn Spanish?	dónde aprendiste español	410,316,-16,380	2018-06-26 21:24:51.422015-06	2018-06-26 21:24:51.421-06
43		I created a mobile app to study Spanish.	creé una aplicación móvil para estudiar español	352,-6,392,424,427,421,353,380	2018-06-26 21:25:00.156027-06	2018-06-26 21:25:00.155-06
44		I took a class in Spanish.	asistí una clase de español	350,-15,392,422,409,380	2018-06-26 21:25:14.854279-06	2018-06-26 21:25:14.851-06
45		I study Spanish.	estudio español	353,-1,380	2018-06-27 08:50:29.172548-06	2018-06-27 08:50:29.163-06
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 45, true);


--
-- Data for Name: leafs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY leafs (leaf_id, leaf_type, es_mixed, en, en_disambiguation, en_plural, en_past, infinitive_es_mixed, number, person, tense, created_at) FROM stdin;
315	Inf	andar	walk		\N	walked	\N	\N	\N	\N	2018-06-24 09:57:33.983446-06
316	Inf	aprender	learn		\N	learned	\N	\N	\N	\N	2018-06-24 09:57:33.984734-06
317	Inf	comer	eat		\N	ate	\N	\N	\N	\N	2018-06-24 09:57:33.985347-06
318	Inf	conocer	know	be able to	\N	knew	\N	\N	\N	\N	2018-06-24 09:57:33.986019-06
319	Inf	contar	tell		\N	told	\N	\N	\N	\N	2018-06-24 09:57:33.98678-06
320	Inf	dar	give		\N	gave	\N	\N	\N	\N	2018-06-24 09:57:33.987309-06
321	Inf	decir	say		\N	said	\N	\N	\N	\N	2018-06-24 09:57:33.987899-06
322	Inf	empezar	start		\N	started	\N	\N	\N	\N	2018-06-24 09:57:33.988574-06
323	Inf	encontrar	find		\N	found	\N	\N	\N	\N	2018-06-24 09:57:33.994568-06
324	Inf	entender	understand		\N	understood	\N	\N	\N	\N	2018-06-24 09:57:34.000548-06
325	Inf	enviar	send		\N	sent	\N	\N	\N	\N	2018-06-24 09:57:34.006513-06
326	Inf	estar	be	be (how)	\N	was	\N	\N	\N	\N	2018-06-24 09:57:34.012434-06
327	Inf	hablar	speak		\N	spoke	\N	\N	\N	\N	2018-06-24 09:57:34.017548-06
328	Inf	hacer	do		\N	did	\N	\N	\N	\N	2018-06-24 09:57:34.018056-06
329	Inf	ir	go		\N	went	\N	\N	\N	\N	2018-06-24 09:57:34.018688-06
330	Inf	parecer	seem		\N	seemed	\N	\N	\N	\N	2018-06-24 09:57:34.019227-06
331	Inf	pedir	request		\N	requested	\N	\N	\N	\N	2018-06-24 09:57:34.019677-06
332	Inf	pensar	think		\N	thought	\N	\N	\N	\N	2018-06-24 09:57:34.020182-06
333	Inf	poder	can		\N	could	\N	\N	\N	\N	2018-06-24 09:57:34.020785-06
334	Inf	poner	put		\N	put	\N	\N	\N	\N	2018-06-24 09:57:34.021223-06
335	Inf	preguntar	ask		\N	asked	\N	\N	\N	\N	2018-06-24 09:57:34.021846-06
336	Inf	querer	want		\N	wanted	\N	\N	\N	\N	2018-06-24 09:57:34.022716-06
337	Inf	recordar	remember		\N	remembered	\N	\N	\N	\N	2018-06-24 09:57:34.023446-06
338	Inf	saber	know	know (thing)	\N	knew	\N	\N	\N	\N	2018-06-24 09:57:34.024181-06
339	Inf	salir	go out		\N	went out	\N	\N	\N	\N	2018-06-24 09:57:34.02479-06
340	Inf	seguir	follow		\N	followed	\N	\N	\N	\N	2018-06-24 09:57:34.025256-06
341	Inf	sentir	feel		\N	felt	\N	\N	\N	\N	2018-06-24 09:57:34.026079-06
342	Inf	ser	be	be (what)	\N	was	\N	\N	\N	\N	2018-06-24 09:57:34.026682-06
343	Inf	tener	have		\N	had	\N	\N	\N	\N	2018-06-24 09:57:34.027222-06
344	Inf	trabajar	work		\N	worked	\N	\N	\N	\N	2018-06-24 09:57:34.027967-06
345	Inf	ver	see		\N	saw	\N	\N	\N	\N	2018-06-24 09:57:34.028806-06
346	Inf	venir	come		\N	came	\N	\N	\N	\N	2018-06-24 09:57:34.029696-06
347	Inf	visitar	visit		\N	visited	\N	\N	\N	\N	2018-06-24 09:57:34.030334-06
348	Inf	volver	return		\N	returned	\N	\N	\N	\N	2018-06-24 09:57:34.031357-06
349	Inf	vivir	live		\N	lived	\N	\N	\N	\N	2018-06-24 10:12:18.679112-06
350	Inf	asistir	attend		\N	attended	\N	\N	\N	\N	2018-06-24 10:15:03.427516-06
351	Inf	mudar	move		\N	moved	\N	\N	\N	\N	2018-06-24 10:16:29.743042-06
352	Inf	crear	create		\N	created	\N	\N	\N	\N	2018-06-24 10:17:19.293622-06
353	Inf	estudiar	study		\N	studied	\N	\N	\N	\N	2018-06-24 10:21:48.839702-06
383	Nonverb	tarde	afternoon		afternoons	\N	\N	\N	\N	\N	2018-06-24 09:42:32.325038-06
354	Nonverb	brazo	arm		arms	\N	\N	\N	\N	\N	2018-06-24 09:42:32.310062-06
355	Nonverb	pierna	leg		legs	\N	\N	\N	\N	\N	2018-06-24 09:42:32.31134-06
356	Nonverb	corazón	heart		hearts	\N	\N	\N	\N	\N	2018-06-24 09:42:32.311925-06
357	Nonverb	estómago	stomach		stomachs	\N	\N	\N	\N	\N	2018-06-24 09:42:32.312547-06
358	Nonverb	ojo	eye		eyes	\N	\N	\N	\N	\N	2018-06-24 09:42:32.313039-06
359	Nonverb	nariz	nose		noses	\N	\N	\N	\N	\N	2018-06-24 09:42:32.313538-06
360	Nonverb	boca	mouth		mouths	\N	\N	\N	\N	\N	2018-06-24 09:42:32.31404-06
361	Nonverb	oreja	ear		ears	\N	\N	\N	\N	\N	2018-06-24 09:42:32.314516-06
362	Nonverb	cara	face		faces	\N	\N	\N	\N	\N	2018-06-24 09:42:32.314983-06
363	Nonverb	cuello	neck		necks	\N	\N	\N	\N	\N	2018-06-24 09:42:32.315436-06
364	Nonverb	dedo	finger		fingers	\N	\N	\N	\N	\N	2018-06-24 09:42:32.315907-06
365	Nonverb	pie	foot		feet	\N	\N	\N	\N	\N	2018-06-24 09:42:32.316363-06
366	Nonverb	muslo	thigh		thighs	\N	\N	\N	\N	\N	2018-06-24 09:42:32.316797-06
367	Nonverb	tobillo	ankle		ankles	\N	\N	\N	\N	\N	2018-06-24 09:42:32.317247-06
368	Nonverb	codo	elbow		elbows	\N	\N	\N	\N	\N	2018-06-24 09:42:32.317698-06
369	Nonverb	muñeca	wrist		wrists	\N	\N	\N	\N	\N	2018-06-24 09:42:32.318139-06
370	Nonverb	cuerpo	body		bodies	\N	\N	\N	\N	\N	2018-06-24 09:42:32.318608-06
371	Nonverb	diente	tooth		tooths	\N	\N	\N	\N	\N	2018-06-24 09:42:32.319075-06
372	Nonverb	mano	hand		hands	\N	\N	\N	\N	\N	2018-06-24 09:42:32.319518-06
373	Nonverb	espalda	back		backs	\N	\N	\N	\N	\N	2018-06-24 09:42:32.31995-06
374	Nonverb	cadera	hip		hips	\N	\N	\N	\N	\N	2018-06-24 09:42:32.320412-06
375	Nonverb	mandíbula	jaw		jaws	\N	\N	\N	\N	\N	2018-06-24 09:42:32.320864-06
376	Nonverb	hombro	shoulder		shoulders	\N	\N	\N	\N	\N	2018-06-24 09:42:32.321315-06
377	Nonverb	pulgar	thumb		thumbs	\N	\N	\N	\N	\N	2018-06-24 09:42:32.321761-06
378	Nonverb	lengua	tongue		tongues	\N	\N	\N	\N	\N	2018-06-24 09:42:32.322202-06
379	Nonverb	garganta	throat		throats	\N	\N	\N	\N	\N	2018-06-24 09:42:32.322985-06
380	Nonverb	español	Spanish		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.323407-06
381	Nonverb	inglés	English		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.323906-06
382	Nonverb	día	day		days	\N	\N	\N	\N	\N	2018-06-24 09:42:32.324572-06
384	Nonverb	ingeniero	engineer		engineers	\N	\N	\N	\N	\N	2018-06-24 09:42:32.325593-06
385	Nonverb	lista	list		lists	\N	\N	\N	\N	\N	2018-06-24 09:42:32.326072-06
386	Nonverb	oración	sentence		sentences	\N	\N	\N	\N	\N	2018-06-24 09:42:32.326465-06
387	Nonverb	bueno	good	masc.	good	\N	\N	\N	\N	\N	2018-06-24 09:42:32.326926-06
388	Nonverb	buena	good	fem.	good	\N	\N	\N	\N	\N	2018-06-24 09:42:32.327412-06
389	Nonverb	el	the	masc.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.327897-06
390	Nonverb	la	the	fem.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.32839-06
391	Nonverb	un	a	masc.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.328869-06
392	Nonverb	una	a	fem.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.329419-06
393	Nonverb	mi	my		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.329823-06
394	Nonverb	este	this	masc.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.330276-06
395	Nonverb	esta	this	fem.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33074-06
396	Nonverb	cada	every		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.331212-06
397	Nonverb	cómo	how		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.331646-06
398	Nonverb	bien	well		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.332094-06
399	Nonverb	yo	I		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.332558-06
400	Nonverb	tú	you	pronoun	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33304-06
401	Nonverb	él	he		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33464-06
402	Nonverb	ella	she		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.335082-06
403	Nonverb	nosotros	we	masc.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.335483-06
404	Nonverb	nosotras	we	fem.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.335885-06
405	Nonverb	ellos	they	masc.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33628-06
406	Nonverb	ellas	they	fem.	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.336675-06
407	Nonverb	qué	what		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.337066-06
408	Nonverb	hola	hello		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.337468-06
409	Nonverb	de	of		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.337867-06
410	Nonverb	dónde	where	question	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.338256-06
411	Nonverb	donde	where	relative	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.338645-06
412	Nonverb	software	software		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.339084-06
413	Nonverb	con	with		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.339496-06
414	Nonverb	quién	who		\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.339963-06
416	Nonverb	te	you	direct/indirect object	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.340855-06
417	Nonverb	Longmont	Longmont		\N	\N	\N	\N	\N	\N	2018-06-24 10:12:57.81832-06
418	Nonverb	Cuba	Cuba		\N	\N	\N	\N	\N	\N	2018-06-24 10:14:14.159249-06
420	Nonverb	por	for	on behalf of	\N	\N	\N	\N	\N	\N	2018-06-24 10:18:21.748271-06
421	Nonverb	para	for	in order to	\N	\N	\N	\N	\N	\N	2018-06-24 10:18:37.720114-06
422	Nonverb	clase	class		classes	\N	\N	\N	\N	\N	2018-06-24 10:18:54.790579-06
423	Nonverb	enero	January		\N	\N	\N	\N	\N	\N	2018-06-24 10:19:36.45117-06
424	Nonverb	aplicación	application		applications	\N	\N	\N	\N	\N	2018-06-24 10:19:47.157449-06
425	Nonverb	unos	some	masc.	\N	\N	\N	\N	\N	\N	2018-06-24 10:20:00.535063-06
426	Nonverb	unas	some	fem.	\N	\N	\N	\N	\N	\N	2018-06-24 10:20:07.365061-06
427	Nonverb	móvil	mobile phone		mobile phones	\N	\N	\N	\N	\N	2018-06-24 10:20:48.975803-06
428	Nonverb	semana	week		weeks	\N	\N	\N	\N	\N	2018-06-24 10:21:05.140751-06
497	Nonverb	piel	skin		\N	\N	\N	\N	\N	\N	2018-06-26 20:37:34.949585-06
419	Nonverb	a	to	toward	\N	\N	\N	\N	\N	\N	2018-06-24 10:16:56.797247-06
415	Nonverb	me	me	to me	\N	\N	\N	\N	\N	\N	2018-06-24 09:42:32.340438-06
429	StemChange	pued-	can		\N	could	poder	\N	\N	PRES	2018-06-24 11:26:43.651439-06
430	StemChange	tien-	have		\N	had	tener	\N	\N	PRES	2018-06-24 11:26:43.803834-06
431	StemChange	quier-	want		\N	wanted	querer	\N	\N	PRES	2018-06-24 11:26:43.804733-06
432	StemChange	sig-	follow		\N	followed	seguir	\N	\N	PRES	2018-06-24 11:26:43.805456-06
433	StemChange	encuentr-	find		\N	found	encontrar	\N	\N	PRES	2018-06-24 11:26:43.806086-06
434	StemChange	vien-	come		\N	came	venir	\N	\N	PRES	2018-06-24 11:26:43.806698-06
435	StemChange	piens-	think		\N	thought	pensar	\N	\N	PRES	2018-06-24 11:26:43.807283-06
436	StemChange	vuelv-	return		\N	returned	volver	\N	\N	PRES	2018-06-24 11:26:43.807795-06
437	StemChange	sient-	feel		\N	felt	sentir	\N	\N	PRES	2018-06-24 11:26:43.808329-06
438	StemChange	cuent-	tell		\N	told	contar	\N	\N	PRES	2018-06-24 11:26:43.808861-06
439	StemChange	empiez-	start		\N	started	empezar	\N	\N	PRES	2018-06-24 11:26:43.809358-06
440	StemChange	dic-	say		\N	said	decir	\N	\N	PRES	2018-06-24 11:26:43.809844-06
441	StemChange	recuerd-	remember		\N	remembered	recordar	\N	\N	PRES	2018-06-24 11:26:43.810424-06
442	StemChange	pid-	request		\N	requested	pedir	\N	\N	PRES	2018-06-24 11:26:43.81091-06
443	StemChange	entiend-	understand		\N	understood	entender	\N	\N	PRES	2018-06-24 11:26:43.811642-06
444	StemChange	anduv-	walk		\N	walked	andar	\N	\N	PRET	2018-06-24 11:26:43.812328-06
445	StemChange	sup-	know		\N	knew	saber	\N	\N	PRET	2018-06-24 11:26:43.812976-06
446	StemChange	quis-	want		\N	wanted	querer	\N	\N	PRET	2018-06-24 11:26:43.81373-06
447	StemChange	pus-	put		\N	put	poner	\N	\N	PRET	2018-06-24 11:26:43.814224-06
448	StemChange	vin-	come		\N	came	venir	\N	\N	PRET	2018-06-24 11:26:43.814936-06
449	StemChange	dij-	say		\N	said	decir	\N	\N	PRET	2018-06-24 11:26:43.815792-06
450	StemChange	tuv-	have		\N	had	tener	\N	\N	PRET	2018-06-24 11:26:43.816356-06
451	StemChange	hic-	do		\N	did	hacer	\N	\N	PRET	2018-06-24 11:26:43.816942-06
452	StemChange	pud-	can		\N	could	poder	\N	\N	PRET	2018-06-24 11:26:43.817449-06
453	UniqV	soy	am		\N	\N	ser	1	1	PRES	2018-06-24 10:53:11.331513-06
454	UniqV	eres	are		\N	\N	ser	1	2	PRES	2018-06-24 10:53:11.334102-06
455	UniqV	es	is		\N	\N	ser	1	3	PRES	2018-06-24 10:53:11.334799-06
456	UniqV	somos	are		\N	\N	ser	2	1	PRES	2018-06-24 10:53:11.335596-06
457	UniqV	son	are		\N	\N	ser	2	3	PRES	2018-06-24 10:53:11.336235-06
458	UniqV	fui	was		\N	\N	ser	1	1	PRET	2018-06-24 10:53:11.336833-06
459	UniqV	fuiste	were		\N	\N	ser	1	2	PRET	2018-06-24 10:53:11.337566-06
460	UniqV	fue	was		\N	\N	ser	1	3	PRET	2018-06-24 10:53:11.338114-06
461	UniqV	fuimos	were		\N	\N	ser	2	1	PRET	2018-06-24 10:53:11.338658-06
462	UniqV	fueron	were		\N	\N	ser	2	3	PRET	2018-06-24 10:53:11.339177-06
463	UniqV	estoy	am		\N	\N	estar	1	1	PRES	2018-06-24 10:53:11.339723-06
464	UniqV	estás	are		\N	\N	estar	1	2	PRES	2018-06-24 10:53:11.340233-06
465	UniqV	está	is		\N	\N	estar	1	3	PRES	2018-06-24 10:53:11.340796-06
466	UniqV	están	are		\N	\N	estar	2	3	PRES	2018-06-24 10:53:11.341339-06
467	UniqV	tengo	have		\N	\N	tener	1	1	PRES	2018-06-24 10:53:11.341841-06
468	UniqV	hago	do		\N	\N	hacer	1	1	PRES	2018-06-24 10:53:11.342385-06
469	UniqV	digo	say		\N	\N	decir	1	1	PRES	2018-06-24 10:53:11.34283-06
470	UniqV	dijeron	said		\N	\N	decir	2	3	PRET	2018-06-24 10:53:11.343357-06
471	UniqV	voy	go		\N	\N	ir	1	1	PRES	2018-06-24 10:53:11.343851-06
472	UniqV	vas	go		\N	\N	ir	1	2	PRES	2018-06-24 10:53:11.344385-06
473	UniqV	va	goes		\N	\N	ir	1	3	PRES	2018-06-24 10:53:11.34485-06
474	UniqV	vamos	go		\N	\N	ir	2	1	PRES	2018-06-24 10:53:11.345309-06
475	UniqV	van	go		\N	\N	ir	2	3	PRES	2018-06-24 10:53:11.345931-06
476	UniqV	veo	see		\N	\N	ver	1	1	PRES	2018-06-24 10:53:11.346443-06
477	UniqV	vi	saw		\N	\N	ver	1	1	PRET	2018-06-24 10:53:11.346938-06
478	UniqV	vio	saw		\N	\N	ver	1	3	PRET	2018-06-24 10:53:11.347455-06
479	UniqV	vimos	saw		\N	\N	ver	2	1	PRET	2018-06-24 10:53:11.347861-06
480	UniqV	doy	give		\N	\N	dar	1	1	PRES	2018-06-24 10:53:11.348332-06
481	UniqV	di	gave		\N	\N	dar	1	1	PRET	2018-06-24 10:53:11.348782-06
482	UniqV	diste	gave		\N	\N	dar	1	2	PRET	2018-06-24 10:53:11.349211-06
483	UniqV	dio	gave		\N	\N	dar	1	3	PRET	2018-06-24 10:53:11.349614-06
484	UniqV	dimos	gave		\N	\N	dar	2	1	PRET	2018-06-24 10:53:11.349999-06
485	UniqV	dieron	gave		\N	\N	dar	2	3	PRET	2018-06-24 10:53:11.350387-06
486	UniqV	sé	know		\N	\N	saber	1	1	PRES	2018-06-24 10:53:11.350775-06
487	UniqV	pongo	put		\N	\N	poner	1	1	PRES	2018-06-24 10:53:11.351199-06
488	UniqV	vengo	come		\N	\N	venir	1	1	PRES	2018-06-24 10:53:11.351597-06
489	UniqV	salgo	go out		\N	\N	salir	1	1	PRES	2018-06-24 10:53:11.351985-06
490	UniqV	parezco	look like		\N	\N	parecer	1	1	PRES	2018-06-24 10:53:11.352406-06
491	UniqV	conozco	know		\N	\N	conocer	1	1	PRES	2018-06-24 10:53:11.352811-06
492	UniqV	empecé	started		\N	\N	empezar	1	1	PRET	2018-06-24 10:53:11.353348-06
493	UniqV	envío	sent		\N	\N	enviar	1	1	PRES	2018-06-24 10:53:11.354736-06
494	UniqV	envías	sent		\N	\N	enviar	1	2	PRES	2018-06-24 10:53:11.355389-06
495	UniqV	envía	sent		\N	\N	enviar	1	3	PRES	2018-06-24 10:53:11.355845-06
496	UniqV	envían	sent		\N	\N	enviar	2	1	PRES	2018-06-24 10:53:11.356343-06
\.


--
-- Name: leafs_leaf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('leafs_leaf_id_seq', 497, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create goals and cards	SQL	V1__create_goals_and_cards.sql	-13256656	postgres	2018-06-27 09:31:17.379663	46	t
2	2	create leaf tables	SQL	V2__create_leaf_tables.sql	779524700	postgres	2018-06-27 09:31:17.474367	34	t
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
-- Name: leafs leafs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY leafs
    ADD CONSTRAINT leafs_pkey PRIMARY KEY (leaf_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: idx_cards_leaf_ids_csv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cards_leaf_ids_csv ON cards USING btree (leaf_ids_csv);


--
-- Name: idx_leafs_es_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_es_lower ON leafs USING btree (lower(es_mixed));


--
-- Name: idx_leafs_es_mixed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_es_mixed ON leafs USING btree (es_mixed);


--
-- Name: idx_leafs_infinitives_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_infinitives_en_and_en_disambiguation ON leafs USING btree (en, en_disambiguation) WHERE (leaf_type = 'Inf'::text);


--
-- Name: idx_leafs_infinitives_en_past_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_infinitives_en_past_and_en_disambiguation ON leafs USING btree (en_past, en_disambiguation) WHERE (leaf_type = 'Inf'::text);


--
-- Name: idx_leafs_nonverbs_en_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_nonverbs_en_and_en_disambiguation ON leafs USING btree (en, en_disambiguation) WHERE (leaf_type = 'Nonverb'::text);


--
-- Name: idx_leafs_nonverbs_en_plural_and_en_disambiguation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_nonverbs_en_plural_and_en_disambiguation ON leafs USING btree (en_plural, en_disambiguation) WHERE (leaf_type = 'Nonverb'::text);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX schema_version_s_idx ON schema_version USING btree (success);


--
-- Name: leafs fk_leafs_leafs_es_mixed; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY leafs
    ADD CONSTRAINT fk_leafs_leafs_es_mixed FOREIGN KEY (infinitive_es_mixed) REFERENCES leafs(es_mixed);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

