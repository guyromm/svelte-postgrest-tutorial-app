<script>
  import {onMount} from 'svelte';
  import {select} from '../../../common/postgrest.js';
  let as=[];
  let es=[];
  let al=[];
  onMount(async () => {
    as = await select('attendees_sources',{limit:1});
    es = await select('events',{limit:1,order:'ts.desc'});
    al = await select('events_attendance',{limit:1})
  });
</script>
<h4>welcome to attendance!</h4>
<ul>
  <li>
    <input type='checkbox' checked={as.length} disabled/>
    begin by <a href="/sources">ingesting</a> some google sheets with attendants</li>

  <li>
    you can now make sure that the ingested list {#if as.length}<a href={`/attendees?src=${as[0].id}`}>matches to what you intended</a>{:else}matches what you intended{/if}.
  </li>
  
  
  <li>
    <input type='checkbox' checked={es.length} disabled/>
    follow up by defining <a href="/events">an event</a> with the created attendants list</li>

  <li>
    <input type='checkbox' checked={al && al.length} disabled/>
    next, you can {#if es.length}<a href={es.length?`/attendance?id=${es[0].id}`:''}>start checking the status</a>{:else}start checking the status{/if} for your attendees
      </li>

</ul>
