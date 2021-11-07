-- Name: events_attendance events_attendance_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY events_attendance_policy ON public.events_attendance USING (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true))) WITH CHECK (((owner_id)::text = current_setting('request.jwt.claim.email'::text, true)));


--
