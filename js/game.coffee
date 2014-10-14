---
---

$ ->
    basil = new window.Basil()

    window.save_settings = ->
        card_settings = $('form').serializeArray()
        card_settings = {
            n_hn_foc: card_settings[0].value
            n_wws: card_settings[1].value
            blacklist: card_settings[2..-1].map (d) -> d.name
        }
        basil.set("card_settings", card_settings)

    get_n_random = (array, n) ->
        array.sort -> 0.5 - Math.random()
        array[0..n]

    setup_greygory_deck = ->
        d3.json "characters.json", (error, data) ->
            if error?
                console.warn error
                return
            basic_characters = data
                .filter (d) -> d.type == "basic"
                .map (d) -> d.name
            $('div#greygory-deck').data("basic-characters", JSON.stringify(basic_characters))

    start_new_game = ->
        card_settings = basil.get("card_settings")
        current_game = {}
        d3.json "cards.json", (error, data) ->
            hn_foc_cards = data.filter (d) ->
                d.name not in card_settings.blacklist and d.type in ["hn", "foc"]
            hn_foc_cards = get_n_random(
                hn_foc_cards.map (d) -> d.name,
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
                wws_cards.map (d) -> d.name,
                card_settings.n_wws)
            wws_cards.push data.filter((d) ->
                d.type == "wws-last")[0].name
            current_game.wws_cards = wws_cards
            current_game.wws_index = 0
            basil.set("current_game", current_game)
            set_hn_foc(current_game)
                                            
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
        i = current_game.hn_foc_index
        cards = current_game.hn_foc_cards
        $("ul#show-hn-foc li:first")
            .toggleClass("disabled", current_game.hn_foc_index == 0)
        text = ""
        if i == current_game.n_hn_foc
            text = "#{cards[i]}"
        else
            text = "#{cards[i]} &rarr; #{cards[i + 1]}"
        $("ul#show-hn-foc li:nth-child(2)")
            .html "<a href='#'>#{text}</a>"
        $("ul#show-hn-foc li:last")
            .toggleClass("disabled", current_game.hn_foc_index == current_game.n_hn_foc)

    set_wws = (current_game) ->

    
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
    window.settings_cards(card_settings)
    $('button#new_game').click start_new_game
    $("ul#show-hn-foc li:first").click hn_foc_previous
    $("ul#show-hn-foc li:last").click hn_foc_next
