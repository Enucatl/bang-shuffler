---
---

$ ->
    d3.json "cards.json", (error, data) ->
        if error?
            console.warn error
            return

        card = d3.select "#card-checkboxes"
            .selectAll "input"
            .data data

        card
            .enter()
            .append "input"
            .attr "type", "checkbox"
            .attr "data-label", (d) -> d.name

        card.exit().remove()

        $('input[type="checkbox"]').checkbox()
