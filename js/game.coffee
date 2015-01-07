---
---

$ ->
    basil = new window.Basil()

    get_n_random = (array, n) ->
        array.sort -> 0.5 - Math.random()
        array[0..(n - 1)]

    start_new_game = ->
        card_settings = basil.get("card_settings")
        current_game = {}
        d3.csv "cards.csv", (error, data) ->
            hn_foc_cards = data.filter (d) ->
                d.name not in card_settings.blacklist and d.type in ["hn", "foc"]
            hn_foc_cards = get_n_random(
                hn_foc_cards,
                card_settings.n_hn_foc)
            if Math.random() < 0.5
                hn_foc_cards.push data.filter((d) ->
                    d.type == "hn-last")[0]
            else
                hn_foc_cards.push data.filter((d) ->
                    d.type == "foc-last")[0]
            current_game.hn_foc_cards = hn_foc_cards
            current_game.hn_foc_index = 0
            wws_cards = data.filter (d) ->
                d.name not in card_settings.blacklist and d.type == "wws"
            wws_cards = get_n_random(
                wws_cards,
                card_settings.n_wws)
            wws_cards.push data.filter((d) ->
                d.type == "wws-last")[0]
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
        $("div#current_hn_foc")
            .toggleClass("disabled", i < 0 or i == n)
        text = ""
        tooltip = ""
        if i == -1
            text = "#{cards[i].name}"
            tooltip = cards[i].description
        else if i == n
            text = "&mdash; &rarr; #{cards[0].name}"
            tooltip = cards[0].description
        else
            text = "#{cards[i].name} &rarr; #{cards[i + 1].name}"
            tooltip = """
            #{cards[i].name}: #{cards[i].description}
            <br><br>
            #{cards[i + 1].name}: #{cards[i + 1].description}
            """
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
        tooltip = if i >= 0 then cards[i].description else ""
        $("div#show-wws button:nth-child(2)")
            .toggleClass("disabled", i == n)
            .html "<a href='#'>#{text}</a>"
        $("div#show-wws button:last")
            .toggleClass("disabled", i == n)
        $("div#progress-wws")
            .css "width", "#{(i + 1) / (n + 1) * 100}%" 
            .text "#{i + 1} / #{n + 1}" 

    if basil.get("current_game")?
        set_hn_foc basil.get "current_game"
        set_wws basil.get "current_game"

    $('button#new_game').click start_new_game
    $("div#show-hn-foc button:first").click hn_foc_previous
    $("div#show-hn-foc button:nth-child(2)").click hn_foc_next
    $("div#show-hn-foc button:last").click hn_foc_next
    $("div#show-wws button:first").click wws_previous
    $("div#show-wws button:nth-child(2)").click wws_next
    $("div#show-wws button:last").click wws_next
