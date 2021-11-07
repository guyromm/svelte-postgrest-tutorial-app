<script>
  import {onMount} from 'svelte';
  import { page } from '$app/stores'
  import {select,selectOne,insert,del} from '../../../common/postgrest.js';
  const l =console.log;
  let events;
  let sources;
  let src_id = ($page.query.get('src') || undefined);
  let src;
  
  async function load() {
    if (src_id)
      src = await selectOne('attendees_sources',{id:'eq.'+src_id});
    else
      src = null;
    events = await select('events',{select:'*,attendees_sources(*)'});
    sources = await select('attendees_sources');
  }
  onMount(load);
  let newEvent={name:'',attendee_source_id:null};
  async function create() {
    await insert('events',newEvent);
    await load();
  }
  async function delEvent(eid) {
    if (!confirm(`Really delete event ${eid}?`)) return;
    await del('events',{id:'eq.'+eid});
    await load();
  }
</script>

<input type='text' bind:value={newEvent.name}/>

<select placeholder='please select an attendee list'
	disabled={!sources} bind:value={newEvent.attendee_source_id}>
  {#each (sources?sources:[]) as s}
    <option value={s.id}>{s.name}</option>
  {/each}
</select>

<button disabled={!newEvent.attendee_source_id} on:click={create}>create</button>
{#if !events}
  loading
{:else}
  <h4>{events.length} events {#if src}with attendees source {src.id}{/if}</h4>
  <table>
    <thead>
      <tr>
	<th>id</th>
	<th>name</th>
	<th>created</th>
	<th>source</th>
	<th>delete</th>
      </tr>
    </thead>
    <tbody>
      {#each events as e}
	<tr>
	  <td><a title='mark attendance for this event'
		 href={`/attendance?id=${e.id}`}>{e.id}</a></td>
	  <td>{e.name}</td>
	  <td>{e.ts}</td>
	  <td>{#if e.attendee_source_id}
	    {e.attendee_source_id}. {e.attendees_sources.name}
	  {/if}
	</td>
	  <td>
	    <button on:click={()=>delEvent(e.id)}>delete</button>
	  </td>
	</tr>
      {/each}
    </tbody>
  </table>
{/if}

