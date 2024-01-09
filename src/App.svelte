<script>
  import { width, height } from './stores/dimensions';
  import Sunburst from "./components/Sunburst.svelte";


  $: console.log($width, $height)

  let text = "Web Annex C. WHO AWaRe (access, watch, reserve) classification of antibiotics for evaluation and monitoring of use, 2023. WHO; 2023."

</script>

<main
  bind:clientWidth={$width}
  bind:clientHeight={$height}
>
<div style="height: 97%; aspect-ratio:1;">
  <Sunburst />
</div>


<div class="citations">
  {text}
</div>

<div class="title">
WHO AWaRe <br>Classification of Antibiotics
<br>
<p class="credit">Viz by Rory White</p>
</div>


</main>
<style>
  main {
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: flex-start;
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
