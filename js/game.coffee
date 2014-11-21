---
---

$ ->
    basil = new window.Basil()
    Opentip.defaultStyle = "dark"
    hn_foc_tooltip = new Opentip($("div#show-hn-foc button:nth-child(2)"),
        "Click to get the next card")
    wws_tooltip = new Opentip($("div#show-wws button:nth-child(2)"),
        "Click to get the next card")
    greygory_deck_tooltip = new Opentip($("#show-gd"),
        "Click to get two characters")

    window.save_settings = ->
        card_settings = $('form').serializeArray()
        card_settings = {
            n_hn_foc: parseInt(card_settings[0].value)
            n_wws: parseInt(card_settings[1].value)
            blacklist: card_settings[2..-1]
        }
        basil.set("card_settings", card_settings)

    get_n_random = (array, n) ->
        array.sort -> 0.5 - Math.random()
        array[0..(n - 1)]

    setup_greygory_deck = ->
        d3.json "characters.json", (error, data) ->
            if error?
                console.warn error
                return
            basic_characters = data
                .filter (d) -> d.type == "basic"
            $('#show-gd').data("basic-characters", JSON.stringify(basic_characters))

    start_new_game = ->
        card_settings = basil.get("card_settings")
        current_game = {}
        d3.json "cards.json", (error, data) ->
            hn_foc_cards = data.filter (d) ->
                d.name not in card_settings.blacklist and d.type in ["hn", "foc"]
            hn_foc_cards = get_n_random(
                hn_foc_cards,
                card_settings.n_hn_foc)
            if Math.random() < 0.5
                hn_foc_cards.push data.filter((d) ->
                    d.type == "hn-last")[0].name
            else
                hn_foc_cards.push data.filter((d) ->
                    d.type == "foc-last")[0].name
            current_game.hn_foc_cards = hn_foc_cards
            current_game.hn_foc_index = 0
            wws_cards = data.filter (d) ->
                d.name not in card_settings.blacklist and d.type == "wws"
            wws_cards = get_n_random(
                wws_cards,
                card_settings.n_wws)
            wws_cards.push data.filter((d) ->
                d.type == "wws-last")[0].name
            current_game.wws_cards = wws_cards
            current_game.wws_index = 0
            basil.set("current_game", current_game)
            set_hn_foc current_game 
            set_wws current_game 
                                            
    hn_foc_previous = ->
        if $(this).hasClass "disabled"
            return
        game = basil.get "current_game"
        game.hn_foc_index -= 1
        basil.set "current_game", game 
        set_hn_foc game 
    hn_foc_next = ->
        if $(this).hasClass "disabled"
            return
        game = basil.get "current_game"
        game.hn_foc_index += 1
        basil.set "current_game", game 
        set_hn_foc game 
    wws_previous = ->
        if $(this).hasClass "disabled"
            return
        game = basil.get "current_game"
        game.wws_index -= 1
        basil.set "current_game", game 
        set_wws game 
    wws_next = ->
        if $(this).hasClass "disabled"
            return
        game = basil.get "current_game"
        game.wws_index += 1
        basil.set "current_game", game 
        set_wws game 

    set_hn_foc = (current_game) ->
        i = current_game.hn_foc_index - 1
        cards = current_game.hn_foc_cards
        n = cards.length - 1
        $("div#show-hn-foc button:first")
            .toggleClass("disabled", i < 0)
        text = ""
        tooltip = ""
        if i == n
            text = "#{cards[i].name}"
            tooltip = cards[i].description
        else if i == -1
            text = "&mdash; &rarr; #{cards[0].name}"
            tooltip = cards[0].description
        else
            text = "#{cards[i].name} &rarr; #{cards[i + 1].name}"
            tooltip = """
            #{cards[i].name}: #{cards[i].description}
            <br><br>
            #{cards[i + 1].name}: #{cards[i + 1].description}
            """
        hn_foc_tooltip.setContent tooltip
        $("div#show-hn-foc button:nth-child(2)")
            .toggleClass("disabled", i == n)
            .html "<a href='#'>#{text}</a>"
        $("div#show-hn-foc button:last")
            .toggleClass("disabled", i == n)
        $("div#progress-hn-foc")
            .css "width", "#{(i + 1) / (n + 1) * 100}%" 
            .text "#{i + 1} / #{n + 1}" 

    set_wws = (current_game) ->
        i = current_game.wws_index - 1
        cards = current_game.wws_cards
        n = cards.length - 1
        $("div#show-wws button:first")
            .toggleClass("disabled", i < 0)
        text = if i >= 0 then "#{cards[i].name}" else "&mdash;"
        wws_tooltip.setContent(cards[i].description) unless i < 0
        $("div#show-wws button:nth-child(2)")
            .toggleClass("disabled", i == n)
            .html "<a href='#'>#{text}</a>"
        $("div#show-wws button:last")
            .toggleClass("disabled", i == n)
        $("div#progress-wws")
            .css "width", "#{(i + 1) / (n + 1) * 100}%" 
            .text "#{i + 1} / #{n + 1}" 

    set_gd = ->
        characters = JSON.parse($("#show-gd").data("basic-characters"))
        chosen = get_n_random characters, 2 
        greygory_deck_tooltip.setContent """
        #{chosen[0].name}: #{chosen[0].description}
        <br><br>
        #{chosen[1].name}: #{chosen[1].description}
        """
        $("#show-gd").html((chosen
            .map (d) -> d.name)
            .join " &#43; ")

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

    if basil.get("current_game")?
        set_hn_foc basil.get "current_game"
        set_wws basil.get "current_game"

    $('input#n_hn_foc').val card_settings.n_hn_foc
    $('input#n_wws').val card_settings.n_wws
    window.settings_cards(card_settings)
    setup_greygory_deck()
    $('button#new_game').click start_new_game
    $('#show-gd').click set_gd
    $("div#show-hn-foc button:first").click hn_foc_previous
    $("div#show-hn-foc button:nth-child(2)").click hn_foc_next
    $("div#show-hn-foc button:last").click hn_foc_next
    $("div#show-wws button:first").click wws_previous
    $("div#show-wws button:nth-child(2)").click wws_next
    $("div#show-wws button:last").click wws_next
