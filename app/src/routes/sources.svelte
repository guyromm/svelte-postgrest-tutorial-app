<script>
  import {onMount} from 'svelte';
  import {select,insert,del,update} from '../../../common/postgrest.js';
  import vars from '$lib/variables.js';
  const l = console.log;
  const e = console.error;
  const DISCOVERY_DOCS = ["https://sheets.googleapis.com/$discovery/rest?version=v4"];
  const SCOPES = "https://www.googleapis.com/auth/drive"; // spreadsheets"; // readonly";


  let sources;
  async function load() {
    try {
      message= 'Loading';
      sources = await select('attendees_sources',
			     {select:'*,attendees(*),events(*)',
			      order:'ts.desc'})
      message='Loaded';
    } catch (err) {
      message=err.toString();
    }

  }
  onMount(load);


  function handleClientLoad() {
    gapi.load('client:auth2', initClient);
  }

  let signedIn=false;
  
  function updateSigninStatus(isSignedIn) {
    signedIn=true;
  }
      /**
       *  Initializes the API client library and sets up sign-in state
       *  listeners.
       */
  async function initClient() {
    await gapi.client.init({
      apiKey: vars.API_KEY,
      clientId: vars.CLIENT_ID,
      discoveryDocs: DISCOVERY_DOCS,
      scope: SCOPES
    });
    // Listen for sign-in state changes.
    gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);
    // Handle the initial sign-in state.
    updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
    //authorizeButton.onclick = handleAuthClick;
    //signoutButton.onclick = handleSignoutClick;
  }
  
  function onload() {
    handleClientLoad();
  }

  window.gapi_onload = onload;
  
  let busy={};
  let data={};
  
  async function loadContents(sheetId,s) {
    busy[sheetId]=true;
    let o;
    try {
      o = await gapi.client.sheets.spreadsheets.get({spreadsheetId:sheetId});
    } catch (err) {
      message=JSON.stringify(err); //.toString();
      busy[sheetId]=false;
      return;
    }

    if (!s)
    {
      try {
	s = (await (await insert('attendees_sources',{name:o.result.properties.title,
						      google_sheet_id:sheetId,
						     })).json())[0];
      } catch (err) {
	busy[sheetId]=false;
	message=err.toString();
	return;
      }
      l('source inserted',s);      
    }
    else
      l('using existing source',s);

    
    l('o=',o);
    
    let r = await gapi.client.sheets.spreadsheets.values.get({spreadsheetId:sheetId,
                                                              range:'A1:Z999'});
    l('loadContents response',r);
    let range=r.result.range;
    let header=[];
    let values=[];
    if (r.result.values && r.result.values.length)
    {
      header = r.result.values[0];
      values = r.result.values.slice(1);
    }
    let dictValues = [];
    for (let vr of values)
    {
      let nr = Object.fromEntries(vr.map((vrv,idx)=>([header[idx]?header[idx]:'column-'+idx,vrv])));
      dictValues.push(nr);
    }
    l('range',range);
    l('values',dictValues);
    data[sheetId]={range,header,dictValues};
    
    busy[sheetId]=false;
    //recalcDataState();

    try {
      l('existing attendees',s.attendees);
      const exemails = [...new Set(s.attendees?s.attendees.map(a=>a.email):[])];
      const exsnames = s.attendees?s.attendees.map(a=>a.name):[];
      const exnames = [...new Set(
	(s.attendees?s.attendees.map(a=>`${a.first_name} ${a.last_name}`):[]).concat(exsnames)
      )];
      l('exemails',exemails);
      l('exnames',exnames);
      const shouldInsert = a=>{
	if (!Object.keys(a).length) return false;
	const rt =  (!exemails.includes(a.email) && !exnames.includes(`${a.first_name} ${a.last_name}`))
	l('checking if',a,':',a.email,'or',a.first_name,a.last_name,'is present already =>',rt);
	return rt;
      }
      const fieldMapper = meta=>{
	let rt = {attendee_source_id:s.id,
		  meta,
		  first_name:meta.first_name,
		  last_name:meta.last_name,
		  email:meta.email};
	if (!rt.first_name && !rt.last_name && meta.name)
	{
	  rt.first_name = meta.name.split(' ')[0];
	  rt.last_name = meta.name.split(' ').slice(1).join(' ');
	}
	return rt;
      }
      
      const toins = dictValues
		   .filter(shouldInsert)
		   .map(fieldMapper);
      for (let i of toins)
	await insert('attendees',i);
      //await insert('attendees',toins);
    } catch (err) {
      busy[sheetId]=false;
      message=err.toString();
      throw err;
      return;
    }
    await load();
  }
  let newSheetId=vars.DEFAULT_INGEST_SHEET_ID;
  function ingest() {
    loadContents(newSheetId);
  }
  async function delSource(sid) {
    if (!confirm(`Really delete source ${sid}?`)) return;
    await del('attendees_sources',{id:'eq.'+sid});
    await load();
  }
  let message='';
  async function signOut() {
    await gapi.auth2.getAuthInstance().signOut();
    updateSigninStatus(false);
  }
  async function signIn() {
    await gapi.auth2.getAuthInstance().signIn();
    updateSigninStatus(true);
  }
</script>
<style>
  .ralign { text-align:right; }
</style>
<svelte:head>
  <script async defer
src="https://apis.google.com/js/api.js"
	  onload={onload}
	  onerror={(e)=>alert('error loading gapi',e)}
	  onreadystatechange="if (this.readyState === 'complete') this.onload(); else alert('wtf');z"
    >
  </script>
</svelte:head>
[ signed in: {signedIn}

<button on:click={signIn}>sign in</button> | 

<button on:click={signOut}>sign out</button>  

<input type='text' placeholder='please enter a google sheet id here' bind:value={newSheetId}/><button on:click={ingest}>ingest</button>
<b>please provide a sheet with the fields: email & name (or: first_name, last_name)</b>
{message}

  ]<hr/>
{#if sources}
  <h4>{sources.length} sources</h4>
  <table>
    <thead>
      <tr>
	<th>id</th>
	<th>name</th>
	<th class='ralign'>attendees</th>
	<th class='ralign'>events</th>
	<th>sheet link</th>
	<th>actions</th>
      </tr>
    </thead>
  {#each sources as s}
    <tr>
      <td>{s.id}</td>
      <td><input type='text' bind:value={s.name} on:change={()=>update('attendees_sources',{id:s.id,name:s.name})}/></td>
      <td class='ralign'><a href={`/attendees?src=${s.id}`}>{s.attendees.length}</a></td>
      <td class='ralign'><a href={`/events?src=${s.id}`}>{s.events.length}</a></td>
      <td><a target='_blank'
	     href={`https://docs.google.com/spreadsheets/d/${s.google_sheet_id}/edit`}>${s.google_sheet_id}</a></td>
      <td>
	<button on:click={()=>delSource(s.id)}>delete</button>
	<button on:click={()=>loadContents(s.google_sheet_id,s)}>sync</button>
      </td>
    </tr>
  {/each}
</table>
  
{/if}

