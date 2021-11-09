-- Name: attendees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendees (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    attendee_source_id character varying NOT NULL,
    owner_id character varying DEFAULT current_setting('request.jwt.claim.email'::text, true),
    email character varying,
    first_name character varying,
    last_name character varying,
    meta jsonb,
    is_disabled boolean DEFAULT false
);


--
