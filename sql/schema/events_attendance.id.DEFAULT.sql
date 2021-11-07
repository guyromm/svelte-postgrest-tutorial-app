-- Name: events_attendance id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_attendance ALTER COLUMN id SET DEFAULT nextval('public.events_attendance_id_seq'::regclass);


--
