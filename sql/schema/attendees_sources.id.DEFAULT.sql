-- Name: attendees_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendees_sources ALTER COLUMN id SET DEFAULT nextval('public.attendees_sources_id_seq'::regclass);


--
