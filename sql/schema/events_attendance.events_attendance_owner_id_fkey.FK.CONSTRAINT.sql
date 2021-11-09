-- Name: events_attendance events_attendance_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_attendance
    ADD CONSTRAINT events_attendance_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES basic_auth.users(email);


--
