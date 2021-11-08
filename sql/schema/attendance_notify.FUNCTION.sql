-- Name: attendance_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.attendance_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
perform pg_notify('events_attendance',row_to_json(NEW)::varchar);
return NEW;
end;
$$;


--
