<script>
    import data from "../data/nude_export.csv"
    import allData from "../data/shades_export.csv"
    import InteractiveWrapper from "./InteractiveWrapper.svelte"
    import InteractiveParent from "./InteractiveParent.svelte"

    export let step;

    $: filterValue = step === 'natural' ? 'natural' : 'nude'
    $: filteredData = data.filter(d => d.namingScheme === filterValue)

    let options;
    let annotations = [];

    $: {
        if (step === 'all') options = ['shuffled'];
        if (step === 'sort') options = ['histogram', 'gradient', 'tooltip']
        if (step === 'majority') options = ['histogram', 'gradient', 'majority']
        if (step === 'distribution') options = ['gradient', 'majority', 'line']
        if (step === 'compare') options = ['gradient', 'majority', 'line', 'allLine', 'annotations']
        if (step === 'nudestix') options = ['histogram', 'gradient', 'majority', 'nudestix']
        if (step === 'highlight') options = ['histogram', 'gradient', 'majority', 'highlight', 'annotations']  
        if (step === 'natural') options = ['natural', 'gradient', 'majority', 'tooltip', 'annotations']
    }

    $: title = `${filteredData.length - 1} shades with "${filterValue}" in the name`

</script>
<InteractiveWrapper {title} {filteredData} {allData} {options} id={'nude'}/>

