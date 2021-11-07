<script>
  import { onMount } from 'svelte'
  import { page } from '$app/stores'
  import {select,selectOne,update,insert} from '../../../common/postgrest.js';
  const l = console.log;
  
  let eid = ($page.query.get('id')||undefined);
  let mode = ($page.query.get('mode')||'swipe');
  let e;
  let attendees;
  let curpres;
  let aidx=0; // attendee index
  let a; // current attendee
  $: a = attendees?attendees[aidx]:a;
  const load = async () => {
    e = await selectOne('events',{id:'eq.'+eid,
				  select:'*,attendees_sources(*,attendees(*))'});
    curpres = Object.fromEntries((await select('events_attendance_lst',{event_id:'eq.'+e.id})).map(ea=>([ea.attendee_id,ea.is_present])));
    attendees = e.attendees_sources.attendees;
    l('e',e);
  }
  
  onMount(load);
  async function mark(a,e,is_present) {
    await insert('events_attendance',{event_id:e.id,
				      is_present,
				      attendee_id:a.id});
    aidx=(aidx<=attendees.length-2?aidx+1:0);
    await load();
  }
  async function yes(a,e) {
    return await mark(a,e,true);
  }
  async function no(a,e) {
    return await mark(a,e,false);
  }
</script>
{#if e && attendees}
  <h4>attendance for {e.name} ({e.id}) ; {attendees.length} participants</h4>
  {#if mode==='report'}
    <a
      on:click={()=>mode='swipe'}
      href={`/attendance?id=${eid}&mode=swipe`}>swipe mode</a>    
    <table>
      <thead>
	<tr>
	  <th>email</th>
	  <th>first name</th>
	  <th>last name</th>
	  <th>present?</th>
	</tr>
      </thead>
      <tbody>
	{#each attendees as a}
	  <tr>
	    <td><a href={`mailto:${a.email}`}>{a.email}</a></td>
	    <td>{a.first_name}</td>
	    <td>{a.last_name}</td>
	    <td>{curpres[a.id]}</td>
	  </tr>
	  {/each}
	</tbody>
    </table>
    {:else}
      <a
	on:click={()=>mode='report'}
	href={`/attendance?id=${eid}&mode=report`}>see report</a>
      {#if a}
	<p>is {a.first_name} {a.last_name} ({a.email}) attending?<br/>
	  <button accesskey='y' on:click={()=>yes(a,e)}>yes</button>
	  <button accesskey='n' on:click={()=>no(a,e)}>no</button>
	  (current: {curpres[a.id]})
	</p>
      {/if}
    {/if}
{/if}
