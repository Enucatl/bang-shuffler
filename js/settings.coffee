---
---

$ ->
    basil = new window.Basil()

    save_settings = ->
        card_settings = $('form').serializeArray()
        card_settings = {
            n_hn_foc: parseInt(card_settings[0].value)
            n_wws: parseInt(card_settings[1].value)
            blacklist: card_settings[2..-1].map (d) -> d.name
        }
        basil.set("card_settings", card_settings)

    set_cards = (card_settings) ->
        d3.csv "cards.csv", (error, data) ->
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
                .attr "name", (d) -> d.name
                .property "checked", (d) ->
                    d.name in card_settings.blacklist
                .attr "data-label", (d) -> d.name

            card.exit().remove()

            $('input[type="checkbox"]').checkbox()
            $('input').change save_settings

    card_settings = basil.get("card_settings")
    if not card_settings?
        card_settings = {
            n_hn_foc: 6
            n_wws: 5
            blacklist: [
                "Helena Zontero"
                "Miniera Abbandonata"
                "Bavaglio"
                "Lady Rosa del Texas"
            ]
        }
        basil.set("card_settings", card_settings)

    $('input#n_hn_foc').val card_settings.n_hn_foc
    $('input#n_wws').val card_settings.n_wws
    set_cards card_settings
    $('button#reset_basil').click ->
        basil.remove("card_settings")
        location.reload()

