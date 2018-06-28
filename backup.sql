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
ALTER TABLE ONLY public.card_embeddings DROP CONSTRAINT card_embeddings_shorter_card_id_fkey;
ALTER TABLE ONLY public.card_embeddings DROP CONSTRAINT card_embeddings_longer_card_id_fkey;
DROP INDEX public.schema_version_s_idx;
DROP INDEX public.idx_leafs_nonverbs_en_plural_and_en_disambiguation;
DROP INDEX public.idx_leafs_nonverbs_en_and_en_disambiguation;
DROP INDEX public.idx_leafs_infinitives_en_past_and_en_disambiguation;
DROP INDEX public.idx_leafs_infinitives_en_and_en_disambiguation;
DROP INDEX public.idx_leafs_es_mixed;
DROP INDEX public.idx_leafs_es_lower;
DROP INDEX public.idx_cards_leaf_ids_csv;
DROP INDEX public.idx_card_embeddings;
ALTER TABLE ONLY public.schema_version DROP CONSTRAINT schema_version_pk;
ALTER TABLE ONLY public.leafs DROP CONSTRAINT leafs_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_pkey;
ALTER TABLE ONLY public.card_embeddings DROP CONSTRAINT card_embeddings_pkey;
ALTER TABLE public.leafs ALTER COLUMN leaf_id DROP DEFAULT;
ALTER TABLE public.goals ALTER COLUMN goal_id DROP DEFAULT;
ALTER TABLE public.cards ALTER COLUMN card_id DROP DEFAULT;
ALTER TABLE public.card_embeddings ALTER COLUMN card_embedding_id DROP DEFAULT;
DROP TABLE public.schema_version;
DROP SEQUENCE public.leafs_leaf_id_seq;
DROP TABLE public.leafs;
DROP SEQUENCE public.goals_goal_id_seq;
DROP TABLE public.goals;
DROP SEQUENCE public.cards_card_id_seq;
DROP TABLE public.cards;
DROP SEQUENCE public.card_embeddings_card_embedding_id_seq;
DROP TABLE public.card_embeddings;
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
-- Name: card_embeddings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE card_embeddings (
    card_embedding_id integer NOT NULL,
    longer_card_id integer NOT NULL,
    shorter_card_id integer NOT NULL,
    first_leaf_index integer NOT NULL,
    last_leaf_index integer NOT NULL
);


ALTER TABLE card_embeddings OWNER TO postgres;

--
-- Name: card_embeddings_card_embedding_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE card_embeddings_card_embedding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE card_embeddings_card_embedding_id_seq OWNER TO postgres;

--
-- Name: card_embeddings_card_embedding_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE card_embeddings_card_embedding_id_seq OWNED BY card_embeddings.card_embedding_id;


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
    card_id integer NOT NULL
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
-- Name: card_embeddings card_embedding_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY card_embeddings ALTER COLUMN card_embedding_id SET DEFAULT nextval('card_embeddings_card_embedding_id_seq'::regclass);


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
-- Data for Name: card_embeddings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY card_embeddings (card_embedding_id, longer_card_id, shorter_card_id, first_leaf_index, last_leaf_index) FROM stdin;
1	140	142	0	0
3	144	140	0	1
5	144	142	0	0
7	139	140	0	1
9	139	142	0	0
10	122	123	0	0
11	125	126	0	0
13	128	409	0	0
14	185	186	0	1
15	185	193	0	0
16	418	186	0	1
17	418	193	0	0
19	134	135	0	0
21	425	415	0	0
22	429	415	0	0
23	433	415	0	0
24	160	415	0	0
28	437	438	0	0
30	439	442	0	0
32	444	156	0	0
33	446	152	0	0
34	450	451	0	1
35	450	152	0	0
37	451	152	0	0
38	455	456	0	1
39	455	458	0	0
41	456	458	0	0
44	462	458	0	0
45	460	461	0	0
48	465	466	0	1
49	465	469	0	0
51	466	469	0	0
54	471	469	0	0
55	472	469	0	0
57	471	472	0	1
60	476	477	0	0
62	478	480	0	0
72	155	156	0	0
73	157	158	0	0
75	167	137	0	0
76	369	167	0	1
77	176	181	0	0
78	511	176	0	1
82	186	193	0	0
84	511	181	0	0
85	215	192	0	0
89	196	197	0	1
90	196	202	0	0
92	197	202	0	0
95	204	205	0	0
96	482	483	0	0
97	136	137	0	0
100	369	137	0	0
107	489	490	0	0
109	375	175	0	0
110	237	225	0	0
111	238	225	0	0
112	219	227	0	0
113	220	227	0	0
114	499	227	0	0
115	505	227	0	0
116	506	227	0	0
117	229	230	0	1
118	229	235	0	0
119	207	210	0	0
121	230	235	0	0
124	213	135	0	0
127	219	220	0	1
130	499	220	0	1
132	237	238	0	1
147	505	506	0	1
153	122	124	1	1
155	125	127	1	1
157	128	131	2	2
159	128	130	1	1
160	128	132	3	3
161	185	131	4	4
163	185	187	2	2
164	185	190	5	5
165	185	191	6	6
166	185	192	7	7
168	185	194	1	1
169	185	188	3	3
170	418	421	3	3
172	418	187	2	2
174	418	194	1	1
180	229	131	4	4
181	134	136	1	2
182	134	137	1	1
183	134	138	2	2
191	425	427	1	1
196	429	431	1	1
199	433	435	1	1
202	437	439	1	2
203	437	440	3	3
204	437	441	4	4
205	437	442	1	1
206	437	218	2	2
210	439	218	1	1
215	444	446	1	2
216	444	447	3	3
217	444	152	1	1
219	444	218	2	2
222	446	218	1	1
225	450	452	2	2
227	450	236	1	1
230	451	236	1	1
233	455	457	2	2
235	455	236	1	1
238	456	236	1	1
242	460	458	1	1
246	460	462	1	2
247	460	218	2	2
251	462	218	1	1
254	465	544	3	3
255	465	236	1	1
256	465	371	2	2
259	466	236	1	1
266	471	473	2	2
267	471	218	1	1
270	472	218	1	1
273	476	478	1	2
274	476	480	1	1
275	476	162	3	3
276	476	236	2	2
280	478	236	1	1
286	204	142	4	4
289	144	143	1	1
290	140	143	1	1
291	237	143	1	1
292	238	143	1	1
293	139	143	1	1
297	144	146	2	2
302	167	153	1	1
303	369	153	1	1
304	155	157	1	2
305	155	158	1	1
306	155	138	2	2
310	157	138	1	1
316	176	182	1	1
318	375	176	1	2
320	375	177	3	3
321	196	201	5	5
322	375	180	6	6
324	160	162	1	1
326	196	182	1	1
327	197	182	1	1
328	482	182	2	2
329	489	182	6	6
330	219	182	1	1
331	220	182	1	1
332	375	182	2	2
333	499	182	1	1
334	511	182	1	1
338	186	194	1	1
340	375	181	1	1
344	229	187	2	2
345	219	187	2	2
346	505	187	2	2
349	219	191	5	5
351	213	192	1	1
364	196	199	3	3
365	196	200	4	4
367	196	198	2	2
376	204	138	3	3
377	204	141	5	5
378	204	210	2	2
380	204	206	1	1
381	204	207	2	3
384	482	485	3	3
385	482	486	4	4
386	482	227	1	1
387	482	220	1	2
390	136	138	1	1
400	207	138	1	1
406	229	141	5	5
407	213	141	3	3
408	219	141	7	7
409	237	141	2	2
410	139	141	2	2
418	505	486	3	3
421	489	227	5	5
422	489	220	5	6
423	489	491	1	1
424	489	492	2	2
425	489	493	3	3
426	489	494	4	4
428	369	169	3	3
429	375	169	4	4
432	219	225	6	6
446	229	232	3	3
448	229	236	1	1
453	230	236	1	1
469	213	215	1	2
470	213	218	2	2
474	215	218	1	1
492	219	222	3	3
493	219	223	4	4
513	369	371	2	2
516	375	371	5	5
526	499	491	2	2
545	499	502	3	3
551	505	510	1	1
554	506	510	1	1
560	511	513	2	2
561	511	514	3	3
\.


--
-- Name: card_embeddings_card_embedding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('card_embeddings_card_embedding_id_seq', 563, true);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cards (card_id, gloss_rows_json, last_seen_at, leaf_ids_csv, prompt, stage, mnemonic, created_at, updated_at) FROM stdin;
123	[{"leafId":387,"en":"good","es":"buenos"}]	2018-06-27 14:00:37-06	387	good (masc.)	4		2018-06-26 21:22:40.532507-06	2018-06-27 16:43:32.647-06
124	[{"leafId":382,"en":"days","es":"días"}]	2018-06-27 14:00:35-06	382	days	4		2018-06-26 21:22:40.532507-06	2018-06-27 16:43:32.654-06
125	[{"leafId":388,"en":"good","es":"buenas"},{"leafId":383,"en":"afternoons","es":"tardes"}]	2018-06-27 14:00:33-06	388,383	Good afternoon!	4		2018-06-26 21:22:50.209001-06	2018-06-27 16:43:32.66-06
126	[{"leafId":388,"en":"good","es":"buenas"}]	2018-06-27 14:00:30-06	388	good (fem.)	4		2018-06-26 21:22:50.209001-06	2018-06-27 16:43:32.661-06
128	[{"leafId":453,"en":"am","es":"soy"},{"leafId":384,"en":"engineer","es":"ingeniero"},{"leafId":409,"en":"of","es":"de"},{"leafId":412,"en":"software","es":"software"}]	2018-06-27 12:34:37-06	453,384,409,412	I'm a software engineer.	0		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.664-06
185	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"},{"leafId":392,"en":"a","es":"una"},{"leafId":385,"en":"list","es":"lista"},{"leafId":409,"en":"of","es":"de"},{"leafId":386,"en":"sentences","es":"oraciones"},{"leafId":421,"en":"for","es":"para"},{"leafId":316,"en":"learn","es":"aprender"}]	2018-06-27 12:22:53-06	451,-22,392,385,409,386,421,316	I made a list of sentences to learn.	0		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.695-06
418	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"},{"leafId":392,"en":"a","es":"una"},{"leafId":499,"en":"test","es":"prueba"}]	\N	451,-22,392,499	I did a test.	0		2018-06-27 15:36:09.510179-06	2018-06-27 16:43:32.73-06
421	[{"leafId":499,"en":"test","es":"prueba"}]	2018-06-27 15:41:54-06	499	test	4		2018-06-27 15:36:09.510179-06	2018-06-27 16:43:32.731-06
122	[{"leafId":387,"en":"good","es":"buenos"},{"leafId":382,"en":"days","es":"días"}]	2018-06-27 14:00:39-06	387,382	Good morning!	4		2018-06-26 21:22:40.532507-06	2018-06-27 16:43:32.639-06
131	[{"leafId":409,"en":"of","es":"de"}]	2018-06-27 13:59:49-06	409	of	4		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.666-06
134	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:32-06	410,349,-12	Where do you live?	0		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.668-06
409	[{"leafId":453,"en":"am","es":"soy"}]	2018-06-27 15:24:07-06	453	I am (what)	3		2018-06-27 15:22:50.588203-06	2018-06-27 16:43:32.727-06
413	[{"leafId":342,"en":"be","es":"ser"}]	2018-06-27 15:23:55-06	342	to be (what)	3		2018-06-27 15:22:50.588203-06	2018-06-27 16:43:32.728-06
415	[{"leafId":463,"en":"am","es":"estoy"}]	2018-06-27 15:23:51-06	463	I am (how)	3		2018-06-27 15:23:20.084918-06	2018-06-27 16:43:32.729-06
417	[{"leafId":326,"en":"be","es":"estar"}]	2018-06-27 15:23:47-06	326	to be (how)	3		2018-06-27 15:23:20.084918-06	2018-06-27 16:43:32.73-06
425	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":500,"en":"happy","es":"feliz"}]	\N	463,500	I'm happy.	0		2018-06-27 16:00:49.986098-06	2018-06-27 16:43:32.732-06
427	[{"leafId":500,"en":"happy","es":"feliz"}]	2018-06-27 16:31:34-06	500	happy	3		2018-06-27 16:00:49.986098-06	2018-06-27 16:43:32.733-06
130	[{"leafId":384,"en":"engineer","es":"ingeniero"}]	2018-06-27 13:59:51-06	384	engineer	4		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.665-06
127	[{"leafId":383,"en":"afternoons","es":"tardes"}]	2018-06-27 14:00:28-06	383	afternoons	4		2018-06-26 21:22:50.209001-06	2018-06-27 16:43:32.662-06
429	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":501,"en":"alone","es":"solo"}]	\N	463,501	I'm alone.	0		2018-06-27 16:01:36.519258-06	2018-06-27 16:43:32.733-06
431	[{"leafId":501,"en":"alone","es":"solo"}]	2018-06-27 16:31:32-06	501	alone	4		2018-06-27 16:01:36.519258-06	2018-06-27 16:43:32.734-06
433	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":502,"en":"sad","es":"triste"}]	\N	463,502	I'm sad.	0		2018-06-27 16:02:09.868374-06	2018-06-27 16:43:32.737-06
435	[{"leafId":502,"en":"sad","es":"triste"}]	2018-06-27 16:31:31-06	502	sad	4		2018-06-27 16:02:09.868374-06	2018-06-27 16:43:32.738-06
437	[{"leafId":503,"en":"yet","es":"ya"},{"leafId":504,"en":"sold","es":"vend-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":390,"en":"the","es":"la"},{"leafId":505,"en":"house","es":"casa"}]	\N	503,504,-16,390,505	Did you sell the house yet?	0		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.739-06
438	[{"leafId":503,"en":"yet","es":"ya"}]	2018-06-27 16:31:29-06	503	yet	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.74-06
439	[{"leafId":504,"en":"sold","es":"vend-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	504,-16	(you) sold	0		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.741-06
440	[{"leafId":390,"en":"the","es":"la"}]	2018-06-27 16:31:27-06	390	the (fem.)	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.742-06
441	[{"leafId":505,"en":"house","es":"casa"}]	2018-06-27 16:31:25-06	505	house	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.742-06
442	[{"leafId":504,"en":"sell","es":"vender"}]	2018-06-27 16:31:23-06	504	to sell	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.743-06
444	[{"leafId":407,"en":"what","es":"qué"},{"leafId":317,"en":"ate","es":"com-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":507,"en":"today","es":"hoy"}]	\N	407,317,-16,507	What did you eat today?	0		2018-06-27 16:10:43.293921-06	2018-06-27 16:43:32.744-06
446	[{"leafId":317,"en":"ate","es":"com-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	317,-16	(you) ate	0		2018-06-27 16:10:43.293921-06	2018-06-27 16:43:32.745-06
447	[{"leafId":507,"en":"today","es":"hoy"}]	2018-06-27 16:31:22-06	507	today	4		2018-06-27 16:10:43.293921-06	2018-06-27 16:43:32.746-06
450	[{"leafId":317,"en":"ate","es":"com-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":508,"en":"too much","es":"demasiado"}]	\N	317,-15,508	I ate too much.	0		2018-06-27 16:11:55.915249-06	2018-06-27 16:43:32.748-06
451	[{"leafId":317,"en":"ate","es":"com-"},{"leafId":-15,"en":"(I)","es":"-í"}]	\N	317,-15	(I) ate	0		2018-06-27 16:11:55.915249-06	2018-06-27 16:43:32.749-06
452	[{"leafId":508,"en":"too much","es":"demasiado"}]	2018-06-27 16:31:20-06	508	too much	4		2018-06-27 16:11:55.915249-06	2018-06-27 16:43:32.75-06
455	[{"leafId":509,"en":"ran","es":"corr-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":510,"en":"outside","es":"afuera"}]	\N	509,-15,510	I ran outside.	0		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.751-06
456	[{"leafId":509,"en":"ran","es":"corr-"},{"leafId":-15,"en":"(I)","es":"-í"}]	\N	509,-15	(I) ran	0		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.751-06
457	[{"leafId":510,"en":"outside","es":"afuera"}]	2018-06-27 16:31:18-06	510	to outside	4		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.752-06
458	[{"leafId":509,"en":"run","es":"correr"}]	2018-06-27 16:31:15-06	509	to run	4		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.753-06
460	[{"leafId":511,"en":"why","es":"porqué"},{"leafId":509,"en":"ran","es":"corr-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	511,509,-16	Why did you run?	0		2018-06-27 16:14:35.029309-06	2018-06-27 16:43:32.754-06
461	[{"leafId":511,"en":"why","es":"porqué"}]	2018-06-27 16:31:14-06	511	why	4		2018-06-27 16:14:35.029309-06	2018-06-27 16:43:32.755-06
462	[{"leafId":509,"en":"ran","es":"corr-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	509,-16	(you) ran	0		2018-06-27 16:14:35.029309-06	2018-06-27 16:43:32.756-06
465	[{"leafId":513,"en":"grew up","es":"crec-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":512,"en":"Pennsylvania","es":"Pennsylvania"}]	\N	513,-15,498,512	I grew up in Pennsylvania.	0		2018-06-27 16:16:17.029139-06	2018-06-27 16:43:32.757-06
466	[{"leafId":513,"en":"grew up","es":"crec-"},{"leafId":-15,"en":"(I)","es":"-í"}]	\N	513,-15	(I) grew up	0		2018-06-27 16:16:17.029139-06	2018-06-27 16:43:32.758-06
469	[{"leafId":513,"en":"grow up","es":"crecer"}]	2018-06-27 16:31:10-06	513	to grow up	4		2018-06-27 16:16:17.029139-06	2018-06-27 16:43:32.76-06
471	[{"leafId":513,"en":"grew up","es":"crec-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":514,"en":"here","es":"aquí"}]	\N	513,-16,514	Did you grow up here?	0		2018-06-27 16:17:49.570515-06	2018-06-27 16:43:32.761-06
472	[{"leafId":513,"en":"grew up","es":"crec-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	\N	513,-16	(you) grew up	0		2018-06-27 16:17:49.570515-06	2018-06-27 16:43:32.762-06
473	[{"leafId":514,"en":"here","es":"aquí"}]	2018-06-27 16:31:08-06	514	here	4		2018-06-27 16:17:49.570515-06	2018-06-27 16:43:32.763-06
476	[{"leafId":515,"en":"him","es":"lo"},{"leafId":318,"en":"knew","es":"conoc-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":398,"en":"well","es":"bien"}]	\N	515,318,-15,398	I knew him well.	0		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.763-06
477	[{"leafId":515,"en":"him","es":"lo"}]	2018-06-27 16:31:05-06	515	him	4		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.764-06
478	[{"leafId":318,"en":"knew","es":"conoc-"},{"leafId":-15,"en":"(I)","es":"-í"}]	\N	318,-15	(I) knew (be able to)	0		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.765-06
480	[{"leafId":318,"en":"know","es":"conocer"}]	2018-06-27 16:28:42-06	318	to know (someone)	3		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.766-06
132	[{"leafId":412,"en":"software","es":"software"}]	2018-06-27 13:59:47-06	412	software	5		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.667-06
544	[{"leafId":512,"en":"Pennsylvania","es":"Pennsylvania"}]	\N	512	Pennsylvania	5		2018-06-27 17:08:39.845218-06	2018-06-27 17:08:39.842-06
142	[{"leafId":327,"en":"speak","es":"hablar"}]	2018-06-27 13:59:36-06	327	to speak	3		2018-06-26 21:23:11.364754-06	2018-06-27 16:43:32.675-06
143	[{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-27 13:59:33-06	-1	(I work)	3		2018-06-26 21:23:11.364754-06	2018-06-27 16:43:32.676-06
144	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":381,"en":"English","es":"inglés"}]	2018-06-26 21:29:07-06	327,-1,381	I speak English.	0		2018-06-26 21:23:18.524111-06	2018-06-27 16:43:32.677-06
152	[{"leafId":317,"en":"eat","es":"comer"}]	2018-06-27 15:42:40-06	317	to eat	4		2018-06-26 21:23:25.706003-06	2018-06-27 16:43:32.678-06
153	[{"leafId":-11,"en":"(I)","es":"-o"}]	2018-06-27 14:08:00-06	-11	(I learn)	3		2018-06-26 21:23:25.706003-06	2018-06-27 16:43:32.679-06
155	[{"leafId":407,"en":"what","es":"qué"},{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:18-06	407,328,-12	What are you doing?	0		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.68-06
157	[{"leafId":328,"en":"do","es":"hac-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:15-06	328,-12	(you) do	0		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.682-06
164	[{"leafId":408,"en":"hello","es":"hola"}]	2018-06-27 13:58:56-06	408	Hello!	4		2018-06-26 21:23:53.914204-06	2018-06-27 16:43:32.685-06
158	[{"leafId":328,"en":"do","es":"hacer"}]	2018-06-27 15:42:38-06	328	to do	4		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.683-06
167	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"}]	2018-06-26 21:29:25-06	349,-11	(I) live	0		2018-06-26 21:24:01.746243-06	2018-06-27 16:43:32.686-06
176	[{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 13:58:50-06	351,-6	(I) moved	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.69-06
177	[{"leafId":419,"en":"to","es":"a"}]	2018-06-27 13:58:48-06	419	to (toward)	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.691-06
201	[{"leafId":428,"en":"weeks","es":"semanas"}]	2018-06-27 13:57:43-06	428	weeks	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.707-06
180	[{"leafId":423,"en":"January","es":"enero"}]	2018-06-27 13:58:46-06	423	January	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.692-06
160	[{"leafId":463,"en":"am","es":"estoy"},{"leafId":398,"en":"well","es":"bien"}]	2018-06-26 21:27:55-06	463,398	I'm doing well.	0		2018-06-26 21:23:47.71726-06	2018-06-27 16:43:32.684-06
182	[{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 13:58:38-06	-6	(I worked)	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.694-06
186	[{"leafId":451,"en":"did","es":"hic-"},{"leafId":-22,"en":"(I)","es":"-e"}]	2018-06-26 21:27:01-06	451,-22	(I) did	0		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.696-06
181	[{"leafId":351,"en":"move","es":"mudar"}]	2018-06-27 13:58:42-06	351	to move	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.693-06
187	[{"leafId":392,"en":"a","es":"una"}]	2018-06-27 13:58:36-06	392	a (fem.)	4		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.697-06
190	[{"leafId":386,"en":"sentences","es":"oraciones"}]	2018-06-27 13:58:32-06	386	sentences	4		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.699-06
191	[{"leafId":421,"en":"for","es":"para"}]	2018-06-27 13:58:31-06	421	for (in order to)	4		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.7-06
192	[{"leafId":316,"en":"learn","es":"aprender"}]	2018-06-27 13:58:28-06	316	to learn	4		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.701-06
193	[{"leafId":451,"en":"did","es":"hic-"}]	2018-06-27 15:42:32-06	451	Stem change for hacer in PRET	3		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.702-06
162	[{"leafId":398,"en":"well","es":"bien"}]	2018-06-27 15:42:36-06	398	well	4		2018-06-26 21:23:47.71726-06	2018-06-27 16:43:32.684-06
194	[{"leafId":-22,"en":"(I)","es":"-e"}]	2018-06-27 15:42:30-06	-22	(I had)	4		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.702-06
196	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":418,"en":"Cuba","es":"Cuba"},{"leafId":420,"en":"for","es":"por"},{"leafId":426,"en":"some","es":"unas"},{"leafId":428,"en":"weeks","es":"semanas"}]	2018-06-26 21:27:10-06	347,-6,418,420,426,428	I visited Cuba for a few weeks.	0		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.703-06
197	[{"leafId":347,"en":"visited","es":"visit-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 13:58:40-06	347,-6	(I) visited	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.704-06
199	[{"leafId":420,"en":"for","es":"por"}]	2018-06-27 15:42:56-06	420	for (on behalf of)	3		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.706-06
200	[{"leafId":426,"en":"some","es":"unas"}]	2018-06-27 13:57:45-06	426	some (fem.)	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.707-06
202	[{"leafId":347,"en":"visit","es":"visitar"}]	2018-06-27 13:57:41-06	347	to visit	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.708-06
204	[{"leafId":413,"en":"with","es":"con"},{"leafId":414,"en":"who","es":"quién"},{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"},{"leafId":327,"en":"speak","es":"hablar"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 12:33:53-06	413,414,431,-12,327,380	Who do you want to speak Spanish with?	0		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.709-06
482	[{"leafId":518,"en":"not","es":"no"},{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":516,"en":"that","es":"esa"},{"leafId":517,"en":"account","es":"cuenta"}]	\N	518,352,-6,516,517	I didn't create that account	0		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.766-06
136	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-26 21:29:28-06	349,-12	(you) live	0		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.67-06
137	[{"leafId":349,"en":"live","es":"vivir"}]	2018-06-27 13:59:43-06	349	to live	4		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.671-06
138	[{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-27 14:07:42-06	-12	(you learn)	3		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.671-06
140	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-26 21:29:05-06	327,-1	(I) speak	0		2018-06-26 21:23:11.364754-06	2018-06-27 16:43:32.673-06
141	[{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 13:59:41-06	380	Spanish	4		2018-06-26 21:23:11.364754-06	2018-06-27 16:43:32.674-06
146	[{"leafId":381,"en":"English","es":"inglés"}]	2018-06-27 13:59:31-06	381	English	4		2018-06-26 21:23:18.524111-06	2018-06-27 16:43:32.678-06
156	[{"leafId":407,"en":"what","es":"qué"}]	2018-06-27 13:59:14-06	407	what	4		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.681-06
188	[{"leafId":385,"en":"list","es":"lista"}]	2018-06-27 13:58:34-06	385	list	4		2018-06-26 21:24:23.139561-06	2018-06-27 16:43:32.698-06
483	[{"leafId":518,"en":"not","es":"no"}]	2018-06-27 16:43:25-06	518	not	4		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.767-06
485	[{"leafId":516,"en":"that","es":"esa"}]	2018-06-27 16:43:23-06	516	that (fem.)	4		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.768-06
486	[{"leafId":517,"en":"account","es":"cuenta"}]	2018-06-27 16:43:21-06	517	account	4		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.769-06
489	[{"leafId":455,"en":"is","es":"es"},{"leafId":391,"en":"a","es":"un"},{"leafId":519,"en":"game","es":"juego"},{"leafId":520,"en":"that","es":"que"},{"leafId":399,"en":"I","es":"yo"},{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"}]	\N	455,391,519,520,399,352,-6	It's a game that I made	0		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.769-06
490	[{"leafId":455,"en":"is","es":"es"}]	2018-06-27 16:43:18-06	455	he/she is (what)	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.77-06
169	[{"leafId":417,"en":"Longmont","es":"Longmont"}]	2018-06-27 13:58:54-06	417	Longmont	5		2018-06-26 21:24:01.746243-06	2018-06-27 16:43:32.688-06
198	[{"leafId":418,"en":"Cuba","es":"Cuba"}]	2018-06-27 13:57:50-06	418	Cuba	5		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.705-06
175	[{"leafId":415,"en":"me","es":"me"}]	2018-06-27 13:58:52-06	415	me (to me)	5		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.689-06
225	[{"leafId":353,"en":"study","es":"estudiar"}]	2018-06-27 15:42:26-06	353	to study	4		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.718-06
227	[{"leafId":352,"en":"create","es":"crear"}]	2018-06-27 14:22:34-06	352	to create	3		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.719-06
229	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"},{"leafId":392,"en":"a","es":"una"},{"leafId":422,"en":"class","es":"clase"},{"leafId":409,"en":"of","es":"de"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:47-06	350,-15,392,422,409,380	I took a class in Spanish.	0		2018-06-26 21:25:14.87594-06	2018-06-27 16:43:32.72-06
210	[{"leafId":431,"en":"want","es":"quier-"}]	2018-06-27 14:22:37-06	431	Stem change for querer in PRES	3		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.712-06
230	[{"leafId":350,"en":"attended","es":"asist-"},{"leafId":-15,"en":"(I)","es":"-í"}]	2018-06-26 21:28:28-06	350,-15	(I) attended	0		2018-06-26 21:25:14.87594-06	2018-06-27 16:43:32.721-06
212	[{"leafId":336,"en":"want","es":"querer"}]	2018-06-27 13:57:35-06	336	to want	4		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.713-06
232	[{"leafId":422,"en":"class","es":"clase"}]	2018-06-27 15:42:24-06	422	class	4		2018-06-26 21:25:14.87594-06	2018-06-27 16:43:32.721-06
235	[{"leafId":350,"en":"attend","es":"asistir"}]	2018-06-27 15:42:22-06	350	to attend	4		2018-06-26 21:25:14.87594-06	2018-06-27 16:43:32.722-06
236	[{"leafId":-15,"en":"(I)","es":"-í"}]	2018-06-27 15:42:54-06	-15	(I learned)	4		2018-06-26 21:25:14.87594-06	2018-06-27 16:43:32.723-06
213	[{"leafId":410,"en":"where","es":"dónde"},{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 12:33:45-06	410,316,-16,380	Where did you learn Spanish?	0		2018-06-26 21:24:51.438947-06	2018-06-27 16:43:32.713-06
215	[{"leafId":316,"en":"learned","es":"aprend-"},{"leafId":-16,"en":"(you)","es":"-iste"}]	2018-06-27 12:33:42-06	316,-16	(you) learned	0		2018-06-26 21:24:51.438947-06	2018-06-27 16:43:32.714-06
218	[{"leafId":-16,"en":"(you)","es":"-iste"}]	2018-06-27 15:42:49-06	-16	(you learned)	3		2018-06-26 21:24:51.438947-06	2018-06-27 16:43:32.715-06
219	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":392,"en":"a","es":"una"},{"leafId":424,"en":"application","es":"aplicación"},{"leafId":427,"en":"mobile phone","es":"móvil"},{"leafId":421,"en":"for","es":"para"},{"leafId":353,"en":"study","es":"estudiar"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 12:32:18-06	352,-6,392,424,427,421,353,380	I created a mobile app to study Spanish.	0		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.716-06
220	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"}]	2018-06-27 12:32:11-06	352,-6	(I) created	0		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.716-06
222	[{"leafId":424,"en":"application","es":"aplicación"}]	2018-06-27 13:56:02-06	424	application	4		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.717-06
223	[{"leafId":427,"en":"mobile phone","es":"móvil"}]	2018-06-27 15:42:28-06	427	mobile phone	4		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.718-06
237	[{"leafId":353,"en":"study","es":"estudi-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-27 13:16:08-06	353,-1,380	I study Spanish.	0		2018-06-27 08:50:29.172548-06	2018-06-27 16:43:32.724-06
238	[{"leafId":353,"en":"study","es":"estudi-"},{"leafId":-1,"en":"(I)","es":"-o"}]	2018-06-27 13:16:03-06	353,-1	(I) study	0		2018-06-27 08:50:29.172548-06	2018-06-27 16:43:32.725-06
369	[{"leafId":349,"en":"live","es":"viv-"},{"leafId":-11,"en":"(I)","es":"-o"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":417,"en":"Longmont","es":"Longmont"}]	2018-06-27 13:15:50-06	349,-11,498,417	I live in Longmont.	0		2018-06-27 13:14:05.021884-06	2018-06-27 16:43:32.725-06
371	[{"leafId":498,"en":"in/on","es":"en"}]	2018-06-27 14:00:42-06	498	in/on	4		2018-06-27 13:14:05.021884-06	2018-06-27 16:43:32.726-06
375	[{"leafId":415,"en":"me","es":"me"},{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":419,"en":"to","es":"a"},{"leafId":417,"en":"Longmont","es":"Longmont"},{"leafId":498,"en":"in/on","es":"en"},{"leafId":423,"en":"January","es":"enero"}]	2018-06-27 14:00:44-06	415,351,-6,419,417,498,423	I moved to Longmont in January.	3		2018-06-27 13:14:36.959357-06	2018-06-27 16:43:32.727-06
491	[{"leafId":391,"en":"a","es":"un"}]	2018-06-27 16:43:16-06	391	a (masc.)	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.771-06
492	[{"leafId":519,"en":"game","es":"juego"}]	2018-06-27 16:43:14-06	519	game	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.772-06
135	[{"leafId":410,"en":"where","es":"dónde"}]	2018-06-27 13:59:45-06	410	where (question)	4		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.669-06
139	[{"leafId":327,"en":"speak","es":"habl-"},{"leafId":-1,"en":"(I)","es":"-o"},{"leafId":380,"en":"Spanish","es":"español"}]	2018-06-26 21:29:10-06	327,-1,380	I speak Spanish.	0		2018-06-26 21:23:11.364754-06	2018-06-27 16:43:32.672-06
205	[{"leafId":413,"en":"with","es":"con"}]	2018-06-27 13:57:39-06	413	with	4		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.709-06
493	[{"leafId":520,"en":"that","es":"que"}]	2018-06-27 16:43:12-06	520	that	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.772-06
206	[{"leafId":414,"en":"who","es":"quién"}]	2018-06-27 13:57:37-06	414	who	4		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.71-06
207	[{"leafId":431,"en":"want","es":"quier-"},{"leafId":-12,"en":"(you)","es":"-es"}]	2018-06-27 12:33:49-06	431,-12	(you) want	0		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.711-06
494	[{"leafId":399,"en":"I","es":"yo"}]	2018-06-27 16:43:11-06	399	I	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.773-06
499	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":391,"en":"a","es":"un"},{"leafId":521,"en":"profile","es":"perfil"}]	\N	352,-6,391,521	I created a profile.	0		2018-06-27 16:38:29.525567-06	2018-06-27 16:43:32.774-06
502	[{"leafId":521,"en":"profile","es":"perfil"}]	2018-06-27 16:43:09-06	521	profile	4		2018-06-27 16:38:29.525567-06	2018-06-27 16:43:32.774-06
505	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-7,"en":"(you)","es":"-aste"},{"leafId":392,"en":"a","es":"una"},{"leafId":517,"en":"account","es":"cuenta"}]	\N	352,-7,392,517	Did you create an account?	0		2018-06-27 16:40:23.223164-06	2018-06-27 16:43:32.775-06
506	[{"leafId":352,"en":"created","es":"cre-"},{"leafId":-7,"en":"(you)","es":"-aste"}]	\N	352,-7	(you) created	0		2018-06-27 16:40:23.223164-06	2018-06-27 16:43:32.776-06
510	[{"leafId":-7,"en":"(you)","es":"-aste"}]	2018-06-27 16:43:04-06	-7	(you worked)	2		2018-06-27 16:40:23.223164-06	2018-06-27 16:43:32.776-06
511	[{"leafId":351,"en":"moved","es":"mud-"},{"leafId":-6,"en":"(I)","es":"-é"},{"leafId":522,"en":"three","es":"tres"},{"leafId":523,"en":"times","es":"veces"}]	\N	351,-6,522,523	I moved three times.	0		2018-06-27 16:42:16.908643-06	2018-06-27 16:43:32.777-06
513	[{"leafId":522,"en":"three","es":"tres"}]	2018-06-27 16:43:02-06	522	three	4		2018-06-27 16:42:16.908643-06	2018-06-27 16:43:32.778-06
514	[{"leafId":523,"en":"times","es":"veces"}]	2018-06-27 16:42:57-06	523	times (occasion)	3		2018-06-27 16:42:16.908643-06	2018-06-27 16:43:32.778-06
\.


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_card_id_seq', 574, true);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, tags_csv, en, es, created_at, updated_at, card_id) FROM stdin;
51		Good morning!	buenos días	2018-06-27 11:32:20.197587-06	2018-06-27 11:32:20.196-06	122
52		Good afternoon!	buenas tardes	2018-06-27 11:33:22.240924-06	2018-06-27 11:33:22.239-06	125
66		I created a mobile app to study Spanish.	creé una aplicación móvil para estudiar español	2018-06-27 11:38:39.11106-06	2018-06-27 11:38:39.11-06	219
54		Where do you live?	dónde vives	2018-06-27 11:33:43.293132-06	2018-06-27 11:33:43.291-06	134
56		I speak English.	hablo inglés	2018-06-27 11:36:31.198704-06	2018-06-27 11:36:31.195-06	144
57		What are you doing?	qué haces	2018-06-27 11:36:42.409091-06	2018-06-27 11:36:42.408-06	155
59		Hello!	hola	2018-06-27 11:36:54.74803-06	2018-06-27 11:36:54.747-06	164
62		I made a list of sentences to learn.	hice una lista de oraciones para aprender	2018-06-27 11:37:30.031693-06	2018-06-27 11:37:30.03-06	185
63		I visited Cuba for a few weeks.	visité Cuba por unas semanas	2018-06-27 11:37:41.944888-06	2018-06-27 11:37:41.944-06	196
88		I didn't create that account	no creé esa cuenta	2018-06-27 16:35:37.782737-06	2018-06-27 16:35:37.781-06	482
89		It's a game that I made	es un juego que yo creé	2018-06-27 16:36:57.80771-06	2018-06-27 16:36:57.806-06	489
90		I created a profile.	creé un perfil	2018-06-27 16:38:29.530083-06	2018-06-27 16:38:29.529-06	499
91		Did you create an account?	creaste una cuenta	2018-06-27 16:40:23.232433-06	2018-06-27 16:40:23.231-06	505
92		I moved three times.	mudé tres veces	2018-06-27 16:42:16.920114-06	2018-06-27 16:42:16.918-06	511
97		I grew up in Pennsylvania.	crecí en Pennsylvania	2018-06-27 17:08:39.852694-06	2018-06-27 17:08:39.851-06	465
64		Who do you want to speak Spanish with?	con quién quieres hablar español	2018-06-27 11:38:01.05192-06	2018-06-27 11:38:01.051-06	204
65		Where did you learn Spanish?	dónde aprendiste español	2018-06-27 11:38:14.912658-06	2018-06-27 11:38:14.911-06	213
67		I took a Spanish class.	asistí una clase de español	2018-06-27 11:39:07.120565-06	2018-06-27 11:39:07.119-06	229
55		I speak Spanish.	hablo español	2018-06-27 11:36:23.881449-06	2018-06-27 11:36:23.88-06	139
86		Did you grow up here?	creciste aquí	2018-06-27 16:17:49.579741-06	2018-06-27 16:17:49.579-06	471
87		I knew him well.	lo conocí bien	2018-06-27 16:21:20.059281-06	2018-06-27 16:21:20.058-06	476
68		I live in Longmont.	vivo en Longmont	2018-06-27 13:14:05.055061-06	2018-06-27 13:14:05.053-06	369
69		I moved to Longmont in January.	me mudé a Longmont en enero	2018-06-27 13:14:36.969027-06	2018-06-27 13:14:36.967-06	375
74		I'm a software engineer.	soy ingeniero de software	2018-06-27 15:22:50.59426-06	2018-06-27 15:22:50.593-06	128
75		I'm well.	estoy bien	2018-06-27 15:23:20.094644-06	2018-06-27 15:23:20.093-06	160
76		I did a test.	hice una prueba	2018-06-27 15:36:09.526577-06	2018-06-27 15:36:09.525-06	418
77		I'm happy.	estoy feliz	2018-06-27 16:00:49.992096-06	2018-06-27 16:00:49.991-06	425
78		I'm alone.	estoy solo	2018-06-27 16:01:36.524009-06	2018-06-27 16:01:36.522-06	429
79		I'm sad.	estoy triste	2018-06-27 16:02:09.873451-06	2018-06-27 16:02:09.872-06	433
80		Did you sell the house yet?	ya vendiste la casa	2018-06-27 16:06:42.83877-06	2018-06-27 16:06:42.838-06	437
81		What did you eat today?	qué comiste hoy	2018-06-27 16:10:43.303767-06	2018-06-27 16:10:43.303-06	444
82		I ate too much.	comí demasiado	2018-06-27 16:11:55.919313-06	2018-06-27 16:11:55.918-06	450
83		I ran outside.	corrí afuera	2018-06-27 16:13:49.833986-06	2018-06-27 16:13:49.833-06	455
84		Why did you run?	porqué corriste	2018-06-27 16:14:35.038984-06	2018-06-27 16:14:35.038-06	460
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 97, true);


--
-- Data for Name: leafs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY leafs (leaf_id, leaf_type, es_mixed, en, en_disambiguation, en_plural, en_past, infinitive_es_mixed, number, person, tense, created_at) FROM stdin;
315	Inf	andar	walk		\N	walked	\N	\N	\N	\N	2018-06-24 09:57:33.983446-06
316	Inf	aprender	learn		\N	learned	\N	\N	\N	\N	2018-06-24 09:57:33.984734-06
317	Inf	comer	eat		\N	ate	\N	\N	\N	\N	2018-06-24 09:57:33.985347-06
319	Inf	contar	tell		\N	told	\N	\N	\N	\N	2018-06-24 09:57:33.98678-06
320	Inf	dar	give		\N	gave	\N	\N	\N	\N	2018-06-24 09:57:33.987309-06
321	Inf	decir	say		\N	said	\N	\N	\N	\N	2018-06-24 09:57:33.987899-06
322	Inf	empezar	start		\N	started	\N	\N	\N	\N	2018-06-24 09:57:33.988574-06
323	Inf	encontrar	find		\N	found	\N	\N	\N	\N	2018-06-24 09:57:33.994568-06
324	Inf	entender	understand		\N	understood	\N	\N	\N	\N	2018-06-24 09:57:34.000548-06
325	Inf	enviar	send		\N	sent	\N	\N	\N	\N	2018-06-24 09:57:34.006513-06
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
339	Inf	salir	go out		\N	went out	\N	\N	\N	\N	2018-06-24 09:57:34.02479-06
340	Inf	seguir	follow		\N	followed	\N	\N	\N	\N	2018-06-24 09:57:34.025256-06
341	Inf	sentir	feel		\N	felt	\N	\N	\N	\N	2018-06-24 09:57:34.026079-06
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
326	Inf	estar	be	how	\N	was	\N	\N	\N	\N	2018-06-24 09:57:34.012434-06
318	Inf	conocer	know	someone	\N	knew	\N	\N	\N	\N	2018-06-24 09:57:33.986019-06
338	Inf	saber	know	something	\N	knew	\N	\N	\N	\N	2018-06-24 09:57:34.024181-06
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
453	UniqV	soy	am	what	\N	\N	ser	1	1	PRES	2018-06-24 10:53:11.331513-06
454	UniqV	eres	are	what	\N	\N	ser	1	2	PRES	2018-06-24 10:53:11.334102-06
455	UniqV	es	is	what	\N	\N	ser	1	3	PRES	2018-06-24 10:53:11.334799-06
456	UniqV	somos	are	what	\N	\N	ser	2	1	PRES	2018-06-24 10:53:11.335596-06
457	UniqV	son	are	what	\N	\N	ser	2	3	PRES	2018-06-24 10:53:11.336235-06
458	UniqV	fui	was	what	\N	\N	ser	1	1	PRET	2018-06-24 10:53:11.336833-06
459	UniqV	fuiste	were	what	\N	\N	ser	1	2	PRET	2018-06-24 10:53:11.337566-06
460	UniqV	fue	was	what	\N	\N	ser	1	3	PRET	2018-06-24 10:53:11.338114-06
461	UniqV	fuimos	were	what	\N	\N	ser	2	1	PRET	2018-06-24 10:53:11.338658-06
462	UniqV	fueron	were	what	\N	\N	ser	2	3	PRET	2018-06-24 10:53:11.339177-06
463	UniqV	estoy	am	how	\N	\N	estar	1	1	PRES	2018-06-24 10:53:11.339723-06
464	UniqV	estás	are	how	\N	\N	estar	1	2	PRES	2018-06-24 10:53:11.340233-06
465	UniqV	está	is	how	\N	\N	estar	1	3	PRES	2018-06-24 10:53:11.340796-06
466	UniqV	están	are	how	\N	\N	estar	2	3	PRES	2018-06-24 10:53:11.341339-06
342	Inf	ser	be	what	\N	was	\N	\N	\N	\N	2018-06-24 09:57:34.026682-06
499	Nonverb	prueba	test		tests	\N	\N	\N	\N	\N	2018-06-27 15:35:58.629886-06
500	Nonverb	feliz	happy		\N	\N	\N	\N	\N	\N	2018-06-27 16:00:33.653382-06
501	Nonverb	solo	alone		\N	\N	\N	\N	\N	\N	2018-06-27 16:01:16.754582-06
502	Nonverb	triste	sad		\N	\N	\N	\N	\N	\N	2018-06-27 16:02:01.449627-06
503	Nonverb	ya	yet		\N	\N	\N	\N	\N	\N	2018-06-27 16:04:47.506244-06
504	Inf	vender	sell		\N	sold	\N	\N	\N	\N	2018-06-27 16:05:02.651479-06
505	Nonverb	casa	house		houses	\N	\N	\N	\N	\N	2018-06-27 16:06:23.119046-06
506	Nonverb	almuerzo	lunch		lunches	\N	\N	\N	\N	\N	2018-06-27 16:10:03.657745-06
507	Nonverb	hoy	today		\N	\N	\N	\N	\N	\N	2018-06-27 16:10:22.676819-06
508	Nonverb	demasiado	too much		\N	\N	\N	\N	\N	\N	2018-06-27 16:11:43.342318-06
509	Inf	correr	run		\N	ran	\N	\N	\N	\N	2018-06-27 16:13:24.686094-06
510	Inf	afuera	outside		\N		\N	\N	\N	\N	2018-06-27 16:13:41.673097-06
511	Nonverb	porqué	why		\N	\N	\N	\N	\N	\N	2018-06-27 16:14:22.939146-06
512	Nonverb	Pennsylvania	Pennsylvania		\N	\N	\N	\N	\N	\N	2018-06-27 16:15:45.409633-06
513	Inf	crecer	grow up		\N	grew up	\N	\N	\N	\N	2018-06-27 16:16:00.615531-06
514	Nonverb	aquí	here		\N	\N	\N	\N	\N	\N	2018-06-27 16:17:37.925483-06
515	Nonverb	lo	him		\N	\N	\N	\N	\N	\N	2018-06-27 16:21:02.916295-06
516	Nonverb	esa	that	fem.	\N	\N	\N	\N	\N	\N	2018-06-27 16:34:31.058747-06
517	Nonverb	cuenta	account		accounts	\N	\N	\N	\N	\N	2018-06-27 16:34:39.097297-06
518	Nonverb	no	not		\N	\N	\N	\N	\N	\N	2018-06-27 16:35:32.851134-06
519	Nonverb	juego	game		games	\N	\N	\N	\N	\N	2018-06-27 16:36:31.585454-06
520	Nonverb	que	that		\N	\N	\N	\N	\N	\N	2018-06-27 16:36:37.387123-06
521	Nonverb	perfil	profile		profiles	\N	\N	\N	\N	\N	2018-06-27 16:38:19.183428-06
522	Nonverb	tres	three		\N	\N	\N	\N	\N	\N	2018-06-27 16:41:20.489311-06
523	Nonverb	vez	time	occasion	times	\N	\N	\N	\N	\N	2018-06-27 16:42:00.67647-06
\.


--
-- Name: leafs_leaf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('leafs_leaf_id_seq', 523, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create goals and cards	SQL	V1__create_goals_and_cards.sql	-13256656	postgres	2018-06-27 09:31:17.379663	46	t
2	2	create leaf tables	SQL	V2__create_leaf_tables.sql	779524700	postgres	2018-06-27 09:31:17.474367	34	t
3	3	create card embeddings	SQL	V3__create_card_embeddings.sql	-552310015	postgres	2018-06-27 19:43:19.226605	42	t
\.


--
-- Name: card_embeddings card_embeddings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY card_embeddings
    ADD CONSTRAINT card_embeddings_pkey PRIMARY KEY (card_embedding_id);


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
-- Name: idx_card_embeddings; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_card_embeddings ON card_embeddings USING btree (longer_card_id, shorter_card_id);


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
-- Name: card_embeddings card_embeddings_longer_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY card_embeddings
    ADD CONSTRAINT card_embeddings_longer_card_id_fkey FOREIGN KEY (longer_card_id) REFERENCES cards(card_id);


--
-- Name: card_embeddings card_embeddings_shorter_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY card_embeddings
    ADD CONSTRAINT card_embeddings_shorter_card_id_fkey FOREIGN KEY (shorter_card_id) REFERENCES cards(card_id);


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

