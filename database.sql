--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 17.2

-- Started on 2025-04-21 21:18:31

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
-- Name: conversations; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.conversations (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.conversations OWNER TO neondb_owner;

--
-- TOC entry 217 (class 1259 OID 24587)
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
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
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- TOC entry 224 (class 1259 OID 24628)
-- Name: messages; Type: TABLE; Schema: public; Owner: neondb_owner
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


ALTER SEQUENCE public.users_id_seq OWNER TO neondb_owner;

--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3201 (class 2604 OID 24591)
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- TOC entry 3204 (class 2604 OID 24631)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 3202 (class 2604 OID 24603)
-- Name: training_data id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.training_data ALTER COLUMN id SET DEFAULT nextval('public.training_data_id_seq'::regclass);


--
-- TOC entry 3203 (class 2604 OID 24617)
-- Name: training_files id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.training_files ALTER COLUMN id SET DEFAULT nextval('public.training_files_id_seq'::regclass);


--
-- TOC entry 3200 (class 2604 OID 24580)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3369 (class 0 OID 24588)
-- Dependencies: 218
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.conversations (id, title, user_id, created_at, updated_at) FROM stdin;
25	New Conversation	3	2025-04-21 16:04:53.66398	2025-04-21 16:04:53.66398
26	New Conversation	3	2025-04-21 16:05:12.463992	2025-04-21 16:36:56.581641
27	New Conversation	3	2025-04-21 16:38:11.181412	2025-04-21 16:38:23.38404
\.


--
-- TOC entry 3375 (class 0 OID 24628)
-- Dependencies: 224
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.messages (id, conversation_id, role, content, created_at) FROM stdin;
27	26	user	البنك التجاري	2025-04-21 16:36:57.403773
28	26	assistant	I can assist with account information, transfers, payments, and other banking services. What would you like to know?	2025-04-21 16:36:58.75868
29	27	user	البنك	2025-04-21 16:38:24.306527
30	27	assistant	هو بنك يمني	2025-04-21 16:38:25.52683
\.


--
-- TOC entry 3371 (class 0 OID 24600)
-- Dependencies: 220
-- Data for Name: training_data; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.training_data (id, user_id, question, answer, source_type, source_name, created_at) FROM stdin;
30	3	البنك التجاري	هو بنك يمني	manual	\N	2025-04-21 16:37:40.192801
\.


--
-- TOC entry 3373 (class 0 OID 24614)
-- Dependencies: 222
-- Data for Name: training_files; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.training_files (id, user_id, filename, original_filename, file_size, file_type, status, created_at, processed_at) FROM stdin;
\.


--
-- TOC entry 3367 (class 0 OID 24577)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.users (id, username, email, password_hash, created_at) FROM stdin;
1	Abderzaq	abderzaq@gmail.com	scrypt:32768:8:1$ctXISEFvP1IBjERO$3df172509291537577fdfa6e378944ca6fdf4fde19086e3941a46ef3e64f9bcb13b825d89938f5e9919be1781bb034b377cf058ba6ad4e0beb3cbcf65708133c	2025-04-20 12:04:38.710334
2	ali	ss@gmail.com	scrypt:32768:8:1$JorTIZwsiu3R3GDs$3318d59a25177ad66fc865d6d46b7dee36d8e631c7c94e0fcb82043328632dcf0078d9f0f5be8c85ce80431334b0a5af0da96c6c708469e2d55ef493e224439f	2025-04-21 15:01:32.645684
3	علي	mostfaalsiory@gmail.com	scrypt:32768:8:1$W3spJ7HkfMkZLvr5$545796d5a7b32163d7361e17f7f3e24c8ba2e04e141a7b7c34c6b7824d4ce5618b605b39fb73f1ff6ee74595f1e63ad212110e1b0cd55c62b67cd67881c74d83	2025-04-21 15:20:23.576571
\.


--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 217
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


--
-- TOC entry 3212 (class 2606 OID 24593)
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 24635)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 24607)
-- Name: training_data training_data_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.training_data
    ADD CONSTRAINT training_data_pkey PRIMARY KEY (id);


--
-- TOC entry 3216 (class 2606 OID 24621)
-- Name: training_files training_files_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.training_files
    ADD CONSTRAINT training_files_pkey PRIMARY KEY (id);


--
-- TOC entry 3206 (class 2606 OID 24586)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3208 (class 2606 OID 24582)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 24584)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3219 (class 2606 OID 24594)
-- Name: conversations conversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3222 (class 2606 OID 24636)
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id);


--
-- TOC entry 3220 (class 2606 OID 24608)
-- Name: training_data training_data_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.training_data
    ADD CONSTRAINT training_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3221 (class 2606 OID 24622)
-- Name: training_files training_files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.training_files
    ADD CONSTRAINT training_files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 2059 (class 826 OID 16392)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- TOC entry 2058 (class 826 OID 16391)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO neon_superuser WITH GRANT OPTION;


-- Completed on 2025-04-21 21:20:19

--
-- PostgreSQL database dump complete
--

