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

ALTER TABLE ONLY public.leafs DROP CONSTRAINT leafs_infinitive_leaf_id_fkey;
ALTER TABLE ONLY public.card_embeddings DROP CONSTRAINT card_embeddings_shorter_card_id_fkey;
ALTER TABLE ONLY public.card_embeddings DROP CONSTRAINT card_embeddings_longer_card_id_fkey;
DROP INDEX public.schema_version_s_idx;
DROP INDEX public.idx_leafs_fr_mixed;
DROP INDEX public.idx_leafs_es_mixed;
DROP INDEX public.idx_cards_leaf_ids_csv;
DROP INDEX public.idx_card_embeddings;
ALTER TABLE ONLY public.schema_version DROP CONSTRAINT schema_version_pk;
ALTER TABLE ONLY public.paragraphs DROP CONSTRAINT paragraphs_pkey;
ALTER TABLE ONLY public.new_cards DROP CONSTRAINT new_cards_pkey;
ALTER TABLE ONLY public.morphemes DROP CONSTRAINT morphemes_pkey;
ALTER TABLE ONLY public.leafs DROP CONSTRAINT leafs_pkey;
ALTER TABLE ONLY public.goals DROP CONSTRAINT goals_pkey;
ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_pkey;
ALTER TABLE ONLY public.card_embeddings DROP CONSTRAINT card_embeddings_pkey;
ALTER TABLE public.paragraphs ALTER COLUMN paragraph_id DROP DEFAULT;
ALTER TABLE public.new_cards ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.morphemes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.leafs ALTER COLUMN leaf_id DROP DEFAULT;
ALTER TABLE public.goals ALTER COLUMN goal_id DROP DEFAULT;
ALTER TABLE public.cards ALTER COLUMN card_id DROP DEFAULT;
ALTER TABLE public.card_embeddings ALTER COLUMN card_embedding_id DROP DEFAULT;
DROP TABLE public.schema_version;
DROP SEQUENCE public.paragraphs_paragraph_id_seq;
DROP TABLE public.paragraphs;
DROP SEQUENCE public.new_cards_id_seq;
DROP TABLE public.new_cards;
DROP SEQUENCE public.morphemes_id_seq;
DROP TABLE public.morphemes;
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
    en text NOT NULL,
    l2 text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    card_id integer,
    paragraph_id integer DEFAULT 0 NOT NULL
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
    es_mixed text,
    en text NOT NULL,
    en_disambiguation text,
    en_plural text,
    en_past text,
    number integer,
    person integer,
    tense text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    infinitive_leaf_id integer,
    fr_mixed text,
    ar_buckwalter text,
    ar_pres_middle_vowel_buckwalter text,
    persons_csv text,
    gender text,
    CONSTRAINT leafs_ar_buckwalter_check CHECK ((((leaf_type = ANY (ARRAY['ArNonverb'::text, 'ArVRoot'::text, 'ArStemChange'::text, 'ArUniqV'::text, 'ArNoun'::text])) AND (ar_buckwalter IS NOT NULL)) OR ((leaf_type <> ALL (ARRAY['ArNonverb'::text, 'ArVRoot'::text, 'ArStemChange'::text, 'ArUniqV'::text, 'ArNoun'::text])) AND (ar_buckwalter IS NULL)))),
    CONSTRAINT leafs_ar_pres_middle_vowel_buckwalter_check CHECK ((((leaf_type = 'ArVRoot'::text) AND (ar_pres_middle_vowel_buckwalter = ANY (ARRAY['a'::text, 'i'::text, 'u'::text, 'o'::text, '?'::text]))) OR ((leaf_type <> 'ArVRoot'::text) AND (ar_pres_middle_vowel_buckwalter IS NULL)))),
    CONSTRAINT leafs_en_disambiguation_check CHECK ((((leaf_type = ANY (ARRAY['EsUniqV'::text, 'EsStemChange'::text, 'EsNonverb'::text, 'EsInf'::text])) AND (en_disambiguation IS NOT NULL)) OR ((leaf_type <> ALL (ARRAY['EsUniqV'::text, 'EsStemChange'::text, 'EsNonverb'::text, 'EsInf'::text])) AND (en_disambiguation IS NULL)))),
    CONSTRAINT leafs_en_past_check CHECK ((((leaf_type = ANY (ARRAY['EsInf'::text, 'EsStemChange'::text, 'FrInf'::text, 'FrStemChange'::text, 'ArVRoot'::text])) AND (en_past IS NOT NULL)) OR ((leaf_type <> ALL (ARRAY['EsInf'::text, 'EsStemChange'::text, 'FrInf'::text, 'FrStemChange'::text, 'ArVRoot'::text])) AND (en_past IS NULL)))),
    CONSTRAINT leafs_en_plural_check CHECK (((leaf_type = 'EsNonverb'::text) OR ((leaf_type <> 'EsNonverb'::text) AND (en_plural IS NULL)))),
    CONSTRAINT leafs_es_mixed_check CHECK ((((leaf_type = ANY (ARRAY['EsInf'::text, 'EsStemChange'::text, 'EsUniqV'::text, 'EsNonverb'::text])) AND (es_mixed IS NOT NULL)) OR ((leaf_type <> ALL (ARRAY['EsInf'::text, 'EsStemChange'::text, 'EsUniqV'::text, 'EsNonverb'::text])) AND (es_mixed IS NULL)))),
    CONSTRAINT leafs_fr_mixed_check CHECK ((((leaf_type = ANY (ARRAY['FrInf'::text, 'FrUniqV'::text, 'FrNonverb'::text, 'FrStemChange'::text])) AND (fr_mixed IS NOT NULL)) OR ((leaf_type <> ALL (ARRAY['FrInf'::text, 'FrUniqV'::text, 'FrNonverb'::text, 'FrStemChange'::text])) AND (fr_mixed IS NULL)))),
    CONSTRAINT leafs_gender_check CHECK ((((leaf_type = 'ArUniqV'::text) AND (gender = ANY (ARRAY[''::text, 'M'::text, 'F'::text]))) OR ((leaf_type = 'ArNoun'::text) AND (gender = ANY (ARRAY['M'::text, 'F'::text]))) OR ((leaf_type <> ALL (ARRAY['ArUniqV'::text, 'ArNoun'::text])) AND (gender IS NULL)))),
    CONSTRAINT leafs_infinitive_leaf_id_check CHECK ((((leaf_type = ANY (ARRAY['EsUniqV'::text, 'EsStemChange'::text, 'FrUniqV'::text, 'FrStemChange'::text, 'ArStemChange'::text, 'ArUniqV'::text])) AND (infinitive_leaf_id IS NOT NULL)) OR ((leaf_type <> ALL (ARRAY['EsUniqV'::text, 'EsStemChange'::text, 'FrUniqV'::text, 'FrStemChange'::text, 'ArStemChange'::text, 'ArUniqV'::text])) AND (infinitive_leaf_id IS NULL)))),
    CONSTRAINT leafs_leaf_type_check CHECK ((leaf_type = ANY (ARRAY['EsInf'::text, 'EsNonverb'::text, 'EsStemChange'::text, 'EsUniqV'::text, 'FrNonverb'::text, 'FrInf'::text, 'FrUniqV'::text, 'FrStemChange'::text, 'ArNonverb'::text, 'ArVRoot'::text, 'ArStemChange'::text, 'ArUniqV'::text, 'ArNoun'::text]))),
    CONSTRAINT leafs_number_check CHECK ((((leaf_type = ANY (ARRAY['EsUniqV'::text, 'FrUniqV'::text, 'ArUniqV'::text])) AND (number = ANY (ARRAY[1, 2]))) OR ((leaf_type <> ALL (ARRAY['EsUniqV'::text, 'FrUniqV'::text, 'ArUniqV'::text])) AND (number IS NULL)))),
    CONSTRAINT leafs_person_check CHECK ((((leaf_type = ANY (ARRAY['EsUniqV'::text, 'FrUniqV'::text, 'ArUniqV'::text])) AND (person = ANY (ARRAY[1, 2, 3]))) OR ((leaf_type <> ALL (ARRAY['EsUniqV'::text, 'FrUniqV'::text, 'ArUniqV'::text])) AND (person IS NULL)))),
    CONSTRAINT leafs_persons_csv_check CHECK ((((leaf_type = 'ArStemChange'::text) AND (persons_csv = ANY (ARRAY['1,2'::text, '3'::text, '1,2,3'::text]))) OR ((leaf_type <> 'ArStemChange'::text) AND (persons_csv IS NULL)))),
    CONSTRAINT leafs_tense_check CHECK ((((leaf_type = ANY (ARRAY['EsUniqV'::text, 'EsStemChange'::text])) AND (tense = ANY (ARRAY['PRES'::text, 'PRET'::text]))) OR ((leaf_type = ANY (ARRAY['FrUniqV'::text, 'FrStemChange'::text])) AND (tense = 'PRES'::text)) OR ((leaf_type = ANY (ARRAY['ArStemChange'::text, 'ArUniqV'::text])) AND (tense = ANY (ARRAY['PAST'::text, 'PRES'::text]))) OR ((leaf_type <> ALL (ARRAY['EsUniqV'::text, 'EsStemChange'::text, 'FrUniqV'::text, 'FrStemChange'::text, 'ArStemChange'::text, 'ArUniqV'::text])) AND (tense IS NULL))))
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
-- Name: morphemes; Type: TABLE; Schema: public; Owner: dan
--

CREATE TABLE morphemes (
    id integer NOT NULL,
    lang text NOT NULL,
    type text NOT NULL,
    l2 text NOT NULL,
    gloss text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    atoms_json text NOT NULL
);


ALTER TABLE morphemes OWNER TO dan;

--
-- Name: morphemes_id_seq; Type: SEQUENCE; Schema: public; Owner: dan
--

CREATE SEQUENCE morphemes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE morphemes_id_seq OWNER TO dan;

--
-- Name: morphemes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dan
--

ALTER SEQUENCE morphemes_id_seq OWNED BY morphemes.id;


--
-- Name: new_cards; Type: TABLE; Schema: public; Owner: dan
--

CREATE TABLE new_cards (
    id integer NOT NULL,
    lang text NOT NULL,
    type text NOT NULL,
    en_task text,
    en_content text,
    morpheme_ids_csv text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE new_cards OWNER TO dan;

--
-- Name: new_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: dan
--

CREATE SEQUENCE new_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE new_cards_id_seq OWNER TO dan;

--
-- Name: new_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dan
--

ALTER SEQUENCE new_cards_id_seq OWNED BY new_cards.id;


--
-- Name: paragraphs; Type: TABLE; Schema: public; Owner: dan
--

CREATE TABLE paragraphs (
    paragraph_id integer NOT NULL,
    topic text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    lang text NOT NULL
);


ALTER TABLE paragraphs OWNER TO dan;

--
-- Name: paragraphs_paragraph_id_seq; Type: SEQUENCE; Schema: public; Owner: dan
--

CREATE SEQUENCE paragraphs_paragraph_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE paragraphs_paragraph_id_seq OWNER TO dan;

--
-- Name: paragraphs_paragraph_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dan
--

ALTER SEQUENCE paragraphs_paragraph_id_seq OWNED BY paragraphs.paragraph_id;


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
-- Name: morphemes id; Type: DEFAULT; Schema: public; Owner: dan
--

ALTER TABLE ONLY morphemes ALTER COLUMN id SET DEFAULT nextval('morphemes_id_seq'::regclass);


--
-- Name: new_cards id; Type: DEFAULT; Schema: public; Owner: dan
--

ALTER TABLE ONLY new_cards ALTER COLUMN id SET DEFAULT nextval('new_cards_id_seq'::regclass);


--
-- Name: paragraphs paragraph_id; Type: DEFAULT; Schema: public; Owner: dan
--

ALTER TABLE ONLY paragraphs ALTER COLUMN paragraph_id SET DEFAULT nextval('paragraphs_paragraph_id_seq'::regclass);


--
-- Data for Name: card_embeddings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY card_embeddings (card_embedding_id, longer_card_id, shorter_card_id, first_leaf_index, last_leaf_index) FROM stdin;
1	140	142	0	0
3	144	140	0	1
5	144	142	0	0
7	139	140	0	1
9	139	142	0	0
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
163	185	187	2	2
164	185	190	5	5
165	185	191	6	6
166	185	192	7	7
168	185	194	1	1
169	185	188	3	3
170	418	421	3	3
172	418	187	2	2
174	418	194	1	1
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
582	581	132	2	2
587	585	586	0	0
588	585	491	1	1
589	585	588	2	2
597	590	586	0	0
599	590	491	1	1
600	590	593	2	2
608	595	586	0	0
611	595	187	1	1
612	595	222	2	2
624	600	187	0	0
625	600	222	1	1
626	600	191	2	2
627	600	604	3	3
628	600	141	4	4
655	606	187	0	0
656	606	222	1	1
657	606	191	2	2
658	606	192	3	3
659	606	141	4	4
692	612	187	0	0
693	612	222	1	1
694	612	191	2	2
695	612	616	3	3
696	612	617	4	4
698	612	619	6	6
731	628	622	1	1
732	628	624	3	3
733	628	409	0	0
735	628	177	2	2
737	628	633	4	4
738	628	634	5	5
745	636	588	5	5
746	636	622	1	1
747	636	625	4	4
750	636	490	0	0
752	636	177	2	2
753	636	640	3	3
765	644	622	1	1
766	644	624	3	3
771	644	633	4	4
775	644	490	0	0
777	644	177	2	2
780	644	222	5	5
794	652	588	2	2
798	652	653	0	0
799	652	654	1	1
803	652	657	4	4
806	652	659	6	6
815	661	207	0	1
816	661	663	2	2
817	661	664	3	3
818	661	210	0	0
819	661	138	1	1
845	668	664	2	2
846	668	143	1	1
847	669	143	1	1
850	668	190	4	4
855	668	669	0	1
859	668	673	0	0
862	669	673	0	0
880	675	664	2	2
881	675	143	1	1
884	675	187	8	8
898	675	669	0	1
901	675	673	0	0
906	675	679	4	4
907	675	680	5	5
908	675	681	6	7
910	675	683	9	9
913	675	686	6	6
914	675	687	7	7
918	681	686	0	0
919	681	687	1	1
935	688	440	5	5
937	688	490	1	1
942	688	683	6	6
943	688	689	0	0
945	688	691	2	2
946	688	692	3	3
957	697	190	2	2
958	697	156	1	1
960	697	371	0	0
967	697	680	3	3
968	697	681	4	5
971	697	686	4	4
973	697	687	5	5
984	705	624	0	0
988	705	491	4	4
991	705	683	1	1
994	705	692	5	5
997	705	708	2	3
1000	705	711	2	2
1001	705	712	3	3
1003	708	711	0	0
1004	708	712	1	1
1010	714	624	0	0
1016	714	177	4	4
1017	714	190	5	5
1021	714	683	1	1
1028	714	712	3	3
1029	717	712	1	1
1032	714	717	2	3
1035	714	720	2	2
1038	717	720	0	0
1042	722	723	0	0
1043	722	724	1	1
1048	725	153	2	2
1049	727	153	1	1
1053	725	141	3	3
1054	725	483	0	0
1062	725	727	1	2
1064	725	729	1	1
1067	727	729	0	0
1074	732	490	0	0
1077	732	734	1	1
1078	732	735	2	2
1083	737	146	2	2
1086	737	142	0	0
1087	738	142	0	0
1091	737	687	1	1
1092	738	687	1	1
1094	737	738	0	1
1103	742	143	2	2
1105	742	144	1	3
1110	742	146	3	3
1112	742	140	1	2
1115	742	142	1	1
1120	742	491	4	4
1132	742	743	0	0
1136	742	747	5	5
1144	750	141	2	2
1153	750	729	0	0
1154	751	729	0	0
1155	750	751	0	1
1158	750	754	1	1
1161	751	754	1	1
1165	756	153	1	1
1169	756	162	3	3
1174	756	727	0	1
1177	756	729	0	0
1182	756	758	2	2
1188	763	679	0	0
1190	763	734	2	2
1192	763	765	1	1
1199	773	774	0	0
1200	773	775	1	1
1209	776	141	3	3
1210	776	142	0	0
1220	776	687	1	1
1225	776	734	2	2
1229	776	738	0	1
1241	782	143	2	2
1247	782	162	4	4
1249	782	140	1	2
1253	782	142	1	1
1255	782	483	0	0
1272	782	758	3	3
1285	789	162	4	4
1289	789	141	2	2
1290	789	142	0	0
1300	789	687	1	1
1307	789	738	0	1
1314	789	758	3	3
1328	796	483	0	0
1330	796	142	1	1
1333	796	143	2	2
1338	796	140	1	2
1349	782	796	0	2
1435	815	153	2	2
1437	815	483	0	0
1450	815	727	1	2
1453	815	729	1	1
1459	815	818	3	3
1475	827	483	0	0
1489	827	829	1	1
1571	844	751	0	1
1574	844	754	1	1
1579	844	729	0	0
1586	844	818	2	2
1631	122	123	0	0
1632	122	124	1	1
1640	870	142	0	0
1648	870	687	1	1
1651	870	734	2	2
1660	870	738	0	1
1670	870	818	3	3
1730	883	162	5	5
1733	883	142	1	1
1741	883	687	2	2
1744	883	734	0	0
1747	883	758	4	4
1760	883	738	1	2
1770	883	818	3	3
1784	128	409	0	0
1786	891	409	1	1
1787	891	483	0	0
1790	891	735	2	2
1802	896	409	0	0
1804	896	735	1	1
1805	891	896	1	2
1811	128	131	2	2
1812	581	131	1	1
1813	185	131	4	4
1814	612	131	5	5
1816	652	131	3	3
1818	900	131	1	1
1819	900	409	0	0
1820	229	131	4	4
1821	668	131	3	3
1822	675	131	3	3
1823	688	131	4	4
1828	900	903	2	2
1836	905	131	0	0
1840	905	135	1	1
1855	908	131	0	0
1857	908	490	2	2
1861	908	135	1	1
1868	908	734	3	3
1874	908	905	0	1
1881	125	126	0	0
1882	125	127	1	1
1886	917	127	1	1
1888	917	440	0	0
1893	920	691	0	0
1895	920	922	1	1
1898	923	440	0	0
1899	923	724	1	1
1905	926	124	1	1
1907	926	691	0	0
1913	929	126	0	0
1915	929	931	1	1
1918	932	440	0	0
1923	932	931	1	1
1934	935	131	2	2
1935	935	490	1	1
1944	935	734	0	0
1957	935	939	3	3
1967	941	131	1	1
1968	941	409	0	0
1982	941	944	2	2
1990	946	131	0	0
2001	946	948	1	1
2005	949	409	0	0
2007	949	440	1	1
2008	949	724	2	2
2015	949	923	1	2
2023	949	953	3	3
2027	955	409	0	0
2029	955	691	1	1
2033	955	920	1	2
2036	955	922	2	2
2043	955	959	3	3
2095	968	640	3	3
2098	968	131	2	2
2099	968	409	1	1
2100	968	483	0	0
2129	968	973	4	4
2131	977	978	0	0
2132	977	979	1	1
2135	981	982	0	0
2136	981	983	1	1
2139	985	986	0	0
2140	985	987	1	1
2144	989	987	1	1
2145	989	990	0	0
2148	993	994	0	0
2150	993	995	1	1
2152	997	998	0	0
2153	997	999	1	1
2156	1001	1002	0	0
2157	1001	1003	1	1
2161	1005	1003	1	1
2162	1005	1006	0	0
2165	1009	1010	0	0
2166	1009	1011	1	1
2167	1009	1012	2	2
2173	1014	1011	0	0
2174	1014	1012	1	1
2177	1014	1017	2	2
2178	1014	1018	3	3
2179	1014	1019	4	4
2184	1021	998	1	1
2185	1021	1022	0	0
2189	1024	978	0	0
2191	1024	1026	1	2
2192	1024	1027	1	1
2193	1024	1028	2	2
2195	1026	1027	0	0
2196	1026	1028	1	1
2202	1029	982	0	0
2205	1029	1027	1	1
2206	1031	1027	0	0
2208	1029	1031	1	2
2210	1029	1033	2	2
2213	1031	1033	1	1
2217	1034	986	0	0
2220	1034	1027	1	1
2221	1036	1027	0	0
2225	1034	1036	1	2
2227	1034	1038	2	2
2230	1036	1038	1	1
2233	1039	994	0	0
2237	1039	1027	1	1
2238	1041	1027	0	0
2244	1039	1041	1	2
2246	1039	1043	2	2
2249	1041	1043	1	1
2253	1044	998	0	0
2257	1044	1027	1	1
2258	1046	1027	0	0
2266	1044	1046	1	2
2268	1044	1048	2	2
2271	1046	1048	1	1
2275	1049	1002	0	0
2278	1049	1027	1	1
2279	1051	1027	0	0
2289	1049	1051	1	2
2291	1049	1053	2	2
2294	1051	1053	1	1
2298	1054	986	0	0
2302	1054	1038	2	2
2303	1056	1038	1	1
2305	1054	1056	1	2
2306	1054	1057	1	1
2309	1056	1057	0	0
2313	1060	994	0	0
2318	1060	1043	2	2
2319	1062	1043	1	1
2320	1060	1059	1	1
2321	1062	1059	0	0
2323	1060	1062	1	2
2330	1065	990	0	0
2333	1065	1028	2	2
2334	1067	1028	1	1
2337	1065	1057	1	1
2338	1067	1057	0	0
2342	1065	1067	1	2
2349	1071	1002	0	0
2353	1071	1053	2	2
2354	1073	1053	1	1
2357	1071	1057	1	1
2358	1073	1057	0	0
2364	1071	1073	1	2
2372	1077	1011	0	0
2373	1077	1012	1	1
2377	1077	1019	2	2
2383	1082	998	1	1
2386	1082	1010	0	0
2393	1082	1048	3	3
2394	1085	1048	1	1
2395	1082	1059	2	2
2396	1085	1059	0	0
2402	1082	1085	2	3
2442	1097	978	0	0
2446	1097	1028	3	3
2450	1097	1057	2	2
2457	1097	1067	2	3
2464	1097	1093	4	4
2466	1097	1099	1	1
2473	1107	998	1	1
2474	1107	1021	0	1
2477	1107	1022	0	0
2483	1107	1110	2	3
2484	1107	1111	4	4
2485	1107	1112	5	5
2486	1107	1113	2	2
2487	1107	1114	3	3
2489	1110	1113	0	0
2490	1110	1114	1	1
2498	1115	978	0	0
2504	1115	1117	1	2
2505	1115	1118	3	3
2506	1115	1119	4	4
2507	1115	1120	1	1
2508	1115	1121	2	2
2510	1117	1120	0	0
2511	1117	1121	1	1
2518	1123	977	0	1
2521	1123	978	0	0
2522	1123	979	1	1
2528	1123	1126	2	2
2531	1128	978	0	0
2540	1128	1117	1	2
2543	1128	1120	1	1
2545	1128	1121	2	2
2550	1128	1131	3	3
2551	1128	1132	4	4
2552	1128	1133	5	5
2558	1137	977	0	1
2561	1137	978	0	0
2562	1137	979	1	1
2571	1137	1140	2	2
2574	1142	998	0	0
2585	1142	1110	1	2
2588	1142	1111	3	3
2589	1142	1112	4	4
2590	1142	1113	1	1
2592	1142	1114	2	2
2598	1142	1147	5	5
2603	1150	978	0	0
2613	1150	1117	1	2
2616	1150	1118	3	3
2617	1150	1120	1	1
2619	1150	1121	2	2
2631	1150	1154	4	4
2635	1158	977	0	1
2638	1158	978	0	0
2639	1158	979	1	1
2651	1158	1161	2	2
2653	1163	977	0	1
2656	1163	978	0	0
2657	1163	979	1	1
2661	1163	1111	3	3
2674	1163	1166	2	2
2676	1163	1168	4	4
2680	1170	998	0	0
2684	1170	1027	1	1
2692	1170	1044	0	2
2697	1170	1046	1	2
2700	1170	1048	2	2
2711	1170	1168	3	3
2718	1178	998	0	0
2722	1178	1027	1	1
2730	1178	1044	0	2
2735	1178	1046	1	2
2738	1178	1048	2	2
2748	1178	1126	3	3
2759	1184	1185	0	0
2760	1184	1186	1	1
2761	1184	1187	2	2
2766	1188	978	0	0
2777	1188	1190	1	1
2778	1188	1191	2	2
2779	1188	1192	3	3
2780	1188	1193	4	4
2786	1195	1192	0	0
2788	1195	1197	1	1
2790	1198	1199	0	0
2791	1198	1200	1	1
2794	1201	1202	0	0
2795	1201	1203	1	1
2798	1204	1205	0	0
2799	1204	1206	1	3
2800	1204	1207	2	2
2803	1206	1207	1	1
2808	1209	1207	1	1
2809	1211	1207	0	0
2810	1209	1210	0	0
2811	1209	1211	1	2
2818	1214	1207	1	1
2819	1216	1207	0	0
2822	1214	1215	0	0
2823	1214	1216	1	2
2830	1219	1207	1	1
2831	1221	1207	0	0
2836	1219	1220	0	0
2837	1219	1221	1	2
2844	1224	1207	1	1
2845	1226	1207	0	0
2852	1224	1225	0	0
2853	1224	1226	1	2
2860	1229	1207	1	1
2861	1231	1207	0	0
2870	1229	1230	0	0
2871	1229	1231	1	2
2878	1234	1207	1	1
2879	1236	1207	0	0
2890	1234	1235	0	0
2891	1234	1236	1	2
2898	1239	1207	1	1
2899	1241	1207	0	0
2912	1239	1240	0	0
2913	1239	1241	1	2
2920	1244	1207	1	1
2921	1246	1207	0	0
2936	1244	1245	0	0
2937	1244	1246	1	2
2944	1249	1207	1	1
2945	1251	1207	0	0
2962	1249	1250	0	0
2963	1249	1251	1	2
2970	1254	1205	0	0
2972	1254	1207	2	2
2973	1256	1207	1	1
2993	1254	1256	1	3
2999	1259	1207	2	2
3000	1261	1207	1	1
3003	1259	1210	0	0
3024	1259	1261	1	3
3030	1264	1207	2	2
3031	1266	1207	1	1
3036	1264	1215	0	0
3057	1264	1266	1	3
3063	1269	1207	2	2
3064	1271	1207	1	1
3071	1269	1220	0	0
3092	1269	1271	1	3
3098	1274	1207	2	2
3099	1276	1207	1	1
3112	1274	1235	0	0
3129	1274	1276	1	3
3135	1279	1207	2	2
3136	1281	1207	1	1
3151	1279	1240	0	0
3168	1279	1281	1	3
3174	1284	1207	2	2
3175	1286	1207	1	1
3192	1284	1245	0	0
3209	1284	1286	1	3
3215	1289	1207	2	2
3216	1291	1207	1	1
3235	1289	1250	0	0
3252	1289	1291	1	3
3257	1294	1210	0	0
3260	1294	1296	1	3
3261	1294	1297	2	2
3263	1296	1297	1	1
3267	1299	1205	0	0
3270	1299	1301	1	3
3271	1299	1302	2	2
3273	1301	1302	1	1
3277	1305	1205	0	0
3281	1305	1307	1	2
3282	1305	1308	1	1
3284	1307	1308	0	0
3288	1311	1205	0	0
3293	1311	1313	1	2
3294	1311	1314	1	1
3296	1313	1314	0	0
3301	1317	1220	0	0
3303	1317	1319	1	3
3304	1317	1320	2	2
3306	1319	1320	1	1
3310	1323	1245	0	0
3313	1323	1325	1	3
3314	1323	1326	2	2
3316	1325	1326	1	1
3321	1329	1220	0	0
3324	1329	1331	1	3
3325	1329	1332	2	2
3327	1331	1332	1	1
3331	1335	1205	0	0
3337	1335	1337	1	3
3338	1335	1338	2	2
3340	1337	1338	1	1
3344	1341	1225	0	0
3346	1341	1343	1	2
3347	1341	1344	1	1
3349	1343	1344	0	0
3353	1347	1225	0	0
3356	1347	1349	1	2
3357	1347	1350	1	1
3359	1349	1350	0	0
3363	1353	1205	0	0
3369	1353	1346	1	1
3370	1355	1346	0	0
3372	1353	1355	1	2
3378	1358	1220	0	0
3384	1358	1360	1	1
3386	1362	1363	0	0
3387	1362	1364	1	3
3388	1362	1365	2	2
3391	1364	1365	1	1
3394	1368	1369	0	0
3395	1368	1370	1	3
3396	1368	1371	2	2
3399	1370	1371	1	1
3402	1373	1375	0	0
3403	1373	1376	1	1
3408	1377	1375	0	0
3410	1377	1376	1	1
3416	1381	1375	1	1
3418	1381	1376	2	2
3420	1381	1373	1	3
3425	1381	1382	0	0
3430	1386	1375	1	1
3432	1386	1376	2	2
3436	1386	1377	1	3
3442	1386	1382	0	0
3448	1392	1375	0	0
3463	1396	1375	0	0
3464	1397	1375	0	0
3470	1396	1393	2	2
3471	1396	1397	0	1
3474	1396	1400	1	1
3477	1397	1400	1	1
3480	1401	1402	0	0
3481	1401	1403	1	3
3482	1401	1404	2	2
3485	1403	1404	1	1
3489	1406	1210	2	2
3492	1406	1407	0	0
3493	1406	1408	1	1
3498	1410	1215	2	2
3502	1410	1407	0	0
3503	1410	1408	1	1
3508	1414	1205	0	0
3516	1414	1407	1	1
3522	1421	1376	2	2
3523	1423	1376	1	1
3525	1421	1363	0	0
3527	1373	1426	2	2
3530	1381	1426	3	3
3533	1421	1423	1	3
3534	1421	1424	1	1
3536	1421	1426	3	3
3538	1423	1424	0	0
3540	1423	1426	2	2
3545	1427	1376	2	2
3546	1429	1376	1	1
3548	1427	1363	0	0
3551	1377	1432	2	2
3554	1386	1432	3	3
3560	1427	1424	1	1
3561	1429	1424	0	0
3563	1427	1429	1	3
3566	1427	1432	3	3
3570	1429	1432	2	2
3573	1433	1376	2	2
3574	1435	1376	1	1
3581	1433	1382	0	0
3588	1433	1426	3	3
3589	1435	1426	2	2
3593	1433	1435	1	3
3594	1433	1436	1	1
3598	1435	1436	0	0
3603	1439	1376	2	2
3604	1441	1376	1	1
3610	1439	1382	0	0
3620	1439	1432	3	3
3621	1441	1432	2	2
3627	1439	1436	1	1
3628	1441	1436	0	0
3630	1439	1441	1	3
3638	1445	1447	1	1
3641	1449	1451	1	1
3644	1453	1455	1	1
\.


--
-- Name: card_embeddings_card_embedding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('card_embeddings_card_embedding_id_seq', 3646, true);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cards (card_id, gloss_rows_json, last_seen_at, leaf_ids_csv, prompt, stage, mnemonic, created_at, updated_at) FROM stdin;
1091	[{"leafId":614,"en":"me","l2":"me"}]	\N	614	me	5		2018-09-03 09:03:17.864285-06	2018-09-03 09:03:17.854-06
1147	[{"leafId":630,"en":"exactly","l2":"exactement"}]	\N	630	exactly	1		2018-09-03 10:44:59.573471-06	2018-09-03 10:44:59.571-06
1154	[{"leafId":631,"en":"Boston","l2":"Boston"}]	\N	631	Boston	5		2018-09-03 10:45:39.670279-06	2018-09-03 10:45:39.668-06
973	[{"leafId":575,"en":"angels","l2":"angeles"}]	\N	575	angels	1		2018-09-01 17:27:54.366281-06	2018-09-01 17:27:54.364-06
946	[{"leafId":409,"en":"of","l2":"de"},{"leafId":572,"en":"Bolivia","l2":"Bolivia"}]	\N	409,572	from Bolivia	0		2018-09-01 17:21:09.280959-06	2018-09-01 17:21:09.278-06
673	[{"leafId":547,"en":"need","l2":"necesitar"}]	\N	547	to need	1		2018-07-17 08:52:55.119972-06	2018-07-17 08:52:55.118-06
1161	[{"leafId":632,"en":"student","l2":"étudiant"}]	\N	632	student	1		2018-09-03 10:46:05.028706-06	2018-09-03 10:46:05.022-06
1036	[{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-103,"en":"(he/she)","l2":"-e"}]	\N	610,-103	(he/she) speaks	0		2018-09-02 17:18:33.176219-06	2018-09-02 17:18:33.173-06
1038	[{"leafId":-103,"en":"(he/she)","l2":"-e"}]	\N	-103	(he/she speaks)	1		2018-09-02 17:18:33.176219-06	2018-09-02 17:18:33.173-06
652	[{"leafId":539,"en":"is","l2":"hay"},{"leafId":542,"en":"many","l2":"muchos"},{"leafId":524,"en":"programs","l2":"programas"},{"leafId":409,"en":"of","l2":"de"},{"leafId":536,"en":"learning","l2":"aprendizaje"},{"leafId":409,"en":"of","l2":"de"},{"leafId":378,"en":"tongues","l2":"lenguas"}]	\N	539,542,524,409,536,409,378	There are many language learning programs	0		2018-07-17 08:49:36.241636-06	2018-07-17 08:49:36.239-06
653	[{"leafId":539,"en":"is","l2":"hay"}]	\N	539	he/she is (exists)	1		2018-07-17 08:49:36.241636-06	2018-07-17 08:49:36.24-06
654	[{"leafId":542,"en":"many","l2":"muchos"}]	\N	542	many	1		2018-07-17 08:49:36.241636-06	2018-07-17 08:49:36.24-06
657	[{"leafId":536,"en":"learning","l2":"aprendizaje"}]	\N	536	learning	1		2018-07-17 08:49:36.241636-06	2018-07-17 08:49:36.24-06
743	[{"leafId":559,"en":"yes","l2":"sí"}]	2018-08-31 20:07:40-06	559	yes	4		2018-08-31 19:13:13.800644-06	2018-08-31 20:09:49.167-06
659	[{"leafId":378,"en":"tongues","l2":"lenguas"}]	\N	378	tongues	1		2018-07-17 08:49:36.241636-06	2018-07-17 08:49:36.24-06
660	[{"leafId":538,"en":"be","l2":"haber"}]	\N	538	to be (exist)	1		2018-07-17 08:49:36.241636-06	2018-07-17 08:49:36.24-06
152	[{"leafId":317,"en":"eat","l2":"comer"}]	2018-06-27 15:42:40-06	317	to eat	4		2018-06-26 21:23:25.706003-06	2018-06-27 16:43:32.678-06
483	[{"leafId":518,"en":"not","l2":"no"}]	2018-06-27 16:43:25-06	518	not	4		2018-06-27 16:35:37.766885-06	2018-08-31 20:09:49.151-06
661	[{"leafId":431,"en":"want","l2":"quier-"},{"leafId":-12,"en":"(you)","l2":"-es"},{"leafId":544,"en":"listen","l2":"escuchar"},{"leafId":546,"en":"examples","l2":"ejemplos"}]	\N	431,-12,544,546	Do you want to listen to examples?	0		2018-07-17 08:51:53.467863-06	2018-07-17 08:51:53.465-06
131	[{"leafId":409,"en":"of","l2":"de"}]	2018-06-27 13:59:49-06	409	of	4		2018-06-26 21:22:57.352948-06	2018-06-28 12:41:00.484-06
1297	[{"leafId":742,"en":"sit","l2":"jlis"}]	\N	742	to sit	1		2018-09-07 14:11:56.437662-06	2018-09-07 14:11:56.434-06
134	[{"leafId":410,"en":"where","l2":"dónde"},{"leafId":349,"en":"live","l2":"viv-"},{"leafId":-12,"en":"(you)","l2":"-es"}]	2018-06-26 21:29:32-06	410,349,-12	Where do you live?	0		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.668-06
948	[{"leafId":572,"en":"Bolivia","l2":"Bolivia"}]	\N	572	Bolivia	5		2018-09-01 17:21:09.280959-06	2018-09-01 17:21:09.278-06
949	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":390,"en":"the","l2":"la"},{"leafId":556,"en":"lady, ma\\u0027am, Mrs.","l2":"señora"},{"leafId":573,"en":"Garcia","l2":"García"}]	\N	453,390,556,573	I'm Mrs. Garcia.	0		2018-09-01 17:21:42.806026-06	2018-09-01 17:21:42.803-06
953	[{"leafId":573,"en":"Garcia","l2":"García"}]	\N	573	Garcia	1		2018-09-01 17:21:42.806026-06	2018-09-01 17:21:42.803-06
955	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":389,"en":"the","l2":"el"},{"leafId":568,"en":"gentleman","l2":"señor"},{"leafId":574,"en":"Jones","l2":"Jones"}]	\N	453,389,568,574	I'm Mr. Jones.	0		2018-09-01 17:22:05.967308-06	2018-09-01 17:22:05.965-06
959	[{"leafId":574,"en":"Jones","l2":"Jones"}]	\N	574	Jones	5		2018-09-01 17:22:05.967308-06	2018-09-01 17:22:05.965-06
968	[{"leafId":518,"en":"not","l2":"no"},{"leafId":453,"en":"am","l2":"soy"},{"leafId":409,"en":"of","l2":"de"},{"leafId":532,"en":"the","l2":"los"},{"leafId":575,"en":"angels","l2":"angeles"}]	\N	518,453,409,532,575	I'm not from Los Angeles.	0		2018-09-01 17:27:54.366281-06	2018-09-01 17:27:54.364-06
977	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":583,"en":"am","l2":"suis"}]	\N	589,583	I am.	0		2018-09-02 16:46:53.913397-06	2018-09-02 16:46:53.908-06
978	[{"leafId":589,"en":"I/me","l2":"je"}]	\N	589	I/me	1		2018-09-02 16:46:53.913397-06	2018-09-02 16:46:53.908-06
979	[{"leafId":583,"en":"am","l2":"suis"}]	\N	583	I am	1		2018-09-02 16:46:53.913397-06	2018-09-02 16:46:53.908-06
980	[{"leafId":582,"en":"be","l2":"être"}]	\N	582	to be	1		2018-09-02 16:46:53.913397-06	2018-09-02 16:46:53.908-06
981	[{"leafId":590,"en":"you","l2":"tu"},{"leafId":584,"en":"are","l2":"es"}]	\N	590,584	You are.	0		2018-09-02 16:48:08.855588-06	2018-09-02 16:48:08.853-06
982	[{"leafId":590,"en":"you","l2":"tu"}]	\N	590	you	1		2018-09-02 16:48:08.855588-06	2018-09-02 16:48:08.853-06
983	[{"leafId":584,"en":"are","l2":"es"}]	\N	584	you are	1		2018-09-02 16:48:08.855588-06	2018-09-02 16:48:08.853-06
985	[{"leafId":591,"en":"he","l2":"il"},{"leafId":585,"en":"is","l2":"est"}]	\N	591,585	He is.	0		2018-09-02 16:48:38.395058-06	2018-09-02 16:48:38.393-06
986	[{"leafId":591,"en":"he","l2":"il"}]	\N	591	he	1		2018-09-02 16:48:38.395058-06	2018-09-02 16:48:38.393-06
987	[{"leafId":585,"en":"is","l2":"est"}]	\N	585	he/she is	1		2018-09-02 16:48:38.395058-06	2018-09-02 16:48:38.393-06
989	[{"leafId":592,"en":"she","l2":"elle"},{"leafId":585,"en":"is","l2":"est"}]	\N	592,585	She is.	0		2018-09-02 16:48:59.899569-06	2018-09-02 16:48:59.897-06
990	[{"leafId":592,"en":"she","l2":"elle"}]	\N	592	she	1		2018-09-02 16:48:59.899569-06	2018-09-02 16:48:59.897-06
993	[{"leafId":593,"en":"we","l2":"nous"},{"leafId":586,"en":"are","l2":"sommes"}]	\N	593,586	We are.	0		2018-09-02 16:49:20.074875-06	2018-09-02 16:49:20.072-06
995	[{"leafId":586,"en":"are","l2":"sommes"}]	\N	586	we are	1		2018-09-02 16:49:20.074875-06	2018-09-02 16:49:20.072-06
136	[{"leafId":349,"en":"live","l2":"viv-"},{"leafId":-12,"en":"(you)","l2":"-es"}]	2018-06-26 21:29:28-06	349,-12	(you) live	0		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.67-06
1017	[{"leafId":606,"en":"very","l2":"très"}]	\N	606	very	1		2018-09-02 16:55:18.451886-06	2018-09-02 16:55:18.45-06
1018	[{"leafId":607,"en":"well","l2":"bien"}]	\N	607	well	1		2018-09-02 16:55:18.451886-06	2018-09-02 16:55:18.45-06
1111	[{"leafId":620,"en":"from","l2":"d\\u0027"}]	\N	620	from	1		2018-09-03 10:41:36.623821-06	2018-09-03 10:41:36.618-06
1208	[{"leafId":-225,"en":"(we)","l2":"na-"},{"leafId":-225,"en":"write","l2":"ktub-"},{"leafId":-225,"en":"(we)","l2":"-u"}]	\N	-225,-225,-225	(we write)	0		2018-09-07 13:58:35.727558-06	2018-09-07 13:58:35.725-06
206	[{"leafId":414,"en":"who","l2":"quién"}]	2018-06-27 13:57:37-06	414	who	4		2018-06-26 21:24:42.777343-06	2018-06-28 12:41:00.537-06
734	[{"leafId":557,"en":"you","l2":"usted"}]	2018-08-31 20:06:45-06	557	you (formal)	4		2018-08-31 19:11:55.626087-06	2018-08-31 20:09:49.161-06
903	[{"leafId":567,"en":"Chicago","l2":"Chicago"}]	\N	567	Chicago	5		2018-09-01 17:09:14.535417-06	2018-09-01 17:09:14.534-06
905	[{"leafId":409,"en":"of","l2":"de"},{"leafId":410,"en":"where","l2":"dónde"}]	\N	409,410	From where?	0		2018-09-01 17:10:05.224125-06	2018-09-01 17:10:05.223-06
908	[{"leafId":409,"en":"of","l2":"de"},{"leafId":410,"en":"where","l2":"dónde"},{"leafId":455,"en":"is","l2":"es"},{"leafId":557,"en":"you","l2":"usted"}]	\N	409,410,455,557	Where are you from? (formal)	0		2018-09-01 17:10:23.669103-06	2018-09-01 17:10:23.668-06
917	[{"leafId":390,"en":"the","l2":"la"},{"leafId":383,"en":"afternoon","l2":"tarde"}]	\N	390,383	the afternoon	0		2018-09-01 17:11:18.608673-06	2018-09-01 17:11:18.606-06
920	[{"leafId":389,"en":"the","l2":"el"},{"leafId":568,"en":"gentleman","l2":"señor"}]	\N	389,568	the gentleman	0		2018-09-01 17:12:59.63222-06	2018-09-01 17:12:59.631-06
1243	[{"leafId":-207,"en":"wrote","l2":"katab-"},{"leafId":-207,"en":"(you)","l2":"-otun~a"}]	\N	-207,-207	(you wrote)	0		2018-09-07 14:00:12.411998-06	2018-09-07 14:00:12.411-06
1244	[{"leafId":739,"en":"they (masc.)","l2":"humo"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-208,"en":"(they)","l2":"-uwA"}]	\N	739,729,-208	They (masc.) wrote.	0		2018-09-07 14:00:24.824393-06	2018-09-07 14:00:24.823-06
1246	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-208,"en":"(they)","l2":"-uwA"}]	\N	729,-208	(they) wrote	0		2018-09-07 14:00:24.824393-06	2018-09-07 14:00:24.823-06
1249	[{"leafId":740,"en":"they (fem.)","l2":"hun~a"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-209,"en":"(they)","l2":"-ona"}]	\N	740,729,-209	They (fem.) wrote.	0		2018-09-07 14:00:41.274739-06	2018-09-07 14:00:41.273-06
1263	[{"leafId":-221,"en":"(you)","l2":"ta-"},{"leafId":-221,"en":"write","l2":"ktub-"},{"leafId":-221,"en":"(you)","l2":"-u"}]	\N	-221,-221,-221	(you write)	0		2018-09-07 14:01:26.347053-06	2018-09-07 14:01:26.346-06
1264	[{"leafId":733,"en":"you (fem.)","l2":">anoti"},{"leafId":-222,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-222,"en":"(you)","l2":"-iyna"}]	\N	733,-222,729,-222	You (fem.) write.	0		2018-09-07 14:01:41.57602-06	2018-09-07 14:01:41.574-06
1266	[{"leafId":-222,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-222,"en":"(you)","l2":"-iyna"}]	\N	-222,729,-222	(you) write	0		2018-09-07 14:01:41.57602-06	2018-09-07 14:01:41.574-06
1268	[{"leafId":-222,"en":"(you)","l2":"ta-"},{"leafId":-222,"en":"write","l2":"ktub-"},{"leafId":-222,"en":"(you)","l2":"-iyna"}]	\N	-222,-222,-222	(you write)	0		2018-09-07 14:01:41.57602-06	2018-09-07 14:01:41.575-06
1269	[{"leafId":734,"en":"he","l2":"huwa"},{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	734,-223,729,-223	He writes.	0		2018-09-07 14:01:51.375131-06	2018-09-07 14:01:51.374-06
1271	[{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	-223,729,-223	(he/she) writes	0		2018-09-07 14:01:51.375131-06	2018-09-07 14:01:51.374-06
1273	[{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":-223,"en":"writes","l2":"ktub-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	-223,-223,-223	(he/she writes)	0		2018-09-07 14:01:51.375131-06	2018-09-07 14:01:51.374-06
997	[{"leafId":594,"en":"you all","l2":"vous"},{"leafId":587,"en":"are","l2":"êtes"}]	\N	594,587	You are. (pl.)	0		2018-09-02 16:49:52.69405-06	2018-09-02 16:49:52.692-06
998	[{"leafId":594,"en":"you all","l2":"vous"}]	\N	594	you all	1		2018-09-02 16:49:52.69405-06	2018-09-02 16:49:52.692-06
999	[{"leafId":587,"en":"are","l2":"êtes"}]	\N	587	null are	1		2018-09-02 16:49:52.69405-06	2018-09-02 16:49:52.692-06
1001	[{"leafId":595,"en":"they (masc.)","l2":"ils"},{"leafId":588,"en":"are","l2":"sont"}]	\N	595,588	They are. (masc.)	0		2018-09-02 16:50:59.551823-06	2018-09-02 16:50:59.55-06
1002	[{"leafId":595,"en":"they (masc.)","l2":"ils"}]	\N	595	they (masc.)	1		2018-09-02 16:50:59.551823-06	2018-09-02 16:50:59.55-06
1003	[{"leafId":588,"en":"are","l2":"sont"}]	\N	588	they are	1		2018-09-02 16:50:59.551823-06	2018-09-02 16:50:59.55-06
1005	[{"leafId":596,"en":"they (fem.)","l2":"elles"},{"leafId":588,"en":"are","l2":"sont"}]	\N	596,588	They are. (fem.)	0		2018-09-02 16:51:13.354222-06	2018-09-02 16:51:13.352-06
1006	[{"leafId":596,"en":"they (fem.)","l2":"elles"}]	\N	596	they (fem.)	1		2018-09-02 16:51:13.354222-06	2018-09-02 16:51:13.352-06
1009	[{"leafId":604,"en":"how","l2":"comment"},{"leafId":605,"en":"it","l2":"ça"},{"leafId":600,"en":"goes","l2":"va"}]	\N	604,605,600	How's it going?	0		2018-09-02 16:54:37.503502-06	2018-09-02 16:54:37.502-06
1010	[{"leafId":604,"en":"how","l2":"comment"}]	\N	604	how	1		2018-09-02 16:54:37.503502-06	2018-09-02 16:54:37.502-06
1011	[{"leafId":605,"en":"it","l2":"ça"}]	\N	605	it	1		2018-09-02 16:54:37.503502-06	2018-09-02 16:54:37.502-06
1012	[{"leafId":600,"en":"goes","l2":"va"}]	\N	600	he/she goes	1		2018-09-02 16:54:37.503502-06	2018-09-02 16:54:37.502-06
1013	[{"leafId":597,"en":"go","l2":"aller"}]	\N	597	to go	1		2018-09-02 16:54:37.503502-06	2018-09-02 16:54:37.502-06
461	[{"leafId":511,"en":"why","l2":"porqué"}]	2018-06-27 16:31:14-06	511	why	4		2018-06-27 16:14:35.029309-06	2018-06-27 16:43:32.755-06
1014	[{"leafId":605,"en":"it","l2":"ça"},{"leafId":600,"en":"goes","l2":"va"},{"leafId":606,"en":"very","l2":"très"},{"leafId":607,"en":"well","l2":"bien"},{"leafId":608,"en":"thanks","l2":"merci"}]	\N	605,600,606,607,608	It's going very well, thanks.	0		2018-09-02 16:55:18.451886-06	2018-09-02 16:55:18.45-06
1019	[{"leafId":608,"en":"thanks","l2":"merci"}]	\N	608	thanks	1		2018-09-02 16:55:18.451886-06	2018-09-02 16:55:18.45-06
604	[{"leafId":526,"en":"practice","l2":"practicar"}]	\N	526	to practice	1		2018-07-17 08:27:37.719766-06	2018-07-17 08:27:37.718-06
1021	[{"leafId":609,"en":"and","l2":"et"},{"leafId":594,"en":"you all","l2":"vous"}]	\N	609,594	And you? (formal)	0		2018-09-02 16:55:45.700067-06	2018-09-02 16:55:45.699-06
1022	[{"leafId":609,"en":"and","l2":"et"}]	\N	609	and	1		2018-09-02 16:55:45.700067-06	2018-09-02 16:55:45.699-06
1024	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-101,"en":"(I)","l2":"-e"}]	\N	589,610,-101	I speak.	0		2018-09-02 17:17:58.945208-06	2018-09-02 17:17:58.94-06
1026	[{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-101,"en":"(I)","l2":"-e"}]	\N	610,-101	(I) speak	0		2018-09-02 17:17:58.945208-06	2018-09-02 17:17:58.941-06
1027	[{"leafId":610,"en":"speak","l2":"parler"}]	\N	610	to speak	1		2018-09-02 17:17:58.945208-06	2018-09-02 17:17:58.941-06
1028	[{"leafId":-101,"en":"(I)","l2":"-e"}]	\N	-101	(I speak)	1		2018-09-02 17:17:58.945208-06	2018-09-02 17:17:58.941-06
1029	[{"leafId":590,"en":"you","l2":"tu"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-102,"en":"(you)","l2":"-es"}]	\N	590,610,-102	You speak.	0		2018-09-02 17:18:18.323576-06	2018-09-02 17:18:18.322-06
1031	[{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-102,"en":"(you)","l2":"-es"}]	\N	610,-102	(you) speak	0		2018-09-02 17:18:18.323576-06	2018-09-02 17:18:18.322-06
1033	[{"leafId":-102,"en":"(you)","l2":"-es"}]	\N	-102	(you speak)	1		2018-09-02 17:18:18.323576-06	2018-09-02 17:18:18.322-06
1034	[{"leafId":591,"en":"he","l2":"il"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-103,"en":"(he/she)","l2":"-e"}]	\N	591,610,-103	He speaks.	0		2018-09-02 17:18:33.176219-06	2018-09-02 17:18:33.173-06
1039	[{"leafId":593,"en":"we","l2":"nous"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-104,"en":"(we)","l2":"-ons"}]	\N	593,610,-104	We speak.	0		2018-09-02 17:18:47.034566-06	2018-09-02 17:18:47.032-06
1041	[{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-104,"en":"(we)","l2":"-ons"}]	\N	610,-104	(we) speak	0		2018-09-02 17:18:47.034566-06	2018-09-02 17:18:47.032-06
1043	[{"leafId":-104,"en":"(we)","l2":"-ons"}]	\N	-104	(we speak)	1		2018-09-02 17:18:47.034566-06	2018-09-02 17:18:47.032-06
1044	[{"leafId":594,"en":"you all","l2":"vous"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-105,"en":"(we)","l2":"-ez"}]	\N	594,610,-105	You speak. (pl.)	0		2018-09-02 17:19:01.169922-06	2018-09-02 17:19:01.168-06
1046	[{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-105,"en":"(we)","l2":"-ez"}]	\N	610,-105	(we) speak	0		2018-09-02 17:19:01.169922-06	2018-09-02 17:19:01.168-06
1048	[{"leafId":-105,"en":"(we)","l2":"-ez"}]	\N	-105	(we speak)	1		2018-09-02 17:19:01.169922-06	2018-09-02 17:19:01.168-06
1049	[{"leafId":595,"en":"they (masc.)","l2":"ils"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-106,"en":"(they)","l2":"-ent"}]	\N	595,610,-106	They speak.	0		2018-09-02 17:19:21.828227-06	2018-09-02 17:19:21.825-06
634	[{"leafId":535,"en":"persons","l2":"personas"}]	\N	535	persons	1		2018-07-17 08:35:15.151412-06	2018-07-17 08:35:15.149-06
215	[{"leafId":316,"en":"learned","l2":"aprend-"},{"leafId":-16,"en":"(you)","l2":"-iste"}]	2018-06-28 12:40:39-06	316,-16	(you) learned	4		2018-06-26 21:24:51.438947-06	2018-06-28 12:41:00.541-06
1051	[{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-106,"en":"(they)","l2":"-ent"}]	\N	610,-106	(they) speak	0		2018-09-02 17:19:21.828227-06	2018-09-02 17:19:21.825-06
1053	[{"leafId":-106,"en":"(they)","l2":"-ent"}]	\N	-106	(they speak)	1		2018-09-02 17:19:21.828227-06	2018-09-02 17:19:21.825-06
1054	[{"leafId":591,"en":"he","l2":"il"},{"leafId":613,"en":"call","l2":"appell"},{"leafId":-103,"en":"(he/she)","l2":"-e"}]	\N	591,613,-103	He calls.	0		2018-09-03 01:46:19.399464-06	2018-09-03 01:46:19.392-06
1056	[{"leafId":613,"en":"call","l2":"appell"},{"leafId":-103,"en":"(he/she)","l2":"-e"}]	\N	613,-103	(he/she) calls	0		2018-09-03 01:46:19.399464-06	2018-09-03 01:46:19.393-06
1057	[{"leafId":613,"en":"call","l2":"appell"}]	\N	613	Stem change for appeler in PRES	1		2018-09-03 01:46:19.399464-06	2018-09-03 01:46:19.393-06
1059	[{"leafId":611,"en":"call","l2":"appeler"}]	\N	611	to call	1		2018-09-03 01:46:19.399464-06	2018-09-03 01:46:19.393-06
1060	[{"leafId":593,"en":"we","l2":"nous"},{"leafId":611,"en":"call","l2":"appel-"},{"leafId":-104,"en":"(we)","l2":"-ons"}]	\N	593,611,-104	We call.	0		2018-09-03 01:57:58.767856-06	2018-09-03 01:57:58.763-06
1062	[{"leafId":611,"en":"call","l2":"appel-"},{"leafId":-104,"en":"(we)","l2":"-ons"}]	\N	611,-104	(we) call	0		2018-09-03 01:57:58.767856-06	2018-09-03 01:57:58.763-06
1065	[{"leafId":592,"en":"she","l2":"elle"},{"leafId":613,"en":"call","l2":"appell-"},{"leafId":-101,"en":"(I)","l2":"-e"}]	\N	592,613,-101	She calls.	0		2018-09-03 01:58:13.571453-06	2018-09-03 01:58:13.568-06
1067	[{"leafId":613,"en":"call","l2":"appell-"},{"leafId":-101,"en":"(I)","l2":"-e"}]	\N	613,-101	(I) call	0		2018-09-03 01:58:13.571453-06	2018-09-03 01:58:13.568-06
1071	[{"leafId":595,"en":"they (masc.)","l2":"ils"},{"leafId":613,"en":"call","l2":"appell-"},{"leafId":-106,"en":"(they)","l2":"-ent"}]	\N	595,613,-106	They call.	0		2018-09-03 02:03:42.540446-06	2018-09-03 02:03:42.533-06
1073	[{"leafId":613,"en":"call","l2":"appell-"},{"leafId":-106,"en":"(they)","l2":"-ent"}]	\N	613,-106	(they) call	0		2018-09-03 02:03:42.540446-06	2018-09-03 02:03:42.535-06
1248	[{"leafId":-208,"en":"wrote","l2":"katab-"},{"leafId":-208,"en":"(they)","l2":"-uwA"}]	\N	-208,-208	(they wrote)	0		2018-09-07 14:00:24.824393-06	2018-09-07 14:00:24.823-06
1077	[{"leafId":605,"en":"it","l2":"ça"},{"leafId":600,"en":"goes","l2":"va"},{"leafId":608,"en":"thanks","l2":"merci"}]	\N	605,600,608	It's going well, thanks.	0		2018-09-03 07:40:24.725002-06	2018-09-03 07:40:24.72-06
1082	[{"leafId":604,"en":"how","l2":"comment"},{"leafId":594,"en":"you all","l2":"vous"},{"leafId":611,"en":"call","l2":"appel-"},{"leafId":-105,"en":"(we)","l2":"-ez"},{"leafId":594,"en":"you all","l2":"vous"}]	\N	604,594,611,-105,594	What do you call yourself?	0		2018-09-03 07:40:54.242283-06	2018-09-03 07:40:54.239-06
1085	[{"leafId":611,"en":"call","l2":"appel-"},{"leafId":-105,"en":"(we)","l2":"-ez"}]	\N	611,-105	(we) call	0		2018-09-03 07:40:54.242283-06	2018-09-03 07:40:54.239-06
1093	[{"leafId":615,"en":"Pat","l2":"Pat"}]	\N	615	Pat	5		2018-09-03 09:03:17.864285-06	2018-09-03 09:03:17.858-06
1097	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":616,"en":"me","l2":"m\\u0027"},{"leafId":613,"en":"call","l2":"appell-"},{"leafId":-101,"en":"(I)","l2":"-e"},{"leafId":615,"en":"Pat","l2":"Pat"}]	\N	589,616,613,-101,615	I call myself Pat.	0		2018-09-03 09:06:47.279612-06	2018-09-03 09:06:47.274-06
1099	[{"leafId":616,"en":"me","l2":"m\\u0027"}]	\N	616	me	1		2018-09-03 09:06:47.279612-06	2018-09-03 09:06:47.275-06
1105	[{"leafId":617,"en":"enchanted","l2":"enchanté"}]	\N	617	Enchanted.	1		2018-09-03 10:13:44.473515-06	2018-09-03 10:13:44.471-06
513	[{"leafId":522,"en":"three","l2":"tres"}]	2018-06-27 16:43:02-06	522	three	4		2018-06-27 16:42:16.908643-06	2018-06-27 16:43:32.778-06
1107	[{"leafId":609,"en":"and","l2":"et"},{"leafId":594,"en":"you all","l2":"vous"},{"leafId":618,"en":"come","l2":"v-"},{"leafId":-115,"en":"(you)","l2":"-enez"},{"leafId":620,"en":"from","l2":"d\\u0027"},{"leafId":621,"en":"where","l2":"où"}]	\N	609,594,618,-115,620,621	And you come from where? (formal)	0		2018-09-03 10:41:36.623821-06	2018-09-03 10:41:36.617-06
1110	[{"leafId":618,"en":"come","l2":"v-"},{"leafId":-115,"en":"(you)","l2":"-enez"}]	\N	618,-115	(you) come	0		2018-09-03 10:41:36.623821-06	2018-09-03 10:41:36.618-06
1112	[{"leafId":621,"en":"where","l2":"où"}]	\N	621	where	1		2018-09-03 10:41:36.623821-06	2018-09-03 10:41:36.618-06
1113	[{"leafId":618,"en":"come","l2":"venir"}]	\N	618	to come	1		2018-09-03 10:41:36.623821-06	2018-09-03 10:41:36.618-06
1114	[{"leafId":-115,"en":"(you)","l2":"-enez"}]	\N	-115	(you come)	1		2018-09-03 10:41:36.623821-06	2018-09-03 10:41:36.618-06
1115	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":619,"en":"come","l2":"vien-"},{"leafId":-111,"en":"(I)","l2":"-iens"},{"leafId":623,"en":"from","l2":"de"},{"leafId":624,"en":"France","l2":"France"}]	\N	589,619,-111,623,624	I come from France.	0		2018-09-03 10:42:20.266468-06	2018-09-03 10:42:20.258-06
1117	[{"leafId":619,"en":"come","l2":"vien-"},{"leafId":-111,"en":"(I)","l2":"-iens"}]	\N	619,-111	(I) come	0		2018-09-03 10:42:20.266468-06	2018-09-03 10:42:20.258-06
1118	[{"leafId":623,"en":"from","l2":"de"}]	\N	623	from	1		2018-09-03 10:42:20.266468-06	2018-09-03 10:42:20.258-06
1119	[{"leafId":624,"en":"France","l2":"France"}]	\N	624	France	5		2018-09-03 10:42:20.266468-06	2018-09-03 10:42:20.258-06
1120	[{"leafId":619,"en":"come","l2":"vien-"}]	\N	619	Stem change for venir in PRES	1		2018-09-03 10:42:20.266468-06	2018-09-03 10:42:20.258-06
1121	[{"leafId":-111,"en":"(I)","l2":"-iens"}]	\N	-111	(I come)	1		2018-09-03 10:42:20.266468-06	2018-09-03 10:42:20.259-06
1123	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":583,"en":"am","l2":"suis"},{"leafId":625,"en":"French","l2":"français"}]	\N	589,583,625	I am French. (masc.)	0		2018-09-03 10:42:42.689761-06	2018-09-03 10:42:42.687-06
1126	[{"leafId":625,"en":"French","l2":"français"}]	\N	625	French	1		2018-09-03 10:42:42.689761-06	2018-09-03 10:42:42.687-06
1128	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":619,"en":"come","l2":"vien-"},{"leafId":-111,"en":"(I)","l2":"-iens"},{"leafId":626,"en":"from","l2":"des"},{"leafId":627,"en":"states","l2":"états"},{"leafId":628,"en":"united","l2":"unis"}]	\N	589,619,-111,626,627,628	I come from the United States.	0		2018-09-03 10:44:02.894182-06	2018-09-03 10:44:02.89-06
1132	[{"leafId":627,"en":"states","l2":"états"}]	\N	627	states	1		2018-09-03 10:44:02.894182-06	2018-09-03 10:44:02.89-06
1133	[{"leafId":628,"en":"united","l2":"unis"}]	\N	628	united	1		2018-09-03 10:44:02.894182-06	2018-09-03 10:44:02.89-06
1137	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":583,"en":"am","l2":"suis"},{"leafId":629,"en":"American","l2":"américain"}]	\N	589,583,629	I am American.	0		2018-09-03 10:44:28.944079-06	2018-09-03 10:44:28.942-06
1140	[{"leafId":629,"en":"American","l2":"américain"}]	\N	629	American	1		2018-09-03 10:44:28.944079-06	2018-09-03 10:44:28.943-06
1142	[{"leafId":594,"en":"you all","l2":"vous"},{"leafId":618,"en":"come","l2":"v-"},{"leafId":-115,"en":"(you)","l2":"-enez"},{"leafId":620,"en":"from","l2":"d\\u0027"},{"leafId":621,"en":"where","l2":"où"},{"leafId":630,"en":"exactly","l2":"exactement"}]	\N	594,618,-115,620,621,630	You come from where exactly? (formal)	0		2018-09-03 10:44:59.573471-06	2018-09-03 10:44:59.571-06
691	[{"leafId":389,"en":"the","l2":"el"}]	\N	389	the (masc.)	1		2018-07-17 08:56:07.444174-06	2018-07-17 08:56:07.443-06
1150	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":619,"en":"come","l2":"vien-"},{"leafId":-111,"en":"(I)","l2":"-iens"},{"leafId":623,"en":"from","l2":"de"},{"leafId":631,"en":"Boston","l2":"Boston"}]	\N	589,619,-111,623,631	I come from Boston.	0		2018-09-03 10:45:39.670279-06	2018-09-03 10:45:39.668-06
1158	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":583,"en":"am","l2":"suis"},{"leafId":632,"en":"student","l2":"étudiant"}]	\N	589,583,632	I am a student.	0		2018-09-03 10:46:05.028706-06	2018-09-03 10:46:05.022-06
1163	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":583,"en":"am","l2":"suis"},{"leafId":633,"en":"professor","l2":"professeur"},{"leafId":620,"en":"from","l2":"d\\u0027"},{"leafId":634,"en":"English","l2":"anglais"}]	\N	589,583,633,620,634	I'm an professor of English.	0		2018-09-03 10:47:02.83699-06	2018-09-03 10:47:02.835-06
1166	[{"leafId":633,"en":"professor","l2":"professeur"}]	\N	633	professor	1		2018-09-03 10:47:02.83699-06	2018-09-03 10:47:02.835-06
1168	[{"leafId":634,"en":"English","l2":"anglais"}]	\N	634	English	1		2018-09-03 10:47:02.83699-06	2018-09-03 10:47:02.835-06
1170	[{"leafId":594,"en":"you all","l2":"vous"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-105,"en":"(you)","l2":"-ez"},{"leafId":634,"en":"English","l2":"anglais"}]	\N	594,610,-105,634	You speak English? (formal)	0		2018-09-03 10:47:22.294687-06	2018-09-03 10:47:22.293-06
1176	[{"leafId":635,"en":"yes","l2":"oui"}]	\N	635	Yes.	1		2018-09-03 10:47:45.268003-06	2018-09-03 10:47:45.267-06
1178	[{"leafId":594,"en":"you all","l2":"vous"},{"leafId":610,"en":"speak","l2":"parl-"},{"leafId":-105,"en":"(you)","l2":"-ez"},{"leafId":625,"en":"French","l2":"français"}]	\N	594,610,-105,625	You speak French? (formal)	0		2018-09-03 10:48:05.38478-06	2018-09-03 10:48:05.383-06
1184	[{"leafId":636,"en":"a","l2":"un"},{"leafId":637,"en":"little","l2":"petit"},{"leafId":638,"en":"bit","l2":"peu"}]	\N	636,637,638	A little bit.	0		2018-09-03 10:48:55.320384-06	2018-09-03 10:48:55.318-06
1185	[{"leafId":636,"en":"a","l2":"un"}]	\N	636	a	1		2018-09-03 10:48:55.320384-06	2018-09-03 10:48:55.318-06
1186	[{"leafId":637,"en":"little","l2":"petit"}]	\N	637	little	1		2018-09-03 10:48:55.320384-06	2018-09-03 10:48:55.318-06
1187	[{"leafId":638,"en":"bit","l2":"peu"}]	\N	638	bit	1		2018-09-03 10:48:55.320384-06	2018-09-03 10:48:55.318-06
1188	[{"leafId":589,"en":"I/me","l2":"je"},{"leafId":598,"en":"go","l2":"vais"},{"leafId":639,"en":"home","l2":"chez"},{"leafId":640,"en":"my","l2":"moi"},{"leafId":641,"en":"now","l2":"maintenant"}]	\N	589,598,639,640,641	I'm going to my home now.	0		2018-09-03 10:50:14.129822-06	2018-09-03 10:50:14.128-06
1191	[{"leafId":639,"en":"home","l2":"chez"}]	\N	639	home	1		2018-09-03 10:50:14.129822-06	2018-09-03 10:50:14.128-06
1192	[{"leafId":640,"en":"my","l2":"moi"}]	\N	640	my	1		2018-09-03 10:50:14.129822-06	2018-09-03 10:50:14.128-06
1193	[{"leafId":641,"en":"now","l2":"maintenant"}]	\N	641	now	1		2018-09-03 10:50:14.129822-06	2018-09-03 10:50:14.128-06
1195	[{"leafId":640,"en":"my","l2":"moi"},{"leafId":642,"en":"also","l2":"aussi"}]	\N	640,642	Me too.	0		2018-09-03 10:50:39.87576-06	2018-09-03 10:50:39.874-06
1198	[{"leafId":643,"en":"to the","l2":"Au"},{"leafId":644,"en":"seeing again","l2":"revoir"}]	\N	643,644	Goodbye!	0		2018-09-03 10:52:25.893737-06	2018-09-03 10:52:25.893-06
1199	[{"leafId":643,"en":"to the","l2":"Au"}]	\N	643	to the	1		2018-09-03 10:52:25.893737-06	2018-09-03 10:52:25.893-06
1200	[{"leafId":644,"en":"seeing again","l2":"revoir"}]	\N	644	seeing again	1		2018-09-03 10:52:25.893737-06	2018-09-03 10:52:25.893-06
1201	[{"leafId":645,"en":"good","l2":"bonne"},{"leafId":646,"en":"day","l2":"journée"}]	\N	645,646	Good day!	0		2018-09-03 10:53:12.939458-06	2018-09-03 10:53:12.938-06
1202	[{"leafId":645,"en":"good","l2":"bonne"}]	\N	645	good	1		2018-09-03 10:53:12.939458-06	2018-09-03 10:53:12.938-06
1203	[{"leafId":646,"en":"day","l2":"journée"}]	\N	646	day	1		2018-09-03 10:53:12.939458-06	2018-09-03 10:53:12.938-06
1204	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":-225,"en":"(we)","l2":"na-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-225,"en":"(we)","l2":"-u"}]	\N	731,-225,729,-225	I wrote.	0		2018-09-07 13:58:35.727558-06	2018-09-07 13:58:35.724-06
1205	[{"leafId":731,"en":"I","l2":">nA"}]	\N	731		1		2018-09-07 13:58:35.727558-06	2018-09-07 13:58:35.725-06
1206	[{"leafId":-225,"en":"(we)","l2":"na-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-225,"en":"(we)","l2":"-u"}]	\N	-225,729,-225	(we) write	0		2018-09-07 13:58:35.727558-06	2018-09-07 13:58:35.725-06
1207	[{"leafId":729,"en":"write","l2":"ktb"}]	\N	729	to write	1		2018-09-07 13:58:35.727558-06	2018-09-07 13:58:35.725-06
1209	[{"leafId":732,"en":"you (masc.)","l2":">anota"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-201,"en":"(you)","l2":"-ota"}]	\N	732,729,-201	You (masc.) wrote.	0		2018-09-07 13:58:47.792271-06	2018-09-07 13:58:47.789-06
1210	[{"leafId":732,"en":"you (masc.)","l2":">anota"}]	\N	732		1		2018-09-07 13:58:47.792271-06	2018-09-07 13:58:47.789-06
1211	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-201,"en":"(you)","l2":"-ota"}]	\N	729,-201	(you) wrote	0		2018-09-07 13:58:47.792271-06	2018-09-07 13:58:47.789-06
1213	[{"leafId":-201,"en":"wrote","l2":"katab-"},{"leafId":-201,"en":"(you)","l2":"-ota"}]	\N	-201,-201	(you wrote)	0		2018-09-07 13:58:47.792271-06	2018-09-07 13:58:47.79-06
439	[{"leafId":504,"en":"sold","l2":"vend-"},{"leafId":-16,"en":"(you)","l2":"-iste"}]	\N	504,-16	(you) sold	0		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.741-06
440	[{"leafId":390,"en":"the","l2":"la"}]	2018-06-27 16:31:27-06	390	the (fem.)	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.742-06
441	[{"leafId":505,"en":"house","l2":"casa"}]	2018-06-27 16:31:25-06	505	house	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.742-06
442	[{"leafId":504,"en":"sell","l2":"vender"}]	2018-06-27 16:31:23-06	504	to sell	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.743-06
444	[{"leafId":407,"en":"what","l2":"qué"},{"leafId":317,"en":"ate","l2":"com-"},{"leafId":-16,"en":"(you)","l2":"-iste"},{"leafId":507,"en":"today","l2":"hoy"}]	\N	407,317,-16,507	What did you eat today?	0		2018-06-27 16:10:43.293921-06	2018-06-27 16:43:32.744-06
446	[{"leafId":317,"en":"ate","l2":"com-"},{"leafId":-16,"en":"(you)","l2":"-iste"}]	\N	317,-16	(you) ate	0		2018-06-27 16:10:43.293921-06	2018-06-27 16:43:32.745-06
447	[{"leafId":507,"en":"today","l2":"hoy"}]	2018-06-27 16:31:22-06	507	today	4		2018-06-27 16:10:43.293921-06	2018-06-27 16:43:32.746-06
450	[{"leafId":317,"en":"ate","l2":"com-"},{"leafId":-15,"en":"(I)","l2":"-í"},{"leafId":508,"en":"too much","l2":"demasiado"}]	\N	317,-15,508	I ate too much.	0		2018-06-27 16:11:55.915249-06	2018-06-27 16:43:32.748-06
975	[{"leafId":581,"en":"hello","l2":"Bonjour"}]	\N	581	Hello!	1		2018-09-02 15:44:30.766874-06	2018-09-02 15:44:30.763-06
126	[{"leafId":388,"en":"good","l2":"buenas"}]	2018-06-27 14:00:30-06	388	good (fem.)	4		2018-06-26 21:22:50.209001-06	2018-06-27 16:43:32.661-06
187	[{"leafId":392,"en":"a","l2":"una"}]	2018-06-27 13:58:36-06	392	a (fem.)	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.528-06
123	[{"leafId":387,"en":"good","l2":"buenos"}]	2018-08-31 20:04:44-06	387	good (masc.)	4		2018-06-26 21:22:40.532507-06	2018-08-31 20:09:49.094-06
125	[{"leafId":388,"en":"good","l2":"buenas"},{"leafId":383,"en":"afternoons","l2":"tardes"}]	2018-06-27 14:00:33-06	388,383	Good afternoon!	4		2018-06-26 21:22:50.209001-06	2018-06-27 16:43:32.66-06
128	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":384,"en":"engineer","l2":"ingeniero"},{"leafId":409,"en":"of","l2":"de"},{"leafId":412,"en":"software","l2":"software"}]	2018-06-27 12:34:37-06	453,384,409,412	I'm a software engineer.	0		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.664-06
418	[{"leafId":451,"en":"did","l2":"hic-"},{"leafId":-22,"en":"(I)","l2":"-e"},{"leafId":392,"en":"a","l2":"una"},{"leafId":499,"en":"test","l2":"prueba"}]	\N	451,-22,392,499	I did a test.	0		2018-06-27 15:36:09.510179-06	2018-06-27 16:43:32.73-06
451	[{"leafId":317,"en":"ate","l2":"com-"},{"leafId":-15,"en":"(I)","l2":"-í"}]	\N	317,-15	(I) ate	0		2018-06-27 16:11:55.915249-06	2018-06-27 16:43:32.749-06
452	[{"leafId":508,"en":"too much","l2":"demasiado"}]	2018-06-27 16:31:20-06	508	too much	4		2018-06-27 16:11:55.915249-06	2018-06-27 16:43:32.75-06
455	[{"leafId":509,"en":"ran","l2":"corr-"},{"leafId":-15,"en":"(I)","l2":"-í"},{"leafId":510,"en":"outside","l2":"afuera"}]	\N	509,-15,510	I ran outside.	0		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.751-06
456	[{"leafId":509,"en":"ran","l2":"corr-"},{"leafId":-15,"en":"(I)","l2":"-í"}]	\N	509,-15	(I) ran	0		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.751-06
457	[{"leafId":510,"en":"outside","l2":"afuera"}]	2018-06-27 16:31:18-06	510	to outside	4		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.752-06
458	[{"leafId":509,"en":"run","l2":"correr"}]	2018-06-27 16:31:15-06	509	to run	4		2018-06-27 16:13:49.823617-06	2018-06-27 16:43:32.753-06
460	[{"leafId":511,"en":"why","l2":"porqué"},{"leafId":509,"en":"ran","l2":"corr-"},{"leafId":-16,"en":"(you)","l2":"-iste"}]	\N	511,509,-16	Why did you run?	0		2018-06-27 16:14:35.029309-06	2018-06-27 16:43:32.754-06
462	[{"leafId":509,"en":"ran","l2":"corr-"},{"leafId":-16,"en":"(you)","l2":"-iste"}]	\N	509,-16	(you) ran	0		2018-06-27 16:14:35.029309-06	2018-06-27 16:43:32.756-06
465	[{"leafId":513,"en":"grew up","l2":"crec-"},{"leafId":-15,"en":"(I)","l2":"-í"},{"leafId":498,"en":"in/on","l2":"en"},{"leafId":512,"en":"Pennsylvania","l2":"Pennsylvania"}]	\N	513,-15,498,512	I grew up in Pennsylvania.	0		2018-06-27 16:16:17.029139-06	2018-06-27 16:43:32.757-06
466	[{"leafId":513,"en":"grew up","l2":"crec-"},{"leafId":-15,"en":"(I)","l2":"-í"}]	\N	513,-15	(I) grew up	0		2018-06-27 16:16:17.029139-06	2018-06-27 16:43:32.758-06
469	[{"leafId":513,"en":"grow up","l2":"crecer"}]	2018-06-27 16:31:10-06	513	to grow up	4		2018-06-27 16:16:17.029139-06	2018-06-27 16:43:32.76-06
471	[{"leafId":513,"en":"grew up","l2":"crec-"},{"leafId":-16,"en":"(you)","l2":"-iste"},{"leafId":514,"en":"here","l2":"aquí"}]	\N	513,-16,514	Did you grow up here?	0		2018-06-27 16:17:49.570515-06	2018-06-27 16:43:32.761-06
472	[{"leafId":513,"en":"grew up","l2":"crec-"},{"leafId":-16,"en":"(you)","l2":"-iste"}]	\N	513,-16	(you) grew up	0		2018-06-27 16:17:49.570515-06	2018-06-27 16:43:32.762-06
473	[{"leafId":514,"en":"here","l2":"aquí"}]	2018-06-27 16:31:08-06	514	here	4		2018-06-27 16:17:49.570515-06	2018-06-27 16:43:32.763-06
476	[{"leafId":515,"en":"him","l2":"lo"},{"leafId":318,"en":"knew","l2":"conoc-"},{"leafId":-15,"en":"(I)","l2":"-í"},{"leafId":398,"en":"well","l2":"bien"}]	\N	515,318,-15,398	I knew him well.	0		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.763-06
477	[{"leafId":515,"en":"him","l2":"lo"}]	2018-06-27 16:31:05-06	515	him	4		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.764-06
478	[{"leafId":318,"en":"knew","l2":"conoc-"},{"leafId":-15,"en":"(I)","l2":"-í"}]	\N	318,-15	(I) knew (be able to)	0		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.765-06
480	[{"leafId":318,"en":"know","l2":"conocer"}]	2018-06-27 16:28:42-06	318	to know (someone)	3		2018-06-27 16:21:20.049983-06	2018-06-27 16:43:32.766-06
132	[{"leafId":412,"en":"software","l2":"software"}]	2018-06-27 13:59:47-06	412	software	5		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.667-06
544	[{"leafId":512,"en":"Pennsylvania","l2":"Pennsylvania"}]	\N	512	Pennsylvania	5		2018-06-27 17:08:39.845218-06	2018-06-27 17:08:39.842-06
663	[{"leafId":544,"en":"listen","l2":"escuchar"}]	\N	544	to listen	1		2018-07-17 08:51:53.467863-06	2018-07-17 08:51:53.465-06
939	[{"leafId":570,"en":"Mexico","l2":"México"}]	\N	570	Mexico	1		2018-09-01 17:20:15.392626-06	2018-09-01 17:20:15.39-06
664	[{"leafId":546,"en":"examples","l2":"ejemplos"}]	\N	546	examples	1		2018-07-17 08:51:53.467863-06	2018-07-17 08:51:53.466-06
146	[{"leafId":381,"en":"English","l2":"inglés"}]	2018-08-31 20:07:30-06	381	English	4		2018-06-26 21:23:18.524111-06	2018-08-31 20:09:49.13-06
153	[{"leafId":-11,"en":"(I)","l2":"-o"}]	2018-08-31 20:07:28-06	-11	(I learn)	4		2018-06-26 21:23:25.706003-06	2018-08-31 20:09:49.143-06
162	[{"leafId":398,"en":"well","l2":"bien"}]	2018-06-27 15:42:36-06	398	well	4		2018-06-26 21:23:47.71726-06	2018-08-31 20:09:49.15-06
689	[{"leafId":551,"en":"which","l2":"cuál"}]	\N	551	which	1		2018-07-17 08:56:07.444174-06	2018-07-17 08:56:07.443-06
218	[{"leafId":-16,"en":"(you)","l2":"-iste"}]	2018-06-28 12:40:07-06	-16	(you learned)	4		2018-06-26 21:24:51.438947-06	2018-06-28 12:41:00.543-06
155	[{"leafId":407,"en":"what","l2":"qué"},{"leafId":328,"en":"do","l2":"hac-"},{"leafId":-12,"en":"(you)","l2":"-es"}]	2018-06-26 21:29:18-06	407,328,-12	What are you doing?	0		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.68-06
157	[{"leafId":328,"en":"do","l2":"hac-"},{"leafId":-12,"en":"(you)","l2":"-es"}]	2018-06-26 21:29:15-06	328,-12	(you) do	0		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.682-06
164	[{"leafId":408,"en":"hello","l2":"hola"}]	2018-06-27 13:58:56-06	408	Hello!	4		2018-06-26 21:23:53.914204-06	2018-06-27 16:43:32.685-06
158	[{"leafId":328,"en":"do","l2":"hacer"}]	2018-06-27 15:42:38-06	328	to do	4		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.683-06
167	[{"leafId":349,"en":"live","l2":"viv-"},{"leafId":-11,"en":"(I)","l2":"-o"}]	2018-06-26 21:29:25-06	349,-11	(I) live	0		2018-06-26 21:24:01.746243-06	2018-06-27 16:43:32.686-06
138	[{"leafId":-12,"en":"(you)","l2":"-es"}]	2018-06-28 12:40:00-06	-12	(you learn)	4		2018-06-26 21:23:03.228956-06	2018-06-28 12:41:00.513-06
176	[{"leafId":351,"en":"moved","l2":"mud-"},{"leafId":-6,"en":"(I)","l2":"-é"}]	2018-06-27 13:58:50-06	351,-6	(I) moved	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.69-06
177	[{"leafId":419,"en":"to","l2":"a"}]	2018-06-27 13:58:48-06	419	to (toward)	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.691-06
180	[{"leafId":423,"en":"January","l2":"enero"}]	2018-06-27 13:58:46-06	423	January	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.692-06
160	[{"leafId":463,"en":"am","l2":"estoy"},{"leafId":398,"en":"well","l2":"bien"}]	2018-06-26 21:27:55-06	463,398	I'm doing well.	0		2018-06-26 21:23:47.71726-06	2018-06-27 16:43:32.684-06
182	[{"leafId":-6,"en":"(I)","l2":"-é"}]	2018-06-27 13:58:38-06	-6	(I worked)	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.694-06
181	[{"leafId":351,"en":"move","l2":"mudar"}]	2018-06-27 13:58:42-06	351	to move	4		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.693-06
188	[{"leafId":385,"en":"list","l2":"lista"}]	2018-06-27 13:58:34-06	385	list	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.528-06
191	[{"leafId":421,"en":"for","l2":"para"}]	2018-06-27 13:58:31-06	421	for (in order to)	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.531-06
192	[{"leafId":316,"en":"learn","l2":"aprender"}]	2018-06-27 13:58:28-06	316	to learn	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.532-06
193	[{"leafId":451,"en":"did","l2":"hic-"}]	2018-06-28 12:40:05-06	451	Stem change for hacer in PRET	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.533-06
194	[{"leafId":-22,"en":"(I)","l2":"-e"}]	2018-06-27 15:42:30-06	-22	(I had)	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.534-06
490	[{"leafId":455,"en":"is","l2":"es"}]	2018-06-27 16:43:18-06	455	he/she is (what)	4		2018-06-27 16:36:57.797061-06	2018-08-31 20:09:49.152-06
204	[{"leafId":413,"en":"with","l2":"con"},{"leafId":414,"en":"who","l2":"quién"},{"leafId":431,"en":"want","l2":"quier-"},{"leafId":-12,"en":"(you)","l2":"-es"},{"leafId":327,"en":"speak","l2":"hablar"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-06-28 12:40:48-06	413,414,431,-12,327,380	Who do you want to speak Spanish with?	3		2018-06-26 21:24:42.777343-06	2018-06-28 12:41:00.535-06
213	[{"leafId":410,"en":"where","l2":"dónde"},{"leafId":316,"en":"learned","l2":"aprend-"},{"leafId":-16,"en":"(you)","l2":"-iste"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-06-28 12:40:41-06	410,316,-16,380	Where did you learn Spanish?	3		2018-06-26 21:24:51.438947-06	2018-06-28 12:41:00.54-06
196	[{"leafId":347,"en":"visited","l2":"visit-"},{"leafId":-6,"en":"(I)","l2":"-é"},{"leafId":418,"en":"Cuba","l2":"Cuba"},{"leafId":420,"en":"for","l2":"por"},{"leafId":426,"en":"some","l2":"unas"},{"leafId":428,"en":"weeks","l2":"semanas"}]	2018-06-26 21:27:10-06	347,-6,418,420,426,428	I visited Cuba for a few weeks.	0		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.703-06
197	[{"leafId":347,"en":"visited","l2":"visit-"},{"leafId":-6,"en":"(I)","l2":"-é"}]	2018-06-27 13:58:40-06	347,-6	(I) visited	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.704-06
142	[{"leafId":327,"en":"speak","l2":"hablar"}]	2018-06-28 12:39:58-06	327	to speak	4		2018-06-26 21:23:11.364754-06	2018-08-31 20:09:49.105-06
199	[{"leafId":420,"en":"for","l2":"por"}]	2018-06-27 15:42:56-06	420	for (on behalf of)	3		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.706-06
200	[{"leafId":426,"en":"some","l2":"unas"}]	2018-06-27 13:57:45-06	426	some (fem.)	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.707-06
202	[{"leafId":347,"en":"visit","l2":"visitar"}]	2018-06-27 13:57:41-06	347	to visit	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.708-06
141	[{"leafId":380,"en":"Spanish","l2":"español"}]	2018-08-31 20:04:40-06	380	Spanish	4		2018-06-26 21:23:11.364754-06	2018-08-31 20:09:49.098-06
482	[{"leafId":518,"en":"not","l2":"no"},{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-6,"en":"(I)","l2":"-é"},{"leafId":516,"en":"that","l2":"esa"},{"leafId":517,"en":"account","l2":"cuenta"}]	\N	518,352,-6,516,517	I didn't create that account	0		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.766-06
137	[{"leafId":349,"en":"live","l2":"vivir"}]	2018-06-27 13:59:43-06	349	to live	4		2018-06-26 21:23:03.228956-06	2018-06-27 16:43:32.671-06
143	[{"leafId":-1,"en":"(I)","l2":"-o"}]	2018-06-28 12:39:56-06	-1	(I work)	4		2018-06-26 21:23:11.364754-06	2018-08-31 20:09:49.117-06
144	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":381,"en":"English","l2":"inglés"}]	2018-08-31 20:08:31-06	327,-1,381	I speak English.	4		2018-06-26 21:23:18.524111-06	2018-08-31 20:09:49.123-06
186	[{"leafId":451,"en":"did","l2":"hic-"},{"leafId":-22,"en":"(I)","l2":"-e"}]	2018-06-28 12:40:13-06	451,-22	(I) did	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.526-06
190	[{"leafId":386,"en":"sentences","l2":"oraciones"}]	2018-06-27 13:58:32-06	386	sentences	4		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.53-06
156	[{"leafId":407,"en":"what","l2":"qué"}]	2018-06-27 13:59:14-06	407	what	4		2018-06-26 21:23:38.542987-06	2018-06-27 16:43:32.681-06
140	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-1,"en":"(I)","l2":"-o"}]	2018-06-28 12:40:17-06	327,-1	(I) speak	4		2018-06-26 21:23:11.364754-06	2018-08-31 20:09:49.097-06
485	[{"leafId":516,"en":"that","l2":"esa"}]	2018-06-27 16:43:23-06	516	that (fem.)	4		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.768-06
486	[{"leafId":517,"en":"account","l2":"cuenta"}]	2018-06-27 16:43:21-06	517	account	4		2018-06-27 16:35:37.766885-06	2018-06-27 16:43:32.769-06
489	[{"leafId":455,"en":"is","l2":"es"},{"leafId":391,"en":"a","l2":"un"},{"leafId":519,"en":"game","l2":"juego"},{"leafId":520,"en":"that","l2":"que"},{"leafId":399,"en":"I","l2":"yo"},{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-6,"en":"(I)","l2":"-é"}]	\N	455,391,519,520,399,352,-6	It's a game that I made	0		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.769-06
169	[{"leafId":417,"en":"Longmont","l2":"Longmont"}]	2018-06-27 13:58:54-06	417	Longmont	5		2018-06-26 21:24:01.746243-06	2018-06-27 16:43:32.688-06
198	[{"leafId":418,"en":"Cuba","l2":"Cuba"}]	2018-06-27 13:57:50-06	418	Cuba	5		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.705-06
175	[{"leafId":415,"en":"me","l2":"me"}]	2018-06-27 13:58:52-06	415	me (to me)	5		2018-06-26 21:24:09.613753-06	2018-06-27 16:43:32.689-06
225	[{"leafId":353,"en":"study","l2":"estudiar"}]	2018-06-27 15:42:26-06	353	to study	4		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.718-06
227	[{"leafId":352,"en":"create","l2":"crear"}]	2018-06-27 14:22:34-06	352	to create	3		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.719-06
230	[{"leafId":350,"en":"attended","l2":"asist-"},{"leafId":-15,"en":"(I)","l2":"-í"}]	2018-06-28 12:40:15-06	350,-15	(I) attended	4		2018-06-26 21:25:14.87594-06	2018-06-28 12:41:00.545-06
235	[{"leafId":350,"en":"attend","l2":"asistir"}]	2018-06-27 15:42:22-06	350	to attend	4		2018-06-26 21:25:14.87594-06	2018-06-28 12:41:00.546-06
212	[{"leafId":336,"en":"want","l2":"querer"}]	2018-06-27 13:57:35-06	336	to want	4		2018-06-26 21:24:42.777343-06	2018-06-27 16:43:32.713-06
236	[{"leafId":-15,"en":"(I)","l2":"-í"}]	2018-06-27 15:42:54-06	-15	(I learned)	4		2018-06-26 21:25:14.87594-06	2018-06-28 12:41:00.547-06
229	[{"leafId":350,"en":"attended","l2":"asist-"},{"leafId":-15,"en":"(I)","l2":"-í"},{"leafId":392,"en":"a","l2":"una"},{"leafId":422,"en":"class","l2":"clase"},{"leafId":409,"en":"of","l2":"de"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-06-28 12:40:23-06	350,-15,392,422,409,380	I took a class in Spanish.	3		2018-06-26 21:25:14.87594-06	2018-06-28 12:41:00.544-06
232	[{"leafId":422,"en":"class","l2":"clase"}]	2018-06-27 15:42:24-06	422	class	4		2018-06-26 21:25:14.87594-06	2018-06-28 12:41:00.545-06
219	[{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-6,"en":"(I)","l2":"-é"},{"leafId":392,"en":"a","l2":"una"},{"leafId":424,"en":"application","l2":"aplicación"},{"leafId":427,"en":"mobile phone","l2":"móvil"},{"leafId":421,"en":"for","l2":"para"},{"leafId":353,"en":"study","l2":"estudiar"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-06-27 12:32:18-06	352,-6,392,424,427,421,353,380	I created a mobile app to study Spanish.	0		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.716-06
375	[{"leafId":415,"en":"me","l2":"me"},{"leafId":351,"en":"moved","l2":"mud-"},{"leafId":-6,"en":"(I)","l2":"-é"},{"leafId":419,"en":"to","l2":"a"},{"leafId":417,"en":"Longmont","l2":"Longmont"},{"leafId":498,"en":"in/on","l2":"en"},{"leafId":423,"en":"January","l2":"enero"}]	2018-06-27 14:00:44-06	415,351,-6,419,417,498,423	I moved to Longmont in January.	3		2018-06-27 13:14:36.959357-06	2018-06-27 16:43:32.727-06
493	[{"leafId":520,"en":"that","l2":"que"}]	2018-06-27 16:43:12-06	520	that	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.772-06
210	[{"leafId":431,"en":"want","l2":"quier-"}]	2018-06-28 12:40:02-06	431	Stem change for querer in PRES	4		2018-06-26 21:24:42.777343-06	2018-06-28 12:41:00.539-06
494	[{"leafId":399,"en":"I","l2":"yo"}]	2018-06-27 16:43:11-06	399	I	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.773-06
499	[{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-6,"en":"(I)","l2":"-é"},{"leafId":391,"en":"a","l2":"un"},{"leafId":521,"en":"profile","l2":"perfil"}]	\N	352,-6,391,521	I created a profile.	0		2018-06-27 16:38:29.525567-06	2018-06-27 16:43:32.774-06
502	[{"leafId":521,"en":"profile","l2":"perfil"}]	2018-06-27 16:43:09-06	521	profile	4		2018-06-27 16:38:29.525567-06	2018-06-27 16:43:32.774-06
505	[{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-7,"en":"(you)","l2":"-aste"},{"leafId":392,"en":"a","l2":"una"},{"leafId":517,"en":"account","l2":"cuenta"}]	\N	352,-7,392,517	Did you create an account?	0		2018-06-27 16:40:23.223164-06	2018-06-27 16:43:32.775-06
506	[{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-7,"en":"(you)","l2":"-aste"}]	\N	352,-7	(you) created	0		2018-06-27 16:40:23.223164-06	2018-06-27 16:43:32.776-06
510	[{"leafId":-7,"en":"(you)","l2":"-aste"}]	2018-06-27 16:43:04-06	-7	(you worked)	2		2018-06-27 16:40:23.223164-06	2018-06-27 16:43:32.776-06
511	[{"leafId":351,"en":"moved","l2":"mud-"},{"leafId":-6,"en":"(I)","l2":"-é"},{"leafId":522,"en":"three","l2":"tres"},{"leafId":523,"en":"times","l2":"veces"}]	\N	351,-6,522,523	I moved three times.	0		2018-06-27 16:42:16.908643-06	2018-06-27 16:43:32.777-06
514	[{"leafId":523,"en":"times","l2":"veces"}]	2018-06-27 16:42:57-06	523	times (occasion)	3		2018-06-27 16:42:16.908643-06	2018-06-27 16:43:32.778-06
135	[{"leafId":410,"en":"where","l2":"dónde"}]	2018-06-27 13:59:45-06	410	where (question)	4		2018-06-26 21:23:03.228956-06	2018-06-28 12:41:00.506-06
139	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-06-28 12:40:22-06	327,-1,380	I speak Spanish.	4		2018-06-26 21:23:11.364754-06	2018-06-28 12:41:00.514-06
207	[{"leafId":431,"en":"want","l2":"quier-"},{"leafId":-12,"en":"(you)","l2":"-es"}]	2018-06-28 12:40:45-06	431,-12	(you) want	4		2018-06-26 21:24:42.777343-06	2018-06-28 12:41:00.538-06
668	[{"leafId":547,"en":"need","l2":"necesit-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":546,"en":"examples","l2":"ejemplos"},{"leafId":409,"en":"of","l2":"de"},{"leafId":386,"en":"sentences","l2":"oraciones"}]	\N	547,-1,546,409,386	I need examples of sentences.	0		2018-07-17 08:52:55.119972-06	2018-07-17 08:52:55.118-06
669	[{"leafId":547,"en":"need","l2":"necesit-"},{"leafId":-1,"en":"(I)","l2":"-o"}]	\N	547,-1	(I) need	0		2018-07-17 08:52:55.119972-06	2018-07-17 08:52:55.118-06
723	[{"leafId":555,"en":"pardon","l2":"perdón"}]	2018-08-31 20:07:03-06	555	pardon	4		2018-08-31 19:09:07.208434-06	2018-08-31 20:09:49.156-06
491	[{"leafId":391,"en":"a","l2":"un"}]	2018-06-27 16:43:16-06	391	a (masc.)	4		2018-06-27 16:36:57.797061-06	2018-08-31 20:09:49.153-06
433	[{"leafId":463,"en":"am","l2":"estoy"},{"leafId":502,"en":"sad","l2":"triste"}]	\N	463,502	I'm sad.	0		2018-06-27 16:02:09.868374-06	2018-06-27 16:43:32.737-06
435	[{"leafId":502,"en":"sad","l2":"triste"}]	2018-06-27 16:31:31-06	502	sad	4		2018-06-27 16:02:09.868374-06	2018-06-27 16:43:32.738-06
675	[{"leafId":547,"en":"need","l2":"necesit-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":546,"en":"examples","l2":"ejemplos"},{"leafId":409,"en":"of","l2":"de"},{"leafId":397,"en":"how","l2":"cómo"},{"leafId":548,"en":"itself","l2":"se"},{"leafId":549,"en":"use","l2":"us-"},{"leafId":-3,"en":"(he/she)","l2":"-a"},{"leafId":392,"en":"a","l2":"una"},{"leafId":550,"en":"word","l2":"palabra"}]	\N	547,-1,546,409,397,548,549,-3,392,550	I need examples of how a word is used.	0		2018-07-17 08:54:45.43614-06	2018-07-17 08:54:45.434-06
680	[{"leafId":548,"en":"itself","l2":"se"}]	\N	548	itself	1		2018-07-17 08:54:45.43614-06	2018-07-17 08:54:45.434-06
681	[{"leafId":549,"en":"use","l2":"us-"},{"leafId":-3,"en":"(he/she)","l2":"-a"}]	\N	549,-3	(he/she) uses	0		2018-07-17 08:54:45.43614-06	2018-07-17 08:54:45.434-06
683	[{"leafId":550,"en":"word","l2":"palabra"}]	\N	550	word	1		2018-07-17 08:54:45.43614-06	2018-07-17 08:54:45.434-06
686	[{"leafId":549,"en":"use","l2":"usar"}]	\N	549	to use	1		2018-07-17 08:54:45.43614-06	2018-07-17 08:54:45.434-06
688	[{"leafId":551,"en":"which","l2":"cuál"},{"leafId":455,"en":"is","l2":"es"},{"leafId":389,"en":"the","l2":"el"},{"leafId":552,"en":"context","l2":"contexto"},{"leafId":409,"en":"of","l2":"de"},{"leafId":390,"en":"the","l2":"la"},{"leafId":550,"en":"word","l2":"palabra"}]	\N	551,455,389,552,409,390,550	What's the context of the word?	0		2018-07-17 08:56:07.444174-06	2018-07-17 08:56:07.443-06
692	[{"leafId":552,"en":"context","l2":"contexto"}]	\N	552	context	1		2018-07-17 08:56:07.444174-06	2018-07-17 08:56:07.443-06
697	[{"leafId":498,"en":"in/on","l2":"en"},{"leafId":407,"en":"what","l2":"qué"},{"leafId":386,"en":"sentence","l2":"oración"},{"leafId":548,"en":"itself","l2":"se"},{"leafId":549,"en":"use","l2":"us-"},{"leafId":-3,"en":"(he/she)","l2":"-a"}]	\N	498,407,386,548,549,-3	In what sentence is it used?	0		2018-07-17 08:56:27.721413-06	2018-07-17 08:56:27.719-06
705	[{"leafId":531,"en":"the","l2":"las"},{"leafId":550,"en":"words","l2":"palabras"},{"leafId":430,"en":"have","l2":"tien-"},{"leafId":-14,"en":"(they)","l2":"-en"},{"leafId":391,"en":"a","l2":"un"},{"leafId":552,"en":"context","l2":"contexto"}]	\N	531,550,430,-14,391,552	Words have a context	0		2018-07-17 08:56:49.693717-06	2018-07-17 08:56:49.691-06
708	[{"leafId":430,"en":"have","l2":"tien-"},{"leafId":-14,"en":"(they)","l2":"-en"}]	\N	430,-14	(they) have	0		2018-07-17 08:56:49.693717-06	2018-07-17 08:56:49.691-06
711	[{"leafId":430,"en":"have","l2":"tien-"}]	\N	430	Stem change for tener in PRES	1		2018-07-17 08:56:49.693717-06	2018-07-17 08:56:49.691-06
712	[{"leafId":-14,"en":"(they)","l2":"-en"}]	\N	-14	(they learn)	1		2018-07-17 08:56:49.693717-06	2018-07-17 08:56:49.691-06
714	[{"leafId":531,"en":"the","l2":"las"},{"leafId":550,"en":"words","l2":"palabras"},{"leafId":554,"en":"belong","l2":"pertenec-"},{"leafId":-14,"en":"(they)","l2":"-en"},{"leafId":419,"en":"to","l2":"a"},{"leafId":386,"en":"sentences","l2":"oraciones"}]	\N	531,550,554,-14,419,386	Words belong in sentences	0		2018-07-17 08:58:30.421863-06	2018-07-17 08:58:30.42-06
717	[{"leafId":554,"en":"belong","l2":"pertenec-"},{"leafId":-14,"en":"(they)","l2":"-en"}]	\N	554,-14	(they) belong	0		2018-07-17 08:58:30.421863-06	2018-07-17 08:58:30.42-06
720	[{"leafId":554,"en":"belong","l2":"pertenecer"}]	\N	554	to belong	1		2018-07-17 08:58:30.421863-06	2018-07-17 08:58:30.421-06
679	[{"leafId":397,"en":"how","l2":"cómo"}]	2018-08-31 20:07:10-06	397	how	4		2018-07-17 08:54:45.43614-06	2018-08-31 20:09:49.154-06
687	[{"leafId":-3,"en":"(he/she)","l2":"-a"}]	2018-08-31 20:07:51-06	-3	(he/she works)	4		2018-07-17 08:54:45.43614-06	2018-08-31 20:09:49.155-06
731	[{"leafId":324,"en":"understand","l2":"entender"}]	\N	324	to understand	1		2018-08-31 19:09:35.082228-06	2018-08-31 19:09:35.079-06
1131	[{"leafId":626,"en":"from","l2":"des"}]	\N	626	from	1		2018-09-03 10:44:02.894182-06	2018-09-03 10:44:02.89-06
732	[{"leafId":455,"en":"is","l2":"es"},{"leafId":557,"en":"you","l2":"usted"},{"leafId":558,"en":"American","l2":"norteamericano"}]	2018-08-31 20:07:56-06	455,557,558	Are you American?	4		2018-08-31 19:11:55.626087-06	2018-08-31 20:09:49.16-06
735	[{"leafId":558,"en":"American","l2":"norteamericano"}]	2018-08-31 20:06:43-06	558	American	4		2018-08-31 19:11:55.626087-06	2018-08-31 20:09:49.162-06
751	[{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-13,"en":"(he/she)","l2":"-e"}]	2018-08-31 20:08:46-06	443,-13	(he/she) understands	4		2018-08-31 19:13:44.206561-06	2018-08-31 20:09:49.17-06
754	[{"leafId":-13,"en":"(he/she)","l2":"-e"}]	2018-08-31 20:07:37-06	-13	(he/she learns)	4		2018-08-31 19:13:44.206561-06	2018-08-31 20:09:49.171-06
756	[{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-11,"en":"(I)","l2":"-o"},{"leafId":561,"en":"very","l2":"muy"},{"leafId":398,"en":"well","l2":"bien"}]	2018-08-31 20:08:21-06	443,-11,561,398	I understand very well.	4		2018-08-31 19:14:10.355408-06	2018-08-31 20:09:49.172-06
758	[{"leafId":561,"en":"very","l2":"muy"}]	2018-08-31 20:05:04-06	561	very	4		2018-08-31 19:14:10.355408-06	2018-08-31 20:09:49.174-06
763	[{"leafId":397,"en":"how","l2":"cómo"},{"leafId":465,"en":"is","l2":"está"},{"leafId":557,"en":"you","l2":"usted"}]	2018-08-31 20:07:53-06	397,465,557	How are you? (formal)	4		2018-08-31 19:14:23.99941-06	2018-08-31 20:09:49.175-06
765	[{"leafId":465,"en":"is","l2":"está"}]	2018-08-31 20:05:01-06	465	he/she is (how)	4		2018-08-31 19:14:23.99941-06	2018-08-31 20:09:49.177-06
771	[{"leafId":562,"en":"thanks","l2":"gracias"}]	2018-08-31 20:04:59-06	562	Thanks	4		2018-08-31 19:15:25.422334-06	2018-08-31 20:09:49.178-06
773	[{"leafId":563,"en":"bye","l2":"adiós"},{"leafId":564,"en":"miss","l2":"señorita"}]	2018-08-31 20:08:43-06	563,564	Bye, miss.	4		2018-08-31 19:16:20.762468-06	2018-08-31 20:09:49.18-06
774	[{"leafId":563,"en":"bye","l2":"adiós"}]	2018-08-31 20:04:56-06	563	bye	4		2018-08-31 19:16:20.762468-06	2018-08-31 20:09:49.181-06
782	[{"leafId":518,"en":"not","l2":"no"},{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":561,"en":"very","l2":"muy"},{"leafId":398,"en":"well","l2":"bien"}]	2018-08-31 20:07:34-06	518,327,-1,561,398	I don't speak well.	4		2018-08-31 19:16:56.375801-06	2018-08-31 20:09:49.184-06
789	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-3,"en":"(he/she)","l2":"-a"},{"leafId":380,"en":"Spanish","l2":"español"},{"leafId":561,"en":"very","l2":"muy"},{"leafId":398,"en":"well","l2":"bien"}]	2018-08-31 20:09:09-06	327,-3,380,561,398	You speak Spanish very well. (formal)	3		2018-08-31 19:17:19.710995-06	2018-08-31 20:09:49.185-06
122	[{"leafId":387,"en":"good","l2":"buenos"},{"leafId":382,"en":"days","l2":"días"}]	2018-08-31 20:04:47-06	387,382	Good morning!	4		2018-06-26 21:22:40.532507-06	2018-08-31 20:09:49.08-06
722	[{"leafId":555,"en":"pardon","l2":"perdón"},{"leafId":556,"en":"ma\\u0027am/Mrs.","l2":"señora"}]	2018-08-31 20:08:51-06	555,556	Pardon, ma'am.	4		2018-08-31 19:09:07.208434-06	2018-08-31 20:09:49.156-06
725	[{"leafId":518,"en":"not","l2":"no"},{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-11,"en":"(I)","l2":"-o"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-08-31 20:08:23-06	518,443,-11,380	I don't understand Spanish.	4		2018-08-31 19:09:35.082228-06	2018-08-31 20:09:49.158-06
727	[{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-11,"en":"(I)","l2":"-o"}]	2018-08-31 20:08:19-06	443,-11	(I) understand	4		2018-08-31 19:09:35.082228-06	2018-08-31 20:09:49.158-06
729	[{"leafId":443,"en":"understand","l2":"entiend-"}]	2018-08-31 20:07:46-06	443	Stem change for entender in PRES	4		2018-08-31 19:09:35.082228-06	2018-08-31 20:09:49.159-06
737	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-3,"en":"(he/she)","l2":"-a"},{"leafId":381,"en":"English","l2":"inglés"}]	2018-08-31 20:09:26-06	327,-3,381	Do you speak English? (formal)	3		2018-08-31 19:12:24.453307-06	2018-08-31 20:09:49.163-06
738	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-3,"en":"(he/she)","l2":"-a"}]	2018-08-31 20:08:48-06	327,-3	(he/she) speaks	4		2018-08-31 19:12:24.453307-06	2018-08-31 20:09:49.164-06
437	[{"leafId":503,"en":"yet","l2":"ya"},{"leafId":504,"en":"sold","l2":"vend-"},{"leafId":-16,"en":"(you)","l2":"-iste"},{"leafId":390,"en":"the","l2":"la"},{"leafId":505,"en":"house","l2":"casa"}]	\N	503,504,-16,390,505	Did you sell the house yet?	0		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.739-06
742	[{"leafId":559,"en":"yes","l2":"sí"},{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":381,"en":"English","l2":"inglés"},{"leafId":391,"en":"a","l2":"un"},{"leafId":560,"en":"little","l2":"poco"}]	2018-08-31 20:09:03-06	559,327,-1,381,391,560	Yes, I speak English a little.	4		2018-08-31 19:13:13.800644-06	2018-08-31 20:09:49.165-06
747	[{"leafId":560,"en":"little","l2":"poco"}]	2018-08-31 20:05:20-06	560	little	4		2018-08-31 19:13:13.800644-06	2018-08-31 20:09:49.168-06
750	[{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-13,"en":"(he/she)","l2":"-e"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-08-31 20:09:21-06	443,-13,380	Do you understand Spanish? (formal)	3		2018-08-31 19:13:44.206561-06	2018-08-31 20:09:49.169-06
775	[{"leafId":564,"en":"miss","l2":"señorita"}]	2018-08-31 20:07:32-06	564	miss	4		2018-08-31 19:16:20.762468-06	2018-08-31 20:09:49.182-06
776	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-3,"en":"(he/she)","l2":"-a"},{"leafId":557,"en":"you","l2":"usted"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-08-31 20:09:13-06	327,-3,557,380	Do you speak Spanish? (formal)	3		2018-08-31 19:16:43.205661-06	2018-08-31 20:09:49.183-06
796	[{"leafId":518,"en":"not","l2":"no"},{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-1,"en":"(I)","l2":"-o"}]	\N	518,327,-1		0		2018-09-01 16:07:37.035391-06	2018-09-01 16:07:37.029-06
994	[{"leafId":593,"en":"we","l2":"nous"}]	\N	593	we	1		2018-09-02 16:49:20.074875-06	2018-09-02 16:49:20.072-06
815	[{"leafId":518,"en":"not","l2":"no"},{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-11,"en":"(I)","l2":"-o"},{"leafId":565,"en":"Castilian","l2":"castellano"}]	\N	518,443,-11,565	I don't understand Castilian.	0		2018-09-01 16:43:39.732548-06	2018-09-01 16:43:39.725-06
818	[{"leafId":565,"en":"Castilian","l2":"castellano"}]	\N	565	Castilian	1		2018-09-01 16:43:39.732548-06	2018-09-01 16:43:39.726-06
827	[{"leafId":518,"en":"not","l2":"no"},{"leafId":566,"en":"American","l2":"norteamericana"},{"leafId":518,"en":"not","l2":"no"}]	\N	518,566,518	No, not American.	0		2018-09-01 16:49:52.061252-06	2018-09-01 16:49:52.056-06
829	[{"leafId":566,"en":"American","l2":"norteamericana"}]	\N	566	American (fem.)	1		2018-09-01 16:49:52.061252-06	2018-09-01 16:49:52.056-06
844	[{"leafId":443,"en":"understand","l2":"entiend-"},{"leafId":-13,"en":"(he/she)","l2":"-e"},{"leafId":565,"en":"Castilian","l2":"castellano"}]	\N	443,-13,565	Do you understand Castilian? (formal)	0		2018-09-01 17:04:37.707161-06	2018-09-01 17:04:37.703-06
870	[{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-3,"en":"(he/she)","l2":"-a"},{"leafId":557,"en":"you","l2":"usted"},{"leafId":565,"en":"Castilian","l2":"castellano"}]	\N	327,-3,557,565	Do you speak Castilian? (formal)	0		2018-09-01 17:06:44.755181-06	2018-09-01 17:06:44.753-06
883	[{"leafId":557,"en":"you","l2":"usted"},{"leafId":327,"en":"speak","l2":"habl-"},{"leafId":-3,"en":"(he/she)","l2":"-a"},{"leafId":565,"en":"Castilian","l2":"castellano"},{"leafId":561,"en":"very","l2":"muy"},{"leafId":398,"en":"well","l2":"bien"}]	\N	557,327,-3,565,561,398	You speak Castilian very well. (formal)	0		2018-09-01 17:07:28.377416-06	2018-09-01 17:07:28.375-06
891	[{"leafId":518,"en":"not","l2":"no"},{"leafId":453,"en":"am","l2":"soy"},{"leafId":558,"en":"American","l2":"norteamericano"}]	\N	518,453,558	I'm not American. (masc.)	0		2018-09-01 17:08:39.13597-06	2018-09-01 17:08:39.134-06
896	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":558,"en":"American","l2":"norteamericano"}]	\N	453,558	I'm American. (masc.)	0		2018-09-01 17:08:52.384327-06	2018-09-01 17:08:52.383-06
900	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":409,"en":"of","l2":"de"},{"leafId":567,"en":"Chicago","l2":"Chicago"}]	\N	453,409,567	I'm from Chicago.	0		2018-09-01 17:09:14.535417-06	2018-09-01 17:09:14.534-06
1245	[{"leafId":739,"en":"they (masc.)","l2":"humo"}]	\N	739		1		2018-09-07 14:00:24.824393-06	2018-09-07 14:00:24.823-06
922	[{"leafId":568,"en":"gentleman","l2":"señor"}]	\N	568	gentleman	1		2018-09-01 17:12:59.63222-06	2018-09-01 17:12:59.631-06
923	[{"leafId":390,"en":"the","l2":"la"},{"leafId":556,"en":"ma\\u0027am/Mrs.","l2":"señora"}]	\N	390,556	the lady	0		2018-09-01 17:13:50.153915-06	2018-09-01 17:13:50.153-06
926	[{"leafId":389,"en":"the","l2":"el"},{"leafId":382,"en":"day","l2":"día"}]	\N	389,382	the day	0		2018-09-01 17:14:37.475525-06	2018-09-01 17:14:37.474-06
929	[{"leafId":388,"en":"good","l2":"buenas"},{"leafId":569,"en":"night","l2":"noche"}]	\N	388,569	Good evening!	0		2018-09-01 17:18:57.108476-06	2018-09-01 17:18:57.103-06
931	[{"leafId":569,"en":"night","l2":"noche"}]	\N	569	night	1		2018-09-01 17:18:57.108476-06	2018-09-01 17:18:57.104-06
932	[{"leafId":390,"en":"the","l2":"la"},{"leafId":569,"en":"night","l2":"noche"}]	\N	390,569	the night	0		2018-09-01 17:19:20.893234-06	2018-09-01 17:19:20.891-06
935	[{"leafId":557,"en":"you","l2":"usted"},{"leafId":455,"en":"is","l2":"es"},{"leafId":409,"en":"of","l2":"de"},{"leafId":570,"en":"Mexico","l2":"México"}]	\N	557,455,409,570	You're from Mexico. (formal)	0		2018-09-01 17:20:15.392626-06	2018-09-01 17:20:15.39-06
941	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":409,"en":"of","l2":"de"},{"leafId":571,"en":"America","l2":"Norteamérica"}]	\N	453,409,571	I'm from America. (formal)	0		2018-09-01 17:20:47.326717-06	2018-09-01 17:20:47.324-06
944	[{"leafId":571,"en":"America","l2":"Norteamérica"}]	\N	571	America	1		2018-09-01 17:20:47.326717-06	2018-09-01 17:20:47.324-06
1215	[{"leafId":733,"en":"you (fem.)","l2":">anoti"}]	\N	733		1		2018-09-07 13:59:01.390127-06	2018-09-07 13:59:01.388-06
1216	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-202,"en":"(you)","l2":"-oti"}]	\N	729,-202	(you) wrote	0		2018-09-07 13:59:01.390127-06	2018-09-07 13:59:01.388-06
1218	[{"leafId":-202,"en":"wrote","l2":"katab-"},{"leafId":-202,"en":"(you)","l2":"-oti"}]	\N	-202,-202	(you wrote)	0		2018-09-07 13:59:01.390127-06	2018-09-07 13:59:01.388-06
1219	[{"leafId":734,"en":"he","l2":"huwa"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-203,"en":"(he/she)","l2":"-a"}]	\N	734,729,-203	He wrote.	0		2018-09-07 13:59:11.719467-06	2018-09-07 13:59:11.717-06
1220	[{"leafId":734,"en":"he","l2":"huwa"}]	\N	734		1		2018-09-07 13:59:11.719467-06	2018-09-07 13:59:11.717-06
1221	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-203,"en":"(he/she)","l2":"-a"}]	\N	729,-203	(he/she) wrote	0		2018-09-07 13:59:11.719467-06	2018-09-07 13:59:11.717-06
1223	[{"leafId":-203,"en":"wrote","l2":"katab-"},{"leafId":-203,"en":"(he/she)","l2":"-a"}]	\N	-203,-203	(he/she wrote)	0		2018-09-07 13:59:11.719467-06	2018-09-07 13:59:11.717-06
1224	[{"leafId":735,"en":"she","l2":"hiya"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	735,729,-204	She wrote.	0		2018-09-07 13:59:25.61129-06	2018-09-07 13:59:25.608-06
1225	[{"leafId":735,"en":"she","l2":"hiya"}]	\N	735		1		2018-09-07 13:59:25.61129-06	2018-09-07 13:59:25.608-06
1226	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	729,-204	(he/she) wrote	0		2018-09-07 13:59:25.61129-06	2018-09-07 13:59:25.608-06
1228	[{"leafId":-204,"en":"wrote","l2":"katab-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	-204,-204	(he/she wrote)	0		2018-09-07 13:59:25.61129-06	2018-09-07 13:59:25.608-06
1229	[{"leafId":736,"en":"we","l2":"naHonu"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-205,"en":"(we)","l2":"-onaA"}]	\N	736,729,-205	We wrote.	0		2018-09-07 13:59:37.266768-06	2018-09-07 13:59:37.265-06
130	[{"leafId":384,"en":"engineer","l2":"ingeniero"}]	2018-06-27 13:59:51-06	384	engineer	4		2018-06-26 21:22:57.352948-06	2018-06-27 16:43:32.665-06
127	[{"leafId":383,"en":"afternoons","l2":"tardes"}]	2018-06-27 14:00:28-06	383	afternoons	4		2018-06-26 21:22:50.209001-06	2018-06-27 16:43:32.662-06
429	[{"leafId":463,"en":"am","l2":"estoy"},{"leafId":501,"en":"alone","l2":"solo"}]	\N	463,501	I'm alone.	0		2018-06-27 16:01:36.519258-06	2018-06-27 16:43:32.733-06
431	[{"leafId":501,"en":"alone","l2":"solo"}]	2018-06-27 16:31:32-06	501	alone	4		2018-06-27 16:01:36.519258-06	2018-06-27 16:43:32.734-06
438	[{"leafId":503,"en":"yet","l2":"ya"}]	2018-06-27 16:31:29-06	503	yet	4		2018-06-27 16:06:42.827465-06	2018-06-27 16:43:32.74-06
1250	[{"leafId":740,"en":"they (fem.)","l2":"hun~a"}]	\N	740		1		2018-09-07 14:00:41.274739-06	2018-09-07 14:00:41.273-06
1230	[{"leafId":736,"en":"we","l2":"naHonu"}]	\N	736		1		2018-09-07 13:59:37.266768-06	2018-09-07 13:59:37.265-06
1231	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-205,"en":"(we)","l2":"-onaA"}]	\N	729,-205	(we) wrote	0		2018-09-07 13:59:37.266768-06	2018-09-07 13:59:37.265-06
1233	[{"leafId":-205,"en":"wrote","l2":"katab-"},{"leafId":-205,"en":"(we)","l2":"-onaA"}]	\N	-205,-205	(we wrote)	0		2018-09-07 13:59:37.266768-06	2018-09-07 13:59:37.265-06
1234	[{"leafId":737,"en":"you (masc. pl.)","l2":">anotumo"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-206,"en":"(you)","l2":"-otumo"}]	\N	737,729,-206	You (masc. pl.) wrote.	0		2018-09-07 13:59:55.987489-06	2018-09-07 13:59:55.985-06
1235	[{"leafId":737,"en":"you (masc. pl.)","l2":">anotumo"}]	\N	737		1		2018-09-07 13:59:55.987489-06	2018-09-07 13:59:55.985-06
1236	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-206,"en":"(you)","l2":"-otumo"}]	\N	729,-206	(you) wrote	0		2018-09-07 13:59:55.987489-06	2018-09-07 13:59:55.986-06
1238	[{"leafId":-206,"en":"wrote","l2":"katab-"},{"leafId":-206,"en":"(you)","l2":"-otumo"}]	\N	-206,-206	(you wrote)	0		2018-09-07 13:59:55.987489-06	2018-09-07 13:59:55.986-06
1239	[{"leafId":738,"en":"you (fem. pl.)","l2":">anotun~a"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-207,"en":"(you)","l2":"-otun~a"}]	\N	738,729,-207	You (fem. pl.) wrote.	0		2018-09-07 14:00:12.411998-06	2018-09-07 14:00:12.411-06
409	[{"leafId":453,"en":"am","l2":"soy"}]	2018-06-27 15:24:07-06	453	I am (what)	3		2018-06-27 15:22:50.588203-06	2018-06-27 16:43:32.727-06
413	[{"leafId":342,"en":"be","l2":"ser"}]	2018-06-27 15:23:55-06	342	to be (what)	3		2018-06-27 15:22:50.588203-06	2018-06-27 16:43:32.728-06
415	[{"leafId":463,"en":"am","l2":"estoy"}]	2018-06-27 15:23:51-06	463	I am (how)	3		2018-06-27 15:23:20.084918-06	2018-06-27 16:43:32.729-06
417	[{"leafId":326,"en":"be","l2":"estar"}]	2018-06-27 15:23:47-06	326	to be (how)	3		2018-06-27 15:23:20.084918-06	2018-06-27 16:43:32.73-06
1197	[{"leafId":642,"en":"also","l2":"aussi"}]	\N	642	also	1		2018-09-03 10:50:39.87576-06	2018-09-03 10:50:39.874-06
425	[{"leafId":463,"en":"am","l2":"estoy"},{"leafId":500,"en":"happy","l2":"feliz"}]	\N	463,500	I'm happy.	0		2018-06-27 16:00:49.986098-06	2018-06-27 16:43:32.732-06
427	[{"leafId":500,"en":"happy","l2":"feliz"}]	2018-06-27 16:31:34-06	500	happy	3		2018-06-27 16:00:49.986098-06	2018-06-27 16:43:32.733-06
1240	[{"leafId":738,"en":"you (fem. pl.)","l2":">anotun~a"}]	\N	738		1		2018-09-07 14:00:12.411998-06	2018-09-07 14:00:12.411-06
1241	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-207,"en":"(you)","l2":"-otun~a"}]	\N	729,-207	(you) wrote	0		2018-09-07 14:00:12.411998-06	2018-09-07 14:00:12.411-06
1274	[{"leafId":737,"en":"you (masc. pl.)","l2":">anotumo"},{"leafId":-226,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-226,"en":"(you)","l2":"-uwna"}]	\N	737,-226,729,-226	You (masc. pl.) write.	0		2018-09-07 14:02:08.430259-06	2018-09-07 14:02:08.429-06
1276	[{"leafId":-226,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-226,"en":"(you)","l2":"-uwna"}]	\N	-226,729,-226	(you) write	0		2018-09-07 14:02:08.430259-06	2018-09-07 14:02:08.429-06
1278	[{"leafId":-226,"en":"(you)","l2":"ta-"},{"leafId":-226,"en":"write","l2":"ktub-"},{"leafId":-226,"en":"(you)","l2":"-uwna"}]	\N	-226,-226,-226	(you write)	0		2018-09-07 14:02:08.430259-06	2018-09-07 14:02:08.429-06
421	[{"leafId":499,"en":"test","l2":"prueba"}]	2018-06-27 15:41:54-06	499	test	4		2018-06-27 15:36:09.510179-06	2018-06-27 16:43:32.731-06
581	[{"leafId":384,"en":"engineer","l2":"ingeniero"},{"leafId":409,"en":"of","l2":"de"},{"leafId":412,"en":"software","l2":"software"}]	\N	384,409,412	software engineer	0		2018-06-28 12:12:28.838833-06	2018-06-28 12:12:28.834-06
606	[{"leafId":392,"en":"a","l2":"una"},{"leafId":424,"en":"application","l2":"aplicación"},{"leafId":421,"en":"for","l2":"para"},{"leafId":316,"en":"learn","l2":"aprender"},{"leafId":380,"en":"Spanish","l2":"español"}]	\N	392,424,421,316,380	an app to learn Spanish	0		2018-07-17 08:27:56.685753-06	2018-07-17 08:27:56.684-06
612	[{"leafId":392,"en":"a","l2":"una"},{"leafId":424,"en":"application","l2":"aplicación"},{"leafId":421,"en":"for","l2":"para"},{"leafId":527,"en":"review","l2":"revisar"},{"leafId":529,"en":"cards","l2":"tarjetas"},{"leafId":409,"en":"of","l2":"de"},{"leafId":528,"en":"memory","l2":"memoria"}]	\N	392,424,421,527,529,409,528	an app to review flashcards	0		2018-07-17 08:29:39.020692-06	2018-07-17 08:29:39.019-06
616	[{"leafId":527,"en":"review","l2":"revisar"}]	\N	527	to review	1		2018-07-17 08:29:39.020692-06	2018-07-17 08:29:39.019-06
622	[{"leafId":530,"en":"different","l2":"diferente"}]	\N	530	different	1		2018-07-17 08:32:40.64313-06	2018-07-17 08:32:40.641-06
624	[{"leafId":531,"en":"the","l2":"las"}]	\N	531	the (fem. pl.)	1		2018-07-17 08:32:40.64313-06	2018-07-17 08:32:40.641-06
625	[{"leafId":533,"en":"others","l2":"otros"}]	\N	533	others	1		2018-07-17 08:32:40.64313-06	2018-07-17 08:32:40.641-06
628	[{"leafId":453,"en":"am","l2":"soy"},{"leafId":530,"en":"different","l2":"diferente"},{"leafId":419,"en":"to","l2":"a"},{"leafId":531,"en":"the","l2":"las"},{"leafId":534,"en":"others","l2":"otras"},{"leafId":535,"en":"persons","l2":"personas"}]	\N	453,530,419,531,534,535	I'm different than most people	0		2018-07-17 08:35:15.151412-06	2018-07-17 08:35:15.149-06
633	[{"leafId":534,"en":"others","l2":"otras"}]	\N	534	others (fem.)	1		2018-07-17 08:35:15.151412-06	2018-07-17 08:35:15.149-06
185	[{"leafId":451,"en":"did","l2":"hic-"},{"leafId":-22,"en":"(I)","l2":"-e"},{"leafId":392,"en":"a","l2":"una"},{"leafId":385,"en":"list","l2":"lista"},{"leafId":409,"en":"of","l2":"de"},{"leafId":386,"en":"sentences","l2":"oraciones"},{"leafId":421,"en":"for","l2":"para"},{"leafId":316,"en":"learn","l2":"aprender"}]	2018-06-28 12:40:29-06	451,-22,392,385,409,386,421,316	I made a list of sentences to learn.	3		2018-06-26 21:24:23.139561-06	2018-06-28 12:41:00.525-06
585	[{"leafId":467,"en":"have","l2":"tengo"},{"leafId":391,"en":"a","l2":"un"},{"leafId":524,"en":"program","l2":"programa"}]	\N	467,391,524	I have a program.	0		2018-07-17 08:25:23.011478-06	2018-07-17 08:25:23.009-06
586	[{"leafId":467,"en":"have","l2":"tengo"}]	\N	467	I have (null)	1		2018-07-17 08:25:23.011478-06	2018-07-17 08:25:23.009-06
588	[{"leafId":524,"en":"program","l2":"programa"}]	\N	524	program	1		2018-07-17 08:25:23.011478-06	2018-07-17 08:25:23.009-06
589	[{"leafId":343,"en":"have","l2":"tener"}]	\N	343	to have	1		2018-07-17 08:25:23.011478-06	2018-07-17 08:25:23.009-06
590	[{"leafId":467,"en":"have","l2":"tengo"},{"leafId":391,"en":"a","l2":"un"},{"leafId":525,"en":"project","l2":"proyecto"}]	\N	467,391,525	I have a project.	0		2018-07-17 08:26:11.784506-06	2018-07-17 08:26:11.782-06
593	[{"leafId":525,"en":"project","l2":"proyecto"}]	\N	525	project	1		2018-07-17 08:26:11.784506-06	2018-07-17 08:26:11.783-06
595	[{"leafId":467,"en":"have","l2":"tengo"},{"leafId":392,"en":"a","l2":"una"},{"leafId":424,"en":"application","l2":"aplicación"}]	\N	467,392,424	I have an app.	0		2018-07-17 08:26:28.978076-06	2018-07-17 08:26:28.975-06
600	[{"leafId":392,"en":"a","l2":"una"},{"leafId":424,"en":"application","l2":"aplicación"},{"leafId":421,"en":"for","l2":"para"},{"leafId":526,"en":"practice","l2":"practicar"},{"leafId":380,"en":"Spanish","l2":"español"}]	\N	392,424,421,526,380	an app to practice Spanish	0		2018-07-17 08:27:37.719766-06	2018-07-17 08:27:37.718-06
1279	[{"leafId":738,"en":"you (fem. pl.)","l2":">anotun~a"},{"leafId":-227,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-227,"en":"(you)","l2":"-ona"}]	\N	738,-227,729,-227	You (fem. pl.) write.	0		2018-09-07 14:02:27.747514-06	2018-09-07 14:02:27.746-06
1376	[{"leafId":-240,"en":"nominative","l2":"-u"}]	\N	-240	Case ending for nominative	1		2018-09-07 21:04:13.854143-06	2018-09-07 21:04:13.85-06
1281	[{"leafId":-227,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-227,"en":"(you)","l2":"-ona"}]	\N	-227,729,-227	(you) write	0		2018-09-07 14:02:27.747514-06	2018-09-07 14:02:27.746-06
1283	[{"leafId":-227,"en":"(you)","l2":"ta-"},{"leafId":-227,"en":"write","l2":"ktub-"},{"leafId":-227,"en":"(you)","l2":"-ona"}]	\N	-227,-227,-227	(you write)	0		2018-09-07 14:02:27.747514-06	2018-09-07 14:02:27.746-06
1294	[{"leafId":732,"en":"you (masc.)","l2":">anota"},{"leafId":-222,"en":"(you)","l2":"ta-"},{"leafId":742,"en":"sit","l2":"jolis-"},{"leafId":-222,"en":"(you)","l2":"-iyna"}]	\N	732,-222,742,-222	You (fem.) sit.	0		2018-09-07 14:11:56.437662-06	2018-09-07 14:11:56.434-06
1296	[{"leafId":-222,"en":"(you)","l2":"ta-"},{"leafId":742,"en":"sit","l2":"jolis-"},{"leafId":-222,"en":"(you)","l2":"-iyna"}]	\N	-222,742,-222	(you) sit	0		2018-09-07 14:11:56.437662-06	2018-09-07 14:11:56.434-06
636	[{"leafId":455,"en":"is","l2":"es"},{"leafId":530,"en":"different","l2":"diferente"},{"leafId":419,"en":"to","l2":"a"},{"leafId":532,"en":"the","l2":"los"},{"leafId":533,"en":"others","l2":"otros"},{"leafId":524,"en":"programs","l2":"programas"}]	\N	455,530,419,532,533,524	It's different than most programs.	0		2018-07-17 08:37:44.187312-06	2018-07-17 08:37:44.183-06
640	[{"leafId":532,"en":"the","l2":"los"}]	\N	532	the (masc. pl.)	1		2018-07-17 08:37:44.187312-06	2018-07-17 08:37:44.183-06
124	[{"leafId":382,"en":"days","l2":"días"}]	2018-08-31 20:04:42-06	382	days	4		2018-06-26 21:22:40.532507-06	2018-08-31 20:09:49.095-06
617	[{"leafId":529,"en":"cards","l2":"tarjetas"}]	\N	529	cards	1		2018-07-17 08:29:39.020692-06	2018-07-17 08:29:39.019-06
619	[{"leafId":528,"en":"memory","l2":"memoria"}]	\N	528	memory	1		2018-07-17 08:29:39.020692-06	2018-07-17 08:29:39.019-06
644	[{"leafId":455,"en":"is","l2":"es"},{"leafId":530,"en":"different","l2":"diferente"},{"leafId":419,"en":"to","l2":"a"},{"leafId":531,"en":"the","l2":"las"},{"leafId":534,"en":"others","l2":"otras"},{"leafId":424,"en":"applications","l2":"aplicaciones"}]	\N	455,530,419,531,534,424	It's different than most apps.	0		2018-07-17 08:38:38.846625-06	2018-07-17 08:38:38.845-06
237	[{"leafId":353,"en":"study","l2":"estudi-"},{"leafId":-1,"en":"(I)","l2":"-o"},{"leafId":380,"en":"Spanish","l2":"español"}]	2018-06-27 13:16:08-06	353,-1,380	I study Spanish.	0		2018-06-27 08:50:29.172548-06	2018-06-27 16:43:32.724-06
238	[{"leafId":353,"en":"study","l2":"estudi-"},{"leafId":-1,"en":"(I)","l2":"-o"}]	2018-06-27 13:16:03-06	353,-1	(I) study	0		2018-06-27 08:50:29.172548-06	2018-06-27 16:43:32.725-06
369	[{"leafId":349,"en":"live","l2":"viv-"},{"leafId":-11,"en":"(I)","l2":"-o"},{"leafId":498,"en":"in/on","l2":"en"},{"leafId":417,"en":"Longmont","l2":"Longmont"}]	2018-06-27 13:15:50-06	349,-11,498,417	I live in Longmont.	0		2018-06-27 13:14:05.021884-06	2018-06-27 16:43:32.725-06
371	[{"leafId":498,"en":"in/on","l2":"en"}]	2018-06-27 14:00:42-06	498	in/on	4		2018-06-27 13:14:05.021884-06	2018-06-27 16:43:32.726-06
724	[{"leafId":556,"en":"ma\\u0027am/Mrs.","l2":"señora"}]	2018-08-31 20:07:49-06	556	ma'am/Mrs.	4		2018-08-31 19:09:07.208434-06	2018-08-31 20:09:49.157-06
492	[{"leafId":519,"en":"game","l2":"juego"}]	2018-06-27 16:43:14-06	519	game	4		2018-06-27 16:36:57.797061-06	2018-06-27 16:43:32.772-06
1190	[{"leafId":598,"en":"go","l2":"vais"}]	\N	598	I go	1		2018-09-03 10:50:14.129822-06	2018-09-03 10:50:14.128-06
201	[{"leafId":428,"en":"weeks","l2":"semanas"}]	2018-06-27 13:57:43-06	428	weeks	4		2018-06-26 21:24:31.970408-06	2018-06-27 16:43:32.707-06
1251	[{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-209,"en":"(they)","l2":"-ona"}]	\N	729,-209	(they) wrote	0		2018-09-07 14:00:41.274739-06	2018-09-07 14:00:41.274-06
1253	[{"leafId":-209,"en":"wrote","l2":"katab-"},{"leafId":-209,"en":"(they)","l2":"-ona"}]	\N	-209,-209	(they wrote)	0		2018-09-07 14:00:41.274739-06	2018-09-07 14:00:41.274-06
1254	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	731,-220,729,-220	I write.	0		2018-09-07 14:00:59.731476-06	2018-09-07 14:00:59.73-06
1256	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,729,-220	(I) write	0		2018-09-07 14:00:59.731476-06	2018-09-07 14:00:59.73-06
1258	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":-220,"en":"write","l2":"ktub-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,-220,-220	(I write)	0		2018-09-07 14:00:59.731476-06	2018-09-07 14:00:59.73-06
1259	[{"leafId":732,"en":"you (masc.)","l2":">anota"},{"leafId":-221,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-221,"en":"(you)","l2":"-u"}]	\N	732,-221,729,-221	You (masc.) write.	0		2018-09-07 14:01:26.347053-06	2018-09-07 14:01:26.346-06
1261	[{"leafId":-221,"en":"(you)","l2":"ta-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-221,"en":"(you)","l2":"-u"}]	\N	-221,729,-221	(you) write	0		2018-09-07 14:01:26.347053-06	2018-09-07 14:01:26.346-06
220	[{"leafId":352,"en":"created","l2":"cre-"},{"leafId":-6,"en":"(I)","l2":"-é"}]	2018-06-27 12:32:11-06	352,-6	(I) created	0		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.716-06
222	[{"leafId":424,"en":"application","l2":"aplicación"}]	2018-06-27 13:56:02-06	424	application	4		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.717-06
223	[{"leafId":427,"en":"mobile phone","l2":"móvil"}]	2018-06-27 15:42:28-06	427	mobile phone	4		2018-06-26 21:25:00.173425-06	2018-06-27 16:43:32.718-06
205	[{"leafId":413,"en":"with","l2":"con"}]	2018-06-27 13:57:39-06	413	with	4		2018-06-26 21:24:42.777343-06	2018-06-28 12:41:00.536-06
1214	[{"leafId":733,"en":"you (fem.)","l2":">anoti"},{"leafId":729,"en":"wrote","l2":"katab-"},{"leafId":-202,"en":"(you)","l2":"-oti"}]	\N	733,729,-202	You (fem.) wrote.	0		2018-09-07 13:59:01.390127-06	2018-09-07 13:59:01.388-06
1284	[{"leafId":739,"en":"they (masc.)","l2":"humo"},{"leafId":-228,"en":"(they)","l2":"ya-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-228,"en":"(they)","l2":"-uwna"}]	\N	739,-228,729,-228	They (masc.) write.	0		2018-09-07 14:02:40.402859-06	2018-09-07 14:02:40.4-06
1286	[{"leafId":-228,"en":"(they)","l2":"ya-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-228,"en":"(they)","l2":"-uwna"}]	\N	-228,729,-228	(they) write	0		2018-09-07 14:02:40.402859-06	2018-09-07 14:02:40.4-06
1288	[{"leafId":-228,"en":"(they)","l2":"ya-"},{"leafId":-228,"en":"write","l2":"ktub-"},{"leafId":-228,"en":"(they)","l2":"-uwna"}]	\N	-228,-228,-228	(they write)	0		2018-09-07 14:02:40.402859-06	2018-09-07 14:02:40.4-06
1289	[{"leafId":740,"en":"they (fem.)","l2":"hun~a"},{"leafId":-229,"en":"(they)","l2":"ya-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-229,"en":"(they)","l2":"-ona"}]	\N	740,-229,729,-229	They (fem.) write.	0		2018-09-07 14:02:54.445406-06	2018-09-07 14:02:54.444-06
1291	[{"leafId":-229,"en":"(they)","l2":"ya-"},{"leafId":729,"en":"write","l2":"kotub-"},{"leafId":-229,"en":"(they)","l2":"-ona"}]	\N	-229,729,-229	(they) write	0		2018-09-07 14:02:54.445406-06	2018-09-07 14:02:54.444-06
1293	[{"leafId":-229,"en":"(they)","l2":"ya-"},{"leafId":-229,"en":"write","l2":"ktub-"},{"leafId":-229,"en":"(they)","l2":"-ona"}]	\N	-229,-229,-229	(they write)	0		2018-09-07 14:02:54.445406-06	2018-09-07 14:02:54.444-06
1299	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":744,"en":"arrive","l2":"Sil-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	731,-220,744,-220	I arrive.	0		2018-09-07 16:34:45.264533-06	2018-09-07 16:34:45.259-06
1301	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":744,"en":"arrive","l2":"Sil-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,744,-220	(I) arrive	0		2018-09-07 16:34:45.264533-06	2018-09-07 16:34:45.26-06
1302	[{"leafId":744,"en":"arrive","l2":"Sil-"}]	\N	744	Stem change for wSl in PRES	1		2018-09-07 16:34:45.264533-06	2018-09-07 16:34:45.26-06
1304	[{"leafId":743,"en":"arrive","l2":"wSl"}]	\N	743	to arrive	1		2018-09-07 16:34:45.264533-06	2018-09-07 16:34:45.26-06
1305	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":758,"en":"visited","l2":"zur-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	731,758,-200	I visited.	0		2018-09-07 17:08:11.128566-06	2018-09-07 17:08:11.124-06
1307	[{"leafId":758,"en":"visited","l2":"zur-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	758,-200	(I) visited	0		2018-09-07 17:08:11.128566-06	2018-09-07 17:08:11.124-06
1308	[{"leafId":758,"en":"visited","l2":"zur-"}]	\N	758	Stem change for zwr in PAST for persons [1, 2]	1		2018-09-07 17:08:11.128566-06	2018-09-07 17:08:11.124-06
1309	[{"leafId":-200,"en":"wrote","l2":"katab-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	-200,-200	(I wrote)	0		2018-09-07 17:08:11.128566-06	2018-09-07 17:08:11.124-06
1310	[{"leafId":751,"en":"visit","l2":"zwr"}]	\N	751	to visit	1		2018-09-07 17:08:11.128566-06	2018-09-07 17:08:11.124-06
1311	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":760,"en":"flew","l2":"Tir-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	731,760,-200	I flew.	0		2018-09-07 17:08:35.172053-06	2018-09-07 17:08:35.169-06
1313	[{"leafId":760,"en":"flew","l2":"Tir-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	760,-200	(I) flew	0		2018-09-07 17:08:35.172053-06	2018-09-07 17:08:35.169-06
1314	[{"leafId":760,"en":"flew","l2":"Tir-"}]	\N	760	Stem change for Tyr in PAST for persons [1, 2]	1		2018-09-07 17:08:35.172053-06	2018-09-07 17:08:35.169-06
1316	[{"leafId":755,"en":"fly","l2":"Tyr"}]	\N	755	to fly	1		2018-09-07 17:08:35.172053-06	2018-09-07 17:08:35.169-06
1317	[{"leafId":734,"en":"he","l2":"huwa"},{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":761,"en":"visit","l2":"zuwr-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	734,-223,761,-223	He visits.	0		2018-09-07 17:17:03.77516-06	2018-09-07 17:17:03.769-06
1319	[{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":761,"en":"visit","l2":"zuwr-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	-223,761,-223	(he/she) visits	0		2018-09-07 17:17:03.77516-06	2018-09-07 17:17:03.769-06
1320	[{"leafId":761,"en":"visit","l2":"zuwr-"}]	\N	761	Stem change for zwr in PRES for persons [1, 2, 3]	1		2018-09-07 17:17:03.77516-06	2018-09-07 17:17:03.769-06
1323	[{"leafId":739,"en":"they (masc.)","l2":"humo"},{"leafId":-228,"en":"(they)","l2":"ya-"},{"leafId":762,"en":"sell","l2":"biyE-"},{"leafId":-228,"en":"(they)","l2":"-uwna"}]	\N	739,-228,762,-228	They sell.	0		2018-09-07 17:17:37.569581-06	2018-09-07 17:17:37.564-06
1325	[{"leafId":-228,"en":"(they)","l2":"ya-"},{"leafId":762,"en":"sell","l2":"biyE-"},{"leafId":-228,"en":"(they)","l2":"-uwna"}]	\N	-228,762,-228	(they) sell	0		2018-09-07 17:17:37.569581-06	2018-09-07 17:17:37.564-06
1326	[{"leafId":762,"en":"sell","l2":"biyE-"}]	\N	762	Stem change for byE in PRES for persons [1, 2, 3]	1		2018-09-07 17:17:37.569581-06	2018-09-07 17:17:37.564-06
1328	[{"leafId":753,"en":"sell","l2":"byE"}]	\N	753	to sell	1		2018-09-07 17:17:37.569581-06	2018-09-07 17:17:37.564-06
1329	[{"leafId":734,"en":"he","l2":"huwa"},{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":764,"en":"sleep","l2":"naAm-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	734,-223,764,-223	He sleeps.	0		2018-09-07 17:17:59.702477-06	2018-09-07 17:17:59.7-06
1331	[{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":764,"en":"sleep","l2":"naAm-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	-223,764,-223	(he/she) sleeps	0		2018-09-07 17:17:59.702477-06	2018-09-07 17:17:59.7-06
1332	[{"leafId":764,"en":"sleep","l2":"naAm-"}]	\N	764	Stem change for ynAm in PRES for persons [1, 2, 3]	1		2018-09-07 17:17:59.702477-06	2018-09-07 17:17:59.7-06
1334	[{"leafId":763,"en":"sleep","l2":"ynAm"}]	\N	763	to sleep	1		2018-09-07 17:17:59.702477-06	2018-09-07 17:17:59.7-06
1335	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":765,"en":"fly","l2":"Tiyr-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	731,-220,765,-220	I fly.	0		2018-09-07 17:20:17.421732-06	2018-09-07 17:20:17.419-06
1337	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":765,"en":"fly","l2":"Tiyr-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,765,-220	(I) fly	0		2018-09-07 17:20:17.421732-06	2018-09-07 17:20:17.419-06
1338	[{"leafId":765,"en":"fly","l2":"Tiyr-"}]	\N	765	Stem change for Tyr in PRES for persons [1, 2, 3]	1		2018-09-07 17:20:17.421732-06	2018-09-07 17:20:17.419-06
1341	[{"leafId":735,"en":"she","l2":"hiya"},{"leafId":767,"en":"complained","l2":"$ak-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	735,767,-204	She complained.	0		2018-09-07 17:30:25.507055-06	2018-09-07 17:30:25.504-06
1343	[{"leafId":767,"en":"complained","l2":"$ak-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	767,-204	(he/she) complained	0		2018-09-07 17:30:25.507055-06	2018-09-07 17:30:25.504-06
1344	[{"leafId":767,"en":"complained","l2":"$ak-"}]	\N	767	Stem change for $kw in PAST for persons [1, 2, 3]	1		2018-09-07 17:30:25.507055-06	2018-09-07 17:30:25.504-06
1346	[{"leafId":766,"en":"complain","l2":"$kw"}]	\N	766	to complain	1		2018-09-07 17:30:25.507055-06	2018-09-07 17:30:25.504-06
1347	[{"leafId":735,"en":"she","l2":"hiya"},{"leafId":769,"en":"walked","l2":"ma$-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	735,769,-204	She walked.	0		2018-09-07 17:31:02.808728-06	2018-09-07 17:31:02.807-06
1349	[{"leafId":769,"en":"walked","l2":"ma$-"},{"leafId":-204,"en":"(he/she)","l2":"-ato"}]	\N	769,-204	(he/she) walked	0		2018-09-07 17:31:02.808728-06	2018-09-07 17:31:02.807-06
1350	[{"leafId":769,"en":"walked","l2":"ma$-"}]	\N	769	Stem change for m$y in PAST for persons [1, 2, 3]	1		2018-09-07 17:31:02.808728-06	2018-09-07 17:31:02.807-06
1352	[{"leafId":768,"en":"walk","l2":"m$y"}]	\N	768	to walk	1		2018-09-07 17:31:02.808728-06	2018-09-07 17:31:02.807-06
1353	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":766,"en":"complained","l2":"$akaw-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	731,766,-200	I complained.	0		2018-09-07 17:36:04.178508-06	2018-09-07 17:36:04.176-06
1355	[{"leafId":766,"en":"complained","l2":"$akaw-"},{"leafId":-200,"en":"(I)","l2":"-otu"}]	\N	766,-200	(I) complained	0		2018-09-07 17:36:04.178508-06	2018-09-07 17:36:04.176-06
1358	[{"leafId":734,"en":"he","l2":"huwa"},{"leafId":772,"en":"complained","l2":"$akaA"}]	\N	734,772	He complained.	0		2018-09-07 18:25:50.796681-06	2018-09-07 18:25:50.791-06
1360	[{"leafId":772,"en":"complained","l2":"$akaA"}]	\N	772	he/she complained	1		2018-09-07 18:25:50.796681-06	2018-09-07 18:25:50.792-06
1362	[{"leafId":775,"en":"how","l2":"kayofa"},{"leafId":-225,"en":"(we)","l2":"na-"},{"leafId":774,"en":"said","l2":"quwl-"},{"leafId":-225,"en":"(we)","l2":"-u"}]	\N	775,-225,774,-225	How do we say...	0		2018-09-07 18:33:21.50024-06	2018-09-07 18:33:21.497-06
1363	[{"leafId":775,"en":"how","l2":"kayofa"}]	\N	775	how	1		2018-09-07 18:33:21.50024-06	2018-09-07 18:33:21.497-06
1364	[{"leafId":-225,"en":"(we)","l2":"na-"},{"leafId":774,"en":"said","l2":"quwl-"},{"leafId":-225,"en":"(we)","l2":"-u"}]	\N	-225,774,-225	(we) say	0		2018-09-07 18:33:21.50024-06	2018-09-07 18:33:21.497-06
1365	[{"leafId":774,"en":"said","l2":"quwl-"}]	\N	774	Stem change for qwl in PRES for persons [1, 2, 3]	1		2018-09-07 18:33:21.50024-06	2018-09-07 18:33:21.497-06
1367	[{"leafId":773,"en":"say","l2":"qwl"}]	\N	773	to say	1		2018-09-07 18:33:21.50024-06	2018-09-07 18:33:21.497-06
1368	[{"leafId":778,"en":"what","l2":"maA*aA"},{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":777,"en":"mean","l2":"Eoniy-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	778,-223,777,-223	What does ... mean?	0		2018-09-07 18:42:49.155584-06	2018-09-07 18:42:49.153-06
1369	[{"leafId":778,"en":"what","l2":"maA*aA"}]	\N	778	what	1		2018-09-07 18:42:49.155584-06	2018-09-07 18:42:49.153-06
1370	[{"leafId":-223,"en":"(he/she)","l2":"ya-"},{"leafId":777,"en":"mean","l2":"Eoniy-"},{"leafId":-223,"en":"(he/she)","l2":"-u"}]	\N	-223,777,-223	(he/she) means	0		2018-09-07 18:42:49.155584-06	2018-09-07 18:42:49.153-06
1371	[{"leafId":777,"en":"mean","l2":"Eny"}]	\N	777	to mean	1		2018-09-07 18:42:49.155584-06	2018-09-07 18:42:49.153-06
1375	[{"leafId":780,"en":"name","l2":"Aisom"}]	\N	780	name	1		2018-09-07 21:04:13.854143-06	2018-09-07 21:04:13.85-06
1373	[{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-251,"en":"your","l2":"-ka"}]	\N	780,-240,-251	your (masc.) name	0		2018-09-07 21:04:13.854143-06	2018-09-07 21:04:13.849-06
1377	[{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-252,"en":"your","l2":"-ki"}]	\N	780,-240,-252	your (fem.) name	0		2018-09-07 21:06:11.467701-06	2018-09-07 21:06:11.465-06
1381	[{"leafId":784,"en":"what","l2":"maA"},{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-251,"en":"your","l2":"-ka"}]	\N	784,780,-240,-251	What is your (masc.) name?	0		2018-09-07 21:07:10.850238-06	2018-09-07 21:07:10.847-06
1382	[{"leafId":784,"en":"what","l2":"maA"}]	\N	784	what	1		2018-09-07 21:07:10.850238-06	2018-09-07 21:07:10.848-06
1386	[{"leafId":784,"en":"what","l2":"maA"},{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-252,"en":"your","l2":"-ki"}]	\N	784,780,-240,-252	What is your (fem.) name?	0		2018-09-07 21:07:24.057689-06	2018-09-07 21:07:24.055-06
1392	[{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-242,"en":"genitive","l2":"-i"}]	\N	780,-242	name (genitive)	0		2018-09-07 21:09:15.567728-06	2018-09-07 21:09:15.565-06
1393	[{"leafId":785,"en":"Daniel","l2":"daAniyaAl"}]	\N	785	Daniel	1		2018-09-07 21:09:15.567728-06	2018-09-07 21:09:15.565-06
1395	[{"leafId":-242,"en":"genitive","l2":"-i"}]	\N	-242	Case ending for genitive	1		2018-09-07 21:09:15.567728-06	2018-09-07 21:09:15.566-06
1396	[{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-250,"en":"my","l2":"-iy"},{"leafId":785,"en":"Daniel","l2":"daAniyaAl"}]	\N	780,-250,785	My name is Daniel.	0		2018-09-07 21:31:36.915244-06	2018-09-07 21:31:36.909-06
1397	[{"leafId":780,"en":"name","l2":"Aisom"},{"leafId":-250,"en":"my","l2":"-iy"}]	\N	780,-250	name (my)	0		2018-09-07 21:31:36.915244-06	2018-09-07 21:31:36.91-06
1400	[{"leafId":-250,"en":"my","l2":"-iy"}]	\N	-250	Suffix pronoun for my	1		2018-09-07 21:31:36.915244-06	2018-09-07 21:31:36.91-06
1401	[{"leafId":787,"en":"no","l2":"laA"},{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":786,"en":"know","l2":"Eorif-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	787,-220,786,-220	I don't know.	0		2018-09-07 21:47:31.415893-06	2018-09-07 21:47:31.413-06
1402	[{"leafId":787,"en":"no","l2":"laA"}]	\N	787	no	1		2018-09-07 21:47:31.415893-06	2018-09-07 21:47:31.413-06
1403	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":786,"en":"know","l2":"Eorif-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,786,-220	(I) know	0		2018-09-07 21:47:31.415893-06	2018-09-07 21:47:31.413-06
1404	[{"leafId":786,"en":"know","l2":"Erf"}]	\N	786	to know	1		2018-09-07 21:47:31.415893-06	2018-09-07 21:47:31.413-06
1406	[{"leafId":788,"en":"from","l2":"mino"},{"leafId":789,"en":"where","l2":">ayona"},{"leafId":732,"en":"you (masc.)","l2":">anota"}]	\N	788,789,732	From where are you (masc.)?	0		2018-09-07 21:51:18.233205-06	2018-09-07 21:51:18.231-06
1407	[{"leafId":788,"en":"from","l2":"mino"}]	\N	788	from	1		2018-09-07 21:51:18.233205-06	2018-09-07 21:51:18.231-06
1408	[{"leafId":789,"en":"where","l2":">ayona"}]	\N	789	where	1		2018-09-07 21:51:18.233205-06	2018-09-07 21:51:18.231-06
1410	[{"leafId":788,"en":"from","l2":"mino"},{"leafId":789,"en":"where","l2":">ayona"},{"leafId":733,"en":"you (fem.)","l2":">anoti"}]	\N	788,789,733	From where are you (fem.)?	0		2018-09-07 21:51:39.52394-06	2018-09-07 21:51:39.521-06
1414	[{"leafId":731,"en":"I","l2":">nA"},{"leafId":788,"en":"from","l2":"mino"}]	\N	731,788	I am from ...	0		2018-09-07 21:52:26.202082-06	2018-09-07 21:52:26.2-06
1417	[{"leafId":790,"en":"yes","l2":"naEamo"}]	\N	790	Yes!	1		2018-09-07 21:53:30.258984-06	2018-09-07 21:53:30.257-06
1421	[{"leafId":775,"en":"how","l2":"kayofa"},{"leafId":791,"en":"condition","l2":"HaAl"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-251,"en":"your","l2":"-ka"}]	\N	775,791,-240,-251	How is your (masc.) condition?	0		2018-09-07 22:01:18.504865-06	2018-09-07 22:01:18.502-06
1423	[{"leafId":791,"en":"condition","l2":"HaAl"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-251,"en":"your","l2":"-ka"}]	\N	791,-240,-251	condition (nominative) (your)	0		2018-09-07 22:01:18.504865-06	2018-09-07 22:01:18.503-06
1424	[{"leafId":791,"en":"condition","l2":"HaAl"}]	\N	791	condition	1		2018-09-07 22:01:18.504865-06	2018-09-07 22:01:18.503-06
1426	[{"leafId":-251,"en":"your","l2":"-ka"}]	\N	-251	Suffix pronoun for your	1		2018-09-07 22:01:18.504865-06	2018-09-07 22:01:18.503-06
1427	[{"leafId":775,"en":"how","l2":"kayofa"},{"leafId":791,"en":"condition","l2":"HaAl"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-252,"en":"your","l2":"-ki"}]	\N	775,791,-240,-252	How is your (fem.) condition?	0		2018-09-07 22:01:46.001556-06	2018-09-07 22:01:45.999-06
1429	[{"leafId":791,"en":"condition","l2":"HaAl"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-252,"en":"your","l2":"-ki"}]	\N	791,-240,-252	condition (nominative) (your)	0		2018-09-07 22:01:46.001556-06	2018-09-07 22:01:45.999-06
1432	[{"leafId":-252,"en":"your","l2":"-ki"}]	\N	-252	Suffix pronoun for your	1		2018-09-07 22:01:46.001556-06	2018-09-07 22:01:45.999-06
1433	[{"leafId":784,"en":"what","l2":"maA"},{"leafId":792,"en":"news","l2":">axobaAr"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-251,"en":"your","l2":"-ka"}]	\N	784,792,-240,-251	What is your (masc.) news?	0		2018-09-07 22:04:09.79551-06	2018-09-07 22:04:09.793-06
1435	[{"leafId":792,"en":"news","l2":">axobaAr"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-251,"en":"your","l2":"-ka"}]	\N	792,-240,-251	news (nominative) (your)	0		2018-09-07 22:04:09.79551-06	2018-09-07 22:04:09.793-06
1436	[{"leafId":792,"en":"news","l2":">axobaAr"}]	\N	792	news	1		2018-09-07 22:04:09.79551-06	2018-09-07 22:04:09.793-06
1439	[{"leafId":784,"en":"what","l2":"maA"},{"leafId":792,"en":"news","l2":">axobaAr"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-252,"en":"your","l2":"-ki"}]	\N	784,792,-240,-252	What is your (fem.) news?	0		2018-09-07 22:04:23.891977-06	2018-09-07 22:04:23.889-06
1441	[{"leafId":792,"en":"news","l2":">axobaAr"},{"leafId":-240,"en":"nominative","l2":"-u"},{"leafId":-252,"en":"your","l2":"-ki"}]	\N	792,-240,-252	news (nominative) (your)	0		2018-09-07 22:04:23.891977-06	2018-09-07 22:04:23.889-06
1445	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":797,"en":"study","l2":"dorus-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,797,-220	I study ...	0		2018-09-07 22:25:52.204767-06	2018-09-07 22:25:52.203-06
1447	[{"leafId":797,"en":"study","l2":"drs"}]	\N	797	to study	1		2018-09-07 22:25:52.204767-06	2018-09-07 22:25:52.203-06
1449	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":798,"en":"live","l2":"sokun-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,798,-220	I live ...	0		2018-09-07 22:27:41.030558-06	2018-09-07 22:27:41.029-06
1451	[{"leafId":798,"en":"live","l2":"skn"}]	\N	798	to live	1		2018-09-07 22:27:41.030558-06	2018-09-07 22:27:41.03-06
1453	[{"leafId":-220,"en":"(I)","l2":">a-"},{"leafId":799,"en":"work","l2":"Eomal-"},{"leafId":-220,"en":"(I)","l2":"-u"}]	\N	-220,799,-220	I work ...	0		2018-09-07 22:28:53.283689-06	2018-09-07 22:28:53.283-06
1455	[{"leafId":799,"en":"work","l2":"Eml"}]	\N	799	to work	1		2018-09-07 22:28:53.283689-06	2018-09-07 22:28:53.283-06
\.


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cards_card_id_seq', 1456, true);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY goals (goal_id, en, l2, created_at, updated_at, card_id, paragraph_id) FROM stdin;
51	Good morning!	buenos días	2018-06-27 11:32:20.197587-06	2018-06-27 11:32:20.196-06	122	1
52	Good afternoon!	buenas tardes	2018-06-27 11:33:22.240924-06	2018-06-27 11:33:22.239-06	125	1
57	What are you doing?	qué haces	2018-06-27 11:36:42.409091-06	2018-06-27 11:36:42.408-06	155	1
59	Hello!	hola	2018-06-27 11:36:54.74803-06	2018-06-27 11:36:54.747-06	164	1
75	I'm well.	estoy bien	2018-06-27 15:23:20.094644-06	2018-06-27 15:23:20.093-06	160	1
77	I'm happy.	estoy feliz	2018-06-27 16:00:49.992096-06	2018-06-27 16:00:49.991-06	425	1
78	I'm alone.	estoy solo	2018-06-27 16:01:36.524009-06	2018-06-27 16:01:36.522-06	429	1
79	I'm sad.	estoy triste	2018-06-27 16:02:09.873451-06	2018-06-27 16:02:09.872-06	433	1
66	I created a mobile app to study Spanish.	creé una aplicación móvil para estudiar español	2018-06-27 11:38:39.11106-06	2018-06-27 11:38:39.11-06	219	2
88	I didn't create that account	no creé esa cuenta	2018-06-27 16:35:37.782737-06	2018-06-27 16:35:37.781-06	482	2
89	It's a game that I made	es un juego que yo creé	2018-06-27 16:36:57.80771-06	2018-06-27 16:36:57.806-06	489	2
90	I created a profile.	creé un perfil	2018-06-27 16:38:29.530083-06	2018-06-27 16:38:29.529-06	499	2
91	Did you create an account?	creaste una cuenta	2018-06-27 16:40:23.232433-06	2018-06-27 16:40:23.231-06	505	2
74	I'm a software engineer.	soy ingeniero de software	2018-06-27 15:22:50.59426-06	2018-06-27 15:22:50.593-06	128	2
54	Where do you live?	dónde vives	2018-06-27 11:33:43.293132-06	2018-06-27 11:33:43.291-06	134	3
63	I visited Cuba for a few weeks.	visité Cuba por unas semanas	2018-06-27 11:37:41.944888-06	2018-06-27 11:37:41.944-06	196	3
92	I moved three times.	mudé tres veces	2018-06-27 16:42:16.920114-06	2018-06-27 16:42:16.918-06	511	3
97	I grew up in Pennsylvania.	crecí en Pennsylvania	2018-06-27 17:08:39.852694-06	2018-06-27 17:08:39.851-06	465	3
86	Did you grow up here?	creciste aquí	2018-06-27 16:17:49.579741-06	2018-06-27 16:17:49.579-06	471	3
68	I live in Longmont.	vivo en Longmont	2018-06-27 13:14:05.055061-06	2018-06-27 13:14:05.053-06	369	3
69	I moved to Longmont in January.	me mudé a Longmont en enero	2018-06-27 13:14:36.969027-06	2018-06-27 13:14:36.967-06	375	3
80	Did you sell the house yet?	ya vendiste la casa	2018-06-27 16:06:42.83877-06	2018-06-27 16:06:42.838-06	437	3
56	I speak English.	hablo inglés	2018-06-27 11:36:31.198704-06	2018-06-27 11:36:31.195-06	144	4
62	I made a list of sentences to learn.	hice una lista de oraciones para aprender	2018-06-27 11:37:30.031693-06	2018-06-27 11:37:30.03-06	185	4
64	Who do you want to speak Spanish with?	con quién quieres hablar español	2018-06-27 11:38:01.05192-06	2018-06-27 11:38:01.051-06	204	4
65	Where did you learn Spanish?	dónde aprendiste español	2018-06-27 11:38:14.912658-06	2018-06-27 11:38:14.911-06	213	4
67	I took a Spanish class.	asistí una clase de español	2018-06-27 11:39:07.120565-06	2018-06-27 11:39:07.119-06	229	4
55	I speak Spanish.	hablo español	2018-06-27 11:36:23.881449-06	2018-06-27 11:36:23.88-06	139	4
87	I knew him well.	lo conocí bien	2018-06-27 16:21:20.059281-06	2018-06-27 16:21:20.058-06	476	5
76	I did a test.	hice una prueba	2018-06-27 15:36:09.526577-06	2018-06-27 15:36:09.525-06	418	5
81	What did you eat today?	qué comiste hoy	2018-06-27 16:10:43.303767-06	2018-06-27 16:10:43.303-06	444	5
82	I ate too much.	comí demasiado	2018-06-27 16:11:55.919313-06	2018-06-27 16:11:55.918-06	450	5
83	I ran outside.	corrí afuera	2018-06-27 16:13:49.833986-06	2018-06-27 16:13:49.833-06	455	5
84	Why did you run?	porqué corriste	2018-06-27 16:14:35.038984-06	2018-06-27 16:14:35.038-06	460	5
99	software engineer	ingeniero de software	2018-06-28 12:12:28.882483-06	2018-06-28 12:12:28.88-06	581	2
100	I have a program.	tengo un programa	2018-07-17 08:25:23.077859-06	2018-07-17 08:25:23.077-06	585	2
101	I have a project.	tengo un proyecto	2018-07-17 08:26:11.795916-06	2018-07-17 08:26:11.794-06	590	2
102	I have an app.	tengo una aplicación	2018-07-17 08:26:28.988641-06	2018-07-17 08:26:28.987-06	595	2
103	an app to practice Spanish	una aplicación para practicar español	2018-07-17 08:27:37.738882-06	2018-07-17 08:27:37.738-06	600	2
104	an app to learn Spanish	una aplicación para aprender español	2018-07-17 08:27:56.697588-06	2018-07-17 08:27:56.696-06	606	2
105	an app to review flashcards	una aplicación para revisar tarjetas de memoria	2018-07-17 08:29:39.042319-06	2018-07-17 08:29:39.04-06	612	2
107	I'm different than most people	soy diferente a las otras personas	2018-07-17 08:35:15.164984-06	2018-07-17 08:35:15.164-06	628	2
108	It's different than most programs.	es diferente a los otros programas	2018-07-17 08:37:44.195121-06	2018-07-17 08:37:44.194-06	636	2
109	It's different than most apps.	es diferente a las otras aplicaciones	2018-07-17 08:38:38.861874-06	2018-07-17 08:38:38.861-06	644	2
110	There are many language learning programs	hay muchos programas de aprendizaje de lenguas	2018-07-17 08:49:36.251795-06	2018-07-17 08:49:36.251-06	652	2
111	Do you want to listen to examples?	quieres escuchar ejemplos	2018-07-17 08:51:53.491506-06	2018-07-17 08:51:53.49-06	661	2
112	I need examples of sentences.	necesito ejemplos de oraciones	2018-07-17 08:52:55.147978-06	2018-07-17 08:52:55.146-06	668	2
113	I need examples of how a word is used.	necesito ejemplos de cómo se usa una palabra	2018-07-17 08:54:45.456537-06	2018-07-17 08:54:45.455-06	675	2
114	What's the context of the word?	cuál es el contexto de la palabra	2018-07-17 08:56:07.45952-06	2018-07-17 08:56:07.458-06	688	2
115	In what sentence is it used?	en qué oración se usa	2018-07-17 08:56:27.735312-06	2018-07-17 08:56:27.734-06	697	2
116	Words have a context	las palabras tienen un contexto	2018-07-17 08:56:49.715932-06	2018-07-17 08:56:49.715-06	705	2
117	Words belong in sentences	las palabras pertenecen a oraciones	2018-07-17 08:58:30.433049-06	2018-07-17 08:58:30.432-06	714	2
134	Pardon, ma'am.	Perdón, señora.	2018-09-01 16:29:03.566214-06	2018-09-01 16:29:03.564-06	722	7
136	I don't understand Castilian.	No entiendo castellano.	2018-09-01 16:43:39.787248-06	2018-09-01 16:43:39.785-06	815	7
137	Are you American? (formal)	¿Es usted norteamericano?	2018-09-01 16:45:34.324614-06	2018-09-01 16:45:34.323-06	732	7
138	No, not American.	No, norteamericana no.	2018-09-01 16:49:52.115113-06	2018-09-01 16:49:52.114-06	827	7
139	Do you speak English? (formal)	¿Habla inglés?	2018-09-01 17:03:58.601612-06	2018-09-01 17:03:58.6-06	737	7
140	Yes, I speak English a little.	Sí, hablo inglés un poco.	2018-09-01 17:04:18.935675-06	2018-09-01 17:04:18.934-06	742	7
141	Do you understand Castilian? (formal)	¿Entiende castellano?	2018-09-01 17:04:37.736529-06	2018-09-01 17:04:37.735-06	844	7
142	I understand very well.	Entiendo muy bien.	2018-09-01 17:04:55.14432-06	2018-09-01 17:04:55.143-06	756	7
143	How are you? (formal)	¿Cómo está usted?	2018-09-01 17:05:17.022334-06	2018-09-01 17:05:17.02-06	763	7
144	Good morning!	Buenos días.	2018-09-01 17:05:51.032702-06	2018-09-01 17:05:51.032-06	122	7
145	Thanks!	Gracias.	2018-09-01 17:06:05.159978-06	2018-09-01 17:06:05.158-06	771	7
146	Bye, miss.	Adiós, señorita.	2018-09-01 17:06:19.850869-06	2018-09-01 17:06:19.85-06	773	7
147	Do you speak Castilian? (formal)	¿Habla usted castellano?	2018-09-01 17:06:44.778785-06	2018-09-01 17:06:44.777-06	870	7
148	I don't speak very well.	No hablo muy bien.	2018-09-01 17:07:00.475458-06	2018-09-01 17:07:00.474-06	782	7
149	You speak Castilian very well. (formal)	(Usted) habla castellano muy bien.	2018-09-01 17:07:28.393163-06	2018-09-01 17:07:28.392-06	883	7
150	I'm not American. (masc.)	No soy norteamericano.	2018-09-01 17:08:39.17807-06	2018-09-01 17:08:39.177-06	891	8
151	I'm American. (masc.)	Soy norteamericano.	2018-09-01 17:08:52.40878-06	2018-09-01 17:08:52.408-06	896	8
152	I'm from Chicago.	Soy de Chicago.	2018-09-01 17:09:14.548184-06	2018-09-01 17:09:14.547-06	900	8
153	From where?	¿De dónde?	2018-09-01 17:10:05.242034-06	2018-09-01 17:10:05.241-06	905	8
154	Where are you from? (formal)	¿De dónde es usted?	2018-09-01 17:10:23.683196-06	2018-09-01 17:10:23.682-06	908	8
155	Good afternoon!	Buenas tardes.	2018-09-01 17:10:59.796903-06	2018-09-01 17:10:59.796-06	125	8
156	the afternoon	la tarde	2018-09-01 17:11:18.626206-06	2018-09-01 17:11:18.625-06	917	8
157	the gentleman	el señor	2018-09-01 17:12:59.641812-06	2018-09-01 17:12:59.64-06	920	8
158	the lady	la señora	2018-09-01 17:13:50.160677-06	2018-09-01 17:13:50.16-06	923	8
159	the day	el día	2018-09-01 17:14:37.491031-06	2018-09-01 17:14:37.49-06	926	8
160	Good evening!	Buenas noches.	2018-09-01 17:18:57.171977-06	2018-09-01 17:18:57.17-06	929	8
161	the night	la noche	2018-09-01 17:19:20.911304-06	2018-09-01 17:19:20.91-06	932	8
162	You're from Mexico. (formal)	Usted es de México.	2018-09-01 17:20:15.418844-06	2018-09-01 17:20:15.418-06	935	8
163	I'm from America. (formal)	Soy de Norteamérica.	2018-09-01 17:20:47.346149-06	2018-09-01 17:20:47.345-06	941	8
164	from Bolivia	de Bolivia	2018-09-01 17:21:09.295713-06	2018-09-01 17:21:09.293-06	946	8
165	I'm Mrs. Garcia.	Soy la señora García.	2018-09-01 17:21:42.828628-06	2018-09-01 17:21:42.827-06	949	8
166	I'm Mr. Jones.	Soy el señor Jones	2018-09-01 17:22:05.97867-06	2018-09-01 17:22:05.978-06	955	8
168	I'm not from Los Angeles.	No soy de Los Angeles.	2018-09-01 17:27:54.380998-06	2018-09-01 17:27:54.38-06	968	8
169	Hello!	Bonjour!	2018-09-02 15:44:30.792113-06	2018-09-02 15:44:30.79-06	975	9
170	I am.	Je suis.	2018-09-02 16:46:53.979935-06	2018-09-02 16:46:53.978-06	977	9
172	He is.	Il est.	2018-09-02 16:48:38.406524-06	2018-09-02 16:48:38.405-06	985	9
173	She is.	Elle est.	2018-09-02 16:48:59.912164-06	2018-09-02 16:48:59.909-06	989	9
174	We are.	Nous sommes.	2018-09-02 16:49:20.086159-06	2018-09-02 16:49:20.085-06	993	9
175	You are. (pl.)	Vous êtes.	2018-09-02 16:49:52.701229-06	2018-09-02 16:49:52.7-06	997	9
171	You are. (sing.)	Tu es.	2018-09-02 16:48:08.869497-06	2018-09-02 16:48:08.868-06	981	9
176	They are. (masc.)	Ils sont.	2018-09-02 16:50:59.558839-06	2018-09-02 16:50:59.558-06	1001	9
177	They are. (fem.)	Elles sont.	2018-09-02 16:51:13.364943-06	2018-09-02 16:51:13.364-06	1005	9
178	How's it going?	Comment ça va?	2018-09-02 16:54:37.511941-06	2018-09-02 16:54:37.511-06	1009	9
179	It's going very well, thanks.	Ça va très bien, merci.	2018-09-02 16:55:18.461535-06	2018-09-02 16:55:18.46-06	1014	9
180	And you? (formal)	Et vous?	2018-09-02 16:55:45.705979-06	2018-09-02 16:55:45.705-06	1021	9
181	I speak.	Je parle.	2018-09-02 17:17:58.996582-06	2018-09-02 17:17:58.995-06	1024	9
182	You speak.	Tu parles.	2018-09-02 17:18:18.346806-06	2018-09-02 17:18:18.346-06	1029	9
183	He speaks.	Il parle.	2018-09-02 17:18:33.197903-06	2018-09-02 17:18:33.197-06	1034	9
184	We speak.	Nous parlons.	2018-09-02 17:18:47.058296-06	2018-09-02 17:18:47.055-06	1039	9
185	You speak. (pl.)	Vous parlez.	2018-09-02 17:19:01.183814-06	2018-09-02 17:19:01.183-06	1044	9
186	They speak.	Ils parlent.	2018-09-02 17:19:21.844623-06	2018-09-02 17:19:21.843-06	1049	9
187	He calls.	Il appelle.	2018-09-03 01:46:19.484676-06	2018-09-03 01:46:19.482-06	1054	9
188	We call.	Nous appelons.	2018-09-03 01:57:58.839346-06	2018-09-03 01:57:58.837-06	1060	9
189	She calls.	Elle appelle.	2018-09-03 01:58:13.595394-06	2018-09-03 01:58:13.594-06	1065	9
190	They call.	Ils appellent.	2018-09-03 02:03:42.605601-06	2018-09-03 02:03:42.603-06	1071	9
191	It's going well, thanks.	Ça va, merci.	2018-09-03 07:40:24.808897-06	2018-09-03 07:40:24.806-06	1077	9
192	What do you call yourself?	Comment vous appelez-vous?	2018-09-03 07:40:54.270232-06	2018-09-03 07:40:54.269-06	1082	9
194	I call myself Pat.	Je m'appelle Pat.	2018-09-03 09:06:47.349887-06	2018-09-03 09:06:47.348-06	1097	9
195	Enchanted.	Enchanté.	2018-09-03 10:13:44.483017-06	2018-09-03 10:13:44.481-06	1105	9
196	And you come from where? (formal)	Et vous venez d'où?	2018-09-03 10:41:36.694268-06	2018-09-03 10:41:36.692-06	1107	9
197	I come from France.	Je viens de France.	2018-09-03 10:42:20.303468-06	2018-09-03 10:42:20.302-06	1115	9
198	I am French. (masc.)	Je suis français.	2018-09-03 10:42:42.702922-06	2018-09-03 10:42:42.702-06	1123	9
199	I come from the United States.	Je viens des États-Unis.	2018-09-03 10:44:02.9212-06	2018-09-03 10:44:02.92-06	1128	9
200	I am American.	Je suis américain.	2018-09-03 10:44:28.953505-06	2018-09-03 10:44:28.952-06	1137	9
201	You come from where exactly? (formal)	Vous venez d'où exactement?	2018-09-03 10:44:59.589935-06	2018-09-03 10:44:59.589-06	1142	9
202	I come from Boston.	Je viens de Boston.	2018-09-03 10:45:39.687164-06	2018-09-03 10:45:39.686-06	1150	9
203	I am a student.	Je suis étudiant.	2018-09-03 10:46:05.057655-06	2018-09-03 10:46:05.056-06	1158	9
204	I'm an professor of English.	Je suis professeur d'anglais.	2018-09-03 10:47:02.846993-06	2018-09-03 10:47:02.846-06	1163	9
205	You speak English? (formal)	Vous parlez anglais?	2018-09-03 10:47:22.308728-06	2018-09-03 10:47:22.308-06	1170	9
206	Yes.	Oui.	2018-09-03 10:47:45.277554-06	2018-09-03 10:47:45.276-06	1176	9
207	You speak French? (formal)	Vous parlez français?	2018-09-03 10:48:05.397261-06	2018-09-03 10:48:05.396-06	1178	9
208	A little bit.	Un petit peu.	2018-09-03 10:48:55.333109-06	2018-09-03 10:48:55.332-06	1184	9
209	I'm going to my home now.	Je vais chez moi maintenant.	2018-09-03 10:50:14.15055-06	2018-09-03 10:50:14.149-06	1188	9
210	Me too.	Moi aussi.	2018-09-03 10:50:39.900853-06	2018-09-03 10:50:39.9-06	1195	9
211	Goodbye!	Au revoir!	2018-09-03 10:52:25.904307-06	2018-09-03 10:52:25.903-06	1198	9
212	Good day!	Bonne journée!	2018-09-03 10:53:12.948423-06	2018-09-03 10:53:12.947-06	1201	9
213	I wrote.	>nA nakotubu	2018-09-07 13:58:35.798015-06	2018-09-07 13:58:35.797-06	1204	10
214	You (masc.) wrote.	>anota katabota	2018-09-07 13:58:47.806918-06	2018-09-07 13:58:47.805-06	1209	10
215	You (fem.) wrote.	>anoti kataboti	2018-09-07 13:59:01.404397-06	2018-09-07 13:59:01.403-06	1214	10
216	He wrote.	huwa kataba	2018-09-07 13:59:11.736283-06	2018-09-07 13:59:11.735-06	1219	10
217	She wrote.	hiya katabato	2018-09-07 13:59:25.622427-06	2018-09-07 13:59:25.621-06	1224	10
218	We wrote.	naHonu katabonaA	2018-09-07 13:59:37.28073-06	2018-09-07 13:59:37.279-06	1229	10
219	You (masc. pl.) wrote.	>anotumo katabotumo	2018-09-07 13:59:56.002312-06	2018-09-07 13:59:56.001-06	1234	10
220	You (fem. pl.) wrote.	>anotun~a katabotun~a	2018-09-07 14:00:12.421191-06	2018-09-07 14:00:12.42-06	1239	10
221	They (masc.) wrote.	humo katabuwA	2018-09-07 14:00:24.838875-06	2018-09-07 14:00:24.838-06	1244	10
222	They (fem.) wrote.	hun~a katabona	2018-09-07 14:00:41.292526-06	2018-09-07 14:00:41.291-06	1249	10
223	I write.	>nA >akotubu	2018-09-07 14:00:59.746726-06	2018-09-07 14:00:59.746-06	1254	10
224	You (masc.) write.	>anota takotubu	2018-09-07 14:01:26.36215-06	2018-09-07 14:01:26.361-06	1259	10
225	You (fem.) write.	>anoti takotubiyna	2018-09-07 14:01:41.586342-06	2018-09-07 14:01:41.585-06	1264	10
226	He writes.	huwa yakotubu	2018-09-07 14:01:51.391214-06	2018-09-07 14:01:51.39-06	1269	10
227	You (masc. pl.) write.	>anotumo takotubuwna	2018-09-07 14:02:08.45161-06	2018-09-07 14:02:08.45-06	1274	10
228	You (fem. pl.) write.	>anotun~a takotubona	2018-09-07 14:02:27.766485-06	2018-09-07 14:02:27.765-06	1279	10
229	They (masc.) write.	humo yakotubuwna	2018-09-07 14:02:40.421748-06	2018-09-07 14:02:40.421-06	1284	10
230	They (fem.) write.	hun~a yakotubona	2018-09-07 14:02:54.460258-06	2018-09-07 14:02:54.459-06	1289	10
231	You (fem.) sit.	>anota tajolisiyna	2018-09-07 14:11:56.479091-06	2018-09-07 14:11:56.478-06	1294	10
232	I arrive.	>nA >aSilu	2018-09-07 16:34:45.325427-06	2018-09-07 16:34:45.324-06	1299	10
233	I visited.	>nA zurotu	2018-09-07 17:08:11.171766-06	2018-09-07 17:08:11.17-06	1305	10
234	I flew.	>nA Tirotu	2018-09-07 17:08:35.194543-06	2018-09-07 17:08:35.193-06	1311	10
235	He visits.	huwa yazuwru	2018-09-07 17:17:03.82239-06	2018-09-07 17:17:03.82-06	1317	10
236	They sell.	humo yabiyEuwna	2018-09-07 17:17:37.587643-06	2018-09-07 17:17:37.587-06	1323	10
237	He sleeps.	huwa yanaAmu	2018-09-07 17:17:59.715697-06	2018-09-07 17:17:59.714-06	1329	10
238	I fly.	>nA >aTiyru	2018-09-07 17:20:17.440786-06	2018-09-07 17:20:17.438-06	1335	10
239	She complained.	hiya $akato	2018-09-07 17:30:25.517612-06	2018-09-07 17:30:25.517-06	1341	10
240	She walked.	hiya ma$ato	2018-09-07 17:31:02.824177-06	2018-09-07 17:31:02.823-06	1347	10
241	I complained.	>nA $akawotu	2018-09-07 17:36:04.305703-06	2018-09-07 17:36:04.305-06	1353	10
242	He complained.	huwa $akaA	2018-09-07 18:25:50.839769-06	2018-09-07 18:25:50.838-06	1358	10
243	How do we say...	kayofa naquwlu	2018-09-07 18:33:21.540067-06	2018-09-07 18:33:21.539-06	1362	11
244	What does ... mean?	maA*aA yaEoniyu	2018-09-07 18:42:49.170495-06	2018-09-07 18:42:49.169-06	1368	11
245	your (masc.) name	Aisomuka	2018-09-07 21:04:13.918393-06	2018-09-07 21:04:13.915-06	1373	11
246	your (fem.) name	Aisomuki	2018-09-07 21:06:11.485074-06	2018-09-07 21:06:11.483-06	1377	11
247	What is your (masc.) name?	maA Aisomuka	2018-09-07 21:07:10.868857-06	2018-09-07 21:07:10.867-06	1381	11
248	What is your (fem.) name?	maA Aisomuki	2018-09-07 21:07:24.069246-06	2018-09-07 21:07:24.068-06	1386	11
250	My name is Daniel.	Aisomiy daAniyaAl	2018-09-07 21:31:36.973458-06	2018-09-07 21:31:36.972-06	1396	11
251	I don't know.	laA >aEorifu	2018-09-07 21:47:31.45394-06	2018-09-07 21:47:31.453-06	1401	12
252	From where are you (masc.)?	mino >ayona >anota	2018-09-07 21:51:18.248293-06	2018-09-07 21:51:18.247-06	1406	12
253	From where are you (fem.)?	mino >ayona >anoti	2018-09-07 21:51:39.541426-06	2018-09-07 21:51:39.54-06	1410	12
254	I am from ...	>nA mino 	2018-09-07 21:52:26.221799-06	2018-09-07 21:52:26.221-06	1414	12
255	Yes!	naEamo	2018-09-07 21:53:30.26645-06	2018-09-07 21:53:30.264-06	1417	12
256	No!	laA	2018-09-07 21:53:50.931538-06	2018-09-07 21:53:50.93-06	1402	12
257	How is your (masc.) condition?	kayofa HaAluka	2018-09-07 22:01:18.523566-06	2018-09-07 22:01:18.522-06	1421	13
258	How is your (fem.) condition?	kayofa HaAluki	2018-09-07 22:01:46.01816-06	2018-09-07 22:01:46.017-06	1427	13
259	What is your (masc.) news?	maA >axobaAruka	2018-09-07 22:04:09.81005-06	2018-09-07 22:04:09.809-06	1433	13
260	What is your (fem.) news?	maA >axobaAruki	2018-09-07 22:04:23.913715-06	2018-09-07 22:04:23.913-06	1439	13
261	I study ...	>adorusu	2018-09-07 22:25:52.225971-06	2018-09-07 22:25:52.225-06	1445	14
262	I live ...	>asokunu	2018-09-07 22:27:41.039585-06	2018-09-07 22:27:41.039-06	1449	14
263	I work ...	>aEomalu	2018-09-07 22:28:53.29411-06	2018-09-07 22:28:53.293-06	1453	14
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('goals_goal_id_seq', 263, true);


--
-- Data for Name: leafs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY leafs (leaf_id, leaf_type, es_mixed, en, en_disambiguation, en_plural, en_past, number, person, tense, created_at, infinitive_leaf_id, fr_mixed, ar_buckwalter, ar_pres_middle_vowel_buckwalter, persons_csv, gender) FROM stdin;
581	FrNonverb	\N	hello	\N	\N	\N	\N	\N	\N	2018-09-02 15:44:30.654025-06	\N	Bonjour	\N	\N	\N	\N
315	EsInf	andar	walk		\N	walked	\N	\N	\N	2018-06-24 09:57:33.983446-06	\N	\N	\N	\N	\N	\N
316	EsInf	aprender	learn		\N	learned	\N	\N	\N	2018-06-24 09:57:33.984734-06	\N	\N	\N	\N	\N	\N
317	EsInf	comer	eat		\N	ate	\N	\N	\N	2018-06-24 09:57:33.985347-06	\N	\N	\N	\N	\N	\N
319	EsInf	contar	tell		\N	told	\N	\N	\N	2018-06-24 09:57:33.98678-06	\N	\N	\N	\N	\N	\N
320	EsInf	dar	give		\N	gave	\N	\N	\N	2018-06-24 09:57:33.987309-06	\N	\N	\N	\N	\N	\N
321	EsInf	decir	say		\N	said	\N	\N	\N	2018-06-24 09:57:33.987899-06	\N	\N	\N	\N	\N	\N
322	EsInf	empezar	start		\N	started	\N	\N	\N	2018-06-24 09:57:33.988574-06	\N	\N	\N	\N	\N	\N
323	EsInf	encontrar	find		\N	found	\N	\N	\N	2018-06-24 09:57:33.994568-06	\N	\N	\N	\N	\N	\N
324	EsInf	entender	understand		\N	understood	\N	\N	\N	2018-06-24 09:57:34.000548-06	\N	\N	\N	\N	\N	\N
325	EsInf	enviar	send		\N	sent	\N	\N	\N	2018-06-24 09:57:34.006513-06	\N	\N	\N	\N	\N	\N
327	EsInf	hablar	speak		\N	spoke	\N	\N	\N	2018-06-24 09:57:34.017548-06	\N	\N	\N	\N	\N	\N
328	EsInf	hacer	do		\N	did	\N	\N	\N	2018-06-24 09:57:34.018056-06	\N	\N	\N	\N	\N	\N
329	EsInf	ir	go		\N	went	\N	\N	\N	2018-06-24 09:57:34.018688-06	\N	\N	\N	\N	\N	\N
330	EsInf	parecer	seem		\N	seemed	\N	\N	\N	2018-06-24 09:57:34.019227-06	\N	\N	\N	\N	\N	\N
331	EsInf	pedir	request		\N	requested	\N	\N	\N	2018-06-24 09:57:34.019677-06	\N	\N	\N	\N	\N	\N
332	EsInf	pensar	think		\N	thought	\N	\N	\N	2018-06-24 09:57:34.020182-06	\N	\N	\N	\N	\N	\N
333	EsInf	poder	can		\N	could	\N	\N	\N	2018-06-24 09:57:34.020785-06	\N	\N	\N	\N	\N	\N
334	EsInf	poner	put		\N	put	\N	\N	\N	2018-06-24 09:57:34.021223-06	\N	\N	\N	\N	\N	\N
335	EsInf	preguntar	ask		\N	asked	\N	\N	\N	2018-06-24 09:57:34.021846-06	\N	\N	\N	\N	\N	\N
336	EsInf	querer	want		\N	wanted	\N	\N	\N	2018-06-24 09:57:34.022716-06	\N	\N	\N	\N	\N	\N
337	EsInf	recordar	remember		\N	remembered	\N	\N	\N	2018-06-24 09:57:34.023446-06	\N	\N	\N	\N	\N	\N
339	EsInf	salir	go out		\N	went out	\N	\N	\N	2018-06-24 09:57:34.02479-06	\N	\N	\N	\N	\N	\N
340	EsInf	seguir	follow		\N	followed	\N	\N	\N	2018-06-24 09:57:34.025256-06	\N	\N	\N	\N	\N	\N
341	EsInf	sentir	feel		\N	felt	\N	\N	\N	2018-06-24 09:57:34.026079-06	\N	\N	\N	\N	\N	\N
343	EsInf	tener	have		\N	had	\N	\N	\N	2018-06-24 09:57:34.027222-06	\N	\N	\N	\N	\N	\N
344	EsInf	trabajar	work		\N	worked	\N	\N	\N	2018-06-24 09:57:34.027967-06	\N	\N	\N	\N	\N	\N
345	EsInf	ver	see		\N	saw	\N	\N	\N	2018-06-24 09:57:34.028806-06	\N	\N	\N	\N	\N	\N
346	EsInf	venir	come		\N	came	\N	\N	\N	2018-06-24 09:57:34.029696-06	\N	\N	\N	\N	\N	\N
347	EsInf	visitar	visit		\N	visited	\N	\N	\N	2018-06-24 09:57:34.030334-06	\N	\N	\N	\N	\N	\N
348	EsInf	volver	return		\N	returned	\N	\N	\N	2018-06-24 09:57:34.031357-06	\N	\N	\N	\N	\N	\N
349	EsInf	vivir	live		\N	lived	\N	\N	\N	2018-06-24 10:12:18.679112-06	\N	\N	\N	\N	\N	\N
350	EsInf	asistir	attend		\N	attended	\N	\N	\N	2018-06-24 10:15:03.427516-06	\N	\N	\N	\N	\N	\N
351	EsInf	mudar	move		\N	moved	\N	\N	\N	2018-06-24 10:16:29.743042-06	\N	\N	\N	\N	\N	\N
352	EsInf	crear	create		\N	created	\N	\N	\N	2018-06-24 10:17:19.293622-06	\N	\N	\N	\N	\N	\N
353	EsInf	estudiar	study		\N	studied	\N	\N	\N	2018-06-24 10:21:48.839702-06	\N	\N	\N	\N	\N	\N
326	EsInf	estar	be	how	\N	was	\N	\N	\N	2018-06-24 09:57:34.012434-06	\N	\N	\N	\N	\N	\N
318	EsInf	conocer	know	someone	\N	knew	\N	\N	\N	2018-06-24 09:57:33.986019-06	\N	\N	\N	\N	\N	\N
338	EsInf	saber	know	something	\N	knew	\N	\N	\N	2018-06-24 09:57:34.024181-06	\N	\N	\N	\N	\N	\N
342	EsInf	ser	be	what	\N	was	\N	\N	\N	2018-06-24 09:57:34.026682-06	\N	\N	\N	\N	\N	\N
504	EsInf	vender	sell		\N	sold	\N	\N	\N	2018-06-27 16:05:02.651479-06	\N	\N	\N	\N	\N	\N
509	EsInf	correr	run		\N	ran	\N	\N	\N	2018-06-27 16:13:24.686094-06	\N	\N	\N	\N	\N	\N
510	EsInf	afuera	outside		\N		\N	\N	\N	2018-06-27 16:13:41.673097-06	\N	\N	\N	\N	\N	\N
513	EsInf	crecer	grow up		\N	grew up	\N	\N	\N	2018-06-27 16:16:00.615531-06	\N	\N	\N	\N	\N	\N
526	EsInf	practicar	practice		\N	practiced	\N	\N	\N	2018-07-17 08:27:34.682383-06	\N	\N	\N	\N	\N	\N
527	EsInf	revisar	review		\N	reviewed	\N	\N	\N	2018-07-17 08:29:02.066228-06	\N	\N	\N	\N	\N	\N
538	EsInf	haber	be	exist	\N	existed	\N	\N	\N	2018-07-17 08:44:14.793496-06	\N	\N	\N	\N	\N	\N
544	EsInf	escuchar	listen		\N	listened	\N	\N	\N	2018-07-17 08:50:59.808615-06	\N	\N	\N	\N	\N	\N
547	EsInf	necesitar	need		\N	needed	\N	\N	\N	2018-07-17 08:52:50.335987-06	\N	\N	\N	\N	\N	\N
549	EsInf	usar	use		\N	used	\N	\N	\N	2018-07-17 08:54:22.907576-06	\N	\N	\N	\N	\N	\N
554	EsInf	pertenecer	belong		\N	belonged	\N	\N	\N	2018-07-17 08:58:24.780015-06	\N	\N	\N	\N	\N	\N
383	EsNonverb	tarde	afternoon		afternoons	\N	\N	\N	\N	2018-06-24 09:42:32.325038-06	\N	\N	\N	\N	\N	\N
354	EsNonverb	brazo	arm		arms	\N	\N	\N	\N	2018-06-24 09:42:32.310062-06	\N	\N	\N	\N	\N	\N
355	EsNonverb	pierna	leg		legs	\N	\N	\N	\N	2018-06-24 09:42:32.31134-06	\N	\N	\N	\N	\N	\N
356	EsNonverb	corazón	heart		hearts	\N	\N	\N	\N	2018-06-24 09:42:32.311925-06	\N	\N	\N	\N	\N	\N
357	EsNonverb	estómago	stomach		stomachs	\N	\N	\N	\N	2018-06-24 09:42:32.312547-06	\N	\N	\N	\N	\N	\N
358	EsNonverb	ojo	eye		eyes	\N	\N	\N	\N	2018-06-24 09:42:32.313039-06	\N	\N	\N	\N	\N	\N
359	EsNonverb	nariz	nose		noses	\N	\N	\N	\N	2018-06-24 09:42:32.313538-06	\N	\N	\N	\N	\N	\N
360	EsNonverb	boca	mouth		mouths	\N	\N	\N	\N	2018-06-24 09:42:32.31404-06	\N	\N	\N	\N	\N	\N
361	EsNonverb	oreja	ear		ears	\N	\N	\N	\N	2018-06-24 09:42:32.314516-06	\N	\N	\N	\N	\N	\N
362	EsNonverb	cara	face		faces	\N	\N	\N	\N	2018-06-24 09:42:32.314983-06	\N	\N	\N	\N	\N	\N
363	EsNonverb	cuello	neck		necks	\N	\N	\N	\N	2018-06-24 09:42:32.315436-06	\N	\N	\N	\N	\N	\N
364	EsNonverb	dedo	finger		fingers	\N	\N	\N	\N	2018-06-24 09:42:32.315907-06	\N	\N	\N	\N	\N	\N
365	EsNonverb	pie	foot		feet	\N	\N	\N	\N	2018-06-24 09:42:32.316363-06	\N	\N	\N	\N	\N	\N
366	EsNonverb	muslo	thigh		thighs	\N	\N	\N	\N	2018-06-24 09:42:32.316797-06	\N	\N	\N	\N	\N	\N
367	EsNonverb	tobillo	ankle		ankles	\N	\N	\N	\N	2018-06-24 09:42:32.317247-06	\N	\N	\N	\N	\N	\N
368	EsNonverb	codo	elbow		elbows	\N	\N	\N	\N	2018-06-24 09:42:32.317698-06	\N	\N	\N	\N	\N	\N
369	EsNonverb	muñeca	wrist		wrists	\N	\N	\N	\N	2018-06-24 09:42:32.318139-06	\N	\N	\N	\N	\N	\N
370	EsNonverb	cuerpo	body		bodies	\N	\N	\N	\N	2018-06-24 09:42:32.318608-06	\N	\N	\N	\N	\N	\N
371	EsNonverb	diente	tooth		tooths	\N	\N	\N	\N	2018-06-24 09:42:32.319075-06	\N	\N	\N	\N	\N	\N
372	EsNonverb	mano	hand		hands	\N	\N	\N	\N	2018-06-24 09:42:32.319518-06	\N	\N	\N	\N	\N	\N
373	EsNonverb	espalda	back		backs	\N	\N	\N	\N	2018-06-24 09:42:32.31995-06	\N	\N	\N	\N	\N	\N
374	EsNonverb	cadera	hip		hips	\N	\N	\N	\N	2018-06-24 09:42:32.320412-06	\N	\N	\N	\N	\N	\N
375	EsNonverb	mandíbula	jaw		jaws	\N	\N	\N	\N	2018-06-24 09:42:32.320864-06	\N	\N	\N	\N	\N	\N
376	EsNonverb	hombro	shoulder		shoulders	\N	\N	\N	\N	2018-06-24 09:42:32.321315-06	\N	\N	\N	\N	\N	\N
377	EsNonverb	pulgar	thumb		thumbs	\N	\N	\N	\N	2018-06-24 09:42:32.321761-06	\N	\N	\N	\N	\N	\N
378	EsNonverb	lengua	tongue		tongues	\N	\N	\N	\N	2018-06-24 09:42:32.322202-06	\N	\N	\N	\N	\N	\N
379	EsNonverb	garganta	throat		throats	\N	\N	\N	\N	2018-06-24 09:42:32.322985-06	\N	\N	\N	\N	\N	\N
380	EsNonverb	español	Spanish		\N	\N	\N	\N	\N	2018-06-24 09:42:32.323407-06	\N	\N	\N	\N	\N	\N
381	EsNonverb	inglés	English		\N	\N	\N	\N	\N	2018-06-24 09:42:32.323906-06	\N	\N	\N	\N	\N	\N
382	EsNonverb	día	day		days	\N	\N	\N	\N	2018-06-24 09:42:32.324572-06	\N	\N	\N	\N	\N	\N
384	EsNonverb	ingeniero	engineer		engineers	\N	\N	\N	\N	2018-06-24 09:42:32.325593-06	\N	\N	\N	\N	\N	\N
385	EsNonverb	lista	list		lists	\N	\N	\N	\N	2018-06-24 09:42:32.326072-06	\N	\N	\N	\N	\N	\N
386	EsNonverb	oración	sentence		sentences	\N	\N	\N	\N	2018-06-24 09:42:32.326465-06	\N	\N	\N	\N	\N	\N
387	EsNonverb	bueno	good	masc.	good	\N	\N	\N	\N	2018-06-24 09:42:32.326926-06	\N	\N	\N	\N	\N	\N
388	EsNonverb	buena	good	fem.	good	\N	\N	\N	\N	2018-06-24 09:42:32.327412-06	\N	\N	\N	\N	\N	\N
389	EsNonverb	el	the	masc.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.327897-06	\N	\N	\N	\N	\N	\N
390	EsNonverb	la	the	fem.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.32839-06	\N	\N	\N	\N	\N	\N
391	EsNonverb	un	a	masc.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.328869-06	\N	\N	\N	\N	\N	\N
392	EsNonverb	una	a	fem.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.329419-06	\N	\N	\N	\N	\N	\N
393	EsNonverb	mi	my		\N	\N	\N	\N	\N	2018-06-24 09:42:32.329823-06	\N	\N	\N	\N	\N	\N
394	EsNonverb	este	this	masc.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.330276-06	\N	\N	\N	\N	\N	\N
395	EsNonverb	esta	this	fem.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33074-06	\N	\N	\N	\N	\N	\N
396	EsNonverb	cada	every		\N	\N	\N	\N	\N	2018-06-24 09:42:32.331212-06	\N	\N	\N	\N	\N	\N
397	EsNonverb	cómo	how		\N	\N	\N	\N	\N	2018-06-24 09:42:32.331646-06	\N	\N	\N	\N	\N	\N
398	EsNonverb	bien	well		\N	\N	\N	\N	\N	2018-06-24 09:42:32.332094-06	\N	\N	\N	\N	\N	\N
399	EsNonverb	yo	I		\N	\N	\N	\N	\N	2018-06-24 09:42:32.332558-06	\N	\N	\N	\N	\N	\N
400	EsNonverb	tú	you	pronoun	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33304-06	\N	\N	\N	\N	\N	\N
401	EsNonverb	él	he		\N	\N	\N	\N	\N	2018-06-24 09:42:32.33464-06	\N	\N	\N	\N	\N	\N
402	EsNonverb	ella	she		\N	\N	\N	\N	\N	2018-06-24 09:42:32.335082-06	\N	\N	\N	\N	\N	\N
403	EsNonverb	nosotros	we	masc.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.335483-06	\N	\N	\N	\N	\N	\N
404	EsNonverb	nosotras	we	fem.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.335885-06	\N	\N	\N	\N	\N	\N
405	EsNonverb	ellos	they	masc.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.33628-06	\N	\N	\N	\N	\N	\N
406	EsNonverb	ellas	they	fem.	\N	\N	\N	\N	\N	2018-06-24 09:42:32.336675-06	\N	\N	\N	\N	\N	\N
407	EsNonverb	qué	what		\N	\N	\N	\N	\N	2018-06-24 09:42:32.337066-06	\N	\N	\N	\N	\N	\N
408	EsNonverb	hola	hello		\N	\N	\N	\N	\N	2018-06-24 09:42:32.337468-06	\N	\N	\N	\N	\N	\N
409	EsNonverb	de	of		\N	\N	\N	\N	\N	2018-06-24 09:42:32.337867-06	\N	\N	\N	\N	\N	\N
410	EsNonverb	dónde	where	question	\N	\N	\N	\N	\N	2018-06-24 09:42:32.338256-06	\N	\N	\N	\N	\N	\N
411	EsNonverb	donde	where	relative	\N	\N	\N	\N	\N	2018-06-24 09:42:32.338645-06	\N	\N	\N	\N	\N	\N
412	EsNonverb	software	software		\N	\N	\N	\N	\N	2018-06-24 09:42:32.339084-06	\N	\N	\N	\N	\N	\N
413	EsNonverb	con	with		\N	\N	\N	\N	\N	2018-06-24 09:42:32.339496-06	\N	\N	\N	\N	\N	\N
414	EsNonverb	quién	who		\N	\N	\N	\N	\N	2018-06-24 09:42:32.339963-06	\N	\N	\N	\N	\N	\N
416	EsNonverb	te	you	direct/indirect object	\N	\N	\N	\N	\N	2018-06-24 09:42:32.340855-06	\N	\N	\N	\N	\N	\N
417	EsNonverb	Longmont	Longmont		\N	\N	\N	\N	\N	2018-06-24 10:12:57.81832-06	\N	\N	\N	\N	\N	\N
418	EsNonverb	Cuba	Cuba		\N	\N	\N	\N	\N	2018-06-24 10:14:14.159249-06	\N	\N	\N	\N	\N	\N
420	EsNonverb	por	for	on behalf of	\N	\N	\N	\N	\N	2018-06-24 10:18:21.748271-06	\N	\N	\N	\N	\N	\N
421	EsNonverb	para	for	in order to	\N	\N	\N	\N	\N	2018-06-24 10:18:37.720114-06	\N	\N	\N	\N	\N	\N
422	EsNonverb	clase	class		classes	\N	\N	\N	\N	2018-06-24 10:18:54.790579-06	\N	\N	\N	\N	\N	\N
423	EsNonverb	enero	January		\N	\N	\N	\N	\N	2018-06-24 10:19:36.45117-06	\N	\N	\N	\N	\N	\N
424	EsNonverb	aplicación	application		applications	\N	\N	\N	\N	2018-06-24 10:19:47.157449-06	\N	\N	\N	\N	\N	\N
425	EsNonverb	unos	some	masc.	\N	\N	\N	\N	\N	2018-06-24 10:20:00.535063-06	\N	\N	\N	\N	\N	\N
426	EsNonverb	unas	some	fem.	\N	\N	\N	\N	\N	2018-06-24 10:20:07.365061-06	\N	\N	\N	\N	\N	\N
427	EsNonverb	móvil	mobile phone		mobile phones	\N	\N	\N	\N	2018-06-24 10:20:48.975803-06	\N	\N	\N	\N	\N	\N
428	EsNonverb	semana	week		weeks	\N	\N	\N	\N	2018-06-24 10:21:05.140751-06	\N	\N	\N	\N	\N	\N
497	EsNonverb	piel	skin		\N	\N	\N	\N	\N	2018-06-26 20:37:34.949585-06	\N	\N	\N	\N	\N	\N
419	EsNonverb	a	to	toward	\N	\N	\N	\N	\N	2018-06-24 10:16:56.797247-06	\N	\N	\N	\N	\N	\N
415	EsNonverb	me	me	to me	\N	\N	\N	\N	\N	2018-06-24 09:42:32.340438-06	\N	\N	\N	\N	\N	\N
498	EsNonverb	en	in/on		\N	\N	\N	\N	\N	2018-06-27 13:09:57.624981-06	\N	\N	\N	\N	\N	\N
499	EsNonverb	prueba	test		tests	\N	\N	\N	\N	2018-06-27 15:35:58.629886-06	\N	\N	\N	\N	\N	\N
500	EsNonverb	feliz	happy		\N	\N	\N	\N	\N	2018-06-27 16:00:33.653382-06	\N	\N	\N	\N	\N	\N
501	EsNonverb	solo	alone		\N	\N	\N	\N	\N	2018-06-27 16:01:16.754582-06	\N	\N	\N	\N	\N	\N
502	EsNonverb	triste	sad		\N	\N	\N	\N	\N	2018-06-27 16:02:01.449627-06	\N	\N	\N	\N	\N	\N
503	EsNonverb	ya	yet		\N	\N	\N	\N	\N	2018-06-27 16:04:47.506244-06	\N	\N	\N	\N	\N	\N
505	EsNonverb	casa	house		houses	\N	\N	\N	\N	2018-06-27 16:06:23.119046-06	\N	\N	\N	\N	\N	\N
506	EsNonverb	almuerzo	lunch		lunches	\N	\N	\N	\N	2018-06-27 16:10:03.657745-06	\N	\N	\N	\N	\N	\N
507	EsNonverb	hoy	today		\N	\N	\N	\N	\N	2018-06-27 16:10:22.676819-06	\N	\N	\N	\N	\N	\N
508	EsNonverb	demasiado	too much		\N	\N	\N	\N	\N	2018-06-27 16:11:43.342318-06	\N	\N	\N	\N	\N	\N
511	EsNonverb	porqué	why		\N	\N	\N	\N	\N	2018-06-27 16:14:22.939146-06	\N	\N	\N	\N	\N	\N
512	EsNonverb	Pennsylvania	Pennsylvania		\N	\N	\N	\N	\N	2018-06-27 16:15:45.409633-06	\N	\N	\N	\N	\N	\N
514	EsNonverb	aquí	here		\N	\N	\N	\N	\N	2018-06-27 16:17:37.925483-06	\N	\N	\N	\N	\N	\N
515	EsNonverb	lo	him		\N	\N	\N	\N	\N	2018-06-27 16:21:02.916295-06	\N	\N	\N	\N	\N	\N
516	EsNonverb	esa	that	fem.	\N	\N	\N	\N	\N	2018-06-27 16:34:31.058747-06	\N	\N	\N	\N	\N	\N
517	EsNonverb	cuenta	account		accounts	\N	\N	\N	\N	2018-06-27 16:34:39.097297-06	\N	\N	\N	\N	\N	\N
518	EsNonverb	no	not		\N	\N	\N	\N	\N	2018-06-27 16:35:32.851134-06	\N	\N	\N	\N	\N	\N
519	EsNonverb	juego	game		games	\N	\N	\N	\N	2018-06-27 16:36:31.585454-06	\N	\N	\N	\N	\N	\N
520	EsNonverb	que	that		\N	\N	\N	\N	\N	2018-06-27 16:36:37.387123-06	\N	\N	\N	\N	\N	\N
521	EsNonverb	perfil	profile		profiles	\N	\N	\N	\N	2018-06-27 16:38:19.183428-06	\N	\N	\N	\N	\N	\N
522	EsNonverb	tres	three		\N	\N	\N	\N	\N	2018-06-27 16:41:20.489311-06	\N	\N	\N	\N	\N	\N
523	EsNonverb	vez	time	occasion	times	\N	\N	\N	\N	2018-06-27 16:42:00.67647-06	\N	\N	\N	\N	\N	\N
524	EsNonverb	programa	program		programs	\N	\N	\N	\N	2018-07-17 08:24:58.585589-06	\N	\N	\N	\N	\N	\N
525	EsNonverb	proyecto	project		projects	\N	\N	\N	\N	2018-07-17 08:26:04.045616-06	\N	\N	\N	\N	\N	\N
528	EsNonverb	memoria	memory		memories	\N	\N	\N	\N	2018-07-17 08:29:22.454611-06	\N	\N	\N	\N	\N	\N
529	EsNonverb	tarjeta	card		cards	\N	\N	\N	\N	2018-07-17 08:29:33.244463-06	\N	\N	\N	\N	\N	\N
530	EsNonverb	diferente	different		\N	\N	\N	\N	\N	2018-07-17 08:30:09.528205-06	\N	\N	\N	\N	\N	\N
531	EsNonverb	las	the	fem. pl.	\N	\N	\N	\N	\N	2018-07-17 08:32:06.026733-06	\N	\N	\N	\N	\N	\N
532	EsNonverb	los	the	masc. pl.	\N	\N	\N	\N	\N	2018-07-17 08:32:19.32709-06	\N	\N	\N	\N	\N	\N
534	EsNonverb	otra	other	fem.	others	\N	\N	\N	\N	2018-07-17 08:33:31.661991-06	\N	\N	\N	\N	\N	\N
533	EsNonverb	otro	other	masc.	others	\N	\N	\N	\N	2018-07-17 08:32:38.307387-06	\N	\N	\N	\N	\N	\N
535	EsNonverb	persona	person		persons	\N	\N	\N	\N	2018-07-17 08:35:10.365693-06	\N	\N	\N	\N	\N	\N
536	EsNonverb	aprendizaje	learning		learnings	\N	\N	\N	\N	2018-07-17 08:40:55.205649-06	\N	\N	\N	\N	\N	\N
542	EsNonverb	mucho	many		many	\N	\N	\N	\N	2018-07-17 08:48:32.554069-06	\N	\N	\N	\N	\N	\N
543	EsNonverb	idioma	language		languages	\N	\N	\N	\N	2018-07-17 08:49:33.488019-06	\N	\N	\N	\N	\N	\N
546	EsNonverb	ejemplo	example		examples	\N	\N	\N	\N	2018-07-17 08:51:50.906959-06	\N	\N	\N	\N	\N	\N
548	EsNonverb	se	itself		\N	\N	\N	\N	\N	2018-07-17 08:54:04.413751-06	\N	\N	\N	\N	\N	\N
550	EsNonverb	palabra	word		words	\N	\N	\N	\N	2018-07-17 08:54:42.693204-06	\N	\N	\N	\N	\N	\N
551	EsNonverb	cuál	which		\N	\N	\N	\N	\N	2018-07-17 08:55:57.61761-06	\N	\N	\N	\N	\N	\N
552	EsNonverb	contexto	context		contexts	\N	\N	\N	\N	2018-07-17 08:56:04.870809-06	\N	\N	\N	\N	\N	\N
555	EsNonverb	perdón	pardon		pardons	\N	\N	\N	\N	2018-08-31 19:08:04.939549-06	\N	\N	\N	\N	\N	\N
557	EsNonverb	usted	you	formal	you all	\N	\N	\N	\N	2018-08-31 19:10:16.458494-06	\N	\N	\N	\N	\N	\N
559	EsNonverb	sí	yes		\N	\N	\N	\N	\N	2018-08-31 19:12:58.323924-06	\N	\N	\N	\N	\N	\N
561	EsNonverb	muy	very		\N	\N	\N	\N	\N	2018-08-31 19:14:08.859179-06	\N	\N	\N	\N	\N	\N
562	EsNonverb	gracias	thanks		\N	\N	\N	\N	\N	2018-08-31 19:15:21.864223-06	\N	\N	\N	\N	\N	\N
563	EsNonverb	adiós	bye		\N	\N	\N	\N	\N	2018-08-31 19:16:02.683832-06	\N	\N	\N	\N	\N	\N
564	EsNonverb	señorita	miss		\N	\N	\N	\N	\N	2018-08-31 19:16:19.062648-06	\N	\N	\N	\N	\N	\N
560	EsNonverb	poco	little bit		\N	\N	\N	\N	\N	2018-08-31 19:13:10.526737-06	\N	\N	\N	\N	\N	\N
565	EsNonverb	castellano	Castilian		Castilians	\N	\N	\N	\N	2018-09-01 16:35:55.371716-06	\N	\N	\N	\N	\N	\N
558	EsNonverb	norteamericano	American	masc.	Americans	\N	\N	\N	\N	2018-08-31 19:11:52.624789-06	\N	\N	\N	\N	\N	\N
566	EsNonverb	norteamericana	American	fem.	Americans	\N	\N	\N	\N	2018-09-01 16:49:51.953022-06	\N	\N	\N	\N	\N	\N
567	EsNonverb	Chicago	Chicago		\N	\N	\N	\N	\N	2018-09-01 17:09:14.52525-06	\N	\N	\N	\N	\N	\N
568	EsNonverb	señor	gentleman		gentlemen	\N	\N	\N	\N	2018-09-01 17:12:59.624633-06	\N	\N	\N	\N	\N	\N
556	EsNonverb	señora	lady, ma'am, Mrs.		\N	\N	\N	\N	\N	2018-08-31 19:09:02.783478-06	\N	\N	\N	\N	\N	\N
569	EsNonverb	noche	night		nights	\N	\N	\N	\N	2018-09-01 17:18:56.997228-06	\N	\N	\N	\N	\N	\N
570	EsNonverb	México	Mexico		Mexicos	\N	\N	\N	\N	2018-09-01 17:20:15.384115-06	\N	\N	\N	\N	\N	\N
571	EsNonverb	Norteamérica	America		Americas	\N	\N	\N	\N	2018-09-01 17:20:47.315399-06	\N	\N	\N	\N	\N	\N
572	EsNonverb	Bolivia	Bolivia		Bolivias	\N	\N	\N	\N	2018-09-01 17:21:09.264117-06	\N	\N	\N	\N	\N	\N
573	EsNonverb	García	Garcia		Garcias	\N	\N	\N	\N	2018-09-01 17:21:42.800262-06	\N	\N	\N	\N	\N	\N
574	EsNonverb	Jones	Jones		\N	\N	\N	\N	\N	2018-09-01 17:22:05.963736-06	\N	\N	\N	\N	\N	\N
575	EsNonverb	angel	angel		angels	\N	\N	\N	\N	2018-09-01 17:24:16.356883-06	\N	\N	\N	\N	\N	\N
429	EsStemChange	pued-	can		\N	could	\N	\N	PRES	2018-06-24 11:26:43.651439-06	333	\N	\N	\N	\N	\N
430	EsStemChange	tien-	have		\N	had	\N	\N	PRES	2018-06-24 11:26:43.803834-06	343	\N	\N	\N	\N	\N
431	EsStemChange	quier-	want		\N	wanted	\N	\N	PRES	2018-06-24 11:26:43.804733-06	336	\N	\N	\N	\N	\N
432	EsStemChange	sig-	follow		\N	followed	\N	\N	PRES	2018-06-24 11:26:43.805456-06	340	\N	\N	\N	\N	\N
433	EsStemChange	encuentr-	find		\N	found	\N	\N	PRES	2018-06-24 11:26:43.806086-06	323	\N	\N	\N	\N	\N
434	EsStemChange	vien-	come		\N	came	\N	\N	PRES	2018-06-24 11:26:43.806698-06	346	\N	\N	\N	\N	\N
435	EsStemChange	piens-	think		\N	thought	\N	\N	PRES	2018-06-24 11:26:43.807283-06	332	\N	\N	\N	\N	\N
436	EsStemChange	vuelv-	return		\N	returned	\N	\N	PRES	2018-06-24 11:26:43.807795-06	348	\N	\N	\N	\N	\N
437	EsStemChange	sient-	feel		\N	felt	\N	\N	PRES	2018-06-24 11:26:43.808329-06	341	\N	\N	\N	\N	\N
438	EsStemChange	cuent-	tell		\N	told	\N	\N	PRES	2018-06-24 11:26:43.808861-06	319	\N	\N	\N	\N	\N
439	EsStemChange	empiez-	start		\N	started	\N	\N	PRES	2018-06-24 11:26:43.809358-06	322	\N	\N	\N	\N	\N
440	EsStemChange	dic-	say		\N	said	\N	\N	PRES	2018-06-24 11:26:43.809844-06	321	\N	\N	\N	\N	\N
441	EsStemChange	recuerd-	remember		\N	remembered	\N	\N	PRES	2018-06-24 11:26:43.810424-06	337	\N	\N	\N	\N	\N
442	EsStemChange	pid-	request		\N	requested	\N	\N	PRES	2018-06-24 11:26:43.81091-06	331	\N	\N	\N	\N	\N
443	EsStemChange	entiend-	understand		\N	understood	\N	\N	PRES	2018-06-24 11:26:43.811642-06	324	\N	\N	\N	\N	\N
444	EsStemChange	anduv-	walk		\N	walked	\N	\N	PRET	2018-06-24 11:26:43.812328-06	315	\N	\N	\N	\N	\N
445	EsStemChange	sup-	know		\N	knew	\N	\N	PRET	2018-06-24 11:26:43.812976-06	338	\N	\N	\N	\N	\N
446	EsStemChange	quis-	want		\N	wanted	\N	\N	PRET	2018-06-24 11:26:43.81373-06	336	\N	\N	\N	\N	\N
447	EsStemChange	pus-	put		\N	put	\N	\N	PRET	2018-06-24 11:26:43.814224-06	334	\N	\N	\N	\N	\N
448	EsStemChange	vin-	come		\N	came	\N	\N	PRET	2018-06-24 11:26:43.814936-06	346	\N	\N	\N	\N	\N
449	EsStemChange	dij-	say		\N	said	\N	\N	PRET	2018-06-24 11:26:43.815792-06	321	\N	\N	\N	\N	\N
450	EsStemChange	tuv-	have		\N	had	\N	\N	PRET	2018-06-24 11:26:43.816356-06	343	\N	\N	\N	\N	\N
451	EsStemChange	hic-	do		\N	did	\N	\N	PRET	2018-06-24 11:26:43.816942-06	328	\N	\N	\N	\N	\N
452	EsStemChange	pud-	can		\N	could	\N	\N	PRET	2018-06-24 11:26:43.817449-06	333	\N	\N	\N	\N	\N
467	EsUniqV	tengo	have		\N	\N	1	1	PRES	2018-06-24 10:53:11.341841-06	343	\N	\N	\N	\N	\N
468	EsUniqV	hago	do		\N	\N	1	1	PRES	2018-06-24 10:53:11.342385-06	328	\N	\N	\N	\N	\N
469	EsUniqV	digo	say		\N	\N	1	1	PRES	2018-06-24 10:53:11.34283-06	321	\N	\N	\N	\N	\N
470	EsUniqV	dijeron	said		\N	\N	2	3	PRET	2018-06-24 10:53:11.343357-06	321	\N	\N	\N	\N	\N
471	EsUniqV	voy	go		\N	\N	1	1	PRES	2018-06-24 10:53:11.343851-06	329	\N	\N	\N	\N	\N
472	EsUniqV	vas	go		\N	\N	1	2	PRES	2018-06-24 10:53:11.344385-06	329	\N	\N	\N	\N	\N
473	EsUniqV	va	goes		\N	\N	1	3	PRES	2018-06-24 10:53:11.34485-06	329	\N	\N	\N	\N	\N
474	EsUniqV	vamos	go		\N	\N	2	1	PRES	2018-06-24 10:53:11.345309-06	329	\N	\N	\N	\N	\N
475	EsUniqV	van	go		\N	\N	2	3	PRES	2018-06-24 10:53:11.345931-06	329	\N	\N	\N	\N	\N
476	EsUniqV	veo	see		\N	\N	1	1	PRES	2018-06-24 10:53:11.346443-06	345	\N	\N	\N	\N	\N
477	EsUniqV	vi	saw		\N	\N	1	1	PRET	2018-06-24 10:53:11.346938-06	345	\N	\N	\N	\N	\N
478	EsUniqV	vio	saw		\N	\N	1	3	PRET	2018-06-24 10:53:11.347455-06	345	\N	\N	\N	\N	\N
479	EsUniqV	vimos	saw		\N	\N	2	1	PRET	2018-06-24 10:53:11.347861-06	345	\N	\N	\N	\N	\N
480	EsUniqV	doy	give		\N	\N	1	1	PRES	2018-06-24 10:53:11.348332-06	320	\N	\N	\N	\N	\N
481	EsUniqV	di	gave		\N	\N	1	1	PRET	2018-06-24 10:53:11.348782-06	320	\N	\N	\N	\N	\N
482	EsUniqV	diste	gave		\N	\N	1	2	PRET	2018-06-24 10:53:11.349211-06	320	\N	\N	\N	\N	\N
483	EsUniqV	dio	gave		\N	\N	1	3	PRET	2018-06-24 10:53:11.349614-06	320	\N	\N	\N	\N	\N
484	EsUniqV	dimos	gave		\N	\N	2	1	PRET	2018-06-24 10:53:11.349999-06	320	\N	\N	\N	\N	\N
485	EsUniqV	dieron	gave		\N	\N	2	3	PRET	2018-06-24 10:53:11.350387-06	320	\N	\N	\N	\N	\N
486	EsUniqV	sé	know		\N	\N	1	1	PRES	2018-06-24 10:53:11.350775-06	338	\N	\N	\N	\N	\N
487	EsUniqV	pongo	put		\N	\N	1	1	PRES	2018-06-24 10:53:11.351199-06	334	\N	\N	\N	\N	\N
488	EsUniqV	vengo	come		\N	\N	1	1	PRES	2018-06-24 10:53:11.351597-06	346	\N	\N	\N	\N	\N
489	EsUniqV	salgo	go out		\N	\N	1	1	PRES	2018-06-24 10:53:11.351985-06	339	\N	\N	\N	\N	\N
490	EsUniqV	parezco	look like		\N	\N	1	1	PRES	2018-06-24 10:53:11.352406-06	330	\N	\N	\N	\N	\N
491	EsUniqV	conozco	know		\N	\N	1	1	PRES	2018-06-24 10:53:11.352811-06	318	\N	\N	\N	\N	\N
492	EsUniqV	empecé	started		\N	\N	1	1	PRET	2018-06-24 10:53:11.353348-06	322	\N	\N	\N	\N	\N
493	EsUniqV	envío	sent		\N	\N	1	1	PRES	2018-06-24 10:53:11.354736-06	325	\N	\N	\N	\N	\N
494	EsUniqV	envías	sent		\N	\N	1	2	PRES	2018-06-24 10:53:11.355389-06	325	\N	\N	\N	\N	\N
495	EsUniqV	envía	sent		\N	\N	1	3	PRES	2018-06-24 10:53:11.355845-06	325	\N	\N	\N	\N	\N
496	EsUniqV	envían	sent		\N	\N	2	1	PRES	2018-06-24 10:53:11.356343-06	325	\N	\N	\N	\N	\N
453	EsUniqV	soy	am	what	\N	\N	1	1	PRES	2018-06-24 10:53:11.331513-06	342	\N	\N	\N	\N	\N
454	EsUniqV	eres	are	what	\N	\N	1	2	PRES	2018-06-24 10:53:11.334102-06	342	\N	\N	\N	\N	\N
455	EsUniqV	es	is	what	\N	\N	1	3	PRES	2018-06-24 10:53:11.334799-06	342	\N	\N	\N	\N	\N
456	EsUniqV	somos	are	what	\N	\N	2	1	PRES	2018-06-24 10:53:11.335596-06	342	\N	\N	\N	\N	\N
457	EsUniqV	son	are	what	\N	\N	2	3	PRES	2018-06-24 10:53:11.336235-06	342	\N	\N	\N	\N	\N
458	EsUniqV	fui	was	what	\N	\N	1	1	PRET	2018-06-24 10:53:11.336833-06	342	\N	\N	\N	\N	\N
459	EsUniqV	fuiste	were	what	\N	\N	1	2	PRET	2018-06-24 10:53:11.337566-06	342	\N	\N	\N	\N	\N
460	EsUniqV	fue	was	what	\N	\N	1	3	PRET	2018-06-24 10:53:11.338114-06	342	\N	\N	\N	\N	\N
461	EsUniqV	fuimos	were	what	\N	\N	2	1	PRET	2018-06-24 10:53:11.338658-06	342	\N	\N	\N	\N	\N
462	EsUniqV	fueron	were	what	\N	\N	2	3	PRET	2018-06-24 10:53:11.339177-06	342	\N	\N	\N	\N	\N
463	EsUniqV	estoy	am	how	\N	\N	1	1	PRES	2018-06-24 10:53:11.339723-06	326	\N	\N	\N	\N	\N
464	EsUniqV	estás	are	how	\N	\N	1	2	PRES	2018-06-24 10:53:11.340233-06	326	\N	\N	\N	\N	\N
465	EsUniqV	está	is	how	\N	\N	1	3	PRES	2018-06-24 10:53:11.340796-06	326	\N	\N	\N	\N	\N
466	EsUniqV	están	are	how	\N	\N	2	3	PRES	2018-06-24 10:53:11.341339-06	326	\N	\N	\N	\N	\N
539	EsUniqV	hay	is	exists	\N	\N	1	3	PRES	2018-07-17 08:45:19.386968-06	538	\N	\N	\N	\N	\N
582	FrInf	\N	be	\N	\N	was	\N	\N	\N	2018-09-02 16:18:34.96525-06	\N	être	\N	\N	\N	\N
583	FrUniqV	\N	am	\N	\N	\N	1	1	PRES	2018-09-02 16:18:57.751959-06	582	suis	\N	\N	\N	\N
584	FrUniqV	\N	are	\N	\N	\N	1	2	PRES	2018-09-02 16:19:23.37562-06	582	es	\N	\N	\N	\N
585	FrUniqV	\N	is	\N	\N	\N	1	3	PRES	2018-09-02 16:19:36.769782-06	582	est	\N	\N	\N	\N
586	FrUniqV	\N	are	\N	\N	\N	2	1	PRES	2018-09-02 16:20:04.263868-06	582	sommes	\N	\N	\N	\N
587	FrUniqV	\N	are	\N	\N	\N	2	2	PRES	2018-09-02 16:20:16.369155-06	582	êtes	\N	\N	\N	\N
588	FrUniqV	\N	are	\N	\N	\N	2	3	PRES	2018-09-02 16:20:32.375836-06	582	sont	\N	\N	\N	\N
589	FrNonverb	\N	I/me	\N	\N	\N	\N	\N	\N	2018-09-02 16:46:53.784662-06	\N	je	\N	\N	\N	\N
590	FrNonverb	\N	you	\N	\N	\N	\N	\N	\N	2018-09-02 16:48:08.846709-06	\N	tu	\N	\N	\N	\N
591	FrNonverb	\N	he	\N	\N	\N	\N	\N	\N	2018-09-02 16:48:38.39048-06	\N	il	\N	\N	\N	\N
592	FrNonverb	\N	she	\N	\N	\N	\N	\N	\N	2018-09-02 16:48:59.888882-06	\N	elle	\N	\N	\N	\N
593	FrNonverb	\N	we	\N	\N	\N	\N	\N	\N	2018-09-02 16:49:20.063779-06	\N	nous	\N	\N	\N	\N
594	FrNonverb	\N	you all	\N	\N	\N	\N	\N	\N	2018-09-02 16:49:52.683555-06	\N	vous	\N	\N	\N	\N
595	FrNonverb	\N	they (masc.)	\N	\N	\N	\N	\N	\N	2018-09-02 16:50:59.541744-06	\N	ils	\N	\N	\N	\N
596	FrNonverb	\N	they (fem.)	\N	\N	\N	\N	\N	\N	2018-09-02 16:51:13.343919-06	\N	elles	\N	\N	\N	\N
597	FrInf	\N	go	\N	\N	went	\N	\N	\N	2018-09-02 16:51:54.849762-06	\N	aller	\N	\N	\N	\N
598	FrUniqV	\N	go	\N	\N	\N	1	1	PRES	2018-09-02 16:52:10.070708-06	597	vais	\N	\N	\N	\N
599	FrUniqV	\N	go	\N	\N	\N	1	2	PRES	2018-09-02 16:52:24.04008-06	597	vas	\N	\N	\N	\N
600	FrUniqV	\N	goes	\N	\N	\N	1	3	PRES	2018-09-02 16:53:00.013994-06	597	va	\N	\N	\N	\N
601	FrUniqV	\N	go	\N	\N	\N	2	1	PRES	2018-09-02 16:53:22.421248-06	597	allons	\N	\N	\N	\N
602	FrUniqV	\N	go	\N	\N	\N	2	2	PRES	2018-09-02 16:53:32.464416-06	597	allez	\N	\N	\N	\N
603	FrUniqV	\N	go	\N	\N	\N	2	3	PRES	2018-09-02 16:53:42.408866-06	597	vont	\N	\N	\N	\N
604	FrNonverb	\N	how	\N	\N	\N	\N	\N	\N	2018-09-02 16:54:37.497641-06	\N	comment	\N	\N	\N	\N
605	FrNonverb	\N	it	\N	\N	\N	\N	\N	\N	2018-09-02 16:54:37.500128-06	\N	ça	\N	\N	\N	\N
606	FrNonverb	\N	very	\N	\N	\N	\N	\N	\N	2018-09-02 16:55:18.434126-06	\N	très	\N	\N	\N	\N
607	FrNonverb	\N	well	\N	\N	\N	\N	\N	\N	2018-09-02 16:55:18.441939-06	\N	bien	\N	\N	\N	\N
608	FrNonverb	\N	thanks	\N	\N	\N	\N	\N	\N	2018-09-02 16:55:18.4482-06	\N	merci	\N	\N	\N	\N
609	FrNonverb	\N	and	\N	\N	\N	\N	\N	\N	2018-09-02 16:55:45.691008-06	\N	et	\N	\N	\N	\N
610	FrInf	\N	speak	\N	\N	spoke	\N	\N	\N	2018-09-02 17:17:28.346519-06	\N	parler	\N	\N	\N	\N
611	FrInf	\N	call	\N	\N	called	\N	\N	\N	2018-09-03 01:26:22.431007-06	\N	appeler	\N	\N	\N	\N
613	FrStemChange	\N	call	\N	\N	called	\N	\N	PRES	2018-09-03 01:31:58.545072-06	611	appell-	\N	\N	\N	\N
614	FrNonverb	\N	me	\N	\N	\N	\N	\N	\N	2018-09-03 09:03:17.7684-06	\N	me	\N	\N	\N	\N
615	FrNonverb	\N	Pat	\N	\N	\N	\N	\N	\N	2018-09-03 09:03:17.81668-06	\N	Pat	\N	\N	\N	\N
616	FrNonverb	\N	me	\N	\N	\N	\N	\N	\N	2018-09-03 09:06:47.13204-06	\N	m'	\N	\N	\N	\N
617	FrNonverb	\N	enchanted	\N	\N	\N	\N	\N	\N	2018-09-03 10:13:44.461449-06	\N	enchanté	\N	\N	\N	\N
618	FrInf	\N	come	\N	\N	came	\N	\N	\N	2018-09-03 10:15:07.839627-06	\N	venir	\N	\N	\N	\N
619	FrStemChange	\N	come	\N	\N	came	\N	\N	PRES	2018-09-03 10:15:30.875707-06	618	vien-	\N	\N	\N	\N
620	FrNonverb	\N	from	\N	\N	\N	\N	\N	\N	2018-09-03 10:38:12.118663-06	\N	d'	\N	\N	\N	\N
621	FrNonverb	\N	where	\N	\N	\N	\N	\N	\N	2018-09-03 10:38:12.144859-06	\N	où	\N	\N	\N	\N
623	FrNonverb	\N	from	\N	\N	\N	\N	\N	\N	2018-09-03 10:42:20.240474-06	\N	de	\N	\N	\N	\N
624	FrNonverb	\N	France	\N	\N	\N	\N	\N	\N	2018-09-03 10:42:20.25281-06	\N	France	\N	\N	\N	\N
625	FrNonverb	\N	French	\N	\N	\N	\N	\N	\N	2018-09-03 10:42:42.683836-06	\N	français	\N	\N	\N	\N
626	FrNonverb	\N	from	\N	\N	\N	\N	\N	\N	2018-09-03 10:44:02.877696-06	\N	des	\N	\N	\N	\N
627	FrNonverb	\N	states	\N	\N	\N	\N	\N	\N	2018-09-03 10:44:02.884474-06	\N	états	\N	\N	\N	\N
628	FrNonverb	\N	united	\N	\N	\N	\N	\N	\N	2018-09-03 10:44:02.886831-06	\N	unis	\N	\N	\N	\N
629	FrNonverb	\N	American	\N	\N	\N	\N	\N	\N	2018-09-03 10:44:28.940238-06	\N	américain	\N	\N	\N	\N
630	FrNonverb	\N	exactly	\N	\N	\N	\N	\N	\N	2018-09-03 10:44:59.567957-06	\N	exactement	\N	\N	\N	\N
631	FrNonverb	\N	Boston	\N	\N	\N	\N	\N	\N	2018-09-03 10:45:39.660305-06	\N	Boston	\N	\N	\N	\N
632	FrNonverb	\N	student	\N	\N	\N	\N	\N	\N	2018-09-03 10:46:05.007854-06	\N	étudiant	\N	\N	\N	\N
633	FrNonverb	\N	professor	\N	\N	\N	\N	\N	\N	2018-09-03 10:47:02.821171-06	\N	professeur	\N	\N	\N	\N
634	FrNonverb	\N	English	\N	\N	\N	\N	\N	\N	2018-09-03 10:47:02.828475-06	\N	anglais	\N	\N	\N	\N
635	FrNonverb	\N	yes	\N	\N	\N	\N	\N	\N	2018-09-03 10:47:45.258482-06	\N	oui	\N	\N	\N	\N
636	FrNonverb	\N	a	\N	\N	\N	\N	\N	\N	2018-09-03 10:48:55.30511-06	\N	un	\N	\N	\N	\N
637	FrNonverb	\N	little	\N	\N	\N	\N	\N	\N	2018-09-03 10:48:55.308051-06	\N	petit	\N	\N	\N	\N
638	FrNonverb	\N	bit	\N	\N	\N	\N	\N	\N	2018-09-03 10:48:55.310823-06	\N	peu	\N	\N	\N	\N
639	FrNonverb	\N	home	\N	\N	\N	\N	\N	\N	2018-09-03 10:50:14.122687-06	\N	chez	\N	\N	\N	\N
640	FrNonverb	\N	my	\N	\N	\N	\N	\N	\N	2018-09-03 10:50:14.124387-06	\N	moi	\N	\N	\N	\N
641	FrNonverb	\N	now	\N	\N	\N	\N	\N	\N	2018-09-03 10:50:14.125663-06	\N	maintenant	\N	\N	\N	\N
642	FrNonverb	\N	also	\N	\N	\N	\N	\N	\N	2018-09-03 10:50:39.872063-06	\N	aussi	\N	\N	\N	\N
643	FrNonverb	\N	to the	\N	\N	\N	\N	\N	\N	2018-09-03 10:52:25.886468-06	\N	Au	\N	\N	\N	\N
644	FrNonverb	\N	seeing again	\N	\N	\N	\N	\N	\N	2018-09-03 10:52:25.89043-06	\N	revoir	\N	\N	\N	\N
645	FrNonverb	\N	good	\N	\N	\N	\N	\N	\N	2018-09-03 10:53:12.935056-06	\N	bonne	\N	\N	\N	\N
646	FrNonverb	\N	day	\N	\N	\N	\N	\N	\N	2018-09-03 10:53:12.93673-06	\N	journée	\N	\N	\N	\N
653	ArNonverb	\N	you drink	\N	\N	\N	\N	\N	\N	2018-09-05 20:47:47.900079-06	\N	\N	ta$rab	\N	\N	\N
648	ArNonverb	\N	Ramadan	\N	\N	\N	\N	\N	\N	2018-09-05 19:56:46.940322-06	\N	\N	ramaDAn	\N	\N	\N
650	ArNonverb	\N	thirsty	\N	\N	\N	\N	\N	\N	2018-09-05 20:06:25.526182-06	\N	\N	EaTo$An	\N	\N	\N
655	ArNonverb	\N	God	\N	\N	\N	\N	\N	\N	2018-09-05 21:02:40.168287-06	\N	\N	{ll~`h	\N	\N	\N
656	ArNonverb	\N	goodbye	\N	\N	\N	\N	\N	\N	2018-09-05 21:48:53.079363-06	\N	\N	maEa {ls~alAamap	\N	\N	\N
657	ArNonverb	\N	Afghanistan	\N	\N	\N	\N	\N	\N	2018-09-05 22:12:06.113727-06	\N	\N	>afogaAnisotaAn	\N	\N	\N
658	ArNonverb	\N	Kabul	\N	\N	\N	\N	\N	\N	2018-09-05 22:15:53.692597-06	\N	\N	kaAbuwl	\N	\N	\N
659	ArNonverb	\N	Bahrain	\N	\N	\N	\N	\N	\N	2018-09-05 22:16:45.136059-06	\N	\N	AlobaHorayon	\N	\N	\N
660	ArNonverb	\N	Bhutan	\N	\N	\N	\N	\N	\N	2018-09-05 22:17:29.612904-06	\N	\N	buwtaAn	\N	\N	\N
661	ArNonverb	\N	Canada	\N	\N	\N	\N	\N	\N	2018-09-05 22:18:21.383591-06	\N	\N	kanadaA	\N	\N	\N
662	ArNonverb	\N	Chad	\N	\N	\N	\N	\N	\N	2018-09-05 22:18:59.374424-06	\N	\N	to$aAd	\N	\N	\N
663	ArNonverb	\N	Djibouti	\N	\N	\N	\N	\N	\N	2018-09-05 22:19:46.475391-06	\N	\N	jiybuwtiy	\N	\N	\N
664	ArNonverb	\N	France	\N	\N	\N	\N	\N	\N	2018-09-05 22:20:49.750387-06	\N	\N	faranosaA	\N	\N	\N
665	ArNonverb	\N	Paris	\N	\N	\N	\N	\N	\N	2018-09-05 22:21:15.531061-06	\N	\N	baAriys	\N	\N	\N
666	ArNonverb	\N	Tehran	\N	\N	\N	\N	\N	\N	2018-09-05 22:22:05.82156-06	\N	\N	TahoraAn	\N	\N	\N
667	ArNonverb	\N	Iran	\N	\N	\N	\N	\N	\N	2018-09-05 22:22:28.033201-06	\N	\N	<iyraAn	\N	\N	\N
668	ArNonverb	\N	Iraq	\N	\N	\N	\N	\N	\N	2018-09-05 22:22:57.182804-06	\N	\N	AloEiraAq	\N	\N	\N
669	ArNonverb	\N	Bagdad	\N	\N	\N	\N	\N	\N	2018-09-05 22:23:16.163002-06	\N	\N	bagodaAd	\N	\N	\N
670	ArNonverb	\N	Israel	\N	\N	\N	\N	\N	\N	2018-09-05 22:23:41.305808-06	\N	\N	<isoraA}iyl	\N	\N	\N
673	ArNonverb	\N	Tel Aviv	\N	\N	\N	\N	\N	\N	2018-09-05 22:26:07.214289-06	\N	\N	tal~ >abiyb	\N	\N	\N
674	ArNonverb	\N	Italy	\N	\N	\N	\N	\N	\N	2018-09-05 22:26:26.299435-06	\N	\N	<iyTaAliyaA	\N	\N	\N
675	ArNonverb	\N	Rome	\N	\N	\N	\N	\N	\N	2018-09-05 22:26:44.288779-06	\N	\N	ruwmaA	\N	\N	\N
676	ArNonverb	\N	Kazakhstan	\N	\N	\N	\N	\N	\N	2018-09-05 22:27:16.644943-06	\N	\N	kaAzaAxisotaAn	\N	\N	\N
677	ArNonverb	\N	Kenya	\N	\N	\N	\N	\N	\N	2018-09-05 22:27:45.115008-06	\N	\N	kiyniyaA	\N	\N	\N
678	ArNonverb	\N	Kuwait	\N	\N	\N	\N	\N	\N	2018-09-05 22:28:25.839436-06	\N	\N	Alokuwayot	\N	\N	\N
679	ArNonverb	\N	Kyrgyzstan	\N	\N	\N	\N	\N	\N	2018-09-05 22:28:50.873644-06	\N	\N	qiyrogiyzisotaAn	\N	\N	\N
680	ArNonverb	\N	Lebanon	\N	\N	\N	\N	\N	\N	2018-09-05 22:29:12.752997-06	\N	\N	libonAn	\N	\N	\N
681	ArNonverb	\N	Beirut	\N	\N	\N	\N	\N	\N	2018-09-05 22:29:31.995497-06	\N	\N	bayoruwt	\N	\N	\N
682	ArNonverb	\N	Libya	\N	\N	\N	\N	\N	\N	2018-09-05 22:29:54.155753-06	\N	\N	liybiyaA	\N	\N	\N
683	ArNonverb	\N	Malawi	\N	\N	\N	\N	\N	\N	2018-09-05 22:30:27.905264-06	\N	\N	maAlaAwiy	\N	\N	\N
684	ArNonverb	\N	Malaysia	\N	\N	\N	\N	\N	\N	2018-09-05 22:30:51.754102-06	\N	\N	maAlayoziyaA	\N	\N	\N
685	ArNonverb	\N	Ali	\N	\N	\N	\N	\N	\N	2018-09-05 23:03:09.294198-06	\N	\N	EAly	\N	\N	\N
686	ArNonverb	\N	Amir	\N	\N	\N	\N	\N	\N	2018-09-05 23:03:31.51387-06	\N	\N	EAmr	\N	\N	\N
687	ArNonverb	\N	Adam	\N	\N	\N	\N	\N	\N	2018-09-05 23:04:30.824261-06	\N	\N	|dm	\N	\N	\N
688	ArNonverb	\N	Barack	\N	\N	\N	\N	\N	\N	2018-09-05 23:05:39.427498-06	\N	\N	bArAk	\N	\N	\N
689	ArNonverb	\N	Hussein	\N	\N	\N	\N	\N	\N	2018-09-05 23:07:31.256917-06	\N	\N	Hsyn	\N	\N	\N
690	ArNonverb	\N	imam	\N	\N	\N	\N	\N	\N	2018-09-05 23:08:04.692543-06	\N	\N	<mAm	\N	\N	\N
691	ArNonverb	\N	Islam	\N	\N	\N	\N	\N	\N	2018-09-05 23:08:21.156435-06	\N	\N	<slAm	\N	\N	\N
692	ArNonverb	\N	Jamal	\N	\N	\N	\N	\N	\N	2018-09-05 23:08:45.45169-06	\N	\N	jmAl	\N	\N	\N
694	ArNonverb	\N	Muhammad	\N	\N	\N	\N	\N	\N	2018-09-05 23:10:02.221466-06	\N	\N	mHm~d	\N	\N	\N
695	ArNonverb	\N	Omar	\N	\N	\N	\N	\N	\N	2018-09-05 23:10:35.791887-06	\N	\N	Emr	\N	\N	\N
696	ArNonverb	\N	Saddam	\N	\N	\N	\N	\N	\N	2018-09-05 23:11:15.077444-06	\N	\N	Sd~Am	\N	\N	\N
697	ArNonverb	\N	Shakira	\N	\N	\N	\N	\N	\N	2018-09-05 23:11:42.464971-06	\N	\N	$Akrp	\N	\N	\N
698	ArNonverb	\N	ayatollah	\N	\N	\N	\N	\N	\N	2018-09-05 23:14:39.804042-06	\N	\N	|yap Allh	\N	\N	\N
699	ArNonverb	\N	caliphate	\N	\N	\N	\N	\N	\N	2018-09-05 23:15:28.90548-06	\N	\N	xalyfp	\N	\N	\N
700	ArNonverb	\N	fatwa	\N	\N	\N	\N	\N	\N	2018-09-05 23:15:57.530548-06	\N	\N	ftwY	\N	\N	\N
701	ArNonverb	\N	hadith	\N	\N	\N	\N	\N	\N	2018-09-05 23:16:14.43252-06	\N	\N	Hdyv	\N	\N	\N
702	ArNonverb	\N	Hajj	\N	\N	\N	\N	\N	\N	2018-09-05 23:16:38.176596-06	\N	\N	Haj~	\N	\N	\N
703	ArNonverb	\N	jihad	\N	\N	\N	\N	\N	\N	2018-09-05 23:17:02.051567-06	\N	\N	jhAd	\N	\N	\N
704	ArNonverb	\N	Quran	\N	\N	\N	\N	\N	\N	2018-09-05 23:17:27.428895-06	\N	\N	Alqr|n	\N	\N	\N
705	ArNonverb	\N	Sharia	\N	\N	\N	\N	\N	\N	2018-09-05 23:18:17.046085-06	\N	\N	$ryEp	\N	\N	\N
706	ArNonverb	\N	Shia	\N	\N	\N	\N	\N	\N	2018-09-05 23:18:45.925244-06	\N	\N	$yEp	\N	\N	\N
707	ArNonverb	\N	Sufi	\N	\N	\N	\N	\N	\N	2018-09-05 23:19:18.7801-06	\N	\N	Suwfiy~	\N	\N	\N
709	ArNonverb	\N	shah	\N	\N	\N	\N	\N	\N	2018-09-05 23:21:30.051582-06	\N	\N	$Ah	\N	\N	\N
710	ArNonverb	\N	God is great	\N	\N	\N	\N	\N	\N	2018-09-05 23:23:42.109949-06	\N	\N	Allh >kbr	\N	\N	\N
711	ArNonverb	\N	halal	\N	\N	\N	\N	\N	\N	2018-09-05 23:24:56.921142-06	\N	\N	HlAl	\N	\N	\N
712	ArNonverb	\N	if God wills	\N	\N	\N	\N	\N	\N	2018-09-05 23:25:41.976384-06	\N	\N	<n $A' Allh	\N	\N	\N
713	ArNonverb	\N	madrasah	\N	\N	\N	\N	\N	\N	2018-09-05 23:26:31.651612-06	\N	\N	mdrsp	\N	\N	\N
714	ArNonverb	\N	Sunni	\N	\N	\N	\N	\N	\N	2018-09-05 23:28:58.477545-06	\N	\N	sn~y	\N	\N	\N
715	ArNonverb	\N	burqa	\N	\N	\N	\N	\N	\N	2018-09-05 23:30:16.091452-06	\N	\N	brqE	\N	\N	\N
716	ArNonverb	\N	hijab	\N	\N	\N	\N	\N	\N	2018-09-05 23:30:47.489298-06	\N	\N	HjAb	\N	\N	\N
717	ArNonverb	\N	couscous	\N	\N	\N	\N	\N	\N	2018-09-05 23:32:32.150726-06	\N	\N	kusokus	\N	\N	\N
718	ArNonverb	\N	Al Jazeera	\N	\N	\N	\N	\N	\N	2018-09-05 23:34:57.952292-06	\N	\N	Aljzyrp	\N	\N	\N
719	ArNonverb	\N	Barack Hussein Obama	\N	\N	\N	\N	\N	\N	2018-09-05 23:37:38.638441-06	\N	\N	bArAk Hsyn >wbAmA	\N	\N	\N
720	ArNonverb	\N	Kareem Abdul-Jabbar	\N	\N	\N	\N	\N	\N	2018-09-05 23:38:24.147108-06	\N	\N	krym Ebd AljbAr	\N	\N	\N
721	ArNonverb	\N	Hamid Karzai	\N	\N	\N	\N	\N	\N	2018-09-05 23:40:21.46567-06	\N	\N	HAmd krzAy	\N	\N	\N
722	ArNonverb	\N	Muhammad Ali	\N	\N	\N	\N	\N	\N	2018-09-05 23:40:54.272101-06	\N	\N	mHmd Ely	\N	\N	\N
723	ArNonverb	\N	Rihanna	\N	\N	\N	\N	\N	\N	2018-09-05 23:41:31.925495-06	\N	\N	ryhAnA	\N	\N	\N
724	ArNonverb	\N	Shaquille O’Neal	\N	\N	\N	\N	\N	\N	2018-09-05 23:42:07.107402-06	\N	\N	$Akyl Awnyl	\N	\N	\N
725	ArNonverb	\N	Tupac Shakur	\N	\N	\N	\N	\N	\N	2018-09-05 23:42:38.620662-06	\N	\N	twbAk $Akwr	\N	\N	\N
726	ArNonverb	\N	Saddam Hussein	\N	\N	\N	\N	\N	\N	2018-09-05 23:44:09.882005-06	\N	\N	SdAm Hsyn	\N	\N	\N
727	ArNonverb	\N	Mahmoud Ahmadinejad	\N	\N	\N	\N	\N	\N	2018-09-05 23:44:41.363239-06	\N	\N	mHmwd AHmdynjAd	\N	\N	\N
728	ArNonverb	\N	Mahmoud Abbas	\N	\N	\N	\N	\N	\N	2018-09-05 23:45:04.596028-06	\N	\N	maHomuwd Eaba~As	\N	\N	\N
729	ArVRoot	\N	write	\N	\N	wrote	\N	\N	\N	2018-09-07 10:26:56.175701-06	\N	\N	ktb	u	\N	\N
730	ArVRoot	\N	drink	\N	\N	drank	\N	\N	\N	2018-09-07 10:27:14.594876-06	\N	\N	$rib	a	\N	\N
742	ArVRoot	\N	sit	\N	\N	sat	\N	\N	\N	2018-09-07 14:10:54.230746-06	\N	\N	jlis	i	\N	\N
731	ArNonverb	\N	I	\N	\N	\N	\N	\N	\N	2018-09-07 13:58:35.672884-06	\N	\N	>nA	\N	\N	\N
732	ArNonverb	\N	you (masc.)	\N	\N	\N	\N	\N	\N	2018-09-07 13:58:47.781191-06	\N	\N	>anota	\N	\N	\N
733	ArNonverb	\N	you (fem.)	\N	\N	\N	\N	\N	\N	2018-09-07 13:59:01.383694-06	\N	\N	>anoti	\N	\N	\N
734	ArNonverb	\N	he	\N	\N	\N	\N	\N	\N	2018-09-07 13:59:11.711905-06	\N	\N	huwa	\N	\N	\N
735	ArNonverb	\N	she	\N	\N	\N	\N	\N	\N	2018-09-07 13:59:25.599617-06	\N	\N	hiya	\N	\N	\N
736	ArNonverb	\N	we	\N	\N	\N	\N	\N	\N	2018-09-07 13:59:37.256893-06	\N	\N	naHonu	\N	\N	\N
737	ArNonverb	\N	you (masc. pl.)	\N	\N	\N	\N	\N	\N	2018-09-07 13:59:55.977431-06	\N	\N	>anotumo	\N	\N	\N
738	ArNonverb	\N	you (fem. pl.)	\N	\N	\N	\N	\N	\N	2018-09-07 14:00:12.407077-06	\N	\N	>anotun~a	\N	\N	\N
739	ArNonverb	\N	they (masc.)	\N	\N	\N	\N	\N	\N	2018-09-07 14:00:24.815863-06	\N	\N	humo	\N	\N	\N
740	ArNonverb	\N	they (fem.)	\N	\N	\N	\N	\N	\N	2018-09-07 14:00:41.266117-06	\N	\N	hun~a	\N	\N	\N
743	ArVRoot	\N	arrive	\N	\N	arrived	\N	\N	\N	2018-09-07 16:07:23.468821-06	\N	\N	wSl	i	\N	\N
745	ArVRoot	\N	find	\N	\N	found	\N	\N	\N	2018-09-07 16:13:17.918298-06	\N	\N	wjd	i	\N	\N
746	ArVRoot	\N	put	\N	\N	put	\N	\N	\N	2018-09-07 16:14:35.095171-06	\N	\N	wDE	a	\N	\N
749	ArVRoot	\N	is	\N	\N	was	\N	\N	\N	2018-09-07 16:39:17.431475-06	\N	\N	kwn	o	\N	\N
744	ArStemChange	\N	arrive	\N	\N	\N	\N	\N	PRES	2018-09-07 16:11:15.058908-06	743	\N	Sil-	\N	1,2,3	\N
747	ArStemChange	\N	find	\N	\N	\N	\N	\N	PRES	2018-09-07 16:17:02.152475-06	745	\N	jid-	\N	1,2,3	\N
748	ArStemChange	\N	put	\N	\N	\N	\N	\N	PRES	2018-09-07 16:19:28.65242-06	746	\N	DaE-	\N	1,2,3	\N
750	ArStemChange	\N	was	\N	\N	\N	\N	\N	PAST	2018-09-07 16:56:36.745251-06	749	\N	kaAn-	\N	3	\N
751	ArVRoot	\N	visit	\N	\N	visited	\N	\N	\N	2018-09-07 16:57:48.308585-06	\N	\N	zwr	?	\N	\N
752	ArStemChange	\N	visited	\N	\N	\N	\N	\N	PAST	2018-09-07 16:59:03.631104-06	751	\N	zaAr-	\N	3	\N
753	ArVRoot	\N	sell	\N	\N	sold	\N	\N	\N	2018-09-07 16:59:53.253586-06	\N	\N	byE	?	\N	\N
755	ArVRoot	\N	fly	\N	\N	flew	\N	\N	\N	2018-09-07 17:01:58.684766-06	\N	\N	Tyr	?	\N	\N
757	ArStemChange	\N	was	\N	\N	\N	\N	\N	PAST	2018-09-07 17:03:47.015038-06	749	\N	kun-	\N	1,2	\N
758	ArStemChange	\N	visited	\N	\N	\N	\N	\N	PAST	2018-09-07 17:04:24.868021-06	751	\N	zur-	\N	1,2	\N
759	ArStemChange	\N	sold	\N	\N	\N	\N	\N	PAST	2018-09-07 17:05:04.304094-06	753	\N	biE-	\N	1,2	\N
760	ArStemChange	\N	flew	\N	\N	\N	\N	\N	PAST	2018-09-07 17:06:09.633942-06	755	\N	Tir-	\N	1,2	\N
754	ArStemChange	\N	sold	\N	\N	\N	\N	\N	PAST	2018-09-07 17:01:22.332139-06	753	\N	baAE-	\N	3	\N
756	ArStemChange	\N	flew	\N	\N	\N	\N	\N	PAST	2018-09-07 17:02:49.332723-06	755	\N	TaAra-	\N	3	\N
762	ArStemChange	\N	sell	\N	\N	\N	\N	\N	PRES	2018-09-07 17:12:20.13693-06	753	\N	biyE-	\N	1,2,3	\N
761	ArStemChange	\N	visit	\N	\N	\N	\N	\N	PRES	2018-09-07 17:10:56.985087-06	751	\N	zuwr-	\N	1,2,3	\N
763	ArVRoot	\N	sleep	\N	\N	slept	\N	\N	\N	2018-09-07 17:14:14.825214-06	\N	\N	ynAm	?	\N	\N
764	ArStemChange	\N	sleep	\N	\N	\N	\N	\N	PRES	2018-09-07 17:15:07.828448-06	763	\N	naAm-	\N	1,2,3	\N
765	ArStemChange	\N	fly	\N	\N	\N	\N	\N	PRES	2018-09-07 17:19:25.685692-06	755	\N	Tiyr-	\N	1,2,3	\N
766	ArVRoot	\N	complain	\N	\N	complained	\N	\N	\N	2018-09-07 17:22:08.182334-06	\N	\N	$kw	?	\N	\N
768	ArVRoot	\N	walk	\N	\N	walked	\N	\N	\N	2018-09-07 17:25:24.568517-06	\N	\N	m$y	?	\N	\N
770	ArVRoot	\N	forget	\N	\N	forgot	\N	\N	\N	2018-09-07 17:33:12.042642-06	\N	\N	nsiy	?	\N	\N
771	ArVRoot	\N	meet	\N	\N	met	\N	\N	\N	2018-09-07 17:33:52.838919-06	\N	\N	lqiy	?	\N	\N
769	ArStemChange	\N	walked	\N	\N	\N	\N	\N	PAST	2018-09-07 17:26:01.372287-06	768	\N	ma$-	\N	3	\N
767	ArStemChange	\N	complained	\N	\N	\N	\N	\N	PAST	2018-09-07 17:24:47.196191-06	766	\N	$ak-	\N	3	\N
772	ArUniqV	\N	complained	\N	\N	\N	1	3	PAST	2018-09-07 18:18:40.855669-06	766	\N	$akaA	\N	\N	M
773	ArVRoot	\N	say	\N	\N	said	\N	\N	\N	2018-09-07 18:31:27.111684-06	\N	\N	qwl	?	\N	\N
774	ArStemChange	\N	said	\N	\N	\N	\N	\N	PRES	2018-09-07 18:32:14.877264-06	773	\N	quwl-	\N	1,2,3	\N
775	ArNonverb	\N	how	\N	\N	\N	\N	\N	\N	2018-09-07 18:33:21.462052-06	\N	\N	kayofa	\N	\N	\N
777	ArVRoot	\N	mean	\N	\N	meant	\N	\N	\N	2018-09-07 18:39:16.32222-06	\N	\N	Eny	i	\N	\N
778	ArNonverb	\N	what	\N	\N	\N	\N	\N	\N	2018-09-07 18:42:49.1375-06	\N	\N	maA*aA	\N	\N	\N
779	ArVRoot	\N	rank high	\N	\N	ranked high	\N	\N	\N	2018-09-07 19:01:14.801916-06	\N	\N	$rf	?	\N	\N
780	ArNoun	\N	name	\N	\N	\N	\N	\N	\N	2018-09-07 19:58:27.601448-06	\N	\N	Aisom	\N	\N	M
781	ArNoun	\N	book	\N	\N	\N	\N	\N	\N	2018-09-07 19:59:37.977729-06	\N	\N	kitaAb	\N	\N	M
782	ArNoun	\N	sugar	\N	\N	\N	\N	\N	\N	2018-09-07 20:00:51.328353-06	\N	\N	suka~r	\N	\N	M
783	ArNoun	\N	baker	\N	\N	\N	\N	\N	\N	2018-09-07 20:01:25.395921-06	\N	\N	xaba~Az	\N	\N	M
784	ArNonverb	\N	what	\N	\N	\N	\N	\N	\N	2018-09-07 21:07:10.840683-06	\N	\N	maA	\N	\N	\N
785	ArNonverb	\N	Daniel	\N	\N	\N	\N	\N	\N	2018-09-07 21:09:15.563016-06	\N	\N	daAniyaAl	\N	\N	\N
786	ArVRoot	\N	know	\N	\N	knew	\N	\N	\N	2018-09-07 21:38:26.97205-06	\N	\N	Erf	i	\N	\N
787	ArNonverb	\N	no	\N	\N	\N	\N	\N	\N	2018-09-07 21:47:31.25279-06	\N	\N	laA	\N	\N	\N
788	ArNonverb	\N	from	\N	\N	\N	\N	\N	\N	2018-09-07 21:51:18.205031-06	\N	\N	mino	\N	\N	\N
789	ArNonverb	\N	where	\N	\N	\N	\N	\N	\N	2018-09-07 21:51:18.218558-06	\N	\N	>ayona	\N	\N	\N
790	ArNonverb	\N	yes	\N	\N	\N	\N	\N	\N	2018-09-07 21:53:30.255282-06	\N	\N	naEamo	\N	\N	\N
791	ArNoun	\N	condition	\N	\N	\N	\N	\N	\N	2018-09-07 22:01:13.371085-06	\N	\N	HaAl	\N	\N	M
792	ArNoun	\N	news	\N	\N	\N	\N	\N	\N	2018-09-07 22:03:13.955925-06	\N	\N	>axobaAr	\N	\N	M
793	ArNoun	\N	praise	\N	\N	\N	\N	\N	\N	2018-09-07 22:09:28.115164-06	\N	\N	Hamod	\N	\N	M
794	ArNoun	\N	goodness	\N	\N	\N	\N	\N	\N	2018-09-07 22:12:05.852325-06	\N	\N	xayor	\N	\N	M
795	ArNonverb	\N	thanks	\N	\N	\N	\N	\N	\N	2018-09-07 22:14:28.36809-06	\N	\N	$ukorFA	\N	\N	\N
796	ArNonverb	\N	excuse me	\N	\N	\N	\N	\N	\N	2018-09-07 22:18:34.348136-06	\N	\N	EafowFA	\N	\N	\N
797	ArVRoot	\N	study	\N	\N	studied	\N	\N	\N	2018-09-07 22:24:24.072574-06	\N	\N	drs	u	\N	\N
798	ArVRoot	\N	live	\N	\N	lived	\N	\N	\N	2018-09-07 22:27:31.134482-06	\N	\N	skn	u	\N	\N
799	ArVRoot	\N	work	\N	\N	worked	\N	\N	\N	2018-09-07 22:28:30.467462-06	\N	\N	Eml	a	\N	\N
\.


--
-- Name: leafs_leaf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('leafs_leaf_id_seq', 799, true);


--
-- Data for Name: morphemes; Type: TABLE DATA; Schema: public; Owner: dan
--

COPY morphemes (id, lang, type, l2, gloss, created_at, atoms_json) FROM stdin;
172	ar		hAdhaa	this	2018-09-26 10:23:28.216358-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"A","buckwalter":"`","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"dh","buckwalter":"*","ipa":"ð","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
193	ar		-ii	I	2018-09-26 10:48:58.251656-06	[{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
203	ar		al-	the	2018-09-26 10:54:51.646176-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
208	ar		eld-	the	2018-09-26 11:01:29.382034-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"do","ipa":"d","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
235	ar		-aN	ACCUS-INDEF	2018-09-26 11:38:51.717572-06	[{"atom":"a","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"N","buckwalter":"F","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
244	ar		uN	INDEF-NOM	2018-09-26 11:48:39.386092-06	[{"atom":"u","buckwalter":"","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"N","buckwalter":"N","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
246	ar		el-	the	2018-09-26 11:50:51.525087-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
248	ar		-aan	ACCUS-INDEF	2018-09-26 11:50:51.542664-06	[{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
260	ar		-iyyah	(nisba adjective)	2018-09-26 12:01:18.69413-06	[{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
263	ar		-el	the	2018-09-26 12:06:52.81604-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
284	ar		faDl	favor	2018-09-27 14:24:12.32239-06	[{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"D","buckwalter":"Do","ipa":"dˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
62	ar		-u	he	2018-09-17 23:36:12.789814-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
162	ar		-hum	their	2018-09-26 10:08:52.417507-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
195	ar		-i	GEN	2018-09-26 10:48:58.267019-06	[{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
197	ar		Saff	class	2018-09-26 10:49:30.887368-06	[{"atom":"S","buckwalter":"S","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
10	ar	V	katab-	wrote	2018-09-17 23:11:16.001554-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
14	ar	CONJ	-ti	you-FEM	2018-09-17 23:12:11.217232-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
40	ar		ta-	you all MASC	2018-09-17 23:29:45.207678-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
43	ar		ta-	you all FEM	2018-09-17 23:30:16.677856-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
48	ar		-na	you all FEM	2018-09-17 23:32:24.798245-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
67	ar		-mash-	walked	2018-09-17 23:38:25.734858-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"sh","buckwalter":"$o","ipa":"ʃ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
71	ar		na-	we	2018-09-17 23:40:42.366339-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
73	ar		-u	we	2018-09-17 23:40:42.36977-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
88	ar		-.	.	2018-09-17 23:44:13.210791-06	[{"atom":".","buckwalter":".","ipa":"","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
109	ar		wa-	and	2018-09-17 23:54:37.066462-06	[{"atom":"w","buckwalter":"w","ipa":"w","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
117	ar			to	2018-09-17 23:55:56.933165-06	[]
128	ar		xayr	good	2018-09-17 23:59:33.963492-06	[{"atom":"x","buckwalter":"x","ipa":"x","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
216	ar		-uN	NOM-INDEF	2018-09-26 11:12:09.227639-06	[{"atom":"u","buckwalter":"","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"N","buckwalter":"N","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
6	ar	CONJ	na-	I	2018-09-17 23:10:00.527942-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
9	ar	PRO	'anta	you-MASC	2018-09-17 23:11:15.982298-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
79	ar		-u	it	2018-09-17 23:41:58.162436-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
103	ar		calay	be unto	2018-09-17 23:51:51.343993-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
26	ar		hum	they MASC	2018-09-17 23:27:17.519086-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
29	ar		-na	they FEM	2018-09-17 23:27:37.926213-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
33	ar		-u	I	2018-09-17 23:28:03.278278-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
36	ar		-u	you MASC	2018-09-17 23:28:31.418736-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
57	ar		Sil	arrive	2018-09-17 23:34:09.163504-06	[{"atom":"S","buckwalter":"S","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɘ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
82	ar		-u	NOM	2018-09-17 23:42:40.438254-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
84	ar		-ki	your FEM	2018-09-17 23:42:57.09164-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
86	ar		-ii	my	2018-09-17 23:44:13.208021-06	[{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
93	ar		laa	no	2018-09-17 23:45:33.474591-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
114	ar		ta-	we-PAST	2018-09-17 23:55:34.43416-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
126	ar		saalii	the name Sali	2018-09-17 23:58:26.063264-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
148	ar		fii	in	2018-09-18 00:18:21.257662-06	[{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
229	ar		-uN	INDEF-NOM	2018-09-26 11:33:51.735958-06	[{"atom":"u","buckwalter":"","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"N","buckwalter":"N","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
233	ar		-a	ACCUS	2018-09-26 11:36:38.282395-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
285	ar		shukran	thanks	2018-09-27 14:26:49.852516-06	[{"atom":"sh","buckwalter":"$","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
8	ar	CONJ	-u	I	2018-09-17 23:10:00.544327-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
17	ar		-a	he	2018-09-17 23:23:30.444173-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
51	ar		ya-	they FEM	2018-09-17 23:33:09.859495-06	[{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
19	ar		-at	she	2018-09-17 23:23:46.359604-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"t","buckwalter":"to","ipa":"t","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
21	ar		-naa	we	2018-09-17 23:24:03.297399-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
23	ar		-tum	you all MASC	2018-09-17 23:26:13.806677-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
25	ar		-tunna	you all FEM	2018-09-17 23:26:49.61013-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
27	ar		-uuaa	they MASC	2018-09-17 23:27:17.527958-06	[{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
28	ar		hunna	they FEM	2018-09-17 23:27:37.917288-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
31	ar		'a-	I	2018-09-17 23:28:03.262814-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
141	ar		'antumaa	you two	2018-09-18 00:15:37.116688-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
20	ar		naHnu	we	2018-09-17 23:24:03.288058-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"H","buckwalter":"Ho","ipa":"ħ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
22	ar		'antum	you all MASC	2018-09-17 23:26:13.793235-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
30	ar		'anaa	I	2018-09-17 23:28:03.254905-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
37	ar		-anti	you FEM	2018-09-17 23:28:59.571763-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
38	ar		ta-	you FEM	2018-09-17 23:28:59.579737-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
39	ar		-na	you FEM	2018-09-17 23:28:59.589652-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
41	ar		-uuna	you all MASC	2018-09-17 23:29:45.209985-06	[{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
42	ar		'anti	you all FEM	2018-09-17 23:30:16.670474-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
44	ar		iina	you all FEM	2018-09-17 23:30:16.685607-06	[{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
45	ar		ya-	he	2018-09-17 23:30:38.128904-06	[{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
46	ar		-ktub-	writes	2018-09-17 23:30:38.135872-06	[{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
47	ar		-iina	he	2018-09-17 23:30:38.143999-06	[{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
49	ar		ya-	they MASC	2018-09-17 23:32:48.798003-06	[{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
50	ar		-uuna	they MASC	2018-09-17 23:32:48.80605-06	[{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
52	ar		-ktub-	wite	2018-09-17 23:33:09.866892-06	[{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
53	ar		-uuna	they FEM	2018-09-17 23:33:09.874763-06	[{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
286	ar		'amal	work	2018-09-27 14:37:58.732812-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
35	ar		ta-	you MASC	2018-09-17 23:28:31.410046-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
59	ar		-tu	I	2018-09-17 23:35:40.653401-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
60	ar		Tir-	flew	2018-09-17 23:35:56.243139-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɘ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
61	ar		-zuur-	visits	2018-09-17 23:36:12.782366-06	[{"atom":"z","buckwalter":"z","ipa":"z","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
63	ar		-biic-	sell	2018-09-17 23:37:15.760093-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"Eo","ipa":"ʕ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
64	ar		naam	sleep	2018-09-17 23:37:33.847041-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
65	ar		Tiir-	fly	2018-09-17 23:37:52.291929-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
66	ar		shak-	complained	2018-09-17 23:38:10.735161-06	[{"atom":"sh","buckwalter":"$","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
69	ar		shakaa	complained	2018-09-17 23:39:11.804714-06	[{"atom":"sh","buckwalter":"$","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
70	ar		kayfa	how	2018-09-17 23:40:42.362136-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
72	ar		quul	say	2018-09-17 23:40:42.368233-06	[{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
150	ar		cinda	had	2018-09-26 09:58:30.386549-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
56	ar		-iina	you FEM	2018-09-17 23:33:41.890174-06	[{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
58	ar		zur-	visited	2018-09-17 23:35:40.651633-06	[{"atom":"z","buckwalter":"z","ipa":"z","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
77	ar		ya-	it	2018-09-17 23:41:58.157352-06	[{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
81	ar		'ism	name	2018-09-17 23:42:40.436591-06	[{"atom":"\\u0027","buckwalter":"\\u003c","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
85	ar		maa	what	2018-09-17 23:43:23.675787-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
89	ar		laa	not	2018-09-17 23:44:44.089972-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
91	ar		nacam	yes	2018-09-17 23:45:19.422335-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
92	ar		-!	!	2018-09-17 23:45:19.548181-06	[{"atom":"!","buckwalter":"!","ipa":"","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
165	ar		-naa	our	2018-09-26 10:15:37.631337-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
75	ar		-?	?	2018-09-17 23:40:42.374788-06	[{"atom":"?","buckwalter":"?","ipa":"","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
76	ar		maadhaa	what	2018-09-17 23:41:58.156109-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"dh","buckwalter":"*","ipa":"ð","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
78	ar		-cnii	mean	2018-09-17 23:41:58.160883-06	[{"atom":"c","buckwalter":"Eo","ipa":"ʕ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
80	ar		nacam	yes	2018-09-17 23:41:58.163705-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
83	ar		-ka	your MASC	2018-09-17 23:42:40.439438-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
94	ar		haal	condition	2018-09-17 23:46:13.210217-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
156	ar		-hu	his	2018-09-26 10:01:50.073688-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
90	ar		-crif-	know	2018-09-17 23:44:44.092066-06	[{"atom":"c","buckwalter":"Eo","ipa":"ʕ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
98	ar		-cmal-	work	2018-09-17 23:49:02.916809-06	[{"atom":"c","buckwalter":"Eo","ipa":"ʕ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
104	ar		-kum	you all	2018-09-17 23:51:51.351146-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
105	ar		xurtuum	hose	2018-09-17 23:52:05.68971-06	[{"atom":"x","buckwalter":"x","ipa":"x","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
106	ar		shams	sun	2018-09-17 23:52:14.542132-06	[{"atom":"sh","buckwalter":"$","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
107	ar		ghaa'im	cloudy	2018-09-17 23:52:22.13595-06	[{"atom":"gh","buckwalter":"g","ipa":"ɣ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"\\u0027","buckwalter":"}","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
288	ar		'afham	understand-1-PRES-SING-jussive	2018-09-27 14:44:41.873633-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
97	ar		-skun-	live	2018-09-17 23:48:43.130929-06	[{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
101	ar		'als-	the	2018-09-17 23:51:51.329235-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
102	ar		salaam	peace	2018-09-17 23:51:51.336278-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
115	ar		sharaf	honor	2018-09-17 23:55:34.441248-06	[{"atom":"sh","buckwalter":"$","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
116	ar		-naa	we-PAST	2018-09-17 23:55:34.44841-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
118	ar		'al-	the	2018-09-17 23:55:56.940894-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
119	ar		liqaa	encounter	2018-09-17 23:55:56.948296-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
120	ar		mac	with	2018-09-17 23:56:37.735472-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"Eo","ipa":"ʕ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
122	ar		nizaar	the name Nizar	2018-09-17 23:57:09.456779-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"z","buckwalter":"z","ipa":"z","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
123	ar		'adiib	the name Adib	2018-09-17 23:57:33.627093-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
290	ar		-u		2018-09-27 14:46:35.966619-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
111	ar		-kum	you all MASC	2018-09-17 23:54:37.080467-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
166	ar		anaa	I	2018-09-26 10:21:23.859332-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
110	ar		calay	unto	2018-09-17 23:54:37.073203-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
112	ar		els-	the	2018-09-17 23:54:37.087638-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
132	ar		li-	belong to	2018-09-18 00:01:33.951231-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
133	ar		llAh	God	2018-09-18 00:01:33.958082-06	[{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"A","buckwalter":"`","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"ho","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
134	ar		bi-	by	2018-09-18 00:01:33.959204-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
136	ar		min	from	2018-09-18 00:13:29.204984-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
138	ar		faas	Fez	2018-09-18 00:13:45.995762-06	[{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
139	ar		tuunis	Tunis	2018-09-18 00:14:01.480427-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
140	ar		'anta	you	2018-09-18 00:14:53.95916-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
129	ar		nuur	light	2018-09-18 00:00:04.312556-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
131	ar		Hamd-	praise	2018-09-18 00:01:33.943025-06	[{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"do","ipa":"d","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
137	ar		'ayna	where	2018-09-18 00:13:29.206767-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
232	ar		Taalib	student-MASC	2018-09-26 11:36:38.276128-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
301	ar		ta-	2-MASC-PRES	2018-09-27 15:06:51.319181-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
304	ar		'arab	Arabic	2018-09-27 15:06:51.348071-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
302	ar		-u	2-MASC-PRES	2018-09-27 15:06:51.328773-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
143	ar		humaa	they both	2018-09-18 00:16:27.943911-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
145	ar		hunna	they FEM	2018-09-18 00:17:11.997933-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
147	ar		baghdaad	Baghdad	2018-09-18 00:17:30.240541-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"gh","buckwalter":"go","ipa":"ɣ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"do","ipa":"d","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
303	ar		kalimah	word	2018-09-27 15:06:51.337023-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
153	ar		-ki	your	2018-09-26 09:59:23.094697-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
154	ar		cinda	near/with	2018-09-26 10:00:29.688052-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
155	ar		kiitaab	book	2018-09-26 10:01:20.624555-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
157	ar		-haa	her	2018-09-26 10:02:13.945601-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
158	ar		-humaa	their	2018-09-26 10:05:27.11258-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
159	ar		saacah	watch	2018-09-26 10:05:27.120471-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
160	ar		-kumaa	you	2018-09-26 10:07:07.161316-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
163	ar		-hunna	their	2018-09-26 10:09:29.753318-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
164	ar		-kum	their	2018-09-26 10:10:12.938397-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
146	ar		dimashq	Damascus	2018-09-18 00:17:11.999675-06	[{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"sh","buckwalter":"$o","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"q","buckwalter":"qo","ipa":"q","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
151	ar		-ka	your	2018-09-26 09:58:30.529513-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
152	ar		haatif	telephone	2018-09-26 09:58:30.533513-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
170	ar		'amriikiyyah	American	2018-09-26 10:22:44.011171-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
171	ar		lubnaaniyyah	Lebanese	2018-09-26 10:23:05.377696-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
173	ar		baab	door	2018-09-26 10:24:00.100659-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
168	ar		miSriyy	Egyptian	2018-09-26 10:22:03.385695-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɘ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"S","buckwalter":"So","ipa":"sˤ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
169	ar		miSriyyah	Egyptian	2018-09-26 10:22:24.799641-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɘ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"S","buckwalter":"So","ipa":"sˤ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
174	ar		lawkH	blackboard	2018-09-26 10:24:18.831875-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"w","buckwalter":"wo","ipa":"w","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"H","buckwalter":"Ho","ipa":"ħ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
178	ar		naafidhah	window	2018-09-26 10:26:14.119373-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"dh","buckwalter":"*","ipa":"ð","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
179	ar		Taawilah	table	2018-09-26 10:26:30.973967-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"w","buckwalter":"w","ipa":"w","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
180	ar		misTarah	ruler	2018-09-26 10:26:44.934528-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɘ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
181	ar		haqiibah	bag	2018-09-26 10:26:57.710302-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
183	ar		Haasibah	calculator	2018-09-26 10:27:26.979703-06	[{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
176	ar		qalam	pen	2018-09-26 10:25:55.396357-06	[{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
177	ar		hAdhihi	this	2018-09-26 10:26:14.111567-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"A","buckwalter":"`","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"dh","buckwalter":"*","ipa":"ð","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
187	ar		bustaanii	Bustani	2018-09-26 10:46:28.267916-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
189	ar		hunaa	here	2018-09-26 10:47:37.854643-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
190	ar		jaamicah	university	2018-09-26 10:47:37.863049-06	[{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
191	ar		halab	Aleppo	2018-09-26 10:47:37.870073-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
192	ar		lakinn	but	2018-09-26 10:48:58.244253-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
194	ar		madiinah	city	2018-09-26 10:48:58.259356-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
186	ar		haalaah	Hala	2018-09-26 10:46:28.259511-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
185	ar		mubra'a	pencil sharpener	2018-09-26 10:27:58.709014-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
199	ar		-uhu	his	2018-09-26 10:50:38.711893-06	[{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
200	ar		ilyaas	Elias	2018-09-26 10:50:38.719453-06	[{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
204	ar		bi-	on	2018-09-26 10:54:51.649135-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
205	ar		janib	side	2018-09-26 10:54:51.650173-06	[{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
5	ar	PRO	'anaa	I	2018-09-17 23:10:00.518506-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
11	ar	CONJ	-ta	you-MASC	2018-09-17 23:11:16.007649-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
18	ar		hiya	she	2018-09-17 23:23:46.352488-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
34	ar		'anta	you MASC	2018-09-17 23:28:31.402493-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
198	ar		'ustaadh	professor	2018-09-26 10:50:04.369936-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"dh","buckwalter":"*o","ipa":"ð","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
220	ar		laakin	but	2018-09-26 11:20:59.354324-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
212	ar		Saff	classroom.	2018-09-26 11:07:05.267089-06	[{"atom":"S","buckwalter":"S","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
213	ar		Taalib	student	2018-09-26 11:08:45.159524-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
214	ar		Saff	classroom	2018-09-26 11:08:45.168152-06	[{"atom":"S","buckwalter":"S","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
215	ar		hunaaka	there	2018-09-26 11:12:09.219216-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
218	ar		laysa	not to be	2018-09-26 11:19:48.284472-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
243	ar		nadiyah	Nadia	2018-09-26 11:48:39.36505-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
209	ar		calae	on	2018-09-26 11:04:59.514277-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ae","buckwalter":"Y","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
210	ar		elT-	the	2018-09-26 11:04:59.521831-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
211	ar		elS-	the	2018-09-26 11:07:05.265972-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"S","buckwalter":"So","ipa":"sˤ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
227	ar		Taalibah	student	2018-09-26 11:33:51.719905-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
228	ar		carabiyyah	Arab	2018-09-26 11:33:51.728505-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
258	ar		'aHruf	consonants	2018-09-26 12:00:57.190932-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"H","buckwalter":"Ho","ipa":"ħ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
293	ar		buT'	slowness	2018-09-27 14:52:40.991507-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"ɔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"T","buckwalter":"To","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"\\u0027","buckwalter":"\\u0027","ipa":"ʔ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
223	ar		-ha	she	2018-09-26 11:22:31.767357-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
55	ar		-jlis-	sit	2018-09-17 23:33:41.883229-06	[{"atom":"j","buckwalter":"jo","ipa":"dʒ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
222	ar		-hu	he	2018-09-26 11:22:14.776992-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
294	ar		hal	(yes or no)	2018-09-27 14:59:27.343984-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
240	ar		laysat	not to be (FEM)	2018-09-26 11:45:19.379621-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"to","ipa":"t","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
266	ar		maca	with	2018-09-27 13:28:47.759988-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
267	ar		es-	the	2018-09-27 13:28:47.788105-06	[{"atom":"e","buckwalter":"{","ipa":"","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
236	ar		'ayDaaN	also	2018-09-26 11:39:37.705762-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"D","buckwalter":"D","ipa":"dˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"N","buckwalter":"F","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
237	ar		jidaar	wall	2018-09-26 11:39:51.726028-06	[{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
238	ar		-iyy	(nisba adjective)	2018-09-26 11:41:27.561527-06	[{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
239	ar		qamar	moon	2018-09-26 11:41:43.442172-06	[{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
245	ar		laysa	not to be (MASC)	2018-09-26 11:50:51.516915-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
296	ar		lughah	language	2018-09-27 14:59:27.361136-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"gh","buckwalter":"g","ipa":"ɣ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
299	ar		-ah	FEM	2018-09-27 14:59:27.374967-06	[{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
249	ar		lubnaaniyy	Lebanese	2018-09-26 11:52:49.011034-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
54	ar		'anta	you FEM	2018-09-17 23:33:41.869636-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
268	ar		'alllah	God	2018-09-27 13:39:01.299619-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
254	ar		miftaah	key	2018-09-26 11:55:14.420864-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
256	ar		naZZaarah	eyeglasses	2018-09-26 11:56:07.728997-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"Z","buckwalter":"Zo","ipa":"zˤ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"Z","buckwalter":"Z","ipa":"zˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
257	ar		walaayah	state/province	2018-09-26 11:57:09.497818-06	[{"atom":"w","buckwalter":"w","ipa":"w","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
269	ar		yusallima	peace-3-M-SING-PRES-active-SUBJ	2018-09-27 13:39:01.323991-06	[{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"u","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
252	ar		Haasuub	computer	2018-09-26 11:53:32.942435-06	[{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
255	ar		nisbah	relative adjective	2018-09-26 11:55:46.948937-06	[{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
12	ar	PRO	'anti	you-FEM	2018-09-17 23:12:11.203261-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
270	ar		-ka	your-MASC	2018-09-27 13:39:01.337401-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
271	ar		-ki	your-FEM	2018-09-27 13:40:23.026247-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
15	ar		huwa	he	2018-09-17 23:23:30.416933-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"w","buckwalter":"w","ipa":"w","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
16	ar		katab-	wrote	2018-09-17 23:23:30.435622-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
24	ar		'atunna	you all FEM	2018-09-17 23:26:49.600276-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
32	ar		-ktub-	write	2018-09-17 23:28:03.270309-06	[{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
261	ar		harf	consonant	2018-09-26 12:01:30.76454-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
262	ar		hamzah	hamza	2018-09-26 12:06:52.806838-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"z","buckwalter":"z","ipa":"z","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
264	ar		waSl	link	2018-09-26 12:06:52.826628-06	[{"atom":"w","buckwalter":"w","ipa":"w","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"S","buckwalter":"So","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
7	ar	V	-ktub-	wrote	2018-09-17 23:10:00.536188-06	[{"atom":"k","buckwalter":"ko","ipa":"k","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
124	ar		halaa	the name Hala	2018-09-17 23:57:47.858791-06	[{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
125	ar		miikaa'iil	Mikhail	2018-09-17 23:58:13.548422-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"\\u0027","buckwalter":"}","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
272	ar		'aln-	the	2018-09-27 13:45:15.538904-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
273	ar		-.		2018-09-27 13:45:15.550928-06	[{"atom":".","buckwalter":".","ipa":"","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
95	ar		'axbaar	news	2018-09-17 23:47:33.750076-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"x","buckwalter":"xo","ipa":"x","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
68	ar		shakaw-	complained	2018-09-17 23:38:57.496828-06	[{"atom":"sh","buckwalter":"$","ipa":"ʃ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"w","buckwalter":"wo","ipa":"w","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
74	ar		kanadaa	Canada	2018-09-17 23:40:42.371071-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
108	ar		'ahlaN	familiarly	2018-09-17 23:53:57.805458-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"ho","ipa":"h","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"N","buckwalter":"F","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
274	ar		Haal	condition	2018-09-27 13:50:22.882948-06	[{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
175	ar		kursiyy	chair	2018-09-26 10:24:38.692594-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
188	ar		TaalibaahN	student	2018-09-26 10:47:37.846699-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"N","buckwalter":"K","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
275	ar		'ahl	family	2018-09-27 14:02:38.90425-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"ho","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
276	ar		-aN	ACC-INDEF	2018-09-27 14:02:38.932288-06	[{"atom":"a","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"N","buckwalter":"F","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
277	ar		sahl	plain	2018-09-27 14:02:38.956138-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"ho","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
167	ar		'amriikiyy	American	2018-09-26 10:21:23.866922-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
184	ar		mimHaah	eraser	2018-09-26 10:27:41.839448-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
278	ar		bi-	with	2018-09-27 14:09:56.270265-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
217	ar		darraajah	bicycle	2018-09-26 11:19:04.96489-06	[{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
221	ar		laakinna	but	2018-09-26 11:22:14.768493-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
225	ar		suuriyyah	Syrian	2018-09-26 11:23:45.502891-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
230	ar		Taalibah	student-FEM	2018-09-26 11:36:38.256806-06	[{"atom":"T","buckwalter":"T","ipa":"tˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
279	ar		Hamd	praise	2018-09-27 14:14:14.303739-06	[{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"do","ipa":"d","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
206	ar		daftar	notebook	2018-09-26 10:54:51.651632-06	[{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
280	ar		-i	ACCUS	2018-09-27 14:14:14.318795-06	[{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":true,"endsWithHyphen":false}]
281	ar		xayr	well	2018-09-27 14:16:19.825636-06	[{"atom":"x","buckwalter":"x","ipa":"x","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
247	ar		lubnaaniyy	Lebanese	2018-09-26 11:50:51.535448-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
250	ar		talfazah	television	2018-09-26 11:53:17.856056-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"z","buckwalter":"z","ipa":"z","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
259	ar		qamaryah	lunar	2018-09-26 12:00:57.198678-06	[{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
282	ar		masaa'	evening	2018-09-27 14:18:56.382006-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"\\u0027","buckwalter":"\\u0027","ipa":"ʔ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
241	ar		'amriikiyyah	American-FEM	2018-09-26 11:45:19.386871-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
283	ar		min	favor	2018-09-27 14:24:12.313057-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
96	ar		-drus-	study	2018-09-17 23:48:26.195959-06	[{"atom":"d","buckwalter":"do","ipa":"d","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"so","ipa":"s","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":true}]
99	ar		marHabaN	welcome	2018-09-17 23:50:52.676767-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"H","buckwalter":"H","ipa":"ħ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"N","buckwalter":"F","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
121	ar		salaamah	peace	2018-09-17 23:56:37.744262-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
127	ar		SabaaH	morning	2018-09-17 23:59:33.955472-06	[{"atom":"S","buckwalter":"S","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"H","buckwalter":"Ho","ipa":"ħ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
142	ar		bayruut	Beirut	2018-09-18 00:15:37.12581-06	[{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"to","ipa":"t","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
149	ar		'almaghrib	Morocco	2018-09-18 00:18:21.259485-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"gh","buckwalter":"go","ipa":"ɣ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
182	ar		Suurah	picture	2018-09-26 10:27:10.920382-06	[{"atom":"S","buckwalter":"S","ipa":"sˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
196	ar		ghurfah	room	2018-09-26 10:49:30.879632-06	[{"atom":"gh","buckwalter":"g","ipa":"ɣ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"ro","ipa":"r","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
207	ar		janibi	side	2018-09-26 11:01:29.375048-06	[{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
219	ar		cinda	has	2018-09-26 11:19:48.291969-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
224	ar		lakinna	but	2018-09-26 11:23:45.494731-06	[{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"no","ipa":"n","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
231	ar		tuunisiyyah	Tunisian	2018-09-26 11:36:38.265714-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
251	ar		jariidah	newspaper	2018-09-26 11:53:25.972578-06	[{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
253	ar		musajjil	tape recorder	2018-09-26 11:54:59.383446-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"j","buckwalter":"jo","ipa":"dʒ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
287	ar		jayyid	good	2018-09-27 14:37:58.73866-06	[{"atom":"j","buckwalter":"j","ipa":"dʒ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"do","ipa":"d","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
289	ar		'afham	understand-1-PRES-INDIC	2018-09-27 14:46:35.960709-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
291	ar		'a'rif	know	2018-09-27 14:49:19.756951-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"\\u0027","buckwalter":"\\u003eo","ipa":"ʔ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
292	ar		takallam	talk	2018-09-27 14:52:40.985711-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
305	ar		'aasif	sorry	2018-09-27 15:11:37.175273-06	[{"atom":"\\u0027","buckwalter":"|","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"fo","ipa":"f","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
306	ar		cafuu	forgiveness	2018-09-27 15:13:43.092899-06	[{"atom":"c","buckwalter":"E","ipa":"ʕ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"f","buckwalter":"f","ipa":"f","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"uu","buckwalter":"w","ipa":"uː","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
87	ar		daaniyaal	Daniel	2018-09-17 23:44:13.209675-06	[{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
144	ar		'alqaahirah	Cairo	2018-09-18 00:16:27.947237-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"","ipa":"ɑ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"h","ipa":"h","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
161	ar		sayyaarah	car	2018-09-26 10:07:42.688567-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
201	ar		dhiyaadah	Ziadeh	2018-09-26 10:50:38.727258-06	[{"atom":"dh","buckwalter":"*","ipa":"ð","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
295	ar		tatakallum	talk	2018-09-27 14:59:27.353777-06	[{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"t","ipa":"t","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"lo","ipa":"l","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"u","buckwalter":"u","ipa":"o","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"m","buckwalter":"mo","ipa":"m","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
297	ar		'arab	Arab	2018-09-27 14:59:27.36801-06	[{"atom":"\\u0027","buckwalter":"\\u003e","ipa":"ʔ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"bo","ipa":"b","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
298	ar		-iyy	(nisba)	2018-09-27 14:59:27.371408-06	[{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":true,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
202	ar		riyaaDiyyaat	math	2018-09-26 10:51:46.560808-06	[{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"D","buckwalter":"D","ipa":"dˤ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɘ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"aa","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"t","buckwalter":"to","ipa":"t","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
226	ar		sayyarah	car	2018-09-26 11:25:26.42365-06	[{"atom":"s","buckwalter":"s","ipa":"s","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
234	ar		maghribiyy	Moroccan	2018-09-26 11:36:38.283995-06	[{"atom":"m","buckwalter":"m","ipa":"m","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"gh","buckwalter":"go","ipa":"ɣ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"r","buckwalter":"r","ipa":"r","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"b","buckwalter":"b","ipa":"b","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
242	ar		kanadiyyah	Canadian-FEM	2018-09-26 11:46:00.020663-06	[{"atom":"k","buckwalter":"k","ipa":"k","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"n","buckwalter":"n","ipa":"n","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"d","buckwalter":"d","ipa":"d","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"i","buckwalter":"i","ipa":"ɪ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"yo","ipa":"j","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"y","buckwalter":"y","ipa":"j","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"h","buckwalter":"p","ipa":"h","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
300	ar		qaliilaN	few/little	2018-09-27 15:00:36.78316-06	[{"atom":"q","buckwalter":"q","ipa":"q","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"a","ipa":"ɑ","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"ii","buckwalter":"y","ipa":"iː","endsSyllable":true,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"l","buckwalter":"l","ipa":"l","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"a","buckwalter":"A","ipa":"æ","endsSyllable":false,"endsMorpheme":false,"beginsWithHyphen":false,"endsWithHyphen":false},{"atom":"N","buckwalter":"F","ipa":"n","endsSyllable":true,"endsMorpheme":true,"beginsWithHyphen":false,"endsWithHyphen":false}]
\.


--
-- Name: morphemes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dan
--

SELECT pg_catalog.setval('morphemes_id_seq', 306, true);


--
-- Data for Name: new_cards; Type: TABLE DATA; Schema: public; Owner: dan
--

COPY new_cards (id, lang, type, en_task, en_content, morpheme_ids_csv, created_at) FROM stdin;
2	ar	PhraseCard		I wrote.	5,6,7,8	2018-09-17 23:10:00.54689-06
3	ar	PhraseCard	Say to a man	You wrote.	9,10,11	2018-09-17 23:11:16.009092-06
4	ar	PhraseCard	Say to a woman	You wrote.	12,10,14	2018-09-17 23:12:11.223863-06
5	ar	PhraseCard	Say:	He wrote.	15,16,17	2018-09-17 23:23:30.452297-06
6	ar	PhraseCard	Say	She wrote.	18,16,19	2018-09-17 23:23:46.369769-06
7	ar	PhraseCard	Say	We wrote.	20,16,21	2018-09-17 23:24:03.309825-06
8	ar	PhraseCard	Say to 3+ persons including a man	You wrote.	22,16,23	2018-09-17 23:26:13.816627-06
9	ar	PhraseCard	Say to 3+ women	You wrote.	24,16,25	2018-09-17 23:26:49.617293-06
10	ar	PhraseCard	Say of 3+ persons including a man	They wrote.	26,16,27	2018-09-17 23:27:17.53513-06
11	ar	PhraseCard	Say of 3+ women	They wrote.	28,16,29	2018-09-17 23:27:37.93301-06
12	ar	PhraseCard	Say	I write	30,31,32,33	2018-09-17 23:28:03.279709-06
13	ar	PhraseCard	Say to a man	You write.	34,35,32,36	2018-09-17 23:28:31.425706-06
14	ar	PhraseCard	Say to a woman	You write	37,38,32,39	2018-09-17 23:28:59.596347-06
15	ar	PhraseCard	Say to 3+ persons including a man	You write.	22,40,32,41	2018-09-17 23:29:45.211073-06
16	ar	PhraseCard	Say to 3+ women	You write.	42,43,32,44	2018-09-17 23:30:16.692335-06
17	ar	PhraseCard	Say	He writes.	15,45,46,47	2018-09-17 23:30:38.150933-06
18	ar	PhraseCard	Say to 3+ persons including a man	You write.	22,40,32,41	2018-09-17 23:31:45.690643-06
19	ar	PhraseCard	Say to 3+ women	You write.	24,43,32,48	2018-09-17 23:32:24.80782-06
20	ar	PhraseCard	Say of 3+ persons including a man	They write.	26,49,32,50	2018-09-17 23:32:48.813131-06
21	ar	PhraseCard	Say of 3+ women	They write.	28,51,52,53	2018-09-17 23:33:09.886637-06
22	ar	PhraseCard	Say to a woman	You sit.	54,38,55,56	2018-09-17 23:33:41.895764-06
23	ar	PhraseCard	Say	I arrive.	30,31,57,33	2018-09-17 23:34:09.170603-06
24	ar	PhraseCard	Say	I visited.	30,58,59	2018-09-17 23:35:40.654171-06
25	ar	PhraseCard	Say	I flew.	30,60,59	2018-09-17 23:35:56.250694-06
26	ar	PhraseCard	Say	He visits.	15,45,61,62	2018-09-17 23:36:12.796645-06
27	ar	PhraseCard	Say of 3+ persons including a man:	They sell.	26,49,63,50	2018-09-17 23:37:15.772566-06
28	ar	PhraseCard	Say	He sleeps.	15,45,64,62	2018-09-17 23:37:33.855113-06
29	ar	PhraseCard	Say	I fly.	30,31,65,33	2018-09-17 23:37:52.299204-06
30	ar	PhraseCard	Say	She complained.	18,66,19	2018-09-17 23:38:10.742412-06
31	ar	PhraseCard	Say	She walked.	18,67,19	2018-09-17 23:38:25.743348-06
32	ar	PhraseCard	Say	I complained.	30,68,59	2018-09-17 23:38:57.505502-06
33	ar	PhraseCard	Say	He complained.	15,69	2018-09-17 23:39:11.811374-06
34	ar	PhraseCard	Ask	How do we say "yes"?	70,71,72,73,74,75	2018-09-17 23:40:42.375897-06
35	ar	PhraseCard	Ask	What does "na`am" mean?	76,77,78,79,80,75	2018-09-17 23:41:58.165542-06
36	ar	PhraseCard	Say to a man	your name	81,82,83	2018-09-17 23:42:40.440283-06
37	ar	PhraseCard	Say to a woman	your name	81,82,84	2018-09-17 23:42:57.092619-06
38	ar	PhraseCard	Ask a man:	What is your name?	85,81,82,83,75	2018-09-17 23:43:23.684458-06
39	ar	PhraseCard	Ask a woman	What is your name?	85,81,82,84,75	2018-09-17 23:43:46.292959-06
40	ar	PhraseCard	Say	My name is Daniel.	81,86,87,88	2018-09-17 23:44:13.211382-06
41	ar	PhraseCard	Say	I don't know.	89,31,90,33,88	2018-09-17 23:44:44.093606-06
42	ar	PhraseCard	Say	Yes!	91,92	2018-09-17 23:45:19.548897-06
43	ar	PhraseCard	Say	no	93	2018-09-17 23:45:33.475757-06
46	ar	PhraseCard	Ask a man	What's new for you?	85,95,82,83,75	2018-09-17 23:47:33.754762-06
47	ar	PhraseCard	Ask a woman	What's new for you?	85,95,82,84,75	2018-09-17 23:48:08.536598-06
48	ar	PhraseCard	Say	I study.	31,96,33,88	2018-09-17 23:48:26.197791-06
49	ar	PhraseCard	Say	I live	31,97,33,88	2018-09-17 23:48:43.138611-06
50	ar	PhraseCard	Say	I work.	31,98,33,88	2018-09-17 23:49:02.925891-06
52	ar	PhraseCard	Say	Peace be unto you.	101,102,82,103,104,88	2018-09-17 23:51:51.357234-06
53	ar	PhraseCard	Say	hose	105	2018-09-17 23:52:05.696374-06
54	ar	PhraseCard	Say	sun	106	2018-09-17 23:52:14.548142-06
55	ar	PhraseCard	Say	cloudy	107	2018-09-17 23:52:22.142297-06
58	ar	PhraseCard	Respond	We're honored	114,115,116,88	2018-09-17 23:55:34.455789-06
59	ar	PhraseCard	Say	See you later	117,118,119,88	2018-09-17 23:55:56.95575-06
61	ar	PhraseCard	Ask a man	Are you Nizar?	34,122,75	2018-09-17 23:57:09.463483-06
62	ar	PhraseCard	Say	I'm Adib.	30,123,88	2018-09-17 23:57:33.634113-06
63	ar	PhraseCard	Ask a woman	Are you Hala?	37,124,75	2018-09-17 23:57:47.866468-06
64	ar	PhraseCard	Say	He is Mikhail	15,125,88	2018-09-17 23:58:13.558899-06
65	ar	PhraseCard	Say	She is Sali.	18,126,88	2018-09-17 23:58:26.071554-06
66	ar	PhraseCard	Say good morning		127,118,128,88	2018-09-17 23:59:33.970173-06
68	ar	PhraseCard	Ask	How are you?	70,118,94,75	2018-09-18 00:00:28.16745-06
70	ar	PhraseCard	Ask a woman	Where are you from?	136,137,37,75	2018-09-18 00:13:29.208705-06
71	ar	PhraseCard	Answer	I'm from Fez.	30,136,138,88	2018-09-18 00:13:46.002731-06
72	ar	PhraseCard	Say	He's from Tunis.	15,136,139,88	2018-09-18 00:14:01.482308-06
73	ar	PhraseCard	Say	She's from Tunis.	18,136,139,88	2018-09-18 00:14:19.807317-06
74	ar	PhraseCard	Say to a man	You're from Tunis.	140,136,139,88	2018-09-18 00:14:53.961112-06
75	ar	PhraseCard	Say to a woman	You're from Tunis.	37,136,139,88	2018-09-18 00:15:10.939274-06
76	ar	PhraseCard	Say to 2 persons	You're from Beirut.	141,136,142,88	2018-09-18 00:15:37.1272-06
77	ar	PhraseCard	Say to 3+ persons including a man	You're from Beirut	22,136,142,88	2018-09-18 00:15:58.715973-06
78	ar	PhraseCard	Say of 2 persons	They're from Cairo.	143,136,144,88	2018-09-18 00:16:27.948588-06
79	ar	PhraseCard	Say of 3+ persons including a man	They're from Cairo.	26,136,144,88	2018-09-18 00:16:51.310507-06
80	ar	PhraseCard	Say	They're from Damascus.	145,136,146,88	2018-09-18 00:17:12.00099-06
81	ar	PhraseCard	Say	We're from Baghdad.	20,136,147,88	2018-09-18 00:17:30.242126-06
82	ar	PhraseCard	Ask	Where is Fez?	137,138,75	2018-09-18 00:17:53.323723-06
83	ar	PhraseCard	Answer	Fez is in Morocco.	138,148,149,88	2018-09-18 00:18:21.260845-06
57	ar	PhraseCard	Respond	And unto you peace.	109,110,111,82,112,102,82,88	2018-09-17 23:54:37.095621-06
51	ar	PhraseCard	Say	Hello!	99,92	2018-09-17 23:50:52.68272-06
84	ar	PhraseCard	Ask a man	Do you have a telephone?	150,151,152,75	2018-09-26 09:58:30.538668-06
85	ar	PhraseCard	Ask a woman	Do you have a telephone?	150,153,152,75	2018-09-26 09:59:23.104073-06
86	ar	PhraseCard	Say	I have a telephone	154,86,152,88	2018-09-26 10:00:29.700572-06
87	ar	PhraseCard	Say	I have a book.	154,86,155,88	2018-09-26 10:01:20.632887-06
88	ar	PhraseCard	Say	He has a book.	154,156,155,88	2018-09-26 10:01:50.082067-06
89	ar	PhraseCard	Say	She has a book.	154,157,155,88	2018-09-26 10:02:13.953895-06
90	ar	PhraseCard	Say of two persons	They have a watch.	154,158,159,88	2018-09-26 10:05:27.129185-06
91	ar	PhraseCard	Say to 2 persons	You have a telephone.	154,160,152,88	2018-09-26 10:07:07.170948-06
92	ar	PhraseCard	Say	I have a car.	154,86,161,88	2018-09-26 10:07:42.696108-06
93	ar	PhraseCard	Say of 3+ persons including a man	They have a car.	154,162,161,88	2018-09-26 10:08:52.425725-06
94	ar	PhraseCard	Say of 3+ women	They have a car.	154,163,161,88	2018-09-26 10:09:29.761985-06
95	ar	PhraseCard	Say of 3+ persons including a man	They have a car.	154,164,161,88	2018-09-26 10:10:12.940294-06
96	ar	PhraseCard	Say	We have a car.	154,165,161,88	2018-09-26 10:15:37.64196-06
97	ar	PhraseCard	Say as a man	I'm American.	166,167,88	2018-09-26 10:21:23.874315-06
98	ar	PhraseCard	Say	He's American.	15,167,88	2018-09-26 10:21:43.599248-06
99	ar	PhraseCard	Say	He's Egyptian.	15,168,88	2018-09-26 10:22:03.38729-06
100	ar	PhraseCard	Say	She's Egyptian	18,169,88	2018-09-26 10:22:24.801828-06
101	ar	PhraseCard	Say	She's American.	18,170,88	2018-09-26 10:22:44.012404-06
102	ar	PhraseCard	Say	She's Lebanese.	18,171,88	2018-09-26 10:23:05.385524-06
103	ar	PhraseCard	Say	This is a book.	172,155,88	2018-09-26 10:23:28.227629-06
104	ar	PhraseCard	Say	This is a door.	172,173,88	2018-09-26 10:24:00.108182-06
105	ar	PhraseCard	Say	This is a blackboard.	172,174,88	2018-09-26 10:24:18.839732-06
106	ar	PhraseCard	Say	This is a chair.	172,175,88	2018-09-26 10:24:38.702505-06
107	ar	PhraseCard	Say	This is a pen.	172,176,88	2018-09-26 10:25:55.406277-06
108	ar	PhraseCard	Say	This is a window.	177,178,88	2018-09-26 10:26:14.126656-06
109	ar	PhraseCard	Say	This is a table.	177,179,88	2018-09-26 10:26:30.980904-06
110	ar	PhraseCard	Say	This is a ruler.	177,180,88	2018-09-26 10:26:44.941823-06
111	ar	PhraseCard	Say	This is a bag.	177,181,88	2018-09-26 10:26:57.719499-06
112	ar	PhraseCard	Say	This is a picture.	177,182,88	2018-09-26 10:27:10.927992-06
113	ar	PhraseCard	Say	This is a calculator.	177,183,88	2018-09-26 10:27:26.987258-06
114	ar	PhraseCard	Say	This is an eraser.	177,184,88	2018-09-26 10:27:41.847354-06
115	ar	PhraseCard	Say	This is a pencil sharpener	177,185,88	2018-09-26 10:27:58.714053-06
116	ar	PhraseCard	Say	My name is Hala Bustani.	81,86,186,187,88	2018-09-26 10:46:28.275878-06
117	ar	PhraseCard	Say	I'm a student here in Aleppo University.	30,188,189,148,190,191,88	2018-09-26 10:47:37.871543-06
118	ar	PhraseCard	Say	But I'm from Damascus.	192,193,136,194,195,146,88	2018-09-26 10:48:58.268718-06
119	ar	PhraseCard	Say	This is my classroom.	177,196,197,86,88	2018-09-26 10:49:30.895208-06
120	ar	PhraseCard	Say	And this is my professor.	109,172,198,86,88	2018-09-26 10:50:04.37868-06
121	ar	PhraseCard	Say	His name is Elias Ziadeh.	81,199,200,201,88	2018-09-26 10:50:38.734248-06
122	ar	PhraseCard	Say	He's a math professor.	15,198,82,202,88	2018-09-26 10:51:46.570893-06
126	ar	PhraseCard	Say	The book is beside the notebook.	203,155,82,204,207,208,206,88	2018-09-26 11:02:42.218608-06
127	ar	PhraseCard	Say	The book is on the table.	203,155,82,209,210,179,88	2018-09-26 11:04:59.529497-06
128	ar	PhraseCard	Say	The book is on the notebook.	203,155,82,209,208,206,88	2018-09-26 11:05:27.257838-06
130	ar	PhraseCard	Say	The professor and the student are in the classroom.	203,198,109,210,213,82,148,211,214,88	2018-09-26 11:08:45.17524-06
131	ar	PhraseCard	Say	I'm here.	30,189,88	2018-09-26 11:09:29.977495-06
132	ar	PhraseCard	Say	There is a professor in the classroom.	215,198,216,148,211,214,88	2018-09-26 11:12:09.236887-06
129	ar	PhraseCard	Say	The professor is in the classroom.	203,198,82,148,211,212,88	2018-09-26 11:07:05.2681-06
133	ar	PhraseCard	Say	There is a book on the table.	215,155,216,209,210,179,88	2018-09-26 11:16:09.257666-06
134	ar	PhraseCard	Say	my book	155,86	2018-09-26 11:17:35.683825-06
135	ar	PhraseCard	Say	My book is over there.	155,86,215,88	2018-09-26 11:18:12.542941-06
136	ar	PhraseCard	Say	I have a car.	154,86,161,88	2018-09-26 11:18:43.603961-06
137	ar	PhraseCard	Say	I have a bicycle.	154,86,217,88	2018-09-26 11:19:04.969577-06
138	ar	PhraseCard	Say	I don't have a bicycle.	218,219,86,217,88	2018-09-26 11:19:48.302656-06
139	ar	PhraseCard	Say	I have a car, but I don't have a bicycle.	219,86,161,220,218,219,86,217,88	2018-09-26 11:20:59.366037-06
140	ar	PhraseCard	Say	but he	221,222	2018-09-26 11:22:14.783927-06
141	ar	PhraseCard	Say	But she	221,223	2018-09-26 11:22:31.774102-06
142	ar	PhraseCard	Say as a man	I'm Egyptian, but she's Syrian.	30,168,224,223,225,88	2018-09-26 11:23:45.510337-06
143	ar	PhraseCard	Say as a man	I'm Egyptian.	30,168,88	2018-09-26 11:24:25.244654-06
144	ar	PhraseCard	Say	I don't have a bicycle but a car.	218,219,86,217,224,226,88	2018-09-26 11:25:26.425877-06
145	ar	PhraseCard	Say	the Arab student	118,227,82,228,229,88	2018-09-26 11:33:51.742694-06
147	ar	PhraseCard	Say	The female student is Tunisian, but the male student is Moroccan.	118,230,82,231,229,224,210,232,233,234,235,88	2018-09-26 11:38:51.723388-06
148	ar	PhraseCard	Say	also	236	2018-09-26 11:39:37.713764-06
149	ar	PhraseCard	Say	wall	237	2018-09-26 11:39:51.734057-06
150	ar	PhraseCard	Say	sun	106	2018-09-26 11:39:59.588655-06
151	ar	PhraseCard	Say	solar	106,238	2018-09-26 11:41:27.563262-06
152	ar	PhraseCard	Say	lunar	239,238	2018-09-26 11:41:43.452022-06
153	ar	PhraseCard	Say	My notebook isn't here.	189,218,206,86,88	2018-09-26 11:42:23.080684-06
154	ar	PhraseCard	Say	She isn't American.	18,240,241,229,88	2018-09-26 11:45:19.396177-06
155	ar	PhraseCard	Say	She's Canadian.	18,242,216,88	2018-09-26 11:46:00.03-06
156	ar	PhraseCard	Say	Nadia is not a student.	240,243,82,230,244,88	2018-09-26 11:48:39.389514-06
158	ar	PhraseCard	Say	The professor isn't Lebanese.	245,246,198,82,249,248,88	2018-09-26 11:52:49.019108-06
159	ar	PhraseCard	Say	television	250	2018-09-26 11:53:17.862958-06
160	ar	PhraseCard	Say	newspaper	251	2018-09-26 11:53:25.979278-06
161	ar	PhraseCard	Say	computer	252	2018-09-26 11:53:32.949138-06
162	ar	PhraseCard	Say	bicycle	217	2018-09-26 11:53:45.876803-06
163	ar	PhraseCard	Say	notebook	206	2018-09-26 11:53:57.836594-06
164	ar	PhraseCard	Say	pen	176	2018-09-26 11:54:21.810144-06
165	ar	PhraseCard	Say	city	194	2018-09-26 11:54:42.443095-06
166	ar	PhraseCard	Say	tape recorder	253	2018-09-26 11:54:59.390062-06
167	ar	PhraseCard	Say	key	254	2018-09-26 11:55:14.427918-06
168	ar	PhraseCard	Say	relative adjective	255	2018-09-26 11:55:46.955844-06
169	ar	PhraseCard	Say	eyeglasses	256	2018-09-26 11:56:07.735292-06
170	ar	PhraseCard	Say	telephone	152	2018-09-26 11:56:23.027092-06
171	ar	PhraseCard	Say	state/province	257	2018-09-26 11:57:09.504187-06
172	ar	PhraseCard	Say	lunar consonants	258,259	2018-09-26 12:00:57.205326-06
173	ar	PhraseCard	Say	solar consonants	106,260	2018-09-26 12:01:18.700503-06
174	ar	PhraseCard	Say	consonant	261	2018-09-26 12:01:30.770822-06
175	ar	PhraseCard	Say	hamza link	262,82,263,264,88	2018-09-26 12:06:52.832716-06
176	ar	PhraseCard	Wish someone goodbye		266,267,121,92	2018-09-27 13:28:47.814767-06
177	ar	PhraseCard	Respond to a man wishing you goodbye		268,269,270,92	2018-09-27 13:39:01.351981-06
178	ar	PhraseCard	Respond to a woman wishing you goodbye		268,269,271,92	2018-09-27 13:40:23.031495-06
179	ar	PhraseCard	Respond to being wished a good morning		127,272,129,273	2018-09-27 13:45:15.55244-06
181	ar	PhraseCard	Ask a woman how she's doing		70,274,82,271,75	2018-09-27 13:50:57.089836-06
180	ar	PhraseCard	Ask a man how he's doing		70,274,82,270,75	2018-09-27 13:50:22.894921-06
182	ar	PhraseCard	Ask 1+ persons how they're doing		70,246,274,75	2018-09-27 13:52:32.255454-06
183	ar	PhraseCard	Welcome someone		275,276,109,277,276,92	2018-09-27 14:02:38.977137-06
184	ar	PhraseCard	Respond to a man	Familarly with you!	275,276,278,270,92	2018-09-27 14:09:56.276586-06
185	ar	PhraseCard	Respond to a woman	Familarly with you!	275,276,278,271,92	2018-09-27 14:10:28.630914-06
186	ar	PhraseCard	Say	Praise to God!	118,279,82,132,133,280,92	2018-09-27 14:14:14.322766-06
187	ar	PhraseCard	Respond to being asked how you're doing	well	134,281	2018-09-27 14:16:19.827081-06
188	ar	PhraseCard	Say good evening		282,118,128,92	2018-09-27 14:18:56.549746-06
189	ar	PhraseCard	Respond to good evening		282,272,129,92	2018-09-27 14:19:54.258757-06
190	ar	PhraseCard	Say to a man	please	283,284,233,270	2018-09-27 14:24:12.327493-06
191	ar	PhraseCard	Say to a woman	please	283,284,233,271	2018-09-27 14:24:27.132678-06
192	ar	PhraseCard	Say	thanks	285	2018-09-27 14:26:49.859722-06
193	ar	PhraseCard	Say	good work	286,287	2018-09-27 14:37:58.740245-06
194	ar	PhraseCard	Say	I don't understand.	89,288,88	2018-09-27 14:44:41.89439-06
195	ar	PhraseCard	Say	I understand	289,290,88	2018-09-27 14:46:35.972947-06
196	ar	PhraseCard	Say	I don't know	89,291,88	2018-09-27 14:49:19.89435-06
197	ar	PhraseCard	Request	Speak more slowly.	292,278,293,88	2018-09-27 14:52:40.995225-06
198	ar	PhraseCard	Ask	Do you speak Arabic?	294,295,118,296,246,297,298,299,75	2018-09-27 14:59:27.377471-06
199	ar	PhraseCard	Answer	a little	300	2018-09-27 15:00:36.784992-06
200	ar	PhraseCard	Ask	How do you say the word "Canada" in Arabic?	70,301,72,302,303,74,278,246,304,298,299,75	2018-09-27 15:06:51.35674-06
201	ar	PhraseCard	Say	sorry	305	2018-09-27 15:11:37.177234-06
202	ar	PhraseCard	Respond to an apology		118,306	2018-09-27 15:13:43.099818-06
\.


--
-- Name: new_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dan
--

SELECT pg_catalog.setval('new_cards_id_seq', 202, true);


--
-- Data for Name: paragraphs; Type: TABLE DATA; Schema: public; Owner: dan
--

COPY paragraphs (paragraph_id, topic, created_at, updated_at, enabled, lang) FROM stdin;
3	place	2018-06-28 11:09:46.145422-06	2018-06-28 12:23:34.701-06	f	es
5	other	2018-06-28 11:09:53.385521-06	2018-06-28 12:23:44.663-06	f	es
1	greetings	2018-06-28 11:09:01.735573-06	2018-06-28 12:24:00.777-06	f	es
7	Pimsleur 1.1-2	2018-08-31 19:06:50.192626-06	2018-08-31 19:17:19.704-06	t	es
4	language learning	2018-06-28 11:09:49.905994-06	2018-08-31 19:17:36.658-06	f	es
8	Pimsleur 1.3	2018-09-01 17:07:43.000326-06	2018-09-01 17:07:42.999-06	t	es
2	software	2018-06-28 11:09:42.833001-06	2018-07-17 08:58:30.411-06	f	es
9	Greetings	2018-09-02 15:37:04.777894-06	2018-09-02 15:37:04.745-06	t	fr
10	Verb conjugations	2018-09-07 13:58:23.971876-06	2018-09-07 13:58:23.968-06	t	ar
11	Alif Baa Unit 2	2018-09-07 18:28:21.029119-06	2018-09-07 18:28:21.026-06	t	ar
12	Alif Baaa Unit 4-5	2018-09-07 21:38:43.582374-06	2018-09-07 21:38:43.58-06	t	ar
13	Alif Baa Unit 3	2018-09-07 22:00:32.699487-06	2018-09-07 22:00:32.698-06	t	ar
14	Aliff Baa Unit 6-8	2018-09-07 22:25:25.720979-06	2018-09-07 22:25:25.72-06	t	ar
\.


--
-- Name: paragraphs_paragraph_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dan
--

SELECT pg_catalog.setval('paragraphs_paragraph_id_seq', 14, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
2	2	create leaf tables	SQL	V2__create_leaf_tables.sql	779524700	postgres	2018-06-27 09:31:17.474367	34	t
3	3	create card embeddings	SQL	V3__create_card_embeddings.sql	-552310015	postgres	2018-06-27 19:43:19.226605	42	t
1	1	create goals and cards	SQL	V1__create_goals_and_cards.sql	1062513313	postgres	2018-06-27 09:31:17.379663	46	t
4	4	no unique es mixed	SQL	V4__no_unique_es_mixed.sql	604495595	postgres	2018-09-01 18:07:12.74282	129	t
5	5	add french	SQL	V5__add_french.sql	701199897	postgres	2018-09-02 15:33:33.249875	118	t
6	6	add french verbs	SQL	V6__add_french_verbs.sql	667749704	postgres	2018-09-02 16:03:54.533692	32	t
7	7	add arabic nonverbs	SQL	V7__add_arabic_nonverbs.sql	507587595	postgres	2018-09-05 18:32:58.10174	36	t
8	8	add arabic verb roots	SQL	V8__add_arabic_verb_roots.sql	-82587003	postgres	2018-09-07 10:21:35.115419	28	t
9	9	add arabic stem changes	SQL	V9__add_arabic_stem_changes.sql	-174351429	postgres	2018-09-07 15:42:49.611614	18	t
10	10	add arabic unique conjugations	SQL	V10__add_arabic_unique_conjugations.sql	1328814492	postgres	2018-09-07 18:18:30.616128	41	t
11	11	add arabic nouns	SQL	V11__add_arabic_nouns.sql	-187805131	postgres	2018-09-07 19:47:13.859369	22	t
12	12	create morphemes and new cards	SQL	V12__create_morphemes_and_new_cards.sql	208969610	postgres	2018-09-17 21:21:05.001337	152	t
13	13	add atoms json to morphemes	SQL	V13__add_atoms_json_to_morphemes.sql	1372585115	postgres	2018-09-26 12:24:07.134134	34	t
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
-- Name: morphemes morphemes_pkey; Type: CONSTRAINT; Schema: public; Owner: dan
--

ALTER TABLE ONLY morphemes
    ADD CONSTRAINT morphemes_pkey PRIMARY KEY (id);


--
-- Name: new_cards new_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: dan
--

ALTER TABLE ONLY new_cards
    ADD CONSTRAINT new_cards_pkey PRIMARY KEY (id);


--
-- Name: paragraphs paragraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: dan
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_pkey PRIMARY KEY (paragraph_id);


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
-- Name: idx_leafs_es_mixed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leafs_es_mixed ON leafs USING btree (es_mixed);


--
-- Name: idx_leafs_fr_mixed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_leafs_fr_mixed ON leafs USING btree (fr_mixed);


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
-- Name: leafs leafs_infinitive_leaf_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY leafs
    ADD CONSTRAINT leafs_infinitive_leaf_id_fkey FOREIGN KEY (infinitive_leaf_id) REFERENCES leafs(leaf_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

