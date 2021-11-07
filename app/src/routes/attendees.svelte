<script>
  import { onMount } from 'svelte'
  import { page } from '$app/stores'
  import {select,selectOne,update} from '../../../common/postgrest.js';
  const l = console.log;
  
  let src_id = ($page.query.get('src') || undefined);
  let src;
  let attendees;
  onMount(async () => {
    src = await selectOne('attendees_sources',{id:'eq.'+src_id});
    attendees = await select('attendees',{attendee_source_id:'eq.'+src_id,order:'ts.desc'});
  });
  async function endistoggle(a) {
    l(a.id,a.is_disabled);
    await update('attendees',{id:a.id,is_disabled:a.is_disabled});
  }
</script>

{#if attendees}
  <h4>{attendees.length} attendees belonging to {src.id}</h4>
  <table>
    <thead>
      <tr>
	<th>email</th>
	<th>first name</th>
	<th>last name</th>
	<th>disabled</th>
      </tr>
    </thead>
    <tbody>
      {#each attendees as a}
	<tr>
	  <td>{a.email}</td>
	  <td>{a.first_name}</td>
	  <td>{a.last_name}</td>
	  <td><input
		type='checkbox'
		bind:checked={a.is_disabled}
		on:change={()=>endistoggle(a)}
		/></td>
	</tr>
      {/each}
    </tbody>
  </table>
{/if}
