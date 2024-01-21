<script>
    $: whoContent = whoType == "Access" ? ["first or second choice antibiotics", "offer the best therapeutic value, while minimizing the potential for resistance"] : whoType == "Watch" ? ["first or second choice antibiotics", "only indicated for specific, limited number of infective syndromes", "more prone to be a target of antibiotic resistance and thus prioritized as targets of stewardship programs and monitoring"] : ["“last resort”", "highly selected patients (life-threatening infections due to multi-drug resistant bacteria)", "closely monitored and prioritized as targets of stewardship programs to ensure their continued effectiveness"];
    $: whoType = "Access";
    $: panelStyle = !mediumScreen? "position: relative; height: 100vh; max-width: 50%; width: 33%;" : "height: 100vh; position: absolute !important; left: -2rem; width: 100%; box-sizing: border-box;"
    import {rootStore} from "../stores/rootStore.js";
    import { fade } from 'svelte/transition';

    
    export let smallScreen = false;
    export let mediumScreen = false;
    export let selectedAntibiotic = null;
    export let handleSelection = null;
    export let selectedAntibioticWHOStatus = null;
    export let selectedAntibioticEssential = null;
    export let antibioticsList = [];

    let clientHeight = 0;

  </script>
  
  <div class="left-panel" bind:clientHeight in:fade={{ duration: 300 }} style={panelStyle}>

    
    <img width={clientHeight/2} class="diagram" src="diagram.png" alt="Description" />

      <div class="top-flex" style="flex-shrink: 1;">
      <h1>ANTIBIOTICS AWaRe TOOL</h1>
      <div class="combined-container">
    
      <input class="search-bar" list="antibiotics" type="text" placeholder="Search for an antibiotic..." value={selectedAntibiotic} on:focus={() => selectedAntibiotic = null} on:input={handleSelection}/>
      <datalist id="antibiotics">
        {#each antibioticsList as antibiotic}
          <option value={antibiotic} />
        {/each}
      </datalist>  
      
       {#if selectedAntibiotic}
    <div class="antibiotic-description">
        {#each $rootStore.descendants().slice(1) as d}
          {#if d.data.name == selectedAntibiotic}
            <p>{d.data.description}</p>
          {/if}
        {/each}
    </div>
    {/if}
    
      
    </div>
    
    {#if !selectedAntibiotic}
      <h2>AWaRe Category Definitions (Source: WHO):</h2>
          <div class="WHO-descriptions">
            <div style="display: flex; justify-content: flex-start;">
            <h2 style="opacity: {whoType == "Access" ? 1 : 0.2}; background: #77B48E" on:click={()=> whoType = "Access"}>Access</h2>
            <h2 style="opacity: {whoType == "Watch" ? 1 : 0.2}; background: #E9D17A" on:click={()=> whoType = "Watch"}>Watch</h2>
            <h2 style="opacity: {whoType == "Reserve" ? 1 : 0.2}; background: #E56F7B" on:click={()=> whoType = "Reserve"}>Reserve</h2>
          </div>
          <ul>
            {#each whoContent as content}
              <li>{content}</li>
            {/each}
          </ul>
          </div>
    
    {/if}
    
    {#if selectedAntibiotic}
    <div class="badges-container">
      <div class="badge" 
      style="background: {selectedAntibioticWHOStatus == "Access" ? "#77B48E" : selectedAntibioticWHOStatus == "Watch" ? "#E9D17A" : selectedAntibioticWHOStatus == "Reserve" ? "#E56F7B" : "white"}">
      {selectedAntibioticWHOStatus}</div>
      {#if selectedAntibioticEssential}
      <div class="badge" style="background: #4899A8">WHO Essential Drug</div>
      {/if}
    </div>
    {/if}
    <div>
    
    </div>
    
    </div>
    <div class ="credits" style="font-size: 0.9rem; background: #D6D6D6; position: absolute; bottom: 0; left: 0; padding: 0.1rem 3rem 2rem 3rem; color: #393030;">
    <h2>Credits</h2>
    <p style="line-height: 1.5; padding-right: 0.5rem;">This website was created by Rory White using Svelte and d3/js. Data was sourced from the <a href="https://www.who.int/publications/i/item/WHO-MHP-HPS-EML-2023.04">WHO AWaRe Classification 2023.</a>
    Antibiotic descriptions are from the <a href="https://go.drugbank.com">Drugbank</a> database (Attribution-NonCommercial 4.0 International) and Wikipedia. Text descriptions of the WHO AWaRe categories are from the <a href="https://aware.essentialmeds.org/groups">AWaRe website.</a> The visualization mechanics were adapted from Mike Bostock's Zoomable Sunburst.</p> 
    </div>
    
    
    </div>
  
    <style>

  .diagram {
    position: absolute;
    bottom: 4rem;
    right: -5rem;
    opacity: 0.3;
  }
    .left-panel {
   padding: 0 3rem;
    background-color: #444141;
    box-shadow: 0 19px 38px rgba(0, 0, 0, 0.30), 0 15px 12px rgba(0, 0, 0, 0.22);
    margin-left: 2rem;
    padding-top: 3rem;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: width 0.5s ease; /* Smooth transition for rotation */
  }
  
  h1 {
    color: rgb(214, 214, 214);
    font-family: "vox", sans-serif;
  font-weight: 400;
  font-size: 1.8rem;
  font-style: normal;
  white-space: nowrap;
  }
    
  .badges-container {
    display: flex;
    flex-direction: row;
    justify-content: flex-start;
  }
  
  .badge {
    color: white;
    color: #444141;
    border-radius: 20px;
    padding: 0.5rem 1rem;
    margin-right: 1rem;
    font-size: 1rem;
    font-weight: 300;
    font-family: "lorimer-no-2", sans-serif;
    box-shadow: 0 20px 30px -10px #26394d;
  }
  
  
  .combined-container {
      max-height: 320px;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      max-width: 100%;  
      margin-bottom: 1rem;
      max-height: 60%;
      
    }
    
    
      .antibiotic-description {
        position: relative;
        font-size: 1.2rem;
        overflow-y: scroll;
        color: #D6D6D6;
        font-weight: 300;
        max-height: 165px;
    }
      
    
      .search-bar {
        font-family: "lorimer-no-2", sans-serif;
        font-size: 1.5rem;
        font-weight: bold;
        color: rgb(43, 44, 44);
        background-color: rgba(255, 255, 255, 0);
        border: none;
        border-radius: 20px;
        padding: 0.5rem 0;
        width: 80%;
        color: white;
      }
    
      li {
        color: rgb(192, 192, 192);
        margin-bottom: 0.5rem;
      }
    
      input:focus {
        outline: none;
    }
    
    .top-flex h2 {
      font-size: 1.2rem;
      font-weight: 300;
      color: rgb(192, 192, 192);
      margin-bottom: 0.5rem;
    }
    
    .WHO-descriptions h2{
      width: fit-content;
      height: fit-content;
      padding: 0.3rem 1rem;
      border-radius: 20px;
      font-size: 1.2rem;
      color: #444141;
      margin-right: 1rem;
      cursor: pointer;
    }
    
    
    .WHO-descriptions {
      overflow: scroll;
      max-height: 64%;
    }
    
    .credits {
      min-height: fit-content;
      max-width: calc(100% - 6rem);
    }
    
  </style>