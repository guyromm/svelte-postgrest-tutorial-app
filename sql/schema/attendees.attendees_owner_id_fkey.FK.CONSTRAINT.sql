-- Name: attendees attendees_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES basic_auth.users(email);


--
