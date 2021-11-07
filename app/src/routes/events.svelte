<script>
  import {onMount} from 'svelte';
  import {select,insert} from '../../../common/postgrest.js';
  const l =console.log;
  let events;
  async function load() {
    events = await select('events');
  }
  onMount(load);
  let newEvent={name:''};
  async function create() {
    await insert('events',newEvent);
  }
</script>

<input type='text' bind:value={newEvent.name}/>
<button on:click={create}>create</button>
{#if !events}
  loading
{:else}
  <h4>{events.length} events</h4>
{/if}

