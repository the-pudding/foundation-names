<script>
    import { getContext } from 'svelte';
    import { groups } from 'd3-array';
    import Controller from './Controller.svelte'
import Explore from './Explore.svelte';
    
    const { data, width, height, xScale } = getContext('LayerCake')
    export let blockDimensions;
    export let options;
    export let lineData;
    export let title;

    let controllerContainer;
    let exploreSwatches = false;
    let found = ''
    let groupActive = false;
    let takeoverKeys = true;
    $: groupedData = groups($data, d => d.binStart)
    $: totalGroups = groupedData.length
    let currentGroup = 0
    let ind = 0
    let wordIndex = 0;
    let explore = false;
  

    function handleKeyDown(event){
        const key = event.key;
        explore = true;

        // key bindings for histograms
        if (options.includes('histogram') || options.includes('natural') || options.includes('line')){
            if (key === 'ArrowRight') {
                let newGroup = currentGroup < totalGroups - 1 ? currentGroup + 1 :  0;
                currentGroup = newGroup
                found = ''
                groupActive = true;
                takeoverKeys = true;
                exploreSwatches = false;
            }
            else if (key === 'ArrowLeft') {
                let newGroup = currentGroup === 0 ? totalGroups - 1 : currentGroup - 1 
                currentGroup = newGroup
                found = ''
                groupActive = true;
                takeoverKeys = true;
                exploreSwatches = false;
            }
            else if (key === 'Shift' && key === 'Tab' || key === 'Escape' || key === 'Tab') {
                exploreSwatches = false;
                controllerContainer.focus();
                groupActive = false;
                takeoverKeys = false;
            }
            else if (key === 'ArrowUp' || key === 'ArrowDown'){
                exploreSwatches = true;
                const swatches = groupedData[currentGroup][1]
                const total = swatches.length - 1
                groupActive = false;
                takeoverKeys = true;
                if (key === 'ArrowUp'){
                    // if index is greater than total, start at the total
                    // if the index is equal to the total, go back to 0 otherwise, add one
                    // otherwise, add one
                    let newIndex;
                    if (ind > total) newIndex = total;
                    else if (ind === total) newIndex = 0;
                    else newIndex = ind + 1
                    ind = newIndex 
                    found = swatches[newIndex]
                } else {
                    // if index is greater than total, start at the total
                    // if it's equal to 0, go to the total
                    // otherwise, subtract one
                    let newIndex;
                    if (ind > total || ind === 0) newIndex = total
                    else newIndex = ind - 1
                    ind = newIndex
                    found = swatches[newIndex]
                }
            }
            else {
                exploreSwatches = false
                takeoverKeys = false
            }       
            console.log({exploreSwatches})

        }

        // key bindings for word wall
        else if (options.includes('wordwall')){
            const totalWords = $data.length - 1
            // right and down arrows
            if (key === 'ArrowRight' || key === 'ArrowDown'){
                const newWordIndex = wordIndex === totalWords ? 0 : wordIndex + 1
                wordIndex = newWordIndex
            }
            // left and up arrows
            if (key === 'ArrowLeft' || key === 'ArrowUp'){
                const newWordIndex = wordIndex === 0 ? totalWords : wordIndex - 1
                wordIndex = newWordIndex
            }
        }
        if (takeoverKeys === true) event.preventDefault();
    }

    function clearKeyboard(){
        takeoverKeys = false;
        groupActive = false;
        exploreSwatches = false;
        explore = false;
    }

    function createAccessibleTitle(title, options){
        if (options.includes('histogram')){
            return `Histogram showing ${title}, sorted from dark to light. Graph contains ${totalGroups} columns. Navigate between columns using LEFT and RIGHT arrows and explore swatches within each column using UP and DOWN. Use ESCAPE to exit.`
        }
        else if (options.includes('line')){
            return `Overlapping area chart showing distribution of ${title} compared to all shades, sorted from dark to light. Graph contains ${totalGroups} points of comparison. Navigate between them using the LEFT and RIGHT arrows.  Use ESCAPE to exit.`
        } else if (options.includes('wordwall')) 
        {return `A list of shade names for ${title} sorted from dark to light. Progress through the list using the arrow keys. Exit using ESCAPE.`}
    }

    // let ariaLabel;

    // $: {
    //     if (options.includes('histogram')) ariaLabel = 'This is a histogram showing foundation swatches sorted by lightness level. Use the arrow keys to move between groups and swatches'
    //     if (options.includes('line')) ariaLabel = 'This is a histogram showing the foundation swatches sorted by lightness level, compared to the number of swatches expected at each lightness level. Use the arrow keys to move between groups and swatches.'
    //     if (options.includes('wordwall')) ariaLabel = 'This is a list of the names of foundation shades. Use your arrow keys to move between names.'
    // }

</script>

<svelte:window on:mousemove={clearKeyboard} on:click={clearKeyboard} />

<div class='controller' tabindex="0" role="application" 
    aria-roledescription="data visualization" 
    aria-label={createAccessibleTitle(title, options)}
    aria-activedescendant="null"
    on:keydown={handleKeyDown} bind:this={controllerContainer} >
    <p aria-hidden='true'>Use your arrow keys to explore the swatches. TAB or ESC to exit.</p>
    {#if controllerContainer && explore}
        <Controller {blockDimensions} {options} {currentGroup} {groupedData} {controllerContainer} {found} {exploreSwatches} {groupActive} flatData={$data} {wordIndex} {lineData} />
    {/if}
</div>

<style>
    .controller{
        height: 100%;
        width: 100%;
        position: absolute;
        top: 0;
        left: 0;
        display: flex;
    }
    .controller:focus{
        border: 4px solid var(--accent-color);
        outline: none;
    }

    .controller p {
        display: none;
    }

    .controller:focus p {
        display: inline-block;
        text-align: center;
        margin: 0 auto;
        color: var(--gray);
        text-transform: uppercase;
    }
</style>