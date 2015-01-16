---
---

$ ->
    basil = new window.Basil()

    start_new_game = ->
        card_settings = basil.get("card_settings")
        current_game = {}
        d3.csv "cards.csv", (error, data) ->
            hn_foc_cards = data.filter (d) ->
                d.name not in card_settings.blacklist and d.type in ["hn", "foc"]
            hn_foc_cards = window.get_n_random(
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
            wws_cards = window.get_n_random(
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
        if $("div#current_hn_foc").hasClass "disabled"
            return
        game = basil.get "current_game"
        game.hn_foc_index -= 1
        basil.set "current_game", game 
        set_hn_foc game 
    hn_foc_next = ->
        if $("div#upcoming_hn_foc").hasClass "disabled"
            return
        game = basil.get "current_game"
        game.hn_foc_index += 1
        basil.set "current_game", game 
        set_hn_foc game 
    wws_previous = ->
        if $("div#current_wws").hasClass "disabled-first"
            return
        game = basil.get "current_game"
        game.wws_index -= 1
        basil.set "current_game", game 
        set_wws game 
    wws_next = ->
        if $("div#current_wws").hasClass "disabled-last"
            return
        game = basil.get "current_game"
        game.wws_index += 1
        basil.set "current_game", game 
        set_wws game 

    set_hn_foc = (current_game) ->
        i = current_game.hn_foc_index - 1
        cards = current_game.hn_foc_cards
        n = cards.length
        $("div#current_hn_foc")
            .toggleClass("disabled", i < 0)
        $("div#upcoming_hn_foc")
            .toggleClass("disabled", i == n - 1)
        if i < n - 1
            window.draw_card "div#upcoming_hn_foc", i + 1, n, cards[i + 1]
            window.set_card_class "div#upcoming_hn_foc", cards[i + 1]
            if i > -1
                window.draw_card "div#current_hn_foc", i, n, cards[i]
                window.set_card_class "div#current_hn_foc", cards[i]
            else
                window.clear_card "div#current_hn_foc", "Mezzogiorno di fuoco<br>Per un pugno di carte"

    set_wws = (current_game) ->
        i = current_game.wws_index - 1
        cards = current_game.wws_cards
        n = cards.length
        id = "div#current_wws"
        $(id).toggleClass("disabled-first", i < 0)
        $(id).toggleClass("disabled-last", i == n - 1)
        if i > -1
            window.draw_card "div#current_wws", i, n, cards[i]
            window.set_card_class "div#current_wws", cards[i]
        else
            window.clear_card "div#current_wws", "Wild west show"

    if basil.get("current_game")?
        set_hn_foc basil.get "current_game"
        set_wws basil.get "current_game"

    $('button#new_game').click start_new_game
    current_hn_foc_hammer = new Hammer document.getElementById "current_hn_foc"  
    current_hn_foc_hammer
        .on "swipeleft tap", hn_foc_previous
        .on "swiperight", hn_foc_next
    upcoming_hn_foc_hammer = new Hammer document.getElementById "upcoming_hn_foc"  
    upcoming_hn_foc_hammer
        .on "swipeleft", hn_foc_previous
        .on "swiperight tap", hn_foc_next
    current_wws_hammer = new Hammer document.getElementById "current_wws"  
    current_wws_hammer
        .on "swipeleft", wws_previous
        .on "swiperight tap", wws_next
