-- Name: events_attendance events_attendance_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_attendance
    ADD CONSTRAINT events_attendance_owner_fkey FOREIGN KEY (owner) REFERENCES basic_auth.users(email);


--
