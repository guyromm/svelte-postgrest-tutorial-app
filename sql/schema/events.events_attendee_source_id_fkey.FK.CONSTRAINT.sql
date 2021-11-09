-- Name: events events_attendee_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_attendee_source_id_fkey FOREIGN KEY (attendee_source_id) REFERENCES public.attendees_sources(id);


--
