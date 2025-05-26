--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 24588)
-- Name: conversations; Type: TABLE; Schema: public;
--

CREATE TABLE public.conversations (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.conversations OWNER TO ...;

--
-- TOC entry 217 (class 1259 OID 24587)
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public;
--

CREATE SEQUENCE public.conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversations_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 217
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; 
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- TOC entry 224 (class 1259 OID 24628)
-- Name: messages; Type: TABLE; Schema: public;
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    conversation_id integer NOT NULL,
    role character varying(10) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.messages OWNER TO neondb_owner;

--
-- TOC entry 223 (class 1259 OID 24627)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 223
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 220 (class 1259 OID 24600)
-- Name: training_data; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.training_data (
    id integer NOT NULL,
    user_id integer NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    source_type character varying(20) NOT NULL,
    source_name character varying(256),
    created_at timestamp without time zone
);


ALTER TABLE public.training_data OWNER TO neondb_owner;

--
-- TOC entry 219 (class 1259 OID 24599)
-- Name: training_data_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.training_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.training_data_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 219
-- Name: training_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.training_data_id_seq OWNED BY public.training_data.id;


--
-- TOC entry 222 (class 1259 OID 24614)
-- Name: training_files; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.training_files (
    id integer NOT NULL,
    user_id integer NOT NULL,
    filename character varying(256) NOT NULL,
    original_filename character varying(256) NOT NULL,
    file_size integer NOT NULL,
    file_type character varying(50) NOT NULL,
    status character varying(20) NOT NULL,
    created_at timestamp without time zone,
    processed_at timestamp without time zone
);


ALTER TABLE public.training_files OWNER TO neondb_owner;

--
-- TOC entry 221 (class 1259 OID 24613)
-- Name: training_files_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.training_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.training_files_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 221
-- Name: training_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.training_files_id_seq OWNED BY public.training_files.id;


--
-- TOC entry 216 (class 1259 OID 24577)
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(120) NOT NULL,
    password_hash character varying(256) NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO neondb_owner;

--
-- TOC entry 215 (class 1259 OID 24576)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


: 217
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.conversations_id_seq', 27, true);


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 223
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.messages_id_seq', 30, true);


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 219
-- Name: training_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.training_data_id_seq', 30, true);


--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 221
-- Name: training_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.training_files_id_seq', 4, true);


--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);




