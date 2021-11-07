-- Name: attendees attendees_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY attendees_policy ON public.attendees USING (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true))) WITH CHECK (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true)));


--
