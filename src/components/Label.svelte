<script>
    import { cubicInOut } from 'svelte/easing';
    import { tweened } from 'svelte/motion';
    
    export let dy;
    export let fill_opacity;
    export let title;
    export let d;
    export let radius;
    export let fontSize;

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

    function labelTransform(x0, x1, y0, y1) {
        const x = (x0 + x1) / 2 * 180 / Math.PI;
        const y = (y0 + y1) / 2 * radius;
        return `rotate(${x - 90}) translate(${y},0) rotate(${x < 180 ? 0 : 180})`;
    }
    
</script>


<text dy={dy}  font-size={fontSize} fill-opacity={fill_opacity} transform={labelTransform($x0, $x1, $y0, $y1)}>
    {title}
</text>


<style>
    text {
        transition: fill-opacity 700ms;
    }
</style>


