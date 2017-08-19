--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

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
-- Name: exposures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE exposures (
    id integer NOT NULL,
    type text NOT NULL,
    es text NOT NULL,
    prompted_at bigint NOT NULL,
    responded_at bigint NOT NULL
);


ALTER TABLE exposures OWNER TO postgres;

--
-- Name: exposures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE exposures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE exposures_id_seq OWNER TO postgres;

--
-- Name: exposures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE exposures_id_seq OWNED BY exposures.id;


--
-- Name: exposures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY exposures ALTER COLUMN id SET DEFAULT nextval('exposures_id_seq'::regclass);


--
-- Data for Name: exposures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY exposures (id, type, es, prompted_at, responded_at) FROM stdin;
9	FAST_NOD	muslo	1503155661496	1503155661703
10	FAST_NOD	muslo	1503155753708	1503155754183
11	FAST_NOD	muslo	1503155774715	1503155775193
12	FAST_NOD	muslo	1503155905299	1503155905343
\.


--
-- Name: exposures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('exposures_id_seq', 12, true);


--
-- Name: exposures exposures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY exposures
    ADD CONSTRAINT exposures_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

