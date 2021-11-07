<script>
  import { parseToken, authDataStore } from '../lib/stores.js'
  import { page } from '$app/stores'  
  const l = console.log;
  parseToken()  
  let auth;
  authDataStore.subscribe((value) => (auth = value))
  $: l('$authDataStore',auth);
  $: l('$page=',$page);
  let current;
  $: {
    current = $page && $page.path?$page.path.split('/')[1]:null;
    l('current=',current);
  }
</script>
<style>
	main {
		position: relative;
		max-width: 56em;
		background-color: white;
		padding: 2em;
		margin: 0 auto;
		box-sizing: border-box;
	}
</style>

<nav>
    <a href="/">home</a> ::  
    <a href="/sources">attendee lists</a> ::
    <a href="/events">events</a> ::
    <a href="/auth">auth</a> {#if auth}({auth.email}){/if}
  </nav>
<main>
  {#if auth && !auth.validated && current!=='auth'}
    <p>please <a href="/auth">validate your account</a>.</p>
  {:else}
    <slot></slot>
  {/if}
</main>
