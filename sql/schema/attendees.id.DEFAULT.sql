-- Name: attendees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendees ALTER COLUMN id SET DEFAULT nextval('public.attendees_id_seq'::regclass);


--
