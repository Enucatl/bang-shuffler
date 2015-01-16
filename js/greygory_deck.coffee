---
---

$ ->
    set_gd = ->
        characters = JSON.parse($("#show-gd").data("basic-characters"))
        chosen = window.get_n_random characters, 2 
        window.draw_card "#gd_1", 1, 2, chosen[0]
        window.draw_card "#gd_2", 1, 2, chosen[1]
        $("#gd_1 h3").text chosen[0].name
        $("#gd_2 h3").text chosen[1].name

    setup_greygory_deck = ->
        d3.csv "characters.csv", (error, data) ->
            if error?
                console.warn error
                return
            basic_characters = data
                .filter (d) -> d.type == "basic"
            $('#show-gd').data("basic-characters", JSON.stringify(basic_characters))

    setup_greygory_deck()
    $('#show-gd').click set_gd
