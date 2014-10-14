---
---

$ ->
    window.settings_cards = (card_settings) ->
        d3.json "cards.json", (error, data) ->
            if error?
                console.warn error
                return

            data = data.filter (d) ->
                d.type.indexOf("last") == -1
                
            card = d3.select "#card-checkboxes"
                .selectAll "input"
                .data data

            card
                .enter()
                .append "input"
                .attr "type", "checkbox"
                .property "checked", (d) ->
                    d.name in card_settings.blacklist
                .attr "data-label", (d) -> d.name

            card.exit().remove()

            $('input[type="checkbox"]').checkbox()
