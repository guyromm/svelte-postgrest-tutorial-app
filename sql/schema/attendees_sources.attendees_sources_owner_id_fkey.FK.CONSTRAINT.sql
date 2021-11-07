-- Name: attendees_sources attendees_sources_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendees_sources
    ADD CONSTRAINT attendees_sources_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES basic_auth.users(email);


--
