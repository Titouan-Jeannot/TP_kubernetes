--
-- PostgreSQL database dump
--

\restrict EfJHAQgbPdAtfXzoyqjSwa1l1dHoN0DX0nQ1U2KtewX7CiSc8Yj4MF19kCdfiPx

-- Dumped from database version 13.23 (Debian 13.23-1.pgdg13+1)
-- Dumped by pg_dump version 13.23 (Debian 13.23-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: reviews; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.reviews (
    name text NOT NULL,
    review text NOT NULL
);


ALTER TABLE public.reviews OWNER TO admin;

--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.reviews (name, review) FROM stdin;
test1	voici un petit test
test2	voici un second test
\.


--
-- PostgreSQL database dump complete
--

\unrestrict EfJHAQgbPdAtfXzoyqjSwa1l1dHoN0DX0nQ1U2KtewX7CiSc8Yj4MF19kCdfiPx

