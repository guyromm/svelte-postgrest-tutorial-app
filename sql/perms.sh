for T in $( echo events ; echo attendees_sources ; echo attendees ) ; do
    echo "table $T"
    ./psql.sh -c "grant all on $T to client"
    ./psql.sh -c "grant all on $T""_id_seq to client"
    ./psql.sh -c "alter table $T enable row level security"
    ./psql.sh -c "drop policy if exists  $T""_policy on $T"
    ./psql.sh -c "create policy $T""_policy on $T using (owner_id=current_setting('request.jwt.claim.email', true)) with check (owner_id=current_setting('request.jwt.claim.email', true))"
    done
