-- Name: attendees attendees_attendee_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_attendee_source_id_fkey FOREIGN KEY (attendee_source_id) REFERENCES public.attendees_sources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
