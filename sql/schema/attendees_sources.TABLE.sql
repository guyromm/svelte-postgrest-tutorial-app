-- Name: attendees_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendees_sources (
    id character varying NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    owner_id character varying DEFAULT current_setting('request.jwt.claim.email'::text, true)
);


--
