<script>
    import NumberDistribution from "./NumberDistribution.svelte"
    import data from "../data/numbers_export.csv"
    import copy from "../data/copy.json";
    import { groups } from 'd3-array'

    const baselineIDs = [15, 14, 97, 104]

    $: baseline = groups(data.filter(d => baselineIDs.includes(+d.id)), d => d.id)
    $: darkToLight = groups(data.filter(d => d.lightToDark === 'FALSE'), d => d.id)
</script>

<section id='numbers'>   
    {#each copy.intro as {type, value}}
        <p class='prose'>{@html value}</p>
    {/each}
     <div class='container'>
        {#each baseline as product}
            <NumberDistribution data={product} />
        {/each}
    </div>

    {#each copy.darkToLight as {value}}
    <p class='prose'>{@html value}</p>
    {/each}

    <div class='container'>
        {#each darkToLight as product}
            <NumberDistribution data={product} />
        {/each}
    </div>

    {#each copy.wrapNumbers as {value}}
    <p class='prose'>{@html value}</p>
    {/each}

</section>

<style>
    section {
        max-width: 75rem;
        margin: 0 auto;
    }

    .container {
        display: flex;
        flex-direction: column;
        padding: 1rem 0;
        margin-bottom: 3em;
    }

</style>