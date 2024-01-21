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
  
  <div bind:clientHeight class="left-panel" in:fade={{ duration: 300 }} style={panelStyle}>

    
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
    <div class ="credits" style="width: 100vw; font-size: 0.9rem; background: #D6D6D6; position: {mediumScreen ? "relative" : "absolute"}; bottom: 0; left: 0; padding: 0.1rem 3rem 2rem 3rem; color: #393030;">
    
    <div class="logo-flex" style="display: flex; align-items: center; height: fit-content; line-height: 1;">
      <h2 style="margin-right: 1rem;">Credits</h2> 
      <a href="https://github.com/rorywhite200/antibiotic-aware-viz" target="_blank">
      <svg width="25" height="25" viewBox="0 0 98 96" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z" fill="#24292f"/></svg>
    </a>
    <a href="https://www.linkedin.com/in/rory-white-5a954819a/" target="_blank">
    <svg height="25" viewBox="0 0 72 72" width="25" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><path d="M8,72 L64,72 C68.418278,72 72,68.418278 72,64 L72,8 C72,3.581722 68.418278,-8.11624501e-16 64,0 L8,0 C3.581722,8.11624501e-16 -5.41083001e-16,3.581722 0,8 L0,64 C5.41083001e-16,68.418278 3.581722,72 8,72 Z" fill="#007EBB"/><path d="M62,62 L51.315625,62 L51.315625,43.8021149 C51.315625,38.8127542 49.4197917,36.0245323 45.4707031,36.0245323 C41.1746094,36.0245323 38.9300781,38.9261103 38.9300781,43.8021149 L38.9300781,62 L28.6333333,62 L28.6333333,27.3333333 L38.9300781,27.3333333 L38.9300781,32.0029283 C38.9300781,32.0029283 42.0260417,26.2742151 49.3825521,26.2742151 C56.7356771,26.2742151 62,30.7644705 62,40.051212 L62,62 Z M16.349349,22.7940133 C12.8420573,22.7940133 10,19.9296567 10,16.3970067 C10,12.8643566 12.8420573,10 16.349349,10 C19.8566406,10 22.6970052,12.8643566 22.6970052,16.3970067 C22.6970052,19.9296567 19.8566406,22.7940133 16.349349,22.7940133 Z M11.0325521,62 L21.769401,62 L21.769401,27.3333333 L11.0325521,27.3333333 L11.0325521,62 Z" fill="#FFF"/></g></svg>
  </a>
    </div>
    <p style="margin-top: 0; line-height: 1.5; padding-right: 0.5rem;">This website was created by Rory White using Svelte and d3/js. Data was sourced from the <a href="https://www.who.int/publications/i/item/WHO-MHP-HPS-EML-2023.04">WHO AWaRe Classification 2023.</a>
   Antibiotic descriptions are from the <a href="https://go.drugbank.com">Drugbank</a> database (Attribution-NonCommercial 4.0 International) and Wikipedia. Text descriptions of the WHO AWaRe categories are from the <a href="https://aware.essentialmeds.org/groups">AWaRe website.</a> The visualization mechanics were adapted from Mike Bostock's Zoomable Sunburst.</p> 
    </div>
    
    
    </div>
  
    <style>


.credits svg {
  cursor: pointer;
  opacity: 0.8;
}

.logo-flex a {
  margin-right: 1rem;

}

  .diagram {
    position: absolute;
    bottom: 4rem;
    right: -5rem;
    opacity: 0.3;
  }
    .left-panel {
   padding: 0 3rem;
    background-color: #3C414C;
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