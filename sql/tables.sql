CREATE TABLE public.events (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    attendee_source_id character varying NOT NULL,
    owner_id character varying DEFAULT current_setting('request.jwt.claim.email'::text, true)
);
comment on table events is 'event definitions for which we''d like to write down attendance.';

CREATE TABLE public.attendees (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    attendee_source_id character varying NOT NULL,
    owner character varying DEFAULT current_setting('request.jwt.claim.email'::text, true),
    email character varying,
    first_name character varying,
    last_name character varying
);
comment on table attendees is 'attendees whose attendance we would like to mark ';

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);
    
CREATE TABLE public.attendees_sources (
    id character varying NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    owner_id character varying DEFAULT current_setting('request.jwt.claim.email'::text, true)
);
comment on table attendees_sources is 'attendee list sources. these would be google sheets or uploaded csv files';

CREATE TABLE public.events_attendance (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    owner character varying DEFAULT current_setting('request.jwt.claim.email'::text, true),
    attendee_id integer NOT NULL,
    is_present boolean,
    notes character varying
);
comment on table events_attendance is 'actual attendance to events by attendees';

CREATE SEQUENCE public.attendees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ONLY public.attendees ALTER COLUMN id SET DEFAULT nextval('public.attendees_id_seq'::regclass);

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);
    
ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;

CREATE SEQUENCE public.events_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    
ALTER TABLE ONLY public.events_attendance ALTER COLUMN id SET DEFAULT nextval('public.events_attendance_id_seq'::regclass);
    
ALTER SEQUENCE public.attendees_id_seq OWNED BY public.attendees.id;
ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES basic_auth.users(email);
ALTER SEQUENCE public.events_attendance_id_seq OWNED BY public.events_attendance.id;
ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_owner_fkey FOREIGN KEY (owner) REFERENCES basic_auth.users(email);
ALTER TABLE ONLY public.attendees_sources
    ADD CONSTRAINT attendees_sources_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.events_attendance
    ADD CONSTRAINT events_attendance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_attendee_source_id_fkey FOREIGN KEY (attendee_source_id) REFERENCES public.attendees_sources(id);
ALTER TABLE ONLY public.events_attendance
    ADD CONSTRAINT events_attendance_owner_fkey FOREIGN KEY (owner) REFERENCES basic_auth.users(email);
ALTER TABLE ONLY public.attendees_sources
    ADD CONSTRAINT attendees_sources_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES basic_auth.users(email);
ALTER TABLE ONLY public.events_attendance
    ADD CONSTRAINT events_attendance_attendee_id_fkey FOREIGN KEY (attendee_id) REFERENCES public.attendees(id);
