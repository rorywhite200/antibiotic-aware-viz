<script>
  import { width, height } from './stores/dimensions';
  import Sunburst from "./components/Sunburst.svelte";


  $: console.log($width, $height)

</script>

<main
  bind:clientWidth={$width}
  bind:clientHeight={$height}
>
<div style="height: 95%; aspect-ratio:1;">
  <Sunburst />
</div>

</main>
<style>
  main {
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
  }

</style>
