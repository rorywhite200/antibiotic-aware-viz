import { writable } from 'svelte/store';
import { hierarchy, partition } from 'd3';
import flareData from "./antibiotics.json";

let nodeId = 0; // Initialize a counter for node IDs

function addIds(node) {
    node.id = nodeId;
    nodeId++;
    if (node.children) {
        node.children.forEach(addIds); // Recursively add IDs to children
    }
}


function createHierarchy(data) {

    const root = hierarchy(data)

    root.sum(d => d.value).sort((a, b) => b.value - a.value);

    addIds(root);

    return root;
}

const initialRoot = createHierarchy(flareData);

export const rootStore = writable(partition().size([2 * Math.PI, initialRoot.height + 1])(initialRoot));

