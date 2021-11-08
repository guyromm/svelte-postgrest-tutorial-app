-- Name: events_attendance attendance_notify_trig; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER attendance_notify_trig AFTER INSERT ON public.events_attendance FOR EACH ROW EXECUTE FUNCTION public.attendance_notify();


--
