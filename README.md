# Antibiotic AWaRe Visualization

## Introduction

This project visualizes the World Health Organization's AWaRe classification of antibiotics for evaluation and monitoring of use, [2023](https://www.who.int/publications/i/item/WHO-MHP-HPS-EML-2023.04). 

The AWaRe classification is crucial for understanding and monitoring the use of 257 different antibiotics and their potential to contribute to antibiotic resistance. 

This project brings this data to life through an interactive sunburst visualization, which can be explored here: [Antibiotic AWaRe Visualization](https://rorywhite200.github.io/antibiotic-aware-viz/).

<img src="https://github.com/rorywhite200/antibiotic-aware-viz/blob/main/example.gif" width="300"/>

## Creation

I used Svelte and D3 for their powerful capabilities in creating dynamic data visualizations. The sunburst mechanics are adapted from Mick Bostock's Observable Zoomable Sunburst [chart](https://observablehq.com/@d3/zoomable-sunburst), and written instead in Svelte's declarative style. 

I used R to convert the dataset into a hierachical JSON format for visualization.

## Citations

Bostock, Mike. “Zoomable Sunburst.” Observable. Available at: https://observablehq.com/@d3/zoomable-sunburst.

Web Annex C. WHO AWaRe (access, watch, reserve) classification of antibiotics for evaluation and monitoring of use, 2023. In: The selection and use of essential medicines 2023: Executive summary of the report of the 24th WHO Expert Committee on the Selection and Use of Essential Medicines, 24 – 28 April 2023. Geneva: World Health Organization; 2023 (WHO/MHP/HPS/EML/2023.04). Licence: CC BY-NC-SA 3.0 IGO.
