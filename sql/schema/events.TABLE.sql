-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    attendee_source_id character varying NOT NULL,
    owner_id character varying DEFAULT current_setting('request.jwt.claim.email'::text, true),
    name character varying NOT NULL
);


--
