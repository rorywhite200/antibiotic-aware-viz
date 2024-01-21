<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->

<script>
    import { arc } from "d3";
    import SunburstNode from './SunburstNode.svelte'; 
    import Label from './Label.svelte';
    import { rootStore } from '../stores/rootStore.js';
    
    export let smallScreen = false;
    export let selectedAntibiotic = null;
    export let handleSelection = null;

    let width = 1000;
    let height = 1000;

    $: hoveredItem = null;

    $: radius = width / 6;

    let lastClickedNodeId = 0

    let lastClickedNode = $rootStore.descendants().find(d => d.id == lastClickedNodeId);

   $rootStore.each(d => d.current = d);

   $: prevSelectedAntibiotic = "";

   $: if (selectedAntibiotic != null && selectedAntibiotic != prevSelectedAntibiotic) {
    let selectedNode = $rootStore.descendants().find(d => d.data.name == selectedAntibiotic);
    if (selectedNode && selectedNode.parent) {
        handleClick(selectedNode.parent);
    }
    prevSelectedAntibiotic = selectedAntibiotic;
    }

    $: arc_d3 = arc()
      .startAngle(d => d.x0)
      .endAngle(d => d.x1)
      .padAngle(d => Math.min((d.x1 - d.x0) / 2, 0.005))
      .padRadius(radius * 1.5)
      .innerRadius(d => d.y0 * radius)
      .outerRadius(d => Math.max(d.y0 * radius, d.y1 * radius - 1))

    function arcVisible(d) {
        return d.y1 <= 3 && d.y0 >= 1 && d.x1 > d.x0;
    }

    function labelVisible(d) {
        return d.y1 <= 3 && d.y0 >= 1 && (d.y1 - d.y0) * (d.x1 - d.x0) > 0.01;
    }

    function handleClick(p) {

        if (p.parent == lastClickedNode.parent) {
            return;
        }

        lastClickedNodeId = p.id;
        lastClickedNode = $rootStore.descendants().find(d => d.id == lastClickedNodeId)

        rootStore.update(root => {

            root.each(d => d.current = {
                x0: Math.max(0, Math.min(1, (d.x0 - p.x0) / (p.x1 - p.x0))) * 2 * Math.PI,
                x1: Math.max(0, Math.min(1, (d.x1 - p.x0) / (p.x1 - p.x0))) * 2 * Math.PI,
                y0: Math.max(0, d.y0 - p.depth),
                y1: Math.max(0, d.y1 - p.depth)
            })

        return root;
    })
     
}

    function getColor(d) {
        let node = d;
        if (node.data.name == "Access" || node.parent.data.name == "Access") return "#32965D";
        if (node.data.name == "Watch" || node.parent.data.name == "Watch") return "#E0BE36";
        if (node.data.name == "Reserve" || node.parent.data.name == "Reserve") return "#D52941";

        while (node.depth > 1) node = node.parent;
        if (node.data.name == "Beta-Lactams") return "#EBEBEB"
        if (node.data.name == "Other") return "#DAD2D8"
        
    }

    function getFillOpacity(d) {

        if (!arcVisible(d.current)) {
            return 0;
        } else if (d.depth == 1) {
            return 0.8
        } else if (d.depth == 2) {
            return 0.6
        } else if (!d.children) {
            return 0.4
        } else 
            return 0.6;
    }

    function findTopLevelParent(node) {
        while (node.depth > 1) node = node.parent;
        return node;
    }

    function getPath(node) {
        let path = []
        while (node.depth > 0) {
            node = node.parent;
            path.unshift(node.data.name)
        }
        return path.join('/');
    }

    function handleHover(d) {
        if (!d) {
            hoveredItem = null;
        } else if
         (d.children) {
            hoveredItem = null;
        } else {
            hoveredItem = d;
        }
    }

    $: viewBox = `${width / -2} ${height / -2} ${width} ${height}`;

</script>

<svg viewBox={viewBox}>

    <g>
        {#each $rootStore.descendants().slice(1) as d}
        <SunburstNode
        color = {getColor(d)}
        d = {d}
        handleHover = {handleHover}
        arc_d3 = {arc_d3}
        fill_opacity= {selectedAntibiotic && d.data.name != selectedAntibiotic ? 0.1 
        : selectedAntibiotic && d.data.name == selectedAntibiotic ? 0.7 : getFillOpacity(d)}
        pointer_events={arcVisible(d.current) ? "auto" : "none"}
        handleClick={handleClick}
        handleSelection={handleSelection}
        >
        </SunburstNode>
        {/each}
    </g>

    <g pointer-events="none" text-anchor="middle" style="user-select: none">
        {#each $rootStore.descendants().slice(1) as d}
        <Label dy="0.35em" radius={radius} fontSize={smallScreen ? "29px" : "20px"} fill_opacity={+labelVisible(d.current)} d={d} title={d.data.name}></Label>
        {/each}
    </g>

    <circle 
        r={radius}
        fill = "white"
        pointer-events="auto"
        style="cursor: pointer;"
        on:click={() => {
            lastClickedNode.parent ? handleClick(lastClickedNode.parent) : null
            lastClickedNode.parent ? handleSelection(lastClickedNode.parent.data.name) : handleSelection(lastClickedNode.data.name)
            }}
        on:mouseover={() => {hoveredItem = null}}
    />

    {#if !hoveredItem}
    <text class="middle-text" text-anchor="middle" font-size={smallScreen ? "55px" : "35px"} dominant-baseline="middle" pointer-events="none">
        {lastClickedNode.data.name}
    </text>
    
    {#if lastClickedNode.depth > 0}
    <text class="small-text" text-anchor="lower" font-size={smallScreen ? "30px" : "20px"} dominant-baseline="middle" pointer-events="none" y="40">
        ⏎  {getPath(lastClickedNode)}
    </text>
    {/if}
    {/if}
    {#if hoveredItem}
    <text class= "hover-text" text-anchor="middle" font-size={smallScreen ? "50px" : "35px"} dominant-baseline="middle" pointer-events="none">
        {hoveredItem.data.name}
    </text>
    {/if}

</svg>


<style>

    svg {
        font-size: 20px;
        font-family: "lorimer-no-2", sans-serif;
    font-weight: 300;
        fill: rgb(68, 68, 68);
   -webkit-user-select: none;
   -moz-user-select: none;
   -ms-user-select: none;
   user-select: none;
   overflow: visible;
   pointer-events: none;
}

.middle-text {
    font-family: "alternate-gothic-condensed-a", sans-serif;
    font-weight: 500;
    text-anchor: middle;

    fill: #525252
}

.small-text {
    font-family: "lorimer-no-2", sans-serif;
    fill: rgb(131, 131, 131);
    font-weight: 300;
    text-anchor: middle;
}

.hover-text {
    text-anchor: middle;
}

</style>