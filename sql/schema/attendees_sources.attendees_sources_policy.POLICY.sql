-- Name: attendees_sources attendees_sources_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY attendees_sources_policy ON public.attendees_sources USING (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true))) WITH CHECK (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true)));


--
