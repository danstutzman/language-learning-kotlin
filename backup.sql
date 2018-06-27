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
    updated_at timestamp with time zone NOT NULL,
    goal_card_ids_json text NOT NULL,
    gloss_rows_json text NOT NULL
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
122	[{"leafId":387,"en":"good","es":"buenos"},{"leafId":382,"en":"days","es":"días"}]	2018-06-27 14:00:39-06	387,382	Good morning!	4		2018-06-26 21:22:40.532507-06	2018-06-27 14:08:09.09-06
123	[{"leafId":387,"en":"good","es":"buenos"}]	2018-06-27 14:00:37-06	387	good (masc.)	4		2018-06-26 21:22:40.532507-06	2018-06-27 14:08:09.101-06
124	[{"leafId":382,"en":"days","es":"días"}]	2018-06-27 14:00:35-06	382	days	4		2018-06-26 21:22:40.532507-06	2018-06-27 14:08:09.108-06
125	[{"leafId":388,"en":"good","es":"buenas"},{"leafId":383,"en":"afternoons","es":"tardes"}]	2018-06-27 14:00:33-06	388,383	Good afternoon!	4		2018-06-26 21:22:50.209001-06	2018-06-27 14:08:09.115-06
126	[{"leafId":388,"en":"good","es":"buenas"}]	2018-06-27 14:00:30-06	388	good (fem.)	4		2018-06-26 21:22:50.209001-06	2018-06-27 14:08:09.116-06
128	[{"leafId":453,"en":"am","es":"soy"},{"leafId":384,"en":"engineer","es":"ingeniero"},{"leafId":409,"en":"of","es":"de"},{"leafId":412,"en":"software","es":"software"}]	2018-06-27 12:34:37-06	453,384,409,412	I'm a software engineer.	0		2018-06-26 21:22:57.352948-06	2018-06-27 14:08:09.12-06
185	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"},{"leafId":392,"en":"a","es":"una"},{"leafId":385,"en":"list","es":"lista"},{"leafId":409,"en":"of","es":"de"},{"leafId":386,"en":"sentences","es":"oraciones"},{"leafId":421,"en":"for","es":"para"},{"leafId":316,"en":"learn","es":"aprender"}]	2018-06-27 12:22:53-06	451,-22,392,385,409,386,421,316	I made a list of sentences to learn.	0		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.159-06
127	[{"leafId":383,"en":"afternoons","es":"tardes"}]	2018-06-27 14:00:28-06	383	afternoons	4		2018-06-26 21:22:50.209001-06	2018-06-27 14:08:09.118-06
129	[{"leafId":453,"en":"am","es":"soy"}]	2018-06-27 14:00:10-06	453	(I) to be (be (what))	3		2018-06-26 21:22:57.352948-06	2018-06-27 14:08:09.121-06
130	[{"leafId":384,"en":"engineer","es":"ingeniero"}]	2018-06-27 13:59:51-06	384	engineer	4		2018-06-26 21:22:57.352948-06	2018-06-27 14:08:09.122-06
131	[{"leafId":409,"en":"of","es":"de"}]	2018-06-27 13:59:49-06	409	of	4		2018-06-26 21:22:57.352948-06	2018-06-27 14:08:09.123-06
132	[{"leafId":412,"en":"software","es":"software"}]	2018-06-27 13:59:47-06	412	software	4		2018-06-26 21:22:57.352948-06	2018-06-27 14:08:09.124-06
133	[{"leafId":342,"en":"be","es":"ser"}]	2018-06-27 14:00:00-06	342	to be (be (what))	3		2018-06-26 21:22:57.352948-06	2018-06-27 14:08:09.125-06
134	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:32-06	410,349,-12	Where do you live?	0		2018-06-26 21:23:03.228956-06	2018-06-27 14:08:09.127-06
136	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:28-06	349,-12	(you) live	0		2018-06-26 21:23:03.228956-06	2018-06-27 14:08:09.129-06
137	[{"leafId":349,"en":"live","es":"vivir"}]	2018-06-27 13:59:43-06	349	to live	4		2018-06-26 21:23:03.228956-06	2018-06-27 14:08:09.13-06
138	[{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-27 14:07:42-06	-12	(you) eat (comer)	3		2018-06-26 21:23:03.228956-06	2018-06-27 14:08:09.131-06
135	[{"leafId":410,"en":"where","es":"dónde"}]	2018-06-27 13:59:45-06	410	where (question)	4		2018-06-26 21:23:03.228956-06	2018-06-27 14:08:09.128-06
140	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-26 21:29:05-06	327,-1	(I) speak	0		2018-06-26 21:23:11.364754-06	2018-06-27 14:08:09.133-06
141	[{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 13:59:41-06	380	Spanish	4		2018-06-26 21:23:11.364754-06	2018-06-27 14:08:09.134-06
142	[{"leafId":327,"en":"speak","es":"hablar"}]	2018-06-27 13:59:36-06	327	to speak	3		2018-06-26 21:23:11.364754-06	2018-06-27 14:08:09.135-06
143	[{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-27 13:59:33-06	-1	(I) talk (hablar)	3		2018-06-26 21:23:11.364754-06	2018-06-27 14:08:09.136-06
144	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":381,"en":"English","es":"inglés"}]	2018-06-26 21:29:07-06	327,-1,381	I speak English.	0		2018-06-26 21:23:18.524111-06	2018-06-27 14:08:09.137-06
146	[{"leafId":381,"en":"English","es":"inglés"}]	2018-06-27 13:59:31-06	381	English	4		2018-06-26 21:23:18.524111-06	2018-06-27 14:08:09.138-06
151	[{"leafId":464,"en":"are","es":"estás"}]	2018-06-27 13:59:28-06	464	(you) to be (be (how))	3		2018-06-26 21:23:25.706003-06	2018-06-27 14:08:09.139-06
152	[{"leafId":317,"en":"eat","es":"comer"}]	2018-06-27 13:59:24-06	317	to eat	3		2018-06-26 21:23:25.706003-06	2018-06-27 14:08:09.14-06
153	[{"leafId":-11,"en":"(I)","es":"-o"}]	2018-06-27 14:08:00-06	-11	(I) eat (comer)	3		2018-06-26 21:23:25.706003-06	2018-06-27 14:08:09.141-06
139	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:10-06	327,-1,380	I speak Spanish.	0		2018-06-26 21:23:11.364754-06	2018-06-27 14:08:09.132-06
155	[{"leafId":407,"en":"what","es":"qué"},{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:18-06	407,328,-12	What are you doing?	0		2018-06-26 21:23:38.542987-06	2018-06-27 14:08:09.143-06
156	[{"leafId":407,"en":"what","es":"qué"}]	2018-06-27 13:59:14-06	407	what	4		2018-06-26 21:23:38.542987-06	2018-06-27 14:08:09.144-06
157	[{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:15-06	328,-12	(you) do	0		2018-06-26 21:23:38.542987-06	2018-06-27 14:08:09.145-06
158	[{"leafId":328,"en":"do","es":"hacer"}]	2018-06-27 13:59:11-06	328	to do	3		2018-06-26 21:23:38.542987-06	2018-06-27 14:08:09.146-06
160	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":398,"en":"well","es":"bien"}]	2018-06-26 21:27:55-06	463,398	I'm doing well.	0		2018-06-26 21:23:47.71726-06	2018-06-27 14:08:09.147-06
161	[{"leafId":463,"en":"am","es":"estoy"}]	2018-06-27 13:59:01-06	463	(I) to be (be (how))	3		2018-06-26 21:23:47.71726-06	2018-06-27 14:08:09.148-06
162	[{"leafId":398,"en":"well","es":"bien"}]	2018-06-27 13:58:57-06	398	well	3		2018-06-26 21:23:47.71726-06	2018-06-27 14:08:09.149-06
164	[{"leafId":408,"en":"hello","es":"hola"}]	2018-06-27 13:58:56-06	408	Hello!	4		2018-06-26 21:23:53.914204-06	2018-06-27 14:08:09.15-06
167	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"}]	2018-06-26 21:29:25-06	349,-11	(I) live	0		2018-06-26 21:24:01.746243-06	2018-06-27 14:08:09.151-06
169	[{"leafId":417,"en":"Longmont","es":"Longmont"}]	2018-06-27 13:58:54-06	417	Longmont	4		2018-06-26 21:24:01.746243-06	2018-06-27 14:08:09.152-06
175	[{"leafId":415,"en":"me","es":"me"}]	2018-06-27 13:58:52-06	415	me (to me)	4		2018-06-26 21:24:09.613753-06	2018-06-27 14:08:09.153-06
176	[{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 13:58:50-06	351,-6	(I) moved	4		2018-06-26 21:24:09.613753-06	2018-06-27 14:08:09.154-06
177	[{"leafId":419,"en":"to","es":"a"}]	2018-06-27 13:58:48-06	419	to (toward)	4		2018-06-26 21:24:09.613753-06	2018-06-27 14:08:09.155-06
180	[{"leafId":423,"en":"January","es":"enero"}]	2018-06-27 13:58:46-06	423	January	4		2018-06-26 21:24:09.613753-06	2018-06-27 14:08:09.156-06
181	[{"leafId":351,"en":"move","es":"mudar"}]	2018-06-27 13:58:42-06	351	to move	4		2018-06-26 21:24:09.613753-06	2018-06-27 14:08:09.157-06
182	[{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 13:58:38-06	-6	(I) talked (hablar)	4		2018-06-26 21:24:09.613753-06	2018-06-27 14:08:09.158-06
186	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"}]	2018-06-26 21:27:01-06	451,-22	(I) did	0		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.16-06
187	[{"leafId":392,"en":"a","es":"una"}]	2018-06-27 13:58:36-06	392	a (fem.)	4		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.161-06
188	[{"leafId":385,"en":"list","es":"lista"}]	2018-06-27 13:58:34-06	385	list	4		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.163-06
190	[{"leafId":386,"en":"sentences","es":"oraciones"}]	2018-06-27 13:58:32-06	386	sentences	4		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.164-06
191	[{"leafId":421,"en":"for","es":"para"}]	2018-06-27 13:58:31-06	421	for (in order to)	4		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.165-06
192	[{"leafId":316,"en":"learn","es":"aprender"}]	2018-06-27 13:58:28-06	316	to learn	4		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.166-06
193	[{"leafId":451,"en":"did","es":"hic-"}]	2018-06-27 13:58:20-06	451	Stem change for hacer in PRET	3		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.167-06
194	[{"leafId":-22,"en":"(I)","es":"-e"}]	2018-06-27 13:57:51-06	-22	(I) had (tener)	3		2018-06-26 21:24:23.139561-06	2018-06-27 14:08:09.168-06
196	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":418,"en":"Cuba","es":"Cuba"},{"leafId":420,"en":"for","es":"por"},{"leafId":426,"en":"some","es":"unas"},{"leafId":428,"en":"weeks","es":"semanas"}]	2018-06-26 21:27:10-06	347,-6,418,420,426,428	I visited Cuba for a few weeks.	0		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.169-06
197	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 13:58:40-06	347,-6	(I) visited	4		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.17-06
198	[{"leafId":418,"en":"Cuba","es":"Cuba"}]	2018-06-27 13:57:50-06	418	Cuba	4		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.171-06
199	[{"leafId":420,"en":"for","es":"por"}]	2018-06-27 13:57:47-06	420	for (on behalf of)	2		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.172-06
200	[{"leafId":426,"en":"some","es":"unas"}]	2018-06-27 13:57:45-06	426	some (fem.)	4		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.173-06
201	[{"leafId":428,"en":"weeks","es":"semanas"}]	2018-06-27 13:57:43-06	428	weeks	4		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.174-06
202	[{"leafId":347,"en":"visit","es":"visitar"}]	2018-06-27 13:57:41-06	347	to visit	4		2018-06-26 21:24:31.970408-06	2018-06-27 14:08:09.175-06
204	[{"leafId":413,"en":"with","es":"con"},{"leafId":414,"en":"who","es":"quién"},{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"},{"leafId":327,"en":"speak","es":"hablar"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 12:33:53-06	413,414,431,-12,327,380	Who do you want to speak Spanish with?	0		2018-06-26 21:24:42.777343-06	2018-06-27 14:08:09.176-06
154	[{"leafId":326,"en":"be","es":"estar"}]	2018-06-27 13:59:16-06	326	to be (be (how))	3		2018-06-26 21:23:25.706003-06	2018-06-27 14:08:09.142-06
213	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 12:33:45-06	410,316,-16,380	Where did you learn Spanish?	0		2018-06-26 21:24:51.438947-06	2018-06-27 14:08:09.181-06
215	[{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	2018-06-27 12:33:42-06	316,-16	(you) learned	0		2018-06-26 21:24:51.438947-06	2018-06-27 14:08:09.182-06
218	[{"leafId":-16,"en":"(you)","es":"-iste"}]	2018-06-27 14:07:46-06	-16	(you) ate (comer)	2		2018-06-26 21:24:51.438947-06	2018-06-27 14:08:09.183-06
219	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":392,"en":"a","es":"una"},{"leafId":424,"en":"application","es":"aplicación"},{"leafId":427,"en":"mobile phone","es":"móvil"},{"leafId":421,"en":"for","es":"para"},{"leafId":353,"en":"study","es":"estudiar"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 12:32:18-06	352,-6,392,424,427,421,353,380	I created a mobile app to study Spanish.	0		2018-06-26 21:25:00.173425-06	2018-06-27 14:08:09.184-06
220	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 12:32:11-06	352,-6	(I) created	0		2018-06-26 21:25:00.173425-06	2018-06-27 14:08:09.184-06
237	[{"leafId":353,"en":"study","es":"estudi-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 13:16:08-06	353,-1,380	I study Spanish.	0		2018-06-27 08:50:29.172548-06	2018-06-27 14:08:09.193-06
238	[{"leafId":353,"en":"study","es":"estudi-"},{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-27 13:16:03-06	353,-1	(I) study	0		2018-06-27 08:50:29.172548-06	2018-06-27 14:08:09.193-06
222	[{"leafId":424,"en":"application","es":"aplicación"}]	2018-06-27 13:56:02-06	424	application	4		2018-06-26 21:25:00.173425-06	2018-06-27 14:08:09.185-06
369	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":417,"en":"Longmont","es":"Longmont"}]	2018-06-27 13:15:50-06	349,-11,498,417	I live in Longmont.	0		2018-06-27 13:14:05.021884-06	2018-06-27 14:08:09.194-06
371	[{"leafId":498,"en":"in/on","es":"en"}]	2018-06-27 14:00:42-06	498	in/on	4		2018-06-27 13:14:05.021884-06	2018-06-27 14:08:09.196-06
375	[{"leafId":415,"en":"me","es":"me"},{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":419,"en":"to","es":"a"},{"leafId":417,"en":"Longmont","es":"Longmont"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":423,"en":"January","es":"enero"}]	2018-06-27 14:00:44-06	415,351,-6,419,417,498,423	I moved to Longmont in January.	3		2018-06-27 13:14:36.959357-06	2018-06-27 14:08:09.197-06
223	[{"leafId":427,"en":"mobile phone","es":"móvil"}]	2018-06-27 13:55:59-06	427	mobile phone	3		2018-06-26 21:25:00.173425-06	2018-06-27 14:08:09.186-06
205	[{"leafId":413,"en":"with","es":"con"}]	2018-06-27 13:57:39-06	413	with	4		2018-06-26 21:24:42.777343-06	2018-06-27 14:08:09.176-06
206	[{"leafId":414,"en":"who","es":"quién"}]	2018-06-27 13:57:37-06	414	who	4		2018-06-26 21:24:42.777343-06	2018-06-27 14:08:09.177-06
207	[{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-27 12:33:49-06	431,-12	(you) want	0		2018-06-26 21:24:42.777343-06	2018-06-27 14:08:09.178-06
210	[{"leafId":431,"en":"want","es":"quier-"}]	2018-06-27 13:59:56-06	431	Stem change for querer in PRES	2		2018-06-26 21:24:42.777343-06	2018-06-27 14:08:09.179-06
212	[{"leafId":336,"en":"want","es":"querer"}]	2018-06-27 13:57:35-06	336	to want	4		2018-06-26 21:24:42.777343-06	2018-06-27 14:08:09.18-06
225	[{"leafId":353,"en":"study","es":"estudiar"}]	2018-06-27 13:55:41-06	353	to study	3		2018-06-26 21:25:00.173425-06	2018-06-27 14:08:09.187-06
227	[{"leafId":352,"en":"create","es":"crear"}]	2018-06-27 13:59:53-06	352	to create	2		2018-06-26 21:25:00.173425-06	2018-06-27 14:08:09.188-06
229	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":392,"en":"a","es":"una"},{"leafId":422,"en":"class","es":"clase"},{"leafId":409,"en":"of","es":"de"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:47-06	350,-15,392,422,409,380	I took a class in Spanish.	0		2018-06-26 21:25:14.87594-06	2018-06-27 14:08:09.188-06
230	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"}]	2018-06-26 21:28:28-06	350,-15	(I) attended	0		2018-06-26 21:25:14.87594-06	2018-06-27 14:08:09.189-06
232	[{"leafId":422,"en":"class","es":"clase"}]	2018-06-27 13:55:32-06	422	class	3		2018-06-26 21:25:14.87594-06	2018-06-27 14:08:09.19-06
235	[{"leafId":350,"en":"attend","es":"asistir"}]	2018-06-27 13:53:57-06	350	to attend	3		2018-06-26 21:25:14.87594-06	2018-06-27 14:08:09.191-06
236	[{"leafId":-15,"en":"(I)","es":"-í"}]	2018-06-27 14:07:51-06	-15	(I) ate (comer)	2		2018-06-26 21:25:14.87594-06	2018-06-27 14:08:09.192-06
\.


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_card_id_seq', 383, true);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags_csv, en, es, leaf_ids_csv, created_at, updated_at, goal_card_ids_json, gloss_rows_json) FROM stdin;
51		Good morning!	buenos días	387,382	2018-06-27 11:32:20.197587-06	2018-06-27 11:32:20.196-06	[{"cardId":122,"glossRowStart":0,"glossRowEnd":1},{"cardId":123,"glossRowStart":0,"glossRowEnd":0},{"cardId":124,"glossRowStart":1,"glossRowEnd":1}]	[{"leafId":387,"en":"good","es":"buenos"},{"leafId":382,"en":"days","es":"días"}]
52		Good afternoon!	buenas tardes	388,383	2018-06-27 11:33:22.240924-06	2018-06-27 11:33:22.239-06	[{"cardId":125,"glossRowStart":0,"glossRowEnd":1},{"cardId":126,"glossRowStart":0,"glossRowEnd":0},{"cardId":127,"glossRowStart":1,"glossRowEnd":1}]	[{"leafId":388,"en":"good","es":"buenas"},{"leafId":383,"en":"afternoons","es":"tardes"}]
53		I'm a software engineer.	soy ingeniero de software	453,384,409,412	2018-06-27 11:33:29.519439-06	2018-06-27 11:33:29.518-06	[{"cardId":128,"glossRowStart":0,"glossRowEnd":3},{"cardId":129,"glossRowStart":0,"glossRowEnd":0},{"cardId":130,"glossRowStart":1,"glossRowEnd":1},{"cardId":131,"glossRowStart":2,"glossRowEnd":2},{"cardId":132,"glossRowStart":3,"glossRowEnd":3}]	[{"leafId":453,"en":"am","es":"soy"},{"leafId":384,"en":"engineer","es":"ingeniero"},{"leafId":409,"en":"of","es":"de"},{"leafId":412,"en":"software","es":"software"}]
54		Where do you live?	dónde vives	410,349,-12	2018-06-27 11:33:43.293132-06	2018-06-27 11:33:43.291-06	[{"cardId":134,"glossRowStart":0,"glossRowEnd":2},{"cardId":135,"glossRowStart":0,"glossRowEnd":0},{"cardId":136,"glossRowStart":1,"glossRowEnd":2},{"cardId":137,"glossRowStart":1,"glossRowEnd":1},{"cardId":138,"glossRowStart":2,"glossRowEnd":2}]	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]
56		I speak English.	hablo inglés	327,-1,381	2018-06-27 11:36:31.198704-06	2018-06-27 11:36:31.195-06	[{"cardId":144,"glossRowStart":0,"glossRowEnd":2},{"cardId":140,"glossRowStart":0,"glossRowEnd":1},{"cardId":142,"glossRowStart":0,"glossRowEnd":0},{"cardId":143,"glossRowStart":1,"glossRowEnd":1},{"cardId":146,"glossRowStart":2,"glossRowEnd":2}]	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":381,"en":"English","es":"inglés"}]
57		What are you doing?	qué haces	407,328,-12	2018-06-27 11:36:42.409091-06	2018-06-27 11:36:42.408-06	[{"cardId":155,"glossRowStart":0,"glossRowEnd":2},{"cardId":156,"glossRowStart":0,"glossRowEnd":0},{"cardId":157,"glossRowStart":1,"glossRowEnd":2},{"cardId":158,"glossRowStart":1,"glossRowEnd":1},{"cardId":138,"glossRowStart":2,"glossRowEnd":2}]	[{"leafId":407,"en":"what","es":"qué"},{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]
58		I'm doing well.	estoy bien	463,398	2018-06-27 11:36:49.127101-06	2018-06-27 11:36:49.126-06	[{"cardId":160,"glossRowStart":0,"glossRowEnd":1},{"cardId":161,"glossRowStart":0,"glossRowEnd":0},{"cardId":162,"glossRowStart":1,"glossRowEnd":1}]	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":398,"en":"well","es":"bien"}]
59		Hello!	hola	408	2018-06-27 11:36:54.74803-06	2018-06-27 11:36:54.747-06	[{"cardId":164,"glossRowStart":0,"glossRowEnd":0},{"cardId":164,"glossRowStart":0,"glossRowEnd":0}]	[{"leafId":408,"en":"hello","es":"hola"}]
62		I made a list of sentences to learn.	hice una lista de oraciones para aprender	451,-22,392,385,409,386,421,316	2018-06-27 11:37:30.031693-06	2018-06-27 11:37:30.03-06	[{"cardId":185,"glossRowStart":0,"glossRowEnd":7},{"cardId":186,"glossRowStart":0,"glossRowEnd":1},{"cardId":193,"glossRowStart":0,"glossRowEnd":0},{"cardId":194,"glossRowStart":1,"glossRowEnd":1},{"cardId":187,"glossRowStart":2,"glossRowEnd":2},{"cardId":188,"glossRowStart":3,"glossRowEnd":3},{"cardId":131,"glossRowStart":4,"glossRowEnd":4},{"cardId":190,"glossRowStart":5,"glossRowEnd":5},{"cardId":191,"glossRowStart":6,"glossRowEnd":6},{"cardId":192,"glossRowStart":7,"glossRowEnd":7}]	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"},{"leafId":392,"en":"a","es":"una"},{"leafId":385,"en":"list","es":"lista"},{"leafId":409,"en":"of","es":"de"},{"leafId":386,"en":"sentences","es":"oraciones"},{"leafId":421,"en":"for","es":"para"},{"leafId":316,"en":"learn","es":"aprender"}]
63		I visited Cuba for a few weeks.	visité Cuba por unas semanas	347,-6,418,420,426,428	2018-06-27 11:37:41.944888-06	2018-06-27 11:37:41.944-06	[{"cardId":196,"glossRowStart":0,"glossRowEnd":5},{"cardId":197,"glossRowStart":0,"glossRowEnd":1},{"cardId":202,"glossRowStart":0,"glossRowEnd":0},{"cardId":182,"glossRowStart":1,"glossRowEnd":1},{"cardId":198,"glossRowStart":2,"glossRowEnd":2},{"cardId":199,"glossRowStart":3,"glossRowEnd":3},{"cardId":200,"glossRowStart":4,"glossRowEnd":4},{"cardId":201,"glossRowStart":5,"glossRowEnd":5}]	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":418,"en":"Cuba","es":"Cuba"},{"leafId":420,"en":"for","es":"por"},{"leafId":426,"en":"some","es":"unas"},{"leafId":428,"en":"weeks","es":"semanas"}]
64		Who do you want to speak Spanish with?	con quién quieres hablar español	413,414,431,-12,327,380	2018-06-27 11:38:01.05192-06	2018-06-27 11:38:01.051-06	[{"cardId":204,"glossRowStart":0,"glossRowEnd":5},{"cardId":205,"glossRowStart":0,"glossRowEnd":0},{"cardId":206,"glossRowStart":1,"glossRowEnd":1},{"cardId":207,"glossRowStart":2,"glossRowEnd":3},{"cardId":210,"glossRowStart":2,"glossRowEnd":2},{"cardId":138,"glossRowStart":3,"glossRowEnd":3},{"cardId":142,"glossRowStart":4,"glossRowEnd":4},{"cardId":141,"glossRowStart":5,"glossRowEnd":5}]	[{"leafId":413,"en":"with","es":"con"},{"leafId":414,"en":"who","es":"quién"},{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"},{"leafId":327,"en":"speak","es":"hablar"},{"leafId":380,"en":"Spanish","es":"español"}]
65		Where did you learn Spanish?	dónde aprendiste español	410,316,-16,380	2018-06-27 11:38:14.912658-06	2018-06-27 11:38:14.911-06	[{"cardId":213,"glossRowStart":0,"glossRowEnd":3},{"cardId":135,"glossRowStart":0,"glossRowEnd":0},{"cardId":215,"glossRowStart":1,"glossRowEnd":2},{"cardId":192,"glossRowStart":1,"glossRowEnd":1},{"cardId":218,"glossRowStart":2,"glossRowEnd":2},{"cardId":141,"glossRowStart":3,"glossRowEnd":3}]	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":380,"en":"Spanish","es":"español"}]
67		I took a Spanish class.	asistí una clase de español	350,-15,392,422,409,380	2018-06-27 11:39:07.120565-06	2018-06-27 11:39:07.119-06	[{"cardId":229,"glossRowStart":0,"glossRowEnd":5},{"cardId":230,"glossRowStart":0,"glossRowEnd":1},{"cardId":235,"glossRowStart":0,"glossRowEnd":0},{"cardId":236,"glossRowStart":1,"glossRowEnd":1},{"cardId":187,"glossRowStart":2,"glossRowEnd":2},{"cardId":232,"glossRowStart":3,"glossRowEnd":3},{"cardId":131,"glossRowStart":4,"glossRowEnd":4},{"cardId":141,"glossRowStart":5,"glossRowEnd":5}]	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":392,"en":"a","es":"una"},{"leafId":422,"en":"class","es":"clase"},{"leafId":409,"en":"of","es":"de"},{"leafId":380,"en":"Spanish","es":"español"}]
55		I speak Spanish.	hablo español	327,-1,380	2018-06-27 11:36:23.881449-06	2018-06-27 11:36:23.88-06	[{"cardId":139,"glossRowStart":0,"glossRowEnd":2},{"cardId":140,"glossRowStart":0,"glossRowEnd":1},{"cardId":142,"glossRowStart":0,"glossRowEnd":0},{"cardId":143,"glossRowStart":1,"glossRowEnd":1},{"cardId":141,"glossRowStart":2,"glossRowEnd":2}]	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]
66		I created a mobile app to study Spanish.	creé una aplicación móvil para estudiar español	352,-6,392,424,427,421,353,380	2018-06-27 11:38:39.11106-06	2018-06-27 11:38:39.11-06	[{"cardId":219,"glossRowStart":0,"glossRowEnd":7},{"cardId":220,"glossRowStart":0,"glossRowEnd":1},{"cardId":227,"glossRowStart":0,"glossRowEnd":0},{"cardId":182,"glossRowStart":1,"glossRowEnd":1},{"cardId":187,"glossRowStart":2,"glossRowEnd":2},{"cardId":222,"glossRowStart":3,"glossRowEnd":3},{"cardId":223,"glossRowStart":4,"glossRowEnd":4},{"cardId":191,"glossRowStart":5,"glossRowEnd":5},{"cardId":225,"glossRowStart":6,"glossRowEnd":6},{"cardId":141,"glossRowStart":7,"glossRowEnd":7}]	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":392,"en":"a","es":"una"},{"leafId":424,"en":"application","es":"aplicación"},{"leafId":427,"en":"mobile phone","es":"móvil"},{"leafId":421,"en":"for","es":"para"},{"leafId":353,"en":"study","es":"estudiar"},{"leafId":380,"en":"Spanish","es":"español"}]
68		I live in Longmont.	vivo en Longmont	349,-11,498,417	2018-06-27 13:14:05.055061-06	2018-06-27 13:14:05.053-06	[{"cardId":369,"glossRowStart":0,"glossRowEnd":3},{"cardId":167,"glossRowStart":0,"glossRowEnd":1},{"cardId":137,"glossRowStart":0,"glossRowEnd":0},{"cardId":153,"glossRowStart":1,"glossRowEnd":1},{"cardId":371,"glossRowStart":2,"glossRowEnd":2},{"cardId":169,"glossRowStart":3,"glossRowEnd":3}]	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":417,"en":"Longmont","es":"Longmont"}]
69		I moved to Longmont in January.	me mudé a Longmont en enero	415,351,-6,419,417,498,423	2018-06-27 13:14:36.969027-06	2018-06-27 13:14:36.967-06	[{"cardId":375,"glossRowStart":0,"glossRowEnd":6},{"cardId":175,"glossRowStart":0,"glossRowEnd":0},{"cardId":176,"glossRowStart":1,"glossRowEnd":2},{"cardId":181,"glossRowStart":1,"glossRowEnd":1},{"cardId":182,"glossRowStart":2,"glossRowEnd":2},{"cardId":177,"glossRowStart":3,"glossRowEnd":3},{"cardId":169,"glossRowStart":4,"glossRowEnd":4},{"cardId":371,"glossRowStart":5,"glossRowEnd":5},{"cardId":180,"glossRowStart":6,"glossRowEnd":6}]	[{"leafId":415,"en":"me","es":"me"},{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":419,"en":"to","es":"a"},{"leafId":417,"en":"Longmont","es":"Longmont"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":423,"en":"January","es":"enero"}]
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 69, true);


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
498	Nonverb	en	in/on		\N	\N	\N	\N	\N	\N	2018-06-27 13:09:57.624981-06
\.


--
-- Name: leafs_leaf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('leafs_leaf_id_seq', 498, true);


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

