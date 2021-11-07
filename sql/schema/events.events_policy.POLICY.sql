-- Name: events events_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY events_policy ON public.events USING (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true))) WITH CHECK (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true)));


--
