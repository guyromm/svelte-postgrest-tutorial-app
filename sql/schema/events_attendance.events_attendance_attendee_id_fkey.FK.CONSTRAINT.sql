-- Name: events_attendance events_attendance_attendee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_attendance
    ADD CONSTRAINT events_attendance_attendee_id_fkey FOREIGN KEY (attendee_id) REFERENCES public.attendees(id);


--
