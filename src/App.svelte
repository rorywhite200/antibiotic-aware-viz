<script>
  import { width, height } from './stores/dimensions';
  import Sunburst from "./components/Sunburst.svelte";
  import {rootStore} from "./stores/rootStore.js";
    import { select } from 'd3';


  $: console.log($width, $height)

  $: mobile = $width < 800;

  $: smallScreen = $width < 600;

  $: selectedAntibiotic = null;

  function resetSelectedAntibiotic() {
    selectedAntibiotic = null;
  }

  let text = "Web Annex C. WHO AWaRe (access, watch, reserve) classification of antibiotics for evaluation and monitoring of use, 2023. WHO; 2023."


  let antibioticsList = [];

  let antibiotics = $rootStore.each((d) => {
    if (!d.children) {
      antibioticsList.push(d.data.name)
    }
    antibioticsList.sort()
  })

  function handleSelection(event) {
    selectedAntibiotic = event.target.value;
  }
    
</script>

<main
style="margin-top:{smallScreen ? '2rem' : '0px'};}"
  bind:clientWidth={$width}
  bind:clientHeight={$height}
>
<div style="height: 98%; max-width: 95vw; aspect-ratio:1;">
  <Sunburst selectedAntibiotic={selectedAntibiotic} resetSelectedAntibiotic={resetSelectedAntibiotic} smallScreen={smallScreen}/>
</div>

<div style="right: {mobile ? "" : "5rem"}; top: {mobile ? "" : "1rem"}; bottom: {mobile ? "8%" : ""}; width: {mobile ? "60%" : "200px"}" class="search-div">
  {#if !mobile}
  <input class="search-bar" list="antibiotics" type="text" placeholder="Search for an antibiotic" value={selectedAntibiotic} on:input={handleSelection}/>
  <datalist id="antibiotics">
    {#each antibioticsList as antibiotic}
      <option value={antibiotic} />
    {/each}
  </datalist>  
  {/if}
   {#if mobile}
   <select class="search-bar">
      {#each antibioticsList as antibiotic}
        <option value={antibiotic} on:input={handleSelection}>{antibiotic}</option>
      {/each}
</select>
   {/if}
  
</div>

<div class="citations">
  {text}
</div>
{#if !mobile}
<div class="title">
WHO AWaRe <br>Classification of Antibiotics
<br>
<p class="credit">Viz by Rory White</p>
</div>
{/if}


</main>
<style>
  main {
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    font-family: "lorimer-no-2", sans-serif;
  }

  .credit {
    font-size: 0.9rem;
    font-family: "lorimer-no-2", sans-serif;
    color: rgb(41, 38, 38);
  }
  .title {
    font-family: "lorimer-no-2", sans-serif;
    position: absolute;
    top: 1rem;
    left: 1rem;
    font-size: 1.5rem;
    padding: 0.5rem;
    color: grey;
    z-index: -1;
  }

  .search-div {
    position: absolute;
    display: flex;
    flex-direction: column;
    align-items: center;
    z-index: 1;
    width: 200px;
  }

  .search-bar {
    font-family: "lorimer-no-2", sans-serif;
    font-size: 20px;
    width: 100%;
    color: rgb(43, 44, 44);
    padding: 0.5rem 1rem;
    border-radius: 10px;
    border: 1px solid rgb(88, 87, 87);
    background-color: rgb(233, 233, 233);
  }

  datalist#antibiotics {
    max-height: 50px !important;
  }

  .citations {
    font-family: "lorimer-no-2", sans-serif;
    position: absolute;
    bottom: 1rem;
    right: 1rem;
    width: 150px;
    font-size: 0.6rem;
    padding: 0.5rem;
    color: grey;
    z-index: -1;
  }


</style>
