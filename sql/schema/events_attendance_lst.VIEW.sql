-- Name: events_attendance_lst; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.events_attendance_lst AS
 SELECT DISTINCT ON (events_attendance.event_id, events_attendance.attendee_id) events_attendance.id,
    events_attendance.ts,
    events_attendance.owner_id,
    events_attendance.attendee_id,
    events_attendance.is_present,
    events_attendance.notes,
    events_attendance.event_id
   FROM public.events_attendance
  ORDER BY events_attendance.event_id, events_attendance.attendee_id, events_attendance.ts DESC;


--
