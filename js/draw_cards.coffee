---
---

$ ->
    window.get_n_random = (array, n) ->
        array.sort -> 0.5 - Math.random()
        array[0..(n - 1)]

    window.draw_card = (id, i, n, card) ->
        $("#{id} h3").text "#{card.name} (#{i + 1} / #{n})"
        factor = 42 / 44
        width = $("#{id} div").width()
        height = Math.round factor * width 
        canvas = $("#{id} canvas")
        canvas
            .attr "width", width
            .attr "height", height
        img = new Image()
        img.src = card.address
        img.onload = ->
            context = canvas[0].getContext "2d"
            context.drawImage img, 12, 24, 42, 43, 0, 0, width, height
        $("#{id} p").text card.description

    window.set_card_class = (id, card) ->
        $(id).toggleClass("hn", card? and card.type.indexOf("hn") > -1)
        $(id).toggleClass("foc", card? and card.type.indexOf("foc") > -1)
        $(id).toggleClass("wws", card? and card.type.indexOf("wws") > -1)

    window.clear_card = (id, title) ->
        $("#{id} h3").html title
        $(id).toggleClass "hn", false 
        $(id).toggleClass "foc", false
        canvas = $("#{id} canvas")
        context = canvas[0].getContext "2d"
        context.clearRect 0, 0, canvas.width(), canvas.height() 
        $("#{id} p").text ""

