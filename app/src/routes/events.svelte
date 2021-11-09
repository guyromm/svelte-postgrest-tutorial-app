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
    events = await select('events');
    sources = await select('attendees_sources');
  }
  onMount(load);
  let newEvent={name:'',attendee_source_id:null};
  async function create() {
    await insert('events',newEvent);
    await load();
  }
  async function delEvent(eid) {
    await del('events',{id:'eq.'+eid});
    await load();
  }
</script>

<input type='text' bind:value={newEvent.name}/>

<select disabled={!sources} bind:value={newEvent.attendee_source_id}>
  {#each (sources?sources:[]) as s}
    <option value={s.id}>{s.id}</option>
  {/each}
</select>

<button on:click={create}>create</button>
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
	  <td><a href={`/attendance?id=${e.id}`}>{e.id}</a></td>
	  <td>{e.name}</td>
	  <td>{e.ts}</td>
	  <td>{e.attendee_source_id}</td>
	  <td>
	    <button on:click={()=>delEvent(e.id)}>delete</button>
	  </td>
	</tr>
      {/each}
    </tbody>
  </table>
{/if}

