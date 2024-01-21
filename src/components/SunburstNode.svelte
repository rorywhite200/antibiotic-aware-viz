

<script>
    import { cubicInOut } from 'svelte/easing';
    import { tweened } from 'svelte/motion';

    export let d;
    export let arc_d3;
    export let color;
    export let fill_opacity;
    export let pointer_events
    export let handleClick;
    export let handleHover;
    export let handleSelection;

    let x0 = tweened(d.current.x0, { duration: 700, easing: cubicInOut });
    let x1 = tweened(d.current.x1, { duration: 700, easing: cubicInOut });
    let y0 = tweened(d.current.y0, { duration: 700, easing: cubicInOut });
    let y1 = tweened(d.current.y1, { duration: 700, easing: cubicInOut });

    $: {
        x0.set(d.current.x0);
        x1.set(d.current.x1);
        y0.set(d.current.y0);
        y1.set(d.current.y1);
    }

    // Reactive statement to generate path
    $: dPath = {
        x0: $x0,
        x1: $x1,
        y0: $y0,
        y1: $y1
    };


</script>

<path 
                d={arc_d3(dPath)}
                style="cursor: {d.children ? 'pointer' : 'default'}"
                fill={color}
                fill-opacity={fill_opacity}
                pointer-events={pointer_events}
                on:click={() => {
                    handleSelection(d.data.name)
                    if (d.children) {
                        handleClick(d)
                    }
                }}
                on:mouseover={handleHover(d)}
                on:mouseout={handleHover(null)}
            >
</path>


<style>
    path {
        transition: fill-opacity 500ms;
    }
</style>