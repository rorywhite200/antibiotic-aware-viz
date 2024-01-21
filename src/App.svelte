<script>
  import { width, height } from './stores/dimensions';
  import Sunburst from "./components/Sunburst.svelte";
  import ControlPanel from "./components/ControlPanel.svelte";
  import {rootStore} from "./stores/rootStore.js";
  import { onMount } from 'svelte';

  $: smallScreen = $width < 600;
  $: mediumScreen = $width < 1000;
  $: selectedAntibiotic = null;
  $: selectedAntibioticWHOStatus = null;
  $: selectedAntibioticEssential = null;


  $: showMainPanel = false;

  let antibioticsList = [];

  $rootStore.each((d) => {
      if (!d.children) {
        antibioticsList.push(d.data.name)
      }
    })
  
    antibioticsList.sort()


  function handleSelection(input) {
    let antibioticName;
    if (input.target && antibioticsList.includes(input.target.value)) {
      antibioticName = input.target.value;
    } else if (antibioticsList.includes(input)) {
      antibioticName = input;
    } else {
      antibioticName = null;
    }
    selectedAntibiotic = antibioticName;

    if (selectedAntibiotic) {
      selectedAntibioticWHOStatus = $rootStore.descendants().find(d => d.data.name == selectedAntibiotic).parent.data.name;

      if ($rootStore.descendants().find(d => d.data.name == selectedAntibiotic).data.EML == "Yes") {
        selectedAntibioticEssential = true;
      } else {
        selectedAntibioticEssential = false;
      }
    } else {
      selectedAntibioticWHOStatus = null;
    }
  }

 function handleSVGclick() {
    showMainPanel = !showMainPanel;
 }

</script>

<main
  bind:clientWidth={$width}
  bind:clientHeight={$height}
>
<div style="height: 95%; max-width: {mediumScreen ? "93vw": "50vw"}; aspect-ratio:1; padding-top: 0.5rem;">
  <Sunburst handleSelection={handleSelection} selectedAntibiotic={selectedAntibiotic} smallScreen={smallScreen}/>
</div>

{#if mediumScreen}
  <svg class={showMainPanel ? "menu-bars-svg rotated rotate" : "menu-bars-svg rotate"} on:click={handleSVGclick} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><!-- Font Awesome Pro 5.15.4 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) --><path d="M16 132h416c8.837 0 16-7.163 16-16V76c0-8.837-7.163-16-16-16H16C7.163 60 0 67.163 0 76v40c0 8.837 7.163 16 16 16zm0 160h416c8.837 0 16-7.163 16-16v-40c0-8.837-7.163-16-16-16H16c-8.837 0-16 7.163-16 16v40c0 8.837 7.163 16 16 16zm0 160h416c8.837 0 16-7.163 16-16v-40c0-8.837-7.163-16-16-16H16c-8.837 0-16 7.163-16 16v40c0 8.837 7.163 16 16 16z"/></svg>
  {/if}

  {#if showMainPanel || !mediumScreen}
  <ControlPanel selectedAntibioticEssential={selectedAntibioticEssential} antibioticsList={antibioticsList} handleSelection={handleSelection} selectedAntibiotic={selectedAntibiotic} selectedAntibioticWHOStatus={selectedAntibioticWHOStatus} mediumScreen={mediumScreen} smallScreen={smallScreen}/>
  {/if}
</main>
<style>


  main {
    display: flex;
    height: 100vh;
    padding-left: 4%;
    margin: 0;
    justify-content: space-between;
    align-items: center;
    font-family: "lorimer-no-2", sans-serif;
    overflow: hidden;
    background-image: linear-gradient(315deg, #d5ddf8, #fff 57%);
  }

  .menu-bars-svg {
      position: absolute;
      top: 1rem;
      right: 1rem;
      width: 2rem;
      height: 2rem;
      margin: 1rem;
      cursor: pointer;
      z-index: 100;
      fill: rgb(192, 192, 192);
    }

    .rotate {
  transform-origin: center; /* Adjust as needed */
  transition: transform 0.2s ease; /* Smooth transition for rotation */
}

.rotated {
  transform: rotate(90deg); /* Rotate 90 degrees; adjust angle as desired */
}


</style>
