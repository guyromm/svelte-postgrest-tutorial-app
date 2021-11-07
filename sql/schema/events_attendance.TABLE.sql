-- Name: events_attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_attendance (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    owner character varying DEFAULT current_setting('request.jwt.claim.email'::text, true),
    attendee_id integer NOT NULL,
    is_present boolean,
    notes character varying
);


--
