-- Name: attendees_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendees_sources (
    id integer DEFAULT nextval('public.attendees_sources_id_seq'::regclass) NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    owner_id character varying DEFAULT current_setting('request.jwt.claim.email'::text, true),
    google_sheet_id character varying,
    typ character varying,
    name character varying NOT NULL
);


--
