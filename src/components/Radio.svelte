<script>
    // based on suggestions from:
    // Sami Keijonen https://webdesign.tutsplus.com/tutorials/how-to-make-custom-accessible-checkboxes-and-radio-buttons--cms-32074
    // and Inclusive Components by Heydon Pickering https://inclusive-components.design/toggle-button/
  
    export let options;
    export let legend;
    export let value = options[0].name;
    export let id;

    const uniqueID = `legend-${Math.floor(Math.random() * 100)}`
  
    const slugify = (str = "") =>
      str.toLowerCase().replace(/ /g, "-").replace(/\./g, "");
  </script>
  

  <fieldset id={`field-${id}`} aria-labelledby={uniqueID}>
    <div class='legend' id={uniqueID}>{legend}</div>
    <div class='buttons'>
       {#each options as { name, label } (name)}
      <input
        class="sr-only"
        type="radio"
        id={`${id}-${slugify(name)}`}
        bind:group={value}
        value={slugify(name)} />
      <label class='option' for={`${id}-${slugify(name)}`}> {label} </label>
    {/each}
    </div>
   
  </fieldset>

  
  <style>
    fieldset {
      border-radius: 2px;
      border: 1px solid var(--gray-darker);
      display: flex;
      flex-direction: row;
      align-items: center;
      font-family: 'National 2 Narrow Web'
    }

    @media screen and (max-width: 500px) {
      fieldset {
        flex-direction: column;
      }
    }

    .legend {
      margin-right: 0.5rem;
      font-weight: bold;
    }

    .buttons {
      display: flex;
    }
  
    label {
      user-select: none;
      line-height: 1.2em;
      font-weight: 400;
      color: var(--gray);
      min-width: 100px;
      text-align: center;
    }
  
    .sr-only {
      position: absolute;
      clip: rect(1px, 1px, 1px, 1px);
      padding: 0;
      border: 0;
      height: 1px;
      width: 1px;
      overflow: hidden;
    }
  
    input[type="radio"] {
      position: absolute;
    }
  
    input[type="radio"] + label {
      position: relative;
    }

    .option {
        padding: 0.6em 1em;
        line-height: 1.3em;
        appearance: none;
        background: none;
        font-weight: 600;
        font-size: 0.9em;
        color: var(--accent-color);
        border: 1px solid var(--accent-color);
        border-radius: 0;
        outline: none;
        cursor: pointer;
    }
    .option + .option {
        border-left-width: 0;
    }
    .option:first-of-type {
        border-radius: 6px 0 0 6px;
    }
    .option:last-of-type {
        border-radius: 0 6px 6px 0;
    }
  
  
    input[type="radio"]:checked + label {
        background: var(--accent-color);
        color: white;
    }
  
    input[type="radio"]:focus + label {
        box-shadow: 0 0px 8px var(--accent-color);
    }  
    
    input[type="radio"]:disabled + label {
      color: darken(var(--gray), 10);
    }
  
    input[type="radio"]:disabled + label {
      background: var(--gray);
    } 
    </style>