---
---
$ ->
    set_gd = ->
        characters = JSON.parse($("#show-gd").data("basic-characters"))
        chosen = get_n_random characters, 2 
        greygory_deck_tooltip = """
        #{chosen[0].name}: #{chosen[0].description}
        <br><br>
        #{chosen[1].name}: #{chosen[1].description}
        """
        $("#show-gd").html((chosen
            .map (d) -> d.name)
            .join " &#43; ")

    setup_greygory_deck = ->
        d3.json "characters.json", (error, data) ->
            if error?
                console.warn error
                return
            basic_characters = data
                .filter (d) -> d.type == "basic"
            $('#show-gd').data("basic-characters", JSON.stringify(basic_characters))

    $('#show-gd').click set_gd
